*
*
*   ECON2120: Econometrics
*   Problem Set 05
*   Angie Wang
*   
*   ps05_awang.do
*
*

clear all

cd "/Users/angiewang/Library/CloudStorage/OneDrive-Personal/Classes/fall2026/econ2120/wooldridge_data"

**** PROBLEM 1: Traffic Data ****
use "TRAFFIC2.dta", clear

* 1a. Time series plots
gen date = tm(1981m1)+_n-1
tsset date, monthly

gen month = month(dofm(date))
tab month, gen(m)

tsline totacc
tsline fatacc

* 1b. Investigate seasonality
tab month, sum(totacc)
tab month, sum(fatacc)

* 1c. Seasonality
reg ltotacc m1-m12, r 
reg lfatacc m1-m12, r 

* 1d. Regressions (totacc)
reg totacc beltlaw, r
reg totacc spdlaw, r

reg totacc spdlaw beltlaw, r

* 1e. Regressions (fatacc)
reg fatacc beltlaw, r
reg fatacc spdlaw, r

reg fatacc spdlaw beltlaw, r

* 1f. Redo regressions w/ seasonality
reg fatacc beltlaw spdlaw m1-m12, r
testparm m1-m12


**** PROBLEM 3: Productivity Data ****
use "blsprodwage.dta", clear

* 3a. Time series plot
gen date = tq(1947q2)+_n-1
tsset date, quarterly

* 3b. Dickey-Fuller tests
dfuller ProdIndex
dfuller WageIndex

* 3c. Multiple regression interaction
replace ProdIndex = ProdIndex+100
gen ProdGrowth=. in 1
replace ProdGrowth = 100*(ProdIndex[_n]-ProdIndex[_n-1])/ProdIndex[_n-1] in 2/L

replace WageIndex = WageIndex+100
gen WageGrowth=. in 1
replace WageGrowth = 100*(WageIndex[_n]-WageIndex[_n-1])/WageIndex[_n-1] in 2/L

gen after1978=0
replace after1978=1 if tin(1979q1,)

count
display 293^(1/3)

newey WageGrowth c.ProdGrowth##after1978, lag(6)

* 3d. Dickey-Fuller test on residuals
predict uhat, resid
dfuller uhat

**** PROBLEM 4: Fama-Bliss Data ****
use "fbshort.dta", clear

* 4a. Dickey-Fuller test
dfuller shortrate
gen dshortrate = D.shortrate

reg dshortrate c.t##c.t##c.t if tin(,2010m12)
arima dshortrate if tin(,2010m12), arima(1,0,0)
reg dshortrate L.dshortrate L2.dshortrate if tin(,2010m12)

* 4b. Autocorrelograms
ac dshortrate

quietly arima dshortrate if tin(,2010m12), arima(1,0,0)
predict uii, resid
ac uii

quietly reg dshortrate L.dshortrate L2.dshortrate if tin(,2010m12)
predict uiii, resid
ac uiii

* 4c. In-sample time series plot
quietly reg dshortrate c.t##c.t##c.t if tin(,2010m12)
display e(r2)
predict yi

quietly reg dshortrate L.dshortrate if tin(,2010m12)
display e(r2)
predict yii

quietly reg dshortrate L.dshortrate L2.dshortrate if tin(,2010m12)
display e(r2)
predict yiii

tsline dshortrate yi yii yiii if tin(,2010m12)

* 4d. Root mean squared error
gen ei = dshortrate - yi
gen eii = dshortrate - yii
gen eiii = dshortrate - yiii

sum ei if tin(2011m1,2012m12)
sum eii if tin(2011m1,2012m12)
sum eiii if tin(2011m1,2012m12)

* 4e. Out-of-sample time series plot
tsline dshortrate yi yii yiii if tin(2011m1,2012m12)
