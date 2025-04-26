


# load in auto.dta for demonstration purposes 
# cd your workspace 
capture log close 
log using "ProgrammingCheatsheet.log",replace 
sysuse auto,clear 

* -----------------------------------------------------------------------------*
  *### Scalars - store numeric or string values to be called later
#  /* both r- and e-class results contain scalars
#Notes: Be careful when naming scalars: if a variable and a scalar
#have the same name, Stata will assume you are calling the variable.
#(see http://www.stata-journal.com/sjpdf.html?articlenum=dm0021) */
  
scalar x1 = 3 
scalar a1 = "I am a string scalar"

# list scalars,frops scalar x1 
scalar list 
scalar drop x1 


# 数据可视化

## 1 Bar graphs with CIs
ssc install betterbar
sysuse auto.dta , clear
betterbarci ///
  headroom trunk mpg ///
  , over(foreign) legend(on)

## 2 Treatment effect graphs
ssc install forest

global tw_opts ///
  title(, justification(left) color(black) span pos(11)) ///
  graphregion(color(white) lc(white) lw(med)) bgcolor(white) ///
  ylab(,angle(0) nogrid) xtit(,placement(left) justification(left)) ///
  yscale(noline) xscale(noline) legend(region(lc(none) fc(none)))

sysuse auto.dta , clear
forest reg mpg headroom trunk = displacement , graph($tw_opts)


## 3 Quick regression tables
ssc install outwrite

sysuse auto.dta, clear
reg price i.foreign##c.mpg
est sto reg1
reg price i.foreign##c.mpg##i.rep78
est sto reg2
estadd scalar h = 4
reg price i.rep78
est sto reg3
estadd scalar h = 2.5

outwrite reg1 reg2 reg3 using "test.xlsx" ///
  , stats(N r2 h)  replace col("TEST" "(2)") drop(i.rep78) format(%9.3f)

## 4 Summary statistics tables

ssc install sumstats
sysuse auto.dta , clear
sumstats  ///
  (price mpg if foreign == 0) ///
  (price displacement length if foreign == 1) ///
  using "test.xlsx" , replace stats(mean sd)

## 5 Unique IDs

. ssc install makeid
. sysuse auto.dta , clear
(1978 Automobile Data)

. makeid foreign make , gen(uniqueid) project(Demo)

. de uniqueid

. list foreign make uniqueid in 1/5

. list foreign make uniqueid in 53/57


## 6 Flow charts
ssc install statflow

// Set up a flowchart:
  statflow template using "/path/to/file.xlsx" , [replace]

// Fill it out, then get all the requested statistics:
  statflow using "/path/to/file.xlsx" [if] [in]

##7 K-fold cross-validation
. ssc install crossfold
. sysuse nlsw88 , clear
. crossfold reg wage union


##8 Knapsack solver
ssc install dta2kml

clear
set obs 100
gen lat = rnormal() +38
gen lon = rnormal() -77

dta2kml using "demo.kml" , lat(lat) lon(lon) replace

##9 Knapsack solver
ssc install knapsack
. sysuse auto.dta, clear

. keep mpg price
. rename (mpg price)(cost value)

. knapsack 500, p(cost) v(value) gen(chosen)

. di "`r(max)'"

. table chosen , c(sum cost sum value)


##10 QR codes
txt2qr this is a test using "test.png", replace




































