namespace Spf\Core;

class Router implements RouterInterface
{
    public function mapping()->string|null
    {
        return null;
    }

    /**
    *自动映射
    **/
    public function autoMapping(string! url)->string|null
    {
        var arrSeg,filename;
        var ret=null;
        let url=trim(url,"/");
        if url !="" {
            let arrSeg=explode("/",url);
            let filename=array_pop(arrSeg);
            let ret="Controllers\\".(count(arrSeg)>0?implode("\\",arrSeg):"")."\\".ucfirst(filename);
        }
        return ret;
    }

    /**
    *自定义映射
    **/
    private function manualMapping(string! url)->string|null
    {
        return null;
    }
}