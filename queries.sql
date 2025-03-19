customers_count.csv

	SELECT COUNT(*) AS customers_count FROM customers;
	общее кол-во покупателей в таблице customers
	
	
Анализ отдела продаж:
	
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

	
lowest_average_income

	Общее кол-во сделок на продавца
	SELECT sales_person_id, COUNT(sales_id) AS total_deals
	FROM sales
	GROUP BY sales_person_id;

	Общий доход на продавца
	SELECT 
    s.sales_person_id,
    SUM(p.price * s.quantity) AS total_income
	FROM sales s
	JOIN products p ON s.product_id = p.product_id
	GROUP BY s.sales_person_id;

	Средняя выручка за сделку /продавца
	SELECT 
	    s.sales_person_id,
	    FLOOR(SUM(p.price * s.quantity) / COUNT(s.sales_id)) AS average_income
	FROM sales s
	JOIN products p ON s.product_id = p.product_id
	GROUP BY s.sales_person_id;

	Подтягиваю «Имя», « », «Фамилия» продавцов
	SELECT 
	    CONCAT(e.first_name, ' ', e.last_name) AS seller,
	    FLOOR(SUM(p.price * s.quantity) / COUNT(s.sale_id)) AS average_income
	FROM sales s
	JOIN employees e ON s.sales_person_id = e.employee_id
	JOIN products p ON s.product_id = p.product_id
	GROUP BY seller;
	
	Запрос WITH overall_avg_income, чтобы вычислить среднюю выручку всех продавцов. 
	И выяснить, чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам:
	WITH seller_avg_income AS 
		(SELECT 
	        CONCAT(e.first_name, ' ', e.last_name) AS seller,
	        FLOOR(SUM(p.price * s.quantity) / COUNT(s.sales_id)) AS average_income
	    FROM sales s
	    JOIN employees e ON s.sales_person_id = e.employee_id
	    JOIN products p ON s.product_id = p.product_id
	    GROUP BY seller),
		overall_avg_income AS 
		(SELECT FLOOR(AVG(average_income)) AS avg_income FROM seller_avg_income)
	SELECT seller_avg_income.seller, seller_avg_income.average_income
	FROM seller_avg_income 
	JOIN overall_avg_income ON seller_avg_income.average_income < overall_avg_income.avg_income
	ORDER BY seller_avg_income.average_income ASC;	