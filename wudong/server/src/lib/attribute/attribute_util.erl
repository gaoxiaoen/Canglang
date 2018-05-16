%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 三月 2017 10:01
%%%-------------------------------------------------------------------
-module(attribute_util).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
%% API
%%-compile(export_all).
-export([
    attr_tans_client/1,             %%属性id对照
    make_attribute_to_key_val/1,        %%#attribute{}->[{key,val}]
    make_attribute_by_key_val_list/1,       %%[{key,val}]->#attribute{}
    pack_attr/1,                        %%打包属性到客户端
    get_attr_by_attrkey/2,
    calc_combat_power/1,
    sum_attribute_list/1,
    sub_attribute/2,                %%属性累加
    sum_attribute/1                 %%属性相减
]).

%%属性id对照
attr_tans_client(Key) ->
    case Key of
%%        forza -> 1;  %% 力量
%%        thew -> 2;  %% 体质
        hp_lim -> 1;  %% 血量
        mp_lim -> 2;  %% 魔法
        att -> 3;  %% 攻击
        def -> 4;  %% 防御
        dodge -> 5; %% 闪躲
        crit -> 6; %% 暴击
        hit -> 7; %% 命中
        ten -> 8; %% 坚韧
        crit_inc -> 9; %% 暴击伤害
        crit_dec -> 10; %% 暴击减免
        hurt_inc -> 11; %% 伤害加成
        hurt_dec -> 12; %% 伤害减免
        hurt_fix -> 13; %% 固定伤害
        crit_ratio -> 14; %% 人物暴击率
        hit_ratio -> 15; %% 人物命中率
        hp_lim_inc -> 16; %% 气血增加百分比
        recover_hit -> 17; %% 击中回血
        size -> 18; %% 体型
        cure -> 19; %% 治疗效果-
        base_speed -> 20; %% 基础速度
        speed -> 21; %% 移动速度
        att_speed -> 22; %% 攻击速度
        att_area -> 23; %% 攻击范围
        prepare -> 24; %% 施法前摇
        pet_att -> 25; %% 宠物攻击
        pvp_inc -> 26;%%PVP增伤
        pvp_dec -> 27;%%PVP免伤

        fire_att -> 28; %% 火系元素攻击
        fire_def -> 29; %% 火系元素防御
        wood_att -> 30; %% 木系元素攻击
        wood_def -> 31; %% 木系元素防御
        wind_att -> 32; %% 风系元素攻击
        wind_def -> 33; %% 风系元素防御
        water_att -> 34; %% 水系元素攻击
        water_def -> 35; %% 水系元素防御
        light_att -> 36; %% 光系元素攻击
        light_def -> 37; %% 光系元素防御
        dark_att -> 38; %% 暗系元素攻击
        dark_def -> 39; %% 暗系元素防御
        fire_hurt_inc -> 40; %%火系元素伤害加成
        fire_hurt_dec -> 41; %%火系元素伤害减免
        wood_hurt_inc -> 42; %%木系元素伤害加成
        wood_hurt_dec -> 43; %%木系元素伤害减免
        wind_hurt_inc -> 44; %%风系元素伤害加成
        wind_hurt_dec -> 45; %%风系元素伤害减免
        water_hurt_inc -> 46; %%水系元素伤害加成
        water_hurt_dec -> 47; %%水系元素伤害减免
        light_hurt_inc -> 48; %%光系元素伤害加成
        light_hurt_dec -> 49; %%光系元素伤害减免
        dark_hurt_inc -> 50; %%暗系元素伤害加成
        dark_hurt_dec -> 51; %%暗系元素伤害减免
        _ -> 0
    end.


%%根据属性计算战斗力
calc_combat_power(Attribute) ->
    util:floor(
        Attribute#attribute.att * attr_factor(att) +
            Attribute#attribute.def * attr_factor(def) +
            Attribute#attribute.hp_lim * attr_factor(hp_lim) +
            Attribute#attribute.hit * attr_factor(hit) +
            Attribute#attribute.dodge * attr_factor(dodge) +
            Attribute#attribute.ten * attr_factor(ten) +
            Attribute#attribute.crit * attr_factor(crit) +
            Attribute#attribute.hurt_inc * attr_factor(hurt_inc) +
            Attribute#attribute.hurt_dec * attr_factor(hurt_dec) +
            Attribute#attribute.crit_inc * attr_factor(crit_inc) +
            Attribute#attribute.crit_dec * attr_factor(crit_dec) +
            Attribute#attribute.pvp_inc * attr_factor(pvp_inc) +
            Attribute#attribute.pvp_dec * attr_factor(pvp_dec) +
            Attribute#attribute.fire_att * attr_factor(fire_att) +  %% 火系元素攻击
        Attribute#attribute.fire_def * attr_factor(fire_def) +  %% 火系元素防御
        Attribute#attribute.wood_att * attr_factor(wood_att) +  %% 木系元素攻击
        Attribute#attribute.wood_def * attr_factor(wood_def) +  %% 木系元素防御
        Attribute#attribute.wind_att * attr_factor(wind_att) +  %% 风系元素攻击
        Attribute#attribute.wind_def * attr_factor(wind_def) +  %% 风系元素防御
        Attribute#attribute.water_att * attr_factor(water_att) +  %% 水系元素攻击
        Attribute#attribute.water_def * attr_factor(water_def) +  %% 水系元素防御
        Attribute#attribute.light_att * attr_factor(light_att) +  %% 光系元素攻击
        Attribute#attribute.light_def * attr_factor(light_def) +  %% 光系元素防御
        Attribute#attribute.dark_att * attr_factor(dark_att) +  %% 暗系元素攻击
        Attribute#attribute.dark_def * attr_factor(dark_def) +  %% 暗系元素防御

        Attribute#attribute.fire_hurt_inc * attr_factor(fire_hurt_inc) +  %%火系元素伤害加成
        Attribute#attribute.fire_hurt_dec * attr_factor(fire_hurt_dec) +  %%火系元素伤害减免
        Attribute#attribute.wood_hurt_inc * attr_factor(wood_hurt_inc) +  %%木系元素伤害加成
        Attribute#attribute.wood_hurt_dec * attr_factor(wood_hurt_dec) +  %%木系元素伤害减免
        Attribute#attribute.wind_hurt_inc * attr_factor(wind_hurt_inc) +  %%风系元素伤害加成
        Attribute#attribute.wind_hurt_dec * attr_factor(wind_hurt_dec) +  %%风系元素伤害减免
        Attribute#attribute.water_hurt_inc * attr_factor(water_hurt_inc) +  %%水系元素伤害加成
        Attribute#attribute.water_hurt_dec * attr_factor(water_hurt_dec) +  %%水系元素伤害减免
        Attribute#attribute.light_hurt_inc * attr_factor(light_hurt_inc) +  %%光系元素伤害加成
        Attribute#attribute.light_hurt_dec * attr_factor(light_hurt_dec) +  %%光系元素伤害减免
        Attribute#attribute.dark_hurt_inc * attr_factor(dark_hurt_inc) +  %%暗系元素伤害加成
        Attribute#attribute.dark_hurt_dec * attr_factor(dark_hurt_dec) %%暗系元素伤害减免
    ).

attr_factor(Type) ->
    case Type of
        att -> 5;
        def -> 5;
        hp_lim -> 0.5;
        hit -> 15;
        dodge -> 15;
        ten -> 15;
        crit -> 15;
        hurt_inc -> 360;
        hurt_dec -> 360;
        crit_inc -> 60;
        crit_dec -> 60;
        pvp_inc -> 360;
        pvp_dec -> 360;

        fire_att -> 10; %% 火系元素攻击
        fire_def -> 10; %% 火系元素防御
        wood_att -> 10; %% 木系元素攻击
        wood_def -> 10; %% 木系元素防御
        wind_att -> 10; %% 风系元素攻击
        wind_def -> 10; %% 风系元素防御
        water_att -> 10; %% 水系元素攻击
        water_def -> 10; %% 水系元素防御
        light_att -> 20; %% 光系元素攻击
        light_def -> 20; %% 光系元素防御
        dark_att -> 20; %% 暗系元素攻击
        dark_def -> 20; %% 暗系元素防御

        fire_hurt_inc -> 10; %%火系元素伤害加成
        fire_hurt_dec -> 10; %%火系元素伤害减免
        wood_hurt_inc -> 10; %%木系元素伤害加成
        wood_hurt_dec -> 10; %%木系元素伤害减免
        wind_hurt_inc -> 10; %%风系元素伤害加成
        wind_hurt_dec -> 10; %%风系元素伤害减免
        water_hurt_inc -> 10; %%水系元素伤害加成
        water_hurt_dec -> 10; %%水系元素伤害减免
        light_hurt_inc -> 10; %%光系元素伤害加成
        light_hurt_dec -> 10; %%光系元素伤害减免
        dark_hurt_inc -> 10; %%暗系元素伤害加成
        dark_hurt_dec -> 0; %%暗系元素伤害减免

        _ -> 0
    end.
%%-------------属性工具函数--------------

%%根据key val构造#attribute{}
%%如：[{att,Val}] => #attribute{att=Val}
make_attribute_by_key_val_list(KeyValList) ->
    FieldList = record_info(fields, attribute),
    [RecordName | ValList] = tuple_to_list(#attribute{}),
    NewValList = make_attribute_helper(KeyValList, FieldList, ValList),
    list_to_tuple([RecordName | NewValList]).

make_attribute_helper([], _FieldList, ValList) ->
    ValList;
make_attribute_helper([{Key, Val} | Tail], FieldList, ValList) ->
    case util:get_list_elem_index(Key, FieldList) of
        0 ->
            ?ERR("unknow attr field name ~p~n", [Key]),
            make_attribute_helper(Tail, FieldList, ValList);
        Index ->
            OldVal = lists:nth(Index, ValList),
            NewValList = util:replace_list_elem(Index, Val + OldVal, ValList),
            make_attribute_helper(Tail, FieldList, NewValList)
    end.

%%获取#attribute{} 里面的属性值，返回key val列表，过滤掉Val为0的属性
%%如 #attribute{att=0,def=2} => [{def,2}]
make_attribute_to_key_val(Attr) ->
    FieldList = record_info(fields, attribute),
    [_RecordName | ValList] = tuple_to_list(Attr),
    make_attribute_to_key_val_helper(FieldList, ValList, []).

make_attribute_to_key_val_helper([], [], AccKeyValList) ->
    AccKeyValList;
make_attribute_to_key_val_helper([FieldName | FTail], [Val | VTail], AccKeyValList) ->
    case Val > 0 of
        true ->
            make_attribute_to_key_val_helper(FTail, VTail, [{FieldName, Val} | AccKeyValList]);
        false ->
            make_attribute_to_key_val_helper(FTail, VTail, AccKeyValList)
    end.

%%根据attrkey获取#attribute{}结构的属性值
%%返回：{AttrKey,AttrVal}
get_attr_by_attrkey(AttrKey, Attr) ->
    AttrList = make_attribute_to_key_val(Attr),
    case lists:keyfind(AttrKey, 1, AttrList) of
        false -> 0;
        {_, Val} -> Val
    end.

%%打包属性到客户端
pack_attr(Attr) when is_record(Attr, attribute) ->
    AttrList = make_attribute_to_key_val(Attr),
    pack_attr(AttrList);
pack_attr(AttrList) ->
    [[attr_tans_client(Key), Val] || {Key, Val} <- AttrList].


%% 统计属性记录列表累计属性值
sum_attribute_list(AttributeList) ->
    L = [Attribute || {_, Attribute} <- AttributeList],
    sum_attribute(L).

%% 返回值 #attribute{}
sum_attribute(Attributelist) ->
    [attribute | ValueList] = tuple_to_list(#attribute{}),
    sum_attribute(Attributelist, ValueList).

sum_attribute([], []) ->
    #attribute{};
sum_attribute([], AttList) ->
    list_to_tuple([attribute | AttList]);
sum_attribute([L | T], AttList) ->
    LList = tuple_to_list(L),
    [_name | ValueList] = LList,
    sum_attribute(T, plus_attribute(AttList, ValueList)).


plus_attribute([L1 | T1], [L2 | T2]) ->
    case L2 > 0 of
        true -> [L1 + L2 | plus_attribute(T1, T2)];
        false -> [L1 | plus_attribute(T1, T2)]
    end;
plus_attribute(_, []) -> [];
plus_attribute([], _) -> [].


%%属性相减 Attr2-Attr1
sub_attribute(Attr1, Attr2) ->
    List1 = tuple_to_list(Attr1),
    [_name | ValueList1] = List1,

    List2 = tuple_to_list(Attr2),
    [_name | ValueList2] = List2,
    SubAttrs = sub_attribute_helper(ValueList1, ValueList2),
    list_to_tuple([attribute | SubAttrs]).

sub_attribute_helper([L1 | T1], [L2 | T2]) ->
    [L2 - L1 | sub_attribute_helper(T1, T2)];
sub_attribute_helper(_, []) -> [];
sub_attribute_helper([], _) -> [].
