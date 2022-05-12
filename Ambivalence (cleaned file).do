****Project: SNACK-SNAD
****Author:  Lucas Hamilton
****Date:    2022/04/26
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
bysort SUBID : egen Num_vhassle = sum(ambi_vhassle)
gen Have_vhassle if Num_vhassle > 0 = 1
recode Have_vhassle (.=0)
gen v_ambi = cond(Ambi_mult==9,1,0)
bysort SUBID : egen Num_vambi = sum(v_ambi)
gen Have_V_ambi if Num_vambi > 0 = 1
recode Have_V_ambi (.=0)
gen Have_ambi if number_ambi > 0 = 1
recode Have_ambi (.=0)


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

gen alteralterknow = alteralterclose
recode alteralterknow (1/3=1) (.=0)
gen alteralter_1 = alteralterclose
recode alteralter_1 (1=1) (else=.)
gen alteralter_2 = alteralterclose
recode alteralter_2 (2=1) (else=.)
gen alteralter_3 = alteralterclose
recode alteralter_3 (3=1) (else=.)
tab alteralterknow Ambi_tie
bysort SUBID from: egen avgalteralterclose = mean(alteralterclose)
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

***check for mismatched cases
list SNACK_ID nodeid if outcome==2
sort SNACK_ID nodeid outcome

**recode to make sure it is consistent between SNACK and SNAD
drop tkin
gen tkin=relpartner+relparent+relsibling+relchild+relgrandp+relgrandc+relauntunc+relinlaw+relothrel

**# 3 - Analysis


bysort Ambi_tie: tabulate rel_type cog_stat, chi2
tabulate Ambi_tie cog_stat


melogit Ambi_tie i.discuss#i.regulators#i.burdens ib3.rel_groupedtype alterage alterfreqcon alterstrength alterprox sup_loan sup_chores sup_advice sup_listen sup_care alterrace alterfem netsize mage pwhite mprox mfreq msupport mstrength weakest pfem diverse pkin density bridging || cog_stat:  || SUBID:, covariance(unstructured) or
melogit Ambi_tie i.discuss##i.regulators##i.burdens ib3.rel_groupedtype alterage alterfreqcon alterstrength alterprox sup_loan sup_chores sup_advice sup_listen sup_care alterrace alterfem netsize mage pwhite mprox mfreq msupport mstrength weakest pfem diverse pkin density bridging || cog_stat:  || SUBID:, covariance(unstructured) or
melogit Ambi_tie i.discuss i.regulators i.burdens i.discuss#i.regulators#i.burdens ib3.rel_groupedtype alterage alterfreqcon alterstrength alterprox sup_loan sup_chores sup_advice sup_listen sup_care alterrace alterfem netsize mage pwhite mprox mfreq msupport mstrength weakest pfem diverse pkin density bridging || cog_stat:  || SUBID:, covariance(unstructured) or

mixed Ambi_mult i.discuss i.regulators i.burdens i.discuss#i.regulators#i.burdens ib3.rel_groupedtype alterage alterfreqcon alterstrength alterprox sup_loan sup_chores sup_advice sup_listen sup_care alterrace alterfem netsize mage pwhite mprox mfreq msupport mstrength weakest pfem diverse pkin density bridging || cog_stat:  || SUBID:, covariance(unstructured)

foreach x in loan chores advice care listen alterfreqcon alterfem {
tabulate Ambi_tie `x',chi2
}
bysort Ambi_tie: summarize altercls110 alterage
anova altercls110 Ambi_tie##source_study
margins Ambi_tie#source_study
estat esize
anova alterage Ambi_tie##source_study
margins Ambi_tie#source_study

melogit Ambi_tie i.generator alterage alterfreqcon alterstrength alterprox sup_loan sup_chores sup_advice sup_listen sup_care alterrace alterfem relpartner relchild relfriend netsize mage pwhite mprox mfreq msupport mstrength weakest pfem diverse pkin density bridging || source_study:  || SUBID:, covariance(unstructured) or

melogit Ambi_tie alterage alterfreqcon alterstrength alterprox sup_loan sup_chores sup_advice sup_listen sup_care alterrace alterfem relpartner relchild relfriend netsize mage pwhite mprox mfreq msupport mstrength weakest pfem diverse pkin density bridging || source_study:  || SUBID:, covariance(unstructured) or

melogit Ambi_tie alterage alterfreqcon alterprox sup_listen alterfem relpartner relchild mage mfreq pfem || source_study:  || SUBID:, covariance(unstructured) or



melogit Ambi_tie alterage alterfreqcon alterprox sup_listen relpartner relchild mfreq pfem || SUBID:  || source_study: , covariance(unstructured) or


melogit Ambi_tie alterage alterfreqcon alterstrength ib2.alterprox sup_loan sup_chores sup_advice sup_listen sup_care alterrace alterfem relpartner relchild relfriend netsize mage pwhite mprox mfreq msupport mstrength weakest pfem diverse pkin density bridging || SUBID:  || source_study: , covariance(unstructured) or

melogit Ambi_tie alterage alterfreqcon alterprox sup_listen alterfem relpartner relchild mfreq pfem diverse || SUBID:  || source_study: , covariance(unstructured) or





melogit v_ambi  alterage alterfreqcon altercls110 alterprox alterrace alterfem relpartner relchild relfriend || SUBID: || source_study: , covariance(unstructured)

melogit Ambi_tie alterage alterfreqcon altercls110 alterprox sup_loan sup_chores sup_advice sup_listen sup_care alterrace alterfem relpartner relchild relfriend || SUBID: || source_study: , covariance(unstructured) or

melogit Ambi_tie alterage alterfreqcon altercls110 alterprox loan chores advice listen care alterrace alterfem relpartner relchild relfriend || SUBID: , covariance(unstructured) vce(cluster source_study) or

melogit Ambi_tie alterage alterfreqcon alterstrength alterprox#alterprox sup_loan sup_chores sup_advice sup_listen sup_care alterrace alterfem relpartner relchild relfriend || SUBID: netsize mage pwhite mprox mfreq msupport mstrength weakest pfem diverse pkin density bridging || cog_stat: , covariance(unstructured) or


logistic v_ambi source_study alterage alterfreqcon altercls110 alterprox alterrace alterfem relpartner relchild relfriend, vce(cluster SUBID)
estat gof

logistic Ambi_tie source_study alterage alterfreqcon altercls110 alterprox alterrace alterfem relpartner relchild relfriend, vce(cluster SUBID)
estat gof

|||||||||||\\\\\\\\\\\|||||||||||

duplicates drop SUBID wave, force

save "I:\SNAD Data\Cleaned data\SNAD-SNACK Merged Data\Ambivalent-shortformerge.dta"


\\\\\\\\\\\\\

merge 1:1 SUBID wave using "I:\SNAD Data\Cleaned data\SNAD-SNACK Merged Data\Ambivalent-shortformerge.dta"
list SUBID if _merge==1
save "I:\SNAD Data\Cleaned data\SNAD-SNACK Merged Data\Simple_ambi_04-26.dta"

bysort wave: tabulate Have_ambi source_study, chi2
ttest avgambistrength, by(source_study)
tabulate Have_ambi source_study, chi2
bysort wave: tabulate Have_ambi source_study, chi2
anova netsize source_study##Have_ambi
margins source_study#Have_ambi
marginsplot
anova netsize source_study##Have_V_ambi
margins source_study#Have_ambi
margins source_study#Have_V_ambi
bysort wave: tabulate Have_V_ambi source_study, chi2
ttest number_ambi, by(source_study)
ttest number_ambi, by(source_study) if wave ==1
ttest number_ambi if wave ==1, by(source_study)
ttest p_ambi if wave ==1, by(source_study)
ttest avgambistrength if wave ==1, by(source_study)
esize twosample avgambicls, by(source_study)stripplot avgambicls, cumul cumprob box centre over(source_study) refline vertical xsize(3)
esize twosample avgambicls, by(source_study)stripplot avgambicls, cumul cumprob box centre over(source_study) refline vertical xsize(3)
esize twosample avgambicls, by(source_study)
esize twosample avgambistrength, by(source_study)
stripplot avgambicls, cumul cumprob box centre over(source_study) refline vertical xsize(3)
stripplot avgambistrength, cumul cumprob box centre over(source_study) refline vertical xsize(3)
