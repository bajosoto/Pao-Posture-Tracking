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
	int row = 2,col=2;
	for(uint8_t j = 0; j < col; j++){
		printf("-");
	}
	printf("\n");


	mat_print(mat1,2,2);
	mat_multiply(mat1,2,2,mat2,2,2,buffer);
	for(int i = 0; i < 2; i++){
		for(int j = 0; j < 2; j++){
			assert_true(mat1[i][j] == buffer[i][j]);
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

