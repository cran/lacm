\name{select.C}
\alias{select.C}
\title{
Identification of the \code{C} Constant for Maximum Pairwise Likelihood Estimation
}
\description{
Computes the mean relative variance statistic for identification of the constant \code{C} involved in the variability matrix of maximum pairwise likelihood estimators.}

\usage{
select.C(object, demean = TRUE, adjust = TRUE, plot = TRUE, ...) 
}

\arguments{

\item{object}{a fitted model object of class \code{"\link{lacm}"}.}

\item{demean}{a logical value indicating whether to remove the central bias from the pairwise scores.}

\item{adjust}{a logical value indicating whether to perform computations adjusting for the number of parameters in the model.}

\item{plot}{logical. If \code{TRUE} (the default) the selection criterion values are plotted.}

\item{...}{further arguments to be passed to \code{\link{plot}}.}
}

\details{
Function \code{select.C} computes the mean relative variance statistic for values of C between \code{1} to \code{8}. The mean relative variance for selection of \code{C} is defined as the mean of the ratios between the asymptotic variances computed for a given \code{C} and the corresponding asymptotic variances computed with \code{C = 1}. See Pedeli and Varin (2018) for details.

Conservative choices of \code{C} are recommended, i.e. choose the value of \code{C} that maximizes the mean relative variance.
}


\value{
a vector containing the mean relative variances.
}
\references{
Pedeli, X. and Varin, C. (2018). Pairwise likelihood estimation of latent autoregressive count models. Available at \url{https://arxiv.org/abs/1805.10865}
}

\author{
Xanthi Pedeli and Cristiano Varin.
}
\seealso{
\code{\link{lacm}}, \code{\link{CLIC}}, \code{\link{select.order}}.
}
\examples{
## a small example with simulated data
data(sim50, package = "lacm")
## fit model with pairwise likelihood of order 1
mod1 <- lacm(y ~ x, data = sim50)
summary(mod1)
## selection of C: suggests C = 2
select.C(mod1)
## summary with C = 2
summary(mod1, C = 2)

## a more 'interesting' example with the Polio data
\donttest{
data("polio", package = "lacm")
## model components
trend <- 1:length(polio)
sin.term <- sin(2 * pi * trend / 12)
cos.term <- cos(2 * pi * trend / 12)
sin2.term <- sin(2 * pi * trend / 6)
cos2.term <- cos(2 * pi * trend / 6)
## fit model with pairwise likelihood of order 1
mod1 <- lacm(polio ~ I(trend * 10^(-3)) + sin.term + cos.term + sin2.term + cos2.term)
mod1
## selection of C: suggests C between 1 and 3
select.C(mod1)
}
}
\keyword{regression}
\keyword{nonlinear}
\keyword{timeseries}
