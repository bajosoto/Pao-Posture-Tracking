#ifndef MAT_H
#define MAT_H
#include <inttypes.h>

#define mat_t int32_t
#define MAT_MAX 32768

void mat_multiply(uint8_t r1,uint8_t c1,const mat_t mat1[r1][c1],uint8_t r2,uint8_t c2,const mat_t mat2[r2][c2],mat_t buffer[r1][c2]);
void mat_print(uint8_t row, uint8_t col,const mat_t mat[row][col]);
mat_t vec_norm(uint8_t dim, const mat_t v[dim]);
void vec_print(uint8_t elements, const mat_t vec[elements]);
void vec_sub(uint8_t dim, const mat_t v1[dim], const mat_t v2[dim], mat_t res[dim]);
#endif