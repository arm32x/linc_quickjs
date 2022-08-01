package quickjs;

@:keep
@:allow(quickjs.JS)
@:include("linc_quickjs.hpp")
#if !display
@:build(linc.Linc.touch())
@:build(linc.Linc.xml("quickjs"))
#end
private extern class LincQuickJS {
    private inline static var LINC = 1;
}

// Documentation comments copied and modified from QuickJS and QuickJS.NET.
// https://github.com/lygstate/quickjs/blob/msvc/quickjs.h
// https://github.com/vmas/QuickJS.NET/blob/master/QuickJS.NET/Native/QuickJSNativeApi.cs
@:include("linc_quickjs.hpp")
extern class JS {
    private inline static var LINC = LincQuickJS.LINC;

    /**
        Initializes a new JavaScript runtime environment.

        On success, returns a pointer to the newly created runtime, which the
        caller must later destroy using `freeRuntime`. Otherwise, returns
        `null`.
    **/
    @:native("JS_NewRuntime")
    static function newRuntime(): cpp.Star<JSRuntime>;

    /**
        Sets a string containing information about the runtime. The lifetime of
        `info` must exceed that of `rt`.
    **/
    @:native("JS_SetRuntimeInfo")
    static function setRuntimeInfo(rt: cpp.Star<JSRuntime>, info: cpp.ConstCharStar): Void;

    /**
        Sets the global memory allocation limit for a `JSRuntime`.
    **/
    @:native("JS_SetMemoryLimit")
    static function setMemoryLimit(rt: cpp.Star<JSRuntime>, limit: cpp.SizeT): Void;

    @:native("JS_SetGCThreshold")
    static function setGCThreshold(rt: cpp.Star<JSRuntime>, gcThreshold: cpp.SizeT): Void;

    /**
        Enable or disable checks to avoid overflowing the system stack. Use 0 to
        disable the maximum stack size check.
    **/
    @:native("JS_SetMaxStackSize")
    static function setMaxStackSize(rt: cpp.Star<JSRuntime>, stackSize: cpp.SizeT): Void;

    /**
        Should be called when changing thread to update the stack top value used
        to check stack overflow.
    **/
    @:native("JS_UpdateStackTop")
    static function updateStackTop(rt: cpp.Star<JSRuntime>): Void;

    @:native("linc::quickjs::new_runtime_2")
    static function newRuntime2(mf: cpp.Star<JSMallocFunctions>, opaque: cpp.Star<cpp.Void>): cpp.Star<JSRuntime>;

    @:native("JS_FreeRuntime")
    static function freeRuntime(rt: cpp.Star<JSRuntime>): Void;

    @:native("JS_GetRuntimeOpaque")
    static function getRuntimeOpaque(rt: cpp.Star<JSRuntime>): cpp.Star<cpp.Void>;

    @:native("JS_SetRuntimeOpaque")
    static function setRuntimeOpaque(rt: cpp.Star<JSRuntime>, opaque: cpp.Star<cpp.Void>): Void;

    @:native("JS_MarkValue")
    static function markValue(rt: cpp.Star<JSRuntime>, val: JSValueConst, markFunc: JSMarkFunc): Void;

    /**
        Forces an immediate garbage collection.
    **/
    @:native("JS_RunGC")
    static function runGC(rt: cpp.Star<JSRuntime>): Void;

    @:native("JS_IsLiveObject")
    static function isLiveObject(rt: cpp.Star<JSRuntime>, obj: JSValueConst): Bool;

    @:native("JS_NewContext")
    static function newContext(rt: cpp.Star<JSRuntime>): cpp.Star<JSContext>;

    @:native("JS_FreeContext")
    static function freeContext(s: cpp.Star<JSContext>): Void;

    @:native("JS_DupContext")
    static function dupContext(ctx: cpp.Star<JSContext>): cpp.Star<JSContext>;

    @:native("JS_GetContextOpaque")
    static function getContextOpaque(ctx: cpp.Star<JSContext>): cpp.Star<cpp.Void>;

    @:native("JS_SetContextOpaque")
    static function setContextOpaque(ctx: cpp.Star<JSContext>, opaque: cpp.Star<cpp.Void>): Void;

    @:native("JS_GetRuntime")
    static function getRuntime(ctx: cpp.Star<JSContext>): cpp.Star<JSRuntime>;

    /**
        Sets the class prototype object.
    **/
    @:native("JS_SetClassProto")
    static function setClassProto(ctx: cpp.Star<JSContext>, classId: JSClassID, obj: JSValue): Void;

    /**
        Returns the builtin class prototype object.
    **/
    @:native("JS_GetClassProto")
    static function getClassProto(ctx: cpp.Star<JSContext>, classId: JSClassID): JSValue;
}

@:native("JSValue")
@:include("linc_quickjs.hpp")
extern class JSValue {}

@:native("JSValueConst")
@:include("linc_quickjs.hpp")
extern class JSValueConst {}

@:native("JSRuntime")
@:include("linc_quickjs.hpp")
extern class JSRuntime {}

@:native("JSContext")
@:include("linc_quickjs.hpp")
extern class JSContext {}

@:native("JSObject")
@:include("linc_quickjs.hpp")
extern class JSObject {}

@:native("JSClass")
@:include("linc_quickjs.hpp")
extern class JSClass {}

@:native("JSGCObjectHeader")
@:include("linc_quickjs.hpp")
extern class JSGCObjectHeader {}

typedef JSClassID = cpp.UInt32;
typedef JSAtom = cpp.UInt32;
typedef JSMarkFunc = cpp.Callable<(rt: cpp.Star<JSRuntime>, gp: cpp.Star<JSGCObjectHeader>) -> cpp.Void>;

@:native("JSMallocState")
@:include("linc_quickjs.hpp")
extern class JSMallocState {
    @:native("malloc_count") var mallocCount: cpp.SizeT;
    @:native("malloc_size") var mallocSize: cpp.SizeT;
    @:native("malloc_limit") var mallocLimit: cpp.SizeT;
    var opaque: cpp.Star<cpp.Void>;
}

@:native("linc::quickjs::malloc_functions")
@:include("linc_quickjs.hpp")
@:structAccess
extern class JSMallocFunctions {
    function new();

    @:native("js_malloc") var jsMalloc: cpp.Callable<(s: cpp.Star<JSMallocState>, size: cpp.SizeT) -> cpp.Star<cpp.Void>>;
    @:native("js_free") var jsFree: cpp.Callable<(s: cpp.Star<JSMallocState>, ptr: cpp.Star<cpp.Void>) -> Void>;
    @:native("js_realloc") var jsRealloc: cpp.Callable<(s: cpp.Star<JSMallocState>, ptr: cpp.Star<cpp.Void>, size: cpp.SizeT) -> cpp.Star<cpp.Void>>;
    @:native("js_malloc_usable_size") var jsMallocUsableSize: cpp.Callable<(ptr: cpp.RawConstPointer<cpp.Void>) -> cpp.SizeT>;
}
