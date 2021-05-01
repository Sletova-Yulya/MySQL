/* В базах данных shop1 и sample присутствуют одни и те же таблицы. Переместите запись с id = 1 из таблицы shop1.users в таблицу sample.users. Используйте транзакции. */

START TRANSACTION;
INSERT INTO sample.users SELECT * FROM shop1.users WHERE id = 1;
DELETE FROM shop1.users WHERE id = 1;
COMMIT;

/* Результат:

База sample: */
mysql> USE sample;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SELECT * FROM users;
+----+------------------+-------------+---------------------+---------------------+
| id | name             | birthday_at | created_at          | updated_at          |
+----+------------------+-------------+---------------------+---------------------+
|  1 | Геннадий         | 1990-10-05  | 2021-04-30 22:16:26 | 2021-04-30 22:16:26 |
+----+------------------+-------------+---------------------+---------------------+
1 row in set (0.00 sec)

 
-- База shop1:
mysql> USE shop1;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SELECT * FROM users;
+----+--------------------+-------------+---------------------+---------------------+
| id | name               | birthday_at | created_at          | updated_at          |
+----+--------------------+-------------+---------------------+---------------------+
|  2 | Наталья            | 1984-11-12  | 2021-04-30 22:16:26 | 2021-04-30 22:16:26 |
|  3 | Александр          | 1985-05-20  | 2021-04-30 22:16:26 | 2021-04-30 22:16:26 |
|  4 | Сергей             | 1988-02-14  | 2021-04-30 22:16:26 | 2021-04-30 22:16:26 |
|  5 | Иван               | 1998-01-12  | 2021-04-30 22:16:26 | 2021-04-30 22:16:26 |
|  6 | Мария              | 1992-08-29  | 2021-04-30 22:16:26 | 2021-04-30 22:16:26 |
+----+--------------------+-------------+---------------------+---------------------+
5 rows in set (0.01 sec)

2. /* Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs */

CREATE VIEW prod1 AS (
	SELECT 
		p2.name AS product_name
		,c2.name AS catalog_name	
	FROM 
		products p2 
	LEFT JOIN
		catalogs c2 
	ON 
		p2.catalog_id = c2.id 
);

SELECT * FROM prod1;

product_name           |catalog_name     |
-----------------------|-----------------|
Intel Core i3-8100     |Процессоры       |
Intel Core i5-7400     |Процессоры       |
AMD FX-8320E           |Процессоры       |
AMD FX-8320            |Процессоры       |
ASUS ROG MAXIMUS X HERO|Материнские платы|
Gigabyte H310M S2H     |Материнские платы|
MSI B250M GAMING PRO   |Материнские платы|



1. /* Создайте пользователей, которые имеют доступ к базе shop (у меня данная база имеет название shop1). Первому пользователю shop_read присвойте права на чтение 
данных, второму shop - любые операции в пределах базы данных shop1 */

-- Просмотрим существующих пользователей:

mysql> select Host, User from mysql.user;
+-----------+------------------+
| Host      | User             |
+-----------+------------------+
| localhost | debian-sys-maint |
| localhost | mysql.infoschema |
| localhost | mysql.session    |
| localhost | mysql.sys        |
| localhost | root             |
+-----------+------------------+
5 rows in set (0.04 sec)

-- Создадим новых:

mysql> CREATE USER shop@localhost;
Query OK, 0 rows affected (0.01 sec)

mysql> CREATE USER shop_read@localhost;
Query OK, 0 rows affected (0.00 sec)

mysql> select Host, User from mysql.user;
+-----------+------------------+
| Host      | User             |
+-----------+------------------+
| localhost | debian-sys-maint |
| localhost | mysql.infoschema |
| localhost | mysql.session    |
| localhost | mysql.sys        |
| localhost | root             |
| localhost | shop             |
| localhost | shop_read        |
+-----------+------------------+
7 rows in set (0.00 sec)

-- Присвоим им права:

mysql> use shop1;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

mysql> GRANT SELECT ON * TO shop_read@localhost;
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT ALL ON * TO shop@localhost;
Query OK, 0 rows affected (0.00 sec)

mysql> SHOW GRANTS FOR 'shop'@'localhost';
+---------------------------------------------------------+
| Grants for shop@localhost                               |
+---------------------------------------------------------+
| GRANT USAGE ON *.* TO `shop`@`localhost`                |
| GRANT ALL PRIVILEGES ON `shop1`.* TO `shop`@`localhost` |
+---------------------------------------------------------+
2 rows in set (0.00 sec)

mysql> SHOW GRANTS FOR 'shop_read'@'localhost';
+------------------------------------------------------+
| Grants for shop_read@localhost                       |
+------------------------------------------------------+
| GRANT USAGE ON *.* TO `shop_read`@`localhost`        |
| GRANT SELECT ON `shop1`.* TO `shop_read`@`localhost` |
+------------------------------------------------------+
2 rows in set (0.00 sec)

1. /* Создайте хранимую функцию hello(), которая будет возвращать приветствие в зависимости от времени суток. */

CREATE FUNCTION hello()
RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
	CASE
	WHEN current_time() BETWEEN '00:00:00' AND '05:59:59' THEN RETURN 'Доброй ночи';
	WHEN current_time() BETWEEN '06:00:00' AND '11:59:59' THEN RETURN 'Доброе утро';
	WHEN current_time() BETWEEN '12:00:00' AND '17:59:59' THEN RETURN 'Добрый день';
	WHEN current_time() BETWEEN '18:00:00' AND '23:59:59' THEN RETURN 'Добрый вечер';
	END CASE; 
END

mysql> select current_time();
+----------------+
| current_time() |
+----------------+
| 16:28:40       |
+----------------+
1 row in set (0.00 sec)

mysql> select hello() as hello;
+-----------------------+
| hello                 |
+-----------------------+
| Добрый день           |
+-----------------------+
1 row in set (0.00 sec)

2. /* В таблице products есть два текстовых поля: name и description. Допустимо присутствие обоих полей или одного из них. Ситуация, когда оба поля принимают значение 
NULL, недопустима. С использованием триггеров необходимо добиться того, чтобы одно из полей или оба поля были заполнены. При попытке присвоить полям NULL-значение
необходимо отменить операцию. */

-- Создадим триггер для операции вставки новых строк в таблицу:

CREATE TRIGGER check_name_description_products BEFORE INSERT ON products
FOR EACH ROW 
BEGIN 
	IF (NEW.name = 'NULL' AND NEW.description = 'NULL') THEN 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You need to fill in at least one of the field name or description';
	END IF;
END

--Проверим:

mysql> INSERT INTO products 
    -> (name, description, price, catalog_id)
    -> VALUES
    -> ('NULL', 'NULL', 5000, 2);
ERROR 1644 (45000): You need to fill in at least one of the field name or description

-- Создадим триггер для операции обновления строк в таблице:

CREATE TRIGGER check_name_description_products_upd BEFORE UPDATE ON products
FOR EACH ROW 
BEGIN 
	IF (NEW.name = 'NULL' AND NEW.description = 'NULL') THEN 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You need to fill in at least one of the field name or description';
	END IF;
END

-- Проверим:

mysql> UPDATE products 
    -> SET 
    -> name = 'NULL',
    -> description = 'NULL',
    -> price = 3000,
    -> catalog_id = 2
    -> WHERE id = 1
    -> ;
ERROR 1644 (45000): You need to fill in at least one of the field name or description










