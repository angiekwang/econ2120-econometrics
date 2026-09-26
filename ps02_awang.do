*
*
*
*   ECON2120: Econometrics
*   Problem Set 02
*   Angie Wang
*   17 September 2026
*   
*   ps02_awang.do
*
*

clear all

* Set working directory
cd "/Users/angiewang/Library/CloudStorage/OneDrive-Personal/Classes/fall2026/econ2120/ps02/data_ps02/"

**** PROBLEM 1: MLB Data ****

import excel "mlbdata.xlsx", sheet("Data") firstrow

* 1a. Salary in thousands
gen salaryk = SALARY/1000

* Histogram with 16 bins
histogram salaryk, bin(16)

* Dummy = 1 if salary > $600k
gen highsalary = salaryk > 600

* Number of players earning over $600k
tabulate highsalary


* 1b. First baseman dummy
gen pos1 = POS == "1B"

* Salary distributions: first basemen vs everyone else
histogram salaryk, by(pos1)

* Difference in average salary
ttest salaryk, by(pos1)

* The difference between the average salary of first basemen 
* versus all other players is statistically significant, with a p-value of 0.0005

* 1c. Fraction of first basemen earning over $600k
tabulate pos1 highsalary, row

* T-test only among players earning over $600k
ttest salaryk if highsalary == 1, by(pos1)

* Difference between average salary of
* first basemen verus all other players (only looking at players
* making over $600k) is still statistically significant, with a 
* p-value of 0.0289.

* 1d. Salary vs offensive production
scatter salaryk OPS

* Correlation using full sample
correlate salaryk OPS

* Find player with highest OPS
gsort -OPS
list PLAYER OPS in 1

* Correlation excluding highest-OPS player
correlate salaryk OPS 
correlate salaryk OPS if PLAYER != "Bryce Harper"

* The correlation between salary and offensive output excluding 
* the outlier is 0.206, compared to the correlation of both variables
* in the full sample, which is only 0.1772.

**** PROBLEM 2: Fertility Data ****

use "FERTIL2.dta", clear

* 2a. Distribution of education
tabulate educ

* Median and other descriptive statistics
summarize educ, detail

* 2b. Children vs education
scatter children educ

* 2c. Compare children across educ0 groups
tabulate educ0, summarize(children)

* Women who have never attended school have, on average, 
* around 1.46 more children than women who have completed 
* at least one year of school.

* 2d. Histogram of number of children
histogram children, discrete

* Histograms by education category
histogram children, discrete by(educ0)

* Generate no-children dummy
gen nochildren = children == 0


* 2e. Correlation between educ0 and having no children
correlate educ0 nochildren

* The sample correlation between educ0 and nochildren is -0.176. 
* The negative sign of the indicates, on average, women who have 
* no education are less likely to have zero children.

* 2f. Fraction with no children by educ0
tabulate educ0 nochildren, row


**** PROBLEM 4: Consumption Data ****

use "consump.dta", clear

* 4a. Regress consumption growth on income growth from previous year
regress gc gy_1


* 4b. Variance-covariance matrix
correlate gc gy_1, covariance

* Store covariance matrix
matrix C = r(C)
matrix list C

* Verify slope = Cov(gc,gy_1) / Var(gy_1)
display C[1,2] / C[2,2]

* Manually calculating covariance of gc and gy_1 over variance 
* of gy_1 gives the same slope estimate as what is provided in 
* the regression table in (4a.)

* 4c. Residual plot
rvpplot gy_1, yline(0)

* The residuals do appear to be evenly distributed around zero (mean zero)
* and uncorrelated with gy_1.

* 4d. Generate residuals
predict u, residuals

* Mean of residuals
summarize u

* Correlation between residuals and x
correlate u gy_1


* 4e. Scatterplot + fitted regression line
twoway (scatter gc gy_1) ///
       (lfit gc gy_1)
	   
	   
**** PROBLEM 5: T-tests and Robust Regressions ****	   
	   
import excel "mlbdata.xlsx", firstrow clear

* Recreate variables from Problem 1
gen salaryk = SALARY/1000
gen highsalary = salaryk > 600
gen pos1 = POS == "1B"


* 5a. T-tests using regression

* Full sample
regress salaryk pos1

* Players earning over $600k
regress salaryk pos1 if highsalary == 1

* Replicating the t-test in (1b.) using regression yields a 
* t-statistic with the same magnitude (3.56). Additionally, 
* the magnitude of the difference between the means from the t-test 
* yields the slope estimator from the regression (5396.482). 

* The standard error of the regression slope estimator is also 
* the same as the standard error of the difference between the 
* means in the t-test (1515.839).

* 5b. Compare salary variance across groups
tabulate pos1, summarize(salaryk)

* Formal test for equal variances
sdtest salaryk, by(pos1)

* Conducting an f-test for equal variances results in a conclusion that the variance 
* of the salaries of non-first basemen is unequal to the variance of salaries of first 
* basemen. The f statistic of 0.5255 and p value of 0.0317 leads us to reject the null 
* hypothesis that the variances of salaries are equal for first basemen vs non-first basemen. 


* 5c. Regressions with heteroskedasticity-robust SEs

* Full sample
regress salaryk pos1, robust

* Players earning over $600k
regress salaryk pos1 if highsalary == 1, robust

* Replicating the t-test in (1c.) using a regression with heteroskedastic robust 
* standard errors does not yield a statistically significant result at the 5% 
* significance level because the resulting p value is 0.079 (or 7.9%). This 
* contradicts our conclusion from the regression in (5a.) also replicating the 
* t-test in (1c.), so we fail to reject the null hypothesis when allowing for heteroskedasticity.

* 5d. Unequal-variance t-tests

* Full sample
ttest salaryk, by(pos1) unequal

* Replicating the t-test in (1b.) assuming unequal variances still yields a statistically significant result 

* Players earning over $600k
ttest salaryk if highsalary == 1, by(pos1) unequal

* 5e. Compare basic regression to one with robust standard errors
regress salaryk HR
regress salaryk HR, robust

* The intercept and slope estimators do not change, and the t-statistics 
* (3.40 for robust test; 3.41 for non-robust test) retain their significance 
* in both regressions with and without heteroskedasticity robust standard errors.  
