namespace Spf\Core;

interface ResponseInterface
{
    public function setHeader(string! name,string! value,var httpResponseCode=null,string separator=":");
    public function addHeader(string! name,string! value,var httpResponseCode=null,string separator=":");
    public function setContentType();
    public function redirect(string! url);
    public function setCookie();
}