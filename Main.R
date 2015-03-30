# load XML-library
library(XML)
library(xlsx)
library(stringr)
library(plyr)
library(reshape2)
library(dplyr)

source("functions/getter.R")

#try(file.remove("GAEC2014.xlsx"))


#### Get 2014 Database
# Create Vector of country names
getterstrings <- list.files("data/2014/", pattern="*.html")
countries <- gsub(".html","",getterstrings)
countries <- countries[!countries=="FR"]


listOfDataFrames <- lapply(countries,FUN = function(x) getter(x,T))



df <- ldply(listOfDataFrames, data.frame)

#df[grepl("AZORES",df$titles,]

df15 <- data.frame(lapply(df, as.character), stringsAsFactors=FALSE)

#unique(df15$titles)

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

#unique(df15$titles)
df15$titles <- gsub("\n","",x = df15$titles)
# Replace Azores, Mainland and Madeira
df15[grepl("AZORES",df15$titles),2] <- "Portugal AZORES"
df15$titles <- gsub(" for AZORES","",df15$titles)

df15[grepl("MAINLAND",df15$titles) & df15$Country == "Portugal",2] <- "Portugal MAINLAND"
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

df2013 <- 
  df2013 %>%
  filter(titles=="1.1 Minimum soil cover")%>%
  select(Country,text) %>%
  rename(c("text"="X2013"))

df2014 <- 
  df2014 %>%
  filter(titles=="1.1 Minimum soil cover")%>%
  select(Country,text) %>%
  rename(c("text"="X2014"))

df_final <- merge(df2013,df2014,by = "Country")

#str(df2013)

# df <- rbind(df2013,df2014)
# 
# df <- 
#   df %>%
#   filter(titles=="1.1 Minimum soil cover")%>%
#   select(Year,Country,text)
# 
# 
# df3 <- dcast(data = df,formula = Country~Year)

write.xlsx(df_final,
           file = "HollaDieWaldfee.xlsx", 
           sheetName = "1.1 Minimum soil cover",
           row.names=F)
