-- Для таблицы измерений с датами можно взять значения из таблицы фактов. 
-- Но можно сгенерировать набор дат.
-- Например, видел вот такое решение. Тут берётся сегодняшний день и интервал в 10 лет назад

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
