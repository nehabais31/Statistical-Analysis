# set current working directory
#setwd('E:/Neha/Course_Materials/Fall2020/Data Analysis/Final Project')

# We will be using just the day.csv file for our analysis

#######################
#  Loading libraries  #
#######################
#install.packages('dplyr')

library(dplyr)

#######################
#  Loading data       #
#######################
raw_data <- read.csv('Dataset/day.csv', header = TRUE)


#######################
#  Check for null     #
#######################
missing_val <- data.frame(sapply(raw_data, function(x) sum(is.na(x))))
names(missing_val)[1] = 'missing_val'
missing_val

# Checking for class of all columns
str(raw_data)

###########################
#                         #  
#  Converting categorical #
#        to factor        #
###########################
raw_data$weather <- factor(raw_data$weather,
                           levels = c(1,2,3,4),
                           labels = c('Clear', 'Cloudy', 'Light-Snow', 'Heavy-Rain'))

# selecting desired columns only
raw_data <- raw_data %>% 
  select(weather, temp, cnt) 

names(raw_data) <-  c('weather', 'temperature', 'count')

# Getting a sample of 500 rows for our analysis
set.seed(5)
sampled_data <- sample_n(raw_data, 500)
dim(sampled_data)

# write reduced data to csv file
write.csv(sampled_data, 'bike_cleaned.csv', row.names = FALSE)