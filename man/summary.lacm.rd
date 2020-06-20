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

\method{vcov}{lacm}(object, \ldots) 

\method{simulate}{lacm}(object, nsim = 1, seed = NULL, \ldots)
}

\arguments{

\item{object, x}{a fitted model object of class \code{"\link{lacm}"}.}

\item{digits}{the number of significant digits to use when printing.}

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
Pedeli, X. and Varin, C. (2020). Pairwise likelihood estimation of latent autoregressive count models. \emph{Statistical Methods in Medical Research}.\doi{10.1177/0962280220924068}.
}

\author{
Xanthi Pedeli and Cristiano Varin.
}
\seealso{
\code{\link{CLIC}}.
}
\examples{
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
summary(mod1)
## refit with d = 3
mod3 <- update(mod1, d = 3)
summary(mod3)
}
}
\keyword{regression}
\keyword{nonlinear}
\keyword{timeseries}
