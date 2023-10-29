#### Preamble ####
# Purpose: Clean the all the raw data (ACS, Census)
# Author: Yiliu Cao
# Date: 1 October 2023
# Contact: yiliu.cao@mail.utoronto.ca
# License: MIT
# Pre-requisites: run 01-download_data.R to have the raw data

#### Workspace setup ####
library(dplyr)
library(stringr)
library(tidyverse)
library(janitor)

# Import all the raw data
DP02 <- read.csv("inputs/data/DP_02.csv")
DP03 <- read.csv("inputs/data/DP_03.csv")
DP05 <- read.csv("inputs/data/DP_05.csv")
covid_data <- read.csv("inputs/data/covid_data.csv")
election_data <- read.csv("inputs/data/election_data.csv")

# Convert full state name to its abbreviation.
get_state_abbreviation <- function(state_names) {
  sapply(state_names, function(state_name) {
    state_data <- state.abb[match(state_name, state.name)]
    if (!is.na(state_data)) {
      return(state_data)
    } else {
      return(NA)  # changed from NULL to NA for consistency in a vector
    }
  })
}

# Extract the county name from a 'County, State' formatted string.
extract_county <- function(name) {
  if (!is.na(name) && str_detect(name, ",")) {
    return(str_replace(str_split(name, ",")[[1]][1], " County", ""))
  } 
  else if (!is.na(name)) {
    return(str_replace(str_split(name, " ")[[1]][1], " County", ""))
  }
  else {
    return(NA)
  }
}

# Extract the state abbreviation from a 'County, State' formatted string.
extract_state <- function(name) {
  if (!is.na(name) && str_detect(name, ",")) {
    return(get_state_abbreviation(str_trim(str_split(name, ",")[[1]][2])))
  } else {
    return(NA)
  }
}

# Clean and rename columns in a DataFrame.
data_cleaning <- function(df, rename_dict) {
  df <- df[-1, ]  # Remove the first row
  df$county <- sapply(df$NAME, extract_county)
  df$state <- sapply(df$NAME, extract_state)
  columns_to_select <- c("county", "state", names(rename_dict))
  selected_df <- df[, columns_to_select, drop = FALSE]
  colnames(selected_df) <- c("county", "state", rename_dict)
  selected_df <- na.omit(selected_df)
  # selected_df$state <- unlist(selected_df$state)
  return(selected_df %>% arrange(state, county))
}

dict_02 <- c("DP02_0068PE" = "prop_higher_education")
dict_03 <- c("DP03_0063E" = "mean_household_income",
             "DP03_0009PE" = "unemployment",
             "DP03_0097PE" = "private_insurance",
             "DP03_0098PE" = "public_insurance",
             "DP03_0099PE" = "no_insurance")
dict_05 <- c("DP05_0001PE" = "total_population",
             "DP05_0002PE" = "males",
             "DP05_0003PE" = "females",
             "DP05_0017PE" = "old_85",
             "DP05_0019PE" = "children",
             "DP05_0024PE" = "old_65",
             "DP05_0037PE" = "white_pct",
             "DP05_0038PE" = "black_pct")

# Clean all the ACS raw data
DP02_clean <- data_cleaning(DP02, dict_02)
DP03_clean <- data_cleaning(DP03, dict_03)
DP05_clean <- data_cleaning(DP05, dict_05)

# Clean the covid data
covid_data_clean <- covid_data %>% 
  filter(Country_Region == "US") %>% 
  select(FIPS, Admin2, Province_State, Confirmed, Deaths) %>% 
  rename(`county` = Admin2,
         `state` = Province_State,
         `cases` = Confirmed) %>%
  mutate(state = get_state_abbreviation(state)) %>% 
  clean_names()

covid_data_clean <- na.omit(covid_data_clean)

# Clean the election data
election_data_clean <- election_data %>% 
  mutate(county = sapply(county_name, extract_county),
         state = unlist(get_state_abbreviation(state_name))) %>% 
  select(state, county,votes_gop, votes_dem, total_votes) %>% 
  rename(`votes_rep` = votes_gop)
election_data_clean <- election_data_clean %>% 
  mutate(party = case_when(votes_rep > votes_dem ~ "Republican",
                           votes_rep < votes_dem ~ "Democratic",
                           TRUE ~ "Equal"))
election_data_clean <- na.omit(election_data_clean)

# Merge the five data sets. The merged data set will be the data in this paper
merged_data <- DP02_clean %>%
  inner_join(DP03_clean, by = c("state", "county")) %>%
  inner_join(DP05_clean, by = c("state", "county")) %>%
  inner_join(covid_data_clean, by = c("state", "county")) %>%
  inner_join(election_data_clean, by = c("state", "county"))

merged_data$infection_rate <- (merged_data$cases/merged_data$total_population)*1000
merged_data$death_rate <- (merged_data$deaths/merged_data$total_population)*1000

# Export all the cleaned data sets and merged data sets
write.csv(DP02_clean, "outputs/data/DP02_clean.csv", row.names = FALSE)
write.csv(DP03_clean, "outputs/data/DP03_clean.csv", row.names = FALSE)
write.csv(DP05_clean, "outputs/data/DP05_clean.csv", row.names = FALSE)
write.csv(covid_data_clean, 
          "outputs/data/covid_data_clean.csv", row.names = FALSE)
write.csv(election_data_clean, 
          "outputs/data/election_data_clean.csv", row.names = FALSE)
write.csv(merged_data, "outputs/data/merged_data.csv", row.names = FALSE)
