%% --------------------------------------------------------------------
%% 试练rpc
%% @abu
%% @end
%% --------------------------------------------------------------------
-module(practice_rpc).

%% export
-export([handle/3, push/3]).

%% include
-include("common.hrl").
-include("role.hrl").
-include("practice.hrl").
-include("attr.hrl").
-include("pos.hrl").

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% 请求试练当前状态
handle(16601, {}, #role{pid = Rpid}) ->
    practice_mgr:get_status(Rpid),
    {ok};

%% 获取上一场冠军队伍
handle(16602, {}, #role{}) ->
    case practice_mgr:get_champion() of
        {ok, #practice_combat{roles = Proles, wave = Wave}} ->
            {reply, {Wave, lists:map(fun to_client_champion/1, Proles)}};
        _ ->
            {reply, {0, []}}
    end;

%% 获取上一场排名
handle(16603, {PageSize, PageNo}, #role{}) ->
    Reply = case practice_mgr:get_last_rank(PageSize, PageNo) of
        {ok, TotalPage, Lranks} ->
            {TotalPage, PageNo, lists:map(fun to_client_rank/1, Lranks)};
        _ ->
            {0, PageNo, []}
    end,
    {reply, Reply};

%% 获取试练剩余次数
handle(16604, {}, Role) ->
    EnterCount = practice_mgr:get_enter_count(Role),
    {reply, {?practice_count - EnterCount, ?practice_count}};

%% 参加无尽试炼活动
handle(16605, {}, Role = #role{cross_srv_id = CrossSrvId}) ->
    case check_enter_practice_hall(Role) of
        {false, Msg} ->
            {reply, {?false, Msg}};
        {ok, local} when CrossSrvId =/= <<>> ->
            {reply, {?false, ?L(<<"您在跨服场景中，无法参加本服的无尽试炼">>)}};
        {ok, local} ->
            case hall_type:get_hall(1, Role) of
                {ok, Hall} ->
                    case hall:enter(Hall, Role) of
                        {ok, NewRole} ->
                            {reply, {?true, <<>>}, NewRole};
                        {false, Reason} ->
                            {reply, {?false, Reason}}
                    end;
                {false, Reason} ->
                    {reply, {?false, Reason}};
                _ ->
                    {reply, {?false, ?L(<<"大厅已关闭">>)}}
            end;
        {ok, center} ->
            case practice_mgr:role_enter(Role) of
                {ok, NewRole} ->
                    {reply, {?true, ?L(<<"成功进入无尽试炼跨服准备区">>)}, NewRole};
                {false, local} when CrossSrvId =/= <<>> ->
                    {reply, {?false, ?L(<<"您在跨服场景中，无法参加本服的无尽试炼">>)}};
                {false, local} ->
                    case hall_type:get_hall(1, Role) of
                        {ok, Hall} ->
                            case hall:enter(Hall, Role) of
                                {ok, NewRole} ->
                                    {reply, {?true, <<>>}, NewRole};
                                {false, Reason} ->
                                    {reply, {?false, Reason}}
                            end;
                        {false, Reason} ->
                            {reply, {?false, Reason}};
                        _ ->
                            {reply, {?false, ?L(<<"大厅已关闭">>)}}
                    end;
                {false, Msg} ->
                    {reply, {?false, Msg}}
            end
    end;

%% 退出试练战斗
handle(16612, {}, #role{id = Rid, combat_pid = CombatPid}) when is_pid(CombatPid) ->
    practice_mgr:leave_combat(Rid, CombatPid),
    {ok};
handle(16612, {}, _) -> {ok};

%% 退出试炼准备区
handle(16613, {}, _Role) ->
    {ok};
    
handle(_Cmd, _Data, _Role = #role{event = _Event}) ->
    ?DEBUG("接到错误指令: cmd = ~w, data = ~w, role = ~w, event = ~w ~n", [_Cmd, _Data, _Role, _Event]),
    {ok}.

%% 推送协议到客户端
push(16611, Rpid, Msg) when is_pid(Rpid) ->
    role:pack_send(Rpid, 16611, Msg),
    ok;
push(16601, Rpid, Msg) when is_pid(Rpid) ->
    role:pack_send(Rpid, 16601, Msg),
    ok;

push(_Cmd, _Rpid, _Msg) ->
    ?ERR("收到错误的推送: cmd = ~w, msg = ~w", [_Cmd, _Msg]),
    ok.


%% --------------------------------------------------------------------
%% interval functions
%% --------------------------------------------------------------------

%% 转换成协议可打包的数据形式
to_client_champion(#practice_role{id = {RoleId, SrvId}, name = Name, sex = Sex, guild_name = GuildName, lev = Lev, career = Career, vip_type = VipType, looks = Looks}) ->
    {RoleId, SrvId, Name, Sex, GuildName, Lev, Career, VipType, Looks}.

to_client_rank(#practice_combat{score = Score, rank = Rank, roles = Prole}) ->
    {Score, Rank, lists:map(fun to_client_rank_team/1, Prole)}.

to_client_rank_team(#practice_role{id = {RoleId, SrvId}, name = Name, sex = Sex, guild_name = GuildName, lev = Lev, career = Career, vip_type = VipType}) ->
    {RoleId, SrvId, Name, Sex, GuildName, Lev, Career, VipType}.

%% 检测是否可以参加无尽试炼
check_enter_practice_hall(#role{status = Status}) when Status =/= ?status_normal ->
    {false, ?L(<<"您的状态无法参加无尽试炼">>)};
check_enter_practice_hall(#role{event = ?event_hall}) ->
    {false, ?L(<<"您已经在大厅中">>)};
check_enter_practice_hall(#role{event = Event}) when Event =/= ?event_no ->
    {false, ?L(<<"您的状态无法参加无尽试炼">>)};
check_enter_practice_hall(#role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {false, ?L(<<"组队不能参加无尽试炼">>)};
check_enter_practice_hall(#role{lev = Lev}) when Lev < 40 ->
    {false, ?L(<<"无尽试炼需要40级以上玩家才能参加，请努力提升再来挑战吧">>)};
check_enter_practice_hall(#role{attr = #attr{fight_capacity = Fight}, practice = Practice}) ->
    case practice_mgr:check_enter_count(self, Practice) of
        {false, Msg} ->
            {false, Msg};
        _ ->
            %% case Fight >= 8000 of
            %%     true -> %% 跨服模式
            %%         %% 0:00 - 9:00
            %%         _S1 = 0,
            %%         E1 = 30600,
            %%         %% 12:00 - 13:00
            %%         S2 = 43200,
            %%         E2 = 46800,
            %%         %% 16:00 - 18:00
            %%         S3 = 57600,
            %%         E3 = 64800,
            %%         %% 22:00 - 00:00
            %%         S4 = 79200,
            %%         _E4 = 86400,
            %%         Det = util:unixtime() - util:unixtime(today),
            %%         if
            %%             Det > E1 andalso Det < S2 -> {false, <<"无尽试练异常火爆导致时空通道不稳定，暂时分时段参加活动，每天00:00~9:00、12:00~13:00、16:00~18:00、22:00~00:00开放无尽试练，请准时参加">>};
            %%             Det > E2 andalso Det < S3 -> {false, <<"无尽试练异常火爆导致时空通道不稳定，暂时分时段参加活动，每天00:00~9:00、12:00~13:00、16:00~18:00、22:00~00:00开放无尽试练，请准时参加">>};
            %%             Det > E3 andalso Det < S4 -> {false, <<"无尽试练异常火爆导致时空通道不稳定，暂时分时段参加活动，每天00:00~9:00、12:00~13:00、16:00~18:00、22:00~00:00开放无尽试练，请准时参加">>};
            %%             true ->
            %%                 {ok, center}
            %%         end;
            %%     false ->
            %%         {ok, local}
            %% end
            case Fight >= 8000 of
                true -> %% 跨服模式
                    {ok, center};
                false ->
                    {ok, local}
            end
    end.
