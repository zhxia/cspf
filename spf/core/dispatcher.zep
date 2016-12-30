namespace Spf\Core;

class Dispatcher implements DispatchInterface {
    private _request;
    private _response;
    private _router;
    private static _instance=null;

    private function __construct()
    {

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

    public static function getInstance()-> <DispatchInterface>
    {
        if self::_instance===null {
            let self::_instance=new self();
        }
        return self::_instance;
    }

    public function dispatch()
    {

    }
}