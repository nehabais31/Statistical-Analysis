# reading data from csv file to R-Studio
days <- read.csv('days.csv', header = FALSE)
days

# converting dataframe to a vector
hospital.days <- unlist(days, use.names = FALSE)
hospital.days

# creating a histogram of the duration of hspital stays
hist(hospital.days,  col = 'cyan', breaks = seq(0,18, by=1),
     xlab = 'Days', ylab = 'Frequency',
     main = 'Histogram of duration of hospital stays')

quantile(hospital.days)
sd(hospital.days)
iqr <- fivenum


# 1. The histogram shows a single peak representing hospital stay days equal to 4.
# 2. Distribution is slightly skewed to the right.
# 3. Looking at he graph Center of the data is 5.

# calculation for outliers
# graphical visualisation of outliers
boxplot(hospital.days)

# Manual calculation of outliers
f <- fivenum(hospital.days)

lower <- f[2] - 1.5 * (f[4] - f[2])
upper <- f[4] + 1.5 * (f[4] - f[2])

outliers <- hospital.days[hospital.days < lower | hospital.days > upper]
outliers

# There are 4 outliers in the data -> 13, 14, 15, 17

summary(hospital.days)          # mean = 5.86 , median = 5 , min = 2 , max = 17, 1st qu. = 4, 3rd qu = 7.25
print(sd(hospital.days))        # standard deviation = 3.011829

# Since the distribution is right skewed and there are outliers in the data, mean will be affected due to outliers.
# So, in this case median is the best single number summary of the center f the distribution.

# Part-4 (a)
pnorm(10, mean = 5, sd = 3) * 100  # 95.2% of patients are in hospital for less than 10 days

# Part-4 (b)
pop.mean <- 5
pop.sd <- 3
sample.size <- 35

sample.sd <- pop.sd / sqrt(sample.size)
pnorm(10, mean = pop.mean, sd = sample.sd, lower.tail = F)


