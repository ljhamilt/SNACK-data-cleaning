****Project: SNACK-SNAD
****Author:  Lucas Hamilton
****Date:    2023/01/11
****Purpose: Create cognitive performance measures


**# 1 Create standardized scores to sample average **

destring veg, replace
gen negTraila= -trail_a_time 
gen negTrailb= -trail_b_time 
regress negTrailb negTraila
predict Trailb_resid, residuals

egen reydelaySD=std(delayed_rey_sum)
foreach var in CRAFTDRE negTraila digif digib animals veg waisdsymbol UDSBENTC UDSBENTD MINTTOTS  {
		egen `var'SD=std(`var')
		}

**# 2 Create sample-specific composites**

		* Attention: Digit Span Forward/Backward (2-item)
		egen attention=rowmean(digifSD digibSD)  // note: higher is better
		
		* Speed of Processing: Trails A; WAIS-R Digit Symbol  (2-item)
		egen speed=rowmean(negTrailaSD waisdsymbolSD) // note: higher is better 
		
		* Executive Function: : Trails B [task-switching] (1-item) // formerly also Verbal Fluency (F & L words); 
		egen execfxn = std(Trailb_resid) // note: higher is better
		// formerly, egen exec=rowmean(UDSVERFCSD UDSVERLCSD negTrailbSD), but the alpha was too low 
		
		* Episodic Memory: Craft Story 21 (Recall Paraphrase); Rey AVLT Delayed Recall; Benson Complex Figure Recall (3-item)
		egen epmem=rowmean(CRAFTDRESD reydelaySD UDSBENTDSD) // note: higher is better 
		
		* Language: Animal and Vegetable Naming, Multilingual Naming Test (3-item)
		egen language=rowmean(animalsSD vegSD MINTTOTSSD)
		
		* Visual/Spatial: Benson Complex Figure Copy (1 item only)
		gen visual=UDSBENTCSD
		
**# 3 Checking for outliers**
foreach x in attention speed execfxn epmem language visual {
gen outlier_`x' = `x'
recode outlier_`x' (min/-2=1) (else=0)
}
egen outlier_tot = rowtotal(outlier_attention outlier_speed outlier_execfxn outlier_epmem outlier_language outlier_visual)	
fre outlier_tot
list SUBID source_study if outlier_tot > 2


**# BONUS Create standardized latent scores from Kiselica et al. 2020 **
gen zCRAFTVRS = (CRAFTVRS - 21.9)/6.45
gen zUDSBENTC = (UDSBENTC -15.58)/1.31
gen zDIGIF = (digif - 8.34)/2.3
gen zDIGIB = (digib - 7.12)/2.2
gen zANIMALS = (animals - 21.63)/5.58

gen zVEG = (veg - 14.89)/4.04
gen zTRAILA = ((trail_a_time - 31.21)/12.25)*-1
gen zTRAILB = ((trail_b_time - 80.32)/38.42)*-1
gen zCRAFTDVR = (CRAFTDVR - 19.08)/6.53
gen zUDSBENTD = (UDSBENTD - 11.5)/2.9
gen zMINTTOTS = (MINTTOTS - 30.12)/2
gen zUDSVERTN = (UDSVER_TOT - 28.44)/8.14

***unadjusted for sex, age, or education
gen pop_speed_exec = (.581*zTRAILB) + (.437*zTRAILA) + (.57*zUDSVERTN)
gen pop_visual = (.427*zUDSBENTC) + (.685*zUDSBENTD)
gen pop_epmem = (.909*zCRAFTVRS) + (.952*zCRAFTDVR)
gen pop_attention = (.602*zDIGIF) + (.828*zDIGIB)
gen pop_language = (.456*zVEG) + (.637*zANIMALS) + (.497*zMINTTOTS)
gen gen_cog = (1.075*speed_exec) + (.507*visual) + (.404*ep_memory) + (.611*attention) + (.966*language)
