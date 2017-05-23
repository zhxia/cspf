namespace Spf;

class Dispatcher implements DispatchInterface {
    protected _request;
    protected _response;
    protected _router;
    protected _view;
    protected _loader;
    protected _appNamespace;
    protected _plugins = [];
    protected _interceptors =[];

    public function addPlugin(<Plugin> plugin)
    {
        let this->_plugins[] = plugin;
    }

    public function setLoader(<LoaderInterface> loader)
    {
        let this->_loader=loader;
    }

    public function getLoader() -> <LoaderInterface>
    {
        return this->_loader;
    }

    public function setRouter(<RouterInterface> router)
    {
        let this->_router=router;
    }

    public function getRouter() -> <RouterInterface>
    {
        return this->_router;
    }

    public function setRequest(<RequestInterface> request)
    {
        let this->_request=request;
    }

    public function getRequest() -> <RequestInterface>
    {
        return this->_request;
    }

    public function setResponse(<ResponseInterface> response)
    {
        let this->_response=response;
    }

    public function getResponse() -> <ResponseInterface>
    {
        return this->_response;
    }

    public function setView(<ViewInterface> view)
    {
        let this->_view=view;
    }

    public function getView() -> <ViewInterface>
    {
        return this->_view;
    }

    public function setAppNamespace(string! $namespace)
    {
        let this->_appNamespace=$namespace;
    }

    public function dispatch()
    {
        var controllerClass,controller,result;
        this->executePlugins(Plugin::STEP_ROUTER_STARTUP);
        let controllerClass = this->_appNamespace."\\".this->_router->mapping();
        if !class_exists(controllerClass){
            let controllerClass=Application::getInstance()->getConfigItem("error404","common");
        }
        this->executePlugins(Plugin::STEP_ROUTER_SHUTDOWN);
        let controller=new {controllerClass};
        this->executePlugins(Plugin::STEP_DISPATCH_LOOP_STARTUP);
        let this->_interceptors = this->getInterceptors(controllerClass);
        //interceptor before
        this->executeInterceptors(Interceptor::INVOKE_BEFORE);
        while true
        {
            this->executePlugins(Plugin::STEP_DISPATCH_STARTUP);
            let result = controller->execute();
            this->executePlugins(Plugin::STEP_DISPATCH_SHUTDOWN);
            if typeof result=="object" && result instanceof ControllerInterface {
                let controller = result;
                continue;
            }
            break;
        }
        //interceptor after
        this->executeInterceptors(Interceptor::INVOKE_AFTER);
        this->executePlugins(plugin::STEP_DISPATCH_LOOP_SHUTDOWN);
        if is_string(result) {
            this->_view->display(result);
        }
    }

    protected function executePlugins(step)
    {
        if empty this->_plugins {
            return;
        }
        var plugin;
        for plugin in this->_plugins {
            switch step{
                case Plugin::STEP_ROUTER_STARTUP:
                    plugin->routerStartup(this->_request,this->_response);
                    break;
                case Plugin::STEP_ROUTER_SHUTDOWN:
                    plugin->routerShutdown(this->_request,this->_response);
                    break;
                case Plugin::STEP_DISPATCH_LOOP_STARTUP:
                    plugin->dispatchLoopStartup(this->_request,this->_response);
                    break;
                case Plugin::STEP_DISPATCH_STARTUP:
                    plugin->dispatchStartup(this->_request,this->_response);
                    break;
                case Plugin::STEP_DISPATCH_SHUTDOWN:
                    plugin->dispatchShutdown(this->_request,this->_response);
                    break;
                case plugin::STEP_DISPATCH_LOOP_SHUTDOWN:
                    plugin->dispatchLoopShutdown(this->_request,this->_response);
                    break;
            }
        }
    }

    protected function executeInterceptors(step)
    {
        if empty this->_interceptors {
            return;
        }
        var interceptor;
        if step == Interceptor::INVOKE_BEFORE {
            for interceptor in this->_interceptors {
                if interceptor->before(this->_request,this->_response) != Interceptor::STEP_CONTINUE {
                    break;
                }
            }
        }
        if step == Interceptor::INVOKE_AFTER {
            let this->_interceptors = array_reverse(this->_interceptors);
            for interceptor in this->_interceptors {
                if interceptor->after(this->_request,this->_response) != Interceptor::STEP_CONTINUE {
                    break;
                }
            }
        }
    }

    protected function getInterceptors(className)
    {
        var app,commonConf,interceptors,interceptorClasses,cls,key;
        let interceptors = [];
        let app = Application::getInstance();
        let commonConf = app->getConfig("common");
        let key=str_replace(this->_appNamespace."\\Controllers\\","",className);
        if fetch interceptorClasses,commonConf["interceptors"][key] {
            for cls in interceptorClasses {
                let interceptors[] = new {cls};
            }
        }
        elseif fetch interceptorClasses,commonConf["interceptors"]["@default"]{
            for cls in interceptorClasses {
                    let interceptors[] = new {cls};
            }
        }
        return interceptors;
    }
}