cap cd "~/code4policy/Climate4Policy/prism_climate_indicators/prism_do/"


do prism_cleaning_0_10v3.do

cap cd "~/code4policy/Climate4Policy/prism_climate_indicators/prism_do/"

do prism10_20.do

cap cd "~/code4policy/Climate4Policy/prism_climate_indicators/prism_do/"

do prism20_30.do

cap cd "~/code4policy/Climate4Policy/prism_climate_indicators/prism_do/"

do prism30_40.do

cap cd "~/code4policy/Climate4Policy/prism_climate_indicators/prism_do/"

do prism40_50.do
cap cd "~/code4policy/Climate4Policy/prism_climate_indicators/prism_do/"


do prism50_58.do
cap cd "~/code4policy/Climate4Policy/prism_climate_indicators/"


use temp/prism1_10.dta, clear
append using temp/prism10_20.dta
append using temp/prism20_30.dta
append using temp/prism30_40.dta
append using temp/prism40_50.dta
append using temp/prism50_58.dta

export delimited using "temp/calcounties_all.csv", replace
save temp/prism_all.dta, replace
