
# load libraries ----------------------------------------------------------

library(tidyverse)
library(rvest)
library(openxlsx)


# set working directory ---------------------------------------------------

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

df<-read.csv("list_digits.csv", colClasses='character',header = FALSE)
colnames(df)<-"digits"
digits<-as.character(df$digits)

# web scraping to extract expiration date ---------------------------------

df_total = data.frame()

for (i in 1:length(digits)){
  
web_site <- read_html(str_c("https://etherscan.io/enslookup-search?search=",digits[i],".eth"))

#inspect the website and check the tree structure 
#to identify where the text you want to extract sits 

exp_date <- web_site %>% 
  html_nodes("div.card-body")%>% #calls nodes based on css class
  html_nodes("span.mr-2")%>% #calls nodes based on css class
  html_text() #extracts raw text

df_output<- data.frame(digits[i],exp_date)
df_total<- rbind(df_total,df_output)
print(df_total)

Sys.sleep(1)
}

# write results in a csv file ---------------------------------------------

write.xlsx(df_total,file = "results.csv")
 