/*
 * Created by PhpStorm.
 * User: zhxia84@gmail.com
 * Date: 2017/5/5
 * Time: 16:31
 */

namespace Spf\Config\Adapter;

use Spf\Config;
use Spf\Config\Exception;

class Json extends Config{
   public function __construct(string! filePath)
    {
        var jsonStr,arrContent;
        let jsonStr=file_get_contents(filePath);
        let arrContent=json_decode(jsonStr,true);
        if arrContent === false {
            throw new Exception("json file:\"".filePath."\" decode failed!");
        }
        parent::__construct(arrContent);
    }
}