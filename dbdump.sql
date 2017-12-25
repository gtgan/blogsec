-- MySQL dump 10.13  Distrib 5.7.16, for osx10.11 (x86_64)
--
-- Host: localhost    Database: blogsec
-- ------------------------------------------------------
-- Server version	5.7.16

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `blogsec`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `blogsec` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `blogsec`;

--
-- Table structure for table `AuthCodes`
--

DROP TABLE IF EXISTS `AuthCodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AuthCodes` (
  `email` varchar(255) NOT NULL,
  `code_hash` char(128) NOT NULL,
  `code_salt` char(128) NOT NULL,
  PRIMARY KEY (`email`),
  CONSTRAINT `authcodes_ibfk_1` FOREIGN KEY (`email`) REFERENCES `Users` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AuthCodes`
--

LOCK TABLES `AuthCodes` WRITE;
/*!40000 ALTER TABLE `AuthCodes` DISABLE KEYS */;
/*!40000 ALTER TABLE `AuthCodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Posts`
--

DROP TABLE IF EXISTS `Posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Posts` (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `content` text,
  `title` varchar(255) NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`post_id`),
  KEY `email` (`email`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`email`) REFERENCES `Users` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Posts`
--

LOCK TABLES `Posts` WRITE;
/*!40000 ALTER TABLE `Posts` DISABLE KEYS */;
INSERT INTO `Posts` VALUES (1,'gregory.gan@sjsu.edu','**First post!** Markup is escaped, so <script>alert(\"This shouldn\'t work!\");</script>','Testing','2017-12-19 19:01:57','2017-12-12 19:01:57'),(2,'gregory.gan@sjsu.edu','I accidentally deleted everything except my database, so lets see if anything works.','Another test post','2017-12-19 19:01:57','2017-12-12 19:01:57'),(3,'tony@starkenterprises.com','I\'m making sure this works before I do anything important with it.','Hello World','2017-12-19 19:01:57','2017-12-12 19:01:57'),(4,'ckent@dailyplanet.com','Superheroes need secret identities to separate their personal and work lives. When a secret identity is revealed, justice is hindered and innocents are put at risk. Stop trying to uncover Superman\'s secret identity!','Stop Investigating Superman!','2017-12-19 19:01:57','2017-12-12 19:01:57'),(10,'gregory.gan@sjsu.edu',''BlogSec is an information security blog project. It implements salted password hashing with SHA512, and escapes markup and SQL input to prevent injection attacks. BlogSec submits information using the POST method. Ideally, BlogSec should be used with SSL; the server should only accept incoming traffic on port 443.\n\nWhile BlogSec is meant to demonstrate security, it also shows how easy a page can be made to hack; [hack.jsp](./hack.jsp) is a page which submits information using the GET method and does not validate input. [Here](./sample_hack.html) is a snapshot of hack.jsp which gives examples of some of its vulnerabilities.\n\nYou can get the source code from [the Github repository](https://github.com/gtgan/blogsec) and load the database from dbdump.sql.\n\n##Authentication\n\nWhen you sign up for a BlogSec account, you will need to enter an email address and password. The password must contain at least eight characters and you need to be able to access the email address to verify your account. The email address will also serve as your unique identifier. You may input your first and last name as well.\n\nAfter you sign up for a BlogSec account, you should receive an email with a verification code. This code consists of sixteen case-sensitive alphanumeric characters and is meant to prevent someone from creating and using an account under your email address. Verify your account to write posts.\n\nYour password is salted and stored as a SHA512 hash; when you log in, the system will find the account associated with your email address, add the included salt to the password you supply, and check the hash with the stored value to authenticate you.\n\nBlogSec does not currently support password resets, so don\'t share your password with anyone, and definitely don\'t forget it.\n\n##Preventing code injection\n\nBlogSec runs on Apache Tomcat using Java Server Pages (JSP). It handles user input using the JSP Standard Tag Library (JSTL) and MySQL Connector/J, which are not inherently secure. To prevent code contained in user input from executing, output must be done through the <c:out> tag, escaping markup, and database queries occur via <sql:transaction> (to ensure atomicity), <sql:query>, and <sql:update>.\n\nThe hack.jsp page does not use any of these precautions; however, to prevent tampering, it uses a MySQL user which only has write privileges for the table associated with hack.jsp.','Behind the scene tour','2017-12-13 08:24:12','2017-12-12 19:01:57');
/*!40000 ALTER TABLE `Posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Replies`
--

DROP TABLE IF EXISTS `Replies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Replies` (
  `reply_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `post_id` bigint(20) NOT NULL,
  `content` text,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reply_id`),
  KEY `email` (`email`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `replies_ibfk_1` FOREIGN KEY (`email`) REFERENCES `Users` (`email`),
  CONSTRAINT `replies_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `Posts` (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Replies`
--

LOCK TABLES `Replies` WRITE;
/*!40000 ALTER TABLE `Replies` DISABLE KEYS */;
INSERT INTO `Replies` VALUES (1,'gregory.gan@sjsu.edu',1,'Markdown will be added eventually.','2017-12-19 03:35:54','2017-12-17 00:07:03'),(2,'gregory.gan@sjsu.edu',2,'Stuff','2017-12-19 03:35:54','2017-12-19 03:14:21'),(3,'gregory.gan@sjsu.edu',2,'This is a reply.','2017-12-19 03:35:54','2017-12-19 03:14:30'),(4,'gregory.gan@sjsu.edu',2,'Okay, I am satisfied that this \"reply\" feature works.','2017-12-19 03:35:54','2017-12-19 03:15:02'),(5,'gregory.gan@sjsu.edu',1,'It works here too!','2017-12-19 03:35:54','2017-12-19 03:15:51'),(6,'gregory.gan@sjsu.edu',3,'It seems to work.','2017-12-19 03:35:54','2017-12-19 03:24:01'),(7,'ckent@dailyplanet.com',1,'Not Markdown, though.','2017-12-19 03:35:54','2017-12-19 03:27:08'),(8,'tony@starkenterprises.com',4,'I disclosed my secret identity.','2017-12-19 03:40:17','2017-12-19 03:40:17'),(9,'gregory.gan@sjsu.edu',4,'Yes, and look how that turned out.','2017-12-19 03:40:57','2017-12-19 03:40:57'),(10,'trudy@hax.com',4,'I thought it went quite well, actually.','2017-12-19 03:42:27','2017-12-19 03:42:27'),(11,'tony@starkenterprises.com',4,'See?','2017-12-19 03:43:04','2017-12-19 03:43:04'),(12,'bruce@wayneterprises.org',4,'Nobody cares what Trudy thinks.','2017-12-19 03:48:55','2017-12-19 03:48:55'),(13,'tony@starkenterprises.com',4,'Isn\'t that a bit harsh?','2017-12-19 03:49:45','2017-12-19 03:49:45'),(14,'gregory.gan@sjsu.edu',4,'All right, you lot.  Break it up.','2017-12-19 03:50:46','2017-12-19 03:50:46'),(17,'gregory.gan@sjsu.edu',10,'I will get Markdown working eventually.','2017-12-19 18:59:24','2017-12-19 18:59:24');
/*!40000 ALTER TABLE `Replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Users` (
  `email` varchar(255) NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `pwd_hash` char(128) NOT NULL,
  `salt` char(128) NOT NULL,
  `bio` text,
  `privilege` enum('none','user','admin') NOT NULL DEFAULT 'none',
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES ('bruce@wayneterprises.org','Bruce','Wayne','cd6625fab2b43dd4e0f0ee81c5a88d545a2c45a2270b8f81cf9305fd2091b35354329361da10b1a38b0ee988516371cfa0763deb25a6e00f614f3df48d8135a4','Æ\0¤«–¹€å:’Ñ7ë¾†¬šC]Ã\'Mw&1>î}<p2»ï¹9\nˆê\rÙø¶»Ë9«ÜÝ’æ>¿ãº®NË~eRí!.éhÁ(š…qkä[\\®àºZX’ã}&Ó02J=Œß ›,ÚÀs&	ñ¹À8ž7\ZwA·',NULL,'user'),('ckent@dailyplanet.com','Clark','Kent','3aae7e1004b1b9731fe975b09742fee853dc8168d31b75c6e79064aeeff95b8d053eae89a17c1af3f37cbcabab37136117e7c88d0cf54af26919ad5d6d74d188','Œ©ÐÕF­†oŒ:(ôŠOÐVlGc/ã‹ìÍoÆž*#Œÿ\'©Ý„ÂL€å¹†“b¾–W:ÒšùR#¯|ÊÁµ¤‰+€H_÷Ä‚MÓe~tG™ò?¼êŸu¾Ã+«ã}AVvßcáSDw{>#Ò>\rw;„ô9',NULL,'user'),('gregory.gan@sjsu.edu','Gregory','Gan','75b81f8406baf42eaf9dc5286fc6c495e361dcec077633d2febfd59162b00a3e1b3b66c5936ba816f12531e5c7b094baa79da7ca08ade69eaf4672788198dfcf','Öá`ëd\0\ZÓ\'%ÖÜ—KGZÜ¶YÿéÖd$TË?ÕµìÏÒ«Jýá¥æ¹f\\\"Ò0-˜I[vÉÒC\"{¥å•¤´}Ü#@*há\ZxÔìÐ:¨°e¤!<NYí	ƒ0AC–o>>ñNÿ‘»4”C£_Ý)úÕ£Å','I\'m in charge here.','admin'),('tony@starkenterprises.com','Tony','Stark','a9532ef2dafbcce5d31d00bcdda06b7584b78a2b1a56861e480c765d4db8595edb380ee1ea083d5647a7a419d93c4bb78023c7d5f1031c5c0495ce85d8aca156','ßõŠvbš=ä;•Fxëo<dÑËåúÉö2èÍóscß¶»ÇFžVÕuGÙimìæòì…~ÁçOZ8A²ñD|ÈÌ?QÇláÿHàíä¥Ý°æ;”I\' ó&” ÛË\rÂ¹ÙœYLX\\`v‰òÏÚD5.ý¾ÕÖt',NULL,'user'),('trudy@hax.com','Trudy','','b7e330d61a549b598336f75878594405baf3c4cb65391fb31efeec9d3ade4fc7d36b6a150042233a783a4b813e3e13fa47b01aa93abe614c199fc91079951245','oõaRcÇˆ„(s4Á·|…0‰i*Àp%oÊÝ˜õqò,$«K•K>¢˜›0Wuû–YdUÞ—> ihÚ2$•OÞa±>+Voãü|Át=ŠjHu\Z>r>G†;•8øíÒ;\"8¤òàÆìoKûDÎ¬æVÐ¢†åò¬Œ=û’Â',NULL,'user');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Vulnerable`
--

DROP TABLE IF EXISTS `Vulnerable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Vulnerable` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `value` text,
  `email` varchar(255) NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `email` (`email`),
  CONSTRAINT `vulnerable_ibfk_1` FOREIGN KEY (`email`) REFERENCES `Users` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Vulnerable`
--

LOCK TABLES `Vulnerable` WRITE;
/*!40000 ALTER TABLE `Vulnerable` DISABLE KEYS */;
INSERT INTO `Vulnerable` VALUES (1,'<button onclick=\"alert(\'Curiosity and gullibility are often indistinguishable.\');\" style=\"width:300px;\"><h1>You won a prize!</h1></button>','trudy@hax.com','2017-12-16 06:44:12'),(3,'<h1>Markup is enabled here.</h1>','gregory.gan@sjsu.edu','2017-12-16 06:44:12'),(5,'There\'s no input validation.','gregory.gan@sjsu.edu','2017-12-16 06:44:12'),(6,'There\'s no input validation.','gregory.gan@sjsu.edu','2017-12-16 06:44:12'),(7,'The form uses GET.','gregory.gan@sjsu.edu','2017-12-16 06:44:12'),(8,'','gregory.gan@sjsu.edu','2017-12-16 06:44:12'),(9,'Try SQL injection: type something like \" \'); &lt;your SQL code&gt; -- comment out the rest \"','gregory.gan@sjsu.edu','2017-12-16 06:44:12'),(10,'You can also write JavaScript, like \"&lt;script&gt;...&lt;/script&gt;\"','gregory.gan@sjsu.edu','2017-12-16 06:44:12'),(26,'<button onClick=\"document.cookie=\'cookieValue=someCookie\';\">Add a cookie</button>\r\n<button onclick=\"alert(escape(document.cookie));\">Show cookies</button><br/>\r\nClick on the \"Add a cookie\" button to add a cookie for this site. Click on the \"Show cookies\" button to show this site\'s cookies. If an injected script can get your cookies, it can do pretty much anything with them, so watch out!','gregory.gan@sjsu.edu','2017-12-19 18:34:15'),(28,'I can also screw up the formatting of other elements by not closing my tags: let\'s make everything else bold.<b>','gregory.gan@sjsu.edu','2017-12-19 18:45:29'),(29,'You could say \" \'); DELETE FROM Vulnerable; -- \" to clear this page.','gregory.gan@sjsu.edu','2017-12-19 18:50:04'),(30,'What you can do to this page isn\'t limited to these simple examples of SQL injection, scripting attacks, and defacing. This page is about as vulnerable as I could make it; try some other attacks!','gregory.gan@sjsu.edu','2017-12-19 18:50:10');
/*!40000 ALTER TABLE `Vulnerable` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-12-20  0:00:41
