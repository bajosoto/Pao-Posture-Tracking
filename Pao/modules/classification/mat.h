#ifndef MAT_H
#define MAT_H
#include <inttypes.h>
void mat_multiply(uint8_t r1,uint8_t c1,float mat1[r1][c1],uint8_t r2,uint8_t c2,float mat2[r2][c2],float buffer[r1][c2]);
void mat_print(uint8_t row, uint8_t col,float mat[row][col]);
#endif