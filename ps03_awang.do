*
*
*
*   ECON2120: Econometrics
*   Problem Set 03
*   Angie Wang
*   24 September 2026
*   
*   ps03_awang.do
*
*

**** PROBLEM 2: Murder Rate Data ****
use "MURDER.DTA", clear

* 2a. Multiple regression
regress mrdrte exec unem, robust

* There is only modest evidence of a ‘deterrent effect.’ Keeping 
* unemployment rate constant, an increase of one execution 
* increases the murder rate by 0.165 units on average, 
* compared to the more significant relationship between unemployment 
* rate and murder rate: a one-percentage increase in annual state 
* unemployment rate increases the murder rate by 1.26 units on average. 

* 2b. Scatterplot
scatter mrdrte unem

* 2c. Outliers
predict uhat, residuals
gsort -uhat
list uhat in 1/10

* 2d. Rerun regression after dropping outliers
drop if uhat > 15
regress mrdrte exec unem, robust

* Dropping the outliers causes the slope coefficient on exec to 
* increase from 0.165 to 0.299. Because the three outliers consisted 
* of extremely high murder rates corresponding with relatively high 
* unemployment rates, they cause the relationship between murder rate 
* and unemployment rate to appear stronger than it is. 

**** PROBLEM 3: College GPA Data ****
use "gpa2.dta", clear

* 3a. Simple regression
regress colgpa athlete, robust

* Because this model is a simple dummy regression, the slope coefficient 
* of athlete is the difference in means between college GPA for athletes 
* and non-athletes. Given the extremely small p-value (0.000) and extremely 
* large t-statistic magnitude (6.45), we can say that the slope coefficient 
* is nonzero, so there is a statistically significant difference in expected 
* college GPA for athletes and non-athletes.

* 3b. Multiple regression
regress colgpa athlete sat, robust

* The 95% confidence interval for the slope coefficient on athlete is [-0.127, 0.256]. 
* Because this coefficient is within a multiple regression model, its interpretation 
* is the “expected difference in average college GPA for athletes and non-athletes, 
* holding SAT score constant.” This is different than the interpretation of the 
* coefficient for a simple dummy regression of colgpa on athlete (as in 3a.), 
* which would just be “the expected difference in average college GPA for athletes and non-athletes.” 

* 3c. Sample correlations
predict yhat
predict uhat, residuals
corr colgpa athlete sat yhat uhat

* The correlation between uhat and athlete as well as uhat and sat is zero. 
* The R-squared value reported by Stata in the original regression table (0.1673) 
* is equal to the squared value of the correlation coefficient between the predicted 
* y-values (yhat) and actual y values (colgpa), which is also 0.1673. 

* 3d. Sample variances of fitted values and residuals
regress colgpa athlete sat

gen n = 4137

summarize yhat
gen yhat_var = .2693975^2
display yhat_var
gen ssr = yhat_var*(n-1)
display ssr

* Multiplying the sample variance of the predicted values by n-1 
* gives 300.17, which is the same as the regression output of SSR (or SS Model). 

summarize uhat
gen uhat_var = .6010197^2
display uhat_var
gen sse = uhat_var*(n-1)
display sse

* Multiplying the sample variance of the residuals by n-1 gives 
* 1949.025, which is the same as the regression output of SSE (or SS Residual). 

gen sst = 1794.19567
display 1 - (sse/sst)

* Calculating R-squared by using the formula 1 – (SSR/SST), where SSR = sum of 
* squared residuals and SST = total sum of squares from the regression table 
* yields an R-squared value of 0.1673, which is the same as Stata’s reported 
* answer in the regression table above.

display sqrt(uhat_var*n/(n-2))

* 3e. Table
tabulate sat, by(athlete)
ttest sat, by(athlete) unequal

* The average SAT score for an athlete is 914 compared to an average SAT 
* score of 1036 for a non-athlete. Running a t-test shows that the difference 
* between the average SAT score for athletes and non-athletes is statistically 
* significant (t-statistic of 9.635). 

**** PROBLEM 4: Recidivism Data ****
use "recid.dta", clear

* 4a. Generate variable
gen substance = alcohol + drugs - alcohol*drugs

* The variable substance is a dummy variable that is equal to 1 if the variable 
* alcohol is 1 or the variable drugs is 1. We can interpret it as a dummy variable 
* that is equal to 1 if there is history of alcohol and/or drug abuse, and 0 otherwise. 
* We subtract the product of the two original variables so that, if both alcohol and drugs 
* is equal to 1, the substance variable is equal to 1, not 2 (making sure substance stays as a dummy variable).

* 4b. Simple Regression
regress durat substance, robust

* It takes individuals with a history of substance abuse, on average, 4.24 less months 
* to receive another conviction after being released from prison than 
* individuals without a history of substance abuse.

* 4c. Table
* Refer to slide 4 in notes 7

* 4d. Multiple Regression
regress durat substance black, robust

* 4f. Multiple Regression
gen blsub = black*substance
regress durat substance black blsub, robust

