#### Preamble ####
# Purpose: Downloads and saves the data from ACS API
# Author: Yiliu Cao
# Date: 1 October 2023
# Contact: yiliu.cao@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

#### Download data ####
url02 <- "https://api.census.gov/data/2021/acs/acs5/profile?get=group(DP02)&for=county:*"
DP02 <- read.csv(url(url02), stringsAsFactors = FALSE)
url03 <- "https://api.census.gov/data/2021/acs/acs5/profile?get=group(DP03)&for=county:*"
DP03 <- read.csv(url(url03), stringsAsFactors = FALSE)
url05 <- "https://api.census.gov/data/2021/acs/acs5/profile?get=group(DP05)&for=county:*"
DP05 <- read.csv(url(url05), stringsAsFactors = FALSE)

url_covid <- paste0(
  "https://raw.githubusercontent.com/CSSEGISandData/",
   "COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/",
   "03-09-2023.csv")
covid_data <- read.csv(url_covid, header = TRUE, sep = ",")

url_election <- paste0(
  "https://raw.githubusercontent.com/tonmcg/US_County_Level_Election_Results_08-20/",
  "master/2020_US_County_Level_Presidential_Results.csv")
election_data <- read.csv(url_election, header = TRUE, sep = ",")

#### Save data ####
write_csv(DP02, "inputs/data/DP_02.csv")
write_csv(DP03, "inputs/data/DP_03.csv")
write_csv(DP05, "inputs/data/DP_05.csv")
write_csv(covid_data, "inputs/data/covid_data.csv")
write_csv(election_data, "inputs/data/election_data.csv")
         
