<?php
// 生成各种字典配置文件
$curPwd = getcwd();
$appRoot = dirname($curPwd).'/';
chdir($appRoot);

// 生成日志类型配置文件
build_log_dict($appRoot);

/**
 * 生成日志类型配置文件
 * 生成log.hrl 和 cfg_log_dict.erl
 */
function build_log_dict($appRoot){
	$logDictFile = "hrl/log.xml";
	$genLogHrlFile = "hrl/log.hrl";
	$genLogDictFile = "config/src/cfg_log_dict.erl";
	// 开始生成log.hrl和cfg_log_dict.erl
	if (!file_exists($logDictFile)){
		print "文件{$appRoot}{$file}不存在";
		exit(1);
	}
	$log_hrl = "";
	$log_hrl .= "%% Author: caochuncheng2002@gmail.com\n";
	$log_hrl .= "%% Created: 2013-7-15\n";
	$log_hrl .= "%% Description: 日志类型宏定义，此文件不可以修改，由log.xml生成\n\n\n";
	
	$cfg_dict_log = "";
	$cfg_dict_log .= "%% -*- coding: latin-1 -*-\n";
	$cfg_dict_log .= "%% Author: caochuncheng2002@gmail.com\n";
	$cfg_dict_log .= "%% Created: 2013-7-15\n";
	$cfg_dict_log .= "%% Description: 日志类型字典信息，此文件不可以修改，由log.xml生成\n\n\n";
	$cfg_dict_log .= "-module(cfg_log_dict).\n\n";
	$cfg_dict_log .= "-export([\n";
	$cfg_dict_log .= "         get_log_dict/0\n";
	$cfg_dict_log .= "        ]).\n";
	
	$log_dict_arr = array();
	
	$log_xml = simplexml_load_file($logDictFile);
	$keys = $log_xml->key;
	foreach($keys as $key){
		$name = (string)$key['name'];
		$value = (string)$key['value'];
		$desc = (string)$key['desc'];
		
		$log_hrl .="-define(".$name.",".$value."). %% ".$desc. "\n";
		
		$type = (int) (intval($value)/100000); 
		//%% [{"id":320000,"desc":"商店购买获得","type":3},...].
		$temp_json = "{\\\"id\\\":".$value;
		$temp_json .= ",\\\"name\\\":\\\"".$desc."\\\"";
		$temp_json .= ",\\\"type\\\":".$type;
		$temp_json .= "}";
		$log_dict_arr[] = $temp_json;
	}
	
	$log_dict_erl = "\"[".implode(",\n      ",$log_dict_arr)."]\"";
	
	$cfg_dict_log .= "%% 获取信息字典信息\n";
	$cfg_dict_log .= "%% 返回 json数据\n";
	$cfg_dict_log .= "%% [{\"id\":320000,\"desc\":\"商店购买获得\",\"type\":3},...].\n";
	$cfg_dict_log .= "get_log_dict() ->\n";
	$cfg_dict_log .= "    ".$log_dict_erl.".\n";
		
	@unlink($genLogHrlFile);
	file_put_contents($genLogHrlFile, $log_hrl);
	@unlink($genLogDictFile);
	file_put_contents($genLogDictFile, $cfg_dict_log);
	print "生成{$appRoot}{$genLogHrlFile}成功\r\n";
	print "生成{$appRoot}{$genLogDictFile}成功\r\n";
}

?>
