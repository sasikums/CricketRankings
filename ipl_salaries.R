library(googlesheets)
library(dplyr)
setwd('C:/Users/Shree/Google Drive/Classes/cricket')
salary_doc <- gs_title('IPL_Salaries')

salaries <- get_via_lf(salary_doc, ws = "Sheet11") 
write.csv(salaries,'ipl_salaries_0815.csv')
annual_total <- salaries %>% group_by(year,team) %>% summarize(total_salary=sum(salary),
                                                          players=length(salary),
                                                          average_salary=total_salary/players)
arrange(filter(annual_total,year==2013),desc(average_salary))

salaries <- ungroup(salaries) 
salaries <- arrange(salaries,desc(total_salary))
head(salaries)
