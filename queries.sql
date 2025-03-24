/* общее кол-во покупателей в таблице customers*/
SELECT COUNT(DISTINCT customer_id) AS customers_count
FROM customers;

/* данные продавца, суммарной выручки с проданных товаров
и количество проведенных сделок*/
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

/* инфо о продавцах, чья средняя выручка за сделку < средней выручки за сделку по всем продавцам.*/
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

/*инфа о выручке по дням недели. содержит имя,фамилию продавца, день недели и суммарную выручку*/
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

/*кол-во покупателей в разных возрастных группах*/
SELECT
    CASE
        WHEN age BETWEEN 16 AND 25 THEN '16-25'
        WHEN age BETWEEN 26 AND 40 THEN '26-40'
        ELSE '40+'
    END AS age_category,
    COUNT(*) AS age_count
FROM
    customers
GROUP BY
    age_category
ORDER BY
    age_category;


