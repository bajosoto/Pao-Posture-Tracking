//
// Created by phil on 3-12-17.
//


#include <stdint.h>
#include <stddef.h>
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>
#include <string.h>

#include "classifier.h"
#include "knn.h"

static void test_train_1(void **state)
{
    feature_t samples[2][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0}};
    class_t labels[2] = {CLASS_UNHEALTHY,
                         CLASS_UNHEALTHY};
    knn_init(1);
    clf_init(CLF_KNN,0,NULL);
    clf_fit(2, samples, labels);
    assert_true(clf_predict(samples[0]) == CLASS_UNHEALTHY);

}
static void test_train_2(void **state)
{
    feature_t samples[4][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0},
                                     {6.0,1.0},
                                     {2.0,3.0}};

    feature_t test_sample[CLF_DIM] = {1.5,2.5};
    class_t labels[4] = {CLASS_HEALTHY,
                         CLASS_HEALTHY,
                         CLASS_HEALTHY,
                         CLASS_UNHEALTHY};

    knn_init(4);
    clf_fit(4, samples, labels);
    assert_true(clf_predict(test_sample) == CLASS_HEALTHY);

}

static void test_train_3(void **state)
{
    feature_t samples[4][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0},
                                     {6.0,1.0},
                                     {2.0,3.0}};

    feature_t test_sample[CLF_DIM] = {1.5,2.5};
    class_t labels[4] = {CLASS_HEALTHY,
                         CLASS_UNHEALTHY,
                         CLASS_UNHEALTHY,
                         CLASS_UNHEALTHY};

    knn_init(4);
    clf_fit(4, samples, labels);
    assert_true(clf_predict(test_sample) == CLASS_UNHEALTHY);

}

static void test_scale_classify(void **state){
    feature_t samples[4][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0},
                                     {6.0,1.0},
                                     {2.0,3.0}};

    feature_t test_sample[CLF_DIM] = {1.5,2.5};
    class_t labels[4] = {CLASS_HEALTHY,
                         CLASS_UNHEALTHY,
                         CLASS_UNHEALTHY,
                         CLASS_UNHEALTHY};

    knn_init(4);
    scaler_t scalers[1] = {SCALER_STD};
    clf_init(CLF_KNN,1,scalers);
    clf_fit(4, samples, labels);
    assert_true(clf_predict(test_sample) == CLASS_UNHEALTHY);
}

/*
* Register Tests
*/
int main(void)
{
    const struct CMUnitTest tests[] = {
            cmocka_unit_test(test_train_1),
            cmocka_unit_test(test_train_2),
            cmocka_unit_test(test_train_3),
            cmocka_unit_test(test_scale_classify)

    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}

