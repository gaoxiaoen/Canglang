%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 一月 2017 15:36
%%%-------------------------------------------------------------------
-module(god_weapon_init).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("god_weapon.hrl").

%% API
-export([init/1, timer_update/0, logout/0, record2list/1, list2record/1, star_record2list/1, star_list2record/1, wash_record2list/1, wash_list2record/1]).

-export([calc_weapon_attribute/2, calc_attribute/1, get_attribute/0,calc_attribute_star/1,get_star_attribute/0]).
%%初始化
init(Player) ->
    StGodWeapon =
        case player_util:is_new_role(Player) of
            true ->
                #st_god_weapon{pkey = Player#player.key};
            false ->
                case god_weapon_load:load(Player#player.key) of
                    [] ->
                        #st_god_weapon{pkey = Player#player.key};
                    [WeaponList, SkillId, WeaponId,StarList] ->
                        StarList1 = if
                            StarList == null -> [];
                            true -> star_list2record(StarList)
                        end,
                        #st_god_weapon{pkey = Player#player.key, weapon_list = list2record(WeaponList), weapon_id = WeaponId, skill_id = SkillId,weapon_star = StarList1}
                end
        end,
    StGodWeapon1 = calc_attribute(StGodWeapon),
    lib_dict:put(?PROC_STATUS_GOD_WEAPON, StGodWeapon1),
    Player#player{
        god_weapon_id = StGodWeapon1#st_god_weapon.weapon_id,
        god_weapon_skill = StGodWeapon1#st_god_weapon.skill_id
    }.



record2list(WeaponList) ->
    F = fun(Weapon) ->
        {Weapon#god_weapon.weapon_id, Weapon#god_weapon.spirit_list, Weapon#god_weapon.type, Weapon#god_weapon.stage}
        end,
    util:term_to_bitstring(lists:map(F, WeaponList)).

list2record(WeaponList) ->
    F = fun({WeaponId, SpiritList, Type, Stage}) ->
        Attribute = calc_weapon_attribute(WeaponId, SpiritList),
        Cbp = attribute_util:calc_combat_power(Attribute),
        #god_weapon{weapon_id = WeaponId, spirit_list = SpiritList, type = Type, stage = Stage, attribute = Attribute, cbp = Cbp}
        end,
    lists:map(F, util:bitstring_to_term(WeaponList)).



star_record2list(WeaponList) ->
    F = fun(Weapon) ->
        {Weapon#god_weapon_star.weapon_id, Weapon#god_weapon_star.star, wash_record2list(Weapon#god_weapon_star.wash)}
        end,
    util:term_to_bitstring(lists:map(F, WeaponList)).


star_list2record(WeaponList) ->
    ?DEBUG("WeaponList ~p~n",[WeaponList]),
    F = fun({WeaponId, Star, Wash}) ->
        Weapon = #god_weapon_star{
            weapon_id = WeaponId,
            star = Star,
            wash = wash_list2record(Wash)
        },
        NewAttr = calc_attribute_star(Weapon),
        Weapon#god_weapon_star{attribute = NewAttr}
        end,
    lists:map(F, util:bitstring_to_term(WeaponList)).

wash_record2list(WashLiost) ->
    F = fun(Wash) ->
        {
            Wash#god_weapon_wash.id,
            Wash#god_weapon_wash.now_attr_type,
            Wash#god_weapon_wash.now_attr_num,
            Wash#god_weapon_wash.now_star,
            Wash#god_weapon_wash.next_attr_type,
            Wash#god_weapon_wash.next_attr_num,
            Wash#god_weapon_wash.next_star,
            Wash#god_weapon_wash.count
        }
        end,
    lists:map(F, WashLiost).

wash_list2record(List) ->
    F = fun({Id, NowAttrType, NowAttrNum,NowStar, NextAttrType, NextAttrNum, NextStar, Count}) ->
        #god_weapon_wash{
            id = Id,
            now_attr_type = NowAttrType,
            now_attr_num = NowAttrNum,
            now_star  = NowStar,
            next_attr_type = NextAttrType,
            next_attr_num = NextAttrNum,
            next_star = NextStar,
            count = Count
        }
        end,
    lists:map(F, List).


%%计算单个神器属性
calc_weapon_attribute(WeaponId, SpiritList) ->
    case data_god_weapon:get(WeaponId) of
        [] ->
            #attribute{};
        BaseData ->
            F = fun({Type, Stage}) ->
                case data_god_weapon_spirit:get(WeaponId, Type, Stage) of
                    [] -> [];
                    Base ->
                        Base#base_god_weapon_spirit.attrs
                end
                end,
            SpiritAttrs = lists:flatmap(F, SpiritList),
            attribute_util:make_attribute_by_key_val_list(BaseData#base_god_weapon.attrs ++ SpiritAttrs)
    end.

%%计算总属性
calc_attribute(StGodWeapon) ->
    AttributeList = [Weapon#god_weapon.attribute || Weapon <- StGodWeapon#st_god_weapon.weapon_list],
    Attribute = attribute_util:sum_attribute(AttributeList),
    Cbp1 = attribute_util:calc_combat_power(Attribute),

    AttributeStarList = [GodWeaponStar#god_weapon_star.attribute || GodWeaponStar <- StGodWeapon#st_god_weapon.weapon_star],
    AttributeStar = attribute_util:sum_attribute(AttributeStarList),
    Cbp2 = attribute_util:calc_combat_power(AttributeStar),

    StGodWeapon#st_god_weapon{attribute = Attribute, attribute_star = AttributeStar, cbp = Cbp1 + Cbp2}.
%%     StGodWeapon#st_god_weapon{attribute = Attribute, cbp = Cbp1}.


%% 计算单个神器阶级属性
calc_attribute_star(Weapon)->
    case data_god_weapon_upgrade:get(Weapon#god_weapon_star.weapon_id,Weapon#god_weapon_star.star) of
        [] ->
            #attribute{};
        #base_god_weapon_upgrade{attr = Attr} ->
            F = fun(Wash) ->
                if
                    Wash#god_weapon_wash.now_attr_type == 0 -> [] ;
                    true -> [{Wash#god_weapon_wash.now_attr_type,Wash#god_weapon_wash.now_attr_num}]
                end
            end,
            SpiritAttrs = lists:flatmap(F, Weapon#god_weapon_star.wash),
            attribute_util:make_attribute_by_key_val_list(Attr ++ SpiritAttrs)
    end.


%%获取属性
get_attribute() ->
    St = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    St#st_god_weapon.attribute.

%%获取属性
get_star_attribute() ->
    St = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    St#st_god_weapon.attribute_star.

%%定时更新
timer_update() ->
    St = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    if St#st_god_weapon.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_GOD_WEAPON, St#st_god_weapon{is_change = 0}),
        god_weapon_load:replace(St);
        true -> ok
    end.


%%离线
logout() ->
    St = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    if St#st_god_weapon.is_change == 1 ->
        god_weapon_load:replace(St);
        true -> ok
    end.