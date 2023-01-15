if("reticulate" %in% rownames(installed.packages())== FALSE){
  install.packages("reticulate")
}
if("here" %in% rownames(installed.packages())== FALSE){
  install.packages("here")
}

library(reticulate)
library(here)

file <-here("ews.py")

source_python(file)

load_data_from_website <- function(saison,liga,kuerzel,output="data",append = TRUE){
  if(!is.numeric(saison)||!is.character(liga)||!is.character(kuerzel)||!is.character(output)||!is.logical(append))stop("One or more arguments are wrong: See help!")
  if (append){
    arguments <- c("-s",saison,"-l",liga,"-k",kuerzel,"-o", output,"--append")
  }
  else {
    arguments <- c("-s",saison,"-l",liga,"-k",kuerzel,"-o", output)
  }
  main(arguments)
}


remove_all_csv_Files <- function(data=FALSE){
  if(!is.logical(data))stop("One or more arguments are wrong: See help!")
  if(data){
    system("rm *.csv")
  }
  else{
    system("ls | grep -xv \"data.csv\" | xargs rm")
  }
}

