# Load necessary libraries
library(tidyverse)
library(gt)

# 1. DATA LOADING AND INITIAL PREPARATION ----

# Load the data from a CSV file into a dataframe called 'df'
df <- read_csv("fake_outbreak_dataset.csv")

# Convert all columns except 'personID' to factor data type
# The '[,-1]' selects all columns except the first one (assuming 'personID' is the first)
df <- df %>% 
  mutate(across(-personID, as.factor)) 

# Display a summary of the dataframe, showing frequencies of all variables
summary(df)

# 2. ATTACK RATE ANALYSIS ----

# Define a function to calculate attack rates for given items
calculate_attack_rate <- function(data, item) {
  data %>%
    group_by(!!sym(item)) %>%
    summarise(Total = n(),
              Ill = sum(illness == 'Y'),
              Attack_Rate = Ill / Total * 100) %>% # Calculate as percentage
    mutate(Item = item) %>% # Add the item as a column
    select(Item, !!sym(item), Total, Ill, Attack_Rate) # Select and order columns
}

# Define the items (variables) to calculate attack rates for, excluding 'personID' and another column
items <- names(df)[3:ncol(df)]

# Calculate attack rates for each item and combine the results into one dataframe
attack_rates <- map_df(items, calculate_attack_rate, data = df)

# Prettier table
attack_rates %>%
  gt() %>%
  tab_header(
    title = "Attack Rates",
    subtitle = "Calculated attack rates for various items"
  ) %>%
  fmt_integer(
    columns = vars(Attack_Rate)
  ) %>%
  cols_label(
    Item = "Item",
    Total = "Total Cases",
    Ill = "Number Ill",
    Attack_Rate = "Attack Rate (%)"
  )


# Display the attack rate results
print(attack_rates)

# 3. STATISTICAL ANALYSIS ----

# Define a function to perform chi-square tests and calculate odds ratio for a dependent variable against all factor variables
perform_chi_square <- function(data, dependent_var) {
  
  # Identify all factor variables excluding the dependent variable
  factor_vars <- names(select(data, where(is.factor))) %>% setdiff(dependent_var) 
  
  results_summary <- purrr::map(factor_vars, function(var) {
    cat("\nAnalyzing:", var, "against", dependent_var, "\n")
    
    cross_tab <- table(data[[var]], data[[dependent_var]])
    
    cat("Cross Table:\n")
    print(cross_tab)
    
    # Perform Fisher's Exact Test for 2x2 tables to calculate Odds Ratio
    if (all(dim(cross_tab) == c(2, 2))) {
      odds_ratio_test <- fisher.test(cross_tab)
      odds_ratio <- odds_ratio_test$estimate
      conf_interval <- odds_ratio_test$conf.int
      cat("Odds Ratio:", odds_ratio, "\n")
      cat("95% Confidence Interval for Odds Ratio:", conf_interval[1], "to", conf_interval[2], "\n")
    } else {
      odds_ratio <- NA
      conf_interval <- c(NA, NA)
      cat("Odds Ratio and Confidence Interval not calculated, table not 2x2.\n")
    }
    
    # Perform Chi-square test
    chi_test_result <- chisq.test(cross_tab)
    cat("\nChi-square Test:\n")
    print(chi_test_result)
    
    # Compile test results into a list
    list(
      Variable = var,
      Odds_Ratio = odds_ratio,
      Conf_Interval_From = conf_interval[1],
      Conf_Interval_To = conf_interval[2],
      X_Squared_Statistic = chi_test_result$statistic,
      p_Value = chi_test_result$p.value
    )
  }) %>% bind_rows() # Combine all lists into a dataframe
  
  # Return the compiled results
  results_summary
}

# Execute the chi-square analysis function for each variable against "illness" and print results
results_summary <- perform_chi_square(df, "illness")
print(results_summary)
