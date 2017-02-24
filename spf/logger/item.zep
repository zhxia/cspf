namespace Spf\Logger;

class Item {
    protected _message {get};

    protected _type {get};

    protected _time {get};

    protected _context {get};

    public function __construct(string message,int type,int time,var context=null)
    {
        let this->_message = message;
        let this->_type = type;
        let this->_time = time;
        if typeof context == "array" {
            let this->_context = context;
        }
    }
}