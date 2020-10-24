DROP DATABASE IF EXISTS amber_crm;
CREATE DATABASE amber_crm;
USE amber_crm;

-- пользователи
DROP TABLE IF EXISTS user;
CREATE TABLE `users` (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50), 
    password_hash VARCHAR(100)
);

-- клиенты
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
	id BIGINT NOT NULL PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50), 
    email VARCHAR(120) UNIQUE,
 	phone BIGINT UNSIGNED UNIQUE,
 	address VARCHAR(120),
 	
 	date_one_order DATETIME,-- дата первого заказа
 	last_order_date DATETIME DEFAULT NOW(),-- дата последнего заказа
 	last_link DATETIME DEFAULT NOW(),-- последний контакт(сообщение, звонок и тп)
	
    INDEX customers_firstname_lastname_idx(firstname, lastname)
);

-- номенклатура
DROP TABLE IF EXISTS nomenclature;
CREATE table nomenclature (
	id BIGINT unsigned PRIMARY KEY, 
    name VARCHAR(50),
    price BIGINT,
    quantity BIGINT, -- количество в наличии
    category VARCHAR(50),
	
    INDEX nomenclature_name_idx(name)
);

-- заказ
DROP TABLE IF exists orders;
CREATE table orders(
	id BIGINT UNSIGNED, 
    orders_name BIGINT NOT NULL,-- кто заказал
    ordered_what BIGINT UNSIGNED,-- что заказал
   
    FOREIGN KEY (orders_name) REFERENCES customers(id),
    FOREIGN KEY (ordered_what) REFERENCES nomenclature(id)
);

-- что не дали по заказу(нет в наличии)
DROP TABLE IF exists of_stock;
CREATE table of_stock (
	id BIGINT NOT NULL PRIMARY KEY, 
    of_stock_name BIGINT NOT NULL,-- кому не дали
    of_stock_what BIGINT UNSIGNED-- что не дали
    
);


ALTER TABLE of_stock ADD FOREIGN KEY (`of_stock_name`) REFERENCES customers(`id`);
ALTER TABLE of_stock ADD FOREIGN KEY (`of_stock_what`) REFERENCES nomenclature(`id`);


-- история заказов
DROP TABLE IF exists order_history;
CREATE table order_history(
	id BIGINT NOT NULL PRIMARY KEY, 
    order_history_name BIGINT NOT NULL,-- кто заказывал
    order_history_what BIGINT UNSIGNED,-- что заказывал
    order_history_missing BIGINT NOT NULL,-- чего не было
    
    FOREIGN KEY (order_history_name) REFERENCES customers(id),
    FOREIGN KEY (order_history_what) REFERENCES nomenclature(id),
    FOREIGN KEY (order_history_missing) REFERENCES of_stock(id)
);


-- медиаданные
DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    body text,
    filename VARCHAR(255),
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

-- кто ставил лайки и к какому посту(что бы потом предлагать)
DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    customers_name BIGINT NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (customers_name) REFERENCES customers(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

-- фотоальбом продукции
DROP TABLE IF exists photo_albums;
CREATE TABLE photo_albums (
	id SERIAL,
	name varchar(255) DEFAULT NULL,

  	PRIMARY KEY (id)
);

-- общение с клиентом
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL,
	customers_id BIGINT NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),

    FOREIGN KEY (customers_id) REFERENCES customers(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);


