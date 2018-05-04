%% -*- coding: utf-8 -*-
%% Author: caochuncheng2002@gmail.com
%% Created: 2015-10-10
%% Description: 技能配置，不可以修改，必须由技能配置表生成

-module(cfg_skill).
-include("common.hrl").
-export([
         find/1,
         get_skill_list/1
        ]).


find(1000000) -> %% 角色基础物理攻击
    [#r_skill_info{skill_id = 1000000,type = 1,level = 1,min_level = 1,category = 0,contain_base_attack = 1,attack_mode = 0,distance = 300,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 5,chant_time = 0,delay_time=0,cd = 1000,common_cd = 800,calc_index = 1,target_type = 3,target_w = 0,target_h = 0,target_kind = 2,target_number = 1,self_effects = [],target_effects = [1000]}];
find(1000001) -> %% 角色基础魔法攻击
    [#r_skill_info{skill_id = 1000001,type = 1,level = 1,min_level = 1,category = 0,contain_base_attack = 1,attack_mode = 0,distance = 600,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 5,chant_time = 0,delay_time=0,cd = 1000,common_cd = 800,calc_index = 1,target_type = 3,target_w = 0,target_h = 0,target_kind = 2,target_number = 1,self_effects = [],target_effects = [1001]}];
find(1100000) -> %% 毛贼普攻
    [#r_skill_info{skill_id = 1100000,type = 1,level = 1,min_level = 1,category = 0,contain_base_attack = 1,attack_mode = 0,distance = 350,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 2000,common_cd = 2000,calc_index = 1,target_type = 3,target_w = 0,target_h = 0,target_kind = 2,target_number = 1,self_effects = [],target_effects = [1012]}];
find(1100001) -> %% 熔岩兽普攻
    [#r_skill_info{skill_id = 1100001,type = 1,level = 1,min_level = 1,category = 0,contain_base_attack = 1,attack_mode = 0,distance = 350,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 2000,common_cd = 2000,calc_index = 1,target_type = 3,target_w = 0,target_h = 0,target_kind = 2,target_number = 1,self_effects = [],target_effects = [1012]}];
find(2100001) -> %% 战士普攻1
    [#r_skill_info{skill_id = 2100001,type = 5,level = 1,min_level = 1,category = 1,contain_base_attack = 1,attack_mode = 0,distance = 200,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 700,common_cd = 700,calc_index = 1,target_type = 3,target_w = 0,target_h = 0,target_kind = 2,target_number = 1,self_effects = [],target_effects = [1016]}];
find(2100002) -> %% 战士普攻2
    [#r_skill_info{skill_id = 2100002,type = 5,level = 1,min_level = 1,category = 1,contain_base_attack = 1,attack_mode = 0,distance = 200,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 700,common_cd = 700,calc_index = 1,target_type = 3,target_w = 0,target_h = 0,target_kind = 2,target_number = 1,self_effects = [],target_effects = [1016]}];
find(2100003) -> %% 战士普攻3
    [#r_skill_info{skill_id = 2100003,type = 5,level = 1,min_level = 1,category = 1,contain_base_attack = 1,attack_mode = 0,distance = 200,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 900,common_cd = 900,calc_index = 1,target_type = 3,target_w = 0,target_h = 0,target_kind = 2,target_number = 1,self_effects = [],target_effects = [1016]}];
find(2100004) -> %% 绝刃连杀
    [#r_skill_info{skill_id = 2100004,type = 1,level = 1,min_level = 1,category = 1,contain_base_attack = 1,attack_mode = 0,distance = 500,move_type = 2,consume_anger = 5000,consume_mp = 0,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 10000,common_cd = 2100,calc_index = 1,target_type = 6,target_w = 500,target_h = 0,target_kind = 2,target_number = 6,self_effects = [1011],target_effects = [1007]}];
find(2100005) -> %% 疾影剑
    [#r_skill_info{skill_id = 2100005,type = 1,level = 1,min_level = 1,category = 1,contain_base_attack = 1,attack_mode = 0,distance = 800,move_type = 1,consume_anger = 0,consume_mp = 3,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 10000,common_cd = 300,calc_index = 1,target_type = 3,target_w = 0,target_h = 0,target_kind = 2,target_number = 1,self_effects = [],target_effects = [1002,1006]}];
find(2100006) -> %% 圆月斩
    [#r_skill_info{skill_id = 2100006,type = 1,level = 1,min_level = 1,category = 1,contain_base_attack = 1,attack_mode = 0,distance = 250,move_type = 0,consume_anger = 0,consume_mp = 3,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 5000,common_cd = 700,calc_index = 1,target_type = 2,target_w = 500,target_h = 0,target_kind = 2,target_number = 6,self_effects = [],target_effects = [1014]}];
find(2300001) -> %% 医生普攻1
    [#r_skill_info{skill_id = 2300001,type = 5,level = 1,min_level = 1,category = 4,contain_base_attack = 1,attack_mode = 0,distance = 700,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 900,common_cd = 900,calc_index = 1,target_type = 3,target_w = 0,target_h = 0,target_kind = 2,target_number = 1,self_effects = [],target_effects = [1017]}];
find(2300002) -> %% 医生普攻2
    [#r_skill_info{skill_id = 2300002,type = 5,level = 1,min_level = 1,category = 4,contain_base_attack = 1,attack_mode = 0,distance = 700,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 900,common_cd = 900,calc_index = 1,target_type = 3,target_w = 0,target_h = 0,target_kind = 2,target_number = 1,self_effects = [],target_effects = [1017]}];
find(2300003) -> %% 医生普攻3
    [#r_skill_info{skill_id = 2300003,type = 5,level = 1,min_level = 1,category = 4,contain_base_attack = 1,attack_mode = 0,distance = 700,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 900,common_cd = 900,calc_index = 1,target_type = 3,target_w = 0,target_h = 0,target_kind = 2,target_number = 1,self_effects = [],target_effects = [1017]}];
find(2300004) -> %% 光羽之佑
    [#r_skill_info{skill_id = 2300004,type = 1,level = 1,min_level = 1,category = 4,contain_base_attack = 1,attack_mode = 0,distance = 700,move_type = 0,consume_anger = 5000,consume_mp = 0,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 10000,common_cd = 650,calc_index = 1,target_type = 2,target_w = 700,target_h = 0,target_kind = 1,target_number = 10,self_effects = [],target_effects = [1009]}];
find(2300005) -> %% 流光
    [#r_skill_info{skill_id = 2300005,type = 1,level = 1,min_level = 1,category = 4,contain_base_attack = 1,attack_mode = 0,distance = 700,move_type = 0,consume_anger = 0,consume_mp = 3,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 5000,common_cd = 650,calc_index = 1,target_type = 7,target_w = 700,target_h = 0,target_kind = 1,target_number = 5,self_effects = [],target_effects = [1003]}];
find(2300006) -> %% 千羽
    [#r_skill_info{skill_id = 2300006,type = 1,level = 1,min_level = 1,category = 4,contain_base_attack = 1,attack_mode = 0,distance = 700,move_type = 0,consume_anger = 0,consume_mp = 3,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 5000,common_cd = 1100,calc_index = 1,target_type = 4,target_w = 400,target_h = 0,target_kind = 2,target_number = 5,self_effects = [],target_effects = [1015]}];
find(3000001) -> %% 奔雷咒
    [#r_skill_info{skill_id = 3000001,type = 2,level = 1,min_level = 1,category = 0,contain_base_attack = 0,attack_mode = 0,distance = 700,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 4000,common_cd = 2000,calc_index = 1,target_type = 4,target_w = 400,target_h = 0,target_kind = 2,target_number = 5,self_effects = [],target_effects = [1018]}];
find(3000002) -> %% 奔雷咒
    [#r_skill_info{skill_id = 3000002,type = 2,level = 1,min_level = 1,category = 0,contain_base_attack = 0,attack_mode = 0,distance = 700,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 4000,common_cd = 2000,calc_index = 1,target_type = 4,target_w = 400,target_h = 0,target_kind = 2,target_number = 5,self_effects = [],target_effects = [1019]}];
find(3100001) -> %% BOSS大招
    [#r_skill_info{skill_id = 3100001,type = 3,level = 1,min_level = 1,category = 0,contain_base_attack = 1,attack_mode = 0,distance = 300,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 4701,delay_time=633,cd = 1000,common_cd = 1500,calc_index = 1,target_type = 2,target_w = 700,target_h = 0,target_kind = 2,target_number = 10,self_effects = [],target_effects = [1004]}];
find(3100002) -> %% BOSS加血
    [#r_skill_info{skill_id = 3100002,type = 3,level = 1,min_level = 1,category = 0,contain_base_attack = 1,attack_mode = 0,distance = 300,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 4701,delay_time=0,cd = 1000,common_cd = 1300,calc_index = 1,target_type = 1,target_w = 0,target_h = 0,target_kind = 1,target_number = 1,self_effects = [],target_effects = [1005]}];
find(3100003) -> %% BOSS普攻
    [#r_skill_info{skill_id = 3100003,type = 3,level = 1,min_level = 1,category = 0,contain_base_attack = 1,attack_mode = 0,distance = 500,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 0,delay_time=0,cd = 2200,common_cd = 2200,calc_index = 1,target_type = 3,target_w = 0,target_h = 0,target_kind = 2,target_number = 1,self_effects = [],target_effects = [1012]}];
find(3100004) -> %% BOSS召唤
    [#r_skill_info{skill_id = 3100004,type = 3,level = 1,min_level = 1,category = 0,contain_base_attack = 1,attack_mode = 0,distance = 500,move_type = 0,consume_anger = 0,consume_mp = 0,consume_mp_index = 0,chant_time = 2000,delay_time=800,cd = 1000,common_cd = 1400,calc_index = 1,target_type = 9,target_w = 600,target_h = 300,target_kind = 2,target_number = 2,self_effects = [1020],target_effects = [1021]}];
find(_) -> 
    [].


get_skill_list(1) ->
    [2100001,2100002,2100003,2100004,2100005,2100006];
get_skill_list(4) ->
    [2300001,2300002,2300003,2300004,2300005,2300006];
get_skill_list(_) ->
    [].


