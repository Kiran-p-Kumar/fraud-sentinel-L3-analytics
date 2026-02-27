import pandas as pd

# Load your original dataset
file_name = 'synthetic_fraud_dataset.csv'
df = pd.read_csv(file_name)

# 1. Create Accounts Table
accounts = df.groupby('User_ID').agg({
    'Account_Balance': 'last',
    'Previous_Fraudulent_Activity': 'max'
}).reset_index()
accounts.to_csv('accounts.csv', index=False)

# 2. Create Locations Table
locations = pd.DataFrame({'Location_Name': df['Location'].unique()})
locations['Location_ID'] = range(1, len(locations) + 1)
locations.to_csv('locations.csv', index=False)

# 3. Create Devices Table
devices = df[['User_ID', 'Device_Type']].drop_duplicates()
devices['Device_ID'] = range(1, len(devices) + 1)
devices.to_csv('devices.csv', index=False)

# 4. Create Transactions Table (with Foreign Keys)
df_final = df.merge(locations, left_on='Location', right_on='Location_Name', how='left')
df_final = df_final.merge(devices, on=['User_ID', 'Device_Type'], how='left')

transactions = df_final[[
    'Transaction_ID', 'User_ID', 'Transaction_Amount', 'Transaction_Type', 
    'Timestamp', 'Location_ID', 'Device_ID', 'Merchant_Category', 
    'IP_Address_Flag', 'Avg_Transaction_Amount_7d', 'Risk_Score', 'Fraud_Label'
]]
transactions.to_csv('transactions.csv', index=False)

print("Success! You now have: accounts.csv, locations.csv, devices.csv, transactions.csv")