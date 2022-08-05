package quickjs;

import cpp.*;
import StdTypes.Void;

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

    // Special values.
    @:native("JS_NULL") static final NULL: JSValue;
    @:native("JS_UNDEFINED") static final UNDEFINED: JSValue;
    @:native("JS_FALSE") static final FALSE: JSValue;
    @:native("JS_TRUE") static final TRUE: JSValue;
    @:native("JS_EXCEPTION") static final EXCEPTION: JSValue;
    @:native("JS_UNINITIALIZED") static final UNINITIALIZED: JSValue;

    // Flags for object properties.
    inline static final PROP_CONFIGURABLE = 1 << 0;
    inline static final PROP_WRITABLE = 1 << 1;
    inline static final PROP_ENUMERABLE = 1 << 2;
    inline static final PROP_C_W_E = PROP_CONFIGURABLE | PROP_WRITABLE | PROP_ENUMERABLE;
    inline static final PROP_LENGTH = 1 << 3; // Used internally in Arrays.
    inline static final PROP_TMASK = 3 << 4; // Mask for NORMAL, GETSET, VARREF, AUTOINIT.
    inline static final PROP_NORMAL = 0 << 4;
    inline static final PROP_GETSET = 1 << 4;
    inline static final PROP_VARREF = 2 << 4; // Used internally.
    inline static final PROP_AUTOINIT = 3 << 4; // Used internally.

    // Flags for `JS.defineProperty`.
    inline static final PROP_HAS_SHIFT = 8;
    inline static final PROP_HAS_CONFIGURABLE = 1 << 8;
    inline static final PROP_HAS_WRITABLE = 1 << 9;
    inline static final PROP_HAS_ENUMERABLE = 1 << 10;
    inline static final PROP_HAS_GET = 1 << 11;
    inline static final PROP_HAS_SET = 1 << 12;
    inline static final PROP_HAS_VALUE = 1 << 13;

    /**
        Throw an exception if `false` would be returned
        (`JS.defineProperty`/`JS.setProperty`).
    **/
    inline static final PROP_THROW = 1 << 14;

    /**
        Throw an exception if `false` would be returned in strict mode
        (`JS.setProperty`).
    **/
    inline static final PROP_THROW_STRICT = 1 << 15;

    inline static final PROP_NO_ADD = 1 << 16; // Internal use.
    inline static final PROP_NO_EXOTIC = 1 << 17; // Internal use.

    inline static final DEFAULT_STACK_SIZE = 256 * 1024;

    // `JS.eval()` flags.
    inline static final EVAL_TYPE_GLOBAL = 0; // Global code (default).
    inline static final EVAL_TYPE_MODULE = 1; // Module code.
    inline static final EVAL_TYPE_DIRECT = 2; // Direct call (internal use).
    inline static final EVAL_TYPE_INDIRECT = 3; // Indirect call (internal use).
    inline static final EVAL_TYPE_MASK = 3;

    inline static final EVAL_FLAG_STRICT = 1 << 3; // Force 'strict' mode.
    inline static final EVAL_FLAG_STRIP = 1 << 4; // Force 'strip' mode.

    /**
        Compile but do not run. The result is an object with a
        `JS_TAG_FUNCTION_BYTECODE` or `JS_TAG_MODULE` tag. It can be executed
        with `JS.evalFunction()`.
    **/
    inline static final EVAL_FLAG_COMPILE_ONLY = 1 << 5;

    /**
        Don't include the stack frames before this eval in the `Error()`
        backtraces.
    **/
    inline static final EVAL_FLAG_BACKTRACE_BARRIER = 1 << 6;

    /**
        Initializes a new JavaScript runtime environment.

        On success, returns a pointer to the newly created runtime, which the
        caller must later destroy using `freeRuntime`. Otherwise, returns
        `null`.
    **/
    @:native("JS_NewRuntime")
    static function newRuntime(): Star<JSRuntime>;

    /**
        Sets a string containing information about the runtime. The lifetime of
        `info` must exceed that of `rt`.
    **/
    @:native("JS_SetRuntimeInfo")
    static function setRuntimeInfo(rt: Star<JSRuntime>, info: ConstCharStar): Void;

    /**
        Sets the global memory allocation limit for a `JSRuntime`.
    **/
    @:native("JS_SetMemoryLimit")
    static function setMemoryLimit(rt: Star<JSRuntime>, limit: SizeT): Void;

    @:native("JS_SetGCThreshold")
    static function setGCThreshold(rt: Star<JSRuntime>, gcThreshold: SizeT): Void;

    /**
        Enable or disable checks to avoid overflowing the system stack. Use 0 to
        disable the maximum stack size check.
    **/
    @:native("JS_SetMaxStackSize")
    static function setMaxStackSize(rt: Star<JSRuntime>, stackSize: SizeT): Void;

    /**
        Should be called when changing thread to update the stack top value used
        to check stack overflow.
    **/
    @:native("JS_UpdateStackTop")
    static function updateStackTop(rt: Star<JSRuntime>): Void;

    @:native("JS_NewRuntime2")
    static function newRuntime2(mf: Star<JSMallocFunctions>, opaque: Star<cpp.Void>): Star<JSRuntime>;

    @:native("JS_FreeRuntime")
    static function freeRuntime(rt: Star<JSRuntime>): Void;

    @:native("JS_GetRuntimeOpaque")
    static function getRuntimeOpaque(rt: Star<JSRuntime>): Star<cpp.Void>;

    @:native("JS_SetRuntimeOpaque")
    static function setRuntimeOpaque(rt: Star<JSRuntime>, opaque: Star<cpp.Void>): Void;

    @:native("JS_MarkValue")
    static function markValue(rt: Star<JSRuntime>, val: JSValueConst, markFunc: JSMarkFunc): Void;

    /**
        Forces an immediate garbage collection.
    **/
    @:native("JS_RunGC")
    static function runGC(rt: Star<JSRuntime>): Void;

    @:native("JS_IsLiveObject")
    static function isLiveObject(rt: Star<JSRuntime>, obj: JSValueConst): Bool;

    @:native("JS_NewContext")
    static function newContext(rt: Star<JSRuntime>): Star<JSContext>;

    @:native("JS_FreeContext")
    static function freeContext(s: Star<JSContext>): Void;

    @:native("JS_DupContext")
    static function dupContext(ctx: Star<JSContext>): Star<JSContext>;

    @:native("JS_GetContextOpaque")
    static function getContextOpaque(ctx: Star<JSContext>): Star<cpp.Void>;

    @:native("JS_SetContextOpaque")
    static function setContextOpaque(ctx: Star<JSContext>, opaque: Star<cpp.Void>): Void;

    @:native("JS_GetRuntime")
    static function getRuntime(ctx: Star<JSContext>): Star<JSRuntime>;

    /**
        Sets the class prototype object.
    **/
    @:native("JS_SetClassProto")
    static function setClassProto(ctx: Star<JSContext>, classId: JSClassID, obj: JSValue): Void;

    /**
        Returns the builtin class prototype object.
    **/
    @:native("JS_GetClassProto")
    static function getClassProto(ctx: Star<JSContext>, classId: JSClassID): JSValue;

    @:native("JS_NewContextRaw")
    static function newContextRaw(rt: Star<JSRuntime>): Star<JSContext>;

    @:native("JS_AddIntrinsicBaseObjects")
    static function addIntrinsicBaseObjects(ctx: Star<JSContext>): Void;

    @:native("JS_AddIntrinsicDate")
    static function addIntrinsicDate(ctx: Star<JSContext>): Void;

    @:native("JS_AddIntrinsicEval")
    static function addIntrinsicEval(ctx: Star<JSContext>): Void;

    @:native("JS_AddIntrinsicStringNormalize")
    static function addIntrinsicStringNormalize(ctx: Star<JSContext>): Void;

    @:native("JS_AddIntrinsicRegExpCompiler")
    static function addIntrinsicRegExpCompiler(ctx: Star<JSContext>): Void;

    @:native("JS_AddIntrinsicRegExp")
    static function addIntrinsicRegExp(ctx: Star<JSContext>): Void;

    @:native("JS_AddIntrinsicJSON")
    static function addIntrinsicJSON(ctx: Star<JSContext>): Void;

    @:native("JS_AddIntrinsicProxy")
    static function addIntrinsicProxy(ctx: Star<JSContext>): Void;

    @:native("JS_AddIntrinsicMapSet")
    static function addIntrinsicMapSet(ctx: Star<JSContext>): Void;

    @:native("JS_AddIntrinsicTypedArrays")
    static function addIntrinsicTypedArrays(ctx: Star<JSContext>): Void;

    @:native("JS_AddIntrinsicPromise")
    static function addIntrinsicPromise(ctx: Star<JSContext>): Void;

    @:native("JS_AddIntrinsicBigInt")
    static function addIntrinsicBigInt(ctx: Star<JSContext>): Void;

    @:native("JS_AddIntrinsicBigFloat")
    static function addIntrinsicBigFloat(ctx: Star<JSContext>): Void;

    @:native("JS_AddIntrinsicBigDecimal")
    static function addIntrinsicBigDecimal(ctx: Star<JSContext>): Void;

    /**
        Enable operator overloading. Must be called after all overloadable base
        types are initialized.
    **/
    @:native("JS_AddIntrinsicOperators")
    static function addIntrinsicOperators(ctx: Star<JSContext>): Void;

    /**
        Enable "use math."
    **/
    @:native("JS_EnableBignumExt")
    static function enableBignumExt(ctx: Star<JSContext>, enable: Bool): Void;

    @:native("js_string_codePointRange")
    static function stringCodePointRange(ctx: Star<JSContext>, thisVal: JSValueConst, argc: Int32,
        argv: Star<JSValueConst>): JSValue;

    @:native("js_malloc_rt")
    static function mallocRT(rt: Star<JSRuntime>, size: SizeT): Star<cpp.Void>;

    @:native("js_free_rt")
    static function freeRT(rt: Star<JSRuntime>, ptr: Star<cpp.Void>): Void;

    @:native("js_realloc_rt")
    static function reallocRT(rt: Star<JSRuntime>, ptr: Star<cpp.Void>, size: SizeT): Star<cpp.Void>;

    @:native("js_malloc_usable_size_rt")
    static function mallocUsableSizeRT(rt: Star<JSRuntime>, ptr: RawConstPointer<Void>): SizeT;

    @:native("js_mallocz_rt")
    static function malloczRT(rt: Star<JSRuntime>, size: SizeT): Star<cpp.Void>;

    @:native("js_malloc")
    static function malloc(ctx: Star<JSContext>, size: SizeT): Star<cpp.Void>;

    @:native("js_free")
    static function free(ctx: Star<JSContext>, ptr: Star<cpp.Void>): Void;

    @:native("js_realloc")
    static function realloc(ctx: Star<JSContext>, ptr: Star<cpp.Void>): Void;

    @:native("js_malloc_usable_size")
    static function mallocUsableSize(ctx: Star<JSContext>, ptr: RawConstPointer<Void>): SizeT;

    @:native("js_realloc2")
    static function realloc2(ctx: Star<JSContext>, ptr: Star<cpp.Void>, size: SizeT,
        pslack: Star<SizeT>): Star<cpp.Void>;

    @:native("js_mallocz")
    static function mallocz(ctx: Star<JSContext>, size: SizeT): Star<cpp.Void>;

    @:native("js_strdup")
    static function strdup(ctx: Star<JSContext>, str: ConstCharStar): Star<Char>;

    @:native("js_strndup")
    static function strndup(ctx: Star<JSContext>, s: ConstCharStar, n: SizeT): Star<Char>;

    @:native("JS_ComputeMemoryUsage")
    static function computeMemoryUsage(rt: Star<JSRuntime>, s: Star<JSMemoryUsage>): Void;

    @:native("JS_DumpMemoryUsage")
    static function dumpMemoryUsage(fp: Star<FILE>, s: ConstStar<JSMemoryUsage>, rt: Star<JSRuntime>): Void;

    static inline final ATOM_NULL: JSAtom = 0;

    @:native("JS_NewAtomLen")
    static function newAtomLen(ctx: Star<JSContext>, str: ConstCharStar, len: SizeT): JSAtom;

    @:native("JS_NewAtom")
    static function newAtom(ctx: Star<JSContext>, str: ConstCharStar): JSAtom;

    @:native("JS_NewAtomUInt32")
    static function newAtomUInt32(ctx: Star<JSContext>, n: UInt32): JSAtom;

    @:native("JS_DupAtom")
    static function dupAtom(ctx: Star<JSContext>, v: JSAtom): JSAtom;

    @:native("JS_FreeAtom")
    static function freeAtom(ctx: Star<JSContext>, v: JSAtom): Void;

    @:native("JS_FreeAtomRT")
    static function freeAtomRT(rt: Star<JSRuntime>, v: JSAtom): Void;

    @:native("JS_AtomToValue")
    static function atomToValue(ctx: Star<JSContext>, atom: JSAtom): JSValue;

    @:native("JS_AtomToString")
    static function atomToString(ctx: Star<JSContext>, atom: JSAtom): JSValue;

    @:native("JS_AtomToCString")
    static function atomToCString(ctx: Star<JSContext>, atom: JSAtom): ConstCharStar;

    @:native("JS_ValueToAtom")
    static function valueToAtom(ctx: Star<JSContext>, val: JSValueConst): JSAtom;

    static inline final CALL_FLAG_CONSTRUCTOR: Int32 = 1 << 0;

    /**
        Returns an assigned class ID. A new class ID is allocated if the value
        of the `classId` is empty.

        @param classId The preferred class ID. The `classId` will be modified if
                       its value is empty.
    **/
    @:native("JS_NewClassID")
    static function newClassID(classId: Star<JSClassID>): JSClassID;

    /**
        Create a new object internal class.

        @return -1 if error, 0 if OK.
    **/
    @:native("JS_NewClass")
    static function newClass(rt: Star<JSRuntime>, classId: JSClassID, classDef: ConstStar<JSClassDef>): Int32;

    /**
        Determines whether a class with the specified ID is available in the
        given JavaScript runtime.

        @return `true` if a class with the specified ID is registered;
                otherwise, `false`.
    **/
    @:native("JS_IsRegisteredClass")
    static function isRegisteredClass(rt: Star<JSRuntime>, classId: JSClassID): Bool;

    @:native("JS_NewBool")
    static function newBool(ctx: Star<JSContext>, val: Bool): JSValue;

    @:native("JS_NewInt32")
    static function newInt32(ctx: Star<JSContext>, val: Int32): JSValue;

    @:native("JS_NewCatchOffset")
    static function newCatchOffset(ctx: Star<JSContext>, val: Int32): JSValue;

    @:native("JS_NewInt64")
    static function newInt64(ctx: Star<JSContext>, val: Int64): JSValue;

    @:native("JS_NewUint32")
    static function newUInt32(ctx: Star<JSContext>, val: UInt32): JSValue;

    @:native("JS_NewBigInt64")
    static function newBigInt64(ctx: Star<JSContext>, v: Int64): JSValue;

    @:native("JS_NewBigUint64")
    static function newBigUInt64(ctx: Star<JSContext>, v: UInt64): JSValue;

    @:native("JS_NewFloat64")
    static function newFloat64(ctx: Star<JSContext>, d: Float64): JSValue;

    @:native("JS_IsNumber")
    static function isNumber(v: JSValueConst): Bool;

    @:native("JS_IsBigInt")
    static function isBigInt(ctx: Star<JSContext>, v: JSValueConst): Bool;

    @:native("JS_IsBigFloat")
    static function isBigFloat(v: JSValueConst): Bool;

    @:native("JS_IsBigDecimal")
    static function isBigDecimal(v: JSValueConst): Bool;

    @:native("JS_IsBool")
    static function isBool(v: JSValueConst): Bool;

    @:native("JS_IsNull")
    static function isNull(v: JSValueConst): Bool;

    @:native("JS_IsUndefined")
    static function isUndefined(v: JSValueConst): Bool;

    @:native("JS_IsException")
    static function isException(v: JSValueConst): Bool;

    @:native("JS_IsUninitialized")
    static function isUninitialized(v: JSValueConst): Bool;

    @:native("JS_IsString")
    static function isString(v: JSValueConst): Bool;

    @:native("JS_IsSymbol")
    static function isSymbol(v: JSValueConst): Bool;

    @:native("JS_IsObject")
    static function isObject(v: JSValueConst): Bool;

    /**
        Throws a user-defined exception. WARNING: `obj` is freed.
    **/
    @:native("JS_Throw")
    static function throw_(ctx: Star<JSContext>, obj: JSValue): JSValue;

    /**
        Returns the current pending exception for a given `JSContext`.

        @return If an exception has been thrown in the context and it has not
                yet been caught or cleared, returns the exception; otherwise
                returns `JS.NULL`.
    **/
    @:native("JS_GetException")
    static function getException(ctx: Star<JSContext>): JSValue;

    /**
        Determine if the specified `JSValue` is an `Error` object.

        @param ctx The pointer to the context that the `JSValue` belongs to.
        @param val The `JSValue` to test.
        @return `true` if `val` is an `Error` object; otherwise, `false`.
    **/
    @:native("JS_IsError")
    static function isError(ctx: Star<JSContext>, val: JSValueConst): Bool;

    /**
        Determine if the specified `JSValue` is an uncatchable `Error` object.

        @param ctx The pointer to the context that the `JSValue` belongs to.
        @param val The `JSValue` to test.
        @return `true` if `val` is an uncatchable `Error` object; otherwise,
                `false`.
    **/
    @:native("JS_IsUncatchableError")
    static function isUncatchableError(ctx: Star<JSContext>, val: JSValueConst): Bool;
}

@:native("JSValue")
@:include("linc_quickjs.hpp")
extern class JSValue extends JSValueConst {}

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

typedef JSClassID = UInt32;
typedef JSAtom = UInt32;
typedef JSMarkFunc = Callable<(rt: Star<JSRuntime>, gp: Star<JSGCObjectHeader>) -> Void>;

typedef JSCFunction = Callable<(ctx: Star<JSContext>, thisVal: JSValueConst, argc: Int32,
        argv: Star<JSValueConst>) -> JSValue>;

typedef JSCFunctionMagic = Callable<(ctx: Star<JSContext>, thisVal: JSValueConst, argc: Int32,
        argv: Star<JSValueConst>, magic: Int32) -> JSValue>;

typedef JSCFunctionData = Callable<(ctx: Star<JSContext>, thisVal: JSValueConst, argc: Int32,
        argv: Star<JSValueConst>, magic: Int32, funcData: Star<JSValue>) -> JSValue>;

@:native("JSMallocState")
@:include("linc_quickjs.hpp")
extern class JSMallocState {
    @:native("malloc_count") var mallocCount: SizeT;
    @:native("malloc_size") var mallocSize: SizeT;
    @:native("malloc_limit") var mallocLimit: SizeT;
    var opaque: Star<cpp.Void>;
}

@:native("JSMallocFunctions")
@:include("linc_quickjs.hpp")
@:structAccess
extern class JSMallocFunctions {
    function new();

    @:native("js_malloc") var jsMalloc: Callable<(s: Star<JSMallocState>, size: SizeT) -> Star<cpp.Void>>;
    @:native("js_free") var jsFree: Callable<(s: Star<JSMallocState>, ptr: Star<cpp.Void>) -> Void>;
    @:native("js_realloc") var jsRealloc: Callable<(s: Star<JSMallocState>, ptr: Star<cpp.Void>,
            size: SizeT) -> Star<cpp.Void>>;
    @:native("js_malloc_usable_size") var jsMallocUsableSize: Callable<(ptr: RawConstPointer<cpp.Void>) -> SizeT>;
}

@:native("JSMemoryUsage")
@:include("linc_quickjs.hpp")
@:structAccess
extern class JSMemoryUsage {
    function new();

    @:native("malloc_size") var mallocSize: Int64;
    @:native("malloc_limit") var mallocLimit: Int64;
    @:native("memory_used_size") var memoryUsedSize: Int64;
    @:native("malloc_count") var mallocCount: Int64;
    @:native("memory_used_count") var memoryUsedCount: Int64;
    @:native("atom_count") var atomCount: Int64;
    @:native("atom_size") var atomSize: Int64;
    @:native("str_count") var strCount: Int64;
    @:native("str_size") var strSize: Int64;
    @:native("obj_count") var objCount: Int64;
    @:native("obj_size") var objSize: Int64;
    @:native("prop_count") var propCount: Int64;
    @:native("prop_size") var propSize: Int64;
    @:native("shape_count") var shapeCount: Int64;
    @:native("shape_size") var shapeSize: Int64;
    @:native("js_func_count") var jsFuncCount: Int64;
    @:native("js_func_size") var jsFuncSize: Int64;
    @:native("js_func_code_size") var jsFuncCodeSize: Int64;
    @:native("js_func_pc2line_count") var jsFuncPc2lineCount: Int64;
    @:native("js_func_pc2line_size") var jsFuncPc2lineSize: Int64;
    @:native("c_func_count") var cFuncCount: Int64;
    @:native("array_count") var arrayCount: Int64;
    @:native("fast_array_count") var fastArrayCount: Int64;
    @:native("fast_array_elements") var fastArrayElements: Int64;
    @:native("binary_object_count") var binaryObjectCount: Int64;
    @:native("binary_object_size") var binaryObjectSize: Int64;
}

@:native("JSPropertyEnum")
@:include("linc_quickjs.hpp")
extern class JSPropertyEnum {
    @:native("is_enumerable") var isEnumerable: Bool;
    var atom: JSAtom;
}

@:native("JSPropertyDescriptor")
@:include("linc_quickjs.hpp")
@:structAccess
extern class JSPropertyDescriptor {
    var flags: Int32;
    var value: JSValue;
    var getter: JSValue;
    var setter: JSValue;
}

@:native("JSClassExoticMethods")
@:include("linc_quickjs.hpp")
@:structAccess
extern class JSClassExoticMethods {
    function new();

    /**
        Return -1 if exception (can only happen in case of `Proxy` object),
        `FALSE` if the property does not exist, `TRUE` if it exists. If 1 is
        returned, the property descriptor `desc` is filled if != `NULL`.
    **/
    @:native("get_own_property")
    var getOwnProperty: Callable<(ctx: Star<JSContext>, desc: Star<JSPropertyDescriptor>, obj: JSValueConst,
            prop: JSAtom) -> Int32>;

    /**
        `*ptab` should hold the `*plen` property keys. Return 0 if OK, -1 if
        exception. The `isEnumerable` field is ignored.
    **/
    @:native("get_own_property_names")
    var getOwnPropertyNames: Callable<(ctx: Star<JSContext>, ptab: Star<Star<JSPropertyEnum>>, plen: Star<UInt32>,
            obj: JSValueConst) -> Int32>;

    /**
        Return `< 0` if exception, or `TRUE`/`FALSE`.
    **/
    @:native("delete_property")
    var deleteProperty: Callable<(ctx: Star<JSContext>, obj: JSValueConst, prop: JSAtom) -> Int32>;

    /**
        Return `< 0` if exception, or `TRUE`/`FALSE`.
    **/
    @:native("define_own_property")
    var defineOwnProperty: Callable<(ctx: Star<JSContext>, thisObj: JSValueConst, prop: JSAtom, val: JSValueConst,
            getter: JSValueConst, setter: JSValueConst, flags: Int32) -> Int32>;

    /* The following methods can be emulated with the previous ones, so they
        are usually not needed. */
    /**
        Return `< 0` if exception, or `TRUE`/`FALSE`.
    **/
    @:native("has_property")
    var hasProperty: Callable<(ctx: Star<JSContext>, obj: JSValueConst, atom: JSAtom) -> Int32>;

    @:native("get_property")
    var getProperty: Callable<(ctx: Star<JSContext>, obj: JSValueConst, atom: JSAtom,
            receiver: JSValueConst) -> JSValue>;

    /**
        Return `< 0` if exception, or `TRUE`/`FALSE`.
    **/
    @:native("set_property")
    var setProperty: Callable<(ctx: Star<JSContext>, obj: JSValueConst, atom: JSAtom, value: JSValueConst,
            receiver: JSValueConst, flags: Int32) -> Int32>;
}

typedef JSClassFinalizer = Callable<(rt: Star<JSRuntime>, val: JSValue) -> Void>;
typedef JSClassGCMark = Callable<(rt: Star<JSRuntime>, val: JSValueConst, markFunc: JSMarkFunc) -> Void>;

typedef JSClassCall = Callable<(ctx: Star<JSContext>, funcObj: JSValueConst, thisVal: JSValueConst, argc: Int32,
        argv: Star<JSValueConst>, flags: Int32) -> JSValue>;

@:native("JSClassDef")
@:include("linc_quickjs.hpp")
@:structAccess
extern class JSClassDef {
    function new();

    @:native("class_name") var className: ConstCharStar;
    var finalizer: Null<JSClassFinalizer>;
    @:native("gc_mark") var gcMark: Null<JSClassGCMark>;

    /**
        If `call` != `NULL`, the object is a function. If
        `(flags & JS.CALL_FLAG_CONSTRUCTOR) != 0`, the function is called as a
        constructor. In this case, `thisVal` is `new.target`. A constructor call
        only happens if the object constructor bit is set (see
        `JS.setConstructorBit()`).
    **/
    var call: Null<JSClassCall>;

    var exotic: Star<JSClassExoticMethods>;
}
