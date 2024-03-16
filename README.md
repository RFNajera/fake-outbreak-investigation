# Fake Outbreak Investigation Using R and Python

First things first: The data set in this repository is __fake__. I cannot emphasize this enough. It is intended for teaching purposes only. Please feel free to fork the repository and play with the code and data as you wish. Second, the data in this repository is different from what was in the blog post on Medium. I added onset dates, and the data were re-created. I've also changed the code to include an epi curve based on the results.

## The Data
The __fake__ data consists of 1,000 records. Within those 1,000 records are 723 non-ill people and 277 ill people. It also includes columns for each food item and a variable indicating if the person ate it or did not eat it.

## Attack Rates
This is what the attack rates should look like after you process the data.

| Food Item    | Attack Rate |
|--------------|-------------|
| Baked Potato | 77.85%      |
| Fish         | 32.32%      |
| Dessert      | 27.96%      |
| Agua Fresca  | 28.11%      |
| Soda         | 27.43%      |
| Bottle Water | NA      |
| Beef         | 26.99%      |
| Chicken      | 21.22%      |
| Salad        | 8.24%      |

## Odds Ratios and 95% Confidence Intervals
This is what the odds ratios and statistical significance should look like. You may see some variation depending on whether you're using the Fisher's Exact Test or Chi Square test.

| Variable       | Odds_Ratio | Conf_Interval_From | Conf_Interval_To | X_Squared_Statistic | p_Value   | Significant? |
|----------------|------------|--------------------|------------------|---------------------|-----------|--------------|
| baked_potato   | 94.6       | 57.6               | 161.0            | 601.0               | 1.09e-132 | Yes          |
| salad          | 0.138      | 0.0894             | 0.208            | 112.0               | 3.02e-26  | Yes          |
| soda           | 0.975      | 0.731              | 1.30             | 0.0113              | 9.15e-1   | No           |
| bottle_water   | NA         | NA                 | NA               | 199.0               | 3.60e-45  | Yes          |
| agua_fresca    | 1.04       | 0.783              | 1.39             | 0.0531              | 8.18e-1   | No           |
| dessert        | 1.14       | 0.706              | 1.87             | 0.183               | 6.69e-1   | No           |
| beef           | 0.951      | 0.689              | 1.31             | 0.0586              | 8.09e-1   | No           |
| chicken        | 0.611      | 0.437              | 0.845            | 8.99                | 2.71e-3   | Yes          |
| fish           | 1.53       | 1.15               | 2.05             | 8.70                | 3.19e-3   | Yes          |

