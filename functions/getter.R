# read the html-document that we want to parse
# Potentially this could be automated 



getter <- function (name,appendval=F,year=2014) {
  require(XML)
  require(xlsx)
  require(stringr)
  path <- paste0("data/",year,"/",name,".html")
  doc.html <- htmlTreeParse(path,
                            useInternalNodes = T)
  
  
  # get Country name
  CnameXML <-  xpathSApply(doc.html, "//h1")
  Cname <- sapply(CnameXML, xmlValue)
  
  
  Country <- str_trim(gsub("Description of Good Agriculture and Environmental condition for","",Cname[1]))
  Year  <- str_trim(gsub("Campaign year:","",Cname[2]))
  
  
  
  
  # get all "h6" headers
  titlesXML <- xpathSApply(doc.html, "//h6")
  titles <- sapply(titlesXML, xmlValue)
  
  
  # get all "text" paragraphs
  textXML <- xpathSApply(doc.html, "//td[@class='text']")
  text <- sapply(textXML, xmlValue)
  
  # create dataframe
  df <- data.frame(Year=Year,Country=Country,titles,text)
  
  # Write the results to xlsx file
  
  
  #write.xlsx(df,
  #           file = paste0("GAEC", Year, ".xlsx"), 
  #           sheetName = Country,
  #           row.names=F,
  #           append=appendval)
  
  return(df)
}
