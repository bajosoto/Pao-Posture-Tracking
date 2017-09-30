#include "mat.h"
#include <stdio.h>
void mat_multiply(float** mat1,uint8_t r1,uint8_t c1,float** mat2,uint8_t r2,uint8_t c2,float** buffer){

	if(c1 != r2){
		printf("Matmult:: Matrices can't be mutltiplied!\n");
		return;
	}

	for(int i=0;i<r1;i++){
		for(int j=0;j<c2;j++){
			for (int k=0;k<c1;k++){
				buffer[i][j] = mat1[i][k]*mat2[k][j];
			}
		}
		
	}
}