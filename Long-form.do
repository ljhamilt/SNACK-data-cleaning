****Project: SNACK-SNAD
****Author:  Lucas Hamilton
****Date:    2022/05/04
****Version: 17
****Purpose: Merge long-form social network data between SNACK-SNAD

clear

**# 1 Prepare SNACK Long-Format Network Data

use "I:\SNACK Data\SNACK-longformat-05-04.dta"

drop alter_name
gen alter_name = alter_name_nc
drop alter_name_nc
rename alterim1 impmat 
rename alterim2 impforce
rename alterim3 impburdn
rename alterhm1 hlthcount
rename alterhm2 hlthencrg
rename alterhm3 hlthburdn
rename alteret3 et_family
rename alteret4 et_cowrkrs
rename alteret5 et_neighbrs
rename alteret6 et_anyelse
drop alteret7
rename altercls110 alterstrength
rename alterdtr altertrust
foreach x in listen care advice chores loan {
	rename `x' sup_`x'
}

drop altersex prevalter* date_snack_w1 date_snack

save "I:\SNACK Data\SNACK-longformat-.dta" //// insert data for reference

**# 2 Merge with Long-Format SNAD

clear 

use "I:\SNAD Data\Cleaned data\Alter-level\SNAD-Analysis-focal-LONG-R01match-20220404.dta"

append using "I:\SNACK Data\SNACK-longformat-.dta", generate(source_study) force /// insert appropriate date

label define source_study 0 "SNAD" 1 "SNACK"
label values source_study source_study

gen wave = time
recode wave (.=1)

**# 3 Add behavioral/questionnaire data from Simple-Merged file

merge m:1 SNACK_ID SUBID wave using "I:\SNACK Data\Simple_merged_04-15.dta" //// replace date as needed

save "I:\SNAD Data\Cleaned data\Alter-level\Merged-longformat-.dta" //// add date for reference
