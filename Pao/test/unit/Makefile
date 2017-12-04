# Build directory
BUILD_DIR = _build

PROGRAM = test

CMOCKA_LIB_PATH = $(abspath ../cmocka/_build/src/)

CFLAGS = -g -O2 -Wall -D PC_COMPILE -D TESTING_MSG
LDFLAGS = -L $(CMOCKA_LIB_PATH) -lcmocka -lm

PROJ_BASE=../../


# TODO: there should be a better way
VPATH = $(PROJ_BASE)/modules/:$(PROJ_BASE)/modules/classification/:$(BUILD_DIR)

# The command used to delete file.
RM = rm -f
MKDIR_P = mkdir -p


INC_PATHS += -I$(abspath $(PROJ_BASE)/modules)
INC_PATHS += -I$(abspath $(PROJ_BASE)/modules/classification)
INC_PATHS += -I$(abspath ../cmocka/include)

# Output directories needed
OUT_DIR = $(BUILD_DIR)


# Program sources
SOURCES_TEST_MATMULT = mat.c test_mat.c
OBJS_TEST_MATMULT = $(addsuffix .o, $(basename $(notdir $(SOURCES_TEST_MATMULT))))

SOURCES_TEST_KNN = knn.c test_knn.c mat.c
OBJS_TEST_KNN = $(addsuffix .o, $(basename $(notdir $(SOURCES_TEST_KNN))))

SOURCES_TEST_CLF = test_classifier.c classifier.c knn.c mat.c
OBJS_TEST_CLF = $(addsuffix .o, $(basename $(notdir $(SOURCES_TEST_CLF))))

SOURCES_TEST_STDSCALER = test_stdscaler.c std_scaler.c
OBJS_TEST_STDSCALER = $(addsuffix .o, $(basename $(notdir $(SOURCES_TEST_STDSCALER))))

SOURCES = $(SOURCES_TEST_MATMULT) $(SOURCES_TEST_KNN) $(SOURCES_TEST_CLF)
OBJS = $(addsuffix .o, $(basename $(notdir $(SOURCES))))

# TODO: C only flags?
COMPILE.c = $(CC) $(CFLAGS) $(INC_PATHS) -c
LINK.c = $(CC) $(CFLAGS)

.PHONY: all objs help directories
.SUFFIXES:

all: directories test-matmult test-knn test-clf test-stdscaler

run: all
	./runtests.sh
#objs:$(OBJS)

%.o:%.c
	$(COMPILE.c) $< -o $(BUILD_DIR)/$@

test-matmult:$(OBJS_TEST_MATMULT)
	$(LINK.c) $(addprefix $(BUILD_DIR)/, $(OBJS_TEST_MATMULT)) -o $@ $(LDFLAGS)

test-knn:$(OBJS_TEST_KNN)
	$(LINK.c) $(addprefix $(BUILD_DIR)/, $(OBJS_TEST_KNN)) -o $@ $(LDFLAGS)

test-clf:$(OBJS_TEST_CLF)
	$(LINK.c) $(addprefix $(BUILD_DIR)/, $(OBJS_TEST_CLF)) -o $@ $(LDFLAGS)

test-stdscaler:$(OBJS_TEST_STDSCALER)
	$(LINK.c) $(addprefix $(BUILD_DIR)/, $(OBJS_TEST_STDSCALER)) -o $@ $(LDFLAGS)


clean:
	$(RM) $(addprefix $(BUILD_DIR)/, $(OBJS)) test-*

directories:$(OUT_DIR)

$(OUT_DIR):
	@$(MKDIR_P) $(OUT_DIR)


