-- phpMyAdmin SQL Dump
-- version 4.5.4.1
-- http://www.phpmyadmin.net
--
-- Client :  localhost
-- Généré le :  Mer 24 Avril 2024 à 10:27
-- Version du serveur :  5.7.11
-- Version de PHP :  5.6.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `gestionhotel`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AnnulerReservation` (IN `reservation_id` INT)  BEGIN
    DECLARE chambre_id INT;
    DECLARE idHotel INT;

        SELECT idChambre, idHotel INTO chambre_id, idHotel FROM reservation WHERE id = reservation_id;

        UPDATE chambre SET occupe = 0 WHERE id = chambre_id;

        DELETE FROM reservation WHERE id = reservation_id;

    
        SELECT CONCAT('La réservation ', reservation_id, ' a été annulée.') AS Message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreerHotelAvecChambres` (IN `nom_hotel` VARCHAR(255), IN `adresse_hotel` VARCHAR(255), IN `nb_chambres` INT)  BEGIN
        INSERT INTO hotel (nom, adresse, nombre_de_chambre) VALUES (nom_hotel, adresse_hotel, nb_chambres);

        SET @hotel_id = LAST_INSERT_ID();

        SET @i = 1;

        WHILE @i <= nb_chambres DO
        INSERT INTO chambre (idHotel, occupe) VALUES (@hotel_id, FALSE);
        SET @i = @i + 1;
    END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreerReservationAvecChambre` (IN `id_client` INT, IN `id_hotel` INT, IN `jour_debut` DATE, IN `jour_fin` DATE)  BEGIN
    DECLARE id_chambre INT;

        SELECT id INTO id_chambre
    FROM chambre
    WHERE idHotel = id_hotel AND occupe = 0
    ORDER BY id
    LIMIT 1
    FOR UPDATE;

        IF id_chambre IS NOT NULL THEN
                INSERT INTO reservation (idClient, idHotel, idChambre, jourDebut, jourFin)
        VALUES (id_client, id_hotel, id_chambre, jour_debut, jour_fin);

                UPDATE chambre SET occupe = 1 WHERE id = id_chambre;

        SELECT CONCAT('La réservation pour la chambre ', id_chambre, ' a été effectuée.') AS Message;
    ELSE
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aucune chambre disponible pour la réservation.';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SupprimerHotelAvecChambresEtReservations` (IN `hotel_id` INT)  BEGIN
    DECLARE chambre_id INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT id FROM chambre WHERE idHotel = hotel_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

        DELETE FROM reservation WHERE idHotel = hotel_id;

        OPEN cur;
    read_loop: LOOP
        FETCH cur INTO chambre_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
                DELETE FROM reservation WHERE idChambre = chambre_id;
        
                DELETE FROM chambre WHERE id = chambre_id;
    END LOOP;
    CLOSE cur;

        DELETE FROM hotel WHERE id = hotel_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `idHotel` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `admin`
--

INSERT INTO `admin` (`id`, `nom`, `prenom`, `email`, `mot_de_passe`, `idHotel`) VALUES
(1, 'test', 'test', 'test', 'test', 1),
(2, 'test2', 'test2', 'test2', 'test2', 45),
(3, 'Dupont', 'Jean', 'm@example.com', 'password', 76),
(4, 'hivers', 'hivers', 'test@gmail.com', 'hivers', 77);

-- --------------------------------------------------------

--
-- Structure de la table `chambre`
--

CREATE TABLE `chambre` (
  `id` int(11) NOT NULL,
  `idHotel` int(11) NOT NULL,
  `occupe` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `chambre`
--

INSERT INTO `chambre` (`id`, `idHotel`, `occupe`) VALUES
(106, 1, 1),
(332, 45, 1),
(333, 45, 1),
(334, 45, 1),
(335, 45, 1),
(336, 45, 1),
(337, 46, 1),
(338, 46, 1),
(339, 46, 0),
(340, 46, 0),
(341, 46, 0),
(342, 46, 0),
(343, 46, 0),
(344, 46, 0),
(345, 46, 0),
(346, 46, 0),
(347, 47, 0),
(348, 47, 0),
(349, 47, 0),
(350, 47, 0),
(351, 47, 0),
(352, 48, 0),
(353, 48, 0),
(354, 48, 0),
(355, 48, 0),
(356, 48, 0),
(357, 49, 0),
(358, 49, 0),
(359, 49, 0),
(360, 49, 0),
(361, 49, 0),
(362, 50, 0),
(363, 50, 0),
(364, 50, 0),
(365, 50, 0),
(366, 50, 0),
(367, 51, 0),
(368, 51, 0),
(369, 51, 0),
(370, 51, 0),
(371, 51, 0),
(372, 52, 0),
(373, 52, 0),
(374, 52, 0),
(375, 52, 0),
(376, 52, 0),
(377, 53, 0),
(378, 53, 0),
(379, 53, 0),
(380, 53, 0),
(381, 53, 0),
(382, 54, 0),
(383, 54, 0),
(384, 54, 0),
(385, 54, 0),
(386, 54, 0),
(387, 55, 0),
(388, 55, 0),
(389, 55, 0),
(390, 55, 0),
(391, 55, 0),
(392, 56, 0),
(393, 56, 0),
(394, 56, 0),
(395, 56, 0),
(396, 56, 0),
(397, 57, 0),
(398, 57, 0),
(399, 57, 0),
(400, 57, 0),
(401, 57, 0),
(402, 58, 0),
(403, 58, 0),
(404, 58, 0),
(405, 58, 0),
(406, 58, 0),
(407, 59, 0),
(408, 59, 0),
(409, 59, 0),
(410, 59, 0),
(411, 59, 0),
(412, 60, 0),
(413, 60, 0),
(414, 60, 0),
(415, 60, 0),
(416, 60, 0),
(417, 61, 0),
(418, 61, 0),
(419, 61, 0),
(420, 61, 0),
(421, 61, 0),
(422, 62, 0),
(423, 62, 0),
(424, 62, 0),
(425, 62, 0),
(426, 62, 0),
(427, 63, 0),
(428, 63, 0),
(429, 63, 0),
(430, 63, 0),
(431, 63, 0),
(432, 64, 0),
(433, 64, 0),
(434, 64, 0),
(435, 64, 0),
(436, 64, 0),
(437, 65, 0),
(438, 65, 0),
(439, 65, 0),
(440, 65, 0),
(441, 65, 0),
(442, 66, 0),
(443, 66, 0),
(444, 66, 0),
(445, 66, 0),
(446, 66, 0),
(447, 67, 0),
(448, 67, 0),
(449, 67, 0),
(450, 67, 0),
(451, 67, 0),
(452, 68, 0),
(453, 68, 0),
(454, 68, 0),
(455, 68, 0),
(456, 68, 0),
(457, 69, 0),
(458, 69, 0),
(459, 69, 0),
(460, 69, 0),
(461, 69, 0),
(462, 70, 0),
(463, 70, 0),
(464, 70, 0),
(465, 70, 0),
(466, 70, 0),
(467, 71, 0),
(468, 71, 0),
(469, 71, 0),
(470, 71, 0),
(471, 71, 0),
(472, 72, 0),
(473, 72, 0),
(474, 72, 0),
(475, 72, 0),
(476, 72, 0),
(477, 73, 0),
(478, 73, 0),
(479, 73, 0),
(480, 73, 0),
(481, 73, 0),
(482, 74, 1),
(483, 74, 0),
(484, 74, 0),
(485, 74, 0),
(486, 74, 0),
(487, 74, 0),
(488, 74, 0),
(489, 74, 0),
(490, 74, 0),
(491, 74, 0),
(492, 74, 0),
(493, 74, 0),
(496, 76, 1),
(497, 76, 1),
(498, 1, 1),
(499, 1, 0),
(500, 1, 0),
(501, 1, 1),
(502, 77, 0),
(503, 77, 0),
(504, 77, 0),
(505, 77, 0),
(506, 77, 0),
(507, 77, 0),
(508, 77, 0),
(509, 77, 0);

-- --------------------------------------------------------

--
-- Structure de la table `client`
--

CREATE TABLE `client` (
  `id` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `adresse` varchar(255) NOT NULL,
  `numeroTel` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `client`
--

INSERT INTO `client` (`id`, `nom`, `prenom`, `adresse`, `numeroTel`, `email`, `mot_de_passe`) VALUES
(1, 'test', 'admin', 'test', 'tset', 'test', 'test'),
(23, 'John', 'Doe', '123 rue d', '0123456789', 'john.doe@example.com', ''),
(24, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(25, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(26, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(27, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(28, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(29, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(30, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(31, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(32, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(33, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(34, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(35, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(36, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(37, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(38, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(39, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(40, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(41, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(42, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(43, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(44, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(45, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(46, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(47, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(48, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(49, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(50, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(51, 'John', 'Doe', '123 rue de Paris', '0123456789', 'john.doe@example.com', ''),
(52, 'test', 'test', 'tes', 'test', 'test', 'test'),
(53, 'Dupont', 'Jean', '20 rue chambre', 'm@example.com', '07 00 00 00 00', 'password'),
(54, 'Dupont', 'Jean', '20 rue chambre', 'm@example.com', '07 00 00 00 00', 'password'),
(55, 'Dupont', 'test', '20 rue chambre', 'm@example.com', '07 00 00 00 00', 'password'),
(56, 'Dupont', 'test2', '20 rue chambre', 'm@example.com', '07 00 00 00 00', 'password'),
(57, 'testfinal', 'testfinal', 'testfinal', 'testfinal', 'testfinal', 'testfinal'),
(58, 'super', 'super', 'super', 'super', 'super', 'super'),
(59, 'test', 'test', 'tes', 'test', 'tes', '0'),
(60, 'Dupont', 'Jean', '20 rue chambre', '07 00 00 00 00', 'm@example.com', 'password'),
(61, 'test2', 'test2', '3 rue des potiers', '0704040404', 'm@example.com', '0'),
(62, 'test', 'test', '20 rue chambre', '07 00 00 00 00', 'm@example.com', 'password'),
(63, 'unique', 'unique', '20 rue chambre', '07 00 00 00 00', 'unique', 'unique1');

-- --------------------------------------------------------

--
-- Structure de la table `clienthotel`
--

CREATE TABLE `clienthotel` (
  `idHotel` int(11) NOT NULL,
  `idClient` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `clienthotel`
--

INSERT INTO `clienthotel` (`idHotel`, `idClient`) VALUES
(1, 56),
(1, 57),
(1, 46),
(1, 59),
(1, 61);

-- --------------------------------------------------------

--
-- Structure de la table `employe`
--

CREATE TABLE `employe` (
  `id` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `adresse` varchar(255) NOT NULL,
  `numeroEmp` varchar(255) NOT NULL,
  `poste` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `employe`
--

INSERT INTO `employe` (`id`, `nom`, `adresse`, `numeroEmp`, `poste`) VALUES
(1, 'test', 'test', 'EMP001', 'test'),
(2, 'tset', 'test', 'EMP002', 'test'),
(40, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(41, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(42, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(43, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(44, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(45, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(46, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(47, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(48, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(49, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(50, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(51, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(52, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(53, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(54, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(55, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(56, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(57, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(58, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(59, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(60, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(61, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(62, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(63, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(64, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(65, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(66, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(67, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(68, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(69, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(70, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(71, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(72, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(73, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(74, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(75, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(76, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(77, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(78, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(79, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(80, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(81, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(82, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(83, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(84, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(85, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(86, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(87, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(88, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(89, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(90, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(91, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(92, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(93, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(94, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(95, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(96, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(97, 'John Doe', '123 Rue de la Paix', 'EMP001', 'Manager'),
(98, 'John Doe2', '123 Rue de la Paix', 'EMP001', 'Manager'),
(99, 'testemploye', 'testemploy', 'testemploy', 'testemploye'),
(101, 'test24', 'm@example.com', 'EMP24', 'chef');

-- --------------------------------------------------------

--
-- Structure de la table `employehotel`
--

CREATE TABLE `employehotel` (
  `idEmploye` int(11) NOT NULL,
  `idHotel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `employehotel`
--

INSERT INTO `employehotel` (`idEmploye`, `idHotel`) VALUES
(40, 1),
(1, 1),
(2, 45),
(99, 1),
(100, 1),
(100, 1),
(101, 1);

-- --------------------------------------------------------

--
-- Structure de la table `hotel`
--

CREATE TABLE `hotel` (
  `id` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `adresse` varchar(255) NOT NULL,
  `nombre_de_chambre` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `hotel`
--

INSERT INTO `hotel` (`id`, `nom`, `adresse`, `nombre_de_chambre`) VALUES
(1, 'testadmin', 'testadmin', 8),
(45, 'Hotel AB', '123 Rue de Pari', 5),
(46, 'NomHotel', 'AdresseHotel', 10),
(47, 'Hotel AB', '123 Rue de Pari', 5),
(48, 'Hotel AB', '123 Rue de Pari', 5),
(49, 'Hotel AB', '123 Rue de Pari', 5),
(50, 'Hotel AB', '123 Rue de Pari', 5),
(51, 'Hotel AB', '123 Rue de Pari', 5),
(52, 'Hotel AB', '123 Rue de Pari', 5),
(53, 'Hotel AB', '123 Rue de Pari', 5),
(54, 'Hotel AB', '123 Rue de Pari', 5),
(55, 'Hotel AB', '123 Rue de Pari', 5),
(56, 'Hotel AB', '123 Rue de Pari', 5),
(57, 'Hotel AB', '123 Rue de Pari', 5),
(58, 'Hotel AB', '123 Rue de Pari', 5),
(59, 'Hotel AB', '123 Rue de Pari', 5),
(60, 'Hotel AB', '123 Rue de Pari', 5),
(61, 'Hotel AB', '123 Rue de Pari', 5),
(62, 'Hotel AB', '123 Rue de Pari', 5),
(63, 'Hotel AB', '123 Rue de Pari', 5),
(64, 'Hotel AB', '123 Rue de Pari', 5),
(65, 'Hotel AB', '123 Rue de Pari', 5),
(66, 'Hotel AB', '123 Rue de Pari', 5),
(67, 'Hotel AB', '123 Rue de Pari', 5),
(68, 'Hotel AB', '123 Rue de Pari', 5),
(69, 'Hotel AB', '123 Rue de Pari', 5),
(70, 'Hotel AB', '123 Rue de Pari', 5),
(71, 'Hotel AB', '123 Rue de Pari', 5),
(72, 'Hotel AB', '123 Rue de Pari', 5),
(73, 'Hotel AB', '123 Rue de Pari', 5),
(74, 'test', 'test', 12),
(76, 'La renaissance', '3 rue des potiers', 2),
(77, 'hiversV2', '3 rue des potiers', 8);

-- --------------------------------------------------------

--
-- Structure de la table `reservation`
--

CREATE TABLE `reservation` (
  `id` int(11) NOT NULL,
  `idChambre` int(11) DEFAULT NULL,
  `idHotel` int(11) NOT NULL,
  `idClient` int(11) DEFAULT NULL,
  `jourDebut` date NOT NULL,
  `jourFin` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `reservation`
--

INSERT INTO `reservation` (`id`, `idChambre`, `idHotel`, `idClient`, `jourDebut`, `jourFin`) VALUES
(46, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(48, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(49, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(50, 332, 45, 23, '2024-02-20', '2024-02-25'),
(51, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(52, 333, 45, 23, '2024-02-20', '2024-02-25'),
(53, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(54, 334, 45, 23, '2024-02-20', '2024-02-25'),
(55, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(56, 335, 45, 23, '2024-02-20', '2024-02-25'),
(57, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(58, 336, 45, 23, '2024-02-20', '2024-02-25'),
(59, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(60, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(61, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(62, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(63, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(64, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(65, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(66, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(67, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(68, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(69, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(70, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(71, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(72, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(73, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(74, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(75, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(76, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(77, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(78, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(79, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(80, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(81, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(82, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(83, NULL, 1, 1, '2024-02-20', '2024-02-25'),
(84, 106, 1, 52, '2020-03-10', '2020-03-10'),
(88, 338, 46, 57, '2020-04-04', '2020-04-04'),
(89, 498, 1, 52, '2021-02-01', '2021-02-01'),
(90, 496, 76, 57, '2022-12-02', '2022-12-04');

--
-- Index pour les tables exportées
--

--
-- Index pour la table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `chambre`
--
ALTER TABLE `chambre`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `employe`
--
ALTER TABLE `employe`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `hotel`
--
ALTER TABLE `hotel`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT pour la table `chambre`
--
ALTER TABLE `chambre`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=510;
--
-- AUTO_INCREMENT pour la table `client`
--
ALTER TABLE `client`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;
--
-- AUTO_INCREMENT pour la table `employe`
--
ALTER TABLE `employe`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;
--
-- AUTO_INCREMENT pour la table `hotel`
--
ALTER TABLE `hotel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;
--
-- AUTO_INCREMENT pour la table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
