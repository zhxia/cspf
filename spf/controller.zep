namespace Spf;

abstract class Controller implements ControllerInterface
{
    protected _dispatcher;
    public final function __construct()
    {
        let this->_dispatcher = Application::getInstance()->getDispatcher();
        this->initialize();
    }

    public function initialize()
    {
    }

    public function getRouter()-> <Router>
    {
        return this->_dispatcher->getRouter();
    }

    public function getRequest()-> <Request>
    {
        return this->_dispatcher->getRequest();
    }

    public function getResponse()-> <Response>
    {
        return this->_dispatcher->getResponse();
    }

    public function getView() -> <View>
    {
        return this->_dispatcher->getView();
    }
}