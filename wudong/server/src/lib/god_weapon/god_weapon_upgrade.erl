%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 十荒神器升阶
%%% @end
%%% Created : 02. 五月 2018 下午3:00
%%%-------------------------------------------------------------------
-module(god_weapon_upgrade).
-author("luobaqun").

-include("god_weapon.hrl").
-include("common.hrl").

-define(COST_GOODS_ID, 11716). %% 洗练道具

%% API
-export([
    upgrade_star/2,
    get_info/1,
    get_cost_list/1,
    get_upgrade_info/2
]).

get_info(_Player) ->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    Alls = data_god_weapon_upgrade:get_all(),
    F = fun(WeaponId) ->
        {_,_,NeedGoods,_,_} = god_weapon_upgrade:get_upgrade_info(_Player, WeaponId),
        case lists:keyfind(WeaponId, #god_weapon_star.weapon_id, StGodWeapon#st_god_weapon.weapon_star) of
            false ->
                [[WeaponId, 0, [], [],NeedGoods]];
            WeaponStar ->
                case data_god_weapon_upgrade:get(WeaponId, WeaponStar#god_weapon_star.star) of
                    [] ->
                        [];
                    Base ->
                        [[WeaponId, WeaponStar#god_weapon_star.star, [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- Base#base_god_weapon_upgrade.attr], god_weapon_wash:pack_wash(WeaponStar#god_weapon_star.wash),NeedGoods]]
                end
        end
        end,
    lists:flatmap(F, Alls).


upgrade_star(Player, WeaponId) ->
    case check_upgrade_star(Player, WeaponId) of
        {Res,Player} -> {Res,Player};
        {true,NeedGoods,Attr0} ->
            StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
            goods:subtract_good(Player, NeedGoods, 780),
            Attr = attribute_util:make_attribute_by_key_val_list(Attr0),
            NewWeaponStar =
                case lists:keytake(WeaponId, #god_weapon_star.weapon_id, StGodWeapon#st_god_weapon.weapon_star) of
                    false ->
                        NewWeaponStar0 = #god_weapon_star{weapon_id = WeaponId, star = 1, attribute = Attr},
                        NewAttr = god_weapon_init:calc_attribute_star(NewWeaponStar0),
                        log_god_weapon_upgrade(Player#player.key,Player#player.nickname,WeaponId,0,1,NeedGoods),
                        [NewWeaponStar0#god_weapon_star{attribute = NewAttr}|StGodWeapon#st_god_weapon.weapon_star];
                    {value, WeaponStar, T} ->
                        NewWeaponStar0 = WeaponStar#god_weapon_star{star = WeaponStar#god_weapon_star.star + 1, attribute = Attr},
                        NewAttr = god_weapon_init:calc_attribute_star(NewWeaponStar0),
                        log_god_weapon_upgrade(Player#player.key,Player#player.nickname,WeaponId,WeaponStar#god_weapon_star.star,WeaponStar#god_weapon_star.star+1,NeedGoods),
                        [NewWeaponStar0#god_weapon_star{attribute = NewAttr} | T]
                end,

            NewStGodWeapon = StGodWeapon#st_god_weapon{weapon_star = NewWeaponStar, is_change = 1},
            NewStGodWeapon1 = god_weapon_init:calc_attribute(NewStGodWeapon),
            lib_dict:put(?PROC_STATUS_GOD_WEAPON, NewStGodWeapon1),
            NewPlayer = player_util:count_player_attribute(Player, true),
            {1, NewPlayer}
end.

check_upgrade_star(Player, WeaponId)->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    case lists:keyfind(WeaponId, #god_weapon.weapon_id, StGodWeapon#st_god_weapon.weapon_list) of
        false ->
            {5, Player};
        _ ->
            NextStar =
                case lists:keyfind(WeaponId, #god_weapon_star.weapon_id, StGodWeapon#st_god_weapon.weapon_star) of
                    false -> 1;
                    GodWeaponStar ->
                        GodWeaponStar#god_weapon_star.star + 1
                end,
            case data_god_weapon_upgrade:get(WeaponId, NextStar) of
                [] ->
                    {10, Player};
                #base_god_weapon_upgrade{need_goods = NeedGoods, attr = Attr0,last_weapon = LastWeapon} ->
                    F = fun({GoodsId, GoodsNum}) ->
                        Count = goods_util:get_goods_count(GoodsId),
                        ?IF_ELSE(Count >= GoodsNum, true, false)
                    end,
                    case lists:all(F, NeedGoods) of
                        false -> {9, Player};
                        true ->
                            ?DEBUG("LastWeapon ~p~n",[LastWeapon]),
                            if
                                LastWeapon == [] ->   {true,NeedGoods,Attr0};
                                true ->
                                    F1 = fun({LaseWeaponId,LastStar})->
                                        case lists:keyfind(LaseWeaponId, #god_weapon.weapon_id, StGodWeapon#st_god_weapon.weapon_star) of
                                            false ->
                                                false;
                                            #god_weapon_star{star =LastStar0 } ->
                                                ?IF_ELSE(LastStar0 >= LastStar ,true,false);
                                            O ->
                                                ?DEBUG("O ~p~n",[O]),
                                                false
                                        end
                                        end,
                                        case lists:all(F1,LastWeapon) of
                                             false ->{15,Player};
                                            true ->
                                                {true,NeedGoods,Attr0}
                                        end
                            end;
                        Other ->
                            ?DEBUG("Other ~p~n",[Other]),
                            {0,Player}
                    end
            end
    end.


get_upgrade_info(_Player, WeaponId) ->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    case lists:keyfind(WeaponId, #god_weapon_star.weapon_id, StGodWeapon#st_god_weapon.weapon_star) of
        false ->
            case data_god_weapon_upgrade:get(WeaponId, 1) of
                [] ->
                    {WeaponId, 0, [], [], []};
                Base ->
                    {WeaponId, 0, goods:pack_goods(Base#base_god_weapon_upgrade.need_goods), [],[[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- Base#base_god_weapon_upgrade.attr] }
            end;
        WeaponStar ->
            Base0 = data_god_weapon_upgrade:get(WeaponId, WeaponStar#god_weapon_star.star),
            case data_god_weapon_upgrade:get(WeaponId, WeaponStar#god_weapon_star.star + 1) of
                [] ->
                    {WeaponId, WeaponStar#god_weapon_star.star,
                        [],
                        [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- Base0#base_god_weapon_upgrade.attr],
                        []};
                Base ->
                    {WeaponId, WeaponStar#god_weapon_star.star, goods:pack_goods(Base#base_god_weapon_upgrade.need_goods),
                        [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <-Base0#base_god_weapon_upgrade.attr],
                        [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <-Base#base_god_weapon_upgrade.attr]}
            end
    end.


get_cost_list(_Player)->
    AllList = data_god_weapon_upgrade:get_all(),
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    F = fun(WeaponId)->
        Activation =  case lists:keyfind(WeaponId, #god_weapon.weapon_id, StGodWeapon#st_god_weapon.weapon_list) of
            false ->
                0;
            _ ->1
            end,

        case lists:keyfind(WeaponId, #god_weapon_star.weapon_id, StGodWeapon#st_god_weapon.weapon_star) of
            false ->
                case data_god_weapon_upgrade:get(WeaponId, 1) of
                    [] ->
                        [WeaponId, 0,0,Activation, [],[]];
                    Base ->
                        [WeaponId, 0,0, Activation,goods:pack_goods(Base#base_god_weapon_upgrade.need_goods),goods:pack_goods(Base#base_god_weapon_upgrade.last_weapon)]
                end;
            WeaponStar ->
                WashState = get_wash_state(WeaponStar),
                case data_god_weapon_upgrade:get(WeaponId, WeaponStar#god_weapon_star.star + 1) of
                    [] ->
                        [WeaponId, WeaponStar#god_weapon_star.star,WashState,Activation, [],[]];
                    Base ->
                        [WeaponId, WeaponStar#god_weapon_star.star, WashState,Activation,goods:pack_goods(Base#base_god_weapon_upgrade.need_goods),goods:pack_goods(Base#base_god_weapon_upgrade.last_weapon)]
                end
            end
        end,
    lists:map(F,AllList).

get_wash_state(WeaponStar)->
    F = fun(Id)->
            #base_god_weapon_wash_open{grade = Grade} = data_god_weapon_wash_open:get(WeaponStar#god_weapon_star.weapon_id ,Id),
            ?IF_ELSE(WeaponStar#god_weapon_star.star>=Grade,[Id],[])
        end,
    Ids = lists:flatmap(F,data_god_weapon_wash_open:get_all()),
    NoewIds = [X#god_weapon_wash.id||X<-WeaponStar#god_weapon_star.wash,X#god_weapon_wash.now_attr_type =/= 0], %% 已洗练id
    case Ids -- NoewIds of
         [] ->0;
        _ ->1
    end.

log_god_weapon_upgrade(Pkey,Nickname,WeaponId,OldStar,NewStar,NeedGoods)->
    Sql = io_lib:format("insert into  log_god_weapon_upgrade (pkey, nickname,weapon_id,old_star,new_star,goods_list, time) VALUES(~p,'~s',~p,~p,~p,'~s',~p)",
        [Pkey,Nickname,WeaponId,OldStar,NewStar,util:term_to_bitstring(NeedGoods), util:unixtime()]),
    log_proc:log(Sql),
    ok.

