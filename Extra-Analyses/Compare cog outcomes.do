****Project: SNACK-SNAD
****Author:  Lucas Hamilton
****Date:    2022/04/29
****Version: 17
****Purpose: Investigate differences in SNACK/SNAD cognitive performance measures


**# 1 Visualizing spread, mean, and density for composite UDS domains, MOCA, and  (see Max's code)**
histogram attention, fraction legend(off) normal by(, note(Attention = Digit Span Forward & Backwards)) by(cog_stat, rows(1))  name(histo1, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\atthisto.png", replace as(png) name("histo1")

histogram speed, fraction normal by(, note(Speed = Trails A & WAIS Digit Symbol)) by(cog_stat, rows(1)) legend(off) name(histo2, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\speedhisto.png", replace as(png) name("histo2")

histogram epmem, fraction normal by(, note(Ep. Mem = Craft Delayed Paraphrase & REY Delayed & Benson)) by(cog_stat, rows(1)) legend(off) name(histo3, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\epmemhisto.png", replace as(png) name("histo3")

histogram exec, fraction normal by(, note(EF = Trails B)) by(cog_stat, rows(1)) legend(off) name(histo4, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\exechisto.png", replace as(png) name("histo4")

histogram language, fraction normal by(, note(Language = Animal & Veggie Naming & MINT)) by(cog_stat, rows(1)) legend(off) name(histo5, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\langhisto.png", replace as(png) name("histo5")

histogram visual, fraction  normal by(, note(Visual = Benson Figure Copy)) by(cog_stat, rows(1)) legend(off) name(histo6, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\visualhisto.png", replace as(png) name("histo6")

histogram moca_raw, fraction legend(off) normal by(, note(MOCA)) by(cog_stat, rows(1))  name(histofisto1, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\moca_raw.png", replace as(png) name("histofisto1")

histogram mocaSD, fraction normal by(, note(MOCA)) by(cog_stat, rows(1)) legend(off) name(histo7, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\MOCASDhisto.png", replace as(png) name("histo7")

histogram occcomplex_data, fraction normal by(cog_stat, rows(1)) legend(off) name(histo8, replace)
histogram occcomplex_people, fraction normal by(cog_stat, rows(1)) legend(off) name(histo9, replace)
histogram occcomplex_things, fraction normal by(cog_stat, rows(1)) legend(off) name(histo10, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\occdata.png", replace as(png) name("histo8")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\occpeople.png", replace as(png) name("histo9")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\occthings.png", replace as(png) name("histo10")

histogram gds15_combined, fraction normal by(cog_stat, rows(1)) legend(off) name(histoGDS, replace)

**# 2 Box/Dot plots***
stripplot attention, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip1, replace)
stripplot speed, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip2, replace)
stripplot epmem, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip3, replace)
stripplot exec, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip4, replace)
stripplot language, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip5, replace)
stripplot visual, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip6, replace)
graph combine strip1 strip2 strip3 strip4 strip5 strip6, xcom ycom name(stripplots1, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\stripplots1.png", replace as(png) name("stripplots1")

stripplot mocaSD, cumul cumprob box centre over(source_study) refline vertical xsize(3) name(MOCA)

stripplot digifSD, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip11, replace)
stripplot digibSD, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip12, replace)
graph combine strip11 strip12, xcom ycom name(attentionitems, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\attentionitems.png", replace as(png) name("attentionitems")

stripplot negTrailaSD, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip13, replace)
stripplot waisdsymbolSD, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip14, replace)
graph combine strip13 strip14, xcom ycom name(speeditems, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\speeditems.png", replace as(png) name("speeditems")

stripplot CRAFTDRESD, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip15, replace)
stripplot reydelaySD, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip16, replace)
stripplot UDSBENTDSD, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip17, replace)
graph combine strip17 strip15 strip16, xcom ycom name(epmemitems, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\epmemitems.png", replace as(png) name("epmemitems")

stripplot animalsSD, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip18, replace)
stripplot vegSD, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip19, replace)
stripplot MINTTOTSSD, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip20, replace)
graph combine strip18 strip19 strip20, xcom ycom name(languageitems, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\languageitems.png", replace as(png) name("languageitems")

stripplot occcomplex_data, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(occdata, replace)
stripplot occcomplex_people, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(occpeople, replace)
stripplot occcomplex_things, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(occthings, replace)

stripplot gds15_combined, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(GDS_raw, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\GDS15_bysource_raw.png", replace as(png) name("GDS_raw")

**# 3 Univariate outliers
foreach x in attention speed exec epmem language visual {
gen outlier_`x' = `x'
recode outlier_`x' (min/-2 = -1) (2/max = 1) (else=0)
gen abs_out_`x' = abs(outlier_`x')
}
egen outlier_comptot = rowtotal(abs_out_*)

foreach x in digif digib negTraila waisdsymbol CRAFTDRE reydelay UDSBENTD negTrailb animals veg MINTTOTS {
gen outlier_`x' = `x'SD
recode outlier_`x' (min/-2 = -1) (2/max = 1) (else=0)
gen abs_out_item_`x' = abs(outlier_`x')
}
egen outlier_itemtot = rowtotal(abs_out_item*)

foreach x in attention speed exec epmem language visual digif digib negTraila waisdsymbol CRAFTDRE delayed_rey_sum UDSBENTD negTrailb animals veg MINTTOTS {
egen mean_`x' =mean(`x'), by(cog_stat)
egen iq_`x' = iqr(`x'), by(cog_stat)
gen iqhalf_`x' = (iq_`x')*1.5
gen iqu_`x' = mean_`x' + iqhalf_`x'
gen iql_`x' = mean_`x' - iqhalf_`x'
gen iqr_outlier_`x' = .
recode iqr_outlier_`x' (.=1) if `x' > iqu_`x'
recode iqr_outlier_`x' (.=-1) if `x' < iql_`x'
recode iqr_outlier_`x' (.=0)
gen abs_iqr_out_`x' = abs(iqr_outlier_`x')
}
egen iqr_comptot = rowtotal( abs_iqr_out_attention abs_iqr_out_speed abs_iqr_out_exec abs_iqr_out_epmem abs_iqr_out_language)
egen iqr_itemtot = rowtotal( abs_iqr_out_digif abs_iqr_out_digib abs_iqr_out_negTraila abs_iqr_out_waisdsymbol abs_iqr_out_CRAFTDRE abs_iqr_out_delayed_rey_sum abs_iqr_out_UDSBENTD abs_iqr_out_negTrailb abs_iqr_out_animals abs_iqr_out_veg abs_iqr_out_MINTTOTS)


fre abs_iqr*
foreach x in  abs_iqr_out_attention abs_iqr_out_speed abs_iqr_out_exec abs_iqr_out_epmem abs_iqr_out_language abs_iqr_out_visual abs_iqr_out_digif abs_iqr_out_digib abs_iqr_out_negTraila abs_iqr_out_waisdsymbol abs_iqr_out_CRAFTDRE abs_iqr_out_delayed_rey_sum abs_iqr_out_UDSBENTD abs_iqr_out_negTrailb abs_iqr_out_animals abs_iqr_out_veg abs_iqr_out_MINTTOTS {
tab cog_stat `x'
}

save "I:\explore long.dta", replace

**# 4 Visualize bivariate relationships

bysort cog_stat: pwcorr attention speed exec epmem language visual, sig

graph matrix attention speed epmem exec language if cog_stat == 0, mcolor(black) msize(tiny) msymbol(circle_hollow) half 
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\SNACK matrix.png", as(png) name("Graph")

graph matrix attention speed epmem exec language if cog_stat == 1, mcolor(black) msize(tiny) msymbol(circle_hollow) half 
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\SNAD Normal matrix.png", as(png) name("Graph")

graph matrix attention speed epmem exec language if cog_stat == 2, mcolor(black) msize(tiny) msymbol(circle_hollow) half 
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\SNAD MCI AD matrix.png", as(png) name("Graph")


foreach x in attention speed exec epmem language {
scatter gds15_combinedSD `x' if cog_stat==0, m(oh) mlc(ebblue) || lfit gds15_combinedSD `x' if cog_stat ==0, lc(ebblue) ||scatter gds15_combinedSD `x' if cog_stat==1, m(oh) mlc(black) || lfit gds15_combinedSD `x' if cog_stat==1, lc(black) ||  scatter gds15_combinedSD `x' if cog_stat==2, m(oh) mlc(red) || lfit gds15_combinedSD `x' if cog_stat==2, lc(red)||, title("Correlation with GDS-15") legend(order(1 "SNACK" 2 "" 3 "SNAD - Normal" 4 "" 5 "SNAD - MCI/AD" 6 "")) name(`x'1, replace)
}
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\attention1.png", replace as(png) name("attention1")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\speed1.png", replace as(png) name("speed1")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\epmem1.png", replace as(png) name("epmem1")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\exec1.png", replace as(png) name("exec1")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\language1.png", replace as(png) name("language1")


foreach x in attention speed exec epmem language {
scatter occcomplex_data `x' if cog_stat==0, m(oh) mlc(ebblue) || lfit occcomplex_data `x' if cog_stat ==0, lc(ebblue) ||scatter occcomplex_data `x' if cog_stat==1, m(oh) mlc(black) || lfit occcomplex_data `x' if cog_stat==1, lc(black) ||  scatter occcomplex_data `x' if cog_stat==2, m(oh) mlc(red) || lfit occcomplex_data `x' if cog_stat==2, lc(red)||, title("Correlation with Working with Data") legend(order(1 "SNACK" 2 "" 3 "SNAD - Normal" 4 "" 5 "SNAD - MCI/AD" 6 "")) name(`x'2, replace)
}
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\attention2.png", replace as(png) name("attention2")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\speed2.png", replace as(png) name("speed2")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\epmem2.png", replace as(png) name("epmem2")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\exec2.png", replace as(png) name("exec2")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\language2.png", replace as(png) name("language2")

foreach x in attention speed exec epmem language {
scatter occcomplex_things `x' if cog_stat==0, m(oh) mlc(ebblue) || lfit occcomplex_things `x' if cog_stat ==0, lc(ebblue) ||scatter occcomplex_things `x' if cog_stat==1, m(oh) mlc(black) || lfit occcomplex_things `x' if cog_stat==1, lc(black) ||  scatter occcomplex_things `x' if cog_stat==2, m(oh) mlc(red) || lfit occcomplex_things `x' if cog_stat==2, lc(red)||, title("Correlation with Working with Things") legend(order(1 "SNACK" 2 "" 3 "SNAD - Normal" 4 "" 5 "SNAD - MCI/AD" 6 "")) name(`x'3, replace)
}
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\attention3.png", replace as(png) name("attention3")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\speed3.png", replace as(png) name("speed3")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\epmem3.png", replace as(png) name("epmem3")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\exec3.png", replace as(png) name("exec3")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\language3.png", replace as(png) name("language3")

foreach x in attention speed exec epmem language {
scatter occcomplex_people `x' if cog_stat==0, m(oh) mlc(ebblue) || lfit occcomplex_people `x' if cog_stat ==0, lc(ebblue) ||scatter occcomplex_people `x' if cog_stat==1, m(oh) mlc(black) || lfit occcomplex_people `x' if cog_stat==1, lc(black) ||  scatter occcomplex_people `x' if cog_stat==2, m(oh) mlc(red) || lfit occcomplex_people `x' if cog_stat==2, lc(red)||, title("Correlation with Working with People") legend(order(1 "SNACK" 2 "" 3 "SNAD - Normal" 4 "" 5 "SNAD - MCI/AD" 6 "")) name(`x'4, replace)
}
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\attention4.png", replace as(png) name("attention4")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\speed4.png", replace as(png) name("speed4")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\epmem4.png", replace as(png) name("epmem4")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\exec4.png", replace as(png) name("exec4")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\ExcOut\language4.png", replace as(png) name("language4")




**# 5 EXTRA CODE
***************Reconstruct Histograms*****************

drop if outlier_total > 1
histogram attention, fraction legend(off) normal by(, note(Attention = Digit Span Forward & Backwards)) by(cog_stat, rows(1))  name(histo1, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\atthisto.png", replace as(png) name("histo1")

histogram speed, fraction normal by(, note(Speed = Trails A & WAIS Digit Symbol)) by(cog_stat, rows(1)) legend(off) name(histo2, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\speedhisto.png", replace as(png) name("histo2")

histogram epmem, fraction normal by(, note(Ep. Mem = Craft Delayed Paraphrase & REY Delayed & Benson)) by(cog_stat, rows(1)) legend(off) name(histo3, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\epmemhisto.png", replace as(png) name("histo3")

histogram exec, fraction normal by(, note(EF = Trails B)) by(cog_stat, rows(1)) legend(off) name(histo4, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\exechisto.png", replace as(png) name("histo4")

histogram language, fraction normal by(, note(Language = Animal & Veggie Naming & MINT)) by(cog_stat, rows(1)) legend(off) name(histo5, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\langhisto.png", replace as(png) name("histo5")

histogram visual, fraction  normal by(, note(Visual = Benson Figure Copy)) by(cog_stat, rows(1)) legend(off) name(histo6, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\visualhisto.png", replace as(png) name("histo6")



twoway (histogram new_attention if cog_stat==1, fraction color(black%50)) (histogram new_attention if cog_stat ==2, fraction color(red%25)) , title("SNAD", box bexpand) legend(order(1 "Normal" 2 "AD/MCI") pos(12)) name(attSNAD, replace)
histogram new_attention if cog_stat==0, fraction color(ebblue%40) title("SNACK", box bexpand) name(attSNACK, replace) 
graph combine attSNAD attSNACK, xcom ycom name(new_attcom, replace) note("Attention = Digit Span Forward & Backwards")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\new_attcom.png", replace as(png) name("new_attcom")

twoway (histogram new_speed if cog_stat==1, fraction color(black%50)) (histogram new_speed if cog_stat ==2, fraction color(red%25)) , title("SNAD", box bexpand) legend(order(1 "Normal" 2 "AD/MCI") pos(12)) name(speedSNAD, replace)
histogram new_speed if cog_stat==0, fraction color(ebblue%40) title("SNACK", box bexpand) name(speedSNACK, replace) 
graph combine speedSNAD speedSNACK, xcom ycom name(new_speedcom, replace) note("Speed = Trails A & WAIS Digit Symbol")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\new_speedcom.png", replace as(png) name("new_speedcom")

twoway (histogram new_epmem if cog_stat==1, fraction color(black%50)) (histogram new_epmem if cog_stat ==2, fraction color(red%25)) , title("SNAD", box bexpand) legend(order(1 "Normal" 2 "AD/MCI") pos(12)) name(epmemSNAD, replace)
histogram new_epmem if cog_stat==0, fraction color(ebblue%40) title("SNACK", box bexpand) name(epmemSNACK, replace) 
graph combine epmemSNAD epmemSNACK, xcom ycom name(new_epmemcom, replace) note("Craft Delayed Paraphrase & REY Delayed & BENSON")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\new_epmemcom.png", replace as(png) name("new_epmemcom")

twoway (histogram new_exec if cog_stat==1, fraction color(black%50)) (histogram new_exec if cog_stat ==2, fraction color(red%25)) , title("SNAD", box bexpand) legend(order(1 "Normal" 2 "AD/MCI") pos(12)) name(execSNAD, replace)
histogram new_exec if cog_stat==0, fraction color(ebblue%40) title("SNACK", box bexpand) name(execSNACK, replace) 
graph combine execSNAD execSNACK, xcom ycom name(new_execcom, replace) note("Exec = Trails B")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\new_execcom.png", replace as(png) name("new_execcom")

twoway (histogram new_language if cog_stat==1, fraction color(black%50)) (histogram new_language if cog_stat ==2, fraction color(red%25)) , title("SNAD", box bexpand) legend(order(1 "Normal" 2 "AD/MCI") pos(12)) name(langSNAD, replace)
histogram new_language if cog_stat==0, fraction color(ebblue%40) title("SNACK", box bexpand) name(langSNACK, replace) 
graph combine langSNAD langSNACK, xcom ycom name(new_langcom, replace) note("Language = Animal & Veggie Naming & MINT")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\new_langcom.png", replace as(png) name("new_langcom")

twoway (histogram new_visual if cog_stat==1, fraction color(black%50)) (histogram new_visual if cog_stat ==2, fraction color(red%25)) , title("SNAD", box bexpand) legend(order(1 "Normal" 2 "AD/MCI") pos(12)) name(visualSNAD, replace)
histogram new_visual if cog_stat==0, fraction color(ebblue%40) title("SNACK", box bexpand) name(visualSNACK, replace) 
graph combine visualSNAD visualSNACK, xcom ycom name(new_visualcom, replace) note("Visual = Figure Copy")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\new_visualcom.png", replace as(png) name("new_visualcom")



 
*Histograms by source with AD/MC separated in SNAD***
twoway (histogram attention if cog_stat==1, fraction color(black%50)) (histogram attention if cog_stat ==2, fraction color(red%25)) , title("SNAD", box bexpand) legend(order(1 "Normal" 2 "AD/MCI") pos(12)) name(attSNAD, replace)
histogram attention if cog_stat==0, fraction color(ebblue%40) title("SNACK", box bexpand) name(attSNACK, replace) 
graph combine attSNAD attSNACK, xcom ycom name(attcom, replace) note("Attention = Digit Span Forward & Backwards")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\attcom.png", replace as(png) name("attcom")

twoway (histogram speed if cog_stat==1, fraction color(black%50)) (histogram speed if cog_stat ==2, fraction color(red%25)) , title("SNAD", box bexpand) legend(order(1 "Normal" 2 "AD/MCI") pos(12)) name(speedSNAD, replace)
histogram speed if cog_stat==0, fraction color(ebblue%40) title("SNACK", box bexpand) name(speedSNACK, replace) 
graph combine speedSNAD speedSNACK, xcom ycom name(speedcom, replace) note("Speed = Trails A & WAIS Digit Symbol")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\speedcom.png", replace as(png) name("speedcom")

twoway (histogram epmem if cog_stat==1, fraction color(black%50)) (histogram epmem if cog_stat ==2, fraction color(red%25)) , title("SNAD", box bexpand) legend(order(1 "Normal" 2 "AD/MCI") pos(12)) name(epmemSNAD, replace)
histogram epmem if cog_stat==0, fraction color(ebblue%40) title("SNACK", box bexpand) name(epmemSNACK, replace) 
graph combine epmemSNAD epmemSNACK, xcom ycom name(epmemcom, replace) note("Craft Delayed Paraphrase & REY Delayed & BENSON")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\epmemcom.png", replace as(png) name("epmemcom")

twoway (histogram exec if cog_stat==1, fraction color(black%50)) (histogram exec if cog_stat ==2, fraction color(red%25)) , title("SNAD", box bexpand) legend(order(1 "Normal" 2 "AD/MCI") pos(12)) name(execSNAD, replace)
histogram exec if cog_stat==0, fraction color(ebblue%40) title("SNACK", box bexpand) name(execSNACK, replace) 
graph combine execSNAD execSNACK, xcom ycom name(execcom, replace) note("Exec = Trails B")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\execcom.png", replace as(png) name("execcom")

twoway (histogram language if cog_stat==1, fraction color(black%50)) (histogram language if cog_stat ==2, fraction color(red%25)) , title("SNAD", box bexpand) legend(order(1 "Normal" 2 "AD/MCI") pos(12)) name(langSNAD, replace)
histogram language if cog_stat==0, fraction color(ebblue%40) title("SNACK", box bexpand) name(langSNACK, replace) 
graph combine langSNAD langSNACK, xcom ycom name(langcom, replace) note("Language = Animal & Veggie Naming & MINT")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\langcom.png", replace as(png) name("langcom")

twoway (histogram visual if cog_stat==1, fraction color(black%50)) (histogram visual if cog_stat ==2, fraction color(red%25)) , title("SNAD", box bexpand) legend(order(1 "Normal" 2 "AD/MCI") pos(12)) name(visualSNAD, replace)
histogram visual if cog_stat==0, fraction color(ebblue%40) title("SNACK", box bexpand) name(visualSNACK, replace) 
graph combine visualSNAD visualSNACK, xcom ycom name(visualcom, replace) note("Visual = Figure Copy")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\visualcom.png", replace as(png) name("visualcom")

twoway (histogram mocaSD if cog_stat==1, fraction color(black%50)) (histogram mocaSD if cog_stat ==2, fraction color(red%25)) , title("SNAD", box bexpand) legend(order(1 "Normal" 2 "AD/MCI") pos(12)) name(mocaSNAD, replace)
histogram mocaSD if cog_stat==0, fraction color(ebblue%40) title("SNACK", box bexpand) name(mocaSNACK, replace) 
graph combine mocaSNAD mocaSNACK, xcom ycom name(mocacom, replace) note("MOCA Std. Dev.")
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\mocacom.png", replace as(png) name("mocacom")

****All groups in one****
twoway (histogram attention if cog_stat==0, frequency color(ebblue%40)) (histogram attention if cog_stat==1, frequency color(black%50)) (histogram attention if cog_stat ==2, frequency color(red%40)) , legend(order(1 "SNACK" 2 "SNAD Normal" 3 "SNAD AD/MCI"))






scatter exec attention if cog_stat==0, m(oh) mlc(ebblue) || lfit exec attention if cog_stat ==0, lc(ebblue) ||scatter exec attention if cog_stat==1, m(oh) mlc(black) || lfit exec attention if cog_stat==1, lc(black) ||  scatter exec attention if cog_stat==2, m(oh) mlc(red) || lfit exec attention if cog_stat==2, lc(red)||, legend(order(1 "SNACK" 2 ".33" 3 "SNAD - Normal" 4 ".46" 5 "SNAD - MCI/AD" 6 ".29")) name(scatter1, replace)


scatter mocaSD attention [w=diagnosis_iadc] if source_study==0, m(oh) mlc(orange_red) || lfit mocaSD attention if source_study ==0, lc(orange_red) || scatter mocaSD attention if source_study==1, m(oh) mlc(edkblue) || lfit mocaSD attention if source_study==1, lc(edkblue) name(graph, replace)

***within UDS items
foreach x in speed exec epmem language {
scatter `x' attention if cog_stat==0, m(oh) mlc(ebblue) || lfit `x' attention if cog_stat ==0, lc(ebblue) ||, name(SNACKattention`x', replace)
scatter `x' attention if cog_stat==1, m(oh) mlc(black) || lfit `x' attention if cog_stat==1, lc(black) ||  scatter `x' attention if cog_stat==2, m(oh) mlc(red) || lfit `x' attention if cog_stat==2, lc(red) ||, name(SNADattention`x', replace)
}
