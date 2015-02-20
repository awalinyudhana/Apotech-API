/*
SQLyog Ultimate v11.11 (64 bit)
MySQL - 5.5.37-0ubuntu0.13.10.1 : Database - apotech
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `medicine` */

DROP TABLE IF EXISTS `medicine`;

CREATE TABLE `medicine` (
  `id_medicine` int(11) NOT NULL AUTO_INCREMENT,
  `medicine_name` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id_medicine`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Table structure for table `medicine_detail` */

DROP TABLE IF EXISTS `medicine_detail`;

CREATE TABLE `medicine_detail` (
  `id_medicine_detail` int(11) NOT NULL AUTO_INCREMENT,
  `id_receipt_detail` int(11) DEFAULT NULL,
  `medicine_name` varchar(32) DEFAULT NULL,
  `type` enum('tub') DEFAULT NULL,
  `dose` varchar(8) DEFAULT NULL,
  `note` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id_medicine_detail`),
  KEY `id_receipt_detail` (`id_receipt_detail`),
  CONSTRAINT `medicine_detail_ibfk_1` FOREIGN KEY (`id_receipt_detail`) REFERENCES `receipt_detail` (`id_receipt_detail`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `office` */

DROP TABLE IF EXISTS `office`;

CREATE TABLE `office` (
  `id_office` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) DEFAULT NULL,
  `sip` varchar(32) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL,
  `address` varchar(64) DEFAULT NULL,
  `city` varchar(32) DEFAULT NULL,
  `state` varchar(32) DEFAULT NULL,
  `country` varchar(32) DEFAULT NULL,
  `no_telp` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id_office`),
  UNIQUE KEY `sip` (`sip`),
  KEY `id_user` (`id_user`),
  CONSTRAINT `office_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Table structure for table `pharmacy` */

DROP TABLE IF EXISTS `pharmacy`;

CREATE TABLE `pharmacy` (
  `id_pharmacy` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `address` varchar(64) DEFAULT NULL,
  `city` varchar(32) DEFAULT NULL,
  `state` varchar(32) DEFAULT NULL,
  `country` varchar(32) DEFAULT NULL,
  `no_telp` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id_pharmacy`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Table structure for table `receipt` */

DROP TABLE IF EXISTS `receipt`;

CREATE TABLE `receipt` (
  `id_receipt` int(11) NOT NULL AUTO_INCREMENT,
  `code_receipt` varchar(16) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `id_office` int(11) DEFAULT NULL,
  `id_pharmacy` int(11) DEFAULT NULL,
  `patient_name` varchar(64) DEFAULT NULL,
  `diagnosis` text,
  PRIMARY KEY (`id_receipt`),
  UNIQUE KEY `kode_receipt` (`code_receipt`),
  KEY `id_office` (`id_office`),
  KEY `id_pharmacy` (`id_pharmacy`),
  CONSTRAINT `receipt_ibfk_1` FOREIGN KEY (`id_office`) REFERENCES `office` (`id_office`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `receipt_ibfk_2` FOREIGN KEY (`id_pharmacy`) REFERENCES `pharmacy` (`id_pharmacy`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

/*Table structure for table `receipt_detail` */

DROP TABLE IF EXISTS `receipt_detail`;

CREATE TABLE `receipt_detail` (
  `id_receipt_detail` int(11) NOT NULL AUTO_INCREMENT,
  `id_receipt` int(11) DEFAULT NULL,
  `type` enum('single','mix','other') DEFAULT NULL,
  `dose` varchar(8) DEFAULT NULL,
  `note` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id_receipt_detail`),
  KEY `id_receipt` (`id_receipt`),
  CONSTRAINT `receipt_detail_ibfk_1` FOREIGN KEY (`id_receipt`) REFERENCES `receipt` (`id_receipt`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `specialist` */

DROP TABLE IF EXISTS `specialist`;

CREATE TABLE `specialist` (
  `id_specialist` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `parent` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_specialist`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id_user` int(11) NOT NULL AUTO_INCREMENT,
  `id_specialist` int(11) DEFAULT NULL,
  `username` varchar(32) DEFAULT NULL,
  `first_name` varchar(16) DEFAULT NULL,
  `last_name` varchar(32) DEFAULT NULL,
  `address` varchar(64) DEFAULT NULL,
  `city` varchar(32) DEFAULT NULL,
  `state` varchar(32) DEFAULT NULL,
  `country` varchar(32) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `no_hape` varchar(16) DEFAULT NULL,
  `no_telp` varchar(16) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `plain_password` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id_user`),
  KEY `id_specialist` (`id_specialist`),
  KEY `email` (`email`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`id_specialist`) REFERENCES `specialist` (`id_specialist`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/* Trigger structure for table `medicine_detail` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `medicine_recap_insert` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `medicine_recap_insert` AFTER INSERT ON `medicine_detail` FOR EACH ROW BEGIN
  DECLARE m_count INTEGER ;
  SELECT 
    COUNT(*) INTO m_count 
  FROM
    medicine 
  WHERE medicine_name = NEW.medicine_name ;
  IF m_count = 0 
  THEN 
  INSERT INTO medicine (medicine_name) 
  VALUES
    (NEW.medicine_name) ;
  END IF ;
END */$$


DELIMITER ;

/* Trigger structure for table `medicine_detail` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `medicine_recap_update` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `medicine_recap_update` AFTER UPDATE ON `medicine_detail` FOR EACH ROW BEGIN
    DECLARE m_count INTEGER ;
SELECT 
  COUNT(*) INTO m_count 
FROM
  medicine 
WHERE medicine_name = NEW.medicine_name ;
IF m_count = 0 
THEN 
INSERT INTO medicine (medicine_name) 
VALUES
  (NEW.medicine_name) ;
END IF ;
END */$$


DELIMITER ;

/* Trigger structure for table `receipt` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `generate_receipt_code` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `generate_receipt_code` BEFORE INSERT ON `receipt` FOR EACH ROW BEGIN
  DECLARE code_receipt VARCHAR (16) ;
  declare last_id int ;
  select 
    id_receipt into last_id 
  from
    receipt 
  ORDER BY id_receipt DESC 
  limit 1 ;
  if last_id > 0 
  then set last_id = last_id + 1 ;
  else SET last_id = 1 ;
  end if ;
  SET code_receipt = generate_code (
    last_id,
    NEW.id_office,
    NEW.id_pharmacy,
    NEW.patient_name
  ) ;
  SET NEW.code_receipt = code_receipt ;
END */$$


DELIMITER ;

/* Function  structure for function  `generate_code` */

/*!50003 DROP FUNCTION IF EXISTS `generate_code` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` FUNCTION `generate_code`(
  id_receipt INT,
  id_office INT,
  id_pharmacy INT,
  patient_name VARCHAR (32)
) RETURNS varchar(16) CHARSET latin1
BEGIN
  DECLARE code_receipt VARCHAR (12) ;
  DECLARE city_office VARCHAR (32) ;
  SELECT 
    LEFT(city, 2) INTO city_office 
  FROM
    office 
  WHERE id_office = id_office ;
  SELECT 
    CONCAT(
      city_office,
      LEFT(patient_name, 2),
      id_pharmacy,
      id_receipt
    ) INTO code_receipt ;
  RETURN UCASE(code_receipt );
END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
