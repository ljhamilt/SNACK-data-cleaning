DATASET ACTIVATE DataSet1.

RELIABILITY
  /VARIABLES=Office_deceit Office_infer Office_motiv
  /SCALE('CogTOM') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR.

RELIABILITY
  /VARIABLES=Office_faux Office_emotion RTME
  /SCALE('AffTOM') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR.

RELIABILITY
  /VARIABLES=Office_deceit Office_infer Office_motiv Office_emotion Office_faux
  /SCALE('CogTOM') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR.


T-TEST GROUPS=age_group(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=RTME Office_Control Office_deceit Office_emotion Office_faux Office_infer Office_motiv 
    delayed_rey_sum ZRE_2
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).

CROSSTABS
  /TABLES=Office_Seen BY age_group
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT
  /COUNT ROUND CELL.

  IF  (age_group = 1) OwnAgeBias_OA=NEW_YA - OLD_YA.
EXECUTE.

IF  (age_group = 0) OwnAgeBias_YA=NEW_OA - OLD_OA.
EXECUTE.


COMPUTE recog_perc=FN_recog_correct / 16.
EXECUTE.
  
UNIANOVA FN_recall BY age_group FaceName_version
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /CRITERIA=ALPHA(0.05)
  /DESIGN=age_group FaceName_version age_group*FaceName_version.

UNIANOVA FN_recog_correct BY age_group FaceName_version
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /CRITERIA=ALPHA(0.05)
  /DESIGN=age_group FaceName_version age_group*FaceName_version.

GLM YA_freerec OA_freerec BY age_group
  /WSFACTOR=TargetAge 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(age_group) 
  /EMMEANS=TABLES(TargetAge) 
  /EMMEANS=TABLES(age_group*TargetAge) COMPARE(age_group) ADJ(LSD)
  /EMMEANS=TABLES(age_group*TargetAge) COMPARE(TargetAge) ADJ(LSD)
  /PRINT=ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=TargetAge 
  /DESIGN=age_group.
  
EXAMINE VARIABLES=FN_recall
  /PLOT BOXPLOT STEMLEAF
  /COMPARE GROUPS
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

GLM OLD_OA NEW_OA OLD_YA NEW_YA BY age_group
  /WSFACTOR=TargAge 2 Polynomial Foil 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(age_group) 
  /EMMEANS=TABLES(TargAge) 
  /EMMEANS=TABLES(Foil) 
  /EMMEANS=TABLES(age_group*TargAge) COMPARE(age_group) ADJ(LSD)
  /EMMEANS=TABLES(age_group*TargAge) COMPARE(TargAge) ADJ(LSD)
  /EMMEANS=TABLES(age_group*Foil) COMPARE(age_group) ADJ(LSD)
  /EMMEANS=TABLES(age_group*Foil) COMPARE(Foil) ADJ(LSD)
  /EMMEANS=TABLES(TargAge*Foil) COMPARE(TargAge) ADJ(LSD)
  /EMMEANS=TABLES(TargAge*Foil) COMPARE(Foil) ADJ(LSD)
  /EMMEANS=TABLES(age_group*TargAge*Foil) COMPARE(age_group) ADJ(LSD)
  /EMMEANS=TABLES(age_group*TargAge*Foil) COMPARE(TargAge) ADJ(LSD)
  /EMMEANS=TABLES(age_group*TargAge*Foil) COMPARE(Foil) ADJ(LSD)
  /PRINT=ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=TargAge Foil TargAge*Foil
  /DESIGN=age_group.

SORT CASES  BY age_group.
SPLIT FILE SEPARATE BY age_group.

GLM OLD_OA NEW_OA OLD_YA NEW_YA
  /WSFACTOR=TargAge 2 Polynomial Foil 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(OVERALL) 
  /EMMEANS=TABLES(TargAge) 
  /EMMEANS=TABLES(Foil) 
  /EMMEANS=TABLES(TargAge*Foil) COMPARE(TargAge) ADJ(LSD)
  /EMMEANS=TABLES(TargAge*Foil) COMPARE(Foil) ADJ(LSD)
  /PRINT=ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=TargAge Foil TargAge*Foil.


SPLIT FILE OFF.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT trail_b_time
  /METHOD=ENTER trail_a_time
  /SAVE RESID ZRESID.

COMPUTE TMT_ratio=trail_a_time / trail_b_time.
EXECUTE.
  

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT FN_recog_correct
  /METHOD=ENTER gender school ladder age_group
  /METHOD=ENTER RES_1 delayed_rey_sum
  /METHOD=ENTER Office_Control Office_deceit Office_emotion Office_faux Office_infer Office_motiv 
    Office_Seen.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT FN_recall
  /METHOD=ENTER gender school ladder age_group
  /METHOD=ENTER RES_1 delayed_rey_sum Office_Control Office_deceit Office_emotion Office_faux Office_infer Office_motiv 
    Office_Seen.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT FN_recall
  /METHOD=ENTER gender school ladder age_group
  /METHOD=ENTER delayed_rey_sum 
  /METHOD=ENTER Office_emotion.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA COLLIN TOL CHANGE ZPP
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT std_recall
  /METHOD=ENTER gender school ladder age
  /METHOD=ENTER trail_a_time trail_b_time delayed_rey_sum moca_raw CRAFTDRE digib MINT_uncued VERFL_totalsum waisdsymbol 
  /METHOD=ENTER Office_Control Office_deceit Office_emotion Office_faux Office_infer Office_motiv 
    Office_Seen RTME.

  PROCESS 
  y=std_recall
  /x=age_group
  /m=delayed_rey_sum Office_emotion        
  /cov=gender school ladder                    
  /decimals=F10.4                                
  /boot=5000    
  
  /conf=95
  /longname=1
  /model=4.

  
  PROCESS 
  y=std_recall
  /x=age_group
  /m=delayed_rey_sum Office_emotion        
  /cov=gender school ladder                    
  /decimals=F10.4                                
  /boot=5000    
  
  /conf=95
  /longname=1
  /model=6.
  
  
  PROCESS 
  y=std_recall
  /x=age_group
  /m=Office_emotion delayed_rey_sum       
  /cov=gender school ladder                    
  /decimals=F10.4                                
  /boot=5000    
  
  /conf=95
  /longname=1
  /model=6.

