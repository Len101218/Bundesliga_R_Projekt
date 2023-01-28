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

bigFive<-read_data_from_csv("C:/Users/HP/OneDrive/Dokumente/bundesliga_r_gruppe_38/CsvFiles/BigFive.csv") 

filter_data(data=bigFive,saison_von=2016,saison_bis=2018,ligen="Bundesliga")
