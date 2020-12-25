# Statistical Analysis of Bike Sharing Dataset  
  
### Project Description  
The dataset contains the bike share rental data from ‘Capital Bikeshare’ company servicing Washington D.C. and surrounding areas since 2010. Bike sharing system provides people with a short distance transportation option without worrying about the traffic hustle and enjoying the city view as well as workout at the same time.   
This dataset contains many factors like temperature, weather, season, holidays, working days, humidity, wind-speed that can affect the rental count. We are interested mainly in actual temperature and the different weather change that affect the bike rental count in city.  
  
### Research Scenario    
Capital Bikeshare is one of the America’s most successful and largest bikeshare system. They have collected a data of total number of rental counts based on different factors like season, weather, temperature, holidays, working-days, humidity, wind-speed and few more for years 2011 and 2012.  
They want to investigate if temperature plays a role in the number of rental counts. Also, they would like to know what is the effect of different weather conditions on the rental count. And at last is there any effect of weather conditions on rental count after adjusting for temperature.  
  
We will be using Simple Linear Regression, ANOVA model, ANCOVA for answering these questions.  
  
### Data Description    
The dataset can be downloaded from http://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset.     
  
It contains bike rental data containing 731 rows and 16 columns for two years 2010 and 2011 and the rental count based on weather, temperature, humidity, windspeed, holiday, working-day and some other factors.  
  
As a part of some pre-processing, we checked for any missing values in the dataset and found no missing/null values in any of the columns. Since, in order to answer our research questions, we are interested in weather, temperature and count variables, so we have kept these 3 columns only and removed the other unused columns from our dataset.  
Also, sampled our dataset and randomly selected 500 rows for our analysis.   
At last, we checked for any outliers in our selected variables and found none. So, our final dataset is of dimension (500,3) which we exported to ‘bike_cleaned.csv’ file.  
  
### Research Question  
1.	Is temperature a significant predictor for rental count?   
2.	Does the rental count varies based on the weather conditions? If yes, which two different weather conditions show a significant difference in average rental count.  
3.	What is the effect of weather conditions on rental count after adjusting for temperature?  

### Conclusion    
1. After performing Simple Linear regression and testing for model assumptions, we concluded that we reject the null hypothesis, since p-value (2e-16) was too small and less than alpha (0.05). 
We have significant evidence at alpha = 0.05 level that there is a linear association between temperature and rental count.  
  
2. From the one-way ANOVA analysis, we reject the null hypothesis at alpha = 0.05 level, since p-value came out be (2e-16) which is less than 0.05.  
So, we can say that we have significant evidence at alpha = 0.05 level that there is a difference in average rental count due to different weather conditions.  
After performing the pair-wise comparisons using TukeyHSD method, we find that all of the different pairs of weather conditions (Clear, Cloudy, Light-Snow) show a significant difference in average rental count.   
  
3. After adjusting for temperature and using ANCOVA model, we concluded that the differences we saw between the weather conditions in the ANOVA model were significant and temperature had no effect on them.   
We can still see the differences in average rental count for different weather after adjusting for temperature, since p-value was (1.483e-14) < 0.05. So, we can say temperature is not a co-founding variable in this case.  
  
