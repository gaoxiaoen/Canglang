%% -*- coding: utf-8 -*-
%% Author: caochuncheng2002@gmail.com
%% Created: 2015-10-10
%% Description: Buff配置，不可以修改，必须由Buff配置表生成

-module(cfg_buff).
-include("common.hrl").
-export([
         find/1
        ]).


find(1000) -> %% 增加角色力量
    [#r_buff_info{buff_id = 1000,type = 1,kind = 0,group_id = 0,level = 1,overlap = 0,remove = 0,toc = 1,is_debuff = 0,target_type = 0,keep_type = 1,keep_value = 0,keep_interval = 0,duration = 300000,value_type = 0,a = [{1,25}],b = 0,c = 0}];
find(1001) -> %% 眩晕
    [#r_buff_info{buff_id = 1001,type = 3,kind = 1,group_id = 1001,level = 1,overlap = 0,remove = 0,toc = 1,is_debuff = 0,target_type = 0,keep_type = 1,keep_value = 0,keep_interval = 0,duration = 5000,value_type = 0,a = 0,b = 0,c = 0}];
find(1002) -> %% 减免伤害
    [#r_buff_info{buff_id = 1002,type = 4,kind = 1,group_id = 1002,level = 1,overlap = 0,remove = 0,toc = 1,is_debuff = 0,target_type = 0,keep_type = 1,keep_value = 0,keep_interval = 0,duration = 10000,value_type = 0,a = 50,b = 5,c = 0}];
find(1003) -> %% 无敌
    [#r_buff_info{buff_id = 1003,type = 5,kind = 1,group_id = 1003,level = 1,overlap = 0,remove = 0,toc = 1,is_debuff = 0,target_type = 0,keep_type = 1,keep_value = 0,keep_interval = 0,duration = 15000,value_type = 0,a = 0,b = 0,c = 0}];
find(1004) -> %% 持续加血
    [#r_buff_info{buff_id = 1004,type = 2,kind = 1,group_id = 1004,level = 1,overlap = 0,remove = 0,toc = 1,is_debuff = 0,target_type = 0,keep_type = 1,keep_value = 500,keep_interval = 3,duration = 15000,value_type = 0,a = 4,b = 0,c = 0}];
find(1005) -> %% 战士大招期间虚空
    [#r_buff_info{buff_id = 1005,type = 6,kind = 1,group_id = 1005,level = 1,overlap = 0,remove = 0,toc = 1,is_debuff = 0,target_type = 0,keep_type = 1,keep_value = 0,keep_interval = 0,duration = 2300,value_type = 0,a = 0,b = 0,c = 0}];
find(_) -> 
    [].


