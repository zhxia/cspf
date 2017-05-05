namespace Spf;

class Loader implements LoaderInterface
{
    private _namespaces=null;
    private _files=null;
    private _classes=null;
    private _directories=null;
    private _registered=false;

    public function register() -><Loader>
    {
        if this->_registered === false {
            this->loadFiles();
            spl_autoload_register([this,"autoLoad"]);
            let this->_registered=true;
        }
        return this;
    }

    public function unRegister() -><Loader>
    {
        if this->_registered === true {
            spl_autoload_unregister([this,"autoLoad"]);
            let this->_registered=false;
        }
        return this;
    }

    public function autoLoad(string! className) -> boolean
    {
        var filePath,ds,ns,nsPrefix,directories,filename,directory;
        if typeof this->_classes == "array" {
            if fetch filePath,this->_classes[className] {
                if is_file(filePath){
                    require filePath;
                    return true;
                }
            }
        }

        let ds=DIRECTORY_SEPARATOR,ns="\\";
        if typeof this->_namespaces == "array" {
            for nsPrefix,directories in this->_namespaces {
                if !starts_with(className,nsPrefix) {
                    continue;
                }
                let filename = substr(className,strlen(nsPrefix . ns));
                let filename = str_replace(ns,ds,filename).".php";
                if !filename {
                    continue;
                }
                for directory in directories {
                    let directory = rtrim(directory,ds).ds;
                    let filePath = directory.filename;
                    if is_file(filePath){
                        require filePath;
                        return true;
                    }
                }
            }
        }

        if typeof this->_directories == "array" {
            for directory in this->_directories {
                let directory=rtrim(directory,ds).ds;
                let filePath = directory.str_replace(ns,ds,className).".php";
                if is_file(filePath){
                    require filePath;
                    return true;
                }
            }
        }
        return false;
    }

    public function loadFiles()
    {
        var filePath;
        if typeof this->_files == "array" {
            for filePath in this->_files {
                if is_file(filePath) {
                    require filePath;
                }
            }
        }
    }

    public function registerDirs(array! directories,boolean merge=false) -> <Loader>
    {
        if merge && typeof this->_directories == "array" {
            let this->_directories = array_merge(this->_directories,directories);
        }
        else{
            let this->_directories = directories;
        }
        return this;
    }

    public function registerClasses(array! classes,boolean merge=false)-><Loader>
    {
        if merge && typeof this->_classes == "array" {
            let this->_classes=array_merge(this->_classes,classes);
        }
        else{
            let this->_classes=classes;
        }
        return this;
    }

    public function registerFiles(array! files,boolean merge=false)-><Loader>
    {
        if merge && typeof this->_files == "array" {
           let this->_files=array_merge(this->_files,files);
        }
        else{
           let this->_files=files;
        }
        return this;
    }

    public function registerNamespaces(array! namespaces,boolean merge=false) -> <Loader>
    {
        var preparedNamespaces,name,paths;
        let preparedNamespaces=this->prepareNamespace(namespaces);
        if merge && typeof this->_namespaces == "array" {
            for name,paths in preparedNamespaces {
                if !isset this->_namespaces[name]{
                    let this->_namespaces[name]=[];
                }
                let this->_namespaces=array_merge(this->_namespaces,paths);
            }
        }
        else{
            let this->_namespaces=preparedNamespaces;
        }
        return this;
    }

    protected function prepareNamespace(array! namespaces)->array
    {
        var name,paths,localPaths,result;
        let result=[];
        for  name,paths in namespaces {
            if typeof paths != "array" {
                let localPaths = [paths];
            }
            else{
                let localPaths = paths;
            }
            let result[name]=localPaths;
        }
        return result;
    }
}