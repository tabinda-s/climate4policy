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


*
