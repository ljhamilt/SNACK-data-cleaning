****Project: SNACK
****Author:  Lucas Hamilton (Credit to Siyun Peng [https://github.com/PengSiyun] for source code)
****Date:    2022/04/21
****Purpose: Clean SNACK participant social network data

clear

**********************************************************************
**# 1  Unzipping Data
**********************************************************************

ssc install mvfiles
local sourcedir "I:\SNACK Interviews" 
local unzipdir "I:\SNACK Interviews\Netcanvas"
cap mkdir "`unzipdir'" 

local fls : dir "`sourcedir'" files "*.zip"
cd "`unzipdir'"

foreach f of local fls {
  2. di "Working on `f'"
  3. unzipfile "`sourcedir'/`f'", replace
}

***move files to respective folders
mvfiles , infolder("`unzipdir'") outfolder("`unzipdir'/ego") match("*ego*") makedirs erase 
mvfiles , infolder("`unzipdir'") outfolder("`unzipdir'/alter") match("*attributeList_name*") makedirs erase
mvfiles , infolder("`unzipdir'") outfolder("`unzipdir'/interviewer") match("*attributeList_Inter*") makedirs erase
mvfiles , infolder("`unzipdir'") outfolder("`unzipdir'/alter_tie") match("*edgeList*") makedirs erase

***clean up the zip files 
local fls : dir "`sourcedir'" files "*.zip"
foreach f of local fls {
  2. erase "`sourcedir'/`f'"
}


**********************************************************************
**# 2  Clean Participant and Interviewer Data
**********************************************************************

*only run this if participants to be added are interviewed by more than one person
multimport delimited, dir("I:\SNACK Interviews\Netcanvas\interviewer") clear force
drop id _filename networkcanvasuuid
save "NC-part-interviewer.dta", replace

multimport delimited, dir("I:\SNACK Interviews\Netcanvas\ego") clear force import(stringcols(_all))

***check if variable names imported properly
rename v10 interviewername
rename v9 subname
rename v8 ccid
rename v7 sessionexported
rename v6 sessionfinish
rename v5 sessionstart
rename v4 networkcanvasprotocolname
rename v3 networkcanvassessionid
rename v2 networkcanvascaseid
rename v1 networkcanvasegouuid

***convert dates - should align with when they were uploaded to the OneDrive, not their actual participation dates
list ccid session* if missing(sessionfinish) 
replace sessionfinish=sessionexported if missing(sessioninish)
replace sessionfinish = substr(sessionfinish,1,10)
gen date_snack = date(sessionfinish,"YMD") // convert string to date 
format date_snack %dM_d,_CY //display in date 
list date_snack sessionfinish //double check

***check ccid
list ccid networkcanvascaseid if ccid!=networkcanvascaseid //0 case, otherwise correct in the excel

sort ccid date_snack 
bysort ccid: gen NC=_n
list ccid date_snack NC 
drop sessionstart sessionfinish sessionexported interviewwave alterid ego_variable _filename

save "NC-part-ego.dta", replace


**********************************************************************
**# 3  Read and Clean Alter-level Data
**********************************************************************

multimport delimited, dir("I:\SNACK Interviews\Netcanvas\alter") clear force import(stringcols(_all)) //import all variables as string
drop if missing(networkcanvasegouuid) //empty row with no networkcanvasegouuid
drop v57 v77 v78 _filename // drop unnessary variables

merge m:1 networkcanvasegouuid using "NC-part-ego.dta", nogen
rename (ccid name) (SUBID alter_name)
order SUBID alterid
sort SUBID alterid
destring SUBID alterid,replace

replace alter_name =strtrim(alter_name) //remove leading and trailing blanks
replace alter_name =subinstr(alter_name, ".", "",.) //remove .
replace alter_name =subinstr(alter_name, `"""' , "",.) //remove "
replace alter_name =strlower(alter_name) //change to lower case
replace alter_name =stritrim(alter_name) //consecutive blanks collapsed to one blank

preserve

***check alterid & alter_name within each wave

duplicates list SUBID alter_name date_snack //none should exist, otherwise fix.  
duplicates list SUBID alterid date_snack //none should exist, otherwise fix. 

***check alterid & alter_name across waves
duplicates drop SUBID alterid alter_name,force //drop alters in multiple waves
duplicates list SUBID alter_name //none should exist, otherwise fix 
rename alterid alterid_nc
save "NC-altername-match",replace

restore

foreach x of varlist prevalter broughtforward stilldiscuss alterim* alterhm* alteret* prevalterimcat* alterrel* {
        replace `x' = "1" if `x'== "true" | `x'== "TRUE"
        replace `x' = "0" if `x'== "false" | `x'== "FALSE"
        destring `x', replace
}
recode broughtforward stilldiscuss (. 2 =0) /// check if missing generators and stilldiscuss=1

list SUBID alter_name if name_gen==0 & stilldiscuss==1 //0 missing generators while stilldiscuss=1
list SUBID if name_gen>0 & stilldiscuss==0 & broughtforward==0

replace alterim1=1 if prevalterimcat_ima==1
replace alterim2=1 if prevalterimcat_imb==1
replace alterim3=1 if prevalterimcat_imc==1
replace alterhm1=1 if prevalterimcat_ihma==1
replace alterhm2=1 if prevalterimcat_ihmb==1
replace alterhm3=1 if prevalterimcat_ihmc==1
replace alteret3=1 if prevalterimcat_etc==1
replace alteret4=1 if prevalterimcat_etd==1
replace alteret5=1 if prevalterimcat_ete==1
replace alteret6=1 if prevalterimcat_etf==1
replace alteret7=1 if prevalterimcat_etg==1
drop prevalterimcat_*

fre prevalter 
drop if prevalter!=1 & name_gen==0
save "I:\SNACK Interviews\Netcanvas\NC-part-alter-LONG-prevalters.dta",replace


**mvpatterns if name_gen==0 //check those alters are not interviewed
drop if name_gen==0

destring SUBID altersex altercollege alterage alterrace,replace force
recode altercollege (-8=.) (1=1) (2=0)
recode altersex (-8=.) (2=1) (1=0),gen(tfem)
drop altersex
recode alterrace (3=4) (4=3) (5=4)
label define alterrace 1 "Asian" 2 "African American" 3 "White" 4 "Other"
label values alterrace alterrace
rename (tfem) (alterfem)
rename (alterrel_1-alterrel_23) (relpartner relparent relsibling relchild relgrandp relgrandc relauntunc relinlaw relothrel relcowork relneigh relfriend relboss relemploy relschool rellawyer reldoctor relothmed relmental relrelig relchurch relclub relleisure)
egen relmiss=rowtotal(rel*)

foreach x of varlist altercollege alterfem alterrace {
        bysort SUBID alterid: replace `x'=`x'[1] if missing(`x') & NC>1 //take T1 values if missing
}
foreach x of varlist rel* {
        bysort SUBID alterid: replace `x'=`x'[1] if relmiss==0 & NC>1 //take T1 values if relmiss=0
}


**********************************************************************
**# 4  Clean Alter-level Interpreters
**********************************************************************

bysort SUBID NC: egen netsize=count(name_gen)
lab var netsize "Total number of alters mentioned" 

destring altercloseego,replace
recode altercloseego (1=3) (2=2) (3=1)
label define altercloseego 1 "Not very close" 2 "Sort of close" 3 "Very close"
label values altercloseego altercloseego
recode altercloseego (1 2=0) (3=1),gen(tclose)
lab var tclose "Alter is very close"
bysort SUBID NC: egen pclose=mean(tclose)
lab var pclose "Proportion very close in network"
bysort SUBID NC: egen mclose=mean(altercloseego)
lab var mclose "Mean closeness in network, HI=MORE"

destring alterfreqcon,replace
recode alterfreqcon (1=3) (2=2) (3=1)
label define alterfreqcon 1 "Hardly ever" 2 "Occcasionally" 3 "Often"
label values alterfreqcon alterfreqcon
recode alterfreqcon (1 2=0) (3=1),gen(tfreq)
lab var tfreq "Alter sees or talks to ego often"
bysort SUBID NC: egen pfreq=mean(tfreq)
lab var pfreq "Proportion often in contact in network"
bysort SUBID NC: egen mfreq=mean(alterfreqcon)
lab var mfreq "Mean freq of contact in network, HI=MORE"
bysort SUBID NC: egen sdfreq=sd(alterfreqcon)
lab var sdfreq "Standard deviation of freq of contact in network"

foreach x of varlist altersupfunc_* {
        replace `x'="0" if `x'=="false" | `x'=="FALSE"
        replace `x'="1" if `x'=="true" | `x'=="TRUE"
        destring `x',replace
}
rename (altersupfunc_1-altersupfunc_5) (listen care advice chores loan)
egen numsup=rowtotal(listen-loan),mi
lab var numsup "Number of support functions"
bysort SUBID NC: egen msupport=mean(numsup)
lab var msupport "Mean number of support functions in network, HI=MORE"

egen numsup3=rowtotal(listen care advice),mi
bysort SUBID NC: egen msupport3=mean(numsup3)
lab var msupport3 "Mean number of support functions in network (listen, care, advice), HI=MORE"

foreach x of varlist listen-loan {
        bysort SUBID NC: egen p`x'=mean(`x') 
}
lab var plisten "Prop. listen to you when upset"
lab var pcare "Prop. tell you they care about what happens to you"
lab var padvice "Prop. give suggestions when you have a problem"
lab var pchores "Prop. help you with daily chores"
lab var ploan "Prop. loan money when you are short of money"

destring alterhassle,replace
revrs alterhassle, replace 
bysort SUBID NC: egen mhassles=mean(alterhassle)
lab var mhassles "Mean hassles in network, HI=MORE)"
recode alterhassle (1=0) (2/3=1),gen(thassles)
lab var thassles "Alter hassles, causes problems sometimes or a lot"
bysort SUBID NC: egen phassles=mean(thassles)
lab var phassles "Proportion that hassle, cause problems in network"

destring altercls110,replace
bysort SUBID NC: egen mstrength=mean(altercls110)
lab var mstrength "Mean tie strength in network, HI=MORE"
bysort SUBID NC: egen weakest=min(altercls110)
lab var weakest "Minimum tie strength score"
bysort SUBID NC: egen iqrstrength=iqr(altercls110)
lab var iqrstrength "Interquartile range of tie strength"
bysort SUBID NC: egen sdstrength=sd(altercls110)
lab var sdstrength "Standard deveiation of tie strength"

lab var alterfem "Alter is female"
bysort SUBID NC: egen pfem=mean(alterfem)
lab var pfem "Proportion female in network"

lab var alterage "Alter age"
bysort SUBID NC: egen mage=mean(alterage)
lab var mage "Mean alter age"
bysort SUBID NC: egen sdage=sd(alterage)
lab var sdage "Standard deveiation of alter age"

bysort SUBID NC: egen pcollege=mean(altercollege)
lab var pcollege "Proportion college in network"

destring alterprox,replace
label define alterprox 1 "<30 mins" 2 "30-60 mins" 3 "1-2 hour" 4 ">2 hour",replace
label values alterprox alterprox
bysort SUBID NC: egen mprox=mean(alterprox)
lab var mprox "Mean alter proximity"
recode alterprox (2/4=0),gen(prox30)
bysort SUBID NC: egen pprox=mean(prox30)
lab var pprox "Proportion <30 mins"

destring alterhknow,replace
recode alterhknow (1=3) (2=2) (3=1)
label define alterhknow 1 "Not very much" 2 "Some" 3 "A lot",replace
label values alterhknow alterhknow
bysort SUBID NC: egen mknow=mean(alterhknow)
lab var mknow "Mean knowledge of aging problems in network, HI=MORE"
recode alterhknow (1 2=0) (3=1),gen(tknow)
lab var tknow "Alter knows a lot about memory loss, confusion, or other similar problems that you might be experiencing as you age"
bysort SUBID NC: egen pknow=mean(tknow)
lab var pknow "Proportion knows a lot about aging"

destring alterdtr,replace
recode alterdtr (1=3) (2=2) (3=1) (-8=.)
label define alterdtr 1 "Not very much" 2 "Most of the time" 3 "A lot",replace
label values alterdtr alterdtr
bysort SUBID NC: egen mtrust=mean(alterdtr)
lab var mtrust "Mean trust in doctors in network, HI=MORE"
recode alterdtr (1 2 =0) (3=1),gen(ttrust)
lab var ttrust "Alter trusts doctors a lot"
bysort SUBID NC: egen ptrust=mean(ttrust)
lab var ptrust "Proportion who trust doctors in network"

destring alterquestion,replace
recode alterquestion (-8=.)
label define alterquestion 1 "Rarely" 2 "Sometimes" 3 "Often",replace
label values alterquestion alterquestion
bysort SUBID NC: egen mquestion=mean(alterquestion)
lab var mquestion "Mean questions doctors in network, HI=MORE"

recode alterrace (1 2 4=0) (3=1),gen(white)
bysort SUBID NC: egen pwhite=mean(white)
lab var pwhite "Proportion White in network"

gen tkin=relpartner+relparent+relsibling+relchild+relgrandp+relgrandc+relauntunc+relinlaw+relothrel
recode tkin (1/9=1)
replace tkin=. if relmiss==0
lab var tkin "Alter is family member"
bysort SUBID NC: egen pkin=mean(tkin)
lab var pkin "Proportion of network that is kin"

***network diversity measure (Cohen)
egen othfam=rowtotal(relsibling relgrandp relgrandc relauntunc relothrel),mi //group into other family
egen fri=rowtotal(relfriend relleisure),mi //group into friend
egen work=rowtotal(relemploy relboss relcowork),mi //group into workmate
egen church=rowtotal(relrelig relchurch),mi //group into religious group
egen prof=rowtotal(relmental relothmed reldoctor rellawyer),mi //group into  professional group

recode othfam fri work church prof (1/10=1)
foreach x of varlist relpartner relparent relinlaw relchild othfam relneigh fri work relschool church prof relclub {
egen u`x' = tag(SUBID NC `x') if `x'>0 & !missing(`x') // e.g., count multiple friends as 1 friend
}
recode urelpartner-urelclub (0=.) if relmiss==0 & netsize>0 //if a named alter is not specified for relation type then treat as missing
bysort SUBID NC: egen diverse=total(urelpartner+urelparent+urelinlaw+urelchild+uothfam+urelneigh+ufri+uwork+urelschool+uchurch+uprof+urelclub),mi //cohen's 12 categories(volunteer is not in this data thus leaving us 11 of 12 Cohen's categories, and I add a group call prof as a replacement)
drop relmiss urelpartner-urelclub othfam fri work church prof
lab var diverse "Network diversity"

drop tclose tfreq numsup numsup3 thassles prox30 tknow ttrust white tkin //drop alter level variables
save "NC-part-alter-clean.dta"


**********************************************************************
**# 5  Clean and Add Alter-Alter Data
**********************************************************************
multimport delimited, dir("I:\SNACK Interviews\Netcanvas\alter_tie") clear force import(stringcols(_all))

fre alteralterclose // alter do not know each other is not in the data
destring alteralterclose,replace

recode alteralterclose (1=3) (2=2) (3=1) 
label define alteralterclose 1 "Not very close" 2 "Sort of close" 3 "Very close"
label values alteralterclose alteralterclose
bysort networkcanvasegouuid: egen totval=total(alteralterclose),mi //for value density

recode alteralterclose (2/3=1) (1=0),gen(tievalue)
bysort networkcanvasegouuid: egen totnum=total(tievalue),mi //for Binary density

recode alteralterclose (1/3=1),gen(newtievalue)
bysort networkcanvasegouuid: egen totnum1=total(newtievalue),mi // for Density of networks know each other
drop _filename

keep networkcanvasegouuid totval totnum totnum1 
duplicates drop networkcanvasegouuid, force
save "NC-part-altertie-EGO.dta"

merge 1:m networkcanvasegouuid using "NC-part-alter-clean" 
fre SUBID if _merge==2 
drop _merge


***adjust for randomization 
destring random, replace
bysort SUBID NC: egen trandom=total(random),mi
bysort SUBID NC: gen npossties=trandom*(trandom-1)/2 
bysort SUBID NC: replace npossties=netsize*(netsize-1)/2 if missing(npossties) //early NC did not implement randomization

gen density=totval/npossties
lab var density "Valued density of networks from matrix"
gen bdensity=totnum/npossties
lab var bdensity "Binary density of networks from matrix"
gen b1density=totnum1/npossties
lab var b1density "Density of networks know each other"
recode b1density (1=0) (.=.) (else=1),gen(sole) 
lab var sole "Sole bridge status"

bysort SUBID NC: gen npossties_rd=trandom*(trandom-1)/2 
bysort SUBID NC: gen npossties_full=netsize*(netsize-1)/2
gen efctsize=netsize - 2*totnum1*(npossties_full/npossties_rd)/netsize //adjust totnum1 proportionaly to npossties_full/npossties_rd; trandom to netsize/trandom
replace efctsize=netsize-2*totnum1/netsize if missing(efctsize)
label var efctsize "Effective size"
drop npossties_rd npossties_full


***************************************************************
**#6 Save files 
***************************************************************

cd "I:\SNACK Interviews\cleaned"
replace SNACK_ID =strtrim(SNACK_ID) //// remove leading and trailing blanks from SNACK_ID
save "NC-LONG-clean-.dta", replace /// add date to confirm when cleaning occurred and avoid saving over previous files

duplicates drop SUBID NC, force
keep SUBID date_snack NC netsize-efctsize
save "NC-SHORT-clean-.dta", replace /// add date to confirm when cleaning occurred and avoid saving over previous files
