\name{CLIC}
\alias{CLIC}
\title{
Composite Likelihood Information Criterion
}
\description{
Calculates the composite likelihood information criterion for a latent autoregressive count model fitted through maximum pairwise likelihood.}
\usage{
CLIC(object, ...)
}

\arguments{

\item{object}{a fitted model object of class \code{"\link{lacm}"}.}

\item{...}{optional arguments.}

}

\details{
Function \code{CLIC} computes the composite likelihood information criterion (Varin and Vidoni, 2005) for a latent autoregressive count model estimated by maximum pairwise likelihood. See Pedeli and Varin (2020) for details.

When comparing models fitted by maximum pairwise likelihood to the same data, the smaller the CLIC, the better the fit.
}


\value{
a numeric value with the corresponding CLIC.
}
\references{
Pedeli, X. and Varin, C. (2020). Pairwise likelihood estimation of latent autoregressive count models. Available at arXiv.org.

Varin, C. and Vidoni, P. (2005). A note on composite likelihood inference and model selection. \emph{Biometrika}, \bold{92}, 519--528.
}

\author{
Xanthi Pedeli and Cristiano Varin.
}
\seealso{
\code{\link{lacm}}.
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
CLIC(mod1)
}
}
\keyword{regression}
\keyword{nonlinear}
\keyword{timeseries}
