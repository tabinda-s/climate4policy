#!/usr/bin/env bash
# wget https://projects.propublica.org/congress/assets/staffers/201{5,6,7,8}Q{1,2,3,4}-house-disburse-detail.csv 


# December
wget http://prism.oregonstate.edu/tmp/dWNYYRIfHFsUIozt/PRISM_tmean_provisional_4km_onemonth_198112:201812_42.1351_-72.6316.csv 
# November
wget http://prism.oregonstate.edu/tmp/iXXoc8UuADU5YV6q/PRISM_tmean_provisional_4km_onemonth_198111:201811_42.1351_-72.6316.csv 
# October
wget http://prism.oregonstate.edu/tmp/TpOrvr1t2bb6tPfF/PRISM_tmean_provisional_4km_onemonth_198110:201810_42.1351_-72.6316.csv 

# September
wget http://prism.oregonstate.edu/tmp/xx9K9Dh35WwFhXTs/PRISM_tmean_provisional_4km_onemonth_198109:201809_42.1351_-72.6316.csv 

# August
wget http://prism.oregonstate.edu/tmp/8LEbCk9m4E8914GB/PRISM_tmean_provisional_4km_onemonth_198108:201808_42.1351_-72.6316.csv

# July
wget http://prism.oregonstate.edu/tmp/31esQpRwHQzawk5O/PRISM_tmean_provisional_4km_onemonth_198107:201807_42.1351_-72.6316.csv

# June
wget http://prism.oregonstate.edu/tmp/1cLIGQqyA3dUqJX0/PRISM_tmean_stable_4km_onemonth_198106:201806_42.1351_-72.6316.csv

# May
wget http://prism.oregonstate.edu/tmp/KGGOAmKPMMpnpUZu/PRISM_tmean_stable_4km_onemonth_198105:201805_42.1351_-72.6316.csv

# April
wget http://prism.oregonstate.edu/tmp/mx5KcC1MZzGdOQoM/PRISM_tmean_stable_4km_onemonth_198104:201804_42.1351_-72.6316.csv

# March
wget http://prism.oregonstate.edu/tmp/ZqFUixXiUzhUdN7f/PRISM_tmean_stable_4km_onemonth_198103:201803_42.1351_-72.6316.csv

# February
wget http://prism.oregonstate.edu/tmp/vvrFjFVLI9lTVOiC/PRISM_tmean_stable_4km_onemonth_198102:201802_42.1351_-72.6316.csv

# January
wget http://prism.oregonstate.edu/tmp/EX3iFB24Nxl6tG6w/PRISM_tmean_stable_4km_onemonth_198101:201801_42.1351_-72.6316.csv



cat PRISM_tmean_provisional_4km_onemonth_198109:201809_42.1351_-72.6316.csv | tail -n +12 >> mean_temp.csv

# Creating blank master csv
touch mean_temp1.csv > mean_temp1.csv
# Appending all the data
cat PRISM_tmean_stable_4km_onemonth_1981{01,02,03,04,05,06}:2018{01,02,03,04,05,06}_42.1351_-72.6316.csv | tail -n +12 >> mean_temp1.csv
cat PRISM_tmean_provisional_4km_onemonth_1981{07,08,09,10,11,12}:2018{07,08,09,10,11,12}_42.1351_-72.6316.csv | tail -n +12 >> mean_temp1.csv
# Download year averages for mean temperature
wget http://prism.oregonstate.edu/tmp/JdqQOPBoAcemuczV/PRISM_tmean_stable_4km_1981_2017_42.1351_-72.6316.csv

# Round 2
# First county
wget http://prism.oregonstate.edu/tmp/mHNakNDGEcqg9oMZ/PRISM_ppt_tmin_tmean_tmax_stable_4km_198101_201806_37.6464_-121.8861.csv
# Second county
wget http://prism.oregonstate.edu/tmp/dsLg5IpZoRuGpay8/PRISM_ppt_tmin_tmean_tmax_stable_4km_198101_201806_38.5973_-119.8207.csv

#
# ./getprism.sh
