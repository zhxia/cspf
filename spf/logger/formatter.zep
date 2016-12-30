namespace Spf\Logger;

class Formatter implements FormatterInterface
{
    public function format(string message,int type,int timestamp,var context=null)->string|array;
}