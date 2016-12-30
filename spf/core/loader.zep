namespace Spf\Core;

class Loader implements LoaderInterface
{
    private static _namespaces=[];
    private static _configPath=null;
    private static _configItems=[];

    public static function addNameSpace(string! root,string! path) -> void
    {
        let self::_namespaces[root] = path;
    }


    public static function autoload(string! className) -> bool
    {
        var arrSeg,root,path,classFile;
        if class_exists(className,false) {
            return false;
        }
        let arrSeg = explode("\\",className,2);
        if isset arrSeg[1] {
            let root = arrSeg[0];
            if fetch path,self::_namespaces[root] {
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

    public static function getConfig(string! filename="common") ->var|null
    {
        var confFile,config,configArray=null;
        let confFile=self::_configPath."/".filename.".php";
        if file_exists(confFile) {
            if  isset(self::_configItems[filename]){
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
        fetch value,configArray[name];
        return value;
    }
}