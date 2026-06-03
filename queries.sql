-- =========================
-- 1–10: SELECT / WHERE
-- =========================

-- 1. Барлық тауарлар
SELECT * FROM products;

-- 2. Барлық категориялар
SELECT * FROM categories;

-- 3. Ең қымбат тауар
SELECT * FROM products ORDER BY price DESC LIMIT 1;

-- 4. Ең арзан тауар
SELECT * FROM products ORDER BY price ASC LIMIT 1;

-- 5. 50000-нан қымбат тауарлар
SELECT * FROM products WHERE price > 50000;

-- 6. Алғашқы 10 сатылым
SELECT * FROM sales ORDER BY sale_date ASC LIMIT 10;

-- 7. quantity > 3 сатылымдар
SELECT * FROM sales WHERE quantity > 3;

-- 8. 100000-нан асатын чектер
SELECT * FROM sales WHERE total_amount > 100000;

-- 9. "Книга" бар тауарлар
SELECT * FROM products WHERE name ILIKE '%Книга%';

-- 10. Белгілі күндегі сатылымдар
SELECT * FROM sales WHERE DATE(sale_date) = '2023-05-15';


-- =========================
-- 11–17: Агрегация
-- =========================

-- 11. Санат саны
SELECT COUNT(*) FROM categories;

-- 12. Тауар саны
SELECT COUNT(*) FROM products;

-- 13. Орташа баға
SELECT AVG(price) FROM products;

-- 14. Жалпы түсім
SELECT SUM(total_amount) FROM sales;

-- 15. Ең үлкен чек
SELECT MAX(total_amount) FROM sales;

-- 16. Ең кіші чек
SELECT MIN(total_amount) FROM sales;

-- 17. Жалпы сатылған өнім саны
SELECT SUM(quantity) FROM sales;


-- =========================
-- 18–22: GROUP BY
-- =========================

-- 18. Өнім бойынша сатылым саны
SELECT product_id, SUM(quantity)
FROM sales
GROUP BY product_id;

-- 19. Өнім бойынша түсім
SELECT product_id, SUM(total_amount)
FROM sales
GROUP BY product_id;

-- 20. 1 000 000+ түсім өнімдер
SELECT product_id
FROM sales
GROUP BY product_id
HAVING SUM(total_amount) > 1000000;

-- 21. Күн бойынша сатылым
SELECT DATE(sale_date), COUNT(*)
FROM sales
GROUP BY DATE(sale_date);

-- 22. Ең көп түсім болған күн
SELECT DATE(sale_date), SUM(total_amount)
FROM sales
GROUP BY DATE(sale_date)
ORDER BY SUM(total_amount) DESC
LIMIT 1;


-- =========================
-- 23–28: JOIN
-- =========================

-- 23. Өнім + категория
SELECT p.name AS product, c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.category_id;

-- 24. Сатылым + өнім аты
SELECT s.sale_id, p.name, s.total_amount
FROM sales s
JOIN products p ON s.product_id = p.product_id;

-- 25. Категория бойынша түсім
SELECT c.name, SUM(s.total_amount)
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name;

-- 26. Ең жоғары орташа чек категория
SELECT c.name, AVG(s.total_amount)
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name
ORDER BY AVG(s.total_amount) DESC
LIMIT 1;

-- 27. Толық сатылым ақпарат
SELECT s.sale_date, p.name, c.name, s.total_amount
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id;

-- 28. Ешқашан сатылмаған тауарлар
SELECT p.name
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.product_id IS NULL;


-- =========================
-- 29–30: Subquery / Complex
-- =========================

-- 29. Орташа бағадан қымбат тауарлар
SELECT *
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- 30. TOP-3 ең көп сатылған өнім
SELECT p.name, c.name AS category, SUM(s.total_amount) AS total_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY p.name, c.name
ORDER BY total_sales DESC
LIMIT 3;