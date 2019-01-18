## README file for B4

Climate Change in California

Below is a summary of how we went about implementing this project.

Climate indicators section:
 
I found the data from PRISM climate group at Oregon State during my search for high quality climate data. I saw that it had data on max temperature, mean temperature, min temperature, and precipitation down to the county level in California for every month since 1981. However, I also observed that it was not easy to download the data in bulk.
 
The first step I took was to see if I could use wget from the command line to download the data and append it together. I built the getprism.sh file to do that, but realized that there was a middle part of the url that changed for each data download before the csv such that using special characters {} to download multiple counties no longer worked. For that reason, we divided the 58 counties to our group members and each downloaded some. Once the files were downloaded, I was able to append them using the command line (using getprism.sh), but found later that it was better to use STATA. The main reason for this choice was that the data for each county came with latitude and longitude coordinates but did not list the county name so I had to back into that link later (I also tried to spatially join the latitude and longitude to shapefiles, but had unresolvable issues related to the projection – more on that later).
 
 
Append and Data Cleaning with STATA
Once I had 58 csvs (1 per county) with the raw climate indicators (mean temp in month, max temp in month, precipitation in inches for month, and min temp in month) for all months over the time period of 1981-2018, I needed to read them into a single file
I created a loop to read each of the 58 csv files and used a local variable to attach the number in which the file was read as an idnum column (the first file had an idnum equal to 1, second file idnum ==2, etc.)
This loop created a STATA data file for each of the input csvs
Given how we divided the download of files using wget between the team members, I had a list of the file names that was (if order could be preserved) in alphabetical order
Next, I found an alphabetical list of California counties online and created a matching key of ascending numbers
In the STATA file I created a county variable and I filled that county with appropriate name based on the matching list. I used the alt trick you showed us in class in Jupyter Notebook cells to create STATA code (replacing county if idnum == 1, etc.). There isn’t a specific record of this because in the STATA code this results in 58 lines of “if idnum==1, replace = “county name”, but this wasn’t as repetitive as it looks.
This was the main cleaning issue, but I also renamed variables and changed the date to the appropriate date filetype
 
Create the change variables
The dataset had mean and max temperatures, but it did not tell us how these things changed over time
I consulted a professor and learned that I could get a measure of the monthly change by county by running a regression where I would regress time (year) on the various indicators (max_temp, mean_temp, precipitation) for each county and month
This would tell me how these indicators changed each year for this locality and month
At this point, I ran into an issue with my matrix size (my version of STATA was not powerful enough to run this operation), so I divided this process into 6 stata files where I ran the analysis code on 10 counties each
I created a file called prism_runall.do and appended the resulting datasets together after running the analysis 10 counties at a time and outputting 6 intermediate files
 
Outputs from STATA files
From the first cleaning effort (inelegantly named prism_cleaning_0_10v3.do), I saved a long data format, which had the raw indicators and all months over the 37 years called appended_prism.dta
Then after getting the indicator change measure and appending the files (in prism_runall.do), I created an output called prism_all.dta, which has one line per county with its change for each indicator (this change is a measure of yearly change so I multiplied by 37 in many cases to show total change)
I made a post-analysis file to load data in ready-to-visualize formats in R in another STATA script file called prism_viz.do
This created csvs with annual averages (across the months), yearly averages, and specific month and county snapshots of the data
 
Visualizing data
I visualized the data in Jupyter Notebooks (with Python), Rstudio, and Datawrapper
I used Datawrapper to create two visuals but I found the iFrame to be pretty inflexible so I ultimately remade one of the visuals in R. The one remaining visual is an interactive map
The file Cali_maps2.ipynb show my commented code in Jupyter Notebooks and the file yearmeanchange.R contains my commented R scripts for the other 4 visuals

Summary of learning
In sum, of the graphics that were used, I created 1 graphic in data wrapper, 2 using Python’s geopandas library, and 4 in R
R was an entirely new language for me and so making those graphics and translating the initial drafts from STATA was one of my primary challenges
Using the command line in the shell file to download the files (although ultimately only half successful) was another entirely new exercise for me
Finally, while I had used Python before, I did use this project to deepen and consolidate my knowledge and actually had to spend much of the project time trouble-shooting the issue with merging the county data correctly. I also had to apply a new concept of a local variable to STATA in order to count the order in which the files were loaded in, which I was able to do because of the Python lessons and understanding more about programming

Wildfire data:

Data Sources

For both the visualizations, the original data source was the Cal Fire website. Data focusing on acres burned, structures damaged and deaths was in a PDF format here: http://www.fire.ca.gov/communications/downloads/fact_sheets/Top20_Destruction.pdf. The data showed the stats for the counties most affected by wildfires. The data included figures from 1923-2018.

The data on dollars spent combating wildfires and associated damage was also in PDF format here: (http://cdfdata.fire.ca.gov/pub/cdf/images/incidentstatsevents_270.pdf). The data included figures from 1933 - 2016.

Data Analysis

To understand and analyze the data, I converted the PDFs to CSV files using Tableau’s built-in features. There were a few errors, especially related to location data, that had to be manually fixed.
To visualize the data, I tried using several charts on Tableau and settled on the bar graphs for the ‘all stats’ section and the ‘acres burned and structures damaged’. I wanted to try building a dashboard on Tableau so I included the location data that corresponded to the other two charts. 
For the dollar damage data, I again used a bar chart since it provided a good visual. I adjusted the chart to only pick data from 1988 onwards since the data prior to that was causing the dollars spent figure minimal and rising sharply. Adjusting the chart to pick data from 1988 onwards helped communicate the figures better.
I also tried adjusting (using a basic Python script initially but then I later switched to Excel) the dollar data for inflation by using the CPI but I did not end up using the inflation adjusted data because it was not producing a compelling visualization.

Sea Level data:

The datasets are from Underwater: Rising Seas, Chronic Floods, and the Implications for US Coastal Real Estate (2018)
(https://www.ucsusa.org/global-warming/global-warming-impacts/sea-level-rise-chronic-floods-and-us-coastal-real-estate-implications#.XD6PVs9Kh0t ) There are 3 different sets are: states, community, and zp-code. For the first set graphic, I used D3 scripts from vida.io and used states datasets transferred to JSON file. For the  second set graphic, I used datawrapper to transform zip-code data into CSV file. For the third set graphic, I used datawrapper to transform community data into CSV file.

Emissions and GDP:

Data sources
Emissions data were from the US Energy Information Administration (EIA) in the form of an xlxs file showing annual carbon dioxide emissions broken out by state. See https://www.eia.gov/environment/emissions/state/
GDP per capita data were from the US Bureau of Economic Analysis (BEA). The BEA offers a downloadable zip archive of GDP by state, which includes csv files with GDP over time for each state as well as for all areas consolidated. The data set used in this analysis was pulled from a single csv that included GDP per capita for each state from 1997 through 2017. See https://www.bea.gov/data/gdp/gdp-state 

Consolidation and cleaning
The majority of data processing was done in Microsoft Excel, the tool I’m most familiar with.
I began by adding both data sets to a single workbook (GHG_GDP_processed.xlxs) and creating a small proof of concept by creating lookups to pull emissions and GDP data from a particular state into a single table. I narrowed the year range down to years where the data sets overlapped, 1997 through 2016.
To be able to use the data in initial D3 visualizations, I used Excel to create a csv that included year, emissions, and GDP per capita for every state (ghg-gdp.csv).
I used Excel to update the date format by appending a month and a day to each year value so it could be more easily interpreted by D3. 
After making changes to my D3 visualization, I again used Excel to modify the data set so each state would have a column for emissions and a column for GDP (rather than two columns running down the entire document with every state contained within). 
I used Excel formulas to quickly fill in the column headings in the format used in my D3 code.
I also used Excel formulas to build the lists/dictionaries that power the selection feature in my D3 visualization, which I then exported as csvs and pasted directly into my code. I think this would also have been a good opportunity to use Python (eg looping through lists of states, abbreviations, etc to build dictionaries).
