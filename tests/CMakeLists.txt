# Copyright(c) 2025-present zsl authors Distributed under the MIT License (http://opensource.org/licenses/MIT)

cmake_minimum_required(VERSION 3.14)
project(zsl_utests CXX)

# if(NOT TARGET zsl)
#     # Stand-alone build
#     find_package(zsl REQUIRED)
# endif()

# include(../cmake/utils.cmake)

# find_package(Catch2 3 QUIET)
# if(Catch2_FOUND)
#     message(STATUS "Packaged version of Catch will be used.")
# else()
#     message(STATUS "Bundled version of Catch will be downloaded and used.")
#     include(FetchContent)
#     FetchContent_Declare(Catch2
#             GIT_REPOSITORY https://github.com/catchorg/Catch2.git
#             GIT_TAG fa43b77429ba76c462b1898d6cd2f2d7a9416b14 # v3.7.1
#     )
#     FetchContent_MakeAvailable(Catch2)
# endif()

set(ZSL_UTESTS_SOURCES
    test_logging.cpp
    test_quill_logging.cpp
)

include_directories(../zsl/)

# enable_testing()

# function(zsl_prepare_test test_target zsl_lib)
#     add_executable(${test_target} ${ZSL_UTESTS_SOURCES})
#     zsl_enable_warnings(${test_target})
#     target_link_libraries(${test_target} PRIVATE ${zsl_lib})
#     target_link_libraries(${test_target} PRIVATE Catch2::Catch2WithMain)
#     if(ZSL_SANITIZE_ADDRESS)
#         zsl_enable_addr_sanitizer(${test_target})
#     elseif (ZSL_SANITIZE_THREAD)
#         zsl_enable_thread_sanitizer(${test_target})
#     endif ()
#     add_test(NAME ${test_target} COMMAND ${test_target})
#     set_tests_properties(${test_target} PROPERTIES RUN_SERIAL ON)
# endfunction()

# # The compiled library tests
# if(ZSL_BUILD_TESTS OR ZSL_BUILD_ALL)
#     zsl_prepare_test(zsl-utests zsl::zsl)
# endif()

add_executable(test_logging test_logging.cc)
target_link_libraries(test_logging zsl-static)
