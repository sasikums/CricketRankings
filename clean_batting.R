
#setwd('C:/Users/Shree/Google Drive/Classes/cricket')

library(dplyr)
library(lubridate)

raw_innings_data <- read.csv('innings_data.csv')

# Seperate some varaibles out
raw_innings_data$country <-substr(raw_innings_data$Player,
                                  regexpr("(",as.character(raw_innings_data$Player),fixed=TRUE)+1,
                                  regexpr("(",as.character(raw_innings_data$Player),fixed=TRUE)+2)
raw_innings_data$player <- substr(raw_innings_data$Player,
                                  1,
                                  regexpr("(",as.character(raw_innings_data$Player),fixed=TRUE)-2)

raw_innings_data$match_type <- substr(raw_innings_data$Opposition,
       1,
       regexpr(" ",as.character(raw_innings_data$Opposition),fixed=TRUE)-1)

raw_innings_data$opposition <- substr(raw_innings_data$Opposition,
                                      regexpr("v",as.character(raw_innings_data$Opposition),fixed=TRUE)+2,
                                      nchar(as.character(raw_innings_data$Opposition)))

#cleaning runs for * for not out
raw_innings_data$not_out <- grepl("\\*",raw_innings_data$Runs)
raw_innings_data$out <- !(raw_innings_data$not_out)
raw_innings_data$runs=as.numeric(gsub("\\*","",raw_innings_data$Runs))

#remove cases of runs being na (DNB)

raw_innings_data<- raw_innings_data[!is.na(raw_innings_data$runs),]
# cycle through numeric variables stored as factors and convert to numeric
#num_names <- c('Mins','BF','X4s','X6s','SR','Inns')

for (i in 4:9) {
  raw_innings_data[,i] <- as.numeric(paste(raw_innings_data[,i]))
}

#convert start date to type date and create match_string (country+date) to uniquely identify a match
raw_innings_data$match_string <- paste(raw_innings_data$Start.Date,raw_innings_data$Ground)
raw_innings_data$innings_string <- paste(raw_innings_data$Start.Date,raw_innings_data$country,raw_innings_data$Inns)
raw_innings_data$start_date <- dmy(raw_innings_data$Start.Date)


clean_vars <- c('player','country','match_type','opposition',
                'runs','not_out','out','Mins','BF','X4s','X6s','SR','Inns',
                'match_string','innings_string','start_date')
clean_innings_data <- raw_innings_data[,clean_vars]

#assign a variable player_match_num to show nth match by player and match_type
clean_innings_data <- arrange(clean_innings_data,player,start_date)
clean_innings_data <- group_by(clean_innings_data,player,match_type)
clean_innings_data <- mutate(clean_innings_data,player_match_num=1:n())

write.csv(clean_innings_data,'cleaned_innings_data.csv',row.names=FALSE)



