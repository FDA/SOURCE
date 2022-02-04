# This code is for multi-year analysis of NSDUH data 
# The data can be found at: https://www.datafiles.samhsa.gov/dataset/nsduh-2002-2019-ds0001-nsduh-2002-2019-ds0001

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

KeepVars <-
  c( 
    "QUESTID2",
    "ANALWC1" ,# main analytic weight
    "YEAR",
    
    "VESTR" , 		# sampling strata
    
    "VEREP" ,     # primary sampling units
    "IRHERRC",
    "IRPNRNMREC", #This variable is used for 2015-on and replaces "ANALREC" which is
    ## Time since last used pain reliever nonmedically
    
    "HERFMFPB",    # spent month or more on heroin past 12 months
    "HERFMCTD", # used heroin more often than intended past 12 months
    "HERPDANG", # built up tolerance past 12 months
    "HERSERPB", # heroin reduced important activities past 12 months
    "HERWDSMT", # heroin caused emotional problems p
    "HERLSACT", # heroin caused health problems
    "HEREMCTD",   # wanted or tried to cut down on heroin
    "HERPHCTD", # heroin reduced important activities past 12 months
    "HERCUTEV", # heroin caused emotional problems p
    "HERLSEFX", # heroin caused health problems
    "HERNDMOR",   # wanted or tried to cut down on heroin
    "HERKPLMT", # heroin reduced important activities past 12 months
    "HERLOTTM", # heroin caused emotional problems p
    "HERGTOVR", # heroin caused health problems
    
    #These are for pre-2015 variables, so should be retained, but ANL = analgesic#
    "ANLFMFPB",    # spent month or more on heroin past 12 months
    "ANLFMCTD", # used heroin more often than intended past 12 months
    "ANLPDANG", # built up tolerance past 12 months
    "ANLSERPB", # heroin reduced important activities past 12 months
    "ANLWDSMT", # heroin caused emotional problems p
    "ANLLSACT", # heroin caused health problems
    "ANLEMCTD",   # wanted or tried to cut down on heroin
    "ANLPHCTD", # heroin reduced important activities past 12 months
    "ANLCUTEV", # heroin caused emotional problems p
    "ANLLSEFX", # heroin caused health problems
    "ANLNDMOR",   # wanted or tried to cut down on heroin
    "ANLKPLMT", # heroin reduced important activities past 12 months
    "ANLLOTTM", # heroin caused emotional problems p
    "ANLGTOVR", # heroin caused health problems
    
    #These variables are 2015-on, but PNRL = pain reliever# 
    "PNRLFMFPB",    # spent month or more on heroin past 12 months
    "PNRLFMCTD", # used heroin more often than intended past 12 months
    "PNRLPDANG", # built up tolerance past 12 months
    "PNRLSERPB", # heroin reduced important activities past 12 months
    "PNRLWDSMT", # heroin caused emotional problems p
    "PNRLLSACT", # heroin caused health problems
    "PNRLEMCTD",   # wanted or tried to cut down on heroin
    "PNRLPHCTD", # heroin reduced important activities past 12 months
    "PNRLCUTEV", # heroin caused emotional problems p
    "PNRLLSEFX", # heroin caused health problems
    "PNRLNDMOR",   # wanted or tried to cut down on heroin
    "PNRLKPLMT", # heroin reduced important activities past 12 months
    "PNRLLOTTM", # heroin caused emotional problems p
    "PNRLGTOVR", # heroin caused health problems
    
    "ANALYFU", # year of first use of opioids used 2001-2014 
    "PNRNMYFU", # RC- YR 1ST MISUSED FOR PAST YR PAIN RLVR INITIATES for 2015-on
    "PNRNMAGE", # RC- AGE AT 1ST MISUSE FOR PAST YR PNRLV INITIATES for 2015-on
    "HERYFU", # year of first use of heroin
    "HERAGE", # Age of first use of heroin 
    "IRHERYFU", 
    "ANALAGE", #Age of first use of opioids 
    "IRANLYFU",
    "IRPNRNMYFU",
    "IRPNRNMINIT"
  )

# Replace 'datafilename' with the name of the data set
# R is case-sensitive, change lower-case names to upper-case
names(#datafilename) <- toupper(names(#datafilename))
  # Using only the variables we need out of this larger file
  NSDUH_subset <- #datafilename %>% 
    select(KeepVars)
  
  # to free up RAM, remove the full r data frame
  rm()
  
  # garbage collection: clear up RAM
  gc()
  
  
  # heroin criteria
  NSDUH_subset <- NSDUH_subset %>% 
    mutate( family = case_when(
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
      udcount = family + danger + seriousprob + withdrawal + cutdown + activities + emotional + tolerance + time + limit,
      hud = ifelse(udcount > 1, 1, 0)
    )
  
  #Rx opioids 
  
  NSDUH_subset <- NSDUH_subset %>% 
    mutate( familyrx = case_when(
      (ANLFMFPB == 1 & ANLFMCTD == 1)  ~ 1,
      (PNRLFMFPB == 1 & PNRLFMCTD == 1)  ~ 1,
      TRUE  ~ 0),
      dangerrx = case_when(
        ANLPDANG == 1  ~ 1,
        PNRLPDANG == 1  ~ 1,
        TRUE  ~ 0),
      seriousprobrx = case_when(
        ANLSERPB == 1  ~ 1,
        PNRLSERPB == 1  ~ 1,
        TRUE  ~ 0),
      withdrawalrx = case_when(
        ANLWDSMT == 1  ~ 1,
        PNRLWDSMT == 1  ~ 1,
        TRUE  ~ 0),
      activitiesrx =  case_when(
        ANLLSACT == 1  ~ 1,
        PNRLLSACT == 1  ~ 1,
        TRUE  ~ 0),
      emotionalrx = case_when(
        (ANLEMCTD == 1 | ANLPHCTD == 1)  ~ 1,
        (PNRLEMCTD == 1 | PNRLPHCTD == 1)  ~ 1,
        TRUE  ~ 0),
      cutdownrx = case_when(
        ANLCUTEV == 2  ~ 1,
        PNRLCUTEV == 2  ~ 1,
        TRUE  ~ 0),
      tolerancerx =  case_when(
        (ANLLSEFX == 1 | ANLNDMOR == 1)  ~ 1,
        (PNRLLSEFX == 1 | PNRLNDMOR == 1)  ~ 1,
        TRUE  ~ 0),
      timerx = case_when(
        (ANLLOTTM == 1 | ANLGTOVR == 1)  ~ 1,
        (PNRLLOTTM == 1 | PNRLGTOVR == 1)  ~ 1,
        TRUE  ~ 0),
      limitrx = case_when(
        ANLKPLMT == 2  ~ 1,
        PNRLKPLMT == 2  ~ 1,
        TRUE  ~ 0),
      oudcount = familyrx + dangerrx + seriousprobrx + withdrawalrx  + activitiesrx + emotionalrx+ cutdownrx + tolerancerx + timerx + limitrx,
      oud = ifelse(oudcount > 1, 1, 0),
      pyher = ifelse((IRHERRC == 1 |IRHERRC == 2),1,0),
      pyanl = ifelse(((IRANLRC == 1 |IRANLRC == 2)|(IRPNRNMREC ==1 |IRPNRNMREC ==2)),1,0)
    )
  
  #XXXXXXXX
  NSDUH_subset <- NSDUH_subset %>% 
    mutate(stock = case_when(
      hud == 1 ~ "HUD NSDUH",
      (oud == 1 & hud == 0 & pyher == 1) ~ "Rx OUD + PY H", 
      (oud == 1 & hud == 0 & pyher == 0) ~ "Rx OUD no PY H",
      (oud == 0 & hud == 0 & pyher == 1) ~ "Nondisordered heroin Abuse", 
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
      strata = ~VESTR , 
      data = NSDUH_subset , 
      weights = ~ANALWC1 , 
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
  
  #stocks counts table
  stcktbl02_19 <- bind_rows(unwt_stocks, wt_stocks)
  write.csv(stcktbl02_19, "stcktbl02_19.csv")
  
  
  # weighted counts #
  # (population size column) #
  
  svytotal( ~one , y )							# total valid cases
  svyby( ~one , ~YEAR , y , svytotal )			
  svyby( ~one , ~ANALYFU , y , svytotal )			
  svyby( ~one , ~HERYFU , y , svytotal )			
  
  tbl2002_2019 <- svyby( ~YEAR , ~stock , y , svytotal )	
  View(tbl2002_2019)
  write.csv(tbl2002_2019, "tbl2002_2019.csv")#
  
  #weighted total counts table
  
  (tbl02_19 <- svytable(~stock+YEAR, y))
  plot(tbl02_19)
  View(tbl02_19)
  write.csv(tbl02_19, "tbl02_19.csv")
  
  
  
  
  
  