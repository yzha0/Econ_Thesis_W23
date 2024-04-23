# Undergraduate Economic Thesis: "Unemployment Insurance recipiency in NY: From a social network perspective"

This project explore the possible relationships between regional (County-level) social networks' effect on Unemployment Insurance (UI) take-up situations in NY. We employ time-fixed effect OLS model to study our question. Regardless data limiation and possible network endogenity problem, We found that social capitals that aggregated by online social networks can influence policy-maker's decision on distributing UI expenditure.

# Replicating results

Use files in [Build](/code/Build) subfolder in code folder to build cleaned/merged dataset from raw data source.

Use files in [Analysis](/code/Analysis) subfolder in code folder to return spatial summary, summary stats, and regression model results.

# Relevant files

[Build](/code/Build): 

* Data_Processing.R
* Data_Construction.R

[Analysis](/code/Analysis):

* Summary_Stats.R
* Spatial_Analysis.R
* Fixed_Effect.R



# Data sources

Social Captial Data:
[Social Capital Atlas Data repository](https://data.humdata.org/dataset/social-capital-atlas)


UI Data:
[LAUS](https://dol.ny.gov/local-area-unemployment-statistics)
