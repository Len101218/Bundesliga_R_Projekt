#' Chi_squared_test
#' @description   Führt einen Chi-Quadrat-Unabhängigkeitstest durch, wahlweise basierend auf einem theoretischenoder einem resampling Ansatz.
#' @param data    DataFrame (noch unkategorisiert), welches die zu testenden Zufallsvariablen (Spalten), Marktwert und Platzierung enthalten sollte.
#' @param method    Wähle zwischen "theory" und "simulation"
#' @param reps    Nur für den resample (simulation) Ansatz benötigt und gibt die Anzahl der permutions an.
#'
#' @return No return value
#' @export
#'
#' @import infer
#' @import tidyverse
#' 
#' @examples 
#' filtered_data <- filter_data(bigFive,saison_von = 2021)
#' chi_squared_test(filtered_data,"theory")
#' chi_squared_test(filtered_data,"simulation",1000)
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
      stop("Wähle zwischen \"theory\" oder \"simulation\"")
    }
  
  obs_stat <- data %>%
    hypothesise(null ="independence")%>%
    calculate(stat = "Chisq")
  
  p_val <- get_p_value(res,obs_stat = obs_stat, direction = "greater")
  print(p_val)
  
  #visualization of distribution
  dist_plot <- res %>%
    visualize(bins = 15,
              method = method,
              dens_color = "blue") + 
    labs(
      x = "X",
      y = "Verteilung",
      title = paste(method,"based chi-squared-distribution")
    ) +
    theme_light()
    dist_plot <- dist_plot +
    shade_p_value(obs_stat, direction = "greater")
  
  
  plot(dist_plot)
  
}