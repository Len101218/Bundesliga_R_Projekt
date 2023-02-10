
#PythonWrapper
if("reticulate" %in% rownames(installed.packages())== FALSE){
  install.packages("reticulate",repos = "http://cran.us.r-project.org")
}
if("here" %in% rownames(installed.packages())== FALSE){
  install.packages("here",repos = "http://cran.us.r-project.org")
}

library(reticulate)
library(here)



#filter
#Check ob alle benötigten Packages bereits installiert wurden, falls nicht werden diese installiert.
if("tidyverse" %in% rownames(installed.packages())== FALSE){
  install.packages("tidyverse", repos = "http://cran.us.r-project.org")
}
if("devtools" %in% rownames(installed.packages())== FALSE){
  install.packages("devtools", repos = "http://cran.us.r-project.org")
}
if("here" %in% rownames(installed.packages())== FALSE){
  install.packages("here", repos = "http://cran.us.r-project.org")
}

library(here)
library(tidyverse)
library(usethis)
library(devtools)