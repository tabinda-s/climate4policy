cap cd "~/code4policy/Climate4Policy/prism_climate_indicators"

use temp/appended_prism.dta, clear

* I am creating a local variable of all the different counties so that I can run a loop
* Such a loop will basically say "do this for each county"
*levelsof idnum
*local counties = r(levels)

* I also want to be able to do things for each month
*levelsof month
*local months = r(levels)

*I am saving the coefficient of a regression for the max temp change over time in a given month and county
* Really I want to capture the coefficient of the changing max temperatures over time 
* I am saving the coefficient of a regression for the max temp change over time in a given month and county
drop if idnum <= 20 | idnum >30
gen coeff = 0

levelsof month_str
local months = r(levels)
levelsof idnum
local counties = r(levels)
foreach mnth in `months' {
foreach cnty in `counties' {
reg max_temp year if month_str == "`mnth'" & idnum == `cnty'
gen coeff`cnty'`mnth' = _b[year]
replace coeff = coeff`cnty'`mnth' if idnum == `cnty' & month_str == "`mnth'"
}
}

*Now I need to average this change (over all the months) by county
bys idnum: egen maxtemp_coeff = mean(coeff)
drop coeff*


****mean temp
gen coeff = 0

levelsof month_str
local months = r(levels)
levelsof idnum
local counties = r(levels)
foreach mnth in `months' {
foreach cnty in `counties' {
reg mean_temp year if month_str == "`mnth'" & idnum == `cnty'
gen coeff`cnty'`mnth' = _b[year]
replace coeff = coeff`cnty'`mnth' if idnum == `cnty' & month_str == "`mnth'"
}
}

*Now I need to average this change (over all the months) by county
bys idnum: egen meantemp_coeff = mean(coeff)

drop coeff*
****precipitation
gen coeff = 0

levelsof month_str
local months = r(levels)
levelsof idnum
local counties = r(levels)
foreach mnth in `months' {
foreach cnty in `counties' {
reg precip year if month_str == "`mnth'" & idnum == `cnty'
gen coeff`cnty'`mnth' = _b[year]
replace coeff = coeff`cnty'`mnth' if idnum == `cnty' & month_str == "`mnth'"
}
}

*Now I need to average this change (over all the months) by county
bys idnum: egen precip_change = mean(coeff)

drop coef*

egen county_tag  = tag(idnum)

*Now that I created my county max temp change measure I want to only keep the relevant variables
*I also only want one row (observation) per county
keep if county_tag
keep precip_change meantemp_coeff maxtemp_coeff county id idnum latitude longitude

*I am exporting this file. Without specifying the file path it is placed in the current working directory
*of your jupyter notebook
export delimited using "temp/maxtempbycounty20_30.csv", replace
save temp/prism20_30.dta, replace
