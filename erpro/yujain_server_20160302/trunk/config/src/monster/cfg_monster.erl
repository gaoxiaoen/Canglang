%% -*- coding: latin-1 -*-
%% Author: caochuncheng2002@gmail.com
%% Created: 2015-10-09
%% Description: 怪物配置，不可以修改，必须由怪物配置表生成

-module(cfg_monster).

-include("common.hrl").

-export([
         find/1,
         find/2,
         gen_type_id/2
        ]).


gen_type_id(TypeCode,MonsterLevel) -> 
    TypeCode * 1000 + MonsterLevel.

find(TypeCode,MonsterLevel) -> 
    cfg_monster:find(gen_type_id(TypeCode,MonsterLevel)).

find(10000001) ->
    #r_monster_info{type_id=10000001,type_code=10000,level=1,name = <<"盗宝贼">>,type=1,body_radius=100,attack_mode=1,
                    exp=100,silver=0,coin=100,ai_id=0,ai_attack_type=2,ai_move_type=0,
                    guard_radius=800,trace_radius=1100,max_drop_times=0,base_skill={1100000,1},
                    attr = #p_fight_attr{max_hp=12000,hp=12000,max_mp=1000,mp=1000,max_anger=15000,anger=15000,
                                        phy_attack=100,magic_attack=100,phy_defence=10,magic_defence=10,
                                        hit=10000,miss=0,double_attack=100,tough=0,
                                        seal=0,anti_seal=0,cure_effect=1000,move_speed=300},
                    drops=[]};
find(10001001) ->
    #r_monster_info{type_id=10001001,type_code=10001,level=1,name = <<"熔岩兽">>,type=1,body_radius=100,attack_mode=1,
                    exp=100,silver=0,coin=100,ai_id=0,ai_attack_type=2,ai_move_type=0,
                    guard_radius=800,trace_radius=1100,max_drop_times=0,base_skill={1100001,1},
                    attr = #p_fight_attr{max_hp=12000,hp=12000,max_mp=1000,mp=1000,max_anger=15000,anger=15000,
                                        phy_attack=100,magic_attack=100,phy_defence=10,magic_defence=10,
                                        hit=10000,miss=0,double_attack=100,tough=0,
                                        seal=0,anti_seal=0,cure_effect=1000,move_speed=300},
                    drops=[]};
find(10002001) ->
    #r_monster_info{type_id=10002001,type_code=10002,level=1,name = <<"火焰教主">>,type=3,body_radius=300,attack_mode=1,
                    exp=2000,silver=0,coin=100,ai_id=1001,ai_attack_type=2,ai_move_type=0,
                    guard_radius=900,trace_radius=1200,max_drop_times=0,base_skill={3100003,1},
                    attr = #p_fight_attr{max_hp=100000,hp=100000,max_mp=1000,mp=1000,max_anger=15000,anger=15000,
                                        phy_attack=250,magic_attack=250,phy_defence=20,magic_defence=20,
                                        hit=10000,miss=0,double_attack=100,tough=0,
                                        seal=0,anti_seal=0,cure_effect=1000,move_speed=300},
                    drops=[]};
find(10010001) ->
    #r_monster_info{type_id=10010001,type_code=10010,level=1,name = <<"盗宝贼">>,type=1,body_radius=100,attack_mode=1,
                    exp=100,silver=0,coin=100,ai_id=0,ai_attack_type=2,ai_move_type=0,
                    guard_radius=800,trace_radius=1100,max_drop_times=0,base_skill={1100000,1},
                    attr = #p_fight_attr{max_hp=20000,hp=20000,max_mp=1000,mp=1000,max_anger=15000,anger=15000,
                                        phy_attack=350,magic_attack=350,phy_defence=10,magic_defence=10,
                                        hit=10000,miss=0,double_attack=100,tough=0,
                                        seal=0,anti_seal=0,cure_effect=1000,move_speed=300},
                    drops=[]};
find(10011001) ->
    #r_monster_info{type_id=10011001,type_code=10011,level=1,name = <<"熔岩兽">>,type=1,body_radius=100,attack_mode=1,
                    exp=100,silver=0,coin=100,ai_id=0,ai_attack_type=2,ai_move_type=0,
                    guard_radius=800,trace_radius=1100,max_drop_times=0,base_skill={1100001,1},
                    attr = #p_fight_attr{max_hp=20000,hp=20000,max_mp=1000,mp=1000,max_anger=15000,anger=15000,
                                        phy_attack=350,magic_attack=350,phy_defence=10,magic_defence=10,
                                        hit=10000,miss=0,double_attack=100,tough=0,
                                        seal=0,anti_seal=0,cure_effect=1000,move_speed=300},
                    drops=[]};
find(10012001) ->
    #r_monster_info{type_id=10012001,type_code=10012,level=1,name = <<"火焰教主">>,type=3,body_radius=300,attack_mode=1,
                    exp=2000,silver=0,coin=100,ai_id=1001,ai_attack_type=2,ai_move_type=0,
                    guard_radius=900,trace_radius=1200,max_drop_times=0,base_skill={3100003,1},
                    attr = #p_fight_attr{max_hp=200000,hp=200000,max_mp=1000,mp=1000,max_anger=15000,anger=15000,
                                        phy_attack=1250,magic_attack=1250,phy_defence=20,magic_defence=20,
                                        hit=10000,miss=0,double_attack=100,tough=0,
                                        seal=0,anti_seal=0,cure_effect=1000,move_speed=300},
                    drops=[]};
find(20001001) ->
    #r_monster_info{type_id=20001001,type_code=20001,level=1,name = <<"测试召唤">>,type=3,body_radius=300,attack_mode=1,
                    exp=2000,silver=0,coin=100,ai_id=1002,ai_attack_type=2,ai_move_type=0,
                    guard_radius=900,trace_radius=1200,max_drop_times=0,base_skill={3100003,1},
                    attr = #p_fight_attr{max_hp=100000,hp=100000,max_mp=1000,mp=1000,max_anger=15000,anger=15000,
                                        phy_attack=1250,magic_attack=1250,phy_defence=20,magic_defence=20,
                                        hit=10000,miss=0,double_attack=100,tough=0,
                                        seal=0,anti_seal=0,cure_effect=1000,move_speed=300},
                    drops=[]};
find(99999200) ->
    #r_monster_info{type_id=99999200,type_code=99999,level=200,name = <<"秒杀你">>,type=3,body_radius=300,attack_mode=1,
                    exp=1,silver=0,coin=0,ai_id=0,ai_attack_type=2,ai_move_type=0,
                    guard_radius=800,trace_radius=1100,max_drop_times=0,base_skill={1100001,1},
                    attr = #p_fight_attr{max_hp=9999999,hp=9999999,max_mp=1000,mp=1000,max_anger=15000,anger=15000,
                                        phy_attack=9999999,magic_attack=9999999,phy_defence=9999999,magic_defence=9999999,
                                        hit=10000,miss=0,double_attack=100,tough=0,
                                        seal=0,anti_seal=0,cure_effect=1000,move_speed=300},
                    drops=[]};
find(_) -> 
    undefined.


