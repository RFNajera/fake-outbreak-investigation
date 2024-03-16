import pandas as pd
import numpy as np
from scipy.stats import chi2_contingency, fisher_exact
import statsmodels.api as sm
import statsmodels.formula.api as smf
import matplotlib.pyplot as plt

# 1. DATA LOADING AND INITIAL PREPARATION ----

# Load the data
df = pd.read_csv("fake_outbreak_dataset.csv")

# Convert all columns except 'personID' and the dates to 'category' dtype
# Define a list of columns to exclude from being converted to 'category' data type
exclude_columns = ['personID', 'onset_date', 'exposure_date']

# Loop through all columns and convert them to 'category' data type except the excluded ones
for col in df.columns:
    if col not in exclude_columns:
        df[col] = df[col].astype('category')

        
# Display a summary (Python equivalent does not directly compute frequencies like R's summary)
print(df.describe(include='all'))

# 2. ATTACK RATE ANALYSIS ----

def calculate_attack_rate(data, item):
    grouped = data.groupby(item).agg(Total=('illness', 'count'),
                                      Ill=('illness', lambda x: (x == 'Y').sum()))
    grouped['Attack_Rate'] = grouped['Ill'] / grouped['Total'] * 100
    grouped.reset_index(inplace=True)
    grouped['Item'] = item  # Add the item as a column for identification
    return grouped[['Item', item, 'Total', 'Ill', 'Attack_Rate']]

items = df.columns[2:11]  # Assuming 'personID' and 'illness' are first two columns

# Using a list comprehension and Pandas concat to mimic R's map_df functionality
attack_rates = pd.concat([calculate_attack_rate(df, item) for item in items], ignore_index=True)
print(attack_rates)

# 3. STATISTICAL ANALYSIS ----

def perform_chi_square(data, dependent_var):
    results = []
    factor_vars = data.select_dtypes(include=['category']).columns.drop([dependent_var])

    for var in factor_vars:
        print(f"\nAnalyzing: {var} against {dependent_var}")
        
        cross_tab = pd.crosstab(data[var], data[dependent_var])
        print("Cross Table:\n", cross_tab)
        
        chi2, p, dof, expected = chi2_contingency(cross_tab)
        print(f"\nChi-square Test:\nChi2: {chi2}, p-value: {p}")
        
        # Fisher's Exact Test and odds ratio calculation for 2x2 tables
        if cross_tab.shape == (2, 2):
            odds_ratio, p_value = fisher_exact(cross_tab)
            print(f"Odds Ratio: {odds_ratio}, p-value (Fisher's Exact): {p_value}")
        else:
            odds_ratio = np.nan
            print("Odds Ratio not calculated, table not 2x2.")
        
        results.append({
            'Variable': var,
            'Odds_Ratio': odds_ratio,
            'X_Squared_Statistic': chi2,
            'p_Value': p
        })
        
    return pd.DataFrame(results)

results_summary = perform_chi_square(df, 'illness')
print(results_summary)

# 4. EPI CURVE ----

# Convert 'onset_date' to datetime format
df['onset_date'] = pd.to_datetime(df['onset_date'])

# Make the epi curve
plt.figure(figsize=(10, 6))
# Calculate the number of bins based on the range of dates and desired width of each bin (21600 seconds or 6 hours here)
bin_width_seconds = 21600  # 6 hours in seconds
num_bins = int((df['onset_date'].max() - df['onset_date'].min()).total_seconds() / bin_width_seconds)

sns.histplot(data=df, x='onset_date', bins=num_bins)
plt.title("Epidemiological Curve of Onset Dates")
plt.xlabel("Onset Date")
plt.ylabel("Number of Cases")
plt.xticks(rotation=90)
plt.show()
plt.clf()
