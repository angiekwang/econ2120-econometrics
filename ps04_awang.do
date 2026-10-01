*
*
*
*   ECON2120: Econometrics
*   Problem Set 04
*   Angie Wang
*   6 October 2026
*   
*   ps04_awang.do
*
*

**** PROBLEM 1: Wage Data ****
use "WAGE2.dta", clear

* 1a. Test null hypothesis using unrestricted model
reg lwage educ IQ KWW
testparm IQ KWW

* 1b. Calculate F-statistic
reg lwage educ

scalar R2_u = 0.1547
scalar R2_r = 0.0974
scalar n = 935
scalar k = 3
display ((R2_u - R2_r)/2)/((1 - R2_u)/(n - k - 1))

* 1d. Redo part 1a with robust SEs
reg lwage educ IQ KWW, r
testparm IQ KWW


**** PROBLEM 2: CEO Salary Data ****
use "CEOSAL1.dta", clear

* 2a. Scatterplots
scatter salary sales
scatter lsalary lsales

* 2b. Regression
reg lsalary lsales consprod, r

* 2c. Twoway graph of predicted and actual values 
predict yhat
sort lsales

graph twoway (scatter lsalary lsales if !consprod) (scatter lsalary lsales if consprod) (scatter yhat lsales if !consprod, connect(l) msize(vtiny)) (scatter yhat lsales if consprod, connect(l) msize(vtiny))

* 2d. Interaction effect
reg lsalary c.lsales##consprod, r

* 2e. F-tests
gen cplsales = consprod*lsales
reg lsalary lsales consprod cplsales, r
testparm consprod cplsales

* 2f. Twoway graph with interaction effect
graph twoway (scatter lsalary lsales if !consprod) (scatter lsalary lsales if consprod) (lfit lsalary lsales if !consprod) (lfit lsalary lsales if consprod)

**** PROBLEM 3: Airfare Data ****
use "airfare.dta", clear

* 3a. Scatterplots


* 3b. Regression and residual scatterplot
reg fare ldist, r

predict resid, residuals
scatter resid ldist

* 3c. Regression and scatterplot
reg fare ldist ldistsq, r

predict yhat
sort ldist

graph twoway (scatter fare ldist) (lfit fare ldist) (scatter yhat ldist, connect(l) msize(vtiny))

* 3d. Regression and scatterplot
gen ldist98 = y98*ldist
gen ldistsq98 = y98*ldistsq
gen ldist99 = y99*ldist
gen ldistsq99 = y99*ldistsq
gen ldist00 = y00*ldist
gen ldistsq00 = y00*ldistsq

reg fare ldist ldistsq y98 y99 y00 ldist98-ldistsq00

* 3e. Scatterplot of predicted values by year
drop yhat*
predict yhat
separate yhat, by(year)
scatter yhat1997-yhat2000 ldist

* 3f. F-tests
reg fare ldist ldistsq y98 y99 y00 ldist98-ldistsq00, r

testparm y98-y00 ldist98-ldistsq00
testparm ldist98-ldistsq00

