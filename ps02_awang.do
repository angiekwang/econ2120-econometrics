*
*
*
*   ECON2101: Econometrics
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


* 1c. Fraction of first basemen earning over $600k
tabulate pos1 highsalary, row

* T-test only among players earning over $600k
ttest salaryk if highsalary == 1, by(pos1)


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

* 2d. Histogram of number of children
histogram children, discrete

* Histograms by education category
histogram children, discrete by(educ0)

* Generate no-children dummy
gen nochildren = children == 0


* 2e. Correlation between educ0 and having no children
correlate educ0 nochildren


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


* 4c. Residual plot
rvpplot gy_1, yline(0)


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


* 5b. Compare salary variance across groups
tabulate pos1, summarize(salaryk)

* Formal test for equal variances
sdtest salaryk, by(pos1) // reject null hypothesis; variances are not equal


* 5c. Regressions with heteroskedasticity-robust SEs

* Full sample
regress salaryk pos1, robust

* Players earning over $600k
regress salaryk pos1 if highsalary == 1, robust


* 5d. Unequal-variance t-tests

* Full sample
ttest salaryk, by(pos1) unequal

* Players earning over $600k
ttest salaryk if highsalary == 1, by(pos1) unequal

* 5e. Compare basic regression to one with robust standard errors
regress salaryk HR
regress salaryk HR, robust
