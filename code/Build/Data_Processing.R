# ---------------------------------------------------------------------------------------------
# File: Data_Processing.R
# By: Eric Zhao
# Date: 
# Description: This file build the base data file from raw datasets imported
# ---------------------------------------------------------------------------------------------


#library preparation
# Store string containing all required packages
my_packages <- c("readxl","readr", "tidyverse")

# Store all installed packages
ya_loaded <- (.packages())

# Check whether required packages are already installed and grab only those that still need installation
need_load<-my_packages[!(my_packages %in% ya_loaded)]

# Load required packages
lapply(need_load, require, character.only = TRUE)

#Raw Data
#social capital data
social_capital_county <- read_csv("data/social_capital_county.csv")
View(social_capital_county)

#Unemployment data
Unemployment_ma_2021<-read_csv("data/MA_2021_Unemployed.csv", 
                               skip = 6)
Unemployment_ma_2022<-read_csv("data/MA_2022_Unemployed.csv", skip = 6)
Unemployment_ny<-read_csv("data/NY_21_22_Unemployed.csv")
  
#UI Claim data
claim_data_ny <- read_excel("data/claim_data_ny.xlsx", 
                              sheet = "Monthly Bens & Amts by County")
claim_data_ma <-read_excel("data/ClaimsDataCounty_MA.xlsx", 
                                                   sheet = "ContinuedClaims")
View(claim_data_ma)
View(claim_data_ny)


#Data Merging, Reshaping, Recoding
#Unemployment in MA
Unemployment_ma<-rbind(Unemployment_ma_2022, Unemployment_ma_2021)


#matching structures for MA and NY data
Unemployment_ny_reshaped<-Unemployment_ny %>% select(Year, Month, `Area Name`, Employed, Unemployed, `Labor Force`)%>% rename(`NY Area`=`Area Name`) 
Unemployment_ma_reshaped<- Unemployment_ma %>% select(Year, Month, Area, Employed, Unemployed, `Labor Force`) %>% rename(`MA Area`=`Area`)  


# Create a unique key for merging by combining Year and Month
Unemployment_ny_reshaped <- Unemployment_ny_reshaped %>%
  mutate(YearMonth = paste(Year, Month, sep = "-")) %>%
  mutate(`YearMonth` = as.Date(paste0(`YearMonth`, "-01"), format="%Y-%b-%d")) %>% arrange(YearMonth, `NY Area`)


Unemployment_ma_reshaped <- Unemployment_ma_reshaped %>%
  mutate(YearMonth = paste(Year, Month, sep = "-")) %>% filter(Month != "Annual") %>%
  mutate(`YearMonth` = as.Date(paste0(`YearMonth`, "-01"), format="%Y-%b-%d"))%>% arrange(YearMonth, `MA Area`)

# Unemployment_cleaned<-merge(Unemployment_ma_reshaped, Unemployment_ny_reshaped, by='YearMonth')


#Sc Data Subsetting
#filtering social captial measures in MA and NY
social_capital_county_MA_NY <- social_capital_county %>%
  filter(grepl("Massachusetts", county_name) | grepl("New York", county_name))



#UI Claim Data Cleaning

# Remove the first row from the data frame
colnames(claim_data_ma) <- unlist(claim_data_ma[1, ])
claim_data_ma <- claim_data_ma[-1, ]

claim_data_ma<-claim_data_ma[729:2198,1:3]
claim_data_ny<-claim_data_ny[,c(2, seq(51, 97, 2))]

#UI Claim Data Reorganization
Months<-colnames(claim_data_ny)
colnames(claim_data_ny) <- unlist(claim_data_ny[1, ])
claim_data_ny <- claim_data_ny[-1, ]
colnames(claim_data_ny)[-1]<-Months[-1]
#long_claim_data_ny <- melt(claim_data_ny, id.vars = "Month", variable.name = "County Name", value.name = "Beneficiaries")

claim_data_ny_cleaned<-claim_data_ny[,-1] %>% pivot_longer(cols = everything(), names_to = "Time", values_to = "Claims") %>% mutate(County=rep(ny_county, each=24))%>% relocate(Time, County)

#Convert weekly data to monthly data
claim_data_ma$Date <- as.Date(as.numeric(claim_data_ma$`Week-Ending Date`), origin = "1899-12-30")

claim_data_ma_cleaned<- claim_data_ma %>%
  mutate(year_month = floor_date(`Date`, "month")) %>%  # Create a year-month column
  group_by(County_Name, year_month) %>%  # Group by this new column
  summarise(Claims = sum(as.numeric(Claims)))%>% # Summarize values by county for each month 
  rename(Time=year_month, County=County_Name) %>% select(Time, County, Claims) 

claim_data_ny_cleaned<- claim_data_ny_cleaned %>%
  mutate(Time =  as.Date(paste0(Time, " 1"), format="%b %Y %d"))  # recreate Time column
  


#Save cleaned base data files
write.csv(Unemployment_ma_reshaped, "data/Base_Data/Unemployment_ma_2122_cleaned.csv")
write.csv(Unemployment_ny_reshaped, "data/Base_Data/Unemployment_ny_2122_cleaned.csv")
write.csv(social_capital_county_MA_NY, "data/Base_Data/Social_Capital_ma_ny.csv")

write.csv(claim_data_ny_cleaned, "data/Base_Data/UI_CClaim_ny_2122_cleaned.csv")
write.csv(claim_data_ma_cleaned, "data/Base_Data/UI_CClaim_ma_2122_cleaned.csv")

