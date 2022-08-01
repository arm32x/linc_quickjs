#pragma once

// hxcpp include should always be first
#ifndef HXCPP_H
#include <hxcpp.h>
#endif

// include other library includes as needed
#include "quickjs.h"

namespace linc {
namespace quickjs {

    struct malloc_functions {
        cpp::Function<void*(JSMallocState*, size_t)> js_malloc;
        cpp::Function<void(JSMallocState*, void*)> js_free;
        cpp::Function<void*(JSMallocState*, void*, size_t)> js_realloc;
        cpp::Function<size_t(const void*)> js_malloc_usable_size;
    };

    extern JSRuntime* new_runtime_2(malloc_functions* mf, void* opaque);

}
}
