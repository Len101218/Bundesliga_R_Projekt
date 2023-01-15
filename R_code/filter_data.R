
#Check ob alle benötigten Packages bereits installiert wurden, falls nicht werden diese installiert.
if("tidyverse" %in% rownames(installed.packages())== FALSE){
  install.packages("tidyverse")
}
if("devtools" %in% rownames(installed.packages())== FALSE){
  install.packages("devtools")
}
library(tidyverse)
library(devtools)



data <- read_csv("C:/Users/HP/OneDrive/Desktop/EWS_projekt_Datensatz_1.csv")

#' filter_data
#' 
#' Filter data by parameter. You have to put in at least the season you want to start extracting data and one team or league you want to gather data from!
#'
#' @param data database you are looking through 
#' @param saison_von The first season from which you want to extract the data. If you want to extract data from the 2018/19 season set 'saison_von = 2018'.
#' @param saison_bis The last season from which you want to extract the data. It's set to 2023 /the actual year by default.
#' If you want to extract data from the 2021/22 season set 'saison_bis = 2021'.
#' @param teams A character-vector with the teams you're searching for. optional
#' @param ligen A charcter-vector with the leagues you're searching for. optional 
#' @param platzierungen A integer-vector with the end-season-placements optional
#' @param punkte A integer-vector with the points you're searching for. optional
#' @param marktwert_von A integer with the min-marketvalue you're searching for. 
#' @param marktwert_bis A integer with the max-marketvalue you're searching for. optional
#'
#' @return database
#' @export
#'
#' @examples
get_data <- function(data,saison_von,saison_bis=2022,teams="ALLTEAMS",ligen="ALLLEAGUES",platzierungen="ALLPLACES", punkte="ALLPOINTS",marktwert_von="ALLVALUESFROM",marktwer_bis="ALLVALUESTO"){#TODO: use current year
  
  
  
  #falschen/schlechten Input abfangen
  if(teams=="ALLTEAMS"&ligen=="ALLLEAGUES"){
    return("FEHLER: Es muss mindestens ein Team oder eine Liga übergeben werden!")
  }
  
  if(typeof(saison_von)!="integer"|typeof(saison_bis)!="integer"|typeof(teams)!="character"|typeof(ligen)!="character"|
    (platzierungen!="ALLPLACES"|typeof(platzierungen)!="integer")|(punkte!="ALLPOINTS"|typeof(punkte)!="integer")|
    (typeof(marktwert_von)!="integer"|marktwert!="ALLVALUESFROM")|(typeof(marktwert_bis)!="integer"|marktwert!="ALLVALUESTO")){
    return("Ein/Mehrere Paramter wurden falsch übergeben!")
  }
  
  #Filtern
  data %>%
    filter(Saison>=saison_von,Saison<=saison_bis)
  if(teams!="ALLTEAMS"){
    data %>%
      filter(Team %in% teams)
  }
  if(ligen!="ALLLEAGUES"){
    data %>%
      filter(Liga %in% ligen)
  }
  if(platzierungen!="ALLPLACES"){
    data %>%
      filter(Platzierung %in% platzierungen)
  }
  if(punkte!="ALLPOINTS"){
    data %>%
      filter(Punkte %in% punkte)
  }
  if(marktwert!="ALLVALUES"){
    data %>%
      filter(Marktwert %in% marktwert)
  }
}
?get_data




