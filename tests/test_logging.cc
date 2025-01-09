// Copyright(c) 2025-present, Zhang Chao & zsl contributors.
// Distributed under the MIT License (http://opensource.org/licenses/MIT)

#include "../zsl/version.h"
#include "../zsl/log.h"

#include <chrono>
#include <thread>

int main() {
    zsl::quillSetup("./logs/test.log");
    LOG(Info, "Hello zsl:{}.{}.{}", ZSL_VER_MAJOR, ZSL_VER_MINOR, ZSL_VER_PATCH);
    for (int i = 0; i < 100'000'000; ++i) {
        LOG(Error, "Hello from rotating logger, index is {}", i);
        std::this_thread::sleep_for(std::chrono::microseconds(100));
    }
    return 0;
}
