%%----------------------------------------------------
%% 打孔、镶嵌、摘除数据相关 
%% @author shawnoyc@163.com
%%----------------------------------------------------
-module(embed_data).
-export([
        get_symbol_id/0
       ,get_embed_coin/1
       ,get/1
       ,type_to_stone/1
       ,special_to_stone/1
       ,stone_to_lev/1
       ,get_pre_stone/1
       ,get_embed_lev/1
    ]
).

-include("item.hrl").
-include("blacksmith.hrl").

get_symbol_id() -> 22010.

get_embed_coin(1) -> 10000;
get_embed_coin(2) -> 30000;
get_embed_coin(3) -> 50000.

get(xqf) -> 22020;
get(zcf) -> 22030.

%% 类型 0:气血 1:法力 2:攻击 3:防御 4:暴击 
%%      5:命中 6:躲闪 7:坚韧 8:敏捷
%% 普通类型
%% 武器：攻击、暴击、命中
%% 防具：气血、法力、防御、躲闪
%% 护符：命中、坚韧、敏捷
%% 戒指：攻击、暴击、命中、敏捷
type_to_stone(Type) ->
    WeaponType = lists:member(Type, ?eqm),
    ArmorType = lists:member(Type, ?armor),
    if
        WeaponType -> [2, 4, 5];
        ArmorType -> [0, 1, 3, 6];
        Type =:= ?item_jie_zhi -> [2, 4, 5, 8];
        Type =:= ?item_hu_fu -> [5, 7, 8];
        Type =:= ?item_wing -> [9, 10, 11, 12, 13, 14];
        Type =:= ?item_shi_zhuang -> [9, 10, 11, 12, 13, 14];
        Type =:= ?item_weapon_dress -> [9, 10, 11, 12, 13, 14];
        Type =:= ?item_jewelry_dress -> [9, 10, 11, 12, 13, 14];
        Type =:= ?item_zuo_qi -> [9, 10, 11, 12, 13, 14];
        true -> []
    end.

%% 特殊类型
%% 武器：攻击、命中、暴击
%% 防具：防御、气血、坚韧
%% 护符：坚韧、命中
%% 戒指：攻击、命中、暴击
special_to_stone(Type) ->
    WeaponType = lists:member(Type, ?eqm),
    ArmorType = lists:member(Type, ?armor),
    if
        WeaponType -> [2, 4, 5];
        ArmorType -> [0, 3, 7];
        Type =:= ?item_jie_zhi -> [2, 4, 5];
        Type =:= ?item_hu_fu -> [5, 7];
        Type =:= ?item_wing -> [10, 11, 12, 13, 14];
        Type =:= ?item_shi_zhuang -> [10, 11, 12, 13, 14];
        Type =:= ?item_weapon_dress -> [9, 10, 11, 12, 13, 14];
        Type =:= ?item_jewelry_dress -> [9, 10, 11, 12, 13, 14];
        Type =:= ?item_zuo_qi -> [9, 10, 11, 12, 13, 14, 15];
        true -> []
    end.

%% 计算宝石等级
stone_to_lev(BaseId) when BaseId >= 26000 andalso BaseId =< 26015 -> 1;
stone_to_lev(BaseId) when BaseId >= 26020 andalso BaseId =< 26035 -> 2;
stone_to_lev(BaseId) when BaseId >= 26040 andalso BaseId =< 26055 -> 3;
stone_to_lev(BaseId) when BaseId >= 26060 andalso BaseId =< 26075 -> 4;
stone_to_lev(BaseId) when BaseId >= 26080 andalso BaseId =< 26095 -> 5;
stone_to_lev(BaseId) when BaseId >= 26100 andalso BaseId =< 26115 -> 6;
stone_to_lev(BaseId) when BaseId >= 26120 andalso BaseId =< 26135 -> 7;
stone_to_lev(BaseId) when BaseId >= 26140 andalso BaseId =< 26155 -> 8;
stone_to_lev(BaseId) when BaseId >= 26160 andalso BaseId =< 26175 -> 9;

stone_to_lev(BaseId) when BaseId >= 26500 andalso BaseId =< 26515 -> 1;
stone_to_lev(BaseId) when BaseId >= 26520 andalso BaseId =< 26535 -> 2;
stone_to_lev(BaseId) when BaseId >= 26540 andalso BaseId =< 26555 -> 3;
stone_to_lev(BaseId) when BaseId >= 26560 andalso BaseId =< 26575 -> 4;
stone_to_lev(BaseId) when BaseId >= 26580 andalso BaseId =< 26595 -> 5;
stone_to_lev(BaseId) when BaseId >= 26600 andalso BaseId =< 26615 -> 6;
stone_to_lev(BaseId) when BaseId >= 26620 andalso BaseId =< 26635 -> 7;
stone_to_lev(BaseId) when BaseId >= 26640 andalso BaseId =< 26655 -> 8;
stone_to_lev(BaseId) when BaseId >= 26660 andalso BaseId =< 26675 -> 9;

stone_to_lev(_BaseId) -> 0.

%% 根据宝石BASEID返回前一等级的宝石BASEID
get_pre_stone(BaseId) ->
    Flag = lists:member(BaseId, [26560, 26561, 26562, 26563, 26564, 26565, 26566, 26567, 26568, 26569, 26570, 26571, 26572, 26573, 26574, 26575]),
    case stone_to_lev(BaseId) =:= 1 of
        true -> 0;
        false ->
            case Flag of
                true -> BaseId - 500;
                false -> BaseId - 20
            end
    end.

get_embed_lev(4) ->
    [{?attr_dmg,30},
        {?attr_defence,80},
        {?attr_hp_max,200},
        {?attr_mp_max,100}];
get_embed_lev(5) ->
    [{?attr_dmg,60},
        {?attr_defence,150},
        {?attr_hp_max,400},
        {?attr_mp_max,200},
        {?attr_hitrate,5},
        {?attr_evasion,5},
        {?attr_critrate,5},
        {?attr_tenacity,5}];
get_embed_lev(6) ->
    [{?attr_dmg,100},
        {?attr_defence,200},
        {?attr_hp_max,600},
        {?attr_mp_max,300},
        {?attr_hitrate,10},
        {?attr_evasion,10},
        {?attr_critrate,10},
        {?attr_tenacity,10},
        {?attr_aspd,2}];
get_embed_lev(7) ->
    [{?attr_dmg,150},
        {?attr_defence,250},
        {?attr_hp_max,800},
        {?attr_mp_max,400},
        {?attr_hitrate,15},
        {?attr_evasion,15},
        {?attr_critrate,15},
        {?attr_tenacity,15},
        {?attr_aspd,4},
        {?attr_dmg_magic,100},
        {?attr_anti_stun,20},
        {?attr_anti_silent,20},
        {?attr_anti_sleep,20},
        {?attr_anti_stone,20},
        {?attr_anti_taunt,20}];
get_embed_lev(8) ->
    [{?attr_dmg,200},
        {?attr_defence,350},
        {?attr_hp_max,1000},
        {?attr_mp_max,500},
        {?attr_hitrate,20},
        {?attr_evasion,20},
        {?attr_critrate,20},
        {?attr_tenacity,20},
        {?attr_aspd,6},
        {?attr_dmg_magic,150},
        {?attr_anti_stun,40},
        {?attr_anti_silent,40},
        {?attr_anti_sleep,40},
        {?attr_anti_stone,40},
        {?attr_anti_taunt,40}];
get_embed_lev(9) ->
    [{?attr_dmg,300},
        {?attr_defence,500},
        {?attr_hp_max,1500},
        {?attr_mp_max,600},
        {?attr_hitrate,25},
        {?attr_evasion,25},
        {?attr_critrate,25},
        {?attr_tenacity,25},
        {?attr_aspd,8},
        {?attr_dmg_magic,300},
        {?attr_anti_stun,70},
        {?attr_anti_silent,70},
        {?attr_anti_sleep,70},
        {?attr_anti_stone,70},
        {?attr_anti_taunt,70}];
get_embed_lev(_) -> [].
