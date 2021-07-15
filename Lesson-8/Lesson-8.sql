/* Из всех друзей пользователя найдите того, кто больше всех общался с ним. 
1. В запросе на вебинаре используется два JOINа. Мне не очень понятно использование первого, ведь в таблице friendship уже есть user_id, зачем присоединять его 
из таблицы users?
2. Не могу понять, почему, но у меня не срабавтывает функция MAX, как в запросе на вебинаре. Собственно, в прошлый раз я тоже не смогла написать запрос с этой функцией,
поэтому реализовала через сортировку и выборку первого значения. В этот раз я оставила так же. В моем случае функция MAX возвращает весь список. Подскажите, пожалуйста,
в чем проблема. Привожу мой запрос:
SELECT
	t3.friend_id
	,MAX(t3.number_of_messages) 
FROM (
		SELECT 
			t2.friend_id
			,COUNT(t2.id) AS number_of_messages
		FROM (
			SELECT 
				f.friend_id
				,m.id 
			FROM 
				friendship f 
			LEFT JOIN messages m ON (
				f.user_id = m.to_user_id 
				AND f.friend_id = m.from_user_id)
			WHERE f.user_id = 15
			UNION
			SELECT 
				f.user_id
				,m.id 
			FROM 
				friendship f 
			LEFT JOIN messages m ON (
				f.user_id = m.to_user_id 
				AND f.friend_id = m.from_user_id)
			WHERE 
				f.friend_id = 15
			) t2
		GROUP BY 
			t2.friend_id
		) t3
GROUP BY 
	t3.friend_id
;

3. В своем запросе я добавила выборку сообщений как от изначального пользователя (id=15) друзьям, так и ему от друзей, потому что размер диалога зависит и от того,
что написали ему в ответ.
*/

SELECT 
	id
	,CONCAT_WS(' ', first_name, last_name) AS name
FROM 
	users u2 
WHERE 
	id = (SELECT t1.friend_id 
		  FROM (
			SELECT 
				t2.friend_id
				,SUM(number_of_messages) AS messages
			FROM (
				SELECT 
					f.friend_id
					,COUNT(m.id) AS number_of_messages 
				FROM 
					friendship f 
				LEFT JOIN 
					messages m ON (
					f.user_id = m.to_user_id 
					AND f.friend_id = m.from_user_id)
				WHERE 
					f.user_id = 15
				GROUP BY 
					f.friend_id 
				UNION
				SELECT 
					f.user_id
					,count(m.id) 
				FROM 
					friendship f 
				LEFT JOIN 
					messages m ON (
					f.user_id = m.to_user_id 
					AND f.friend_id = m.from_user_id)
				WHERE 
					f.friend_id = 15
				GROUP BY 
				f.user_id
				) t2
			GROUP BY 
				t2.friend_id
			ORDER BY 
				messages DESC 
			LIMIT 1
			) t1
)
;

id|name        |
--|------------|
14|Andre Murray|

-- Ответ совпадает с ответом на запрос без JOIN.

2. /* Посчитать количество лайков, которые получили 10 самых молодых пользователей.
Добавила проверку на тип реакции, потоому что в таблице есть и дизлайки тоже. */

SELECT 
	p.user_id 
	,COUNT(reaction_type_id) AS likes 
FROM 
		(SELECT 
			user_id 
		FROM 
			profiles pr 
		ORDER BY 
			birthday DESC 
		LIMIT 10) youngest
		LEFT JOIN 
			posts p ON (
			youngest.user_id = p.user_id
			)
	 	LEFT JOIN 
		 	posts_reactions pr2 ON (
		 	pr2.post_id = p.id 
			)
WHERE reaction_type_id = 1
GROUP BY p.user_id
;

user_id|likes|
-------|-----|
     11|    3|
     81|    1|
     95|    1|

-- Ответ совпадает с ответом на запрос без JOIN.

3. /* Определить, кто больше поставил лайков - мужчины или женщины. Лайки считались по постам. Мужчины - 1, женщины - 2. Аналогичная задача в предыдущем ДЗ 
была решена неверно, запрос надо переписать. */

SELECT 
	gender
	, COUNT(gender) AS likes
FROM (
SELECT 
	pr.id
	, p.user_id 
	, p2.gender 
FROM 
	posts_reactions pr 
LEFT JOIN 
	posts p ON (
	p.id = pr.post_id 
	)
LEFT JOIN 
	profiles p2 ON (
	p2.user_id = p.user_id 
	)
WHERE 
	reaction_type_id = 1
	) t1
GROUP BY gender 
ORDER by likes DESC
LIMIT 1
;

gender|likes|
------|-----|
2     |   53|

4. /* Найти наименее активных пользователей. Выдача при таком запросе не очень показательная, потому что в конце у всех одинаковое количество постов, сообщений и тд.
Я составила запрос на самых активных пользователей и взяла в качестве показателя активности количество постов и сообщений. Чтобы получить наименее активных, надо
в конце запроса отсортировать все в прямом порядке по activity. */

SELECT 
	t1.id 
	,SUM(posts) as activity
FROM (
		SELECT 
			u.id
			,COUNT(p2.id) AS posts
		FROM
			users u 
		LEFT JOIN
			posts p2 ON (
			p2.user_id = u.id 
			)
		GROUP BY u.id 
		UNION ALL 
		SELECT 
			u2.id 
			,COUNT(m3.id) AS messages
		FROM users u2 
		LEFT JOIN 
			messages m3 ON (
			m3.from_user_id = u2.id 
			)
		GROUP BY u2.id 
		) t1
GROUP BY 
	t1.id
ORDER BY 
	activity DESC 
LIMIT 10
;

id|activity|
--|--------|
15|      10|
14|      10|
 3|       8|
 9|       7|
11|       7|
 1|       6|
 2|       6|
 5|       5|
 6|       5|
 8|       5|
 
 -- Похоже на правду, потому что пользователи с id=14, 15 активно друг с другом переписывались, это рассматривалось выше.
