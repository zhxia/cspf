namespace Spf;

interface ViewInterface
{
    public function display(string! viewFile,array vars=[]);
}