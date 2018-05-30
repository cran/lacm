\name{summary.lacm}

\alias{summary.lacm}
\alias{print.lacm}
\alias{coef.lacm}
\alias{vcov.lacm}
\alias{simulate.lacm}
\title{
Methods for \code{lacm} Objects
}
\description{
Methods for fitted latent autoregressive count model objects of class \code{"\link{lacm}"}
}
\usage{
\method{summary}{lacm}(object, \ldots)

\method{print}{lacm}(x, digits = max(3L, getOption("digits") - 3L), \ldots)

\method{coef}{lacm}(object, \ldots)

\method{vcov}{lacm}(object, C = 1, demean = TRUE, adjust = TRUE, \ldots) 

\method{simulate}{lacm}(object, nsim = 1, seed = NULL, \ldots)
}

\arguments{

\item{object, x}{a fitted model object of class \code{"\link{lacm}"}.}

\item{digits}{the number of significant digits to use when printing.}

\item{C}{the constant C for computing the variability matrix. See \code{\link{select.C}}.}

\item{demean}{a logical value indicating whether to remove the central bias from the pairwise scores. See \code{\link{select.C}}.}

\item{adjust}{a logical value indicating whether to perform computations adjusting for the number of parameters in the model.}

\item{nsim}{number of response vectors to simulate. Defaults to \code{1}.}

\item{seed}{an object specifying if and how the random number generator should be initialized ('seeded'). See \code{\link{simulate}}.}

\item{...}{additional optional arguments.}
}



\value{
The function \code{summary.lacm} returns an object of class  \code{"summary.lacm"}, a list of some components of the \code{"\link{lacm}"} object, plus
\item{coefficients}{a summary of the parameter estimates, standard errors, z-values and corresponding p-values.}
\item{clic}{the composite likelihood information criterion.}

The function \code{simulate.lacm} returns a list of simulated responses.

The function \code{print} returns the \code{call} and \code{coefficients}, \code{coef} returns the estimated coefficients and \code{vcov} the corresponding variance-covariance matrix. 
}
\references{
Pedeli, X. and Varin, C. (2018). Pairwise likelihood estimation of latent autoregressive count models. Available at \url{https://arxiv.org/abs/1805.10865}
}

\author{
Xanthi Pedeli and Cristiano Varin.
}
\seealso{
\code{\link{CLIC}}, \code{\link{select.C}}, \code{\link{select.order}}.
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
mod1
## selection of C: suggests C between 1 and 3
select.C(mod1)
## summary with C = 1
summary(mod1, C = 1)
## selection of d: suggests d = 3
## select.order takes a few seconds
select.order(mod1, C = 1)
## select.order suggests d = 3
mod3 <- update(mod1, d = 3)
summary(mod3, C = 1)
}
}
\keyword{regression}
\keyword{nonlinear}
\keyword{timeseries}
