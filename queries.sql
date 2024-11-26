-- Business Problems
-- Finding different payment methods and number of transactions, number of qty sold.
SELECT DISTINCT payment_method, 
	   COUNT(*) AS numbers_of_transactions,
	   SUM(quantity) AS quantity_sold
FROM walmart
GROUP BY payment_method
ORDER BY COUNT(*) DESC;

-- Identifying the highest-rated category in each branch, displaying the branch, category and average rating.
WITH cte AS (SELECT branch,
	   category,
	   ROUND(AVG(rating)::NUMERIC, 2) AS avg_rating,
	   RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rnk
FROM walmart
GROUP BY branch, category)

SELECT branch, 
	   category, 
	   avg_rating
FROM cte
WHERE rnk = 1;

-- Determining each city's average, minimum, and maximum category rating. 
SELECT 
	city,
	category,
	MIN(rating) as min_rating,
	MAX(rating) as max_rating,
	ROUND(AVG(rating)::NUMERIC, 2) as avg_rating
FROM walmart
GROUP BY 1, 2
ORDER BY city;

-- Calculating the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
SELECT 
	category,
	ROUND(SUM(total)::NUMERIC, 2) as total_revenue,
	ROUND(SUM(total * profit_margin)::NUMERIC, 2) as profit
FROM walmart
GROUP BY 1;

-- Determine the most common payment method for each Branch. 
WITH cte AS (SELECT branch, 
	   payment_method, 
	   COUNT(*),
	   RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
FROM walmart
GROUP BY branch, payment_method)

SELECT branch, 
	   payment_method, 
	   count
FROM cte
WHERE rnk = 1
ORDER BY branch;

SELECT * FROM walmart;

-- Identify 5 branches with the highest decrease ratio in revenue compared to last year.
WITH revenue_2022 AS (
    SELECT branch,
           SUM(total) AS revenue
    FROM walmart
    WHERE EXTRACT(YEAR FROM date) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT branch,
           SUM(total) AS revenue
    FROM walmart
    WHERE EXTRACT(YEAR FROM date) = 2023
    GROUP BY branch
)
SELECT 
    ls.branch,
    ls.revenue as last_year_revenue,
    cs.revenue as cr_year_revenue,
    ROUND(
        (ls.revenue - cs.revenue)::numeric/
        ls.revenue::numeric * 100, 
        2) as rev_dec_ratio
FROM revenue_2022 as ls
JOIN revenue_2023 as cs
ON ls.branch = cs.branch
WHERE 
    ls.revenue > cs.revenue
ORDER BY rev_dec_ratio DESC
LIMIT 5;