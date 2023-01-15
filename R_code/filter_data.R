if("tidyverse" %in% rownames(installed.packages())== FALSE){
  install.packages("tidyverse")
}

library(tidyverse)
data <- read_csv("C:/Users/HP/OneDrive/Desktop/EWS_projekt_Datensatz_1.csv")

get_data <- function(saison_von,saison_bis=2022,teams="ALLTEAMS",ligen="ALLLEAGUES",platzierungen="ALLPLACES", punkte="ALLPOINTS",marktwert="ALLVALUES"){#TODO: use current year

  #falschen/schlechten Input abfangen
  if(teams=="ALLTEAMS"&ligen=="ALLLEAGUES"){
    return("FEHLER: Es muss mindestens ein Team oder eine Liga übergeben werden!")
  }
  
  if(typeof(saison_von)!="integer"|typeof(saison_bis)!="integer"|typeof(teams)!="character"|typeof(ligen)!="character"|
    (platzierungen!="ALLPLACES"|typeof(platzierungen)!="integer")|(punkte!="ALLPOINTS"|typeof(punkte)!="integer")|(typeof(marktwert)!="integer"|marktwert!="ALLVALUES")){
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

get_data(2021, team= "FC Augsburg",ligen=1)



