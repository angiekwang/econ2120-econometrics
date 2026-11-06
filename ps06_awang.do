*
*
*   ECON2120: Econometrics
*   Problem Set 06
*   
*

clear all

cd "/Users/angiewang/Library/CloudStorage/OneDrive-Personal/Classes/fall2026/econ2120/wooldridge_data"

**** PROBLEM 2: Traffic Data ****
use "traffic1 (1).dta", clear

* 2a. Reformat data 
reshape long dthrte admn open speed, i(state) j(year)
tab year

* 2b. Declare data as panel
encode state, gen(stateid)
summarize state stateid

xtset stateid year, delta(5)

* 2c. Estimate models

* pooled OLS
reg dthrte admn open speed, robust

* between estimator
xtreg dthrte admn open speed, be

* first differences
reg D.dthrte D.admn D.open D.speed, noconstant

* fixed effects
xtreg dthrte admn open speed, fe cluster(stateid)

* 2d. Remove states
preserve
drop if inlist(state, "AK", "FL", "NM")

reg D.dthrte D.admn D.open D.speed, noconstant
xtreg dthrte admn open speed, fe cluster(stateid)

restore


**** PROBLEM 3: Crime Rate Data ****
use "CRIME4 (1).DTA", clear
xtset county year

* 3a. Pooled OLS
reg lcrmrte lpolpc, robust

* 3b. Histogram
histogram density, by(west)

* 3c. Separate variables based on geographic location
separate lcrmrte, by(west)
scatter lcrmrte0 lcrmrte1 lpolpc

* 3d. Fixed effects
xtset county year
xtreg lcrmrte lpolpc, fe cluster(county)
xtreg lcrmrte lpolpc ldensity, fe cluster(county)

* 3e. Add a regressor
xtreg lcrmrte lpolpc ldensity west, fe cluster(county)

* 3f. First differences scatterplot
scatter clcrmrte clpolpc

* 3g. Generate new variables
egen maxclpolpc = max(clpolpc), by(county)
egen minclpolpc = min(clpolpc), by(county)

* 3h. Remove outliers, rerun regressions
drop if abs(clpolpc) > 1
xtreg lcrmrte lpolpc, fe cluster(county)
xtreg lcrmrte lpolpc ldensity, fe cluster(county)

xtreg lcrmrte lpolpc, fe 
xtreg lcrmrte lpolpc ldensity, fe 


**** PROBLEM 4: Manufacturing Data ****
use "jtrain (1).dta", clear

* 4a. Summary stats
tab year if grant == 1, sum(grant)

* 4b. Average scrap rate by year
tabulate grant if d88+d89, summarize(lscrap)
reg lscrap grant if d88+d89, robust

* 4c. Change in scrap rate
tab grant if d88+d89, summarize(clscrap)
reg clscrap grant if d88+d89, robust

* 4e. Multiple regression
xtset fcode year
reg lscrap grant lemploy lsales
xtreg lscrap grant lemploy lsales, fe cluster(fcode)

* 4f. Dummy variables
egen sumgrant = sum(grant), by(fcode)
gen nevergrant = 1 - sumgrant
tab year if nevergrant, summarize(lscrap)

* 4g. Two-way fixed effects
xtreg lscrap grant lemploy lsales d88 d89, fe cluster(fcode)

* 4h. TWFE including lag
xtreg lscrap grant lemploy lsales d88 d89 grant_1, fe cluster(fcode)


