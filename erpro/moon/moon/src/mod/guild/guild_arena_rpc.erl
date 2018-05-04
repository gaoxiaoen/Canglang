%%----------------------------------------------------
%% @doc 新帮战系统RPC
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(guild_arena_rpc).

-export([handle/3
    ,push/3]).

-include("common.hrl").
-include("role.hrl").
-include("guild.hrl").
%%
-include("guild_arena.hrl").
-include("assets.hrl").

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% 帮战报名
handle(15901, {}, Role) ->
    Reply = case guild_arena_mgr:join(guild, Role) of
        ok -> {?true, ?L(<<"帮战报名成功">>)};
        {false, not_in_guild} -> {?false, ?L(<<"您还没有帮会">>)};
        {false ,no_permission} -> {?false, ?L(<<"只有帮主或者长老才能报名">>)};
        {false, wrong_level} -> {?false, ?L(<<"您的帮会级别低于5级，请提升帮会等级">>)};
        {false, already_join} -> {?false, ?L(<<"你的帮会已报名">>)};
        {false, wrong_time} -> {?false, ?L(<<"很遗憾，您错过了帮战报名时间">>)};
        {false, wrong_guild} -> {?false, ?L(<<"无效帮会">>)};
        {false, member_not_enough} -> {?false, ?L(<<"当前帮会在线人数不足5人，不能报名！">>)};
        _Else -> 
            ?DEBUG("意外的参数 ~p", [_Else]),
            {?false, ?L(<<"目前状态下，不能完成帮战报名">>)}
    end,
    {reply, Reply};

%% 进入准备区
handle(15902, {}, Role) ->
    case guild_arena_mgr:join(role, Role) of
        {ok, NewRole} -> 
            {reply, {?true, ?L(<<"成功进入战区">>)}, NewRole#role{event = ?event_guild_arena}};
        {false, not_in_guild} -> 
            {reply, {?false, ?L(<<"您还没有帮会">>)}};
        {false ,guild_not_join} -> 
            {reply, {?false, ?L(<<"您的帮会没有报名帮战">>)}};
        {false ,guild_lost} -> 
            {reply, {?false, ?L(<<"您的帮会在上一轮已经被淘汰">>)}};
        {false, in_team} -> 
            {reply, {?false, ?L(<<"您在队伍中不能进入帮战">>)}};
        {false, already_join} -> 
            {reply, {?false, ?L(<<"您已经在战区了">>)}};
        {false, wrong_time} -> 
            {reply, {?false, ?L(<<"很遗憾，现在不能进入战区了">>)}};
        {false, flying} -> 
            {reply, {?false, ?L(<<"飞行中不能进入帮战">>)}};
        {false, wrong_event} -> 
            {reply, {?false, ?L(<<"当前状态不能进入帮战">>)}};
        {false, cross_srv} ->
            {reply, {?false, ?L(<<"跨服场景中不能参加帮战, 请先返回本服服务器再参加">>)}};
        _Else -> 
            ?DEBUG("意外的参数 ~p", [_Else]),
            {reply, {?false, ?L(<<"目前状态下，不能完成帮战报名">>)}}
    end;


%% 退出帮战
handle(15903, {}, Role) ->
    [Reply, NewRole] = case guild_arena:off(Role) of
        ok -> 
            [{?true, ?L(<<"成功退出帮战">>)}, Role#role{event = ?event_no}];
        {false, in_team} -> 
            [{?false, ?L(<<"请先退出队伍，再离开帮战">>)}, Role];
        _ -> 
            [{?false, ?L(<<"退出帮战失败">>)}, Role]
    end,
    {reply, Reply, NewRole};

%% 帮战战况(帮派)
handle(15904, {Page}, #role{event = ?event_guild_arena, event_pid = EventPid, cross_srv_id = <<"center">>}) ->
    Reply = case ?CENTER_CALL(guild_arena_center, get_info, [EventPid, {guilds, Page}]) of
        {NewPage, Guilds, GuildNum} -> {?true, <<>>, NewPage, GuildNum, make_proto15904(Guilds)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    {reply, Reply};
handle(15904, {Page}, #role{id = Id}) ->
    Reply = case guild_arena_mgr:get_info({guilds, Page, Id}) of
        {NewPage, Guilds, GuildNum} -> {?true, <<>>, NewPage, GuildNum, make_proto15904(Guilds)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    {reply, Reply};

%% 帮战战况(个人)
handle(15905, {Page}, #role{event = ?event_guild_arena, event_pid = EventPid, cross_srv_id = <<"center">>}) ->
    Reply = case ?CENTER_CALL(guild_arena_center, get_info, [EventPid, {roles, Page}]) of
        {NewPage, Roles, RoleNum} -> {?true, <<>>, NewPage, RoleNum, make_proto15905(Roles)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    {reply, Reply};
handle(15905, {Page}, #role{id = Id}) ->
    Reply = case guild_arena_mgr:get_info({roles, Page, Id}) of
        {NewPage, Roles, RoleNum} -> {?true, <<>>, NewPage, RoleNum, make_proto15905(Roles)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    {reply, Reply};

%% 获取帮战状态
handle(15906, {}, #role{lev = Lev}) when Lev < ?join_lev_limit ->
    {reply, {0, 0, 0, 1}};
handle(15906, {}, Role = #role{id = Rid}) ->
    Reply = case guild_arena_mgr:able_to_cross(Role) of
        true -> 
            case ?CENTER_CALL(guild_arena_center_mgr, get_info, [{state_time, Rid}]) of
                {Id, StateId, Timeout} -> {Id, StateId, Timeout, 2};
                _R -> {0, 0, 0, 2}
            end;
        _ ->
            case guild_arena:get_info({state_time, Rid}) of
                {Id, StateId, Timeout} -> {Id, StateId, Timeout, 1};
                _R -> {0, 0, 0, 1}
            end
    end,
    {reply, Reply};

%% 帮战战区战况(帮派)
handle(15907, {Page}, #role{id = Id, cross_srv_id = <<"center">>, event_pid = EventPid, event = ?event_guild_arena}) ->
    Reply = case ?CENTER_CALL(guild_arena_center, get_info, [EventPid, {area_guilds, Page, Id}]) of
        {NewPage, Guilds, GuildNum} -> {?true, <<>>, NewPage, GuildNum, make_proto15907(Guilds)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    {reply, Reply};
handle(15907, {Page}, #role{id = Id}) ->
    Reply = case guild_arena_mgr:get_info({area_guilds, Page, Id}) of
        {NewPage, Guilds, GuildNum} -> {?true, <<>>, NewPage, GuildNum, make_proto15907(Guilds)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    {reply, Reply};

%% 帮战战区战况(个人)
handle(15908, {Page}, #role{id = Id, cross_srv_id = <<"center">>, event_pid = EventPid, event = ?event_guild_arena}) ->
    Reply = case ?CENTER_CALL(guild_arena_center, get_info, [EventPid, {area_roles, Page, Id}]) of
        {NewPage, Roles, RoleNum} -> {?true, <<>>, NewPage, RoleNum, make_proto15908(Roles)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    {reply, Reply};
handle(15908, {Page}, #role{id = Id}) ->
    Reply = case guild_arena_mgr:get_info({area_roles, Page, Id}) of
        {NewPage, Roles, RoleNum} -> {?true, <<>>, NewPage, RoleNum, make_proto15908(Roles)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    {reply, Reply};

%% 帮战个人战绩
handle(15909, {}, #role{id = Id, cross_srv_id = <<"center">>, event_pid = EventPid, event = ?event_guild_arena}) ->
    Reply = case ?CENTER_CALL(guild_arena_center, get_info, [EventPid, {mine, Id}]) of
        Role = #guild_arena_role{} -> make_proto15909(0, Role, 0);
        _ -> {?true, <<>>, 0, <<>>, <<>>, 0, 0, 0, 0, 0, []}
    end,
    {reply, Reply};
handle(15909, {}, #role{id = Id, event = ?event_guild_arena}) ->
%pack(srv, 15909, {P0_result, P0_reason, P0_type, P0_name, P0_guild_name, P0_score, P0_kill, P0_stone}) ->
    Reply = case guild_arena:get_info({mine, Id}) of
        Role = #guild_arena_role{} -> make_proto15909(0, Role, 0);
        _ -> {?true, <<>>, 0, <<>>, <<>>, 0, 0, 0, 0, 0, []}
    end,
    {reply, Reply};
handle(15909, {}, _) ->
    {ok};

%% 查看帮战报名帮派数
handle(15910, {}, _) ->
%pack(srv, 15909, {P0_result, P0_reason, P0_type, P0_name, P0_guild_name, P0_score, P0_kill, P0_stone}) ->
    Reply = case guild_arena:get_info(guild_num) of
        Num when is_integer(Num) -> {Num};
        _ -> {0}
    end,
    {reply, Reply};

%% 帮战报名情况(帮派)
handle(15911, {Page}, _) ->
    Reply = case guild_arena:get_info({sign_guilds, Page}) of
        {NewPage, Guilds, GuildNum} -> {?true, <<>>, NewPage, GuildNum, Guilds};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    {reply, Reply};

%% 查看是否可以进入帮战
handle(15913, {}, Role) ->
    Reply = case guild_arena:can_join(Role) of
        Round when is_integer(Round) -> {Round};
        _ -> {0}
    end,
    {reply, Reply};

%% 进入战区
handle(15914, {}, Role) ->
    case guild_arena_mgr:join(to_war_area, Role) of
        ok -> 
            {reply, {?true, ?L(<<"成功进入战区">>)}};
        {false, not_in_guild} -> 
            {reply, {?false, ?L(<<"您还没有帮会">>)}};
        {false ,guild_not_join} -> 
            {reply, {?false, ?L(<<"您的帮会没有报名帮战">>)}};
        {false, wrong_time} -> 
            {reply, {?false, ?L(<<"很遗憾，现在不能进入战区了">>)}};
        {false, not_in} -> 
            {reply, {?false, ?L(<<"很遗憾，现在不能进入战区了">>)}};
        {false, follow_team} -> 
            {reply, {?false, ?L(<<"您在跟随队伍中不能进入帮战">>)}};
        {false, flying} -> 
            {reply, {?false, ?L(<<"飞行中不能进入帮战">>)}};
        {false, wrong_event} -> 
            {reply, {?false, ?L(<<"当前状态不能进入帮战">>)}};
        _Else -> 
            ?DEBUG("意外的参数 ~p", [_Else]),
            {reply, {?false, ?L(<<"目前状态下，不能完成帮战报名">>)}}
    end;

%% 帮战战区战况(个人排名所在页)
handle(15915, {}, #role{id = Id, pid = Pid}) ->
    Reply = case guild_arena_mgr:get_info({my_rank, Id}) of
        {NewPage, Roles, RoleNum} -> {?true, <<>>, NewPage, RoleNum, make_proto15905(Roles)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    role:pack_send(Pid, 15905, Reply),
    {ok};

%% 帮战战区战况(所属帮派排名所在页)
handle(15916, {}, #role{id = MyId, pid = Pid, guild = #role_guild{gid = Id, srv_id = SrvId}}) ->
    Reply = case guild_arena_mgr:get_info({my_guild_rank, MyId, {Id, SrvId}}) of
        {NewPage, Guilds, GuildNum} -> {?true, <<>>, NewPage, GuildNum, make_proto15904(Guilds)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    role:pack_send(Pid, 15904, Reply),
    {ok};

%% 查看自己所在跨服战区id和当前是第几轮
handle(15917, {}, Role) ->
    Reply = guild_arena:get_area_and_round(Role),
    ?DEBUG("战区信息  ~w", [Reply]),
    {reply, Reply};

%% 本服帮战战况(帮派)
handle(15918, {Page}, _Role) ->
    Reply = case guild_arena:get_info({guilds, Page}) of
        {NewPage, Guilds, GuildNum} -> {?true, <<>>, NewPage, GuildNum, make_proto15904(Guilds)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    {reply, Reply};

%% 本服帮战战况(个人)
handle(15919, {Page}, _Role) ->
    Reply = case guild_arena:get_info({roles, Page}) of
        {NewPage, Roles, RoleNum} -> {?true, <<>>, NewPage, RoleNum, make_proto15905(Roles)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    {reply, Reply};

%% 跨服帮战战况某轮某战区(帮派)
handle(15920, {Round, AreaId, Page}, _Role) ->
    Reply = case guild_arena_mgr:get_info({guilds_round, Round, AreaId, Page}) of
        [Areas, {NewPage, Guilds, GuildNum}] -> 
            NewGuilds = make_proto15920(Guilds),
            {Areas, NewPage, GuildNum, NewGuilds};
        _ -> {[], 1, 0, []}
    end,
    {reply, Reply};

%% 跨服帮战战况某轮某战区(个人)
handle(15921, {Round, AreaId, Page}, _Role) ->
    Reply = case guild_arena_mgr:get_info({roles_round, Round, AreaId, Page}) of
        [Areas, {NewPage, Roles, RoleNum}] -> {Areas, NewPage, RoleNum, make_proto15921(Roles)};
        _ -> {[], 1, 0, []}
    end,
    {reply, Reply};

%% 跨服历届排名(帮派)
handle(15922, {Page}, _Role) ->
    Reply = case guild_arena_mgr:get_info({guilds_cross, Page}) of
        {NewPage, Guilds, GuildNum} -> {NewPage, GuildNum, make_proto15920(Guilds)};
        _ -> {1, 0, []}
    end,
    {reply, Reply};

%% 跨服历届排名(个人)
handle(15923, {Page}, _Role) ->
    Reply = case guild_arena_mgr:get_info({roles_cross, Page}) of
        {NewPage, Roles, RoleNum} -> {NewPage, RoleNum, make_proto15921(Roles)};
        _ -> {1, 0, []}
    end,
    {reply, Reply};

%% 本服帮战战况(所属帮派排名所在页)
handle(15924, {}, #role{pid = Pid, guild = #role_guild{gid = Id, srv_id = SrvId}}) ->
    Reply = case guild_arena:get_info({my_guild_rank, {Id, SrvId}}) of
        {NewPage, Guilds, GuildNum} -> {?true, <<>>, NewPage, GuildNum, make_proto15904(Guilds)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    role:pack_send(Pid, 15918, Reply),
    {ok};

%% 本服帮战战况(个人排名所在页)
handle(15925, {}, #role{id = Id, pid = Pid}) ->
    Reply = case guild_arena:get_info({my_rank, Id}) of
        {NewPage, Roles, RoleNum} -> {?true, <<>>, NewPage, RoleNum, make_proto15905(Roles)};
        _ -> {?true, <<>>, 1, 0, []}
    end,
    role:pack_send(Pid, 15919, Reply),
    {ok};

%% 自己帮派跨服帮战战况某轮(帮派)
handle(15926, {Round}, #role{pid = Pid, guild = #role_guild{gid = Id, srv_id = SrvId}}) ->
    Reply = case guild_arena_mgr:get_info({guilds_round_my_rank, Round, {Id, SrvId}}) of
        [Areas, {NewPage, Guilds, GuildNum}] -> 
            NewGuilds = make_proto15920(Guilds),
            {Areas, NewPage, GuildNum, NewGuilds};
        _ -> {[], 1, 0, []}
    end,
    role:pack_send(Pid, 15920, Reply),
    {ok};

%% 跨服帮战战况某轮某战区(个人)
handle(15927, {Round}, #role{id = Id, pid = Pid}) ->
    Reply = case guild_arena_mgr:get_info({roles_round_my_rank, Round, Id}) of
        [Areas, {NewPage, Roles, RoleNum}] -> {Areas, NewPage, RoleNum, make_proto15921(Roles)};
        _ -> {[], 1, 0, []}
    end,
    role:pack_send(Pid, 15921, Reply),
    {ok};

%% 自己帮派跨服帮战历届排名(帮派)
handle(15928, {}, #role{pid = Pid, guild = #role_guild{gid = Id, srv_id = SrvId}}) ->
    Reply = case guild_arena_mgr:get_info({guilds_cross_my_rank, {Id, SrvId}}) of
        {NewPage, Guilds, GuildNum} -> {NewPage, GuildNum, make_proto15920(Guilds)};
        _ -> {1, 0, []}
    end,
    role:pack_send(Pid, 15922, Reply),
    {ok};

%% 跨服帮战历届排名(个人)
handle(15929, {}, #role{id = Id, pid = Pid}) ->
    Reply = case guild_arena_mgr:get_info({roles_cross_my_rank, Id}) of
        {NewPage, Roles, RoleNum} -> {NewPage, RoleNum, make_proto15921(Roles)};
        _ -> {1, 0, []}
    end,
    role:pack_send(Pid, 15923, Reply),
    {ok};


handle(_Cmd, _Request, _Role = #role{name = _Name}) ->
    ?DEBUG("无效请求 name = ~s, cmd = ~w, request = ~w", [_Name, _Cmd, _Request]),
    {ok}.

%% @spec push(Pids, Cmd, Data)
%% Pids = [pid(), ...] | pid()
%% Cmd = atom()
%% Data = term()
%% 推送消息到客户端
%% 状态倒计时
push(Pid, state_time, Data) when is_pid(Pid) ->
    role:pack_send(Pid, 15906, Data);
%% 战区帮派战况
push(Pid, area_guilds, {NewPage, Guilds, GuildNum}) when is_pid(Pid) ->
    role:pack_send(Pid, 15907, {?true, <<>>, NewPage, GuildNum, make_proto15907(Guilds)});
%% 报名帮派总数
push(Pid, guild_num, {GuildNum}) when is_pid(Pid) ->
    role:pack_send(Pid, 15910, {GuildNum});
%% 通知前端打开邀请界面
push(Pid, open_invite, {Type}) when is_pid(Pid) ->
    role:pack_send(Pid, 15913, {Type});
%% 每一轮结束消息
push(Pid, round, {Type, Round, Msg, #guild_arena_role{name = Name, guild_name = GuildName, score = Score, kill = Kill, stone = Stone}}) when is_pid(Pid) ->
    role:pack_send(Pid, 15912, {Type, Round, Msg, Name, GuildName, Score, Kill, Stone});
%% 我的战绩
push(Pid, mine, {Type, ArenaRole, RoundScore, EnemyNames}) when is_pid(Pid) ->
    role:pack_send(Pid, 15909, make_proto15909(Type, ArenaRole, RoundScore, EnemyNames));
push(_, _Cmd, _Para) ->
    ?DEBUG("无效请求 cmd = ~w, para = ~w", [_Cmd, _Para]),
    {ok}.

%% 生成个人战绩数据
make_proto15909(Type, GuildRole, RoundScore) ->
    make_proto15909(Type, GuildRole, RoundScore, []).
make_proto15909(Type, #guild_arena_role{name = Name, guild_name = GuildName, score = Score, kill = Kill, stone = Stone, die = Die}, RoundScore, EnemyNames) ->
    {?true, <<>>, Type, Name, GuildName, Score, Kill, Stone, RoundScore, ?guild_arena_role_max_die - Die, EnemyNames};
make_proto15909(_T, _R, _S, _N) ->
    ?DEBUG("无效参数 ~p ~p ~p ~p", [_T, _R, _S, _N]),
    {?true, <<>>, 0, <<>>, <<>>, 0, 0, 0, 0, 0, []}.

%% 生成个人15905协议列表内容
make_proto15905(Roles) ->
    F = fun(#guild_arena_role{id = {Rid, SrvId}, name = Name, guild_name = GuildName, sum_score = SumScore, sum_kill = SumKill, sum_stone = SumStone, fc = Fc}) ->
            {Rid, SrvId, Name, GuildName, SumScore, SumKill, SumStone, Fc}
    end,
    [F(R) || R <- Roles].

%% 生成个人15908协议列表内容
make_proto15908(Roles) ->
    F = fun(#guild_arena_role{id = {Rid, SrvId}, name = Name, guild_name = GuildName, score = Score, kill = Kill, stone = Stone, fc = Fc}) ->
            {Rid, SrvId, Name, GuildName, Score, Kill, Stone, Fc}
    end,
    [F(R) || R <- Roles].

%% 生成帮派15904协议列表内容
make_proto15904(Guilds) ->
    F = fun(#arena_guild{id = {Gid, SrvId}, name = Name, join_num = JoinNum, sum_score = SumScore, sum_kill = SumKill, sum_stone = SumStone, lev = Lev, die = Die}) ->
            {Gid, SrvId, Name, JoinNum, SumKill, SumScore, SumStone, Lev, Die}
    end,
    [F(G) || G <- Guilds].

%% 生成帮派15907协议列表内容
make_proto15907(Guilds) ->
    F = fun(#arena_guild{id = {Gid, SrvId}, name = Name, join_num = JoinNum, score = Score, kill = Kill, stone = Stone, die = Die}) ->
            {Gid, SrvId, Name, JoinNum, Kill, Score, Stone, Die}
    end,
    [F(G) || G <- Guilds].

%% 生成帮派15920协议列表内容
make_proto15920(Guilds) ->
    F = fun(#guild_arena_guild_cross{id = {Gid, SrvId}, name = Name, chief = Chief, member_num = MemNum, lev = Lev, current_score = CurrentScore, round_score = RoundScore, total_score = TotalScore}) ->
            {Gid, SrvId, Name, Chief, MemNum, Lev, CurrentScore, RoundScore, TotalScore}
    end,
    [F(G) || G <- Guilds].

%% 生成帮派15921协议列表内容
make_proto15921(Roles) ->
    F = fun(#guild_arena_role_cross{id = {Id, SrvId}, name = Name, lev = Lev, gid = {Gid, GSrvId}, career = Career, fc = Fc, guild_name = GuildName, current_score = CurrentScore, round_score = RoundScore, total_score = TotalScore}) ->
            {Id, SrvId, Name, Lev, Career, Fc, Gid, GSrvId, GuildName, CurrentScore, RoundScore, TotalScore}
    end,
    [F(R) || R <- Roles].
