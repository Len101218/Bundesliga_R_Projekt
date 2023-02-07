
#' plot_last10years
#' 
#' Plots the performance of one team over the last 10 years.
#'
#' @param data The data, which you want to use.
#' @param team The team you want to get the performance from.
#' @param categoric If true you plot in categoric variables. If false you plot continuous.
#'
#' @return Returns a plot.
#' @export
#'
#' @examples plot_last10years(data,"FC Schalke 04",categoric=TRUE)
plot_last10years<-function(data,team,categoric=TRUE){
  if(categoric==TRUE){
    actualseason=get_lastfullseason()
    actdata<-categorize_data(data)
    actdata<-filter_data(actdata,saison_von=actualseason-9,saison_bis=actualseason,teams=team)
    print(actdata)
    
    league<-as.character(actdata[1,1])
   
    plot<-ggplot(data=actdata)+
      geom_line(mapping=aes(x=Saison,y=Platzierung,group=1))+
      geom_point(mapping=(aes(x=Saison,y=Platzierung,size=Marktwert)))+
      scale_size_manual(limits=c("low","avg","high"),values=pointsize)+
      scale_y_discrete(limits=c("end","mid","front"))+
      theme(panel.grid.major.y = element_line(color = "grey",size = 1,linetype = 1),panel.grid.minor.y=element_blank())+
      labs(title=paste(team,"s Platzierungen der letzten 10 Jahre", sep=""))
  
  }
  else{
  actualseason=get_lastfullseason()
    
  actdata<-filter_data(data,saison_von=actualseason-9,saison_bis=actualseason,teams=team)
  print(actdata)
  
  league<-as.character(actdata[1,1])
  
  teamsinleague<-filter_data(data,saison_von=actualseason,saison_bis=actualseason,ligen=league)
  teamsinleague<-teamsinleague%>%
    summarise(Teamsinleague=n())
  teamsinleague<-as.numeric(teamsinleague)
  
  plot<-ggplot(data=actdata)+
      geom_line(mapping=aes(x=Saison,y=Platzierung))+
      scale_y_continuous(expand=c(0,0),limits=c(0,teamsinleague+0.5),breaks=seq(0,teamsinleague,1))+
      theme(panel.grid.major.y = element_line(color = "grey",size = 1,linetype = 1),panel.grid.minor.y=element_blank())+
      labs(title=paste(team,"s Platzierungen der letzten 10 Jahre", sep=""))
  }
      
  return(plot)

}

#' plot_oneleague
#' 
#' Plots marketvalue and placements of  one single season from the choosen league.
#' The red lines symbolize the categoric classification of "Marktwert" and "Platzierung".
#'
#' @param data The data you want to plot.
#' @param liga The league you want to plot.
#' @param saison The season you want to plot.
#'
#' @return Returns a plot.
#' @export
#'
#' @examples plot_oneleague(data,"Premier League", 2018)
plot_oneleague<-function(data,liga,saison=get_lastfullseason()){
  actdata<-filter_data(data,saison_von=saison,saison_bis=saison,ligen=liga)
  
  actdata<-actdata%>%
    mutate(Marktwert=Marktwert/1e6)
  
  mean <- actdata %>%
    summarize(mean(Marktwert))
  mean<-as.numeric(mean)
  
  maxmarketvalue<-as.numeric(actdata%>%summarise(Marktwert=max(Marktwert)))
  options(scipen=999)
  
  plot<-ggplot(data=actdata,aes(y=reorder(Team,-Platzierung),x=Marktwert))+
    geom_point(stat="identity")+
    geom_vline(xintercept=0.5*mean,color="red")+
    geom_vline(xintercept=1.5*mean,color="red")+
    geom_hline(yintercept=8.5,color="red")+
    geom_hline(yintercept=14.5,color="red")+
    scale_x_continuous(expand=c(0,0),limits=c(0,maxmarketvalue+100))+
    ylab(paste(liga,"-Platzierungen der Teams in ",saison," (absteigend)",sep=""))+
    xlab("Marktwert in Mio.")
  
  return(plot)
}

#' plot_data_points
#'
#' Plots marketvalue and points of your data.
#'
#'@param data The data you want to plot from.
#'
#' @return Returns a plot.
#' @export
#'
#' @examples plot_data_points(data)
plot_data_points<-function(data){
  actdata1 <- data %>%
    filter(Liga=="Bundesliga")%>%
    mutate(Punkte=round((Punkte/34)*38))
  
  actdata2<-data%>%
    filter(Liga!="Bundesliga")
  
  actdata<-rbind(actdata1,actdata2)
  
  actdata<-actdata%>%
    group_by(Liga,Saison)%>%
    mutate(meanM=mean(Marktwert))%>%
    ungroup()%>%
    mutate(Marktwert = Marktwert/meanM,.keep = "unused")
  
  
  meanpoints<- actdata %>%
    summarise(Punkte=mean(Punkte))
  
  meanpoints<-as.numeric(meanpoints)
  
  
  maxmarketvalue<-as.numeric(actdata%>%summarise(Marktwert=max(Marktwert)))
  options(scipen=999)
  maxpoints<-as.numeric(actdata%>%summarise(Punkte=max(Punkte)))
  options(scipen=999)
  
  plot<-ggplot(data=actdata,aes(y=Punkte,x=Marktwert))+
    geom_point(stat="identity",aes(color=Liga))+
    geom_vline(xintercept=0.5,color="red")+
    geom_vline(xintercept=1.5,color="red")+
    geom_hline(yintercept=meanpoints,color="red")+
    geom_hline(yintercept=1.75*meanpoints,color="red")+
    scale_x_continuous(expand=c(0,0),limits=c(0,maxmarketvalue+0.5))+
    scale_y_continuous(expand=c(0,0),limits=c(0,maxpoints+5))+
    xlab("Marktwerts-Quotient")
  
  return(plot)
  
}

#' plot_data_placements
#'
#' Plots marketvalue and placements of your data
#'
#' @param data The data you want to plot from.
#'
#' @return Returns a plot.
#' @export
#'
#' @examples plot_data_placements(data)
plot_data_placements<-function(data){
  
  actdata<-data%>%
    group_by(Liga,Saison)%>%
    mutate(meanM=mean(Marktwert))%>%
    ungroup()%>%
    mutate(Marktwert = Marktwert/meanM,.keep = "unused")
  
  maxmarketvalue<-as.numeric(actdata%>%summarise(Marktwert=max(Marktwert)))
  options(scipen=999)
  
  plot<-ggplot(data=actdata,aes(y=Platzierung,x=Marktwert))+
    geom_point(stat="identity",aes(color=Liga))+
    geom_vline(xintercept=0.5,color="red")+
    geom_vline(xintercept=1.5,color="red")+
    geom_hline(yintercept=6.5,color="red")+
    geom_hline(yintercept=12.5,color="red")+
    scale_x_continuous(expand=c(0,0),limits=c(0,maxmarketvalue+0.5))+
    scale_y_continuous(expand=c(0,0),limits=c(0,21))+
    xlab("Marktwerts-Quotient")
  
  return(plot)
  
}

#' frame_performance
#'
#' Gives you a frame, which only contains really good (2), good (1), normal (0), bad (-1), really bad (-1) team-performances. 
#'
#' @param data The data you want to be rated.
#' @param performance The performances you´re looking for. Put in qn element of {-2,-1,0,1,2}.
#'
#' @return Returns a dataframe.
#' @export
#'
#' @examples frame_performance(data,2) returns a frame consisting out of teams with low marketvalue and high placement.
frame_performance<-function(data,performance){
  actdata<-categorize_data(data)

  if(performance==0){
      actdata<-actdata%>%
      filter((Marktwert=="high"&Platzierung=="front")||(Marktwert=="avg"&Platzierung=="mid")||(Marktwert=="low"&Platzierung=="end"))
  }
  if(performance==1){
    actdata<-actdata%>%
    filter((Marktwert=="low"&Platzierung=="mid")|(Marktwert=="avg"&Platzierung=="front"))
  }
  if(performance==2){
    actdata<-actdata%>%
      filter((Marktwert=="low"&Platzierung=="front"))
  }
  if(performance==-2){
    actdata<-actdata%>%
      filter((Marktwert=="high"&Platzierung=="end"))
  }
  if(performance==-1){
    actdata<-actdata%>%
      filter((Marktwert=="high"&Platzierung=="mid")|(Marktwert=="avg"&Platzierung=="end"))
  }
  
  return(actdata)
}


  
