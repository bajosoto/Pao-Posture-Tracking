#ifndef MAT_H
#define MAT_H
#include <inttypes.h>
void mat_multiply(float mat1[2][2],uint8_t r1,uint8_t c1,float mat2[2][2],uint8_t r2,uint8_t c2,float buffer[2][2]);
void mat_print(float mat[2][2],uint8_t row, uint8_t col);
#endif