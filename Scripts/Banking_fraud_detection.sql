-- 1. Create the Database
CREATE DATABASE IF NOT EXISTS banking_fraud_db;
USE banking_fraud_db;

-- 2. Create the Locations Table
CREATE TABLE IF NOT EXISTS locations (
    Location_ID INT PRIMARY KEY,
    Location_Name VARCHAR(100) NOT NULL
);

-- 3. Create the Accounts Table
CREATE TABLE IF NOT EXISTS accounts (
    User_ID VARCHAR(50) PRIMARY KEY,
    Account_Balance DECIMAL(15,2),
    Previous_Fraudulent_Activity INT
);

-- 4. Create the Devices Table
CREATE TABLE IF NOT EXISTS devices (
    Device_ID INT PRIMARY KEY,
    User_ID VARCHAR(50),
    Device_Type VARCHAR(50)
);

-- 5. Create the Transactions Table
CREATE TABLE IF NOT EXISTS transactions (
    Transaction_ID VARCHAR(50) PRIMARY KEY,
    User_ID VARCHAR(50),
    Transaction_Amount DECIMAL(10,2),
    Transaction_Type VARCHAR(50),
    Timestamp DATETIME,
    Location_ID INT,
    Device_ID INT,
    Merchant_Category VARCHAR(50),
    IP_Address_Flag INT,
    Avg_Transaction_Amount_7d DECIMAL(10,2),
    Risk_Score DECIMAL(10,6),
    Fraud_Label INT,
    FOREIGN KEY (User_ID) REFERENCES accounts(User_ID),
    FOREIGN KEY (Location_ID) REFERENCES locations(Location_ID)
);

SET GLOBAL local_infile = 1;
USE banking_fraud_db;

-- Load Locations
LOAD DATA LOCAL INFILE 'C:/Users/HP/Downloads/Data Analytics Projects/data_analytics_project/Banking_Fraud_Project/Data/locations.csv'
INTO TABLE locations
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@col1, @col2) SET Location_Name = @col1, Location_ID = @col2;

-- Load Accounts
LOAD DATA LOCAL INFILE 'C:/Users/HP/Downloads/Data Analytics Projects/data_analytics_project/Banking_Fraud_Project/Data/accounts.csv'
INTO TABLE accounts
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Load Devices
LOAD DATA LOCAL INFILE 'C:/Users/HP/Downloads/Data Analytics Projects/data_analytics_project/Banking_Fraud_Project/Data/devices.csv'
INTO TABLE devices
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@col1, @col2, @col3) SET User_ID = @col1, Device_Type = @col2, Device_ID = @col3;

-- Load Transactions
LOAD DATA LOCAL INFILE 'C:/Users/HP/Downloads/Data Analytics Projects/data_analytics_project/Banking_Fraud_Project/Data/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT 
    User_ID, 
    Transaction_ID, 
    Transaction_Amount, 
    ROUND(AVG(Transaction_Amount) OVER(PARTITION BY User_ID ORDER BY Timestamp ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING), 2) AS Last_5_Avg,
    CASE 
        WHEN Transaction_Amount > (AVG(Transaction_Amount) OVER(PARTITION BY User_ID) * 2) THEN 'High Spike'
        ELSE 'Normal'
    END AS Spending_Behavior
FROM transactions
LIMIT 100;

WITH Travel_Data AS (
    SELECT 
        t.User_ID,
        t.Timestamp AS Txn_Time,
        l.Location_Name AS Loc_Name,
        LAG(l.Location_Name) OVER(PARTITION BY t.User_ID ORDER BY t.Timestamp) AS Prev_Loc,
        LAG(t.Timestamp) OVER(PARTITION BY t.User_ID ORDER BY t.Timestamp) AS Prev_Time
    FROM transactions t
    JOIN locations l ON t.Location_ID = l.Location_ID
)
SELECT 
    User_ID,
    Prev_Loc,
    Loc_Name AS Current_Loc,
    Prev_Time,
    Txn_Time,
    TIMESTAMPDIFF(MINUTE, Prev_Time, Txn_Time) AS Min_Diff
FROM Travel_Data
WHERE Prev_Loc IS NOT NULL 
  AND Prev_Loc <> Loc_Name
  AND TIMESTAMPDIFF(MINUTE, Prev_Time, Txn_Time) < 1440; -- Expanded to 24 hours to ensure you see results
  
  SELECT 
    Merchant_Category,
    COUNT(*) AS Total_Txn,
    SUM(Fraud_Label) AS Total_Fraud,
    ROUND(SUM(CASE WHEN Fraud_Label = 1 THEN Transaction_Amount ELSE 0 END), 2) AS Lost_Revenue
FROM transactions
GROUP BY Merchant_Category
ORDER BY Lost_Revenue DESC;

SELECT 
    Merchant_Category,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Label) AS Fraudulent_Count,
    ROUND((SUM(Fraud_Label) / COUNT(*)) * 100, 2) AS Fraud_Rate_Percent,
    ROUND(SUM(CASE WHEN Fraud_Label = 1 THEN Transaction_Amount ELSE 0 END), 2) AS Financial_Loss
FROM transactions
GROUP BY Merchant_Category
ORDER BY Financial_Loss DESC;

CREATE OR REPLACE VIEW v_fraud_analysis_summary AS
SELECT 
    t.Transaction_ID,
    t.User_ID,
    t.Timestamp AS Transaction_Time,
    t.Transaction_Amount,
    l.Location_Name,
    t.Merchant_Category,
    t.Risk_Score,
    -- Add the Fraud Status Label
    CASE 
        WHEN t.Fraud_Label = 1 THEN 'Confirmed Fraud'
        ELSE 'Legitimate'
    END AS Fraud_Status,
    -- Combine Risk Score and IP flag for a Priority Level
    CASE 
        WHEN t.Risk_Score > 0.8 OR t.IP_Address_Flag = 1 THEN 'Immediate Review'
        WHEN t.Risk_Score > 0.5 THEN 'Potential Risk'
        ELSE 'Safe'
    END AS Action_Priority
FROM transactions t
JOIN locations l ON t.Location_ID = l.Location_ID
JOIN accounts a ON t.User_ID = a.User_ID;

-- Run this to see your new summary table:
SELECT * FROM v_fraud_analysis_summary LIMIT 100;

SELECT * FROM locations;
SELECT * FROM accounts;
Select * From devices ;
SELECT * FROM transactions;