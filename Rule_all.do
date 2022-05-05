****Project: SNACK
****Author:  Lucas Hamilton
****Date:    2022/05/05
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


**********************************************************************
**# 4 Long-Form: Create long-formatted merged dataset
**********************************************************************

do "Long-form" //merge alter-level data for SNACK-SNAD and add behavioral data

/*Summary of workflow:
1. run NC clean: Import and clean social network data
2. run Harmonize: Merge and harmonize all psycho/social/behavioral data within SNACK
3. run Merging: Merge and harmonize across study arms
4. run Long-form: Merge alter-level SNAD data with alter-level SNACK data and add beahvioral data from short-form merge
