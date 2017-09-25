#include <classifier.h>

typedef struct ldc_params
{
	float prior;
	float mean;
	float covariance[POSTURE_NCLASSES][POSTURE_NCLASSES];
}ldc_params_t;

ldc_params_t params[N_CLASSES]={
	/*CLASS 1*/
	{
		.prior = 0.5,
		.mean = 1,
		.covariance = {
			{1, 0},
			{0, 1}
		}
	},
	/*CLASS 2*/
	{
		.prior = 0.5,
		.mean = 3,
		.covariance = {
			{1, 0},
			{0, 1}
		}
	}
}


float pdf(int class,int* sample){
	/*TODO sample^T *params->cov^(-1)*params->mean + ln(params->prior) - 0.5 params->mean^T*params->cov^(-1)*params->mean */
	return 0.0
}