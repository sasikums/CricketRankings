## Script to download batting data from Cricinfos Statsguru
## Thanks to Ajay Ohri who has provided the method
## See: http://decisionstats.com/2013/04/25/using-r-for-cricket-analysis-rstats-ipl/


#setwd('C:/Users/Shree/Google Drive/Classes/cricket')
library(XML)
library(dplyr)

# download first page of data store in data frame innings_data
url="http://stats.espncricinfo.com/ci/engine/stats/index.html?class=11;template=results;type=batting;view=innings"
tables=readHTMLTable(url,stringsAsFactors = F)

innings_data <- tables$'Innings by innings list'

#loop to download other pages
for (page in 2:3518){
  url_string <- paste("http://stats.espncricinfo.com/ci/engine/stats/index.html?class=11;page=",
                   page,";template=results;type=batting;view=innings",sep="")
  tables=readHTMLTable(url_string,stringsAsFactors = F)
  inn_data <- tables$'Innings by innings list'
  innings_data <- bind_rows(innings_data,inn_data)
  print(paste("Completed: ",page))
  
  
}

write.csv(innings_data,'innings_data.csv')
