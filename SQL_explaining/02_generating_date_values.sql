-- Для таблицы измерений с датами можно взять значения из таблицы фактов. 
-- Но можно сгенерировать набор дат.
-- Например, видел вот такое решение:

-- ************************************** calendar_dim
DROP TABLE IF EXISTS calendar_test CASCADE;
CREATE TABLE IF NOT EXISTS calendar_test
(
 order_date date NOT NULL,
);

INSERT INTO calendar (order_date)
VALUES (
DATE(generate_series(DATE(NOW()) - INTERVAL '10 year', DATE(NOW()), INTERVAL '1 day'))
);
