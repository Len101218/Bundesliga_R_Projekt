if("reticulate" %in% rownames(installed.packages())== FALSE){
  install.packages("reticulate")
}
if("here" %in% rownames(installed.packages())== FALSE){
  install.packages("here")
}

library(reticulate)
library(here)

file <-here("python_Code/run.py")

import_from_path("LoadPageModule", path = here("python_Code"), FALSE)
source_python(file)

load_data_from_website <- function(saison,liga,output="data",append = TRUE){
  if(!is.numeric(saison)||!is.character(liga)||!is.character(output)||!is.logical(append))stop("One or more arguments are wrong: See help!")
  arguments <- c("-s",saison,"-l",liga,"-o", output)
  if (append){
    arguments = append(arguments,"-a")
  }
  main(arguments)
}

load_leagues_and_saisons <- function(leagues,saison_von,saison_bis,output="data"){
  for(liga in leagues){
    for(saison in saison_von:saison_bis){
      load_data_from_website(saison,liga,output,TRUE)
    }
  }
}

load_big_five <- function(){
  remove_file("BigFive.csv")
  system("echo \"Liga,Saison,Team,Marktwert,Platzierung,Punkte\"> \"BigFive.csv\"")
  load_leagues_and_saisons(c("Bundesliga","Premier League","LaLiga","Ligue 1","Serie A"),2011,2021, "BigFive")
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
    system("ls |grep .csv | grep -xv \"data.csv\" | xargs rm")
    }
  }
}

