namespace Spf;

class Config implements \ArrayAccess,\Countable
{
    public function __construct(array! arrayConfig=null)
    {
        var key,value;
        for key,value in arrayConfig {
            this->offsetSet(key,value);
        }
    }

    public function offsetSet(var index,var value)
    {
        let index=strval(index);
        if typeof value === "array" {
            let this->{index}=new self(value);
        }
        else{
            let this->{index}=value;
        }
    }

    public function offsetGet(var index) -> string
    {
        let index=strval(index);
        return this->{index};
    }

    public function offsetUnset(var index)
    {
        let index = strval(index);
        let this->{index}=null;
    }

    public function offsetExists(var index) -> boolean
    {
        let index = strval(index);
        return isset this->{index};
    }

    public function count() -> int
    {
        return count(get_object_vars(this));
    }

    public function toArray() -> array
    {
        var key,value,arrayConfig;
        let arrayConfig=[];
        for key,value in get_object_vars(this) {
            if typeof value === "object" {
                if method_exists(value,"toArray") {
                    let arrayConfig[key] = value->toArray();
                }
                else{
                    let arrayConfig[key] = value;
                }
            }
            else{
               let arrayConfig[key] = value;
            }
        }
        return arrayConfig;
    }

}