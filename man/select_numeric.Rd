% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ez_summ.R
\name{select_numeric}
\alias{select_numeric}
\title{Selecting numeric variables from a data frame}
\usage{
select_numeric(df)
}
\arguments{
\item{df}{A data frame.}
}
\description{
Selecting numeric variables from a data frame
}
\examples{

data("credit")

credit \%>\% select_numeric()

}

