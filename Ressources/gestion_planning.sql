-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Client :  127.0.0.1
-- Généré le :  Jeu 13 Juillet 2017 à 14:30
-- Version du serveur :  5.7.14
-- Version de PHP :  5.6.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `gestion_planning`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AjoutDatesCalendrier` (IN `NumPremierJour` INT)  BEGIN
 DECLARE startdate date;
 DECLARE enddate  date;
 DECLARE Jour int;
 

 
 SET startdate = makedate(year(CURRENT_DATE),1);
 SET enddate = last_day(DATE_ADD(CURRENT_DATE, INTERVAL 12-MONTH(CURRENT_DATE) MONTH));
 SET Jour = NumPremierJour;
 DELETE FROM calendrier WHERE 1;
 DELETE from horaires where 1;
 WHILE startdate  <= enddate DO
     INSERT INTO calendrier(Date_jour,Num_Jour)
     VALUES (startdate,Jour);
     SET startdate = DATE_ADD(startdate, INTERVAL 1 DAY);
     SET Jour = 1 + MOD(Jour,7);
 END WHILE;
 
 

 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Ajout_CA` (IN `IDPIN` INT, IN `IDLIN` INT, IN `NumMois` INT, IN `ListeJours` VARCHAR(500))  NO SQL
BEGIN
declare idx,prev_idx int;
declare v_id varchar(10);

set idx := locate(',',ListeJours,1);
set prev_idx := 1;

WHILE idx > 0 DO
 set v_id := substr(ListeJours,prev_idx,idx-prev_idx);
 insert into horaires(IDP,IDL,Date_Jour,NbHeures,Etat) values (IDPIN,IDLIN,concat(year(CURRENT_DATE),'-',NumMois,'-',v_id),0,'CA');
 set prev_idx := idx+1;
 set idx := locate(',',ListeJours,prev_idx);
END WHILE;

set v_id := substr(ListeJours,prev_idx);
insert into horaires(IDP,IDL,Date_Jour,NbHeures,Etat) values (IDPIN,IDLIN,concat(year(CURRENT_DATE),'-',NumMois,'-',v_id),0,'CA');


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Ajout_Heures_IDL` (IN `IDPIN` INT, IN `IDLIN` INT, IN `NumMois` INT, IN `ListeJours` VARCHAR(500), IN `NbHeure` DOUBLE)  NO SQL
BEGIN
declare idx,prev_idx int;
declare v_id varchar(10);

set idx := locate(',',ListeJours,1);
set prev_idx := 1;

WHILE idx > 0 DO
 set v_id := substr(ListeJours,prev_idx,idx-prev_idx);
 insert into horaires(IDP,IDL,Date_Jour,NbHeures,Etat) values (IDPIN,IDLIN,concat(year(CURRENT_DATE),'-',NumMois,'-',v_id),NbHeure,'Travail');
 set prev_idx := idx+1;
 set idx := locate(',',ListeJours,prev_idx);
END WHILE;

set v_id := substr(ListeJours,prev_idx);
insert into horaires(IDP,IDL,Date_Jour,NbHeures,Etat) values (IDPIN,IDLIN,concat(year(CURRENT_DATE),'-',NumMois,'-',v_id),NbHeure,'Travail');


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Ajout_Maladie` (IN `IDPIN` INT, IN `IDLIN` INT, IN `NumMois` INT, IN `ListeJours` VARCHAR(500))  NO SQL
BEGIN
declare idx,prev_idx int;
declare v_id varchar(10);

set idx := locate(',',ListeJours,1);
set prev_idx := 1;

WHILE idx > 0 DO
 set v_id := substr(ListeJours,prev_idx,idx-prev_idx);
 insert into horaires(IDP,IDL,Date_Jour,NbHeures,Etat) values (IDPIN,IDLIN,concat(year(CURRENT_DATE),'-',NumMois,'-',v_id),0,'Maladie');
 set prev_idx := idx+1;
 set idx := locate(',',ListeJours,prev_idx);
END WHILE;

set v_id := substr(ListeJours,prev_idx);
insert into horaires(IDP,IDL,Date_Jour,NbHeures,Etat) values (IDPIN,IDLIN,concat(year(CURRENT_DATE),'-',NumMois,'-',v_id),0,'Maladie');


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Ajout_Repos` (IN `IDPIN` INT, IN `IDLIN` INT, IN `NumMois` INT, IN `ListeJours` VARCHAR(500))  NO SQL
BEGIN
declare idx,prev_idx int;
declare v_id varchar(10);

set idx := locate(',',ListeJours,1);
set prev_idx := 1;

WHILE idx > 0 DO
 set v_id := substr(ListeJours,prev_idx,idx-prev_idx);
 insert into horaires(IDP,IDL,Date_Jour,NbHeures,Etat) values (IDPIN,IDLIN,concat(year(CURRENT_DATE),'-',NumMois,'-',v_id),0,'Repos');
 set prev_idx := idx+1;
 set idx := locate(',',ListeJours,prev_idx);
END WHILE;

set v_id := substr(ListeJours,prev_idx);
insert into horaires(IDP,IDL,Date_Jour,NbHeures,Etat) values (IDPIN,IDLIN,concat(year(CURRENT_DATE),'-',NumMois,'-',v_id),0,'Repos');


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_heures_mois` (IN `IDPIN` INT, IN `NumMois` INT)  NO SQL
SELECT site.NomLieu, sum(NbHeures) as 'Total(Lieu)' from horaires join site on site.IDL=horaires.IDL where idp=IDPIN and month(Date_jour)=NumMois group by site.IDL$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `config_mois` (IN `IDPIN` INT, IN `NumMois` INT)  NO SQL
SELECT  sum(NbHeures) as 'Total(Lieu)', (SELECT count(Etat) from horaires WHERE idp=IDPIN and Etat='Repos'and month(Date_jour)=NumMois) as 'RTTs', (SELECT count(Etat) from horaires WHERE idp=IDPIN and Etat='Maladie' and month(Date_jour)=NumMois) as 'Maladie',(SELECT count(Etat) from horaires WHERE idp=IDPIN and Etat='CA' and month(Date_jour)=NumMois) as 'CA',(SELECT count(Etat) from horaires WHERE idp=IDPIN and Etat='CA avant Avril' and month(Date_jour)=NumMois) as 'CA av Avril' from horaires WHERE horaires.IDP=IDPIN and month(Date_jour)=NumMois$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CreationTotauxPersonne` (IN `IDP` INT, IN `IDL` INT)  BEGIN
 DECLARE i int ;

 
 
 SET i = '01';
 
 WHILE i  <= '12' DO
     INSERT INTO total(idp,idl,mois,total)
     VALUES (IDP,IDL,i,0);
     SET i = i+1;
 END WHILE;
 
 

 END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eraseTest` ()  BEGIN
  delete from  horaires where idp!=3;
  update personne set nbhfaites=0 where idp!=3;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `admin`
--

CREATE TABLE `admin` (
  `Mdp` varchar(40) CHARACTER SET utf8 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `admin`
--

INSERT INTO `admin` (`Mdp`) VALUES
('3c018426ba45a42286951e125408ea7374c864f5');

-- --------------------------------------------------------

--
-- Structure de la table `calendrier`
--

CREATE TABLE `calendrier` (
  `Date_jour` date NOT NULL,
  `Num_jour` int(11) NOT NULL,
  `Ferie` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `calendrier`
--

INSERT INTO `calendrier` (`Date_jour`, `Num_jour`, `Ferie`) VALUES
('2017-01-01', 7, 0),
('2017-01-02', 1, 0),
('2017-01-03', 2, 0),
('2017-01-04', 3, 0),
('2017-01-05', 4, 0),
('2017-01-06', 5, 0),
('2017-01-07', 6, 0),
('2017-01-08', 7, 0),
('2017-01-09', 1, 0),
('2017-01-10', 2, 0),
('2017-01-11', 3, 0),
('2017-01-12', 4, 0),
('2017-01-13', 5, 0),
('2017-01-14', 6, 0),
('2017-01-15', 7, 0),
('2017-01-16', 1, 0),
('2017-01-17', 2, 0),
('2017-01-18', 3, 0),
('2017-01-19', 4, 0),
('2017-01-20', 5, 0),
('2017-01-21', 6, 0),
('2017-01-22', 7, 0),
('2017-01-23', 1, 0),
('2017-01-24', 2, 0),
('2017-01-25', 3, 0),
('2017-01-26', 4, 0),
('2017-01-27', 5, 0),
('2017-01-28', 6, 0),
('2017-01-29', 7, 0),
('2017-01-30', 1, 0),
('2017-01-31', 2, 0),
('2017-02-01', 3, 0),
('2017-02-02', 4, 0),
('2017-02-03', 5, 0),
('2017-02-04', 6, 0),
('2017-02-05', 7, 0),
('2017-02-06', 1, 0),
('2017-02-07', 2, 0),
('2017-02-08', 3, 0),
('2017-02-09', 4, 0),
('2017-02-10', 5, 0),
('2017-02-11', 6, 0),
('2017-02-12', 7, 0),
('2017-02-13', 1, 0),
('2017-02-14', 2, 0),
('2017-02-15', 3, 0),
('2017-02-16', 4, 0),
('2017-02-17', 5, 0),
('2017-02-18', 6, 0),
('2017-02-19', 7, 0),
('2017-02-20', 1, 0),
('2017-02-21', 2, 0),
('2017-02-22', 3, 0),
('2017-02-23', 4, 0),
('2017-02-24', 5, 0),
('2017-02-25', 6, 0),
('2017-02-26', 7, 0),
('2017-02-27', 1, 0),
('2017-02-28', 2, 0),
('2017-03-01', 3, 0),
('2017-03-02', 4, 0),
('2017-03-03', 5, 0),
('2017-03-04', 6, 0),
('2017-03-05', 7, 0),
('2017-03-06', 1, 0),
('2017-03-07', 2, 0),
('2017-03-08', 3, 0),
('2017-03-09', 4, 0),
('2017-03-10', 5, 0),
('2017-03-11', 6, 0),
('2017-03-12', 7, 0),
('2017-03-13', 1, 0),
('2017-03-14', 2, 0),
('2017-03-15', 3, 0),
('2017-03-16', 4, 0),
('2017-03-17', 5, 0),
('2017-03-18', 6, 0),
('2017-03-19', 7, 0),
('2017-03-20', 1, 0),
('2017-03-21', 2, 0),
('2017-03-22', 3, 0),
('2017-03-23', 4, 0),
('2017-03-24', 5, 0),
('2017-03-25', 6, 0),
('2017-03-26', 7, 0),
('2017-03-27', 1, 0),
('2017-03-28', 2, 0),
('2017-03-29', 3, 0),
('2017-03-30', 4, 0),
('2017-03-31', 5, 0),
('2017-04-01', 6, 0),
('2017-04-02', 7, 0),
('2017-04-03', 1, 0),
('2017-04-04', 2, 0),
('2017-04-05', 3, 0),
('2017-04-06', 4, 0),
('2017-04-07', 5, 0),
('2017-04-08', 6, 0),
('2017-04-09', 7, 0),
('2017-04-10', 1, 0),
('2017-04-11', 2, 0),
('2017-04-12', 3, 0),
('2017-04-13', 4, 0),
('2017-04-14', 5, 0),
('2017-04-15', 6, 0),
('2017-04-16', 7, 0),
('2017-04-17', 1, 1),
('2017-04-18', 2, 0),
('2017-04-19', 3, 0),
('2017-04-20', 4, 0),
('2017-04-21', 5, 0),
('2017-04-22', 6, 0),
('2017-04-23', 7, 0),
('2017-04-24', 1, 0),
('2017-04-25', 2, 0),
('2017-04-26', 3, 0),
('2017-04-27', 4, 0),
('2017-04-28', 5, 0),
('2017-04-29', 6, 0),
('2017-04-30', 7, 0),
('2017-05-01', 1, 1),
('2017-05-02', 2, 0),
('2017-05-03', 3, 0),
('2017-05-04', 4, 0),
('2017-05-05', 5, 0),
('2017-05-06', 6, 0),
('2017-05-07', 7, 0),
('2017-05-08', 1, 1),
('2017-05-09', 2, 0),
('2017-05-10', 3, 0),
('2017-05-11', 4, 0),
('2017-05-12', 5, 0),
('2017-05-13', 6, 0),
('2017-05-14', 7, 0),
('2017-05-15', 1, 0),
('2017-05-16', 2, 0),
('2017-05-17', 3, 0),
('2017-05-18', 4, 0),
('2017-05-19', 5, 0),
('2017-05-20', 6, 0),
('2017-05-21', 7, 0),
('2017-05-22', 1, 0),
('2017-05-23', 2, 0),
('2017-05-24', 3, 0),
('2017-05-25', 4, 1),
('2017-05-26', 5, 0),
('2017-05-27', 6, 0),
('2017-05-28', 7, 0),
('2017-05-29', 1, 0),
('2017-05-30', 2, 0),
('2017-05-31', 3, 0),
('2017-06-01', 4, 0),
('2017-06-02', 5, 0),
('2017-06-03', 6, 0),
('2017-06-04', 7, 0),
('2017-06-05', 1, 1),
('2017-06-06', 2, 0),
('2017-06-07', 3, 0),
('2017-06-08', 4, 0),
('2017-06-09', 5, 0),
('2017-06-10', 6, 0),
('2017-06-11', 7, 0),
('2017-06-12', 1, 0),
('2017-06-13', 2, 0),
('2017-06-14', 3, 0),
('2017-06-15', 4, 0),
('2017-06-16', 5, 0),
('2017-06-17', 6, 0),
('2017-06-18', 7, 0),
('2017-06-19', 1, 0),
('2017-06-20', 2, 0),
('2017-06-21', 3, 0),
('2017-06-22', 4, 0),
('2017-06-23', 5, 0),
('2017-06-24', 6, 0),
('2017-06-25', 7, 0),
('2017-06-26', 1, 0),
('2017-06-27', 2, 0),
('2017-06-28', 3, 0),
('2017-06-29', 4, 0),
('2017-06-30', 5, 0),
('2017-07-01', 6, 0),
('2017-07-02', 7, 0),
('2017-07-03', 1, 0),
('2017-07-04', 2, 0),
('2017-07-05', 3, 0),
('2017-07-06', 4, 0),
('2017-07-07', 5, 0),
('2017-07-08', 6, 0),
('2017-07-09', 7, 0),
('2017-07-10', 1, 0),
('2017-07-11', 2, 0),
('2017-07-12', 3, 0),
('2017-07-13', 4, 0),
('2017-07-14', 5, 1),
('2017-07-15', 6, 0),
('2017-07-16', 7, 0),
('2017-07-17', 1, 0),
('2017-07-18', 2, 0),
('2017-07-19', 3, 0),
('2017-07-20', 4, 0),
('2017-07-21', 5, 0),
('2017-07-22', 6, 0),
('2017-07-23', 7, 0),
('2017-07-24', 1, 0),
('2017-07-25', 2, 0),
('2017-07-26', 3, 0),
('2017-07-27', 4, 0),
('2017-07-28', 5, 0),
('2017-07-29', 6, 0),
('2017-07-30', 7, 0),
('2017-07-31', 1, 0),
('2017-08-01', 2, 0),
('2017-08-02', 3, 0),
('2017-08-03', 4, 0),
('2017-08-04', 5, 0),
('2017-08-05', 6, 0),
('2017-08-06', 7, 0),
('2017-08-07', 1, 0),
('2017-08-08', 2, 0),
('2017-08-09', 3, 0),
('2017-08-10', 4, 0),
('2017-08-11', 5, 0),
('2017-08-12', 6, 0),
('2017-08-13', 7, 0),
('2017-08-14', 1, 0),
('2017-08-15', 2, 1),
('2017-08-16', 3, 0),
('2017-08-17', 4, 0),
('2017-08-18', 5, 0),
('2017-08-19', 6, 0),
('2017-08-20', 7, 0),
('2017-08-21', 1, 0),
('2017-08-22', 2, 0),
('2017-08-23', 3, 0),
('2017-08-24', 4, 0),
('2017-08-25', 5, 0),
('2017-08-26', 6, 0),
('2017-08-27', 7, 0),
('2017-08-28', 1, 0),
('2017-08-29', 2, 0),
('2017-08-30', 3, 0),
('2017-08-31', 4, 0),
('2017-09-01', 5, 0),
('2017-09-02', 6, 0),
('2017-09-03', 7, 0),
('2017-09-04', 1, 0),
('2017-09-05', 2, 0),
('2017-09-06', 3, 0),
('2017-09-07', 4, 0),
('2017-09-08', 5, 0),
('2017-09-09', 6, 0),
('2017-09-10', 7, 0),
('2017-09-11', 1, 0),
('2017-09-12', 2, 0),
('2017-09-13', 3, 0),
('2017-09-14', 4, 0),
('2017-09-15', 5, 0),
('2017-09-16', 6, 0),
('2017-09-17', 7, 0),
('2017-09-18', 1, 0),
('2017-09-19', 2, 0),
('2017-09-20', 3, 0),
('2017-09-21', 4, 0),
('2017-09-22', 5, 0),
('2017-09-23', 6, 0),
('2017-09-24', 7, 0),
('2017-09-25', 1, 0),
('2017-09-26', 2, 0),
('2017-09-27', 3, 0),
('2017-09-28', 4, 0),
('2017-09-29', 5, 0),
('2017-09-30', 6, 0),
('2017-10-01', 7, 0),
('2017-10-02', 1, 0),
('2017-10-03', 2, 0),
('2017-10-04', 3, 0),
('2017-10-05', 4, 0),
('2017-10-06', 5, 0),
('2017-10-07', 6, 0),
('2017-10-08', 7, 0),
('2017-10-09', 1, 0),
('2017-10-10', 2, 0),
('2017-10-11', 3, 0),
('2017-10-12', 4, 0),
('2017-10-13', 5, 0),
('2017-10-14', 6, 0),
('2017-10-15', 7, 0),
('2017-10-16', 1, 0),
('2017-10-17', 2, 0),
('2017-10-18', 3, 0),
('2017-10-19', 4, 0),
('2017-10-20', 5, 0),
('2017-10-21', 6, 0),
('2017-10-22', 7, 0),
('2017-10-23', 1, 0),
('2017-10-24', 2, 0),
('2017-10-25', 3, 0),
('2017-10-26', 4, 0),
('2017-10-27', 5, 0),
('2017-10-28', 6, 0),
('2017-10-29', 7, 0),
('2017-10-30', 1, 0),
('2017-10-31', 2, 0),
('2017-11-01', 3, 0),
('2017-11-02', 4, 0),
('2017-11-03', 5, 0),
('2017-11-04', 6, 0),
('2017-11-05', 7, 0),
('2017-11-06', 1, 0),
('2017-11-07', 2, 0),
('2017-11-08', 3, 0),
('2017-11-09', 4, 0),
('2017-11-10', 5, 0),
('2017-11-11', 6, 0),
('2017-11-12', 7, 0),
('2017-11-13', 1, 0),
('2017-11-14', 2, 0),
('2017-11-15', 3, 0),
('2017-11-16', 4, 0),
('2017-11-17', 5, 0),
('2017-11-18', 6, 0),
('2017-11-19', 7, 0),
('2017-11-20', 1, 0),
('2017-11-21', 2, 0),
('2017-11-22', 3, 0),
('2017-11-23', 4, 0),
('2017-11-24', 5, 0),
('2017-11-25', 6, 0),
('2017-11-26', 7, 0),
('2017-11-27', 1, 0),
('2017-11-28', 2, 0),
('2017-11-29', 3, 0),
('2017-11-30', 4, 0),
('2017-12-01', 5, 0),
('2017-12-02', 6, 0),
('2017-12-03', 7, 0),
('2017-12-04', 1, 0),
('2017-12-05', 2, 0),
('2017-12-06', 3, 0),
('2017-12-07', 4, 0),
('2017-12-08', 5, 0),
('2017-12-09', 6, 0),
('2017-12-10', 7, 0),
('2017-12-11', 1, 0),
('2017-12-12', 2, 0),
('2017-12-13', 3, 0),
('2017-12-14', 4, 0),
('2017-12-15', 5, 0),
('2017-12-16', 6, 0),
('2017-12-17', 7, 0),
('2017-12-18', 1, 0),
('2017-12-19', 2, 0),
('2017-12-20', 3, 0),
('2017-12-21', 4, 0),
('2017-12-22', 5, 0),
('2017-12-23', 6, 0),
('2017-12-24', 7, 0),
('2017-12-25', 1, 0),
('2017-12-26', 2, 0),
('2017-12-27', 3, 0),
('2017-12-28', 4, 0),
('2017-12-29', 5, 0),
('2017-12-30', 6, 0),
('2017-12-31', 7, 0);

-- --------------------------------------------------------

--
-- Structure de la table `categories`
--

CREATE TABLE `categories` (
  `NumCat` int(10) NOT NULL,
  `NomCat` varchar(30) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `categories`
--

INSERT INTO `categories` (`NumCat`, `NomCat`) VALUES
(1, 'Études'),
(2, 'Périscolaire'),
(12, 'Ménage'),
(14, 'Scolaire'),
(15, 'Cantine');

-- --------------------------------------------------------

--
-- Structure de la table `horaires`
--

CREATE TABLE `horaires` (
  `IDP` int(11) NOT NULL,
  `IDL` int(11) NOT NULL,
  `Date_jour` date NOT NULL,
  `NbHeures` double UNSIGNED NOT NULL,
  `Etat` varchar(25) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Checked` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `horaires`
--

INSERT INTO `horaires` (`IDP`, `IDL`, `Date_jour`, `NbHeures`, `Etat`, `Checked`) VALUES
(139, 95, '2017-07-05', 5, 'Travail', 0),
(139, 95, '2017-07-06', 5, 'Travail', 0),
(139, 95, '2017-07-04', 5, 'Travail', 0),
(139, 95, '2017-07-03', 5, 'Travail', 0),
(142, 95, '2017-08-17', 0, 'CA', 0),
(142, 95, '2017-08-31', 0, 'CA', 0),
(142, 95, '2017-08-30', 0, 'CA', 0),
(142, 95, '2017-08-29', 0, 'CA', 0),
(142, 95, '2017-08-28', 0, 'CA', 0),
(142, 95, '2017-08-25', 0, 'CA', 0),
(142, 95, '2017-08-24', 0, 'CA', 0),
(142, 95, '2017-08-23', 0, 'CA', 0),
(142, 95, '2017-08-22', 0, 'CA', 0),
(142, 95, '2017-08-21', 0, 'CA', 0),
(142, 95, '2017-08-18', 0, 'CA', 0),
(142, 95, '2017-08-16', 0, 'CA', 0),
(142, 95, '2017-08-14', 0, 'CA', 0),
(142, 95, '2017-08-11', 0, 'CA', 0),
(142, 95, '2017-08-10', 0, 'CA', 0),
(142, 95, '2017-08-09', 0, 'CA', 0),
(142, 95, '2017-08-08', 0, 'CA', 0),
(142, 95, '2017-08-07', 0, 'CA', 0),
(142, 95, '2017-08-04', 0, 'CA', 0),
(142, 95, '2017-08-03', 0, 'CA', 0),
(142, 95, '2017-08-02', 0, 'CA', 0),
(142, 95, '2017-08-01', 0, 'CA', 0),
(142, 95, '2017-07-31', 0, 'CA', 0),
(142, 95, '2017-07-28', 0, 'CA', 0),
(142, 95, '2017-07-27', 0, 'CA', 0),
(142, 95, '2017-07-26', 0, 'Repos', 0),
(142, 95, '2017-07-25', 5, 'Repos', 0),
(142, 95, '2017-07-24', 0, 'Repos', 0),
(142, 95, '2017-07-21', 9, 'Travail', 0),
(142, 95, '2017-07-20', 9, 'Travail', 0),
(142, 95, '2017-07-19', 9, 'Travail', 1),
(142, 95, '2017-07-18', 9, 'Travail', 0),
(142, 95, '2017-07-17', 9, 'Travail', 0),
(142, 95, '2017-07-14', 9, 'Travail', 0),
(142, 95, '2017-07-13', 9, 'Travail', 0),
(142, 95, '2017-07-12', 9, 'Travail', 0),
(142, 95, '2017-07-11', 9, 'Travail', 0),
(142, 95, '2017-07-10', 9, 'Travail', 0),
(142, 95, '2017-07-07', 9, 'Travail', 0),
(142, 95, '2017-07-06', 8.75, 'Travail', 0),
(142, 95, '2017-07-05', 5, 'Travail', 0),
(142, 95, '2017-07-04', 8.75, 'Travail', 0),
(142, 95, '2017-07-03', 8.75, 'Travail', 0),
(142, 95, '2017-06-30', 9, 'Travail', 0),
(142, 95, '2017-06-29', 8.75, 'Travail', 0),
(142, 95, '2017-06-28', 5, 'Travail', 0),
(142, 95, '2017-06-27', 8.75, 'Travail', 0),
(142, 95, '2017-06-26', 8.75, 'Travail', 0),
(142, 95, '2017-06-23', 9, 'Travail', 0),
(142, 95, '2017-06-22', 8.75, 'Travail', 0),
(142, 95, '2017-06-21', 5, 'Travail', 0),
(142, 95, '2017-06-20', 9.25, 'Travail', 1),
(142, 95, '2017-06-19', 8.75, 'Travail', 0),
(142, 95, '2017-06-16', 9, 'Travail', 0),
(142, 95, '2017-06-15', 8.25, 'Travail', 0),
(142, 95, '2017-06-14', 5, 'Travail', 0),
(142, 95, '2017-06-13', 8.25, 'Travail', 0),
(142, 95, '2017-06-12', 8.75, 'Travail', 0),
(142, 95, '2017-06-09', 9, 'Travail', 0),
(142, 95, '2017-06-08', 8.25, 'Travail', 0),
(142, 95, '2017-06-07', 5, 'Travail', 0),
(142, 95, '2017-06-06', 8.25, 'Travail', 0),
(142, 95, '2017-06-02', 9, 'Travail', 0),
(142, 95, '2017-06-01', 8.25, 'Travail', 0),
(142, 95, '2017-05-31', 6.5, 'Travail', 0),
(142, 95, '2017-05-30', 8.25, 'Travail', 0),
(142, 95, '2017-05-29', 7.75, 'Travail', 1),
(142, 95, '2017-05-24', 6.5, 'Travail', 1),
(142, 95, '2017-05-23', 8.25, 'Travail', 0),
(142, 95, '2017-05-22', 8.75, 'Travail', 0),
(142, 95, '2017-05-19', 9, 'Travail', 0),
(142, 95, '2017-05-18', 8.25, 'Travail', 0),
(142, 95, '2017-05-17', 5, 'Travail', 0),
(142, 95, '2017-05-16', 8.25, 'Travail', 0),
(142, 95, '2017-05-15', 8.75, 'Travail', 0),
(142, 95, '2017-05-12', 9, 'Travail', 0),
(142, 95, '2017-05-11', 8.25, 'Travail', 0),
(142, 95, '2017-05-10', 4.5, 'Travail', 1),
(142, 95, '2017-05-09', 8.25, 'Travail', 0),
(142, 95, '2017-05-05', 9, 'Travail', 0),
(142, 95, '2017-05-04', 8.25, 'Travail', 0),
(142, 95, '2017-05-03', 5, 'Travail', 0),
(142, 95, '2017-05-02', 8.25, 'Travail', 0),
(142, 95, '2017-04-28', 9, 'Travail', 0),
(142, 95, '2017-04-27', 8.25, 'Travail', 0),
(142, 95, '2017-04-26', 5, 'Travail', 0),
(142, 95, '2017-04-25', 8.25, 'Travail', 0),
(142, 95, '2017-04-24', 8.75, 'Travail', 0),
(142, 95, '2017-04-21', 9, 'Travail', 0),
(142, 95, '2017-04-20', 8.25, 'Travail', 0),
(142, 95, '2017-04-19', 6.5, 'Travail', 0),
(142, 95, '2017-04-18', 8.25, 'Travail', 0),
(142, 95, '2017-04-13', 0, 'Repos', 0),
(142, 95, '2017-04-14', 0, 'Repos', 0),
(142, 95, '2017-04-12', 0, 'Repos', 0),
(142, 95, '2017-04-11', 0, 'Repos', 0),
(142, 95, '2017-04-10', 0, 'Repos', 0),
(142, 95, '2017-04-07', 7, 'Travail', 0),
(142, 95, '2017-04-06', 7, 'Travail', 0),
(142, 95, '2017-04-05', 7, 'Travail', 0),
(142, 95, '2017-04-04', 7, 'Travail', 0),
(142, 95, '2017-04-03', 7, 'Travail', 0),
(142, 95, '2017-03-31', 9, 'Travail', 1),
(142, 95, '2017-03-30', 8.25, 'Travail', 1),
(142, 95, '2017-03-29', 5, 'Travail', 1),
(142, 95, '2017-03-28', 7.25, 'Travail', 1),
(142, 95, '2017-03-27', 8.75, 'Travail', 1),
(142, 95, '2017-03-24', 9, 'Travail', 1),
(142, 95, '2017-03-23', 8.25, 'Travail', 1),
(142, 95, '2017-03-22', 5, 'Demi Repos', 1),
(142, 95, '2017-03-21', 8.25, 'Travail', 1),
(142, 95, '2017-03-20', 8.75, 'Travail', 1),
(142, 95, '2017-03-17', 9, 'Travail', 1),
(142, 95, '2017-03-16', 8.25, 'Travail', 1),
(142, 95, '2017-03-15', 6.5, 'Demi Repos', 1),
(142, 95, '2017-03-14', 8.25, 'Travail', 1),
(142, 95, '2017-03-13', 8.75, 'Travail', 1),
(142, 95, '2017-03-10', 9, 'Travail', 1),
(142, 95, '2017-03-09', 8.25, 'Travail', 1),
(142, 95, '2017-03-08', 5, 'Demi Repos', 1),
(142, 95, '2017-03-07', 8.25, 'Travail', 1),
(142, 95, '2017-03-06', 8.75, 'Travail', 1),
(142, 95, '2017-03-03', 8.25, 'Travail', 1),
(142, 95, '2017-03-02', 8.25, 'Travail', 1),
(142, 95, '2017-03-01', 5, 'Demi Repos', 1),
(142, 95, '2017-02-28', 8.25, 'Travail', 1),
(142, 95, '2017-02-27', 8.75, 'Travail', 1),
(142, 95, '2017-02-24', 9, 'Travail', 1),
(142, 95, '2017-02-23', 8.25, 'Travail', 1),
(142, 95, '2017-02-22', 6.5, 'Demi Repos', 1),
(142, 95, '2017-02-21', 8.75, 'Travail', 1),
(142, 95, '2017-02-20', 7.75, 'Travail', 1),
(142, 95, '2017-02-17', 0, 'Repos', 0),
(142, 95, '2017-02-16', 0, 'Repos', 0),
(142, 95, '2017-02-15', 0, 'Repos', 0),
(142, 95, '2017-02-14', 7, 'Travail', 1),
(142, 95, '2017-02-13', 7, 'Travail', 1),
(142, 95, '2017-02-10', 7, 'Travail', 1),
(142, 95, '2017-02-09', 7, 'Travail', 1),
(142, 95, '2017-02-08', 7, 'Travail', 1),
(142, 95, '2017-02-07', 7, 'Travail', 1),
(142, 95, '2017-02-06', 7, 'Travail', 1),
(142, 95, '2017-02-03', 8.25, 'Travail', 1),
(142, 95, '2017-02-02', 8.25, 'Travail', 1),
(142, 95, '2017-02-01', 5, 'Demi Repos', 1),
(142, 95, '2017-01-31', 8.25, 'Travail', 1),
(142, 95, '2017-01-30', 8.75, 'Travail', 1),
(142, 95, '2017-01-27', 8.25, 'Travail', 1),
(142, 95, '2017-01-26', 8.25, 'Travail', 1),
(142, 95, '2017-01-25', 5, 'Demi Repos', 1),
(142, 95, '2017-01-24', 8.25, 'Travail', 1),
(142, 95, '2017-01-23', 8.75, 'Travail', 1),
(142, 95, '2017-01-20', 8.25, 'Travail', 1),
(142, 95, '2017-01-19', 8.25, 'Travail', 1),
(142, 95, '2017-01-18', 6.5, 'Demi Repos', 1),
(142, 95, '2017-01-17', 8.25, 'Travail', 1),
(142, 95, '2017-01-16', 8.75, 'Travail', 1),
(142, 95, '2017-01-13', 8.25, 'Travail', 1),
(142, 95, '2017-01-12', 8.25, 'Travail', 1),
(142, 95, '2017-01-11', 5, 'Demi Repos', 1),
(142, 95, '2017-01-10', 8.75, 'Travail', 1),
(142, 95, '2017-01-09', 8.75, 'Travail', 1),
(142, 95, '2017-01-06', 8.25, 'Travail', 1),
(142, 95, '2017-01-05', 8.25, 'Travail', 1),
(142, 95, '2017-01-04', 5, 'Demi Repos', 1),
(142, 95, '2017-01-03', 7.25, 'Travail', 1),
(142, 95, '2017-01-02', 0, 'Repos', 0),
(138, 110, '2017-01-02', 0, 'Repos', 0),
(138, 121, '2017-01-03', 1.5, 'Travail', 1),
(138, 110, '2017-01-04', 5, 'Travail', 1),
(138, 110, '2017-01-05', 8.25, 'Travail', 1),
(138, 110, '2017-01-06', 8.25, 'Travail', 1),
(138, 110, '2017-01-09', 8.25, 'Travail', 1),
(138, 110, '2017-01-10', 8.75, 'Travail', 1),
(138, 110, '2017-01-11', 5, 'Travail', 1),
(138, 110, '2017-01-12', 8.25, 'Travail', 1),
(138, 110, '2017-01-13', 8.25, 'Travail', 1),
(138, 110, '2017-01-16', 8.75, 'Travail', 1),
(138, 110, '2017-01-17', 8.75, 'Travail', 1),
(138, 110, '2017-01-18', 5, 'Travail', 1),
(138, 110, '2017-01-19', 8.25, 'Travail', 1),
(138, 110, '2017-01-20', 8.25, 'Travail', 1),
(138, 110, '2017-01-23', 8.25, 'Travail', 1),
(138, 110, '2017-01-24', 8.75, 'Travail', 1),
(138, 110, '2017-01-25', 6.5, 'Travail', 1),
(138, 110, '2017-01-26', 8.25, 'Travail', 1),
(138, 110, '2017-01-27', 8.25, 'Travail', 1),
(138, 110, '2017-01-30', 8.75, 'Travail', 1),
(138, 110, '2017-01-31', 8.75, 'Travail', 1),
(138, 110, '2017-07-17', 0, 'CA', 0),
(138, 110, '2017-07-18', 0, 'CA', 0),
(138, 110, '2017-07-19', 0, 'CA', 0),
(138, 110, '2017-07-20', 0, 'CA', 0),
(138, 110, '2017-07-21', 0, 'CA', 0),
(138, 110, '2017-07-24', 0, 'CA', 0),
(138, 110, '2017-07-25', 0, 'CA', 0),
(138, 110, '2017-07-26', 0, 'CA', 0),
(138, 110, '2017-07-27', 0, 'CA', 0),
(138, 110, '2017-07-28', 0, 'CA', 0),
(138, 110, '2017-07-31', 0, 'CA', 0),
(138, 110, '2017-07-03', 8.75, 'Travail', 0),
(138, 110, '2017-07-04', 8.25, 'Travail', 0),
(138, 110, '2017-07-05', 5, 'Travail', 0),
(138, 110, '2017-07-06', 8.25, 'Travail', 0),
(138, 110, '2017-07-07', 8.25, 'Travail', 0),
(138, 110, '2017-07-10', 7, 'Travail', 0),
(138, 110, '2017-07-11', 7, 'Travail', 0),
(138, 110, '2017-07-12', 7, 'Travail', 0),
(138, 110, '2017-07-13', 7, 'Travail', 0),
(138, 110, '2017-08-01', 0, 'CA', 0),
(138, 110, '2017-08-02', 0, 'CA', 0),
(138, 110, '2017-08-03', 0, 'CA', 0),
(138, 110, '2017-08-04', 0, 'CA', 0),
(138, 110, '2017-08-07', 0, 'CA', 0),
(138, 110, '2017-08-08', 0, 'CA', 0),
(138, 110, '2017-08-10', 0, 'CA', 0),
(138, 110, '2017-08-09', 0, 'CA', 0),
(138, 110, '2017-08-11', 0, 'CA', 0),
(138, 110, '2017-08-14', 0, 'CA', 0),
(138, 110, '2017-08-16', 0, 'CA', 0),
(138, 110, '2017-08-17', 0, 'CA', 0),
(138, 110, '2017-08-18', 0, 'CA', 0),
(138, 110, '2017-08-21', 0, 'CA', 0),
(138, 110, '2017-08-22', 0, 'CA', 0),
(138, 110, '2017-08-23', 0, 'CA', 0),
(138, 110, '2017-08-24', 0, 'CA', 0),
(138, 110, '2017-08-25', 0, 'Repos', 0),
(138, 110, '2017-08-28', 7, 'Travail', 0),
(138, 110, '2017-08-29', 7, 'Travail', 0),
(138, 110, '2017-08-30', 7, 'Travail', 0),
(138, 110, '2017-08-31', 7, 'Travail', 0),
(123, 107, '2017-06-01', 2.25, 'Travail', 0),
(123, 99, '2017-06-01', 2, 'Travail', 0),
(123, 98, '2017-06-01', 1, 'Travail', 0),
(138, 119, '2017-01-13', 1, 'Travail', 1),
(138, 120, '2017-01-03', 5.75, 'Travail', 1),
(138, 110, '2017-01-03', 0.5, 'Travail', 1),
(123, 124, '2017-07-11', 0, 'CA', 0),
(142, 128, '2017-07-03', 0, 'Maladie', 0);

--
-- Déclencheurs `horaires`
--
DELIMITER $$
CREATE TRIGGER `Ajout_CA` AFTER INSERT ON `horaires` FOR EACH ROW BEGIN
  DECLARE maxCA INT;
  DECLARE actCA INT;
  SET maxCA = (SELECT personne.CAapMax from personne where personne.IDP = New.IDP);
  SET actCA = (SELECT personne.CAapPris from personne where personne.IDP = New.IDP);
  IF New.Etat='CA' AND actCA+1<=maxCA THEN BEGIN
      

    UPDATE personne SET personne.CAapPris = personne.CAapPris + 1 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_CA2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  DECLARE maxCA INT;
  DECLARE actCA INT;
  SET maxCA = (SELECT personne.CAapMax from personne where personne.IDP = New.IDP);
  SET actCA = (SELECT personne.CAapPris from personne where personne.IDP = New.IDP);
  IF New.Etat='CA' AND actCA+1<=maxCA THEN BEGIN
    UPDATE personne SET personne.CAapPris = personne.CAapPris + 1 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_CA_Avant_Janvier2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='CA avant Janvier' THEN BEGIN
    UPDATE personne SET personne.CAavPris = personne.CAavPris + 1 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_CA_Avant_janvier` AFTER INSERT ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='CA avant Janvier' THEN BEGIN
    UPDATE personne SET personne.CAavPris = personne.CAavPris + 1 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_Demi_CA` AFTER INSERT ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='Demi CA' THEN BEGIN
    UPDATE personne SET personne.CAapPris = personne.CAapPris + 0.5 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_Demi_CA2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='Demi CA' THEN BEGIN
    UPDATE personne SET personne.CAapPris = personne.CAapPris + 0.5 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_Demi_CA_Avant_Janvier` AFTER INSERT ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='Demi CA avant Janvier' THEN BEGIN
    UPDATE personne SET personne.CAavPris = personne.CAavPris + 0.5 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_Demi_CA_Avant_Janvier2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='Demi CA avant Janvier' THEN BEGIN
    UPDATE personne SET personne.CAavPris = personne.CAavPris + 0.5 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_Demi_Repos` AFTER INSERT ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='Demi Repos' THEN BEGIN
    UPDATE personne SET personne.RTTpris = personne.RTTpris + 0.5 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_Demi_Repos2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='Demi Repos' THEN BEGIN
    UPDATE personne SET personne.RTTpris = personne.RTTpris + 0.5 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_Heure2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF (New.Etat = 'Travail' OR New.Etat='Maladie' OR New.Etat='Repos' OR New.Etat='Demi Repos') AND New.NbHeures>0 THEN BEGIN
    UPDATE personne SET personne.NbHFaites = personne.NbHFaites+New.NbHeures WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_Heures` AFTER INSERT ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat = 'Travail' AND New.NbHeures>0 THEN BEGIN
    UPDATE personne SET personne.NbHFaites = personne.NbHFaites+New.NbHeures WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_Maladie` AFTER INSERT ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='Maladie' THEN BEGIN
    UPDATE personne SET personne.NbJMal = personne.NbJMal + 1 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_Maladie2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='Maladie' THEN BEGIN
    UPDATE personne SET personne.NbJMal = personne.NbJMal + 1 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_Repos` AFTER INSERT ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='Repos' THEN BEGIN
    UPDATE personne SET personne.RTTpris = personne.RTTpris + 1 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_Repos2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='Repos' THEN BEGIN
    UPDATE personne SET personne.RTTpris = personne.RTTpris + 1 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_CA` AFTER DELETE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='CA' THEN BEGIN
    UPDATE personne SET personne.CAapPris = personne.CAapPris - 1 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_CA2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='CA' THEN BEGIN
    UPDATE personne SET personne.CAapPris = personne.CAapPris - 1 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_CA_Avant_Janvier` AFTER DELETE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='CA avant Janvier' THEN BEGIN
    UPDATE personne SET personne.CAavPris = personne.CAavPris - 1 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_CA_Avant_Janvier2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='CA avant Janvier' THEN BEGIN
    UPDATE personne SET personne.CAavPris = personne.CAavPris - 1 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_Demi_CA` AFTER DELETE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='Demi CA' THEN BEGIN
    UPDATE personne SET personne.CAapPris = personne.CAapPris - 0.5 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_Demi_CA2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='Demi CA' THEN BEGIN
    UPDATE personne SET personne.CAapPris = personne.CAapPris - 0.5 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_Demi_CA_Avant_Janvier` AFTER DELETE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='Demi CA avant Janvier' THEN BEGIN
    UPDATE personne SET personne.CAavPris = personne.CAavPris - 0.5 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_Demi_CA_Avant_Janvier2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='Demi CA avant Janvier' THEN BEGIN
    UPDATE personne SET personne.CAavPris = personne.CAavPris - 0.5 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_Demi_Repos` AFTER DELETE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='Demi Repos' THEN BEGIN
    UPDATE personne SET personne.RTTpris = personne.RTTpris - 0.5 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_Demi_Repos2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='Demi Repos' THEN BEGIN
    UPDATE personne SET personne.RTTpris = personne.RTTpris - 0.5 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_Heures` AFTER DELETE ON `horaires` FOR EACH ROW BEGIN
  IF (Old.Etat = 'Travail' OR old.Etat='Maladie' OR old.Etat='Repos' OR old.Etat='Demi Repos') THEN BEGIN
    UPDATE personne SET personne.NbHFaites = personne.NbHFaites-Old.NbHeures WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_Heures2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF (Old.Etat = 'Travail' OR old.Etat='Maladie' OR old.Etat='Repos' OR old.Etat='Demi Repos') THEN BEGIN
    UPDATE personne SET personne.NbHFaites = personne.NbHFaites-Old.NbHeures WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_Maladie` AFTER DELETE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='Maladie' THEN BEGIN
    UPDATE personne SET personne.NbJMal = personne.NbJMal - 1 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_Maladie2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='Maladie' THEN BEGIN
    UPDATE personne SET personne.NbJMal = personne.NbJMal - 1 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_Repos` AFTER DELETE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='Repos' THEN BEGIN
    UPDATE personne SET personne.RTTpris = personne.RTTpris - 1 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_Repos2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='Repos' THEN BEGIN
    UPDATE personne SET personne.RTTpris = personne.RTTpris - 1 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `personne`
--

CREATE TABLE `personne` (
  `IDP` int(11) NOT NULL,
  `Prenom` varchar(20) CHARACTER SET utf8 NOT NULL,
  `Nom` varchar(20) CHARACTER SET utf8 NOT NULL,
  `NbHaFaire` double NOT NULL,
  `NbHFaites` double NOT NULL DEFAULT '0',
  `CAavPris` double NOT NULL DEFAULT '0',
  `CAavMax` double NOT NULL,
  `CAapPris` double NOT NULL DEFAULT '0',
  `CAapMax` double NOT NULL,
  `NbJMal` int(11) NOT NULL DEFAULT '0',
  `RTTpris` double NOT NULL DEFAULT '0',
  `HSupp` int(11) NOT NULL DEFAULT '0',
  `Contrat` varchar(20) COLLATE utf8_bin NOT NULL,
  `Matricule` varchar(20) COLLATE utf8_bin NOT NULL,
  `Type` varchar(20) COLLATE utf8_bin DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contenu de la table `personne`
--

INSERT INTO `personne` (`IDP`, `Prenom`, `Nom`, `NbHaFaire`, `NbHFaites`, `CAavPris`, `CAavMax`, `CAapPris`, `CAapMax`, `NbJMal`, `RTTpris`, `HSupp`, `Contrat`, `Matricule`, `Type`) VALUES
(123, '', 'Arcadia', 1010.5, 5.25, 0, 0, 0, 25, 0, 0, 0, 'Titulaire', 'DBSBFLQS?SDT5', 'Agent'),
(126, '', 'Meriem', 1018, 0, 0, 0, 0, 25, 0, 0, 0, 'Titulaire', 'DFNSD541DAZED', 'Agent'),
(125, '', 'Florence', 1486.75, 0, 0, 0, 0, 25, 0, 0, 0, 'Vaccataire', 'DFNSDLFNLS5DZ', 'Agent'),
(131, '', 'Soraya', 747, 0, 0, 0, 0, 25, 0, 0, 0, 'Titulaire', 'BFIDKFLSCNPDS', 'ASEM'),
(124, '', 'Badia', 1509, 0, 0, 0, 0, 25, 0, 0, 0, 'Vaccataire', 'DFDSFDSFDZD', 'Agent'),
(127, '', 'Mireille', 1600, 0, 0, 0, 0, 25, 0, 0, 0, 'Titulaire', '#?LFMQDS3D54', 'Agent'),
(128, '', 'Nathalie D', 1041.5, 0, 0, 0, 0, 25, 0, 0, 0, 'Titulaire', 'BFIDKFLSCNPDS', 'Agent'),
(129, '', 'Nathalie V', 1234.5, 0, 0, 0, 0, 25, 0, 0, 0, 'Titulaire', 'BFIDKFLSCNPDS', 'Agent'),
(130, '', 'Sandrine', 1425.25, 0, 0, 0, 0, 5, 0, 0, 0, 'Titulaire', 'BFIDKFLSCNPDS', 'Agent'),
(135, '', 'Françoise', 1500, 0, 0, 0, 0, 0, 0, 0, 0, 'Titulaire', '12151515151', 'ASEM'),
(136, '', 'Marylyne', 1500, 0, 0, 0, 0, 0, 0, 0, 0, 'Titulaire', '151565161', 'ASEM'),
(137, '', 'Odile', 1000, 0, 0, 0, 0, 0, 0, 0, 0, 'Titulaire', '165156165', 'ASEM'),
(138, '', 'Salima', 1600, 259.75, 0, 0, 28, 28, 0, 2, 0, 'Titulaire', '1561656', 'ASEM'),
(139, '', 'Attal', 1500, 20, 0, 0, 0, 0, 0, 0, 0, 'Titulaire', '165166156', 'ASEM'),
(140, '', 'Lubin', 1000, 0, 0, 0, 0, 0, 0, 0, 0, 'Titulaire', '155161616161', 'ASEM'),
(141, '', 'Mule', 1000, 0, 0, 0, 0, 0, 0, 0, 0, 'Titulaire', '15165161616', 'ASEM'),
(142, '', 'Armant', 1000, 1017, 0, 0, 25, 25, 1, 17, 0, 'Vaccataire', '1651565', 'ASEM'),
(143, '', 'Bonatto', 1200, 0, 0, 0, 0, 0, 0, 0, 0, 'Titulaire', '15161616516154', 'ASEM');

--
-- Déclencheurs `personne`
--
DELIMITER $$
CREATE TRIGGER `Suppression_personne` AFTER DELETE ON `personne` FOR EACH ROW delete from horaires where horaires.IDP=Old.IDP
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `site`
--

CREATE TABLE `site` (
  `IDL` int(11) NOT NULL,
  `NomLieu` varchar(30) CHARACTER SET utf8 NOT NULL,
  `Categorie` double NOT NULL DEFAULT '1',
  `Type` varchar(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `site`
--

INSERT INTO `site` (`IDL`, `NomLieu`, `Categorie`, `Type`) VALUES
(96, 'Mairie', 2, 'Agent'),
(95, 'Ancienne Mairie', 12, 'Agent'),
(91, 'Fontaine', 2, 'Agent'),
(93, 'Arts Plastiques', 2, 'Agent'),
(94, 'Salle A.Hugo', 1, 'Agent'),
(92, 'École Musique', 1, 'Agent'),
(97, 'Salle des Fêtes', 1, 'Agent'),
(98, 'CLP', 2, 'Agent'),
(99, 'Crèche', 1, 'ASEM'),
(102, 'VH - Classe', 14, 'ASEM'),
(107, 'JF - Classe', 14, 'ASEM'),
(110, 'G - Ménage', 12, 'ASEM'),
(119, 'G - PP', 2, 'ASEM'),
(126, 'JF - PP', 2, 'ASEM'),
(120, 'G - Classe', 14, 'ASEM'),
(121, 'G - Cantine', 14, 'ASEM'),
(122, 'JF - Cantine', 14, 'ASEM'),
(123, 'JF - Ménage', 12, 'ASEM'),
(124, 'VH - Cantine', 14, 'ASEM'),
(125, 'VH - Ménage', 12, 'ASEM'),
(127, 'VH - PP', 2, 'ASEM'),
(128, 'CLM', 2, 'Agent');

--
-- Déclencheurs `site`
--
DELIMITER $$
CREATE TRIGGER `Suppression_lieu` AFTER DELETE ON `site` FOR EACH ROW delete from horaires where horaires.IDL = Old.IDL
$$
DELIMITER ;

--
-- Index pour les tables exportées
--

--
-- Index pour la table `calendrier`
--
ALTER TABLE `calendrier`
  ADD PRIMARY KEY (`Date_jour`);

--
-- Index pour la table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`NumCat`);

--
-- Index pour la table `horaires`
--
ALTER TABLE `horaires`
  ADD PRIMARY KEY (`IDP`,`IDL`,`Date_jour`);

--
-- Index pour la table `personne`
--
ALTER TABLE `personne`
  ADD PRIMARY KEY (`IDP`),
  ADD UNIQUE KEY `IDP_2` (`IDP`),
  ADD KEY `IDP` (`IDP`),
  ADD KEY `IDP_3` (`IDP`);

--
-- Index pour la table `site`
--
ALTER TABLE `site`
  ADD PRIMARY KEY (`IDL`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE `categories`
  MODIFY `NumCat` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT pour la table `personne`
--
ALTER TABLE `personne`
  MODIFY `IDP` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=148;
--
-- AUTO_INCREMENT pour la table `site`
--
ALTER TABLE `site`
  MODIFY `IDL` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
