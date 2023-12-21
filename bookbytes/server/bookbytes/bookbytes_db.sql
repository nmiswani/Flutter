-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 21, 2023 at 06:41 PM
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
-- Database: `bookbytes_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_books`
--

CREATE TABLE `tbl_books` (
  `book_id` int(5) NOT NULL,
  `user_id` varchar(5) NOT NULL,
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
(1, '1', '0-316-32223-X', 'In Cold Blood', 'Truman Capote\\\'s non-fiction novel recounts the real-life murder of a wealthy farm family in Kansas and the subsequent trial and execution of the killers.', 'Truman Capote', 400.00, 1, 'Used'),
(2, '1', '0-399-12321-5', 'The Alchemist', 'Paulo Coelho\'s inspirational novel about a shepherd boy named Santiago who travels from Spain to Egypt in search of a personal treasure.', 'Paulo Coelho', 22.90, 2, 'New'),
(3, '1', '0-06-092798-7', 'The Martian', 'Andy Weir\'s science fiction novel about an astronaut stranded on Mars who must use his ingenuity to survive and find a way to communicate with Earth.', 'Andy Weir', 31.00, 18, 'Digital'),
(4, '1', '0-7475-6320-6', 'The Secret Garden', 'Frances Hodgson Burnett\'s classic children\'s novel about a young girl named Mary Lennox who discovers a hidden garden on her uncle\'s estate and brings it back to life.', 'Frances Hodgson Burnett', 29.00, 12, 'Digital'),
(5, '1', '0-14-194949-5', 'The Great Gatsby', 'The story follows the mysterious Jay Gatsby and his obsession with the beautiful Daisy Buchanan. The novel explores themes of wealth, decadence, and the American Dream.', 'F. Scott Fitzgerald', 75.00, 2, 'Used'),
(6, '1', '0-394-55808-X', '1984', 'The story is set in a totalitarian society ruled by the Party and its leader, Big Brother. The protagonist, Winston Smith, struggles against the oppressive regime, and the novel explores themes of surveillance, propaganda, and the loss of personal freedom.', 'George Orwell', 9.99, 17, 'New'),
(7, '1', '0-399-12327-3', 'To Kill a Mockingbird', 'The story is set in the fictional town of Maycomb, Alabama, during the Great Depression. It follows the life of Scout Finch, a young girl, as her father, attorney Atticus Finch, defends a black man accused of raping a white woman.', 'Harper Lee', 12.99, 3, 'New'),
(8, '2', '0-06-130362-7', 'Love of the Blue Bear', 'A heartwarming coming-of-age story by Ain Maisarah, following the journey of Maisarah, a young girl navigating the complexities of first love and family relationships. It explores themes of self-discovery, acceptance, and the power of imagination.', 'Ain Maisarah', 32.00, 6, 'New'),
(9, '2', '0-743-29803-2', 'The Tale of Si Tanggang', ' A classic Malay folklore retold by Mohd Faizal Mohd Noh, exploring themes of filial piety, forgiveness, and the consequences of betrayal. It delves into the importance of cultural values and traditions.', 'Mohd Faizal Mohd Noh', 25.00, 2, 'Used'),
(10, '2', '0-316-00613-9', 'Whispers of the Wild', 'A collection of evocative poems by Faisal Tehrani, capturing the beauty and power of nature, the complexities of human emotions, and the search for meaning in a chaotic world.', 'Faisal Tehrani', 12.99, 15, 'Digital'),
(11, '2', '8-9052-1128-9', 'The Red Onion and the White Onion', 'A charming retelling of a beloved Malay folktale about two sisters with contrasting personalities, teaching valuable lessons about kindness, jealousy, and the importance of family.', 'A. F. Abdullah', 18.00, 21, 'Digital'),
(12, '2', '0-141-00807-0', 'Tun Teja', 'A thrilling historical novel by Faisal Tehrani, bringing to life the legendary Malay warrior Tun Teja and his valiant fight against Portuguese invaders. It offers a glimpse into the rich history and culture of Malaysia.', 'Faisal Tehrani', 35.00, 2, 'Used'),
(13, '2', '0-099-54281-9', 'Pachinko', 'Min Jin Lee\'s epic historical saga follows four generations of a Korean family as they navigate discrimination, displacement, and resilience in Japan during the 20th century. It\'s a powerful story of family, perseverance, and the enduring human spirit.', 'Min Jin Lee', 54.80, 1, 'Used'),
(14, '2', '0-316-06529-2', 'Three-Body Problem', 'Cixin Liu\'s science fiction masterpiece catapults you into a cosmic adventure where humanity faces the imminent arrival of an alien civilization. It\'s a thrilling and thought-provoking exploration of first contact, existential questions, and the future of our species.', 'Cixin Liu', 38.00, 9, 'Digital'),
(15, '5', '9-787-50868-0', 'Moon and Sixpence', 'A compelling story of a man who abandons his conventional life to pursue his artistic passion in Paris.', '毛姆 (Somerset Maugham)', 38.00, 4, 'Used'),
(16, '5', '9-787-50865-1', 'To Live', 'An epic saga of a family\'s struggles during turbulent times in China\'s 20th century.', 'Yu Hua', 78.00, 5, 'Digital'),
(17, '5', '9-787-50651-8', 'One Hundred Years of Solitude', 'A magical realist masterpiece about a family\'s cyclical rise and fall in a Colombian village.', 'Gabriel García Márquez', 52.00, 8, 'New'),
(18, '5', '9-787-50510-4', 'The Besieged City', 'A witty and satirical novel about love, marriage, and academia in China\'s 1930s.', '钱钟书 (Qian Zhongshu)', 55.90, 2, 'Used'),
(19, '5', '9-787-50754-1', 'Dream of the Red Chamber', 'An epic novel about the rise and fall of two aristocratic families in Qing Dynasty China.', '曹雪芹 (Cao Xueqin)', 60.00, 23, 'Digital'),
(20, '1', '8-067-00446-0', 'The God of Small Things', 'A hauntingly beautiful story of childhood, loss, and the complexities of family in Kerala, India.', 'Arundhati Roy', 39.00, 6, 'New'),
(21, '1', '8-812-91020-0', 'Train to Pakistan', 'A powerful historical novel set during the partition of India and Pakistan, exploring themes of love, loss, and political turmoil.', 'Khushwant Singh', 42.00, 5, 'Digital'),
(22, '1', '8-014-02452-3', 'Midnight\'s Children', 'A magical realist epic following the lives of 106 children born at the stroke of midnight on India\'s independence day, weaving fantasy and history together.', 'Salman Rushdie', 55.00, 9, 'New'),
(23, '1', '8-067-97463-0', 'A Fine Balance', 'A powerful and heartbreaking novel set during the Emergency in India, following the lives of four characters caught in the midst of political upheaval and human suffering.', 'Rohinton Mistry', 88.00, 1, 'Used'),
(24, '1', '7-801-43420-1', 'Legends of Khasak', 'A collection of charming and heartwarming stories set in the fictional Himalayan town of Khasak, capturing the beauty and simplicity of life in the mountains.', 'Ruskin Bond', 32.00, 10, 'Digital');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_phone` varchar(15) NOT NULL,
  `user_password` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_password`) VALUES
(1, 'wani@gmail.com', 'Syazwani', '0192793200', '7c222fb2927d828af22f592134e8932480637c0d'),
(2, 'aina@gmail.com', 'Aina', '0182901173', '7c4a8d09ca3762af61e59520943dc26494f8941b'),
(3, 'zamiradha@gmail.com', 'ZamirAdha', '0182115656', 'fba6b1ef9c110bf18f9ad3dde986abcdf26018a3'),
(4, 'faridam@gmail.com', 'FaridAmsyar', '0162117821', '7eaafba188119815f25ded347b704acd97e52d16'),
(5, 'fatimah@gmail.com', 'Fatimah', '0128763300', '55af9969919e0f55f3d6ef3daaf47e6aba558859'),
(6, 'sarahbatrisyia@gmail.com', 'SarahBat', '0156112893', '79a434e4d88bb847ba928d1478049f0d70d395b3'),
(7, 'ahchong@gmail.com', 'AhChong', '0192137786', '20eabe5d64b0e216796e834f52d61fd0b70332fc'),
(8, 'zahin@gmail.com', 'zahinAhmad', '0128976650', '6367c48dd193d56ea7b0baad25b19455e529f5ee');

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
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
