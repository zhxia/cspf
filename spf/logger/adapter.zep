namespace Spf\Logger;

abstract class Adapter implements AdapterInterface
{

    protected _trans = false;
    protected _formatter;
    protected _logLevel = 9;
    protected _queue = [];

    public function setLogLevel(int level) -> <AdapterInterface>
    {
        let this->_logLevel = level;
        return this;
    }

    public function getLogLevel() -> int
    {
        return this->_logLevel;
    }

    public function setFormatter(<FormatterInterface> formatter) -> <AdapterInterface>
    {
        let this->_formatter = formatter;
        return this;
    }

    public function getFormatter() -> <FormatterInterface>
    {
        return this->_formatter;
    }

    public function begin() -> <AdapterInterface>
    {
        let this->_trans = true;
        return this;
    }

    public function commit() -> <AdapterInterface>
    {
        var message;
        if !this->_trans {
            throw new Exception("There is no active transaction");
        }
        let this->_trans = true;
        for message in this->_queue {
            this->{"logInternal"}(message->getMessage,message->getType,message->getTime,message->getContext);
        }
        let this->_queue=[];
        return this;
    }

    public function rollback() -> <AdapterInterface>
    {
        if !this->_trans {
            throw new Exception("There is no active transaction");
        }
        let this->_trans=false,this->_queue=[];
        return this;
    }

    public function isTransaction() -> boolean
    {
        return this->_trans;
    }

    public function log(var type,var message=null,array! context=null) -> <AdapterInterface>
    {
        var timestamp,toggledMessage,toggledType;
        if typeof type == "string" && typeof message == "integer" {
            let toggledMessage = type,toggledType = message;
        }
        else{
            if typeof type == "string" && typeof message == "null" {
                let toggledMessage = type,toggledType = message;
            }
            else{
                let toggledMessage = message,toggledType = type;
            }
        }

        if typeof toggledType == "null" {
            let toggledType = \Spf\Logger::DEBUG;
        }

        if this->_logLevel >= toggledType {
            let timestamp = time();
            if this->_trans {
                let this->_queue[]= new Item(toggledMessage,toggledType,timestamp,context);
            }
            else {
                this->{"logInternal"}(toggledMessage,toggledType,timestamp,context);
            }
        }

        return this;
    }

    public function info(string! message,array! context=null) -> <AdapterInterface>
    {
        return this->log(\Spf\Logger::INFO,message,context);
    }

    public function debug(string! message,array! context=null) -> <AdapterInterface>
    {
        return this->log(\Spf\Logger::DEBUG,message,context);
    }

    public function notice(string! message,array! context) -> <AdapterInterface>
    {
        return this->log(\Spf\Logger::NOTICE,message,context);
    }

    public function warning(string! message,array! context) -> <AdapterInterface>
    {
        return this->log(\Spf\Logger::WARNING,message,context);
    }

    public function alert(string! message,array! context) -> <AdapterInterface>
    {
        return this->log(\Spf\Logger::ALERT,message,context);
    }

    public function error(string! message,array! context) -> <AdapterInterface>
    {
        return this->log(\Spf\Logger::ERROR,message,context);
    }

    public function critical(string! message,array! context) -> <AdapterInterface>
    {
        return this->log(\Spf\Logger::CRITICAL,message,context);
    }

    public function emergency(string! message,array! context) -> <AdapterInterface>
    {
        return this->log(\Spf\Logger::EMERGENCY,message,context);
    }


}
