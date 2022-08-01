import quickjs.JS;

class Test {
    static function main() {
        var mf = new JSMallocFunctions();
        mf.jsMalloc = cpp.Callable.fromStaticFunction(noopMalloc);
        mf.jsFree = cpp.Callable.fromStaticFunction(noopFree);
        mf.jsRealloc = cpp.Callable.fromStaticFunction(noopRealloc);
        mf.jsMallocUsableSize = cpp.Callable.fromStaticFunction(noopMallocUsableSize);
        var rt = JS.newRuntime2(mf, null);
    }

    static function noopMalloc(s: cpp.Star<JSMallocState>, size: cpp.SizeT): cpp.Star<cpp.Void> {
        return null;
    }

    static function noopFree(s: cpp.Star<JSMallocState>, ptr: cpp.Star<cpp.Void>): Void {}

    static function noopRealloc(s: cpp.Star<JSMallocState>, ptr: cpp.Star<cpp.Void>, size: cpp.SizeT): cpp.Star<cpp.Void> {
        return null;
    }

    static function noopMallocUsableSize(ptr: cpp.RawConstPointer<cpp.Void>): cpp.SizeT {
        return 0;
    }
}
