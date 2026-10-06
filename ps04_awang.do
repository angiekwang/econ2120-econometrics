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

clear all

cd "/Users/angiewang/Library/CloudStorage/OneDrive-Personal/Classes/fall2026/econ2120/wooldridge_data"

**** PROBLEM 1: Wage Data ****
use "WAGE2.dta", clear

* 1a. Test null hypothesis using unrestricted model
reg lwage educ IQ KWW
testparm IQ KWW

* The null hypothesis is rejected, and we can say that IQ and KWW have a jointly statistically significant 
* effect on (log) wages, controlling for years of education. 

* 1b. Calculate F-statistic
reg lwage educ

scalar R2_u = 0.1547
scalar R2_r = 0.0974
scalar n = 935
scalar k = 3
display ((R2_u - R2_r)/2)/((1 - R2_u)/(n - k - 1))

* The estimate of the F-statistic using the calculation is 31.56, and the F-statistic from the regression output in part (1a) is 31.54.

* 1d. Redo part 1a with robust SEs
reg lwage educ IQ KWW, r
testparm IQ KWW

* Using robust standard errors reduces the F-statistic's magnitude from 31.54 to 28.36, though it is still statistically significant. 

**** PROBLEM 2: CEO Salary Data ****
use "CEOSAL1.dta", clear

* 2a. Scatterplots
scatter salary sales
scatter lsalary lsales

* The relationship between log salary and log sales appears to be linear.

* 2b. Regression
reg lsalary lsales consprod, r

* The coefficient on consprod is significant at the 5% level (p-value is 0.001 and t-statistic is 3.28).

* 2c. Twoway graph of predicted and actual values 
predict yhat
sort lsales

graph twoway (scatter lsalary lsales if !consprod) (scatter lsalary lsales if consprod) (scatter yhat lsales if !consprod, connect(l) msize(vtiny)) (scatter yhat lsales if consprod, connect(l) msize(vtiny))

* Average salaries for consumer product CEOs appear higher on average than non-consumer product CEOs, controlling for log sales.

* 2d. Interaction effect
reg lsalary c.lsales##consprod, r

* The coefficients on the consprod and consprod##lsales interaction terms each are not significant at the 5% level.

* 2e. F-tests
gen cplsales = consprod*lsales
reg lsalary lsales consprod cplsales, r
testparm consprod cplsales

* This time, we reject the null hypothesis at the 5% significance level that the coefficients on 
* consprod and cplsales are jointly equal to zero. The p-value of the F-statistic 0.0049 < 0.05.

* 2f. Twoway graph with interaction effect
graph twoway (scatter lsalary lsales if !consprod) (scatter lsalary lsales if consprod) (lfit lsalary lsales if !consprod) (lfit lsalary lsales if consprod)

* Although CEOs for consumer product firms make higher salaries on average than CEOs of non-consumer 
* product firms, it appears that CEOs of non-consumer product firms see a greater percentage increase of their salary, 
* on average, for every percent increase in sales than for CEOs of consumer product firms.  However, this 
* difference is not statistically significant, with a p-value of 0.455.

**** PROBLEM 3: Airfare Data ****
use "airfare.dta", clear

* 3a. Scatterplots
scatter fare dist
scatter lfare dist
scatter fare ldist
scatter lfare ldist

* The slope coefficient from a regression of fare on log distance is 100 times the expected 
* increase in fare (in dollars) given a 1% increase in distance of the flight.

* 3b. Regression and residual scatterplot
reg fare ldist, r

predict resid, residuals
scatter resid ldist

* There appears to be a curved, nonlinear relationship between residuals and log distance, 
* as residuals are higher at the lowest and highest log distances and lower in the middle.

* 3c. Regression and scatterplot
reg fare ldist ldistsq, r

predict yhat
sort ldist

graph twoway (scatter fare ldist) (lfit fare ldist) (scatter yhat ldist, connect(l) msize(vtiny))

* A regression of fare on log distance predicts a strictly linear relationship (shown by the red line). 
* Our regression of fare on log distance and the square of log distance yields predicted values that 
* follow a quadratic relationship (shown by the green line) that fits the shape of the raw scattered data better. 

* 3d. Regression and scatterplot
gen ldist98 = y98*ldist
gen ldistsq98 = y98*ldistsq
gen ldist99 = y99*ldist
gen ldistsq99 = y99*ldistsq
gen ldist00 = y00*ldist
gen ldistsq00 = y00*ldistsq

reg fare ldist ldistsq y98 y99 y00 ldist98-ldistsq00

* In this regression, we separate the effects of year in our nonlinear model of fare on log 
* distance. By including the ldist and ldistsq regressors, we model a quadratic relationship 
* between log distance and fare, and by including the three year dummy variables, we investigate differences 
* in the baseline fare across 1997-2000 (aka the intercept of our best-fit lines). The interaction effects model 
* whether the fundamental "shape" of the relationship between fare and ldist change for each year.

* 3e. Scatterplot of predicted values by year
drop yhat*
predict yhat
separate yhat, by(year)
scatter yhat1997-yhat2000 ldist

* Predicted airfares "spike" in the year 2000. The shape of the graph of predicted airfare does not 
* change much from 1997 through 1999, but the graph noticeably shifts upward in 2000. 

* 3f. F-tests
reg fare ldist ldistsq y98 y99 y00 ldist98-ldistsq00, r

testparm y98-y00 ldist98-ldistsq00
testparm ldist98-ldistsq00

* The first joint f-test tests whether the intercepts, slopes, and curvature shape of the relationship between 
* expected airfare and log distance is the same for years 1997-2000. Like the graph in part (e) visually shows, 
* this relationship is not the same across all years, so the first f-test yields the result that there is a 
* statistically significant difference between the expected airfare and log distance between the four years. 

* On the other hand, the second joint f-test shows that there is no statistically significant difference 
* between the rate at which airfare changes with log distance for each year. This is also shown in the scatterplot 
* in part (e), as the shapes of the curves are nearly identical for all four years. 

