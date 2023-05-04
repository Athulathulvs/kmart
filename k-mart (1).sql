-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 11, 2023 at 06:07 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `k-mart`
--

-- --------------------------------------------------------

--
-- Table structure for table `sensor_data`
--

CREATE TABLE `sensor_data` (
  `id` int(11) NOT NULL,
  `temp` float NOT NULL,
  `hum` float NOT NULL,
  `moi` float NOT NULL,
  `client_id` varchar(200) NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sensor_data`
--

INSERT INTO `sensor_data` (`id`, `temp`, `hum`, `moi`, `client_id`, `timestamp`) VALUES
(125, 27.9, 57, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:24:05'),
(126, 27.5, 57, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:24:36'),
(127, 27, 58, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:25:36'),
(128, 26.7, 59, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:26:36'),
(129, 26.6, 60, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:27:36'),
(130, 26.5, 60, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:28:36'),
(131, 26.4, 60, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:29:36'),
(132, 26.4, 60, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:30:36'),
(133, 26.4, 60, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:31:37'),
(134, 26.4, 61, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:32:37'),
(135, 26.4, 60, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:33:37'),
(136, 26.3, 60, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:34:37'),
(137, 26.3, 61, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:35:37'),
(138, 26.3, 61, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:36:37'),
(139, 26.3, 61, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:37:37'),
(140, 26.4, 61, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:38:37'),
(141, 26.3, 60, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:39:37'),
(142, 26.5, 61, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:40:37'),
(143, 26.4, 60, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:41:37'),
(144, 26.5, 61, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:42:37'),
(145, 26.5, 60, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:43:37'),
(146, 26.5, 60, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:44:08'),
(147, 26.6, 60, 0, 'k-Mart_smart-farm_user1', '2023-04-08 22:45:02'),
(148, 26.6, 60, 0, 'k-mart_smart-farm_user1', '2023-04-08 22:45:40'),
(149, 26.5, 60, 0, 'k-mart_smart-farm_user1', '2023-04-08 22:46:34'),
(150, 26.4, 61, 0, 'k-mart_smart-farm_user1', '2023-04-08 22:47:35'),
(151, 26.4, 61, 21.514, 'k-mart_smart-farm_user1', '2023-04-08 22:48:35'),
(152, 26.3, 61, 10.7448, 'k-mart_smart-farm_user1', '2023-04-08 22:49:35'),
(153, 26.3, 61, 29.9389, 'k-mart_smart-farm_user1', '2023-04-08 22:50:35'),
(154, 26.3, 61, 23.1746, 'k-mart_smart-farm_user1', '2023-04-08 22:51:35'),
(155, 26.3, 61, 18.3883, 'k-mart_smart-farm_user1', '2023-04-08 22:52:35'),
(156, 26.3, 61, 11.0867, 'k-mart_smart-farm_user1', '2023-04-08 22:53:53'),
(157, 26.3, 61, 6.93529, 'k-mart_smart-farm_user1', '2023-04-08 22:54:48'),
(158, 26.3, 61, 40.0977, 'k-mart_smart-farm_user1', '2023-04-08 22:55:48'),
(159, 26.3, 61, 24.7131, 'k-mart_smart-farm_user1', '2023-04-08 22:56:48'),
(160, 26.3, 61, 22.4176, 'k-mart_smart-farm_user1', '2023-04-08 22:57:48'),
(161, 26.4, 61, 20.6349, 'k-mart_smart-farm_user1', '2023-04-08 22:58:48'),
(162, 26.4, 61, 16.8498, 'k-mart_smart-farm_user1', '2023-04-08 22:59:48'),
(163, 26.3, 61, 9.91453, 'k-mart_smart-farm_user1', '2023-04-08 23:00:48'),
(164, 26.3, 61, 6.15385, 'k-mart_smart-farm_user1', '2023-04-08 23:01:48'),
(165, 26.3, 61, 8.30281, 'k-mart_smart-farm_user1', '2023-04-08 23:02:42'),
(166, 26.2, 61, 46.1294, 'k-mart_smart-farm_user1', '2023-04-08 23:03:36'),
(167, 26.1, 61, 0, 'k-mart_smart-farm_user1', '2023-04-08 23:04:36'),
(168, 26.2, 61, 0, 'k-mart_smart-farm_user1', '2023-04-08 23:05:36'),
(169, 26.1, 61, 0, 'k-mart_smart-farm_user1', '2023-04-08 23:07:24'),
(170, 26.2, 61, 0, 'k-mart_smart-farm_user1', '2023-04-08 23:08:18'),
(171, 26.1, 61, 0, 'k-mart_smart-farm_user1', '2023-04-08 23:09:18'),
(172, 26.2, 61, 0, 'k-mart_smart-farm_user1', '2023-04-08 23:10:18'),
(173, 0, 0, 85.5678, 'k-mart_smart-farm_user1', '2023-04-08 23:13:15'),
(174, 27.5, 61, 86.6423, 'k-mart_smart-farm_user1', '2023-04-08 23:14:09'),
(175, 27.6, 60, 0, 'k-mart_smart-farm_user1', '2023-04-09 10:05:24'),
(176, 0, 0, 0, 'k-mart_smart-farm_user1', '2023-04-09 10:06:58'),
(177, 27.7, 59, 0, 'k-mart_smart-farm_user1', '2023-04-09 10:07:52'),
(178, 28.3, 57, 0, 'k-mart_smart-farm_user1', '2023-04-09 10:18:34'),
(179, 28.5, 56, 0, 'k-mart_smart-farm_user1', '2023-04-09 10:20:33'),
(180, 28.5, 56, 0, 'k-mart_smart-farm_user1', '2023-04-09 10:21:50'),
(181, 28.6, 55, 0, 'k-mart_smart-farm_user1', '2023-04-09 10:22:45'),
(182, 28.7, 56, 0, 'k-mart_smart-farm_user1', '2023-04-09 10:23:44'),
(183, 28.7, 55, 0, 'k-mart_smart-farm_user1', '2023-04-09 10:24:45'),
(184, 28.8, 55, 0, 'k-mart_smart-farm_user1', '2023-04-09 10:25:45'),
(185, 28.8, 55, 0, 'k-mart_smart-farm_user1', '2023-04-09 19:52:44');

-- --------------------------------------------------------

--
-- Table structure for table `sensor_status`
--

CREATE TABLE `sensor_status` (
  `client_id` varchar(250) NOT NULL,
  `motor_state` int(11) NOT NULL,
  `irrigation_type` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sensor_status`
--

INSERT INTO `sensor_status` (`client_id`, `motor_state`, `irrigation_type`) VALUES
('k-Mart_smart-farm_user1', 1, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `sensor_data`
--
ALTER TABLE `sensor_data`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sensor_status`
--
ALTER TABLE `sensor_status`
  ADD PRIMARY KEY (`client_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `sensor_data`
--
ALTER TABLE `sensor_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=186;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
