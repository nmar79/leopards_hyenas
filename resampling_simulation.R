#set parameters: 
#length of study period (date_range) 
#minimum number of animals (MNI; leopard = 5, hyena = 11)
#length of years from which there is no data 
#(absence_range; leopard = 3200, hyena = 6827)

MAX_RANGE <- 10000
HYENA_FAD <- 3173
LEOPARD_LAD <- 3200
date_range <- 1:10000
MNI_hyena <- 11
MNI_leopard <- 5
absence_range_hyena <- 6783
absence_range_leopard <- 3200
presence_range_hyena <- MAX_RANGE - absence_range_hyena
presence_range_leopard <- MAX_RANGE - absence_range_leopard
range_subsamp_hyena <- 1:10000
range_subsamp_leopard <- 1:10000


#subsample with replacement from the range, and determine the
#range of presence period

for (i in date_range){
  subsamp <- sample(date_range, MNI_hyena)
  range_subsamp_hyena[i] <- max(subsamp)
}

for (i in date_range){
  subsamp <- sample(date_range, MNI_leopard)
  range_subsamp_leopard[i] <- min(subsamp)
}

#plot the ranges
#calculate the proportion of the absence range from the total 
#resamples (p)

subset_hyena <- range_subsamp_hyena[range_subsamp_hyena < HYENA_FAD] 
length(subset_hyena)

subset_leopard <- range_subsamp_leopard[range_subsamp_leopard > LEOPARD_LAD] 
length(subset_leopard)

p_hyena <- length(subset_hyena)/MAX_RANGE
p_leopard <- length(subset_leopard)/MAX_RANGE

hist(range_subsamp_hyena, xlim = c(0,10000), col = "green", main = "Hyena", xlab = c("Range for 11 samples, 10000 repeats, P = ", p_hyena))

hist(range_subsamp_leopard, xlim = c(0,10000), col = "yellow", main = "Leopard", xlab = c("Range for 5 samples, 10000 repeats, P = ", p_leopard))

