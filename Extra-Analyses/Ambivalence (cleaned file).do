****Project: SNACK-SNAD
****Author:  Lucas Hamilton
****Date:    2022/05/20
****Version: 17
****Purpose: Generate ambivalent tie metrics for alter-level data


**# 1 - Generate variables in alter-level dataset (i.e., long-format)

use "I:\SNAD Data\Cleaned data\Alter-level\Long-Format_merged_05-05-2022.dta"

gen Ambi_mult = altercloseego*alterhassle
gen Ambi_tie = cond(Ambi_mult > 4, 1, 0)
bysort SUBID wave: egen number_ambi=sum(Ambi_tie)
gen ambistrength if Ambi_tie == 1 = Ambi_tie*alterstrength
bysort SUBID wave: egen avgambistrength = mean(ambistrength)
bysort SUBID wave: gen p_ambi = number_ambi / netsize
gen v_hassle if alterhassle == 3 = 1
gen ambi_vhassle = v_hassle*Ambi_tie
recode ambi_vhassle (.=0)
bysort SUBID: egen Num_vhassle = sum(ambi_vhassle)
gen Have_vhassle if Num_vhassle > 0 = 1
recode Have_vhassle (.=0)
gen v_ambi = cond(Ambi_mult==9,1,0)
bysort SUBID : egen Num_vambi = sum(v_ambi)
gen Have_V_ambi if Num_vambi > 0 = 1
recode Have_V_ambi (.=0)
gen Have_ambi if number_ambi > 0 = 1
recode Have_ambi (.=0)

gen rel_type7 = 0
replace rel_type7 = 7 if relcowork == 1 | relneigh == 1 | relboss == 1 | relemploy == 1 | relschool == 1 | rellawyer == 1 | reldoctor == 1 | relothmed == 1 | relmental == 1 | relrelig == 1 | relchurch == 1 | relclub == 1 | relleisure == 1
replace rel_type7 = 6 if relparent == 1 | relgrandp == 1 | relgrandc == 1 | relauntunc == 1 |  relothrel == 1
replace rel_type7 = 5 if relfriend == 1
replace rel_type7 = 4 if relinlaw == 1
replace rel_type7 = 3 if relsibling == 1 
replace rel_type7 = 2 if relchild == 1
replace rel_type7 = 1 if relpartner == 1
label define rel_type7 0 "missing" 1 "partner" 2 "child" 3 "sibling" 4 "in-law" 5 "friend" 6 "other relatives" 7 "other non-relatives"
label values rel_type7 rel_type7

gen rel_type = 0
replace rel_type = 5 if relcowork == 1 | relneigh == 1 | relboss == 1 | relemploy == 1 | relschool == 1 | rellawyer == 1 | reldoctor == 1 | relothmed == 1 | relmental == 1 | relrelig == 1 | relchurch == 1 | relclub == 1 | relleisure == 1
replace rel_type = 4 if relparent == 1 | relsibling == 1 | relgrandp == 1 | relgrandc == 1 | relauntunc == 1 | relinlaw == 1 | relothrel == 1
replace rel_type = 3 if relfriend == 1
replace rel_type = 2 if relchild == 1
replace rel_type = 1 if relpartner == 1
label define rel_type 0 "missing" 1 "partner" 2 "child" 3 "friend" 4 "other relatives" 5 "other non-relatives"
label values rel_type rel_type
**drop alters with missing relationship information
tab rel_type
drop if rel_type == 6

gen discuss = .
gen regulators = .
gen burdens = .
replace discuss = 1 if impmat==1 | hlthcount==1
replace regulators = 1 if impforce==1 | hlthencrg==1
replace burdens = 1 if impburdn==1 | hlthburdn==1
recode discuss (.=0)
recode regulators (.=0)
recode burdens (.=0)
label define discuss 0 "Non-discussant" 1 "Discussant"
label values discuss discuss
label define regulators 0 "Non-regulator" 1 "Regulator"
label values regulators regulators
label define burdens 0 "Non-burden" 1 "Burden"
label values burdens burdens

table (discuss regulators) burdens, statistic(frequency) statistic(percent)


gen ambi_partnerraw=1 if ambi_groupedtype == 1
gen ambi_childraw=1 if ambi_groupedtype == 2
gen ambi_friendraw=1 if ambi_groupedtype == 3
gen ambi_otherrelativesraw=1 if ambi_groupedtype == 4
gen ambi_nonrelateotherraw=1 if ambi_groupedtype == 5
gen ambi_typemissing=1 if ambi_groupedtype == 6

bysort SUBID wave: egen ambi_partners = count(ambi_partnerraw)
bysort SUBID wave: egen ambi_children = count(ambi_childraw)
bysort SUBID wave: egen ambi_friends = count(ambi_friendraw)
bysort SUBID wave: egen ambi_otherrelatives = count(ambi_otherrelativesraw)
bysort SUBID wave: egen ambi_othernonrelatives = count(ambi_nonrelateotherraw)
bysort SUBID wave: egen ambi_missing = count(ambi_typemissing)

gen ambi_part_str if ambi_partnerraw == 1 = ambi_partnerraw*alterstrength
gen ambi_child_str if ambi_childraw == 1 = ambi_childraw*alterstrength
gen ambi_friend_str if ambi_friendraw == 1 = ambi_friendraw*alterstrength
gen ambi_otherrelate_str if ambi_otherrelativesraw == 1 = ambi_otherrelativesraw*alterstrength
gen ambi_nonrelateother_str if ambi_nonrelateotherraw == 1 = ambi_nonrelateotherraw*alterstrength
gen ambi_missing_str if ambi_typemissing == 1 = ambi_typemissing*alterstrength

bysort SUBID wave: egen avgstr_ambipart = mean(ambi_part_str)
bysort SUBID wave: egen avgstr_ambichildren = mean(ambi_child_str)
bysort SUBID wave: egen avgstr_ambifriends = mean(ambi_friend_str)
bysort SUBID wave: egen avgstr_ambiotherrelatives = mean(ambi_otherrelate_str)
bysort SUBID wave: egen avgstr_ambiothernonrelatives = mean(ambi_nonrelateother_str)
bysort SUBID wave: egen avgstr_ambimissing = mean(ambi_missing_str)

gen ambi_part_frq if ambi_partnerraw == 1 = ambi_partnerraw*alterfreqcon
gen ambi_child_frq if ambi_childraw == 1 = ambi_childraw*alterfreqcon
gen ambi_friend_frq if ambi_friendraw == 1 = ambi_friendraw* alterfreqcon
gen ambi_otherrelate_frq if ambi_otherrelativesraw == 1 = ambi_otherrelativesraw* alterfreqcon
gen ambi_nonrelateother_frq if ambi_nonrelateotherraw == 1 = ambi_nonrelateotherraw* alterfreqcon
gen ambi_missing_frq if ambi_typemissing == 1 = ambi_typemissing* alterfreqcon

bysort SUBID wave: egen avgfrq_ambipart = mean(ambi_part_frq)
bysort SUBID wave: egen avgfrq_ambichildren = mean(ambi_child_frq)
bysort SUBID wave: egen avgfrq_ambifriends = mean(ambi_friend_frq)
bysort SUBID wave: egen avgfrq_ambiotherrelatives = mean(ambi_otherrelate_frq)
bysort SUBID wave: egen avgfrq_ambiothernonrelatives = mean(ambi_nonrelateother_frq)
bysort SUBID wave: egen avgfrq_ambimissing = mean(ambi_missing_frq)

save "I:\ambivalent_ties.dta"

clear 

**# 2 - Compute a pseudo-centrality indicator for 10 randomly chosen alters 

////for SNAD/////
use "I:\SNAD ENSO.dta", clear
merge m:m SUBID TIEID using "I:\SNAD Data\ENSO-participant-altertie-long.dta", gen(outcome)
drop if outcome==2
gen alteralter_1 = tievalue
recode alteralter_1 (1=1) (else=.)
gen alteralter_2 = tievalue
recode alteralter_2 (2=1) (else=.)
gen alteralter_3 = tievalue
recode alteralter_3 (3=1) (else=.)
bysort SUBID TIEID: egen avgalteralterclose = mean(tievalue)
bysort SUBID TIEID: egen central_3 = count(alteralter_3)
bysort SUBID TIEID: egen central_2 = count(alteralter_2)
bysort SUBID TIEID: egen central_1 = count(alteralter_1)
gen central_degree = central_3 + central_2 + central_1
gen central_hideg = central_3
gen central_lowdeg = central_degree - central_hideg
drop if tievalue == .
keep SUBID source source_study wave TIEID alter_a_name avgalteralterclose central_3 central_2 central_1 central_degree central_hideg central_lowdeg


**step 1 - reload original alter-level data to preserve merged dataset

multimport delimited, dir("I:\SNACK Interviews\Netcanvas\alter") clear force import(stringcols(_all))
destring altercloseego alterhassle random nodeid, replace
gen Ambi_mult = altercloseego*alterhassle
gen Ambi_tie = cond(Ambi_mult > 4, 1, 0)
gen randomambi = Ambi_tie*random
bysort SUBID: egen num_randamb=sum(randomambi)
gen Have_ambi if number_ambi > 0 = 1
recode Have_ambi (.=0)
rename nodeid from
drop if random==0 | .
save "I:\random-only.dta", replace

**step 2 - reload alter-alter tie data
multimport delimited, dir("I:\SNACK Interviews\All\alter_tie") clear force import(stringcols(_all))
destring from alteralterclose, replace
recode alteralterclose (1=3) (2=2) (3=1) 
save "I:\alter-alter.dta"

**step 3 - merge alter-alter tie into alter-level data for randomized only
use "I:\random-only.dta"
merge m:m networkcanvasegouuid from using "I:\alter-alter.dta"

gen alteralterknow = alteralterclose //// change all alteralterclose to tievalue for SNAD-ENSO
recode alteralterknow (1/3=1) (.=0) 
gen alteralter_1 = alteralterclose
recode alteralter_1 (1=1) (else=.)
gen alteralter_2 = alteralterclose
recode alteralter_2 (2=1) (else=.)
gen alteralter_3 = alteralterclose
recode alteralter_3 (3=1) (else=.)
tab alteralterknow Ambi_tie
bysort SUBID from: egen avgalteralterclose = mean(alteralterclose) ///// change SUBID from = networkcanvassourceuuid for SNAD-NC / alter_a_id for SNAD-ENSO
bysort SUBID from: egen central_3 = count(alteralter_3)
bysort SUBID from: egen central_2 = count(alteralter_2)
bysort SUBID from: egen central_1 = count(alteralter_1)
gen central_degree = central_3 + central_2 + central_1
gen central_hideg = central_3
gen central_lowdeg = central_degree - central_hideg

clonevar SNACK_ID = SUBID
encode SUBID, generate(SUBID_1)
drop SUBID
rename SUBID_1 SUBID
rename from nodeid

duplicates drop SUBID from, force

drop alterplacement_x alterplacement_y networkcanvascaseid networkcanvassessionid networkcanvasprotocolname sessionstart sessionfinish sessionexported subname interviewername 
drop alterim1 alterim2 alterim3 alterhm1 alterhm3 alterhm2 alteret3 alteret4 alteret5 alteret6 alteret7 relpartner relparent relsibling relchild relgrandp relgrandc relauntunc relinlaw relothrel relcowork relneigh relfriend relboss relemploy relschool rellawyer reldoctor relothmed relmental relrelig relchurch relclub relleisure altersex alterrace altercollege alterage altercloseego alterfreqcon alterprox alterhknow alterdtr alterquestion altersupfunc_1 altersupfunc_2 altersupfunc_3 altersupfunc_4 altersupfunc_5 alterhassle altercls110 alter_name prevalter broughtforward altermissing stilldiscuss prevalterimcat_ima prevalterimcat_imb prevalterimcat_imc prevalterimcat_ihma prevalterimcat_ihmb prevalterimcat_ihmc prevalterimcat_etc prevalterimcat_etd prevalterimcat_ete prevalterimcat_etf previnterpreter altermissingother random _filename Ambi_mult Ambi_tie randomambi num_randamb number_ambi Have_ambi edgeid to
save "I:\mergeback.dta"

**step 4 - add new indicators back to merged alter-level data
use "I:\ambivalent_ties.dta"
destring nodeid, replace
merge m:m SNACK_ID networkcanvasegouuid nodeid using "I:\mergeback.dta", gen(outcome)

****ENSO ONLY 
duplicates drop SUBID alter_a_id, force
drop tievalue tievalue_min tievalue_max issue survey_id survey_version interview_id respondent_id respondent_name 
drop alter_b_id alter_b_name created_on modified_on _filename dup pickone 
rename alter_a_name alter_name
rename alter_a_id TIEID
merge m:m SUBID TIEID using "I:\ENSO-mergeback1.dta", gen(outcome2)

*****NC SNAD ONLY
duplicates drop networkcanvasegouuid from, force
rename from nodeid
/////\\\\\//\\\///\\/\/\/ must use Excel to create SUBID from filename via copy/paste
merge m:m SUBID alterid using "I:\NC-mergeback2.dta", gen(outcome3)


***check for mismatched cases
list SNACK_ID nodeid if outcome==2
sort SNACK_ID nodeid outcome

bysort SUBID: egen avg_alteralterdeg = mean(central_degree)
gen hi_centrality = .
replace hi_centrality = 0 if random==1 & avg_alteralterdeg != .
replace hi_centrality = 1 if random==1 & central_degree > avg_alteralterdeg
gen central_ambi = Ambi_tie*hi_centrality
bysort SUBID: egen Num_cambi = sum(central_ambi)
gen have_cambi = Num_cambi
recode have_cambi (1/max=1)

**quick recode to make sure it is consistent between SNACK and SNAD
drop tkin
gen tkin=relpartner+relparent+relsibling+relchild+relgrandp+relgrandc+relauntunc+relinlaw+relothrel

**# 3 - Descriptive and frequency statistics
foreach x in alterfem rel_type7 altercollege alterprox alterfreqcon generator sup_loan sup_chores sup_advice sup_care sup_listen {
tab Ambi_tie `x', chi2 expected
}

foreach x in alterage alterstrength avgalteralterclose central_degree central_hideg {
ttest `x', by(Ambi_tie)
esize twosample `x', by(Ambi_tie)
}

**# 4 - Predicting ambivalence

melogit Ambi_tie i.discuss i.regulators i.burdens i.discuss#i.regulators#i.burdens i.rel_type7 alterage alterfreqcon alterstrength alterprox sup_loan sup_chores sup_advice sup_listen sup_care alterrace alterfem netsize mage pwhite mprox mfreq msupport mstrength weakest pfem diverse pkin density bridging || cog_stat:  || SUBID:, covariance(unstructured) or
estat icc
estat ic
testparm i.discuss#i.regulators#i.burdens, equal
pwcompare i.discuss#i.regulators#i.burdens, effect mcompare(bonferroni)
testparm i.rel_type7, equal
pwcompare rel_type7, effects mcompare(bonferroni)


marginsplot, recast(bar) ti("Predicted Probabilities by Relationship Type") ytitle("Marginal predictions") ylabel() xtitle("") xlabel(,angle(45)) plotop(barw(.8) fintensity(inten30)) ciop(msize(vlarge) lw(medthick)) name(fig1d, replace)
margins discuss#regulator#burdens
marginsplot, xdim(discuss regulators) by(burdens) recast(bar) ti("") ytitle("Marginal predictions") ylabel() xtitle("") xlabel(none) plotop(barw(.8) fintensity(inten30)) ciop(msize(vlarge) lw(medthick)) name(fig1g, replace)

****overly-simplified model by removing n.s. predictors in previous estimation
melogit Ambi_tie i.discuss i.regulators i.burdens i.discuss#i.regulators#i.burdens i.rel_type7 alterfreqcon mage mfreq pfem || cog_stat: || SUBID:, covariance(unstructured) or
estat icc
estat ic
***shows worse ICC and IC estimates


****modelling ambivalence as the interaction between closeness and hassling
mixed Ambi_mult i.discuss i.regulators i.burdens i.discuss#i.regulators#i.burdens i.rel_type7 alterage alterfreqcon alterstrength alterprox sup_loan sup_chores sup_advice sup_listen sup_care alterrace alterfem netsize mage pwhite mprox mfreq msupport mstrength weakest pfem diverse pkin density bridging || cog_stat:  || SUBID:, covariance(unstructured)

****including the pseudo-centrality metric about have a hi-degree ambivalent tie
bysort source_study: melogit Ambi_tie i.discuss i.regulators i.burdens i.discuss#i.regulators#i.burdens i.rel_type7 alterage alterfreqcon alterstrength alterprox sup_loan sup_chores sup_advice sup_listen sup_care alterrace alterfem netsize mage pwhite mprox mfreq msupport mstrength weakest pfem diverse pkin density bridging have_cambi || SUBID:, covariance(unstructured) or


regress std_avgdegree have_cambi density netsize weakest diverse pkin bridging source_study
regress  have_cambi std_avgdegree density netsize weakest diverse pkin bridging source_study
logit have_cambi std_avgdegree density netsize weakest diverse pkin bridging source_study

regress number_ambi avg_alteralterdeg have_cambi##Have_V_ambi density netsize weakest diverse pkin source_study
vif
margins have_cambi#Have_V_ambi

**# 5 - Transition to SUBID-level for additional analyses
duplicates drop SUBID wave, force

save "I:\SNAD Data\Cleaned data\SNAD-SNACK Merged Data\Ambivalent-shortformerge.dta"

recode ambi_partners ambi_children ambi_friends ambi_otherrelatives ambi_othernonrelatives (1/max=1)
foreach x in ambi_partners ambi_children ambi_friends ambi_otherrelatives ambi_othernonrelatives {
tab `x' source_study, chi2
}

foreach x in netsize msupport mstrength diverse density bridging {
reg `x' age female edu source_study Have_ambi ambi_partners ambi_children ambi_friends ambi_otherrelatives ambi_othernonrelatives p_ambi
}

foreach x in Have_ambi ambi_partners ambi_children ambi_friends ambi_otherrelatives ambi_othernonrelatives have_cambi p_ambi {
mixed `x' age female edu netsize mage pwhite mprox mfreq msupport mstrength weakest pfem diverse pkin density bridging|| source_study: 
}

foreach x in Have_ambi ambi_partners ambi_children ambi_friends ambi_otherrelatives ambi_othernonrelatives have_cambi p_ambi {
melogit `x' age female edu netsize mage pwhite mprox  pclose mclose pfreq mfreq sdfreq msupport msupport3 pcare ploan pchores plisten padvice mhassles phassles mstrength weakest iqrstrength sdstrength pfem diverse density avg_alteralterdeg bridging|| source_study:, or
}
melogit have_cambi age female edu netsize mage pwhite mprox  pclose mclose pfreq mfreq sdfreq msupport msupport3 pcare ploan pchores plisten padvice mhassles phassles mstrength weakest iqrstrength sdstrength pfem diverse density avg_alteralterdeg bridging|| source_study:, or

bysort source_study: tab rel_type7 central_ambi, chi2  expected


recode lack_companionship1 (1=5)(2=4)(3=3)(4=2)(5=1)
recode left_out1 (1=5)(2=4)(3=3)(4=2)(5=1)
recode feel_isolated1 (1=5)(2=4)(3=3)(4=2)(5=1)
egen perc_soc_sup = rowtotal (family_help1 help_support1 friends_help1 go_wrong1 problems_family1 joys_sorrows1 make_decisions1 problems_friends1 lack_companionship1 left_out1 feel_isolated1)
egen frndsup=rowmean(friends_help1 go_wrong1 joys_sorrows1)
egen famsup=rowmean(family_help1 help_support1 problems_family1 make_decisions1)
