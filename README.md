# leopards_hyenas
data and code for the analysis of radiocarbon dates of large carnivores from the Judean Desert

HnL_radiocarb.csv are radiocarbon date and specimen data.

calibrate_spd.R is a code that uses the 'rcarbon' package for calibrating the dates and for creating and permuting summed probability distributions.

#Bevan, A. and Crema, E.R. (2020) rcarbon v1.3.1: Methods for calibrating and analysing radiocarbon dates URL:
# https://CRAN.R-project.org/package=rcarbon

resampling_simulation.R is a probability simulation for drawing a bunch of leopard or hyena dates with the specific FAD/LAD from a random distribution of dates within a Holocene time frame.
