-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 10, 2024 at 12:38 PM
-- Server version: 10.3.39-MariaDB-cll-lve
-- PHP Version: 8.1.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `infinmwk_wani_bookbytes_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_books`
--

CREATE TABLE `tbl_books` (
  `book_id` int(5) NOT NULL,
  `user_id` int(5) NOT NULL,
  `book_isbn` varchar(17) NOT NULL,
  `book_title` varchar(200) NOT NULL,
  `book_desc` varchar(2000) NOT NULL,
  `book_author` varchar(100) NOT NULL,
  `book_price` decimal(6,2) NOT NULL,
  `book_qty` int(5) NOT NULL,
  `book_status` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_books`
--

INSERT INTO `tbl_books` (`book_id`, `user_id`, `book_isbn`, `book_title`, `book_desc`, `book_author`, `book_price`, `book_qty`, `book_status`) VALUES
(1, 1, '0-316-32223-X', 'In Cold Blood', 'Truman Capote\'s non-fiction novel recounts the real-life murder of a wealthy farm family in Kansas and the subsequent trial and execution of the killers.', 'Truman Capote', 60.00, 0, 'Used'),
(2, 1, '0-399-12321-5', 'The Alchemist', 'Paulo Coelho\'s inspirational novel about a shepherd boy named Santiago who travels from Spain to Egypt in search of a treasure.', 'Paulo Coelho', 12.98, 0, 'New'),
(3, 1, '0-06-092798-7', 'The Martian', 'Andy Weir\'s science fiction novel about an astronaut stranded on Mars who must use his ingenuity to survive and find a way to communicate with Earth.', 'Andy Weir', 11.00, 7, 'Used'),
(4, 1, '0-7475-6320-6', 'The Secret Garden', 'Frances Hodgson Burnett\'s classic children\'s novel about a young girl named Mary Lennox who discover a hidden garden on her uncle\'s estate.', 'Frances Hodgson Burnett', 19.00, 4, 'Used'),
(5, 1, '0-14-194949-5', 'The Great Gatsby', 'The story follows the mysterious Jay Gatsby and his obsession with beautiful Daisy Buchanan. The novel explores themes of wealth and the American Dream.', 'F. Scott Fitzgerald', 15.00, 2, 'Used'),
(6, 2, '0-394-55808-X', '1984', 'The story is set in a totalitarian society ruled by the Party and leader\'s Big Brother. Protagonist, Winston Smith who struggles against the oppressive regime.', 'George Orwell', 9.99, 6, 'New'),
(7, 2, '0-399-12327-3', 'To Kill a Mockingbird', 'The story is set in the fictional town of Maycomb, Alabama, during the Great Depression. Scout Finch\'s father defends a black man accused of rape.', 'Harper Lee', 12.99, 3, 'New'),
(8, 2, '0-06-130362-7', 'Love of the Blue Bear', 'A heartwarming coming-of-age story by Ain Maisarah and her journey, a young girl navigating the complexities of first love and family relationships.', 'Ain Maisarah', 12.00, 6, 'New'),
(9, 2, '0-743-29803-2', 'The Tale of Si Tanggang', 'A classic Malay folklore retold by Mohd Faizal Mohd Noh, exploring themes of filial piety, forgiveness, and the consequences of betrayal.', 'Mohd Faizal Mohd Noh', 15.00, 2, 'Used'),
(10, 2, '0-316-00613-9', 'Whispers of the Wild', 'A collection of evocative poems and capturing the beauty and power of nature, complexities of human emotions, and the meaning in a chaotic world.', 'Faisal Tehrani', 12.99, 5, 'New'),
(11, 3, '8-9052-1128-9', 'The White Onion', 'A charming retelling of a beloved Malay folktale about 2 sisters with contrasting personalities, teaching valuable lessons about kindness and the family.', 'A. F. Abdullah', 18.00, 10, 'New'),
(12, 3, '0-141-00807-0', 'Tun Teja', 'A thrilling historical novel by Faisal Tehrani, bringing to life the legendary Malay warrior Tun Teja and his valiant fight against Portuguese invaders.', 'Faisal Tehrani', 15.98, 0, 'Used'),
(13, 3, '0-099-54281-9', 'Pachinko', 'Min Jin Lee\'s epic historical saga follows four generations of a Korean family as they navigate discrimination in Japan during the 20th century.', 'Min Jin Lee', 24.80, 1, 'Used'),
(14, 3, '0-316-06529-2', 'Three-Body Problem', 'Cixin Liu\'s science fiction masterpiece catapults you into a cosmic adventure where humanity faces the imminent arrival of an alien civilization.', 'Cixin Liu', 18.00, 9, 'New'),
(15, 3, '9-787-50868-0', 'Moon and Sixpence', 'A fascinating story about a man who leaves his conventional life to pursue his artistic passion.', '毛姆 (Somerset Maugham)', 28.00, 4, 'Used'),
(16, 4, '9-787-50865-1', 'To Live', 'An epic saga of a family\'s struggles during turbulent times in China\'s 20th century.', 'Yu Hua', 17.00, 5, 'Used'),
(17, 4, '9-787-50651-8', '100 Years of Solitude', 'A magical realist masterpiece about a family\'s cyclical rise and fall in a Colombian village.', 'Gabriel García Márquez', 12.00, 8, 'New'),
(18, 4, '9-787-50510-4', 'The Besieged City', 'A witty and satirical novel about love, marriage, and academia in China\'s 1930s.', '钱钟书 (Qian Zhongshu)', 25.90, 2, 'Used'),
(19, 4, '9-787-50754-1', 'Dream of the Red Chamber', 'An epic novel about the rise and fall of two aristocratic families in Qing Dynasty China.', '曹雪芹 (Cao Xueqin)', 10.00, 12, 'New'),
(20, 4, '8-067-00446-0', 'The God of Small Things', 'A hauntingly beautiful story of childhood, loss, and the complexities of family in Kerala, India. However, there is a deep loss and family complexity.', 'Arundhati Roy', 19.00, 6, 'New'),
(21, 5, '8-812-91020-0', 'Train to Pakistan', 'A powerful historical novel set during the partition of India and Pakistan. An exploration\'s themes of love, loss, historical story and political turmoil.', 'Khushwant Singh', 22.00, 5, 'Used'),
(22, 5, '8-014-02452-3', 'Midnight\'s Children', 'A magical realist epic following \r\nthe lives of 106 children born at the stroke of midnight on India\'s independence day, weaving fantasy and history together.', 'Salman Rushdie', 19.00, 9, 'New'),
(23, 5, '8-067-97463-0', 'A Fine Balance', 'A powerful and heartbreaking novel set during the Emergency in India, following the lives of four characters caught in the midst of political upheaval.', 'Rohinton Mistry', 18.00, 0, 'Used'),
(24, 5, '7-801-43420-1', 'Legends of Khasak', 'A collection of charming and heartwarming stories set in the fictional Himalayan town of Khasak, capturing the beauty and simplicity of life in mountains.', 'Ruskin Bond', 14.00, 9, 'New');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_carts`
--

CREATE TABLE `tbl_carts` (
  `cart_id` int(5) NOT NULL,
  `buyer_id` int(5) NOT NULL,
  `seller_id` int(5) NOT NULL,
  `book_id` int(5) NOT NULL,
  `cart_qty` int(5) NOT NULL,
  `cart_status` varchar(10) NOT NULL,
  `cart_date` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `book_price` decimal(6,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_carts`
--

INSERT INTO `tbl_carts` (`cart_id`, `buyer_id`, `seller_id`, `book_id`, `cart_qty`, `cart_status`, `cart_date`, `book_price`) VALUES
(13, 1, 1, 2, 1, 'Paid', '2024-02-09 20:15:38.722654', 12.98),
(15, 1, 3, 12, 1, 'Paid', '2024-02-09 20:32:19.560661', 25.88),
(16, 1, 3, 12, 1, 'Paid', '2024-02-09 20:34:37.552526', 25.98),
(17, 1, 1, 3, 1, 'Paid', '2024-02-10 12:36:58.259422', 11.00);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_orders`
--

CREATE TABLE `tbl_orders` (
  `order_id` int(5) NOT NULL,
  `buyer_id` int(5) NOT NULL,
  `seller_id` int(5) NOT NULL,
  `order_total` decimal(6,2) NOT NULL,
  `order_date` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `order_status` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_orders`
--

INSERT INTO `tbl_orders` (`order_id`, `buyer_id`, `seller_id`, `order_total`, `order_date`, `order_status`) VALUES
(5, 1, 1, 22.98, '2024-02-09 20:16:56.630960', 'New'),
(6, 1, 3, 35.88, '2024-02-09 20:33:36.384932', 'New'),
(7, 1, 3, 25.98, '2024-02-09 20:39:13.099891', 'New'),
(8, 1, 1, 21.00, '2024-02-10 12:37:44.546329', 'New');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_phone` varchar(12) NOT NULL,
  `user_password` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_password`) VALUES
(1, 'syazwani@gmail.com', 'Syazwani', '0192793200', '7c4a8d09ca3762af61e59520943dc26494f8941b'),
(2, 'ahmad@gmail.com', 'ahmad', '0123456789', '7c4a8d09ca3762af61e59520943dc26494f8941b');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_books`
--
ALTER TABLE `tbl_books`
  ADD PRIMARY KEY (`book_id`),
  ADD UNIQUE KEY `book_isbn` (`book_isbn`);

--
-- Indexes for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_books`
--
ALTER TABLE `tbl_books`
  MODIFY `book_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  MODIFY `cart_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  MODIFY `order_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
