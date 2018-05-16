%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 限时仙装活动
%%% @end
%%% Created : 13. 十一月 2017 14:48
%%%-------------------------------------------------------------------
-module(act_limit_xian).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    init_ets/0,
    init_data/0,
    midnight_refresh/1,
    get_act/0,
    get_act_info/1,
    get_score_info/1,
    op_draw/2,
    recv_score/2
]).

-export([
    get_score_info_center/5,
    get_score_info_center_cast/1,
    update_sort/0,
    add_score/2,
    add_score_cast/1,
    get_notice_state/1,
    timer/0,
    send_mail/4,
    timer_clean/0,
    init_data_center/1,
    init_data_cast/1
]).

-export([gm_timer/0]).

%% 清理掉合服不符合的数据
timer_clean() ->
    case config:is_center_node() of
        false -> skip;
        true ->
            {{_Y, _Mon, _D}, {_H, M, _S}} = erlang:localtime(),
            if
                M rem 20 == 0 -> clean();
                true -> skip
            end
    end.

clean() ->
    EtsList = ets:tab2list(?ETS_LIMIT_XIAN),
    F = fun(#ets_limit_xian{sn = Sn} = Ets) ->
        case center:get_node_by_sn(Sn) of
            false -> ets:delete_object(?ETS_LIMIT_XIAN, Ets);
            _ -> skip
        end
    end,
    lists:map(F, EtsList).

gm_timer() ->
    case config:is_center_node() of
        false -> skip;
        true ->
            case get_act() of
                [] -> skip;
                #base_act_limit_xian{rank_list = BaseRankList} ->
                    timer_cacl(BaseRankList)
            end
    end.

timer() ->
    case config:is_center_node() of
        false -> skip;
        true ->
            {{_Y, _Mon, _D}, {H, M, _S}} = erlang:localtime(),
            if
                H == 23 andalso M == 57 ->
                    case get_act() of
                        [] -> skip;
                        #base_act_limit_xian{open_info = OpenInfo, rank_list = BaseRankList} ->
                            LTime = activity:calc_act_leave_time(OpenInfo),
                            if
                                LTime > 3600 -> skip;
                                true ->
                                    timer_cacl(BaseRankList),
                                    spawn(fun() -> timer:sleep(LTime*1000), ets:delete_all_objects(?ETS_LIMIT_XIAN) end)
                            end
                    end;
                true -> ok
            end
    end.

timer_cacl(BaseRankList) ->
    EtsList = ets:tab2list(?ETS_LIMIT_XIAN),
    F = fun(Ets) ->
        if
            Ets#ets_limit_xian.rank == 0 -> skip;
            Ets#ets_limit_xian.rank > 10 -> skip;
            true ->
                case lists:keyfind(Ets#ets_limit_xian.rank, 1, BaseRankList) of
                    false ->
                        skip;
                    {Rank, _BaseScore, RewardList} ->
                        center:apply_sn(Ets#ets_limit_xian.sn, ?MODULE, send_mail, [Rank, Ets#ets_limit_xian.pkey, RewardList, Ets#ets_limit_xian.score]),
                        log(Ets)
                end
        end
    end,
    lists:map(F, EtsList).

log(#ets_limit_xian{pkey=Pkey, score = Score, rank = Rank}) ->
    Sql = io_lib:format("insert into log_act_limit_xian_center set node='~s', pkey=~p, score=~p, rank=~p, `time`=~p",
        [node(),Pkey,Score,Rank,util:unixtime()]),
    log_proc:log(Sql),
    ok.

send_mail(Rank, Pkey, RewardList, Score) ->
    {Title, Content0} = t_mail:mail_content(148),
    Content = io_lib:format(Content0, [Rank]),
    mail:sys_send_mail([Pkey], Title, Content, RewardList),
    Sql = io_lib:format("insert into log_act_limit_xian_reward set pkey=~p, rank=~p,score=~p,reward='~s',`time`=~p",
        [Pkey,Rank, Score, util:term_to_bitstring(RewardList), util:unixtime()]),
    log_proc:log(Sql),
    ok.

init_data() ->
    case config:is_center_node() of
        true -> skip;
        false ->
            case get_act() of
                [] -> skip;
                #base_act_limit_xian{act_id = BaseActId} ->
                    Sql = io_lib:format("select pkey, score from player_act_limit_xian where act_id=~p", [BaseActId]),
                    case db:get_all(Sql) of
                        Rows when is_list(Rows) ->
                            F = fun([Pkey, Score]) ->
                                Player = shadow_proc:get_shadow(Pkey),
                                {Pkey, Player#player.nickname, Score, Player#player.sn}
                            end,
                            DataList = lists:map(F, Rows),
                            cross_area:apply(?MODULE, init_data_center, [DataList]);
                        _ -> skip
                    end
            end
    end.

init_data_center(DataList) ->
    ?CAST(activity_proc:get_act_pid(), {act_limit_xian, init_data, DataList}).

init_data_cast(DataList) ->
    Now = util:unixtime(),
    F = fun({Pkey, NickName, Score, Sn}) ->
        NewEts = #ets_limit_xian{nickname = NickName, pkey = Pkey, score = Score, sn = Sn, add_time = Now},
        ets:insert(?ETS_LIMIT_XIAN, NewEts)
    end,
    lists:map(F, DataList),
    update_sort(),
    ok.

init_ets() ->
    case config:is_center_node() of
        false ->
            skip;
        true ->
            ets:new(?ETS_LIMIT_XIAN, [{keypos, #ets_limit_xian.pkey} | ?ETS_OPTIONS])
    end.

init(#player{key = Pkey} = Player) ->
    StActLimitXian =
        case player_util:is_new_role(Player) of
            true -> #st_act_limit_xian{pkey = Pkey};
            false -> activity_load:dbget_limit_xian(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_LIMIT_XIAN, StActLimitXian),
    update_limit_xian(Player),
    Player.

update_limit_xian(_Player) ->
    StActLimitXian = lib_dict:get(?PROC_STATUS_LIMIT_XIAN),
    #st_act_limit_xian{
        pkey = Pkey,
        act_id = ActId
    } = StActLimitXian,
    case get_act() of
        [] ->
            NewStActLimitXian = #st_act_limit_xian{pkey = Pkey};
        #base_act_limit_xian{act_id = BaseActId} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewStActLimitXian =
                        #st_act_limit_xian{
                            pkey = Pkey,
                            act_id = BaseActId,
                            op_time = Now
                        };
                true ->
                    NewStActLimitXian = StActLimitXian
            end
    end,
    lib_dict:put(?PROC_STATUS_LIMIT_XIAN, NewStActLimitXian).

%% 凌晨重置不操作数据库
midnight_refresh(Player) ->
    update_limit_xian(Player).

get_act() ->
    case activity:get_work_list(data_act_limit_xian) of
        [] -> [];
        [Base | _] -> Base
    end.

get_act_info(_Player) ->
    case get_act() of
        [] ->
            {0, 0, 0, 0, [], []};
        #base_act_limit_xian{
            open_info = OpenInfo,
            show_id = ShowId,
            one_cost = OneCost,
            ten_cost = TenCost,
            rank_list = RankList,
            score_list = ScoreList
        } ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            St = lib_dict:get(?PROC_STATUS_LIMIT_XIAN),
            #st_act_limit_xian{
                score = Score,
                recv_list = RecvList
            } = St,
            F = fun({Rank, _BaseScore, RewardList}) ->
                [Rank, util:list_tuple_to_list(RewardList)]
            end,
            ProRankList = lists:map(F, RankList),
            F0 = fun({_ScoreMin, ScoreMax, RewardList}) ->
                case lists:member(ScoreMax, RecvList) of
                    true ->
                        [2, ScoreMax, util:list_tuple_to_list(RewardList)];
                    false ->
                        if
                            Score >= ScoreMax -> [1, ScoreMax, util:list_tuple_to_list(RewardList)];
                            true -> [0, ScoreMax, util:list_tuple_to_list(RewardList)]
                        end
                end
            end,
            ProRecvList = lists:map(F0, ScoreList),
            {LTime, ShowId, OneCost, TenCost, ProRankList, ProRecvList}
    end.

get_score_info(Player) ->
    St = lib_dict:get(?PROC_STATUS_LIMIT_XIAN),
    #st_act_limit_xian{score = MyScore} = St,
    cross_area:apply(?MODULE, get_score_info_center, [Player#player.key, Player#player.nickname, Player#player.sn, Player#player.sid, MyScore]).

get_score_info_center(Pkey, Nickname, Sn, Sid, MyScore) ->
    ?CAST(activity_proc:get_act_pid(), {act_limit_xian, get_score_info_center, [Pkey, Nickname, Sn, Sid, MyScore]}).

get_score_info_center_cast([Pkey, Nickname, Sn, Sid, MyScore]) ->
    case get_act() of
        [] ->
            ok;
        #base_act_limit_xian{rank_list = BaseRankList} ->
            EtsList = ets:tab2list(?ETS_LIMIT_XIAN),
            F = fun(#ets_limit_xian{rank = Rank} = Ets0) ->
                ?IF_ELSE(Rank > 0, [Ets0], [])
            end,
            NewEtsList = lists:flatmap(F, EtsList),
            F2 = fun({BaseRank, BaseScore, _BaseReward}) ->
                case lists:keyfind(BaseRank, #ets_limit_xian.rank, NewEtsList) of
                    false ->
                        [BaseRank, 0, <<>>, 0, BaseScore];
                    #ets_limit_xian{sn = Sn0, nickname = NickName0, score = Score0} ->
                        [BaseRank, Sn0, NickName0, Score0, BaseScore]
                end
            end,
            ProList = lists:map(F2, BaseRankList),
            case ets:lookup(?ETS_LIMIT_XIAN, Pkey) of
                [] ->
                    Ets = #ets_limit_xian{pkey = Pkey, nickname = Nickname, sn = Sn, score = MyScore},
                    ets:insert(?ETS_LIMIT_XIAN, Ets),
                    MyRank = 0;
                [Ets] ->
                    MyRank = Ets#ets_limit_xian.rank
            end,
            {ok, Bin} = pt_439:write(43937, {MyRank, Ets#ets_limit_xian.score, ProList}),
            server_send:send_to_sid(Sid, Bin),
            ok
    end.

update_sort() ->
    case get_act() of
        [] -> skip;
        #base_act_limit_xian{rank_list = BaseRankList} ->
            EtsList = ets:tab2list(?ETS_LIMIT_XIAN),
            F = fun(#ets_limit_xian{score = S1, add_time = AddTime1}, #ets_limit_xian{score = S2, add_time = AddTime2}) ->
                S1 > S2 orelse S1 == S2 andalso AddTime1 < AddTime2
            end,
            NewEtsList = lists:sort(F, EtsList),
            set_rank(NewEtsList, [], 1, BaseRankList)
    end.

set_rank([], AccList, _Rank, _BaseRankList) ->
    AccList;

set_rank([Ets | EtsList] = OldEtsList, AccList, Rank, BaseRankList) ->
    #ets_limit_xian{score = Score} = Ets,
    BaseScore =
        case lists:keyfind(Rank, 1, BaseRankList) of
            false -> 0;
            {Rank, BaseScore0, _BaseRewardList} ->
                BaseScore0
        end,
    if
        Rank > 10 ->
            F = fun(Ets00) ->
                NewEts = Ets00#ets_limit_xian{rank = 0},
                ets:insert(?ETS_LIMIT_XIAN, NewEts)
            end,
            lists:map(F, OldEtsList);
        Score >= BaseScore ->
            NewEts = Ets#ets_limit_xian{rank = Rank},
            ets:insert(?ETS_LIMIT_XIAN, NewEts),
            set_rank(EtsList, [NewEts | AccList], Rank + 1, BaseRankList);
        true ->
            set_rank(OldEtsList, AccList, Rank + 1, BaseRankList)
    end.

op_draw(Player, DrawNum) ->
    case get_act() of
        [] ->
            {0, [], Player};
        #base_act_limit_xian{open_info = OpenInfo, reward_list = BaseRewardList} = Base ->
            case check(Player, DrawNum, Base) of
                {fail, Code} ->
                    {Code, [], Player};
                {true, Cost, RewardList} ->
                    LeaveTime = activity:calc_act_leave_time(OpenInfo),
                    St = lib_dict:get(?PROC_STATUS_LIMIT_XIAN),
                    #st_act_limit_xian{score = Score} = St,
                    NewSt = St#st_act_limit_xian{score = Score+DrawNum, op_time = util:unixtime()},
                    lib_dict:put(?PROC_STATUS_LIMIT_XIAN, NewSt),
                    activity_load:dbup_limit_xian(NewSt),
                    if
                        LeaveTime < 290 -> skip; %% 提前5min结束不记录积分
                        true -> cross_area:apply(?MODULE, add_score, [Player#player.key, DrawNum])
                    end,
                    NPlayer = money:add_no_bind_gold(Player, -Cost, 731, 0, 0),
                    GiveGoodsList = goods:make_give_goods_list(732, RewardList),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                    {Gid, _Gnum, _OnePower, _TenPower} = hd(BaseRewardList),
                    case lists:keyfind(Gid, 1, RewardList) of
                        false -> skip;
                        _ -> notice_sys:add_notice(act_limit_xian, [Player#player.nickname, Gid])
                    end,
                    Sql = io_lib:format("insert into log_act_limit_xian set pkey=~p,cost=~p,`get`='~s',num=~p,time=~p",
                        [Player#player.key, Cost, util:term_to_bitstring(RewardList), DrawNum, util:unixtime()]),
                    log_proc:log(Sql),
                    {1, util:list_tuple_to_list(RewardList), NewPlayer}
            end
    end.

add_score(Pkey, DrawNum) ->
    ?CAST(activity_proc:get_act_pid(), {act_limit_xian, add_score, [Pkey, DrawNum]}).

add_score_cast([Pkey, DrawNum]) ->
    case ets:lookup(?ETS_LIMIT_XIAN, Pkey) of
        [] ->
            skip;
        [Ets] ->
            NewEts = Ets#ets_limit_xian{score = Ets#ets_limit_xian.score + DrawNum, add_time = util:unixtime()},
            ets:insert(?ETS_LIMIT_XIAN, NewEts),
            update_sort()
    end.

check(Player, DrawNum, Base) ->
    #base_act_limit_xian{one_cost = OneCost, ten_cost = TenCost, reward_list = BaseRewardList} = Base,
    case DrawNum of
        1 ->
            case money:is_enough(Player, OneCost, gold) of
                true ->
                    F = fun({Gid, Gnum, OnePower, _TenPower}) ->
                        {{Gid, Gnum}, OnePower}
                    end,
                    NewBaseRewardList = lists:map(F, BaseRewardList),
                    Reward = util:list_rand_ratio(NewBaseRewardList),
                    {true, OneCost, [Reward]};
                false ->
                    {fail, 2} %% 元宝不足
            end;
        10 ->
            case money:is_enough(Player, TenCost, gold) of
                true ->
                    F = fun({Gid, Gnum, _OnePower, TenPower}) ->
                        {{Gid, Gnum}, TenPower}
                    end,
                    NewBaseRewardList = lists:map(F, BaseRewardList),
                    F0 = fun(_N) ->
                        util:list_rand_ratio(NewBaseRewardList)
                    end,
                    RewardList = lists:map(F0, lists:seq(1,10)),
                    {true, TenCost, RewardList};
                false ->
                    {fail, 2} %% 元宝不足
            end
    end.

recv_score(Player, RecvScore) ->
    case get_act() of
        [] ->
            {0, Player};
        #base_act_limit_xian{score_list = BaseScoreList} ->
            St = lib_dict:get(?PROC_STATUS_LIMIT_XIAN),
            #st_act_limit_xian{recv_list = RecvList, score = Score} = St,
            RecvFlag = lists:member(RecvScore, RecvList),
            if
                Score < RecvScore -> {0, Player};
                RecvFlag == true -> {0, Player};
                true ->
                    case lists:keyfind(RecvScore, 2, BaseScoreList) of
                        false -> {0, Player};
                        {_ScoreMin, RecvScore, RewardList} ->
                            NewSt = St#st_act_limit_xian{recv_list = [RecvScore|RecvList], op_time = util:unixtime()},
                            lib_dict:put(?PROC_STATUS_LIMIT_XIAN, NewSt),
                            activity_load:dbup_limit_xian(NewSt),
                            GiveGoodsList = goods:make_give_goods_list(733, RewardList),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            {1, NewPlayer}
                    end
            end
    end.

get_notice_state(_Player) ->
    case get_act() of
        [] -> -1;
        #base_act_limit_xian{act_info = ActInfo} ->
            Args = activity:get_base_state(ActInfo),
            {0, Args}
    end.