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

/*данные по кол-ву уникальных покупателей и выручке, которую они принесли*/
WITH info AS (
    SELECT
        s.sale_date,
        s.customer_id,
        s.quantity,
        p.price
    FROM sales AS s
    LEFT JOIN customers AS c ON s.customer_id = c.customer_id
    LEFT JOIN products AS p ON s.product_id = p.product_id
)

SELECT
    TO_CHAR(sale_date, 'YYYY-MM') AS date,
    COUNT(DISTINCT customer_id) AS total_customers,
    FLOOR(SUM(quantity * price)) AS income
FROM info
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY date;

/* покупатели с 1-ой покупкой во время акции*/
WITH first_buy AS (
    SELECT
        s.customer_id,
        MIN(s.sale_date) AS first_sale_date
    FROM sales AS s
    INNER JOIN products AS p ON s.product_id = p.product_id
    WHERE p.price = 0
    GROUP BY s.customer_id
)

SELECT
    s.sale_date,
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    CONCAT(e.first_name, ' ', e.last_name) AS seller
FROM first_buy AS fb
INNER JOIN
    sales AS s
    ON fb.customer_id = s.customer_id AND fb.first_sale_date = s.sale_date
INNER JOIN products AS p ON s.product_id = p.product_id AND p.price = 0
INNER JOIN customers AS c ON fb.customer_id = c.customer_id
INNER JOIN employees AS e ON s.sales_person_id = e.employee_id
ORDER BY fb.customer_id;



