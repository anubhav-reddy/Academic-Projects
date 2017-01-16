
library(foreign)

customershare <-read.csv("E:/Study/Predictive Analytics - SAS/SAS/custoemrshare.csv")


#checking if any columns have missing data
sapply(customershare, function(x) sum(is.na(x)))
customershare <- na.omit(customershare)
a <- na.omit(customershare)
a <- scale(a[2:22])

# Segmenting the data into 4 clusters
kmean = kmeans(a,centers = 4,iter.max = 10,nstart = 20)

aggregate(a,by=list(kmean$cluster),FUN=mean)
# append cluster assignment
mydata <- data.frame(a, kmean$cluster)


mydata$CustomerId = customershare[,1]
write.csv(mydata,file = "E:/Study/Predictive Analytics - SAS/SAS/custoemrshare1.csv")

customershare[,1]
head(a)

summary(kmean)
head(kmean)
a= fitted(customershare, method = "centers")
head(a)
