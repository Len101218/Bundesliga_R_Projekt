bigFive <- read_data_from_csv(here("Csv/BigFive.csv"))
result<- bigFive %>%
  categorize_data()%>%
  specify(Marktwert ~ Platzierung)%>%
  hypothesize(null = "independence") %>%
  generate(reps = 30, type ="bootstrap") %>%
  calculate(stat = "Chisq")# %>%
  visualise(bins = 30) +
  shade_p_value(obs_stat = 600, direction = "greater")
