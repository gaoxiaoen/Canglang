%%%-------------------------------------------------------------------
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 集聚英雄
%%% @end
%%% Created : 09. 三月 2018 10:04
%%%-------------------------------------------------------------------
-module(act_collection_hero).
-author("Administrator").
-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").

-define(SECRETKEY, "cc5f3d8590b562b2bc098ec1a640bf33").

-define(GET_TIME_LIMIT,1522750349).

%% API
-export([
    get_info/2,
    get_sdk_recharge/1,
    get_player_info/1,
    get_reward/1,
    set_player_info/1,
    get_state/0]).


get_info(Sid,Accname) ->
    {Recharge,_Registertime, State} =
        case  get_player_info(Accname) of
            {true, Recharge0,Registertime0, State0} ->
                {Recharge0,Registertime0, State0};
            _ ->
                {0, 0,0}
        end,
    F = fun(Id) ->
        Base = data_collection_hero:get(Id),
        [[
            Base#base_collection_hero.id,
            Base#base_collection_hero.gold,
            goods:pack_goods(Base#base_collection_hero.goods_list)
        ]]
        end,
    List = lists:flatmap(F, data_collection_hero:get_all()),
    Data = {State, Recharge,?GET_TIME_LIMIT, List},
    {ok, Bin} = pt_438:write(43855, Data),
    server_send:send_to_sid(Sid, Bin).

get_player_info(UserId) ->
    {Recharge,Registertime} =  get_sdk_recharge(UserId),
    {true, Recharge,Registertime, activity_load:dbget_player_act_collection_hero(UserId)}.

set_player_info(UserId) ->
    activity_load:dbup_player_act_collection_hero(UserId),
    ok.

get_reward(Player) ->
    {Recharge,Registertime, State} =
        case cross_all:apply_call(act_collection_hero, get_player_info, [Player#player.accname]) of
            {true, Recharge0,Registertime0, State0} ->
                {Recharge0,Registertime0, State0};
            _ ->
                {0, 0,1}
        end,
    if
        Registertime > ?GET_TIME_LIMIT -> {25, Player};
        State == 1 -> {10, Player};
        true ->
            F = fun(Id) ->
                Base = data_collection_hero:get(Id),
                if
                    Base#base_collection_hero.gold =< Recharge ->
                        [{Base#base_collection_hero.id, Base#base_collection_hero.goods_list}];
                    true -> []
                end
                end,
            List = lists:flatmap(F, data_collection_hero:get_all()),
            if
                List == [] -> {0, Player};
                true ->
                    {_, GoodsList} = lists:max(List),
                    cross_all:apply(act_collection_hero, set_player_info, [Player#player.accname]),
                    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(352, GoodsList)),
                    {1, NewPlayer}
            end
    end.


%%获取越南sdk账号充值数据 注册时间
get_sdk_recharge(Useid) ->
    Now = util:unixtime(),
    Md5Str = util:md5(lists:concat([Useid, Now, ?SECRETKEY])),
    Query = io_lib:format("https://apisdk.gamota.com/read/queryuserinfo/chanlongthientu?userid=~p&endtime=~p&signature=~s", [Useid, Now, Md5Str]),
    Query2 = unicode:characters_to_list(Query, unicode),
    Result = httpc:request(get, {Query2, []}, [{timeout, 2000}], []),
    case Result of
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, JsonList}, _} ->
                    ?DEBUG("JsonList ~p~n",[JsonList]),
                    Recharge =
                        case lists:keyfind("recharge", 1, JsonList) of
                        {_, Val} when is_integer(Val) ->  Val;
                        {_, []} -> 0;
                        _ -> ?ERR("get_center_notice err bad json ~n"),
                            0
                    end,
                    Registertime =
                        case lists:keyfind("registertime", 1, JsonList) of
                        {_, Val1} when is_integer(Val1) -> Val1;
                        {_, []} ->   0;
                            _ ->   ?ERR("get_center_notice err bad json ~n"),
                            0
                    end,
                    {Recharge,Registertime};
                _ ->
                    {0,0}
            end;
        _ ->
            {0,0}
    end.

get_state()->
    Lan = version:get_lan_config(),
    if
        Lan ==  vietnam -> 0;
        true -> -1
    end.


