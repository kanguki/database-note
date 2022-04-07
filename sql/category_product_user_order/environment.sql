-- environment
-- category: | id | name | 
CREATE TABLE `category` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `test`.`category` (`id`, `name`) VALUES ('1', 'Books');
INSERT INTO `test`.`category` (`id`, `name`) VALUES ('2', 'Clothes');
INSERT INTO `test`.`category` (`id`, `name`) VALUES ('3', 'Shoes');
INSERT INTO `test`.`category` (`id`, `name`) VALUES ('4', 'Hats');
INSERT INTO `test`.`category` (`id`, `name`) VALUES ('5', 'Electrics');
-- product: | id | name | category_id | 
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `category_id` varchar(45) NOT NULL,
  PRIMARY KEY (`id`,`name`,`category_id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `test`.`product` (`id`, `name`, `category_id`) VALUES ('1', 'Doi gio hu', '1');
INSERT INTO `test`.`product` (`id`, `name`, `category_id`) VALUES ('2', 'Ao phong', '2');
INSERT INTO `test`.`product` (`id`, `name`, `category_id`) VALUES ('3', 'Quan tay', '2');
INSERT INTO `test`.`product` (`id`, `name`, `category_id`) VALUES ('4', 'Khong gia dinh', '1');
INSERT INTO `test`.`product` (`id`, `name`, `category_id`) VALUES ('5', 'Mu phot', '4');
INSERT INTO `test`.`product` (`id`, `name`, `category_id`) VALUES ('6', 'Mu vanh', '4');
INSERT INTO `test`.`product` (`id`, `name`, `category_id`) VALUES ('7', 'Dep le', '3');
INSERT INTO `test`.`product` (`id`, `name`, `category_id`) VALUES ('8', 'Noi com dien', '5');
INSERT INTO `test`.`product` (`id`, `name`, `category_id`) VALUES ('9', 'Tu lanh', '5');
INSERT INTO `test`.`product` (`id`, `name`, `category_id`) VALUES ('10', 'TV', '5');
-- user: | id | fname | lname | 
CREATE TABLE `user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `fname` varchar(45) DEFAULT NULL,
  `lname` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `test`.`user` (`id`, `fname`, `lname`) VALUES ('1', 'mo', 'nguyen');
INSERT INTO `test`.`user` (`id`, `fname`, `lname`) VALUES ('2', 'uki', 'kang');
INSERT INTO `test`.`user` (`id`, `fname`, `lname`) VALUES ('3', 'jungkook', 'jeon');
INSERT INTO `test`.`user` (`id`, `fname`, `lname`) VALUES ('4', 'ariana', 'grande');
INSERT INTO `test`.`user` (`id`, `fname`, `lname`) VALUES ('5', 'jimin', 'park');
-- order: | id | user_id | product_id | bill |
CREATE TABLE `order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `product_id` varchar(45) DEFAULT NULL,
  `bill` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `test`.`order` (`id`, `user_id`, `product_id`, `bill`) VALUES ('1', '1', '1', '10');
INSERT INTO `test`.`order` (`id`, `user_id`, `product_id`, `bill`) VALUES ('2', '1', '3', '13');
INSERT INTO `test`.`order` (`id`, `user_id`, `product_id`, `bill`) VALUES ('3', '1', '4', '16');
INSERT INTO `test`.`order` (`id`, `user_id`, `product_id`, `bill`) VALUES ('4', '2', '2', '12');
INSERT INTO `test`.`order` (`id`, `user_id`, `product_id`, `bill`) VALUES ('5', '3', '5', '45');
INSERT INTO `test`.`order` (`id`, `user_id`, `product_id`, `bill`) VALUES ('6', '4', '6', '31');
INSERT INTO `test`.`order` (`id`, `user_id`, `product_id`, `bill`) VALUES ('7', '5', '7', '54');
INSERT INTO `test`.`order` (`id`, `user_id`, `product_id`, `bill`) VALUES ('8', '5', '8', '64');
INSERT INTO `test`.`order` (`id`, `user_id`, `product_id`, `bill`) VALUES ('9', '5', '9', '23');
INSERT INTO `test`.`order` (`id`, `user_id`, `product_id`, `bill`) VALUES ('10', '4', '4', '12');
INSERT INTO `test`.`order` (`id`, `user_id`, `product_id`, `bill`) VALUES ('11', '2', '10', '65');
INSERT INTO `test`.`order` (`id`, `user_id`, `product_id`, `bill`) VALUES ('12', '3', '10', '8');
INSERT INTO `test`.`order` (`id`, `user_id`, `product_id`, `bill`) VALUES ('13', '6', '6', '12');

