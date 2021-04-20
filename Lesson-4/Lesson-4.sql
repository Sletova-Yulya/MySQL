1. /* Повторить все действия по доработке БД VK 
После доработки в базе данных есть следующие таблицы*/

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| example            |
| information_schema |
| mysql              |
| performance_schema |
| sample             |
| shop               |
| sys                |
| vk_new             |
+--------------------+
8 rows in set (0.01 sec)

mysql> use vk_new;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
+-------------------------+
| Tables_in_vk_new        |
+-------------------------+
| communities             |
| communities_users       |
| friendship              |
| friendship_statuses     |
| media                   |
| media_reactions         |
| media_types             |
| message_statuses        |
| messages                |
| post_comments_reactions |
| posts                   |
| posts_comments          |
| posts_reactions         |
| profiles                |
| reaction_types          |
| users                   |
+-------------------------+
16 rows in set (0.01 sec)

ysql> SELECT * FROM users LIMIT 10;
+----+------------+-----------+--------------------------------+-------------+---------------------+---------------------+
| id | first_name | last_name | email                          | phone       | created_at          | updated_at          |
+----+------------+-----------+--------------------------------+-------------+---------------------+---------------------+
|  1 | Tomas      | Hills     | cordie50@example.net           | 05326126299 | 2010-07-13 10:02:19 | 2001-08-27 06:03:16 |
|  2 | Josephine  | Renner    | chesley81@example.com          | 47479389814 | 2011-11-21 22:18:03 | 2013-04-14 17:04:45 |
|  3 | Abel       | Stamm     | zgulgowski@example.com         | 93851803431 | 2019-12-04 11:28:30 | 1997-02-02 20:09:28 |
|  4 | Simone     | Little    | esenger@example.com            | 16870800219 | 2006-10-16 09:11:57 | 2015-05-21 06:03:38 |
|  5 | Mikayla    | Baumbach  | rsauer@example.com             | 22473445973 | 2017-06-28 13:04:11 | 1991-05-02 05:23:23 |
|  6 | Javier     | Dooley    | norene01@example.org           | 86539848824 | 2017-07-22 15:13:54 | 1992-11-11 00:46:36 |
|  7 | Aliza      | Muller    | hwalker@example.org            | 65508821805 | 2001-03-16 23:50:57 | 2012-04-13 06:52:12 |
|  8 | Garnett    | Leffler   | konopelski.maybell@example.org | 30856053039 | 2004-12-16 21:09:37 | 1998-11-05 08:23:17 |
|  9 | Rachel     | Haag      | cprice@example.net             | 04961937240 | 2005-02-24 04:07:17 | 2019-01-06 14:17:41 |
| 10 | Asha       | Bins      | hal.metz@example.org           | 31759847133 | 1975-11-28 18:34:38 | 2008-09-26 07:34:47 |
+----+------------+-----------+--------------------------------+-------------+---------------------+---------------------+
10 rows in set (0.00 sec)

/* Созданы так же внешние ключи для таблиц. Пример для таблицы Профили */

mysql> SHOW CREATE TABLE profiles\G
*************************** 1. row ***************************
       Table: profiles
Create Table: CREATE TABLE `profiles` (
  `user_id` int unsigned NOT NULL COMMENT 'Ссылка на пользователя',
  `gender` char(1) NOT NULL COMMENT 'Пол',
  `birthday` date DEFAULT NULL COMMENT 'Дата рождения',
  `city` varchar(130) DEFAULT NULL COMMENT 'Город проживания',
  `country` varchar(130) DEFAULT NULL COMMENT 'Страна проживания',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  `media_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `fk_profiles_media_id` (`media_id`),
  CONSTRAINT `fk_profiles_media_id` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`),
  CONSTRAINT `fk_profiles_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Профили'
1 row in set (0.01 sec)

/* Созданы таблицы, хранящие данные по опубликованным постам,комментариям на посты, реакциям на посты, комментарии и медиа */

mysql> SELECT * FROM reaction_types;
+----+---------+---------------------+---------------------+
| id | name    | created_at          | updated_at          |
+----+---------+---------------------+---------------------+
|  1 | like    | 1971-02-19 08:47:02 | 2005-10-14 02:04:52 |
|  2 | dislike | 2007-09-24 13:15:30 | 2012-08-17 20:29:52 |
+----+---------+---------------------+---------------------+
2 rows in set (0.01 sec)

mysql> SHOW CREATE TABLE posts\G
*************************** 1. row ***************************
       Table: posts
Create Table: CREATE TABLE `posts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `user_id` int unsigned NOT NULL COMMENT 'Ссылка на автора поста',
  `heading` varchar(255) DEFAULT NULL COMMENT 'Заголовок к посту (может отсутствовать)',
  `body` text COMMENT 'Текст поста (может отсутствовать)',
  `media_id` int unsigned NOT NULL COMMENT 'Ссылка на медиа-файлы, если они есть в посте',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  KEY `fk_post_user` (`user_id`),
  KEY `fk_post_media` (`media_id`),
  CONSTRAINT `fk_post_media` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`),
  CONSTRAINT `fk_post_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
1 row in set (0.00 sec)

mysql> SELECT * FROM posts limit 3;
+----+---------+-------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+---------------------+---------------------+
| id | user_id | heading                                                           | body                                                                                                                                                                             | media_id | created_at          | updated_at          |
+----+---------+-------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+---------------------+---------------------+
|  1 |       1 | Tempora consequuntur voluptatem dolor quia commodi.               | Cumque eos corrupti qui nulla inventore expedita. Atque fugiat eius porro dolorum nobis omnis praesentium sed. Repellendus voluptate architecto ipsa. Quia qui sit maxime eius.  |        1 | 2017-04-21 11:30:37 | 1973-01-12 04:00:52 |
|  2 |       2 | Esse ut sit quasi sed fugit ea dignissimos qui.                   | Expedita et quia iure veniam sed earum. Repellendus quam qui aut in qui repellendus harum omnis. Amet fugiat ut delectus mollitia aut aliquid. Expedita iure voluptas quia iste. |        2 | 2008-01-09 04:17:25 | 1999-12-11 13:05:52 |
|  3 |       3 | Sunt aperiam ipsum vitae rerum ipsam dignissimos voluptatum quos. | Illo magnam maxime fuga ut neque. Recusandae deserunt quos sunt ea sed qui. Ratione reiciendis iure nisi unde aut. Fuga error sunt odio necessitatibus nostrum dignissimos quam. |        3 | 2010-12-12 14:31:47 | 1971-04-01 22:02:04 |
+----+---------+-------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+---------------------+---------------------+
3 rows in set (0.00 sec)


mysql> SHOW CREATE TABLE posts_comments\G
*************************** 1. row ***************************
       Table: posts_comments
Create Table: CREATE TABLE `posts_comments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `post_id` int unsigned NOT NULL COMMENT 'Ссылка на комментируемый пост',
  `user_id` int unsigned NOT NULL COMMENT 'Ссылка на автора комментария',
  `body` text NOT NULL COMMENT 'Текст комментария',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  KEY `fk_comment_post_id` (`post_id`),
  KEY `fk_comment_post_user` (`user_id`),
  CONSTRAINT `fk_comment_post_id` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  CONSTRAINT `fk_comment_post_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Таблица для хранения комментариев к постам'
1 row in set (0.00 sec)

mysql> SHOW CREATE TABLE posts_reactions\G
*************************** 1. row ***************************
       Table: posts_reactions
Create Table: CREATE TABLE `posts_reactions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `post_id` int unsigned NOT NULL COMMENT 'Ссылка на пост',
  `reaction_type_id` int unsigned NOT NULL COMMENT 'Ссылка на тип реакции',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  `from_user_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_post_reaction_id` (`post_id`),
  KEY `fk_post_reaction_type_id` (`reaction_type_id`),
  KEY `fk_post_reaction_user` (`from_user_id`),
  CONSTRAINT `fk_post_reaction_id` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  CONSTRAINT `fk_post_reaction_type_id` FOREIGN KEY (`reaction_type_id`) REFERENCES `reaction_types` (`id`),
  CONSTRAINT `fk_post_reaction_user` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Таблица для хранения реакций на посты'
1 row in set (0.00 sec)

ysql> SELECT * FROM posts_reactions limit 3;
+----+---------+------------------+---------------------+---------------------+--------------+
| id | post_id | reaction_type_id | created_at          | updated_at          | from_user_id |
+----+---------+------------------+---------------------+---------------------+--------------+
|  1 |       1 |                1 | 1972-01-21 10:29:38 | 1976-08-29 02:58:01 |            1 |
|  2 |       2 |                2 | 2007-12-02 03:02:08 | 2001-03-06 00:35:32 |            2 |
|  3 |       3 |                1 | 1993-06-22 11:11:27 | 2014-05-19 06:49:43 |            3 |
+----+---------+------------------+---------------------+---------------------+--------------+
3 rows in set (0.00 sec)

3. /* Повторить все операции CRUD */
mysql> SHOW TABLES;
+-------------------+
| Tables_in_example |
+-------------------+
| users             |
+-------------------+
1 row in set (0.00 sec)

CREATE TABLE dogs (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  breed VARCHAR(100) NOT NULL);
  
mysql> SHOW TABLES;
+-------------------+
| Tables_in_example |
+-------------------+
| dogs              |
| users             |
+-------------------+
2 rows in set (0.00 sec)

mysql> DESCRIBE dogs;
+-------+--------------+------+-----+---------+----------------+
| Field | Type         | Null | Key | Default | Extra          |
+-------+--------------+------+-----+---------+----------------+
| id    | int unsigned | NO   | PRI | NULL    | auto_increment |
| breed | varchar(100) | NO   |     | NULL    |                |
+-------+--------------+------+-----+---------+----------------+
2 rows in set (0.01 sec)

INSERT INTO dogs VALUES
(1, 'лабрадор'),
(2, 'питбуль'),
(3, 'пудель'),
(4, 'болонка');

mysql> SELECT * FROM dogs;
+----+------------------+
| id | breed            |
+----+------------------+
|  1 | лабрадор         |
|  2 | питбуль          |
|  3 | пудель           |
|  4 | болонка          |
+----+------------------+
4 rows in set (0.00 sec)

DELETE FROM dogs WHERE id >1 LIMIT 1;

mysql> SELECT * FROM dogs;
+----+------------------+
| id | breed            |
+----+------------------+
|  1 | лабрадор         |
|  3 | пудель           |
|  4 | болонка          |
+----+------------------+
3 rows in set (0.00 sec)

UPDATE dogs SET breed = 'той терьер' WHERE breed = 'лабрадор';

mysql> SELECT * FROM dogs;
+----+---------------------+
| id | breed               |
+----+---------------------+
|  1 | той терьер          |
|  3 | пудель              |
|  4 | болонка             |
+----+---------------------+
3 rows in set (0.00 sec)

TRUNCATE TABLE dogs;

mysql> SELECT * FROM dogs;
Empty set (0.00 sec)

/* Прилагаю так же EER Diagram на базу VK_new и на всякий случай ее дамп */







