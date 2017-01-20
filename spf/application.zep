namespace Spf;

class Application {

    protected _dispatcher;

    public function __construct()
    {
        let this->_dispatcher=new Dispatcher();
    }

    public function run()
    {
        this->initialize();
        this->_dispatcher->dispatch();
    }

    protected function initialize()
    {
        var arrConf,requestClass,responseClass,viewClass,routerClass;
        let arrConf = Loader::getConfig("common");
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
        this->_dispatcher->setView(new {viewClass});
        if !fetch routerClass,arrConf["router_class"] {
            let routerClass="\\Spf\\Router";
        }
        this->_dispatcher->setRouter(new {routerClass});
        spl_autoload_register("Spf\\Loader::autoload");
    }

}