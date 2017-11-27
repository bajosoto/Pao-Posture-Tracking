#include <stdarg.h>
#include <stdint.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include <string.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdbool.h>
#include <math.h>
#include "mat.h"
/*
* Test is test compiled correctly
*/
static void test_train(void **state)
{
    feature_t sample_1 = {1.0,2.0};
    feature_t sample_2 = {2.0,1.0};


}


/*
* Register Tests
*/
int main(void)
{
	const struct CMUnitTest tests[] = {
		cmocka_unit_test(test_train),
	};

	return cmocka_run_group_tests(tests, NULL, NULL);
}

