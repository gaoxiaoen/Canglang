%% -*- coding: latin-1 -*-
%% Author: caochuncheng2002@gmail.com
%% Created: 2013-7-3
%% Description: 任务字典信息


-module(cfg_mission_dict).

-export([
         get_mission_dict/0
        ]).


%% 获取信息字典信息
%% 返回 json数据
%% [{"id":23600155,"name":"奇妙微笑","type":1,"big_group":0},...].
get_mission_dict() ->
    "[{\"id\":10001010,\"name\":\"河边洗衣\",\"type\":1,\"big_group\":0}]".
