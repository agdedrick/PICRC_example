# Do analysis and create example graphs

#################### Set-up: ####################

##### Load libraries
library(tidyverse)  # has a bunch of packages, including dplyr and ggplot2
library(readxl)  # reads in excel files
library(cowplot)  # makes it easy to put multiple plots together
library(mapdata)  # provides map outline 
library(here)  # makes relative file paths easy to navigate and specify in a way that works across computers/users

##### Read in data (reading in each sheet one at a time)
dive_data <- read_excel(here::here("Data","example_data.xlsx"), sheet="Dives")
fish_data <- read_excel(here::here("Data","example_data.xlsx"), sheet="Fish")

#################### Data processing and analyses: ####################

# Join dive data to fish data
fishdive <- left_join(fish_data, dive_data, by="DiveID")

##### Total number of fish of each species at all sites across time
plot1_df <- fishdive %>%
  group_by(Year, Species) %>%
  summarize(Nfish = n())
  
##### Do divers catch different numbers of fish?
plot2_df <- fishdive %>%
  group_by(Diver, Year) %>%
  summarize(Nfish = n())

##### Species by site across time
plot3_df <- fishdive %>%
  group_by(Year, Species, Site) %>%
  summarize(Nfish = n())

#################### Plots: ####################

##### Plot 1: line plot of number of fish in each species at all sites across time
plot1 <- ggplot(data = plot1_df, aes(x=Year, y=Nfish, color=Species)) +
  geom_point() +
  geom_line() +
  xlab("Year") + ylab("Total fish caught") + 
  theme_bw()  # black and white theme
  
##### Plot 2: fish caught by divers
plot2 <- ggplot(data = plot2_df, aes(x=Year, y=Nfish, color=Diver)) +
  geom_point() +
  geom_line() +
  ylab("Total fish caught") +
  theme_bw()

##### Plot 3: species by site over time
plot3 <- ggplot(data = plot3_df, aes(x=Year, y=Nfish, color=Species)) +
  geom_point() +
  geom_line() +
  ylab("Total fish caught") +
  facet_wrap(~Site) +
  theme_bw()

#################### Saving output: ####################

# Plot 1 
pdf(file=here::here("Plots","fish_by_year.pdf"))  # the "here" part of this command is telling the pdf to save in the "Plots" folder of this directory
plot1
dev.off()

# Plot 2 
pdf(file=here::here("Plots","fish_by_diver.pdf"))
plot2
dev.off()

# # Plot 3
# pdf(file=here::here("Plots","fish_by_diver.pdf"))
# plot3
# dev.off()


