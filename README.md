# SQL_learning
Практика по SQL

## Разборы

### 01. MAX_BY реализация в Postgres
В случаях когда в исходнике есть у одного т.н. уникального значения есть связанные с ним не уникальные значения
Например, у 1 id товара несколько названий товаров.

По функции MAX_BY можно попробовать достать последнее (по времени) значение у названия товара и его поставлять в таблицу измерений
В документации Postgres нет такой функции и я проверил несколько вариантов как сделать аналогичное решение
https://github.com/domingocolombo/SQL_learning/blob/main/SQL_explaining/01_max_by_analogues.sql


### 02. Интервал в датах.
Для таблицы измерений с датами можно взять значения из таблицы фактов. 
Но можно сгенерировать набор дат.
Например, видел вот такое решение. Тут берётся сегодняшний день и интервал в 10 лет назад 
https://github.com/domingocolombo/SQL_learning/blob/main/SQL_explaining/02_generating_date_values.sql

Честно говоря, пытался в качестве аргументов брать min и max даты из orders но так и не разобрался как это сделать. В итоге, решил просто через JOIN отсечь лишнее

Разбор можно почитать тут https://habr.com/ru/articles/421969/

Ещё вот тут есть обучение
https://www.timescale.com/blog/how-to-create-lots-of-sample-time-series-data-with-postgresql-generate_series/

и ссылка на видео https://www.youtube.com/watch?v=t5ULlC1MYWU

https://github.com/domingocolombo/SQL_learning/blob/main/SQL_explaining/02_generating_date_values.sql
