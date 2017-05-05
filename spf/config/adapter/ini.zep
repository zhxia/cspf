/*
 * Created by PhpStorm.
 * User: zhxia84@gmail.com
 * Date: 2017/5/5
 * Time: 16:34
 */

namespace Spf\Config\Adapter;

use Spf\Config;
use Spf\Config\Exception;
class Ini extends Config {
    public function __construct(string! filePath,mode=null)
    {
        var iniConfig;
        if mode == null {
            let mode= INI_SCANNER_RAW;
        }
        let iniConfig=parse_ini_file(filePath,true,mode);
        if iniConfig === false {
            throw new Exception("parse ini file:\"".filePath."\" failed!");
        }

        var config, section, sections, directives, path, lastValue;

        		let config = [];

        		for section, directives in iniConfig {
        			if typeof directives == "array" {
        				let sections = [];
        				for path, lastValue in directives {
        					let sections[] = this->_parseIniString((string)path, lastValue);
        				}
        				if count(sections) {
        					let config[section] = call_user_func_array("array_merge_recursive", sections);
        				}
        			} else {
        				let config[section] = this->_cast(directives);
        			}
        		}

        		parent::__construct(config);
    }

    /**
    	 * Build multidimensional array from string
    	 *
    	 * <code>
    	 * $this->_parseIniString('path.hello.world', 'value for last key');
    	 *
    	 * // result
    	 * [
    	 *      'path' => [
    	 *          'hello' => [
    	 *              'world' => 'value for last key',
    	 *          ],
    	 *      ],
    	 * ];
    	 * </code>
    	 */
    	protected function _parseIniString(string! path, var value) -> array
    	{
    		var pos, key;
    		let value = this->_cast(value);
    		let pos = strpos(path, ".");

    		if pos === false {
    			return [path: value];
    		}

    		let key = substr(path, 0, pos);
    		let path = substr(path, pos + 1);

    		return [key: this->_parseIniString(path, value)];
    	}
    	/**
    	 * We have to cast values manually because parse_ini_file() has a poor implementation.
    	 *
    	 * @param mixed ini The array casted by `parse_ini_file`
    	 */
    	private function _cast(var ini) -> bool | null | double | int | string
    	{
    		var key, val;
    		if typeof ini == "array" {
    			for key, val in ini{
    				let ini[key] = this->_cast(val);
    			}
    		}
    		if typeof ini == "string" {
    			// Decode true
    			if ini === "true" || ini === "yes" || strtolower(ini) === "on"{
    				return true;
    			}

    			// Decode false
    			if ini === "false" || ini === "no" || strtolower(ini) === "off"{
    				return false;
    			}

    			// Decode null
    			if ini === "null" {
    				return null;
    			}

    			// Decode float/int
    			if is_numeric(ini) {
    				if preg_match("/[.]+/", ini) {
    					return (double) ini;
    				} else {
    					return (int) ini;
    				}
    			}
    		}
    		return ini;
    	}
}