# Final Project - Analyzing Water Quality and Health Trends

# ---- Load Libraries ----
library(tidyverse)
library(janitor)
library(dplyr)
library(ggplot2)
library(sf)
library(maps)
library(patchwork)

# ---- Load theme ----
source("scripts/theme_regular.R")

# ---------- Nitrate ----------

# Read in raw df
raw_nitrate <- read.csv("data/nitrate_water.csv") %>% 
  clean_names()

# Filter to only surface water source
#surface <- filter(raw_nitrate, water_source == "Surface Water")

# Filter to only groundwater water source
#ground <- filter(raw_nitrate, water_source == "Groundwater")

# Read in Lat/Long Data for US Cities
coords <- read.csv("data/uscities.csv")

# Filter to only MN Cities
mn_coords <- filter(coords, state_name == "Minnesota")

# Left join raw_nitrate and mn_coords to get lat and long data per city
map_df <- left_join(raw_nitrate, mn_coords, by = c("city_served" = "city"))

# Replace "null" or blanks with NA, then convert to numeric
map_df_clean <- map_df %>%
  mutate(
    # Remove any strings (non-numeric)
    mean_clean = str_remove_all(mean, "[a-zA-Z/ ]"),
    # Handle the "null" text
    mean_clean = na_if(mean_clean, "null"),
    # Convert the leftover numbers to numeric
    mean_nitrate_num = as.numeric(mean_clean)
  ) %>%
  # Filter out rows that couldn't be converted or lack coordinates
  filter(!is.na(mean_nitrate_num), !is.na(lat), !is.na(lng))

# Get Minnesota county boundaries for the background
mn_counties <- st_as_sf(map("county", "minnesota", plot = FALSE, fill = TRUE))

# Create the plot
nitrates <- ggplot() +
  # Draw the background county map
  geom_sf(data = mn_counties, fill = "gray80", color = "white") +
  
  # Plot your data points
  geom_point(data = map_df_clean, aes(x = lng, y = lat, color = water_source, size = mean_nitrate_num), 
             alpha = 0.5) +
  
  # Styling the colors and scale
  scale_color_manual(values = c("Groundwater" = "#d95f02", "Surface Water" = "#1f78b4", "Purchased Surface Water" = "forestgreen", "Purchased Groundwater" = "purple")) +
  scale_size_continuous(range = c(2, 8), name = "Nitrate (mg/L)") +
  
  # Add labels and a professional theme
  labs(title = "Minnesota Nitrate Concentrations by Water Source (2013-2022)",
       subtitle = "Comparing Public Groundwater vs. Surface Water Systems",
       caption = "Data Source: MN Dept of Health Drinking Water Query",
       color = "Water Source Type",
       x = "Longitude",
       y = "Latitude") +
  theme_regular() +
  theme(legend.position = "right")

# Display nitrates plot
nitrates


# ---------- Colorectal Cancer Incidence for Nitrates ----------
# Only applying to nitrate concentration

# Read in data from MN Public Health Data Access about Colorectal Cancer Incidence per County
library(readxl)

cancer_df <- read_excel("data/county_cancer_data.xlsx") %>% 
  clean_names()

# Mutate col name in nitrates data frame so both data frames have "county" column
map_df_clean <- map_df_clean %>%
  mutate(county = str_to_title(county_served))

# Join cancer data to nitrate data by county 
joined_df <- map_df_clean %>% 
  left_join(cancer_df, by = "county")

# Clean and convert data types explicitly
joined_df_clean <- joined_df %>%
  mutate(
    mean_nitrate_num = as.numeric(as.character(mean_nitrate_num)),
    cancer_incidence = as.numeric(as.character(value))
  ) %>%
  filter(!is.na(mean_nitrate_num), !is.na(value))

# Visualize cancer data association with nitrates on a city level 
ggplot(joined_df_clean, aes(x = mean_nitrate_num, y = cancer_incidence)) + 
  geom_point(aes(color = water_source), alpha = 0.4) +
  geom_smooth(method = "lm", color = "darkred") +
  labs(title = "Nitrate Levels vs. Colorectal Cancer Incidence",
       x = "Mean Nitrate (mg/L)",
       y = "Cancer Incidence (per 100k)") +
  theme_regular()

# Summarize water data to the county level
county_water_summary <- map_df_clean %>%
  group_by(county) %>%
  summarise(avg_county_nitrate = mean(mean_nitrate_num, na.rm = TRUE))

# Join this summary to your cancer data
analysis_df <- county_water_summary %>%
  inner_join(cancer_df, by = "county")

# Clean and convert data types explicitly
analysis_df_clean <- analysis_df %>%
  mutate(
    avg_county_nitrate = as.numeric(as.character(avg_county_nitrate)),
    cancer_incidence = as.numeric(as.character(value))
  ) %>%
  filter(!is.na(avg_county_nitrate), !is.na(value))

# New scatter plot with one point per county
scatter_plot <- ggplot(analysis_df_clean, aes(x = avg_county_nitrate, y = cancer_incidence)) +
  geom_point(color = "steelblue", size = 3, alpha = 0.5) +
  geom_smooth(method = "lm", formula = y ~ x, color = "darkred", se = TRUE) + 
  labs(title = "Association Between Nitrates and Colorectal Cancer",
       x = "Nitrate (mg/L)",
       y = "Colorectal Cancer Incidence (per 100k)",
       caption = "Data sourced from MN Public Health Data Access") +
  theme_regular()

# Show scatter plot
scatter_plot

# ---------- Trying to map this association between nitrates and colorectal cancer ----------

# install.packages("biscale")
library(biscale)
library(sf)

#head(mn_counties)

# Clean the spatial data so the ID matches your county names
mn_counties_clean <- mn_counties %>%
  mutate(
    # Remove "minnesota" and capitalize the first letter of each word
    county_name = str_remove(ID, "minnesota,"),
    county_name = str_to_title(county_name)
  )

# Join the summarized water/cancer data to the map
final_map_df <- mn_counties_clean %>%
  left_join(analysis_df, by = c("county_name" = "county")) %>%
  mutate(
    # Force the incidence rate to be a number again
    incidence_rate = as.numeric(as.character(value))
  )

# Making Bivariate Choropleth Map
combined_map <- ggplot() +
  # 1. Fill counties by Cancer Incidence
  geom_sf(data = final_map_df, aes(fill = incidence_rate), color = "white", size = 0.2) +
  scale_fill_viridis_c(option = "magma", name = "Cancer Rate", na.value = "gray90") +
  
  # 2. Add points for Nitrates (using your original city-level data)
  geom_point(data = map_df_clean, aes(x = lng, y = lat, size = mean_nitrate_num), 
             color = "deepskyblue4", alpha = 0.3) +
  scale_size_continuous(range = c(1, 5), name = "Nitrate (mg/L)") +
  
  labs(title = "Comparing Nitrate Levels in Water and Cancer Incidence Rates",
       x = "Longitude",
       y = "Latitude",
       caption = "Data sourced from MN Public Health Data Access") +
  theme_regular()

# Show "Comparing Nitrate Levels in Water and County Cancer Incidence Rates" Map
combined_map

# ---------- Viewing and Saving Graphs ----------

# All plots
# nitrates
# 
# scatter_plot
# 
# combined_map

# Patchwork graphs together
# combined_map / scatter_plot