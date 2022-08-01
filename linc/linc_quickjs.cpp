// hxcpp include should be first
#include <hxcpp.h>

#include "./linc_quickjs.hpp"
#include "quickjs.h"

namespace linc {
namespace quickjs {

    JSRuntime* new_runtime_2(malloc_functions* mf, void* opaque) {
        JSMallocFunctions real_mf = {
            mf->js_malloc,
            mf->js_free,
            mf->js_realloc,
            mf->js_malloc_usable_size,
        };
        return JS_NewRuntime2(&real_mf, opaque);
    }

}
}
