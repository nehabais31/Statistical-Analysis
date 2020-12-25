# Set working directory
#setwd('E:/Neha/Course_Materials/Fall2020/Data Analysis/Assignments')

# Q.1

# Reading calorie intake data
calorie.data  <- read.csv('calorie_data.csv' )
calorie.data

# summarizing data
aggregate(calorie.data$calorie_intake, by =list(as.factor(calorie.data$Category)), FUN=summary)
aggregate(calorie.data$calorie_intake, by =list(as.factor(calorie.data$Category)), FUN=sd)


# Plotting the distribution
par(mfrow = c(1,2), oma=c(0,0,2,0))
hist(calorie.data[calorie.data$Category == 'Participants',1], 
     xlab = "Participants Calorie Intake", col = 'lightblue', breaks = seq(100,700,100),
     main = "")

hist(calorie.data[calorie.data$Category == 'Non-Participants',1], 
     xlab = "Non-Participants Calorie Intake", col = 'lightblue',breaks = seq(100,700,100),
     main = "")
mtext("Calorie Intake Distribution", line=0, side=3, outer=TRUE, cex=2)
par(mfrow = c(1,1))

##############################################################################

# Q.2

##########
# Step-1 #
##########
#Set up the Null hypothesis and select the alpha level

# H_0 :μ = 425 (mean calorie consumpition of participants is 425)
# H_1 :μ ≠ 425 (mean calorie consumpition of participants differ from 425)


participants.data <- calorie.data[ calorie.data$Category == 'Participants', 1 ]
x.bar <- mean(participants.data)
participants.sd <- sd(participants.data)
mu <- 425
n <- length(participants.data)
alpha <- 0.05

##########
# Step-2 #
##########

# Select the appropriate test statistic 
# Since the sample size is 25 which is less than 30, we choose t-test statistic

# t =  (x.bar - mu) / (participants.sd / sqrt(n))


##########
# Step-3 #
##########

# State the decision rule
# Determine the critical value 
# Degree of freedom
df <- n - 1

# calculation for critical t value 
t.critical <- qt(1-(alpha/2), df )
t.critical

# Decision Rule: Reject H_0 if |t| ≥ t.critical (2.063899)
# Otherwise do not reject H_0


##########
# Step-4 #
##########

# Compute the test statistic and associated p-value

t <- (x.bar - mu) / (participants.sd / sqrt(n)) 
abs(t)

p.value <- 2 * pt(t, df)
p.value

##########
# Step-5 #
##########

# Conclusion

# Fail to reject H_0 since abs(t) = 0.6139386 is less than t.critical (2.063899).
# Also, p-value (1.454968) > 0.05.
# We do not have significant evidence at alpha = 0.05 level that the mean calorie intake of participants differ from 425.

#############################################################################################################################

# Q-3

# 90% CI for mean calorie intake of participants in meal preparation
t.test(participants.data, alternative = 'two.sided',
       mu = 425, conf.level = 0.90)


# 90% CI = (368.5004 ~ 451.6588)
# This indicates that we are 90% confident that the mean calorie intake of children who participated 
# in the meal preparation experiment lies in between 368.5 and 451.6588.
# This can be validated by seeing that the mean of participants calorie intake = 410.07 which lies in the above range.

#############################################################################################################################

# Q-4

participants.data     <- calorie.data[ calorie.data$Category == 'Participants', 1 ]
non.participants.data <- calorie.data[ calorie.data$Category == 'Non-Participants' , 1 ]

x1.bar <- mean(participants.data)
x2.bar <- mean(non.participants.data)

p.sd   <- sd(participants.data)
np.sd  <- sd(non.participants.data)

n_1 <- length(participants.data)
n_2 <- length(non.participants.data)

alpha <- 0.05


##########
# Step-1 #
##########
#Set up the Null hypothesis and select the alpha level

# H_0 :μ1 = μ2 (mean calorie consumpition of participants is equal to that of non-participants)
# H_1 :μ1 > μ2 (mean calorie consumpition of participants greater than those of non-participants)


##########
# Step-2 #
##########

# Select the appropriate test statistic 
# Since the sample size is 25 which is less than 30, we choose t-test statistic

# t =  (x1.bar - x2.bar) / sqrt( ( (p.sd)**2 / n_1) + ( (np.sd)**2 / n_2) )


##########
# Step-3 #
##########

# State the decision rule
# Determine the critical value 
# Degree of freedom
n_1  # 25
n_2  # 22
df <- min(n_1, n_2) - 1   # choose minimum fro n_1 and n_2
df

# calculation for critical t value 
t.critical <- qt(0.05 , df, lower.tail = F ) 
t.critical

# Decision Rule: Reject H_0 if |t| ≥ t.critical (1.720743)
# Otherwise do not reject H_0


##########
# Step-4 #
##########

# Compute the test statistic and associated p-value

t.twosample <- (x1.bar - x2.bar) / sqrt( ( (p.sd)**2 / n_1) + ( (np.sd)**2 / n_2) )
abs(t.twosample)

p.value.twosample <- 1- pt(t.twosample, df)
p.value.twosample

##########
# Step-5 #
##########

# Conclusion:
# Fail to reject H_0 since abs(t) = 0.9636 is less than t.critical (1.7207).
# Also, p-value (0.1731) > 0.05.
# We do not have significant evidence at alpha = 0.05 level that the mean calorie intake of participants is greater than 
# those of non-participants.

#############################################################################################################################

# Q-5
# Are the assumptions of the test used in Q-4 met?  

# If we see the difference in sample means of participants and non-participants, it was 36.
# This is a positive value which indicates that the mean calorie intake of participants (x1.bar) is greater than
# those of non-participants(x2.bar).
# Hence, we failed to reject the null hypothesis which states that the mean calorie intake of particpants and 
# non-participants are equal.
