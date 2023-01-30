if("reticulate" %in% rownames(installed.packages())== FALSE){
  install.packages("reticulate")
}
if("here" %in% rownames(installed.packages())== FALSE){
  install.packages("here")
}

library(reticulate)
library(here)

file <-here("Python/run.py")

import_from_path("LoadPageModule", path = here("Python"), FALSE)

source_python(file)

load_data_from_website <- function(saison_von,saison_bis,liga,output="data",append = TRUE){
  if(!is.numeric(saison_von)||!is.numeric(saison_bis)||!is.character(liga)||!is.character(output)||!is.logical(append))stop("One or more arguments are wrong: See help!")
  arguments <- c("-v",saison_von,"-b",saison_bis,"-l",liga,"-o", paste("Csv/",output))
  if (append){
    arguments = append(arguments,"-a")
  }
  load(arguments)
}

load_leagues_and_saisons <- function(leagues,saison_von,saison_bis,output="data"){
  for(liga in leagues){
    load_data_from_website(saison_von,saison_bis,liga,output,TRUE)
  }
}

load_big_five <- function(){
  remove_file("Csv/BigFive.csv")
  system("echo \"Liga,Saison,Team,Marktwert,Platzierung,Punkte\"> \"Csv/BigFive.csv\"")
  load_leagues_and_saisons(c("Bundesliga","Premier League","LaLiga","Ligue 1","Serie A"),2011,2022, "Csv/BigFive")
}


remove_file <- function(file){
  if(system(paste("ls |grep ",file))==0)
    system(paste("rm ",file))
}

remove_all_csv_Files <- function(data=FALSE){
  if(!is.logical(data))stop("One or more arguments are wrong: See help!")
  if(data){
    system("rm *.csv")
  }
  else{
    res = system("ls |grep .csv | grep -xv \"data.csv\"")
    if(res==0){
    system("ls Csv |grep .csv | grep -xv \"data.csv\" | xargs rm")
    }
  }
}

