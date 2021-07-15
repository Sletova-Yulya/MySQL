/* Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущим датой и временем 
 Только в середины выполнения ДЗ я поняла, что таблицы уже все были приложены к уроку, и надо было использовать их, а не создавать свои. Но переделывать уже не стала. */

CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(150) NOT NULL,
  second_name VARCHAR(150) NOT NULL,
  date_of_birth DATE DEFAULT NULL,
  created_at DATETIME DEFAULT NULL,
  updated_at DATETIME DEFAULT NULL
);

mysql> DESCRIBE users;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| id            | int unsigned | NO   | PRI | NULL    | auto_increment |
| first_name    | varchar(150) | NO   |     | NULL    |                |
| second_name   | varchar(150) | NO   |     | NULL    |                |
| date_of_birth | date         | YES  |     | NULL    |                |
| created_at    | datetime     | YES  |     | NULL    |                |
| updated_at    | datetime     | YES  |     | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+
6 rows in set (0.00 sec)

INSERT INTO users (id, first_name, second_name, date_of_birth) VALUES (1, 'Надежда', 'Иванова', '1977-10-20');
INSERT INTO users (id, first_name, second_name, date_of_birth) VALUES (2, 'Елена', 'Петрова', '1983-11-14');
INSERT INTO users (id, first_name, second_name, date_of_birth) VALUES (3, 'Любовь', 'Сидорова', '2012-09-03');

mysql> SELECT * FROM users;
+----+----------------+------------------+---------------+------------+------------+
| id | first_name     | second_name      | date_of_birth | created_at | updated_at |
+----+----------------+------------------+---------------+------------+------------+
|  1 | Надежда        | Иванова          | 1977-10-20    | NULL       | NULL       |
|  2 | Елена          | Петрова          | 1983-11-14    | NULL       | NULL       |
|  3 | Любовь         | Сидорова         | 2012-09-03    | NULL       | NULL       |
+----+----------------+------------------+---------------+------------+------------+
3 rows in set (0.00 sec)

UPDATE users SET created_at = NOW(), updated_at = NOW() WHERE id > 0;

mysql> SELECT * FROM users;
+----+----------------+------------------+---------------+---------------------+---------------------+
| id | first_name     | second_name      | date_of_birth | created_at          | updated_at          |
+----+----------------+------------------+---------------+---------------------+---------------------+
|  1 | Надежда        | Иванова          | 1977-10-20    | 2021-04-10 23:07:05 | 2021-04-10 23:07:05 |
|  2 | Елена          | Петрова          | 1983-11-14    | 2021-04-10 23:07:05 | 2021-04-10 23:07:05 |
|  3 | Любовь         | Сидорова         | 2012-09-03    | 2021-04-10 23:07:05 | 2021-04-10 23:07:05 |
+----+----------------+------------------+---------------+---------------------+---------------------+
3 rows in set (0.00 sec)

/* Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля по типу DATETIME, сохранив введенные ранее заняения. */

CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(150) NOT NULL,
  second_name VARCHAR(150) NOT NULL,
  date_of_birth DATE DEFAULT NULL,
  created_at VARCHAR(100) DEFAULT NULL,
  updated_at VARCHAR(100) DEFAULT NULL
  );
  
mysql> DESCRIBE users;
+---------------+--------------+------+-----+---------+----------------+
| Field         | Type         | Null | Key | Default | Extra          |
+---------------+--------------+------+-----+---------+----------------+
| id            | int unsigned | NO   | PRI | NULL    | auto_increment |
| first_name    | varchar(150) | NO   |     | NULL    |                |
| second_name   | varchar(150) | NO   |     | NULL    |                |
| date_of_birth | date         | YES  |     | NULL    |                |
| created_at    | varchar(100) | YES  |     | NULL    |                |
| updated_at    | varchar(100) | YES  |     | NULL    |                |
+---------------+--------------+------+-----+---------+----------------+
6 rows in set (0.00 sec)

INSERT INTO users (id, first_name, second_name, date_of_birth, created_at, updated_at) VALUES (1, 'Надежда', 'Иванова', '1977-10-20', '10.04.21 23:30', '10.04.21 23:30');
INSERT INTO users (id, first_name, second_name, date_of_birth, created_at, updated_at) VALUES (2, 'Елена', 'Петрова', '1983-11-14', '10.04.21 23:30', '10.04.21 23:30');
INSERT INTO users (id, first_name, second_name, date_of_birth, created_at, updated_at) VALUES (3, 'Любовь', 'Сидорова', '2012-09-03', '10.04.21 23:30', '10.04.21 23:30');

mysql> SELECT * FROM users;
+----+----------------+------------------+---------------+----------------+----------------+
| id | first_name     | second_name      | date_of_birth | created_at     | updated_at     |
+----+----------------+------------------+---------------+----------------+----------------+
|  1 | Надежда        | Иванова          | 1977-10-20    | 10.04.21 23:30 | 10.04.21 23:30 |
|  2 | Елена          | Петрова          | 1983-11-14    | 10.04.21 23:30 | 10.04.21 23:30 |
|  3 | Любовь         | Сидорова         | 2012-09-03    | 10.04.21 23:30 | 10.04.21 23:30 |
+----+----------------+------------------+---------------+----------------+----------------+
3 rows in set (0.00 sec)

mysql> SELECT DATE_FORMAT(created_at, '%Y-%m-%d %k:%i:%S') AS created_at FROM us
ers;
+---------------------+
| created_at          |
+---------------------+
| 2010-04-21 23:30:00 |
| 2010-04-21 23:30:00 |
| 2010-04-21 23:30:00 |
+---------------------+
3 rows in set (0.00 sec)

mysql> SELECT DATE_FORMAT(created_at, '%Y-%m-%d %k:%i:%S') AS created_at FROM us
ers;
+---------------------+
| created_at          |
+---------------------+
| 2010-04-21 23:30:00 |
| 2010-04-21 23:30:00 |
| 2010-04-21 23:30:00 |
+---------------------+
3 rows in set (0.00 sec)

mysql> UPDATE users SET created_at = date_format(created_at, '%Y-%m-%d %k:%i:%S');
Query OK, 3 rows affected (0.00 sec)
Rows matched: 3  Changed: 3  Warnings: 0

mysql> UPDATE users SET updated_at = date_format(updated_at, '%Y-%m-%d %k:%i:%S');
Query OK, 3 rows affected (0.03 sec)
Rows matched: 3  Changed: 3  Warnings: 0

mysql> SELECT * FROM users;
+----+----------------+------------------+---------------+---------------------+---------------------+
| id | first_name     | second_name      | date_of_birth | created_at          | updated_at          |
+----+----------------+------------------+---------------+---------------------+---------------------+
|  1 | Надежда        | Иванова          | 1977-10-20    | 2010-04-21 23:30:00 | 2010-04-21 23:30:00 |
|  2 | Елена          | Петрова          | 1983-11-14    | 2010-04-21 23:30:00 | 2010-04-21 23:30:00 |
|  3 | Любовь         | Сидорова         | 2012-09-03    | 2010-04-21 23:30:00 | 2010-04-21 23:30:00 |
+----+----------------+------------------+---------------+---------------------+---------------------+
3 rows in set (0.00 sec)

ALTER TABLE users 
  MODIFY created_at DATETIME DEFAULT current_timestamp(),
  MODIFY updated_at DATETIME DEFAULT current_timestamp() ON UPDATE current_timestamp();
  
mysql> DESCRIBE users;
+---------------+--------------+------+-----+-------------------+-----------------------------------------------+
| Field         | Type         | Null | Key | Default           | Extra                                         |
+---------------+--------------+------+-----+-------------------+-----------------------------------------------+
| id            | int unsigned | NO   | PRI | NULL              | auto_increment                                |
| first_name    | varchar(150) | NO   |     | NULL              |                                               |
| second_name   | varchar(150) | NO   |     | NULL              |                                               |
| date_of_birth | date         | YES  |     | NULL              |                                               |
| created_at    | datetime     | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED                             |
| updated_at    | datetime     | YES  |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
+---------------+--------------+------+-----+-------------------+-----------------------------------------------+
6 rows in set (0.00 sec)

3. /* В таблице складских запасов storehouses_products в поле value могуь встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех значений. */

CREATE TABLE storehouses_products (
  product_id INT UNSIGNED NOT NULL PRIMARY KEY,
  value INT NOT NULL
  );
  
mysql> DESCRIBE storehouses_products;
+------------+--------------+------+-----+---------+-------+
| Field      | Type         | Null | Key | Default | Extra |
+------------+--------------+------+-----+---------+-------+
| product_id | int unsigned | NO   | PRI | NULL    |       |
| value      | int          | NO   |     | NULL    |       |
+------------+--------------+------+-----+---------+-------+
2 rows in set (0.01 sec)

INSERT INTO storehouses_products VALUES (1, 0);
INSERT INTO storehouses_products VALUES (2, 100); 
INSERT INTO storehouses_products VALUES (3, 5000);
INSERT INTO storehouses_products VALUES (4, 3682);
INSERT INTO storehouses_products VALUES (5, 21);
INSERT INTO storehouses_products VALUES (6, 0);

mysql> SELECT * FROM storehouses_products;
+------------+-------+
| product_id | value |
+------------+-------+
|          1 |     0 |
|          2 |   100 |
|          3 |  5000 |
|          4 |  3682 |
|          5 |    21 |
|          6 |     0 |
+------------+-------+
6 rows in set (0.00 sec)

mysql> SELECT * FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 100000 END, value;

+------------+-------+
| product_id | value |
+------------+-------+
|          5 |    21 |
|          2 |   100 |
|          4 |  3682 |
|          3 |  5000 |
|          1 |     0 |
|          6 |     0 |
+------------+-------+
6 rows in set (0.00 sec)

4. /* Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august). */

mysql> SELECT * FROM users;
+----+--------------------+-------------+---------------------+---------------------+
| id | name               | birthday_at | created_at          | updated_at          |
+----+--------------------+-------------+---------------------+---------------------+
|  1 | Геннадий           | 1990-10-05  | 2021-04-11 01:52:05 | 2021-04-11 01:52:05 |
|  2 | Наталья            | 1984-11-12  | 2021-04-11 01:52:05 | 2021-04-11 01:52:05 |
|  3 | Александр          | 1985-05-20  | 2021-04-11 01:52:05 | 2021-04-11 01:52:05 |
|  4 | Сергей             | 1988-02-14  | 2021-04-11 01:52:05 | 2021-04-11 01:52:05 |
|  5 | Иван               | 1998-01-12  | 2021-04-11 01:52:05 | 2021-04-11 01:52:05 |
|  6 | Мария              | 1992-08-29  | 2021-04-11 01:52:05 | 2021-04-11 01:52:05 |
+----+--------------------+-------------+---------------------+---------------------+
6 rows in set (0.00 sec)

mysql> SELECT id, name, DATE_FORMAT(birthday_at, '%M') AS birthday FROM users WHERE MONTH(birthday_at) = 5 OR MONTH(birthday_at) = 8;
+----+--------------------+----------+
| id | name               | birthday |
+----+--------------------+----------+
|  3 | Александр          | May      |
|  6 | Мария              | August   |
+----+--------------------+----------+
2 rows in set (0.00 sec)

5. /* Из таблицы catalogs извлекаются записи при помощи запроса SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN. */

mysql> SELECT * FROM catalogs;
+----+-------------------------------------+
| id | name                                |
+----+-------------------------------------+
|  1 | Процессоры                          |
|  2 | Материнские платы                   |
|  3 | Видеокарты                          |
|  4 | Жесткие диски                       |
|  5 | Оперативная память                  |
+----+-------------------------------------+
5 rows in set (0.00 sec)

mysql> SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY (CASE id WHEN 5 THEN 1 WHEN 1 THEN 2 WHEN 2 THEN 3 END);
+----+-------------------------------------+
| id | name                                |
+----+-------------------------------------+
|  5 | Оперативная память                  |
|  1 | Процессоры                          |
|  2 | Материнские платы                   |
+----+-------------------------------------+
3 rows in set (0.00 sec)

/* АГРЕГАЦИЯ ДАННЫХ */
1. /* Посчитайте средний возраст пользователей в таблице users. */

mysql> SELECT * FROM users;
+----+--------------------+-------------+---------------------+---------------------+
| id | name               | birthday_at | created_at          | updated_at          |
+----+--------------------+-------------+---------------------+---------------------+
|  1 | Геннадий           | 1990-10-05  | 2021-04-11 01:52:05 | 2021-04-11 01:52:05 |
|  2 | Наталья            | 1984-11-12  | 2021-04-11 01:52:05 | 2021-04-11 01:52:05 |
|  3 | Александр          | 1985-05-20  | 2021-04-11 01:52:05 | 2021-04-11 01:52:05 |
|  4 | Сергей             | 1988-02-14  | 2021-04-11 01:52:05 | 2021-04-11 01:52:05 |
|  5 | Иван               | 1998-01-12  | 2021-04-11 01:52:05 | 2021-04-11 01:52:05 |
|  6 | Мария              | 1992-08-29  | 2021-04-11 01:52:05 | 2021-04-11 01:52:05 |
+----+--------------------+-------------+---------------------+---------------------+
6 rows in set (0.00 sec)

mysql> SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())) AS average_age FROM u
sers;
+-------------+
| average_age |
+-------------+
|     30.8333 |
+-------------+
1 row in set (0.00 sec)

2. /* Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения. */

mysql> SELECT DAYNAME(ADDDATE(birthday_at, INTERVAL YEAR(current_date)-YEAR(birthday_at) YEAR)) AS day_name, COUNT(*) AS value FROM users GROUP BY day_name;
+----------+-------+
| day_name | value |
+----------+-------+
| Tuesday  |     2 |
| Friday   |     1 |
| Thursday |     1 |
| Sunday   |     2 |
+----------+-------+
4 rows in set (0.00 sec)

3. /* Последняя задача не решена */












