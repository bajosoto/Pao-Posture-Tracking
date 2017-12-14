
#include <stdint.h>
#include <stddef.h>
#include <stdarg.h>
#include <setjmp.h>
#include <cmocka.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#include <printf.h>
#include "mat.h"
/*
* Test is test compiled correctly
*/
static void test_linking(void **state)
{
    assert_true(true == true);
}

static void test_matmult_2d(void **state){
	mat_t mat1[2][2] = {
		{1, 0},
		{0, 1}
	};
	mat_t mat2[2][2] = {
		{1, 0},
		{0, 1}
	};
	mat_t buffer[2][2]= {
		{0, 0},
		{0, 0}
	};

	mat_multiply(2,2,mat1,2,2,mat2,buffer);
	for(int i = 0; i < 2; i++){
		for(int j = 0; j < 2; j++){
			assert_true(mat1[i][j] == buffer[i][j]);
		}
	}
}

static void test_matmult_3d(void **state){
	mat_t mat1[3][3] = {
		{10, 20, 30},
		{40, 50, 60},
		{70, 80, 90}
	};
	mat_t mat2[3][3] = {
		{10, 0, 50},
		{0, 10, 0},
		{0, 0, 10}
	};
    mat_t buffer[3][3] = {
		{0, 0, 0},
		{0, 0, 0},
		{0, 0, 0}
	};
    mat_t result[3][3] = {
		{100, 200, 800},
		{400, 500, 2600},
		{700, 800, 4400}
	};

	mat_multiply(3,3,mat1,3,3,mat2,buffer);
	for(int i = 0; i < 3; i++){
		for(int j = 0; j < 3; j++){
			assert_true(result[i][j] == buffer[i][j]);
		}
	}
}

static void test_matmult_bad(void **state){
    mat_t mat1[3][3] = {
		{10, 20, 30},
		{40, 50, 60},
		{70, 80, 90}
	};
    mat_t mat2[2][2] = {
		{10, 0},
		{0, 10}
	};
    mat_t buffer[3][3] = {
		{0, 0, 0},
		{0, 0, 0},
		{0, 0, 0}
	};
	

	mat_multiply(3,3,mat1,2,2,mat2,buffer);
	for(int i = 0; i < 3; i++){
		for(int j = 0; j < 3; j++){
			assert_true(buffer[i][j] == 0.0);
		}
	}
} 

static void test_matmult_3to2(void **state){
    mat_t mat1[3][3] = {
		{10, 20, 30},
		{40, 50, 60},
		{70, 80, 90}
	};
    mat_t mat2[3][2] = {
		{1, 0},
		{0, 1},
		{0, 0}

	};
	mat_t buffer[3][2] = {
		{0, 0},
		{0, 0},
		{0, 0}
	};
	

	mat_multiply(3,3,mat1,3,2,mat2,buffer);

	for(int i = 0; i < 3; i++){
		for(int j = 0; j < 2; j++){
			assert_true(buffer[i][j] == mat1[i][j]);
		}
	}
}

static void test_vec_sub(void **state){
	mat_t vec1[3] = {1,2,3};
	mat_t vec2[3] = {3,2,1};
	mat_t res[3] = {0,0,0};
	mat_t true_res[3] = {-2,0,2};

	vec_sub(3,vec1,vec2,res);

	for (int i=0; i<3; i++){
		assert_true(res[i] == true_res[i]);
	}
}

static void test_vec_norm(void **state){
	mat_t vec1[3] = {2,-2};
    mat_t res = vec_norm(2,vec1);
	assert_true(res == 2);
}
/*
* Register Tests
*/
int main(void)
{
	const struct CMUnitTest tests[] = {
		cmocka_unit_test(test_linking),
		cmocka_unit_test(test_matmult_2d),
		cmocka_unit_test(test_matmult_3d),
		cmocka_unit_test(test_matmult_bad),
		cmocka_unit_test(test_matmult_3to2),
		cmocka_unit_test(test_vec_sub),
		cmocka_unit_test(test_vec_norm)



	};

	return cmocka_run_group_tests(tests, NULL, NULL);
}

