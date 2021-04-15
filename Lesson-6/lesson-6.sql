1. /* Относительно запросов, которые мы составляли на вебинаре, есть один вопрос. Момент, когда мы составляли запрос для поиска общих подписчиков. Код был вот таким:

SELECT
	friend_id, frienship_status_id
FROM
	friendship
WHERE user_id IN (
		SELECT user_id FROM friendship WHERE user_id = 5
		UNION
		SELECT user_id FROM friendship WHERE user_id = 88
		)
;

Нижняя часть запроса составлена таким образом, что запрос сработал бы, если бы мы после IN в скобках указали 5 и 88 через запятую. В чем логический смысл этой части?
Если мы выполним его изолированно, мы получим лишь 5 и 88, а если они нам заранее известны, то зачем писать всю эту нижнюю часть? В учебных целях? */


2. /* Пусть задан некоторый пользователь. Из всех друзей нашего пользователя найдите того, кто больше всех общался с нашим пользователем. 
Вопрос: мы предполагаем, что все переписки нашего пользователя ведутся только с друзьями или проверка друг/не друг должна быть реализована в запросе?
Друг = подписчик или важен факт взаимной дружбы, то есть проверка еще и статуса дружбы?
Важен ли факт взаимной переписки или важно просто количество сообщений в диалоговом окне, неважно были ли на них ответы?
Я написла запрос, который выдает лишь данные человека, с которым просто было наибольшее количество сообщений из всех сообщений, в которых фигурировал некоторый пользователь

Запрос писался для пользователя с id=15. База формировалась автоматически, поэтому в нее попали сообщения, которые были написаны самому себе, я не стала исправлять,
допустим, что это возможно */

-- Выведем все строки сообщений для пользователя с id=15

SELECT 
	from_user_id 
FROM 
	messages 
WHERE 
	to_user_id = 15
UNION ALL 
SELECT 
	to_user_id 
FROM 
	messages 
WHERE 
	from_user_id = 15;
	
+--------------+
| from_user_id |
+--------------+
|            6 |
|           13 |
|           15 |
|           15 |
|           15 |
|            1 |
|           14 |
|           13 |
|            3 |
|           14 |
|           14 |
|           14 |
|           14 |
|           14 |
|           14 |
|           15 |
|           15 |
|            4 |
|           15 |
|            3 |
|            4 |
+--------------+
21 rows in set (0.03 sec)

-- Как видно, наибольшее количество писем будет в диалоге с пользователем 14.

SELECT 
	from_user_id
	,COUNT(from_user_id) AS number
FROM (
		SELECT 
			from_user_id 
		FROM 
			messages 
		WHERE to_user_id = 15
		UNION ALL 
		SELECT 
			to_user_id 
		FROM 
			messages 
		WHERE 
			from_user_id = 15
	)t1
GROUP BY 
	from_user_id
;
+--------------+--------+
| from_user_id | number |
+--------------+--------+
|            6 |      1 |
|           13 |      2 |
|           15 |      6 |
|            1 |      1 |
|           14 |      7 |
|            3 |      2 |
|            4 |      2 |
+--------------+--------+
7 rows in set (0.00 sec)

-- Теперь выведем его данные:

SELECT 
	id
	,CONCAT_WS(' ', first_name, last_name) AS name
FROM 
	users u2 
WHERE 
	id = (
		SELECT 
			from_user_id
		FROM (
			SELECT 
				from_user_id
				,COUNT(from_user_id) AS number
			FROM (
				SELECT 
					from_user_id 
				FROM 
					messages 
				WHERE 
					to_user_id = 15
				UNION ALL 
				SELECT 
					to_user_id 
				FROM 
					messages 
				WHERE 
					from_user_id = 15) t2
GROUP BY
	from_user_id
ORDER BY 
	number DESC 
limit 1) ti
);

+----+--------------+
| id | name         |
+----+--------------+
| 14 | Andre Murray |
+----+--------------+
1 row in set (0.00 sec)

3. /* Подсчитать общее количество лайков, которые получили самые молодые пользователи.
Не совсем понятно условие: общее количество лайков, выраженное в одной цифре или общее количество лайков по всем сущностям, которые можно оценить? Решить задачу
с подсчетом лайков по всем сущностям я не смогла, потому что не могу найти способ объединения с учетом того, что между таблицей с реакциями на сущность и id пользователя
есть еще одна таблица с самой сущностью. Сделала подсчет лайков 10 самых молодых пользователей на посты. */

-- Рассмотрим частями. Найдем 10 самых молодых пользователей:

SELECT 
	user_id
	,birthday
FROM 
	profiles p 
ORDER by 
	birthday DESC
LIMIT 10;

+---------+------------+
| user_id | birthday   |
+---------+------------+
|      11 | 2019-01-30 |
|      98 | 2018-10-04 |
|      82 | 2017-12-11 |
|      81 | 2017-11-29 |
|      94 | 2017-11-26 |
|      54 | 2017-08-10 |
|      60 | 2017-03-11 |
|      44 | 2016-02-07 |
|      84 | 2016-01-06 |
|      95 | 2015-09-13 |
+---------+------------+
10 rows in set (0.00 sec)

-- С такими датами рождения они, конечно, не смогли бы стать пользователями соц.сети, но опустим этот момент.

-- Найдем id постов, которые принадлежат этим пользователям:

SELECT 
	id
FROM 
	posts p 
WHERE 
	user_id IN (
	SELECT
		user_id 
	FROM (
		SELECT 
			user_id
			,birthday
		FROM 
			profiles p 
		ORDER by 
			birthday DESC
		LIMIT 10) t1
	)	
;

+-----+
| id  |
+-----+
|  11 |
| 111 |
|  98 |
|  82 |
|  81 |
|  94 |
|  54 |
|  60 |
|  44 |
| 144 |
|  84 |
|  95 |
+-----+
12 rows in set (0.00 sec)

-- У 10 пользователей 12 постов. Подтянем количество лайков по постам.

SELECT 
	post_id
	,COUNT(post_id) AS number_of_likes
FROM 
	posts_reactions pr 
WHERE
	post_id IN (
	SELECT 
		id
	FROM 
		posts p 
	WHERE 
		user_id IN (
		SELECT 
			user_id 
		FROM (
			SELECT 
				user_id
				,birthday
			FROM 
				profiles p 
			ORDER by 
				birthday DESC
			LIMIT 10) t1
			)
		)
AND 
	reaction_type_id = 1
GROUP BY 
	post_id 
;

+---------+-----------------+
| post_id | number_of_likes |
+---------+-----------------+
|      11 |               2 |
|     111 |               1 |
|      81 |               1 |
|      95 |               1 |
+---------+-----------------+
4 rows in set (0.00 sec)

-- Или если одной цифрой:

SELECT 
	COUNT(*) AS number_of_likes
FROM 
	posts_reactions pr 
WHERE
	post_id IN (
	SELECT 
		id
	FROM 
		posts p 
	WHERE 
		user_id IN (
		SELECT 
			user_id 
		FROM (
			SELECT 
				user_id
				,birthday
			FROM 
				profiles p 
			ORDER by 
				birthday DESC
			LIMIT 10) t1
			)
		)
AND 
	reaction_type_id = 1
;

+-----------------+
| number_of_likes |
+-----------------+
|               5 |
+-----------------+
1 row in set (0.00 sec)

-- Получается, что посты 10 самых молодых пользователей соц.сети было поставлено всего 5 лайков.

4. /* Определить, кто больше поставил лайков (всего) - мужчины или женщины.
В данной БД лайки реализованы для таких сущностей, как посты, медиа и комментарии к постам. Так же в базе пол введен, как 1 и 2. Я не стала менять,
поэтому примем, что 1 - мужчины, 2 - женщины. */

SELECT 
	gender
	,COUNT(gender) AS number_of_reactions
FROM
	profiles p2 
WHERE
	user_id IN (
	SELECT 
		from_user_id 
	FROM
		media_reactions mr 
	WHERE
		reaction_type_id =1
	UNION
	SELECT 
		from_user_id 
	FROM
		posts_reactions pr 
	WHERE
		reaction_type_id =1
	UNION
	SELECT
		from_user_id 
	FROM
		post_comments_reactions pcr 
	WHERE
		reaction_type_id =1)
GROUP BY gender;

+--------+---------------------+
| gender | number_of_reactions |
+--------+---------------------+
| 1      |                  27 |
| 2      |                  23 |
+--------+---------------------+
2 rows in set (0.00 sec)

-- Получается, что больше поставили лайков мужчины.

5. /* Найти 10 пользователей, которые проявляют наименьшую активность.
В качестве активности в соц.сети были взяты: проставленные реакции на посты, комментарии, медиа, написанные и полученные сообщения, размещенные посты.
В выдаче все пользователи имеют одинаковое количество "активностей". Это связано с тем, что практически во всех указанных таблицах количество записей кратно количеству
пользователей. */

SELECT
	from_user_id AS user
	,COUNT(from_user_id) AS activity
FROM
	(SELECT 
	 	from_user_id 
	 FROM 
	 	media_reactions mr 
	UNION ALL
	SELECT 
	 	from_user_id 
	FROM 
	 	messages m 
	UNION ALL
	SELECT 
	 	to_user_id 
	FROM 
	 	messages m2 
	UNION ALL
	SELECT 
	 	from_user_id 
	FROM 
	 	post_comments_reactions pcr 
	UNION ALL
	SELECT 
	 	user_id 
	FROM 
	 	posts p 
	UNION ALL
	SELECT 
	 	user_id 
	FROM 
	 	posts_comments pc 
	UNION ALL
	SELECT 
	 	from_user_id 
	FROM 
	 	posts_reactions pr) t1
GROUP BY user
ORDER BY activity
LIMIT 10;
+------+----------+
| user | activity |
+------+----------+
|   53 |        6 |
|   52 |        6 |
|   54 |        6 |
|   59 |        6 |
|  100 |        6 |
|   51 |        6 |
|   56 |        6 |
|   58 |        6 |
|   57 |        6 |
|   60 |        6 |
+------+----------+
10 rows in set (0.01 sec)

 -- Для большей наглядности производимой сортировки приведу пользователей с наибольшей активностью.
 
SELECT
	from_user_id AS user
	,COUNT(from_user_id) AS activity
FROM
	(SELECT 
	 	from_user_id 
	 FROM 
	 	media_reactions mr 
	UNION ALL
	SELECT 
	 	from_user_id 
	FROM 
	 	messages m 
	UNION ALL
	SELECT 
	 	to_user_id 
	FROM 
	 	messages m2 
	UNION ALL
	SELECT 
	 	from_user_id 
	FROM 
	 	post_comments_reactions pcr 
	UNION ALL
	SELECT 
	 	user_id 
	FROM 
	 	posts p 
	UNION ALL
	SELECT 
	 	user_id 
	FROM 
	 	posts_comments pc 
	UNION ALL
	SELECT 
	 	from_user_id 
	FROM 
	 	posts_reactions pr) t1
GROUP BY user
ORDER BY activity DESC
LIMIT 10; 

+------+----------+
| user | activity |
+------+----------+
|   15 |       29 |
|   14 |       19 |
|    3 |       17 |
|    4 |       17 |
|   11 |       16 |
|   13 |       15 |
|    9 |       15 |
|    1 |       14 |
|    5 |       14 |
|    8 |       14 |
+------+----------+
10 rows in set (0.00 sec)




