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


library(WVPlots) # Import for PairPlot

PairPlot(iris, colnames(iris)[1:5],"Iris Pairplot") # A pairplot to visualize 
# possible meaningful clusters


library(plotly) # Import for interactive 3D plot

# Creating a 3D plot for every combination of 3 columns out of the 4 features 
# in the Iris data set
fig1 <- plot_ly(iris, x = ~Sepal.Length, y = ~Sepal.Width, z = ~Petal.Length, color=~Species)
fig1

fig2 <- plot_ly(iris, x = ~Sepal.Width, y = ~Petal.Length, z = ~Petal.Width, color=~Species)
fig2

fig3 <- plot_ly(iris, x = ~Petal.Length, y = ~Petal.Width, z = ~Sepal.Length, color=~Species)
fig3

fig4 <- plot_ly(iris, x = ~Petal.Width, y = ~Sepal.Length, z = ~Sepal.Width, color=~Species)
fig4



# Recreating the above 3D plot combinations with a loop.
# This can be very useful if we had more features to explore, manually creating 
# 3D plots can be very time consuming if we're exploring many combinations.
column_list <- colnames(iris)[1:4] # Obtain list of column names
column_comb <- combn(column_list, 3) # Obtain all combinations of 3 columns

fig <- NULL

# Creating a function for specifying a certain paste
fig.num <- function(n){
  return(paste("fig", n, sep="."))
}

# Loops through all combinations, and generates a 3D plotly plot for each.
# 3D plot objects are assigned to a naming scheme: fig.1, fig.2, fig.n
for (i in (1:4)) {
  feature1 <- column_comb[1,i]
  feature2 <- column_comb[2,i]
  feature3 <- column_comb[3,i]
  
  print(paste(feature1, feature2, feature3, sep=" "))

  fig <- plot_ly(iris, x = ~eval(parse(text=feature1)), y= ~eval(parse(text=feature2)), z = ~eval(parse(text=feature3)), color=~Species)
  fig <- fig %>% layout(scene = list(xaxis = list(title = feature1),
                                     yaxis = list(title = feature2),
                                     zaxis = list(title = feature3)))
  
  assign(fig.num(i), fig)

}

 
fig.1 # Return interactive 3D plot



# Modeling: From the visualizations and summary statistics above, we observe apparent clustering between petal and sepal features across species categories. 
# Possible models we can use are multinomial logistic regression, and K nearest neighbors


# No stratification is needed for train-test split because n across species is consistently 50.

split <- sort(sample(nrow(iris),nrow(iris)*.7))

train <- iris[split,]
test <- iris[-split,]

# K nearest neighbors
library(class)
library(MLmetrics)

output = knn(train[1:4], test[1:4], unlist(train[5],use.names=FALSE))
Accuracy(output, unlist(test[5], use.names = FALSE))
