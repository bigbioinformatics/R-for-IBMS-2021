### Module #4: Analyzing CoV genomes ###

### STEP #1: Download the 'sars2pack' library
if (! "sars2pack" %in% rownames(installed.packages())) {
  install.packages('BiocManager')
  install.packages("remotes")
  BiocManager::install('seandavi/sars2pack')
}

# Load the library
library(sars2pack)
library(tidyverse)

### STEP #2: Select your datasets and view them

# See the available datasets
ad <- available_datasets()
View(ad)

# load the data
nyt <- nytimes_state_data()
dmd <- descartes_mobility_data()

# View the data
glimpse(nyt)
glimpse(dmd)

### STEP #4: Answer questions

## Question #1: What state has the greatest total number of cases?

## Question #2: What state has the greatest total mobility?

## Question #3: What is the relationship between mobility and cases over time?
## Hint: For this question, you will need to perform a bind_rows().
nyt_mod <- select(nyt, date, val=count) %>% mutate(type = "count")
dmd_mod <- select(dmd, date, val=m50) %>% mutate(type = "m50")

# Hint: You will need to scale the data as well and perform some other manipulation
bind_rows(
  nyt_mod,
  dmd_mod
)


