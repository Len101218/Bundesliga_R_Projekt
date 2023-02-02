#Check ob alle benötigten Packages bereits installiert wurden, falls nicht werden diese installiert.
if(!"tidyverse" %in% rownames(installed.packages())){
  install.packages("tidyverse")
}
if(!"devtools" %in% rownames(installed.packages())){
  install.packages("devtools",repos = "http://cran.us.r-project.org")
}
if(!"here" %in% rownames(installed.packages())){
  install.packages("here")
}


library(here)
library(tidyverse)
library(usethis)
library(devtools)


library(here)

if(!exists("filter_data", mode="function")) source(here("R/filter.R"))

bigFive<-read_data_from_csv(here("Csv/BigFive.csv")) 


#result<-categorize_data(bigFive)
# result

#plot_last10years(bigFive,"FC Schalke 04",categoric=TRUE)

#bigFiveOneSeason<-filter_data(data=bigFive,saison_bis=get_lastfullseason(),saison_von=get_lastfullseason())

#plot_data(bigFive)

#plot_oneleague(data=bigFive,"Premier League")

frame_performance(bigFive,-2)