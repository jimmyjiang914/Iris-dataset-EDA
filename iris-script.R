########################
# Loading Iris data set
########################

library(datasets) # load datasets package
data("iris") # Load in iris dataset

iris <- datasets::iris # Setting iris object to iris dataset

iris$Species # Return elements of this column in the dataframe as a list

species <- iris$Species # Assign species column as a variable


####################
#Summary statistics
####################

# Sepal Length, Sepal Width, Petal Length, Petal Width are features/observations
# that we will be able to train on and use to predict species

head(iris,5) # Obtain first 4 rows of iris data set
tail(iris,5) # Obtain last 4 rows of iris data set

summary(iris) # Obtain summary statistics
summary(iris$Sepal.Length) # Obtain summary statistic of particular column

sum(is.na(iris)) # Check sum of missing values in data set


library(skimr) # Provides a more detailed set of packages for obtaining summary 
# statistics than the native summary function

skim(iris) # Get detailed summary statistic

# Groups by species, then performs a skim
# %>% is a way to pass an object to the next object by way of a chain
# %>% is used frequently by dplyr
iris %>%
  dplyr::group_by(Species) %>%
  skim()
