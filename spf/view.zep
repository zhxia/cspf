namespace Spf;

class View implements ViewInterface {
    private _viewFile;
    private _viewPath;
    private _vars=[];
    private _layoutFile;
    private _tpl;
    private _dispatcher;

    public function setLayoutFile(string! layoutFile)
    {
        let this->_layoutFile = layoutFile;
    }

    public function setViewPath(string! viewPath)
    {
        let this->_viewPath = viewPath;
    }

    public function assign(string! name,var value)
    {
        let this->_vars[name] = value ;
    }

    public function assignData(array! data)
    {
        let this->_vars=array_merge(this->_vars,data);
    }

    public function displayJson(array data)
    {
        var response;
        let response=Application::getInstance()->getDispatcher()->getResponse();
        response->setContentType("application/json");
        if typeof data == "array" {
            echo json_encode(data);
        }
        else{
            echo strval(data);
        }
    }

    public function displayJsonp(string! callback,array data)
    {
        var response,params;
        let response=Application::getInstance()->getDispatcher()->getResponse();
        response->setContentType("application/javascript");
        if typeof data == "array" {
            let params = json_encode(data);
        }
        else{
            let params=strval(data);
        }
        echo "try{".callback."(".params.");}catch(e){}";
    }

    public function display(string! viewFile,array vars=[])
    {
        echo this->render(viewFile,vars);
    }

    public function render(string! viewFile,array vars=[]) -> string
    {
        var returnValue;
        if !empty vars {
            let this->_vars=array_merge(this->_vars,vars);
        }
        if empty this->_layoutFile {
            let returnValue = this->renderView(viewFile);
        }
        else{
            let this->_tpl=viewFile;
            let returnValue = this->renderView(this->_layoutFile);
        }
        return returnValue;
    }

    public function getSubView() -> string
    {
        return this->renderView(this->_tpl);
    }

    protected function renderView(string! viewFile) -> string
        {
            var viewContent;
            let viewFile=this->_viewPath.DIRECTORY_SEPARATOR.viewFile.".phtml";
            if !file_exists(viewFile){
                throw new Exception("view file [".viewFile."] not found!");
            }
            ob_start();
            extract(this->_vars);
            require viewFile;
            let viewContent = ob_get_contents();
            ob_end_clean();
            return viewContent;
        }

}