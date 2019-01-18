cap cd "~/code4policy/Climate4Policy/final_analysis/prism_climate_indicators"

use temp/appended_prism.dta, clear
export delimited using "/Users/dannytobin/code4policy/climate4policy/final_analysis/output/appended_prism_all.csv", replace


bys county year: egen avg_mean_temp_cyr = mean(mean_temp)
bys county year: egen avg_max_temp_cyr = mean(max_temp)
bys county year: egen avg_min_temp_cyr = mean(min_temp)
bys county year: egen avg_precip_cyr = mean(precip)

egen county_year_tag = tag(county year)
drop if county_year_tag == 0

keep idnum county year latitude longitude elevation_ft avg*

export delimited using "/Users/dannytobin/code4policy/climate4policy/final_analysis/output/prism_countyyear_panel.csv", replace


use temp/prism_all.dta, clear
export delimited using "/Users/dannytobin/code4policy/climate4policy/final_analysis/output/calcounties_all.csv", replace


* Create data-wrapper visual of counties
use temp/prism_all.dta, clear
gen total_mean_temp_change = meantemp_coeff * 37
gen total_max_temp_change = maxtemp_coeff * 37
keep id county total_mean_temp_change total_max_temp_change 
export delimited using "/Users/dannytobin/Desktop/countytotals.csv", replace


*Create annual change dataset to show total change in intro
use temp/appended_prism.dta, clear
bys year: egen annual_meantemp_change = mean(mean_temp)
bys year: egen annual_maxtemp_change = mean(max_temp)
bys year: egen annual_mintemp_change = mean(min_temp)
bys year: egen annual_precip_change = mean(precip)


export delimited using "/Users/dannytobin/code4policy/climate4policy/final_analysis/output/prism_year_results.csv", replace

egen yeartag = tag(year)
keep if yeartag
keep year annual_meantemp_change annual_maxtemp_change annual_mintemp_change annual_precip_change
reg annual_meantemp_change year
reg annual_maxtemp_change year
reg annual_mintemp_change year
reg annual_precip_change year

twoway (scatter annual_meantemp_change year) (lfit annual_meantemp_change year)

export delimited using "/Users/dannytobin/code4policy/climate4policy/final_analysis/output/prism_year_results.csv", replace


* Create dataset for case studies
use "/Users/dannytobin/code4policy/climate4policy/final_analysis/prism_climate_indicators/temp/appended_prism.dta", clear
keep if idnum == 14
keep date mean_temp max_temp
export delimited using "/Users/dannytobin/code4policy/climate4policy/final_analysis/output/inyo.csv", replace


* Create Inyo case
use "/Users/dannytobin/code4policy/climate4policy/final_analysis/prism_climate_indicators/temp/appended_prism.dta", clear

bys county year: egen avg_mean_temp_cyr = mean(mean_temp)
bys county year: egen avg_max_temp_cyr = mean(max_temp)
bys county year: egen avg_min_temp_cyr = mean(min_temp)
bys county year: egen avg_precip_cyr = mean(precip)

egen county_year_tag = tag(county year)
drop if county_year_tag == 0
keep if idnum == 14

keep year avg*
export delimited using "/Users/dannytobin/code4policy/climate4policy/final_analysis/output/inyo_year.csv", replace

* Inyo July
use "/Users/dannytobin/code4policy/climate4policy/final_analysis/prism_climate_indicators/temp/appended_prism.dta", clear
keep if idnum == 14 & month == 7
keep max_temp year
export delimited using "/Users/dannytobin/code4policy/climate4policy/final_analysis/output/inyo_july.csv", replace

* San Bern july
use "/Users/dannytobin/code4policy/climate4policy/final_analysis/prism_climate_indicators/temp/appended_prism.dta", clear
keep if idnum == 36 & month == 7
keep max_temp year
export delimited using "/Users/dannytobin/code4policy/climate4policy/final_analysis/output/sanbern_july.csv", replace


