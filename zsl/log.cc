// Copyright(c) 2025-present, Zhang Chao & zsl contributors.
// Distributed under the MIT License (http://opensource.org/licenses/MIT)

#include "log.h"

#include "quill/Backend.h"
#include "quill/Frontend.h"
#include "quill/Logger.h"
#include "quill/sinks/RotatingFileSink.h"

// Define a global variable for a logger to avoid looking up the logger each time.
// Additional global variables can be defined for additional loggers if needed.
QUILL_EXPORT quill::Logger* global_logger;

void zsl::quillSetup(const char* logFile) {
    // Start the backend thread
    quill::Backend::start();

    // Setup sink and logger, rotate log file every 1 hour
    auto fileSink = quill::Frontend::create_or_get_sink<quill::RotatingFileSink>(
        logFile,
        []() {
            quill::RotatingFileSinkConfig cfg;
            cfg.set_open_mode('w');
            cfg.set_rotation_frequency_and_interval('H', 1U);
            cfg.set_rotation_naming_scheme(quill::RotatingFileSinkConfig::RotationNamingScheme::DateAndTime);
            cfg.set_timezone(quill::Timezone::GmtTime);
            return cfg;
        }(),
        quill::FileEventNotifier{});
    
    global_logger = quill::Frontend::create_or_get_logger(
        "root",
        std::move(fileSink),
        quill::PatternFormatterOptions{
            "%(time) [%(thread_id)] %(short_source_location:<20) "
            "%(log_level:<8) %(message)",
            "%H:%M:%S.%Qns", quill::Timezone::GmtTime}
    );
}
