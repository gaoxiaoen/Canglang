%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_generate_smelt
	%%% @Created : 2015-10-22 18:23:21
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_generate_smelt).
-export([get/1]).
-include("error_code.hrl").
get(Data) -> throw({"ER_CONFIG_MISSING_STRE_LIMIT",0,Data}).