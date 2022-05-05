****Project: SNACK
****Author:  Lucas Hamilton
****Date:    2022/04/22
****Version: 17
****Purpose: Merge SNACK data with existing SNAD data

clear

**********************************************************************
**# 1 Add SNACK data to SNAD
**********************************************************************

use "I:\SNAD Data\Cleaned data\Focal\snad-analysis-focal-r01match-20220413.dta" //check the date for this file before executing

append using "I:\SNACK Data\SNACK-full-.dta", generate(source_study) force //check the date for this file before executing
***check for errors

label define source_study 0 "SNAD" 1 "SNACK"
label values source_study source_study


**********************************************************************
**# 2 Cleaning and adding variables
**********************************************************************

gen wave = time
recode wave (.=1)

tabulate wave time
***check for miscoded cases, should all align on diagonal

gen snack_session1_date
gen snack_session2_date
***will need to manually copy and paste dates from Experimenter sheet before proceeding

. generate statadate = exceldate + td(30dec1899)
. format statadate %td

***recoding dates to match SNAD format
gen str50 v1 = subinstr(snack_session1_date, "Friday, ","",.)
gen str50 v2 = subinstr(v1, "Thursday, ","",.)
gen str50 v3 = subinstr(v2, "Wednesday, ","",.)
gen str50 v4 = subinstr(v3, "Tuesday, ","",.)
gen str50 v5 = subinstr(v4, "Monday, ","",.)
gen str50 v6 = subinstr(v5, "Saturday, ","",.)
gen str50 v7 = subinstr(v6, "Sunday, ","",.)
gen numv7 = date(v7, "MDY")
format numv7 %td
rename numv7 snack_w1_date
drop v1-v6

order SNACK_ID source_study wave snack_*_date, before(date_red)

order agesnad age_snackw1, before(rey_sum)
destring age_snackw1, replace
egen age = rowtotal(agesnad age_snackw1)
order age, before(source_study)

gen cog_stat = diagnosis_iadc
recode cog_stat (.=0) if source_study == 1
recode cog_stat (3=2) (.=-99)
label define cog_stat 0 "SNACK" 1 "SNAD - Normal" 2 "SNAD - MCI/AD" -99 "Missing"
label values cog_stat cog_stat
order cog_stat, before(record_id)

recode GDS_1 GDS_2 GDS_3 GDS_4 GDS_7 GDS_8 GDS_9 GDS_10 GDS_12 GDS_14 GDS_15 GDS_17 GDS_21 GDS_22 GDS_23 (2=0) // these are the GDS-15 items

egen gds15_snack = rowtotal(GDS_1 GDS_2 GDS_3 GDS_4 GDS_7 GDS_8 GDS_9 GDS_10 GDS_12 GDS_14 GDS_15 GDS_17 GDS_21 GDS_22 GDS_23), miss

gen gds15_combined = .
replace gds15_combined = gds15 if source_study==0
replace gds15_combined = gds15_snack if source_study==1
egen gds15_combinedSD = std(gds15_combined) 

save "I:\SNAD Data\Cleaned\SNAD-SNACK Merged Data\Long-merged-.dta" ///add date for reference"


**********************************************************************
**# 3 Create and save "Simple" file: Remove items and reorder variables
**********************************************************************

drop GDS_1 GDS_2 GDS_3 GDS_4 GDS_5 GDS_6 GDS_7 GDS_8 GDS_9 GDS_10 GDS_11 GDS_12 GDS_13 GDS_14 GDS_15 GDS_16 GDS_17 GDS_18 GDS_19 GDS_20 GDS_21 GDS_22 GDS_23 GDS_24 GDS_25 GDS_26 GDS_27 GDS_28 GDS_29 GDS_30 GAD_1 GAD_2 GAD_3 GAD_4 GAD_5 GAD_6 GAD_7 PHQ_1 PHQ_2 PHQ_3 PHQ_4 PHQ_5 PHQ_6 PHQ_7 PHQ_8  MLQ_1 MLQ_2 MLQ_3 MLQ_4 MLQ_5 MLQ_6 MLQ_7 MLQ_8 MLQ_9 MLQ_10 PANAS_1 PANAS_2 PANAS_3 PANAS_4 PANAS_5 PANAS_6 PANAS_7 PANAS_8 PANAS_9 PANAS_10 PANAS_11 PANAS_12 PANAS_13 PANAS_14 PANAS_15 PANAS_16 PANAS_17 PANAS_18 PANAS_19 PANAS_20 SWLS_1 SWLS_2 SWLS_3 SWLS_4 SWLS_5 FName_RT_recog_correct FN_recog_miss FName_RT_recog_miss FName_NewFoil_correct FName_NewFoil_RT FName_OldFoil FName_OldFoil_RT YA_M YA_M_RT OA_M OA_M_RT YA_F YA_F_RT OA_F OA_F_RT 

label variable FAQ_TOT "functional activites questionnaire total"
label variable PSS_TOT "perceived stress scale total"
label variable GDS_TOT "geriatric dep scale (30)"
label variable GAD_TOT "anxiety total score"
label variable GAD_SUM "anxiety summary id (group)"
label variable PHQ_TOT "patient health questionnaire total"
label variable PHQ_SUM "patient health questionnaire id group"
label variable MLQ_S "search for meaning in life"
label variable MLQ_P "presence of meaning in life"
label variable NA_TOT "average level of negative emotion"
label variable PA_TOT "average level of positive emotion"
label variable SWLS_TOT "satisfaction with life scale"

drop biologicalkids stepchildren volunteer_inc1 volunteer_inc2 volunteer_dec1 volunteer_dec2 Vis_exec_total orient_total 

drop agesnad age_snackw1 date_snack_session1 date_snack_session2 redcap_event_name redcap_repeat_instrument redcap_repeat_instance rey date_avlt rey_avlt_complete date trails cube clock clock_numbers hands naming registration digits letter_a serial_7_s repetition fluency abstraction no_cue category multiple_cue date_orient month year place city2 where_administered moca_complete mailing_packet_1 trails_complete delayed_rey_avlt_complete rey_avlt_correct rey_avlt_confabs rey_avly_intrusions reycorrect reyconfabs reycorrect2 reyconfabs2 reycorrect3 reyconfabs3 reycorrect4 reyconfabs4 reycorrect5 reyconfabs5 reybcorrect reybconfabs reyintrusions reycorrecta reyconfabsa reyintrusionsa vigorhr vigormn vigortothr vigortotmn modhr modmn modtothr modtotmn walkhr walkmn walktothr walktotmin sithr sitmn sitwedhr sitwedmn physical_activity_an_v_4 Trailatime RawTrailA Trailbtime RawTrailB 

order verfl_* , before(UDSVERFC)
order VERFL_*, before(UDSVERFC)
drop day_orient digif_longest digib_longest CRAFTD_Cue UDSBENTD_recog 
rename MIN_semanticcue MINT_semanticcue
label variable MINT_semanticcue "MINT_semanticcue"
drop MINT_uncued MINT_semanticcue
generate UDSVER_TOT = UDSVERFC + UDSVERLC
order UDSVER_TOT, before(UDSVERFC)
label variable UDSVER_TOT "UDS Verbal Fluency TOTAL"
drop verfl_f_rep verfl_f_nonf verfl_l_rep verfl_l_nonf VERFL_totalsum VERFL_totalrep VERFL_totalnon 

order vigor_* , before(moderate)
order mod_*, before(walk)
order walk_*, before(sitting)
order sit_Wednesday, before(oliveoil)
order employment_other, before(workhours)

save "I:\SNAD Data\Cleaned data\SNAD-SNACK Merged Data\Simple-merged-.dta" ///add date for reference

