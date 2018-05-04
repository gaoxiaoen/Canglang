%% -----------------------
%% 勋章配置表
%% @autor wangweibiao
%% ------------------------
-module(leisure_role_data).
-export([
		get_cond/1,
		get_attr/1
		]).

-include("attr.hrl").

%%[{MinLev, MaxLev, AttrId}...]
get_cond(11091) ->
	[{1,0,1}];
get_cond(11092) ->
	[{1,0,2}];
get_cond(12131) ->
	[{1,0,3}];
get_cond(12132) ->
	[{1,0,4}];
get_cond(14121) ->
	[{1,0,5}];
get_cond(14122) ->
	[{1,0,6}];
get_cond(16131) ->
	[{1,0,7}];
get_cond(16132) ->
	[{1,0,8}];
get_cond(18131) ->
	[{1,0,9}];
get_cond(18132) ->
	[{1,0,10}];

get_cond(_Id) ->
    {false, <<"数据不存在">>}.
	

get_attr(1) ->
	{800, #attr{
         aspd = 50
         ,dmg_min = 100
         ,dmg_max = 100
         ,defence = 0
         ,hitrate = 100
         ,evasion = 0
         ,critrate = 0
        ,tenacity = 0
        ,anti_attack = 0
        ,anti_stun = 0
	}};	
get_attr(2) ->
	{800, #attr{
         aspd = 50
         ,dmg_min = 100
         ,dmg_max = 100
         ,defence = 0
         ,hitrate = 100
         ,evasion = 0
         ,critrate = 0
        ,tenacity = 0
        ,anti_attack = 0
        ,anti_stun = 0
	}};	
get_attr(3) ->
	{800, #attr{
         aspd = 50
         ,dmg_min = 100
         ,dmg_max = 100
         ,defence = 0
         ,hitrate = 100
         ,evasion = 0
         ,critrate = 0
        ,tenacity = 0
        ,anti_attack = 0
        ,anti_stun = 0
	}};	
get_attr(4) ->
	{800, #attr{
         aspd = 50
         ,dmg_min = 100
         ,dmg_max = 100
         ,defence = 0
         ,hitrate = 100
         ,evasion = 0
         ,critrate = 0
        ,tenacity = 0
        ,anti_attack = 0
        ,anti_stun = 0
	}};	
get_attr(5) ->
	{800, #attr{
         aspd = 50
         ,dmg_min = 100
         ,dmg_max = 100
         ,defence = 0
         ,hitrate = 100
         ,evasion = 0
         ,critrate = 0
        ,tenacity = 0
        ,anti_attack = 0
        ,anti_stun = 0
	}};	
get_attr(6) ->
	{800, #attr{
         aspd = 50
         ,dmg_min = 100
         ,dmg_max = 100
         ,defence = 0
         ,hitrate = 100
         ,evasion = 0
         ,critrate = 0
        ,tenacity = 0
        ,anti_attack = 0
        ,anti_stun = 0
	}};	
get_attr(7) ->
	{800, #attr{
         aspd = 50
         ,dmg_min = 100
         ,dmg_max = 100
         ,defence = 0
         ,hitrate = 100
         ,evasion = 0
         ,critrate = 0
        ,tenacity = 0
        ,anti_attack = 0
        ,anti_stun = 0
	}};	
get_attr(8) ->
	{800, #attr{
         aspd = 50
         ,dmg_min = 100
         ,dmg_max = 100
         ,defence = 0
         ,hitrate = 100
         ,evasion = 0
         ,critrate = 0
        ,tenacity = 0
        ,anti_attack = 0
        ,anti_stun = 0
	}};	
get_attr(9) ->
	{800, #attr{
         aspd = 50
         ,dmg_min = 100
         ,dmg_max = 100
         ,defence = 0
         ,hitrate = 100
         ,evasion = 0
         ,critrate = 0
        ,tenacity = 0
        ,anti_attack = 0
        ,anti_stun = 0
	}};	
get_attr(10) ->
	{800, #attr{
         aspd = 50
         ,dmg_min = 100
         ,dmg_max = 100
         ,defence = 0
         ,hitrate = 100
         ,evasion = 0
         ,critrate = 0
        ,tenacity = 0
        ,anti_attack = 0
        ,anti_stun = 0
	}};	

get_attr(_Id) ->
    {false, <<"数据不存在">>}.

	
	
	
	
