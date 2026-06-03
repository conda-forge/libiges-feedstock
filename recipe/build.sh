#!/bin/bash
set -ex

cmake ${CMAKE_ARGS} -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX

cmake --build build
cmake --install build

# Skip running the test binaries when cross-compiling (e.g. osx-arm64 built on
# an x86_64 runner), unless an emulator is available: the target binaries
# cannot be executed on the host otherwise.
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
    ctest --test-dir build/src --output-on-failure
fi
