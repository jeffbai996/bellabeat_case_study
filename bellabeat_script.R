# load required packages
library(tidyverse)
library(janitor)
library(skimr)
library(lubridate)

# load .csv into data frames
dailyActivity <- read_csv("datasets/dailyActivity.csv")
sleepDay <- read_csv("datasets/sleepDay.csv")
weightLogInfo <- read_csv("datasets/weightLogInfo.csv")

# convert column names
dailyActivity <- clean_names(dailyActivity)
sleepDay <- clean_names(sleepDay)
weightLogInfo <- clean_names (weightLogInfo)

# identify duplicates
get_dupes(dailyActivity)
get_dupes(sleepDay)
get_dupes(weightLogInfo)

# remove duplicates
sleepDay <- distinct(sleepDay)

# remove invalid records
dailyActivity <- dailyActivity %>% 
  filter(total_steps >= 500)

# identify outliers and bad columns
skim_without_charts(dailyActivity, !id)
skim_without_charts(sleepDay, !id)
weightLogInfo %>% 
  select(-c(id, log_id)) %>% 
  skim_without_charts()

# remove outliers and bad columns
dailyActivity <- select(
  dailyActivity, 
  -c(logged_activities_distance, sedentary_active_distance)
)
weightLogInfo <- select(
  weightLogInfo, 
  -c(fat, log_id)
)

# change column data type to 'date'
dailyActivity$activity_date <- as_date(dailyActivity$activity_date, format = "%m/%d/%Y")

# new column for day of week name
dailyActivity <- dailyActivity %>% 
  mutate(weekday = wday(activity_date, label = TRUE))

# ggplot total steps over day of week
dailyActivity %>% 
  group_by(weekday) %>% 
  ggplot(aes(x = weekday, y = total_steps)) +
  geom_boxplot() +
  labs(
    title = "Total Steps Taken by Day of Week",
    x = "Day of Week",
    y = "Total Steps Taken",
    caption = "Time frame: April 12, 2016 to May 11, 2016"
  )

# calculated column for total time worn
dailyActivity <- dailyActivity %>% 
  mutate(total_time_worn = very_active_minutes + fairly_active_minutes + 
           lightly_active_minutes + sedentary_minutes)

# ggplot tracker use over day of week
dailyActivity %>% 
  group_by(weekday) %>% 
  ggplot(aes(x = weekday, y = total_time_worn)) +
  geom_violin() +
  geom_boxplot(width = 0.1) +
  labs(
    title = "Tracker Use by Day of Week",
    x = "Day of Week",
    y = "Percentage of Day Worn",
    caption = "Time frame: April 12, 2016 to May 11, 2016"
  ) +
  scale_y_continuous(
    breaks = c(360, 720, 1080, 1440),
    labels = c("25%", "50%", "75%", "100%")
  )

# average time slept over day of week
sleepDay$sleep_day <- as_date(sleepDay$sleep_day, format = "%m/%d/%Y")

sleepDay <- sleepDay %>% 
  mutate(weekday = wday(sleep_day, label = TRUE))

sleepDay %>% 
  group_by(weekday) %>% 
  summarize(avg_minutes_asleep = mean(total_minutes_asleep)) %>% 
  ggplot(aes(x = weekday, y = avg_minutes_asleep)) +
  geom_col() +
  coord_cartesian(
    ylim = c(300, 500),
  ) +
  scale_y_continuous(
    breaks = c(300, 360, 420, 480, 540),
    labels = c("5h", "6h", "7h", "8h", "9h")
  ) +
  labs(
    title = "Average Minutes Asleep by Day of Week",
    x = "Day of Week",
    y = "Average Minutes Asleep",
    caption = "Time frame: April 12, 2016 to May 11, 2016"
  )