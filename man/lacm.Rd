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
     kernel.type = c("Rectangular", "Epanechnikov", "Triangular", "Quartic (biweight)",
     "Triweight", "Tricube", "Cosine"), fit = TRUE, gh.num = 20, reltol.opt = 1e-04,
     opt.method = c("Nelder-Mead", "BFGS"), maxit.opt = 1000, compute.jacobian = TRUE,
     jacob.method = c("simple", "Richardson", "complex"), print.info = TRUE) 
}

\arguments{

\item{formula}{an object of class \code{"\link{formula}"} (or one that
    can be coerced to that class): a symbolic description of the
    model to be fitted.  The details of model specification are given
    under \sQuote{Details}.}

\item{data}{an optional data frame, list or environment (or object
    coercible by \code{\link{as.data.frame}} to a data frame) containing
    the variables in the model.  If not found in \code{data}, the
    variables are taken from \code{environment(formula)},
    typically the environment from which \code{lacm} is called.}

\item{subset}{an optional vector specifying a subset of observations
    to be used in the fitting process.}

 \item{offset}{this can be used to specify an \emph{a priori} known
    component to be included in the linear predictor during fitting.
    This should be \code{NULL} or a numeric vector of length equal to
    the number of cases.  One or more \code{\link{offset}} terms can be
    included in the formula instead or as well, and if more than one is
    specified their sum is used.  See \code{\link{model.offset}}.}

\item{contrasts}{an optional list. See the \code{contrasts.arg}
    of \code{\link{model.matrix.default}}.}

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
one of \code{"Rectangular", "Epanechnikov", "Triangular", "Quartic (biweight)", "Triweight", "Tricube", "Cosine"} indicating the type of kernel weights to be used in the weighted pairwise likelihood specification. The default \code{"Rectangular"} corresponds to equal contribution from all pairs of observations that are distant apart up to lag \code{d}. Can be abbreviated.
}

\item{fit}{
a logical value indicating whether to compute the maximum pairwise likelihood estimates.
}

\item{gh.num}{
number of the Gauss-Hermite quadrature nodes. Defaults to 20.
}

\item{reltol.opt}{
relative convergence tolerance to be passed to \code{\link{optim}}. Defaults to 1e-4.
}
 
\item{opt.method}{
one of \code{"Nelder-Mead"} and \code{"BFGS"} indicating the optimization method to be passed to \code{\link{optim}}. Can be abbreviated. See \code{\link{optim}} for details.
}

\item{maxit.opt}{ 
the maximum number of iterations to be passed to \code{\link{optim}}. Defaults to 1000.
}


\item{compute.jacobian}{
a logical value indicating whether to compute the jacobian.
}


\item{jacob.method}{
one of \code{"Richardson"}, \code{"simple"}, or \code{"complex"} indicating the approximation method to be passed to \code{\link{jacobian}}. Can be abbreviated. See \code{\link{jacobian}} for details. 
}

\item{print.info}{
a logical value indicating whether to print information on the computation executed.
}
}

\details{
Function \code{lacm} performs maximum pairwise likelihood estimation in latent autoressive count models, see Pedeli and Varin (2018) for details.

Evaluation of the pairwise likelihood is performed through double Gauss-Hermite quadrature with the \code{gh.num} nodes and weights calculated by \code{\link{gauss.quad}}. 

Standard formula \code{y ~ x1 + x2} indicates that the mean response is modelled as a function of covariates \code{x1} and \code{x2} through a log link function. 

Starting values supplied by the user can be specified through \code{start.theta}. If \code{start.theta=NULL}, then starting values are obtained using the method-of-moments, see Ng et al. (2011). 
}


\value{
An object of class \code{"lacm"} with the following components:
\item{nobs}{the number of observations.}
\item{p}{the number of regressors, including the intercept.}
\item{d}{the order of the pairwise likelihood.}
\item{N}{the number of observations contributing to the pairwise likelihood.}
\item{npar}{the number of parameters.}
\item{Y}{the response used.}
\item{X}{the model matrix used for the mean response.}
\item{offset}{the offset used.}
\item{call}{the matched call.}
\item{kweights}{the kernel weights used.}
\item{start.theta}{the starting values.}
\item{fixed}{the numeric vector indicating which parameters are constants.}
\item{convergence}{an integer code indicating convergence of the optimizer. See \code{link{optim}} for details.}
\item{plik}{the maximum pairwise likelihood value.}
\item{theta}{the maximum pairwise likelihood estimate.}
\item{jacobian}{only if argument \code{compute.jacobian} is \code{TRUE}. The jacobian of the individual pairwise likelihood terms.}

Functions \code{\link{summary.lacm}}, \code{\link{coefficients}} and \code{\link{vcov.lacm}} can be used to obtain or print a summary of the results, extract coefficients and their estimated variance-covariance matrix of the model fitted by \code{\link{lacm}}. 
}
\references{
Ng, C., Joe, H., Karlis, D., and Liu, J. (2011). Composite likelihood for time series models with a latent autoregressive process. \emph{Statistica Sinica}, \bold{21}, 279--305.

Pedeli, X. and Varin, C. (2018). Pairwise likelihood estimation of latent autoregressive count models. Available at \url{https://arxiv.org/abs/1805.10865}
}
\author{
Xanthi Pedeli and Cristiano Varin.
}
\seealso{
\code{\link{CLIC}}, \code{\link{select.C}}, \code{\link{select.order}}, \code{\link{jacobian}}
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
## select.order takes a few seconds... 
select.order(mod1, C = 1)
## select.order suggests d = 3
## refit model with d = 3
mod3 <- update(mod1, d = 3)
summary(mod3, C = 1)
}
}
\keyword{regression}
\keyword{nonlinear}
\keyword{timeseries}
