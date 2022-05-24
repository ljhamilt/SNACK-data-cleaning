****Project: SNACK
****Author:  Lucas Hamilton
****Date:    2022/05/23
****Purpose: Predicting Face-Name for YA and OA in SNACK Wave 1


clonevar SNACK_ID = SUBID
encode SUBID, generate(SUBID_1)
drop SUBID
rename SUBID_1 SUBID

tabulate age_group FN_vers, chi2

anova FName_recall age_group##FN_vers
anova FName_recog age_group##FN_vers
margins age_group#FN_vers

egen std_recall = std(FName_recall)
egen std_recog = std(FName_recog_correct)

stripplot std_recog, cumul cumprob box centre over(age_group) refline vertical xsize(3) name(strip1, replace)

drop if std_recog < -2

anova FName_recog age_group##FN_vers
anova std_recog age_group##FN_vers


**# 1 ANALYSES FOR PAPER

anova FName_recall age_group##FN_vers
estat esize

regress std_recall gender school SES i.age_group delayed_rey_sum RTME Office_emotion i.age_group#c.delayed_rey_sum i.age_group#c.RTME Office_Control Office_deceit i.age_group#c.Office_emotion Office_faux Office_infer Office_motiv Office_seen

regress std_recall gender school SES i.age_group#c.delayed_rey_sum i.age_group#c.RTME Office_Control Office_deceit i.age_group#c.Office_emotion Office_faux Office_infer Office_motiv Office_seen

margins age_group, at(RTME=(0(.2)1))
marginsplot, recast(line)
margins age_group, at(Office_emotion=(0(.2)1))
marginsplot, recast(line)
margins age_group, at(delayed_rey_sum=(0(2.5)15))
marginsplot, recast(line)

margins, dydx(age_group) at(Office_emotion=(0(.2)1))
marginsplot, yline(0)

regress std_recall gender school SES age delayed_rey_sum RTME Office_emotion Office_Control Office_deceit Office_faux Office_infer Office_motiv Office_seen CRAFTDRE digib VERFL_totalsum MINTTOTS if age_group==1
vif

rego std_recall gender school SES age \ RTME Office_emotion Office_Control Office_deceit Office_faux Office_infer Office_motiv Office_seen \ delayed_rey_sum CRAFTDRE digib VERFL_totalsum MINTTOTS, detail



foreach x in netsize mstrength weakest diverse density bridging {
regress `x' gender school SES RTME Office_Control Office_deceit Office_emotion Office_faux Office_infer Office_motiv Office_seen FN_recall FN_recog_correct theoryofmind facemem_cr
vif
}
