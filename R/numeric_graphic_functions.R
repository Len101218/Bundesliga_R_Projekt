

plot_last10years<-function(data,team){
  
  actualseason=get_lastfullseason()
    
  actdata<-filter_data(data,saison_von=actualseason-9,saison_bis=actualseason,teams=team)
  
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
      
  return(plot)

}

plot_oneleague<-function(data,liga,saison=get_lastfullseason()){
  actdata<-filter_data(data,saison_von=saison,saison_bis=saison,ligen=liga)
  
  actdata<-actdata%>%
    mutate(Marktwert=Marktwert/1000000)
  
  maxmarketvalue<-as.numeric(actdata%>%summarise(Marktwert=max(Marktwert)))
  options(scipen=999)
  
  plot<-ggplot(data=actdata,aes(y=reorder(Team,-Platzierung),x=Marktwert))+
    geom_point(stat="identity")+
    scale_x_continuous(expand=c(0,0),limits=c(0,maxmarketvalue+100))+
    ylab(paste(liga,"-Platzierungen der Teams in ",saison," (absteigend)",sep=""))+
    xlab("Marktwert in Mio.")
  
  return(plot)
}


  
