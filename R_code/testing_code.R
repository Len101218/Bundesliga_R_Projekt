#Check ob alle benötigten Packages bereits installiert wurden, falls nicht werden diese installiert.
if("tidyverse" %in% rownames(installed.packages())== FALSE){
  install.packages("tidyverse")
}
if("devtools" %in% rownames(installed.packages())== FALSE){
  install.packages("devtools")
}
if("here" %in% rownames(installed.packages())== FALSE){
  install.packages("here")
}

library(here)
library(tidyverse)
library(usethis)
library(devtools)


library(here)

file <-here("CsvFiles/BigFive.csv")

bigFive<-read_data_from_csv(file) 

filter_data(data=bigFive,saison_von=2016,saison_bis=2018,ligen="Bundesliga")
