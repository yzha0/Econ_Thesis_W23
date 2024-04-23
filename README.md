# Undergraduate Economic Thesis: "Unemployment Insurance recipiency in NY: From a social network perspective"

_KGC: @yzha0, overall this is a well-done approach to a question that is very challenging to answer with the social network data can access at this point. That said, I think you could have taken things a step further to look beyond NY. Other states also have UI data that could be used to review take-up and would have allowed you to consider whether different admin structures relate differently with social networks. You do a good job addressing how you cleaned and worked with the data to get to the point where you can run regressions and interpret your regression coefficients in a fairly straight-forward way. I also think you did a good job addressing that networks are complex beasts with a lot of endogeneity and underlying factors that could cause both social capital measures to change as well as take-up of UI. There is no clear sign to the bias either, which makes this even trickier._

_KGC: I think the biggest shortcoming is that there are many pretty complex variables in this analysis pulled fro mthe social capital dataset. You spend a little time defining these variables, but I think more would be necessary. What does a one-unit increase mean in terms of actual real life experiences? How do I interpret the coefficient on this? For example, what does it mean if clustering county increases by one? What about economic connectedness? Is there a way to re-standardize the variables to make them more meaningful? For example, would Z-scoring have value here? I don't know, I'm just curious._

_KGC: One thing you were missing was a final compiled version of your thesis into a .pdf in this repository. That is an odd choice to leave out (and makes grading a bit trickier). If you can, please upload it._

_KGC: Small notes are that you used royal "we" at several points and had some sentences that needed some grammatical errors and some mixed interpretations that you could clean up with more time/work with a writing studio. Writing is hard, but important._ 

_KGC: In general, you're very talented in this work, but your work feels a tad rushed in places. That is not to say that you are not highly capable, but delivering high-quality research takes time to iterate through multiple drafts. I encourage you to learn from what the thesis process (here and in math) and what you would have done differently as you pursue graduate school in the future._

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
