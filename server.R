
#helper function to display batting rankings
#source('helper_functions.R')
#source('clean_batting.R')
#source('avg_calcs.R')

shinyServer(function(input, output) {
  
  
  output$player_list <- renderPrint(input$player_comp)
  
  
  output$player_chart <- renderPlot({
    input$draw_chart
    plot_players(input$player_comp,input$player_match_type)})
  
  output$table <- renderDataTable(rank_players_bat(input$match_type,
                                               input$min_runs,
                                               input$min_outs,
                                               input$min_avg,
                                               input$min_sr)
                                               ,options = list(orderClasses = TRUE))
  
  
})