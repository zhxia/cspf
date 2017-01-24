namespace Spf;

class Loader implements LoaderInterface
{
    private _namespaces=[];
    private _configPath=null;
    private _configItems=[];
    private _localNameSpace;

    public function addNameSpace(string! root,string! path) -> <Loader>
    {
        let this->_namespaces[root] = path;
        return this;
    }

    public function setLocalNameSpace(string! root) -> <Loader>
    {
        let this->_localNameSpace = root;
        return this;
    }

    public function getLocalNameSpace() -> string
    {
        return this->_localNameSpace;
    }

    public function autoload(string! className) -> bool
    {
        var arrSeg,root,path,classFile;
        if class_exists(className,false) {
            return false;
        }
        let arrSeg = explode("\\",className,2);
        if isset arrSeg[1] {
            let root=arrSeg[0];
            if fetch path,this->_namespaces[root] {
                let classFile = path."/".strtolower(str_replace("\\","/",arrSeg[1])).".php";
                if !file_exists(classFile) {
                    throw new Exception("class file:[".classFile."] not found!");
                }
                require classFile;
                return true;
            }
        }
        return false;
    }

    public function setConfigPath(string! path)
    {
        let this->_configPath = path;
        return this;
    }

    public function getConfig(string! filename="common") ->var
    {
        var confFile,config,configArray=null;
        let confFile=this->_configPath."/".filename.".php";
        if file_exists(confFile) {
            if  isset this->_configItems[filename] {
                let configArray = this->_configItems[filename];
            }
            else{
                let config = new Config(require confFile);
                let configArray = config->toArray();
                let this->_configItems[filename]=configArray;
            }
        }
        return configArray;
    }

    public function getConfigItem(string! name,string filename="common") -> var|null
    {
        var configArray,value=null;
        let configArray = this->getConfig(filename);
        if fetch value,configArray[name] {
            return value;
        }
        return null;
    }
}