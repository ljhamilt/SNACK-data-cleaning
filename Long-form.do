****Project: SNACK-SNAD
****Author:  Lucas Hamilton
****Date:    2022/05/04
****Version: 17
****Purpose: Merge long-form social network data between SNACK-SNAD


use "I:\SNAD Data\Cleaned data\Alter-level\SNAD-Analysis-focal-LONG-R01match-20220404.dta"

rename sup_* *

rename alterstrength altercls110


append using "I:\SNACK Data\SNACK-LONG-all.dta", generate(source_study) force

label define source_study 0 "SNAD" 1 "SNACK"
label values source_study source_study

