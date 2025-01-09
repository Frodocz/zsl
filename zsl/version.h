// Copyright(c) 2025-present, Zhang Chao & zsl contributors.
// Distributed under the MIT License (http://opensource.org/licenses/MIT)

#pragma once

#define ZSL_VER_MAJOR 0
#define ZSL_VER_MINOR 1
#define ZSL_VER_PATCH 0

#define ZSL_TO_VERSION(major, minor, patch) (major * 10000 + minor * 100 + patch)
#define ZSL_VERSION ZSL_TO_VERSION(ZSL_VER_MAJOR, ZSL_VER_MINOR, ZSL_VER_PATCH)
