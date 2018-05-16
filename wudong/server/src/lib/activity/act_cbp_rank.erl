%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 跃升冲榜
%%% @end
%%% Created : 15. 三月 2018 上午10:21
%%%-------------------------------------------------------------------
-module(act_cbp_rank).
-author("luobaqun").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("daily.hrl").

%% API
-export([
    get_info/1,
    init/1,
    get_act/0,
    get_leave_time/0,
    get_up_reward/2,
    update_cbp/1,
    init_data/0,
    timer/0,
    init_rank/0,
    init_info/0,
    get_state/1,
    update_daily_cbp/2,
    get_daily_info/2,
    logout/1,
    update/1,
    gm_send_mail/0,
    get_rank_info/1
]).


init_data() ->
    init_info(),
    init_rank(),
    ok.


init_rank() ->
    case get_act() of
        [] -> [];
        Base ->
            Sql = io_lib:format("select pkey,act_id,nickname,vip,cbp_change from act_cbp_rank where act_id = ~p and sn=~p", [Base#base_act_cbp_rank.act_id, config:get_server_num()]),
            case db:get_all(Sql) of
                Rows when is_list(Rows) ->
                    F = fun([Pkey, ActId, Nickname, Vip, CbpChange]) ->
                        Ets = #ets_act_cbp_rank{
                            pkey = Pkey,
                            act_id = ActId,
                            nickname = Nickname,
                            vip = Vip,
                            cbp_change = CbpChange
                        },
                        ets:insert(?ETS_ACT_CBP_RANK, Ets)
                        end,
                    lists:foreach(F, Rows);
                _ -> skip
            end
    end.

init_info() ->
    case get_act() of
        [] -> [];
        Base ->
            Sql = io_lib:format("select pkey,act_id,nickname,vip,start_cbp,high_cbp from player_act_cbp_rank where act_id = ~p", [Base#base_act_cbp_rank.act_id]),
            case db:get_all(Sql) of
                Rows when is_list(Rows) ->
                    F = fun([Pkey, _ActId, Nickname, Vip, StartCbp, HighCbp]) ->
                        if
                            HighCbp - StartCbp >= Base#base_act_cbp_rank.cbp_limit ->
                                Ets = #ets_act_cbp_info{
                                    pkey = Pkey,
                                    nickname = Nickname,
                                    vip = Vip,
                                    start_cbp = StartCbp,
                                    high_cbp = HighCbp
                                },
                                ets:insert(?ETS_ACT_CBP_INFO, Ets);
                            true -> skip
                        end
                        end,
                    lists:foreach(F, Rows);
                _ ->
                    []
            end
    end.

logout(Player) ->
    case get_act() of
          []->skip;
        #base_act_cbp_rank{lv_limit=LvLimit} ->
            if
                Player#player.lv > LvLimit ->
                    St = lib_dict:get(?PROC_STATUS_ACT_CBP_RANK),
                    activity_load:dbup_player_act_cbp_rank(St#st_act_cbp_rank{high_cbp = max(Player#player.cbp,St#st_act_cbp_rank.high_cbp)});
                true ->
                    skip
            end
    end,
    ok.

init(Player) ->
    St = activity_load:dbget_player_act_cbp_rank(Player),
    lib_dict:put(?PROC_STATUS_ACT_CBP_RANK, St),
    update(Player),
    Player.

update(Player) ->
    St = lib_dict:get(?PROC_STATUS_ACT_CBP_RANK),
    #st_act_cbp_rank{
        pkey = Pkey,
        act_id = ActId
    } = St,
    case get_act() of
        [] ->
            NewSt = #st_act_cbp_rank{pkey = Pkey, nickname = Player#player.nickname};
        #base_act_cbp_rank{act_id = BaseActId} ->
            if
                BaseActId =/= ActId ->
                    NewSt = #st_act_cbp_rank{pkey = Pkey, act_id = BaseActId, start_cbp = Player#player.highest_cbp, nickname = Player#player.nickname};
                true ->
                    NewSt = St
            end
    end,
    lib_dict:put(?PROC_STATUS_ACT_CBP_RANK, NewSt).
get_info(Player) ->
    case get_act() of
        [] -> {0, 0, 0, 0, 0, 0, 0, [], []};
        Base ->
            if
                Player#player.lv < Base#base_act_cbp_rank.lv_limit ->
                    daily:set_count(?DAILY_ACT_CBP_UP,0);
                true ->skip
            end,
            update_cbp(Player),
            St = lib_dict:get(?PROC_STATUS_ACT_CBP_RANK),
            CbpUp = max(0, St#st_act_cbp_rank.high_cbp - St#st_act_cbp_rank.start_cbp),
           ?DEBUG("St ~p~n",[St]),
            F = fun({Id, Limit, GoodsList}) ->
                case lists:member(Id, St#st_act_cbp_rank.get_list) of
                    false ->
                        if
                            CbpUp >= Limit -> [[Id, 1, Limit, goods:pack_goods(GoodsList)]];
                            true -> [[Id, 0, Limit, goods:pack_goods(GoodsList)]]
                        end;
                    true ->
                        [[Id, 2, Limit, goods:pack_goods(GoodsList)]]
                end
                end,
            UprewardList = lists:flatmap(F, Base#base_act_cbp_rank.up_reward),
            DailyCbpUp = daily:get_count(?DAILY_ACT_CBP_UP),
            F0 = fun(BaseRank) ->
                Name =
                    if BaseRank#base_act_cbp_rank_reward.top == BaseRank#base_act_cbp_rank_reward.down ->
                        case ets:match_object(?ETS_ACT_CBP_RANK, #ets_act_cbp_rank{rank = BaseRank#base_act_cbp_rank_reward.top, _ = '_'}) of
                            [] -> [];
                            Info0 ->
                                Info1 = hd(Info0),
                                Info1#ets_act_cbp_rank.nickname
                        end;
                        true -> []
                    end,

                [BaseRank#base_act_cbp_rank_reward.top,
                    BaseRank#base_act_cbp_rank_reward.down,
                    Name,
                    goods:pack_goods(BaseRank#base_act_cbp_rank_reward.rank_reward),
                    goods:pack_goods(BaseRank#base_act_cbp_rank_reward.daily_reward)]
                 end,
            RankRewardList = lists:map(F0, Base#base_act_cbp_rank.rank_reward),
            MyRank = case ets:lookup(?ETS_ACT_CBP_RANK, Player#player.key) of
                         [] -> 0;
                         [RankInfo] -> RankInfo#ets_act_cbp_rank.rank
                     end,
            {
                get_leave_time(),
                Base#base_act_cbp_rank.lv_limit,
                MyRank,
                CbpUp,
                DailyCbpUp,
                Base#base_act_cbp_rank.cbp_limit,
                Base#base_act_cbp_rank.skip_str,
                UprewardList,
                RankRewardList
            }
    end.

%% 获取达标奖励
get_up_reward(Player, Id) ->
    case get_act() of
        [] -> {0, Player};
        Base ->
            case check_reward(Base, Id) of
                {ok, GoodsList} ->
                    St = lib_dict:get(?PROC_STATUS_ACT_CBP_RANK),
                    NewSt = St#st_act_cbp_rank{get_list = [Id | St#st_act_cbp_rank.get_list]},
                    lib_dict:put(?PROC_STATUS_ACT_CBP_RANK, NewSt),
                    activity_load:dbup_player_act_cbp_rank(NewSt),
                    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(353, GoodsList)),
                    activity:get_notice(Player, [191], true),
                    {1, NewPlayer};
                Res ->
                    {Res, Player}
            end
    end.

check_reward(Base, Id) ->
    St = lib_dict:get(?PROC_STATUS_ACT_CBP_RANK),
            case lists:member(Id, St#st_act_cbp_rank.get_list) of
                false ->
                    case lists:keyfind(Id, 1, Base#base_act_cbp_rank.up_reward) of
                        false -> 0;
                        {Id, Limit, GoodsList} ->
                            CbpUp = max(0, St#st_act_cbp_rank.high_cbp - St#st_act_cbp_rank.start_cbp),
                            if
                                Limit > CbpUp -> 22;
                                true ->
                                    {ok, GoodsList}
                            end
                    end;
                true -> 10
    end.


%% 获取排行信息
get_rank_info(Player) ->
    case get_act() of
        [] -> {0, 0, []};
        _ ->
            AllInfo = ets:tab2list(?ETS_ACT_CBP_RANK),
            F = fun(Info) ->
                [
                    Info#ets_act_cbp_rank.pkey,
                    Info#ets_act_cbp_rank.rank,
                    Info#ets_act_cbp_rank.nickname,
                    Info#ets_act_cbp_rank.vip,
                    Info#ets_act_cbp_rank.cbp_change
                ]
                end,
            List = lists:map(F, AllInfo),
            MyRank =
                case ets:lookup(?ETS_ACT_CBP_RANK, Player#player.key) of
                    [] -> 0;
                    [RankInfo] -> RankInfo#ets_act_cbp_rank.rank
                end,
            St = lib_dict:get(?PROC_STATUS_ACT_CBP_RANK),
            CbpUp = max(0, St#st_act_cbp_rank.high_cbp - St#st_act_cbp_rank.start_cbp),
            {MyRank, CbpUp, List}
    end.

update_daily_cbp(CombatPower,Player)->
    CbpUp = CombatPower - Player#player.highest_cbp,
    daily:increment(?DAILY_ACT_CBP_UP, CbpUp),
    ok.

update_cbp(Player) ->
    case get_act() of
        [] -> skip;
        Base ->
            if
                Player#player.lv < Base#base_act_cbp_rank.lv_limit ->
                    skip;
                true ->
                    St0 = lib_dict:get(?PROC_STATUS_ACT_CBP_RANK),
                    St =
                        if
                            St0#st_act_cbp_rank.start_cbp == 0 ->
                                daily:set_count(?DAILY_ACT_CBP_UP,0),
                                St0#st_act_cbp_rank{start_cbp = Player#player.highest_cbp};
                            true -> St0
                        end,
                    NewDailyCbpUp = daily:get_count(?DAILY_ACT_CBP_UP),
                    NewSt = St#st_act_cbp_rank{high_cbp = max(Player#player.cbp,St#st_act_cbp_rank.high_cbp), is_change = 1},
                    lib_dict:put(?PROC_STATUS_ACT_CBP_RANK, NewSt),
                    Ets = #ets_act_cbp_info{
                        pkey = Player#player.key,
                        nickname = Player#player.nickname,
                        vip = Player#player.vip_lv,
                        start_cbp = NewSt#st_act_cbp_rank.start_cbp,
                        high_cbp = NewSt#st_act_cbp_rank.high_cbp
                    },
                    if
                        NewDailyCbpUp < Base#base_act_cbp_rank.cbp_limit -> skip;
                        true ->
                            updata_cbp_info_ets(Ets)
                    end
            end
    end.


timer() ->
    {{_Y, _Mon, _D}, {H, M, _S}} = erlang:localtime(),
    if
        H == 23 andalso M == 00 ->
            case get_act() of
                [] -> skip;
                Base ->
                    EtsInfo = ets:tab2list(?ETS_ACT_CBP_INFO),
                    F = fun(A, B) ->
                        Achange = A#ets_act_cbp_info.high_cbp - A#ets_act_cbp_info.start_cbp,
                        Bchange = B#ets_act_cbp_info.high_cbp - B#ets_act_cbp_info.start_cbp,
                        if
                            Achange > Bchange -> true;
                            Achange < Bchange -> false;
                            A#ets_act_cbp_info.change_time > B#ets_act_cbp_info.change_time -> false;
                            true -> true
                        end
                    end,
                    SortList = lists:sort(F, EtsInfo),
                    ets:delete_all_objects(?ETS_ACT_CBP_RANK),
                    clean_act_cbp_rank(),
                    Sn = config:get_server_num(),
                    Now = util:unixtime(),
                    F0 =
                        fun(Info, Rank) ->
                            RankInfo = #ets_act_cbp_rank{
                                pkey = Info#ets_act_cbp_info.pkey,
                                rank = Rank,
                                act_id = Base#base_act_cbp_rank.act_id,
                                nickname = Info#ets_act_cbp_info.nickname,
                                vip = Info#ets_act_cbp_info.vip,
                                cbp_change = max(0, Info#ets_act_cbp_info.high_cbp - Info#ets_act_cbp_info.start_cbp) %% 战力变化
                            },
                            log_cbp_rank_final(Info#ets_act_cbp_info.pkey,Info#ets_act_cbp_info.nickname,Rank,Info#ets_act_cbp_info.start_cbp, Info#ets_act_cbp_info.high_cbp,Now),
                            if
                                RankInfo#ets_act_cbp_rank.cbp_change >= Base#base_act_cbp_rank.cbp_limit ->
                                    spawn(fun() -> insert_log(Base, Rank, Info) end),
                                    spawn(fun() ->
                                        send_mail(Base, Rank, Info#ets_act_cbp_info.pkey, Info#ets_act_cbp_info.nickname) end),
                                    ets:insert(?ETS_ACT_CBP_RANK, RankInfo),
                                    activity_load:dbup_act_cbp_rank(RankInfo,Sn),
                                    Rank + 1;
                                true ->
                                    Rank
                            end
                        end,
                    lists:foldl(F0, 1, SortList),
                    ok
            end;
        H == 0 andalso M == 1 ->
            LeaveTime = get_leave_time(),
            if
                LeaveTime < 300 ->
                    ets:delete_all_objects(?ETS_ACT_CBP_RANK),
                    ets:delete_all_objects(?ETS_ACT_CBP_INFO),
                    ets:delete_all_objects(?ETS_ACT_CBP_LOG),
                    clean_act_cbp_rank();
                true ->
                    skip
            end;
        true -> skip
    end.

insert_log(Base, Rank, Info) ->
    Day = activity:get_start_day(data_act_cbp_rank),
    case lists:keyfind(Rank, #base_act_cbp_rank_reward.top, Base#base_act_cbp_rank.rank_reward) of
        [] -> skip;
        BaseReward ->
            if
                BaseReward#base_act_cbp_rank_reward.top == BaseReward#base_act_cbp_rank_reward.down ->
                    LogInfo =
                        #ets_act_cbp_log{
                            key = {Rank, Day, Info#ets_act_cbp_info.pkey},
                            top = Rank,
                            day = Day,
                            pkey = Info#ets_act_cbp_info.pkey,
                            nickname = Info#ets_act_cbp_info.nickname
                        },
                    ets:insert(?ETS_ACT_CBP_LOG, LogInfo);
                true ->
                    skip
            end
    end.

get_daily_info(_Player, Top) ->
    case get_act() of
        [] -> {0, [], []};
        Base ->
            case lists:keyfind(Top, #base_act_cbp_rank_reward.top, Base#base_act_cbp_rank.rank_reward) of
                false -> {0, [], []};
                Base0 ->
                    AllInfo = ets:match_object(?ETS_ACT_CBP_LOG, #ets_act_cbp_log{top = Top, _ = '_'}),
                    RankList = [{X#ets_act_cbp_log.day, X#ets_act_cbp_log.nickname} || X <- AllInfo],
                    DayList = get_day_list(),

                    F = fun(Day) ->
                        case lists:keyfind(Day, 1, RankList) of
                            false -> [{Day, ?T("")}];
                            _ -> []
                        end
                        end,
                    OtherList = lists:flatmap(F, DayList),
                    RankList1 = OtherList ++ RankList,
                    {1, [tuple_to_list(X) || X <- RankList1], goods:pack_goods(Base0#base_act_cbp_rank_reward.daily_reward)}
            end
    end.

get_day_list() ->
    case get_act() of
        [] -> [];
        _Base ->
            LeaveTime = get_leave_time(),
            OpenDay = activity:get_start_day(data_act_cbp_rank),
            LastDay = LeaveTime div ?ONE_DAY_SECONDS,
            lists:seq(1, OpenDay + LastDay)
    end.


gm_send_mail() ->
    case get_act() of
        [] -> skip;
        Base ->
            EtsInfo = ets:tab2list(?ETS_ACT_CBP_INFO),
            F = fun(A, B) ->
                Achange = A#ets_act_cbp_info.high_cbp - A#ets_act_cbp_info.start_cbp,
                Bchange = B#ets_act_cbp_info.high_cbp - B#ets_act_cbp_info.start_cbp,
                if
                    Achange > Bchange -> true;
                    Achange < Bchange -> false;
                    A#ets_act_cbp_info.change_time > B#ets_act_cbp_info.change_time -> false;
                    true -> true
                end
                end,
            SortList = lists:sort(F, EtsInfo),
            ets:delete_all_objects(?ETS_ACT_CBP_RANK),
            clean_act_cbp_rank(),
            Now = util:unixtime(),
            Sn = config:get_server_num(),
            F0 =
                fun(Info, Rank) ->
                    RankInfo = #ets_act_cbp_rank{
                        pkey = Info#ets_act_cbp_info.pkey,
                        rank = Rank,
                        act_id = Base#base_act_cbp_rank.act_id,
                        nickname = Info#ets_act_cbp_info.nickname,
                        vip = Info#ets_act_cbp_info.vip,
                        cbp_change = max(0, Info#ets_act_cbp_info.high_cbp - Info#ets_act_cbp_info.start_cbp) %% 战力变化
                    },
                    log_cbp_rank_final(Info#ets_act_cbp_info.pkey,Info#ets_act_cbp_info.nickname,Rank,Info#ets_act_cbp_info.start_cbp, Info#ets_act_cbp_info.high_cbp,Now),
                    spawn(fun() -> insert_log(Base, Rank, Info) end),
                    spawn(fun() ->
                        send_mail(Base, Rank, Info#ets_act_cbp_info.pkey, Info#ets_act_cbp_info.nickname) end),
                    ets:insert(?ETS_ACT_CBP_RANK, RankInfo),
                    activity_load:dbup_act_cbp_rank(RankInfo,Sn),
                    Rank + 1
                end,
            lists:foldl(F0, 1, SortList),
            ok
    end.

send_mail(Base, Rank, Pkey, Nickname) ->
    F = fun(BaseReward0, BaseInfo) ->
        if
            BaseReward0#base_act_cbp_rank_reward.top =< Rank andalso BaseReward0#base_act_cbp_rank_reward.down >= Rank ->
                BaseReward0;
            true -> BaseInfo
        end
        end,
    case lists:foldl(F, [], Base#base_act_cbp_rank.rank_reward) of
        [] -> skip;
        BaseReward ->
            if BaseReward#base_act_cbp_rank_reward.daily_reward == [] -> skip;
                true ->
                    if
                        Rank == 1 ->
                            ContentNotice = io_lib:format(t_tv:get(308), [t_tv:cl(Nickname, 1)]),
                            notice:add_sys_notice(ContentNotice, 308);
                        true -> skip
                    end,
                    {Title, Content} = t_mail:mail_content(179),
                    Content0 = io_lib:format(Content, [Rank]),
                    mail:sys_send_mail([Pkey], Title, Content0, BaseReward#base_act_cbp_rank_reward.daily_reward)
            end,
            LeaveTime = get_leave_time(),
            if
                BaseReward#base_act_cbp_rank_reward.rank_reward == [] -> skip;
                LeaveTime > ?ONE_DAY_SECONDS -> skip;
                true ->
                    {Title1, Content1} = t_mail:mail_content(180),
                    Content2 = io_lib:format(Content1, [Rank]),
                    mail:sys_send_mail([Pkey], Title1, Content2, BaseReward#base_act_cbp_rank_reward.rank_reward)
            end,
            ok
    end.


get_state(_Player) ->
    case get_act() of
        [] -> -1;
        Base ->
%%            if
%%                Player#player.lv < Base#base_act_cbp_rank.lv_limit -> -1;
%%                true ->
            F = fun(Id) ->
                case check_reward(Base, Id) of
                    {ok, _} -> 1;
                    _ -> 0
                end
                end,
            List = lists:map(F, [Id0 || {Id0, _, _} <- Base#base_act_cbp_rank.up_reward]),
            lists:max(List)
%%            end
    end.

get_act() ->
    case activity:get_work_list(data_act_cbp_rank) of
        [] -> [];
        [Base | _] -> Base
    end.

get_leave_time() ->
    activity:get_leave_time(data_act_cbp_rank).

updata_cbp_info_ets(Ets) ->
    ets:insert(?ETS_ACT_CBP_INFO, Ets).

clean_act_cbp_rank() ->
    db:execute("truncate act_cbp_rank ").


log_cbp_rank_final(Pkey,Nickname,Rank,StartCbp, HighCbp,Time)->
    Sql = io_lib:format("insert into log_cbp_rank_final(pkey,nickname,rank,start_cbp,high_cbp,change_cbp ,time) VALUES(~p,'~s',~p,~p,~p,~p,~p)",[Pkey,Nickname,Rank,StartCbp, HighCbp,max(0,HighCbp -StartCbp), Time]),
    log_proc:log(Sql),
    ok.
