from flask import Flask, render_template, request, redirect, url_for, jsonify
import mysql.connector
import os
from werkzeug.utils import secure_filename
from PIL import Image
import logging
# from flask_wtf.csrf import CSRFProtect
from flask import request

app = Flask(__name__, static_folder='static')
app.config['UPLOAD_FOLDER'] = 'static/uploads'
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16 MB
# app.secret_key = 'your_secret_key'
# csrf = CSRFProtect(app)

logging.basicConfig(level=logging.INFO)

def create_connection():
    try:
        connection = mysql.connector.connect(
            host='localhost',
            user='root',
            password='',
            database='mini_sql'
        )
        if connection.is_connected():
            logging.info("Connected to MySQL")
            return connection
    except mysql.connector.Error as error:
        logging.error("Error connecting to MySQL: %s", error)
        return None

@app.route('/')
def login_page():
    return render_template('Login.html')

@app.route('/home', methods=['GET', 'POST'])
def search_page():
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            cursor.execute('''
                SELECT p.product_name, p.image, p.quantity, c.category_name 
                FROM product p
                JOIN categories c ON p.category_id = c.category_id
            ''')
            products = cursor.fetchall()

            cursor.execute('SELECT category_name FROM categories')
            categories = cursor.fetchall()

            cursor.close()
            connection.close()
            return render_template('home.html', products=products, categories=categories)
        except mysql.connector.Error as error:
            logging.error("Error fetching data from database: %s", error)
            return "Error fetching data from database"
    else:
        return "Error connecting to the database"

@app.route('/search', methods=['GET', 'POST'])
def search_products():
    search_term = request.args.get('search')
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor(dictionary=True)
            if search_term:
                cursor.execute('''
                    SELECT p.product_name, p.image, p.quantity, c.category_name 
                    FROM product p
                    JOIN categories c ON p.category_id = c.category_id
                    WHERE p.product_name LIKE %s
                ''', ('%' + search_term + '%',))
                products = cursor.fetchall()
            else:
                products = []

            cursor.execute('SELECT category_name FROM categories')
            categories = cursor.fetchall()

            cursor.close()
            connection.close()
            return render_template('search_product.html', products=products, categories=categories, search=search_term)
        except mysql.connector.Error as error:
            logging.error("Error fetching data from database: %s", error)
            return "Error fetching data from database"
    else:
        return "Error connecting to the database"

@app.route('/insert', methods=['GET', 'POST'])
def insert_data():
    if request.method == 'POST':
        name = request.form['name']
        image = request.files['image']
        quantity = request.form['quantity']
        category_id = request.form['category_id']
        x_position = request.form['x_position']
        y_position = request.form['y_position']
        z_position = request.form['z_position']
        warehouse_location = request.form['warehouse_location']

        if image:
            filename = secure_filename(image.filename)
            image_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            image.save(image_path)

            img = Image.open(image_path)
            img = img.resize((200, 200), Image.LANCZOS)
            img.save(image_path)
            image_path = os.path.join('uploads', filename).replace('\\', '/')

        connection = create_connection()
        if connection:
            try:
                cursor = connection.cursor()
                insert_product_query = """
                INSERT INTO product (product_name, image, quantity, category_id) 
                VALUES (%s, %s, %s, %s)
                """
                product_data = (name, image_path, quantity, category_id)
                cursor.execute(insert_product_query, product_data)

                warehouse_id = cursor.lastrowid  # Get the last inserted product id

                insert_position_query = """
                INSERT INTO robot_arm_position (warehouse_id, x_coordinate, y_coordinate, z_coordinate, warehouse_location) 
                VALUES (%s, %s, %s, %s, %s)
                """
                position_data = (warehouse_id, x_position, y_position, z_position, warehouse_location)
                cursor.execute(insert_position_query, position_data)

                connection.commit()
                cursor.close()
                connection.close()
                return redirect(url_for('search_page'))
            except mysql.connector.Error as error:
                logging.error("Error inserting data into database: %s", error)
                return "Error inserting data into database"
        else:
            return "Error connecting to the database"
    else:
        connection = create_connection()
        if connection:
            cursor = connection.cursor()
            cursor.execute('SELECT category_id, category_name FROM categories')
            categories = cursor.fetchall()
            cursor.close()
            connection.close()
            return render_template('insert.html', categories=categories)
        else:
            return "Error connecting to the database"


@app.route('/market', methods=['POST'])
def add_to_market():
    product_name = request.json.get('product_name')
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor(dictionary=True)
            
            # Fetch product details from the product table
            cursor.execute('SELECT product_id, image, quantity FROM product WHERE product_name = %s', (product_name,))
            product = cursor.fetchone()
            
            if product:
                product_id = product['product_id']
                
                # Fetch position details from the robot_arm_position table using the correct column name
                cursor.execute('SELECT warehouse_id FROM robot_arm_position WHERE warehouse_id = %s', (product_id,))
                position = cursor.fetchone()
                
                if position:
                    warehouse_id = position['warehouse_id']
                    
                    # Insert product details into the market table
                    cursor.execute('INSERT INTO market (product_id, product_name, image, quantity, warehouse_id) VALUES (%s, %s, %s, %s, %s)', 
                                   (product_id, product_name, product['image'], product['quantity'], warehouse_id))
                    connection.commit()
                    
                    cursor.close()
                    connection.close()
                    return jsonify({'success': True}), 200
                else:
                    cursor.close()
                    connection.close()
                    return jsonify({'success': False, 'error': 'Position not found'}), 404
            else:
                cursor.close()
                connection.close()
                return jsonify({'success': False, 'error': 'Product not found'}), 404
                
        except mysql.connector.Error as error:
            logging.error("Error adding product to market: %s", error)
            if cursor:
                cursor.close()
            if connection:
                connection.close()
            return jsonify({'success': False, 'error': str(error)}), 500
    else:
        return jsonify({'success': False, 'error': 'Error connecting to the database'}), 500

if __name__ == '__main__':
    app.run(debug=True)
