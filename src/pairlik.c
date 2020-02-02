#include <R.h>
#include <R.h>
#include <Rmath.h>
#include <R_ext/Rdynload.h>
#include <R_ext/RS.h>
#include <R_ext/Applic.h>
#include <stdlib.h>
#define SMALL 1e-8

/* Pairwise log-likelihood via Gauss-Hermite quadrature */
void pairlik(const double *eta,
	     const double *phi,
	     const double *tau2,
	     const int *y,
	     const int *nobs,
	     const int *d,
	     const int *latent,
	     const double *nodes,
	     const double *weights,
	     const int *m, /* number of nodes */
	     double *output)
{	
  unsigned int t, i, j, k, id;
  double uj, uk, phi_powi, integr, prob1, prob2;

  id = 0;
  if (*latent) {
    for (t = (*d); t < (*nobs); t++) {
      for (i = 1; i <= (*d); i++) {
	phi_powi = R_pow_di((*phi), i);
	integr = 0.0;
	for (j = 0; j < (*m); j++) {
	  uj = sqrt(2 * (*tau2)) * nodes[j];
	  prob1 = dpois(y[t - i], exp(eta[t - i] + uj), 0);
	  for (k = 0; k < (*m); k++) {
	    uk = sqrt(2 * (*tau2)) * (sqrt(1 - phi_powi * phi_powi) * nodes[k] + phi_powi * nodes[j]);
	    prob2 = dpois(y[t], exp(eta[t] + uk), 0);
	    integr +=  prob1 * prob2 * weights[j] * weights[k];
	  }
	}
	output[id] = log(integr) - log(M_PI);
	id++;	  
      }
    }
  }
  else  {
    for (t = (*d); t < (*nobs); t++) {
      for (i = 1; i <= (*d); i++) {
	output[id] = dpois(y[t - i], exp(eta[t - i]), TRUE) + dpois(y[t], exp(eta[t]), TRUE);
	id++;	  
      }
    }
  }
}

/* Jacobian of the pairwise log-likelihood */
void jacob(const double *eta,
	   const double *phi,
	   const double *tau2,
	   const int *y,
	   const int *nobs,
	   const double *x,
	   const int *ncovar,
	   const int *d,
	   const int *latent,
	   const double *nodes,
	   const double *weights,
	   const int *m, /* number of nodes */
	   double *output)
{	
  unsigned int t, i, j, k, p, id;
  double uj, uk, phi_powi, phi_powiM1, denom, probj, probk, resj, resk, A;
  double *num = (double *) R_alloc((*ncovar + 2), sizeof(double));

  if (*latent) {
    id = 0;
    for (t = (*d); t < (*nobs); t++) {
      for (i = 1; i <= (*d); i++) {
	phi_powi = R_pow_di((*phi), i);
	phi_powiM1 = R_pow_di((*phi), i - 1);
	denom = 0.0;
	for (p = 0; p < (*ncovar + 2); p++)
	  num[p] = 0.0;
	for (j = 0; j < (*m); j++) {
	  uj = sqrt(2 * (*tau2)) * nodes[j];
	  probj = dpois(y[t - i], exp(eta[t - i] + uj), 0);
	  resj = y[t - i] - exp(eta[t - i] + uj);
	  for (k = 0; k < (*m); k++) {
	    uk = sqrt(2 * (*tau2)) * (sqrt(1 - phi_powi * phi_powi) * nodes[k] + phi_powi * nodes[j]);
	    probk = dpois(y[t], exp(eta[t] + uk), 0);
	    resk = y[t] - exp(eta[t] + uk);
	    A = probj * probk * weights[j] * weights[k];
	    denom +=  A;
	    for (p = 0; p < (*ncovar); p++)
	      num[p] += A * (resj * x[(t - i) + p * (*nobs)] + resk * x[t + p * (*nobs)]);
	    if ((*tau2) != 0) {
	      num[*ncovar] += A * resk * sqrt(2 * (*tau2)) * i * phi_powiM1 * (-phi_powi / sqrt(1 - phi_powi * phi_powi) * nodes[k] + nodes[j]);
	      num[*ncovar + 1] += A * (resj * uj + resk * uk) / (2 * (*tau2));
	    }
	  }
	}
	for (p = 0; p < (*ncovar + 2); p++)
	  output[p + id] = num[p] / denom;
	id += (*ncovar + 2);	  
      }
    }
  }
  else {
    id = 0;
    for (t = (*d); t < (*nobs); t++) {
      for (i = 1; i <= (*d); i++) {
	phi_powi = R_pow_di((*phi), i);
	phi_powiM1 = R_pow_di((*phi), i - 1);
	for (p = 0; p < (*ncovar); p++)
	  output[p + id] += (y[t - i] - exp(eta[t - i])) * x[(t - i) + p * (*nobs)] + (y[t] - exp(eta[t])) * x[t + p * (*nobs)];
	id += (*ncovar + 2);
      }
    }
  }
} 
 
/* registration */
static const R_CMethodDef CEntries[] = {
  {"pairlik", (DL_FUNC) &pairlik, 11},
  {"jacob", (DL_FUNC) &jacob, 13},
  {NULL, NULL, 0}
};

void R_init_lacm(DllInfo *dll)
{
  R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
