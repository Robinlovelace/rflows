### OA flow data
# Read in Sheffield codes
library(foreign)
shef.oa <- read.dbf("/media/3C3863A438635BC0/MyFolder/Datagis/Localdata/Oa/allmodes.dbf")
head(shef.oa)
# Read in (massive) workflows file
uk.oa.flow <- read.csv("/media/3C3863A438635BC0/MyFolder/Datagis/flowdata/OA-flows/W301_OUT.csv") # This file's half a Gib big!
# Subset massive workflow file so just Sheff flows remain
head(uk.oa.flow)
# Test first with a subset of Shef data
test <- shef.oa[sample(nrow(shef.oa), size= 40 ), 1]
head(test)
test.merge <- shef.oa[which(shef.oa$ZONE_CODE %in% test),]
test.merge # This works: now apply the same method to the entire dataset
shef.flow <- uk.oa.flow[which(uk.oa.flow$X00AAFA0001 %in% shef.oa$ZONE_CODE),]
# Remove giant file from workspace
rm(uk.oa.flow, test, test.merge)
# Save the results
setwd("~/1Projects/flows")
save.image("flows1.RData")
# Plot the results