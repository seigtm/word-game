#!/usr/bin/env bash

# Set up build folder
BUILD_FOLDER="build"

# Create build folder
mkdir -p "$BUILD_FOLDER" || {
    echo "Error: Unable to create build folder '$BUILD_FOLDER'"
    exit 1
}

# Function to check for errors
check_error() {
    local code=$?
    local error_message=$1

    if [ $code -ne 0 ]; then
        echo "Error: $error_message. Exit code = $code."
        exit $code
    fi
}

# Compile assembly
nasm -g -F dwarf -f elf64 -o "$BUILD_FOLDER/coursework.o" coursework.nasm
check_error "Compilation failed"

# Outdated, because now I use GCC for C library functions:
# Link
# ld.gold -static -s -o "$BUILD_FOLDER/coursework" "$BUILD_FOLDER/coursework.o" -no-pie
# check_error "Linking failed"

# Use GCC
gcc -g -m64 -o "$BUILD_FOLDER/coursework" "$BUILD_FOLDER/coursework.o" -no-pie
check_error "Linking failed"

# Run the executable
EXECUTABLE_PATH="$BUILD_FOLDER/coursework"
if [ -x "$EXECUTABLE_PATH" ]; then
    "$EXECUTABLE_PATH"
    # Optional: debug
    # gdb --args "$BUILD_FOLDER/coursework"
    check_error "Execution failed"
else
    echo "Error: Executable '$EXECUTABLE_PATH' not found or not executable"
    exit 1
fi
