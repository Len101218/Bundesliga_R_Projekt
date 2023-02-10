#' read_data_from_csv
#'
#' Generates your data out of a CSV.
#'
#' @param relPath The sourcepath of your CSV.
#'
#' @return Returns your data.
#' @export
#' @import here
#' @examples read_data_from_csv("< your cs-path >")
read_data_from_csv <- function(relPath){
  if(!is.character(relPath))stop("One or more arguments are wrong: See help!")
  absPath <- here(relPath) 
  return (read_csv(absPath))
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
#' @param ligen A character-vector with the leagues you're searching for. optional 
#' @param platzierungen A integer-vector with the end-season-placements optional
#' @param punkte A integer-vector with the points you're searching for. optional
#' @param marktwert_von A integer with the min-marketvalue you're searching for. 
#' @param marktwert_bis A integer with the max-marketvalue you're searching for. optional
#'
#' @return database
#' @export
#'
#' @examples filter_data(data,saison_von=2015,saison_bis=2019,teams=c("FC Augsburg", "VfL Bochum"))          
filter_data <- function(data,saison_von,saison_bis=2022,teams="ALLTEAMS",ligen="ALLLEAGUES",platzierungen="ALLPLACES", punkte="ALLPOINTS",marktwert_von="ALLVALUESFROM",marktwert_bis="ALLVALUESTO"){#TODO: use current year
  
  
  
  #falschen/schlechten Input abfangen
  if(teams=="ALLTEAMS" && ligen=="ALLLEAGUES"){
    #return("FEHLER: Es muss mindestens ein Team oder eine Liga übergeben werden!")
  }
  
  if(!is.numeric(saison_von) || !is.numeric(saison_bis) || !is.character(teams) || !is.character(ligen) ||!(platzierungen=="ALLPLACES" || is.numeric(platzierungen)) || !(punkte=="ALLPOINTS"||is.numeric(punkte)) ||!(marktwert_von=="ALLVALUESFROM"||is.numeric(marktwert_von))|!(is.numeric(marktwert_bis)||marktwert_bis=="ALLVALUESTO")){
    return("Ein/Mehrere Parameter wurden falsch übergeben!")
  }
  actdata<-data
  
  #Filtern
  actdata <- actdata %>%
    filter(Saison>=saison_von,Saison<=saison_bis)
  
  if(teams!="ALLTEAMS"){
    actdata <- actdata %>%
      filter(Team %in% teams)
  }
  if(ligen!="ALLLEAGUES"){
    actdata <- actdata %>%
      filter(Liga %in% ligen)
    
  }
  if(platzierungen!="ALLPLACES"){
    actdata <- actdata %>%
      filter(Platzierung %in% platzierungen)
  }
  if(punkte!="ALLPOINTS"){
    actdata <- actdata %>%
      filter(Punkte %in% punkte)
  }
  if(marktwert_von!="ALLVALUESFROM"&&marktwert_bis!="ALLVALUESTO"){
    actdata <- actdata %>%
      filter(Marktwert>=marktwert_von,Marktwert<=marktwert_bis)
  }
  if(marktwert_von!="ALLVALUESFROM"&&marktwert_bis=="ALLVALUESTO"){
    actdata <- actdata %>%
      filter(Marktwert>=marktwert_von)
  }
  if(marktwert_von=="ALLVALUESFROM"&&marktwert_bis!="ALLVALUESTO"){
    actdata <- actdata %>%
      filter(Marktwert<=marktwert_bis)
  }
  return(actdata)
}

#' categorize_data
#' 
#' Categorizes your data (Marktwert, Platzierung and Punkte) from continuous/discrete values to categoric values.
#'
#' @param data The data you want to categorize.
#'
#' @return Returns your data. But categorized.
#' @export
#'
#' @examples categorize_data(data)
categorize_data <-function(data){
  actdata <- data %>%
      group_by(Liga,Saison)%>%
        mutate(meanM=mean(Marktwert),countGames=2*n(),Marktwert,Team)%>%
          ungroup()%>%
            mutate(Marktwert = Marktwert/meanM,Punkte = Punkte/countGames,.keep = "unused")
  
  actdata$Marktwert<-cut(actdata$Marktwert,breaks=categorized_Markt,labels=c('low','avg','high'))
  actdata$Platzierung<-cut(data$Platzierung,breaks=categorized_Platzierung,labels=c('front','mid','end'))
  actdata$Punkte<-cut(actdata$Punkte,breaks=categorized_Punkte,labels=c('end','mid','front'))
  
  return(actdata)
}


#' get_lastfullseason
#' 
#' Gets you the last fully completed season.
#'
#' @return Returns you an integer.
#' @export
#'
#' @examples
get_lastfullseason<-function(){
  actualseason=as.integer(format(Sys.Date(), "%Y"))-1
  month <- format(Sys.Date(),"%b")
  if(!month  %in% c("Jul","Aug","Sep","Oct","Nov","Dec")){
    actualseason=actualseason-1
  }
  return(actualseason)
}





