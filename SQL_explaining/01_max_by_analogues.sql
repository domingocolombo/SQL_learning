-- В случаях когда в исходнике есть у одного т.н. уникального значения есть связанные с ним не уникальные значения
-- Например, у 1 id товара несколько названий товаров


-- Вариант 1. Генерация словаря product_id и максимального значения order_date и потом JOIN по этому значению
-- 1862 строки
-- Execution Time: 21.112 ms
-- EXPLAIN ANALYZE 
select count(*) from
(
select
distinct
	o.product_id,
	o.product_name 
FROM orders o
join
	(
		SELECT
			product_id,
			MAX(order_date) as order_date_max 
		FROM orders o
		
		GROUP BY 
			product_id
	) m
on o.product_id = m.product_id and o.order_date = m.order_date_max
--where o.product_id = 'FUR-BO-10002213'
)
;

-- Вариант 2. То же самое, только с применением коррелирующего подзапроса 
-- 1862 строки
-- Тот же result, что и в 1 раз, только дольше гораздо считался 
--(Execution Time: 48744.822 ms)
--EXPLAIN ANALYZE 
--select count(*) from
--(
select
distinct
	o.product_id,
	o.product_name
FROM orders o
  where true
--and o.product_id = 'FUR-BO-10002213'
  and o.order_date = 
	(select MAX(order_date)
	from orders o2
	where o.product_id = o2.product_id 
	) 
--)
;

-- 3 вариант с FIRST_VALUE (с LAST_VALUE сложнее)
-- 1862 строки
-- Execution Time: 61.767 ms
EXPLAIN ANALYZE 
--select count(*) from
--(
SELECT
	distinct product_id,
	FIRST_VALUE(product_name)
	OVER(
	partition by product_id 
	order by order_date DESC
	) as product_name_order_date_max
FROM 
orders
--)
--where product_id = 'FUR-BO-10002213'
;


-- 4 вариант с LAST_VALUE
-- 1862 строки
-- Execution Time: 53.612 ms
-- Тут надо обязательно указать RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
-- подробнее можно прочитать тут: http://www.sql-tutorial.ru/ru/book_first_value_and_last_value_functions.html
EXPLAIN ANALYZE 
--select count(*) from
--(
SELECT
	distinct product_id,
	LAST_VALUE(product_name)
	OVER(
	partition by product_id 
	order by order_date
	RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
	) as product_name_order_date_max
FROM 
orders
--)
--where product_id = 'FUR-BO-10002213'
;
