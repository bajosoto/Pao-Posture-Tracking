# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build

# Include any dependencies generated for this target.
include example/CMakeFiles/key_value_test.dir/depend.make

# Include the progress variables for this target.
include example/CMakeFiles/key_value_test.dir/progress.make

# Include the compile flags for this target's objects.
include example/CMakeFiles/key_value_test.dir/flags.make

example/CMakeFiles/key_value_test.dir/key_value.c.o: example/CMakeFiles/key_value_test.dir/flags.make
example/CMakeFiles/key_value_test.dir/key_value.c.o: ../example/key_value.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object example/CMakeFiles/key_value_test.dir/key_value.c.o"
	cd /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build/example && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/key_value_test.dir/key_value.c.o   -c /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/example/key_value.c

example/CMakeFiles/key_value_test.dir/key_value.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/key_value_test.dir/key_value.c.i"
	cd /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build/example && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/example/key_value.c > CMakeFiles/key_value_test.dir/key_value.c.i

example/CMakeFiles/key_value_test.dir/key_value.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/key_value_test.dir/key_value.c.s"
	cd /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build/example && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/example/key_value.c -o CMakeFiles/key_value_test.dir/key_value.c.s

example/CMakeFiles/key_value_test.dir/key_value.c.o.requires:

.PHONY : example/CMakeFiles/key_value_test.dir/key_value.c.o.requires

example/CMakeFiles/key_value_test.dir/key_value.c.o.provides: example/CMakeFiles/key_value_test.dir/key_value.c.o.requires
	$(MAKE) -f example/CMakeFiles/key_value_test.dir/build.make example/CMakeFiles/key_value_test.dir/key_value.c.o.provides.build
.PHONY : example/CMakeFiles/key_value_test.dir/key_value.c.o.provides

example/CMakeFiles/key_value_test.dir/key_value.c.o.provides.build: example/CMakeFiles/key_value_test.dir/key_value.c.o


example/CMakeFiles/key_value_test.dir/key_value_test.c.o: example/CMakeFiles/key_value_test.dir/flags.make
example/CMakeFiles/key_value_test.dir/key_value_test.c.o: ../example/key_value_test.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object example/CMakeFiles/key_value_test.dir/key_value_test.c.o"
	cd /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build/example && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/key_value_test.dir/key_value_test.c.o   -c /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/example/key_value_test.c

example/CMakeFiles/key_value_test.dir/key_value_test.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/key_value_test.dir/key_value_test.c.i"
	cd /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build/example && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/example/key_value_test.c > CMakeFiles/key_value_test.dir/key_value_test.c.i

example/CMakeFiles/key_value_test.dir/key_value_test.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/key_value_test.dir/key_value_test.c.s"
	cd /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build/example && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/example/key_value_test.c -o CMakeFiles/key_value_test.dir/key_value_test.c.s

example/CMakeFiles/key_value_test.dir/key_value_test.c.o.requires:

.PHONY : example/CMakeFiles/key_value_test.dir/key_value_test.c.o.requires

example/CMakeFiles/key_value_test.dir/key_value_test.c.o.provides: example/CMakeFiles/key_value_test.dir/key_value_test.c.o.requires
	$(MAKE) -f example/CMakeFiles/key_value_test.dir/build.make example/CMakeFiles/key_value_test.dir/key_value_test.c.o.provides.build
.PHONY : example/CMakeFiles/key_value_test.dir/key_value_test.c.o.provides

example/CMakeFiles/key_value_test.dir/key_value_test.c.o.provides.build: example/CMakeFiles/key_value_test.dir/key_value_test.c.o


# Object files for target key_value_test
key_value_test_OBJECTS = \
"CMakeFiles/key_value_test.dir/key_value.c.o" \
"CMakeFiles/key_value_test.dir/key_value_test.c.o"

# External object files for target key_value_test
key_value_test_EXTERNAL_OBJECTS =

example/key_value_test: example/CMakeFiles/key_value_test.dir/key_value.c.o
example/key_value_test: example/CMakeFiles/key_value_test.dir/key_value_test.c.o
example/key_value_test: example/CMakeFiles/key_value_test.dir/build.make
example/key_value_test: src/libcmocka.so.0.4.1
example/key_value_test: example/CMakeFiles/key_value_test.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking C executable key_value_test"
	cd /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build/example && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/key_value_test.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
example/CMakeFiles/key_value_test.dir/build: example/key_value_test

.PHONY : example/CMakeFiles/key_value_test.dir/build

example/CMakeFiles/key_value_test.dir/requires: example/CMakeFiles/key_value_test.dir/key_value.c.o.requires
example/CMakeFiles/key_value_test.dir/requires: example/CMakeFiles/key_value_test.dir/key_value_test.c.o.requires

.PHONY : example/CMakeFiles/key_value_test.dir/requires

example/CMakeFiles/key_value_test.dir/clean:
	cd /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build/example && $(CMAKE_COMMAND) -P CMakeFiles/key_value_test.dir/cmake_clean.cmake
.PHONY : example/CMakeFiles/key_value_test.dir/clean

example/CMakeFiles/key_value_test.dir/depend:
	cd /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/example /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build/example /home/phil/Code/Pao/Pao-Posture-Tracking/Pao/test/cmocka/_build/example/CMakeFiles/key_value_test.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : example/CMakeFiles/key_value_test.dir/depend

