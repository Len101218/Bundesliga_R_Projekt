% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import_and_filter_data.R
\name{filter_data}
\alias{filter_data}
\title{filter_data}
\usage{
filter_data(
  data,
  saison_von,
  saison_bis = 2022,
  teams = c("ALLTEAMS"),
  ligen = c("ALLLEAGUES"),
  platzierungen = c("ALLPLACES"),
  punkte = c("ALLPOINTS"),
  marktwert_von = "ALLVALUESFROM",
  marktwert_bis = "ALLVALUESTO"
)
}
\arguments{
\item{data}{database you are looking through}

\item{saison_von}{The first season from which you want to extract the data. If you want to extract data from the 2018/19 season set 'saison_von = 2018'.}

\item{saison_bis}{The last season from which you want to extract the data. It's set to 2023 /the actual year by default.
If you want to extract data from the 2021/22 season set 'saison_bis = 2021'.}

\item{teams}{A character-vector with the teams you're searching for. optional}

\item{ligen}{A character-vector with the leagues you're searching for. optional}

\item{platzierungen}{A integer-vector with the end-season-placements optional}

\item{punkte}{A integer-vector with the points you're searching for. optional}

\item{marktwert_von}{A integer with the min-marketvalue you're searching for.}

\item{marktwert_bis}{A integer with the max-marketvalue you're searching for. optional}
}
\value{
database
}
\description{
Filter data by parameter. You have to put in at least the season you want to start extracting data and one team or league you want to gather data from!
}
\examples{
filter_data(data,saison_von=2015,saison_bis=2019,teams=c("FC Augsburg", "VfL Bochum"))          
}
