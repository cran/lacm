\name{lacm}
\alias{lacm}
\title{
Fitting Latent Autoregressive Count Models by Maximum Pairwise Likelihood
}
\description{
Fits latent autoregressive count models by maximum pairwise likelihood.   
}
\usage{
lacm(formula, data, subset, offset, contrasts = NULL, start.theta = NULL, fixed, d = 1,
     kernel.type = c("Rectangular", "Trapezoidal"), fit = TRUE, gh.num = 20,
     reltol.opt = 1e-06, opt.method = c("BFGS", "Nelder-Mead"), maxit.opt = 1000,
     sandwich.lag = NULL, bread.method = c("Outer-product", "Hessian"), \ldots) 
}

\arguments{

\item{formula}{an object of class \code{"\link[stats]{formula}"} (or one that
    can be coerced to that class): a symbolic description of the
    model to be fitted.  The details of model specification are given
    under \sQuote{Details}.}

\item{data}{an optional data frame, list or environment (or object
    coercible by \code{\link[base]{as.data.frame}} to a data frame) containing
    the variables in the model.  If not found in \code{data}, the
    variables are taken from \code{environment(formula)},
    typically the environment from which \code{lacm} is called.}

\item{subset}{an optional vector specifying a subset of observations
    to be used in the fitting process.}

 \item{offset}{this can be used to specify an \emph{a priori} known
    component to be included in the linear predictor during fitting.
    This should be \code{NULL} or a numeric vector of length equal to
    the number of cases.  One or more \code{\link[stats]{offset}} terms can be
    included in the formula instead or as well, and if more than one is
    specified their sum is used.  See \code{\link[stats]{model.offset}}.}

\item{contrasts}{an optional list. See the \code{contrasts.arg}
    of \code{\link[stats]{model.matrix.default}}.}

\item{start.theta}{
optional numeric vector with starting values for the model parameters.
}

\item{fixed}{
optional numeric vector of the same length as the total number of parameters. If supplied, only \code{NA} entries in fixed will be varied. 
}

\item{d}{
order of the pairwise likelihood. Defaults to 1.
}

\item{kernel.type}{
one of \code{"Rectangular", "Trapezoidal"} indicating the type of kernel weights to be used in the weighted pairwise likelihood specification. The default \code{"Rectangular"} corresponds to equal contribution from all pairs of observations that are distant apart up to lag \code{d}. Can be abbreviated.
}

\item{fit}{
a logical value indicating whether to compute the maximum pairwise likelihood estimates or not.
}

\item{gh.num}{
number of the Gauss-Hermite quadrature nodes. Defaults to 20.
}

\item{reltol.opt}{
relative convergence tolerance to be passed to \code{\link[stats]{optim}}. Defaults to 1e-6.
}
 
\item{opt.method}{
one of \code{"BFGS"} or \code{"Nelder-Mead"} indicating the optimization method to be passed to \code{\link{optim}}. Can be abbreviated. See \code{\link{optim}} for details.
}

\item{maxit.opt}{ 
the maximum number of iterations to be passed to \code{\link[stats]{optim}}. Defaults to 1000.
}

\item{sandwich.lag}{ 
the lag length used for computing the bandwith of the sandwich variance. See \sQuote{Details}.}

\item{bread.method}{
one of \code{"Outer-product"} or \code{"Hessian"} indicating whether the bread matrix of the sandwich variance is estimated with the outer-product of the individual gradients or with a numerical approximation of the Hessian matrix.  Can be abbreviated. See \sQuote{Details}.}

\item{\ldots}{
further arguments passed to or from other methods.
}
}

\details{
Function \code{lacm} performs maximum pairwise likelihood estimation in latent autoressive count models, see Pedeli and Varin (2020) for details.

Evaluation of the pairwise likelihood is performed through double Gauss-Hermite quadrature with the \code{gh.num} nodes and weights calculated by \code{\link[statmod]{gauss.quad}}. 

Standard formula \code{y ~ x1 + x2} indicates that the mean response is modelled as a function of covariates \code{x1} and \code{x2} through a log link function. 

Starting values supplied by the user can be specified through \code{start.theta}. If \code{start.theta=NULL}, then starting values are obtained using the method-of-moments as discussed in Ng et al. (2011).

Sandwich standard errors that are robust to heteroschedasticity and autocorrelation (HAC-type) are computed. The "meat matrix" is estimated using a lag length equal to \code{sandwich.lag}. If \code{sandwich.lag} is \code{NULL}, then \code{L} is set equal to \code{10 * log10(n)}, where \code{n} is the time series length and \code{d} is the pairwise likelihood order. The "bread matrix" is computed with the average of outer products of the individual grandients (\code{bread.matrix = "Outer-product"}) or with a numerical approximation of the Hessian (\code{bread.method = "Hessian"}).  Details are given in Pedeli and Varin (2020). 
}


\value{
An object of class \code{"lacm"} with the following components:
\item{nobs}{the number of observations.}
\item{p}{the number of regressors, including the intercept.}
\item{d}{the order of the pairwise likelihood.}
\item{npar}{the number of parameters.}
\item{Y}{the response used.}
\item{X}{the model matrix used for the mean response.}
\item{offset}{the offset used.}
\item{sandwich.lag}{the lag length used for the bandwith of the HAC-type standard errors.} 
\item{fit}{logical. Was the model fitted or not?}
\item{gh.num}{number of Gauss-Hermite nodes used.}
\item{call}{the matched call.}
\item{terms}{the \code{\link[stats]{terms}} object  used.}
\item{latent}{logical. Does the model include the latent part?}
\item{fixed}{the numeric vector indicating which parameters are constants.}
\item{ifree}{indeces of the free parameters.}
\item{kweights}{the kernel weights used.}
\item{start.theta}{the starting values.}
\item{objfun}{function computing the logarithm of the pairwise likelihood of order d.}
\item{grad}{function computing the gradient of the pairwise likelihood of order d.}
\item{gh}{Gauss-Hermite nodes and weights used.}
\item{opt.method}{a character string specifying the method argument passed to optim. The default optimization routine is the quasi-Newton algorithm BFGS. See \code{\link{optim}} for details.} 
\item{convergence}{an integer code indicating convergence of the optimizer. See \code{link{optim}} for details.}
\item{gh}{a list with components the Gauss-Hermite \code{nodes} and the \code{weights} used for approximating the pairwise likelihood.}
\item{plik}{the maximum pairwise likelihood value.}
\item{theta}{the maximum pairwise likelihood estimate.}
\item{jacobian}{the jacobian of the individual pairwise likelihood terms.}
\item{outer-product}{logical. Was the bread matrix of the sandwich variance computed with the outer product of the individual scores?}
\item{H}{the bread matrix.}
\item{J}{the meat matrix.}
\item{vcov}{the variance-covariance matrix of the maximum pairwise likelihood estimate.}
\item{CLIC}{the composite likelihood information criterion.}

Functions \code{\link{summary.lacm}}, \code{\link[stats]{coefficients}} and \code{\link{vcov.lacm}} can be used to obtain or print a summary of the results, extract coefficients and their estimated variance-covariance matrix of the model fitted by \code{\link{lacm}}. 
}
\references{
Ng, C., Joe, H., Karlis, D., and Liu, J. (2011). Composite likelihood for time series models with a latent autoregressive process. \emph{Statistica Sinica}, \bold{21}, 279--305.

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
