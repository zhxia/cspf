namespace Spf;

class Loader implements LoaderInterface
{
    private static _namespace=[];
    private static _configPath=null;
    private static _configItems=[];

    public static function registerNameSpace(string! name,string! path) -> void
    {
        let self::_namespace=["name":name,"path":path];
    }

    public static function getNameSpace(){
        return self::_namespace;
    }

    public static function autoload(string! className) -> bool
    {
        var arrSeg,path,classFile;
        if class_exists(className,false) {
            return false;
        }
        let arrSeg = explode("\\",className,2);
        if isset arrSeg[1] {
            if fetch path,self::_namespace["path"] {
                let classFile = path."/".str_replace("\\","/",arrSeg[1]).".php";
                if !file_exists(classFile) {
                    throw new Exception("class file:'".classFile."' doesn't exist!");
                }
                require classFile;
            }
        }
        return false;
    }

    public static function setConfigPath(string! path)
    {
        let self::_configPath = path;
    }

    public static function getConfig(string! filename="common") ->var
    {
        var confFile,config,configArray=null;
        let confFile=self::_configPath."/".filename.".php";
        if file_exists(confFile) {
            if  isset self::_configItems[filename] {
                let configArray = self::_configItems[filename];
            }
            else{
                let config = new Config(require confFile);
                let configArray = config->toArray();
                let self::_configItems[filename]=configArray;
            }
        }
        return configArray;
    }

    public static function getConfigItem(string! name,string filename="common") -> var|null
    {
        var configArray,value=null;
        let configArray = self::getConfig(filename);
        if fetch value,configArray[name] {
            return value;
        }
        return null;
    }
}