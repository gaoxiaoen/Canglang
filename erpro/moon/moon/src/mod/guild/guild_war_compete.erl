%% --------------------------------------------------------------------
%% 主将赛
%% @author abu@jieyou.cn
%% @end
%% --------------------------------------------------------------------
-module(guild_war_compete).
-behaviour(gen_server).

%% export functions
-export([
        start_link/1
        ,sign/5
        ,cancel/3
        ,push_compete/3
        ,combat/2
        ,info/0
        ,start/0
        ,stop/0
    ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

%% record
-record(state, {
                war_pid = 0 
                ,finish_team = []
                ,teams = [] 
                ,is_sign = true
                ,sign_start_time = 0
                ,prepare_start_time = 0
            }).
-record(team_info, {team_no, team_pid, team_member = [], remain_hp = 0, fight_capacity = 0}).

%% include files
-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("guild_war.hrl").
%%
-include("team.hrl").
-include("combat.hrl").

%% macro
-define(sign_timeout, 180).
-define(prepare_timeout, 10).
-define(update_timeout, 30).
-define(compete_enter_point, {{5400, 1200}, {6000, 1500}}).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link(WarPid, WarState) -> {ok,Pid} | ignore | {error,Error}
%% WarPid = pid()
%% WarState = #guild_war{}
%% Starts the server
start_link(WarPid) ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [WarPid], []).

%% @spec sign(Pid, Union, TeamNo, Tpid) ->
%% Pid = pid()
%% Union = 1 | 2
%% TeamNO = integer()
%% Tpid = pid()
%% 报名主将赛
sign(Pid, Union, TeamNO, Tpid, Rpid) when is_pid(Pid) ->
    Pid ! {sign, Union, TeamNO, Tpid, Rpid};
sign(_Pid, _Union, _TeamNO, _Tpid, _Rpid) ->
    ok.

%% @spec cancel(Pid, Tpid, Rpid) ->
%% Pid = pid()
%% Tpid = pid()
%% Rpid = pid()
%% 取消报名
cancel(Pid, Tpid, Rpid) when is_pid(Pid) ->
    Pid ! {cancel, Tpid, Rpid};
cancel(_Pid, _, _) ->
    ok.

%% 推送主将赛面板
push_compete(Pid, Rpid, Union) when is_pid(Pid) ->
    Pid ! {push_compete, Rpid, Union};
push_compete(_, _, _) ->
    ok.

%% 战斗处理
combat(compete_combat_over, {ComPid, Winner, Loser}) ->
    ?debug_log([compete_combat_over, {}]),
    LeftHp = get_remain_hp(Winner),
    ?debug_log([remain_hp, LeftHp]),
    ComPid ! {compete_combat_over, [{Wrid, WsrvId} || #fighter{rid = Wrid, srv_id = WsrvId} <- Winner], [{Lrid, LsrvId} || #fighter{rid = Lrid, srv_id = LsrvId} <- Loser], LeftHp},
    {ok}.

%% 主将赛信息
info() ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {info};
        _ ->
            ok
    end.

%% 开启主将赛
start() ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {end_sign};
        _ ->
            ok
    end.

%% 关闭主将赛进程
stop() ->
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {stop};
        _ ->
            ok
    end.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([WarPid]) ->
    process_flag(trap_exit, true),
    erlang:send_after(?update_timeout * 1000, self(), {update}),
    erlang:send_after(?sign_timeout * 1000, self(), {end_sign}),
    {ok, #state{war_pid = WarPid, teams = [], sign_start_time = util:unixtime()}}.

%% @spec: handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%% @spec: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
handle_cast(_Msg, State) ->
    {noreply, State}.

%% @spec: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages

%% 报名
handle_info({sign, _Union, _TeamNo, _Tpid, Rpid}, State = #state{is_sign = false}) ->
    guild_war_util:send_notice(Rpid, ?L(<<"很遗憾，报名时间已过">>), 2),
    {noreply, State};
handle_info({sign, Union, TeamNo, Tpid, Rpid}, State = #state{teams = Teams}) ->
    NewState = case lists:keyfind(Tpid, #team_info.team_pid, Teams) of
        false ->
            case lists:keyfind({Union, TeamNo}, #team_info.team_no, Teams) of
                false ->
                    case catch get_team_fight_capacity(Tpid) of
                        F1 when F1 >= 6000 -> 
                            guild_war_util:send_notice(Rpid, ?L(<<"报名成功">>), 1),
                            Teams2 = [#team_info{team_pid = Tpid, team_no = {Union, TeamNo}, fight_capacity = F1} | Teams],
                            update_team(State#state{teams = Teams2});
                        _ ->
                            guild_war_util:send_notice(Rpid, ?L(<<"您的队伍战斗力低于6000，暂难担当重任。">>), 2),
                            State
                    end;
                #team_info{team_pid = Tpid2} ->
                    case catch compare_fight_capacity(Tpid, Tpid2) of
                        F2 when is_integer(F2) ->
                            guild_war_util:send_notice(Rpid, ?L(<<"报名成功">>), 1),
                            Teams3 = lists:keyreplace({Union, TeamNo}, #team_info.team_no, Teams, #team_info{team_pid = Tpid, team_no = {Union, TeamNo}, fight_capacity = F2}),
                            update_team(State#state{teams = Teams3});
                        false ->
                            guild_war_util:send_notice(Rpid, ?L(<<"你的队伍的总战斗力低于已报名的队伍。">>), 2),
                            State;
                        _ ->
                            guild_war_util:send_notice(Rpid, ?L(<<"您的队伍战斗力低于6000，暂难担当重任。">>), 2),
                            State
                    end;
                _ ->
                    State
            end;
        _ ->
            guild_war_util:send_notice(Rpid, ?L(<<"您的队伍已经报名了">>), 2),
            State
    end,
    {noreply, NewState};

%% 取消报名
handle_info({cancle, _Tpid, Rpid}, State = #state{is_sign = false}) ->
    guild_war_util:send_notice(Rpid, ?L(<<"很遗憾，报名时间已过">>), 2),
    {noreply, State};
handle_info({cancel, Tpid, Rpid}, State = #state{teams = Teams}) ->
    NewState = case lists:keyfind(Tpid, #team_info.team_pid, Teams) of
        false ->
            guild_war_util:send_notice(Rpid, ?L(<<"您没有报名参加主将赛">>), 2),
            State;
        _ ->
            guild_war_util:send_notice(Rpid, ?L(<<"取消成功">>), 1),
            update_team(State#state{teams = lists:keydelete(Tpid, #team_info.team_pid, Teams)})
    end,
    {noreply, NewState};

%% 推送主将赛面板
handle_info({push_compete, Rpid, Union}, State = #state{sign_start_time = Stime, teams = Teams}) when is_pid(Rpid) ->
    {AtkMsg, DfdMsg} = pack_msg(Stime, Teams),
    case Union of
        ?guild_war_union_attack ->
            Rpid ! {socket_proxy, AtkMsg};
        _ ->
            Rpid ! {socket_proxy, DfdMsg}
    end,
    {noreply, State};

%% 主将赛战斗结束处理
handle_info({compete_combat_over, Wrids, Lrids, RemainHp}, State = #state{war_pid = Wpid, teams = Teams}) ->
    ?debug_log([compete_combat_over, {Wrids, Lrids, RemainHp}]),
    {WinUnion, TeamNo} = get_team_no(Wrids, State),
    {LostUnion, LostTeamNo} = get_team_no(Lrids, State),
    ?debug_log([WinUnion, TeamNo]),
    NewTeams = case lists:keyfind({WinUnion, TeamNo}, #team_info.team_no, Teams) of
        Team = #team_info{} ->
            lists:keyreplace({WinUnion, TeamNo}, #team_info.team_no, Teams, Team#team_info{remain_hp = RemainHp});
        _ ->
            Teams
    end,
    NewState = State#state{teams = NewTeams},
    do_credit(win, TeamNo, Wrids, NewState),
    do_credit(lose, TeamNo, Lrids, NewState),
    catch do_cast({WinUnion, TeamNo}, {LostUnion, LostTeamNo}, NewState),
    guild_war:credit(Wpid, {WinUnion, RemainHp}, {compete_union, TeamNo}),
    guild_war:finish_compete(Wpid, Wrids ++ Lrids),
    {noreply, NewState};

%% 报名时间结束
handle_info({end_sign}, State = #state{is_sign = true}) ->
    ?debug_log([end_sign, {}]),
    erlang:send_after(?prepare_timeout * 1000, self(), {start_compete}),
    {ok, Msg} = proto_109:pack(srv, 10931, {55, ?L(<<"主将赛即将开始，请报名的队伍做好战斗准备！">>), []}),
    guild_war:cast(State#state.war_pid, {Msg}),
    do_enter_cast(State#state.teams),
    {noreply, State#state{prepare_start_time = util:unixtime(), is_sign = false}};

%% 开启主将赛
handle_info({start_compete}, State = #state{}) ->
    NewState = update_team(State),
    NewState2 = start_compete(NewState),
    {noreply, NewState2#state{}};

%% 更新队伍信息
handle_info({update}, State = #state{is_sign = true}) ->
    erlang:send_after(?update_timeout * 1000, self(), {update}),
    NewState = update_team(State),
    {noreply, NewState};
handle_info({update}, State) ->
    {noreply, State};

%% 关闭主将赛进程
handle_info({stop}, State) ->
    {stop, normal, State};

%% 打印主将赛信息
handle_info({info}, State = #state{teams = _Teams}) ->
    ?debug_log([teams, _Teams]),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, _State) ->
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------

%% 比较队伍的战斗力
compare_fight_capacity(Tpid, Tpid2) ->
    F1 = get_team_fight_capacity(Tpid),
    case F1 < 6000 of
        true ->
            {false, weak};
        false ->
            F2 = get_team_fight_capacity(Tpid2),
            ?debug_log([fight_capacity, {F1, F2}]),
            case F1 > F2 of
                true ->
                    F1;
                false ->
                    false
            end
    end.

get_team_fight_capacity(Tpid) ->
    case team:get_team_info(Tpid) of
        {ok, #team{leader = #team_member{id = Lid}, member = Members}} ->
            get_fight_capacity([Lid] ++ [Id || #team_member{id = Id, mode = 0} <- Members]);
        _ ->
            0
    end.

get_fight_capacity(Rids) ->
    get_fight_capacity(Rids, 0).
get_fight_capacity([], Back) ->
    Back;
get_fight_capacity([H | T], Back) ->
    case role_api:lookup(by_id, H, #role.attr) of
        {ok, _, #attr{fight_capacity = Fc}} ->
            get_fight_capacity(T, Back + Fc);
        _ ->
            get_fight_capacity(T, Back)
    end.

%% 更新报名队伍的信息
update_team(State = #state{teams = Teams, war_pid = Wpid, sign_start_time = Stime}) ->
    NewTeams = do_update_team(Teams),
    {AtkMsg, DfdMsg} = pack_msg(Stime, NewTeams),
    guild_war:cast(Wpid, {AtkMsg, DfdMsg}),
    State#state{teams = NewTeams}.

do_update_team(Teams) ->
    do_update_team(Teams, []).

do_update_team([], Back) ->
    Back;
do_update_team([H = #team_info{team_pid = Tpid} | T], Back) ->
    case get_team_info(Tpid) of
        false ->
            do_update_team(T, Back);
        TeamMember ->
            do_update_team(T, [H#team_info{team_member = TeamMember} | Back])
    end;
do_update_team([_ | T], Back) ->
    do_update_team(T, Back).

get_team_info(Tpid) ->
    case guild_war_util:check([{is_pid_alive, Tpid}]) of
        ok ->
            case team:get_team_info(Tpid) of
                {ok, #team{leader = Leader, member = Members}} ->
                    [Leader | Members];
                _ ->
                    false
            end;
        {false, _} ->
            false
    end.

%% 打包主将赛报名信息
pack_msg(Stime, Teams) ->
    pack_msg(Stime, Teams, [], []).
pack_msg(Stime, [], AtkBack, DfdBack) ->
    TimeLeft = case ?sign_timeout - (util:unixtime() - Stime) of
        T1 when T1 < 0 ->
            0;
        T2 ->
            T2
    end,
    {ok, AtkMsg} = proto_146:pack(srv, 14611, {TimeLeft, AtkBack}),
    {ok, DfdMsg} = proto_146:pack(srv, 14611, {TimeLeft, DfdBack}),
    {AtkMsg, DfdMsg};
pack_msg(Stime, [#team_info{team_no = {Union, TeamNo}, team_member = Tmems, fight_capacity = FightCapacity} | T], AtkBack, DfdBack) ->
    Names = get_names(Tmems),
    Info = [TeamNo, Names, FightCapacity],
    case Union of 
        ?guild_war_union_attack ->
            pack_msg(Stime, T, [Info | AtkBack], DfdBack);
        _ ->
            pack_msg(Stime, T, AtkBack, [Info | DfdBack])
    end;
pack_msg(Stime, [_ | T], AtkBack, DfdBack) ->
    pack_msg(Stime, T, AtkBack, DfdBack).

%% 按队伍发起战斗
start_compete(State) ->
    Nos = [0, 1, 2, 3, 4],
    do_start_compete(Nos, State, [], []).

do_start_compete([], State, AtkBack, DfdBack) ->
    NewAtkBack = lists:reverse(AtkBack),
    NewDfdBack = lists:reverse(DfdBack),
    ?debug_log([atk_back, AtkBack]),
    ?debug_log([dfd_back, DfdBack]),
    start_combat(NewAtkBack, NewDfdBack, State),
    State;
do_start_compete([H | T], State = #state{teams = Teams, finish_team = Fteam}, AtkBack, DfdBack) ->
    ?debug_log([do_start_compete, H]),
    case {lists:keyfind({?guild_war_union_attack, H}, #team_info.team_no, Teams), lists:keyfind({?guild_war_union_defend, H}, #team_info.team_no, Teams)} of
        {false, false} ->
            ?debug_log([H, no_team]),
            do_start_compete(T, State#state{finish_team = [H | Fteam]}, AtkBack, DfdBack);
        {false, T1} ->
            ?debug_log([H, atk_no_team]),
            do_start_compete(T, State, AtkBack, [T1 | DfdBack]);
        {T2, false} ->
            ?debug_log([H, dfd_no_team]),
            do_start_compete(T, State, [T2 | AtkBack], DfdBack);
        {T3 = #team_info{}, T4 = #team_info{}} ->
            NewState = start_combat(T3, T4, State),
            do_start_compete(T, NewState, AtkBack, DfdBack);
        _ ->
            do_start_compete(T, State, AtkBack, DfdBack)
    end.

start_combat([], DfdBack, State = #state{war_pid = Wpid}) ->
    ?debug_log([atk_no_team, DfdBack]),
    lists:foreach(fun(DfdTeam)-> win(Wpid, DfdTeam, State) end, DfdBack),
    State;
start_combat(AtkBack, [], State = #state{war_pid = Wpid}) ->
    ?debug_log([dfd_no_team, AtkBack]),
    lists:foreach(fun(AtkTeam)-> win(Wpid, AtkTeam, State) end, AtkBack),
    State;
start_combat([AtkTeam = #team_info{team_no = _ATeamNo} | AtkBack], [DfdTeam = #team_info{team_no = _DTeamNo} | DfdBack], State) ->
    ?debug_log([{atk, _ATeamNo}, {dfd, _DTeamNo}]),
    start_combat(AtkTeam, DfdTeam, State),
    start_combat(AtkBack, DfdBack, State);

start_combat(AtkTeam = #team_info{team_pid = AtkTpid}, DfdTeam = #team_info{team_pid = DfdTpid}, State = #state{war_pid = Wpid}) ->
    case {get_team_leader(AtkTpid), get_team_leader(DfdTpid)} of
        {false, false} ->
            ?debug_log([start_compete_combat, no_role]),
            State;
        {false, _} ->
            ?debug_log([defend_win, {}]),
            win(Wpid, DfdTeam, State),
            State#state{};
        {_, false} ->
            ?debug_log([attack_win, {}]),
            win(Wpid, AtkTeam, State),
            State#state{};
        {AtkLeader, DfdLeader} ->
            ?debug_log([start_combat, {}]),
            guild_war:attend_compete(Wpid, get_team_rids(AtkTpid) ++ get_team_rids(DfdTpid)),
            combat_type:check(?combat_type_guild_war_compete, self(), {AtkLeader, DfdLeader}),
            State
    end.

get_team_leader(Tpid) ->
    case team:get_leader(Tpid) of
        {ok, _, #team_member{id = Rid}} ->
            case role_api:lookup(by_id, Rid) of
                {ok, _, Role} ->
                    Role;
                _ ->
                    false
            end;
        _ ->
            false
    end.

get_team_rids(Tpid) ->
    case team:get_team_info(Tpid) of
        {ok, #team{leader = Leader, member = Members}} ->
            [Rid || #team_member{id = Rid} <- [Leader | Members]];
        _ ->
            []
    end.

%% 胜利处理
win(Wpid, #team_info{team_no = {Union, TeamNo}, team_member = Members}, State) ->
    ?debug_log([no_team_win, {Union, TeamNo}]),
    Wrids = [Rid || #team_member{id = Rid} <- Members],
    do_credit(win, TeamNo, Wrids, State),
    catch do_cast({Union, TeamNo}, {?guild_war_opp_union(Union), -1}, State),
    guild_war:credit(Wpid, {Union, 100}, {compete_union, TeamNo}).
            
%% 取得名字发送
get_names(Tmems) ->
    get_names(Tmems, []).
get_names([], Back) ->
    Back;
get_names([#team_member{name = Name, id = {RoleId, SrvId}} | T], Back) ->
    get_names(T, Back ++ [[Name, RoleId, SrvId]]).

%% 获取剩余血量
get_remain_hp(Fighters) ->
    get_remain_hp(Fighters, 1, 0).

get_remain_hp([], Total, Remain) ->
    util:ceil(Remain * 100 / Total);
get_remain_hp([#fighter{hp_max = HpMax, hp = Hp} | T], Total, Remain) ->
    get_remain_hp(T, Total + HpMax, Remain + Hp).

get_team_no([], _) ->
    {?guild_war_union_defend, 2};
get_team_no([Rid | T], State = #state{teams = Teams}) ->
    case role_api:lookup(by_id, Rid, #role.team_pid) of
        {ok, _, TeamPid} ->
            case lists:keyfind(TeamPid, #team_info.team_pid, Teams) of
                #team_info{team_no = No} ->
                    No;
                _ ->
                    get_team_no(T, State)
            end;
        _ ->
            get_team_no(T, State)
    end.

do_credit(_, _, [], _) ->
    ok;
do_credit(win, TeamNo, [Rid | T], State = #state{war_pid = Wpid}) ->
    guild_war:credit(Wpid, Rid, {compete_win, TeamNo}),
    do_credit(win, TeamNo, T, State);
do_credit(lose, TeamNo, [Rid | T], State = #state{war_pid = Wpid}) ->
    guild_war:credit(Wpid, Rid, {compete_lose, TeamNo}),
    do_credit(lose, TeamNo, T, State).
    
do_cast({Union, TeamNo}, {Lunion, LteamNo}, #state{war_pid = Wpid, teams = Teams}) ->
    Leader = get_leader({Union, TeamNo}, Teams),
    OppLeader = get_leader({Lunion, LteamNo}, Teams),
    case lists:keyfind({Union, TeamNo}, #team_info.team_no, Teams) of
        #team_info{remain_hp = RemainHp} ->
            Credit = case RemainHp of
                0 ->
                    guild_war_credit:calc_compete_credit(TeamNo, 100);
                _ ->
                    guild_war_credit:calc_compete_credit(TeamNo, RemainHp)
            end,
            UnionName = ?guild_war_union_name(Union),
            OppUnionName = ?guild_war_union_name(Lunion),
            CastLeader = case Leader of
                #team_member{id = {RoleId, SrvId}, name = Name} ->
                    notice:role_to_msg({RoleId, SrvId, Name});
                false ->
                    <<"">>
            end,
            CastOppLeader = case OppLeader of
                #team_member{id = {RoleId2, SrvId2}, name = Name2} ->
                    notice:role_to_msg({RoleId2, SrvId2, Name2});
                false ->
                    <<"">>
            end,
            CastMsg = case CastOppLeader of
                <<"">> ->
                    {ok, Msg} = proto_109:pack(srv, 10931, {54, util:fbin(?L(<<"在~s对决中，~s望风而逃，没有报名~s，~s自动获得~w积分。">>), [?guild_war_compete_name(TeamNo), OppUnionName, ?guild_war_compete_name(TeamNo), UnionName, Credit]), []}),
                    Msg;
                _ ->
                    {ok, Msg} = proto_109:pack(srv, 10931, {54, util:fbin(?L(<<"在~s对决中~s的~s带领的队伍~s~s的~s带领的队伍，为~s赢得了~w积分!">>), [?guild_war_compete_name(TeamNo), UnionName, CastLeader, ?L(<<"战胜">>), OppUnionName, CastOppLeader, UnionName, Credit]), []}),
                    Msg
            end,
            guild_war:cast(Wpid, {CastMsg});
        _ ->
            ok
    end.

do_enter_cast([]) ->
    ok;
do_enter_cast([#team_info{team_member = Members} | T]) ->
    do_enter_cast_member(Members),
    do_enter_cast(T).
do_enter_cast_member([]) ->
    ok;
do_enter_cast_member([#team_member{pid = Pid} | T]) ->
    ?debug_log([push, {}]),
    guild_war_rpc:push(Pid, get_flow_time, {4, 10}),
    do_enter_cast_member(T).

%% 获取队长名称
get_leader(TeamNo, Teams) ->
    case lists:keyfind(TeamNo, #team_info.team_no, Teams) of
        #team_info{team_member = Members} ->
            get_leader(Members);
        _ ->
            false
    end.
get_leader([]) ->
    false;
get_leader([Member = #team_member{} | _]) ->
    Member;
get_leader([_ | T]) ->
    get_leader(T).


