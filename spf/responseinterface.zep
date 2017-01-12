namespace Spf;

interface ResponseInterface
{
    public function setHeader(string name,string value,httpResponseCode=null,string separator=":" ) -> <ResponseInterface>;
    public function setContentType(string contentType,charset=null) -> <ResponseInterface>;
    public function setCacheControl(string value) -> <ResponseInterface>;
    public function redirect(string url,boolean permanent=false) ->void;
    public function setCookie(string name,string value,int expire,string path="/",domain=null,boolean secure = false,boolean httpOnly = false) -> <ResponseInterface>;
    public function removeCookie(string name,string path="/",domain=null,boolean secure = false,boolean httpOnly = false) -> <ResponseInterface>;
}