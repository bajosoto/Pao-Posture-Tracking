//
// Created by phil on 4-12-17.
//

#include <stdint.h>
#include <stddef.h>
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>
#include <string.h>

#define WINDOW_SIZE 2
#define RAW_DIM 9
#define CLF_DIM 3
#include "mat.h"
#include "preprocessor.h"

static void test_transform(void **state)
{
    feature_t raw_samples[2][RAW_DIM]={{10,10,10,10,10,10,10,10,10},
                                       {20,20,20,20,20,20,20,20,20}};
    feature_t samples[1][CLF_DIM] = {{0,0,0}};

    prep_transform(2,raw_samples,1,samples);

    assert_true(samples[0][0] == 15);
    assert_true(samples[0][1] == 15);

}

/*
* Register Tests
*/
int main(void)
{
    const struct CMUnitTest tests[] = {
            cmocka_unit_test(test_transform),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}

