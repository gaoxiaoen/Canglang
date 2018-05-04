%%----------------------------------------------------
%% 地图相关远程调用
%% @author yeahoo2000@gmail.com
%%
%% ## 进入地图操作流程：
%% 1 请求进入指定地图
%% 2 判定进入条件
%% ## 进入成功后:
%% 1 离开上一个地图
%% 2 加入新地图，并隐藏角色，然后等待地图加载完成
%% 3 客户端收到进入成功事件后，开始加载场景角色和地图元素，加载完成后发送加载完成事件
%% 4 服务端收到地图加载完成事件时广播显示角色事件和角色进入事件
%%----------------------------------------------------
-module(map_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("link.hrl").
-include("map.hrl").
-include("arena_career.hrl").
-include("compete.hrl").
-include("jail.hrl").
-include("tutorial.hrl").
-include("map_line.hrl").
-include("demon.hrl").

%%

%% 角色刚登录时加载首个场景
handle(10100, {0, _}, Role = #role{event = ?event_tree}) ->
    Role2 = tree_api:enter(Role),
    {ok, Role2};

handle(10100, {0, _}, #role{event = ?event_jail, link = #link{conn_pid = ConnPid}, 
        pos = #pos{map = ?jail_map_id, x = X, y = Y}}) ->
    sys_conn:pack_send(ConnPid, 10110, {?jail_map_id, X, Y}),
    {ok};

handle(10100, {0, _}, _Role = #role{id = Rid, pid = RolePid, event = ?event_wanted}) ->
    wanted_mgr:login_enter(RolePid, Rid);

%% 中庭战神
handle(10100, {0, _}, Role = #role{event = ?event_arena_career}) ->
    Role2 = arena_career:reenter_map(Role),
    {ok, Role2};
%% 妖精碎片掠夺
handle(10100, {0, _}, Role = #role{event = ?event_demon_challenge}) ->
    Role2 = demon_challenge:reenter_map(Role),
    {ok, Role2};

%%PVP竞技场房间
handle(10100, {0, _}, #role{event = ?event_hall, link = #link{conn_pid = ConnPid}, 
        pos = #pos{map = ?compete_prepare_map_id, x = X, y = Y}}) ->
    sys_conn:pack_send(ConnPid, 10110, {?compete_prepare_map_id, X, Y}),
    {ok};

%% 试炼场
handle(10100, {0, _}, Role = #role{event = ?event_trial}) ->
    Role2 = trial_combat:reenter_map(Role),
    {ok, Role2};

%% 进入新手剧情副本场景
?tutorial_handle(10100, {0, _Any}, Role);
%% handle(10100, {0, _}, #role{pos = #pos{map_pid = MapPid}}) when is_pid(MapPid) -> {ok}; %% 不是刚登录时，忽略请求
handle(10100, {0, _}, Role = #role{}) ->
    %% 因为副本类的地图不会永久存在，进入此类地图之前必须记录下前一刻所在的普通地图
    %% 检查当前地图是否存在，如果不存在则使用最后一次记录的地点
    case get_map_info(Role) of
        {MapGid, MapBaseId, X, Y, NewRole} ->
            %% 第一次登陆检测飞行状态以及所处位置是否合法
            {Role0, ToX, ToY} = fly_api:check_map(NewRole, MapBaseId, X, Y),
            case map:role_enter(MapGid, ToX, ToY, Role0) of
                {ok, NewR} -> 
                    {ok, NewR};
                {false, 'bad_pos'} -> 
                    {notice:alert(error, Role, ?MSGID(<<"进入地图失败:无效的坐标">>))};
                {false, 'bad_map' } -> 
                    {notice:alert(error, Role, ?MSGID(<<"进入地图失败:不存在的地图">>))};
                {false, _Reason } -> 
                    {notice:alert(error, Role, ?MSGID(<<"进入地图失败">>))}
            end;
        _ -> 
            {notice:alert(error, Role, ?MSGID(<<"进入地图失败:不存在的地图">>))}
    end;

%% 过滤非法请求
handle(10100, {_ElemId, _Action}, Role = #role{status = Status}) when Status =/= ?status_normal ->
    {notice:alert(error, Role, ?MSGID(<<"当前状态下无法触发地图元素">>))};

%% 对某个地图元素进行操作
handle(10100, {ElemId, Action}, Role = #role{pos = Pos}) ->
    %% ?DEBUG("handle elem: ~w~n", [{ElemId, Action}]),
    case map:elem_action(map:gid(Pos), ElemId, Action, Role) of
        {false, Reason} -> {notice:alert(error, Role, Reason)};
        {ok} -> {ok};
        {ok, NewRole} -> {ok, NewRole};
        {ok, NewRole, Msg} -> {notice:alert(succ, Role, Msg), NewRole}
    end;

%% 直接传送场景(非副本)
handle(10101, Data, Role = #role{tutorial = #tutorial{}}) ->
    handle(10101, Data, Role#role{tutorial = undefined});  %% 新手副本防出错
handle(10101, {MapId}, Role = #role{pos = #pos{map = _MapId}}) ->
    case map_data:get(MapId) of
        false ->
            {notice:alert(error, Role, ?MSGID(<<"进入地图失败:不存在的地图">>))};
        _Map ->
            {DestX, DestY} = 
                
                %% 从荣耀学院出来的特殊处理，下面坐标硬编码有点粗暴！
                case _MapId =:= 200 andalso MapId =:= 1405 of 
                    false -> 
                        ?map_def_xy;
                    true -> {1616, 391} 
                end,
            
            case map:role_enter(MapId, DestX, DestY, Role) of
                {false, _Reason} ->
                    ?ERR("进入场景出错：~p", [_Reason]),
                    {notice:alert(error, Role, ?MSGID(<<"无法进入场景">>))};
                {ok, NewRole} -> 
                    {ok, NewRole}
            end
    end;

%% 对某个地图元素进行操作
handle(10102, {}, _Role = #role{max_map_id = MapId}) ->
    {reply, {MapId}};

%% 请求地图元素
%% 军团副本
%%handle(10111, {}, Role = #role{event = ?event_guild_td}) ->
%%    {reply, {[], [], []}, Role#role{status = ?status_normal}};
%%请求世界树地图元素
handle(10111, {}, Role = #role{event = ?event_tree}) ->
    {reply, {[], [], []}, Role#role{status = ?status_normal}};
%%请求悬赏Boss地图元素
handle(10111, {}, Role = #role{event = ?event_wanted}) ->
    {reply, {[], [], []}, Role#role{status = ?status_normal}};
handle(10111, {}, Role = #role{pos = #pos{map = ?compete_prepare_map_id}}) ->
    {reply, {[], [], []}, Role#role{status = ?status_normal}};
handle(10111, {}, Role = #role{pos = #pos{map = ?jail_map_id}}) ->
    {reply, {[], [], []}, Role#role{status = ?status_normal}};
%%请求中庭战神地图元素
handle(10111, {}, Role = #role{event = ?event_arena_career, pos = #pos{map = ?arena_career_map_id}, combat_pid = CombatPid, arena_career = #arena_career{target=Target}}) ->
    case is_pid(CombatPid) andalso erlang:is_process_alive(CombatPid) of
        true -> %% 战斗中
            {NewRole, TargetMapRoles} = case Target of
                {TargetRid, TargetSrvId} ->
                    case arena_career:get_role(TargetRid, TargetSrvId) of
                        false ->
                            {arena_career:leave_map(Role), []};
                        ARole ->
                            TargetRole = arena_career:to_fight_role(ARole, Role#role.pos),
                            {ok, TargetMR} = role_convert:do(to_map_role, TargetRole),
                            {Role, [TargetMR]}
                    end;
                _ ->
                    {arena_career:leave_map(Role), []}
            end,
            {reply, {[], [], TargetMapRoles}, NewRole};
        _ -> %% 不在战斗中(bug引起)
            {ok, arena_career:leave_map(Role)}
    end;
%%请求荣耀学院试炼场地图元素
handle(10111, {}, Role = #role{event = ?event_trial, combat_pid = CombatPid}) ->
    case is_pid(CombatPid) andalso erlang:is_process_alive(CombatPid) of
        true -> %% 战斗中
            {reply, {[], [], []}};
        _ -> %% 不在战斗中(bug引起)
            {ok, trial_combat:leave_map(Role)}
    end;
%%请求妖精碎片掠夺地图元素
handle(10111, {}, Role = #role{event = ?event_demon_challenge, pos = #pos{map = ?demon_challenge_map_id}, combat_pid = CombatPid}) ->
    case is_pid(CombatPid) andalso erlang:is_process_alive(CombatPid) of
        true -> %% 战斗中
            {reply, {[], [], []}};
        _ -> %% 不在战斗中(bug引起)
            {ok, demon_challenge:leave_map(Role)}
    end;

%% 请求新手剧情副本场景元素
?tutorial_handle(10111, Data, Role);

handle(10111, {}, Role = #role{status = ?status_transfer, pos = #pos{map_base_id = MapBaseId, map_pid = MapPid, x = X, y = Y}, link = #link{conn_pid = ConnPid}, scene_id = SceneId}) ->
    map:send_10111(MapPid, self(), get(conn_pid), X, Y),
    #map_data{type = Type} = map_data:get(MapBaseId),
    case SceneId =/= 0 andalso Type =:= 1 of true -> sys_conn:pack_send(ConnPid, 10163, {SceneId}); false -> skip end, %% 推送是否第一次进去主城信息
    vip:push_charge_flag(Role), %% 推送首充界面信息
    {ok, Role#role{status = ?status_normal}};

handle(10111, {}, #role{event = _Event, pos = #pos{map_pid = MapPid, x = X, y = Y}}) ->
    ?DEBUG("  事件标志  ~w", [_Event]),
    map:send_10111(MapPid, self(), get(conn_pid), X, Y),
    {ok};

%% 客户端地图数据加载完成事件
%% handle(10112, {}, Role = #role{pos = Pos = #pos{map_pid = MapPid}}) ->
%%     NewRole = Role#role{pos = Pos#pos{hidden = 1}},
%%     %% TODO: 是否需要更新这个状态
%%     {ok, Mr} = role_convert:do(to_map_role, NewRole),
%%     map:role_update(MapPid, Mr),
%%     {ok, NewRole};

%% 新手剧情副本场景内移动
?tutorial_handle(10115, Data, Role);

%% 未进入地图时忽略掉移动操作
handle(10115, {_DestX, _DestY, _Dir}, #role{name = _Name, pos = #pos{map_pid = MapPid}})
when false =:= is_pid(MapPid) ->
    ?DEBUG("角色[~s]未进入地图时发送了移动包", [_Name]),
    {ok};

%% 传送状态下忽略掉移动操作
handle(10115, {_DestX, _DestY, _Dir}, #role{name = _Name, status = ?status_transfer}) ->
    ?DEBUG("角色[~s]发送了移动包，但处于传送状态，不于处理", [_Name]),
    {ok};

%% 死亡状态下忽略掉移动操作
handle(10115, {_DestX, _DestY, _Dir}, #role{name = _Name, status = ?status_die}) ->
    ?DEBUG("角色[~s]发送了移动包，但处于死亡状态，不于处理", [_Name]),
    {ok};

handle(10115, {_DestX, _DestY, _Dir}, #role{name = _Name, event = ?event_tree}) ->
    ?DEBUG("角色[~s], event_tree, 发送了移动包，不于处理", [_Name]),
    {ok};

handle(10115, {_DestX, _DestY, _Dir}, #role{name = _Name, event = ?event_wanted}) ->
    ?DEBUG("角色[~s], event_wanted, 发送了移动包，不于处理", [_Name]),
    {ok};

%% 打坐状态下移动
handle(10115, Data = {_, _, _}, Role = #role{action = Action})
when Action >= ?action_sit andalso Action =< ?action_sit_demon ->
    %% TODO: 可能会出现bug：先设置移动的方向，否则客户端显示可能会有问题
    %% 注意handle_sit返回值
    handle(10115, Data, sit:handle_sit(?action_no, Role));

%% 帮会领地内，移动
handle(10115, {DestX, DestY, Dir}, Role = #role{pid = Rpid, status = Status, event = ?event_guild, pos = Pos = #pos{map_pid = MapPid, x = X, y = Y}}) when Status =:= ?status_normal -> %% 正常状态下才可以移动
    map:role_move_towards(MapPid, Rpid, X, Y, DestX, DestY, Dir),
    {ok, guild_area:moved(Role#role{pos = Pos#pos{dest_x = DestX, dest_y = DestY, dir = Dir}})};

%% 组队移动
%% handle(10115, {DestX, DestY, Dir}, Role = #role{team_pid = Tpid}) when is_pid(Tpid) ->
%%     team:move(Tpid, Role, {DestX, DestY, Dir}),
%%     {ok, Role}; %% 如果不返回Role，则打坐取消操作时会有bug哦

%% 无组队移动
handle(10115, {DestX, DestY, Dir}, Role = #role{pid = Rpid, status = Status, event = Event, pos = Pos = #pos{map_pid = MapPid, x = X, y = Y}}) when Status =:= ?status_normal -> %% 正常状态下才可以移动
    case Event of
        ?event_guild_war -> %% 帮战中对移动做特殊处理
            guild_war:disturb(Role);
        ?event_guild_arena -> %% 新帮战同样要处理
            guild_arena:stop_collect(Role);
        ?event_guard_counter -> %% 洛水反击战中
            guard_counter:move_disturb(Role);
        _ ->
            ok
    end,
    map:role_move_towards(MapPid, Rpid, X, Y, DestX, DestY, Dir),
    {nosync, Role#role{pos = Pos#pos{dest_x = DestX, dest_y = DestY, dir = Dir}}};

%% 移动容错
handle(10115, {_DestX, _DestY, _Dir}, #role{status = _Status}) ->
    ?DEBUG("在状态[~w]下收到无效的移动请求", [_Status]),
    {ok};

%% 获取分线信息
handle(10160, _, _Role = #role{pos = #pos{line = CurrLine}}) ->
    List = [ {Line, if Size > ?LINE_CAPACITY -> 1; true -> 0 end} || {Line, Size} <- map_line:info() ],
    {reply, {CurrLine, List}};

%% 获取当前线路
handle(10161, _, _Role = #role{pos = #pos{line = Line}}) ->
    {reply, {Line}};

%% 切换线路
handle(10162, {ToLine}, Role = #role{pos = #pos{line = CurrLine}}) ->
    LineNum = map_line:line_num(),
    case ToLine  of
        CurrLine -> 
            {reply, {?false}};
        _ when ToLine > LineNum orelse ToLine < 1 -> 
            {reply, {?false}};
        _ ->
            case map_line:switch(ToLine, Role) of
                {ok, NewRole} ->
                    {reply, {?true}, NewRole};
                _Err ->
                    ?DEBUG("~p", [_Err]),
                    {reply, {?false}}
            end
    end;

%% 客户端通知章节完成
handle(10164, _, Role = #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 10163, {0}),
    {ok, Role#role{scene_id = 0}};

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

%% -------------------------------------------
%% 内部处理
%% -------------------------------------------
%% 验证地图当前是否存在，并提取信息
get_map_info(Role = #role{id = {RoleId, SrvId}, name = RoleName, cross_srv_id = CrossSrvId, pos = #pos{map = CMapId,  x = Cx, y = Cy, last = {LMapId, Lx, Ly}, map_base_id = MapBaseId, line = Line}}) ->
    CMapGid = map:gid(Line, CMapId, MapBaseId),
    case map_mgr:get_map_info(CrossSrvId, CMapGid) of
        [#map{id = CMapId, base_id = CMapBaseId}] when MapBaseId =:= CMapBaseId orelse MapBaseId < 10000 orelse CMapId < 100000 ->
            {NewX, NewY} = case map_data:get(CMapBaseId) of
                #map_data{width = Width, height = Height} when Width =< Cx orelse Height =< Cy orelse Cx < 0 orelse Cy < 0 -> 
                    ?ERR("角色[Rid:~w, SrvId:~s, Name:~s, CrossSrvId:~s]进入地图出错, 超大的地图坐标[EMapBaseId:~w, MapBaseId:~w, Cx:~w, Cy:~w]", [RoleId, SrvId, RoleName, CrossSrvId, CMapBaseId, MapBaseId, Cx, Cy]),
                    {Width, Height};
                _ -> 
                    {Cx, Cy}
            end,
            {CMapGid, CMapBaseId, NewX, NewY, Role}; 
        [#map{base_id = EMapBaseId}] -> %% map base id不一致
            ?ERR("角色[Rid:~w, SrvId:~s, Name:~s, CrossSrvId:~s]进入地图出错, 错误的地图坐标[EMapBaseId:~w, MapBaseId:~w, Cx:~w, Cy:~w]", [RoleId, SrvId, RoleName, CrossSrvId, EMapBaseId, MapBaseId, Cx, Cy]),
            {{Line, ?capital_map_id}, ?capital_map_id, ?map_def_x, ?map_def_y, Role#role{cross_srv_id = <<>>}};
        _ -> 
            LMapGid = map:gid(Line, LMapId, LMapId),
            case map_mgr:get_map_info(CrossSrvId, LMapGid) of
                [#map{id = LMapId, base_id = MapBaseId2}] -> 
                    case map_data:get(MapBaseId2) of
                        #map_data{width = W, height = H} when W > Lx andalso H > Ly ->
                            {LMapGid, MapBaseId2, Lx, Ly, Role}; 
                        _ ->
                            {{Line, ?capital_map_id}, ?capital_map_id, ?map_def_x, ?map_def_y, Role#role{cross_srv_id = <<>>}}
                    end;
                _ -> 
                    {{Line, ?capital_map_id}, ?capital_map_id, ?map_def_x, ?map_def_y, Role#role{cross_srv_id = <<>>}}
            end
    end.

