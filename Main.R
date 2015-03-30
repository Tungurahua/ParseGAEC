# load XML-library
library(XML)
library(xlsx)
library(stringr)
library(plyr)
library(reshape2)


source("functions/getter.R")

try(file.remove("GAEC2014.xlsx"))
# Create Vector of country names
getterstrings <- list.files("data/2014/", pattern="*.html")
countries <- gsub(".html","",getterstrings)

listOfDataFrames <- lapply(countries,FUN = function(x) getter(x,T))

df <- ldply(listOfDataFrames, data.frame)

dcast(data = df,formula = Country~titles,value.var = text)
