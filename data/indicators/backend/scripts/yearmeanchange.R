library(readr)
library(ggplot2)
library(gridExtra)
library(ggalt)
install.packages("ggalt")
year_change <- read_csv("../output/prism_year_results.csv")
getwd()
head(year_change, 5)

#basic regression plot
reg1 <- lm(annual_meantemp_change~year,data=year_change) 
summary(reg1)
with(year_change,plot(year,annual_meantemp_change))
abline(reg1)

# make it prettier with ggplot
ggplot(year_change, aes(x=year, y=annual_meantemp_change)) + 
  geom_point()+
  geom_smooth(method=lm, color="black")+
  labs(title="California Warmed 1.16 Degrees F \n Annual Mean Temperature over Time Period",
       x="Year", y = "Annual Mean Temperature Change")+
  theme_classic()  




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

theme_black2 = function(base_size = 12, base_family = "") {
  
  theme_grey(base_size = base_size, base_family = base_family) %+replace%
    
    theme(
      # Specify axis options
      axis.line = element_blank(),  
      axis.text.x = element_text(size = base_size*0.8, color = "white", lineheight = 0.9),  
      axis.text.y = element_text(size = base_size*0.8, color = "white", lineheight = 0.9),  
      axis.ticks = element_line(color = "white", size  =  0.2),  
      axis.title.x = element_text(size = base_size, color = "white", margin = margin(0, 10, 0, 0)),  
      axis.title.y = element_text(size = base_size, color = "white", angle = 90, margin = margin(0, 10, 0, 0)),  
      axis.ticks.length = unit(0.3, "lines"),   
      # Specify legend options
      legend.background = element_rect(color = NA, fill = "black"),  
      legend.key = element_rect(color = "white",  fill = "black"),  
      legend.key.size = unit(1.2, "lines"),  
      legend.key.height = NULL,  
      legend.key.width = NULL,      
      legend.text = element_text(size = base_size*0.8, color = "white"),  
      legend.title = element_text(size = base_size*0.8, face = "bold", hjust = 0, color = "white"),  
      legend.position = "right",  
      legend.text.align = NULL,  
      legend.title.align = NULL,  
      legend.direction = "vertical",  
      legend.box = NULL, 
      # Specify panel options
      panel.background = element_rect(fill = "black", color  =  NA),  
      panel.border = element_rect(fill = NA, color = "white"),  
      panel.grid.major = element_line(color = "grey35"),  
      panel.grid.minor = element_line(color = "grey20"),  
      panel.margin = unit(0.5, "lines"),   
      # Specify facetting options
      strip.background = element_rect(fill = "grey30", color = "grey10"),  
      strip.text.x = element_text(size = base_size*0.8, color = "white"),  
      strip.text.y = element_text(size = base_size*0.8, color = "white",angle = -90),  
      # Specify plot options
      plot.background = element_rect(color = "black", fill = "black"),  
      plot.title = element_text(size = base_size*1.2, color = "white"),  
      plot.margin = unit(rep(1, 4), "lines")
      
    )
  
}

# Remake datawrapper
library(ggalt)
theme_set(theme_black())

county_totes <- read.csv("~/Desktop/countytotals.csv")
county_totes$county <- factor(county_totes$county, levels=as.character(county_totes$county))  # for right ordering of the dumbells
library(dplyr)
library(tidyr)
# health$Area <- factor(health$Area)
df2 = tidyr::gather(country_totes, group, value, -trt)

gg <- ggplot(county_totes, aes(x=total_mean_temp_change, xend=total_max_temp_change, y=county, group=county, legend(x, xend))) + 
  geom_dumbbell(color="#CDC5BF", colour_x = "#EE2C2C", size=1, colour_xend="#FA8072", show.legend = TRUE) + 
  scale_x_continuous() + 
  labs(x=NULL, 
       y=NULL, 
       title="Total Mean and Max Temperature Change per Month by County", 
       caption="Source: PRISM Climate Data")
  
gg + theme_black2()
ggsave("maxmeancompare2.png", width = 20, height = 30, units = "cm")



############
############
#Remake all plots in black 
# Create black theme
theme_black = function(base_size = 12, base_family = "") {
  
  theme_grey(base_size = base_size, base_family = base_family) %+replace%
    
    theme(
      # Specify axis options
      axis.line = element_blank(),  
      axis.text.x = element_text(size = base_size*0.8, color = "white", lineheight = 0.9),  
      axis.text.y = element_text(size = base_size*0.8, color = "white", lineheight = 0.9),  
      axis.ticks = element_line(color = "white", size  =  0.2),  
      axis.title.x = element_text(size = base_size, color = "white", margin = margin(0, 10, 0, 0)),  
      axis.title.y = element_text(size = base_size, color = "white", angle = 90, margin = margin(0, 10, 0, 0)),  
      axis.ticks.length = unit(0.3, "lines"),   
      # Specify legend options
      legend.background = element_rect(color = NA, fill = "black"),  
      legend.key = element_rect(color = "white",  fill = "black"),  
      legend.key.size = unit(1.2, "lines"),  
      legend.key.height = NULL,  
      legend.key.width = NULL,      
      legend.text = element_text(size = base_size*0.8, color = "white"),  
      legend.title = element_text(size = base_size*0.8, face = "bold", hjust = 0, color = "white"),  
      legend.position = "right",  
      legend.text.align = NULL,  
      legend.title.align = NULL,  
      legend.direction = "vertical",  
      legend.box = NULL, 
      # Specify panel options
      panel.background = element_rect(fill = "black", color  =  NA),  
      panel.border = element_rect(fill = NA, color = "white"),  
      panel.grid.major = element_line(color = "grey35"),  
      panel.grid.minor = element_line(color = "grey20"),  
      panel.margin = unit(0.5, "lines"),   
      # Specify facetting options
      strip.background = element_rect(fill = "grey30", color = "grey10"),  
      strip.text.x = element_text(size = base_size*0.8, color = "white"),  
      strip.text.y = element_text(size = base_size*0.8, color = "white",angle = -90),  
      # Specify plot options
      plot.background = element_rect(color = "black", fill = "black"),  
      plot.title = element_text(size = base_size*1.2, color = "white"),  
      plot.margin = unit(rep(1, 4), "lines")
      
    )
  
}
# Remove confidence bands and add subtitle
reg_meantemp <- ggplot(year_change, aes(x=year, y=annual_meantemp_change)) + 
  geom_point(color = "white")+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  labs(title="California Steadily Warms",
       x="Year", y = "Annual Mean Temperature Change (F)",
       subtitle = "Mean Temperature Change by Year 1981-2018",
       caption="Source: Prism Climate Data", cex=1.5)
reg_meantemp + theme_black()
ggsave("reg_meantemp.png", width = 20, height = 22, units = "cm")

# Inyo All Months
inyo2 <- ggplot(inyo_year, aes(x=year, y=avg_max_temp_cyr)) + 
  geom_line(aes(y=avg_max_temp_cyr), color="white") + 
  geom_smooth(method=lm, color="white")+
  labs(title="Max Temperature Change: Inyo", 
       subtitle="All Months", 
       caption="Source: Prism Climate Data", 
       y="Average Max Monthly Temperature (F)")
inyo2 + theme_black()
ggsave("inyo_allmonths.png", width = 20, height = 20, units = "cm")

# Inyo focus on July
inyo_jul <- read_csv("../output/inyo_july.csv")

july_max <- ggplot(inyo_jul, aes(x=year, y=max_temp)) + 
  geom_point(color="white")+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  labs(title="Inyo's Hotter Summers",
       x="Year", y = "Max Temperature in July (F)",
       subtitle = "The Hottest Summer Day Has Gotten Hotter",
       caption="Source: Prism Climate Data")
july_max + theme_black()
ggsave("inyo_july.png", width = 20, height = 20, units = "cm")


# San Bernadino Temps July
sb_jul <- read_csv("../output/sanbern_july.csv")

sb_max <- ggplot(sb_jul, aes(x=year, y=max_temp)) + 
  geom_point(color="white")+
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  labs(title="San Bernadino's Hotter Summers",
       x="Year", y = "Max Temperature in July (F)",
       subtitle = "The Hottest Summer Day Has Gotten Hotter",
       caption="Source: Prism Climate Data")
sb_max + theme_black()
ggsave("sb_july.png", width = 20, height = 20, units = "cm")


