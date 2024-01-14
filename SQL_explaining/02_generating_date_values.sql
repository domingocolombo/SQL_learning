-- Для таблицы измерений с датами можно взять значения из таблицы фактов. 
-- Но можно сгенерировать набор дат.
-- Например, видел вот такое решение. Тут берётся сегодняшний день и интервал в 10 лет назад

--Разбор можно почитать тут https://habr.com/ru/articles/421969/

-- ************************************** calendar_test
DROP TABLE IF EXISTS calendar_test CASCADE;
CREATE TABLE IF NOT EXISTS calendar_test
(
 order_date date NOT NULL
);

--clean table
truncate table calendar_test;

INSERT INTO calendar_test (order_date)
VALUES (
DATE(generate_series(DATE(NOW()) - INTERVAL '10 year', DATE(NOW()), INTERVAL '1 day'))
);


-- Вариант 2. Заливка диапазона в 1 год от min и max значений в таблице фактов
-- Пока не разобрался. Например. была ошибка "функции, возвращающие множества, нельзя применять в конструкции VALUES"

select
	all_dates.*
 FROM
(
select
	generate_series(
	'2000-01-01'::date,
	DATE(NOW()),
--		DATE(NOW()) - INTERVAL '20 year',
--		DATE(NOW()),
		INTERVAL '1 day'
	) date_column
) all_dates
join
(
	select
		min(order_date)::date - INTERVAL '1 year' as min_date,
		max(order_date)::date + INTERVAL '1 year' as max_date
	from orders 
) min_max
on all_dates.date_column >= min_max.min_date and all_dates.date_column <= min_max.max_date
;
