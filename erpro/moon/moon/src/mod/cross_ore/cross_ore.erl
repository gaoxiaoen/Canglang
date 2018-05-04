%% --------------------------------------------------------------------
%% 跨服抢矿相关接口
%% @author wpf (wprehard@qq.com)
%% @end
%% --------------------------------------------------------------------
-module(cross_ore).
-export([
        get_status/0
        ,get_areas/0
        ,get_my_room/1
        ,get_room_info/1
        ,get_log/1
        ,role_login/1
        ,role_logout/1
        ,role_enter/2
        ,role_leave/1
        ,role_revive_back/1
        ,rob_ore/2
        ,capture_ore/2
        ,mail_rob_award/3
        ,mail_capture_award/3
        ,mail_reap_award/3
    ]).
-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("pos.hrl").
-include("team.hrl").
-include("link.hrl").

%% @spec get_status() -> {Status, Time}
get_status() ->
    case center:call(cross_ore_mgr, get_status, []) of
        {ok, {StatusId, Time}} -> {StatusId, Time};
        _ -> {0, 0}
    end.

%% @spec get_areas() -> list()
get_areas() ->
    case center:call(cross_ore_mgr, get_areas, []) of
        Areas when is_list(Areas) ->
            Fun = fun({Id, Num}) when Num < 0 ->
                    {Id, 0};
                ({Id, Num}) -> {Id, Num}
            end,
            [Fun(X) || X <- Areas];
        _ -> []
    end.

%% @spec get_my_room(RoleId) -> tuple()
get_my_room(RoleId) ->
    case center:call(cross_ore_mgr, get_ore_room, [RoleId]) of
        Data = {_Id, _Name, _Lev, _Roles, _Award, _NextTime, _Npc} -> Data;
        _D ->
            ?DEBUG("_D:~w", [_D]),
            {0, <<>>, 0, [], [], 0, []}
    end.

%% @spec get_room_info(RoleId) -> tuple()
get_room_info(RoomId) ->
    case center:call(cross_ore_mgr, get_ore_room, [RoomId]) of
        Data = {_RoomId, _Name, _Lev, _Flag, _Status, _Roles, _AL, _Npc} -> Data;
        _D ->
            ?DEBUG("_D:~w", [_D]),
            {0, <<>>, 0, 0, 0, [], [], 0, []}
    end.

%% @spec get_log(RoleId) -> tuple()
get_log(RoleId) ->
    case center:call(cross_ore_mgr, get_log, [RoleId]) of
        Data = {_Log1, _Log2, _Log3, _Log4} -> Data;
        _D ->
            ?DEBUG("****:~w", [_D]),
            {[], [], [], []}
    end.

%% @spec role_login(Role) -> NewRole
%% Role = #role{}
role_login(Role = #role{event = ?event_cross_ore, cross_srv_id = CrossSrvId, pos = Pos = #pos{map = _MapId, last = {LastMapId, X, Y}}}) ->
    case CrossSrvId of
        <<"center">> -> %% 直接离开活动状态
            Role#role{event = ?event_no, cross_srv_id = <<>>, ride = ?ride_no, pos = Pos#pos{map = LastMapId, x = X, y = Y}};
            %% case center:is_connect() of
            %%     false -> %% 如果与中央服断了连接，重置event
            %%         Role#role{event = ?event_no, event_pid = 0};
            %%     _ ->
            %%         case center:call(cross_ore_mgr, get_status, []) of
            %%             {ok, {Status, _}} when Status =:= 2 orelse Status =:= 1 ->
            %%                 center:cast(cross_ore_mgr, role_login, [RoleId, RoleName, RolePid, MapId]),
            %%                 Role#role{ride = ?ride_fly}; %% 活动中默认登陆飞行
            %%             _ ->
            %%                 Role#role{event = ?event_no, event_pid = 0}
            %%         end
            %% end;
        _ ->
            role_leave(Role),
            Role#role{event = ?event_no, event_pid = 0}
    end;
role_login(Role) -> Role.

%% @spec role_logout(Role) -> any()
%% 登出
role_logout(#role{event = ?event_cross_ore, id = RoleId, pos = #pos{map = MapId}}) ->
    center:cast(cross_ore_mgr, role_logout, [RoleId, MapId]);
role_logout(_) -> ok.

%% @spec role_revive_back(Role) -> NewRole
%% @doc 角色死亡回城
role_revive_back(Role = #role{event = ?event_cross_ore}) ->
    Role#role{event = ?event_no, ride = ?ride_fly};
role_revive_back(Role) -> Role.

%% @spec role_enter(Role, AreaId) -> {false, Msg} | ok
%% Role = #role{}
role_enter(Role = #role{id = RoleId, name = RoleName, pid = RolePid}, AreaId) ->
    case check_enter_pre(Role) of
        {false, Msg} -> {false, Msg};
        {ok, L} -> %% 带队进入
            TmpL = lists:map(fun({_, Name, Pid}) ->
                        case role_api:c_lookup(by_pid, Pid, [#role.status, #role.event, #role.lev, #role.attr]) of
                            {ok, _, [Status, Event, Lev, Attr]} ->
                                {Name, Status, Event, Lev, Attr};
                            _ -> error
                        end
                end, L),
            case check_member_enter_pre(TmpL) of
                {false, Msg} -> {false, Msg};
                ok ->
                    center:cast(cross_ore_mgr, role_enter, [RolePid, [{RoleId, RoleName, RolePid} | L], AreaId]),
                    ok
            end;
        ok ->
            center:cast(cross_ore_mgr, role_enter, [RoleId, RoleName, RolePid, AreaId]),
            ok
    end.

%% @spec role_leave(Role) -> {false, Msg} | ok
%% Role = #role{}
role_leave(#role{status = Status}) when Status =/= ?status_normal ->
    {false, ?L(<<"战斗中，不能离开跨服仙府">>)};
role_leave(#role{event = ?event_cross_ore, id = RoleId, name = Name, pid = Pid, pos = #pos{map = MapId}, team_pid = TeamPid}) when is_pid(TeamPid) ->
    case team_api:get_team_info(TeamPid) of
        {ok, #team{leader = #team_member{id = RoleId}, member = Members}} ->
            case length([Id || #team_member{id = Id, mode = ?MODE_NORMAL} <- Members]) of
                0 ->
                    center:cast(cross_ore_mgr, role_leave, [RoleId, Name, Pid, MapId]),
                    ok;
                _ -> 
                    {false, ?L(<<"您还在队伍中，请先退出队伍才能退出昆仑仙境">>)}
            end;
        {ok, #team{member = Members}} ->
            case lists:keyfind(RoleId, #team_member.id, Members) of
                #team_member{mode = ?MODE_TEMPOUT} ->
                    center:cast(cross_ore_mgr, role_leave, [RoleId, Name, Pid, MapId]),
                    ok;
                _ ->
                    {false, ?L(<<"您还在队伍中，请先退出队伍才能退出昆仑仙境">>)}
            end;
        _ ->
            {false, ?L(<<"您还在队伍中，请先退出队伍才能退出昆仑仙境">>)}
    end;
role_leave(#role{event = ?event_cross_ore, id = RoleId, name = Name, pid = Pid, pos = #pos{map = MapId}}) ->
    center:cast(cross_ore_mgr, role_leave, [RoleId, Name, Pid, MapId]),
    ok;
role_leave(_) ->
    {false, ?L(<<"操作失败">>)}.

%% @spec rob_ore(Role, OreId) -> ok | {false, Msg}
rob_ore(#role{event = Event}, _OreId) when Event =/= ?event_cross_ore ->
    {false, ?L(<<"您需要先进入跨服仙府地图才能打劫或争夺">>)};
rob_ore(#role{team_pid = TeamPid}, _OreId) when not is_pid(TeamPid) ->
    {false, ?L(<<"需要三人组队才能发起争夺和打劫">>)};
rob_ore(#role{id = RoleId, pid = RolePid, team_pid = TeamPid, team = #role_team{is_leader = ?true}}, OreId) ->
    case team_api:get_members_id(TeamPid) of
        IdList when is_list(IdList) ->
            case length(IdList) >= 2 of
                true ->
                    center:cast(cross_ore_mgr, rob_ore, [RoleId, RolePid, IdList, OreId]),
                    ok;
                false ->
                    {false, ?L(<<"需要三人组队由队长发起争夺和打劫">>)}
            end;
        _ ->
            {false, ?L(<<"需要三人组队由队长发起争夺和打劫">>)}
    end;
rob_ore(#role{team = #role_team{is_leader = ?false}}, _OreId) ->
    {false, ?L(<<"需要三人组队由队长发起争夺和打劫">>)};
rob_ore(_, _) ->
    {false, ?L(<<"操作失败">>)}.

%% @spec capture_ore(Role, OreId) -> ok | {false, Msg}
capture_ore(#role{event = Event}, _OreId) when Event =/= ?event_cross_ore ->
    {false, ?L(<<"您需要先进入跨服仙府地图才能打劫或争夺">>)};
capture_ore(#role{team_pid = TeamPid}, _OreId) when not is_pid(TeamPid) ->
    {false, ?L(<<"需要三人组队才能发起争夺和打劫">>)};
capture_ore(#role{id = RoleId, pid = RolePid, team_pid = TeamPid, team = #role_team{is_leader = ?true}}, OreId) ->
    case team_api:get_members_id(TeamPid) of
        IdList when is_list(IdList) ->
            case length(IdList) >= 2 of
                true ->
                    center:cast(cross_ore_mgr, capture_ore, [RoleId, RolePid, IdList, OreId]),
                    ok;
                false ->
                    {false, ?L(<<"需要三人组队由队长发起争夺和打劫">>)}
            end;
        _ ->
            {false, ?L(<<"需要三人组队由队长发起争夺和打劫">>)}
    end;
capture_ore(#role{team = #role_team{is_leader = ?false}}, _OreId) ->
    {false, ?L(<<"需要三人组队由队长发起争夺和打劫">>)};
capture_ore(_, _) ->
    {false, ?L(<<"操作失败">>)}.

%% 组装内容
content_rob(OreRoleList) ->
    case [Name || {_, _, Name} <- OreRoleList] of
        [Name] ->
            util:fbin(?L(<<"您打劫了玩家~s的仙府，并大肆掠夺了一番，收获颇丰，获得了以下资源。">>), [Name]);
        [Name1, Name2] ->
            util:fbin(?L(<<"您打劫了玩家~s、~s的仙府，并大肆掠夺了一番，收获颇丰，获得了以下资源。">>), [Name1, Name2]);
        [Name1, Name2, Name3] ->
            util:fbin(?L(<<"您打劫了玩家~s、~s、~s的仙府，并大肆掠夺了一番，收获颇丰，获得了以下资源。">>), [Name1, Name2, Name3]);
        _ -> ?L(<<"您打劫仙府，获得如下资源">>)
    end.

content_capture(RoleList) ->
    case [Name || {_, _, Name} <- RoleList] of
        [Name] ->

            util:fbin(?L(<<"玩家~s竟然占领了您的仙府，简直是不知所谓，马上去抢回来吧！">>), [Name]);
        [Name1, Name2] ->
            util:fbin(?L(<<"玩家~s、~s竟然占领了您的仙府，简直是不知所谓，马上去抢回来吧！">>), [Name1, Name2]);
        [Name1, Name2, Name3] ->
            util:fbin(?L(<<"玩家~s、~s、~s竟然占领了您的仙府，简直是不知所谓，马上去抢回来吧！">>), [Name1, Name2, Name3]);
        _ -> ?L(<<"您仙府被占领，去抢回来吧">>)
    end.

%% @spec mail_rob_award({Rid, SrvId, Name}, OreRoleList, AL) -> any()
%% 邮件发放
%% 打劫奖励
mail_rob_award(ToRole = {_Rid, _SrvId, _Name}, _OreRoleList, []) ->
    mail_mgr:deliver(ToRole, {?L(<<"仙府争夺">>), ?L(<<"您打劫了仙府，并大肆搜索了一番，可惜此仙府灵气未至没有资源，你什么也没得到。">>), [], []});
mail_rob_award(ToRole = {_Rid, _SrvId, _Name}, OreRoleList, AL) ->
    {AssetList, ItemList} = parse_award(AL, [], []),
    Content = content_rob(OreRoleList),
    mail_mgr:deliver(ToRole, {?L(<<"仙府争夺">>), Content, AssetList, ItemList});
mail_rob_award(_, _, _) -> ignore.

%% 被占领资源返回
mail_capture_award(ToRole = {_Rid, _SrvId, _Name}, {win, RoleList}, AL) ->
    {AssetList, ItemList} = parse_award(AL, [], []),
    Content = content_capture(RoleList),
    mail_mgr:deliver(ToRole, {?L(<<"仙府争夺">>), Content, AssetList, ItemList});
mail_capture_award(ToRole = {_Rid, _SrvId, _Name}, {lose, _}, AL) ->
    {AssetList, ItemList} = parse_award(AL, [], []),
    Content = ?L(<<"很不幸，您的仙府被其他玩家夺走了。万幸的是，您的仆人偷偷将仙府资源带回来给了您。">>),
    mail_mgr:deliver(ToRole, {?L(<<"仙府争夺">>), Content, AssetList, ItemList}).

%% 收获资源
mail_reap_award(ToRole = {_Rid, _SrvId, _Name}, AL, Type) ->
    {AssetList, ItemList} = parse_award(AL, [], []),
    TypeStr = case Type of
        abandon -> <<"abandon">>;
        sys_gain -> <<"system">>;
        self_gain -> <<"self">>;
        _ -> <<"default">>
    end,
    Content = util:fbin(?L(<<"[~s]您在仙府收获了如下资源，请查收">>), [TypeStr]),
    mail_mgr:deliver(ToRole, {?L(<<"仙府争夺">>), Content, AssetList, ItemList});
mail_reap_award(_ToRole, _AL, _Type) ->
    ignore.

%% -----------------------------------------------
%% internal functions
%% -----------------------------------------------

%% 检测是否可进入准备区
check_enter_pre(#role{status = Status}) when Status =/= ?status_normal ->
    {false, ?L(<<"状态异常，不能进入">>)};
check_enter_pre(#role{event = Event}) when Event =/= ?event_no ->
    {false, ?L(<<"当前状态不能进入">>)};
check_enter_pre(#role{id = RoleId, team_pid = TeamPid}) when is_pid(TeamPid) ->
    case team_api:get_team_info(TeamPid) of
        {ok, #team{leader = #team_member{id = RoleId}, member = Members}} ->
            L = [{Id, Name, Pid} || #team_member{id = Id, name = Name, pid = Pid, mode = ?MODE_NORMAL} <- Members],
            {ok, L};
        {ok, #team{member = Members}} ->
            case lists:keyfind(RoleId, #team_member.id, Members) of
                #team_member{mode = ?MODE_TEMPOUT} ->
                    ok;
                _ ->
                    {false, ?L(<<"请由队长操作参加跨服仙府争夺活动">>)}
            end;
        _ ->
            {false, ?L(<<"请由队长操作参加跨服仙府争夺活动">>)}
    end;
check_enter_pre(#role{lev = _Lev, attr = #attr{fight_capacity = FightCapacity}}) when FightCapacity < 18000 ->
    {false, ?L(<<"很可惜，参加跨服仙府争夺需要18000战斗力以上，请努力修炼再来吧！">>)};
check_enter_pre(_) -> ok.

check_member_enter_pre([]) -> ok;
check_member_enter_pre([{Name, Status, Event, Lev, Attr} | T]) ->
    case do_check_member_enter_pre(Name, Status, Event, Lev, Attr) of
        {false, Msg} ->
            {false, Msg};
        ok -> check_member_enter_pre(T)
    end;
check_member_enter_pre([_ | _T]) ->
    {false, ?L(<<"队员状态异常，请退出队伍后参加活动">>)}.

do_check_member_enter_pre(Name, Status, _Event, _Lev, _Attr) when Status =/= ?status_normal ->
    {false, util:fbin(?L(<<"~s状态异常，不能进入">>), [Name])};
do_check_member_enter_pre(Name, _Status, Event, _Lev, _Attr) when Event =/= ?event_no ->
    {false, util:fbin(?L(<<"~s状态不能进入">>), [Name])};
do_check_member_enter_pre(Name, _Status, _Event, _Lev, #attr{fight_capacity = FightCapacity}) when FightCapacity < 18000 ->
    {false, util:fbin(?L(<<"参加跨服仙府争夺需要18000战斗力以上，~s还未达到！">>), [Name])};
do_check_member_enter_pre(_Name, _, _, _, _) ->
    ok.

%% -define(mail_coin, 0).        %% 金币
%% -define(mail_coin_bind, 1).   %% 绑定金币
%% -define(mail_gold, 2).        %% 晶钻
%% -define(mail_gold_bind, 3).   %% 绑定晶钻
%% -define(mail_arena, 4).       %% 竞技场积分
%% -define(mail_exp, 5).         %% 经验
%% -define(mail_psychic, 6).     %% 灵力
%% -define(mail_honor, 7).       %% 荣誉值
%% -define(mail_activity, 8).    %% 精力、活跃度
%% -define(mail_attainment, 9).  %% 阅力值
%% 解析资源
parse_award([], AL, IL) ->
    {AL, IL};
parse_award([{Id, _Bind, Num} | T], AL, IL) when Id < 100 ->
    parse_award(T, [{Id, Num} | AL], IL);
parse_award([{Id, Bind, Num} | T], AL, IL) ->
    parse_award(T, AL, [{Id, Bind, Num} | IL]);
parse_award([_ | T], AL, IL) ->
    parse_award(T, AL, IL).

