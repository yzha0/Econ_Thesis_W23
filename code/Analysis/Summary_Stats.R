# ---------------------------------------------------------------------------------------------
# File: Summary_Stats.R
# By: Eric Zhao
# Date: 03/10/2024
# Description: This file construct summary tables
# ---------------------------------------------------------------------------------------------
#Load-in Data
merged_unmeployed_claim_ny<-read_csv("data/Analysis_Data/merged_outcome_ny.csv")

#selected variables
dep_ind_data<-merged_unmeployed_claim_ny %>% select(County, Year, Month, recip_rate, ec_county, clustering_county, volunteering_rate_county)%>% group_by(Year,Month,County)

#summary stats table in latex format
knitr::kable(describe(dep_ind_data)[, c(2:10)],  caption = "Summary Statistics of Dependent and Independent Variables", digits = 3, format = "latex")

#summary of variables by county
#> merged_unmeployed_claim_ny %>% select(County, ec_county) %>% group_by(County) %>% skim() %>% select(County, numeric.mean, numeric.sd, numeric.p0, numeric.p25, numeric.p50, numeric.p75, numeric.p100)

