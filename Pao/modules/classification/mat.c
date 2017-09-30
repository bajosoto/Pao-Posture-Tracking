#include "mat.h"
#include <stdio.h>
void mat_multiply(float mat1[2][2],uint8_t r1,uint8_t c1,float mat2[2][2],uint8_t r2,uint8_t c2,float buffer[2][2]){

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

void mat_print(float mat[2][2],uint8_t row, uint8_t col){
	for(uint8_t i = 0; i < row; i++){
		for(uint8_t j = 0; j < col; j++){
			printf("| %f |",mat[i][j]);
		}

	}
}