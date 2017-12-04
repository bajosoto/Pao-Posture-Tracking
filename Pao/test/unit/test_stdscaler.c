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

static void test_fit_transform(void **state)
{
    feature_t samples[2][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0}};
    class_t labels[2] = {CLASS_HEALTHY,
                         CLASS_HEALTHY};

    stds_fit(2,samples);
    stds_transform(samples[0]);
    stds_transform(samples[1]);

    assert_in_range(samples[0][0],0.0,1.0);
    assert_in_range(samples[0][1],0.0,1.0);
    assert_in_range(samples[1][0],0.0,1.0);
    assert_in_range(samples[1][1],0.0,1.0);

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

