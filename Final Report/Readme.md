# 🛡️ Global Banking Fraud Analytics System

## Project Overview
This end-to-end data analytics project focuses on identifying, monitoring, and mitigating fraudulent activities within a global banking network. Using a combination of **Python** for data synthesis, **SQL** for complex anomaly detection, and **Power BI** for executive-level visualization, this system provides real-time insights into high-risk transaction patterns.

---

## 📊 Interactive Power BI Dashboard

Below is a snapshot of the fully interactive Power BI dashboard, designed with a modern "FinTech Command Center" aesthetic, featuring a deep navy background and striking aqua green accents.

[Dashboard screen shot](<Screenshot 2025-12-31 120143.png>)

---

## 📈 Business Insights & Strategic Recommendations

Based on the current data visualization, we have identified four critical business insights, their likely causes, and strategic solutions:

### 1. Spending Volatility & Seasonal Spikes (February & August)
* **Insight**: The Area Chart, showing "Sum of Transaction Amount by Quarter and Month," clearly highlights significant spikes in transaction volume during February and August, followed by sharp declines.
* **Cause**: This cyclical pattern often indicates periods where fraudsters either launch large-scale bot attacks (during high-traffic months to blend in) or conduct "testing" phases to identify system vulnerabilities. These could also correlate with specific seasonal events driving transaction volume, which fraudsters exploit.
* **Solution**: Implement **Dynamic Velocity Limits** during these peak months. If a user’s transaction frequency (e.g., number of transactions per hour) exceeds their 12-month rolling average by 50% during these periods, trigger an immediate SMS Multi-Factor Authentication (MFA) or a temporary transaction hold.

### 2. Elevated Risk Profile by Device Type (Tablets)
* **Insight**: The "Sum of Risk_Score by Device_Type" Bar Chart reveals that "Tablets" carry a higher cumulative Risk Score ($8.5\text{K}$) compared to Laptops and Mobile devices, indicating they are associated with more risky transactions.
* **Cause**: Older tablet operating systems or less frequently updated devices often lack the advanced biometric security features (e.g., FaceID, fingerprint scanners) found on modern smartphones, making them a preferred tool for fraudsters performing manual transaction entry or account takeovers.
* **Solution**: Enforce **Enhanced Device Fingerprinting** and authentication for tablet-originated transactions. Require re-authorization (e.g., push notification to a trusted mobile device) for any tablet-based transaction over $500$ and flag devices running outdated OS versions for automated behavioral analytics or manual review.

### 3. Geographic Anomaly Concentration (Mumbai & London)
* **Insight**: The "Location_Name" Tile Slicer, when interacted with, helps pinpoint that high transaction volumes and potential anomalies are often concentrated between specific global hubs like London and Mumbai (though not explicitly shown on the static screenshot, this is an interactive insight).
* **Cause**: This often points to "Impossible Travel" fraud, where a user appears to transact in two geographically distant locations within an implausibly short timeframe. These high-traffic financial centers are prime targets for cross-border fraud attempts.
* **Solution**: Deploy **Geospatial Fencing with Time-Based Rules**. If a transaction is initiated in Mumbai less than 6 hours after a physical card swipe (or IP-verified login) in London, the system should automatically "Soft Block" the card or account until the user confirms the activity via a secure banking app notification or registered phone call.

### 4. Merchant Category Vulnerability (Clothing & Electronics)
* **Insight**: The "User_ID, Merchant_Category, Sum of Risk_Score, Sum of Transaction_Amount" Table (drill-down) indicates that "Clothing" and "Electronics" merchant categories are associated with high transaction amounts and significant risk scores for individual users.
* **Cause**: These categories represent "High Resale Value" items. Fraudsters frequently target these goods because they can be quickly converted into cash on secondary markets, making them attractive targets for illicit gains.
* **Solution**: Implement **Category-Specific Risk Scoring with Transaction Holds**. Transactions within "Clothing" and "Electronics" sectors that exceed a defined `Risk_Score` threshold (e.g., >0.75) should trigger an automated "Hold" period (e.g., 1 hour). During this hold, real-time fraud pattern matching can occur, and customers can be proactively contacted before funds are fully settled.

---

## 💻 SQL Implementations for Fraud Detection

To drive the robust analytics and anomaly detection, we implemented four key SQL queries:

1.  **Spending Spike Detection**: Utilized `AVG() OVER(PARTITION BY User_ID ORDER BY Timestamp ROWS BETWEEN 10 PRECEDING AND 1 PRECEDING)` window functions to identify individual transactions significantly higher than a user's recent spending history.
2.  **"Impossible Travel" Anomaly**: Employed `LAG(Location_Name)` and `LAG(Timestamp)` with `TIMESTAMPDIFF()` to calculate time differences between consecutive transactions, flagging rapid, geographically impossible movements.
3.  **High-Risk Profile Detection**: Combined multiple "Red Flags" by filtering for transactions with `Risk_Score > 0.8` AND `IP_Address_Flag = 1` to prioritize critical alerts.
4.  **Strategic Merchant Fraud Report**: Aggregated data using `COUNT(*)`, `SUM(Fraud_Label)`, and `SUM(CASE WHEN Fraud_Label = 1 THEN Transaction_Amount ELSE 0 END)` to quantify financial loss and fraud rates by `Merchant_Category`.

---

## 🛠️ Technical Challenges & Resolutions

During the development of this project, several technical hurdles were encountered. Below is a summary of how they were resolved to ensure a professional-grade output:

### 1. Data Granularity & Area Chart Rendering
* **The Challenge**: Initially, the "Spending Trend" Area Chart displayed only a single data point because the X-axis was set to the 'Year' level. This prevented the "filling" effect of the area chart.
* **The Solution**: I transitioned the X-axis from a high-level 'Year' hierarchy to a more granular **'Month/Quarter'** view. By expanding the hierarchy levels, I allowed Power BI to plot multiple points, enabling the "Aqua Lightning" fill effect that visually represents seasonal spending volatility.

### 2. UI/UX: Modern Interactive Filtering (Slicer)
* **The Challenge**: Standard slicers appeared as basic lists, which clashed with the intended "FinTech Command Center" aesthetic and lacked modern interactive feedback.
* **The Solution**: I implemented the **Slicer (New)** visual, utilizing **Tile** styling. I configured custom "Button States" where the button "lights up" in Aqua Green when selected, along with rounded corners and an accent bar, providing a more intuitive and responsive user experience.

### 3. Metric Accuracy & Clarity (Sum vs. Average Risk Score)
* **The Challenge**: Default aggregations in Power BI often used 'Sum' for the 'Risk Score' metric, which was misleading as it inflated the perceived danger based on transaction volume rather than the actual intensity of risk per event.
* **The Solution**: I adjusted the aggregation logic to **Average** for the Risk Score KPI card and relevant visuals. This ensures that the dashboard accurately reflects the *intensity* of fraud risk per transaction, providing a more precise measure for analysts.

### 4. Database Optimization & Performance
* **The Challenge**: Working with a single, large flat CSV file (50,000+ rows) made it challenging to run complex analytical queries efficiently and integrate data effectively into Power BI.
* **The Solution**: I designed and implemented a **Star Schema** in MySQL. This involved splitting the raw data into a central `fact_transactions` table linked to several dimension tables (`dim_locations`, `dim_accounts`, `dim_devices`). This structure significantly improved query performance, reduced data redundancy, and made the Power BI data model cleaner and more scalable.

---

## 🚀 Future Scope
This project lays a strong foundation for advanced fraud analytics. Future enhancements could include:
* Integrating **Machine Learning models** (e.g., Isolation Forest, XGBoost) for real-time anomaly detection and predictive scoring.
* Developing **real-time streaming analytics** to process transactions as they occur, enabling instant fraud alerts.
* Incorporating **Network Graph Analysis** to visualize complex fraud rings and relationships between accounts.

---

## 🛠️ Tech Stack
* **Data Cleaning & Synthesis**: Python (Pandas, NumPy)
* **Database Management**: MySQL Workbench (Star Schema Design, SQL Queries)
* **Data Analysis**: Advanced DAX (Data Analysis Expressions) in Power BI
* **Visualization & Reporting**: Power BI Desktop (Dashboard Design, UI/UX Principles)

---