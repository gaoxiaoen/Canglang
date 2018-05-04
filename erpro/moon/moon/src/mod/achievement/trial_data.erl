%%----------------------------------------------------
%% 试炼场数据配置
%% @author qingxuan
%% (此文件由工具生成，请不要手工修改)
%% @end
%%----------------------------------------------------
-module(trial_data).
-export([
    get/1
    ,is_trial_map/1
]).
-include("common.hrl").
-include("trial.hrl").

%% -> undefined | #trial_base{}


get(10000) ->
    #trial_base{
		id = 10000,
        map = 201,      
        npc = 13022 ,
		award = [{coin,10000},{stone,1000}]		
    };
get(10001) ->
    #trial_base{
		id = 10001,
        map = 201,      
        npc = 13000 ,
		award = [{coin,40000},{stone,4000}]		
    };
get(10002) ->
    #trial_base{
		id = 10002,
        map = 201,      
        npc = 13001 ,
		award = [{coin,80000},{stone,8000}]		
    };
get(10003) ->
    #trial_base{
		id = 10003,
        map = 201,      
        npc = 13002 ,
		award = [{coin,120000},{stone,12000}]		
    };
get(10004) ->
    #trial_base{
		id = 10004,
        map = 201,      
        npc = 13003 ,
		award = [{coin,160000},{stone,16000}]		
    };
get(10005) ->
    #trial_base{
		id = 10005,
        map = 201,      
        npc = 13004 ,
		award = [{coin,200000},{stone,20000}]		
    };
get(10006) ->
    #trial_base{
		id = 10006,
        map = 201,      
        npc = 13005 ,
		award = [{coin,240000},{stone,24000}]		
    };
get(10007) ->
    #trial_base{
		id = 10007,
        map = 201,      
        npc = 13006 ,
		award = [{coin,280000},{stone,28000}]		
    };
get(10008) ->
    #trial_base{
		id = 10008,
        map = 201,      
        npc = 13007 ,
		award = [{coin,320000},{stone,32000}]		
    };
get(10009) ->
    #trial_base{
		id = 10009,
        map = 201,      
        npc = 13008 ,
		award = [{coin,360000},{stone,36000}]		
    };
get(10010) ->
    #trial_base{
		id = 10010,
        map = 201,      
        npc = 13009 ,
		award = [{coin,400000},{stone,40000}]		
    };
get(10011) ->
    #trial_base{
		id = 10011,
        map = 201,      
        npc = 13010 ,
		award = [{coin,440000},{stone,44000}]		
    };
get(10012) ->
    #trial_base{
		id = 10012,
        map = 201,      
        npc = 13011 ,
		award = [{coin,480000},{stone,48000}]		
    };
get(10013) ->
    #trial_base{
		id = 10013,
        map = 201,      
        npc = 13012 ,
		award = [{coin,520000},{stone,52000}]		
    };
 
get(_) ->
    undefined.

is_trial_map(201) -> true;
 
is_trial_map(_) -> false.

