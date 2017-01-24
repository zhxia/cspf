namespace Spf;

interface LoaderInterface
{
    public function autoload(string! className) -> void;
}