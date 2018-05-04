%%----------------------------------------------------
%% 帮会历练远程调用
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(guild_practise_rpc).
-export([handle/3]).

-include("common.hrl").
-include("role.hrl").
-include("guild.hrl").
-include("guild_practise.hrl").
-include("gain.hrl").
-include("link.hrl").
%%

%% 获取自身历练数据
handle(Mod, Data, Role = #role{guild_practise = GuildPra}) when not is_record(GuildPra, guild_practise) ->
    handle(Mod, Data, Role#role{guild_practise = #guild_practise{}});

handle(_Mod, _Data, #role{lev = Lev}) when Lev < ?guild_practise_min_lev ->
    {ok};

handle(15100, {}, Role = #role{guild_practise = GuildPra = #guild_practise{day_time = DayTime, status = RoleStatus}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}, id = Rid}) ->
    case guild_practise_mgr:apply(sync, {self, {Gid, Gsrvid}, Rid, GuildPra}) of 
        {ok, #guild_practise_role{luck = Luck, refresh_time = RT, status = Status, help_others = Others, refresh_self = Self, quality = Q, task_id = TaskId, refresh_list = RList}} ->
            Now = util:unixtime(),
            Role1 = case util:is_same_day2(Now, DayTime) of
                false when Status =/= RoleStatus -> %% 不是同一天 状态异常处理
                    Role#role{guild_practise = GuildPra#guild_practise{status = Status, quality = Q, task_id = TaskId}};
                _ ->
                    Role 
            end,
            {ok, NRole = #role{guild_practise = #guild_practise{exp = Exp, psychic = _Psychic, progress = Progs}}} = guild_practise:calc_reward(Role1, Q),
            {Value, TargetVal} = case Progs of
                [#guild_practise_progress{value = Val, target_value = TVal}] -> {Val, TVal};
                _ -> {0, 0}
            end,
            {reply, {Luck, RT, Status, Others, Self, Q, TaskId, RList, Exp, 0, Value, TargetVal}, NRole};
        _ ->
            {ok}
    end;

%% 获取帮会其它成员信息
handle(15101, {}, _Role = #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_practise_mgr:lookup(Gid, Gsrvid) of
        #guild_practise_list{list = Members} when is_list(Members) ->
            {reply, {Members}};
        _ ->
            {ok}
    end;

%% 查看任务
handle(15102, {}, Role = #role{link = #link{conn_pid = ConnPid}, guild_practise = GuildPra = #guild_practise{day_time = DayTime, status = OldStatus}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    Now = util:unixtime(),
    case util:is_same_day2(Now, DayTime) of
        true when OldStatus =:= ?guild_practise_status_commit ->
            {reply, {0, ?L(<<"今天帮会试练任务已完成">>)}};
        _ ->
            case guild_practise_mgr:apply(sync, {look_task, {Gid, Gsrvid}, Role}) of
                {ok, #guild_practise_role{quality = Q, task_id = TaskId, refresh_time = Time, status = Status}} ->
                    {ok, NRole} = guild_practise:calc_reward(Role#role{guild_practise = GuildPra#guild_practise{status = Status}}, Q),
                    sys_conn:pack_send(ConnPid, 15105, {1, <<>>, TaskId, Time}),
                    {reply, {1, <<>>}, NRole};
                {false, Reason} ->
                    {reply, {0, Reason}};
                _ ->
                    {ok}
            end
    end;

%% 接受任务
handle(15103, {}, Role) ->
    case guild_practise:accept(Role) of
        {ok, NewRole} ->
            {reply, {1, <<>>}, NewRole};
        {false, Reason} ->
            {reply, {0, Reason}}
    end;

%% 提交任务
handle(15104, {}, Role) ->
    case guild_practise:finish(Role) of
        {ok, NewRole} ->
            {reply, {1, <<>>}, NewRole};
        {false, Reason} ->
            {reply, {0, Reason}}
    end;

%% 刷新任务类型 Type = 1:花钱,0:到点免费
handle(15105, {Type = 0}, Role = #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_practise_mgr:apply(sync, {refresh_task, {Gid, Gsrvid}, Type, Role}) of
        {ok, TaskId, Time} ->
            {reply, {1, <<>>, TaskId, Time}};
        {false, Reason} ->
            {reply, {0, Reason, 0, 0}};
        _ ->
            {ok}
    end;
handle(15105, {Type = 1}, Role = #role{pid = Pid, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    GL = #loss{label = gold, val = pay:price(?MODULE, refresh, null)},
    case role_gain:do(GL, Role) of
        {ok, NRole} ->
            case guild_practise_mgr:apply(sync, {refresh_task, {Gid, Gsrvid}, Type, Role}) of
                {ok, TaskId, Time} ->
                    role_api:push_assets(Role, NRole),
                    Msg = notice_inform:gain_loss([GL], ?L(<<"刷新试练任务">>)),
                    notice:inform(Pid, Msg),
                    {reply, {1, <<>>, TaskId, Time}, NRole};
                {false, Reason} ->
                    {reply, {0, Reason, 0, 0}};
                _ ->
                    {ok}
            end;
        _ ->
            {reply, {?gold_less, ?L(<<"晶钻不足">>), 0, 0}}
    end;

%% 请求他人帮忙刷新任务品质
handle(15106, {_Rid, _SrvId}, _Role = #role{guild_practise = #guild_practise{status = ?guild_practise_status_no_look}}) ->
    {reply, {0, ?L(<<"请先查看自己的任务然后再请人刷新品质">>)}};
handle(15106, {_Rid, _SrvId}, _Role = #role{guild_practise = #guild_practise{status = ?guild_practise_status_doing}}) ->
    {reply, {0, ?L(<<"试练任务正在进行中,无需请人刷新">>)}};
handle(15106, {_Rid, _SrvId}, _Role = #role{guild_practise = #guild_practise{status = ?guild_practise_status_finish}}) ->
    {reply, {0, ?L(<<"任务已完成,请提交,无需请人刷新">>)}};
handle(15106, {Rid, SrvId}, _Role = #role{id = {MyRid, MySrvId}, name = Name, guild_practise = #guild_practise{status = ?guild_practise_status_no_accept}}) ->
    case role_api:lookup(by_id, {Rid, SrvId}) of
        {ok, _Node, #role{lev = Lev}} when Lev < ?guild_practise_min_lev ->
            {reply, {0, ?L(<<"对方等级不足,不能助人刷新">>)}};
        {ok, _Node, #role{link = #link{conn_pid = ConnPid}}} ->
            sys_conn:pack_send(ConnPid, 15107, {MyRid, MySrvId, Name}),
            {reply, {1, <<>>}};
        _ ->
            {reply, {0, ?L(<<"角色不在线">>)}}
    end;
handle(15106, {_Rid, _SrvId}, _Role) ->
    {ok};

%% 帮他人刷新任务品质
handle(15108, {ToRid, ToSrvId, 1}, _Role = #role{id = MyId, name = Name, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_practise_mgr:apply(sync, {help_other, {Gid, Gsrvid}, {MyId, Name}, {ToRid, ToSrvId}}) of
        {ok, Data = {_MyRid, _MySrvId, _MyName, Quality}} ->
            case role_api:lookup(by_id, {ToRid, ToSrvId}) of
                {ok, _Node, #role{pid = Pid, link = #link{conn_pid = ConnPid}}} ->
                    role:apply(async, Pid, {guild_practise, calc_reward, [Quality]}),
                    sys_conn:pack_send(ConnPid, 15153, Data);
                _ ->
                    ok
            end,
            {reply, {1, <<>>}};
        {false, Reason} ->
            {reply, {0, Reason}};
        _ ->
            {ok}
    end;
handle(15108, {_ToRid, _ToSrvId, _Type}, _Role) ->
    {ok};

%% 放弃任务
handle(15109, {}, Role) ->
    case guild_practise:give_up(Role) of
        {ok, NewRole} ->
            {reply, {1, <<>>}, NewRole};
        {false, Reason} ->
            {reply, {0, Reason}}
    end;

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

