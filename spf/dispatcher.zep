namespace Spf;

class Dispatcher implements DispatchInterface {
    private _request;
    private _response;
    private _router;
    private _view;

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

    public function dispatch()
    {
        var controllerClass,controller,result;
        let controllerClass = this->_router->mapping();
        let controller=new {controllerClass};
        while true
        {
            let result = controller->execute();
            if result instanceof ControllerInterface {
                let controller = result;
                continue;
            }
            break;
        }
        if is_string(result) {
            this->_view->display(result);
        }
    }
}