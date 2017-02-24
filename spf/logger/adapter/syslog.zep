namespace Spf\Logger\Adapter;

use Spf\Logger\AdapterInterface;
use Spf\Logger\Adapter;
use Spf\Logger\Formatter\Syslog as SyslogFormatter;
use Spf\Logger\Exception;
class Syslog extends Adapter{

    protected _opened=false;

    public function __construct(name,options=null)
    {
        var option,facility;

        if name {

            if !fetch option,options["option"] {
                let option = LOG_ODELAY;
            }

            if !fetch facility,options["facility"] {
                let facility = LOG_USER;
            }

            openlog(name,option,facility);

            let this->_opened = true;
        }
    }

    public function getFormatter() -> <SyslogFormatter>
    {
        if typeof this->_formatter != "object" {
            let this->_formatter=new SyslogFormatter;
        }
        return this->_formatter;
    }

    public function logInternal(string message,int type,int time,array context)
    {
        var appliedFormat;
        let appliedFormat=this->getFormatter()->format(message,type,time,context);
        if typeof appliedFormat != "array" {
            throw new Exception("this formatted message is not invalid");
        }
        syslog(appliedFormat[0],appliedFormat[1]);
    }

    public function close() -> boolean
    {
        if !this->_opened {
            return true;
        }
        return closelog();
    }
}