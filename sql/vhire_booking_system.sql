-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 12, 2021 at 10:13 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.0.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vhire_booking_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `orderID` int(11) NOT NULL,
  `customerID` int(11) NOT NULL,
  `tripID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Date` date NOT NULL DEFAULT current_timestamp(),
  `AmountDue` float NOT NULL DEFAULT 0,
  `Status` enum('UNCONFIRMED','CONFIRMED','CANCELLED') NOT NULL DEFAULT 'UNCONFIRMED',
  `orderCreationDT` timestamp NOT NULL DEFAULT current_timestamp(),
  `statusChangeDT` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`orderID`, `customerID`, `tripID`, `Quantity`, `Date`, `AmountDue`, `Status`, `orderCreationDT`, `statusChangeDT`) VALUES
(1, 3, 10, 3, '2021-12-12', 0, 'CANCELLED', '2021-12-12 05:03:08', '2021-12-12 05:03:19'),
(2, 3, 10, 12, '2021-12-12', 0, 'UNCONFIRMED', '2021-12-12 05:21:37', '2021-12-12 05:21:37');

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `decrementSeats` AFTER UPDATE ON `orders` FOR EACH ROW IF NEW.Status = 'CANCELLED' THEN
	UPDATE trip
	SET FreeSeats = FreeSeats + NEW.Quantity
	WHERE tripID = NEW.tripID;
END IF
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `incrementSeats` AFTER INSERT ON `orders` FOR EACH ROW UPDATE trip
SET FreeSeats = FreeSeats - NEW.Quantity
WHERE tripID = NEW.tripID
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `route`
--

CREATE TABLE `route` (
  `routeID` char(9) NOT NULL,
  `O_termID` char(4) NOT NULL,
  `D_termID` char(4) NOT NULL,
  `Fare` float NOT NULL,
  `Trip Duration` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `route`
--

INSERT INTO `route` (`routeID`, `O_termID`, `D_termID`, `Fare`, `Trip Duration`) VALUES
('AYLA-CLNK', 'AYLA', 'CLNK', 100, '00:45:00'),
('AYLA-SMSC', 'AYLA', 'SMSC', 100, '00:45:00'),
('CLNK-AYLA', 'CLNK', 'AYLA', 100, '00:45:00'),
('CLNK-SMCC', 'CLNK', 'SMCC', 100, '00:45:00'),
('SMCC-CLNK', 'SMCC', 'CLNK', 100, '00:45:00'),
('SMCC-SMSC', 'SMCC', 'SMSC', 100, '00:45:00'),
('SMSC-AYLA', 'SMSC', 'AYLA', 100, '00:45:00'),
('SMSC-SMCC', 'SMSC', 'SMCC', 100, '00:45:00');

-- --------------------------------------------------------

--
-- Table structure for table `terminal`
--

CREATE TABLE `terminal` (
  `terminalID` char(4) NOT NULL,
  `adminID` int(11) NOT NULL,
  `Location_Name` varchar(128) NOT NULL,
  `City` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `terminal`
--

INSERT INTO `terminal` (`terminalID`, `adminID`, `Location_Name`, `City`) VALUES
('AYLA', 1, 'Ayala Center Cebu', 'Cebu City'),
('CLNK', 4, 'Cebu City Link Terminal', 'Cebu City'),
('SMCC', 2, 'SM City Cebu', 'Cebu City'),
('SMSC', 3, 'SM Seaside City', 'Cebu City');

-- --------------------------------------------------------

--
-- Table structure for table `trip`
--

CREATE TABLE `trip` (
  `tripID` int(11) NOT NULL,
  `vehicleID` int(11) NOT NULL,
  `routeID` char(9) NOT NULL,
  `FreeSeats` int(11) NOT NULL,
  `ETD` time NOT NULL,
  `ETA` time NOT NULL,
  `Status` enum('ACTIVE','CLOSED','ARRIVED') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `trip`
--

INSERT INTO `trip` (`tripID`, `vehicleID`, `routeID`, `FreeSeats`, `ETD`, `ETA`, `Status`) VALUES
(10, 1, 'AYLA-CLNK', 4, '08:00:00', '08:45:00', 'ACTIVE'),
(11, 1, 'CLNK-AYLA', 16, '08:45:00', '09:30:00', 'ACTIVE'),
(20, 2, 'CLNK-SMCC', 16, '08:00:00', '08:45:00', 'ARRIVED'),
(21, 2, 'SMCC-CLNK', 16, '08:45:00', '09:30:00', 'ACTIVE'),
(30, 3, 'SMCC-SMSC', 16, '08:00:00', '08:45:00', 'CLOSED'),
(31, 3, 'SMSC-SMCC', 16, '08:45:00', '09:30:00', 'ACTIVE');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userID` int(10) UNSIGNED NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contactNum` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('ACTIVE','INACTIVE') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVE',
  `role` enum('CUSTOMER','ADMIN') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vhire`
--

CREATE TABLE `vhire` (
  `vehicleID` int(11) NOT NULL,
  `driverID` int(20) NOT NULL,
  `PlateNum` varchar(16) NOT NULL,
  `Brand` varchar(32) NOT NULL,
  `Model` varchar(32) NOT NULL,
  `Color` varchar(20) NOT NULL,
  `Capacity` int(11) NOT NULL,
  `Weight` float NOT NULL,
  `status` enum('ACTIVE','INACTIVE') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vhire`
--

INSERT INTO `vhire` (`vehicleID`, `driverID`, `PlateNum`, `Brand`, `Model`, `Color`, `Capacity`, `Weight`, `status`) VALUES
(1, 2, 'ABC1234', 'Toyota', 'Avanza', '#ff0000', 1, 1, 'ACTIVE'),
(2, 2, 'ABC1234', 'Toyota', 'Innova', '#FFFFFF', 16, 24.5, 'ACTIVE'),
(3, 1, 'ANZ9874', 'Izuzu', 'Ambot', '#000000', 14, 25.3, 'ACTIVE');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`orderID`),
  ADD KEY `customerFK` (`customerID`),
  ADD KEY `tripFK` (`tripID`);

--
-- Indexes for table `route`
--
ALTER TABLE `route`
  ADD PRIMARY KEY (`routeID`),
  ADD KEY `Destination_FK` (`D_termID`),
  ADD KEY `Origin_FK` (`O_termID`);

--
-- Indexes for table `terminal`
--
ALTER TABLE `terminal`
  ADD PRIMARY KEY (`terminalID`);

--
-- Indexes for table `trip`
--
ALTER TABLE `trip`
  ADD PRIMARY KEY (`tripID`),
  ADD KEY `routeFK` (`routeID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userID`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `vhire`
--
ALTER TABLE `vhire`
  ADD PRIMARY KEY (`vehicleID`),
  ADD KEY `driverFK` (`driverID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `orderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `trip`
--
ALTER TABLE `trip`
  MODIFY `tripID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vhire`
--
ALTER TABLE `vhire`
  MODIFY `vehicleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
