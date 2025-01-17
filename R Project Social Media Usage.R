
# Time Spent On Social Media by user.

" This data shows how much a user spends time on their devices using Social Media platforms "

" The purpose of this project is to predict which social media is mostly used by users it can 
 be in different spheres of life "

# 1 which is the most prefered social media by males?
# 2 which is the most prefered social media by females?
# 3 which social media platform is mostly used by location?
# 4 which age group spent so much time on social media platform?

library(dplyr)
library(ggplot2)
library(scales)
library(tidyr)
library(forcats)
library(grid)
library(cowplot)
library(ggrepel)
library(ggforce)
library(readxl)
library(Hmisc)
library(psych)
library(tidytext)
library(ISLR)
library(chron)

mydata <- read.csv('D:/Data/usersOnSocialMedia.csv', sep = ',')
mydata

#DATA CLEANSING

names(mydata)
dim(mydata)
sum(is.na(mydata))
sum(duplicated(mydata))
colSums(mydata == 0)
min(mydata$age)
max(mydata$age)
summary(mydata)

# 1 which is the most prefered social media by males?

mysubdata <- mydata[mydata$gender %in% 'male', ] 
myplotdata <- mysubdata %>% select(platform, gender) %>% count(platform)
myplotdata <- mutate(myplotdata, platform = fct_reorder(platform, -n))
ggplot(data = myplotdata, aes(x = platform, y = n)) +
  geom_col(fill = 'blue') +
  labs(title = 'Social Media Usage by Males') +
  labs(x = 'Social Media platform', y = 'Number of Users') +
  geom_text(aes(label = n), vjust = -0.5)  +
  scale_y_continuous(limits = c(0, 150), breaks = scales::pretty_breaks(n = 7), 
                      labels = function(x) paste0(x*1))

" The graph shows the number of male users on each social media platform, where most males 
  spend most of their time on instagram, because men are mostly on instagram for business
  reasons, they gather the information they need to build influence"

" when i draw my conclusion based on the graph, men are more likely to follow video content on
  social media, especially content about sports, cars and humor. "

# 2 Which is the most prefered social media by females?

mysubdata <- mydata[mydata$gender %in% 'female', ]
countedata <- mysubdata %>% select(platform, gender) %>% count(platform)
countedata <-  mutate(countedata, platform = fct_reorder(platform, -n))
ggplot(data = countedata, aes(x = platform, y = n)) +
  geom_col(fill = 'green') +
  labs(title = 'Social Media Usage by Females') +
  labs(x = 'Social Media platform', y = 'Number of Users') +
  geom_text(aes(label = n), vjust = -0.5)  +
  scale_y_continuous(limits = c(0, 150), breaks = scales::pretty_breaks(n = 7), 
                     labels = function(x) paste0(x*1))

" The graph shows the number of females on each social media platform, where most females spend
  most of their time on instagram because women are biologically wired for social networking,  
  women also spend most of their time on youtube because they are more likely to seek out a
  how-to video "

# 3 Which Social media platform used mostly by location?

mysubdata <- mydata %>% select(location, platform) %>% count(location, platform)
mysubdata <- mysubdata %>% mutate(platform = reorder_within(
  x = platform, 
  by = -n,
  within = location
))  
ggplot(mysubdata, aes(x = platform, y = n, fill = location)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = n), vjust = -0.5) +
  labs(x = 'Social Media Platform', y = 'Number of users in Countries') + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 0.5)) +
  scale_x_reordered() +
  facet_wrap(~ location, scales = 'free') 

" The graph shows the number of users based on 3 different Countries which are Australia, 
 United Kingdom and the United States, where most of the users in all the countries prefer 
 instagram, we can also see that YouTube is the second most prefered social media platform 
 in both Australia and the United States "

" when i draw my conclusion based on the graph, all the 3 countries are the target market for
 the instagram social medial platform"

# 4 Which age group spent so much time on social media platform?

mydata[mydata$age >= 12 & mydata$age <= 27, 'age_group'] <- 'GenZ(12 -27)'
mydata[mydata$age >= 28 & mydata$age <= 43, 'age_group'] <- 'Millennial(28 - 43)'
mydata[mydata$age >= 44 & mydata$age <= 59, 'age_group'] <- 'GenX(44 - 59)'
mydata[mydata$age >= 60 & mydata$age <= 69, 'age_group'] <- 'Boomers(60 - 69)'
mydata

mysubdata <- mydata %>% select(time_spent, age_group)
sumTimeSpentData <- as.data.frame(xtabs(time_spent ~ age_group, mysubdata)%/%60)
sumTimeSpentData2 <- as.data.frame(xtabs(time_spent ~ age_group, mysubdata)%%60)
sumTimeSpentData <- sumTimeSpentData %>% rename(hours = Freq)
sumTimeSpentData2 <- sumTimeSpentData2 %>% rename(minutes = Freq)
sumTimeSpentData
sumTimeSpentData2
concatenatedData <- cbind(sumTimeSpentData, minutes = sumTimeSpentData2$minutes)
concatenatedData 
concatenatedData2  <- select(concatenatedData , hours, minutes)
concatenatedData2 
sumUnitedData <- mutate(concatenatedData, unite(concatenatedData2 , hoursMinutes, sep = ':'))
sumUnitedData
ggplot(data = sumUnitedData, aes(x = reorder(age_group, -hours), hours)) +
  ggtitle('Time Spent by Age Group') +
  labs(x = 'age group', y = 'time spent') +
  geom_col(fill = 'red') +
  geom_text(aes(label = format(hoursMinutes)), angle = 0, vjust = -0.5, hjust = 0.5) +
  theme(axis.text.x = element_text(angle = 0, vjust = 0.5, hjust = 0.5)) +
  scale_y_continuous(limits = c(0, 24), breaks = scales::pretty_breaks(n = 12),
                     labels = function(x) paste0(x*1, 'hr'))

" The graph shows the time spent in hours on social media by different age groups including males 
  and females, the millennial age group shows the highest time spent followed by the GenX, The 
  huge gap between the GenX and the GenZ is created because most people under the GenZ age 
  group are students that means they spend most of their time in school and the Boomers 
  spend less time on social media because theres no enough content for their liking "
                                                                                                                                              
