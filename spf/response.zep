namespace Spf;
class Response implements ResponseInterface
{

    public function setHeader(string name,string value,httpResponseCode=null,string separator=":") -> <Response>
    {
        header(name.separator.value,true,httpResponseCode);
        return this;
    }

    public function setContentType(string name,charset=null) -> <Response>
    {
        if charset === null {
            return this->setHeader("Content-Type",name);
        }
        else{
            return this->setHeader("Content-Type",name.";".charset);
        }
    }

    public function setCookie(string name,value=null,int expire=0,string path="/",boolean secure=null,string! domain=null,boolean httpOnly =null) -> <Response>
    {
        if expire {
            let expire = time() + expire;
        }
        setcookie(name,value,expire,path,secure,domain,httpOnly);
        return this;
    }

    public function removeCookie(string name,string path="/",boolean secure=null,string! domain=null,boolean httpOnly =null) -> <Response>
    {
        setcookie(name,null,-3600,path,secure,domain,httpOnly);
        return this;
    }

    public function setCacheControl(string value) -> <Response>
    {
        return this->setHeader("Cache-Control",value);
    }

    public function redirect(string url,boolean permanent=false) -> void
    {
        var httpResponseCode;
        if permanent {
            let httpResponseCode=301;
        }
        else{
            let httpResponseCode=302;
        }
        this->setHeader("Location",url,httpResponseCode);
        exit(0);
    }
}