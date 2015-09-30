library(dplyr)
library(ggplot2)
library(scales)

rank_players_bat <- function(game_type="",
                             min_runs=0,
                             min_outs=0,
                             min_avg=0,
                             min_sr=0){
  
  table_data <- ungroup(filter(play_avg, runs>min_runs,
                       out>min_outs,
                       Average_Score>min_avg,
                       Average_SR>min_sr))
  
  if(game_type != ""){
    table_data <- table_data[table_data$match_type==game_type,]
  }
 
  #table_data <- table_data[order-(get(paste('table_data$',sort_order,sep="")))]
  table_data <- arrange(table_data,-Above_Score)
  
  table_data$MAS_Average <- table_data$Above_Score
  table_data$Raw_Average <- table_data$Average_Score
  table_data$MAS_SR <- table_data$Above_SR
  table_data$Raw_SR <- table_data$Average_SR
  table_data$MAS_Runs <- table_data$runs_above_avg
  table_data$Raw_Runs <- table_data$runs
  table_data$Comp_Innings <- table_data$out 
  
  rel_vars <- c('player','match_type','MAS_Average','Raw_Average',
                'MAS_SR','Raw_SR','MAS_Runs','Raw_Runs','Comp_Innings')
  
  #Restrict table to relevant variables
  table_data <- table_data[,rel_vars]
  
  #for (i in 3:7){
   # table_data[,i] <- format(table_data[,i],digits=2)
 # }
  
  return(table_data)
}
#rank_players_bat()
#function to calculate moving averages
mav <- function(x,n=20){stats::filter(x,rep(1/n,n), sides=2)}
plot_players <- function(player_list=c('Lara','Tendul'),game_type){
  
  
  
  chart_data <- filter(sum_innings_data,grepl(paste(player_list,collapse="|"),player))
  
  if (game_type!=""){
    chart_data <- filter(chart_data,match_type==game_type)
  }
  print(head(chart_data))
  chart_plot <- ggplot(data = chart_data, 
         aes(x = player_match_num, 
             y = mav(sr_above_avg,50), group=player, color = player,
         ))  +
    
    geom_line()  +
    xlab('Match Number') +
    ylab('MAS Score')+
    theme_bw() 
  return(chart_plot)
  
}


rank_innings_bat <- function(game_type="",
                             min_runs=0,
                             min_sr=0){
  
  table_data <- ungroup(filter(sum_innings_data, runs>min_runs,
                                            SR>min_sr))
  
  if(game_type != ""){
    table_data <- table_data[table_data$match_type==game_type,]
  }
  
  #table_data <- table_data[order-(get(paste('table_data$',sort_order,sep="")))]
  table_data <- arrange(table_data,desc(runs_above_avg))
  
  table_data$MAS_Runs <- table_data$runs_above_avg
  table_data$Raw_Runs <- table_data$runs
  table_data$MAS_SR <- table_data$sr_above_avg
  table_data$Raw_SR <- table_data$SR
  
  
  rel_vars <- c('player','match_type','MAS_Runs','Raw_Runs',
                'MAS_SR','Raw_SR')
  
  #Restrict table to relevant variables
  table_data <- table_data[,rel_vars]
  
  #for (i in 3:7){
  # table_data[,i] <- format(table_data[,i],digits=2)
  # }
  
  return(table_data)
}

