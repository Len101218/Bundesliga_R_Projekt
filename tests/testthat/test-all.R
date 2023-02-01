devtools::load_all()

bigFive<-read_data_from_csv(here("Csv/BigFive.csv")) 
result <-filter_data(bigFive,Saison = "Bundesliga",Saison_von = 2011,Team = "FC Bayern München")
#result<-categorize_data(bigFive)

test_that("multiplication works", {
  expect_equal(result, NULL)
})
