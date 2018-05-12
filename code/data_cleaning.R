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

###########################
####  Clean up metrics ####
###########################

# everything to Kg
fabrics[, usage_kg := ifelse(fabrics_usage_unit ==  'Kg', fabrics_usage,
                             ifelse(fabrics_usage_unit == 'mt', fabrics_usage*1000, 
                                    NA))]

##############################
####  Feature Generation  ####
##############################
# how many sizes are there?
dimensions$nsizes <- stringr::str_count(dimensions$grading_tables_size_names, '-') + 1

# row for each size
long <- melt(dimensions, 
     id.vars = names(dimensions)[!grepl('grading_tables_size[1-9]', names(dimensions))],
     variable.name = 'which_size', value.name = 'measurement')

# drop zero size rows
long <- long[measurement > 0]

# trim size variable to just the number
long$which_size <- gsub('[[:alpha:]]|_', '', long$which_size)

# table for just the base size
base_sizes <- long[grading_tables_basic_size == which_size]

View(base_sizes)
