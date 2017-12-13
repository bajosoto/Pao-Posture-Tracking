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
#include <preprocessor.h>
#include <mat.h>
#include <stdio.h>

#include "classifier.h"
#include "knn.h"

static void test_train_1(void **state)
{
    feature_t samples[2][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0}};
    class_t labels[2] = {CLASS_STILL_UNHEALTHY,
                         CLASS_STILL_UNHEALTHY};
    knn_init(1);
    clf_init(CLF_KNN,0,NULL);
    clf_fit(2, samples, labels);
    assert_true(clf_predict(samples[0]) == CLASS_STILL_UNHEALTHY);

}
static void test_train_2(void **state)
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
    clf_fit(4, samples, labels);
    assert_true(clf_predict(test_sample) == CLASS_STILL_HEALTHY);

}

static void test_train_3(void **state)
{
    feature_t samples[4][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0},
                                     {6.0,1.0},
                                     {2.0,3.0}};

    feature_t test_sample[CLF_DIM] = {1.5,2.5};
    class_t labels[4] = {CLASS_STILL_HEALTHY,
                         CLASS_STILL_UNHEALTHY,
                         CLASS_STILL_UNHEALTHY,
                         CLASS_STILL_UNHEALTHY};

    knn_init(4);
    clf_fit(4, samples, labels);
    clf_init(CLF_KNN,0,NULL);
    assert_true(clf_predict(test_sample) == CLASS_STILL_UNHEALTHY);

}

static void test_scale_classify(void **state){
    feature_t samples[4][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0},
                                     {6.0,1.0},
                                     {2.0,3.0}};

    feature_t test_sample[CLF_DIM] = {1.5,2.5};
    class_t labels[4] = {CLASS_STILL_HEALTHY,
                         CLASS_STILL_UNHEALTHY,
                         CLASS_STILL_UNHEALTHY,
                         CLASS_STILL_UNHEALTHY};

    knn_init(4);
    transformer_t scalers[1] = {TRANSF_SCALE_STD};
    clf_init(CLF_KNN,1,scalers);
    clf_fit(4, samples, labels);
    assert_true(clf_predict(test_sample) == CLASS_STILL_UNHEALTHY);
}

static void test_preprocess_scale_classify(void **state){
    /* Some random values generated with matlab
         each class follows a normal distribution around
         a different mean */
    feature_t const raw_samples[8][RAW_DIM] = {{ 2932, -4019,  6957, -2664, -7102,  9407, -6580,  1720, 1101},
                                    { 6968,  2276,  6828, -8007,  6011, -8313,  4011,  7999, 3001},
                                    {-6663,  3544, -1927,  2378, -4965,  3561,  1103,  7437, -753},
                                    {-7158,   595, -1664, -4646, -6766,  6544,  5131,  1682, -4363},
                                    {9943,  -6623,   3347,  11330,   -759,   1746,   4062,  7086,   5099},
                                    {6152,  -8198,   5529,   5184,    997,    317,   9233, 5349,   3941},
                                    {-1896,   5473,   3671,    904,   8221,   3144,   2457,5190,  -4494},
                                    {3199,   5523,   -639,   1002,   3565,   6418,   -432, 982,   1943}};

    class_t labels[4] = {CLASS_STILL_UNHEALTHY,
                         CLASS_STILL_UNHEALTHY,
                         CLASS_STILL_HEALTHY,
                         CLASS_STILL_HEALTHY};

    knn_init(1);
    transformer_t scalers[1] = {TRANSF_SCALE_STD};
    clf_init(CLF_KNN,1,scalers);

    feature_t samples[4][CLF_DIM];
    prep_transform(8,raw_samples,4,samples);
    clf_fit(4, samples, labels);
    assert_true(clf_predict(samples[0]) == CLASS_STILL_UNHEALTHY);
    assert_true(clf_predict(samples[1]) == CLASS_STILL_UNHEALTHY);
    assert_true(clf_predict(samples[2]) == CLASS_STILL_HEALTHY);
    assert_true(clf_predict(samples[3]) == CLASS_STILL_HEALTHY);

}

static void test_scale_classify_proba(void **state)
{
    feature_t samples[4][CLF_DIM] = {{1.0,2.0},
                                     {5.0,1.0},
                                     {6.0,1.0},
                                     {2.0,3.0}};

    class_t labels[4] = {CLASS_STILL_HEALTHY,
                         CLASS_STILL_HEALTHY,
                         CLASS_STILL_HEALTHY,
                         CLASS_STILL_UNHEALTHY};

    knn_init(4);
    transformer_t scalers[1] = {TRANSF_SCALE_STD};
    clf_init(CLF_KNN,1,scalers);


    clf_fit(4, samples, labels);
    proba_t pdfs[CLASS_NCLASSES];
    memset(pdfs,0,sizeof(proba_t)*CLASS_NCLASSES);
    class_t prediction = clf_predict_proba(samples,pdfs);
    assert_true(pdfs[CLASS_STILL_HEALTHY] == 0.75);
    assert_true(pdfs[CLASS_STILL_UNHEALTHY] == 0.25);
    assert_true(prediction == CLASS_STILL_HEALTHY);

}

static void test_full_4_classes(void **state){
    /* Some random values generated with matlab
        each class follows a normal distribution around
        a different mean */
    feature_t raw_samples[16][RAW_DIM] = {{302059,  311892,  328724,  314090,  366105,  297056,  304204,  311898,  398831},
                                          {315065,  330153,  309342,  293722,  334431,  309373,  318552,  380989,  295388},
                                          {312436,  298537,  344487,  262788,  313841,  326388,  385832,  355044,  330292},
                                          {351566,  362731,  303741,  342252,  302703,  309311,  351268,  395590,  325183},
                                          {679190,  625584,  669668,  663964,  744811,  685762,  718557,  665978,  643931},
                                          {635464,  634764,  675853,  631189,  650649,  687418,  669794,  594957,  602996},
                                          {584975,  625144,  640781,  645618,  684277,  602086,  671255,  646617,  628929},
                                          {670141,  702627,  641175,  661168,  658250,  672704,  624727,  668939,  695402},
                                          {1003039, 917433,  1028758, 992611,  988342,  929013,  1000001, 1010609, 989244},
                                          {907849,  965844,  1002620, 969149,  981863,  979351,  971731,  983675,  948002},
                                          {982101,  1000363, 961233,  996807,  946755,  1012943, 977604,  1012184, 955194},
                                          {1014769, 1008881, 992386,  966761,  984999,  982830,  978771,  998926,  909259},
                                          {1297455, 1352661, 1270248, 1318715, 1229549, 1315849, 1398888, 1325705, 1328335},
                                          {1280600, 1350313, 1281103, 1263721, 1346888, 1264659, 1319496, 1335224, 1324791},
                                          {1320636, 1351038, 1347974, 1274803, 1293685, 1294260, 1302000, 1307297, 1320920},
                                          {1328895, 1345072, 1318636, 1307066, 1299297, 1358920, 1299399, 1293797, 1308654}};

    class_t labels[8] =  {CLASS_STILL_HEALTHY,
                          CLASS_STILL_HEALTHY,
                          CLASS_STILL_UNHEALTHY,
                          CLASS_STILL_UNHEALTHY,
                          CLASS_MOVING_HEALTHY,
                          CLASS_MOVING_HEALTHY,
                          CLASS_MOVING_UNHEALTHY,
                          CLASS_MOVING_UNHEALTHY,
    };

    knn_init(1);
    transformer_t scalers[1] = {TRANSF_SCALE_STD};
    clf_init(CLF_KNN,1,scalers);

    feature_t samples[8][CLF_DIM];
    prep_transform(16,raw_samples,8,samples);
    clf_fit(8, samples, labels);

    proba_t class_probabilities[CLASS_NCLASSES-1];
    for (int i = 0; i < 8; i++){
//        printf("I=%d-------------------\n",i);

        class_t label = clf_predict_proba(samples[i],class_probabilities);

//        vec_print(CLASS_NCLASSES-1,class_probabilities);

        assert_true(label == labels[i]);
        for (int j = 0; j < CLASS_NCLASSES-1; j++){
            if((class_t)j == label){
                assert_in_range(class_probabilities[j], 0.6, 1.0);
            }else{
                assert_in_range(class_probabilities[j], 0, 0.4);
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
            cmocka_unit_test(test_scale_classify),
            cmocka_unit_test( test_preprocess_scale_classify),
            cmocka_unit_test(test_scale_classify_proba),
            cmocka_unit_test(test_full_4_classes)
    };

    return cmocka_run_group_tests(tests, NULL, NULL);
}

