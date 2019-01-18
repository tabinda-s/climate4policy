cap cd "~/code4policy/Climate4Policy/prism_climate_indicators"

* use this to set the working directory 
* cap cd "~/code4policy/Development"

* Get all files from csv into dta
foreach i in 37.6464_-121.8861 38.5973_-119.8207 38.4461_-120.6520 39.6670_-121.6006 38.2047_-120.5541 39.1776_-122.2370 37.9192_-121.9263 41.7431_-123.8968 38.7786_-120.5248 36.7584_-119.6504 39.5984_-122.3922 40.6989_-123.8733 33.0396_-115.3653 36.5111_-117.4108 35.3429_-118.7298 36.0753_-119.8155 39.0996_-122.7532 40.6736_-120.5943 34.3231_-118.2249 37.2181_-119.7626 38.0724_-122.7183 37.5816_-119.9051 39.4403_-123.3912 37.1922_-120.7182 41.5898_-120.7250 37.9390_-118.8866 36.2172_-121.2390 38.5064_-122.3305 39.3014_-120.7682 33.7029_-117.7610 39.0636_-120.7175 40.0047_-120.8386 33.7437_-115.9938 38.4493_-121.3438 36.6057_-121.0750 34.8415_-116.1784 33.0360_-116.7329 37.7557_-122.4428 37.9344_-121.2715 35.3871_-120.4040 37.4220_-122.3289 34.6730_-120.0167 37.2316_-121.6948 37.0562_-122.0018 40.7637_-122.0405 39.5804_-120.5161 41.5927_-122.5403 38.2700_-121.9326 38.5284_-122.8871 37.5591_-120.9976 39.0347_-121.6948 40.1257_-122.2339 40.6507_-123.1126 36.2201_-118.8005 38.0272_-119.9553 34.4566_-119.0836 38.6867_-121.9017 39.2690_-121.3512 {
import delimited PRISM_ppt_tmin_tmean_tmax_stable_4km_198101_201806_`i'.csv, clear
gen location = ""
replace location = v1 if regexm(v1, "Lat") & regexm(v1, "Lon")

ren v1 date_str
ren v2 precip
ren v3 min_temp
ren v4 mean_temp
ren v5 max_temp
gen id = "`i'"
egen idnum = group(id)

local id_string = subinstr("`i'", "-", "n", .)
local id_string = subinstr("`id_string'", ".", "_", .)

xfill location, i(idnum)
drop if precip == ""

save temp/prism`id_string'.dta, replace
}

* Append all files
use temp/prism33_0360_n116_7329.dta, clear
foreach i in 37_6464_n121_8861 38_5973_n119_8207 38_4461_n120_6520 39_6670_n121_6006 38_2047_n120_5541 39_1776_n122_2370 37_9192_n121_9263 41_7431_n123_8968 38_7786_n120_5248 36_7584_n119_6504 39_5984_n122_3922 40_6989_n123_8733 33_0396_n115_3653 36_5111_n117_4108 35_3429_n118_7298 36_0753_n119_8155 39_0996_n122_7532 40_6736_n120_5943 34_3231_n118_2249 37_2181_n119_7626 38_0724_n122_7183 37_5816_n119_9051 39_4403_n123_3912 37_1922_n120_7182 41_5898_n120_7250 37_9390_n118_8866 36_2172_n121_2390 38_5064_n122_3305 39_3014_n120_7682 33_7029_n117_7610 39_0636_n120_7175 40_0047_n120_8386 33_7437_n115_9938 38_4493_n121_3438 36_6057_n121_0750 34_8415_n116_1784 33_0360_n116_7329 37_7557_n122_4428 37_9344_n121_2715 35_3871_n120_4040 37_4220_n122_3289 34_6730_n120_0167 37_2316_n121_6948 37_0562_n122_0018 40_7637_n122_0405 39_5804_n120_5161 41_5927_n122_5403 38_2700_n121_9326 38_5284_n122_8871 37_5591_n120_9976 39_0347_n121_6948 40_1257_n122_2339 40_6507_n123_1126 36_2201_n118_8005 38_0272_n119_9553 34_4566_n119_0836 38_6867_n121_9017 39_2690_n121_3512 {

append using temp/prism`i'.dta

}



* Combined file cleaning

split location, parse(:) gen(loc)

drop loc1 loc2
foreach i in loc3 loc4 loc5 {

replace `i' = subinstr(`i', "   ", "", .)

}


ren loc3 longitude
ren loc4 latitude
ren loc5 elevation_ft

replace longitude = subinstr(longitude, "Lon", "", .)
replace latitude = subinstr(latitude, "Elev", "", .)
replace elevation_ft = subinstr(elevation_ft, "ft", "", .)

destring longitude, replace
destring latitude, replace
destring elevation_ft, replace
drop location
drop if date_str == "Date"


* Creating month and year in date format
gen date = date(date_str, "YM", 2020)
format date %td
codebook date

* Generating new year and month
gen month = month(date)
gen year = year(date)

tostring month, gen(month_str)

* Gen group for county
drop idnum
egen idnum = group(id)

drop date_str
destring precip, replace
destring min_temp, replace
destring max_temp, replace
destring mean_temp, replace

* Add county names
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

ren longitude latitude2
ren latitude longitude2
ren latitude2 latitude
ren longitude2 longitude

save temp/appended_prism.dta, replace

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
drop if idnum > 10
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
export delimited using "temp/maxtempbycounty1_10.csv", replace
save temp/prism1_10.dta, replace











