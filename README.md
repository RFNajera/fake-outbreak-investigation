# Fake Outbreak Investigation
The data set in this repository is __fake__. I cannot emphasize this enough. It is meant for teaching purposes only. Please feel free to fork the repository and play with the code and data as you wish.

## Attack Rates
This is what the attack rates should look like after you process the data.

| Food Item    | Attack Rate |
|--------------|-------------|
| Baked Potato | 79.43%      |
| Fish         | 35.81%      |
| Dessert      | 32.59%      |
| Agua Fresca  | 32.44%      |
| Soda         | 32.23%      |
| Bottle Water | 31.90%      |
| Beef         | 30.40%      |
| Chicken      | 25.24%      |
| Salad        | 10.22%      |

## Odds Ratios and 95% Confidence Intervals
This is what the odds ratios and statistical significance should look like. You may see some variation depending on whether you're using the Fisher's Exact Test or Chi Square test.

| Food Item    | Odds Ratio | 95% CI Lower | 95% CI Upper | Significant? |
|--------------|------------|--------------|--------------|--------------|
| Baked Potato | 57.35      | 38.10        | 86.32        | Yes          |
| Salad        | 0.13       | 0.09         | 0.19         | Yes          |
| Soda         | 1.03       | 0.79         | 1.35         | No           |
| Agua Fresca  | 1.05       | 0.80         | 1.37         | No           |
| Dessert      | 1.39       | 0.87         | 2.23         | No           |
| Beef         | 0.91       | 0.67         | 1.23         | No           |
| Chicken      | 0.63       | 0.47         | 0.85         | Yes          |
| Fish         | 1.41       | 1.08         | 1.84         | Yes          |
