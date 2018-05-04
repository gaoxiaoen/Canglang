%% -*- coding: latin-1 -*-
%% Author: caochuncheng2002@gmail.com
%% Created: 2015-10-09
%% Description:宠物配置，不可以修改，必须由宠物配置表生成

-module(cfg_pet).

-include("common.hrl").

-export([
         find/1
        ]).


find(100000) ->
    #r_pet_info{type_id=100000,name = <<"金绒狮王">>,attack_type=1,carry_level=10,sex=1,life=100,inborn=[{100,50},{120,30},{150,20}],hp_aptitude=[{3000000,5000000}],mp_aptitude=[{2000,3000}],phy_attack_aptitude=[{1000,1500}],magic_attack_aptitude=[{2000,3000}],phy_defence_aptitude=[{1,2}],magic_defence_aptitude=[{1,2}],miss_aptitude=[{100,300}],base_attr_dot=100,skills=[{3000001,1,10000}],display_type=0};
find(100001) ->
    #r_pet_info{type_id=100001,name = <<"朵朵">>,attack_type=2,carry_level=10,sex=2,life=100,inborn=[{100,50},{120,30},{150,20},{160,5}],hp_aptitude=[{3000000,5000000}],mp_aptitude=[{2000,3000}],phy_attack_aptitude=[{1000,1500}],magic_attack_aptitude=[{2000,3000}],phy_defence_aptitude=[{1,2}],magic_defence_aptitude=[{1,2}],miss_aptitude=[{100,300}],base_attr_dot=100,skills=[{3000002,1,10000}],display_type=0};
find(_) -> 
    undefined.


