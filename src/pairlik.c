#include <R.h>
#include <Rmath.h>
#include <stdlib.h> 
#include <R_ext/Rdynload.h>

/**********************************************************************/
/* Pairwise likelihood of order d for Poisson parameter driven        */
/**********************************************************************/
void pairlik(const double *eta,
	     const double *phi,
	     const double *tau2,
	     const int *y,
	     const int *nobs,
	     const int *d, /* pairwise likelihood order */
	     const double *nodes,
	     const double *weights,
	     const int *m, /* number of nodes */
	     double *output)
{
	
  int t, i, j, k, id;
  double A =  sqrt(2 * (*tau2));
  int y_pair[2] = {0, 0};
  double eta_pair[2] = {0.0, 0.0};
  double v_pair[2] = {0.0, 0.0};
  double lambda_pair[2] = {0.0, 0.0};
  double integr = 0.0;
  double phi_pow_i = 0.0;
  double phi_pow_2i = 0.0;

  id = 0;
  for (t = (*d); t < (*nobs); t++) {
    for (i = 1; i <= (*d); i++) {
      y_pair[0] = y[t - i];
      eta_pair[0] = eta[t - i];
      y_pair[1] = y[t];
      eta_pair[1] = eta[t];
      phi_pow_i = R_pow_di((*phi), i);
      phi_pow_2i = R_pow_di((*phi), 2 * i);
      integr = 0.0;
      for (j = 0; j < (*m); j++) {
	v_pair[0] = A * nodes[j];
	lambda_pair[0] = exp(eta_pair[0] + v_pair[0]);
	for (k = 0; k < (*m); k++) {
	  v_pair[1] = A * sqrt(1 - phi_pow_2i) * nodes[k] + phi_pow_i * v_pair[0];
	  lambda_pair[1] = exp(eta_pair[1] + v_pair[1]);
	  integr +=  dpois(y_pair[0], exp(eta_pair[0] + v_pair[0]), 0) * dpois(y_pair[1], exp(eta_pair[1] + v_pair[1]), 0) * weights[j] * weights[k];
	}
      }
      output[id] = log(integr);
      id++;	  
    }
  }
}

/* registration */
static const R_CMethodDef CEntries[] = {
    {"pairlik", (DL_FUNC) &pairlik, 10},
    {NULL, NULL, 0}
};

void R_init_lacm(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
