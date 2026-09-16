# Minnesota Water Quality & Colorectal Cancer Analysis

## Project Overview
This project aggregates, cleans, and integrates large public health and environmental datasets sourced from the Minnesota Public Health Data Access portal. The goal was to evaluate and visualize potential epidemiological correlations between drinking water nitrate concentrations and colorectal cancer incidence rates at both city and county levels.

## Key Technical Features
* **Data Harmonization:** Used `left_join` and `inner_join` in R to merge disparate spatial, environmental, and medical datasets across shared geographic attributes.
* **Data Cleaning & Type Constraints:** Developed automated text-scrubbing pipelines using `tidyverse` to strip alphanumeric string anomalies, handle missing values (`na_if`), and enforce numeric restrictions (`as.numeric`).
* **Biostatistical Modeling:** Applied linear regression trendlines (`geom_smooth`) to analyze incidence weights per 100k residents.
* **Spatial Visualization:** Constructed bivariate choropleth mapping configurations using `ggplot2` and `sf` spatial boundaries.

## Key Visualizations

### 1. Regional Comparison Map
![Comparing Nitrate Levels and Cancer Rates](Comparing_Nitrate_Levels_and_Cancer_Rates.png)

### 2. Statistical Correlation
![Association Between Nitrates and Cancer](Association_Between_Nitrates_and_Colorectal_Cancer.png)

## Technologies Used
* **Language:** R
* **Libraries:** `tidyverse`, `sf`, `ggplot2`, `dplyr`, `janitor`, `maps`
