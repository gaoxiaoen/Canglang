%%----------------------------------------------------
%% 帮会副本相关远程调用
%% @author shawnoyc@163.com
%%----------------------------------------------------

-module(guild_td_rpc).
-export([handle/3, time_to_mode/1]).

-include("role.hrl").
-include("common.hrl").
-include("guild_td.hrl").
-include("guild.hrl").
-include("link.hrl").
%%

%% 获取当前战场信息
handle(14900, {}, #role{event = ?event_guild_td, event_pid = EventPid}) ->
    case is_pid(EventPid) andalso is_process_alive(EventPid) of
        false ->
            ?ERR("获取不存在的帮会副本状态出错"),
            {ok};
        true ->
            case catch guild_td:get_guild_status(EventPid) of
                {?GUILD_TD_STATE_READY, #guild_td{td_lev = Lev, hp = Hp, enter_role = EnterRole}} ->
                    ?DEBUG("准备状态中的军团副本 ~w", [{?GUILD_TD_STATE_RUN, Lev, Hp, ?GUILD_TD_KEEP_TIME div 1000, guild_td:get_role_point(EnterRole)}]),
                    {reply, {?GUILD_TD_STATE_RUN, 0, Lev, Hp, ?GUILD_TD_TIME_PRE_START div 1000, guild_td:get_role_point(EnterRole)}};
                {Status, #guild_td{td_lev = Lev, hp = Hp, enter_role = EnterRole, end_time = EndTime}} ->
                    Now = util:unixtime(),
                    ?DEBUG("开始状态中的军团副本 ~w", [{Status, Lev, Hp, EndTime - Now, guild_td:get_role_point(EnterRole)}]),
                    {reply, {Status, 1, Lev, Hp, EndTime - Now, guild_td:get_role_point(EnterRole)}};
                _ ->
                    ?ERR("获取帮会副本状态出错"),
                    {ok}
            end
    end;
handle(14900, {}, #role{guild = #role_guild{gid = Gid, srv_id = GsrvId}}) ->
    case guild_td_mgr:get_guild_td({Gid, GsrvId}) of 
        {false, _Reason} -> {reply, {0,0,0,0,0,[]}};
        pre_stop -> {reply, {0,0,0,0,0,[]}};
        {TdPid, _MapId} ->
            case is_pid(TdPid) andalso is_process_alive(TdPid) of
                true -> 
                    {reply, {1, 0, 0, 0, 0, []}};
                false ->
                    {reply, {0,0,0,0,0,[]}}
            end
    end;

%% 进入帮会副本
handle(14901, {}, Role = #role{guild = #role_guild{join_date = JoinTime}}) ->
    case day_diff(util:unixtime(), JoinTime) > 0 of
        true -> 
            case guild_td_api:role_enter(Role) of
                {false, Reason} -> {reply, {0, Reason}};
                {ok, NewRole} -> {reply, {1, ?L(<<"成功进入军团副本">>)}, NewRole}
            end;
        false ->
            case guild_td_api:role_enter(Role) of
                {false, Reason} -> {reply, {0, Reason}};
                {ok, NewRole} -> {reply, {1, ?L(<<"成功进入军团副本">>)}, NewRole}
            end
    end;

%% 退出帮会副本
handle(14902, {}, Role = #role{event = ?event_guild_td, link = #link{conn_pid = ConnPid}}) ->
    case guild_td_api:role_leave(Role) of
        {false, Reason} ->
            {reply, {0, Reason}};
        {ok, NewRole} ->
            sys_conn:pack_send(ConnPid, 14902, {1, <<>>}),
            ?DEBUG("成功退出军团副本"),
            {ok, NewRole}
            %{reply, {1, <<>>}, NewRole}
    end;

%% 设置帮会副本时间
handle(14906, {Mode, Lev}, #role{link = #link{conn_pid = ConnPid}, guild = #role_guild{gid = Gid, srv_id = GsrvId, position = Pos}})
when (Pos =:= ?guild_chief orelse Pos =:= ?guild_elder) andalso Mode >= 1 andalso Mode =< 25 ->
    case guild_td_api:get_guild({Gid, GsrvId}) of
        false -> {reply, {0, ?L(<<"你没有军团，不能设置">>)}};
        %% #guild{lev = Lev} when Lev < 3 -> {reply, {0, ?L(<<"帮会等级低于3级，无法设置军团副本开启时间">>)}};
        _ ->
            case guild_td_mgr:get_guild_td({Gid, GsrvId}) of
                {false, _} ->
                    %case guild_td_mgr:get_today_run_state({Gid, GsrvId}) of
                    %    {0} ->
                            Today = util:unixtime(today) + mode_to_time(Mode),
                            Now = util:unixtime(),
                            case Now >= Today of
                                false ->
                                    case lists:member(Lev, guild_td_data:all_lev()) of
                                        true ->
                                            case guild_td_mgr:set_conf({Gid, GsrvId}, mode_to_time(Mode), guild_td_data:lev2wave(Lev)) of
                                                {false, Reason} -> {reply, {0, Reason}};
                                                {ok, Day, _Time, Msg} ->
                                                    ?DEBUG("Day:~w, mode:~w, Lev: ~w",[Day, Mode, Lev]),
                                                    sys_conn:pack_send(ConnPid, 14908, {Day, Mode, Lev}),
                                                    {reply, {1, Msg}}
                                            end;
                                        false ->
                                            {reply, {0, ?L(<<"不能设置此难度！">>)}}
                                    end;
                                true ->
                                    {reply, {0, ?L(<<"不能早于当前时间喔！">>)}}
                            end;
                   %     {1} ->
                   %         {reply, {0, ?L(<<"今天不能设置开启副本">>)}}
                   % end;
                _ ->
                    {reply, {0, ?L(<<"军团副本正在开启中，不能设置开启时间">>)}}
            end
    end;

handle(14906, {Mode}, #role{}) when Mode >= 1 andalso Mode =< 7 ->
    {reply, {0, ?L(<<"只有团长能设置开启时间">>)}};

%% 查询帮会副本开启时间
handle(14908, {}, #role{guild = #role_guild{gid = Gid, srv_id = GsrvId}}) ->
    case guild_td_mgr:get_time({Gid,GsrvId}) of
        false ->
            ?DEBUG(" 没有开启时间"),
            {reply, {0, 0, 0}};
        {ok, Day, Time, Lev} ->
            ?DEBUG("军团开启时间 Time: ~w  DAY: ~w, Mode: ~w, Lev: ~w", [Time, Day, time_to_mode(Time), Lev]),
            {reply, {Day, time_to_mode(Time), Lev}}
    end;

handle(_Cmd, _Data, _Role) ->
    {error, guild_td_rpc_unknow_command}.

%% ---------
mode_to_time(1) -> ?GUILD_TD_MODE_1;
mode_to_time(2) -> ?GUILD_TD_MODE_2;
mode_to_time(3) -> ?GUILD_TD_MODE_3;
mode_to_time(4) -> ?GUILD_TD_MODE_4;
mode_to_time(5) -> ?GUILD_TD_MODE_5;
mode_to_time(6) -> ?GUILD_TD_MODE_6;
mode_to_time(7) -> ?GUILD_TD_MODE_7;
mode_to_time(8) -> ?GUILD_TD_MODE_8;
mode_to_time(9) -> ?GUILD_TD_MODE_9;
mode_to_time(10) -> ?GUILD_TD_MODE_10;
mode_to_time(11) -> ?GUILD_TD_MODE_11;
mode_to_time(12) -> ?GUILD_TD_MODE_12;
mode_to_time(13) -> ?GUILD_TD_MODE_13;
mode_to_time(14) -> ?GUILD_TD_MODE_14;
mode_to_time(15) -> ?GUILD_TD_MODE_15;
mode_to_time(16) -> ?GUILD_TD_MODE_16;
mode_to_time(17) -> ?GUILD_TD_MODE_17;
mode_to_time(18) -> ?GUILD_TD_MODE_18;
mode_to_time(19) -> ?GUILD_TD_MODE_19;
mode_to_time(20) -> ?GUILD_TD_MODE_20;
mode_to_time(21) -> ?GUILD_TD_MODE_21;
mode_to_time(22) -> ?GUILD_TD_MODE_22;
mode_to_time(23) -> ?GUILD_TD_MODE_23;
mode_to_time(24) -> ?GUILD_TD_MODE_24;
mode_to_time(25) -> ?GUILD_TD_MODE_25.

time_to_mode(?GUILD_TD_MODE_1) -> 1;
time_to_mode(?GUILD_TD_MODE_2) -> 2;
time_to_mode(?GUILD_TD_MODE_3) -> 3;
time_to_mode(?GUILD_TD_MODE_4) -> 4;
time_to_mode(?GUILD_TD_MODE_5) -> 5;
time_to_mode(?GUILD_TD_MODE_6) -> 6;
time_to_mode(?GUILD_TD_MODE_7) -> 7;
time_to_mode(?GUILD_TD_MODE_8) -> 8;
time_to_mode(?GUILD_TD_MODE_9) -> 9;
time_to_mode(?GUILD_TD_MODE_10) -> 10;
time_to_mode(?GUILD_TD_MODE_11) -> 11;
time_to_mode(?GUILD_TD_MODE_12) -> 12;
time_to_mode(?GUILD_TD_MODE_13) -> 13;
time_to_mode(?GUILD_TD_MODE_14) -> 14;
time_to_mode(?GUILD_TD_MODE_15) -> 15;
time_to_mode(?GUILD_TD_MODE_16) -> 16;
time_to_mode(?GUILD_TD_MODE_17) -> 17;
time_to_mode(?GUILD_TD_MODE_18) -> 18;
time_to_mode(?GUILD_TD_MODE_19) -> 19;
time_to_mode(?GUILD_TD_MODE_20) -> 20;
time_to_mode(?GUILD_TD_MODE_21) -> 21;
time_to_mode(?GUILD_TD_MODE_22) -> 22;
time_to_mode(?GUILD_TD_MODE_23) -> 23;
time_to_mode(?GUILD_TD_MODE_24) -> 24;
time_to_mode(?GUILD_TD_MODE_25) -> 25.

%% @spec day_diff(UnixTime, UnixTime) -> int()
%% @doc 两个unixtime相差的天数,相邻2天返回1
%% return int() 相差的天数
day_diff(FromTime, ToTime) when ToTime > FromTime ->
    FromDate = util:unixtime({today, FromTime}),
    ToDate = util:unixtime({today, ToTime}),
    case (ToDate - FromDate) / (3600 * 24) of
        Diff when Diff < 0 -> 0;
        Diff -> round(Diff)
    end;

day_diff(FromTime, ToTime) when ToTime=:=FromTime ->
    0;

day_diff(FromTime, ToTime) ->
    day_diff(ToTime, FromTime).
