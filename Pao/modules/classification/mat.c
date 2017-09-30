#include "mat.h"
#include <stdio.h>
void mat_multiply(uint8_t r1,uint8_t c1,float mat1[c1][c1],uint8_t r2,uint8_t c2,float mat2[r2][c2],float buffer[r1][c2]){

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
void mat_print(uint8_t row, uint8_t col,float mat[row][col]){
	for(uint8_t i = 0; i < row; i++){
		for(uint8_t j = 0; j < col; j++){
			printf("| %f |",mat[i][j]);
		}

	}
}