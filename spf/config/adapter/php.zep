/*
 * Created by PhpStorm.
 * User: zhxia84@gmail.com
 * Date: 2017/5/5
 * Time: 16:34
 */

namespace Spf\Config\Adapter;

use Spf\Config;
use Spf\Config\Exception;

class Php extends Config {
   public function __construct(string! filePath)
    {
        if is_file(filePath) === false {
            throw Exception("file \"".filePath."\" not found!");
        }

        parent::__construct(require filePath);
    }
}