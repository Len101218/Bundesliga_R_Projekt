#bigFive <- read_data_from_csv(here("Csv/BigFive.csv"))
#result<- bigFive %>%filter_data(2021)%>%
#  categorize_data()%>%
#  specify(Marktwert ~ Platzierung)%>%
#  hypothesize(null = "independence") %>%
#  generate(reps = 10000, type ="permute") %>%
#  calculate(stat = "Chisq") %>%
#  visualise(bins = 100)+
#  shade_p_value(obs_stat = 10, direction = "greater")
#result

#result<- bigFive %>%filter_data(2021)%>%
#  categorize_data()%>%
#  specify(Marktwert ~ Platzierung)%>%
#  assume(distribution = "Chisq")%>%
#  visualise()+
#  shade_p_value(obs_stat = 10, direction = "greater")
#result




#' Title
#'
#' @param data 
#' @param method 
#' @param reps 
#'
#' @return
#' @export
#'
#' @examples
chi_squared_test <- function(data,method,reps){
  data <- data %>%
    categorize_data %>%
    specify(Marktwert ~ Platzierung) 

    if(method == "theory"){
        res <- data %>%
        assume(distribution = "Chisq")
        
    }else if(method == "simulation"){
        res <- data %>%
        hypothesize(null = "independence") %>%
        generate(reps = reps, type = "permute")%>%
        calculate(stat = "Chisq")
    }else{
      #throw error
    }
  
  obs_stat <- data %>%
    hypothesise(null ="independence")%>%
    calculate(stat = "Chisq")
  #view(obs_stat)
  p_val <- get_p_value(res,obs_stat = obs_stat, direction = "greater")
  #view(p_val)
  print(res)
  
  #visualization of distribution
  dist_plot <- res %>%
    visualize(bins = 15,
              method = method,
              dens_color = "blue") +
    labs(
      x = "x",
      y = "Verteilung",
      title = paste0(
        "Simulierte ",
        ifelse(method == "both", "und theoretische ", ""),
        "Chi-Quadrat-Verteilung"
      )
    ) +
    theme_light()
    dist_plot <- dist_plot +
    shade_p_value(obs_stat, direction = "greater")
  
  
  plot(dist_plot)
  
}