-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 22, 2024 at 06:19 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mini_sql`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`) VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Clothing'),
(4, 'Home & Kitchen'),
(5, 'Toys & Games');

-- --------------------------------------------------------

--
-- Table structure for table `market`
--

CREATE TABLE `market` (
  `market_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `warehouse_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `market`
--

INSERT INTO `market` (`market_id`, `product_id`, `product_name`, `image`, `quantity`, `warehouse_id`) VALUES
(1, 30, 'food', 'uploads/burger-with-melted-cheese.webp', 12, 30),
(2, 31, 'Shert', 'uploads/istockphoto-1237985231-612x612.jpg', 43, 31),
(3, 32, 'tank', 'uploads/istockphoto-458804963-612x612.jpg', 1, 32),
(4, 33, 'car', 'uploads/pexels-mikebirdy-170811.jpg', 12, 33),
(5, 34, 'camera', 'uploads/SLR-Camera-next-to-laptop-855.jpg', 10, 34),
(6, 36, 'เครื่องบิน', 'uploads/Emirates_A380-2-scaled-e1691397446290.jpg', 1, 36),
(7, 30, 'food', 'uploads/burger-with-melted-cheese.webp', 12, 30),
(8, 30, 'food', 'uploads/burger-with-melted-cheese.webp', 12, 30),
(9, 31, 'Shert', 'uploads/istockphoto-1237985231-612x612.jpg', 43, 31),
(10, 32, 'tank', 'uploads/istockphoto-458804963-612x612.jpg', 1, 32),
(11, 33, 'car', 'uploads/pexels-mikebirdy-170811.jpg', 12, 33),
(12, 34, 'camera', 'uploads/SLR-Camera-next-to-laptop-855.jpg', 10, 34),
(13, 30, 'food', 'uploads/burger-with-melted-cheese.webp', 12, 30),
(14, 30, 'food', 'uploads/burger-with-melted-cheese.webp', 12, 30),
(15, 30, 'food', 'uploads/burger-with-melted-cheese.webp', 12, 30);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `image` text DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `product_name`, `image`, `quantity`, `category_id`) VALUES
(29, 'Laptop', 'uploads/How-to-Choose-a-Laptop-August-2023-Gear.webp', 1, 1),
(30, 'food', 'uploads/burger-with-melted-cheese.webp', 12, 4),
(31, 'Shert', 'uploads/istockphoto-1237985231-612x612.jpg', 43, 4),
(32, 'tank', 'uploads/istockphoto-458804963-612x612.jpg', 1, 1),
(33, 'car', 'uploads/pexels-mikebirdy-170811.jpg', 12, 1),
(34, 'camera', 'uploads/SLR-Camera-next-to-laptop-855.jpg', 10, 1),
(35, 'Laptop', 'uploads/h7RghmVhRSKgsqSpRCgiL-1200-80.jpg', 43, 1),
(36, 'เครื่องบิน', 'uploads/Emirates_A380-2-scaled-e1691397446290.jpg', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `robot_arm_position`
--

CREATE TABLE `robot_arm_position` (
  `position_id` int(11) NOT NULL,
  `warehouse_id` int(11) DEFAULT NULL,
  `x_coordinate` int(11) DEFAULT NULL,
  `y_coordinate` int(11) DEFAULT NULL,
  `z_coordinate` int(11) DEFAULT NULL,
  `warehouse_location` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `robot_arm_position`
--

INSERT INTO `robot_arm_position` (`position_id`, `warehouse_id`, `x_coordinate`, `y_coordinate`, `z_coordinate`, `warehouse_location`) VALUES
(7, 29, 0, 1, 2, 'FA1'),
(8, 30, 1, 2, 3, 'FA1'),
(9, 31, 1, 3, 2, 'FA1'),
(10, 32, 2, 1, 2, 'FA1'),
(11, 33, 1, 1, 2, 'FA1'),
(12, 34, 1, 2, 3, 'FA1'),
(13, 35, 21, 1, 1, 'FA1'),
(14, 36, 1, 2, 1, 'FA1');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `market`
--
ALTER TABLE `market`
  ADD PRIMARY KEY (`market_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `warehouse_id` (`warehouse_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `robot_arm_position`
--
ALTER TABLE `robot_arm_position`
  ADD PRIMARY KEY (`position_id`),
  ADD KEY `product_id` (`warehouse_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `market`
--
ALTER TABLE `market`
  MODIFY `market_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `robot_arm_position`
--
ALTER TABLE `robot_arm_position`
  MODIFY `position_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `market`
--
ALTER TABLE `market`
  ADD CONSTRAINT `market_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  ADD CONSTRAINT `market_ibfk_2` FOREIGN KEY (`warehouse_id`) REFERENCES `robot_arm_position` (`warehouse_id`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `robot_arm_position`
--
ALTER TABLE `robot_arm_position`
  ADD CONSTRAINT `robot_arm_position_ibfk_1` FOREIGN KEY (`warehouse_id`) REFERENCES `product` (`product_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
