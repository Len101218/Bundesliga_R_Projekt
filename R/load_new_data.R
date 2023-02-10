file <-here("Python/run.py")



if(!system("pyv=\"$(python -V)\" | echo $pyv| grep \"Python\"")){
  print("Python not installed!")
  return()
}
tryCatch({
import_from_path("LoadPageModule", path = here("Python"), FALSE)

source_python(file)

#' Title
#'
#' @param saison_von 
#' @param saison_bis 
#' @param liga 
#' @param output 
#' @param append 
#'
#' @return
#' @export
#'
#'@importFrom 
#'
#' @examples
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
  load_leagues_and_saisons(c("Bundesliga","Premier League","LaLiga","Ligue 1","Serie A"),2011,2022, "BigFive")
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
    res = system("tree . |grep .csv | grep -xv \"Csv/data.csv\" | grep -xv \"Csv/BigFive.csv\" ")
    if(res==0){
      system("find . -regex \"^.*\\.csv$\"|grep -v \"data.csv\" | grep -v \"BigFive.csv\" | xargs rm")
    }
  }
}





},finally = {})



