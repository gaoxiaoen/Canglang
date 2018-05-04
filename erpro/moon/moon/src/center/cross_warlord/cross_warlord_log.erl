%% --------------------------------------------------------------------
%% 武神坛日志进程
%% @author shawn 
%% @end
%% --------------------------------------------------------------------
-module(cross_warlord_log).
-export([
        start_link/0
        ,add_log/1
        ,match_over/1
        ,clean/0
        ,clean/1
        ,query_role/1
        ,get_role_info/1
        ,get_page/1
        ,get_status/0
        ,make_bet/1
        ,make_top_32/0
        ,make_16_bet/0
        ,bet_team/6
        ,bet_16_team/19
        ,bet_top_3/6
        ,get_bet_team/1
        ,get_bet_team_16/1
        ,get_bet_top/1
        ,report/2
        ,do_send_bet_mail/5
        ,do_send_top_mail/5
        ,do_send_bet_16_mail/5
        ,get_bet_log/1
        ,get_bet_switch/0
        ,close_bet/0
        ,open_bet/0
        ,pack_to_all/1
        ,add_team/1
        ,calc_16_bet/0
    ]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-behaviour(gen_server).

-include("common.hrl").
-include("role.hrl").
-include("cross_warlord.hrl").
-include("mail.hrl").

-record(state, {
        tmp_log = []
        ,last_fight = 0
        ,length = 0
        ,ranks = [] %% 
        ,switch = ?true
    }).

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Pid = pid()
%% Error = string()
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

add_log(Log) ->
    gen_server:cast(?MODULE, {add_log, Log}).

match_over(Type) ->
    gen_server:cast(?MODULE, {match_over, Type}).

clean() ->
    gen_server:cast(?MODULE, clean).

clean(bet) ->
    gen_server:cast(?MODULE, clean_bet);
clean(top3) ->
    gen_server:cast(?MODULE, clean_top_32);
clean(bet16) ->
    gen_server:cast(?MODULE, clean_bet_16).

get_bet_team(Label) ->
    gen_server:call(?MODULE, {get_bet_team, Label}).

get_bet_team_16(Label) ->
    gen_server:call(?MODULE, {get_bet_team_16, Label}).

get_bet_top(Label) ->
    gen_server:call(?MODULE, {get_bet_top, Label}).

get_bet_switch() ->
    gen_server:call(?MODULE, get_bet_switch).

close_bet() ->
    gen_server:cast(?MODULE, close_bet).

open_bet() ->
    gen_server:cast(?MODULE, open_bet).

add_team(Team) ->
    gen_server:cast(?MODULE, {add_team, Team}).

query_role({Rid, SrvId}) ->
    ets:lookup(ets_cross_warlord_log, {Rid, SrvId}).

get_role_info(Id) ->
    gen_server:call(?MODULE, {get_role_info, Id}).

get_page(Page) ->
    gen_server:call(?MODULE, {get_page, Page}).

get_status() ->
    gen_server:call(?MODULE, get_status).

make_bet(Quality) ->
    gen_server:cast(?MODULE, {make_bet, Quality}).

make_16_bet() ->
    gen_server:cast(?MODULE, make_16_bet).

make_top_32() ->
    gen_server:cast(?MODULE, make_top_32).

get_bet_log({Rid, SrvId}) ->
    case ets:lookup(ets_cross_warlord_bet, {Rid, SrvId}) of
        [#cross_warlord_bet{top_3 = Top3, bet_log = BetLog, bet_16 = Bet16}] ->
            {ok, Top3, BetLog, Bet16};
        [] ->
            {ok, [], [], []};
        _ ->
            ?ERR("查询角色竞猜日志错误"),
            false
    end.

bet_team({Rid, SrvId}, Quality, Label, Seq, TeamCode, Coin) ->
    case ets:lookup(ets_cross_warlord_bet, {Rid, SrvId}) of
        [RoleBet = #cross_warlord_bet{bet_log = BetLog}] ->
            case find_bet_log(BetLog, Quality, Label, Seq) of
                {ok, _} ->
                    ?DEBUG("角色[Rid:~w, SrvId:~s]已经竞猜过该场",[Rid, SrvId]),
                    {false, ?L(<<"您已经竞猜过该场比赛">>)};
                _ ->
                    gen_server:call(?MODULE, {bet_team, RoleBet, Quality, Label, Seq, TeamCode, Coin})
            end;
        [] ->
            RoleBet = #cross_warlord_bet{id = {Rid, SrvId}},
            gen_server:call(?MODULE, {bet_team, RoleBet, Quality, Label, Seq, TeamCode, Coin});
        _ ->
            ?ERR("错误的角色竞猜数据"),
            {false, ?L(<<"您已经竞猜过该场比赛">>)}
    end.

bet_top_3({Rid, SrvId}, Label, TeamCode1, TeamCode2, TeamCode3, Coin) ->
    case ets:lookup(ets_cross_warlord_bet, {Rid, SrvId}) of
        [RoleBet = #cross_warlord_bet{top_3 = Top3}] ->
            case Top3 of
                TopList when is_list(TopList) ->
                    case lists:keyfind(Label, 1, TopList) of
                        false ->
                            gen_server:call(?MODULE, {bet_top_3, RoleBet, Label, TeamCode1, TeamCode2, TeamCode3, Coin});
                        _ ->
                            ?DEBUG("角色[Rid:~w, SrvId:~s]已经竞猜过前三甲",[Rid, SrvId]),
                            {false, ?L(<<"您已经竞猜过前三甲,无法再次竞猜">>)}
                    end;
                _ ->
                    ?DEBUG("角色[Rid:~w, SrvId:~s]已经竞猜过前三甲",[Rid, SrvId]),
                    {false, ?L(<<"您已经竞猜过前三甲,无法再次竞猜">>)}
            end;
        [] ->
            RoleBet = #cross_warlord_bet{id = {Rid, SrvId}},
            gen_server:call(?MODULE, {bet_top_3, RoleBet, Label, TeamCode1, TeamCode2, TeamCode3, Coin});
        _ ->
            ?ERR("错误的角色竞猜数据"),
            {false, ?L(<<"您已经竞猜过前三甲, 无法再次竞猜">>)}
    end.

bet_16_team({Rid, SrvId}, Label, TeamCode1, TeamCode2, TeamCode3, TeamCode4, TeamCode5, TeamCode6, TeamCode7, TeamCode8, TeamCode9, TeamCode10, TeamCode11, TeamCode12, TeamCode13, TeamCode14, TeamCode15, TeamCode16, Coin) ->
    case ets:lookup(ets_cross_warlord_bet, {Rid, SrvId}) of
        [RoleBet = #cross_warlord_bet{bet_16 = Bet16}] ->
            case Bet16 of
                Bet16List when is_list(Bet16List) ->
                    case lists:keyfind(Label, 1, Bet16List) of
                        false ->
                            gen_server:call(?MODULE, {bet_16_team, RoleBet, Label, [{1, TeamCode1}, {2, TeamCode2}, {3, TeamCode3}, {4, TeamCode4}, {5, TeamCode5}, {6, TeamCode6}, {7, TeamCode7}, {8, TeamCode8}, {9, TeamCode9}, {10, TeamCode10}, {11, TeamCode11}, {12, TeamCode12}, {13, TeamCode13}, {14, TeamCode14}, {15, TeamCode15}, {16, TeamCode16}], Coin});
                        _ ->
                            ?DEBUG("角色[Rid:~w, SrvId:~s]已经竞猜过16强",[Rid, SrvId]),
                            {false, ?L(<<"您已经竞猜过16强,无法再次竞猜">>)}
                    end;
                _ ->
                    ?DEBUG("角色[Rid:~w, SrvId:~s]已经竞猜过16强",[Rid, SrvId]),
                    {false, ?L(<<"您已经竞猜过16强,无法再次竞猜">>)}
            end;
        [] ->
            RoleBet = #cross_warlord_bet{id = {Rid, SrvId}},
            gen_server:call(?MODULE, {bet_16_team, RoleBet, Label, [{1, TeamCode1}, {2, TeamCode2}, {3, TeamCode3}, {4, TeamCode4}, {5, TeamCode5}, {6, TeamCode6}, {7, TeamCode7}, {8, TeamCode8}, {9, TeamCode9}, {10, TeamCode10}, {11, TeamCode11}, {12, TeamCode12}, {13, TeamCode13}, {14, TeamCode14}, {15, TeamCode15}, {16, TeamCode16}], Coin});
        _ ->
            ?ERR("错误的角色竞猜数据"),
            {false, ?L(<<"您已经竞猜过16强,无法再次竞猜">>)}
    end.

%% 为空的胜者不进行判断
report(_, []) -> skip;
report(?cross_warlord_quality_top_8, [#cross_warlord_team{team_code = TeamCode, team_label = Label, team_group_8 = TeamGroup8}]) ->
    gen_server:cast(?MODULE, {report, ?cross_warlord_quality_top_8, Label, TeamGroup8, TeamCode});
report(?cross_warlord_quality_top_4_1, [#cross_warlord_team{team_code = TeamCode, team_label = Label, team_group_4 = TeamGroup4}]) ->
    gen_server:cast(?MODULE, {report, ?cross_warlord_quality_top_4_1, Label, TeamGroup4, TeamCode});
report(?cross_warlord_quality_top_4_2, [#cross_warlord_team{team_code = TeamCode, team_label = Label, team_group_4 = TeamGroup4}]) ->
    gen_server:cast(?MODULE, {report, ?cross_warlord_quality_top_4_2, Label, TeamGroup4, TeamCode});
report(?cross_warlord_quality_semi_final, [#cross_warlord_team{team_code = TeamCode, team_label = Label}]) ->
    gen_server:cast(?MODULE, {report, ?cross_warlord_quality_semi_final, Label, 1, TeamCode});
report(?cross_warlord_quality_final, [#cross_warlord_team{team_code = TeamCode, team_label = Label}]) ->
    gen_server:cast(?MODULE, {report, ?cross_warlord_quality_final, Label, 1, TeamCode});
report(_, _) -> skip.

%% 统计16强竞猜结算
calc_16_bet() ->
    gen_server:cast(?MODULE, calc_16_bet).

do_calc_bet([], _Quality, _Label, _Seq, _TeamCode) -> ok;
do_calc_bet([BetRole = #cross_warlord_bet{id = {Rid, SrvId}, bet_log = BetLog} | T], Quality, Label, Seq, TeamCode) ->
    case find_bet_log(BetLog, Quality, Label, Seq) of
        false ->
            do_calc_bet(T, Quality, Label, Seq, TeamCode);
        %% 战斗类型, 战区, 场次 队伍编号相同则判断发奖励 wincoin此时必须为0 保证第一次发
        {ok, {Quality, Label, Seq, Name1, Name2, TeamCode, TeamName, Coin, Rate, 0}} ->
            WinCoin = round(Coin * Rate / 100),
            NewBet = {Quality, Label, Seq, Name1, Name2, TeamCode, TeamName, Coin, Rate, WinCoin}, 
            NewBetLog = modify_bet_log(BetLog, NewBet, []),
            spawn(fun() -> send_bet_mail(Rid, SrvId, TeamName, Coin, WinCoin) end),
            update_bet(all, BetRole#cross_warlord_bet{bet_log = NewBetLog}),
            do_calc_bet(T, Quality, Label, Seq, TeamCode);
        _ -> %% 未中奖, 或者已经发奖过的
            do_calc_bet(T, Quality, Label, Seq, TeamCode)
    end.

%% 冠军场次结算
do_calc_bet_final([], _Quality, _Label, _Seq, _TeamCode1, _TeamCode2, _TeamCode3) -> ok;
do_calc_bet_final([BetRole = #cross_warlord_bet{id = {Rid, SrvId}, bet_log = BetLog} | T], Quality, Label, Seq, TeamCode1, TeamCode2, TeamCode3) ->
    case find_bet_log(BetLog, Quality, Label, Seq) of
        false ->
            case do_calc_final(BetRole, Label, TeamCode1, TeamCode2, TeamCode3) of
                {ok, NewBetRole} ->
                    update_bet(all, NewBetRole);
                _ -> skip
            end,
            do_calc_bet_final(T, Quality, Label, Seq, TeamCode1, TeamCode2, TeamCode3);
        {ok, {Quality, Label, Seq, Name1, Name2, TeamCode1, TeamName, Coin, Rate, 0}} ->
            WinCoin = round(Coin * Rate / 100),
            NewBet = {Quality, Label, Seq, Name1, Name2, TeamCode1, TeamName, Coin, Rate, WinCoin}, 
            NewBetLog = modify_bet_log(BetLog, NewBet, []),
            spawn(fun() -> send_bet_mail(Rid, SrvId, TeamName, Coin, WinCoin) end),
            BetRole1 = BetRole#cross_warlord_bet{bet_log = NewBetLog},
            NewBetRole = case do_calc_final(BetRole1, Label, TeamCode1, TeamCode2, TeamCode3) of
                {ok, NewBetRole2} -> NewBetRole2;
                _ -> BetRole1
            end,
            update_bet(all, NewBetRole),
            do_calc_bet_final(T, Quality, Label, Seq, TeamCode1, TeamCode2, TeamCode3);
        _ -> %% 未中奖
            case do_calc_final(BetRole, Label, TeamCode1, TeamCode2, TeamCode3) of
                {ok, NewBetRole} ->
                    update_bet(all, NewBetRole);
                _ -> skip
            end,
            do_calc_bet_final(T, Quality, Label, Seq, TeamCode1, TeamCode2, TeamCode3)
    end.

do_calc_final(BetRole = #cross_warlord_bet{id = {Rid, SrvId}, top_3 = Top3}, Label, TeamCode1, TeamCode2, TeamCode3) ->
    case lists:keyfind(Label, 1, Top3) of
        {Label, TeamCode1, TeamName1, TeamCode2, TeamName2, TeamCode3, TeamName3, Coin, 0} -> 
            WinCoin = round(Coin * 10),
            NewTop3 = lists:keyreplace(Label, 1, Top3, {Label, TeamCode1, TeamName1, TeamCode2, TeamName2, TeamCode3, TeamName3, Coin, WinCoin}),
            spawn(fun() -> send_top_mail(Rid, SrvId, Label, Coin, WinCoin) end),
            {ok, BetRole#cross_warlord_bet{top_3 = NewTop3}};
        _ ->
            skip
    end.

do_calc_16_bet([], _SkyTeam, _LandTeam) -> ok;
do_calc_16_bet([BetRole = #cross_warlord_bet{id = {Rid, SrvId}, bet_16 = Bet16} | T], SkyTeam, LandTeam) ->
    {Flag, NewBet16} = case lists:keyfind(?cross_warlord_label_sky, 1, Bet16) of
        {?cross_warlord_label_sky, BetTeam1, Coin1, 0} ->
            %% 玩家投注
            Bsky = [TeamCode || {_, TeamCode, _} <- BetTeam1],
            case Bsky -- SkyTeam of
                [] ->
                    WinCoin1 = round(Coin1 * 20),
                    spawn(fun() -> send_bet_16_mail(Rid, SrvId, ?cross_warlord_label_sky, Coin1, WinCoin1) end),
                    {?true, lists:keyreplace(?cross_warlord_label_sky, 1, Bet16, {?cross_warlord_label_sky, BetTeam1, Coin1, WinCoin1})};
                _ -> {?false, Bet16}
            end;
        _ -> {?false, Bet16}
    end,
    {Flag2, NBet16} = case lists:keyfind(?cross_warlord_label_land, 1, NewBet16) of
        {?cross_warlord_label_land, BetTeam2, Coin2, 0} ->
            Bland = [TeamCode || {_, TeamCode, _} <- BetTeam2],
            case Bland -- LandTeam of
                [] -> 
                    WinCoin2 = round(Coin2 * 20),
                    spawn(fun() -> send_bet_16_mail(Rid, SrvId, ?cross_warlord_label_land, Coin2, WinCoin2) end),
                    {?true, lists:keyreplace(?cross_warlord_label_land, 1, NewBet16, {?cross_warlord_label_land, BetTeam2, Coin2, WinCoin2})};
                _ ->
                    {?false, NewBet16}
            end;
        _ ->
            {?false, NewBet16}
    end,
    case Flag =:= ?false andalso Flag2 =:= ?false of
        true ->
            do_calc_16_bet(T, SkyTeam, LandTeam);
        false ->
            update_bet(all, BetRole#cross_warlord_bet{bet_16 = NBet16}),
            do_calc_16_bet(T, SkyTeam, LandTeam)
    end.

send_bet_mail(Rid, SrvId, TeamName, Coin, WinCoin) ->
    c_mirror_group:cast(node, SrvId, cross_warlord_log, do_send_bet_mail, [Rid, SrvId, TeamName, Coin, WinCoin]).

do_send_bet_mail(Rid, SrvId, TeamName, Coin, WinCoin) ->
    Subject = ?L(<<"武神坛幸运竞猜">>),
    Content = util:fbin(?L(<<"恭喜您的竞猜的队伍【~s】在比赛中胜出, 本金~w金币, 赢得奖金~w绑定金币">>), [TeamName, Coin, WinCoin - Coin]),
    mail_mgr:deliver({Rid, SrvId}, {Subject, Content, [{?mail_coin_bind, WinCoin - Coin}, {?mail_coin, Coin}], []}).

send_top_mail(Rid, SrvId, Label, Coin, WinCoin) ->
    c_mirror_group:cast(node, SrvId, cross_warlord_log, do_send_top_mail, [Rid, SrvId, Label, Coin, WinCoin]).

do_send_top_mail(Rid, SrvId, Label, Coin, WinCoin) ->
    Subject = ?L(<<"武神坛前三甲竞猜">>),
    Fun = fun(?cross_warlord_label_sky) -> ?L(<<"天龙">>);
        (?cross_warlord_label_land) -> ?L(<<"玄虎">>)
    end,
    Content = util:fbin(?L(<<"恭喜您竞猜中~s榜前三甲, 本金~w金币, 赢得奖金~w绑定金币">>), [Fun(Label), Coin, WinCoin - Coin]),
    mail_mgr:deliver({Rid, SrvId}, {Subject, Content, [{?mail_coin_bind, WinCoin - Coin}, {?mail_coin, Coin}], []}).

send_bet_16_mail(Rid, SrvId, Label, Coin, WinCoin) ->
    c_mirror_group:cast(node, SrvId, cross_warlord_log, do_send_bet_16_mail, [Rid, SrvId, Label, Coin, WinCoin]).

do_send_bet_16_mail(Rid, SrvId, Label, Coin, WinCoin) ->
    Subject = ?L(<<"武神坛16强竞猜">>),
    Fun = fun(?cross_warlord_label_sky) -> ?L(<<"天龙">>);
        (?cross_warlord_label_land) -> ?L(<<"玄虎">>)
    end,
    Content = util:fbin(?L(<<"恭喜您竞猜中~s榜16强, 本金~w金币, 赢得奖金~w绑定金币">>), [Fun(Label), Coin, WinCoin - Coin]),
    mail_mgr:deliver({Rid, SrvId}, {Subject, Content, [{?mail_coin_bind, WinCoin - Coin}, {?mail_coin, Coin}], []}).

find_top_team(Label, TeamCode) ->
    case cross_warlord_mgr:get_team(?cross_warlord_quality_final, Label) of
        [#cross_warlord_team{team_code = TeamCode1}, #cross_warlord_team{team_code =TeamCode2}] ->
            if
                TeamCode =:= TeamCode1 ->
                    case cross_warlord_mgr:get_team(?cross_warlord_quality_third_place, Label) of
                        [#cross_warlord_team{team_code = TeamCode3}] ->
                            {TeamCode1, TeamCode2, TeamCode3};
                        _ ->
                            false
                    end;
                TeamCode =:= TeamCode2 ->
                    case cross_warlord_mgr:get_team(?cross_warlord_quality_third_place, Label) of
                        [#cross_warlord_team{team_code = TeamCode3}] ->
                            {TeamCode2, TeamCode1, TeamCode3};
                        _ ->
                            false
                    end;
                true ->
                    ?ERR("决赛局出现非决赛资格的人参与"),
                    false
            end;
        _ ->
            false
    end.

find_16_team() ->
    Sky = case cross_warlord_mgr:get_team(?cross_warlord_quality_top_16, ?cross_warlord_label_sky) of
        TeamList when length(TeamList) =:= 16 ->
            [TeamCode || #cross_warlord_team{team_code = TeamCode} <- TeamList];
        _ ->
            false
    end,
    Land = case cross_warlord_mgr:get_team(?cross_warlord_quality_top_16, ?cross_warlord_label_land) of
        TeamList2 when length(TeamList2) =:= 16 ->
            [TeamCode || #cross_warlord_team{team_code = TeamCode} <- TeamList2];
        _ ->
            false
    end,
    {Sky, Land}.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% Func: init/1
%% Returns: {ok, StateName, StateData}          |
%%          {ok, StateName, StateData, Timeout} |
%%          ignore                              |
%%          {stop, StopReason}
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ets:new(ets_cross_warlord_log, [named_table, public, duplicate_bag, {keypos, #cross_warlord_log.id}]),
    ets:new(ets_cross_warlord_bet, [named_table, public, set, {keypos, #cross_warlord_bet.id}]),
    dets:open_file(dets_cross_warlord_log, [{file, "../var/cross_warlord_log.dets"}, {keypos, #cross_warlord_log.id}, {type, duplicate_bag}]),
    dets:open_file(dets_cross_warlord_bet, [{file, "../var/cross_warlord_bet.dets"}, {keypos, #cross_warlord_bet.id}, {type, set}]),
    load_rank(),
    erlang:send_after(10 * 1000, self(), init_rank),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% 获取角色所在队伍,已经在排行榜排名
handle_call({get_role_info, Id}, _From, State = #state{ranks = Ranks}) ->
    Reply = case ets:lookup(ets_cross_warlord_role, Id) of
        [#cross_warlord_role{team_code = TeamCode}] ->
            case ets:lookup(ets_cross_warlord_team, TeamCode) of
                [#cross_warlord_team{team_member = TeamMem, team_name = TeamName}] ->
                    Rank = case lists:keyfind(TeamCode, #cross_warlord_rank.team_code, Ranks) of
                        #cross_warlord_rank{team_rank = R} -> R;
                        _ -> 0
                    end,
                    TeamInfo = [{Rid, SrvId, Name, Lev, Career, FightCapacity, PetFight} || #cross_warlord_role{id = {Rid, SrvId}, name = Name, lev = Lev, career = Career, fight_capacity = FightCapacity, pet_fight = PetFight} <- TeamMem],
                    {?true, Rank, TeamName, TeamInfo};
                _ ->
                    {?false, 0, <<"">>, []}
            end;
        _ -> 
            {?false, 0, <<"">>, []}
    end,
    {reply, Reply, State};

handle_call({get_page, Page}, _From, State = #state{ranks = Ranks}) ->
    Reply = get_page(Ranks, Page),
    {reply, {ok, Reply}, State};

handle_call(get_status, _From, State = #state{length = Length, last_fight = LastFight}) ->
    {reply, {Length, LastFight}, State};

handle_call(get_bet_switch, _From, State = #state{switch = Switch}) ->
    {reply, {Switch}, State};

handle_call({get_bet_team, ?cross_warlord_label_sky}, _From, State) ->
    Reply = case get(cross_warlord_bets_sky) of
        Bets when is_list(Bets) ->
            Bets;
        _ ->
            ?DEBUG("竞猜榜暂无数据"),
            []
    end,
    {reply, {ok, Reply}, State}; 
handle_call({get_bet_team, ?cross_warlord_label_land}, _From, State) ->
    Reply = case get(cross_warlord_bets_land) of
        Bets when is_list(Bets) ->
            Bets;
        _ ->
            ?DEBUG("竞猜榜暂无数据"),
            []
    end,
    {reply, {ok, Reply}, State}; 

%% 获取16强对战列表
handle_call({get_bet_team_16, ?cross_warlord_label_sky}, _From, State) ->
    Reply = case get(cross_warlord_16bets_sky) of
        Bets when is_list(Bets) ->
            Bets;
        _ ->
            ?DEBUG("竞猜榜16强无数据"),
            []
    end,
    {reply, {ok, Reply}, State};
handle_call({get_bet_team_16, ?cross_warlord_label_land}, _From, State) ->
    Reply = case get(cross_warlord_16bets_land) of
        Bets when is_list(Bets) ->
            Bets;
        _ ->
            ?DEBUG("竞猜榜16强无数据"),
            []
    end,
    {reply, {ok, Reply}, State};

%% 获取前32名
handle_call({get_bet_top, ?cross_warlord_label_sky}, _From, State) ->
    Reply = case get(cross_warlord_bet_top_32_sky) of
        Bets when is_list(Bets) ->
            Bets;
        _ ->
            ?DEBUG("竞猜榜暂无数据"),
            []
    end,
    {reply, {ok, Reply}, State}; 
handle_call({get_bet_top, ?cross_warlord_label_land}, _From, State) ->
    Reply = case get(cross_warlord_bet_top_32_land) of
        Bets when is_list(Bets) ->
            Bets;
        _ ->
            ?DEBUG("竞猜榜暂无数据"),
            []
    end,
    {reply, {ok, Reply}, State}; 

%% 3甲竞猜 
handle_call({bet_top_3, RoleBet = #cross_warlord_bet{top_3 = Top3}, Label, TeamCode1, TeamCode2, TeamCode3, Coin}, _From, State) ->
    Reply = case find_top3(Label, TeamCode1, TeamCode2, TeamCode3) of
        false ->
            ?DEBUG("存在非法竞猜队伍"),
            {false, ?L(<<"竞猜单里面存在非32强队伍">>)};
        {TeamCode1, TeamName1, TeamCode2, TeamName2, TeamCode3, TeamName3} ->
            Top = {Label, TeamCode1, TeamName1, TeamCode2, TeamName2, TeamCode3, TeamName3, Coin, 0},
            update_bet(all, RoleBet#cross_warlord_bet{top_3 = [Top | Top3]}),
            ok;
        _ ->
            ?DEBUG("无法投注"),
            {false, ?L(<<"队伍不存在, 无法竞猜">>)}
    end,
    {reply, Reply, State};


%% 场次投注
handle_call({bet_team, RoleBet = #cross_warlord_bet{bet_log = BetLog}, Quality, Label, Seq, TeamCode, Coin}, _From, State) ->
    Reply = case find_bet(Quality, Label, Seq) of
        false ->
            ?DEBUG("没有该场比赛的记录"),
            {false, ?L(<<"该场比赛不存在, 无法竞猜">>)};
        %% 投注A
        {ok, {Quality, Seq, TeamCode, TeamName1, Rate1, _, _, TeamName2, _, _}} ->
            Bet = {Quality, Label, Seq, TeamName1, TeamName2, TeamCode, TeamName1, Coin, Rate1, 0},
            NewBetLog = [Bet | BetLog],
            NewRoleBet = RoleBet#cross_warlord_bet{bet_log = NewBetLog},
            update_bet(all, NewRoleBet), 
            ok;
        %% 投注B
        {ok, {Quality, Seq, _, TeamName1, _, _, TeamCode, TeamName2, Rate2, _}} ->
            Bet = {Quality, Label, Seq, TeamName1, TeamName2, TeamCode, TeamName2, Coin, Rate2, 0},
            NewBetLog = [Bet | BetLog],
            NewRoleBet = RoleBet#cross_warlord_bet{bet_log = NewBetLog},
            update_bet(all, NewRoleBet),
            ok;
        _ ->
            ?DEBUG("该场比赛没有该队伍"),
            {false, ?L(<<"该场比赛不存在你所竞猜的队伍, 无法竞猜">>)}
    end,
    {reply, Reply, State};

%% 16强场次投注
handle_call({bet_16_team, RoleBet = #cross_warlord_bet{bet_16 = Bet16}, Label, TeamCodeList, Coin}, _From, State) ->
    Reply = case find_16_bet(Label, TeamCodeList) of
        false ->
            ?DEBUG("没有该场比赛的记录"),
            {false, ?L(<<"竞猜中有不存在的队伍, 无法竞猜">>)};
        {ok, BetTeam} ->
            Bet = {Label, BetTeam, Coin, 0},
            update_bet(all, RoleBet#cross_warlord_bet{bet_16 = [Bet | Bet16]}),
            ok;
        _ ->
            ?DEBUG("该场比赛没有该队伍"),
            {false, ?L(<<"该场比赛不存在你所竞猜的队伍, 无法竞猜">>)}
    end,
    {reply, Reply, State};

handle_call(_Info, _From, State) ->
    {reply, ok, State}.

handle_cast(close_bet, State) ->
    ?INFO("关闭竞猜成功"),
    c_mirror_group:cast(all, cross_warlord_log, pack_to_all, [?false]),
    {noreply, State#state{switch = ?false}};
handle_cast(open_bet, State) ->
    ?INFO("开启竞猜成功"),
    c_mirror_group:cast(all, cross_warlord_log, pack_to_all, [?true]),
    {noreply, State#state{switch = ?true}};

%% 进行下注统计结算
handle_cast({report, ?cross_warlord_quality_final, Label, Seq, TeamCode}, State) ->
    case find_top_team(Label, TeamCode) of
        false ->
            {noreply, State};
        {TeamCode1, TeamCode2, TeamCode3} ->
            AllRole = ets:tab2list(ets_cross_warlord_bet),
            do_calc_bet_final(AllRole, ?cross_warlord_quality_final, Label, Seq, TeamCode1, TeamCode2, TeamCode3),
            {noreply, State}
    end;
handle_cast({report, Quality, Label, Seq, TeamCode}, State) ->
    AllRole = ets:tab2list(ets_cross_warlord_bet),
    do_calc_bet(AllRole, Quality, Label, Seq, TeamCode),
    {noreply, State};

%% 进行16强结算
handle_cast(calc_16_bet, State) ->
    case find_16_team() of
        {false, false} ->
            {noreply, State};
        {false, LandTeam} ->
            AllRole = ets:tab2list(ets_cross_warlord_bet),
            do_calc_16_bet(AllRole, [], LandTeam),
            {noreply, State};
        {SkyTeam, false} ->
            AllRole = ets:tab2list(ets_cross_warlord_bet),
            do_calc_16_bet(AllRole, SkyTeam, []),
            {noreply, State};
        {SkyTeam, LandTeam} ->
            AllRole = ets:tab2list(ets_cross_warlord_bet),
            do_calc_16_bet(AllRole, SkyTeam, LandTeam),
            {noreply, State}
    end;

%% 创建16强竞猜榜
handle_cast(make_16_bet, State) ->
    SkyTeam = cross_warlord_mgr:get_team(?cross_warlord_quality_top_32, ?cross_warlord_label_sky),
    LandTeam = cross_warlord_mgr:get_team(?cross_warlord_quality_top_32, ?cross_warlord_label_land),
    SkyBets = make_combat_16team(SkyTeam),
    LandBets = make_combat_16team(LandTeam),
    put(cross_warlord_16bets_sky, SkyBets),
    put(cross_warlord_16bets_land, LandBets),
    {noreply, State};

%% 创建下注榜
handle_cast({make_bet, Type}, State) ->
    SkyTeam = cross_warlord_mgr:get_team(Type, ?cross_warlord_label_sky),
    LandTeam = cross_warlord_mgr:get_team(Type, ?cross_warlord_label_land),
    SkyBets = make_combat_team(Type, SkyTeam),
    LandBets = make_combat_team(Type, LandTeam),
    put(cross_warlord_bets_sky, SkyBets),
    put(cross_warlord_bets_land, LandBets),
    {noreply, State};

%% 创建32强榜
handle_cast(make_top_32, State) ->
    SkyTeam = cross_warlord_mgr:get_team(?cross_warlord_quality_top_32, ?cross_warlord_label_sky),
    LandTeam = cross_warlord_mgr:get_team(?cross_warlord_quality_top_32, ?cross_warlord_label_land),
    Sky = [{TeamCode, TeamName} || #cross_warlord_team{team_code = TeamCode, team_name = TeamName} <- SkyTeam],
    Land = [{TeamCode, TeamName} || #cross_warlord_team{team_code = TeamCode, team_name = TeamName} <- LandTeam],
    put(cross_warlord_bet_top_32_sky, Sky), 
    put(cross_warlord_bet_top_32_land, Land), 
    {noreply, State};

handle_cast(clean_bet, State) ->
    put(cross_warlord_bets_sky, undefined),
    put(cross_warlord_bets_land, undefined),
    {noreply, State};

handle_cast(clean_top_32, State) ->
    put(cross_warlord_bet_top_32_sky, undefined),
    put(cross_warlord_bet_top_32_land, undefined),
    {noreply, State};

handle_cast(clean_bet_16, State) ->
    put(cross_warlord_16bets_sky, undefined),
    put(cross_warlord_16bets_land, undefined),
    {noreply, State};

handle_cast(clean, State) ->
    ets:delete_all_objects(ets_cross_warlord_log),
    dets:delete_all_objects(dets_cross_warlord_log),
    ets:delete_all_objects(ets_cross_warlord_bet),
    dets:delete_all_objects(dets_cross_warlord_bet),
    {noreply, State#state{ranks = [], length = 0, last_fight = 0}};

handle_cast({add_log, {type_one, [], []}}, State) ->
    {noreply, State};
handle_cast({add_log, {type_two, [], [], []}}, State) ->
    {noreply, State};
handle_cast({add_log, {type_one, WinTeams, LoseTeams}}, State = #state{tmp_log = TmpLog}) ->
    Now = util:unixtime(),
    Loglist = to_normal_log(WinTeams, LoseTeams, 1, 0, Now),
    {noreply, State#state{tmp_log = TmpLog ++ Loglist}};

handle_cast({add_log, {type_two, WinTeams, LoseTeams, TeamPoint}}, State = #state{tmp_log = TmpLog}) ->
    Now = util:unixtime(),
    {WinPoint, LosePoint} = get_point(WinTeams, LoseTeams, TeamPoint),
    Loglist = to_normal_log(WinTeams, LoseTeams, WinPoint, LosePoint, Now),
    {noreply, State#state{tmp_log = TmpLog ++ Loglist}};

handle_cast({match_over, Type}, State = #state{tmp_log = TmpLog}) ->
    add_log_save(TmpLog, Type),
    {noreply, State#state{tmp_log = []}};

handle_cast({add_team, #cross_warlord_team{team_fight = TeamFight}}, State = #state{length = Length, last_fight = LastFight})
when (LastFight > TeamFight andalso Length >= 1024) ->
    ?DEBUG("报名队伍已满,该队伍无资格"),
    {noreply, State};

handle_cast({add_team, #cross_warlord_team{team_code = TeamCode, team_name = TeamName, team_fight = TeamFight, team_member = TeamMem}}, State = #state{ranks = Ranks}) ->
    NewRankMem = [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem],
    TeamRank = #cross_warlord_rank{team_code = TeamCode, team_name = TeamName, team_fight = TeamFight, team_member = NewRankMem},  
    SortRanks = keys_sort(1, [TeamRank | Ranks]),
    NewRanks1 = lists:sublist(SortRanks, 1024),
    NewRanks = modify_rand(NewRanks1),
    Length = length(NewRanks),
    #cross_warlord_rank{team_fight = LastFight} = lists:last(NewRanks),
    {noreply, State#state{ranks = NewRanks, length = Length, last_fight = LastFight}};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(init_rank, State) ->
    TeamList = ets:tab2list(ets_cross_warlord_team),
    case TeamList =:= [] of
        false ->
            Fun = fun(#cross_warlord_team{team_code = TeamCode, team_name = TeamName, team_fight = TeamFight, team_member = TeamMem}) ->
                    NewRankMem = [{Rid, SrvId, Name} || #cross_warlord_role{id = {Rid, SrvId}, name = Name} <- TeamMem],
                    #cross_warlord_rank{team_code = TeamCode, team_name = TeamName, team_fight = TeamFight, team_member = NewRankMem} 
            end,
            Ranks = [Fun(Team) || Team <- TeamList],
            SortRanks = keys_sort(1, Ranks),
            NewRanks1 = lists:sublist(SortRanks, 1024),
            NewRanks = modify_rand(NewRanks1),
            Length = length(NewRanks),
            #cross_warlord_rank{team_fight = LastFight} = lists:last(NewRanks),
            {noreply, State#state{ranks = NewRanks, length = Length, last_fight = LastFight}};
        true ->
            {noreply, State}
    end;
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
%% 广播开关状态
pack_to_all(Switch) ->
    role_group:pack_cast(world, 18122, {Switch}). 

%% 更新角色下注
update_bet(all, RoleBet) -> 
    ets:insert(ets_cross_warlord_bet, RoleBet),
    dets:insert(dets_cross_warlord_bet, RoleBet).

%% 修改下注 
modify_bet_log([], _Bet, NewBetLog) -> NewBetLog;
modify_bet_log([{Quality, Label, Seq, _, _, _, _, _, _, _} | T], Bet = {Quality, Label, Seq, _, _, _, _, _, _, _}, Head) ->
    [Bet | T] ++ Head;
modify_bet_log([B | T], Bet, Head) ->
    modify_bet_log(T, Bet, [B | Head]).

%% 查找是否下注过
find_bet_log([], _Quality, _Label, _Seq) -> false;
find_bet_log([Bet = {Quality, Label, Seq, _Name1, _Name2, _TeamCode, _TeamName, _Coin, _Rate, _WinCoin} | _T], Quality, Label, Seq) ->
    {ok, Bet};
find_bet_log([_ | T], Quality, Label, Seq) ->
    find_bet_log(T, Quality, Label, Seq).

%% 查找前32强投注榜
find_top3(?cross_warlord_label_sky, Team1, Team2, Team3) ->
    case get(cross_warlord_bet_top_32_sky) of
        Sky when is_list(Sky) ->
            do_find_top3(Sky, [Team1, Team2, Team3], []);
        _ -> false
    end;
find_top3(?cross_warlord_label_land, Team1, Team2, Team3) ->
    case get(cross_warlord_bet_top_32_land) of
        Land when is_list(Land) ->
            do_find_top3(Land, [Team1, Team2, Team3], []);
        _ -> false
    end.

do_find_top3(_List, [], [{TeamCode3, TeamName3}, {TeamCode2, TeamName2}, {TeamCode1, TeamName1}]) -> 
    {TeamCode1, TeamName1, TeamCode2, TeamName2, TeamCode3, TeamName3};
do_find_top3([], [_ | _], _) -> false;
do_find_top3(List, [TeamCode | T], All) ->
    case lists:keyfind(TeamCode, 1, List) of
        {TeamCode, TeamName} ->
            do_find_top3(lists:keydelete(TeamCode, 1, List), T, [{TeamCode, TeamName} | All]);
        _ -> false
    end.

%% 查找16强对战表
find_16_bet(?cross_warlord_label_sky, TeamCodeList) ->
    case get(cross_warlord_16bets_sky) of
        SkyBets when is_list(SkyBets) ->
            do_find_16bet(SkyBets, TeamCodeList, []);
        _ ->
            false
    end;
find_16_bet(?cross_warlord_label_land, TeamCodeList) ->
    case get(cross_warlord_16bets_land) of
        SkyBets when is_list(SkyBets) ->
            do_find_16bet(SkyBets, TeamCodeList, []);
        _ ->
            false
    end.
do_find_16bet(_Bets, [], BetTeam) -> {ok, BetTeam};
do_find_16bet(Bets, [{Id, TeamCode} | T], BetTeam) ->
    case lists:keyfind(Id, 1, Bets) of
        {Id, TeamCode, TeamName, _, _} ->
            do_find_16bet(Bets, T, [{Id, TeamCode, TeamName} | BetTeam]);
        {Id, _, _, TeamCode, TeamName} ->
            do_find_16bet(Bets, T, [{Id, TeamCode, TeamName} | BetTeam]);
        _ ->
            false
    end.

%% 查找当前投注榜
find_bet(Quality, ?cross_warlord_label_sky, Seq) ->
    case get(cross_warlord_bets_sky) of
        SkyBets when is_list(SkyBets) ->
            do_find_bet(SkyBets, Quality, Seq);
        _ ->
            false
    end;
find_bet(Quality, ?cross_warlord_label_land, Seq) ->
    case get(cross_warlord_bets_land) of
        LandBets when is_list(LandBets) ->
            do_find_bet(LandBets, Quality, Seq);
        _ ->
            false
    end.
do_find_bet([], _, _) -> false;
do_find_bet([Bet = {Quality, Seq, _, _, _, _, _, _, _, _} | _T], Quality, Seq) -> {ok, Bet};
do_find_bet([_ | T], Quality, Seq) ->
    do_find_bet(T, Quality, Seq).

%% 查找对手
find_rival(Type, GroupId, FindTeam) ->
    find_rival(Type, GroupId, FindTeam, []).
find_rival(_Type, _GroupId, [], _Head) -> false;
find_rival(?cross_warlord_quality_top_32, GroupId, [Team = #cross_warlord_team{team_group_32 = GroupId} | T], Head) ->
    {ok, Team, Head ++ T};
find_rival(?cross_warlord_quality_top_8, GroupId, [Team = #cross_warlord_team{team_group_8 = GroupId} | T], Head) ->
    {ok, Team, Head ++ T};
find_rival(?cross_warlord_quality_top_4_1, GroupId, [Team = #cross_warlord_team{team_group_4 = GroupId} | T], Head) ->
    {ok, Team, Head ++ T};
find_rival(?cross_warlord_quality_top_4_2, GroupId, [Team = #cross_warlord_team{team_group_4 = GroupId} | T], Head) ->
    {ok, Team, Head ++ T};
find_rival(?cross_warlord_quality_semi_final, _GroupId, [Team | T], Head) ->
    {ok, Team, Head ++ T};
find_rival(?cross_warlord_quality_final, _GroupId, [Team | T], Head) ->
    {ok, Team, Head ++ T};
find_rival(Quality, GroupId, [H | T], Head) ->
    find_rival(Quality, GroupId, T, [H | Head]).

%% 组装16强竞猜列表
make_combat_16team(Teams) ->
    make_combat_16team(Teams, []).
make_combat_16team([], CombatBets) -> CombatBets;
make_combat_16team([#cross_warlord_team{team_name = TeamName1, team_code = TeamCode1, team_group_32 = GroupId} | T], CombatBets) ->
    case find_rival(?cross_warlord_quality_top_32, GroupId, T) of
        false ->
            ?DEBUG("~s找不到对手", [TeamName1]),
            make_combat_16team(T, CombatBets);
        {ok, _OtherTeam = #cross_warlord_team{team_name = TeamName2, team_code = TeamCode2}, NewT} ->
            ?DEBUG("~s vs ~s",[TeamName1, TeamName2]),
            Bet = {GroupId, TeamCode1, TeamName1, TeamCode2, TeamName2},
            make_combat_16team(NewT, [Bet | CombatBets])
    end.

%% 组装对战列表
make_combat_team(Type, Teams) ->
    make_combat_team(Type, Teams, []).

make_combat_team(_, [], CombatBets) -> CombatBets;
make_combat_team(?cross_warlord_quality_top_8, [#cross_warlord_team{team_name = TeamName1, team_code = TeamCode1, team_group_8 = GroupId, team_member = TeamMem1, team_fight = TeamFight1} | T], CombatBets) ->
    case find_rival(?cross_warlord_quality_top_8, GroupId, T) of
        false ->
            ?DEBUG("~s找不到对手", [TeamName1]),
            make_combat_team(?cross_warlord_quality_top_8, T, CombatBets);
        {ok, _OtherTeam = #cross_warlord_team{team_name = TeamName2, team_code = TeamCode2, team_fight = TeamFight2, team_member = TeamMem2}, NewT} ->
            Rate1 = trunc(TeamFight2/TeamFight1 * 100) + 100,
            Rate2 = trunc(TeamFight1/TeamFight2 * 100) + 100,
            ?DEBUG("~s:~w vs ~s:~w",[TeamName1, Rate1, TeamName2, Rate2]),
            TeamInfo1 = [{Rid, SrvId, Name, Career, FightCapacity, PetFight} || #cross_warlord_role{id = {Rid, SrvId}, name = Name, fight_capacity = FightCapacity, pet_fight = PetFight, career = Career} <- TeamMem1], 
            TeamInfo2 = [{Rid, SrvId, Name, Career, FightCapacity, PetFight} || #cross_warlord_role{id = {Rid, SrvId}, name = Name, fight_capacity = FightCapacity, pet_fight = PetFight, career = Career} <- TeamMem2], 
            Bet = {?cross_warlord_quality_top_8, GroupId, TeamCode1, TeamName1, Rate1, TeamInfo1, TeamCode2, TeamName2, Rate2, TeamInfo2}, 
            make_combat_team(?cross_warlord_quality_top_8, NewT, [Bet | CombatBets])
    end;
make_combat_team(?cross_warlord_quality_top_4_1, [#cross_warlord_team{team_name = TeamName1, team_code = TeamCode1, team_group_4 = GroupId, team_member = TeamMem1, team_fight = TeamFight1} | T], CombatBets) ->
    case find_rival(?cross_warlord_quality_top_4_1, GroupId, T) of
        false ->
            ?DEBUG("~s找不到对手", [TeamName1]),
            make_combat_team(?cross_warlord_quality_top_4_1, T, CombatBets);
        {ok, _OtherTeam = #cross_warlord_team{team_name = TeamName2, team_code = TeamCode2, team_fight = TeamFight2, team_member = TeamMem2}, NewT} ->
            Rate1 = trunc(TeamFight2/TeamFight1 * 100) + 100,
            Rate2 = trunc(TeamFight1/TeamFight2 * 100) + 100,
            ?DEBUG("~s:~w vs ~s:~w",[TeamName1, Rate1, TeamName2, Rate2]),
            TeamInfo1 = [{Rid, SrvId, Name, Career, FightCapacity, PetFight} || #cross_warlord_role{id = {Rid, SrvId}, name = Name, fight_capacity = FightCapacity, pet_fight = PetFight, career = Career} <- TeamMem1], 
            TeamInfo2 = [{Rid, SrvId, Name, Career, FightCapacity, PetFight} || #cross_warlord_role{id = {Rid, SrvId}, name = Name, fight_capacity = FightCapacity, pet_fight = PetFight, career = Career} <- TeamMem2], 
            Bet = {?cross_warlord_quality_top_4_1, GroupId, TeamCode1, TeamName1, Rate1, TeamInfo1, TeamCode2, TeamName2, Rate2, TeamInfo2}, 
            make_combat_team(?cross_warlord_quality_top_4_1, NewT, [Bet | CombatBets])
    end;
make_combat_team(?cross_warlord_quality_top_4_2, [#cross_warlord_team{team_name = TeamName1, team_code = TeamCode1, team_group_4 = GroupId, team_member = TeamMem1, team_fight = TeamFight1} | T], CombatBets) ->
    case find_rival(?cross_warlord_quality_top_4_2, GroupId, T) of
        false ->
            ?DEBUG("~s找不到对手", [TeamName1]),
            make_combat_team(?cross_warlord_quality_top_4_2, T, CombatBets);
        {ok, _OtherTeam = #cross_warlord_team{team_name = TeamName2, team_code = TeamCode2, team_fight = TeamFight2, team_member = TeamMem2}, NewT} ->
            Rate1 = trunc(TeamFight2/TeamFight1 * 100) + 100,
            Rate2 = trunc(TeamFight1/TeamFight2 * 100) + 100,
            ?DEBUG("~s:~w vs ~s:~w",[TeamName1, Rate1, TeamName2, Rate2]),
            TeamInfo1 = [{Rid, SrvId, Name, Career, FightCapacity, PetFight} || #cross_warlord_role{id = {Rid, SrvId}, name = Name, fight_capacity = FightCapacity, pet_fight = PetFight, career = Career} <- TeamMem1], 
            TeamInfo2 = [{Rid, SrvId, Name, Career, FightCapacity, PetFight} || #cross_warlord_role{id = {Rid, SrvId}, name = Name, fight_capacity = FightCapacity, pet_fight = PetFight, career = Career} <- TeamMem2], 
            Bet = {?cross_warlord_quality_top_4_2, GroupId, TeamCode1, TeamName1, Rate1, TeamInfo1, TeamCode2, TeamName2, Rate2, TeamInfo2}, 
            make_combat_team(?cross_warlord_quality_top_4_2, NewT, [Bet | CombatBets])
    end;
make_combat_team(?cross_warlord_quality_semi_final, [#cross_warlord_team{team_name = TeamName1, team_code = TeamCode1, team_member = TeamMem1, team_fight = TeamFight1} | T], CombatBets) ->
    case find_rival(?cross_warlord_quality_semi_final, 1, T) of
        false ->
            ?DEBUG("~s找不到对手", [TeamName1]),
            make_combat_team(?cross_warlord_quality_semi_final, T, CombatBets);
        {ok, _OtherTeam = #cross_warlord_team{team_name = TeamName2, team_code = TeamCode2, team_fight = TeamFight2, team_member = TeamMem2}, NewT} ->
            Rate1 = trunc(TeamFight2/TeamFight1 * 100) + 100,
            Rate2 = trunc(TeamFight1/TeamFight2 * 100) + 100,
            ?DEBUG("~s:~w vs ~s:~w",[TeamName1, Rate1, TeamName2, Rate2]),
            TeamInfo1 = [{Rid, SrvId, Name, Career, FightCapacity, PetFight} || #cross_warlord_role{id = {Rid, SrvId}, name = Name, fight_capacity = FightCapacity, pet_fight = PetFight, career = Career} <- TeamMem1], 
            TeamInfo2 = [{Rid, SrvId, Name, Career, FightCapacity, PetFight} || #cross_warlord_role{id = {Rid, SrvId}, name = Name, fight_capacity = FightCapacity, pet_fight = PetFight, career = Career} <- TeamMem2], 
            Bet = {?cross_warlord_quality_semi_final, 1, TeamCode1, TeamName1, Rate1, TeamInfo1, TeamCode2, TeamName2, Rate2, TeamInfo2}, 
            make_combat_team(?cross_warlord_quality_semi_final, NewT, [Bet | CombatBets])
    end;
make_combat_team(?cross_warlord_quality_final, [#cross_warlord_team{team_name = TeamName1, team_code = TeamCode1, team_member = TeamMem1, team_fight = TeamFight1} | T], CombatBets) ->
    case find_rival(?cross_warlord_quality_final, 1, T) of
        false ->
            ?DEBUG("~s找不到对手", [TeamName1]),
            make_combat_team(?cross_warlord_quality_final, T, CombatBets);
        {ok, _OtherTeam = #cross_warlord_team{team_name = TeamName2, team_code = TeamCode2, team_fight = TeamFight2, team_member = TeamMem2}, NewT} ->
            Rate1 = trunc(TeamFight2/TeamFight1 * 100) + 100,
            Rate2 = trunc(TeamFight1/TeamFight2 * 100) + 100,
            ?DEBUG("~s:~w vs ~s:~w",[TeamName1, Rate1, TeamName2, Rate2]),
            TeamInfo1 = [{Rid, SrvId, Name, Career, FightCapacity, PetFight} || #cross_warlord_role{id = {Rid, SrvId}, name = Name, fight_capacity = FightCapacity, pet_fight = PetFight, career = Career} <- TeamMem1], 
            TeamInfo2 = [{Rid, SrvId, Name, Career, FightCapacity, PetFight} || #cross_warlord_role{id = {Rid, SrvId}, name = Name, fight_capacity = FightCapacity, pet_fight = PetFight, career = Career} <- TeamMem2], 
            Bet = {?cross_warlord_quality_final, 1, TeamCode1, TeamName1, Rate1, TeamInfo1, TeamCode2, TeamName2, Rate2, TeamInfo2}, 
            make_combat_team(?cross_warlord_quality_final, NewT, [Bet | CombatBets])
    end;
make_combat_team(_, _Teams, _CombatBets) -> [].


%% 更新排行
modify_rand(Ranks) ->
    modify_rand(Ranks, 1, []).
modify_rand([], _, Ranks) -> lists:reverse(Ranks);
modify_rand([R | T], Rank, Ranks) ->
    NewR = R#cross_warlord_rank{team_rank = Rank},
    modify_rand(T, Rank + 1, [NewR | Ranks]).

%% 取页码
get_page(Rank, Page) when Page < 1 -> get_page(Rank, 1);
get_page(Rank, Page) when Page >= 1 ->
    AllPage = util:ceil(length(Rank) / 12),
    case  AllPage < Page of
        true ->
            Get = get_list(Rank, (AllPage - 1) * 12 + 1, Page * 12),
            {AllPage, AllPage, Get};
        false ->
            Get = get_list(Rank, (Page - 1) * 12 + 1, Page * 12), 
            {AllPage, Page, Get} 
    end.


%% 取多少到多少
get_list(List, Head, Tail) when Head =< Tail -> get_list(List, Head, Tail, [], 1);
get_list(List, Head, Tail) -> get_list(List, Tail, Head).

get_list([], _, _, GetList, _Flag) -> lists:reverse(GetList);
get_list(_List, Head, Tail, GetList, _Flag) when Head =:= Tail + 1 -> lists:reverse(GetList);
get_list([R | T], Flag, Tail, GetList, Flag) ->
    get_list(T, Flag + 1, Tail, [R | GetList], Flag + 1);
get_list([_ | T], Head, Tail, GetList, Flag) ->
    get_list(T, Head, Tail, GetList, Flag + 1).

%% 按多键排序 后面优先 即第二个键优先于第一个键
keys_sort(N, TupleList) ->
    do_keys_sort(get_sort_key(N), TupleList).
do_keys_sort([],TupleList) -> lists:reverse(TupleList);
do_keys_sort([H|T], TupleList) ->
    NewTupleList = lists:keysort(H, TupleList),
    do_keys_sort(T,NewTupleList).

%% 获取排行榜排序key
get_sort_key(1) -> [#cross_warlord_rank.team_code, #cross_warlord_rank.team_fight].

get_point(WinTeams, LoseTeams, TeamPoint) ->
    WinPoint = case WinTeams of
        [#cross_warlord_team{team_code = TeamCode1}] ->
            case lists:keyfind(TeamCode1, 1, TeamPoint) of
                {_, _, P} -> P;
                _ -> 0
            end;
        _ -> 0
    end,
    LosePoint = case LoseTeams of
        [#cross_warlord_team{team_code = TeamCode2}] ->
            case lists:keyfind(TeamCode2, 1, TeamPoint) of
                {_, _, P2} -> P2;
                _ -> 0
            end;
        _ -> 0
    end,
    {WinPoint, LosePoint}.

add_log_save([], _)  -> ok;
add_log_save([Log | Logs], Type) when is_record(Log, cross_warlord_log) ->
    ets:insert(ets_cross_warlord_log, Log#cross_warlord_log{war_quality = Type}),
    dets:insert(dets_cross_warlord_log, Log#cross_warlord_log{war_quality = Type}),
    add_log_save(Logs, Type).

to_normal_log(WinTeams, LoseTeams, WinPoint, LosePoint, Time) ->
    Fun = fun(#cross_warlord_role{id = {Rid, SrvId}, name = Name}) -> {Rid, SrvId, Name} end,
    WinRoles = case WinTeams of
        [#cross_warlord_team{team_member = TeamMem1}] ->
            [Fun(R) || R <- TeamMem1];
        _ -> []
    end,
    LoseRoles = case LoseTeams of
        [#cross_warlord_team{team_member = TeamMem2}] ->
            [Fun(R) || R <- TeamMem2];
        _ -> []
    end,
    to_normal_log(WinRoles, LoseRoles, WinRoles, LoseRoles, WinPoint, LosePoint, Time, []).

to_normal_log([], [], _, _, _, _, _, Logs) -> Logs;

to_normal_log([], [{Rid, SrvId, _Name} | T], WinRoles, LoseRoles, WinPoint, LosePoint, Time, Logs) ->

    Log = #cross_warlord_log{id = {Rid, SrvId}, ctime = Time, rival = WinRoles, point = LosePoint, rival_point = WinPoint},
    to_normal_log([], T, WinRoles, LoseRoles, WinPoint, LosePoint, Time, [Log | Logs]);
to_normal_log([{Rid, SrvId, _Name} | T], LoseRoles, WinRoles, LoseRoles, WinPoint, LosePoint, Time, Logs) ->

    Log = #cross_warlord_log{id = {Rid, SrvId}, ctime = Time, rival = LoseRoles, point = WinPoint, rival_point = LosePoint},
    to_normal_log(T, LoseRoles, WinRoles, LoseRoles, WinPoint, LosePoint, Time, [Log | Logs]).

load_rank() ->
    case dets:first(dets_cross_warlord_log) of
        '$end_of_table' -> ?INFO("没有武神坛日志数据");
        _ ->
            dets:traverse(dets_cross_warlord_log,
                fun(Clog) ->
                        ets:insert(ets_cross_warlord_log, Clog),
                        continue
                end
            ),
            ?INFO("武神坛日志数据加载完毕")
    end,
    case dets:first(dets_cross_warlord_bet) of
        '$end_of_table' -> ?INFO("没有武神坛竞猜数据");
        _ ->
            dets:traverse(dets_cross_warlord_bet,
                fun(Clog) ->
                        NewClog = convert_bet(Clog),
                        ets:insert(ets_cross_warlord_bet, NewClog),
                        continue
                end
            ),
            ?INFO("武神坛竞猜数据加载完毕")
    end.

convert_bet({cross_warlord_bet, Id, Top3, Bets}) ->
    #cross_warlord_bet{id = Id, top_3 = Top3, bet_log = Bets};
convert_bet(CrossBet) when is_record(CrossBet, cross_warlord_bet) ->
    CrossBet.
