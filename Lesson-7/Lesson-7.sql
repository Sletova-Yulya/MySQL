1. /* Составьте список пользователей users, 
которые осуществили хотя бы один заказ orders в интернет магазине. */

SELECT
	id
	,name
FROM
	users
WHERE 
	id IN (
    SELECT 
		user_id 
	FROM
		orders
)
;

-- Результат:

# id, name
'1', 'Геннадий'
'2', 'Наталья'
'3', 'Александр'
'4', 'Сергей'

2. /* Выведите список товаров products и разделов catalogs, который соответствует товару. */

SELECT 
	pr.id
    ,pr.name
    ,pr.price
    ,c.name
FROM 
	products pr
    ,catalogs c
WHERE 
	pr.catalog_id = c.id
;

-- Результат:

# id, name, price, name
'1', 'Intel Core i3-8100', '7890.00', 'Процессоры'
'2', 'Intel Core i5-7400', '12700.00', 'Процессоры'
'3', 'AMD FX-8320E', '4780.00', 'Процессоры'
'4', 'AMD FX-8320', '7120.00', 'Процессоры'
'5', 'ASUS ROG MAXIMUS X HERO', '19310.00', 'Материнские платы'
'6', 'Gigabyte H310M S2H', '4790.00', 'Материнские платы'
'7', 'MSI B250M GAMING PRO', '5060.00', 'Материнские платы'

3. /* Пусть имеется таблица рейсов flights (id, from, to) и таблица городов 
cities (label, name). Поля from, to и label содержат английские названия городов, 
поле name — русское. Выведите список рейсов flights с русскими названиями городов. */

  SELECT 
	flights.id
	,cities.name AS from_city
	,ct.name AS to_city
  FROM
	flights
  JOIN
	cities
  ON 
	flights.from_city = cities.label
  JOIN
	cities AS ct
  ON 
	flights.to_city = ct.label
  ORDER BY 
	flights.id
  ;
  
  -- Результат:
  
  # id, from_city, to_city
1, Москва, Омск
2, Новгород, Казань
3, Иркутск, Москва
4, Омск, Иркутск
5, Москва, Казань


