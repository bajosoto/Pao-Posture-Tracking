
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
    posture_t labels[2] = {POSTURE_HEALTHY,
                           POSTURE_HEALTHY};
    knn_init(1);
	knn_train(2, samples, labels);
    assert_true(knn_pdf(samples[0],POSTURE_HEALTHY) == 1.0);

}

static void test_train_2(void **state)
{
    feature_t samples[2][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0}};

    feature_t test_sample[CLF_DIM] = {1.5,2.5};
    posture_t labels[2] = {POSTURE_HEALTHY,
                           POSTURE_UNHEALTHY};

    knn_init(2);
    knn_train(2, samples, labels);
    assert_true(knn_pdf(test_sample,POSTURE_HEALTHY) == 0.5);
    assert_true(knn_pdf(test_sample,POSTURE_UNHEALTHY) == 0.5);

}

static void test_train_3(void **state)
{
    feature_t samples[4][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0},
                                     {6.0,1.0},
                                     {2.0,3.0}};

    feature_t test_sample[CLF_DIM] = {1.5,2.5};
    posture_t labels[4] = {POSTURE_HEALTHY,
                           POSTURE_HEALTHY,
                           POSTURE_HEALTHY,
                           POSTURE_UNHEALTHY};

    knn_init(4);
    knn_train(3, samples, labels);
    assert_true(knn_pdf(test_sample,POSTURE_HEALTHY) == 0.75);
    assert_true(knn_pdf(test_sample,POSTURE_UNHEALTHY) == 0.25);

}

/*
* Register Tests
*/
int main(void)
{
	const struct CMUnitTest tests[] = {
		cmocka_unit_test(test_train_1),
        cmocka_unit_test(test_train_2),
        cmocka_unit_test(test_train_3)
	};

	return cmocka_run_group_tests(tests, NULL, NULL);
}

