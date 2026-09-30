CREATE DATABASE banking_db;
USE banking_db;


-- =========================================================
-- 1. CUSTOMERS
-- =========================================================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    gender VARCHAR(20),
    date_of_birth DATE,
    city VARCHAR(50),
    state VARCHAR(50),
    occupation VARCHAR(50),
    employment_type VARCHAR(30),
    employer_name VARCHAR(100),
    years_employed DECIMAL(4,1),
    annual_income DECIMAL(15,2),
    monthly_income DECIMAL(15,2),
    other_monthly_income DECIMAL(15,2),
    monthly_expenses DECIMAL(15,2),
    existing_emi DECIMAL(15,2),
    existing_loan_count INT,
    total_existing_loan_amount DECIMAL(15,2),
    credit_score INT,
    credit_history_years DECIMAL(4,1),
    customer_since DATE,
    customer_segment VARCHAR(30),
    risk_category VARCHAR(20),
    kyc_status VARCHAR(20),
    residence_type VARCHAR(30),
    dependents INT,
    marital_status VARCHAR(20),
    bank_account_type VARCHAR(30),
    average_monthly_balance DECIMAL(15,2),
    preferred_channel VARCHAR(20),
    customer_status VARCHAR(20)
    
	-- Validation Constraints
    CONSTRAINT chk_gender
        CHECK (gender IN ('Male', 'Female', 'Other')),

    CONSTRAINT chk_years_employed
        CHECK (years_employed >= 0),

    CONSTRAINT chk_income
        CHECK (annual_income >= 0 AND monthly_income >= 0),

    CONSTRAINT chk_other_income
        CHECK (other_monthly_income >= 0),

    CONSTRAINT chk_expenses
        CHECK (monthly_expenses >= 0),

    CONSTRAINT chk_existing_emi
        CHECK (existing_emi >= 0),

    CONSTRAINT chk_existing_loans
        CHECK (
            existing_loan_count >= 0
            AND total_existing_loan_amount >= 0
        ),

    CONSTRAINT chk_credit_score
        CHECK (credit_score IS NULL OR credit_score BETWEEN 300 AND 900),

    CONSTRAINT chk_credit_history
        CHECK (credit_history_years >= 0),

    CONSTRAINT chk_dependents
        CHECK (dependents >= 0),

    CONSTRAINT chk_balance
        CHECK (average_monthly_balance >= 0),

    CONSTRAINT chk_risk_category
        CHECK (
            risk_category IN ('Low', 'Medium', 'High')
            OR risk_category IS NULL
        ),

    CONSTRAINT chk_kyc_status
        CHECK (
            kyc_status IN ('Verified', 'Pending', 'Expired')
            OR kyc_status IS NULL
        ),

    CONSTRAINT chk_customer_status
        CHECK (
            customer_status IN ('Active', 'Dormant', 'Closed')
        )
);


-- =========================================================
-- 2. BRANCHES
-- =========================================================

CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    state VARCHAR(50),
    branch_type VARCHAR(30),
    manager_id INT,
    branch_code VARCHAR(20) UNIQUE,
    ifsc_code VARCHAR(20) UNIQUE,
    opening_date DATE,
    branch_status VARCHAR(20),
    loan_officers_count INT,
    sales_executives_count INT,
    credit_officers_count INT,
    service_staff_count INT,
    total_employees INT,
    monthly_loan_target DECIMAL(15,2),
    annual_loan_target DECIMAL(15,2),
    monthly_application_target INT,
    avg_monthly_applications INT,
    avg_monthly_disbursement DECIMAL(15,2),
    avg_approval_rate DECIMAL(5,2),
    avg_processing_days DECIMAL(5,2),
    rejection_rate DECIMAL(5,2),
    default_rate DECIMAL(5,2),
    npa_ratio DECIMAL(5,2),
    portfolio_outstanding DECIMAL(18,2),
    deposit_base DECIMAL(18,2),
    customer_count INT,
    loan_customer_count INT,
    digital_application_percentage DECIMAL(5,2),
    dealer_partner_count INT,
    dsa_partner_count INT,
    service_area VARCHAR(100),
    risk_category VARCHAR(20),
    manager_experience_years DECIMAL(4,1),
    last_audit_date DATE,
    audit_rating VARCHAR(20)
);


-- =========================================================
-- 3. LOAN APPLICATIONS
-- =========================================================

CREATE TABLE loan_applications (
    application_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    application_date DATE,
    loan_type VARCHAR(50),
    loan_purpose VARCHAR(100),
    requested_amount DECIMAL(15,2),
    approved_amount DECIMAL(15,2),
    disbursed_amount DECIMAL(15,2),
    tenure_months INT,
    interest_rate DECIMAL(5,2),
    emi_amount DECIMAL(15,2),
    processing_fee DECIMAL(15,2),
    down_payment DECIMAL(15,2),
    loan_to_value_ratio DECIMAL(5,2),
    application_status VARCHAR(30),
    rejection_reason VARCHAR(100),
    application_source VARCHAR(30),
    sales_channel VARCHAR(30),
    credit_score_at_application INT,
    monthly_income_at_application DECIMAL(15,2),
    existing_emi_at_application DECIMAL(15,2),
    foir_ratio DECIMAL(5,2),
    risk_grade VARCHAR(20),
    collateral_type VARCHAR(50),
    collateral_value DECIMAL(15,2),
    document_status VARCHAR(30),
    verification_status VARCHAR(30),
    underwriting_status VARCHAR(30),
    approval_date DATE,
    rejection_date DATE,
    disbursement_date DATE,
    processed_by INT,
    processing_days INT,

    CONSTRAINT fk_application_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_application_branch
        FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);


-- =========================================================
-- 4. LOANS
-- =========================================================

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    application_id INT NOT NULL,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    disbursement_date DATE,
    loan_amount DECIMAL(15,2),
    interest_rate DECIMAL(5,2),
    interest_type VARCHAR(20),
    loan_type VARCHAR(30),
    tenure_months INT,
    emi_amount DECIMAL(15,2),
    emi_start_date DATE,
    emi_end_date DATE,
    total_emi_count INT,
    paid_emi_count INT,
    missed_emi_count INT,
    next_emi_date DATE,
    last_payment_date DATE,
    last_payment_amount DECIMAL(15,2),
    total_amount_paid DECIMAL(18,2),
    principal_paid DECIMAL(18,2),
    interest_paid DECIMAL(18,2),
    outstanding_principal DECIMAL(18,2),
    outstanding_amount DECIMAL(18,2),
    prepayment_amount DECIMAL(15,2),
    prepayment_date DATE,
    loan_status VARCHAR(30),
    days_past_due INT,
    dpd_bucket VARCHAR(20),
    default_flag TINYINT,
    npa_flag TINYINT,
    npa_date DATE,
    risk_category VARCHAR(20),
    collateral_type VARCHAR(50),
    collateral_value DECIMAL(18,2),
    ltv_ratio DECIMAL(5,2),
    processing_fee DECIMAL(15,2),
    insurance_amount DECIMAL(15,2),
    closure_date DATE,
    closure_reason VARCHAR(30),

    CONSTRAINT fk_loan_application
        FOREIGN KEY (application_id)
        REFERENCES loan_applications(application_id),

    CONSTRAINT fk_loan_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_loan_branch
        FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);


-- =========================================================
-- 5. PAYMENTS
-- =========================================================

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    loan_id INT NOT NULL,
    payment_date DATE,
    due_date DATE,
    emi_due DECIMAL(15,2),
    amount_paid DECIMAL(15,2),
    principal_component DECIMAL(15,2),
    interest_component DECIMAL(15,2),
    penalty_amount DECIMAL(15,2),
    late_fee DECIMAL(15,2),
    amount_outstanding_after_payment DECIMAL(18,2),
    payment_status VARCHAR(30),
    days_late INT,
    payment_method VARCHAR(30),
    payment_channel VARCHAR(30),
    transaction_reference VARCHAR(50),
    payment_attempt INT,
    failure_reason VARCHAR(100),
    bounce_flag TINYINT,
    bounce_charge DECIMAL(15,2),
    collection_status VARCHAR(30),
    collection_agent_id INT,
    collection_date DATE,
    promise_to_pay_date DATE,
    payment_type VARCHAR(30),
    is_prepayment TINYINT,
    is_partial_payment TINYINT,
    waiver_amount DECIMAL(15,2),
    remarks VARCHAR(255),

    CONSTRAINT fk_payment_loan
        FOREIGN KEY (loan_id)
        REFERENCES loans(loan_id)
);


-- =========================================================
-- 6. COLLATERAL
-- =========================================================

CREATE TABLE collateral (
    collateral_id INT PRIMARY KEY,
    loan_id INT NOT NULL,
    customer_id INT NOT NULL,
    vehicle_type VARCHAR(30),
    vehicle_brand VARCHAR(50),
    vehicle_model VARCHAR(50),
    vehicle_variant VARCHAR(100),
    vehicle_value DECIMAL(15,2),
    manufacture_year INT,
    registration_year INT,
    registration_number VARCHAR(20),
    engine_number VARCHAR(50),
    chassis_number VARCHAR(50),
    fuel_type VARCHAR(20),
    vehicle_usage VARCHAR(30),
    new_or_used VARCHAR(20),
    odometer_reading INT,
    purchase_price DECIMAL(15,2),
    down_payment DECIMAL(15,2),
    financed_amount DECIMAL(15,2),
    loan_to_value DECIMAL(5,2),
    valuation_date DATE,
    current_market_value DECIMAL(15,2),
    forced_sale_value DECIMAL(15,2),
    depreciation_rate DECIMAL(5,2),
    insurance_status VARCHAR(30),
    insurance_provider VARCHAR(100),
    insurance_expiry_date DATE,
    insurance_sum_insured DECIMAL(15,2),
    hypothecation_status VARCHAR(30),
    hypothecation_date DATE,
    rc_status VARCHAR(30),
    rc_owner_name VARCHAR(100),
    valuation_status VARCHAR(30),
    valuation_method VARCHAR(50),
    valuer_id INT,
    collateral_status VARCHAR(30),
    repossession_status VARCHAR(30),
    repossession_date DATE,
    recovery_value DECIMAL(15,2),
    sale_status VARCHAR(30),
    sale_date DATE,
    collateral_location VARCHAR(100),
    created_date DATE,
    last_updated_date DATE,

    CONSTRAINT fk_collateral_loan
        FOREIGN KEY (loan_id)
        REFERENCES loans(loan_id),

    CONSTRAINT fk_collateral_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);


-- =========================================================
-- 7. COLLECTIONS
-- =========================================================

CREATE TABLE collections (
    collection_id INT PRIMARY KEY,
    loan_id INT NOT NULL,
    customer_id INT NOT NULL,
    payment_id INT,
    collection_date DATE,
    due_date DATE,
    collection_amount DECIMAL(15,2),
    amount_due DECIMAL(15,2),
    principal_collected DECIMAL(15,2),
    interest_collected DECIMAL(15,2),
    penalty_collected DECIMAL(15,2),
    late_fee_collected DECIMAL(15,2),
    outstanding_before_collection DECIMAL(18,2),
    outstanding_after_collection DECIMAL(18,2),
    days_past_due INT,
    dpd_bucket VARCHAR(30),
    collection_method VARCHAR(30),
    collection_channel VARCHAR(30),
    collection_status VARCHAR(30),
    collection_type VARCHAR(30),
    collection_stage VARCHAR(30),
    collection_agent_id INT,
    contact_attempts INT,
    successful_contact TINYINT,
    contact_method VARCHAR(30),
    contact_date DATE,
    promise_to_pay TINYINT,
    promise_to_pay_date DATE,
    promise_amount DECIMAL(15,2),
    ptp_kept_flag TINYINT,
    reason_for_nonpayment VARCHAR(100),
    customer_response VARCHAR(50),
    field_visit_required TINYINT,
    field_visit_date DATE,
    recovery_agent_id INT,
    legal_action_flag TINYINT,
    legal_action_date DATE,
    settlement_flag TINYINT,
    settlement_amount DECIMAL(15,2),
    waiver_amount DECIMAL(15,2),
    recovery_cost DECIMAL(15,2),
    collection_status_reason VARCHAR(100),
    next_followup_date DATE,
    recovery_location VARCHAR(100),
    created_date DATE,
    last_updated_date DATE,

    CONSTRAINT fk_collection_loan
        FOREIGN KEY (loan_id)
        REFERENCES loans(loan_id),

    CONSTRAINT fk_collection_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_collection_payment
        FOREIGN KEY (payment_id)
        REFERENCES payments(payment_id)
);

-- =========================================================
-- 8. EMPLOYEES
-- =========================================================

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_code VARCHAR(20) UNIQUE,
    employee_name VARCHAR(100) NOT NULL,
    gender VARCHAR(20),
    date_of_birth DATE,

    branch_id INT,
    department VARCHAR(50),
    designation VARCHAR(50),
    employee_role VARCHAR(50),

    employment_type VARCHAR(30),
    joining_date DATE,
    years_of_experience DECIMAL(4,1),

    manager_id INT,

    email VARCHAR(100),
    phone_number VARCHAR(20),

    city VARCHAR(50),
    state VARCHAR(50),

    monthly_salary DECIMAL(12,2),
    annual_salary DECIMAL(15,2),

    monthly_target DECIMAL(15,2),
    annual_target DECIMAL(18,2),

    loans_processed_count INT,
    loans_approved_count INT,
    loans_rejected_count INT,
    total_disbursement_amount DECIMAL(18,2),

    approval_rate DECIMAL(5,2),
    average_processing_days DECIMAL(5,2),

    collection_target DECIMAL(15,2),
    collection_amount DECIMAL(18,2),
    collection_rate DECIMAL(5,2),

    customer_handled_count INT,

    performance_rating DECIMAL(3,2),
    performance_category VARCHAR(20),

    incentive_amount DECIMAL(15,2),

    employee_status VARCHAR(20),

    last_promotion_date DATE,
    last_training_date DATE,

    created_date DATE,
    last_updated_date DATE,

    CONSTRAINT fk_employee_branch
        FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id),

    CONSTRAINT fk_employee_manager
        FOREIGN KEY (manager_id)
        REFERENCES employees(employee_id)
);

-- INDEX
CREATE INDEX idx_employee_branch
ON employees(branch_id);

CREATE INDEX idx_employee_department
ON employees(department);

CREATE INDEX idx_employee_role
ON employees(employee_role);

CREATE INDEX idx_employee_status
ON employees(employee_status);

CREATE INDEX idx_employee_manager
ON employees(manager_id);

CREATE INDEX idx_employee_joining_date
ON employees(joining_date);

CREATE INDEX idx_customers_city
ON customers(city);

CREATE INDEX idx_customers_credit_score
ON customers(credit_score);

CREATE INDEX idx_applications_customer
ON loan_applications(customer_id);

CREATE INDEX idx_applications_branch
ON loan_applications(branch_id);

CREATE INDEX idx_applications_status
ON loan_applications(application_status);

CREATE INDEX idx_loans_customer
ON loans(customer_id);

CREATE INDEX idx_loans_branch
ON loans(branch_id);

CREATE INDEX idx_loans_status
ON loans(loan_status);

CREATE INDEX idx_loans_dpd
ON loans(days_past_due);

CREATE INDEX idx_payments_loan
ON payments(loan_id);

CREATE INDEX idx_payments_date
ON payments(payment_date);

CREATE INDEX idx_collections_loan
ON collections(loan_id);

CREATE INDEX idx_collections_status
ON collections(collection_status);