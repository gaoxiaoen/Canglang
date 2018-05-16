%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_qinmidu_args
	%%% @Created : 2017-03-28 15:35:49
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_qinmidu_args).
-export([get/1]).
-include("relation.hrl").
%%类型说明
%% 0  跨服消消乐;
%% 1  跨服副本;


  get(0) -> #qinmidu{  id=0, value=10,limit=20 };
  get(1) -> #qinmidu{  id=1, value=3,limit=10 };
get(_) -> [].
