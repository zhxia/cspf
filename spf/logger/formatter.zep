namespace Spf\Logger;

abstract class Formatter implements FormatterInterface
{
    public function getTypeString(int type) -> string
    {
        switch type {
            case \Spf\Logger::DEBUG:
                return "DEBUG";
            case \Spf\Logger::INFO:
                return "INFO";
            case \Spf\Logger::NOTICE:
                return "NOTICE";
            case \Spf\Logger::WARNING:
                return "WARNING";
            case \Spf\Logger::ERROR:
                return "ERROR";
            case \Spf\Logger::ALERT:
                return "ALERT";
            case \Spf\Logger::EMERGENCY:
                return "EMERGENCY";
            case \Spf\Logger::CRITICAL:
                return "CRITICAL";
            case \Spf\Logger::CUSTOM:
                return "CUSTOM";
            case \Spf\Logger::SPECIAL:
                return "SPECIAL";
        }
        return "CUSTOM";
    }

    public function interpolate(string message,var context=null) -> string
    {
        var replace,key,value;
        if typeof context == "array" && count(context) > 0 {
            let replace= [];
            for key,value in context {
                let replace["{".key."}"]=value;
            }
            return strtr(message,replace);
        }
        return message;
    }

}