#setwd('C:/Users/Shree/Google Drive/Classes/cricket')

library(dplyr)
library(ggplot2)
library(scales)

clean_innings_data <- read.csv('cleaned_innings_data.csv')
sum_innings_data <- group_by(clean_innings_data,match_string)


sum_innings_data <- mutate(sum_innings_data,
                           inn_outs=sum(out),inn_runs=sum(runs),
                           innings_avg=sum(runs)/sum(out),
                           innings_sr =  100*sum(runs)/sum(BF))

# set innings with 0 outs to an average of 0
sum_innings_data$innings_avg[sum_innings_data$innings_avg==Inf] <- 0

# set SR of NA to 0
sum_innings_data$SR[is.na(sum_innings_data$SR)] <- 0


sum_innings_data <- mutate(sum_innings_data,runs_above_avg=runs-innings_avg,
                           runs_rel_avg=runs/innings_avg,
                           sr_above_avg=SR-innings_sr,
                           sr_rel_avg=SR/innings_sr)
# set relative average for innings with 0 innings_avg to 1
sum_innings_data$runs_rel_avg[sum_innings_data$runs_rel_avg==Inf] <- 1

sum_innings_data <- group_by(sum_innings_data,player,match_type)

play_aggr <- summarize(sum_innings_data,runs=sum(runs,na.rm=TRUE),
          out=sum(out,na.rm=TRUE),
          not_out=sum(not_out,na.rm=TRUE),
          balls = sum(BF,na.rm=TRUE),
          runs_above_avg=sum(runs_above_avg,na.rm=TRUE),
          run_rel_avg=sum(runs_rel_avg*runs,na.rm=TRUE),
          sr_above_avg=sum(sr_above_avg*runs,na.rm=TRUE),
          sr_rel_avg=sum(sr_rel_avg*runs,na.rm=TRUE))


play_avg <- mutate(play_aggr, 
                   Average_Score=runs/out,
                   Average_SR = 100*(runs/balls),
                   Above_Score=runs_above_avg/out,
                   Rel_Score=run_rel_avg/(runs*out),
                   Above_SR=sr_above_avg/(runs*out),
                   Rel_SR=sr_rel_avg/(runs*out))

play_avg <- play_avg[,c("player", "match_type","Average_Score","Average_SR",
                        "Above_Score","Rel_Score", "Above_SR","Rel_SR",
                "runs","runs_above_avg","run_rel_avg","out" )]

play_avg <-play_avg[order(-(play_avg$Above_Score)),]

