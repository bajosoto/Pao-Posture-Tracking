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
#include <mat.h>

#include "preprocessor.h"

static void test_transform(void **state)
{
    feature_t raw_samples[2][RAW_DIM]={{1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0},
                                       {2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0,2.0}};
    feature_t samples[1][CLF_DIM] = {{0.0,0.0}};

    prep_init(2);
    prep_transform(2,raw_samples,1,samples);
    vec_print(2,samples[0]);
    assert_true(samples[0][0] == 1.5);
    assert_true(samples[0][1] == 1.5);

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

