%%----------------------------------------------------
%% @doc 巅峰对决
%%
%% <pre>
%% 巅峰对决远程过程调用模块173
%% </pre> 
%% @author yqhuang(QQ:19123767)
%% @author abu
%% @end
%%----------------------------------------------------
-module(top_fight_rpc).

-export([
        handle/3
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("top_fight.hrl").
-include("pos.hrl").
%%
-include("link.hrl").
-include("attr.hrl").

%% 登录后客户端主动请求
handle(17300, {}, _Role = #role{event = ?event_top_fight_match}) ->
    {reply, {3, 0}};
handle(17300, {}, _Role) ->
    Reply = case top_fight_mgr:atime(notice) of
        {ok, R} ->
            R;
        _ ->
            ?DEBUG("[巅峰对决]获取开始报名时间有误!"),
            {0, 0}
    end,
    {reply, Reply};

%% 巅峰对决报名
handle(17301, {}, _Role = #role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {reply, {?top_fight_op_fail, ?L(<<"组队状态不可以报名竞技场活动">>)}};
handle(17301, {}, Role = #role{event = ?event_no, pos = #pos{map = MapId, x = X, y = Y}}) ->
    Reply = case top_fight_center_mgr:sign_up(Role) of
        {ok, NewRole = #role{pos = Pos}} ->
            log:log(log_coin, {<<"巅峰对决报名">>, <<"">>, Role, NewRole}),
            %notice:send_interface({connpid, ConnPid}, 9, Account, SrvId, Name, <<"">>, []),
            {reply, {?top_fight_op_succ, ?L(<<"报名成功">>)}, NewRole#role{pos = Pos#pos{last = {MapId, X, Y}}}};
        {false, Reason} ->
            {reply, {?top_fight_op_fail, Reason}};
        _ ->
            {reply, {?top_fight_op_fail, ?L(<<"你们与时空隧道失去联系!">>)}}
    end,
    Reply;
handle(17301, {}, _Role = #role{event = ?event_dungeon}) ->
    {reply, {?top_fight_op_fail, ?L(<<"在副本内不能报名">>)}};
handle(17301, {}, _Role = #role{event = ?event_guild}) ->
    {reply, {?top_fight_op_fail, ?L(<<"在帮会领地内不可报名">>)}};
handle(17301, {}, _Role) ->
    {reply, {?top_fight_op_fail, ?L(<<"当前状态不可以报名">>)}};

%% 确定进入战场，及设置是否蒙面
%% handle(17302, {1}, _Role = #role{cross_srv_id = <<"center">>}) ->
%%     {reply, {?top_fight_op_fail, <<"不能蒙面请入战场">>}};
handle(17302, {}, Role = #role{cross_srv_id = <<"center">>}) ->
    case top_fight_center_mgr:enter_match(Role, 0) of
        {ok} ->
            {reply, {?top_fight_op_succ, ?L(<<"操作成功">>)}};
        {false, Reason} ->
            {reply, {?top_fight_op_fail, Reason}}
    end;

%% 退出竞技场
handle(17303, {}, Role = #role{pid = _Pid, cross_srv_id = <<"center">>}) ->
    case top_fight_center_mgr:exit_match(Role) of
        ok ->
            {reply, {?top_fight_op_succ, ?L(<<"操作成功">>)}};
        {false, Reason} ->
            {reply, {?top_fight_op_fail, Reason}}
    end;

%% 请求排行榜信息
handle(17309, {}, #role{event = ?event_top_fight_match, event_pid = EventPid}) ->
    case top_fight_center:get_rank(EventPid) of
        {ok, Reply} ->
            {reply, {Reply}};
        _ ->
            {ok}
    end;
handle(17309, {}, _Role) ->
    {ok};

%% 获取准备/比赛时间
handle(17311, {}, #role{event = ?event_top_fight_prepare}) ->
    case top_fight_mgr:atime(prepare) of
        {ok, Reply} -> 
            {reply, {1, Reply}};
        _ -> {ok}
    end;
handle(17311, {}, #role{event = ?event_top_fight_match}) ->
    case top_fight_mgr:atime(match) of
        {ok, Reply} -> {reply, {2, Reply}};
        _ -> {ok}
    end;
handle(17311, {}, _Role) ->
    {ok};

%% 添加buff
handle(17315, {TarRoleId, TarSrvId}, #role{id = {RoleId, SrvId}}) when TarRoleId =:= RoleId andalso  TarSrvId =:= SrvId ->
    {reply, {?false, ?L(<<"不可以给自己加buff">>)}};
handle(17315, {TarRoleId, TarSrvId}, #role{id = {RoleId, SrvId}, event =?event_top_fight_match, event_pid = EventPid, cross_srv_id = <<"center">>}) ->
    case top_fight_center:add_buff(EventPid, {RoleId, SrvId}, {TarRoleId, TarSrvId}) of
        ok -> 
            {reply, {?true, ?L(<<"鼓舞成功,组员的战斗能力提高了">>)}};
        {false, Reason} ->
            {reply, {?false, Reason}}
    end;
handle(17315, {_TarRoleId, _TarSrvId}, _Role) ->
    {reply, {?false, ?L(<<"当前状态属非法操作">>)}};

%% 获取组员列表
handle(17316, {}, #role{id = {RoleId, SrvId}, event = ?event_top_fight_match, event_pid = EventPid}) ->
    case top_fight_center:group_list(EventPid, RoleId, SrvId) of
        {ok, GroupList} -> {reply, {GroupList}};
        _ -> {ok}
    end;
handle(17316, {}, _Role) ->
    {ok};

%% 竞技场统计信息 
handle(17317, {}, #role{event = ?event_top_fight_match, event_pid = EventPid}) ->
    case top_fight_center:group_num(EventPid) of
        {ok, Dragon, Tiger} -> {reply, {Tiger, Dragon}};
        _ -> {ok}
    end;
handle(17317, {}, _Role) ->
    {ok};

%% 斩杀信息
handle(17318, {}, #role{id = {RoleId, SrvId}, event = ?event_top_fight_match, event_pid = EventPid}) ->
    case top_fight_center:kill_report(EventPid, RoleId, SrvId) of
        {ok, Score, Kill} -> 
            {reply, {Score, Kill}};
        _Other -> 
            {ok}
    end;
handle(17318, {}, _Role) ->
    {ok};

%% 地点
handle(17319, {}, _Role = #role{event = ?event_top_fight_match}) ->
    {reply, {2}};
handle(17319, {}, _Role = #role{event = ?event_top_fight_prepare}) ->
    {reply, {3}};
handle(17319, {}, _Role) ->
    {reply, {1}};

%% 竞技场面板信息
handle(17322, {}, _Role) ->
    case top_fight_center_mgr:get_panel_info() of
        {ok, {Status, LowName, MiddleName, HightName, SuperName, AngleName, GodName}} -> 
            {reply, {Status, LowName, MiddleName, HightName, SuperName, AngleName, GodName}};
        {false, _Reason} ->
            {reply, {4, <<>>, <<>>, <<>>, <<>>, <<>>, <<>>}}
    end;

%% 竞技场英雄榜
handle(17325, {ArenaSeq}, _Role) ->
    case top_fight_mgr:get_hero_rank(ArenaSeq) of
        {ok, Num, #top_fight_hero_zone{winner = Winner, hero_list = HeroList}} ->
            {reply, {Num, Winner, HeroList}};
        {false, _Reason} ->
            ?DEBUG("[竞技场]获取竞技场英雄榜有误:~w", [_Reason]),
            {reply, {0, 0, []}}
    end;

%% 竞技场霸主列表
handle(17326, {}, _Role) ->
    case top_fight_mgr:get_hero() of
        {ok, HeroList} ->
            {reply, {HeroList}};
        _ ->
            {reply, {[]}}
    end;

%% 获取霸主
handle(17327, {}, _Role) ->
    case top_fight_mgr:get_top_hero() of
        {ok, #top_fight_top_hero{role_id = RoleId, srv_id = SrvId, name = Name, career = Career, lev = Lev, fight_capacity = Fc, pet_fight_capacity = PetFc, vip = Vip, sex = Sex, looks = Looks, eqms = Eqms}} ->
            {reply, {1, <<>>, RoleId, SrvId, Name, Career, Lev, Fc, PetFc, Vip, Sex, Looks, Eqms}};
        _ ->
            {reply, {0, <<>>, 0, <<>>, <<>>, 0, 0, 0, 0, 0, 0, [], []}}
    end;

%% 容错函数
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
