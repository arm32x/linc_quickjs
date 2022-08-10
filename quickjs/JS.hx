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
        slack: Star<SizeT>): Star<cpp.Void>;

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

    @:native("JS_ResetUncatchableError")
    static function resetUncatchableError(ctx: Star<JSContext>): Void;

    @:native("JS_NewError")
    static function newError(ctx: Star<JSContext>): JSValue;

    @:native("JS_ThrowSyntaxError")
    private static function internalThrowSyntaxError(ctx: Star<JSContext>, fmt: ConstCharStar,
        s: ConstCharStar): JSValue;
    static inline function throwSyntaxError(ctx: Star<JSContext>, s: ConstCharStar): JSValue {
        return internalThrowSyntaxError(ctx, "%s", s);
    }

    @:native("JS_ThrowTypeError")
    private static function internalThrowTypeError(ctx: Star<JSContext>, fmt: ConstCharStar,
        s: ConstCharStar): JSValue;
    static inline function throwTypeError(ctx: Star<JSContext>, s: ConstCharStar): JSValue {
        return internalThrowTypeError(ctx, "%s", s);
    }

    @:native("JS_ThrowReferenceError")
    private static function internalThrowReferenceError(ctx: Star<JSContext>, fmt: ConstCharStar,
        s: ConstCharStar): JSValue;
    static inline function throwReferenceError(ctx: Star<JSContext>, s: ConstCharStar): JSValue {
        return internalThrowReferenceError(ctx, "%s", s);
    }

    @:native("JS_ThrowRangeError")
    private static function internalThrowRangeError(ctx: Star<JSContext>, fmt: ConstCharStar,
        s: ConstCharStar): JSValue;
    static inline function throwRangeError(ctx: Star<JSContext>, s: ConstCharStar): JSValue {
        return internalThrowRangeError(ctx, "%s", s);
    }

    @:native("JS_ThrowInternalError")
    private static function internalThrowInternalError(ctx: Star<JSContext>, fmt: ConstCharStar,
        s: ConstCharStar): JSValue;
    static inline function throwInternalError(ctx: Star<JSContext>, s: ConstCharStar): JSValue {
        return internalThrowInternalError(ctx, "%s", s);
    }

    @:native("JS_ThrowOutOfMemory")
    static function throwOutOfMemory(ctx: Star<JSContext>): JSValue;

    @:native("JS_FreeValue")
    static function freeValue(ctx: Star<JSContext>, v: JSValue): Void;

    @:native("JS_FreeValueRT")
    static function freeValueRT(ctx: Star<JSRuntime>, v: JSValue): Void;

    @:native("JS_DupValue")
    static function dupValue(ctx: Star<JSContext>, v: JSValueConst): JSValue;

    @:native("JS_DupValueRT")
    static function dupValueRT(ctx: Star<JSRuntime>, v: JSValueConst): JSValue;

    // Return -1 for `JS_EXCEPTION`.
    @:native("JS_ToBool")
    static function toBool(ctx: Star<JSContext>, val: JSValueConst): Int32;

    @:native("JS_ToInt32")
    static function toInt32(ctx: Star<JSContext>, res: Star<Int32>, val: JSValueConst): Int32;

    @:native("JS_ToUint32")
    static function toUInt32(ctx: Star<JSContext>, res: Star<UInt32>, val: JSValueConst): Int32;

    @:native("JS_ToInt64")
    static function toInt64(ctx: Star<JSContext>, res: Star<Int64>, val: JSValueConst): Int32;

    @:native("JS_ToIndex")
    static function toIndex(ctx: Star<JSContext>, len: Star<UInt64>, val: JSValueConst): Int32;

    @:native("JS_ToFloat64")
    static function toFloat64(ctx: Star<JSContext>, res: Star<Float64>, val: JSValueConst): Int32;

    // Return an exception if `val` is a `Number`.
    @:native("JS_ToBigInt64")
    static function toBigInt64(ctx: Star<JSContext>, res: Star<Int64>, val: JSValueConst): Int32;

    // Same as `JS.toInt64()` but allow `BigInt`.
    @:native("JS_ToInt64Ext")
    static function toInt64Ext(ctx: Star<JSContext>, res: Star<Int64>, val: JSValueConst): Int32;

    @:native("JS_NewStringLen")
    static function newStringLen(ctx: Star<JSContext>, str1: ConstCharStar, len1: SizeT): JSValue;

    @:native("JS_NewString")
    static function newString(ctx: Star<JSContext>, str: ConstCharStar): JSValue;

    @:native("JS_NewAtomString")
    static function newAtomString(ctx: Star<JSContext>, str: ConstCharStar): JSValue;

    @:native("JS_ToString")
    static function toString(ctx: Star<JSContext>, val: JSValueConst): JSValue;

    @:native("JS_ToPropertyKey")
    static function toPropertyKey(ctx: Star<JSContext>, val: JSValueConst): JSValue;

    @:native("JS_ToCStringLen2")
    static function toCStringLen2(ctx: Star<JSContext>, len: Star<SizeT>, val1: JSValueConst,
        cesu8: Bool): ConstCharStar;

    @:native("JS_ToCStringLen")
    static function toCStringLen(ctx: Star<JSContext>, len: Star<SizeT>, val1: JSValueConst): ConstCharStar;

    @:native("JS_ToCString")
    static function toCString(ctx: Star<JSContext>, val1: JSValueConst): ConstCharStar;

    @:native("JS_FreeCString")
    static function freeCString(ctx: Star<JSContext>, ptr: ConstCharStar): Void;

    @:native("JS_NewObjectProtoClass")
    static function newObjectProtoClass(ctx: Star<JSContext>, proto: JSValueConst, classId: JSClassID): JSValue;

    @:native("JS_NewObjectClass")
    static function newObjectClass(ctx: Star<JSContext>, classId: Int32): JSValue;

    @:native("JS_NewObjectProto")
    static function newObjectProto(ctx: Star<JSContext>, proto: JSValueConst): JSValue;

    @:native("JS_NewObject")
    static function newObject(ctx: Star<JSContext>): JSValue;

    @:native("JS_IsFunction")
    static function isFunction(ctx: Star<JSContext>, val: JSValueConst): Bool;

    @:native("JS_IsConstructor")
    static function isConstructor(ctx: Star<JSContext>, val: JSValueConst): Bool;

    @:native("JS_SetConstructorBit")
    static function setConstructorBit(ctx: Star<JSContext>, funcObj: JSValueConst, val: Bool): Bool;

    @:native("JS_NewArray")
    static function newArray(ctx: Star<JSContext>): JSValue;

    @:native("JS_IsArray")
    static function isArray(ctx: Star<JSContext>, val: JSValueConst): Int32;

    @:native("JS_GetPropertyInternal")
    static function getPropertyInternal(ctx: Star<JSContext>, obj: JSValueConst, prop: JSAtom, receiver: JSValueConst,
        throwRefError: Bool): JSValue;

    @:native("JS_GetProperty")
    static function getProperty(ctx: Star<JSContext>, thisObj: JSValueConst, prop: JSAtom): JSValue;

    @:native("JS_GetPropertyStr")
    static function getPropertyStr(ctx: Star<JSContext>, thisObj: JSValueConst, prop: ConstCharStar): JSValue;

    @:native("JS_GetPropertyUint32")
    static function getPropertyUInt32(ctx: Star<JSContext>, thisObj: JSValueConst, idx: UInt32): JSValue;

    @:native("JS_SetPropertyInternal")
    static function setPropertyInternal(ctx: Star<JSContext>, thisObj: JSValueConst, prop: JSAtom, val: JSValue,
        flags: Int32): Int32;

    @:native("JS_SetProperty")
    static function setProperty(ctx: Star<JSContext>, thisObj: JSValueConst, prop: JSAtom, val: JSValue): Int32;

    @:native("JS_SetPropertyUint32")
    static function setPropertyUInt32(ctx: Star<JSContext>, thisObj: JSValueConst, idx: UInt32, val: JSValue): Int32;

    @:native("JS_SetPropertyInt64")
    static function setPropertyInt64(ctx: Star<JSContext>, thisObj: JSValueConst, idx: Int64, val: JSValue): Int32;

    @:native("JS_SetPropertyStr")
    static function setPropertyStr(ctx: Star<JSContext>, thisObj: JSValueConst, prop: ConstCharStar,
        val: JSValue): Int32;

    @:native("JS_HasProperty")
    static function hasProperty(ctx: Star<JSContext>, thisObj: JSValueConst, prop: JSAtom): Int32;

    @:native("JS_IsExtensible")
    static function isExtensible(ctx: Star<JSContext>, obj: JSValueConst): Int32;

    @:native("JS_PreventExtensions")
    static function preventExtensions(ctx: Star<JSContext>, obj: JSValueConst): Int32;

    @:native("JS_DeleteProperty")
    static function deleteProperty(ctx: Star<JSContext>, obj: JSValueConst, prop: JSAtom, flags: Int32): Int32;

    @:native("JS_SetPrototype")
    static function setPrototype(ctx: Star<JSContext>, obj: JSValueConst, protoVal: JSValueConst): Int32;

    @:native("JS_GetPrototype")
    static function getPrototype(ctx: Star<JSContext>, val: JSValueConst): JSValue;

    static inline final GPN_STRING_MASK = 1 << 0;
    static inline final GPN_SYMBOL_MASK = 1 << 1;
    static inline final GPN_PRIVATE_MASK = 1 << 2;
    static inline final GPN_ENUM_ONLY = 1 << 4; // Only include the enumerable properties.
    static inline final GPN_SET_ENUM = 1 << 5; // Set the JSPropertyEnum.isEnumerable field.

    @:native("JS_GetOwnPropertyNames")
    static function getOwnPropertyNames(ctx: Star<JSContext>, tab: Star<Star<JSPropertyEnum>>, len: Star<UInt32>,
        obj: JSValueConst, flags: Int32): Int32;

    @:native("JS_GetOwnProperty")
    static function getOwnProperty(ctx: Star<JSContext>, desc: Star<JSPropertyDescriptor>, obj: JSValueConst,
        prop: JSAtom): Int32;

    @:native("JS_Call")
    static function call(ctx: Star<JSContext>, funcObj: JSValueConst, thisObj: JSValueConst, argc: Int32,
        argv: Star<JSValueConst>): JSValue;

    @:native("JS_Invoke")
    static function invoke(ctx: Star<JSContext>, thisVal: JSValueConst, atom: JSAtom, argc: Int32,
        argv: Star<JSValueConst>): JSValue;

    @:native("JS_CallConstructor")
    static function callConstructor(ctx: Star<JSContext>, funcObj: JSValueConst, argc: Int32,
        argv: Star<JSValueConst>): JSValue;

    @:native("JS_CallConstructor2")
    static function callConstructor2(ctx: Star<JSContext>, funcObj: JSValueConst, newTarget: JSValueConst,
        argc: Int32, argv: Star<JSValueConst>): JSValue;

    @:native("JS_DetectModule")
    static function detectModule(input: ConstCharStar, inputLen: SizeT): Bool;

    // `input` must be zero terminated, i.e. `input[inputLen] = '\0'`.
    @:native("JS_Eval")
    static function eval(ctx: Star<JSContext>, input: ConstCharStar, inputLen: SizeT, filename: ConstCharStar,
        evalFlags: Int): JSValue;

    // Same as `JS.eval()` but with an explicit `thisObj` parameter.
    @:native("JS_EvalThis")
    static function evalThis(ctx: Star<JSContext>, thisObj: JSValueConst, input: ConstCharStar, inputLen: SizeT,
        filename: ConstCharStar, evalFlags: Int32): JSValue;

    @:native("JS_GetGlobalObject")
    static function getGlobalObject(ctx: Star<JSContext>): JSValue;

    @:native("JS_IsInstanceOf")
    static function isInstanceOf(ctx: Star<JSContext>, val: JSValueConst, obj: JSValueConst): Int32;

    @:native("JS_DefineProperty")
    static function defineProperty(ctx: Star<JSContext>, thisObj: JSValueConst, prop: JSAtom, val: JSValueConst,
        getter: JSValueConst, setter: JSValueConst, flags: Int32): Int32;

    @:native("JS_DefinePropertyValue")
    static function definePropertyValue(ctx: Star<JSContext>, thisObj: JSValueConst, prop: JSAtom, val: JSValue,
        flags: Int32): Int32;

    @:native("JS_DefinePropertyValueUint32")
    static function definePropertyValueUInt32(ctx: Star<JSContext>, thisObj: JSValueConst, idx: UInt32, val: JSValue,
        flags: Int32): Int32;

    @:native("JS_DefinePropertyValueStr")
    static function definePropertyValueStr(ctx: Star<JSContext>, thisObj: JSValueConst, prop: ConstCharStar,
        val: JSValue, flags: Int32): Int32;

    @:native("JS_DefinePropertyGetSet")
    static function definePropertyGetSet(ctx: Star<JSContext>, thisObj: JSValueConst, prop: JSAtom, getter: JSValue,
        setter: JSValue, flags: Int32): Int32;

    @:native("JS_SetOpaque")
    static function setOpaque(obj: JSValue, opaque: Star<cpp.Void>): Void;

    @:native("JS_GetOpaque")
    static function getOpaque(obj: JSValueConst, classId: JSClassID): Star<cpp.Void>;

    @:native("JS_GetOpaque2")
    static function getOpaque2(obj: Star<JSContext>, obj: JSValueConst, classId: JSClassID): Star<cpp.Void>;

    // `buf` must be zero terminated, i.e. `buf[bufLen] = '\0'`.
    @:native("JS_ParseJSON")
    static function parseJSON(ctx: Star<JSContext>, buf: ConstCharStar, bufLen: SizeT,
        filename: ConstCharStar): JSValue;

    static inline final PARSE_JSON_EXT = 1 << 0; // Allow extended JSON.

    @:native("JS_ParseJSON2")
    static function parseJSON2(ctx: Star<JSContext>, buf: ConstCharStar, bufLen: SizeT, filename: ConstCharStar,
        flags: Int32): JSValue;

    @:native("JS_JSONStringify")
    static function jsonStringify(ctx: Star<JSContext>, obj: JSValueConst, replacer: JSValueConst,
        space0: JSValueConst): JSValue;

    @:native("JS_NewArrayBuffer")
    static function newArrayBuffer(ctx: Star<JSContext>, buf: ConstStar<UInt8>, len: SizeT,
        freeFunc: JSFreeArrayBufferDataFunc, opaque: Star<cpp.Void>, isShared: Bool): JSValue;

    @:native("JS_NewArrayBufferCopy")
    static function newArrayBufferCopy(ctx: Star<JSContext>, buf: ConstStar<UInt8>, len: SizeT): JSValue;

    @:native("JS_DetachArrayBuffer")
    static function detachArrayBuffer(ctx: Star<JSContext>, obj: JSValueConst): Void;

    @:native("JS_GetArrayBuffer")
    static function getArrayBuffer(ctx: Star<JSContext>, size: Star<SizeT>, obj: JSValueConst): Star<UInt8>;

    @:native("JS_GetTypedArrayBuffer")
    static function getTypedArrayBuffer(ctx: Star<JSContext>, obj: JSValueConst, byteOffset: Star<SizeT>,
        byteLength: Star<SizeT>, bytesPerElement: Star<SizeT>): JSValue;

    @:native("JS_SetSharedArrayBufferFunctions")
    static function setSharedArrayBufferFunctions(rt: Star<JSRuntime>,
        sf: ConstStar<JSSharedArrayBufferFunctions>): Void;

    @:native("JS_NewPromiseCapability")
    static function newPromiseCapability(ctx: Star<JSContext>, resolvingFuncs: JSValue): JSValue;

    @:native("JS_SetHostPromiseRejectionTracker")
    static function setHostPromiseRejectionTracker(rt: Star<JSRuntime>, cb: JSHostPromiseRejectionTracker,
        opaque: Star<cpp.Void>): Void;

    @:native("JS_SetInterruptHandler")
    static function setInterruptHandler(rt: Star<JSRuntime>, cb: JSInterruptHandler, opaque: Star<cpp.Void>): Void;

    // If `canBlock` is `true`, `Atomics.wait()` can be used.
    @:native("JS_SetCanBlock")
    static function setCanBlock(rt: Star<JSRuntime>, canBlock: Bool): Void;

    // Set the `[IsHTMLDDA]` internal slot.
    @:native("JS_SetIsHTMLDDA")
    static function setIsHTMLDDA(ctx: Star<JSContext>, obj: JSValueConst): Void;

    @:native("JS_SetModuleLoaderFunc")
    static function setModuleLoaderFunc(rt: Star<JSRuntime>, moduleNormalize: JSModuleNormalizeFunc,
        moduleLoader: JSModuleLoaderFunc, opaque: Star<cpp.Void>): Void;

    // Return the `import.meta` object of a module.
    @:native("JS_GetImportMeta")
    static function getImportMeta(ctx: Star<JSContext>, m: Star<JSModuleDef>): JSValue;

    @:native("JS_GetModuleName")
    static function getModuleName(ctx: Star<JSContext>, m: Star<JSModuleDef>): JSAtom;

    @:native("JS_EnqueueJob")
    static function enqueueJob(ctx: Star<JSContext>, jobFunc: JSJobFunc, argc: Int32, argv: Star<JSValueConst>): Int32;

    @:native("JS_IsJobPending")
    static function isJobPending(rt: Star<JSRuntime>): Bool;

    @:native("JS_ExecutePendingJob")
    static function executePendingJob(rt: Star<JSRuntime>, ctx: Star<Star<JSContext>>): Int32;

    // Object writer/reader (currently only used to handle precompiled code).
    inline static final WRITE_OBJ_BYTECODE = 1 << 0; // Allow function/module.
    inline static final WRITE_OBJ_BSWAP = 1 << 1; // Byte swapped output.
    inline static final WRITE_OBJ_SAB = 1 << 2; // Allow SharedArrayBuffer.
    inline static final WRITE_OBJ_REFERENCE = 1 << 3; // Allow object references to encode arbitrary object graph.

    @:native("JS_WriteObject")
    static function writeObject(ctx: Star<JSContext>, size: Star<SizeT>, obj: JSValueConst, flags: Int32): Star<UInt8>;

    @:native("JS_WriteObject2")
    static function writeObject2(ctx: Star<JSContext>, size: Star<SizeT>, obj: JSValueConst, flags: Int32,
        sabTab: Star<Star<Star<UInt8>>>, sabTabLen: Star<SizeT>): Star<UInt8>;

    inline static final READ_OBJ_BYTECODE = 1 << 0; // Allow function/module.
    inline static final READ_OBJ_ROM_DATA = 1 << 1; // Avoid duplicating `buf` datas.
    inline static final READ_OBJ_SAB = 1 << 2; // Allow SharedArrayBuffer.
    inline static final READ_OBJ_REFERENCE = 1 << 3; // Allow object references.

    @:native("JS_ReadObject")
    static function readObject(ctx: Star<JSContext>, buf: ConstStar<UInt8>, bufLen: SizeT, flags: Int32): JSValue;

    /**
        Instantiate and evaluate a bytecode function. Only used when reading a
        script or module with `JS.readObject()`.
    **/
    @:native("JS_EvalFunction")
    static function evalFunction(ctx: Star<JSContext>, funObj: JSValue): JSValue;

    /**
        Load the dependencies of the module `obj`. Useful when `JS.readObject()`
        returns a module.
    **/
    @:native("JS_ResolveModule")
    static function resolveModule(ctx: Star<JSContext>, obj: JSValueConst): Int32;

    // Only exported for `os.Worker()`.
    @:native("JS_GetScriptOrModuleName")
    static function getScriptOrModuleName(ctx: Star<JSContext>, nStackLevels: Int32): JSAtom;

    // Only exported for `os.Worker()`.
    @:native("JS_RunModule")
    static function runModule(ctx: Star<JSContext>, basename: ConstCharStar,
        filename: ConstCharStar): Star<JSModuleDef>;
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
        `*tab` should hold the `*len` property keys. Return 0 if OK, -1 if
        exception. The `isEnumerable` field is ignored.
    **/
    @:native("get_own_property_names")
    var getOwnPropertyNames: Callable<(ctx: Star<JSContext>, tab: Star<Star<JSPropertyEnum>>, len: Star<UInt32>,
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

typedef JSFreeArrayBufferDataFunc = Callable<(rt: Star<JSRuntime>, opaque: Star<cpp.Void>,
        ptr: Star<cpp.Void>) -> Void>;

@:native("JSSharedArrayBufferFunctions")
@:include("linc_quickjs.hpp")
@:structAccess
extern class JSSharedArrayBufferFunctions {
    function new();

    @:native("sab_alloc") var sabAlloc: Callable<(opaque: Star<cpp.Void>, size: SizeT) -> Star<cpp.Void>>;
    @:native("sab_free") var sabFree: Callable<(opaque: Star<cpp.Void>, ptr: Star<cpp.Void>) -> Void>;
    @:native("sab_dup") var sabDup: Callable<(opaque: Star<cpp.Void>, ptr: Star<cpp.Void>) -> Void>;
    @:native("sab_opaque") var sabOpaque: Star<cpp.Void>;
}

// `isHandled == true` means that the rejection is handled.
typedef JSHostPromiseRejectionTracker = Callable<(ctx: Star<JSContext>, promise: JSValueConst, reason: JSValueConst,
        isHandled: Bool, opaque: Star<cpp.Void>) -> Void>;

// Return != 0 if the JS code needs to be interrupted.
typedef JSInterruptHandler = Callable<(rt: Star<JSRuntime>, opaque: Star<cpp.Void>) -> Int32>;

@:native("JSModuleDef")
@:include("linc_quickjs.hpp")
extern class JSModuleDef {}

// Return the module specifier (allocated with `JS.malloc()`) or `null` if
// exception.
typedef JSModuleNormalizeFunc = Callable<(ctx: Star<JSContext>, moduleBaseName: ConstCharStar,
        moduleName: ConstCharStar, opaque: Star<cpp.Void>) -> Star<Char>>;

typedef JSModuleLoaderFunc = Callable<(ctx: Star<JSContext>, moduleName: ConstCharStar,
        opaque: Star<cpp.Void>) -> Star<JSModuleDef>>;

typedef JSJobFunc = Callable<(ctx: Star<JSContext>, argc: Int32, argv: Star<JSValueConst>) -> JSValue>;
