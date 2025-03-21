/* считает общее количество покупателей в таблице customers*/
SELECT COUNT(DISTINCT customer_id) AS customers_count
FROM customers;

/* выводит данные продавца, суммарной выручки с проданных товаров
и количество проведенных сделок.Сортирует по убыванию выручки*/
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS seller,
    COUNT(s.sales_id) AS operations,
    FLOOR(SUM(p.price * s.quantity)) AS income
FROM
    sales AS s
INNER JOIN
    employees AS e ON s.sales_person_id = e.employee_id
INNER JOIN
    products AS p ON s.product_id = p.product_id
GROUP BY
    e.first_name, e.last_name
ORDER BY
    income DESC
LIMIT 10;

/* выводит данные инфy о продавцах, чья средняя выручка за сделку < средней выручки за сделку по всем продавцам.
 сортирует по выручке, по возрастанию.*/
WITH seller_avg_income AS (
    SELECT
        CONCAT(e.first_name, ' ', e.last_name) AS seller,
        FLOOR(SUM(p.price * s.quantity) / COUNT(s.sales_id)) AS average_income
    FROM sales AS s
    INNER JOIN employees AS e ON s.sales_person_id = e.employee_id
    INNER JOIN products AS p ON s.product_id = p.product_id
    GROUP BY seller
),

overall_avg_income AS (
    SELECT FLOOR(AVG(average_income)) AS avg_income FROM seller_avg_income
)

SELECT
    seller_avg_income.seller,
    seller_avg_income.average_income
FROM seller_avg_income
INNER JOIN
    overall_avg_income
    ON seller_avg_income.average_income < overall_avg_income.avg_income
ORDER BY seller_avg_income.average_income ASC;

/*выводит инфу о выручке по дням недели. содержит имя,фамилию продавца, день недели и суммарную выручку. 
 сортирует данные по порядковому номеру дня недели и seller*/
WITH seller_income AS (
    SELECT
        CONCAT(e.first_name, ' ', e.last_name) AS seller,
        FLOOR(SUM(p.price * s.quantity)) AS income,
        TO_CHAR(s.sale_date, 'ID') AS day_number,
        TO_CHAR(s.sale_date, 'Day') AS day_of_week
    FROM sales AS s
    INNER JOIN employees AS e ON s.sales_person_id = e.employee_id
    INNER JOIN products AS p ON s.product_id = p.product_id
    GROUP BY seller, sale_date
)

SELECT
    seller,
    day_of_week,
    income
FROM seller_income
GROUP BY seller, day_of_week, day_number, income
ORDER BY day_number, income;

