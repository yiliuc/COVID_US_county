#### Preamble ####
# Purpose: Simulate the data
# Author: Yiliu Cao
# Date: 1 October 2023
# Contact: yiliu.cao@mail.utoronto.ca
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
library(tidyverse)

#### Simulate data ####

data <- tibble(county = sample(c(1:3000)),
               infection_rate = runif(3000, min = 0, max = 1),
               death_rate = runif(3000, min = 0, max = 1),
               insurance = runif(3000, min = 0, max = 1),
               higher_education = runif(3000, min = 0, max = 0.5),
               winning_party = sample(x = c("Democrat", "Republican"), size = 3000, replace = TRUE))


