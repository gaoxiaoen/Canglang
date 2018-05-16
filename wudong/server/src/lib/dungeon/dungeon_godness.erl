%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 神祇副本
%%% @end
%%% Created : 05. 一月 2018 11:22
%%%-------------------------------------------------------------------
-module(dungeon_godness).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("godness.hrl").
-include("dungeon.hrl").

%% API
-export([
    init/1,
    update_db/1,
    midnight_refresh/1,
    check_enter/2,
    dungeon_info/1,
    dungeon_godness_ret/3,
    buy_reset/2,
    saodang_dun/3,
    get_notice_state/1
]).

get_notice_state(Player) ->
    Lv = data_menu_open:get(86),
    if
        Player#player.lv < Lv -> 0;
        true ->
            AllDunId = data_dungeon_godness:get_all(),
            F = fun(DunId) ->
                case check_enter(Player, DunId) of
                    true -> true;
                    _ -> false
                end
            end,
            Flag = lists:any(F, AllDunId),
            ?IF_ELSE(Flag == true, 1, 0)
    end.

init(#player{key = Pkey}) ->
    Sql = io_lib:format("select buy_num,left_godsoul_num,left_godness_num,right_godsoul_num,right_godness_num,left_pass_list,right_pass_list,log_dun_id_list,op_time from player_dun_godness where pkey=~p", [Pkey]),
    StDunGodness =
        case db:get_row(Sql) of
            [BuyNum, LeftGodsoulNum, LeftGodnessNum, RightGodsoulNum, RightGodnessNum, LeftPassList, RightPassList,LogDunIdList, OpTime] ->
                #st_dun_godness{
                    pkey = Pkey
                    , buy_num = util:bitstring_to_term(BuyNum) %% 是否花云宝购买
                    , left_godsoul_num = util:bitstring_to_term(LeftGodsoulNum) %% 神魂副本挑战次数
                    , left_godness_num = util:bitstring_to_term(LeftGodnessNum) %% 神祇副本挑战次数
                    , right_godsoul_num = util:bitstring_to_term(RightGodsoulNum) %% 神魂副本挑战次数
                    , right_godness_num = util:bitstring_to_term(RightGodnessNum) %% 神祇副本挑战次数
                    , left_pass_list = util:bitstring_to_term(LeftPassList) %% 通关列表
                    , right_pass_list = util:bitstring_to_term(RightPassList) %% 通关列表
                    , log_dun_id_list = util:bitstring_to_term(LogDunIdList)
                    , op_time = OpTime
                };
            _ ->
                #st_dun_godness{pkey = Pkey}
        end,
    lib_dict:put(?PROC_STATUS_DUN_GODNESS, StDunGodness),
    update().

update_db(StDunGodness) ->
    #st_dun_godness{
        pkey = Pkey
        , buy_num = BuyNum
        , left_godsoul_num = LeftGodsoulNum
        , left_godness_num = LeftGodnessNum
        , right_godsoul_num = RightGodsoulNum
        , right_godness_num = RightGodnessNum
        , left_pass_list = LeftPassList
        , right_pass_list = RightPassList
        , log_dun_id_list = LogDunIdList
    } = StDunGodness,
    Sql = io_lib:format("replace into player_dun_godness set pkey=~p,buy_num='~s',left_godsoul_num='~s',left_godness_num='~s',right_godsoul_num='~s',right_godness_num='~s',left_pass_list='~s',right_pass_list='~s',log_dun_id_list='~s',op_time=~p",
        [Pkey, util:term_to_bitstring(BuyNum), util:term_to_bitstring(LeftGodsoulNum),util:term_to_bitstring(LeftGodnessNum), util:term_to_bitstring(RightGodsoulNum), util:term_to_bitstring(RightGodnessNum), util:term_to_bitstring(LeftPassList), util:term_to_bitstring(RightPassList), util:term_to_bitstring(LogDunIdList), util:unixtime()]),
    db:execute(Sql),
    ok.

update() ->
    StDunGodness = lib_dict:get(?PROC_STATUS_DUN_GODNESS),
    Now = util:unixtime(),
    case util:is_same_date(Now, StDunGodness#st_dun_godness.op_time) of
        true -> ok;
        false ->
            NewStDunGodness =
                StDunGodness#st_dun_godness{
                    buy_num = []
                    , left_godsoul_num = []
                    , left_godness_num = []
                    , right_godsoul_num = []
                    , right_godness_num = []
                    , left_pass_list = []
                    , right_pass_list = []
                    , op_time = util:unixtime()
                },
            lib_dict:put(?PROC_STATUS_DUN_GODNESS, NewStDunGodness)
    end.

midnight_refresh(_Time) ->
    update().

%% 结算
dungeon_godness_ret(0, Player, DunId) ->
    {ok, Bin} = pt_128:write(12802, {0, DunId, []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player;
dungeon_godness_ret(1, Player, DunId) ->
    StDunGodness = lib_dict:get(?PROC_STATUS_DUN_GODNESS),
    #st_dun_godness{
        left_godsoul_num = LeftGodsoulNum
        , left_godness_num = LeftGodnessNum
        , right_godsoul_num = RightGodsoulNum
        , right_godness_num = RightGodnessNum
        , left_pass_list = LeftPassList
        , right_pass_list = RightPassList
        , log_dun_id_list = LogDunIdList
    } = StDunGodness,
    #base_dun_godness{
        layer = Layer
        , type = Type
        , subtype = SubType
        , first_reward = FirstReward
        , daily_reward = DailyReward
    } = data_dungeon_godness:get(DunId),
    {NewLeftGodsoulNum, NewLeftGodnessNum, NewRightGodsoulNum, NewRightGodnessNum} =
        get_data(Layer, Type, SubType, {LeftGodsoulNum, LeftGodnessNum, RightGodsoulNum, RightGodnessNum}),
    case Type of
        1 ->
            NewLeftPassList = util:list_filter_repeat([{Layer,DunId}] ++ LeftPassList),
            NewRightPassList = RightPassList;
        _ ->
            NewLeftPassList = LeftPassList,
            NewRightPassList = util:list_filter_repeat([{Layer, DunId}] ++ RightPassList)
    end,
    NewStDunGodness =
        StDunGodness#st_dun_godness{
            left_godsoul_num = NewLeftGodsoulNum
            , left_godness_num = NewLeftGodnessNum
            , right_godsoul_num = NewRightGodsoulNum
            , right_godness_num = NewRightGodnessNum
            , left_pass_list = NewLeftPassList
            , right_pass_list = NewRightPassList
            , log_dun_id_list = util:list_filter_repeat([DunId|LogDunIdList])
        },
    lib_dict:put(?PROC_STATUS_DUN_GODNESS, NewStDunGodness),
    update_db(NewStDunGodness),
    RewardList =
        case lists:member(DunId, LogDunIdList) of
            true -> DailyReward;
            false -> FirstReward
        end,
    ProRewardList =
        case lists:member(DunId, LogDunIdList) of
            true -> lists:map(fun({Gid, Gnum}) -> [Gid, Gnum, 1] end, DailyReward);
            false -> lists:map(fun({Gid, Gnum}) -> [Gid, Gnum, 0] end, FirstReward)
        end,
    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(750, RewardList)),
    {ok, Bin} = pt_128:write(12802, {1, DunId, ProRewardList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(NewPlayer, [180], true),
    Sql = io_lib:format("insert into log_godness_dun set pkey=~p,dun_id=~p,reward='~s',time=~p",
        [Player#player.key, DunId, util:term_to_bitstring(RewardList), util:unixtime()]),
    log_proc:log(Sql),
    NewPlayer.

get_data(Layer, Type, SubType, {LeftGodsoulNum,LeftGodnessNum,RightGodsoulNum,RightGodnessNum}) ->
    if
        Type == 1 andalso SubType == 1 ->
            NewLeftGodsoulNum = get_data2(Layer, LeftGodsoulNum),
            NewLeftGodnessNum = LeftGodnessNum,
            NewRightGodsoulNum = RightGodsoulNum,
            NewRightGodnessNum = RightGodnessNum;
        Type == 1 andalso SubType == 2 ->
            NewLeftGodsoulNum = LeftGodsoulNum,
            NewLeftGodnessNum = get_data2(Layer, LeftGodnessNum),
            NewRightGodsoulNum = RightGodsoulNum,
            NewRightGodnessNum = RightGodnessNum;
        Type == 2 andalso SubType == 1 ->
            NewLeftGodsoulNum = LeftGodsoulNum,
            NewLeftGodnessNum = LeftGodnessNum,
            NewRightGodsoulNum = get_data2(Layer, RightGodsoulNum),
            NewRightGodnessNum = RightGodnessNum;
        Type == 2 andalso SubType == 2 ->
            NewLeftGodsoulNum = LeftGodsoulNum,
            NewLeftGodnessNum = LeftGodnessNum,
            NewRightGodsoulNum = RightGodsoulNum,
            NewRightGodnessNum = get_data2(Layer, RightGodnessNum);
        true ->
            NewLeftGodsoulNum = LeftGodsoulNum,
            NewLeftGodnessNum = LeftGodnessNum,
            NewRightGodsoulNum = RightGodsoulNum,
            NewRightGodnessNum = RightGodnessNum
    end,
    {NewLeftGodsoulNum, NewLeftGodnessNum, NewRightGodsoulNum, NewRightGodnessNum}.

get_data2(Layer, NumList) ->
    case lists:keytake(Layer, 1, NumList) of
        false -> [{Layer,1}|NumList];
        {value, {_Layer, OldNum}, Rest} -> [{Layer,OldNum+1}|Rest]
    end.

check_enter(Player, DunId) ->
    case dungeon_util:is_dungeon_godness(DunId) of
        false ->
            true;
        true ->
            case data_dungeon_godness:get(DunId) of
                [] -> true;
                #base_dun_godness{
                    layer = BaseLayer,
                    type = Type,
                    subtype = SubType,
                    limit_lv = LimitLv
                } ->
                    if
                        Player#player.lv < LimitLv -> {false, ?T("等级不足")};
                        true ->
                            StDunGodness = lib_dict:get(?PROC_STATUS_DUN_GODNESS),
                            #st_dun_godness{
                                buy_num = BuyNumList
                                , left_godsoul_num = LeftGodsoulNum
                                , left_godness_num = LeftGodnessNum
                                , right_godsoul_num = RightGodsoulNum
                                , right_godness_num = RightGodnessNum
                            } = StDunGodness,
                            case Type == ?DUN_LEFT of
                                true ->
                                    case SubType of
                                        1 -> %% 低级神魂
                                            case check_dun(BaseLayer, ?DUN_LEFT, ?DUN_GODSOUL, LeftGodsoulNum) of
                                                false -> {false, ?T("挑战次数已满")};
                                                true -> true
                                            end;
                                        2 -> %% 低级神祇
                                            case check_dun(BaseLayer, ?DUN_LEFT, ?DUN_GODSOUL, LeftGodsoulNum) of
                                                true ->
                                                    {false, ?T("请先挑战御魂本，通关指定次数后即可解锁")};
                                                false ->
                                                    case check_dun(BaseLayer, ?DUN_LEFT, ?DUN_GODNESS, LeftGodnessNum) of
                                                        false -> {false, ?T("挑战次数已满")};
                                                        true -> true
                                                    end
                                            end
                                    end;
                                false ->
                                    case lists:keyfind(BaseLayer, 1, BuyNumList) of
                                        false ->
                                            {false, ?T("购买次数后即可挑战")};
                                        _ ->
                                            case SubType of
                                                ?DUN_GODSOUL -> %% 高级神魂
                                                    case check_dun(BaseLayer, ?DUN_RIGHT, ?DUN_GODSOUL, RightGodsoulNum) of
                                                        false -> {false, ?T("挑战次数已满")};
                                                        true -> true
                                                    end;
                                                ?DUN_GODNESS -> %% 高级神祇
                                                    case check_dun(BaseLayer, ?DUN_RIGHT, ?DUN_GODSOUL, RightGodsoulNum) of
                                                        true ->
                                                            {false, ?T("请先挑战御魂本，通关指定次数后即可解锁")};
                                                        false ->
                                                            case check_dun(BaseLayer, ?DUN_RIGHT, ?DUN_GODNESS, RightGodnessNum) of
                                                                false -> {false, ?T("挑战次数已满")};
                                                                true -> true
                                                            end
                                                    end
                                            end
                                    end
                            end
                    end
            end
    end.

check_dun(BaseLayer, Type, SubType, LeftGodsoulNum) ->
    case lists:keyfind(BaseLayer,1,LeftGodsoulNum) of
        false -> true;
        {_Layer, Num} ->
            BaseNum = data_dungeon_godness_condition:get_pass_num(BaseLayer,Type,SubType),
            if
                Num < BaseNum -> true;
                true -> false
            end
    end.


dungeon_info(_Player) ->
    StDungeonGodness = lib_dict:get(?PROC_STATUS_DUN_GODNESS),
    #st_dun_godness{
        buy_num = BuyNum
        , left_godsoul_num = LeftGodsoulNum
        , left_godness_num = LeftGodnessNum
        , right_godsoul_num = RightGodsoulNum
        , right_godness_num = RightGodnessNum
        , left_pass_list = LeftPassList
        , right_pass_list = RightPassList
        , log_dun_id_list = LogDunIdList
    } = StDungeonGodness,
    F0 = fun(Layer) ->
        LeftDunList = get_by_layer_type(Layer, ?DUN_LEFT),
        RightDunList = get_by_layer_type(Layer, ?DUN_RIGHT),
        IsRest = ?IF_ELSE(get_num(Layer, BuyNum) > 0, 1, 0),
        LeftF = fun(#base_dun_godness{dun_id = DunId}) ->
            IsFirst = ?IF_ELSE(lists:member(DunId, LogDunIdList) == true, 0, 1),
            %% 通关并且没有被扫荡为1
            IsSaodang = ?IF_ELSE(lists:member({Layer,DunId}, LeftPassList) == true, 1, 0),
            case lists:member(DunId, get_list(Layer, LeftPassList)) of
                true ->
                    [?DUN_LEFT, DunId, IsFirst, IsSaodang, 2];
                false ->
                    [?DUN_LEFT, DunId, IsFirst, IsSaodang, 1]
            end
        end,
        ProLeftDunList = lists:map(LeftF, LeftDunList),
        RightF = fun(#base_dun_godness{dun_id = DunId}) ->
            IsFirst = ?IF_ELSE(lists:member(DunId, LogDunIdList) == true, 0, 1),
            IsSaodang = ?IF_ELSE(lists:member({Layer,DunId}, RightPassList) == true, 1, 0),
            case lists:member(DunId, get_list(Layer, RightPassList)) of
                true ->
                    [?DUN_RIGHT, DunId, IsFirst, IsSaodang, 2];
                false ->
                    IsChallenge = ?IF_ELSE(IsRest == 1, 1, 0),
                    [?DUN_RIGHT, DunId, IsFirst, IsSaodang, IsChallenge]
            end
        end,
        ProRightDunList = lists:map(RightF, RightDunList),
        BaseLeftGodsoulPassNum = data_dungeon_godness_condition:get_pass_num(Layer, ?DUN_LEFT, ?DUN_GODSOUL),
        BaseLeftGodnessPassNum = data_dungeon_godness_condition:get_pass_num(Layer, ?DUN_LEFT, ?DUN_GODNESS),
        BaseRightGodsoulPassNum = data_dungeon_godness_condition:get_pass_num(Layer, ?DUN_RIGHT, ?DUN_GODSOUL),
        BaseRightGodnessPassNum = data_dungeon_godness_condition:get_pass_num(Layer, ?DUN_RIGHT, ?DUN_GODNESS),
        CostGold = data_dungeon_godness_condition:get_cost(Layer, ?DUN_RIGHT, ?DUN_GODSOUL),
        BaseBuyNum = data_dungeon_godness_condition:get_buy_num(Layer, ?DUN_RIGHT, ?DUN_GODSOUL),
        [
            Layer,
            max(0, BaseLeftGodsoulPassNum - get_num(Layer,LeftGodsoulNum)),
            max(0, BaseLeftGodnessPassNum - get_num(Layer,LeftGodnessNum)),
            max(0, BaseRightGodsoulPassNum - get_num(Layer,RightGodsoulNum)),
            max(0, BaseRightGodnessPassNum - get_num(Layer,RightGodnessNum)),
            CostGold,
            max(0, BaseBuyNum - get_num(Layer,BuyNum)),
            IsRest,
            ProLeftDunList ++ ProRightDunList
        ]
    end,
    lists:map(F0, lists:seq(1, get_max_layer())).

get_num(Layer, NumList) ->
    case lists:keyfind(Layer,1,NumList) of
        false -> 0;
        {_, Num} -> Num
    end.
get_list(Layer, DunIdList) ->
    F = fun({Layer0, DunId}) ->
        if
            Layer == Layer0 -> [DunId];
            true -> []
        end
    end,
    lists:flatmap(F, DunIdList).

get_by_layer_type(Layer,Type) ->
    F = fun(Id) ->
        Base = data_dungeon_godness:get(Id),
        #base_dun_godness{layer = BaseLayer, type = BaseType} = Base,
        if
            Layer == BaseLayer andalso Type == BaseType -> [Base];
            true -> []
        end
    end,
    lists:flatmap(F, data_dungeon_godness:get_all()).

get_max_layer() ->
    data_dungeon_godness:get_max_layer().

buy_reset(Player, Layer) ->
    StDunGodness = lib_dict:get(?PROC_STATUS_DUN_GODNESS),
    #st_dun_godness{
        buy_num = BuyNum
        , right_godsoul_num = RightGodsoulNum
        , right_godness_num = RightGodnessNum
    } = StDunGodness,
    case check_buy_reset(Player, Layer, BuyNum) of
        {fail, Code} ->
            {Code, Player};
        {true, CostGold} ->
            NewPlayer = money:add_no_bind_gold(Player, -CostGold, 748, 0, 0),
            F = fun({Layer0, _Num0}) ->
                Layer /= Layer0
            end,
            NewRightGodnessNum = lists:filter(F, RightGodnessNum),
            NewRightGodsoulNum = lists:filter(F, RightGodsoulNum),
            NewBuyNum =
                case lists:keytake(Layer, 1, BuyNum) of
                    false -> [{Layer, 1} | BuyNum];
                    {value, {Layer, Num}, Rest} -> [{Layer, Num + 1} | Rest]
                end,
            NewStDunGodness =
                StDunGodness#st_dun_godness{
                    buy_num = NewBuyNum
                    , right_godsoul_num = NewRightGodsoulNum
                    , right_godness_num = NewRightGodnessNum
                },
            lib_dict:put(?PROC_STATUS_DUN_GODNESS, NewStDunGodness),
            update_db(NewStDunGodness),
            activity:get_notice(NewPlayer, [180], true),
            {1, NewPlayer}
    end.

check_buy_reset(Player, Layer, BuyNum) ->
    BaseBuyNum = data_dungeon_godness_condition:get_buy_num(Layer, ?DUN_RIGHT, ?DUN_GODSOUL),
    Cost = data_dungeon_godness_condition:get_cost(Layer, ?DUN_RIGHT, ?DUN_GODSOUL),
    case lists:keyfind(Layer, 1, BuyNum) of
        false ->
            case money:is_enough(Player, Cost, gold) of
                false -> {fail, 2};
                true -> {true, Cost}
            end;
        {Layer, Num} ->
            if
                BaseBuyNum >= Num ->
                    case money:is_enough(Player, Cost, gold) of
                        false -> {fail, 2};
                        true -> {true, Cost}
                    end;
                true ->
                    {fail, 5}
            end
    end.



%% 副本扫荡
saodang_dun(Player, DunId, SaodangNum) ->
    StDunGodness = lib_dict:get(?PROC_STATUS_DUN_GODNESS),
    case check_saodang(DunId, SaodangNum, StDunGodness) of
        {fail, Code} -> {Code, [], Player};
        {true, NewStDunGodness} ->
            lib_dict:put(?PROC_STATUS_DUN_GODNESS, NewStDunGodness),
            update_db(NewStDunGodness),
            #base_dun_godness{daily_reward = DailyReward} = data_dungeon_godness:get(DunId),
            F = fun(_N) -> DailyReward end,
            RewardList = lists:flatmap(F, lists:seq(1, SaodangNum)),
            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(749, RewardList)),
            activity:get_notice(Player, [180], true),
            Sql = io_lib:format("insert into log_godness_dun_saodang set pkey=~p, dun_id=~p, saodang_num=~p,reward='~s',time=~p",
                [Player#player.key, DunId, SaodangNum, util:term_to_bitstring(RewardList), util:unixtime()]),
            log_proc:log(Sql),
            {1, util:list_tuple_to_list(RewardList), NewPlayer}
    end.

check_saodang(_DunId, 0, _) -> {fail, 0};
check_saodang(DunId, SaodangNum, StDunGodness) ->
    #base_dun_godness{layer = Layer, type = Type, subtype = SubType} = data_dungeon_godness:get(DunId),
    #st_dun_godness{
        left_godsoul_num = LeftGodsoulNum
        , left_godness_num = LeftGodnessNum
        , right_godsoul_num = RightGodsoulNum
        , right_godness_num = RightGodnessNum
        , left_pass_list = LeftPassList
        , right_pass_list = RightPassList
    } = StDunGodness,
    PassList = LeftPassList ++ RightPassList,
    case lists:member({Layer, DunId}, PassList) of
        false ->
            {fail, 4}; %% 请先通关
        true ->
            BasePassNum = data_dungeon_godness_condition:get_pass_num(Layer, Type, SubType),
            PassNum =
                case Type of
                    1 -> %% 左边
                        case SubType of
                            1 -> %% 神魂
                                get_num(Layer, LeftGodsoulNum);
                            2 -> %% 神祇
                                get_num(Layer, LeftGodnessNum)
                        end;
                    2 -> %% 右边
                        case SubType of
                            1 -> %% 神魂
                                get_num(Layer, RightGodsoulNum);
                            2 -> %% 神祇
                                get_num(Layer, RightGodnessNum)
                        end
                end,
            if
                BasePassNum < PassNum+SaodangNum -> {fail, 3};
                true ->
                    F = fun(_N, {AccLeftGodsoulNum, AccLeftGodnessNum, AccRightGodsoulNum, AccRightGodnessNum}) ->
                        get_data(Layer, Type, SubType, {AccLeftGodsoulNum, AccLeftGodnessNum, AccRightGodsoulNum, AccRightGodnessNum})
                    end,
                    {NewLeftGodsoulNum, NewLeftGodnessNum, NewRightGodsoulNum, NewRightGodnessNum} =
                        lists:foldl(F, {LeftGodsoulNum, LeftGodnessNum, RightGodsoulNum, RightGodnessNum}, lists:seq(1, SaodangNum)),
                    NewStDunGodness =
                        StDunGodness#st_dun_godness{
                            left_godsoul_num = NewLeftGodsoulNum
                            , left_godness_num = NewLeftGodnessNum
                            , right_godsoul_num = NewRightGodsoulNum
                            , right_godness_num = NewRightGodnessNum
                        },
                    {true, NewStDunGodness}
            end
    end.
