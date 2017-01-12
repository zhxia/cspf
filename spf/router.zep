namespace Spf;

class Router implements RouterInterface
{
    public function mapping()->string|null
    {
        var baseURI,uri,cls;
        if DIRECTORY_SEPARATOR == "/" {
            let baseURI=_SERVER["SCRIPT_NAME"];
        }
        else{
            let baseURI=str_replace("\\","/",dirname(_SERVER["SCRIPT_NAME"]));
        }
        if baseURI !="" && strpos(_SERVER["REQUEST_URI"],baseURI) === 0 {
            let uri=substr(_SERVER["REQUEST_URI"],strlen(baseURI));
        }
        else{
            let uri=_SERVER["REQUEST_URI"];
        }
        if strpos(uri,"?") !== false {
            let uri=strstr(uri,"?",true);
        }

        if empty uri {
            let uri = "/";
        }
        let cls=this->manualMapping(uri);
        if empty cls {
            let cls=this->autoMapping(uri);
        }
        return cls;
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
        var routeConfig,cls,val,pattern,matches;
        let routeConfig=Loader::getConfig("route");
        if !empty routeConfig {
            for cls,val in routeConfig {
                for pattern in val{
                    if preg_match(pattern,url,matches) {
                        return cls;
                    }
                }
            }
        }
        return null;
    }
}