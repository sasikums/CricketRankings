

library(shiny)
source('helper_functions.R')
#source('clean_batting.R')
source('avg_calcs.r')

shinyUI(fluidPage(
  
  # Application title
  titlePanel(h1("Match Adjusted Statistics (MAS)", align='center')),
  
  
  sidebarLayout(
  sidebarPanel(
    tabsetPanel(
      tabPanel ("All Time Career Rankings",
          # Radio Buttons to Select Match Type
          radioButtons("match_type","Match Type:",
                       c( "All" ="",
                         "Test Match" ="Test",
                         "One Day International"="ODI",
                         "Twenty20"="T20I"
                         )),
          #Create Line Break
          br(),
          #Sliders to allow user to set min runs, innings, etc.
          sliderInput("min_runs","Minimum Runs (Unadj.)",
                      value=500,
                      min=0,
                      max=10000),
          
         
          sliderInput("min_outs","Minimum Innings",
                      value=40,
                      min=1,
                      max=1000),
          
          sliderInput("min_avg","Minimum Average (Unadj.)",
                      value=20,
                      min=1,
                      max=100),
          
          sliderInput("min_sr","Minimum Strike Rate (Unadj.)",
                      value=40,
                      min=0,
                      max=1000)
      ),
      #end All Time Rankings Tab
      
      tabPanel("Player Comparison",
               
               radioButtons("player_match_type","Match Type:",
                            c( "Test Match" ="Test",
                               "One Day International"="ODI",
                               "Twenty20"="T20I"
                            )),
               
               selectInput('player_comp',"Select Players to Compare",
                           unique(as.character(play_avg$player)),
                           multiple=TRUE,selectize=TRUE),
               p("You have selected:"),
               verbatimTextOutput('player_list'),
               actionButton("draw_chart", "Draw Chart")
               
               ),
      #end Player Comparison Tab
      tabPanel("Methodology",
               h2 ("MAS Methodology"),
               p('Match adjusted statistics allow us to see how much BETTER a player was
                 than the ones he played with. By standardizing player performances by 
                 match conditions, we can adjust for differences variables like pitch
                 conditions or bowling strength and easily compare players of different
                 eras.'),
               br(),
               p('Standardization is achieved by adjusting each perfomance by a player by
                 the average performance for all players in the match. Imagine a ODI in
                 which Team 1 scores 249/8 while Team 2 scored 251/2, i.e. 500 runs for 10 wickets.
                 The average score per wicket was 50. Player X who scored 80 in this game
                 would have an MAS score of 30 (80-50) while Player Y who scored 60
                 would have a MAS score of 10 (60-50). The losing team batsmen would on average have
                 MAS scores of -19.'),
               br(),
               p('Now if in the next game the pitch is seaming and the scores
                 are 149/10 and 151/9, i.e, ~16 runs per wicket. Lets say Player X scores 80 again.
                 That would give him a MAS score of 64, the 80 in the
                 close game was higher than the 80 in the easy victory.'),
               br(),
               p('So MAS is calculated by adjusting all performances by a player in
                 their career by match conditions. This allows us to see how good
                 a player was relative to the conditions/time that they played in.')
               )
      #end Methodology tab
      
  )
  #end of tabPanel
    ),
  #end of sidebarpanel
  
  mainPanel(
    tabsetPanel(
      tabPanel("Rankings Table",
        dataTableOutput('table')
      ),
      #end of rankings table tab
      tabPanel("Player Comparsion Chart",
                     plotOutput('player_chart')
      )
      #end of rankings table tab
  )
  #end of tabset
  )
  #end of main panel
  )#end of layout
  ))