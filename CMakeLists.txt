# Copyright(c) 2025 zsl authors Distributed under the MIT License (http://opensource.org/licenses/MIT)

cmake_minimum_required(VERSION 3.15)

# ---------------------------------------------------------------------------------------
# Start zsl project
# ---------------------------------------------------------------------------------------
include(cmake/utils.cmake)

zsl_extract_version()

project(zsl VERSION ${ZSL_VERSION} LANGUAGES CXX)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

if(MSVC)
    add_compile_options(/std:c++latest)
else()
    add_compile_options(-Wall -O3 -std=c++17)
    #add_compile_options(-Wall -Ofast -std=c++2a -DNDEBUG -march=skylake -flto -fno-exceptions -fno-rtti -fno-unwind-tables -fno-asynchronous-unwind-tables)
    #SET(CMAKE_AR  "gcc-ar")
    #SET(CMAKE_RANLIB  "gcc-ranlib")
    link_libraries(pthread)
endif()

link_directories(.)
include_directories(third_party/quill/include) # log module used in the project

# add_library(zsl-shared SHARED src/log.cc)
# if(MSVC)
#   target_link_libraries(zsl-shared quill)
# endif()
# install(TARGETS zsl-shared)

add_library(zsl-static zsl/log.cc)
if(MSVC)
  target_link_libraries(zsl-static quill)
endif()
install(TARGETS zsl-static)

add_subdirectory(third_party/quill)
add_subdirectory(tests)
