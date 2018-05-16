%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 一月 2018 20:17
%%%-------------------------------------------------------------------
-module(act_call_godness).
-author("Administrator").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    update/0,
    get_info/1,
    draw/2,
    get_state/1,
    get_count_reward/2
]).

init(#player{key = Pkey} = Player) ->
    St =
        case player_util:is_new_role(Player) of
            true -> #st_call_godnesst{pkey = Pkey};
            false -> activity_load:dbget_call_godness(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_CALL_GODNESS, St),
    update(),
    Player.

update() ->
    St = lib_dict:get(?PROC_STATUS_CALL_GODNESS),
    #st_call_godnesst{
        pkey = Pkey,
        act_id = ActId,
        op_time = Time
    } = St,
    case get_act() of
        [] ->
            NewSt = #st_call_godnesst{pkey = Pkey};
        #base_call_godness{act_id = BaseActId} ->
            if
                BaseActId =/= ActId ->
                    NewSt = #st_call_godnesst{pkey = Pkey, act_id = BaseActId};
                true ->
                    case util:is_same_date(Time, util:unixtime()) of
                        false -> NewSt = #st_call_godnesst{pkey = Pkey, act_id = BaseActId};
                        true ->
                            NewSt = St
                    end
            end
    end,
    lib_dict:put(?PROC_STATUS_CALL_GODNESS, NewSt).

get_act() ->
    case activity:get_work_list(data_call_godness) of
        [] -> [];
        [Base | _] -> Base
    end.

get_info(_Player) ->
    case get_act() of
        [] -> {0, 0, 0, 0, 0, 0, 0, [], [], []};
        Base ->
            St = lib_dict:get(?PROC_STATUS_CALL_GODNESS),
            LeaveTime = activity:get_leave_time(data_call_godness),
            Base#base_call_godness.show_list,
            Base#base_call_godness.count_reward,

            F = fun({Id, Count, Reward}) ->
                State =
                    case check_count_reward(Base, Id) of
                        {false, Res} -> Res;
                        {ok, Reward} -> 1
                    end,
                [Id, Count, State,
                    goods:pack_goods(Reward)
                ]
            end,
            CountList = lists:map(F, Base#base_call_godness.count_reward),
            Cost =
                if
                    St#st_call_godnesst.free_count >= Base#base_call_godness.free_count ->
                        Base#base_call_godness.one_cost;
                    true -> 0
                end,
            ?DEBUG("St#st_call_godnesst.value ~p~n", [St#st_call_godnesst.value]),
            SpList = get_sp_list(Base),
            {
                LeaveTime,
                Cost,
                Base#base_call_godness.ten_cost,
                St#st_call_godnesst.value,
                Base#base_call_godness.max_value,
                St#st_call_godnesst.count,
                Base#base_call_godness.show_id,
                goods:pack_goods(Base#base_call_godness.show_list),
                goods:pack_goods(SpList),
                CountList
            }
    end.

check_count_reward(Base, Id) ->
    case lists:keyfind(Id, 1, Base#base_call_godness.count_reward) of
        {Id, Count, Reward} ->
            St = lib_dict:get(?PROC_STATUS_CALL_GODNESS),
            if
                Count > St#st_call_godnesst.count -> {false, 0};
                true ->
                    case lists:member(Id, St#st_call_godnesst.get_list) of
                        true -> {false, 2};
                        false -> {ok, Reward}
                    end
            end;
        false ->
            {false, 0}
    end.

%% 唤神抽奖
draw(Player, Type) ->
    case check_draw(Player, Type) of
        {false, Res} -> {Res, Player, []};
        {Base, Cost, Len} ->
            NewPlayer = money:add_no_bind_gold(Player, -Cost, 343, 0, 0),
            F = fun(_, {GoodsList0, NewPlayer0}) ->
                {List, NewPlayer1} = draw_help(NewPlayer0, Base),
                {List ++ GoodsList0, NewPlayer1}
            end,
            {GoodsList, NewPlayer2} = lists:foldl(F, {[], NewPlayer}, lists:seq(1, Len)),
            St = lib_dict:get(?PROC_STATUS_CALL_GODNESS),
            NewFreeCount =
                if
                    Type == 0 -> St#st_call_godnesst.free_count + 1;
                    true -> St#st_call_godnesst.free_count
                end,
            NewSt = St#st_call_godnesst{free_count = NewFreeCount},
            lib_dict:put(?PROC_STATUS_CALL_GODNESS, NewSt),
            activity_load:dbup_call_godness(NewSt),
            activity:get_notice(Player, [181], true),
            log_call_godness_draw(Player#player.key, Player#player.nickname, Cost, GoodsList),
            {ok, NewPlayer3} = goods:give_goods(NewPlayer2, goods:make_give_goods_list(343, GoodsList)),
            {1, NewPlayer3, goods:pack_goods(GoodsList)}
    end.

draw_help(Player, Base) ->
    St = lib_dict:get(?PROC_STATUS_CALL_GODNESS),
    F = fun(Info, List) ->
        if St#st_call_godnesst.value =< Info#call_godness_info.down andalso St#st_call_godnesst.value >= Info#call_godness_info.top ->
            {Info#call_godness_info.value_down, Info#call_godness_info.value_top, [{{GoodsId, GoodsNum}, Ratio} || {GoodsId, GoodsNum, Ratio} <- Info#call_godness_info.reward]};
            true -> List
        end
    end,
    {ValueDown, ValueTop, Reward} = lists:foldl(F, [], Base#base_call_godness.reward_list),
    {GoodsId, GoodsNum} = util:list_rand_ratio(Reward),
    SpList = get_sp_list(Base),
    Value =
        case lists:member({GoodsId, GoodsNum}, SpList) of
            true -> %% 特殊物品
                0;
            false ->
                St#st_call_godnesst.value + util:rand(ValueDown, ValueTop)
        end,
    NewSt = St#st_call_godnesst{
        value = Value,
        count = St#st_call_godnesst.count + 1
    },
    lib_dict:put(?PROC_STATUS_CALL_GODNESS, NewSt),
    activity_load:dbup_call_godness(NewSt),
%%     {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(343, [{GoodsId, GoodsNum}])),
    {[{GoodsId, GoodsNum}], Player}.

check_draw(Player, Type) ->
    case get_act() of
        [] ->
            {false, 0};
        Base ->
            St = lib_dict:get(?PROC_STATUS_CALL_GODNESS),
            Cost =
                if
                    Type == 1 -> Base#base_call_godness.ten_cost;
                    true ->
                        if
                            St#st_call_godnesst.free_count >= Base#base_call_godness.free_count ->
                                Base#base_call_godness.one_cost;
                            true -> 0
                        end
                end,
%%             Cost = ?IF_ELSE(Type == 0, Base#base_call_godness.one_cost, Base#base_call_godness.ten_cost),
            Base#base_call_godness.free_count,
            case money:is_enough(Player, Cost, gold) of
                false -> {false, 2};
                true ->
                    {Base, Cost, ?IF_ELSE(Type == 0, 1, 10)}
            end
    end.


get_sp_list(Base) ->
    List = lists:keysort(#call_godness_info.id, Base#base_call_godness.reward_list),
    Info = hd(lists:reverse(List)),
    SpList = [{GoodsId, GoodsNum} || {GoodsId, GoodsNum, _} <- Info#call_godness_info.reward],
    SpList.


get_count_reward(Player, Id) ->
    case get_act() of
        [] -> {0, Player};
        Base ->
            case check_count_reward(Base, Id) of
                {false, Res} -> {Res, Player};
                {ok, Reward} ->
                    St = lib_dict:get(?PROC_STATUS_CALL_GODNESS),
                    NewSt = St#st_call_godnesst{
                        get_list = [Id | St#st_call_godnesst.get_list]
                    },
                    lib_dict:put(?PROC_STATUS_CALL_GODNESS, NewSt),
                    activity_load:dbup_call_godness(NewSt),
                    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(344, Reward)),
                    activity:get_notice(Player, [181], true),
                    log_call_godness_count(Player#player.key, Player#player.nickname, Id, Reward),
                    {1, NewPlayer}
            end
    end.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        Base ->
            St = lib_dict:get(?PROC_STATUS_CALL_GODNESS),
            Args = activity:get_base_state(Base#base_call_godness.act_info),
            if
                St#st_call_godnesst.free_count < Base#base_call_godness.free_count ->
                    {1, Args};
                true ->
                    F = fun({Id, _Count, _Reward}) ->
                        case check_count_reward(Base, Id) of
                            {false, _Res} -> false;
                            {ok, _Reward} ->
                                true
                        end
                    end,
                    case lists:any(F, Base#base_call_godness.count_reward) of
                        true -> {1, Args};
                        _ -> {0, Args}
                    end
            end
    end.

%% 抽奖日志
log_call_godness_draw(Pkey, Nickname, Cost, GoodsList) ->
    Sql = io_lib:format("insert into log_call_godness_draw set pkey=~p,nickname='~s',cost = ~p, goods_list='~s',time=~p",
        [Pkey, Nickname, Cost, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql).

%% 次数奖励日志
log_call_godness_count(Pkey, Nickname, CountId, GoodsList) ->
    Sql = io_lib:format("insert into log_call_godness_count set pkey=~p,nickname='~s',count_id = ~p, goods_list='~s',time=~p",
        [Pkey, Nickname, CountId, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql).
