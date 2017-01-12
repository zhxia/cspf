namespace Spf;
interface RequestInterface
{
    public function get(string! name,defaultValue=null);

    public function getQuery(string! name,defaultValue=null);

    public function getPost(string! name,defaultValue=null);

    public function getCookie(string! name,defaultValue=null);

}