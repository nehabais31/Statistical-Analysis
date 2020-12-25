# set current working directory
#setwd('E:/Neha/Course_Materials/Fall2020/Data Analysis/Final Project')

#######################
#  Loading libraries  #
#######################
#install.packages('dplyr')
#install.packages('car')

library(dplyr)
library(car)
par(mfrow=c(1,1))

############################
#                          #
#   Analysis with cleaned  # 
#        dataset           #
############################

# import cleaned data
bike_data <- read.csv('bike_cleaned.csv', header = T)
bike_data$weather <- as.factor(bike_data$weather)
str(bike_data)
head(bike_data)

####################
#       EDA        #
####################

#Categorical variable
aggregate(bike_data$count, by=list(bike_data$weather), summary)
aggregate(bike_data$count, by=list(bike_data$weather), sd)

boxplot(bike_data$count ~ bike_data$weather,
        data = bike_data,
        main = "Total Bike Rentals Vs Weather",
        xlab = "Weather",
        ylab = "Total Bike Rentals",
        col = c("#D6EAF8", "#2ECC71", "#E74C3C", "#F39C12")) 

# We can see that most of the bike rentals are in clear weather conditions.
# NO-one rents a bike when there is a chance of heavy rains.

# Continuous variable
# Let's see how is the correlation between  temperature and rental count
cor(bike_data$count, bike_data$temperature)   # 0.64   (moderately strong positive correlation)

#Scatter plot
plot(bike_data$temperature, bike_data$count, pch=16, col='blue',
     xlab = 'Temperature in Celsius',
     ylab = 'Rental Count',
     main = 'Rental count based on Temperature')

# the scatter plot shows a positive linear relationship between temperature and rental count.
# There seems to be some points that deviate the plot somewhat from linearity, like the ones showing higher temperature
# but less rental counts. 
# In order to see if this is due to the outliers, we will check for outliers in our data.


## Outlier Detection:  

outlier_iqr <- function(x){
  iqr <- IQR(x,na.rm = T,type = 7)
  q <- quantile(x)
  upper_bound = q[4]+(iqr*1.5)
  lower_bound = q[2]-(iqr*1.5)
  outliers <- which ((x > upper_bound) | (x < lower_bound))
  return(outliers)
}

# Checking outliers for Rental count and temperature
print(outlier_iqr(bike_data$count))

print(outlier_iqr(bike_data$temperature))

# No outliers are present in the rental count and temperature.
# The deviation we see in plot is might be because the data is recorded like this only.  


#####################
#   Research Q-1    #
#####################

### Is temperature a significant predictor for rental count?

# In order to answer this question, will perform a simple linear regression with count as dependent and temperature as independent variable.
# at alpha = 0.05 level.

# The hypothesis test will be -
# H0: beta_temp = 0 (There is not a  linear association between temperature and rental count )    
# H1: beta_temp ≠ 0 (There is a linear association between temperature and rental count )     
# alpha = 0.05

# Generating model
slr <-  lm(count ~ temperature, data=bike_data)
summary(slr)

# Now, since our model gave significant results, we will check whether all our model assumptions are met before making any inferences.
# We will check for Linearity, Independence, Constant variance and normality assumptions.


###  Regression Diagnostics  
par(mfrow=c(2,2))

plot(bike_data$temperature, bike_data$count, xlab= "Temperature",col = 'blue',
     ylab = 'Rental Count',
     main = 'Temperature vs Rental Count')
abline(slr, col = 'red', lty =1)

plot(bike_data$temperature, resid(slr), axes=TRUE, frame.plot=TRUE, xlab='Temperature', ylab='Residue',
     main = 'Residual Plot', col = 'blue')
abline(h=0, lty=1, col='red')

plot(fitted(slr), resid(slr), axes=TRUE, frame.plot=TRUE, xlab='Fitted values', ylab='Residue',
     main = 'Fitted values vs Residual plot', col = 'blue')
abline(h=0, lty=1, col='red')

hist(resid(slr), main = 'Histogram of Residuals', xlab = 'Residuals')
par(mfrow=c(1,1))

# Looking at the plots, we can say that all our model assumptions are met.
# Linearity: Residual plot shows that there is a positive linear relationship between the variables.  
# Independent: The independence assumption is met as the observations are drawn based on different days of years.  
# Constant Variance: From the residual plot, we can see that the variance is almost constant around the regression line.  
# Normality: The histogram tells us that the residuals are normally distributed.

## Checking for influence points
cooks.dist <- cooks.distance(slr)
which(cooks.dist > (4/(nrow(bike_data)-2-1))) 

# Let's check the effect of these influence points on our model
influence.points <- as.vector( which(cooks.dist > (4/(nrow(bike_data)-2-1))) )

for (i in influence.points) {
  count2 <- bike_data$count[-i]
  temp2  <- bike_data$temperature[-i]
  
  bike_data2 <- data.frame(count2, temp2)
  cor(count2, temp2)
  
  lm.2 <- lm(count2 ~ temp2, data = bike_data2)
  model.summary <- summary(lm.2)
  print(paste('Influence Point:', i, 
              '  R-squared: ',  round(model.summary$r.squared,4),
              '  beta1: ', model.summary$coefficients[2,1]),)
}

# By removing these influential points for our data, we checked the model's performance.
# Earlier including these points in our data, the adjusted R-square was around 0.41 which is almost the same after removing these points from our data.
# The beta1 estimate also does not a large difference. So these influence points are not much impacting our data.
# Keeping them in our data won't cause much problem.
# We can say that the model fits well on our data.


# Model Conclusions: 
# Reject the Null hypothesis as p-value (2e-16 ) is too small and is less than alpha.
# We can say that, we have significant evidence at alpha = 0.05 level that there is a linear association between temperature and rental count.
# Here the beta1 estimate is positive, which indicates a positive linear relationship.
# Beta1 = 6803, this can be interpreted as for every 1 degree celsius increase in temperature, the rental count increases by around 6803 on average.


#####################
#   Research Q-2    #
#####################

### Does the rental count varies based on the weather conditions. 
### If yes, which two different weather conditions show a significant difference in average rental count.

# In order to answer this question we will perform a global F-test first using anova model to see if there is a 
# significant difference in the average rental count due to weather change. 
# If the results come significant, we will perform a pairwise comparisons by adjusting for Type-I error using TukeyHSD to see
# which two weather conditions show a significant difference.
 
# Our null hypothesis will be - Fro
# H0: μ_clear = μ_cloudy = μ_lightSnow = μ_heavyRain = 0 (No difference in average rental count due to different weather conditions)
# H1: μi ≠ μj for some i and j  (Difference in average rental count in atleast two of th weather conditions)
# alpha = 0.05

anova.model <- aov(bike_data$count~bike_data$weather)
summary(anova.model)

# Reject the null hypothesis, since p-value (cau is quite small and also less than alpha level.
# From global test, we can say that we have significant evidence at alpha = 0.05 level that there is a significant difference 
# in average rental count based on different weather conditions.

# In order to see under which two weather conditions are these count differ, we will perform pairwise comparison test using TukeyHSD.
TukeyHSD(anova.model)

# Conclusions:
# We can see the  p-value(1.3e-14) is significant i.e. less than alpha level. 
# So, we can say here that there is a significant difference in average rental count between cloudy - clear, LightSnow - Clear
# and LighSnow and Cloudy weather conditions.
# All of the different weather conditions show a significant difference in rental count.


#####################
#   Research Q-3    #
#####################

### What is the effect of weather conditions on rental count after adjusting for temperature.

# TO answer this question, we will perform ANCOVA test and check whether the differences due to weather conditions are significant alone 
# or does temperature plays a part in it.

Anova(lm(bike_data$count ~ bike_data$weather + bike_data$temperature), type = 3)


### Conclusion:
# After adjusting for temperature using an ANCOVA model, we can see the differences in average rental count due to different
# weather conditions are still significant. 
# Temperature has no effect on the results that we got from ANOVA model.
# So, we can say that temperature is not a co-founding variable here.


