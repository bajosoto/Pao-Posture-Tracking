#include "mat.h"
#include <stdio.h>
#include <math.h>
void mat_multiply(uint8_t r1,uint8_t c1,mat_t mat1[c1][c1],uint8_t r2,uint8_t c2,mat_t mat2[r2][c2],mat_t buffer[r1][c2]){

	if(c1 != r2){
		printf("Matmult:: Matrices can't be mutltiplied!\n");
		return;
	}

	for(uint8_t i = 0; i < r1; i++){
		for(uint8_t j = 0; j < c2; j++){
			for (uint8_t k = 0; k < c1; k++){
				buffer[i][j] += mat1[i][k]*mat2[k][j];
			}
		}
		
	}
}
void mat_print(uint8_t row, uint8_t col,mat_t mat[row][col]){
	for(uint8_t i = 0; i < row; i++){
		for(uint8_t j = 0; j < col; j++){
			printf("| %f |",mat[i][j]);
		}

	}
}

void vec_print(uint8_t elements,mat_t vec[elements]){
	for(uint8_t i = 0; i < elements; i++){
			printf("| %f |\n",vec[i]);
		}
}

mat_t vec_norm(uint8_t dim, mat_t v[dim]){
	mat_t res = 0;
	for (uint8_t i=0; i<dim; i++){
		res += v[i]*v[i];
	}
	return (mat_t)sqrt(res);
}

void vec_sub(uint8_t dim, mat_t v1[dim], mat_t v2[dim], mat_t res[dim]){
	for (uint8_t i=0; i<dim; i++){
		res[i] = v1[i]-v2[i];
	}	
}
