namespace Spf;

interface LoaderInterface
{
    public static function autoload(string! className) -> void;
}