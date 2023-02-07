
n <- 98
B <- 10000

bigFive <- read_data_from_csv("Csv/BigFive.csv")

filtered_data <- filter_data(bigFive,2021)

cat_data <- categorize_data(filtered_data)


stp_98 <- cat_data %>%
  rep_sample_n(size = 98,replace = TRUE, reps = B)

tabel <- stp_98 %>%
  group_by(replicate, Marktwert, Platzierung) %>%
  summarise(num = n()) %>%
  group_by(replicate)




rand <- tabel %>%
  group_by(replicate,Marktwert)%>%
  mutate(M = sum(num),num,.keep = "unused") %>%
  group_by(replicate, Platzierung) %>%
  mutate(P = sum(num),num,.keep= "unused")


res <- rand %>%
  group_by(replicate)%>%
  mutate(v = (num - M*P/n)^2/(M*P/n)) %>%
  summarize(chi_Quadrat = sum(v))%>%
  ungroup() 

res %>%
  ggplot(aes(x = chi_Quadrat)) + 
  geom_histogram(binwidth = 2, color = "white")

conf <-res %>%
  get_confidence_interval(level = 0.75, type ="percentile")


#chisq.test(cat_data$Marktwert,cat_data$Platzierung)

