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



-- Посмотреть ещё на такой код потом:

select 
to_char(date,'yyyymmdd')::int as date_id,  
       extract('year' from date)::int as year,
       extract('quarter' from date)::int as quarter,
       extract('month' from date)::int as month,
       extract('week' from date)::int as week,
       date::date,
       to_char(date, 'dy') as week_day,
       extract('day' from
               (date + interval '2 month - 1 day')
              ) = 29
       as leap
  from generate_series(date '2000-01-01',
                       date '2030-01-01',
                       interval '1 day')
       as t(date);
--checking



-- https://habr.com/ru/articles/421969/
/* Вводим что-то типа переменных, чтобы в едином месте можно было вводить входные данные, когда нет возможности использовать параметры */
with dates as (
   select '2018-01-31'::date as dt1, '2018-05-31'::date as dt2 
),
/* Вычисляем разницу между датами в "иерархических" единицах */
g_age as (
   select age( (select dt2 from dates), (select dt1 from dates))
),
/* Считаем сколько месяцев в полученной разнице (годы*12 + месяцы) и добавляем +1 месяц на возможную потерю при округлении  */
months as (
   select (extract(year from (select * from g_age))*12 + 
     extract(month from (select * from g_age))+1)::integer
),
/* Количество посчитано, генерируем последовательность и добавляем проверку на выход из первоначального диапазона из-за возможного лишнего месяца, который мы добавили как корректировку округления */

seq as(
 select ((select dt1 from dates) + make_interval(0, gs)) as gs
 from  generate_series (
     0,
     (select * from months),
     1
 ) as gs 
 where ((select dt1 from dates) + make_interval(0, gs)) <= (select dt2 from dates)
)
/* Ну и собственно смотрим что у нас получилось */
select * from seq
;

