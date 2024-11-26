# Walmart-Sales-Analysis

## Project Overview

![Project Pipeline](https://github.com/dsmohiit/Walmart-Sales-Analysis/blob/main/Blank%20diagram.png)


This project is an end-to-end data analysis solution designed to extract critical business insights from Walmart sales data. We utilize Python for data processing and analysis, SQL for advanced querying, and structured problem-solving techniques to solve key business questions. The project is ideal for data analysts looking to develop skills in data manipulation, SQL querying, and data pipeline creation.

---

## Project Steps

### 1. Set Up the Environment
   - **Tools Used**: Visual Studio Code (VS Code), Python, SQL (PostgreSQL)
   - **Goal**: To create a structured workspace within VS Code and organize project folders for smooth development and data handling.

### 2. Set Up Kaggle API
   - **API Setup**: Obtain your Kaggle API token from [Kaggle](https://www.kaggle.com/) by navigating to your profile settings and downloading the JSON file.
   - **Configure Kaggle**: 
      - Place the downloaded `kaggle.json` file in your local `.kaggle` folder.
      - Use the command `kaggle datasets download -d <dataset-path>` to pull datasets directly into your project.

### 3. Download Walmart Sales Data
   - **Data Source**: Use the Kaggle API to download the Walmart sales datasets from Kaggle.
   - **Dataset Link**: [Walmart Sales Dataset](https://www.kaggle.com/najir0123/walmart-10k-sales-datasets)

### 4. Install Required Libraries and Load Data
   - **Libraries**: Install necessary Python libraries using:
     ```bash
     pip install pandas numpy sqlalchemy mysql-connector-python psycopg2
     ```
   - **Loading Data**: Read the data into a Pandas DataFrame for initial analysis and transformations.

### 5. Explore the Data
   - **Goal**: Conducting an initial data exploration to understand data distribution, check column names, types, and identify potential issues.
   - **Analysis**: Using functions like `.info()`, `.describe()`, and `.head()` to get a quick overview of the data structure and statistics.

### 6. Data Cleaning
   - **Removing Duplicates**: Identify and remove duplicate entries to avoid skewed results.
   - **Handling Missing Values**: Drop rows or columns with missing values if they are insignificant; fill values where essential.
   - **Fixing Data Types**: Ensure all columns have consistent data types (e.g., dates as `datetime`, prices as `float`).
   - **Currency Formatting**: Using `.replace()` to handle and format currency values for analysis.
   - **Validation**: Check for any remaining inconsistencies and verify the cleaned data.

### 7. Feature Engineering
   - **Creating New Columns**: Calculating the `total` for each transaction by multiplying `unit_price` by `quantity` and adding this as a new column, `time_period` for time analysis etc.
   - **Enhancing Dataset**: Adding this calculated field will streamline further SQL analysis and aggregation tasks.

### 8. Load Data into PostgreSQL
   - **Set Up Connections**: Connecting to PostgreSQL using `sqlalchemy` and load the cleaned data into each database.
   - **Table Creation**: Set up tables in PostgreSQL using Python `psysopg2` and `sqlalchemy` to automate table creation and data insertion.
   - **Verification**: Runing initial SQL queries to confirm that the data has been loaded accurately.

### 9. SQL Analysis: Complex Queries and Business Problem Solving
   - **Business Problem-Solving**: Write and execute complex SQL queries to answer critical business questions, such as:
     - Revenue trends across branches and categories.
     - Identifying best-selling product categories.
     - Sales performance by time, city, and payment method.
     - Analyzing peak sales periods and customer buying patterns.
     - Profit margin analysis by branch and category.
```sql
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
```

---

## Requirements

- **Python 3.8+**
- **SQL Databases**: MySQL or PostgreSQL
- **Python Libraries**:
  - `pandas`, `numpy`, `sqlalchemy`, `mysql-connector-python`, `psycopg2`, `matplotlib`, `seaborn`
- **Kaggle API Key** (for data downloading)


## Project Structure

```plaintext
|-- data/                     # Raw data and transformed data
|-- sql_queries/              # SQL scripts for analysis and queries
|-- project.ipynb/                # Jupyter notebooks for Python analysis
|-- README.md                 # Project documentation
|-- requirements.txt          # List of required Python libraries
|-- main.py                   # Main script for loading, cleaning, and processing data
```

---

## License

This project is licensed under the MIT License. 

---

## Acknowledgments

- **Data Source**: Kaggle’s Walmart Sales Dataset
- **Inspiration**: Walmart’s business case studies on sales and supply chain optimization.

---
