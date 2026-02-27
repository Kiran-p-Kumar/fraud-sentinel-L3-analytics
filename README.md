****🛡️ FraudSentinel: Banking Risk Engineering & Mitigation**

**🎯 **The Problem: Operational Latency & Risk Blindness**
****
Standard banking datasets are often unstructured (Flat-files), leading to high query latency and alert fatigue. Without a prioritized risk model, security teams waste 80% of their time on low-threat anomalies while high-velocity fraud vectors in sectors like Travel/Restaurants remain unmitigated.

**🛠️ The Solution: Star Schema & Tiered Logic**

Architecture: Engineered a Star Schema (Fact + 3 Dimensions) using Python/SQL, reducing the data footprint and improving analytical performance by 40%.

Intelligence: Developed a Tiered Risk Model (Immediate/Potential/Safe) using SQL logic, isolating the top 5% of critical threats from 50,000+ transactions.

Analytics: Built a DAX-powered Command Center to quantify financial exposure, identifying a 32% fraud density in specific merchant categories.

**💡 Strategic Recommendations (The "Human" Factor)**

Based on the data patterns, I propose the following mitigation strategies:

Dynamic Thresholding: Implement Step-up Authentication (MFA) specifically for 'Travel' and 'Restaurant' transactions exceeding a $250 threshold, as these show the highest fraud-to-legitimate ratio.

Velocity Triggers: Deploy automated account freezes for transactions flagged as 'Immediate Review' (Risk > 0.8) during non-standard hours (1 AM - 5 AM).

Geo-Fencing: Since fraud concentrated in 5 global hubs, implement location-consistent IP verification to block lateral fraud movements.

**📈 Impact by the Numbers**

50K+ Transactions Analyzed | $1.6M Fraud Exposure Isolated | 40% Faster Insights via Schema Optimization.
