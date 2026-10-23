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

* There is evidence of seasonality in both variables

* 1c. Seasonality
reg ltotacc m1-m12, r 
reg lfatacc m1-m12, r 

* fatacc has more seasonality

* 1d. Regressions (totacc)
reg totacc beltlaw, r
reg totacc spdlaw, r

reg totacc spdlaw beltlaw, r

* While both law dummies appear significant in simple regressions, 
* controlling for the variation in accidents after January 1984 
* (due to the seatbelt law) largely nullifies the effect of the speeding law

* 1e. Regressions (fatacc)
reg fatacc beltlaw, r
reg fatacc spdlaw, r

reg fatacc spdlaw beltlaw, r

* The effect of the seatbelt law on expected traffic fatalities 
* is not statistically significant in a multiple regression model 
* controlling for the speeding law

* 1f. Redo regressions w/ seasonality
reg fatacc beltlaw m1-m12, r
reg fatacc spdlaw m1-m12, r

reg fatacc beltlaw spdlaw m1-m12, r
testparm m1-m12

* In a multiple regression model controlling for seasonality, 
* both the seatbelt law and speeding law have statistically significant 
* effects on the average number of traffic accident fatalities. 
* The joint F-test gives evidence for seasonality.

**** PROBLEM 3: Productivity Data ****
use "blsprodwage.dta", clear

* 3a. Time series plot
gen date = tq(1947q2)+_n-1
tsset date, quarterly

tsline ProdIndex WageIndex

* There is evidence of a “productivity gap”

* 3b. Dickey-Fuller tests
dfuller ProdIndex
dfuller WageIndex

* We fail to reject the null hypothesis for both Dickey-Fuller tests, 
* meaning that both ProdIndex and WageIndex are nonstationary time series

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

* we reject the null hypothesis in a Dickey-Fuller test on the residuals 
* of the regression of WageGrowth on ProdGrowth, so we can conclude that 
* these regression residuals are a mean-reverting time series

* 3e. Null hypothesis test
display (-0.2639864-(-0.25))/0.1160635

quietly newey WageGrowth c.ProdGrowth##after1978, lag(6)
test (1.after1978#c.ProdGrowth = 0) (1.after1978 = -0.25)

* H0: “Since 1979, the relationship between wage growth and productivity growth 
* is statistically unchanged, but real wage growth has slowed by about 1% per year (0.25 quarterly).”

* We fail to reject the null hypothesis

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

* We see (in the autocorellogram of the AR(1) model) that there is a 
* significant spike in the correlation between dshortrate and the residuals 
* of the model at Lag = 2. Therefore, we add an additional lag and use an AR(2) model.

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

* The cubic polynomial has the largest R-squared value of 0.149, so it has the best in-sample fit.

* 4d. Root mean squared error
gen ei = dshortrate - yi
gen eii = dshortrate - yii
gen eiii = dshortrate - yiii

sum ei if tin(2011m1,2012m12)
sum eii if tin(2011m1,2012m12)
sum eiii if tin(2011m1,2012m12)

* Although the cubic polynomial has the largest R-squared for in sample prediction, 
* it also has the largest Root Mean Squared Error (RMSE) of 0.0835, which is roughly five 
* times larger than the RMSE of the AR(1) model, 0.0164, and the AR(2) with the smallest RMSE of 0.0161.

* 4e. Out-of-sample time series plot
tsline dshortrate yi yii yiii if tin(2011m1,2012m12)

* Although the cubic polynomial model performed the best in-sample with the largest R-squared value, 
* it is clearly the worst-performing model when conducting out-of-sample forecasting.
