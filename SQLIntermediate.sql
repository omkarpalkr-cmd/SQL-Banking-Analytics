USE banking_db;

SELECT * FROM CUSTOMERS;

-- CASE Statements

-- Create an income category:
/*< 3 lakh      → Low
3–7 lakh      → Medium
7–15 lakh     → High
> 15 lakh     → Very High*/

SELECT 
	customer_id,
    annual_income,
    CASE
		WHEN annual_income IS NULL
			THEN 'Invalid Income'
		WHEN annual_income < 300000
			THEN 'Low'
		WHEN annual_income < 700000
			THEN 'Medium'
		WHEN annual_income <= 1500000
			THEN 'High'
		ELSE 'Very High'
	END AS income_category
FROM CUSTOMERS;

-- Categorize customers based on credit score:
/*300–579 → Poor
580–669 → Fair
670–739 → Good
740–799 → Very Good
800–900 → Excellent
*/

SELECT 
	customer_id,
	credit_score,
    CASE
		WHEN credit_score IS NULL
			THEN 'Unknown'
		WHEN credit_score BETWEEN 300 AND 579
         THEN 'Poor'
		WHEN credit_score BETWEEN 580 AND 669
         THEN 'Fair'
		WHEN credit_score BETWEEN 670 AND 739
			THEN 'Good'
		WHEN credit_score BETWEEN 740 and 799
			THEN 'Very Good'
		WHEN credit_score BETWEEN 800 AND 900
			THEN 'Excellent'
		ELSE 'Out Of Range'
	END AS credit_score_category
FROM CUSTOMERS;
                  
-- Create an EMI burden category using:
/*existing_emi / monthly_income
Classify customers as:
< 20%       → Low
20–40%      → Medium
> 40%       → High
*/

SELECT 
	customer_id,
    monthly_income,
    existing_emi,
    ROUND(existing_emi/NULLIF(monthly_income, 0)* 100,
    2
    ) AS emi_burden_pct,
    CASE
		WHEN monthly_income IS NULL OR monthly_income <= 0
			THEN 'Invalid Income'
		WHEN existing_emi IS NULL OR existing_emi < 0
			THEN 'Invalid EMI'
		WHEN existing_emi / monthly_income < 0.20
         THEN 'Low'
		WHEN existing_emi / monthly_income <= 0.40
			THEN 'Medium'
		ELSE 'High'
	END AS emi_burden_category
FROM CUSTOMERS;

-- -- Calculate each customer's total monthly income:
-- monthly_income + other_monthly_income
SELECT 
	customer_id,
    monthly_income,
    other_monthly_income,
    COALESCE(monthly_income, 0)
		+ COALESCE(other_monthly_income, 0)
        AS total_monthly_income
FROM CUSTOMERS;

-- Calculate disposable income:
-- total income - monthly expenses - existing EMI
SELECT 
    customer_id,
    COALESCE(monthly_income, 0)
        + COALESCE(other_monthly_income, 0)
        AS total_monthly_income,
    monthly_expenses,
    existing_emi,
    (
        COALESCE(monthly_income, 0)
        + COALESCE(other_monthly_income, 0)
        - COALESCE(monthly_expenses, 0)
        - COALESCE(existing_emi, 0)
    ) AS disposable_income
FROM CUSTOMERS;

-- Identify customers whose disposable income is negative.
WITH customer_finances AS (
    SELECT
        customer_id,
        COALESCE(monthly_income, 0)
            + COALESCE(other_monthly_income, 0)
            - COALESCE(monthly_expenses, 0)
            - COALESCE(existing_emi, 0)
            AS disposable_income
    FROM customers
)
SELECT
    customer_id,
    disposable_income
FROM customer_finances
WHERE disposable_income < 0;

-- Create a customer financial health category based on disposable income.
WITH customer_finances AS (
	SELECT 
		customer_id,
        COALESCE(monthly_income, 0)
            + COALESCE(other_monthly_income, 0)
            - COALESCE(monthly_expenses, 0)
            - COALESCE(existing_emi, 0)
            AS disposable_income
    FROM customers
)
SELECT 
	customer_id,
    disposable_income,
    CASE
		WHEN disposable_income < 0 
			THEN 'Financial Stress'
		WHEN disposable_income = 0
			THEN 'Break-even'
		ELSE 'Positive Surplus'
	END AS financial_health_category
FROM customer_finances;

-- Classify customers based on employment stability.
SELECT DISTINCT employment_type FROM CUSTOMERS;

SELECT 
	customer_id,
	employment_type,
    CASE
		WHEN employment_type = 'Permanent'
			THEN 'High Stability'
		WHEN employment_type = 'Self-employed'
			THEN 'Medium Stability'
		WHEN employment_type = 'Contract'
			THEN 'Medium Stability'
		WHEN employment_type IS  NULL
			THEN 'Unknown'
		ELSE 'Review Required'
	END AS employment_stability
FROM CUSTOMERS;

/*Create an age group:
18–25
26–35
36–45
46–55
56+*/

SELECT 
	customer_id,
    date_of_birth,
    TIMESTAMPDIFF(
    YEAR,
    date_of_birth,
    CURDATE()
    )AS age,
    CASE
		WHEN date_of_birth IS NULL
			THEN 'Unknown'
		WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) < 18
			THEN 'Under 18'
		WHEN TIMESTAMPDIFF(YEAR , date_of_birth, CURDATE()) <= 25
			THEN '18-25'
		WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 35 
			THEN '26-35'
		WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 45
            THEN '36-45'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 55
            THEN '46-55'
		ELSE '56+'
	END AS age_group
FROM CUSTOMERS;
    
-- Identify customers who have both high income and high credit score.
/*Assumptions:
- High income = annual income of ₹7 lakh or more.
- High credit score = 740 or above. */
SELECT
	customer_id,
    annual_income,
    credit_score
FROM CUSTOMERS
WHERE annual_income >= 700000
	AND credit_score BETWEEN 740 AND 900;

-- Identify customers who have high income but poor credit scores.
SELECT
	customer_id,
    annual_income,
    credit_score
FROM CUSTOMERS
WHERE annual_income >= 700000
	AND credit_score BETWEEN 300 AND 579;
    
-- Identify customers who have low income but excellent credit scores.
SELECT
	customer_id,
    annual_income,
    credit_score
FROM CUSTOMERS
WHERE annual_income < 300000
	AND annual_income >= 0
	AND credit_score BETWEEN 800 AND 900;
    
-- Create a risk flag using both credit_score and risk_category.
SELECT  
	customer_id,
    credit_score,
    risk_category,
    CASE	
		WHEN credit_score IS NULL
		OR risk_category IS NULL
			THEN 'Review Required'
		WHEN credit_score < 580
		OR risk_category = 'High'
			THEN 'High Risk'
		WHEN credit_score < 670
		OR risk_category = 'Medium'
			THEN 'Medium Risk'
		ELSE 'Low Risk'
	END AS risk_flag
FROM CUSTOMERS;

-- Create a KYC risk flag for customers whose KYC is Pending or Expired.
SELECT DISTINCT kyc_status FROM CUSTOMERS;
SELECT
    customer_id,
    kyc_status,
    CASE
        WHEN kyc_status IN ('Pending', 'Expired')
            THEN 'KYC Attention Required'
        WHEN kyc_status = 'Verified'
            THEN 'KYC Verified'
        WHEN kyc_status IS NULL
            THEN 'KYC Status Unknown'
        ELSE 'Review Required'
    END AS kyc_risk_flag
FROM CUSTOMERS;

-- Create a financial stress flag when:
-- monthly_expenses + existing_emi > total monthly income
WITH customer_finances AS (
SELECT 
	customer_id,
    COALESCE(monthly_income, 0)
    + COALESCE(other_monthly_income, 0)
    AS total_monthly_income,
    COALESCE(monthly_expenses, 0)
    + COALESCE(existing_emi, 0)
    AS total_monthly_obligations
    FROM CUSTOMERS
) 
SELECT 
	customer_id,
    total_monthly_income,
    total_monthly_obligations,
    CASE
		WHEN total_monthly_obligations > total_monthly_income
			THEN 'Financial Stress'
		ELSE 'No Financial Stress Flag'
	END AS financial_stress_flag
FROM customer_finances;

-- Date & Customer Lifecycle Questions
 
-- Calculate each customer's current age from date_of_birth.
SELECT
	customer_id,
    date_of_birth,
    TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM CUSTOMERS
WHERE date_of_birth IS NOT NULL;

-- Find customers older than 40.
SELECT
	customer_id,
    date_of_birth,
    TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM CUSTOMERS
WHERE date_of_birth <= DATE_SUB(CURDATE(), INTERVAL 40 YEAR);
-- Find customers younger than 30.
SELECT
	customer_id,
    date_of_birth,
    TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM CUSTOMERS
WHERE date_of_birth > DATE_SUB(CURDATE(), INTERVAL 30 YEAR)
	AND date_of_birth <= CURDATE();

-- Find the average customer age.
SELECT
	ROUND(
		AVG(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())),2
    ) AS average_customer_age
FROM CUSTOMERS
WHERE date_of_birth IS NOT NULL
	AND date_of_birth <= CURDATE();
    
-- Find the oldest customer.
SELECT
    customer_id,
    date_of_birth,
    TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM CUSTOMERS
WHERE date_of_birth IS NOT NULL
  AND date_of_birth <= CURDATE()
ORDER BY date_of_birth ASC
LIMIT 1;

SELECT
    customer_id,
    date_of_birth,
    TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM customers
WHERE date_of_birth = (
    SELECT MIN(date_of_birth)
    FROM customers
    WHERE date_of_birth <= CURDATE()
);

-- Find the youngest customer.
SELECT
    customer_id,
    date_of_birth,
    TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM customers
WHERE date_of_birth IS NOT NULL
  AND date_of_birth <= CURDATE()
ORDER BY date_of_birth DESC
LIMIT 1;

-- Find customers who have been with the bank for more than 10 years.
SELECT
	customer_id,
    customer_since,
    TIMESTAMPDIFF(YEAR, customer_since, CURDATE())
		AS tenure_years
FROM CUSTOMERS
WHERE customer_since <= DATE_SUB(CURDATE(), INTERVAL 10 YEAR);

-- Calculate customer tenure in years using customer_since.
SELECT
    customer_id,
    customer_since,
    TIMESTAMPDIFF(YEAR, customer_since, CURDATE())
        AS tenure_years
FROM customers
WHERE customer_since IS NOT NULL
  AND customer_since <= CURDATE();
  
-- Find the average customer tenure by customer segment.
SELECT DISTINCT customer_segment FROM CUSTOMERS;
SELECT 
	customer_segment,
    COUNT(*) AS total_customers,
    ROUND(
		AVG(TIMESTAMPDIFF(YEAR, customer_since, CURDATE())),2
        ) AS average_tenure_years
FROM CUSTOMERS
WHERE customer_since IS NOT NULL
	AND customer_since <= CURDATE()
GROUP BY customer_segment
ORDER BY average_tenure_years DESC;

-- Find the number of customers who joined the bank each year.
SELECT
	YEAR(customer_since) AS joining_year,
    COUNT(*) AS total_customers
FROM CUSTOMERS
WHERE customer_since IS NOT NULL
	AND customer_since <= CURDATE()
GROUP BY YEAR(customer_since)
ORDER BY joining_year;

-- check table
SELECT DISTINCT customer_segment
FROM customers;

SELECT
    COUNT(*) AS total_customers,
    SUM(date_of_birth IS NULL) AS missing_dob,
    SUM(customer_since IS NULL) AS missing_joining_date
FROM customers;

-- Subqueries
-- Find customers whose annual income is greater than the overall average income.
SELECT
	customer_id,
    annual_income
FROM CUSTOMERS
WHERE annual_income > (
	SELECT AVG(annual_income)
    FROM CUSTOMERS
    WHERE annual_income IS NOT NULL
);

-- Find customers whose credit score is higher than the average credit score.
SELECT
	customer_id,
	credit_score
FROM CUSTOMERS
WHERE credit_score > (
	SELECT AVG(credit_score)
    FROM  CUSTOMERS
);

-- Find customers whose existing EMI is greater than the average EMI.
SELECT
    customer_id,
    existing_emi
FROM CUSTOMERS
WHERE existing_emi > (
    SELECT AVG(existing_emi)
    FROM CUSTOMERS
);

-- Find customers whose monthly balance is higher than the average balance.
SELECT
    customer_id,
    customer_name,
    city,
    average_monthly_balance
FROM CUSTOMERS
WHERE average_monthly_balance > (
    SELECT AVG(average_monthly_balance)
    FROM CUSTOMERS
)
ORDER BY average_monthly_balance DESC;

-- Find customers who have more existing loans than the average customer.
-- Q65: Existing loan count above average
SELECT
    customer_id,
    existing_loan_count
FROM CUSTOMERS
WHERE existing_loan_count > (
    SELECT AVG(existing_loan_count)
    FROM CUSTOMERS
);

-- Find customers whose annual income is the highest in the database.
-- Q66: Customers with the highest annual income
SELECT
    customer_id,
    annual_income
FROM CUSTOMERS
WHERE annual_income = (
    SELECT MAX(annual_income)
    FROM CUSTOMERS
);

-- Find customers with the second-highest credit score.
SELECT
    customer_id,
    credit_score
FROM CUSTOMERS
WHERE credit_score = (
    SELECT MAX(credit_score)
    FROM CUSTOMERS
    WHERE credit_score < (
        SELECT MAX(credit_score)
        FROM CUSTOMERS
    )
);

-- Find customers whose income is greater than the average income of their city.
SELECT
	c.customer_id,
    c.city,
    c.monthly_income
FROM CUSTOMERS AS c
WHERE c.monthly_income > (
	SELECT AVG(c2.monthly_income)
    FROM CUSTOMERS AS C2
    WHERE C2.city = c.city
);

-- Find customers whose credit score is higher than the average score of their occupation.
SELECT
    c.customer_id,
    c.occupation,
    c.credit_score
FROM CUSTOMERS AS c
WHERE c.credit_score > (
    SELECT AVG(c2.credit_score)
    FROM CUSTOMERS AS c2
    WHERE c2.occupation = c.occupation
);


EXPLAIN
SELECT occupation, AVG(credit_score)
FROM customers
WHERE credit_score IS NOT NULL
GROUP BY occupation;

-- optimized query
SELECT
    c.customer_id,
    c.occupation,
    c.credit_score
FROM CUSTOMERS AS c
JOIN (
    SELECT
        occupation,
        AVG(credit_score) AS avg_credit_score
    FROM CUSTOMERS
    WHERE credit_score IS NOT NULL
    GROUP BY occupation
) AS avg_scores
    ON c.occupation <=> avg_scores.occupation
WHERE c.credit_score > avg_scores.avg_credit_score
ORDER BY c.occupation, c.credit_score DESC
LIMIT 1000;

-- Find customers whose existing loan amount is greater than the average loan amount of their risk category.
SELECT
    c.customer_id,
    c.risk_category,
    c.total_existing_loan_amount
FROM CUSTOMERS AS c
WHERE c.total_existing_loan_amount > (
    SELECT AVG(c2.total_existing_loan_amount)
    FROM CUSTOMERS AS c2
    WHERE c2.risk_category = c.risk_category
);

-- Optimized query

SELECT
    c.customer_id,
    c.risk_category,
    c.total_existing_loan_amount
FROM customers AS c
JOIN (
    SELECT
        risk_category,
        AVG(total_existing_loan_amount) AS avg_loan_amount
    FROM customers
    WHERE total_existing_loan_amount IS NOT NULL
    GROUP BY risk_category
) AS risk_avg
    ON c.risk_category <=> risk_avg.risk_category
WHERE c.total_existing_loan_amount > risk_avg.avg_loan_amount
ORDER BY c.total_existing_loan_amount DESC
LIMIT 1000;