
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
    feature_t samples[2][CLF_DIM] = {{1.0,2.0},
    					 			{5.0,1.0}};
    class_t labels[2] = {CLASS_STILL_UNHEALTHY,
                         CLASS_STILL_UNHEALTHY};
    knn_init(1);
    knn_fit(2, samples, labels);
    assert_true(knn_class_pdf(samples[0], CLASS_STILL_UNHEALTHY) == 1.0);

}

static void test_train_2(void **state)
{
    feature_t samples[2][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0}};

    feature_t test_sample[CLF_DIM] = {2.5, 1.5};
    class_t labels[2] = {CLASS_STILL_HEALTHY,
                         CLASS_STILL_UNHEALTHY};

    knn_init(2);
    knn_fit(2, samples, labels);
    assert_true(knn_class_pdf(test_sample, CLASS_STILL_HEALTHY) == 0.5);
    assert_true(knn_class_pdf(test_sample, CLASS_STILL_UNHEALTHY) == 0.5);

}

static void test_train_3(void **state)
{
    feature_t samples[4][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0},
                                     {6.0,1.0},
                                     {2.0,3.0}};

    feature_t test_sample[CLF_DIM] = {1.5,2.5};
    class_t labels[4] = {CLASS_STILL_HEALTHY,
                         CLASS_STILL_HEALTHY,
                         CLASS_STILL_HEALTHY,
                         CLASS_STILL_UNHEALTHY};

    knn_init(4);
    knn_fit(4, samples, labels);
    assert_true(knn_class_pdf(test_sample, CLASS_STILL_HEALTHY) == 0.75);
    assert_true(knn_class_pdf(test_sample, CLASS_STILL_UNHEALTHY) == 0.25);

}

static void test_probas(void **state)
{
    feature_t samples[4][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0},
                                     {6.0,1.0},
                                     {2.0,3.0}};

    feature_t test_sample[CLF_DIM] = {1.5,2.5};
    class_t labels[4] = {CLASS_STILL_HEALTHY,
                         CLASS_STILL_HEALTHY,
                         CLASS_STILL_HEALTHY,
                         CLASS_STILL_UNHEALTHY};

    knn_init(4);
    knn_fit(4, samples, labels);
    proba_t pdfs[CLASS_NCLASSES];
    memset(pdfs,0,sizeof(proba_t)*CLASS_NCLASSES);
    knn_pdf(test_sample, pdfs);
    assert_true(pdfs[CLASS_STILL_HEALTHY] == 0.75);
    assert_true(pdfs[CLASS_STILL_UNHEALTHY] == 0.25);

}

static void test_4_classes(void **state) {
    /* Some random values generated with matlab
        each class follows a normal distribution around
        a different mean */
    feature_t samples[16][CLF_DIM] = {{22228, 9660},
                                      {41954, 41057},
                                      {11173, 33674},
                                      {117093, 82855},
                                      {356157, 262373},
                                      {301923, 297398},
                                      {356161, 382182},
                                      {116836, 75989},
                                      {619742, 652277},
                                      {697741, 665251},
                                      {653184, 676213},
                                      {671065, 701331},
                                      {975190, 1005666},
                                      {991095, 1051966},
                                      {995829, 894978},
                                      {988802, 1008729},
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
                assert_in_range(pdfs[j], 0.6, 1.0);
            } else {
                assert_in_range(pdfs[j], 0.0, 0.4);
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

