<?php
header('Content-Type:text/html;charset=utf-8');
/**
 * caochuncheng2002@gmail.com
 * 生成前端错误码文件
 * 根据后端的reason_code.hrl生成前端的errors.lua文件
 * 每一次发版本就会自己动生成并提交
 */
 
$curPwd = getcwd();
$appRoot = dirname($curPwd).'/';
chdir($appRoot);

$reasonCodeHrlFile=$argv[1];
$reasonCodeLuaFile=$argv[2];
if( !$reasonCodeHrlFile || !$reasonCodeLuaFile){
    echo '请使用语法: php build_reason_code.php 源目录文件 输出目录文件'."\n";
	exit;
}

// 生成errors.lua文件
build_reason_code($reasonCodeHrlFile,$reasonCodeLuaFile);

/**
 * 分析reason_code.hrl文件生成errors.lua
 */
function build_reason_code($reasonCodeHrlFile,$reasonCodeLuaFile){
	if (!file_exists($reasonCodeHrlFile)){
		print "文件{$appRoot}{$file}不存在";
		exit(1);
	}
	$contents = file_get_contents($reasonCodeHrlFile);
	//
	if (preg_match_all("/-define(.*)\\n/", $contents, $matches) <= 0) {
		throw new Exception ("{$reasonCodeHrlFile}文件格式定义出错");
	}
	$reasonCodeArr = array();
	foreach($matches[1] as $matche) {
		if (trim($matche) == '') {
			continue;
		}
		//(_RC_GLOBAL_MONEY_004,1004).          %% 扣费操作，扣费类型出错
		$str=str_replace(" ","",$matche);
		$str=str_replace("(","",$str);
		$str=str_replace(").",",",$str);
		$str=str_replace("%%","",$str);
		$strArr = explode(",",$str);
		$reasonCodeArr[] = $strArr;
	}
	
	$genFileName="GameErrors";
	$lua_code = "-----------------------------------------------------------\n";
	$lua_code .= "-- Author: caochuncheng2002@gmail.com\n";
	$lua_code .= "-- Created: 2013-11-26\n";
	$lua_code .= "-- Description: 游戏错误码配置，统一由后端reason_code.hrl生成\n";
	$lua_code .= "-- 策划如果要调描述内容，必须跟后端程序获取reason_code.hrl文件进行修改\n";
	$lua_code .= "-- 注：在此文件修改都是无效的\n";
	$lua_code .= "-----------------------------------------------------祝好运!\n";
	$lua_code .= "-----------------------------------------------------------\n\n\n\n";
	$lua_code .= "local ".$genFileName." = {\n";
	
	foreach ($reasonCodeArr as $subArr) {
		$lua_code .= "    [".$subArr[1]."] = \"".$subArr[2]."\",\n";
	}
	$lua_code .= "}\n\n";
	$lua_code .= "return ".$genFileName;
	
	@unlink($reasonCodeLuaFile);
	file_put_contents($reasonCodeLuaFile, $lua_code);
	
	print "生成{$reasonCodeLuaFile}成功\r\n";
}

?>
