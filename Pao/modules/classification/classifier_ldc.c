#include <classifier.h>
#include "mat.h"

#define DIM 2;

typedef struct ldc_params
{
	float prior;
	float mean[DIM];
	float cov[DIM][DIM];
	float cov_inv[DIM][DIM];
	float lnprior;
	float c; /*0.5 params->mean^T*params->cov^(-1)*params->mean */
}ldc_params_t;

#define PRIOR_1 0.5
#define MEAN_1 3
#define COV_1 {{1, 0},{0, 1}}

#define PRIOR_1 0.5
#define MEAN_1 -1
#define COV_1 {{1, 0},{0, 1}}

static const ldc_params_t params[N_CLASSES]={
	/*CLASS 1*/
	{
		.prior = 0.5,
		.mean = {1,0},
		.covariance = {
			{1, 0},
			{0, 1}
		}
		.cov_inv = {
			{1, 0},
			{0, 1}
		}
		.lnprior = -0.693,
		.c = 1.0
	},
	/*CLASS 2*/
	{
		.prior = 0.5,
		.mean = {3,0},
		.covariance = {
			{1, 0},
			{0, 1}
		}
		.cov_inv = {
			{1, 0},
			{0, 1}
		}
		.lnprior = -0.693,
		.c = 9
	}
}


float pdf(int class,int* sample){
	/*TODO sample^T *params->cov^(-1)*params->mean + ln(params->prior) - 0.5 params->mean^T*params->cov^(-1)*params->mean */

	float buffer = float[1][2];
	float pdf = 0;

	mat_multiply(sample,1,2,params[class].cov,2,2,buffer);
	mat_multiply(buffer,1,2,params[class].mean,2,1,pdf);
	pdf += params[class].lnprior;
	pdf += params[class].c;

	return 0.0
}