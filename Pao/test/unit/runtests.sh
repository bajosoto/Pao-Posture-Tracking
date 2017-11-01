#/bin/bash

#for f (test-*) echo "${$(tput setaf 4)}running test: $f${$(tput sgr0)}" && ./$f
for f in test-*; do
    echo "$(tput setaf 4)Running test: $f $(tput sgr0)"
    ./$f
done
