namespace Spf\Logger\Formatter;

class Syslog extends \Spf\Logger\Formatter
{
    public function format(string message,int type,int timestamp,var context=null) -> array
    {
        if typeof context == "array" {
            let message = this->interpolate(message,context);
        }
        return [type,message];
    }
}