
#include <stdint.h>
#include <stddef.h>
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>
#include <string.h>

#include "classifier.h"
#include "knn.h"


/*
* Test is test compiled correctly
*/
static void test_train_1(void **state)
{
    feature_t samples[2][CLF_DIM] = {{1.0,2.0},
    					 			{5.0,1.0}};
    class_t labels[2] = {CLASS_HEALTHY,
                           CLASS_HEALTHY};
    knn_init(1);
	knn_train(2, samples, labels);
    assert_true(knn_class_pdf(samples[0], CLASS_HEALTHY) == 1.0);

}

static void test_train_2(void **state)
{
    feature_t samples[2][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0}};

    feature_t test_sample[CLF_DIM] = {1.5,2.5};
    class_t labels[2] = {CLASS_HEALTHY,
                           CLASS_UNHEALTHY};

    knn_init(2);
    knn_train(2, samples, labels);
    assert_true(knn_class_pdf(test_sample, CLASS_HEALTHY) == 0.5);
    assert_true(knn_class_pdf(test_sample, CLASS_UNHEALTHY) == 0.5);

}

static void test_train_3(void **state)
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
    knn_train(4, samples, labels);
    assert_true(knn_class_pdf(test_sample, CLASS_HEALTHY) == 0.75);
    assert_true(knn_class_pdf(test_sample, CLASS_UNHEALTHY) == 0.25);

}

static void test_train_all_classes(void **state)
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
    knn_train(4, samples, labels);
    proba_t pdfs[CLASS_NCLASSES];
    knn_pdf(test_sample, pdfs);
    assert_true(pdfs[CLASS_HEALTHY] == 0.75);
    assert_true(pdfs[CLASS_UNHEALTHY] == 0.25);

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
        cmocka_unit_test(test_train_all_classes)

    };

	return cmocka_run_group_tests(tests, NULL, NULL);
}

