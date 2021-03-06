% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bivariate_analysis.R
\name{bt}
\alias{bt}
\title{Bivariate Table}
\usage{
bt(variable, target)
}
\arguments{
\item{variable}{A variable}

\item{target}{A numeric binary vector {0,1}}
}
\value{
A dplyr::data_frame object with the counts, percents and odds
}
\description{
This function calculate a bivariate table.
}
\examples{
data(credit)

variable <- credit$marital_status
target <- 1 - credit$bad

bt(variable, target)

variable <- cut(credit$payment_day, breaks = c(-Inf, 10, 20, Inf))

bt(variable, target)
 
}
\references{
http://documentation.statsoft.com/portals/0/formula%20guide/Weight%20of%20Evidence%20Formula%20Guide.pdf
}

