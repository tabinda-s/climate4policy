library(readr)
year_change <- read_csv("../output/prism_year_results.csv")

head(year_change, 5)

#basic regression plot
reg1 <- lm(annual_meantemp_change~year,data=year_change) 
summary(reg1)
with(year_change,plot(year,annual_meantemp_change))
abline(reg1)

library(ggplot2)
# make it prettier with ggplot
ggplot(year_change, aes(x=year, y=annual_meantemp_change)) + 
  geom_point()+
  geom_smooth(method=lm, color="black")+
  labs(title="California Warmed 1.16 Degrees F \n Annual Mean Temperature over Time Period",
       x="Year", y = "Annual Mean Temperature Change")+
  theme_classic()  

# Remove confidence bands and add subtitle
reg_meantemp <- ggplot(year_change, aes(x=year, y=annual_meantemp_change)) + 
  geom_point()+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  labs(title="California Steadily Warms",
       x="Year", y = "Annual Mean Temperature Change (F)",
       subtitle = "Mean Temperature Change by Year 1981-2018",
       caption="Source: Prism Climate Data")
reg_meantemp + theme_classic()
ggsave("reg_meantemp.png", width = 20, height = 20, units = "cm")


####
####
####
# Case study 
inyo_max <- read_csv("../output/inyo.csv")


data(inyo_max, package = "ggplot2")
head(inyo_max)
## From Timeseries object (ts)
library(ggplot2)
library(lubridate)
theme_set(theme_bw())

inyo_max <- inyo_max[inyo_max$variable %in% c("mean_temp", "max_temp"), ]
inyo_max <- inyo_max[lubridate::year(inyo_max$date) %in% c(1981:2018), ]

# labels and breaks for X axis text
brks <- inyo_max$date[seq(1, length(df$date), 12)]
lbls <- lubridate::year(brks)

# case study: plot
ggplot(inyo_max, aes(x=date)) + 
  geom_line(aes(y=max_temp, col=variable)) + 
  labs(title="Time Series of Returns Percentage", 
       subtitle="Drawn from Long Data format", 
       caption="Source: Economics", 
       y="Returns %", 
       color=NULL) +  # title and caption
  scale_x_date(labels = lbls, breaks = brks) +  # change to monthly ticks and labels
  scale_color_manual(labels = c("psavert", "uempmed"), 
                     values = c("psavert"="#00ba38", "uempmed"="#f8766d")) +  # line color
  theme(axis.text.x = element_text(angle = 90, vjust=0.5, size = 8),  # rotate x axis text
        panel.grid.minor = element_blank())  # turn off minor grid


# Inyo yearly data
inyo_year <- read_csv("../output/inyo_year.csv")
head(inyo_year)
library(ggplot2)
theme_set(theme_classic())

#Inyo All Months Test
# Allow Default X Axis Labels
inyo <- ggplot(inyo_year, aes(x=year)) + 
  geom_line(aes(y=avg_max_temp_cyr)) + 
  labs(title="Inyo All Months", 
       subtitle="Test", 
       caption="Source: Prism", 
       y="Temp")
inyo + theme_classic()


# Inyo All Months
inyo2 <- ggplot(inyo_year, aes(x=year, y=avg_max_temp_cyr)) + 
  geom_line(aes(y=avg_max_temp_cyr)) + 
  geom_smooth(method=lm, color="red")+
  labs(title="Max Temperature Change: Inyo", 
       subtitle="All Months", 
       caption="Source: Prism Climate Data", 
       y="Average Max Monthly Temperature (F)")
inyo2 + theme_classic()
ggsave("inyo_allmonths.png", width = 20, height = 20, units = "cm")

# Inyo focus on July
inyo_jul <- read_csv("../output/inyo_july.csv")

july_max <- ggplot(inyo_jul, aes(x=year, y=max_temp)) + 
  geom_point()+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  labs(title="Inyo's Hotter Summers",
       x="Year", y = "Max Temperature in July (F)",
       subtitle = "The Hottest Summer Day Has Gotten Hotter",
       caption="Source: Prism Climate Data")
july_max + theme_classic()
ggsave("inyo_july.png", width = 20, height = 20, units = "cm")


# San Bernadino Temps July
sb_jul <- read_csv("../output/sanbern_july.csv")

sb_max <- ggplot(sb_jul, aes(x=year, y=max_temp)) + 
  geom_point()+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  labs(title="San Bernadino's Hotter Summers",
       x="Year", y = "Max Temperature in July (F)",
       subtitle = "The Hottest Summer Day Has Gotten Hotter",
       caption="Source: Prism Climate Data")
sb_max + theme_classic()
ggsave("sb_july.png", width = 20, height = 20, units = "cm")

