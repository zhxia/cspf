namespace Spf;

class Application {

    protected _dispatcher;
    protected _config;
    protected static _instance;
    protected _configItems=[];

    public function __construct(array! config)
    {
        var app;
        let app=self::_instance;
        if !app {
            let this->_config = config;
            let self::_instance = this;
        }
    }

    public static function getInstance() -> <Application>
    {
        return self::_instance;
    }

    public function run()
    {
        var e;
        try{
            this->initialize();
            this->_dispatcher->dispatch();
        }
        catch \Exception, e {
            throw e;
        }
    }

    protected function initialize()
    {
        var appNamespace,requestClass,responseClass,viewClass,routerClass,loader,viewDir,view;
        var namespaces,classes,files,dirs,plugins,plugin;
        let this->_dispatcher=new Dispatcher();
        //set class loader
        let loader=new Loader();
        if fetch namespaces,this->_config["loader"]["namespaces"] {
            loader->registerNamespaces(namespaces);
        }
        if fetch classes,this->_config["loader"]["classes"] {
            loader->registerClasses(classes);
        }
        if fetch files,this->_config["loader"]["files"] {
            loader->registerFiles(files);
        }
        if fetch dirs,this->_config["loader"]["dirs"] {
            loader->registerDirs(dirs);
        }
        spl_autoload_register([loader,"autoLoad"]);
        //set app namespace
        if !fetch appNamespace,this->_config["namespace"] {
            let appNamespace="";
        }
        this->_dispatcher->setAppNamespace(appNamespace);

        //set request
        if !fetch requestClass,this->_config["request_class"] {
            let requestClass="\\Spf\\Request";
        }
        this->_dispatcher->setRequest(new {requestClass});

        //set response
        if !fetch responseClass,this->_config["response_class"] {
            let responseClass="\\Spf\\Response";
        }
        this->_dispatcher->setResponse(new {responseClass});

        //set view
        if !fetch viewClass,this->_config["view_class"] {
            let viewClass="\\Spf\\View";
        }
        if !fetch viewDir,this->_config["view_directory"] {
            let viewDir=this->_config["dir"].DIRECTORY_SEPARATOR."views";
        }
        let view=new {viewClass};
        view->setViewDir(viewDir);
        this->_dispatcher->setView(view);

        //set router
        if !fetch routerClass,this->_config["router_class"] {
            let routerClass="\\Spf\\Router";
        }
        this->_dispatcher->setRouter(new {routerClass});

        //set plugins
        if fetch plugins,this->_config["plugins"] {
            for plugin in plugins {
                this->_dispatcher->addPlugin(new {plugin});
            }
        }
    }

    public function getDispatcher() -> <Dispatcher>
    {
        return this->_dispatcher;
    }

    public function getConfig(string! filename,fileExt=".php") -> var|null
    {
        var configDir,envName,configFile,arrConfig,configClass,configObject;
        if !fetch configDir,this->_config["config_dir"] {
            let envName = get_cfg_var("env.name");
            if empty envName {
                let envName = "product";
            }
            let configDir = this->_config["dir"].DIRECTORY_SEPARATOR."config".DIRECTORY_SEPARATOR.envName;
        }
        let configFile=configDir.DIRECTORY_SEPARATOR.filename.fileExt;
        if is_file(configFile) {
            if !fetch arrConfig,this->_configItems[filename] {
                if fileExt == ".ini" {
                    let configClass = "\\Spf\\Config\\Adapter\\Ini";
                }
                elseif fileExt == ".json" {
                    let configClass = "\\Spf\\Config\\Adapter\\Json";
                }
                elseif fileExt == ".yaml" {
                    let configClass = "\\Spf\\Config\\Adapter\\Yaml";
                }
                else{
                    let configClass = "\\Spf\\Config\\Adapter\\Php";
                }
                let configObject = new {configClass}(configFile);
                let arrConfig = configObject->toArray();
                let this->_configItems[filename]=arrConfig;
            }
            return arrConfig;
        }
        return null;
    }

    public function getConfigItem(string! name,string! filename="common",fileExt=".php")->var|null
    {
        var arrConfig,configItem;
        let arrConfig=this->getConfig(filename,fileExt);
        if !fetch configItem,arrConfig[name] {
            return null;
        }
        return configItem;
    }
}