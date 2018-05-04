%% -*- coding: latin-1 -*-
%% Author: caochuncheng2002@gmail.com
%% Created: 2013-7-3
%% Description: 任务配置，不可以修改，必须由任务配置表生成


-module(cfg_mission).

-export([
         find/1,
         list/0,
         get_mission_id_list/1,
         get_mission_group/1,
         find_mission_loop_reward/1,
         get_mission_all_group/0,
         get_no_group_mission_id_list/1,
         get_no_group_level_list/0
        ]).


find(10001010) ->
    [{r_mission_base_info,10001010,"河边洗衣",1,0,1,0,"",0,[],1,160,1,1,0,[],[],[],[{r_mission_model_status,[1000101],[]},{r_mission_model_status,[1000102],[]}],1,{r_mission_reward,1,0,1,0,750,0,100},[]}];
%% 根据任务Id查找任务信息
%% 返回 [#r_mission_base_info{}]
find(_) ->
    [].

%% 所有任务Id列表
list() ->
    [10001010].

%% 根据任务分组，最小等级，最大等级
%% {{Group,MinLevel,MaxLevel},{TotalMissionIdNumber,[MissionId,....]}}.
%% 返回 [{TotalMissionIdNumber,[MissionId,...]}] | []
get_mission_id_list(_) ->
    [].

%% 根据任务大组获取任务分组信息
%% {Group,[{MinLevel,MaxLevel},...]}.
%% 返回 [{MinLevel,MaxLevel},...]
get_mission_group(_) ->
    [].

%% 获取所有任务分组
%% 返回 [GroupId,...]
get_mission_all_group() ->
    [].

get_no_group_mission_id_list({1,160}) ->
    [10001010];
%% 根据最小等级、最大等级获取主线和支线可接受的任务id列表
%% 返回 [MissionId,...]
get_no_group_mission_id_list({_MinLevel,_MaxLevel}) ->
    [].

%% 获取主线和支线所有任务等级段信息列表
%% 返回 [{MinLevel,MaxLevel},...]
get_no_group_level_list() ->
    [{1,160}].

find_mission_loop_reward({1003,35}) ->
    [{{r_mission_reward,0,0,0,0,500,0,0},[{5,[{r_mission_reward_item,10201007,1,25}]}]}];
%% 循环任务奖励配置
%% {{BigGroup,Level},{#r_mission_reward{},[{DoTimes,[#r_mission_reward_item{},...]},...]}}.
%% 返回 [{MissionReward,RewardItemList}] | []
find_mission_loop_reward(_) ->
    [].

