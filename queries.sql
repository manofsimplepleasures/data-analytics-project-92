
customers_count.csv

SELECT COUNT(*) AS customers_count FROM customers;
общее кол-во покупателей в таблице customers

top_10_total_income.csv

SELECT CONCAT(first_name,' ',last_name) as seller,
склеивает имя, пробел, фамилия и выводит как seller

COUNT(sales.sales_id) AS operations,
считает продажи по id и выводит как operations

FLOOR(SUM(p.price * sales.quantity)) AS income
умножает стоимость продукта на количество продаж, суммирует и округляет до целого числа 
и выводит как income
    
JOIN employees e  ON sales.sales_person_id = e.employee_id 
соединяет таблицу sales с таблицей employees,
связывая sales.sales_person_id с employees.employee_id

JOIN products p ON sales.product_id = p.product_id
соединяет таблицу sales с таблицей products,
связывая sales.sproduct_id с products.product_id

GROUP BY seller
Группирует данные по продавцу

ORDER BY income desc
cортирует результат по убыванию DESC колонки income (общая сумма выручки продавца)

LIMIT 10;
ограничивает результат 10 строками 