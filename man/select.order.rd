\name{select.order}
\alias{select.order}
\title{
Identification of the Pairwise Likelihood Order
}
\description{
Computes the mean relative variance statistic for identification of the pairwise likelihood order \code{d}.
}

\usage{
select.order(object, max.d = 10, C = 1, fit = FALSE, demean = TRUE, adjust = TRUE,
plot = TRUE, ...)
}

\arguments{

\item{object}{a fitted model object of class \code{"\link{lacm}"}.}

\item{max.d}{the maximum order to be considered.}

\item{C}{a constant to be specified by the user or identified by \code{\link{select.C}} (recommended).}

\item{fit}{a logical value indicating whether to compute the maximum pairwise likelihood estimates.}

\item{demean}{a logical value indicating whether to remove the central bias from the pairwise scores.}

\item{adjust}{a logical value indicating whether to adjust for the number of parameters in the model.}

\item{plot}{logical. If \code{TRUE} (the default) the mean relative variances are plotted.}

\item{...}{further arguments to be passed to \code{plot}.}
}

\details{
Function \code{	link{select.order}} can be used for identification of the pairwise likelihood order. The selection statistic is the mean relative variance defined as mean of the ratios between the asymptotic variances computed for a given \code{d} and the corresponding asymptotic variances computed with \code{d = 1}. See Pedeli and Varin (2018) for details. 

The mean relative variance is computed for each order \code{d=1,...,max.d}. It is recommended to select the order that minimizes the mean relative variance.

The constant \code{C} should be preliminary identified, possibly though \code{\link{select.C}}.
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
\code{\link{lacm}}, \code{\link{CLIC}}, \code{\link{select.C}}.
}
\examples{
## a small example with simulated data
data(sim50, package = "lacm")
## fit model with pairwise likelihood of order 1
mod1 <- lacm(y ~ x, data = sim50)
summary(mod1)
## selection of C: suggests C = 2
select.C(mod1)
## selection of d: suggests d = 2
select.order(mod1, C = 2)
## refit model with d = 2
mod2 <- update(mod1, d = 2)
summary(mod2, C = 2)

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
## selection of d: suggests d = 3
## this takes a few seconds...
select.order(mod1, C = 1)
## refit model with d = 3
mod3 <- update(mod1, d = 3)
summary(mod3, C = 1)
}
}
\keyword{regression}
\keyword{nonlinear}
\keyword{timeseries}
