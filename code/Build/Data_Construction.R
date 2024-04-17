# ---------------------------------------------------------------------------------------------
# File: Data_Construction.R
# By: Eric Zhao
# Date: 02/29/2024
# Description: This file Transform your base data file into analysis data files. 
# ---------------------------------------------------------------------------------------------

#library preparation
# Store string containing all required packages
my_packages <- c("readxl","readr", "tidyverse","stringr")

# Store all installed packages
ya_loaded <- (.packages())

# Check whether required packages are already installed and grab only those that still need installation
need_load<-my_packages[!(my_packages %in% ya_loaded)]

# Load required packages
lapply(need_load, require, character.only = TRUE)

#opening based data files
social_capital_ma_ny<-read_csv("data/Base_Data/Social_Capital_ma_ny.csv")
CClaim_ma<-read_csv("data/Base_Data/UI_CClaim_ma_2122_cleaned.csv")
CClaim_ny<-read_csv("data/Base_Data/UI_CClaim_ny_2122_cleaned.csv")
Unemployed_ma<-read_csv("data/Base_Data/Unemployment_ma_2122_cleaned.csv")
Unemployed_ny<-read_csv("data/Base_Data/Unemployment_ny_2122_cleaned.csv")

#generating new variable
#Matching variables
CClaim_ma<-CClaim_ma %>%select(-1) %>% mutate(County=tolower(County),
                                              County=str_remove(County, 'county'),
                                              County=trimws(County))
CClaim_ny<-CClaim_ny %>%select(-1) %>% mutate(County=tolower(County), County=trimws(County))
Unemployed_ma<- Unemployed_ma%>% select(-1) %>% mutate( `MA Area` = str_remove(`MA Area`, " COUNTY"),  # Remove the specified substring
                                            `MA Area` = tolower(`MA Area`)) %>% rename(County=`MA Area`, Time=`YearMonth`)%>% mutate(County = trimws(County))
Unemployed_ny<- Unemployed_ny%>% select(-1) %>% mutate( `NY Area` = tolower(`NY Area`),
  `NY Area` = str_remove(`NY Area`, " county"))%>%   # Remove the specified substring 
                                  rename(County=`NY Area`, Time=`YearMonth`) %>% mutate(County = trimws(County))

merged_unemployed_claim_ma<-merge(Unemployed_ma, CClaim_ma)

merged_unmeployed_claim_ny<-merge(Unemployed_ny, CClaim_ny)
#Generating outcome variable 
merged_unemployed_claim_ma$recip_rate<-merged_unemployed_claim_ma$Claims/merged_unemployed_claim_ma$Unemployed
merged_unmeployed_claim_ny$recip_rate<-merged_unmeployed_claim_ny$Claims/merged_unmeployed_claim_ny$Unemployed

#transforming variables
social_capital_ny<-social_capital_ma_ny[,-1] %>%
  filter(grepl("New York", county_name))


# Extract county names
social_capital_ny$County <- sub(", New York", "", social_capital_ny$county_name)

# Step 2: Standardize formats (optional step, depending on your data)
# Convert to lowercase and trim whitespace for consistent matching
social_capital_ny$County <- tolower(trimws(social_capital_ny$County))
merged_unmeployed_claim_ny$County <- tolower(trimws(merged_unmeployed_claim_ny$County))

# Step 3: Matching entries
# Option A: Merge datasets based on the county names
merged_df <- merge(social_capital_ny, merged_unmeployed_claim_ny, by='County', all=TRUE)

# # Option B: Find matching entries (if you only need to know which rows match)
# df1$matched <- df1$county_extracted %in% df2$county_name

#saving intermediate and analysis data files
write_csv(merged_unemployed_claim_ma, "data/Analysis_Data/merged_outcome_ma.csv")
write_csv(merged_unmeployed_claim_ny, "data/Analysis_Data/merged_outcome_ny.csv")
write_csv(merged_df, "data/Analysis_Data/merged_outcome_socialcaptial_ny.csv")
write_csv(social_capital_ny, "data/Analysis_Data/social_captial_ny.csv")

