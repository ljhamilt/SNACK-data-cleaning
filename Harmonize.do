
****Project: SNACK
****Author:  Lucas Hamilton
****Date:    2022/04/22
****Purpose: Import psycho/social/behavioral data and harmonize with social network data

clear

**********************************************************************
**# 1  Importing data from Excel
**********************************************************************

import excel "I:\SNACK_full_data.xlsx", sheet("Sheet1") firstrow

***remove oddities in variable names (should be prechecked)
rename *_ *
rename *_w1 *

***change variable types

destring female marital living_own1-moved living_number employment buy_food-ladder mastery1-feel_isolated1 edu veteran kids kind_bus* family_finances_red education_mother1_red education_father1_red  religious_group1 what_religion1 religious_attendance1 volunteer volunteer_act* volunteer_help volunteer_often volunteer_company volunteer_change1, replace
***all should be converted to byte; check output. If not, check variables for discrepancies in format. Then, destring them.

recast float kind_bus* family_finances_red education_mother1_red education_father1_red religious_group1 what_religion1 religious_attendance1 volunteer_act* volunteer_help volunteer_often volunteer_company 

destring SWLS_1-Office_TOTAL, replace
***all should be converted to byte; check output. If not, check variables for discrepancies in format. Then, destring them.

destring sm_* social_media1___1 - social_media1___12, replace
***all should be converted to byte; check output. If not, check variables for discrepancies in format. Then, destring them.

recast float sm_* social_media*

***oddball string variable in merged data
tostring veg, replace

save "I:\SNACK Data\SNACK-no-net-vars-.dta" /// add date for reference later


**********************************************************************
**# 2  Merge with social network data
**********************************************************************

merge 1:1 SUBID using "I:\SNACK Data\NC-SHORT-clean-.dta"
***check the automatically generated variable "_merge" for discrepancies in cases that are mismatched. Correct as needed.

***generate string and byte ID
clonevar SNACK_ID = SUBID
encode SUBID, generate(SUBID_1)
drop SUBID
rename SUBID_1 SUBID

save "I:\SNACK Data\SNACK-full-.dta" /// add date for reference later
