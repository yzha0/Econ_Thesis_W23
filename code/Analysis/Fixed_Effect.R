# ---------------------------------------------------------------------------------------------
# File: Fixed_Effect.R
# By: Eric Zhao
# Date: 03/10/2024
# Description: This file perform fixed-effect regression
# ---------------------------------------------------------------------------------------------

#Load-in Data
data_month<-read_csv("data/Analysis_Data/data_month.csv")

#
lm1<-lm(numeric.mean ~ ec_county+clustering_county+volunteering_rate_county+ County-1, data = data_month)

lm2<-lm(numeric.mean ~ ec_county+clustering_county+volunteering_rate_county+Year-1, data = data_month)

lm3<-lm(numeric.mean ~ ec_county+clustering_county+volunteering_rate_county+ County+Year-1, data = data_month)

stargazer(list(lm1, lm2, lm3), title = "", style = "qje", digits = 2)

#fixest:time effect
flm01<-feols(numeric.mean ~ec_county|csw0(Year, Month), data=data_month)
flm02<-feols(numeric.mean ~ec_county+clustering_county|csw0(Year, Month), data=data_month)
flm03<-feols(numeric.mean ~ clustering_county+volunteering_rate_county|csw0(Year, Month), data=data_month)
flm1<-feols(numeric.mean ~ ec_county+clustering_county+volunteering_rate_county|csw0(Year, Month), data = data_month)

#Table construction
etable(flm1, vcov ="hetero", digits = 3, tex = TRUE, dict = c("numeric.mean"="Average takeup rate"),  title = "Time Fixed-effect")

etable(flm01, vcov ="hetero", digits = 3, tex = TRUE, dict = c("numeric.mean"="Average takeup rate"),  title = "Time Fixed-effect")

etable(flm02, vcov ="hetero", digits = 3, tex = TRUE, dict = c("numeric.mean"="Average takeup rate"),  title = "Time Fixed-effect")

etable(flm03, vcov ="hetero", digits = 3, tex = TRUE, dict = c("numeric.mean"="Average takeup rate"),  title = "Time Fixed-effect")


