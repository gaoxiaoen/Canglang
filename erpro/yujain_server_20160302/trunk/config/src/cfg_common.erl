%% Author: caochuncheng2002@gmail.com
%% Created: 2015-12-22
%% Description: 通用配置，不可以修改，必须由通用配置表生成

-module(cfg_common).

-include("common.hrl").

-export([
         find/1
        ]).


%% 多少秒自动恢复魔法值,单位：秒
find(auto_recovery_mp_interval) ->
    2;
%% 每次自动恢复魔法值
find(auto_recovery_mp_value) ->
    1;
%% 怒气恢复计算系数
find(add_anger_index) ->
    50000;
%% 进入副本最大怒气值
find(enter_fb_max_anger) ->
    7500;
%% 最大怒气值
find(max_anger) ->
    10000;
%% 出生地图id【创建角色出生地图】
find({newer_born_map_id,0}) ->
    10001;
%% 出生点坐标【创建角色出生坐标】
find({newer_born_point,0}) ->
    {6850,4618};
find(_) -> 
    undefined.


