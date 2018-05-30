\name{sim50}
\alias{sim50}
\docType{data}
\title{
Simulate Time Series of Counts
}
\description{
A simulated time series of counts of length 50
}
\usage{data(sim50)}
\format{
A dataframe with the following components:
\tabular{ll}{
\code{y}\tab the simulated response \cr
\code{x} \tab the simulated predictor.
}
}
\examples{
data(sim50, package = "lacm")
lacm(y ~ x, data = sim50)
}
\keyword{datasets}
