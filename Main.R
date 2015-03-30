# load XML-library
library(XML)
library(xlsx)
library(stringr)
library(plyr)
library(reshape2)
library(dplyr)

source("functions/getter.R")

try(file.remove("GAEC2014.xlsx"))


#### Get 2014 Database
# Create Vector of country names
getterstrings <- list.files("data/2014/", pattern="*.html")
countries <- gsub(".html","",getterstrings)
countries <- countries[!countries=="FR"]


listOfDataFrames <- lapply(countries,FUN = function(x) getter(x,T))


names(listOfDataFram)

df <- ldply(listOfDataFrames, data.frame)

#df[grepl("AZORES",df$titles,]

df

levels(df$titles)


df15 <- data.frame(lapply(df, as.character), stringsAsFactors=FALSE)

unique(df15$titles)

# Replace Azores, Mainland and Madeira
df15[grepl("AZORES",df15$titles),2] <- "Portugal AZORES"
df15$titles <- gsub(" for AZORES","",df15$titles)

df15[grepl("MAINLAND",df15$titles),2] <- "Portugal MAINLAND"
df15$titles <- gsub(" for MAINLAND","",df15$titles)

df15[grepl("MADEIRA",df15$titles),2] <- "Portugal MADEIRA"
df15$titles <- gsub(" for MADEIRA","",df15$titles)

df2014 <- df15



#### Get 2013 Database
# Create Vector of country names
getterstrings <- list.files("data/2013/", pattern="*.html")
countries <- gsub(".html","",getterstrings)

listOfDataFrames <- lapply(countries,FUN = function(x) getter(x,T,"2013"))


#names(listOfDataFrames)

df <- ldply(listOfDataFrames, data.frame)

#df[grepl("AZORES",df$titles,]



df15 <- data.frame(lapply(df, as.character), stringsAsFactors=FALSE)

unique(df15$titles)
df15$titles <- gsub("\n","",x = df15$titles)
# Replace Azores, Mainland and Madeira
df15[grepl("AZORES",df15$titles),2] <- "Portugal AZORES"
df15$titles <- gsub(" for AZORES","",df15$titles)

#df15[grepl("MAINLAND",df15$titles),2] <- "Portugal MAINLAND"
#df15$titles <- gsub(" for MAINLAND","",df15$titles)

df15[grepl("MADEIRA",df15$titles),2] <- "Portugal MADEIRA"
df15$titles <- gsub(" for MADEIRA","",df15$titles)

# Replace GUADELOUPE, GUYANE, MAINLAND, MARTINIQUE, REUNION
df15[grepl("GUADELOUPE",df15$titles),2] <- "France GUADELOUPE"
df15$titles <- gsub(" for GUADELOUPE","",df15$titles)

df15[grepl("GUYANE",df15$titles),2] <- "France GUYANE"
df15$titles <- gsub(" for GUYANE","",df15$titles)

df15[grepl("MAINLAND",df15$titles),2] <- "France MAINLAND"
df15$titles <- gsub(" for MAINLAND","",df15$titles)

df15[grepl("REUNION",df15$titles),2] <- "France REUNION"
df15$titles <- gsub(" for REUNION","",df15$titles)

df15[grepl("MARTINIQUE",df15$titles),2] <- "France MARTINIQUE"
df15$titles <- gsub(" for MARTINIQUE","",df15$titles)



df2013 <- df15

str(df2013)

df <- rbind(df2013,df2014)

df <- 
  df %>%
  filter(titles=="1.1 Minimum soil cover")%>%
  select(Year,Country,text)

unique(df$titles)
df3 <- dcast(data = df,formula = Country~Year)

write.xlsx(df3,
           file = "HollaDieWaldfee.xlsx", 
           sheetName = "1.1 Minimum soil cover",
           row.names=F)
