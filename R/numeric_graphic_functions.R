
plot_last10years<-function(data,team){
  
  actualseason=as.integer(format(Sys.Date(), "%Y"))-2
  
  if(format(Sys.Date(),"%b")=="Jul"||format(Sys.Date(),"%b")=="Aug"||format(Sys.Date(),"%b")=="Sep"||format(Sys.Date(),"%b")=="Oct"||format(Sys.Date(),"%b")=="Nov"||format(Sys.Date(),"%b")=="Dec"){
    actualseason=actualseason+1
  }
  
  actdata<-filter_data(data,saison_von=actualseason-9,saison_bis=actualseason,teams=team)
  
  league<-as.character(actdata[1,1])
  
  teamsinleague<-filter_data(data,saison_von=actualseason,saison_bis=actualseason,ligen=league)
  teamsinleague<-teamsinleague%>%
    summarise(Teamsinleague=n())
  teamsinleague<-as.numeric(teamsinleague)
  #actdata<-categorize_data(actdata)
  
  plot<-ggplot(data=actdata)+
      geom_line(mapping=aes(x=Saison,y=Platzierung))+
      ylim(0,teamsinleague)
      
  list(plot,actdata)
  return(list)
}


  
