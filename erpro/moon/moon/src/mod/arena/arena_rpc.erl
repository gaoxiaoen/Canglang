%%----------------------------------------------------
%% @doc 竞技场
%%
%% <pre>
%% 竞技声远程过程调用模块133
%% </pre> 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(arena_rpc).

-export([
        handle/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("arena.hrl").
-include("pos.hrl").
-include("link.hrl").
-include("attr.hrl").
-include("max_fc.hrl").

%% 登录后客户端主动请求
handle(13300, {}, _Role = #role{event = ?event_arena_match}) ->
    {reply, {-1}};
handle(13300, {}, _Role = #role{event = ?event_arena_prepare}) ->
    {reply, {0}};
handle(13300, {}, _Role) ->
    Time = case arena_mgr:time(notice) of
        {ok, Num} ->
            Num;
        _ ->
            ?DEBUG("[竞技场]获取竞技场开始报名时间有误!"),
            -1
    end,
    {reply, {Time}};

%% 竞技场报名
handle(13301, {_Type}, _Role = #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {reply, {?arena_op_fail, ?L(<<"组队状态不可以报名竞技场活动">>)}};
handle(13301, {_Type}, _Role = #role{cross_srv_id = <<"center">>}) ->
    {reply, {?arena_op_fail, ?L(<<"跨服场景中不可以报名">>)}};
handle(13301, {?arena_sign_up_cross}, _Role = #role{max_fc = #max_fc{max = FightCapacity}}) when FightCapacity < 8000 ->
    {reply, {?arena_op_fail, ?L(<<"至少要达到8000战斗力才能跨越时空的壁障，参加跨服超时空竞技">>)}};
handle(13301, {?arena_sign_up_cross}, _Role = #role{lev = Lev}) when Lev < 60 ->
    {reply, {?arena_op_fail, ?L(<<"等级不够，不可以参加跨服超时空竞技">>)}};
%%handle(13301, {?arena_sign_up_cross}, _Role = #role{lev = Lev}) when Lev < 70 ->
%%    {reply, {?arena_op_fail, <<"凌云级暂时不开放跨服超时空竞技，请参加正常模式竞技">>}};
handle(13301, {?arena_sign_up_cross}, Role = #role{id = {_, SrvId}, name = Name, link = #link{conn_pid = ConnPid}, account = Account, event = ?event_no, pos = #pos{map = MapId, x = X, y = Y}}) ->
    case sys_env:get(center) of
        {_Node, _Mpid} ->
            case arena_center_mgr:sign_up(Role) of
                {ok, NewRole = #role{pos = Pos}} ->
                    log:log(log_coin, {<<"竞技报名">>, <<"">>, Role, NewRole}),
                    notice:send_interface({connpid, ConnPid}, 9, Account, SrvId, Name, <<"">>, []),
                    {reply, {?arena_op_succ, ?L(<<"报名成功">>)}, NewRole#role{pos = Pos#pos{last = {MapId, X, Y}}}};
                {false, Reason} ->
                    {reply, {?arena_op_fail, Reason}}
            end;
        _ ->
            {reply, {?arena_op_fail, ?L(<<"你们与时空隧道失去联系，只能参加正常模式竞技">>)}}
    end;

handle(13301, {?arena_sign_up_local}, Role = #role{id = {_, SrvId}, event = ?event_no, account = Account, link = #link{conn_pid = ConnPid}, name = Name, pos = #pos{map = MapId, x = X, y = Y}}) ->
    case arena_mgr:sign_up(Role) of
        {ok, NewRole = #role{pos = Pos}} ->
            log:log(log_coin, {<<"竞技报名">>, <<"">>, Role, NewRole}),
            notice:send_interface({connpid, ConnPid}, 9, Account, SrvId, Name, <<"">>, []),
            {reply, {?arena_op_succ, ?L(<<"报名成功">>)}, NewRole#role{pos = Pos#pos{last = {MapId, X, Y}}}};
        {false, Reason} ->
            {reply, {?arena_op_fail, Reason}}
    end;
handle(13301, {_Type}, _Role = #role{event = ?event_dungeon}) ->
    {reply, {?arena_op_fail, ?L(<<"在副本内不能报名">>)}};
handle(13301, {_Type}, _Role = #role{event = ?event_guild}) ->
    {reply, {?arena_op_fail, ?L(<<"在帮会领地内不可报名">>)}};
handle(13301, {_Type}, _Role) ->
    {reply, {?arena_op_fail, ?L(<<"当前状态不可以报名">>)}};

%% 确定进入战场，及设置是否蒙面
handle(13302, {1}, _Role = #role{cross_srv_id = <<"center">>}) ->
    {reply, {?arena_op_fail, <<"跨服竞技不能蒙面请入战场">>}};
handle(13302, {Mask}, Role = #role{cross_srv_id = <<"center">>}) ->
    case arena_center_mgr:enter_match(Role, Mask) of
        {ok} ->
            {reply, {?arena_op_succ, ?L(<<"操作成功">>)}};
        {false, Reason} ->
            {reply, {?arena_op_fail, Reason}}
    end;
handle(13302, {Mask}, Role) ->
    case arena_mgr:enter_match(Role, Mask) of
        {ok} ->
            {reply, {?arena_op_succ, ?L(<<"操作成功">>)}};
        {false, Reason} ->
            {reply, {?arena_op_fail, Reason}}
    end;

%% 退出竞技场
handle(13303, {}, Role = #role{pid = _Pid, cross_srv_id = <<"center">>}) ->
    case arena_center_mgr:exit_match(Role) of
        ok ->
            {reply, {?arena_op_succ, ?L(<<"操作成功">>)}};
        {false, Reason} ->
            {reply, {?arena_op_fail, Reason}}
    end;
handle(13303, {}, Role = #role{pid = _Pid}) ->
    %% ?DEBUG("===============rpc 退出竞技场[pid:~w]", [_Pid]),
    case arena_mgr:exit_match(Role) of
        ok ->
            {reply, {?arena_op_succ, ?L(<<"操作成功">>)}};
        {false, Reason} ->
            {reply, {?arena_op_fail, Reason}}
    end;

%% 请求排行榜信息
handle(13309, {}, #role{event = ?event_arena_match, event_pid = EventPid}) ->
    case arena:get_rank(EventPid) of
        {ok, Reply} ->
            {reply, {Reply}};
        _ ->
            {ok}
    end;
handle(13309, {}, _Role) ->
    {ok};

%% 获取准备/比赛时间
handle(13311, {}, #role{event = ?event_arena_prepare}) ->
    case arena_mgr:time(prepare) of
        {ok, Reply} -> {reply, {1, Reply}};
        _ -> {ok}
    end;
handle(13311, {}, #role{event = ?event_arena_match}) ->
    case arena_mgr:time(match) of
        {ok, Reply} -> {reply, {2, Reply}};
        _ -> {ok}
    end;
handle(13311, {}, _Role) ->
    {ok};

%% 添加buff
handle(13315, {TarRoleId, TarSrvId}, #role{id = {RoleId, SrvId}}) when TarRoleId =:= RoleId andalso  TarSrvId =:= SrvId ->
    {reply, {?false, ?L(<<"不可以给自己加buff">>)}};
handle(13315, {TarRoleId, TarSrvId}, #role{id = {RoleId, SrvId}, event =?event_arena_match, event_pid = EventPid, cross_srv_id = <<"center">>}) ->
    case arena_center:add_buff(EventPid, {RoleId, SrvId}, {TarRoleId, TarSrvId}) of
        ok -> 
            {reply, {?true, ?L(<<"鼓舞成功,组员的战斗能力提高了">>)}};
        {false, Reason} ->
            {reply, {?false, Reason}}
    end;
handle(13315, {TarRoleId, TarSrvId}, #role{id = {RoleId, SrvId}, event =?event_arena_match, event_pid = EventPid}) ->
    case arena:add_buff(EventPid, {RoleId, SrvId}, {TarRoleId, TarSrvId}) of
        ok -> 
            {reply, {?true, ?L(<<"鼓舞成功,组员的战斗能力提高了">>)}};
        {false, Reason} ->
            {reply, {?false, Reason}}
    end;
handle(13315, {_TarRoleId, _TarSrvId}, _Role) ->
    {reply, {?false, ?L(<<"当前状态属非法操作">>)}};

%% 获取组员列表
handle(13316, {}, #role{id = {RoleId, SrvId}, event = ?event_arena_match, event_pid = EventPid}) ->
    case arena:group_list(EventPid, RoleId, SrvId) of
        {ok, GroupList} -> {reply, {GroupList}};
        _ -> {ok}
    end;
handle(13316, {}, _Role) ->
    {ok};

%% 竞技场统计信息 
handle(13317, {}, #role{event = ?event_arena_match, event_pid = EventPid}) ->
    case arena:group_num(EventPid) of
        {ok, Dragon, Tiger} -> {reply, {Tiger, Dragon}};
        _ -> {ok}
    end;
handle(13317, {}, _Role) ->
    {ok};

%% 获取组员列表
handle(13318, {}, #role{id = {RoleId, SrvId}, event = ?event_arena_match, event_pid = EventPid}) ->
    case arena:kill_report(EventPid, RoleId, SrvId) of
        {ok, Score, Kill} -> {reply, {Score, Kill}};
        _ -> {ok}
    end;
handle(13318, {}, _Role) ->
    {ok};

%% 地点
handle(13319, {}, _Role = #role{event = ?event_arena_match}) ->
    {reply, {2}};
handle(13319, {}, _Role = #role{event = ?event_arena_prepare}) ->
    {reply, {3}};
handle(13319, {}, _Role) ->
    {reply, {1}};

%% 竞技场面板信息
handle(13322, {}, _Role) ->
    case arena_mgr:get_panel_info() of
        {ok, {Status, LowName, MiddleName, HightName, SuperName, AngleName, GodName}} -> 
            {reply, {Status, LowName, MiddleName, HightName, SuperName, AngleName, GodName}};
        {false, _Reason} ->
            {reply, {4, <<>>, <<>>, <<>>, <<>>, <<>>, <<>>}}
    end;

%% 竞技场英雄榜
handle(13325, {ArenaLev, ArenaSeq}, _Role) ->
    case arena_mgr:get_hero_rank(ArenaLev, ArenaSeq) of
        {ok, Num, #arena_hero_zone{winner = Winner, hero_list = HeroList}} ->
            {reply, {Num, Winner, HeroList}};
        {false, _Reason} ->
            ?DEBUG("[竞技场]获取竞技场英雄榜有误:~w", [_Reason]),
            {reply, {0, 0, []}}
    end;

%% 容错函数
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
