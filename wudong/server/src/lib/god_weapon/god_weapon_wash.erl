%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 十荒神器洗练
%%% @end
%%% Created : 02. 五月 2018 下午2:52
%%%-------------------------------------------------------------------
-module(god_weapon_wash).
-author("luobaqun").

-include("god_weapon.hrl").
-include("common.hrl").
-include("new_shop.hrl").

-define(COST_GOODS_ID, 11716). %% 洗练道具


%% API
-export([
    pack_wash/1,
    pack_next_wash/1,
    get_wash_info/2,
    wash_weapon/5,
    wash_replace/2
]).

get_wash_info(_Player, WeaponId) ->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    case lists:keyfind(WeaponId, #god_weapon_star.weapon_id, StGodWeapon#st_god_weapon.weapon_star) of
        false ->
            {WeaponId, 0, [], []};
        WeaponStar ->
            NowList = pack_wash(WeaponStar#god_weapon_star.wash),
            NextList = pack_next_wash(WeaponStar#god_weapon_star.wash),
            {WeaponId, WeaponStar#god_weapon_star.star, NowList, NextList}
    end.

wash_weapon(Player, WeaponId, Type, Ids,LockIds) ->
    case check_wash_weapon(Player, WeaponId, Type, Ids,LockIds) of
        {false, Res} -> {Res, Player};
        {ok,  {BgoldCost,GoodsCost,CoinCost,OldWeaponStar}} ->
            {NewWeaponStar,Log} = reset_wash(Player, WeaponId, Ids,LockIds),
            NewPlayer0 = money:add_gold(Player, -BgoldCost, 360, 0, 0),
            ?DO_IF(GoodsCost>0, goods:subtract_good(NewPlayer0, [{?COST_GOODS_ID, GoodsCost}], 360)),
            NewPlayer1 = money:add_coin(NewPlayer0, -CoinCost, 360, 0, 0),
            StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
            log_wash_weapon(Player#player.key,Player#player.nickname,WeaponId,OldWeaponStar,Log,BgoldCost,GoodsCost,CoinCost),
            lib_dict:put(?PROC_STATUS_GOD_WEAPON, StGodWeapon#st_god_weapon{weapon_star = NewWeaponStar,is_change = 1}),
            {1, NewPlayer1}
    end.


check_wash_weapon(Player, WeaponId, Type, Ids,LockIds) ->
    case Ids of
        [] -> {false, 0};
        _ ->
            MaxId = lists:max(Ids),
            StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
            case lists:keyfind(WeaponId, #god_weapon_star.weapon_id, StGodWeapon#st_god_weapon.weapon_star) of
                false ->
                    {false, 0};
                WeaponStar ->
                    case data_god_weapon_wash_open:get(WeaponId,MaxId) of
                        [] ->
                            {false, 0};
                        #base_god_weapon_wash_open{grade = Grade} ->
                            if
                                Grade > WeaponStar#god_weapon_star.star -> {false, 11}; %% 阶数
                                true ->
                                    Len = length(Ids),
                                    case data_gods_weapon_wash_cost:get(Len) of
                                        [] ->
                                            {false, 0};
                                        {CoinCost,GoodsCost} ->
                                            case Type of
                                                1 ->  %%银币
                                                    case money:is_enough(Player, CoinCost, coin) of
                                                        false ->
                                                            {false, 13};
                                                        true ->
                                                            Len1 = length(LockIds),
                                                            case data_gods_weapon_wash_lock:get(Len1) of
                                                                [] ->
                                                                    {ok, {0,0,CoinCost,WeaponStar}};
                                                                LockCost ->
                                                                    case money:is_enough(Player, LockCost, bgold) of
                                                                        false ->
                                                                            {false, 14};
                                                                        true ->
                                                                            {ok, {LockCost,0,CoinCost,WeaponStar}}
                                                                    end
                                                            end
                                                    end;
                                                2 -> %% 材料
                                                    Count = goods_util:get_goods_count(?COST_GOODS_ID),
                                                    if
                                                        Count >= GoodsCost ->
                                                            {ok, {0,GoodsCost,0,WeaponStar}};
                                                        true ->
                                                            case data_new_shop:get_by_type_goods_id(0,?COST_GOODS_ID) of
                                                                [] -> {false,0};
                                                                #base_shop{bgold = Bgold} ->
                                                                    WashCost = Bgold * (GoodsCost -Count),
                                                                    case money:is_enough(Player,WashCost, bgold) of
                                                                        false ->
                                                                            {false, 14};
                                                                        true ->
                                                                            Len1 = length(LockIds),
                                                                            LockCost =
                                                                                if
                                                                                    LockIds == [] -> 0;
                                                                                    true ->
                                                                                        case data_gods_weapon_wash_lock:get(Len1) of
                                                                                            [] ->0;
                                                                                            LockCost0 ->LockCost0
                                                                                        end
                                                                                end,
                                                                            WashCost = Bgold * (GoodsCost -Count),
                                                                            case money:is_enough(Player,WashCost + LockCost, bgold) of
                                                                                false ->
                                                                                    {false, 14};
                                                                                true ->
                                                                                    {ok, {WashCost + LockCost,GoodsCost,0,WeaponStar}}
                                                                            end
                                                                    end
                                                            end
                                                    end
                                            end
                                    end
                            end
                    end
            end
    end.


reset_wash(_Player, WeaponId, Ids0,LockIds) ->
    ?DEBUG("Ids0,LockIds ~p~n",[{Ids0,LockIds}]) ,
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    case lists:keytake(WeaponId, #god_weapon_star.weapon_id, StGodWeapon#st_god_weapon.weapon_star) of
        false ->
            {false, 0};
        {value, WeaponStar, T} ->
            AllId = data_god_weapon_wash_open:get_all(),
            Ids = [X||X<-Ids0,Y<-AllId,X==Y],

%%             OpenList = [X||X<-AllId,X=<WeaponStar#god_weapon_star.star],

            TypeList = reset_wash_help_get_types(WeaponStar#god_weapon_star.wash),
            F = fun(Id0,WashList) ->
                {Wash,Other} =
                    case lists:keytake(Id0,#god_weapon_wash.id, WashList) of
                        false ->
                            {#god_weapon_wash{id=Id0},WashList};
                        {value,Wash0,T0} ->
                            {Wash0,T0}
                    end,
                ?DEBUG("Wash#god_weapon_wash.id,LockIds ~p~n",[{Wash#god_weapon_wash.id,LockIds}]),
                case lists:member(Wash#god_weapon_wash.id,LockIds) of
                    true ->
                        ?DEBUG("true ~n"),
                        [Wash#god_weapon_wash{
                            next_star = Wash#god_weapon_wash.now_star,
                            next_attr_num =  Wash#god_weapon_wash.now_attr_num,
                            next_attr_type =  Wash#god_weapon_wash.now_attr_type
                        }|Other];
                    false ->
                        OpenBase = data_god_weapon_wash_open:get(WeaponId,Wash#god_weapon_wash.id),
                        F1 = fun({Att0, Ratio}) ->  %% 根据已有属性，降低权值
                            case lists:keyfind(Att0, 1, TypeList) of
                                false ->
                                    {Att0, Ratio};
                                {Att0, Count} ->
                                    {Att0, Ratio div Count}
                            end
                        end,
                        NewRatioList = lists:map(F1, OpenBase#base_god_weapon_wash_open.attrs),
                        NextAttr = util:list_rand_ratio(NewRatioList),
                        Base = data_god_weapon_wash_star:get(WeaponStar#god_weapon_star.star),
                        case util:lists_lr_check(Base#base_god_weapon_wash_star.ratio_list, Wash#god_weapon_wash.count) of
                            [] ->
                                [Wash|Other];
                            {_, _, NextStarList} ->

                                NextStar = util:list_rand_ratio(NextStarList),
                                NewCount =
                                    case   lists:member(NextStar,Base#base_god_weapon_wash_star.reset) of
                                        false->
                                            Wash#god_weapon_wash.count+1;
                                        true->
                                            0
                                    end,
                                case data_god_weapon_wash_star_att:get(NextAttr, NextStar) of
                                    [] ->
                                        [Wash|Other];
                                    {L, R} ->
                                        NextVal = util:random(L, R),
                                        [Wash#god_weapon_wash{
                                            next_star = NextStar,
                                            next_attr_num = NextVal,
                                            next_attr_type = NextAttr,
                                            count = NewCount
                                        }|Other]
                                end
                        end
                end
            end,
            NewWash = lists:foldl(F, WeaponStar#god_weapon_star.wash,Ids ++LockIds),
            {[WeaponStar#god_weapon_star{wash = NewWash} | T],WeaponStar#god_weapon_star{wash = NewWash}}
    end.

%% 选出当前已有属性列表
reset_wash_help_get_types(Washs) ->
    TypeList0 = [X#god_weapon_wash.now_star || X <- Washs],
    F1 = fun(Type0, List0) ->
        case lists:keytake(Type0, 1, List0) of
            false ->
                [{Type0, 1} | List0];
            {value, {Type0, Num0}, T0} ->
                [{Type0, Num0 + 1} | T0]
        end
    end,
    lists:foldl(F1, [], TypeList0).





pack_wash(List) ->
    F = fun(Wash) ->
        if
            Wash#god_weapon_wash.now_attr_type == 0 -> [];
            true ->
                [[
                    Wash#god_weapon_wash.id,
                    attribute_util:attr_tans_client(Wash#god_weapon_wash.now_attr_type),
                    Wash#god_weapon_wash.now_attr_num,
                    Wash#god_weapon_wash.now_star]]
        end
    end,
    lists:flatmap(F, List).

pack_next_wash(List) ->
    F = fun(Wash) ->
        if
            Wash#god_weapon_wash.next_attr_type == 0 -> [];
            true ->
                [[
                    Wash#god_weapon_wash.id,
                    attribute_util:attr_tans_client(Wash#god_weapon_wash.next_attr_type),
                    Wash#god_weapon_wash.next_attr_num,
                    Wash#god_weapon_wash.next_star]]
        end
    end,
    lists:flatmap(F, List).



wash_replace(Player, WeaponId) ->
    StGodWeapon = lib_dict:get(?PROC_STATUS_GOD_WEAPON),
    case lists:keytake(WeaponId, #god_weapon_star.weapon_id, StGodWeapon#st_god_weapon.weapon_star) of
        false ->
            {0, Player};
        {value, WeaponStar, T} ->
            F = fun(Wash) ->
                if
                    Wash#god_weapon_wash.next_attr_type == 0 -> Wash;
                    true ->
                        Wash#god_weapon_wash{
                            now_attr_type = Wash#god_weapon_wash.next_attr_type,
                            now_attr_num = Wash#god_weapon_wash.next_attr_num,
                            now_star = Wash#god_weapon_wash.next_star,
                            next_attr_type = 0,
                            next_attr_num = 0,
                            next_star = 0
                        }
                end
            end,
            NewWash = lists:map(F, WeaponStar#god_weapon_star.wash),
            NewWeaponStar0 = WeaponStar#god_weapon_star{wash = NewWash},
            NewAttr = god_weapon_init:calc_attribute_star(NewWeaponStar0),
            NewStGodWeapon0 = StGodWeapon#st_god_weapon{weapon_star = [NewWeaponStar0#god_weapon_star{attribute = NewAttr} | T], is_change = 1},
            NewStGodWeapon1 = god_weapon_init:calc_attribute(NewStGodWeapon0),
            lib_dict:put(?PROC_STATUS_GOD_WEAPON, NewStGodWeapon1),
            NewPlayer = player_util:count_player_attribute(Player, true),
            log_wash_replace(Player#player.key,Player#player.nickname,WeaponId,NewWash),
            {1, NewPlayer}
    end.

log_wash_weapon(Pkey,Nickname,WeaponId,OldWeaponStar,NewWeaponStar,BgoldCost,GoodsCost,CoinCost)->
    OldWash = log_old(OldWeaponStar),
    NewWash = log_new(NewWeaponStar),
    Sql = io_lib:format("insert into  log_wash_weapon (pkey, nickname,weapon_id,bgold,goods_cost,coin_cost,old_wash,new_wash, time) VALUES(~p,'~s',~p,~p,~p,~p,'~s','~s',~p)",
        [Pkey,Nickname,WeaponId,BgoldCost,GoodsCost,CoinCost, util:term_to_bitstring(OldWash),  util:term_to_bitstring(NewWash), util:unixtime()]),
    log_proc:log(Sql),
    ok.

log_old(List)->
    F = fun(Wash)->
        {
            Wash#god_weapon_wash.id,
            Wash#god_weapon_wash.now_attr_type,
            Wash#god_weapon_wash.now_attr_num,
            Wash#god_weapon_wash.now_star
        }
    end,
    lists:map(F,List#god_weapon_star.wash).

log_new(List)->
    F = fun(Wash)->
        {
            Wash#god_weapon_wash.id,
            Wash#god_weapon_wash.next_attr_type,
            Wash#god_weapon_wash.next_attr_num,
            Wash#god_weapon_wash.next_star
        }
    end,
    lists:map(F,List#god_weapon_star.wash).

log_wash_replace(Pkey,Nickname,WeaponId,WashList)->
    F = fun(Wash) ->
        {
            Wash#god_weapon_wash.id,
            Wash#god_weapon_wash.now_attr_type,
            Wash#god_weapon_wash.now_attr_num,
            Wash#god_weapon_wash.now_star
        }
    end,
    NewWash = lists:map(F, WashList),
    Sql = io_lib:format("insert into  log_wash_replace (pkey, nickname,weapon_id,wash_list, time) VALUES(~p,'~s',~p,'~s',~p)",
        [Pkey,Nickname,WeaponId, util:term_to_bitstring(NewWash),util:unixtime()]),
    log_proc:log(Sql),
    ok.
