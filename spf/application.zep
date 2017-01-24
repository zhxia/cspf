namespace Spf;

class Application {

    private static _instance=null;
    protected _dispatcher;

    private function __construct()
    {
        let this->_dispatcher=new Dispatcher();
        this->initialize();
    }

    public static function getInstance() -> <Application>
    {
        if  self::_instance === null {
            let self::_instance=new Application();
        }
        return self::_instance;
    }

    public function getDispatcher() -> <Dispatcher>
    {
        return this->_dispatcher;
    }

    public function run()
    {
        var e;
        try{
            this->_dispatcher->dispatch();
        }
        catch \Exception, e {
            throw e;
        }
    }

    protected function initialize()
    {
        var arrConf,requestClass,responseClass,viewClass,routerClass,view,loader;
        let loader=new Loader();
        this->_dispatcher->getLoader(loader);
        spl_autoload_register([loader,"autoload"]);
        let arrConf = loader->getConfig("common");
        if !fetch requestClass,arrConf["request_class"] {
            let requestClass="\\Spf\\Request";
        }
        this->_dispatcher->setRequest(new {requestClass});
        if !fetch responseClass,arrConf["response_class"] {
            let responseClass="\\Spf\\Response";
        }
        this->_dispatcher->setResponse(new {responseClass});
        if !fetch viewClass,arrConf["view_class"] {
            let viewClass="\\Spf\\View";
        }
        let view=new {viewClass};
        if defined("VIEW_DIRECTORY"){
            view->setViewPath(VIEW_DIRECTORY);
        }
        this->_dispatcher->setView(view);
        if !fetch routerClass,arrConf["router_class"] {
            let routerClass="\\Spf\\Router";
        }
        this->_dispatcher->setRouter(new {routerClass});
    }

}