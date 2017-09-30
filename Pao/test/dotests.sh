#!/bin/bash

#
# Build cmocka -> add libraries to LD_PATH -> build tests -> run tests
#

##"cmocka/_build/src/libcmocka*"

# Go to the scipt dir
cd $( dirname "${BASH_SOURCE[0]}")

# Build cmocka
start_dir=$(pwd) && \
cd cmocka && \
mkdir -p _build && \
cd _build && \
cmake ../ && \
make

if [ $? -eq 0 ]; then
    echo "Successfully build cmocka"
else
    echo "Failed to build cmocka"
fi

# Add library to LD_PATH
export LD_LIBRARY_PATH=$(pwd)/src/:$LD_LIBRARY_PATH

# Go back
cd $start_dir

# Build and run tests

cd unit && \
make run
