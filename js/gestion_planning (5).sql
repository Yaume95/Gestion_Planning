-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Client :  127.0.0.1
-- Généré le :  Lun 26 Juin 2017 à 11:14
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
-- Structure de la table `calendrier`
--

CREATE TABLE `calendrier` (
  `Date_jour` date NOT NULL,
  `Num_jour` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `calendrier`
--

INSERT INTO `calendrier` (`Date_jour`, `Num_jour`) VALUES
('2017-01-01', 3),
('2017-01-02', 4),
('2017-01-03', 5),
('2017-01-04', 6),
('2017-01-05', 7),
('2017-01-06', 1),
('2017-01-07', 2),
('2017-01-08', 3),
('2017-01-09', 4),
('2017-01-10', 5),
('2017-01-11', 6),
('2017-01-12', 7),
('2017-01-13', 1),
('2017-01-14', 2),
('2017-01-15', 3),
('2017-01-16', 4),
('2017-01-17', 5),
('2017-01-18', 6),
('2017-01-19', 7),
('2017-01-20', 1),
('2017-01-21', 2),
('2017-01-22', 3),
('2017-01-23', 4),
('2017-01-24', 5),
('2017-01-25', 6),
('2017-01-26', 7),
('2017-01-27', 1),
('2017-01-28', 2),
('2017-01-29', 3),
('2017-01-30', 4),
('2017-01-31', 5),
('2017-02-01', 6),
('2017-02-02', 7),
('2017-02-03', 1),
('2017-02-04', 2),
('2017-02-05', 3),
('2017-02-06', 4),
('2017-02-07', 5),
('2017-02-08', 6),
('2017-02-09', 7),
('2017-02-10', 1),
('2017-02-11', 2),
('2017-02-12', 3),
('2017-02-13', 4),
('2017-02-14', 5),
('2017-02-15', 6),
('2017-02-16', 7),
('2017-02-17', 1),
('2017-02-18', 2),
('2017-02-19', 3),
('2017-02-20', 4),
('2017-02-21', 5),
('2017-02-22', 6),
('2017-02-23', 7),
('2017-02-24', 1),
('2017-02-25', 2),
('2017-02-26', 3),
('2017-02-27', 4),
('2017-02-28', 5),
('2017-03-01', 6),
('2017-03-02', 7),
('2017-03-03', 1),
('2017-03-04', 2),
('2017-03-05', 3),
('2017-03-06', 4),
('2017-03-07', 5),
('2017-03-08', 6),
('2017-03-09', 7),
('2017-03-10', 1),
('2017-03-11', 2),
('2017-03-12', 3),
('2017-03-13', 4),
('2017-03-14', 5),
('2017-03-15', 6),
('2017-03-16', 7),
('2017-03-17', 1),
('2017-03-18', 2),
('2017-03-19', 3),
('2017-03-20', 4),
('2017-03-21', 5),
('2017-03-22', 6),
('2017-03-23', 7),
('2017-03-24', 1),
('2017-03-25', 2),
('2017-03-26', 3),
('2017-03-27', 4),
('2017-03-28', 5),
('2017-03-29', 6),
('2017-03-30', 7),
('2017-03-31', 1),
('2017-04-01', 2),
('2017-04-02', 3),
('2017-04-03', 4),
('2017-04-04', 5),
('2017-04-05', 6),
('2017-04-06', 7),
('2017-04-07', 1),
('2017-04-08', 2),
('2017-04-09', 3),
('2017-04-10', 4),
('2017-04-11', 5),
('2017-04-12', 6),
('2017-04-13', 7),
('2017-04-14', 1),
('2017-04-15', 2),
('2017-04-16', 3),
('2017-04-17', 4),
('2017-04-18', 5),
('2017-04-19', 6),
('2017-04-20', 7),
('2017-04-21', 1),
('2017-04-22', 2),
('2017-04-23', 3),
('2017-04-24', 4),
('2017-04-25', 5),
('2017-04-26', 6),
('2017-04-27', 7),
('2017-04-28', 1),
('2017-04-29', 2),
('2017-04-30', 3),
('2017-05-01', 4),
('2017-05-02', 5),
('2017-05-03', 6),
('2017-05-04', 7),
('2017-05-05', 1),
('2017-05-06', 2),
('2017-05-07', 3),
('2017-05-08', 4),
('2017-05-09', 5),
('2017-05-10', 6),
('2017-05-11', 7),
('2017-05-12', 1),
('2017-05-13', 2),
('2017-05-14', 3),
('2017-05-15', 4),
('2017-05-16', 5),
('2017-05-17', 6),
('2017-05-18', 7),
('2017-05-19', 1),
('2017-05-20', 2),
('2017-05-21', 3),
('2017-05-22', 4),
('2017-05-23', 5),
('2017-05-24', 6),
('2017-05-25', 7),
('2017-05-26', 1),
('2017-05-27', 2),
('2017-05-28', 3),
('2017-05-29', 4),
('2017-05-30', 5),
('2017-05-31', 6),
('2017-06-01', 7),
('2017-06-02', 1),
('2017-06-03', 2),
('2017-06-04', 3),
('2017-06-05', 4),
('2017-06-06', 5),
('2017-06-07', 6),
('2017-06-08', 7),
('2017-06-09', 1),
('2017-06-10', 2),
('2017-06-11', 3),
('2017-06-12', 4),
('2017-06-13', 5),
('2017-06-14', 6),
('2017-06-15', 7),
('2017-06-16', 1),
('2017-06-17', 2),
('2017-06-18', 3),
('2017-06-19', 4),
('2017-06-20', 5),
('2017-06-21', 6),
('2017-06-22', 7),
('2017-06-23', 1),
('2017-06-24', 2),
('2017-06-25', 3),
('2017-06-26', 4),
('2017-06-27', 5),
('2017-06-28', 6),
('2017-06-29', 7),
('2017-06-30', 1),
('2017-07-01', 2),
('2017-07-02', 3),
('2017-07-03', 4),
('2017-07-04', 5),
('2017-07-05', 6),
('2017-07-06', 7),
('2017-07-07', 1),
('2017-07-08', 2),
('2017-07-09', 3),
('2017-07-10', 4),
('2017-07-11', 5),
('2017-07-12', 6),
('2017-07-13', 7),
('2017-07-14', 1),
('2017-07-15', 2),
('2017-07-16', 3),
('2017-07-17', 4),
('2017-07-18', 5),
('2017-07-19', 6),
('2017-07-20', 7),
('2017-07-21', 1),
('2017-07-22', 2),
('2017-07-23', 3),
('2017-07-24', 4),
('2017-07-25', 5),
('2017-07-26', 6),
('2017-07-27', 7),
('2017-07-28', 1),
('2017-07-29', 2),
('2017-07-30', 3),
('2017-07-31', 4),
('2017-08-01', 5),
('2017-08-02', 6),
('2017-08-03', 7),
('2017-08-04', 1),
('2017-08-05', 2),
('2017-08-06', 3),
('2017-08-07', 4),
('2017-08-08', 5),
('2017-08-09', 6),
('2017-08-10', 7),
('2017-08-11', 1),
('2017-08-12', 2),
('2017-08-13', 3),
('2017-08-14', 4),
('2017-08-15', 5),
('2017-08-16', 6),
('2017-08-17', 7),
('2017-08-18', 1),
('2017-08-19', 2),
('2017-08-20', 3),
('2017-08-21', 4),
('2017-08-22', 5),
('2017-08-23', 6),
('2017-08-24', 7),
('2017-08-25', 1),
('2017-08-26', 2),
('2017-08-27', 3),
('2017-08-28', 4),
('2017-08-29', 5),
('2017-08-30', 6),
('2017-08-31', 7),
('2017-09-01', 1),
('2017-09-02', 2),
('2017-09-03', 3),
('2017-09-04', 4),
('2017-09-05', 5),
('2017-09-06', 6),
('2017-09-07', 7),
('2017-09-08', 1),
('2017-09-09', 2),
('2017-09-10', 3),
('2017-09-11', 4),
('2017-09-12', 5),
('2017-09-13', 6),
('2017-09-14', 7),
('2017-09-15', 1),
('2017-09-16', 2),
('2017-09-17', 3),
('2017-09-18', 4),
('2017-09-19', 5),
('2017-09-20', 6),
('2017-09-21', 7),
('2017-09-22', 1),
('2017-09-23', 2),
('2017-09-24', 3),
('2017-09-25', 4),
('2017-09-26', 5),
('2017-09-27', 6),
('2017-09-28', 7),
('2017-09-29', 1),
('2017-09-30', 2),
('2017-10-01', 3),
('2017-10-02', 4),
('2017-10-03', 5),
('2017-10-04', 6),
('2017-10-05', 7),
('2017-10-06', 1),
('2017-10-07', 2),
('2017-10-08', 3),
('2017-10-09', 4),
('2017-10-10', 5),
('2017-10-11', 6),
('2017-10-12', 7),
('2017-10-13', 1),
('2017-10-14', 2),
('2017-10-15', 3),
('2017-10-16', 4),
('2017-10-17', 5),
('2017-10-18', 6),
('2017-10-19', 7),
('2017-10-20', 1),
('2017-10-21', 2),
('2017-10-22', 3),
('2017-10-23', 4),
('2017-10-24', 5),
('2017-10-25', 6),
('2017-10-26', 7),
('2017-10-27', 1),
('2017-10-28', 2),
('2017-10-29', 3),
('2017-10-30', 4),
('2017-10-31', 5),
('2017-11-01', 6),
('2017-11-02', 7),
('2017-11-03', 1),
('2017-11-04', 2),
('2017-11-05', 3),
('2017-11-06', 4),
('2017-11-07', 5),
('2017-11-08', 6),
('2017-11-09', 7),
('2017-11-10', 1),
('2017-11-11', 2),
('2017-11-12', 3),
('2017-11-13', 4),
('2017-11-14', 5),
('2017-11-15', 6),
('2017-11-16', 7),
('2017-11-17', 1),
('2017-11-18', 2),
('2017-11-19', 3),
('2017-11-20', 4),
('2017-11-21', 5),
('2017-11-22', 6),
('2017-11-23', 7),
('2017-11-24', 1),
('2017-11-25', 2),
('2017-11-26', 3),
('2017-11-27', 4),
('2017-11-28', 5),
('2017-11-29', 6),
('2017-11-30', 7),
('2017-12-01', 1),
('2017-12-02', 2),
('2017-12-03', 3),
('2017-12-04', 4),
('2017-12-05', 5),
('2017-12-06', 6),
('2017-12-07', 7),
('2017-12-08', 1),
('2017-12-09', 2),
('2017-12-10', 3),
('2017-12-11', 4),
('2017-12-12', 5),
('2017-12-13', 6),
('2017-12-14', 7),
('2017-12-15', 1),
('2017-12-16', 2),
('2017-12-17', 3),
('2017-12-18', 4),
('2017-12-19', 5),
('2017-12-20', 6),
('2017-12-21', 7),
('2017-12-22', 1),
('2017-12-23', 2),
('2017-12-24', 3),
('2017-12-25', 4),
('2017-12-26', 5),
('2017-12-27', 6),
('2017-12-28', 7),
('2017-12-29', 1),
('2017-12-30', 2),
('2017-12-31', 3);

-- --------------------------------------------------------

--
-- Structure de la table `horaires`
--

CREATE TABLE `horaires` (
  `IDP` int(11) NOT NULL,
  `IDL` int(11) NOT NULL,
  `Date_jour` date NOT NULL,
  `NbHeures` double UNSIGNED NOT NULL,
  `Etat` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `horaires`
--

INSERT INTO `horaires` (`IDP`, `IDL`, `Date_jour`, `NbHeures`, `Etat`) VALUES
(3, 1, '2017-01-02', 5, 'Travail'),
(3, 3, '2017-01-06', 2.5, 'Travail'),
(3, 1, '2017-01-07', 6, 'Travail'),
(3, 11, '2017-01-06', 0.5, 'Travail'),
(3, 3, '2017-01-07', 2.5, 'Travail'),
(3, 1, '2017-01-09', 6.5, 'Travail'),
(3, 3, '2017-01-09', 2.5, 'Travail'),
(3, 1, '2017-01-17', 6, 'Travail'),
(3, 3, '2017-01-17', 3, 'Travail'),
(3, 1, '2017-01-13', 6, 'Travail'),
(3, 1, '2017-01-14', 6, 'Travail'),
(3, 3, '2017-01-14', 2.5, 'Travail'),
(3, 1, '2017-01-16', 6.5, 'Travail'),
(3, 3, '2017-01-16', 2.5, 'Travail'),
(3, 1, '2017-01-20', 6, 'Travail'),
(3, 3, '2017-01-20', 2.5, 'Travail'),
(3, 1, '2017-01-21', 6, 'Travail'),
(3, 3, '2017-01-21', 2.5, 'Travail'),
(3, 2, '2017-01-22', 6, 'Travail'),
(3, 1, '2017-01-23', 6.5, 'Travail'),
(3, 3, '2017-01-23', 2.5, 'Travail'),
(3, 1, '2017-01-24', 6, 'Travail'),
(3, 3, '2017-01-24', 3, 'Travail'),
(3, 1, '2017-01-27', 6, 'Travail'),
(3, 3, '2017-01-27', 2.5, 'Travail'),
(3, 1, '2017-01-28', 6, 'Travail'),
(3, 3, '2017-01-28', 2.5, 'Travail'),
(3, 1, '2017-01-30', 6.5, 'Travail'),
(3, 3, '2017-01-30', 2.5, 'Travail'),
(3, 1, '2017-01-31', 6, 'Travail'),
(3, 3, '2017-01-31', 3, 'Travail'),
(3, 1, '2017-02-03', 6, 'Travail'),
(3, 3, '2017-02-03', 2.5, 'Travail'),
(3, 1, '2017-02-04', 6, 'Travail'),
(3, 3, '2017-02-04', 2.5, 'Travail'),
(3, 2, '2017-02-05', 6.5, 'Travail'),
(3, 1, '2017-02-06', 6.5, 'Travail'),
(3, 3, '2017-02-06', 2.5, 'Travail'),
(3, 1, '2017-02-07', 6, 'Travail'),
(3, 3, '2017-02-07', 3, 'Travail'),
(3, 1, '2017-02-10', 6, 'Travail'),
(3, 3, '2017-02-10', 2.5, 'Travail'),
(3, 11, '2017-02-10', 1, 'Travail'),
(3, 1, '2017-02-11', 6, 'Travail'),
(3, 3, '2017-02-11', 2.5, 'Travail'),
(3, 11, '2017-02-11', 0.5, 'Travail'),
(3, 1, '2017-02-13', 6.5, 'Travail'),
(3, 3, '2017-02-13', 2.5, 'Travail'),
(3, 1, '2017-02-14', 6, 'Travail'),
(3, 3, '2017-02-14', 2.5, 'Travail'),
(3, 1, '2017-02-17', 0, 'Repos'),
(3, 1, '2017-02-18', 0, 'Repos'),
(3, 1, '2017-02-19', 0, 'Repos'),
(3, 1, '2017-02-20', 0, 'Repos'),
(3, 1, '2017-02-21', 0, 'Repos'),
(3, 3, '2017-02-24', 5.5, 'Travail'),
(3, 3, '2017-02-25', 7, 'Travail'),
(3, 3, '2017-02-26', 7.5, 'Travail'),
(3, 1, '2017-02-27', 0, 'Repos'),
(3, 1, '2017-02-28', 0, 'Repos'),
(3, 1, '2017-01-10', 6, 'Travail'),
(3, 3, '2017-01-10', 3, 'Travail'),
(3, 1, '2017-03-03', 6, 'Travail'),
(3, 3, '2017-03-03', 2.5, 'Travail'),
(3, 1, '2017-03-04', 6, 'Travail'),
(3, 3, '2017-03-04', 2.5, 'Travail'),
(3, 1, '2017-03-05', 0, 'Repos'),
(3, 1, '2017-03-06', 6.5, 'Travail'),
(3, 3, '2017-03-06', 2.5, 'Travail'),
(3, 1, '2017-03-07', 6, 'Travail'),
(3, 3, '2017-03-07', 3, 'Travail'),
(3, 1, '2017-03-10', 6, 'Travail'),
(3, 3, '2017-03-10', 2.5, 'Travail'),
(3, 1, '2017-03-11', 6, 'Travail'),
(3, 3, '2017-03-11', 2.5, 'Travail'),
(3, 2, '2017-03-12', 6, 'Travail'),
(3, 1, '2017-03-13', 6.5, 'Travail'),
(3, 3, '2017-03-13', 2.5, 'Travail'),
(3, 1, '2017-03-14', 6, 'Travail'),
(3, 3, '2017-03-14', 3, 'Travail'),
(3, 1, '2017-03-18', 6, 'Travail'),
(3, 3, '2017-03-18', 2.5, 'Travail'),
(3, 1, '2017-03-17', 6, 'Travail'),
(3, 3, '2017-03-17', 2.5, 'Travail'),
(3, 1, '2017-03-19', 0, 'Repos'),
(3, 1, '2017-03-20', 6.5, 'Travail'),
(3, 3, '2017-03-20', 2.5, 'Travail'),
(3, 1, '2017-03-21', 6, 'Travail'),
(3, 3, '2017-03-21', 3, 'Travail'),
(3, 1, '2017-03-24', 6, 'Travail'),
(3, 3, '2017-03-24', 2.5, 'Travail'),
(3, 1, '2017-03-25', 6.5, 'Travail'),
(3, 3, '2017-03-25', 2.5, 'Travail'),
(3, 2, '2017-03-26', 6, 'Travail'),
(3, 1, '2017-03-27', 6.5, 'Travail'),
(3, 3, '2017-03-27', 2.5, 'Travail'),
(3, 1, '2017-03-28', 6, 'Travail'),
(3, 3, '2017-03-28', 3, 'Travail'),
(3, 1, '2017-03-31', 6, 'Travail'),
(3, 3, '2017-03-31', 2.5, 'Travail'),
(3, 1, '2017-04-01', 6, 'Travail'),
(3, 3, '2017-04-01', 2.5, 'Travail'),
(3, 1, '2017-04-02', 6.5, 'Travail'),
(3, 3, '2017-04-02', 2.5, 'Travail'),
(3, 1, '2017-04-04', 6, 'Travail'),
(3, 3, '2017-04-04', 3, 'Travail'),
(3, 1, '2017-04-07', 6, 'Travail'),
(3, 3, '2017-04-07', 2.5, 'Travail'),
(3, 1, '2017-04-08', 6, 'Travail'),
(3, 3, '2017-04-08', 2.5, 'Travail'),
(3, 1, '2017-04-10', 6.5, 'Travail'),
(3, 3, '2017-04-10', 2.5, 'Travail'),
(3, 1, '2017-04-11', 6, 'Travail'),
(3, 3, '2017-04-11', 2.5, 'Travail'),
(3, 3, '2017-04-14', 7, 'Travail'),
(3, 3, '2017-04-15', 7, 'Travail'),
(3, 3, '2017-04-16', 7, 'Travail'),
(3, 1, '2017-04-17', 0, 'CA avant Avril'),
(3, 1, '2017-04-18', 0, 'CA avant Avril'),
(3, 1, '2017-04-22', 0, 'CA avant Avril'),
(3, 1, '2017-04-23', 0, 'CA avant Avril'),
(3, 1, '2017-04-24', 0, 'CA avant Avril'),
(3, 1, '2017-04-28', 6, 'Travail'),
(3, 3, '2017-04-28', 2.5, 'Travail'),
(3, 1, '2017-04-29', 6.5, 'Travail'),
(3, 3, '2017-04-29', 2.5, 'Travail'),
(3, 1, '2017-05-09', 6, 'Travail'),
(3, 3, '2017-05-09', 3, 'Travail'),
(3, 1, '2017-05-05', 6, 'Travail'),
(3, 3, '2017-05-05', 2.5, 'Travail'),
(3, 1, '2017-05-06', 6, 'Travail'),
(3, 3, '2017-05-06', 2.5, 'Travail'),
(3, 1, '2017-05-07', 0, 'Repos'),
(3, 1, '2017-05-12', 6, 'Travail'),
(3, 3, '2017-05-13', 2.5, 'Travail'),
(3, 3, '2017-05-12', 2.5, 'Travail'),
(3, 1, '2017-05-13', 6, 'Travail'),
(3, 2, '2017-05-14', 5, 'Travail'),
(3, 1, '2017-05-15', 6, 'Travail'),
(3, 3, '2017-05-15', 2.5, 'Travail'),
(3, 1, '2017-05-16', 6, 'Travail'),
(3, 3, '2017-05-16', 3.5, 'Travail'),
(3, 1, '2017-05-19', 6, 'Travail'),
(3, 3, '2017-05-19', 2.5, 'Travail'),
(3, 1, '2017-05-20', 6, 'Travail'),
(3, 3, '2017-05-20', 2.5, 'Travail'),
(3, 1, '2017-05-21', 0, 'Repos'),
(3, 1, '2017-05-22', 6.5, 'Travail'),
(3, 3, '2017-05-22', 2.5, 'Travail'),
(3, 1, '2017-05-23', 6.5, 'Travail'),
(3, 3, '2017-05-23', 3.5, 'Travail'),
(3, 1, '2017-05-26', 6, 'Travail'),
(3, 3, '2017-05-26', 2.5, 'Travail'),
(3, 1, '2017-05-27', 6, 'Travail'),
(3, 3, '2017-05-27', 2.5, 'Travail'),
(3, 1, '2017-05-30', 6, 'Travail'),
(3, 3, '2017-05-30', 3, 'Travail'),
(3, 1, '2017-05-28', 0, 'Repos'),
(3, 1, '2017-05-02', 6, 'Travail'),
(3, 3, '2017-05-02', 3, 'Travail'),
(3, 1, '2017-06-02', 6, 'Travail'),
(3, 1, '2017-06-03', 6, 'Travail'),
(3, 1, '2017-06-05', 6.5, 'Travail'),
(3, 1, '2017-06-06', 6, 'Travail'),
(3, 1, '2017-06-10', 6, 'Travail'),
(3, 1, '2017-06-11', 6, 'Travail'),
(3, 1, '2017-06-12', 6.5, 'Travail'),
(3, 1, '2017-06-13', 6, 'Travail'),
(3, 1, '2017-06-16', 6, 'Travail'),
(3, 1, '2017-06-17', 6, 'Travail'),
(3, 1, '2017-06-19', 6.5, 'Travail'),
(3, 1, '2017-06-20', 6, 'Travail'),
(3, 1, '2017-06-23', 6, 'Travail'),
(3, 1, '2017-06-26', 6.5, 'Travail'),
(3, 1, '2017-06-27', 6, 'Travail'),
(3, 1, '2017-06-30', 6, 'Travail'),
(3, 2, '2017-06-04', 5.5, 'Travail'),
(3, 3, '2017-06-02', 2.5, 'Travail'),
(3, 3, '2017-06-03', 2.5, 'Travail'),
(3, 3, '2017-06-05', 2.5, 'Travail'),
(3, 3, '2017-06-06', 3, 'Travail'),
(3, 3, '2017-06-10', 2.5, 'Travail'),
(3, 3, '2017-06-11', 2.5, 'Travail'),
(3, 3, '2017-06-12', 2.5, 'Travail'),
(3, 3, '2017-06-13', 2.5, 'Travail'),
(3, 3, '2017-06-16', 2.5, 'Travail'),
(3, 3, '2017-06-17', 2.5, 'Travail'),
(3, 3, '2017-06-19', 2.5, 'Travail'),
(3, 3, '2017-06-20', 3, 'Travail'),
(3, 3, '2017-06-23', 2.5, 'Travail'),
(3, 3, '2017-06-26', 2.5, 'Travail'),
(3, 3, '2017-06-27', 3, 'Travail'),
(3, 3, '2017-06-30', 2.5, 'Travail'),
(3, 1, '2017-06-18', 0, 'Repos'),
(3, 1, '2017-06-24', 0, 'Repos'),
(3, 1, '2017-06-25', 0, 'Repos'),
(3, 1, '2017-07-01', 6, 'Travail'),
(3, 1, '2017-07-03', 6.5, 'Travail'),
(3, 1, '2017-07-04', 6, 'Travail'),
(3, 3, '2017-07-01', 2.5, 'Travail'),
(3, 3, '2017-07-03', 2.5, 'Travail'),
(3, 3, '2017-07-04', 2.5, 'Travail'),
(3, 3, '2017-07-07', 7, 'Travail'),
(3, 3, '2017-07-08', 7, 'Travail'),
(3, 3, '2017-07-09', 7, 'Travail'),
(3, 3, '2017-07-10', 7, 'Travail'),
(3, 3, '2017-07-11', 7, 'Travail'),
(3, 3, '2017-07-02', 0, 'Repos'),
(3, 3, '2017-07-15', 0, 'CA'),
(3, 3, '2017-07-16', 0, 'CA'),
(3, 3, '2017-07-17', 0, 'CA'),
(3, 3, '2017-07-18', 0, 'CA'),
(3, 3, '2017-07-21', 0, 'CA'),
(3, 3, '2017-07-22', 0, 'CA'),
(3, 3, '2017-07-23', 0, 'CA'),
(3, 3, '2017-07-24', 0, 'CA'),
(3, 3, '2017-07-25', 0, 'CA'),
(3, 3, '2017-07-28', 0, 'CA'),
(3, 3, '2017-07-29', 0, 'CA'),
(3, 3, '2017-07-30', 0, 'CA'),
(3, 3, '2017-07-31', 0, 'CA'),
(3, 2, '2017-08-11', 5, 'Travail'),
(3, 2, '2017-08-13', 5, 'Travail'),
(3, 2, '2017-08-18', 5, 'Travail'),
(3, 2, '2017-08-20', 5, 'Travail'),
(3, 2, '2017-08-22', 5, 'Travail'),
(3, 2, '2017-08-12', 3, 'Travail'),
(3, 2, '2017-08-25', 7, 'Travail'),
(3, 2, '2017-08-26', 7, 'Travail'),
(3, 2, '2017-08-27', 7, 'Travail'),
(3, 2, '2017-08-28', 7, 'Travail'),
(3, 2, '2017-08-29', 7, 'Travail'),
(3, 3, '2017-08-14', 7, 'Travail'),
(3, 3, '2017-08-19', 7, 'Travail'),
(3, 3, '2017-08-21', 7, 'Travail'),
(3, 3, '2017-08-12', 4, 'Travail'),
(3, 1, '2017-08-01', 0, 'CA'),
(3, 1, '2017-08-04', 0, 'CA'),
(3, 1, '2017-08-05', 0, 'CA'),
(3, 1, '2017-08-06', 0, 'CA'),
(3, 1, '2017-08-07', 0, 'CA'),
(3, 1, '2017-08-08', 0, 'CA'),
(3, 1, '2017-09-03', 6.5, 'Travail'),
(3, 1, '2017-09-05', 6.5, 'Travail'),
(3, 1, '2017-09-06', 6.5, 'Travail'),
(3, 1, '2017-09-09', 6.5, 'Travail'),
(3, 1, '2017-09-10', 6.5, 'Travail'),
(3, 1, '2017-09-12', 6.5, 'Travail'),
(3, 1, '2017-09-13', 6.5, 'Travail'),
(3, 1, '2017-09-16', 6.5, 'Travail'),
(3, 1, '2017-09-17', 6.5, 'Travail'),
(3, 1, '2017-09-19', 6.5, 'Travail'),
(3, 1, '2017-09-20', 6.5, 'Travail'),
(3, 1, '2017-09-23', 6.5, 'Travail'),
(3, 1, '2017-09-24', 6.5, 'Travail'),
(3, 1, '2017-09-26', 6.5, 'Travail'),
(3, 1, '2017-09-27', 6.5, 'Travail'),
(3, 1, '2017-09-30', 6.5, 'Travail'),
(3, 2, '2017-09-04', 6.25, 'Travail'),
(3, 2, '2017-09-18', 6.25, 'Travail'),
(3, 2, '2017-09-02', 6, 'Travail'),
(3, 3, '2017-09-03', 2.5, 'Travail'),
(3, 3, '2017-09-05', 2.5, 'Travail'),
(3, 3, '2017-09-09', 2.5, 'Travail'),
(3, 3, '2017-09-10', 2.5, 'Travail'),
(3, 3, '2017-09-12', 2.5, 'Travail'),
(3, 3, '2017-09-16', 2.5, 'Travail'),
(3, 3, '2017-09-17', 2.5, 'Travail'),
(3, 3, '2017-09-19', 2.5, 'Travail'),
(3, 3, '2017-09-23', 2.5, 'Travail'),
(3, 3, '2017-09-24', 2.5, 'Travail'),
(3, 3, '2017-09-26', 2.5, 'Travail'),
(3, 3, '2017-09-27', 2.5, 'Travail'),
(3, 3, '2017-09-30', 2.5, 'Travail'),
(3, 3, '2017-09-02', 1, 'Travail'),
(3, 3, '2017-09-06', 3.5, 'Travail'),
(3, 3, '2017-09-13', 3.5, 'Travail'),
(3, 3, '2017-09-20', 3.5, 'Travail'),
(3, 1, '2017-09-11', 0, 'Repos'),
(3, 1, '2017-09-25', 0, 'Repos'),
(3, 1, '2017-10-01', 6.5, 'Travail'),
(3, 1, '2017-10-03', 6.5, 'Travail'),
(3, 1, '2017-10-04', 6.5, 'Travail'),
(3, 1, '2017-10-07', 6.5, 'Travail'),
(3, 1, '2017-10-08', 6.5, 'Travail'),
(3, 1, '2017-10-10', 6.5, 'Travail'),
(3, 1, '2017-10-11', 6.5, 'Travail'),
(3, 1, '2017-10-14', 6.5, 'Travail'),
(3, 1, '2017-10-15', 6.5, 'Travail'),
(3, 1, '2017-10-17', 6.5, 'Travail'),
(3, 1, '2017-10-18', 6, 'Travail'),
(3, 2, '2017-10-09', 6, 'Travail'),
(3, 3, '2017-10-01', 2.5, 'Travail'),
(3, 3, '2017-10-03', 2.5, 'Travail'),
(3, 3, '2017-10-07', 2.5, 'Travail'),
(3, 3, '2017-10-08', 2.5, 'Travail'),
(3, 3, '2017-10-10', 2.5, 'Travail'),
(3, 3, '2017-10-14', 2.5, 'Travail'),
(3, 3, '2017-10-15', 2.5, 'Travail'),
(3, 3, '2017-10-17', 2.5, 'Travail'),
(3, 3, '2017-10-18', 2.5, 'Travail'),
(3, 3, '2017-10-11', 3, 'Travail'),
(3, 3, '2017-10-21', 7, 'Travail'),
(3, 3, '2017-10-22', 7, 'Travail'),
(3, 3, '2017-10-23', 7, 'Travail'),
(3, 1, '2017-10-02', 0, 'Repos'),
(3, 1, '2017-10-16', 0, 'Repos'),
(3, 1, '2017-10-24', 0, 'Repos'),
(3, 1, '2017-10-25', 0, 'Repos'),
(3, 1, '2017-10-28', 0, 'Repos'),
(3, 1, '2017-10-29', 0, 'Repos'),
(3, 1, '2017-10-30', 0, 'Repos'),
(3, 1, '2017-10-31', 0, 'Repos'),
(3, 3, '2017-10-04', 3.5, 'Travail'),
(3, 1, '2017-11-04', 6, 'Travail'),
(3, 1, '2017-11-05', 6, 'Travail'),
(3, 1, '2017-11-08', 6, 'Travail'),
(3, 1, '2017-11-12', 6, 'Travail'),
(3, 11, '2017-09-25', 0.5, 'Travail'),
(3, 1, '2017-11-15', 6, 'Travail'),
(3, 1, '2017-11-18', 6, 'Travail'),
(3, 1, '2017-11-19', 6, 'Travail'),
(3, 1, '2017-11-22', 6, 'Travail'),
(3, 1, '2017-11-25', 6, 'Travail'),
(3, 1, '2017-11-26', 6, 'Travail'),
(3, 1, '2017-11-07', 6.5, 'Travail'),
(3, 1, '2017-11-14', 6.5, 'Travail'),
(3, 1, '2017-11-21', 6.5, 'Travail'),
(3, 1, '2017-11-28', 6.5, 'Travail'),
(3, 2, '2017-11-06', 6, 'Travail'),
(3, 3, '2017-11-04', 2.5, 'Travail'),
(3, 3, '2017-11-05', 2.5, 'Travail'),
(3, 3, '2017-11-07', 2.5, 'Travail'),
(3, 3, '2017-11-12', 2.5, 'Travail'),
(3, 3, '2017-11-14', 2.5, 'Travail'),
(3, 3, '2017-11-18', 2.5, 'Travail'),
(3, 3, '2017-11-19', 2.5, 'Travail'),
(3, 3, '2017-11-21', 2.5, 'Travail'),
(3, 3, '2017-11-22', 2.5, 'Travail'),
(3, 3, '2017-11-25', 2.5, 'Travail'),
(3, 3, '2017-11-26', 2.5, 'Travail'),
(3, 3, '2017-11-08', 3, 'Travail'),
(3, 3, '2017-11-15', 3, 'Travail'),
(3, 3, '2017-11-28', 1.5, 'Travail'),
(3, 11, '2017-11-19', 1, 'Travail'),
(3, 11, '2017-11-28', 1, 'Travail'),
(3, 11, '2017-11-27', 5, 'Travail'),
(3, 1, '2017-11-13', 0, 'Repos'),
(3, 1, '2017-11-20', 0, 'Repos'),
(3, 1, '2017-11-29', 0, 'Maladie'),
(3, 11, '2017-10-16', 1.5, 'Travail'),
(3, 1, '2017-11-30', 0, 'Maladie'),
(3, 1, '2017-12-01', 0, 'Maladie'),
(3, 1, '2017-12-02', 0, 'Maladie'),
(3, 1, '2017-12-03', 0, 'Maladie'),
(3, 1, '2017-12-04', 0, 'Maladie'),
(3, 1, '2017-12-05', 0, 'Maladie'),
(3, 1, '2017-12-06', 0, 'Maladie'),
(3, 1, '2017-12-07', 0, 'Maladie'),
(3, 1, '2017-12-08', 0, 'Maladie'),
(3, 1, '2017-12-09', 0, 'Maladie'),
(3, 1, '2017-12-10', 0, 'Maladie'),
(3, 1, '2017-12-11', 0, 'Maladie'),
(3, 1, '2017-12-12', 0, 'Maladie'),
(3, 1, '2017-12-13', 0, 'Maladie'),
(3, 1, '2017-12-14', 0, 'Maladie'),
(3, 1, '2017-12-15', 0, 'Maladie'),
(3, 1, '2017-12-16', 6, 'Travail'),
(3, 1, '2017-12-17', 6, 'Travail'),
(3, 1, '2017-12-20', 6, 'Travail'),
(3, 1, '2017-12-19', 6.5, 'Travail'),
(3, 3, '2017-12-16', 2.5, 'Travail'),
(3, 3, '2017-12-17', 2.5, 'Travail'),
(3, 3, '2017-12-19', 2.5, 'Travail'),
(3, 3, '2017-12-20', 2.5, 'Travail'),
(3, 3, '2017-12-23', 7, 'Travail'),
(3, 3, '2017-12-24', 7, 'Travail'),
(3, 3, '2017-12-26', 7, 'Travail'),
(3, 3, '2017-12-27', 7, 'Travail'),
(3, 3, '2017-12-30', 7, 'Travail'),
(3, 3, '2017-12-31', 7.5, 'Travail'),
(3, 2, '2017-12-18', 6, 'Travail'),
(3, 11, '2017-12-16', 0.5, 'Travail'),
(3, 1, '2017-04-25', 0, 'CA avant Avril'),
(3, 2, '2017-01-01', 5, 'Travail'),
(3, 1, '2017-01-06', 0, 'Repos'),
(3, 1, '2017-01-29', 0, 'Repos'),
(3, 1, '2017-01-08', 0, 'Repos'),
(3, 1, '2017-01-15', 0, 'Repos'),
(3, 2, '2017-08-09', 0, 'Maladie');

--
-- Déclencheurs `horaires`
--
DELIMITER $$
CREATE TRIGGER `Ajout_CA` AFTER INSERT ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='CA' THEN BEGIN
  	UPDATE personne SET personne.CAapPris = personne.CAapPris + 1 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_CA2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='CA' THEN BEGIN
  	UPDATE personne SET personne.CAapPris = personne.CAapPris + 1 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_CA_Avant_Avril` AFTER INSERT ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='CA avant Avril' THEN BEGIN
  	UPDATE personne SET personne.CAavPris = personne.CAavPris + 1 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_CA_Avant_Avril2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='CA avant Avril' THEN BEGIN
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
CREATE TRIGGER `Ajout_Demi_CA_Avant_Avril` AFTER INSERT ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='Demi CA avant Avril' THEN BEGIN
  	UPDATE personne SET personne.CAavPris = personne.CAavPris + 0.5 WHERE personne.IDP = New.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Ajout_Demi_CA_Avant_Avril2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF New.Etat='Demi CA avant Avril' THEN BEGIN
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
CREATE TRIGGER `Suppression_CA_Avant_Avril` AFTER DELETE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='CA avant Avril' THEN BEGIN
  	UPDATE personne SET personne.CAavPris = personne.CAavPris - 1 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_CA_Avant_Avril2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='CA avant Avril' THEN BEGIN
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
CREATE TRIGGER `Suppression_Demi_CA_Avant_Avril` AFTER DELETE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='Demi CA avant Avril' THEN BEGIN
  	UPDATE personne SET personne.CAavPris = personne.CAavPris - 0.5 WHERE personne.IDP = Old.IDP;
  END; END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Suppression_Demi_CA_Avant_Avril2` AFTER UPDATE ON `horaires` FOR EACH ROW BEGIN
  IF Old.Etat='Demi CA avant Avril' THEN BEGIN
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
  `Nom` varchar(20) CHARACTER SET utf8 NOT NULL,
  `NbHaFaire` double NOT NULL,
  `NbHFaites` double NOT NULL DEFAULT '0',
  `CAavPris` double NOT NULL DEFAULT '0',
  `CAavMax` double NOT NULL,
  `CAapPris` double NOT NULL DEFAULT '0',
  `CAapMax` double NOT NULL,
  `NbJMal` int(11) NOT NULL DEFAULT '0',
  `RTTpris` double NOT NULL DEFAULT '0',
  `HSupp` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Contenu de la table `personne`
--

INSERT INTO `personne` (`IDP`, `Nom`, `NbHaFaire`, `NbHFaites`, `CAavPris`, `CAavMax`, `CAapPris`, `CAapMax`, `NbJMal`, `RTTpris`, `HSupp`) VALUES
(1, 'Renard', 1587.75, 0, 0, 6, 0, 25, 0, 0, 0),
(2, 'Bagnol', 1150, 0, 0, 6, 0, 25, 0, 0, 0),
(3, 'Lozach', 1586, 1450, 6, 6, 19, 25, 18, 32, 0),
(4, 'Custos', 1587, 0, 0, 6, 0, 25, 0, 0, 0),
(5, 'Caranton', 1447, 0, 0, 6, 0, 25, 0, 0, 0),
(7, 'Decourty', 1500, 0, 0, 6, 0, 25, 0, 0, 0),
(8, 'Polsinelli', 1750, 0, 0, 6, 0, 25, 0, 0, 0),
(19, 'Attal', 1480, 0, 0, 6, 0, 25, 0, 0, 0),
(23, 'Ibrahim', 1750, 0, 0, 6, 0, 25, 0, 0, 0);

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
  `NomLieu` varchar(30) CHARACTER SET utf8 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `site`
--

INSERT INTO `site` (`IDL`, `NomLieu`) VALUES
(1, 'Cantine Scolaire'),
(2, 'Cantine Centre Loisirs'),
(3, 'Ménage Classe'),
(4, 'École de Musique'),
(6, 'Traversé'),
(8, 'Ménage CLM'),
(9, 'Ménage CLP'),
(11, 'Divers');

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
-- AUTO_INCREMENT pour la table `personne`
--
ALTER TABLE `personne`
  MODIFY `IDP` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=122;
--
-- AUTO_INCREMENT pour la table `site`
--
ALTER TABLE `site`
  MODIFY `IDL` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
