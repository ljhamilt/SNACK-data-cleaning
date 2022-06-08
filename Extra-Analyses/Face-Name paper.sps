DATASET ACTIVATE DataSet1.
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

BOOTSTRAP
  /SAMPLING METHOD=SIMPLE
  /VARIABLES TARGET=FN_recall FN_recog_correct FN_RT_recog_correct FN_recog_miss FN_RT_recog_miss 
    INPUT=age_group 
  /CRITERIA CILEVEL=95 CITYPE=PERCENTILE  NSAMPLES=1000
  /MISSING USERMISSING=EXCLUDE.
T-TEST GROUPS=age_group('YA' 'OA')
  /MISSING=ANALYSIS
  /VARIABLES=FN_recall FN_recog_correct FN_RT_recog_correct FN_recog_miss FN_RT_recog_miss
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).

EXAMINE VARIABLES=FN_recall
  /PLOT BOXPLOT STEMLEAF
  /COMPARE GROUPS
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

GLM Foil_new Foil_old BY age_group
  /WSFACTOR=FoilType 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(age_group*FoilType) COMPARE(age_group) ADJ(LSD)
  /PRINT=ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=FoilType
  /DESIGN=age_group.


GLM Foil_RT_new Foil_RT_old BY age_group
  /WSFACTOR=FoilType 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(age_group*FoilType) COMPARE(age_group) ADJ(LSD)
  /PRINT=ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=FoilType
  /DESIGN=age_group.

  COMPUTE OA_recog=FNameT_OAF + FNameT_OAM.
EXECUTE.
COMPUTE YA_recog=FNameT_YAF + FNameT_YAM.
EXECUTE.

GLM YA_recog OA_recog BY age_group
  /WSFACTOR=TargetAge 2 Polynomial
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(age_group*TargetAge) COMPARE(age_group) ADJ(LSD)
  /PRINT=ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=TargetAge
  /DESIGN=age_group.



