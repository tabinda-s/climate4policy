cap cd "~/code4policy/Climate4Policy/prism_climate_indicators"

use temp/appended_prism.dta, clear

* I am creating a local variable of all the different counties so that I can run a loop
* Such a loop will basically say "do this for each county"
*levelsof idnum
*local counties = r(levels)

* I also want to be able to do things for each month
*levelsof month
*local months = r(levels)

gen county = ""
replace county = "Alameda" if idnum == 1
replace county = "Alpine" if idnum == 2
replace county = "Amador" if idnum == 3
replace county = "Butte" if idnum == 4
replace county = "Calaveras" if idnum == 5
replace county = "Colusa" if idnum == 6
replace county = "Contra Costa" if idnum == 7
replace county = "Del Norte" if idnum == 8
replace county = "El Dorado" if idnum == 9
replace county = "Fresno" if idnum == 10
replace county = "Glenn" if idnum == 11
replace county = "Humboldt" if idnum == 12
replace county = "Imperial" if idnum == 13
replace county = "Inyo" if idnum == 14
replace county = "Kern" if idnum == 15
replace county = "Kings" if idnum == 16
replace county = "Lake" if idnum == 17
replace county = "Lassen" if idnum == 18
replace county = "Los Angeles" if idnum == 19
replace county = "Madera" if idnum == 20
replace county = "Marin" if idnum == 21
replace county = "Mariposa" if idnum == 22
replace county = "Mendocino" if idnum == 23
replace county = "Merced" if idnum == 24
replace county = "Modoc" if idnum == 25
replace county = "Mono" if idnum == 26
replace county = "Monterey" if idnum == 27
replace county = "Napa" if idnum == 28
replace county = "Nevada" if idnum == 29
replace county = "Orange" if idnum == 30
replace county = "Placer" if idnum == 31
replace county = "Plumas" if idnum == 32
replace county = "Riverside" if idnum == 33
replace county = "Sacramento" if idnum == 34
replace county = "San Benito" if idnum == 35
replace county = "San Bernardino" if idnum == 36
replace county = "San Diego" if idnum == 37
replace county = "San Francisco" if idnum == 38
replace county = "San Joaquin" if idnum == 39
replace county = "San Luis Obispo" if idnum == 40
replace county = "San Mateo" if idnum == 41
replace county = "Santa Barbara" if idnum == 42
replace county = "Santa Clara" if idnum == 43
replace county = "Santa Cruz" if idnum == 44
replace county = "Shasta" if idnum == 45
replace county = "Sierra" if idnum == 46
replace county = "Siskiyou" if idnum == 47
replace county = "Solano" if idnum == 48
replace county = "Sonoma" if idnum == 49
replace county = "Stanislaus" if idnum == 50
replace county = "Sutter" if idnum == 51
replace county = "Tehama" if idnum == 52
replace county = "Trinity" if idnum == 53
replace county = "Tulare" if idnum == 54
replace county = "Tuolumne" if idnum == 55
replace county = "Ventura" if idnum == 56
replace county = "Yolo" if idnum == 57
replace county = "Yuba" if idnum == 58
*I am saving the coefficient of a regression for the max temp change over time in a given month and county
* Really I want to capture the coefficient of the changing max temperatures over time 
* I am saving the coefficient of a regression for the max temp change over time in a given month and county
drop if idnum <= 30 | idnum >40
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
save temp/prism30_40.dta, replace
