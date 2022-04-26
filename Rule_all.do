****Project: SNACK
****Author:  Lucas Hamilton
****Date:    2022/04/22
****Version: 17
****Purpose: do file that runs all do files for SNACK participants

clear

**********************************************************************
**# 1 NC clean: Import and clean social network data
**********************************************************************

cd "I:\SNACK Data"
do "NC clean"

**********************************************************************
**# 2 Harmonize: Merge all psycho/social/behavioral data
**********************************************************************

do "Harmonize" //import data from excel, recode variables, merge with social network data

**********************************************************************
**# 3 Merging: Merge newly prepared data with SNAD
**********************************************************************

do "Merging" //merge and create full dataset for SNACK-SNAD


/*Summary of workflow:
1. run NC clean: Import and clean social network data
2. run Harmonize: Merge and harmonize all psycho/social/behavioral data within SNACK
3. run Merging: Merge and harmonize across study arms
