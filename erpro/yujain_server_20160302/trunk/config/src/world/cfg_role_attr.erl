%% Author: caochuncheng2002@gmail.com
%% Created: 2015-9-28
%% Description: 初始属性配置，不可以修改，必须由初始属性配置表生成

-module(cfg_role_attr).

-include("common.hrl").

-export([
         init_attr/1,
         base_to_fight/1
        ]).


init_attr(1) ->
    #p_fight_attr{max_hp=20000,max_mp=10,max_anger=10000,phy_attack=100,phy_defence=60,magic_attack=100,magic_defence=60,hit=0,miss=0,double_attack=150,tough=0,seal=0,anti_seal=0,cure_effect=0,attack_skill=0,phy_defence_skill=0,magic_defence_skill=0,seal_skill=0};
init_attr(2) ->
    #p_fight_attr{max_hp=20000,max_mp=10,max_anger=10000,phy_attack=100,phy_defence=60,magic_attack=100,magic_defence=60,hit=0,miss=0,double_attack=150,tough=0,seal=0,anti_seal=0,cure_effect=0,attack_skill=0,phy_defence_skill=0,magic_defence_skill=0,seal_skill=0};
init_attr(3) ->
    #p_fight_attr{max_hp=20000,max_mp=10,max_anger=10000,phy_attack=100,phy_defence=60,magic_attack=100,magic_defence=60,hit=0,miss=0,double_attack=150,tough=0,seal=0,anti_seal=0,cure_effect=0,attack_skill=0,phy_defence_skill=0,magic_defence_skill=0,seal_skill=0};
init_attr(4) ->
    #p_fight_attr{max_hp=20000,max_mp=10,max_anger=10000,phy_attack=100,phy_defence=60,magic_attack=100,magic_defence=60,hit=0,miss=0,double_attack=150,tough=0,seal=0,anti_seal=0,cure_effect=0,attack_skill=0,phy_defence_skill=0,magic_defence_skill=0,seal_skill=0};
init_attr(5) ->
    #p_fight_attr{max_hp=20000,max_mp=10,max_anger=10000,phy_attack=100,phy_defence=60,magic_attack=100,magic_defence=60,hit=0,miss=0,double_attack=150,tough=0,seal=0,anti_seal=0,cure_effect=0,attack_skill=0,phy_defence_skill=0,magic_defence_skill=0,seal_skill=0};
init_attr(6) ->
    #p_fight_attr{max_hp=20000,max_mp=10,max_anger=10000,phy_attack=100,phy_defence=60,magic_attack=100,magic_defence=60,hit=0,miss=0,double_attack=150,tough=0,seal=0,anti_seal=0,cure_effect=0,attack_skill=0,phy_defence_skill=0,magic_defence_skill=0,seal_skill=0};
init_attr(_) -> 
    #p_fight_attr{}.


%% 获取基础属性转换战斗属性配置信息
%% key={职业，基础属性}
%% 基础属性:
%%         1:力量
%%         2:魔力
%%         3:体质
%%         4:念力
%%         5:敏捷
base_to_fight({1,1}) ->
    #p_fight_attr{phy_attack=1};
base_to_fight({2,1}) ->
    #p_fight_attr{phy_attack=1};
base_to_fight({3,1}) ->
    #p_fight_attr{phy_attack=1};
base_to_fight({4,1}) ->
    #p_fight_attr{phy_attack=1};
base_to_fight({5,1}) ->
    #p_fight_attr{phy_attack=1};
base_to_fight({6,1}) ->
    #p_fight_attr{phy_attack=1};
base_to_fight({1,2}) ->
    #p_fight_attr{magic_attack=1};
base_to_fight({2,2}) ->
    #p_fight_attr{magic_attack=1};
base_to_fight({3,2}) ->
    #p_fight_attr{magic_attack=1};
base_to_fight({4,2}) ->
    #p_fight_attr{magic_attack=1};
base_to_fight({5,2}) ->
    #p_fight_attr{magic_attack=1};
base_to_fight({6,2}) ->
    #p_fight_attr{magic_attack=1};
base_to_fight({1,3}) ->
    #p_fight_attr{phy_defence=0.5};
base_to_fight({2,3}) ->
    #p_fight_attr{phy_defence=0.5};
base_to_fight({3,3}) ->
    #p_fight_attr{phy_defence=0.5};
base_to_fight({4,3}) ->
    #p_fight_attr{phy_defence=0.5};
base_to_fight({5,3}) ->
    #p_fight_attr{phy_defence=0.5};
base_to_fight({6,3}) ->
    #p_fight_attr{phy_defence=0.5};
base_to_fight({1,4}) ->
    #p_fight_attr{magic_defence=0.5,tough=0.7};
base_to_fight({2,4}) ->
    #p_fight_attr{magic_defence=0.5,tough=0.7};
base_to_fight({3,4}) ->
    #p_fight_attr{magic_defence=0.5,tough=0.7};
base_to_fight({4,4}) ->
    #p_fight_attr{magic_defence=0.5,tough=0.7};
base_to_fight({5,4}) ->
    #p_fight_attr{magic_defence=0.5,tough=0.7};
base_to_fight({6,4}) ->
    #p_fight_attr{magic_defence=0.5,tough=0.7};
base_to_fight({1,5}) ->
    #p_fight_attr{hit=1};
base_to_fight({2,5}) ->
    #p_fight_attr{hit=1};
base_to_fight({3,5}) ->
    #p_fight_attr{hit=1};
base_to_fight({4,5}) ->
    #p_fight_attr{hit=1};
base_to_fight({5,5}) ->
    #p_fight_attr{hit=1};
base_to_fight({6,5}) ->
    #p_fight_attr{hit=1};
base_to_fight(_) -> 
    #p_fight_attr{}.


