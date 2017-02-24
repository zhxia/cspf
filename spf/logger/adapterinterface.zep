namespace Spf\Logger;

interface AdapterInterface
{
    public function setFormatter(<FormatterInterface> formatter) -> <AdapterInterface>;

    public function getFormatter() -> <FormatterInterface>;

    public function setLogLevel(int level) -> <AdapterInterface>;

    public function getLogLevel() -> int;

    public function log(var type,var message=null,array! context=null) -> <AdapterInterface>;

    public function begin() -> <AdapterInterface>;

    public function commit() -> <AdapterInterface>;

    public function rollback() -> <AdapterInterface>;

    public function logInternal(string message,int type,int time,array context);

}