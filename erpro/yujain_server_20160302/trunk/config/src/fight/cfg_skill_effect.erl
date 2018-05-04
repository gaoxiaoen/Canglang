%% -*- coding: utf-8 -*-
%% Author: caochuncheng2002@gmail.com
%% Created: 2015-10-10
%% Description: 技能效果配置，不可以修改，必须由技能效果配置表生成

-module(cfg_skill_effect).
-include("common.hrl").
-export([
         find/1
        ]).


find(1000) -> %% 普通物理攻击
    [#r_skill_effect{effect_id=1000,type=1,a=100,b=0,c=0,d=0,e=0}];
find(1001) -> %% 普通魔法攻击
    [#r_skill_effect{effect_id=1001,type=2,a=100,b=0,c=0,d=0,e=0}];
find(1002) -> %% 眩晕
    [#r_skill_effect{effect_id=1002,type=6,a=1001,b=0,c=0,d=0,e=0}];
find(1003) -> %% 加血
    [#r_skill_effect{effect_id=1003,type=5,a=2000,b=0,c=0,d=0,e=0}];
find(1004) -> %% BOSS全屏攻击
    [#r_skill_effect{effect_id=1004,type=1,a=5000,b=0,c=0,d=0,e=0}];
find(1005) -> %% BOSS加血
    [#r_skill_effect{effect_id=1005,type=5,a=20000,b=0,c=0,d=0,e=0}];
find(1006) -> %% 冲刺伤害
    [#r_skill_effect{effect_id=1006,type=1,a=2000,b=0,c=0,d=0,e=0}];
find(1007) -> %% 战士大招
    [#r_skill_effect{effect_id=1007,type=1,a=1500,b=0,c=0,d=0,e=0}];
find(1008) -> %% 持续加血
    [#r_skill_effect{effect_id=1008,type=6,a=1004,b=0,c=0,d=0,e=0}];
find(1009) -> %% 伤害减免
    [#r_skill_effect{effect_id=1009,type=6,a=1002,b=0,c=0,d=0,e=0}];
find(1010) -> %% 无敌
    [#r_skill_effect{effect_id=1010,type=6,a=1003,b=0,c=0,d=0,e=0}];
find(1011) -> %% 虚空
    [#r_skill_effect{effect_id=1011,type=6,a=1005,b=0,c=0,d=0,e=0}];
find(1012) -> %% 怪物普通物理攻击
    [#r_skill_effect{effect_id=1012,type=1,a=10,b=0,c=0,d=0,e=0}];
find(1013) -> %% 怪物普通魔法攻击
    [#r_skill_effect{effect_id=1013,type=2,a=10,b=0,c=0,d=0,e=0}];
find(1014) -> %% 战士群攻伤害
    [#r_skill_effect{effect_id=1014,type=1,a=1000,b=0,c=0,d=0,e=0}];
find(1015) -> %% 医生羽毛群攻
    [#r_skill_effect{effect_id=1015,type=2,a=1000,b=0,c=0,d=0,e=0}];
find(1016) -> %% 战士普攻
    [#r_skill_effect{effect_id=1016,type=1,a=400,b=0,c=0,d=0,e=0}];
find(1017) -> %% 医生普攻
    [#r_skill_effect{effect_id=1017,type=2,a=400,b=0,c=0,d=0,e=0}];
find(1018) -> %% 宠物物理群攻
    [#r_skill_effect{effect_id=1018,type=1,a=850,b=0,c=0,d=0,e=0}];
find(1019) -> %% 宠物魔法群攻
    [#r_skill_effect{effect_id=1019,type=2,a=850,b=0,c=0,d=0,e=0}];
find(1020) -> %% BOSS召唤小怪
    [#r_skill_effect{effect_id=1020,type=7,a=10001001,b=2,c=0,d=0,e=0}];
find(1021) -> %% BOSS召唤伤害
    [#r_skill_effect{effect_id=1021,type=1,a=2000,b=0,c=0,d=0,e=0}];
find(_) -> 
    [].


