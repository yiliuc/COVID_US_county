# Examining the COVID-19 Mortality Rate in the US: While It Varies Across Different Income Levels, the Impact of Political Preference is Unignorable (STA497)

## Overview

This paper uses the 2020 U.S. Election data from Fox News (assembled by Tony McGovern), COVID-19 data from Center for Systems Science and Engineering at Johns Hopkins University and U.S. socio-economic data from American Community Survey (ACS), to build a model in predicting a county's mortality rate with incorporating the county's political preference. Specifically, we perform multiple linear regression and use Cross-Validation to test our resulting model.

## File Structure

The repo is structured as:

-   `input/data` contains the data sources used in analysis including the raw data.
-   `outputs/data` contains the cleaned dataset that was constructed.
-   `outputs/paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.