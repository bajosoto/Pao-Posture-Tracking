#include <stdarg.h>
#include <stdint.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include <string.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdbool.h>
#include "mat.h"
/*
* Test is test compiled correctly
*/
static void test_linking(void **state)
{
    assert_true(true == true);
}

static void test_matmult_2d(void **state){
	float mat1[2][2] = {
		{1.0, 0.0},
		{0.0, 1.0}
	};
	float mat2[2][2] = {
		{1.0, 0.0},
		{0.0, 1.0}
	};
	float buffer[2][2]= {
		{0.0, 0.0},
		{0.0, 0.0}
	};

	mat_multiply(2,2,mat1,2,2,mat2,buffer);
	for(int i = 0; i < 2; i++){
		for(int j = 0; j < 2; j++){
			assert_true(mat1[i][j] == buffer[i][j]);
		}
	}
}

static void test_matmult_3d(void **state){
	#define d 3
	float mat1[d][d] = {
		{1.0, 2.0, 3.0},
		{4.0, 5.0, 6.0},
		{7.0, 8.0, 9.0}
	};
	float mat2[d][d] = {
		{1.0, 0.0, 0.5},
		{0.0, 1.0, 0.0},
		{0.0, 0.0, 1.0}
	};
	float buffer[d][d] = {
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0},
		{0.0, 0.0, 0.0}
	};
	float result[d][d] = {
		{1.0, 2.0, 3.5},
		{4.0, 5.0, 8.0},
		{7.0, 8.0, 12.5}
	};

	mat_multiply(d,d,mat1,d,d,mat2,buffer);
	for(int i = 0; i < d; i++){
		for(int j = 0; j < d; j++){
			assert_true(result[i][j] == buffer[i][j]);
		}
	}
} 

/*
* Register Tests
*/
int main(void)
{
	const struct CMUnitTest tests[] = {
		cmocka_unit_test(test_linking),
		cmocka_unit_test(test_matmult_2d),
	};

	return cmocka_run_group_tests(tests, NULL, NULL);
}

