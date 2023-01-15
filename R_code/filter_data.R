
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



read_data_from_csv <- function(relPath){
  if(!is.character(path))stop("One or more arguments are wrong: See help!")
  absPath <- here(relPath) 
  data <- read_csv(absPath)
}


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
filter_data <- function(data,saison_von,saison_bis=2022,teams="ALLTEAMS",ligen="ALLLEAGUES",platzierungen="ALLPLACES", punkte="ALLPOINTS",marktwert_von="ALLVALUESFROM",marktwer_bis="ALLVALUESTO"){#TODO: use current year
  
  
  
  #falschen/schlechten Input abfangen
  if(teams=="ALLTEAMS"&ligen=="ALLLEAGUES"){
    return("FEHLER: Es muss mindestens ein Team oder eine Liga übergeben werden!")
  }
  
  if(!is.numeric(saison_von) || !is.numeric(saison_bis) || !is.character(teams) || !is.character(ligen) ||!(platzierungen=="ALLPLACES" || is.numerical(platzierungen)) || !(punkte=="ALLPOINTS"||is.numerical(punkte)) ||!(marktwert_von=="ALLVALUESFROM"||is.numerical(marktwert_von))|!(is.numerical(marktwer_bis)||marktwert_bis=="ALLVALUESTO")){
    return("Ein/Mehrere Parameter wurden falsch übergeben!")
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




