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

#include "std_scaler.h"
#include "mat.h"
static void test_fit_transform(void **state)
{
    feature_t samples[2][CLF_DIM] = {{10,20},
                                     {50,10}};

    stds_fit(2,samples);
    stds_transform(samples[0], samples[0]);
    stds_transform(samples[1], samples[1]);
//    mat_print(2,CLF_DIM,samples);
    assert_in_range(samples[0][0],-32768,32768);
    assert_in_range(samples[0][1],-32768,32768);
    assert_in_range(samples[1][0],-32768,32768);
    assert_in_range(samples[1][1],-32768,32768);
    assert_true(samples[1][0] == 32768);
    assert_true(samples[0][0] == -32768);

}

/*
* Register Tests
*/
int main(void)
{
    const struct CMUnitTest tests[] = {
            cmocka_unit_test(test_fit_transform),
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}

