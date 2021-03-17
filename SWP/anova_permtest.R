# Permutation test outline for SWP and variances of individual clustering and path lengths 
# data in the form of table with group, resting, music, faces conditions 

data <- import('/Users/bryncrandles/Documents/Summer Research Project/summer-research-project/SWP_results/controlsandpatients_SWP/SWP_Tables_Delta_SWP.csv')
data_long <- reshape(data, varying = list(names(data)[2:4]), v.names = " ", timevar = "condition", times = c("resting", "music", "faces"), idvar = "id", ids = 1:nrow(data), direction = "long")
# put in variable name (SWP, clust, path)

# make factors
data_long$group <- as.factor(data_long$group)
data_long$condition <- as.factor(data_long$condition)
data_long$id <- as.factor(data_long$id)


av <- summary(aov(" " ~ group * condition + Error(id/condition), data = data_long)) # put in variable name (SWP, clust, path)
Fgroup <-  av[[1]][[1]]$`F value`[1]   # Saving F values for future use
Fcond <-  av[[2]][[1]]$`F value`[1]
Fint <-  av[[2]][[1]]$`F value`[2]

## Do 5000 permutations of the data
N <- 5000

FG <- numeric(N)
FC <- numeric(N)
FI <- numeric(N)

## Input actual F values
FG[1] <- Fgroup
FC[1] <- Fcond
FI[1] <- Fint

for (i in 2:N){
  permdata <- data
  for (j in 1:dim(data)[1]){
    permdata[j, 2:4] <- sample(data[j, 2:4], 3)
  }
  newlabels <- sample(data$group, length(data$group))
  permdata$group <- newlabels
  # put in variable name (SWP, clust, path) in v.names below
  permdata_long <- reshape(permdata, varying = list(names(permdata)[2:4]), v.names = " ", timevar = "condition", times = c("resting", "music", "faces"), idvar = "id", ids = 1:nrow(permdata), direction = "long")
  permdata_long$group <- as.factor(permdata_long$group)
  permdata_long$condition <- as.factor(permdata_long$condition)
  permdata_long$id <- as.factor(permdata_long$id)
  perm_anova <- summary(aov( " " ~ group * condition + Error(id/condition), data = permdata_long))
  FG[i] <- perm_anova[[1]][[1]]$`F value`[1] 
  FC[i] <- perm_anova[[2]][[1]]$`F value`[1] 
  FI[i] <- perm_anova[[2]][[1]]$`F value`[2] 
}

probG <- length(FG[FG >= Fgroup + .Machine$double.eps ^0.5])/N # p value of group effect
probC <- length(FC[FC >= Fcond+ .Machine$double.eps ^0.5])/N   # p value of conditions effect
probI  <-  length(FI[FI >= Fint + .Machine$double.eps ^0.5])/N # p value of interaction effect
