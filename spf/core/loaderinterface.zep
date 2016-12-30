namespace Spf\Core;

interface LoaderInterface
{
    public static function autoload(string! className) -> void;
}