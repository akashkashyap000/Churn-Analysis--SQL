-- ============================================================
-- CUSTOMER CHURN ANALYSIS — SQL PROJECT
-- Dataset: Telco Customer Churn (7,032 customers)
-- Database: PostgreSQL
-- ============================================================

-- ============================================================
-- STEP 1: CREATE TABLE
-- Define structure for telco churn dataset
-- ============================================================
CREATE TABLE telco_churn (
    customerID VARCHAR(20),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure INT,
    PhoneService VARCHAR(5),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(50),
    MonthlyCharges FLOAT,
    TotalCharges VARCHAR(20),
    Churn VARCHAR(5)
);

-- ============================================================
-- STEP 2: IMPORT DATA
-- Import cleaned CSV file into the table
-- ============================================================
COPY telco_churn
FROM 'D:/telco_churn_cleaned.csv'
DELIMITER ','
CSV HEADER;

-- Verify data loaded correctly
SELECT * FROM telco_churn LIMIT 5;

-- ============================================================
-- QUERY 1: OVERALL CHURN RATE
-- Calculate total customers who churned vs retained
-- Using window function to calculate percentage
-- ============================================================
SELECT 
    Churn,
    COUNT(*) as total_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM telco_churn
GROUP BY Churn;
-- Finding: 26.58% customers churned — 1 in 4 customers leaving

-- ============================================================
-- QUERY 2: CONTRACT TYPE VS CHURN
-- Analyze churn rate based on contract type
-- PARTITION BY divides data by each contract type
-- ============================================================
SELECT 
    Contract,
    Churn,
    COUNT(*) as total_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY Contract), 2) as churn_percentage
FROM telco_churn
GROUP BY Contract, Churn
ORDER BY Contract, Churn;
-- Finding: Month-to-month customers churn 42.71% — highest among all contract types

-- ============================================================
-- QUERY 3: TENURE GROUPS VS CHURN
-- Group customers by tenure and analyze churn rate
-- CASE WHEN works like if-else to create tenure buckets
-- ============================================================
SELECT
    CASE 
        WHEN tenure < 6  THEN '0-6 months'
        WHEN tenure < 12 THEN '6-12 months'
        WHEN tenure < 24 THEN '1-2 years'
        ELSE '2+ years'
    END as tenure_group,
    COUNT(*) as total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as churn_rate
FROM telco_churn
GROUP BY tenure_group
ORDER BY churn_rate DESC;
-- Finding: Customers with tenure 0-6 months have highest churn rate of 54.71%

-- ============================================================
-- QUERY 4: MONTHLY CHARGES VS CHURN
-- Compare average monthly charges of churned vs retained customers
-- ::numeric cast required for ROUND function in PostgreSQL
-- ============================================================
SELECT 
    Churn,
    ROUND(AVG(MonthlyCharges::numeric), 2) as avg_monthly_charges,
    ROUND(MIN(MonthlyCharges::numeric), 2) as min_charges,
    ROUND(MAX(MonthlyCharges::numeric), 2) as max_charges
FROM telco_churn
GROUP BY Churn;
-- Finding: Churned customers paid higher avg monthly charges ($74.44)
-- High paying customers are at greater churn risk

-- ============================================================
-- QUERY 5: REVENUE LOSS CALCULATION
-- Calculate total monthly and yearly revenue lost due to churn
-- ============================================================
SELECT 
    ROUND(SUM(MonthlyCharges::numeric), 2) as monthly_revenue_loss,
    ROUND(SUM(MonthlyCharges::numeric) * 12, 2) as yearly_revenue_loss
FROM telco_churn
WHERE Churn = 'Yes';
-- Finding: Monthly loss $139,130.85 | Yearly loss $1,669,570.20

-- ============================================================
-- QUERY 6: INTERNET SERVICE VS CHURN
-- Analyze churn rate by internet service type
-- PARTITION BY InternetService calculates percentage within each service type
-- ============================================================
SELECT 
    InternetService,
    Churn,
    COUNT(*) as total_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY InternetService), 2) as churn_percentage
FROM telco_churn
GROUP BY InternetService, Churn
ORDER BY InternetService, Churn;
-- Finding: Fiber optic customers have highest churn rate of 41.89%

-- ============================================================
-- QUERY 7: SENIOR CITIZEN VS CHURN
-- Compare churn rate between senior and non-senior customers
-- CASE WHEN converts 0/1 to readable labels
-- ============================================================
SELECT 
    CASE WHEN SeniorCitizen = 1 THEN 'Senior' 
         ELSE 'Non-Senior' 
    END as customer_type,
    COUNT(*) as total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) as churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as churn_rate
FROM telco_churn
GROUP BY SeniorCitizen
ORDER BY churn_rate DESC;
-- Finding: Senior citizens churn at 41.68% vs 23.6% non-senior customers

-- ============================================================
-- INSIGHTS SUMMARY
-- ============================================================

-- BUSINESS IMPACT:
-- Monthly Revenue Loss: $139,130.85
-- Yearly Revenue Loss:  $1,669,570.20

-- KEY FINDINGS:
-- 1. 26.58% overall churn rate — 1 in 4 customers leaving
-- 2. Month-to-month customers churn 42.71% — highest churn risk
-- 3. New customers (0-6 months) have 54.71% churn rate
-- 4. Churned customers paid higher avg charges ($74.44)
-- 5. Fiber optic customers churn 41.89% — service issues likely
-- 6. Senior citizens churn 41.68% vs 23.6% non-seniors

-- BUSINESS RECOMMENDATIONS:
-- 1. Offer discounts to convert month-to-month to annual plans
-- 2. Improve onboarding experience for new customers
-- 3. Create retention offers for high-paying customers
-- 4. Investigate fiber optic pricing and service quality
-- 5. Design senior citizen specific retention programs

-- ============================================================
-- ANALYSIS COMPLETE
-- ============================================================
