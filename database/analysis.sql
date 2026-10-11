-- ============================================================
-- NORDIC BANK - DATA ANALYTICS
-- SQL BUSINESS ANALYSIS
-- Database: PostgreSQL
-- ============================================================


-- ============================================================
-- 1. CUSTOMER ANALYSIS
-- ============================================================

-- 1.1 How many customers are in each customer segment?

SELECT
    C.customer_segment,
    COUNT(*) AS number_of_customers
FROM Customer C
GROUP BY C.customer_segment
ORDER BY number_of_customers DESC;


-- 1.2 What is the average income in each customer segment?

SELECT
    C.customer_segment,
    AVG(C.income) AS average_income
FROM Customer C
GROUP BY C.customer_segment
ORDER BY average_income DESC;


-- ============================================================
-- 2. ACCOUNT ANALYSIS
-- ============================================================

-- 2.1 What is the total balance across all accounts?

SELECT
    SUM(A.balance) AS total_balance
FROM Account A;


-- 2.2 What is the average account balance in each customer segment?

SELECT
    C.customer_segment,
    AVG(A.balance) AS average_balance
FROM Customer C
JOIN Account A
    ON C.customer_id = A.customer_id
GROUP BY C.customer_segment
ORDER BY average_balance DESC;


-- ============================================================
-- 3. TRANSACTION ANALYSIS
-- ============================================================

-- 3.1 How many transactions are there in each category?

SELECT
    T.category,
    COUNT(*) AS number_of_transactions
FROM Transactions T
GROUP BY T.category
ORDER BY number_of_transactions DESC;


-- 3.2 What are the total transaction amounts by transaction type?

SELECT
    T.transaction_type,
    SUM(T.amount) AS total_amount
FROM Transactions T
GROUP BY T.transaction_type
ORDER BY total_amount DESC;


-- ============================================================
-- 4. INVESTMENT ANALYSIS
-- ============================================================

-- 4.1 What is the total invested amount in each sector?

SELECT
    I.sector,
    SUM(I.quantity * I.purchase_price) AS invested_amount
FROM Investment I
GROUP BY I.sector
ORDER BY invested_amount DESC;


-- 4.2 How many investments does each customer have?

SELECT
    I.customer_id,
    COUNT(*) AS number_of_investments
FROM Investment I
GROUP BY I.customer_id
ORDER BY number_of_investments DESC;


-- ============================================================
-- 5. SAVINGS ANALYSIS
-- ============================================================

-- 5.1 What is the average target amount and current savings
-- for each savings goal?

SELECT
    SG.goal_name,
    AVG(SG.target_amount) AS average_target,
    AVG(SG.current_amount) AS average_saved
FROM SavingsGoal SG
GROUP BY SG.goal_name
ORDER BY average_target DESC;


-- 5.2 What percentage of each savings goal has been reached?

SELECT
    SG.goal_name,
    AVG(
        SG.current_amount / NULLIF(SG.target_amount, 0)
    ) * 100 AS average_progress_percent
FROM SavingsGoal SG
GROUP BY SG.goal_name
ORDER BY average_progress_percent DESC;


-- ============================================================
-- 6. MARKET DATA ANALYSIS
-- ============================================================

-- 6.1 What is the latest closing price for each stock?

SELECT DISTINCT ON (MD.ticker)
    MD.ticker,
    MD.market_date,
    MD.close_price
FROM MarketData MD
ORDER BY MD.ticker, MD.market_date DESC;


-- ============================================================
-- 7. INVESTMENT PERFORMANCE
-- ============================================================

-- 7.1 What is the current market value of each investment?

SELECT
    I.customer_id,
    I.ticker,
    I.quantity,
    I.purchase_price,
    MD.close_price AS current_price,
    I.quantity * MD.close_price AS current_value
FROM Investment I
JOIN (
    SELECT DISTINCT ON (MD.ticker)
        MD.ticker,
        MD.close_price
    FROM MarketData MD
    ORDER BY MD.ticker, MD.market_date DESC
) MD
    ON I.ticker = MD.ticker
ORDER BY current_value DESC;
