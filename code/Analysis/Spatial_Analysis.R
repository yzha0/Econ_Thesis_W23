# ---------------------------------------------------------------------------------------------
# File: Spatial_Analysis.R
# By: Eric Zhao
# Date: 03/10/2024
# Description: This file perform spatial summary and regression dataset
# ---------------------------------------------------------------------------------------------

library(tigris)
library(readr)
#load-in data
merged_unmeployed_claim_ny<-read_csv("data/Analysis_Data/merged_outcome_ny.csv")
social_capital_ny<-read_csv("data/Analysis_Data/social_captial_ny.csv")

#spatial info
nyCounty<-tigris::counties(state = "NY") %>%select(NAME, geometry)
nyCounty$NAME<-tolower(trimws(nyCounty$NAME))

#take-up rate sum
summ_rate_ny<-merged_unmeployed_claim_ny %>% select(County, Year, recip_rate) %>% group_by(Year,County) %>% skim() %>% 
  select(Year, County, numeric.mean, numeric.sd) 

summ_rate_ny_month<- merged_unmeployed_claim_ny %>% select(County, Year, Month, recip_rate) %>% 
  group_by(Year,Month,County) %>% skim() %>%select(Year, Month, County, numeric.mean)

nyCounty_join_2021<-merge(nyCounty, summ_rate_ny, by.x ='NAME', by.y='County') %>% filter(Year==2021)

nyCounty_join_2022<-merge(nyCounty, summ_rate_ny, by.x ='NAME', by.y='County') %>% filter(Year==2022)

ny_sc_join_2021<-merge(nyCounty, merged_df, by.x='NAME', by.y='County') %>% filter(Year==2021) %>% 
  select(NAME, ec_county, clustering_county, volunteering_rate_county, Time:geometry)
# spatial pattern of recipiency rate in ny 
# par(mfrow=c(1, 2))
ggplot(nyCounty_join_2021) +
  geom_sf(aes(fill = numeric.mean), alpha=0.8, col="white") +
  scale_fill_viridis_c(name = "mean recipiency rate") +
  ggtitle("mean recipiency rate in NY counties 2021")

ggplot(nyCounty_join_2022) +
  geom_sf(aes(fill = numeric.mean), alpha=0.8, col="white") +
  scale_fill_viridis_c(name = "mean recipiency rate") +
  ggtitle("mean recipiency rate in NY counties 2022")


#other sum
social_ny<-merged_unmeployed_claim_ny %>% select(County, ec_county, clustering_county, volunteering_rate_county) %>% group_by(County) %>% 
  skim() %>% select(skim_variable, County, numeric.mean)

nyCounty_join_social<-merge(nyCounty, social_ny, by.x ='NAME', by.y='County')



ggplot(nyCounty_join_social%>%filter(skim_variable=="ec_county")) +
  geom_sf(aes(fill = numeric.mean), alpha=0.8, col="white") +
  scale_fill_viridis_c(name = "economic connectedness") +
  ggtitle("economic connectedness in NY counties")

ggplot(nyCounty_join_social%>% filter(skim_variable=="clustering_county")) +
  geom_sf(aes(fill = numeric.mean), alpha=0.8, col="white") +
  scale_fill_viridis_c(name = "avearge clustering coefficient") +
  ggtitle("Average clustering in NY counties")

ggplot(nyCounty_join_social%>% filter(skim_variable=="volunteering_rate_county")) +
  geom_sf(aes(fill = numeric.mean), alpha=0.8, col="white") +
  scale_fill_viridis_c(name = "Volunteering rate") +
  ggtitle("Percentage of people in volunteering-labelled in NY counties")


data<-merge(social_capital_ny, summ_rate_ny)
data_month<-merge(social_capital_ny, summ_rate_ny_month)
#summary(lm(numeric.mean ~ ec_county+clustering_county+volunteering_rate_county+ County+Year-1, data = data))

write_csv(data_month, "data/Analysis_Data/data_month.csv")

## install.packages("plm")
# library(plm)
# data_2021<-merge(social_capital_ny, summ_rate_ny) %>% filter(Year==2021)
# data_2021_clean<-na.omit(data_2021)

# estimate the fixed effects regression with plm()
# fatal_fe_mod <- plm(numeric.mean ~ ec_county+clustering_county+volunteering_rate_county, 
#                     data = data,
#                     index = c("County","Year"), 
#                     model = "within",
#                     effect = "twoways")
# 
# coeftest(fatal_fe_mod, vcov. = vcovHC, type = "HC1")
