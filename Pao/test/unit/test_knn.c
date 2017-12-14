
#include <stdint.h>
#include <stddef.h>
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>
#include <string.h>

#include "classifier.h"
#include "knn.h"
#include <stdio.h>
#include <mat.h>

/*
* Test is test compiled correctly
*/
static void test_train_1(void **state)
{
    feature_t samples[2][CLF_DIM] = {{10,20},
    					 			{50,10}};
    class_t labels[2] = {CLASS_STILL_UNHEALTHY,
                         CLASS_STILL_UNHEALTHY};
    knn_init(1);
    knn_fit(2, samples, labels);
    assert_true(knn_class_pdf(samples[0], CLASS_STILL_UNHEALTHY) == 100);

}

static void test_train_2(void **state)
{
    feature_t samples[2][CLF_DIM] = {{10,20},
                                     {50,10}};

    feature_t test_sample[CLF_DIM] = {25, 15};
    class_t labels[2] = {CLASS_STILL_HEALTHY,
                         CLASS_STILL_UNHEALTHY};

    knn_init(2);
    knn_fit(2, samples, labels);
    assert_true(knn_class_pdf(test_sample, CLASS_STILL_HEALTHY) == 50);
    assert_true(knn_class_pdf(test_sample, CLASS_STILL_UNHEALTHY) == 50);

}

static void test_train_3(void **state)
{
    feature_t samples[4][CLF_DIM] = {{10,20},
                                     {50,10},
                                     {60,10},
                                     {20,30}};

    feature_t test_sample[CLF_DIM] = {10,20};
    class_t labels[4] = {CLASS_STILL_HEALTHY,
                         CLASS_STILL_HEALTHY,
                         CLASS_STILL_HEALTHY,
                         CLASS_STILL_UNHEALTHY};

    knn_init(4);
    knn_fit(4, samples, labels);
    assert_true(knn_class_pdf(test_sample, CLASS_STILL_HEALTHY) == 75);
    assert_true(knn_class_pdf(test_sample, CLASS_STILL_UNHEALTHY) == 25);

}

static void test_probas(void **state)
{
    feature_t samples[4][CLF_DIM] = {{10,20},
                                     {50,10},
                                     {60,10},
                                     {20,30}};

    feature_t test_sample[CLF_DIM] = {15,25};
    class_t labels[4] = {CLASS_STILL_HEALTHY,
                         CLASS_STILL_HEALTHY,
                         CLASS_STILL_HEALTHY,
                         CLASS_STILL_UNHEALTHY};

    knn_init(4);
    knn_fit(4, samples, labels);
    proba_t pdfs[CLASS_NCLASSES];
    memset(pdfs,0,sizeof(proba_t)*CLASS_NCLASSES-1);
    knn_pdf(test_sample, pdfs);
    assert_true(pdfs[CLASS_STILL_HEALTHY] == 75);
    assert_true(pdfs[CLASS_STILL_UNHEALTHY] == 25);

}

static void test_4_classes(void **state) {
    /* Some random values generated with matlab
        each class follows a normal distribution around
        a different mean */
    feature_t samples[16][CLF_DIM] = {
            {-5010, -4980},
            {-5000, -4990},
            {-4990, -5010},
            {-4990, -4990},
            {-1, 0},
            {-1, 0},
            {0, -1},
            {0, 0},
            {499, 499},
            {499, 499},
            {499, 501},
            {499, 498},
            {2002, 2001},
            {2000, 1999},
            {2000, 1999},
            {1999, 1999},

    };


    class_t labels[16] = {CLASS_STILL_HEALTHY,
                          CLASS_STILL_HEALTHY,
                          CLASS_STILL_HEALTHY,
                          CLASS_STILL_HEALTHY,
                          CLASS_STILL_UNHEALTHY,
                          CLASS_STILL_UNHEALTHY,
                          CLASS_STILL_UNHEALTHY,
                          CLASS_STILL_UNHEALTHY,
                          CLASS_MOVING_HEALTHY,
                          CLASS_MOVING_HEALTHY,
                          CLASS_MOVING_HEALTHY,
                          CLASS_MOVING_HEALTHY,
                          CLASS_MOVING_UNHEALTHY,
                          CLASS_MOVING_UNHEALTHY,
                          CLASS_MOVING_UNHEALTHY,
                          CLASS_MOVING_UNHEALTHY,
    };

    knn_init(3);

    knn_fit(16, samples, labels);

    proba_t pdfs[CLASS_NCLASSES - 1];
    for (int i = 0; i < 16; i++) {
//        printf("I=%d-------------------\n",i);
        memset(pdfs, 0, sizeof(proba_t) * (CLASS_NCLASSES - 1));
        knn_pdf(samples[i], pdfs);

//        vec_print(CLASS_NCLASSES-1,pdfs);

        for (int j = 0; j < CLASS_NCLASSES - 1; j++) {

            if ((class_t) j == labels[i]) {
                assert_in_range(pdfs[j], 60, 100);
            } else {
                assert_in_range(pdfs[j], 0, 40);
            }

        }

    }
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
            cmocka_unit_test(test_4_classes),
            cmocka_unit_test(test_probas)

    };

	return cmocka_run_group_tests(tests, NULL, NULL);
}

