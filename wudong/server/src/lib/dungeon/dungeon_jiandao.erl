%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 三月 2018 11:52
%%%-------------------------------------------------------------------
-module(dungeon_jiandao).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("dungeon.hrl").
-include("element.hrl").

%% API
-export([
    init/1,
    get_dun_list/1,
    midnight_refresh/0,
    check_enter/2,
    dun_jiandao_ret/4,
    get_state/1,
    buy/2
]).

buy(Player, GoodsId) ->
    St = lib_dict:get(?PROC_STATUS_DUN_JIANDAO),
    #st_dun_jiandao{buy_list = BuyList} = St,
    case lists:keytake(GoodsId, 1, BuyList) of
        false ->
            case data_dun_jiandao_goods:get_price_by_goodsId_buyNum(GoodsId, 1) of
                [] -> {3, Player};
                Price ->
                    case money:is_enough(Player, Price, gold) of
                        false -> {2, Player};
                        true ->
                            NewBuyList = [{GoodsId, 1} | BuyList],
                            NewSt = St#st_dun_jiandao{buy_list = NewBuyList},
                            lib_dict:put(?PROC_STATUS_DUN_JIANDAO, NewSt),
                            update_db(NewSt),
                            NPlayer = money:add_no_bind_gold(Player, -Price, 775, 0, 0),
                            GiveGoodsList = goods:make_give_goods_list(776, [{GoodsId, 1}]),
                            {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                            {1, NewPlayer}
                    end
            end;
        {value, {GoodsId, OldBuyNum}, Rest} ->
            case data_dun_jiandao_goods:get_price_by_goodsId_buyNum(GoodsId, OldBuyNum+1) of
                [] -> {3, Player};
                Price ->
                    case money:is_enough(Player, Price, gold) of
                        false -> {2, Player};
                        true ->
                            NewBuyList = [{GoodsId, OldBuyNum+1} | Rest],
                            NewSt = St#st_dun_jiandao{buy_list = NewBuyList},
                            lib_dict:put(?PROC_STATUS_DUN_JIANDAO, NewSt),
                            update_db(NewSt),
                            NPlayer = money:add_no_bind_gold(Player, -Price, 775, 0, 0),
                            GiveGoodsList = goods:make_give_goods_list(776, [{GoodsId, 1}]),
                            {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                            {1, NewPlayer}
                    end
            end
    end.

get_state(_Player) ->
    MaxNum = data_dun_jiandao_args:get_challenge_num(),
    StDunJiandao = lib_dict:get(?PROC_STATUS_DUN_JIANDAO),
    #st_dun_jiandao{
        log_list = LogList
    } = StDunJiandao,
    MaxNum = data_dun_jiandao_args:get_challenge_num(),
    if
        MaxNum =< length(LogList) -> 0;
        true ->1
    end.

dun_jiandao_ret(Player, DungeonId, Score, Mult) ->
    Reward = data_dun_jiandao_score:get(DungeonId, Score),
    if
        Mult == 0 ->
            NewReward = Reward;
        true ->
            NewReward = lists:map(fun({Gid, Gnum}) -> {Gid, Gnum*2} end, Reward)
    end,
    {ok, Bin} = pt_133:write(13305, {1, Score, util:list_tuple_to_list(NewReward)}),
    server_send:send_to_sid(Player#player.sid, Bin),
    GiveGoodsList = goods:make_give_goods_list(773, Reward),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    Sql = io_lib:format("replace into log_dun_jiandao set pkey=~p,dun_id=~p,score=~p,reward='~s',`time`=~p",
        [Player#player.key,DungeonId,Score,util:term_to_bitstring(Reward),util:unixtime()]),
    log_proc:log(Sql),
    activity:get_notice(NewPlayer, [192], true),
    NewPlayer.

check_enter(Player, DunId) ->
    case dungeon_util:is_dungeon_jiandao(DunId) of
        false ->
            true;
        true ->
            case data_dun_jiandao:get(DunId) of
                [] -> {false, ?T("副本ID错误")};
                #base_dun_jiandao{lv_limit = LvLimit} ->
                    if
                        Player#player.lv < LvLimit -> {false, ?T("等级不足")};
                        true ->
                            StDunJiandao = lib_dict:get(?PROC_STATUS_DUN_JIANDAO),
                            #st_dun_jiandao{
                                log_list = LogList,
                                challenge_num = ChallengeNum
                            } = StDunJiandao,
                            MaxNum = data_dun_jiandao_args:get_challenge_num(),
                            DailyMaxNum = data_dun_jiandao_args:get_daily_max_num(),
                            if
                                ChallengeNum >= DailyMaxNum -> {false, ?T("今日挑战次数用完")};
                                MaxNum =< ChallengeNum ->
                                    Consume = data_dun_jiandao_args:get_consume(),
                                    case check_consume(Player, Consume) of
                                        false -> {false, ?T("道具消耗不足")};
                                        true ->
                                            {ok, _} = goods:subtract_good(Player, Consume, 777),
                                            NewStDunJiandao =
                                                StDunJiandao#st_dun_jiandao{
                                                    log_list = util:list_filter_repeat([DunId | LogList]),
                                                    op_time = util:unixtime(),
                                                    challenge_num = ChallengeNum+1
                                                },
                                            lib_dict:put(?PROC_STATUS_DUN_JIANDAO, NewStDunJiandao),
                                            update_db(NewStDunJiandao),
                                            true
                                    end;
                                true ->
                                    NewStDunJiandao =
                                        StDunJiandao#st_dun_jiandao{
                                            log_list = util:list_filter_repeat([DunId | LogList]),
                                            op_time = util:unixtime(),
                                            challenge_num = ChallengeNum+1
                                        },
                                    lib_dict:put(?PROC_STATUS_DUN_JIANDAO, NewStDunJiandao),
                                    update_db(NewStDunJiandao),
                                    true
                            end
                    end
            end
    end.

check_consume(_Player, Consume) ->
    F = fun({GId, GNum}) ->
        goods_util:get_goods_count(GId) < GNum
    end,
    case lists:any(F, Consume) of
        true -> false;
        false -> true
    end.

get_dun_list(Player) ->
    StDunJianDao = lib_dict:get(?PROC_STATUS_DUN_JIANDAO),
    #st_dun_jiandao{buy_list = BuyList, challenge_num = ChallengeNum} = StDunJianDao,
    AllDunId = data_dun_jiandao:get_all(),
    F = fun(DunId) ->
        #base_dun_jiandao{lv_limit = LvLimit} = data_dun_jiandao:get(DunId),
        if
            Player#player.lv > LvLimit -> [DunId, 1];
            true -> [DunId, 0]
        end
    end,
    ProList = lists:map(F, AllDunId),
    UseNum = max(0, ChallengeNum - data_dun_jiandao_args:get_challenge_num()),
    [{Gid, GNum}|_] = data_dun_jiandao_args:get_consume(),
    ProPrice =
        case lists:keyfind(Gid, 1, BuyList) of
            false ->
                data_dun_jiandao_goods:get_price_by_goodsId_buyNum(Gid, 1);
            {Gid, OldNum} ->
                case data_dun_jiandao_goods:get_price_by_goodsId_buyNum(Gid, OldNum + 1) of
                    Price when is_integer(Price) -> Price;
                    _ -> data_dun_jiandao_goods:get_price_by_goodsId_buyNum(Gid, OldNum)
                end
        end,
    {max(0, data_dun_jiandao_args:get_challenge_num()-ChallengeNum),
        max(0, data_dun_jiandao_args:get_daily_max_num() - data_dun_jiandao_args:get_challenge_num() - UseNum),
        data_dun_jiandao_args:get_daily_max_num() - data_dun_jiandao_args:get_challenge_num(),
        Gid, GNum, ProPrice, ProList}.

init(#player{key=Pkey}) ->
    Sql = io_lib:format("select log_list, challenge_num, buy_list, op_time from player_dun_jiandao where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [LogList, ChallengeNum, BuyListBin, OpTime] ->
            StDunJianDao =
                #st_dun_jiandao{
                    pkey = Pkey,
                    log_list = util:bitstring_to_term(LogList),
                    challenge_num = ChallengeNum,
                    buy_list = util:bitstring_to_term(BuyListBin),
                    op_time = OpTime
                };
        _ ->
            StDunJianDao =
                #st_dun_jiandao{
                    pkey = Pkey
                }
    end,
    lib_dict:put(?PROC_STATUS_DUN_JIANDAO, StDunJianDao),
    update().

update_db(StDunJianDao) ->
    #st_dun_jiandao{pkey = Pkey, log_list = LogList, buy_list=BuyList, challenge_num = ChallengeNum, op_time = OpTime} = StDunJianDao,
    Sql = io_lib:format("replace into player_dun_jiandao set pkey=~p,log_list='~s',op_time=~p, challenge_num=~p,buy_list='~s'",
        [Pkey, util:term_to_bitstring(LogList), OpTime, ChallengeNum, util:term_to_bitstring(BuyList)]),
    db:execute(Sql),
    ok.

update() ->
    StDunJianDao = lib_dict:get(?PROC_STATUS_DUN_JIANDAO),
    #st_dun_jiandao{op_time = OpTime} = StDunJianDao,
    Now = util:unixtime(),
    case util:is_same_date(OpTime, Now) of
        true ->
            NewStDunJianDao = StDunJianDao;
        false ->
            NewStDunJianDao = StDunJianDao#st_dun_jiandao{log_list = [], op_time = Now, challenge_num = 0, buy_list = []}
    end,
    lib_dict:put(?PROC_STATUS_DUN_JIANDAO, NewStDunJianDao).

midnight_refresh() ->
    update().
