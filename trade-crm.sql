/*
SQLyog Community v13.3.0 (64 bit)
MySQL - 8.0.30 : Database - trade_crm
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`trade_crm` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `trade_crm`;

/*Table structure for table `failed_jobs` */

DROP TABLE IF EXISTS `failed_jobs`;

CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `failed_jobs` */

/*Table structure for table `migrations` */

DROP TABLE IF EXISTS `migrations`;

CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `migrations` */

insert  into `migrations`(`id`,`migration`,`batch`) values 
(1,'2014_10_12_000000_create_users_table',1),
(2,'2014_10_12_100000_create_password_reset_tokens_table',1),
(3,'2019_08_19_000000_create_failed_jobs_table',1),
(4,'2019_12_14_000001_create_personal_access_tokens_table',1),
(5,'2025_04_30_100512_create_order_items_table',2),
(6,'2025_04_30_100512_create_orders_table',2),
(7,'2025_04_30_100512_create_products_table',2),
(8,'2025_04_30_100512_create_warehouses_table',2),
(9,'2025_04_30_100642_create_stocks_table',2),
(10,'2025_04_30_102527_create_product_movements_table',3);

/*Table structure for table `order_items` */

DROP TABLE IF EXISTS `order_items`;

CREATE TABLE `order_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  `count` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `order_items` */

/*Table structure for table `orders` */

DROP TABLE IF EXISTS `orders`;

CREATE TABLE `orders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `customer` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `warehouse_id` bigint unsigned NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `orders` */

/*Table structure for table `password_reset_tokens` */

DROP TABLE IF EXISTS `password_reset_tokens`;

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `password_reset_tokens` */

/*Table structure for table `personal_access_tokens` */

DROP TABLE IF EXISTS `personal_access_tokens`;

CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `personal_access_tokens` */

/*Table structure for table `product_movements` */

DROP TABLE IF EXISTS `product_movements`;

CREATE TABLE `product_movements` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint unsigned NOT NULL,
  `warehouse_id` bigint unsigned NOT NULL,
  `quantity_change` int NOT NULL,
  `movement_type` enum('incoming','outgoing') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_movements_product_id_foreign` (`product_id`),
  KEY `product_movements_warehouse_id_foreign` (`warehouse_id`),
  CONSTRAINT `product_movements_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_movements_warehouse_id_foreign` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `product_movements` */

insert  into `product_movements`(`id`,`product_id`,`warehouse_id`,`quantity_change`,`movement_type`,`created_at`,`updated_at`) values 
(1,4,6,20,'incoming','2025-04-30 10:34:59','2025-04-30 10:34:59'),
(2,5,6,-10,'outgoing','2025-04-30 10:34:59','2025-04-30 10:34:59'),
(3,6,7,20,'incoming','2025-04-30 10:38:34','2025-04-30 10:38:34'),
(4,7,7,-10,'outgoing','2025-04-30 10:38:34','2025-04-30 10:38:34'),
(5,8,8,30,'incoming','2025-04-30 10:38:34','2025-04-30 10:38:34'),
(6,9,9,-50,'outgoing','2025-04-30 10:38:34','2025-04-30 10:38:34'),
(7,10,10,15,'incoming','2025-04-30 10:38:34','2025-04-30 10:38:34'),
(8,11,11,20,'incoming','2025-04-30 10:41:57','2025-04-30 10:41:57'),
(9,12,11,-10,'outgoing','2025-04-30 10:41:57','2025-04-30 10:41:57'),
(10,13,12,30,'incoming','2025-04-30 10:41:57','2025-04-30 10:41:57'),
(11,14,13,-50,'outgoing','2025-04-30 10:41:57','2025-04-30 10:41:57'),
(12,15,14,15,'incoming','2025-04-30 10:41:57','2025-04-30 10:41:57'),
(13,16,15,20,'incoming','2025-04-30 10:45:36','2025-04-30 10:45:36'),
(14,17,15,-10,'outgoing','2025-04-30 10:45:36','2025-04-30 10:45:36'),
(15,18,16,30,'incoming','2025-04-30 10:45:36','2025-04-30 10:45:36'),
(16,19,17,-50,'outgoing','2025-04-30 10:45:36','2025-04-30 10:45:36'),
(17,20,18,15,'incoming','2025-04-30 10:45:36','2025-04-30 10:45:36');

/*Table structure for table `products` */

DROP TABLE IF EXISTS `products`;

CREATE TABLE `products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` double(8,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `products` */

insert  into `products`(`id`,`name`,`price`) values 
(1,'Товар 1',10.00),
(2,'Товар 2',20.00),
(3,'Товар 3',30.00),
(4,'Товар 1',0.00),
(5,'Товар 2',0.00),
(6,'Товар 1',200.00),
(7,'Товар 2',150.00),
(8,'Товар 3',300.00),
(9,'Товар 4',250.00),
(10,'Товар 5',100.00),
(11,'Товар 1',200.00),
(12,'Товар 2',150.00),
(13,'Товар 3',300.00),
(14,'Товар 4',250.00),
(15,'Товар 5',100.00),
(16,'Товар 1',200.00),
(17,'Товар 2',150.00),
(18,'Товар 3',300.00),
(19,'Товар 4',250.00),
(20,'Товар 5',100.00);

/*Table structure for table `stocks` */

DROP TABLE IF EXISTS `stocks`;

CREATE TABLE `stocks` (
  `product_id` bigint unsigned NOT NULL,
  `warehouse_id` bigint unsigned NOT NULL,
  `stock` int NOT NULL,
  PRIMARY KEY (`product_id`,`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `stocks` */

insert  into `stocks`(`product_id`,`warehouse_id`,`stock`) values 
(1,1,50),
(2,2,30),
(3,3,5);

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `users` */

/*Table structure for table `warehouses` */

DROP TABLE IF EXISTS `warehouses`;

CREATE TABLE `warehouses` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `warehouses` */

insert  into `warehouses`(`id`,`name`) values 
(1,'Склад 1'),
(2,'Склад 2'),
(3,'Склад 3'),
(4,'Склад 4'),
(5,'Основной склад'),
(6,'Основной склад'),
(7,'Основной склад'),
(8,'Дополнительный склад'),
(9,'Склад в Москве'),
(10,'Склад в Санкт-Петербурге'),
(11,'Основной склад'),
(12,'Дополнительный склад'),
(13,'Склад в Москве'),
(14,'Склад в Санкт-Петербурге'),
(15,'Основной склад'),
(16,'Дополнительный склад'),
(17,'Склад в Москве'),
(18,'Склад в Санкт-Петербурге');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
