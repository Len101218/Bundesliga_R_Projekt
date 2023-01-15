if("reticulate" %in% rownames(installed.packages())== FALSE){
  install.packages("reticulate")
}
if("here" %in% rownames(installed.packages())== FALSE){
  install.packages("here")
}
library(reticulate)
library(here)
file <-here("ews.py")

source_python(file,NULL,FALSE)

load_data_from_website <- function(saison,liga,kuerzel,output="data"){
  arguments <- c("-s",saison,"-l",liga,"-k",kuerzel,"-o", output)
  main(arguments)
}
