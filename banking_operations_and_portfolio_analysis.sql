USE banking_db;
-- Customer portfolio: How many active, dormant, and closed customers are recorded in each city and state?
SELECT 
	customer_status,
    city,
    state,
    COUNT(*) AS Total_customer 
FROM customers
GROUP BY customer_status, city, state
ORDER BY Total_customer DESC;
    
-- Customer risk: How many customers belong to each risk category, and what is their average credit score?
SELECT DISTINCT risk_category FROM customers;
SELECT 
	risk_category,
    COUNT(*) AS Total_customer,
    ROUND(AVG(credit_score),0) AS Avg_credit_score
FROM customers
GROUP BY risk_category
ORDER BY Total_customer DESC;
    
-- More Describe credit score slab using CASE statment 
SELECT
	CASE
		WHEN credit_score IS NULL THEN 'Unknown'
		WHEN credit_score < 580 THEN 'Very Low Score'
        WHEN credit_score < 670 THEN 'Low Score'
        WHEN credit_score < 740 THEN 'Moderate Score'
        WHEN credit_score < 800 THEN 'Good Score'
        ELSE 'Excellent Score'
	END AS credit_score_Category,
    ROUND(AVG(credit_score),0) AS Avg_credit_score,
    COUNT(*) AS Total_customer
FROM customers
GROUP BY credit_score_Category
ORDER BY Avg_credit_score;
    
-- KYC compliance: How many customers have verified, pending, or expired KYC status in each customer segment?
SELECT DISTINCT customer_segment, kyc_status FROM customers;
SELECT 
	customer_segment,
    kyc_status,
    COUNT(*) AS Total_customer
FROM customers
GROUP BY kyc_status, customer_segment
ORDER BY customer_segment, Total_customer DESC;
    
-- Loan application pipeline: How many applications are applied, under review, approved, rejected, or cancelled?
SELECT DISTINCT application_status FROM loan_applications;
SELECT 
	application_status,
    COUNT(*) AS Total_customer,
	ROUND(
        100.0 * COUNT(*) /
        NULLIF(SUM(COUNT(*)) OVER (), 0),
        2
    ) AS percentage_of_applications
FROM loan_applications
GROUP BY application_status
ORDER BY Total_customer DESC;
    
-- Application documentation: How many applications have pending documents, failed verification, or incomplete underwriting?
SELECT DISTINCT document_status FROM loan_applications;
SELECT 
	document_status,
    COUNT(application_id) AS Toatl_applications
FROM loan_applications
GROUP BY document_status
ORDER BY Toatl_applications DESC;
    
-- Loan portfolio: How many loans are active, closed, defaulted, or written off?
SELECT DISTINCT loan_status FROM loans;
SELECT 
	loan_status,
	SUM(loan_amount) AS Total_loan_amount,
    SUM(total_amount_paid) AS Total_amount_paid,
    SUM(outstanding_amount) AS Outstanding_amount,
    COUNT(*) AS Total_loans
FROM loans
GROUP BY loan_status
ORDER BY Total_loans DESC;

-- Repayment performance: How many payment records are paid, partial, missed, failed, or waived?
SELECT DISTINCT payment_status FROM payments;
SELECT 
	-- COALESCE(payment_status, 'Unknown') AS payment_status,
    payment_status,
    COUNT(*) AS payment_count,
    ROUND(SUM(emi_due), 2) AS total_amount_due,
    ROUND(SUM(amount_paid), 2) AS total_amount_paid,
    ROUND(SUM(waiver_amount), 2) AS total_waiver_amount,
    SUM(
        CASE
            WHEN waiver_amount > 0 THEN 1
            ELSE 0
        END
    ) AS records_with_waiver
FROM payments
GROUP BY payment_status
ORDER BY payment_count DESC;

-- Collection operations: How many collection activities are successful, partial, failed, promised, or refused?
SELECT
    COALESCE(collection_status, 'Unknown') AS collection_status,
    COUNT(*) AS collection_activity_count,
    ROUND(SUM(amount_due), 2) AS total_amount_due,
    ROUND(SUM(collection_amount), 2) AS total_collection_amount,
    ROUND(
        100.0 * SUM(collection_amount) /
        NULLIF(SUM(amount_due), 0),
        2
    ) AS collection_amount_recovery_pct
FROM collections
GROUP BY collection_status
ORDER BY collection_activity_count DESC;

-- Collateral compliance: How many vehicles have expired insurance, pending RC status, or pending valuation?
SELECT
    COUNT(*) AS total_collateral_records,

    SUM(
        CASE
            WHEN LOWER(COALESCE(insurance_status, '')) = 'expired'
              OR insurance_expiry_date < CURRENT_DATE
            THEN 1 ELSE 0
        END
    ) AS expired_insurance_count,

    SUM(
        CASE
            WHEN LOWER(COALESCE(rc_status, '')) LIKE '%pending%'
            THEN 1 ELSE 0
        END
    ) AS pending_rc_count,

    SUM(
        CASE
            WHEN LOWER(COALESCE(valuation_status, '')) LIKE '%pending%'
            THEN 1 ELSE 0
        END
    ) AS pending_valuation_count

FROM collateral;

SELECT
    collateral_id,
    loan_id,
    customer_id,
    vehicle_brand,
    vehicle_model,
    insurance_status,
    insurance_expiry_date,
    rc_status,
    valuation_status
FROM collateral
WHERE
       LOWER(COALESCE(insurance_status, '')) = 'expired'
    OR insurance_expiry_date < CURRENT_DATE
    OR LOWER(COALESCE(rc_status, '')) LIKE '%pending%'
    OR LOWER(COALESCE(valuation_status, '')) LIKE '%pending%'
ORDER BY insurance_expiry_date;

-- Employee and branch coverage: How many active employees and branches are recorded, and which branches have no employees linked to them?
SELECT
    (SELECT COUNT(*) FROM employees) AS total_employees,
    (SELECT COUNT(*) FROM branches) AS total_branches;
    
SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    b.state,
    COUNT(e.employee_id) AS employee_count
FROM branches AS b
LEFT JOIN employees AS e
    ON b.branch_id = e.branch_id
GROUP BY
    b.branch_id,
    b.branch_name,
    b.city,
    b.state
HAVING COUNT(e.employee_id) = 0
ORDER BY b.city, b.branch_name;
