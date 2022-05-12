****Project: SNACK-SNAD
****Author:  Lucas Hamilton
****Date:    2022/04/26
****Version: 17
****Purpose: Generate ambivalent tie metrics for alter-level data


gen randomambi = Ambi_tie*random
bysort SUBID: egen num_randamb=sum(randomambi)
gen Have_ambi if number_ambi > 0 = 1
recode Have_ambi (.=0)
save "I:\random-ambi.dta", replace

duplicates drop SUBID, force
tab Have_ambi num_randamb
tab num_randamb Have_ambi

drop if random==0
rename nodeid from
save "I:\random only.dta"

multimport delimited, dir("I:\SNACK Interviews\Netcanvas\alter_tie") clear force import(stringcols(_all))

destring from alteralterclose, replace
recode alteralterclose (1=3) (2=2) (3=1) 
save "I:\alter-alter.dta"

use "I:\random only.dta"
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
ttest avgalteralterclose, by(Have_ambi)
ttest avgalteralterclose, by(Ambi_tie)

bysort SUBID from: egen central_3 = count(alteralter_3)
bysort SUBID from: egen central_2 = count(alteralter_2)
bysort SUBID from: egen central_1 = count(alteralter_1)

gen central_degree = central_3 + central_2 + central_1
gen central_hideg = central_3
gen central_lowdeg = central_degree - central_hideg

duplicates drop SUBID from, force
clonevar SNACK_ID = SUBID
encode SUBID, generate(SUBID_1)
drop SUBID
rename SUBID_1 SUBID
rename from nodeid
drop alterplacement_x alterplacement_y networkcanvascaseid networkcanvassessionid networkcanvasprotocolname sessionstart sessionfinish sessionexported subname interviewername 
drop alterim1 alterim2 alterim3 alterhm1 alterhm3 alterhm2 alteret3 alteret4 alteret5 alteret6 alteret7 relpartner relparent relsibling relchild relgrandp relgrandc relauntunc relinlaw relothrel relcowork relneigh relfriend relboss relemploy relschool rellawyer reldoctor relothmed relmental relrelig relchurch relclub relleisure altersex alterrace altercollege alterage altercloseego alterfreqcon alterprox alterhknow alterdtr alterquestion altersupfunc_1 altersupfunc_2 altersupfunc_3 altersupfunc_4 altersupfunc_5 alterhassle altercls110 alter_name prevalter broughtforward altermissing stilldiscuss prevalterimcat_ima prevalterimcat_imb prevalterimcat_imc prevalterimcat_ihma prevalterimcat_ihmb prevalterimcat_ihmc prevalterimcat_etc prevalterimcat_etd prevalterimcat_ete prevalterimcat_etf previnterpreter altermissingother random _filename Ambi_mult Ambi_tie randomambi num_randamb number_ambi Have_ambi edgeid to
save "I:\mergeback.dta"

use "I:\ambi.dta"
destring nodeid, replace
merge m:m SNACK_ID networkcanvasegouuid nodeid using "I:\mergeback.dta", gen(outcome)
list SNACK_ID nodeid if outcome==2
sort SNACK_ID nodeid outcome



gen Ambi_mult = altercloseego*alterhassle
gen Ambi_tie = cond(Ambi_mult > 4, 1, 0)
bysort SUBID wave: egen number_ambi=sum(Ambi_tie)
gen ambistrength if Ambi_tie == 1 = Ambi_tie*alterstrength

bysort SUBID wave: egen avgambistrength = mean(ambistrength)
bysort SUBID wave: gen p_ambi = number_ambi / netsize

gen relationship = 0
replace relationship = 1 if relpartner == 1
replace relationship = 2 if relparent == 1
replace relationship = 3 if relsibling == 1
replace relationship = 4 if relchild == 1
replace relationship = 5 if relgrandp == 1
replace relationship = 6 if relgrandc == 1
replace relationship = 7 if relauntunc == 1
replace relationship = 8 if relinlaw == 1
replace relationship = 9 if relothrel == 1
replace relationship = 10 if relcowork == 1
replace relationship = 11 if relneigh == 1
replace relationship = 12 if relfriend == 1
replace relationship = 13 if relboss == 1
replace relationship = 14 if relemploy == 1
replace relationship = 15 if relschool == 1
replace relationship = 16 if rellawyer == 1
replace relationship = 17 if reldoctor == 1
replace relationship = 18 if relothmed == 1
replace relationship = 19 if relmental == 1
replace relationship = 20 if relrelig == 1
replace relationship = 21 if relchurch == 1
replace relationship = 22 if relclub == 1
replace relationship = 23 if relleisure == 1
label define relationship_type 0 "missing" 1 "partner" 2 "parent" 3 "sibling" 4 "child" 5 "grandparent" 6 "grandchild" 7 "aunt-uncle" 8 "inlaw" 9 "other relative" 10 "coworker" 11 "neighbor" 12 "friend" 13 "boss" 14 "employ" 15 "school" 16 "lawyer" 17 "doctor" 18 "othermed" 19 "mentalhealth" 20 "religious leader" 21 "church" 22 "club" 23 "leisure"
label values relationship relationship_type

gen ambi_type if Ambi_tie == 1 = relationship
label values ambi_type relationship_type
recode ambi_type (1=1 "partner") (4=2 "child") (12=3 "friend") (2 3 5 6 7 8 9 = 4 "other relatives") (0 = 6 "missing") (10 11 13 14 15 16 17 18 19 20 21 22 23 = 5 "other non-relatives"), g(ambi_groupedtype)
label define relationship_group 6 "missing" 1 "partner" 2 "child" 3 "friend" 4 "other relatives" 5 "other non-relatives"
label values ambi_groupedtype relationship_group

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


drop date_red record_id redcap_event_name redcap_repeat_instrument redcap_repeat_instance rey date_avlt reycorrect reyconfabs reycorrect2 reyconfabs2 reycorrect3 reyconfabs3 reycorrect4 reyconfabs4 reycorrect5 reyconfabs5 reybcorrect reybconfabs reyintrusions reycorrecta reyconfabsa reyintrusionsa rey_avlt_complete date trails cube clock clock_numbers hands naming registration digits letter_a serial_7_s repetition fluency abstraction no_cue category multiple_cue date_orient month year day place city2 where_administered moca_complete rey_avlt_correct rey_avlt_confabs rey_avly_intrusions delayed_rey_avlt_complete trailerrors traillines trailerror trailline trails_complete mailing_packet_1 mastery1 mastery2 happiness anxiety1 anxiety2 anxiety3 anxiety4 life1 life2 life3 life4 life5 life6 life7 health energy spirits living_situation memory family marriage friends nofriends_feel self do_chores do_fun money whole marriage_other nofriends sleep stress1 stress2 stress3 stress4 stress5 stress6 stress7 stress8 stress9 stress10 doctor1 doctor2 doctor3 doctor4 doctor5 doctor6 doctor7 hearing hearing_drvisit hearing_activities vision vision_drvisit vision_activities stress_and_quality_o_v_2 mailing_packet rbooks_f rbooks_d rnews_f rnews_d cwpuzzles_f cwpuzzles_d cardgame_f cardgame_d puzzlegame_f puzzlegame_d write_f write_d museum_f museum_d memthink_f memthink_d sew_f sew_d tv_f tv_d radio_f radio_d computer_f computer_d musicinstr_f musicinstr_d famfriends_f famfriends_d visitors_f visitors_d family_help1 help_support1 friends_help1 go_wrong1 problems_family1 joys_sorrows1 make_decisions1 problems_friends1 lack_companionship1 left_out1 feel_isolated1 contacts_phone social_media1___1 social_media1___2 social_media1___3 social_media1___4 social_media1___5 social_media1___6 social_media1___7 social_media1___8 social_media1___9 social_media1___10 social_media1___11 social_media1___12 sm_twitter1 followers_twitter1 sm_instagram1 followers_instagram1 sm_pinterest1 followers_pinterest1 sm_facebook1 followers_facebook1 sm_linkedin1 followers_linkedin1 sm_snapchat1 followers_snapchat1 sm_whatsapp1 followers_whatsapp1 sm_reddit1 followers_reddit1 sm_tumblr1 followers_tumblr1 sm_skype1 followers_skype1 sm_other1 religious_group1 what_religion1 religion_other1 religious_attendance1 white1 black1 hispanic1 other1 group_housing1 living_sit1 share_housing1 meals_residents1 social_activities1 integration1 integration2 integration3 volunteer volunteer_help volunteer_act___coach volunteer_act___teach volunteer_act___mentor volunteer_act___usher volunteer_act___food volunteer_act___cloth volunteer_act___fund volunteer_act___med volunteer_act___office volunteer_act___manage volunteer_act___art volunteer_act___drive volunteer_act___other volunteer_other volunteer_often volunteer_hours volunteer_company volunteer_change1 volunteer_change2 volunteer_change3 social_activity_and__v_3 mailing_packet_2 vigor vigorhr vigormn vigortothr vigortotmn moderate modhr modmn modtothr modtotmn walk walkhr walkmn walktothr walktotmin sithr sitmn sitwedhr sitwedmn oliveoil leafy vegother berry redmeat fish chicken cheese butter beans grain sweets nuts fastfood alcoholdrinks physical_activity_an_v_4 assisting_adult patient patient_relation patient_relation_other patient_old require_care require_expanded primary_caregiver most_help day_week hours_per_day caregiving_hardship enough_money money_retirement taking_care demand_help self_time embarassed_behavior angry_around impact_relationships happen_future dependency_capabilities emotionally_difficult physically_difficult caregiving_complete facial_memory_task_s_v_5 scale_01_v2 scale_02_v2 scale_03_v2 scale_04_v2 scale_05_v2 scale_06_v2 scale_07_v2 scale_08_v2 scale_09_v2 scale_10_v2 scale_11_v2 scale_12_v2 scale_13_v2 scale_14_v2 scale_15_v2 scale_16_v2 scale_17_v2 scale_18_v2 scale_19_v2 scale_20_v2 scale_21_v2 scale_22_v2 scale_23_v2 scale_24_v2 theory_of_mind_complete the_office_task_754b_complete married living_own1 living_own2 living_number moved moved_time employment workhours buy_food skip_meals money_necessities annual_income annual_household ladder current_ses_and_demo_complete outside_recruit ccis01 ccis02 ccis03 ccis04 ccis05 ccis06 ccis07 ccis08 ccis09 ccis10 ccis11 ccis12 ccis13 ccis14 ccis15 ccis16 ccis17 ccis18 ccis19 ccis20 func_checks func_tax func_shopping func_hobby func_coffee func_meal func_events func_tv func_appts func_travel cci_and_faq_complete home obs_home1 obs_home2 obs_home3 obs_home4 obs_home5 obs_home6 obs_home7 obs_home7a obs_home8 obs_home9 obs_home10 obs_home11 obs_home12 obs_home13 obs_home14 obs_home15 obs_home15a obs_home16 obs_home17 obs_home18 obs_home19 neighborhood_observa_v_6 date_iadc address city state zip_code _stress_and_qu_complete _social_activi_complete _physical_acti_complete _caregiving_complete the_office_task_complete _ses_occupatio_complete activities_hear activities_vision followers_twitter followers_instagram followers_pinterest followers_facebook followers_linkedin followers_snapchat followers_whatsapp followers_reddit followers_tumblr followers_skype sm_other religion_other belong_community1 close_community1 comfort_community1 dontvigphy dontvigor dontknowtime dontmod moddont dontmodtot dontkmod dontwalk donttotwalk dontsitting dontsittingwed patient_name volunteering volunteer_amount volunteer_why other_specify living_own other_living date_rey rtester_initials wave_1_rey_complete moca date_moca tester_initials administered delay_recog2 wave_3_informant_moc_v_9 wave_1_delayed_rey_a_v_10 trail date_trails ttester_initials wave_1_trails_complete my_first_instrument_complete _facial_memory_complete _theory_of_mind_complete tot_wave matchred diffred1 diffred2 diffred3 diffred4 diffred5 diffred6 diffred7 minval match ageiadc diag primarysubtype contributel normcondl syndrome udsversion mmse digif digib animals veg trail_a_time RawTrailA trail_b_time RawTrailB waisdsymbol gds15 gds30 tapdh tapnd seq1sumcalc seq2sumcalc seqsumcalc sdssumcalc rey_sum delayed_rey_sum FSIQ moca_raw MOCATRAI MOCACUBE MOCACLOC MOCACLON MOCACLOH MOCANAMI MOCAREGI MOCADIGI MOCALETT MOCASER7 MOCAREPE MOCAFLUE MOCAABST MOCARECN MOCARECC MOCARECR MOCAORDT MOCAORMO MOCAORYR MOCAORDY MOCAORPL MOCAORCT CRAFTVRS CRAFTURS UDSBENTC CRAFTDVR CRAFTDRE CRAFTDTI UDSBENTD MINTTOTS UDSVERFC UDSVERLC cdrmem cdrorient cdrjudge cdrcomm cdrhome cdrpers cdrglobal progression improve memwors CCI_12 CCI_TOT memory_inf CCI_INF12 CCI_INFTOT memoryinf MEMMO MEMONSET LANG LANGMO LANGONSET JUDGE JUDGEMO JUDGEONSET VISSPAT VISSPATMO VISSPATONSET ATT ATTMO ATTONSET list_i recent_i convo_i objects_i repeat_i dates_i told_i appts_i objnames_i instruct_i words_i thoughts_i story_i point_i meanings_i tvprog_i spoken_i mapfollow_i mapread_i car_i meet_i neighborhood_i store_i house_i shop_i weather_i sched_i thinkthrough_i thinkahead_i organize_i checkbook_i finance_i priority_i mail_i meds_i multtask_i interrupt_i distract_i cook_i relation relationOther oftensee hours years gender age_i live sleeprs actout actyrs actmo injured injuredoth dreams moves legs legfeel walks worst sleepwalk choke breathe treat cramps alertness thinfdt concern list recent convo objects storyrepeat datesweek told appts objnames instruct words thoughts story point meanings tvprog spoken mapfollow mapread car meet neighborhood store house shop weather sched conversate act organize checkbook finance priority mail strategy multtask interrupt distract cook walktotmn psq1 psq2 psq3 psq4 psq5a psq5b psq5c psq5d psq5e psq5f psq5g psq5h psq5i psq5j1 psq5j2 psq5j3 psq5j1txt psq5j2txt psq5j3txt thselfdt NPIQINF NPIQINFX DEL DELSEV HALL HALLSEV AGIT AGITSEV DEPD DEPDSEV ANX ANXSEV ELAT ELATSEV APA APASEV DISN DISNSEV IRR IRRSEV MOT MOTSEV NITE NITESEV APP APPSEV BILLS TAXES SHOPPING GAMES STOVE MEALPREP EVENTS PAYATTN REMDATES TRAVEL onmeds medlist ALCOCCAS ALCFREQ TBI TOBAC30 TOBAC100 SMOKYRS PACKSPER ALCOHOL ABUSOTHR DEP2YRS DEPOTHR PSYCDIS BPSYS BPDIAS HRATE VISWCORR HEARWAID bmi OCCUPATION informantstreet informantcity informantzip informantphone RELSEX RELDOB RELSUBJ RELRESID OFTSEE LONGKNOW RELGRADE RELOCCA RELHLTH informantstate ad adtype diagnosis_iadc diff7 diagnosis_moca scanage scanner date_mri mprage flair flair_type hrh dti hydi fmri_2bk fmri_scene fmri_rs perfusion perfusion_type swi lga_lesionvolume lga_lesionnumber icv leftlateralventricle leftinflatvent leftcerebellumwhitematter leftcerebellumcortex leftthalamusproper leftcaudate leftputamen leftpallidum rdventricle thventricle brainstem lefthippocampus leftamygdala csf leftaccumbensarea leftventraldc leftvessel leftchoroidplexus rightlateralventricle rightinflatvent rightcerebellumwhitematter rightcerebellumcortex rightthalamusproper rightcaudate rightputamen rightpallidum righthippocampus rightamygdala rightaccumbensarea rightventraldc rightvessel rightchoroidplexus bm wmhypointensities leftwmhypointensities rightwmhypointensities nonwmhypointensities leftnonwmhypointensities rightnonwmhypointensities opticchiasm cc_posterior cc_mid_posterior cc_central cc_mid_anterior cc_anterior brainsegvol brainsegvolnotvent brainsegvolnotventsurf lhcortexvol rhcortexvol cortexvol lhcerebralwhitemattervol rhcerebralwhitemattervol cerebralwhitemattervol subcortgrayvol totalgrayvol supratentorialvol supratentorialvolnotvent supratentorialvolnotventvox maskvol brainsegvoltoetiv maskvoltoetiv lhsurfaceholes rhsurfaceholes surfaceholes lh_bankssts_volume lh_caudalanteriorcingulate_volum lh_caudalmiddlefrontal_volume lh_cuneus_volume lh_entorhinal_volume lh_fusiform_volume lh_inferiorparietal_volume lh_inferiortemporal_volume lh_isthmuscingulate_volume lh_lateraloccipital_volume lh_lateralorbitofrontal_volume lh_lingual_volume lh_medialorbitofrontal_volume lh_middletemporal_volume lh_parahippocampal_volume lh_paracentral_volume lh_parsopercularis_volume lh_parsorbitalis_volume lh_parstriangularis_volume lh_pericalcarine_volume lh_postcentral_volume lh_posteriorcingulate_volume lh_precentral_volume lh_precuneus_volume lh_rostralanteriorcingulate_volu lh_rostralmiddlefrontal_volume lh_superiorfrontal_volume lh_superiorparietal_volume lh_superiortemporal_volume lh_supramarginal_volume lh_frontalpole_volume lh_temporalpole_volume lh_transversetemporal_volume lh_insula_volume rh_bankssts_volume rh_caudalanteriorcingulate_volum rh_caudalmiddlefrontal_volume rh_cuneus_volume rh_entorhinal_volume rh_fusiform_volume rh_inferiorparietal_volume rh_inferiortemporal_volume rh_isthmuscingulate_volume rh_lateraloccipital_volume rh_lateralorbitofrontal_volume rh_lingual_volume rh_medialorbitofrontal_volume rh_middletemporal_volume rh_parahippocampal_volume rh_paracentral_volume rh_parsopercularis_volume rh_parsorbitalis_volume rh_parstriangularis_volume rh_pericalcarine_volume rh_postcentral_volume rh_posteriorcingulate_volume rh_precentral_volume rh_precuneus_volume rh_rostralanteriorcingulate_volu rh_rostralmiddlefrontal_volume rh_superiorfrontal_volume rh_superiorparietal_volume rh_superiortemporal_volume rh_supramarginal_volume rh_frontalpole_volume rh_temporalpole_volume rh_transversetemporal_volume rh_insula_volume lh_bankssts_thickness lh_caudalanteriorcingulate_thick lh_caudalmiddlefrontal_thickness lh_cuneus_thickness lh_entorhinal_thickness lh_fusiform_thickness lh_inferiorparietal_thickness lh_inferiortemporal_thickness lh_isthmuscingulate_thickness lh_lateraloccipital_thickness lh_lateralorbitofrontal_thicknes lh_lingual_thickness lh_medialorbitofrontal_thickness lh_middletemporal_thickness lh_parahippocampal_thickness lh_paracentral_thickness lh_parsopercularis_thickness lh_parsorbitalis_thickness lh_parstriangularis_thickness lh_pericalcarine_thickness lh_postcentral_thickness lh_posteriorcingulate_thickness lh_precentral_thickness lh_precuneus_thickness lh_rostralanteriorcingulate_thic lh_rostralmiddlefrontal_thicknes lh_superiorfrontal_thickness lh_superiorparietal_thickness lh_superiortemporal_thickness lh_supramarginal_thickness lh_frontalpole_thickness lh_temporalpole_thickness lh_transversetemporal_thickness lh_insula_thickness lh_meanthickness_thickness rh_bankssts_thickness rh_caudalanteriorcingulate_thick rh_caudalmiddlefrontal_thickness rh_cuneus_thickness rh_entorhinal_thickness rh_fusiform_thickness rh_inferiorparietal_thickness rh_inferiortemporal_thickness rh_isthmuscingulate_thickness rh_lateraloccipital_thickness rh_lateralorbitofrontal_thicknes rh_lingual_thickness rh_medialorbitofrontal_thickness rh_middletemporal_thickness rh_parahippocampal_thickness rh_paracentral_thickness rh_parsopercularis_thickness rh_parsorbitalis_thickness rh_parstriangularis_thickness rh_pericalcarine_thickness rh_postcentral_thickness rh_posteriorcingulate_thickness rh_precentral_thickness rh_precuneus_thickness rh_rostralanteriorcingulate_thic rh_rostralmiddlefrontal_thicknes rh_superiorfrontal_thickness rh_superiorparietal_thickness rh_superiortemporal_thickness rh_supramarginal_thickness rh_frontalpole_thickness rh_temporalpole_thickness rh_transversetemporal_thickness rh_insula_thickness rh_meanthickness_thickness totallatventvol totalinflatventvol totalcerebellwmvol totalcerebellctxvol totalthalvol totalcaudvol totalputamvol totalpallvol totalhippvol totalamygvol totalaccumvol totalventdcvol totalvesselvol totalchorplexvol totalccvol meanlatventvol meaninflatventvol meanhippvol meanamygvol bankssts_volume caudalanteriorcingulate_volume caudalmiddlefrontal_volume cuneus_volume entorhinal_volume fusiform_volume inferiorparietal_volume inferiortemporal_volume isthmuscingulate_volume lateraloccipital_volume lateralorbitofrontal_volume lingual_volume medialorbitofrontal_volume middletemporal_volume parahippocampal_volume paracentral_volume parsopercularis_volume parsorbitalis_volume parstriangularis_volume pericalcarine_volume postcentral_volume posteriorcingulate_volume precentral_volume precuneus_volume rostralanteriorcingulate_volume rostralmiddlefrontal_volume superiorfrontal_volume superiorparietal_volume superiortemporal_volume supramarginal_volume frontalpole_volume temporalpole_volume transversetemporal_volume insula_volume lfrontalvol rfrontalvol frontalvol lcingulatevol rcingulatevol cingulatevol lparietalvol rparietalvol parietalvol ltemporalvol rtemporalvol temporalvol lmtlvol rmtlvol mtlvol lmtl2vol rmtl2vol mtl2vol lltlvol rltlvol ltlvol lsmcvol rsmcvol smcvol loccipitalvol roccipitalvol occipitalvol lglobalvol rglobalvol globalvol bankssts_thick caudantcing_thick caudmidfrontal_thick cuneus_thick entctx_thick fusiform_thick infparietal_thick inftemporal_thick isthmcing_thick latoccipital_thick latorbfrontal_thick lingual_thick medorbfrontal_thick midtemporal_thick parahippocampal_thick paracentral_thick parsoper_thick parsorb_thick parstriang_thick pericalcarine_thick postcentral_thick postcing_thick precentral_thick precuneus_thick rostantcing_thick rostmidfrontal_thick supfrontal_thick supparietal_thick suptemporal_thick supramarginal_thick frontalpole_thick temporalpole_thick transvtemppole_thick insula_thick lfrontal_thick rfrontal_thick frontal_thick lcingulate_thick rcingulate_thick cingulate_thick lparietal_thick rparietal_thick parietal_thick ltemporal_thick rtemporal_thick temporal_thick lmtl_thick rmtl_thick mtl_thick lmtl2_thick rmtl2_thick mtl2_thick lltl_thick rltl_thick ltl_thick lsmc_thick rsmc_thick smc_thick loccipital_thick roccipital_thick occipital_thick lglobalctx_thick rglobalctx_thick globalctx_thick matchmri tau date_tau av1451_crus_entctx av1451_crus_fusiform av1451_crus_infparietal av1451_crus_inftemporal av1451_crus_midtemporal av1451_crus_parahippocampal av1451_crus_postcing av1451_crus_precuneus av1451_crus_suptemporal av1451_crus_frontal av1451_crus_cingulate av1451_crus_parietal av1451_crus_temporal av1451_crus_mtl av1451_crus_mtl2 av1451_crus_ltl av1451_crus_smc av1451_crus_occipital av1451_crus_globalctx matchtau amyloid amytracer date_amy abpos glctx_cent_cl matchamy 
drop source 
drop longest_job1_red job_activity1_red kind_business1_red other_describe1_red year_start1_red year_end1_red longest_job2_red job_activity2_red kind_business2_red other_describe2_red year_start2_red year_end2_red different_jobs_red neighborhood1_red long_live1_red neighborhood2_red long_live2_red neighborhood3_red long_live3_red neighborhood4_red long_live4_red neighborhood5_red long_live5_red neighborhood6_red long_live6_red neighborhood7_red long_live7_red neighborhood8_red long_live8_red neighborhood9_red long_live9_red neighborhood10_red long_live10_red family_finances_red education_mother1_red education_mother2_red education_father1_red education_father2_red neighborhood11_red neighborhood12_red neighborhood13_red neighborhood14_red neighborhood15_red long_live11_red long_live12_red long_live13_red long_live14_red long_live15_red work_red work_outside_red neighbor_white_red neighbor_black_red neighbor_hispanic_red neighbor_asian_red 
drop alter_name survey_id survey_version interview_id respondent_id respondent_name TIEID created_on modified_on finalnet5fp inputfromfpt4 stillmem5 forgotboiler5 notnamed5_other nihispnc5 newmem5 notnamed5 selectexc5 
drop fpt5networkall fpt5networkallsuggestexc fpt4t5all fpt5excluded fpt5networkallcare fpt5oldt4members fpt5networkfinal fpt5networkallmoneyexcluded fpt5networknewnocollege fpt5networkallsuggest fpt5networknewcollege fpt5networkallchoresexc fpt5networkalllisten fpt5networkallnotlisten none5 fpt5networknewmales fpt5networkallmoney fpt5networknewnothispanic fpt5networkold fpt5networknew fpt5networkallcareexcluded fpt5networkallchores fpt5networknewfemales nonefinal5 fpt5networknewhispanic _filename nihispnc4 inputfromfpt3 notnamed4 notnamed4_other finalnet4fp selectexc4 stillmem4 newmem4 fpt4networkallsuggestexc fpt4networkall fpt4networkallchores fpt4networkallsuggest fpt4networknewmales fpt4networkallmoneyexcluded nonefinal4 fpt4oldt3members fpt4networkallcareexcluded fpt4networknewhispanic fpt4networkalllisten fpt4networkallnotlisten fpt4networknewnothispanic fpt4networkallcare fpt3t4all fpt4excluded fpt4networknew fpt4networknewfemales fpt4networkold none4 fpt4networkallchoresexc fpt4networkfinal fpt4networkallmoney _other_response forgotboiler3 notnamed3_other nihispnc3 stillmem3 selectexc3 _other_option_checked notnamed3 finalnet3fp inputfromfpt2 newmem3 fpt3networkallmoneyexcluded fpt3networkallsuggest fpt3networkallchores fpt3networknewhispanic fpt3networknew fpt3networkallmoney fpt3networknewmales fpt3networkalllisten all fpt3networkallcare fpt3networkall fpt3networkallnotlisten nonefinal3 fpt3networkallcareexcluded fpt3excluded fpt3networkold fpt2t3all fpt3networknewfemales fpt3networkfinal fpt3oldt2members fpt3networkallchoresexc none3 fpt3networkallsuggestexc finalnet2fp notnamed2 selectexc2 forgotboiler2 stillmem2 newmem2 nihispnc2 notnamed2_other inputfromfpbl fpt2networkallmoneyexcluded fpt2networkall fpt1t2all fpt2networknewhispanic fpt2networkallcareexcluded fpt2networknewmales fpt2networknew fpt2networkold nonefinal fpt2networkallchoresexc fpt2networkallnotlisten none2 fpt2networkallsuggestexc fpt2networkallsuggest fpt2oldt1members fpt2excluded fpt2networkallcare fpt2networkalllisten fpt2networkfinal fpt2networkallchores fpt2networknewnothispanic fpt2networknewfemales fpt2networkallmoney nihispnc blanyoneelseexc blnetworkfpcare blnetworkfpsuggestexc blhealthcountexc blnetworkfpsuggest blnetworkfphispanic blnetworkfpnotstudypartner blimpmattersburdenexc blnetworkfpcareexcluded blnetworkfpmoneyexcluded blnetworkfplisten blneighborsexc blhealthdiscussencourageexc blcoworkersexc blnetworkfpnotlisten blimpmattersforcetalkexc blimpmattersdiscussexc blnetworkfpmales blnetworkfpmoney blnetworkfp blelastictieswkndexc blnetworknothispanic blelastictieswkdyexc blfamilyexc blhealthdiscussburdenexc blnetworkfpchores blnetworkfpfemales blnetworkfpchoresexc exinput exinput_missing hlthburdn hlthcount hlthencrg impburdn impforce impmat et_wkndties et_wkdyties et_family et_cowrkrs et_neighbrs et_anyelse et_partner name_gen 

drop tkin

gen tkin=relpartner+relparent+relsibling+relchild+relgrandp+relgrandc+relauntunc+relinlaw+relothrel

bysort source_study: tabulate alterhassle alterclose
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



fre ambi_groupedtype
drop if ambi_groupedtype == 6
tabulate ambi_groupedtype source_study, chi2
tabulate Ambi_tie source_study
egen generator_count = rowtotal(hlthburdn-et_anyelse)
gen generator = .
replace generator = 0 if generator_count > 1
replace generator = 1 if impmat == 1 & generator_count ==1
replace generator = 2 if impforce == 1 & generator_count ==1
replace generator = 3 if impburdn == 1 & generator_count ==1
replace generator = 4 if hlthencrg == 1 & generator_count ==1
replace generator = 5 if hlthcount == 1 & generator_count ==1
replace generator = 6 if hlthburdn == 1 & generator_count ==1
replace generator = 7 if et_family == 1 & generator_count ==1
replace generator = 8 if et_cowrkrs == 1 & generator_count ==1
replace generator = 9 if et_neighbrs == 1 & generator_count ==1
replace generator = 10 if et_anyelse == 1 & generator_count ==1
label define generator 1 "IM - Support" 2 "IM - Forced" 3 "IM - Burden" 4 "HM - Encourage" 5 "HM - Support" 6 "HM - Burden" 7 "ET Family" 8 "ET Coworkers" 9 "ET Neighbors" 10 "ET Other" 
label values generator generator

fre generator
tab Ambi_tie generator
fre  hlthburdn hlthcount hlthencrg impburdn impforce impmat et_wkndties et_wkdyties et_family et_cowrkrs et_neighbrs et_anyelse if generator ==0 & Ambi_tie ==1

gen discuss = .
gen regulators = .
gen burdens = .
replace discuss = 1 if impmat==1 | hlthcount==1
replace regulators = 1 if impforce==1 | hlthencrg==1
replace burdens = 1 if impburdn==1 | hlthburdn==1
recode discuss (.=0)
recode regulators (.=0)
recode burdens (.=0)
fre discuss regulators burdens


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



\\\\\\\


drop date_snad netsize pcollege mage sdage pwhite mprox pprox mknow pknow mtrust ptrust mquestion pclose mclose pfreq mfreq sdfreq msupport msupport3 pcare ploan pchores plisten padvice mhassles phassles mstrength weakest iqrstrength sdstrength pfem relmiss diverse pkin ENSO density bdensity totnum1 b1density sole efctsize NC trandom npossties female hispanic status grade zipcode famstud hascaregiver enrolldate deceased_iadc deathmnth deathyr PRESTAT PRIMLANG LIVSITUA INDEPEND RESIDENC sibs kids lastvisit APOEGenotype street white married_iadc_demo apoerisk apoe empstat_other_enso first_name_red last_name_red dobdate address_red city_red state_red zip_code_red deceased_red orec_red cfnid_red orecid_red race veteran edu agesnad alterid alterprox alterquestion altertrust alterhknow prox30 numsup numsup3 networkcanvasegouuid totval totnum id nodeid networkcanvasuuid relpartner relparent relsibling relchild relgrandp relgrandc relauntunc relinlaw relothrel relcowork relneigh relfriend relboss relemploy relschool rellawyer reldoctor relothmed relmental relrelig relchurch relclub relleisure alterrace altercollege alterage altercloseego alterfreqcon listen care advice chores loan alterhassle altercls110 prevalter broughtforward altermissing stilldiscuss altermissingother random previnterpreter alterplacement_x alterplacement_y networkcanvascaseid networkcanvassessionid networkcanvasprotocolname subname interviewername alterfem alterdtr alter_name_nc tkin

drop Ambi_mult Ambi_tie ambistrength relationship ambi_type ambi_groupedtype ambi_partnerraw ambi_childraw ambi_friendraw ambi_otherrelativesraw ambi_nonrelateotherraw ambi_typemissing  ambi_part_str ambi_child_str ambi_friend_str ambi_otherrelate_str ambi_nonrelateother_str ambi_missing_str  ambi_part_frq ambi_child_frq ambi_friend_frq ambi_otherrelate_frq ambi_nonrelateother_frq ambi_missing_frq v_hassle ambi_vhassle v_ambi

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
