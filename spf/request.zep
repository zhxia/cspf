namespace Spf;

class Request implements RequestInterface
{
    protected _matches;
    public function setRouterMatches(matches)
    {
        let this->_matches = matches;
    }

    public function getRouterMatches()
    {
        return this->_matches;
    }

    public function get(string! name,var defaultValue=null){
        return this->getHelper(_REQUEST,name,defaultValue);
    }

    public function getQuery(string! name,var defaultValue=null)
    {
        return this->getHelper(_GET,name,defaultValue);
    }

    public function getPost(string! name,var defaultValue=null)
    {
        return this->getHelper(_POST,name,defaultValue);
    }

    public function getCookie(string! name,var defaultValue=null)
    {
        return this->getHelper(_COOKIE,name,defaultValue);
    }

    protected function getHelper(array source,string! name=null,var defaultValue=null)->var
    {
        var value;
        if name===null {
            return source;
        }
        if !fetch value,source[name] {
            return defaultValue;
        }
        return value;
    }
}