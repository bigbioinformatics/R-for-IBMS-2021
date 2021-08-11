#### Week Three Lecture Notes #####

## Getting started with Tidyverse: Readr and Dplyr ##

# Download tidyverse and ggpubr
install.packages("tidyverse")
install.packages("ggpubr")

# Load the tidyverse package
library(tidyverse)
library(ggpubr)

# Grab the titanic data
tidy_titanic <- read_csv('titanic.csv')

# Challenge: What is the class of tidy_titanic?

# Filter the titanic data for passengers > age 12
tidy_titanic <- filter(tidy_titanic, Age > 12) 

# Challenge: How would I use the above code to modify tidy_titanic? 

# Convert to character labels
tidy_titanic <- mutate(tidy_titanic, 
                       Survived = ifelse(Survived == 1, "Yes", "No"))

# Select the "Survived" and "Sex" columns
tidy_titanic <- select(tidy_titanic, Survived, Sex)

# Group by Sex, then Survival
tidy_titanic <- group_by(tidy_titanic, Sex, Survived)

# Challenge: What does the [4] refer to in groups?

# Summarise
tidy_tally <- summarise(tidy_titanic, n_sex_srv = n())

# Challenge: Why cannot we not directly compare the # of men and # of women surviving?

# Review... what does sum() do?
my_nums <- c(1, 5, 8)
sum(my_nums)  # sums
(my_nums / sum(my_nums)) * 100  # percentages

# We use mutate to get the number of each sex surviving
tidy_tally <- mutate(tidy_tally, 
                     pct_sex_srv = n_sex_srv/sum(n_sex_srv) * 100)

# Challenge: How would you filter tidy_tally to include only the percent surviving?
pct_surv <- "< CODE GOES HERE >"


## Doing things the "Tidy" Way ##

# Save the result as a variable
pct_surv <- read_csv('titanic.csv') %>%
  filter(Age > 12) %>%
  mutate(Survived = ifelse(Survived == 1, "Yes", "No")) %>%
  select(Survived, Sex) %>%
  group_by(Sex, Survived) %>%
  summarise(n_sex_srv = n()) %>%
  mutate(pct_sex_srv = n_sex_srv/sum(n_sex_srv) * 100) %>%
  filter(Survived == "Yes")
pct_surv


## Hands-on activity One ##
View(mtcars)

# Filter mtcars for cars where "cyl" is 6 or more
mtcars %>%
  "< CODE GOES HERE >"

# Select the "disp" and "wt" and "mpg" columns from mtcars
mtcars %>%
  "< CODE GOES HERE >"

# Group mtcars by number of cylinders, "cyl"
mtcars %>%
  "< CODE GOES HERE >"

# Add up the number of cars in each cylinder group
mtcars %>%
  "< CODE GOES HERE >"

# Calculate the median weight, "wt", in each cylinder group
mtcars %>%
  "< CODE GOES HERE >"

# Create a new column which contains the ratio of horse power, "hp", to "mpg"
# AND only keep the cars with "wt" greater than 3
mtcars %>%
  "< CODE GOES HERE >"

# Group mtcars by "gear" and then find the average "hp" to "wt" ratio
mtcars %>%
  "< CODE GOES HERE >"


## Getting started with Tidyverse: GGPlot2 ##
pct_surv

# Set the data and aesthetic layer
plt <- ggplot(data = pct_surv, 
              mapping = aes(x = Sex,
                            y = pct_sex_srv,
                            fill = Sex))

# Set the geometry layer
plt <- plt + geom_col()

# Challenge: How could I change the above code to plot the Number Sex Surviving?

# Add y-axis label
plt <- plt + ylab("Percentage Surviving")

# Remove the x label
plt <- plt + xlab(NULL)

# Add title
plt <- plt + labs(title = "Effect of Sex on Survival aboard the Titanic")

# Change the theme
plt <- plt + theme_classic(base_size = 15)

# Remove the legend
plt <- plt + theme(legend.position = "none")

# Set limits and expand on y axis
plt <- plt + scale_y_continuous(limits = c(0, 100), expand = c(0, 0))

# Change the axis labels to capitalized
plt <- plt + scale_x_discrete(labels = c("Female", "Male"))

# Challenge: How can we perform the above operations in a pipe style?


## Hands-on activity Two ##

View(iris)

# Group iris by "Species" 
iris %>%
  "< CODE GOES HERE >"
  
# Find the average "Sepal.length" to "Petal.length" ratio per species
iris %>%
  "< CODE GOES HERE >"


# Pipe this into ggplot2. Set x axis to "Species", y to the ratio column
iris %>%
  "< CODE GOES HERE >"

# Add the barplot geometry
iris %>%
  "< CODE GOES HERE >"
  
# Set y axis label to "Average of Sepal to Petal length (cm)"
iris %>%
  "< CODE GOES HERE >"

# Color the plot by species
iris %>%
  "< CODE GOES HERE >"

# Set the title to "Iris flower analysis"
iris %>%
  "< CODE GOES HERE >"

## Getting started with Tidyverse: Readr and Dplyr Continued... ##

# Set x axis to Survived and y to Fare
plt <- read_csv('titanic.csv') %>%
  filter(Age > 12) %>%
  mutate(Survived = ifelse(Survived == 1, "Yes", "No")) %>%
  ggplot(mapping = aes(x = Survived, y = Fare)) +
  geom_boxplot()

# Log scale for y-axis
plt <- plt + scale_y_log10()

# Challenge: Why did we get a warning?

# Replot
plt <- read_csv('titanic.csv') %>%
  filter(Age > 12) %>%
  filter(Fare > 0) %>%
  mutate(Survived = ifelse(Survived == 1, "Yes", "No")) %>%
  ggplot(mapping = aes(x = Survived, y = Fare)) +
  geom_boxplot() +
  scale_y_log10()

# Test difference of means using wilcoxon rank sum test
plt <- plt + stat_compare_means()

# Clean up the pval a little and make it a pipe
read_csv('titanic.csv') %>%
  filter(Age > 12) %>%
  filter(Fare > 0) %>%
  mutate(Survived = ifelse(Survived == 1, "Yes", "No")) %>%
  ggplot(mapping = aes(x = Survived, y = Fare)) +
  geom_boxplot() +
  scale_y_log10() +
  stat_compare_means(comparisons = list(c("Yes", "No")),
                     label = "p.signif")


# Clean up the overall appearance a little and save it
plt <- read_csv('titanic.csv') %>%
  filter(Age > 12) %>%
  filter(Fare > 0) %>%
  mutate(Survived = ifelse(Survived == 1, "Yes", "No")) %>%
  ggplot(mapping = aes(x = Survived, y = Fare, fill=Survived)) +
  geom_boxplot() +
  scale_y_log10() +
  stat_compare_means(comparisons = list(c("Yes", "No")),
                     label = "p.signif") +
  ylab("Ticket Price (log scale)") +
  labs(title = "Fare and Survival aboard the Titanic") +
  theme_bw(base_size = 17) +
  theme(legend.position = "none") +
  scale_fill_manual(values = c("goldenrod", "skyblue")) 

ggsave(plt, filename = "fare_and_survival.png", height = 5, width = 6)

