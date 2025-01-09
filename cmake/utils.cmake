# Copyright(c) 2024-present zsl authors Distributed under the MIT License (http://opensource.org/licenses/MIT)

# Get zsl version from zsl/version.h and put it in ZSL_VERSION
function(zsl_extract_version)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/zsl/version.h" file_contents)
    string(REGEX MATCH "ZSL_VER_MAJOR ([0-9]+)" _ "${file_contents}")
    if(NOT CMAKE_MATCH_COUNT EQUAL 1)
        message(FATAL_ERROR "Could not extract major version number from zsl/version.h")
    endif()
    set(ver_major ${CMAKE_MATCH_1})

    string(REGEX MATCH "ZSL_VER_MINOR ([0-9]+)" _ "${file_contents}")
    if(NOT CMAKE_MATCH_COUNT EQUAL 1)
        message(FATAL_ERROR "Could not extract minor version number from zsl/version.h")
    endif()

    set(ver_minor ${CMAKE_MATCH_1})
    string(REGEX MATCH "ZSL_VER_PATCH ([0-9]+)" _ "${file_contents}")
    if(NOT CMAKE_MATCH_COUNT EQUAL 1)
        message(FATAL_ERROR "Could not extract patch version number from zsl/version.h")
    endif()
    set(ver_patch ${CMAKE_MATCH_1})

    set(ZSL_VERSION_MAJOR ${ver_major} PARENT_SCOPE)
    set(ZSL_VERSION_MINOR ${ver_minor} PARENT_SCOPE)
    set(ZSL_VERSION_PATCH ${ver_patch} PARENT_SCOPE)
    set(ZSL_VERSION "${ver_major}.${ver_minor}.${ver_patch}" PARENT_SCOPE)
endfunction()

# Turn on warnings on the given target
function(zsl_enable_warnings target_name)
    if(ZSL_BUILD_WARNINGS)
        if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
            list(APPEND MSVC_OPTIONS "/W3")
            if(MSVC_VERSION GREATER 1900) # Allow non fatal security warnings for msvc 2015
                list(APPEND MSVC_OPTIONS "/WX")
            endif()
        endif()

        target_compile_options(
            ${target_name}
            PRIVATE $<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
                    -Wall
                    -Wextra
                    -Wconversion
                    -pedantic
                    -Werror
                    -Wfatal-errors>
                    $<$<CXX_COMPILER_ID:MSVC>:${MSVC_OPTIONS}>)
    endif()
endfunction()

# Enable address sanitizer (gcc/clang only)
function(zsl_enable_addr_sanitizer target_name)
    if(NOT CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        message(FATAL_ERROR "Sanitizer supported only for gcc/clang")
    endif()
    message(STATUS "Address sanitizer enabled")
    target_compile_options(${target_name} PRIVATE -fsanitize=address,undefined)
    target_compile_options(${target_name} PRIVATE -fno-sanitize=signed-integer-overflow)
    target_compile_options(${target_name} PRIVATE -fno-sanitize-recover=all)
    target_compile_options(${target_name} PRIVATE -fno-omit-frame-pointer)
    target_link_libraries(${target_name} PRIVATE -fsanitize=address,undefined)
endfunction()

# Enable thread sanitizer (gcc/clang only)
function(zsl_enable_thread_sanitizer target_name)
    if(NOT CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        message(FATAL_ERROR "Sanitizer supported only for gcc/clang")
    endif()
    message(STATUS "Thread sanitizer enabled")
    target_compile_options(${target_name} PRIVATE -fsanitize=thread)
    target_compile_options(${target_name} PRIVATE -fno-omit-frame-pointer)
    target_link_libraries(${target_name} PRIVATE -fsanitize=thread)
endfunction()

# Define the function to set common compile options
function(set_common_compile_options target_name)
    cmake_parse_arguments(COMPILE_OPTIONS "" "VISIBILITY" "" ${ARGN})

    # Set default visibility to PRIVATE if not provided
    if (NOT DEFINED COMPILE_OPTIONS_VISIBILITY)
        set(COMPILE_OPTIONS_VISIBILITY PRIVATE)
    endif ()

    target_compile_options(${target_name} ${COMPILE_OPTIONS_VISIBILITY}
            $<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
            -Wall -Wextra -pedantic -Werror -Wredundant-decls>
            $<$<CXX_COMPILER_ID:MSVC>:/bigobj /WX /W4 /wd4324 /wd4996>)

    if (ZSL_NO_EXCEPTIONS)
        # Add flags -fno-exceptions -fno-rtti to make sure we support them
        target_compile_options(${target_name} ${COMPILE_OPTIONS_VISIBILITY}
                $<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
                -fno-exceptions -fno-rtti>
                $<$<CXX_COMPILER_ID:MSVC>:/wd4702 /GR- /EHs-c- /D_HAS_EXCEPTIONS=0>)
    else ()
        # Additional MSVC specific options
        if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
            target_compile_options(${target_name} ${COMPILE_OPTIONS_VISIBILITY} /EHsc)
        endif ()
    endif ()
endfunction()
