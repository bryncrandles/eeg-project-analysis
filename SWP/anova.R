# SWP ANOVA 

# run anova for swp results from each frequency band
# data should be in table format with columns: group, resting SWP, music SWP, faces SWP 

# install rio to load data
pacman::p_load(rio)
setwd("~/Documents/Summer Research Project/summer-research-project/SWP_results")

# load data
data <- import(' ')
data_long <- reshape(data, varying = list(names(data)[2:4]), v.names = "SWP", timevar = "condition", times = c("resting", "music", "faces"), idvar = "id", ids = 1:nrow(data), direction = "long")

# QQ normality plots under each condition for controls nad patients
# Controls
## Resting
qqnorm(data$resting[data$group == "control"]); qqline(data$resting[data$group == "control"])
## Music
qqnorm(data$music[data$group == "control"]); qqline(data$music[data$group == "control"])
## Faces
qqnorm(data$faces[data$group == "control"]); qqline(data$faces[data$group == "control"])

# Patients
## Resting
qqnorm(data$resting[data$group == "patient"]); qqline(data$resting[data$group == "patient"])
## Music
qqnorm(data$music[data$group == "patient"]); qqline(data$music[data$group == "patient"])
## Faces
qqnorm(data$faces[data$group == "patient"]); qqline(data$faces[data$group == "patient"])

# make factors
data_long$group <- as.factor(data_long$group)
data_long$Condition <- as.factor(data_long$condition)
data_long$id <- as.factor(data_long$id)

# anova
av <- aov(SWP ~ group * Condition + Error(id/Condition), data = data_long)
summary(av)

