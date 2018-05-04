
%% -----------------------
%% @autor wangweibiao
%% ------------------------
-module(demon_grab_times).
-export([
		get/1
		]).

-include("gain.hrl").
-include("common.hrl").


get(1) -> 
	{[#loss{label = coin,val = 10000, msg = ?MSGID(<<"金币不足">>)}], 10};
	
get(2) -> 
	{[#loss{label = coin,val = 20000, msg = ?MSGID(<<"金币不足">>)}], 10};
	
get(3) -> 
	{[#loss{label = gold_bind,val = 25, msg = ?MSGID(<<"绑定晶钻不足">>)}], 10};
	
get(4) -> 
	{[#loss{label = gold_bind,val = 30, msg = ?MSGID(<<"绑定晶钻不足">>)}], 10};
	
get(5) -> 
	{[#loss{label = gold,val = 30, msg = ?MSGID(<<"晶钻不足">>)}], 10};
	
get(6) -> 
	{[#loss{label = gold,val = 50, msg = ?MSGID(<<"晶钻不足">>)}], 10};
	
get(7) -> 
	{[#loss{label = gold,val = 50, msg = ?MSGID(<<"晶钻不足">>)}], 10};
	
get(8) -> 
	{[#loss{label = gold,val = 50, msg = ?MSGID(<<"晶钻不足">>)}], 10};
	
get(9) -> 
	{[#loss{label = gold,val = 50, msg = ?MSGID(<<"晶钻不足">>)}], 10};
	
get(10) -> 
	{[#loss{label = gold,val = 50, msg = ?MSGID(<<"晶钻不足">>)}], 10};
	
get(_) ->
	false.

