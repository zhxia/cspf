namespace Spf;

abstract class Controller implements ControllerInterface
{
    protected _dispatcher;
    public function __construct()
    {
        let this->_dispatcher = Application::getInstance()->getDispatcher();
    }
    public function getView() -> <View>
    {
        return this->_dispatcher->getView();
    }
}