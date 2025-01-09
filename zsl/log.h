// Copyright(c) 2025-present, Zhang Chao & zsl contributors.
// Distributed under the MIT License (http://opensource.org/licenses/MIT)

#pragma once

#include "quill/Logger.h"
#include "quill/LogMacros.h"

extern quill::Logger* global_logger;

#define LOG(severity, fmt, ...) \
    QUILL_LOGGER_CALL(QUILL_LIKELY, global_logger, nullptr, quill::LogLevel::severity, fmt, ##__VA_ARGS__)

namespace zsl {

void quillSetup(const char* logFile);

} // namespace zsl
