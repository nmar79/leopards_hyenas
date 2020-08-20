############################################################################
### CODE FOR CALIBRATING AND PLOTTING DEADSEA_ECO CARNIVORE RADIOCARB DATA##
### BY NIMROD, nmarom@marsci.haifa.ac.il                                  ##
### 29/03/2020 R vers 3.6.1; RStudio Vers 1.2.1335; rcarbon vers 1.3.0    ##
############################################################################

#load libraries

library(rcarbon)
library(tidyverse)

#import data (note: no lower hyphens!)

my.data <- read.csv("HnL_radiocarb.csv")

#remove empty rows and vars

my.data <- my.data[1:46,1:10] 

#create a vector of calibrated median dates to use in graphics
#sometimes doesn't work outright, exit r-studio and run again...

calibrated.dates <- 1:length(my.data$Genus)

for (i in seq_along(calibrated.dates)) {
temp.1 <- calibrate(x=my.data$Date[i], errors = my.data$Error[i])
calibrated.dates[i] <- temp.1$metadata$CRA
}

rm(temp.1)

#print to a file the calibrated dates in full

sink("calibrations.txt")
for (i in seq_along(calibrated.dates)) {
  print(summary(calibrate(x=my.data$Date[i], errors = my.data$Error[i])))
}
sink()

#build tibble of calibrated median dates by genus, alias "taxon"
TR.DT <- tibble(calBP = calibrated.dates, taxon = my.data$Genus, site = my.data$Site.Name)

#plot taxon by date, entire range
plot.1 <- ggplot(TR.DT, aes(y=calBP)) 
plot.11 <- plot.1 + geom_violin(aes(x=taxon, col = taxon, fill = taxon), scale = "width", alpha = 0.20) + scale_y_reverse() + geom_jitter(aes(x=taxon, shape = site, color = taxon)) + scale_shape_manual(values=c(1:12)) + theme_classic()
plot.11

#plot taxon by date, Holocene
TR.DT.HOL <- filter(TR.DT, calBP < 10000)
plot.2 <-ggplot(TR.DT.HOL, aes(y=calBP))
plot.2 + geom_violin(aes(x=taxon, col = taxon, fill = taxon), scale = "width", alpha = 0.20) + scale_y_reverse() + geom_jitter(aes(x=taxon, col = taxon, shape=site)) + scale_shape_manual(values=c(1:12)) + theme_classic()


####################
# SPDs
###################

by.genus <- split.data.frame(my.data, my.data$Genus)
hyenas <- calibrate(by.genus$Hyaena$Date, by.genus$Hyaena$Error)
leopards <- calibrate(by.genus$Panthera$Date, by.genus$Panthera$Error)

binsense(hyenas, by.genus$Hyaena$Site.Name,h=seq(0,100,20),calendar = 'BCAD', timeRange = c(49000, 100))
binsense(leopards, by.genus$Panthera$Site.Name,h=seq(0,100,20),calendar = 'BCAD', timeRange = c(49000, 100))

binsense(leopards, by.genus$Panthera$Site.Name,h=seq(0,100,20),calendar = 'BCAD', timeRange = c(10000, 100))
binsense(hyenas, by.genus$Hyaena$Site.Name,h=seq(0,100,20),calendar = 'BCAD', timeRange = c(10000, 100))

#permTest
calib.data <- calibrate(my.data$Date, my.data$Error)
bins <- binPrep(my.data$Genus, my.data$Date, h = 20)
res <- permTest(calib.data, marks = as.character(my.data$Genus), nsim = 1000, bins = bins, runm = 200, timeRange = c(8000, 100))
round(res$pValueList,4)
summary(res)
plot(res,focalm="Hyaena")

#probability by yearsBP
leop_prob <- cbind.data.frame(res[["observed"]][["Panthera"]][["calBP"]], res[["observed"]][["Panthera"]][["PrDens"]])
hyena_prob <- cbind.data.frame(res[["observed"]][["Hyaena"]][["calBP"]], res[["observed"]][["Hyaena"]][["PrDens"]])
write.csv(leop_prob,"leoprob.csv")
write.csv(hyena_prob,"hyprob.csv")
