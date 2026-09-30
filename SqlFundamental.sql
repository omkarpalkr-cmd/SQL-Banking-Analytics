CREATE DATABASE banking_db;
USE banking_db;
SELECT * FROM customers;

-- Filtering, Aggregation & Basic Business Logic

-- Find all customers whose credit_score is greater than 750.
SELECT customer_name, state, credit_score FROM customers
WHERE credit_score > 750
ORDER BY credit_score DESC;

-- Find customers with annual income greater than ₹10 lakh.
SELECT customer_name, state, annual_income FROM customers
WHERE annual_income > 1000000
ORDER BY annual_income DESC;

-- Find customers who have existing loans.
SELECT customer_name, state, existing_emi, existing_loan_count FROM customers
WHERE existing_loan_count > 0;

-- Find customers whose existing_emi is greater than ₹20,000.
SELECT customer_name, state, existing_emi, existing_loan_count FROM customers
WHERE existing_emi > 20000
ORDER BY existing_emi DESC;

-- Find all customers from Mumbai.
SELECT customer_id, customer_name, state, city FROM customers
WHERE city = 'Mumbai';

-- Find customers who are salaried and have employment_type = 'Permanent'.
SELECT DISTINCT occupation FROM customers;
SELECT DISTINCT employment_type FROM customers;
SELECT customer_name, state, occupation, employment_type FROM customers
WHERE occupation = 'salaried' AND employment_type = 'Permanent';

-- Count the total number of customers.
SELECT COUNT(*) AS TotalCustomer FROM customers;

-- Count customers by gender.
SELECT gender, COUNT(customer_id) AS TotalCustomer  FROM customers
GROUP BY gender;

-- Count customers by city.
SELECT city, COUNT(customer_id) AS TotalCustomer FROM customers
GROUP BY city;

-- Find the average annual income of all customers.
SELECT AVG(annual_income) AS AverageAnnualIncome FROM customers;

-- Find the maximum and minimum credit score.
SELECT MAX(credit_score) AS Maximumcredit_score, MIN(credit_score) AS Minimumcredit_score FROM customers;

-- Find the average credit score by city.
SELECT city, AVG(credit_score) AS Averagecredit_score FROM customers
GROUP BY city;

-- Find the average monthly income by occupation.
SELECT occupation, AVG(monthly_income) AS Averagemonthly_income FROM customers
GROUP BY occupation;

-- Find the total existing loan amount across all customers.
SELECT  SUM(total_existing_loan_amount) AS Total_Existing_Loan_Amount FROM customers;

-- Find the total existing EMI obligation across all customers.
SELECT SUM(existing_emi) AS Totalexisting_emi FROM customers;

-- Find customers who have more than 2 existing loans.
SELECT customer_id, customer_name, existing_loan_count FROM  customers
WHERE existing_loan_count > 2 
AND existing_loan_count IS NOT NULL;

-- Find customers whose monthly expenses are greater than their monthly income.
SELECT customer_id, customer_name, monthly_expenses, monthly_income FROM customers
WHERE monthly_expenses > monthly_income;

-- Find customers with no existing loans.
SELECT customer_id, customer_name, state, existing_loan_count FROM customers
WHERE existing_loan_count = 0;

-- Find customers whose KYC status is Pending.
SELECT customer_id, customer_name, state, kyc_status FROM customers
WHERE kyc_status = 'pending';

-- Find the number of customers in each risk_category.
SELECT risk_category, COUNT(customer_id) AS Totalcustomer FROM customers
GROUP BY risk_category;

-- GROUP BY + HAVING

-- ₹1 lakh       = 100,000
-- ₹10 lakh      = 1,000,000
-- ₹1 crore      = 10,000,000
-- ₹10 crore     = 100,000,000
-- ₹100 crore    = 1,000,000,000

-- Find cities having more than 500 customers.
SELECT  city, COUNT(*) AS TotalCustomer FROM customers
GROUP BY city
HAVING TotalCustomer > 500;

-- Find occupations having an average annual income greater than ₹8 lakh.
SELECT occupation, AVG(annual_income) AS Averageannual_income FROM customers
GROUP BY occupation
HAVING Averageannual_income > 800000;

-- Find cities where the average credit score is below 650.
SELECT city, AVG(credit_score) AS Avergaecredit_score FROM customers
GROUP BY city
HAVING Avergaecredit_score < 650;

-- Find customer segments having more than 1,000 customers.
SELECT customer_segment, COUNT(*) AS ToatalCustomer FROM customers
GROUP BY customer_segment
HAVING ToatalCustomer > 1000;

-- Find risk categories having average income greater than ₹7 lakh.
SELECT risk_category, AVG(annual_income) AS AverageIncome FROM customers
GROUP BY risk_category
HAVING AverageIncome > 700000;

-- Find occupations where the average existing EMI exceeds ₹15,000.
SELECT occupation, AVG(existing_emi) AS AverageExisting_emi FROM customers
GROUP BY occupation
HAVING AverageExisting_emi > 15000;

-- Find cities where the total existing loan amount exceeds ₹100 crore.
SELECT city, SUM(total_existing_loan_amount) AS Total_existing_loan_amount FROM customers
GROUP BY city
HAVING Total_existing_loan_amount > 10000000;

-- Find employers having more than 50 customers.
SELECT employer_name, COUNT(*) AS TotalCustomer FROM customers
GROUP BY employer_name
HAVING TotalCustomer > 50;

-- Find cities having more than 100 high-risk customers.
SELECT DISTINCT risk_category FROM customers;
SELECT city, COUNT(customer_id) AS HighRiskCustomer FROM customers
WHERE risk_category = 'High'
GROUP BY city
HAVING HighRiskCustomer > 100;

-- Find customer segments where average credit score exceeds 750.
SELECT  customer_segment, AVG(credit_score) AS AverageCredit_score FROM customers
GROUP BY customer_segment
HAVING AverageCredit_score  > 750;

-- Find occupations with at least 100 customers and average annual income above ₹10 lakh.
SELECT occupation , COUNT(customer_id) AS ToatlCustomer, AVG(annual_income) AS AverageAnnual_income FROM customers
GROUP BY occupation
HAVING ToatlCustomer >= 100
AND AverageAnnual_income > 1000000;

-- Find cities where more than 30% of customers have pending KYC.
SELECT 
    city, COUNT(*) AS TotalCustomers,
    SUM(CASE 
            WHEN kyc_status = 'Pending' THEN 1 
            ELSE 0 
        END) AS PendingKYC,
	ROUND(100.0 * SUM(CASE 
					WHEN kyc_status = 'Pending' THEN 1 
					ELSE 0 
				END) / COUNT(*), 
			2
		) AS PendingKYCPct
FROM customers
GROUP BY city
HAVING PendingKYCPct > 30
ORDER BY PendingKYC DESC;

-- Find occupations where the average number of existing loans is greater than 1.
SELECT occupation, COUNT(*) AS TotalCustomers, AVG(existing_loan_count) AS AverageExisting_loan FROM customers
GROUP BY occupation
HAVING AverageExisting_loan > 1;

-- Find cities where the average monthly balance exceeds ₹1 lakh.
SELECT city, AVG(average_monthly_balance) AS AverageMonthlyBalance FROM customers
GROUP BY city
HAVING AverageMonthlyBalance > 100000
ORDER BY AverageMonthlyBalance DESC;

-- Find states having at least 500 active customers.
SELECT state, COUNT(*) AS ActiveTotalCustomer FROM customers
WHERE customer_status = 'active'
GROUP BY state
HAVING ActiveTotalCustomer >= 500
ORDER BY ActiveTotalCustomer DESC;


