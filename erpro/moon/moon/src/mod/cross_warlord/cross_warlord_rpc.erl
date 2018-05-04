%%----------------------------------------------------
%% 武神坛
%% @author shawn 
%%----------------------------------------------------
-module(cross_warlord_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("cross_warlord.hrl").

%% 进入准备区
handle(18100, {RoomId}, Role) when RoomId >= 0 ->
    case allow(cross_warlord_enter_pre) of
        true ->
            case cross_warlord:role_enter(Role, RoomId) of
                {false, Reason} ->
                    {reply, {?false, Reason}};
                {ok} ->
                    {ok};
                _ -> {reply, {?false, ?L(<<"时空不是很稳定,请稍后再进入">>)}}
            end;
        false ->
            {reply, {?false, ?L(<<"请勿频繁操作">>)}}
    end;

%% 退出
handle(18101, {}, #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {reply, {?false, ?L(<<"请离开队伍后,再离开武神坛区域">>)}};
handle(18101, {}, Role) ->
    case cross_warlord:role_leave(Role) of
        {false, Reason} -> {reply, {?false, Reason}};
        {ok} -> {ok}
    end;

%% 进入比赛 
handle(18102, {}, Role) ->
    case allow(cross_warlord_enter_match) of
        true ->
            case cross_warlord:enter_match(Role) of
                {false, Reason} -> {reply, {?false, Reason}};
                {ok} -> {ok}
            end;
        false ->
            {reply, {?false, ?L(<<"请勿频繁操作">>)}}
    end;

%% 报名比赛
handle(18103, _, #role{status = Status}) when Status =/= ?status_normal ->
    {reply, {?false, ?L(<<"该状态下无法参加报名武神坛">>)}};
handle(18103, {Name}, Role) ->
    case allow(cross_warlord_sign) of
        true ->
            case cross_warlord:sign(Role, Name) of
                {false, Reason} -> {reply, {?false, Reason}};
                ok -> {ok}
            end;
        false ->
            {reply, {?false, ?L(<<"请勿频繁的报名">>)}}
    end;

%% 战区信息
handle(18104, {}, #role{event = ?event_cross_warlord_match, event_pid = EventPid}) ->
    case center:is_connect() of
        false -> {ok};
        _ ->
            case cross_warlord:get_zone_status(EventPid) of
                false -> 
                    {ok};
                {Quality, Time, TeamList, ReadyList, Point} ->
                    {reply, {Quality, Time, TeamList, ReadyList, Point}}
            end
    end;
handle(18104, {}, #role{}) -> {ok};

%% 查看选拔赛区
handle(18105, {Seq, Label}, #role{}) when Seq >= 1 andalso Seq =< 32 andalso (Label =:= 0 orelse Label =:= 1) ->
    case allow(cross_warlord_zone) of
        true ->
            case cross_warlord:get_trial_zone(Seq, Label) of
                {TeamInfo, TeamCode, TeamName, TeamSrvId, Roles} when is_list(TeamInfo) ->
                    {reply, {TeamInfo, TeamCode, TeamName, TeamSrvId, Roles}};
                _ -> 
                    {ok}
            end;
        false -> {ok}
    end;
handle(18105, _, #role{}) -> {ok};

%% 请求个人选拔赛区信息 
handle(18106, {}, #role{id = Id, lev = Lev}) when Lev >= 65 ->
    case allow(cross_warlord_self) of
        true ->
            Reply = case cross_warlord:get_role_trial_info(Id) of
                {Seq, Label} -> {Seq, Label};
                _ -> {0, 0}
            end,
            {reply, Reply};
        false -> {ok}
    end;
handle(18106, _, #role{}) -> {reply, {0, 0}};

%% 请求队伍信息 
handle(18107, {TeamCode}, #role{}) when TeamCode >= 1 ->
    case allow(cross_warlord_team) of
        true ->
            case cross_warlord:get_team(TeamCode) of
                {TeamName, TeamInfo} when is_list(TeamInfo) ->
                    {reply, {TeamName, TeamInfo}};
                _ -> {ok}
            end;
        false ->
            {ok}
    end;

%% 32强榜单信息 
handle(18108, {Label}, #role{}) when (Label =:= 0 orelse Label =:= 1) ->
    case allow(cross_warlord_32_team) of
        true ->
            case cross_warlord:get_war_list(Label) of
                false -> {ok};
                {StateLev, Flag, LastName, LastSrvId, InfoList, Code, Name, SrvId, Roles} ->
                    {reply, {StateLev, Flag, LastName, LastSrvId, InfoList, Code, Name, SrvId, Roles}}
            end;
        false ->
            {ok}
    end;

%% 请求上届冠军队伍信息
handle(18109, {Label}, #role{}) when (Label =:= 0 orelse Label =:= 1) ->
    case cross_warlord:get_last_winer(Label) of
        {TeamName, RoleList} ->
            {reply, {TeamName, RoleList}};
        _ ->
            {ok}
    end;

%% 请求活动状态
handle(18110, {}, #role{}) ->
    case cross_warlord:check_in_open_time() of
        true ->
            {Status, Time} = cross_warlord:get_camp_status(),
            {reply, {Status, Time}};
        _ ->
            {ok}
    end;

%% 请求活动日期安排
handle(18112, {}, #role{}) ->
    {Flag, Status, UnixTime, NextStatus, NextUnixtime} = cross_warlord:get_camp_date(),
    {reply, {Flag, Status, UnixTime, NextStatus, NextUnixtime}};

%% 获取房间列表
handle(18113, {}, #role{}) ->
    case allow(cross_warlord_room) of
        true ->
            RoomList = cross_warlord:get_room_list(),
            {reply, {RoomList}};
        false ->
            {ok}
    end;

%% 获取房间列表
handle(18114, {}, #role{lev = Lev, id = Id}) when Lev >= 65 ->
    case allow(cross_warlord_log) of
        true ->
            case center:call(cross_warlord_log, query_role, [Id]) of
                Logs when is_list(Logs) -> {reply, {Logs}};
                _ -> {reply, {[]}}
            end;
        false -> {ok}
    end;

%% 获取角色报名队伍信息
handle(18115, {}, #role{lev = Lev}) when Lev < 65 ->
    {reply, {?false, 0, <<"">>, []}};
handle(18115, {}, #role{id = Id}) ->
    case allow(cross_warlord_role_info) of
        true ->
            case center:call(cross_warlord_log, get_role_info, [Id]) of
                {Flag, Rank, TeamName, TeamInfo} ->
                    {reply, {Flag, Rank, TeamName, TeamInfo}};
                _ -> {ok}
            end;
        false -> {ok}
    end;

%% 获取排行榜
handle(18116, {Page}, #role{}) when Page =< 0 -> {ok};
handle(18116, {Page}, #role{}) ->
    case center:call(cross_warlord_log, get_page, [Page]) of
        {ok, {AllPage, NowPage, Get}} ->
            {reply, {NowPage, AllPage, Get}};
        _ ->
            {ok}
    end;

%% 下注某场比赛
handle(18117, {_, _, _, _}, #role{lev = Lev}) when Lev < 50 ->
    {reply, {?false, ?L(<<"50级以上才可以参与竞猜">>)}};
handle(18117, {_, _, _, Coin}, #role{}) when Coin < 20000 ->
    {reply, {?false, ?L(<<"竞猜金额最低为20000金币">>)}};
handle(18117, {_, _, _, Coin}, #role{}) when Coin > 200000 ->
    {reply, {?false, ?L(<<"竞猜金额最高为200000金币">>)}};
handle(18117, {Label, Seq, TeamCode, Coin}, Role = #role{id = {Rid ,SrvId}}) when (Label =:= 0 orelse Label =:= 1) andalso (Seq >= 1 andalso Seq =< 4) andalso Coin >= 20000 ->
    case allow(cross_warlord_bet_team) of
        true ->
            role:send_buff_begin(),
            case role_gain:do([#loss{label = coin, val = Coin, msg = ?L(<<"金币不足, 无法竞猜">>)}], Role) of
                {false, L} ->
                    role:send_buff_clean(),
                    {reply, {?coin_less, L#loss.msg}};
                {ok, NewRole} ->
                    case center:call(cross_warlord_mgr, bet_team, [{Rid, SrvId}, Label, Seq, TeamCode, Coin]) of
                        ok ->
                            role:send_buff_flush(),
                            log:log(log_coin, {<<"武神坛竞猜队伍">>, <<>>, Role, NewRole}),
                            {reply, {?true, ?L(<<"竞猜成功">>)}, NewRole};
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {reply, {?false, Reason}};
                        _ ->
                            role:send_buff_clean(),
                            {reply, {?false, ?L(<<"时刻隧道暂不稳定, 请稍后再竞猜">>)}}
                    end
            end;
        false ->
            {reply, {?false, ?L(<<"请勿频繁竞猜">>)}}
    end;

%% 竞猜前三甲
handle(18118, {_, _, _, _, _}, #role{lev = Lev}) when Lev < 50 ->
    {reply, {?false, ?L(<<"50级以上才可以参与竞猜">>)}};
handle(18118, {_, _, _, _, Coin}, #role{}) when Coin < 20000 ->
    {reply, {?false, ?L(<<"竞猜金额最低为20000金币">>)}};
handle(18118, {_, _, _, _, Coin}, #role{}) when Coin > 200000 ->
    {reply, {?false, ?L(<<"竞猜金额最高为200000金币">>)}};
handle(18118, {Label, TeamCode1, TeamCode2, TeamCode3, Coin}, Role = #role{id = {Rid, SrvId}}) when (Label =:= 0 orelse Label =:= 1) andalso Coin >= 20000 ->
    case allow(cross_warlord_bet_top_3) of
        true ->
            role:send_buff_begin(),
            case role_gain:do([#loss{label = coin, val = Coin, msg = ?L(<<"金币不足, 无法竞猜">>)}], Role) of
                {false, L} ->
                    role:send_buff_clean(),
                    {reply, {?coin_less, L#loss.msg}};
                {ok, NewRole} ->
                    case center:call(cross_warlord_mgr, bet_top_3, [{Rid, SrvId}, Label, TeamCode1, TeamCode2, TeamCode3, Coin]) of
                        ok ->
                            role:send_buff_flush(),
                            log:log(log_coin, {<<"武神坛竞猜三甲">>, <<>>, Role, NewRole}),
                            {reply, {?true, ?L(<<"竞猜成功">>)}, NewRole};
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {reply, {?false, Reason}};
                        _ ->
                            role:send_buff_clean(),
                            {reply, {?false, ?L(<<"时刻隧道暂不稳定, 请稍后再竞猜">>)}}
                    end
            end;
        false ->
            {reply, {?false, ?L(<<"请勿频繁竞猜">>)}}
    end;

handle(18119, {Label}, #role{}) when (Label =:= 1 orelse Label =:= 0) ->
    case allow(cross_warlord_query_bet_team) of
        true ->
            case center:call(cross_warlord_log, get_bet_team, [Label]) of
                {ok, Bets} when is_list(Bets) ->
                    {reply, {Bets}};
                _ ->
                    {reply, {[]}}
            end;
        false ->
            {ok}
    end;
handle(18120, {Label}, #role{}) when (Label =:= 1 orelse Label =:= 0) ->
    case allow(cross_warlord_query_bet_top_3) of
        true ->
            case center:call(cross_warlord_log, get_bet_top, [Label]) of
                {ok, Bets} when is_list(Bets) ->
                    {reply, {Bets}};
                _ ->
                    {reply, {[]}}
            end;
        false ->
            {ok}
    end;

handle(18121, {}, #role{id = {Rid, SrvId}}) ->
    case allow(cross_warlord_query_bet_log) of
        true ->
            case center:call(cross_warlord_log, get_bet_log, [{Rid, SrvId}]) of
                {ok, Top3, Bets, Bet16} when is_list(Bets) ->
                    {reply, {Top3, Bets, Bet16}};
                _ ->
                    {reply, {[], [], []}}
            end;
        false ->
            {ok}
    end;

handle(18122, {}, #role{}) ->
    case center:call(cross_warlord_log, get_bet_switch, []) of
        {?true} -> {reply, {?true}};
        {?false} -> {reply, {?false}};
        _Err -> {reply, {?false}}
    end;

%% 战区准备/取消准备 
handle(18123, _, #role{combat_pid = CombatPid}) when is_pid(CombatPid) ->
    {reply, {?false, ?L(<<"战斗状态下无法准备/取消准备操作">>)}};
handle(18123, {?true}, #role{id = {Rid, SrvId}, pid = Pid, event = ?event_cross_warlord_match, event_pid = EventPid}) ->
    case center:is_connect() of
        false -> {ok};
        _ ->
            case allow(cross_warlord_cancel_ready) of
                true ->
                    cross_warlord:ready({Rid, SrvId}, Pid, EventPid),
                    {ok};
                false ->
                    {ok}
            end
    end;
handle(18123, {?false}, #role{id = {Rid, SrvId}, pid = Pid, event = ?event_cross_warlord_match, event_pid = EventPid}) ->
    case center:is_connect() of
        false -> {ok};
        _ ->
            case allow(cross_warlord_ready) of
                true ->
                    cross_warlord:cancel_ready({Rid, SrvId}, Pid, EventPid),
                    {ok};
                false ->
                    {ok}
            end
    end;
handle(18123, {_}, #role{}) -> {ok};

%% 改变阵法 
handle(18124, {LineId}, #role{id = {Rid, SrvId}, pid = Pid, event = ?event_cross_warlord_match, event_pid = EventPid}) ->
    case center:is_connect() of
        false -> {ok};
        _ ->
            case allow(cross_warlord_lineup) of
                true ->
                    cross_warlord:change_lineup({Rid, SrvId}, Pid, LineId, EventPid),
                    {ok};
                false ->
                    {ok}
            end
    end;
handle(18124, {_}, #role{}) -> {ok};

%% 获取16强对战表
handle(18125, {Label}, #role{}) when (Label =:= 1 orelse Label =:= 0) ->
    case allow(cross_warlord_query_bet_16) of
        true ->
            case center:call(cross_warlord_log, get_bet_team_16, [Label]) of
                {ok, Bets} when is_list(Bets) ->
                    {reply, {Bets}};
                _ ->
                    {reply, {[]}}
            end;
        false ->
            {ok}
    end;


%% 投注16强
handle(18126, {_, _, _, _, _}, #role{lev = Lev}) when Lev < 50 ->
    {reply, {?false, ?L(<<"50级以上才可以参与竞猜">>)}};
handle(18126, {_, _, _, _, Coin}, #role{}) when Coin < 20000 ->
    {reply, {?false, ?L(<<"竞猜金额最低为20000金币">>)}};
handle(18126, {_, _, _, _, Coin}, #role{}) when Coin > 200000 ->
    {reply, {?false, ?L(<<"竞猜金额最高为200000金币">>)}};
handle(18126, {Label, TeamCode1, TeamCode2, TeamCode3, TeamCode4, TeamCode5, TeamCode6, TeamCode7, TeamCode8, TeamCode9, TeamCode10, TeamCode11, TeamCode12, TeamCode13, TeamCode14, TeamCode15, TeamCode16, Coin}, Role = #role{id = {Rid, SrvId}}) when (Label =:= 0 orelse Label =:= 1) ->
    case allow(cross_warlord_bet_team_16) of
        true ->
            role:send_buff_begin(),
            case role_gain:do([#loss{label = coin, val = Coin, msg = ?L(<<"金币不足, 无法竞猜">>)}], Role) of
                {false, L} ->
                    role:send_buff_clean(),
                    {reply, {?coin_less, L#loss.msg}};
                {ok, NewRole} ->
                    case center:call(cross_warlord_mgr, bet_16_team, [{Rid, SrvId}, Label, TeamCode1, TeamCode2, TeamCode3, TeamCode4, TeamCode5, TeamCode6, TeamCode7, TeamCode8, TeamCode9, TeamCode10, TeamCode11, TeamCode12, TeamCode13, TeamCode14, TeamCode15, TeamCode16, Coin]) of
                        ok ->
                            role:send_buff_flush(),
                            log:log(log_coin, {<<"武神坛竞猜16强">>, <<>>, Role, NewRole}),
                            {reply, {?true, ?L(<<"竞猜成功">>)}, NewRole};
                        {false, Reason} ->
                            role:send_buff_clean(),
                            {reply, {?false, Reason}};
                        _ ->
                            role:send_buff_clean(),
                            {reply, {?false, ?L(<<"时刻隧道暂不稳定, 请稍后再竞猜">>)}}
                    end
            end;
        false ->
            {reply, {?false, ?L(<<"请勿频繁竞猜">>)}}
    end;

handle(18127, _, #role{combat_pid = CombatPid}) when is_pid(CombatPid) -> {ok};
handle(18127, {Label}, #role{}) when Label =:= ?cross_warlord_label_sky orelse Label =:= ?cross_warlord_label_land ->
    case allow(get_live_list) of
        true ->
            case center:call(cross_warlord_live, get_list, [Label]) of
                {ok, List} -> {reply, {List}};
                _ -> {ok}
            end;
        false -> {ok}
    end;

handle(18128, _, #role{combat_pid = CombatPid}) when is_pid(CombatPid) -> {reply, {?false, <<"战斗状态下无法观战">>}};
handle(18128, {Label, Quality, Seq}, Role = #role{pid = RolePid}) when Label =:= ?cross_warlord_label_sky orelse Label =:= ?cross_warlord_label_land ->
    case allow(look_live) of
        true ->
            case center:call(cross_warlord_live, get_live, [Label, Quality, Seq]) of
                {ok, CombatPid} ->
                    case util:is_process_alive(CombatPid) of
                        true ->
                            case role_gain:do([#loss{label = coin_all, val = 10000, msg = <<"金币不足，无法观战">>}], Role) of
                                {false, L} -> {?coin_less, L#loss.msg};
                                {ok, NewRole} ->
                                    combat_live_mgr:sign_up(CombatPid, RolePid),
                                    {reply, {?true, <<>>}, NewRole}
                            end;
                        false ->
                            {reply, {?false, <<"该场比赛暂无直播">>}}
                    end;
                _ -> {reply, {?false, <<>>}}
            end;
        false -> {reply, {?false, <<"请勿频繁操作观看直播">>}}
    end;

%% 容错
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

%% ------------------------

allow(get_live_list) ->
    do_check(get_live_list, 5);
allow(look_live) ->
    do_check(look_live, 5);
allow(cross_warlord_query_bet_16) ->
    do_check(cross_warlord_query_bet_16, 1);
allow(cross_warlord_bet_team_16) ->
    do_check(cross_warlord_bet_team_16, 1);
allow(cross_warlord_cancel_ready) ->
    do_check(cross_warlord_cancel_ready, 1);
allow(cross_warlord_ready) ->
    do_check(cross_warlord_ready, 1);
allow(cross_warlord_lineup) ->
    do_check(cross_warlord_lineup, 1);
allow(cross_warlord_query_bet_log) ->
    do_check(cross_warlord_query_bet_log, 3);
allow(cross_warlord_query_bet_top_3) ->
    do_check(cross_warlord_query_bet_top_3, 3);
allow(cross_warlord_query_bet_team) ->
    do_check(cross_warlord_query_bet_team, 3);
allow(cross_warlord_bet_team) ->
    do_check(cross_warlord_bet_team, 5);
allow(cross_warlord_bet_top_3) ->
    do_check(cross_warlord_bet_top_3, 5);
allow(cross_warlord_enter_pre) ->
    do_check(cross_warlord_enter_pre, 2);
allow(cross_warlord_enter_match) ->
    do_check(cross_warlord_enter_match, 5);
allow(cross_warlord_sign) ->
    do_check(cross_warlord_sign, 2);
allow(cross_warlord_log) ->
    do_check(cross_warlord_log, 1);
allow(cross_warlord_zone) ->
    do_check(cross_warlord_zone, 1);
allow(cross_warlord_self) ->
    do_check(cross_warlord_self, 1);
allow(cross_warlord_team) ->
    do_check(cross_warlord_team, 1);
allow(cross_warlord_32_team) ->
    do_check(cross_warlord_32_team, 1);
allow(cross_warlord_room) ->
    do_check(cross_warlord_room, 1);
allow(cross_warlord_role_info) ->
    do_check(cross_warlord_role_info, 1).

do_check(Type, N) ->
    case get(Type) of
        T when is_integer(T) ->
            case util:unixtime() - T > N of
                true ->
                    put(Type, util:unixtime()),
                    true;
                false -> false
            end;
        _ ->
            put(Type, util:unixtime()),
            true
    end.
