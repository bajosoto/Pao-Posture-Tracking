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
    feature_t samples[2][CLF_DIM] = {{10,40,30},
                                     {50,10,5}};

    stds_fit(2,samples);
    stds_transform(samples[0], samples[0]);
    stds_transform(samples[1], samples[1]);
//    mat_print(2,CLF_DIM,samples);
    assert_true(-32767 <= samples[0][0] && samples[0][0] <= -30000);
    assert_true(30000 <= samples[0][1] && samples[0][1] <= 32767);
    assert_true(30000 <= samples[0][2] && samples[0][2] <= 32767);
    assert_true(30000 <= samples[1][0] && samples[1][0] <= 32767);
    assert_true(-32767 <= samples[1][1] && samples[1][1] <= -30000);
    assert_true(-32767 <= samples[1][2] && samples[1][2] <= -30000);
    assert_true(samples[0][0] == 0-32767);

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

