****Project: SNACK-SNAD
****Author:  Lucas Hamilton
****Date:    2022/04/29
****Version: 17
****Purpose: Investigate differences in SNACK/SNAD cognitive performance measures


**# 1 Visualizing spread, mean, and density for composite UDS domains (see Max's code)**
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

histogram mocaSD, fraction normal by(, note(MOCA)) by(cog_stat, rows(1)) legend(off) name(histo7, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\MOCASDhisto.png", replace as(png) name("histo7")

histogram occcomplex_data, fraction normal by(cog_stat, rows(1)) legend(off) name(histo8, replace)
histogram occcomplex_people, fraction normal by(cog_stat, rows(1)) legend(off) name(histo9, replace)
histogram occcomplex_things, fraction normal by(cog_stat, rows(1)) legend(off) name(histo10, replace)



***Easy extra plots***
stripplot attention, cumul cumprob box centre over(source_study) refline vertical xsize(3) name(strip1, replace)
stripplot speed, cumul cumprob box centre over(source_study) refline vertical xsize(3) name(strip2, replace)
stripplot epmem, cumul cumprob box centre over(source_study) refline vertical xsize(3) name(strip3, replace)
stripplot exec, cumul cumprob box centre over(source_study) refline vertical xsize(3) name(strip4, replace)
stripplot language, cumul cumprob box centre over(source_study) refline vertical xsize(3) name(strip5, replace)
stripplot visual, cumul cumprob box centre over(source_study) refline vertical xsize(3) name(strip6, replace)
graph combine strip1 strip2 strip3 strip4 strip5 strip6, name(stripplots, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\stripplots.png", replace as(png) name("stripplots")

stripplot mocaSD, cumul cumprob box centre over(source_study) refline vertical xsize(3) name(MOCA)


***Histograms by source with AD/MC pulled out in SNAD***
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


**# 2 Visualize bivariate relationships against UDS and MOCOA

scatter mocaSD attention, m(oh) || lfit mocaSD attention || , by(cog_stat, total) name(scat1, replace)
graph export "\\Client\F$\krendl lab\Lucas\SNACK%3aSNAD Materials\PNGs\scat1.png", replace as(png) name("scat1")

scatter mocaSD speed, m(oh) || lfit mocaSD speed || qfit mocaSD speed ||, by(cog_stat, total) name(scat2, replace)

scatter mocaSD epmem, m(oh) || lfit mocaSD epmem || qfit mocaSD epmem ||, by(cog_stat, total) name(scat3, replace)

scatter mocaSD exec, m(oh) || lfit mocaSD exec || qfit mocaSD exec ||, by(cog_stat, total) name(scat4, replace)

scatter mocaSD language, m(oh) || lfit mocaSD language || qfit mocaSD language ||, by(cog_stat, total) name(scat5, replace)

scatter mocaSD visual, m(oh) || lfit mocaSD visual || qfit mocaSD visual ||, by(cog_stat, total) name(scat6, replace)

stripplot gds15_combinedSD, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip1, replace)
graph export "Z:\krendl lab\Lucas\SNACKSNAD Materials\PNGs\GDS15_bysource.png", replace as(png) name("strip1")

stripplot occcomplex_data, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip2, replace)

stripplot occcomplex_people, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip3, replace)

stripplot occcomplex_things, cumul cumprob box centre over(cog_stat) refline vertical xsize(3) name(strip4, replace)


foreach x in attention speed exec epmem language visual{
scatter gds15_combinedSD `x' if cog_stat==0, m(oh) mlc(ebblue) || lfit gds15_combinedSD `x' if cog_stat ==0, lc(ebblue) ||scatter gds15_combinedSD `x' if cog_stat==1, m(oh) mlc(black) || lfit gds15_combinedSD `x' if cog_stat==1, lc(black) ||  scatter gds15_combinedSD `x' if cog_stat==2, m(oh) mlc(red) || lfit gds15_combinedSD `x' if cog_stat==2, lc(red)||, legend(order(1 "SNACK" 2 "" 3 "SNAD - Normal" 4 "" 5 "SNAD - MCI/AD" 6 "")) name(`x'1, replace)
}
graph combine attention1 speed1 exec1 epmem1 language1 visual1, xcom ycom name(combined, replace)

foreach x in attention speed exec epmem language visual{
scatter occcomplex_data `x' if cog_stat==0, m(oh) mlc(ebblue) || lfit occcomplex_data `x' if cog_stat ==0, lc(ebblue) ||scatter occcomplex_data `x' if cog_stat==1, m(oh) mlc(black) || lfit occcomplex_data `x' if cog_stat==1, lc(black) ||  scatter occcomplex_data `x' if cog_stat==2, m(oh) mlc(red) || lfit occcomplex_data `x' if cog_stat==2, lc(red)||, legend(order(1 "SNACK" 2 "" 3 "SNAD - Normal" 4 "" 5 "SNAD - MCI/AD" 6 "")) name(`x'2, replace)
}
graph combine attention2 speed2 exec2 epmem2 language2 visual2, xcom ycom name(combined2, replace)

foreach x in attention speed exec epmem language visual{
scatter occcomplex_things `x' if cog_stat==0, m(oh) mlc(ebblue) || lfit occcomplex_things `x' if cog_stat ==0, lc(ebblue) ||scatter occcomplex_things `x' if cog_stat==1, m(oh) mlc(black) || lfit occcomplex_things `x' if cog_stat==1, lc(black) ||  scatter occcomplex_things `x' if cog_stat==2, m(oh) mlc(red) || lfit occcomplex_things `x' if cog_stat==2, lc(red)||, legend(order(1 "SNACK" 2 "" 3 "SNAD - Normal" 4 "" 5 "SNAD - MCI/AD" 6 "")) name(`x'3, replace)
}
graph combine attention3 speed3 exec3 epmem3 language3 visual3, xcom ycom name(combined3, replace)

foreach x in attention speed exec epmem language visual{
scatter occcomplex_people `x' if cog_stat==0, m(oh) mlc(ebblue) || lfit occcomplex_people `x' if cog_stat ==0, lc(ebblue) ||scatter occcomplex_people `x' if cog_stat==1, m(oh) mlc(black) || lfit occcomplex_people `x' if cog_stat==1, lc(black) ||  scatter occcomplex_people `x' if cog_stat==2, m(oh) mlc(red) || lfit occcomplex_people `x' if cog_stat==2, lc(red)||, legend(order(1 "SNACK" 2 "" 3 "SNAD - Normal" 4 "" 5 "SNAD - MCI/AD" 6 "")) name(`x'4, replace)
}
graph combine attention4 speed4 exec4 epmem4 language4 visual4, xcom ycom name(combined4, replace)


graph export "Z:\krendl lab\Lucas\SNACKSNAD Materials\PNGs\`x'''1.png", replace as(png) name("`x'1")


scatter exec attention if cog_stat==0, m(oh) mlc(ebblue) || lfit exec attention if cog_stat ==0, lc(ebblue) ||scatter exec attention if cog_stat==1, m(oh) mlc(black) || lfit exec attention if cog_stat==1, lc(black) ||  scatter exec attention if cog_stat==2, m(oh) mlc(red) || lfit exec attention if cog_stat==2, lc(red)||, legend(order(1 "SNACK" 2 ".33" 3 "SNAD - Normal" 4 ".46" 5 "SNAD - MCI/AD" 6 ".29")) name(scatter1, replace)


scatter mocaSD attention [w=diagnosis_iadc] if source_study==0, m(oh) mlc(orange_red) || lfit mocaSD attention if source_study ==0, lc(orange_red) || scatter mocaSD attention if source_study==1, m(oh) mlc(edkblue) || lfit mocaSD attention if source_study==1, lc(edkblue) name(graph, replace)

bysort cog_stat: pwcorr mocaSD attention speed exec epmem language visual, sig


**# 3 Univariate outliers

gen outlier_att = attention
gen outlier_speed = speed
gen outlier_epmem = epmem
gen outlier_exec = exec 
gen outlier_language = language 
gen outlier_visual = visual
recode outlier_* (-2/2=0) (else=1)
egen outlier_tot = rowtotal(outlier_*)


recode cog_stat (.=100)
tab cog_stat outlier_tot


***************Reconstruct Histograms*****************

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









