# This code is for 2020 analysis of NSDUH data 
# The data can be found at: https://www.datafiles.samhsa.gov/dataset/national-survey-drug-use-and-health-2020-nsduh-2020-ds0001

NSDUH_data <- load("file path")

#install required packages
install.packages("data.table")
install.packages("survey")
install.packages("dplyr")

# Load required packages 
library(data.table)
require(survey)  
require(dplyr) 

# by default, R will crash if a primary sampling unit (psu) has a single observation
# set R to produce conservative standard errors instead of crashing
options(survey.lonely.psu = "adjust")

# create a character vector that will be used to limit the file to only the variables needed

 KeepVars_2020 <- c(
    "QUESTID2",
    "ANALWTQ1Q4_C", # 2020 standard analysis weight
    "VESTRQ1Q4_C",  # 2020 variance estimation stratum variable
    "VEREP" ,       # Primary sampling units
    "IRHERRC",      # Heroin recency - imputation revised
    "IRPNRNMREC",   # Pain reliever misuse recency - imputation revised #formerly IRANLRC
    ####
    "HERFMFPB",     # USING HEROIN CAUSE PRBS W/FAM/FRNDS PST 12 MOS
    "HERFMCTD",     # CONTD TO USE HEROIN DESPITE PRBS W/FAM/FRNDS
    "HERPDANG",     # USING HEROIN & DO DANGEROUS ACTIVS PST 12 MOS
    "HERSERPB",     # HEROIN CAUSE SER PRB AT HOM/WRK/SCH PST 12 MOS
    "HERWDSMT",     # HAD 3+ HEROIN WDRAW SYM SAME TIME PST 12 MOS
    "HERLSACT",     # LESS ACTIVITIES B/C OF HEROIN USE PAST 12 MOS
    "HEREMCTD",     # CONTD TO USE HEROIN DESPITE EMOT PRBS
    "HERPHCTD",     # CONTD TO USE HEROIN DESPITE PHYS PRBS
    "HERCUTEV",     # ABLE TO CUT/STOP USNG HEROIN EVRY TIME PST 12 MOS
    "HERLSEFX",     # USING SME AMT HEROIN HAD LESS EFFECT PST 12 MOS
    "HERNDMOR",     # NEEDED MORE HEROIN TO GET SME EFFECT PST 12 MOS
    "HERKPLMT",     # ABLE TO KEEP LIMT OR USE MORE HEROIN PST 12 MOS
    "HERLOTTM",     # SPENT MON/MORE GETTING/USING HEROIN PST 12 MOS
    "HERGTOVR",     # MONTH+ SPENT GETTING OVR HEROIN EFFECTS PST 12 MO
    "SDHEURGEED",   # strong urge to use heroin in past 12 months - added in 2020
    ####
    "PNRLFMFPB",    # USING PN RLVR CAUSE PRBS W/FAM/FRNDS PST 12 MOS
    "PNRLFMCTD",    # CONTD TO USE PN RLVR DESPITE PRBS W/FAM/FRNDS
    "PNRLPDANG",    # USING PN RLVR & DO DANGEROUS ACTIVS PST 12 MOS
    "PNRLSERPB",    # PN RLVR CAUSE SER PRB AT HOM/WRK/SCH PST 12 MOS
    "PNRLWDSMT",    # HAD 3+ PN RLVR WDRAW SYM SAME TIME PST 12 MOS
    "PNRLLSACT",    # LESS ACTIVITIES B/C OF PN RLVR USE PAST 12 MOS
    "PNRLEMCTD",    # CONTD TO USE PN RLVR DESPITE EMOT PRBS
    "PNRLPHCTD",    # CONTD TO USE PN RLVR DESPITE PHYS PRBS
    "PNRLCUTEV",    # ABLE TO CUT/STOP USNG PN RLVR EVRY TIME PST 12 MO
    "PNRLLSEFX",    # USING SME AMT PN RLVR HAD LESS EFFECT PST 12 MOS
    "PNRLNDMOR",    # NEEDED MORE PN RLVR TO GET SME EFFECT PST 12 MOS
    "PNRLKPLMT",    # ABLE TO KEEP LIMT/USE MORE PN RLVR PST 12 MOS
    "PNRLLOTTM",    # SPENT MON/MORE GETTNG/USNG PN RLVR PST 12 MOS
    "PNRLGTOVR",    # MON+ SPNT GETTING OVER PN RLVR EFFECTS PST 12 MOS
    "SDPRURGEED",   # strong urge to use pain relievers in past 12 months - added in 2020
    ####
    "HERYFU"       # YEAR OF FIRST HEROIN USE - RECODE
  )
 
# R is case-sensitive, change lower-case names to upper-case
names(NSDUH_2020) <- toupper(names(NSDUH_2020)) 
# Using only the variables we need out of this larger file
  NSDUH_subset <- NSDUH_2020 %>% 
    select(KeepVars_2020)
  
  # to free up RAM, remove the full r data frame
  rm()
  
  # garbage collection: clear up RAM
  gc()
  
# heroin criteria 
  NSDUH_subset <- NSDUH_subset %>% 
    mutate(family = case_when(
      (HERFMFPB == 1 & HERFMCTD == 1)  ~ 1,
      TRUE  ~ 0),
      danger = case_when(
        HERPDANG == 1  ~ 1,
        TRUE  ~ 0),
      seriousprob = case_when(
        HERSERPB == 1  ~ 1,
        TRUE  ~ 0),
      withdrawal = case_when(
        HERWDSMT == 1  ~ 1,
        TRUE  ~ 0),
      activities =  case_when(
        HERLSACT == 1  ~ 1,
        TRUE  ~ 0),
      emotional = case_when(
        (HEREMCTD == 1 | HERPHCTD == 1)  ~ 1,
        TRUE  ~ 0),
      cutdown = case_when(
        HERCUTEV == 2  ~ 1,
        TRUE  ~ 0),
      tolerance =  case_when(
        (HERLSEFX == 1 | HERNDMOR == 1)  ~ 1,
        TRUE  ~ 0),
      time = case_when(
        (HERLOTTM == 1 | HERGTOVR == 1)  ~ 1,
        TRUE  ~ 0),
      limit = case_when(
        HERKPLMT == 2  ~ 1,
        TRUE  ~ 0),
      craving = case_when(
        SDHEURGEED == 1 ~ 1,
        TRUE ~ 0),
      udcount = family + danger + seriousprob + withdrawal + cutdown + activities + emotional + tolerance + time + limit + craving,
      hud = ifelse(udcount > 1, 1, 0)
    )
  
#Rx opioids
  NSDUH_subset <- NSDUH_subset %>% 
    mutate(familyrx = case_when(
      (PNRLFMFPB == 1 & PNRLFMCTD == 1)  ~ 1,
      TRUE  ~ 0),
      dangerrx = case_when(
        PNRLPDANG == 1  ~ 1,
        TRUE  ~ 0),
      seriousprobrx = case_when(
        PNRLSERPB == 1  ~ 1,
        TRUE  ~ 0),
      withdrawalrx = case_when(
        PNRLWDSMT == 1  ~ 1,
        TRUE  ~ 0),
      activitiesrx =  case_when(
        PNRLLSACT == 1  ~ 1,
        TRUE  ~ 0),
      emotionalrx = case_when(
        (PNRLEMCTD == 1 | PNRLPHCTD == 1)  ~ 1,
        TRUE  ~ 0),
      cutdownrx = case_when(
        PNRLCUTEV == 2  ~ 1,
        TRUE  ~ 0),
      tolerancerx =  case_when(
        (PNRLLSEFX == 1 | PNRLNDMOR == 1)  ~ 1,
        TRUE  ~ 0),
      timerx = case_when(
        (PNRLLOTTM == 1 | PNRLGTOVR == 1)  ~ 1,
        TRUE  ~ 0),
      limitrx = case_when(
        PNRLKPLMT == 2  ~ 1,
        TRUE  ~ 0),
      cravingrx = case_when(
        SDPRURGEED == 1 ~ 1,
        TRUE ~ 0),
      oudcount = familyrx + dangerrx + seriousprobrx + withdrawalrx  + activitiesrx + emotionalrx + cutdownrx + tolerancerx + timerx + limitrx + cravingrx,
      oud = ifelse(oudcount > 1, 1, 0),
      pyher = ifelse((IRHERRC == 1  | IRHERRC == 2),1,0),
      pyanl = ifelse((IRPNRNMREC == 1 | IRPNRNMREC == 2),1,0)
    )
  
  #XXXXXXXX
  NSDUH_subset <- NSDUH_subset %>% 
    mutate(stock = case_when(
      hud == 1 ~ "HUD NSDUH",
      (oud == 1 & hud == 0 & pyher == 1) ~ "Rx OUD + PY H", 
      (oud == 1 & hud == 0 & pyher == 0) ~ "Rx OUD no PY H",
      (oud == 0 & hud == 0 & pyher == 1) ~ "Nondisordered heroin use", 
      (oud == 0 & hud == 0 & pyher == 0 & pyanl == 1) ~ "RxMisuse",
      (oud == 0 & hud == 0 & pyher == 0 & pyanl == 0) ~ "Nonuser",
      TRUE ~ "ERROR")
    )
  
  NSDUH_subset <- NSDUH_subset %>% 
    mutate(fractionhud = case_when(
      hud == 1 & oud == 0 & pyanl == 1 ~ "HUD + Rx",
      hud == 1 & oud == 1 ~ "HUD + Rx",
      hud == 1 & oud == 0 & pyanl == 0 ~ "HUD no Rx",
      hud == 0 ~ "No HUD",
      TRUE ~ "ERROR"),
      fractionndhu = case_when(
        hud == 0 & oud == 0 & pyanl == 1 & pyher == 1 ~ "NDHU + Rx",
        hud == 0 & oud == 0 & pyanl == 0 & pyher == 1 ~ "NDHU",
        TRUE ~ "ERROR"),
    )
  
  
  #################################################
  # survey design for taylor-series linearization #
  #################################################
  
  # create a survey design object (y) with NSDUH design information
  
  y <- 
    svydesign( 
      id = ~VEREP , 
      strata = ~VESTRQ1Q4_C , #2020
      data = NSDUH_subset ,
      weights = ~ANALWTQ1Q4_C , #2020
      nest = TRUE 
    )
  
  
  #####################
  # analysis examples #
  #####################
  
  # add a new variable 'one' that simply has the number 1 for each record #
  # and can be used to calculate unweighted and weighted population sizes #
  
  y <-
    update( 
      one = 1 ,
      y
    )
  # unweighted counts #
  # (sample size column) #
  
  unwt_tot <- unwtd.count( ~one , y )							# total valid cases
  HUD_unwt <- svyby( ~one , ~hud , y , unwtd.count )		# hud
  
  # weighted counts #
  # (population size column) #
  
  wt_tot <- svytotal( ~one , y )							# total valid cases
  HUD_wt <- svyby( ~one , ~hud , y , svytotal )			# hud
  
  
  # unweighted counts #
  unwt_stocks <- svyby( ~one , ~stock , y , unwtd.count )		# stocks
  #weighted
  wt_stocks<- svyby( ~one , ~stock , y , svytotal )			# stocks
  
  
  #weighted
  frac_hud <- svyby( ~one , ~fractionhud , y , svytotal )			# fractionhud
  
  #weighted
  frac_ndhu <- svyby( ~one , ~fractionndhu , y , svytotal )			# fractionndhu
  
  #Stocks table
  
  tbl20_20 <- bind_rows(unwt_stocks, wt_stocks)
  write.csv(tbl20_20, "tbl20_20.csv")
  
  
  # weighted counts #
  # (population size column) #
  
  svytotal( ~one , y )							# total valid cases
  
  #weighted total counts
  
  (tbl2020 <- svytable(~stock, y))
  View(tbl2020)
  write.csv(tbl2020, "tbl2020.csv")
  
  
  
  
  