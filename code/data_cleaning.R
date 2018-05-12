library(tidyverse)
library(data.table)

####################
####  read in   ####
####################

styles  <- fread('data/Styles.txt', sep = '\t')
fabrics <- fread('data/StyleFabrics.txt', sep = '\t')

# carriage returns in end of some lines in dimensions file
dimensions <- fread('data/StyleDimensions.txt', sep = '\t')

sapply(list(styles, fabrics, dimensions), names)

# clean up names
clean_names <- function(x) {
  x <- gsub(' ', '_', x)
  x <- gsub('\\[|\\]', '', x)
  x <- tolower(x)

  x
}

names(styles)     <- clean_names(names(styles))
names(fabrics)    <- clean_names(names(fabrics))
names(dimensions) <- clean_names(names(dimensions))

######################################
####  Create table for modelling  ####
######################################

# everything to Kg
fabrics[, usage_kg := ifelse(fabrics_usage_unit ==  'Kg', fabrics_usage,
                             ifelse(fabrics_usage_unit == 'mt', fabrics_usage*1000, 
                                    NA))]




