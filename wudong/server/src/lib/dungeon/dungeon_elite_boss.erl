%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% vip精英boss
%%% @end
%%% Created : 24. 一月 2018 20:57
%%%-------------------------------------------------------------------
-module(dungeon_elite_boss).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("dungeon.hrl").
-include("elite_boss.hrl").
-include("achieve.hrl").

%% API
-export([
    init/1,
    check_enter/2,
    dun_elite_boss_ret/3,
    consume/4,
    midnight_refresh/1,
    dungeon_info/1,
    update_db/1,
    clean_elite_dun_goods/1
]).

clean_elite_dun_goods(Player) ->
    Count = goods_util:get_goods_count(7600001),
    MaxNum = data_elite_daily_reward:get_save_max_num(),
    if
        Count =< MaxNum -> ok;
        true ->
            {ok, _} = goods:subtract_good(Player, [{7600001, Count-MaxNum}], 754)
    end,
    ok.

init(#player{key = Pkey}) ->
    Sql = io_lib:format("select challenge_num, is_recv, buy_num, op_time from player_elite_boss_dun where pkey=~p", [Pkey]),
    St =
        case db:get_row(Sql) of
            [ChallengeNum, IsRecv, BuyNum, OpTime] ->
                #st_dun_elite_boss{pkey = Pkey, buy_num = BuyNum, challenge_num = ChallengeNum, is_recv = IsRecv, op_time = OpTime};
            _ ->
                #st_dun_elite_boss{pkey = Pkey}
        end,
    lib_dict:put(?PROC_STATUS_ELITE_BOSS_DUN, St),
    update(),
    ok.

update() ->
    St = lib_dict:get(?PROC_STATUS_ELITE_BOSS_DUN),
    Now = util:unixtime(),
    case util:is_same_date(Now, St#st_dun_elite_boss.op_time) of
        true -> ok;
        false ->
            NewSt =
                St#st_dun_elite_boss{
                    challenge_num = 0
                    , is_recv = 0
                    , buy_num = 0
                    , op_time = Now
                },
            lib_dict:put(?PROC_STATUS_ELITE_BOSS_DUN, NewSt),
            self() ! clean_elite_dun_goods
    end.

midnight_refresh(_Time) ->
    update().

update_db(St) ->
    #st_dun_elite_boss{pkey = Pkey, challenge_num = ChallengeNum, op_time = OpTime, buy_num = BuyNum, is_recv = IsRecv} = St,
    Sql = io_lib:format("replace into player_elite_boss_dun set pkey=~p, challenge_num=~p, is_recv=~p, buy_num = ~p, op_time=~p",
        [Pkey, ChallengeNum, IsRecv, BuyNum, OpTime]),
    db:execute(Sql),
    ok.

check_enter(Player, DunId) ->
    case dungeon_util:is_dungeon_elite_boss(DunId) of
        false ->
            true;
        true ->
            case data_elite_boss_dun:get(DunId) of
                [] ->
                    {false, ?T("材料不足")};
                #base_dun_elite_boss{consume = Consume, cost_gold = CostGold, vip_limit = VipLimit} ->
                    if
                        Player#player.vip_lv < VipLimit -> {false, ?T("Vip等级不足")};
                        true ->
                            case money:is_enough(Player, CostGold, gold) of
                                false ->
                                    {false, ?T("元宝不足")};
                                true ->
                                    case check_consume(Consume) of
                                        false -> {false, ?T("材料不足")};
                                        {true, NewConsume} ->
                                            BaseNum = data_vip_args:get(59, Player#player.vip_lv),
                                            St = lib_dict:get(?PROC_STATUS_ELITE_BOSS_DUN),
                                            if
                                                BaseNum =< St#st_dun_elite_boss.challenge_num -> {false, ?T("挑战次数不足")};
                                                true ->
                                                    NewSt = St#st_dun_elite_boss{challenge_num = St#st_dun_elite_boss.challenge_num+1, op_time = util:unixtime()},
                                                    lib_dict:put(?PROC_STATUS_ELITE_BOSS_DUN, NewSt),
                                                    update_db(NewSt),
                                                    Player#player.pid ! {dun_elite_boss, NewConsume, CostGold, DunId},
                                                    true
                                            end
                                    end
                            end
                    end
            end
    end.

check_consume([]) ->
    false;
check_consume([{7600001, Num}]) ->
    Count1 = goods_util:get_goods_count(7600001),
    Count2 = goods_util:get_goods_count(7600002),
    if
        Count1+Count2 < Num -> false;
        true ->
            if
                Count1 >= Num -> {true, [{7600001, Num}]};
                Count1 == 0 -> {true, [{7600002, Num}]};
                true -> {true, [{7600001, Count1}, {7600002, Num-Count1}]}
            end
    end.

consume(Player, Consume, CostGold, DunId) ->
    NewPlayer = money:add_no_bind_gold(Player, -CostGold, 755, 0, 0),
    {ok, _} = goods:subtract_good(Player, Consume, 756),
    Sql = io_lib:format("insert into log_elite_dun_enter set pkey=~p,dun_id=~p,cost_gold=~p,consume='~s',`time`=~p",
        [Player#player.key, DunId, CostGold, util:term_to_bitstring(Consume), util:unixtime()]),
    log_proc:log(Sql),
    NewPlayer.

%% 结算
dun_elite_boss_ret(0, Player, DunId) ->
    {ok, Bin} = pt_129:write(12902, {0, DunId, []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player;
dun_elite_boss_ret(1, Player, DunId) ->
    #base_dun_elite_boss{must_reward = MustReward} = data_elite_boss_dun:get(DunId),
    GiveGoodsList = goods:make_give_goods_list(757, MustReward),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    {ok, Bin} = pt_129:write(12902, {1, DunId, util:list_tuple_to_list(MustReward)}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Sql = io_lib:format("insert into log_elite_boss_dun_reward set pkey=~p,reward='~s',dun_id=~p,`time`=~p",
        [Player#player.key, util:term_to_bitstring(MustReward), DunId, util:unixtime()]),
    log_proc:log(Sql),
    achieve:trigger_achieve(Player#player.key, ?ACHIEVE_TYPE_3, ?ACHIEVE_SUBTYPE_3005, 0, 1),
    NewPlayer.

dungeon_info(Player) ->
    St = lib_dict:get(?PROC_STATUS_ELITE_BOSS_DUN),
    #st_dun_elite_boss{challenge_num = N} = St,
    Num = data_vip_args:get(59, Player#player.vip_lv),
    {N, Num}.