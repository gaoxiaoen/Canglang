%%------------------------------------
%% 帮会历练系统
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(guild_practise).
-export([ %% 角色进程处理函数
        login/1
        ,logout/1
        ,gm/2
        ,accept/1
        ,finish/1
        ,give_up/1
        ,calc_reward/2
        ,exit_guild/1
        ,push_progress/1
        ,get_count/1
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("guild.hrl").
-include("guild_practise.hrl").
-include("gain.hrl").
-include("link.hrl").
%%

%% GM命令
gm(reset, Role = #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}, id = Rid}) ->
    guild_practise_mgr:apply(async, {reset, {Gid, Gsrvid}, Rid}),
    Role#role{guild_practise = #guild_practise{}};
gm(_Mod, Role) ->
    Role.

%% 获取试练任务数量
get_count(#role{lev = Lev}) when Lev < ?guild_practise_min_lev -> 0;
get_count(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}, guild_practise = #guild_practise{day_time = DayTime, status = Status}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        Guild when is_record(Guild, guild) ->
            Now = util:unixtime(),
            case util:is_same_day2(Now, DayTime) of
                true when Status =:= ?guild_practise_status_commit -> 0;
                _ -> 1
            end;
        _ -> %% 角色已退帮
            0
    end.

%% 角色登录处理
login(Role = #role{lev = Lev}) when Lev < ?guild_practise_min_lev -> Role;
login(Role = #role{id = Rid, guild = #role_guild{gid = Gid, srv_id = Gsrvid}, trigger = Trigger, guild_practise = GuildPra = #guild_practise{status = ?guild_practise_status_doing, progress = Progs}}) -> %% 历练任务未完成
    guild_practise_mgr:apply(async, {update_online, {Gid, Gsrvid}, Rid, 1}),
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        Guild when is_record(Guild, guild) ->
            {ok, NewProgs, NewTrigger} = reg_trigger(Progs, [], Trigger, Role),
            Role#role{trigger = NewTrigger, guild_practise = GuildPra#guild_practise{progress = NewProgs}};
        _ -> %% 角色已退帮
            Role#role{guild_practise = #guild_practise{}}
    end;
login(Role = #role{id = Rid, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) -> 
    guild_practise_mgr:apply(async, {update_online, {Gid, Gsrvid}, Rid, 1}),
    Role.

%% 角色退出
logout(#role{lev = Lev}) when Lev < ?guild_practise_min_lev -> ok;
logout(#role{id = Rid, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    guild_practise_mgr:apply(async, {update_online, {Gid, Gsrvid}, Rid, 0});
logout(_Role) -> ok.

%% 角色接任务
accept(_Role = #role{guild_practise = #guild_practise{status = ?guild_practise_status_doing}}) ->
    {false, ?L(<<"当前正在进行帮会试练任务,无需重复接受">>)};
accept(_Role = #role{guild_practise = #guild_practise{status = ?guild_practise_status_finish}}) ->
    {false, ?L(<<"任务已完成,请先提交">>)};
accept(Role = #role{id = Rid, trigger = Trigger, guild = #role_guild{gid = Gid, srv_id = Gsrvid}, guild_practise = GuildPra = #guild_practise{status = Status, day_time = DTime}}) ->
    Now = util:unixtime(),
    case Status =:= ?guild_practise_status_commit andalso util:is_same_day2(DTime, Now) of
        true ->
            {false, ?L(<<"每天只能做一次试练任务">>)};
        false ->
            case guild_practise_mgr:lookup(Gid, Gsrvid, Rid) of
                {ok, #guild_practise_role{status = 0}} ->
                    {false, ?L(<<"请先查看试练任务">>)};
                {ok, #guild_practise_role{quality = Q, task_id = TaskId}} ->
                    case guild_practise_data:get_task(TaskId) of
                        {ok, #guild_practise_task{finish_cond = Conds}} ->
                            Progs = guild_practise_progress:convert(Conds, Role),
                            NewStatus = case [Prog || Prog <- Progs, Prog#guild_practise_progress.status =:= 0] of
                                [] -> ?guild_practise_status_finish;
                                _ -> ?guild_practise_status_doing
                            end,
                            {ok, NewProgs, NewTrigger} = reg_trigger(Progs, [], Trigger, Role),
                            NewGuildPra = GuildPra#guild_practise{
                                day_time = Now, status = NewStatus, quality = Q, task_id = TaskId, progress = NewProgs
                            },
                            guild_practise_mgr:apply(async, {update_status, {Gid, Gsrvid}, Rid, NewStatus}),
                            NewRole = Role#role{trigger = NewTrigger, guild_practise = NewGuildPra},
                            push_progress(NewRole),
                            {ok, NewRole};
                        _ ->
                            {false, ?L(<<"无法获取试练任务数据">>)}
                    end;
                {false, Reason} ->
                    {false, Reason};
                _ ->
                    {false, ?L(<<"获取试练数据失败">>)}
            end
    end.

%% 提交任务 领取奖励
finish(_Role = #role{guild_practise = #guild_practise{status = ?guild_practise_status_doing}}) ->
    {false, ?L(<<"任务没有完成,无法提交">>)};
finish(Role = #role{id = Rid, pid = Pid, guild_practise = GuildPra = #guild_practise{status = ?guild_practise_status_finish, task_id = TaskId, quality = Quality, exp = Exp, psychic = _Psychic}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_practise_data:get_reward(TaskId, Quality) of
        {ok, #guild_practise_reward{rewards = Rewards}} ->
            GL = [
                #gain{label = exp, val = Exp}
                | Rewards
            ],
            case role_gain:do(GL, Role) of
                {ok, NRole} ->
                    Msg = notice_inform:gain_loss(GL, ?L(<<"帮会试练">>)),
                    notice:inform(Pid, Msg),
                    NewStatus = ?guild_practise_status_commit,
                    guild_practise_mgr:apply(async, {update_status, {Gid, Gsrvid}, Rid, NewStatus}),
                    Nr = NRole#role{guild_practise = GuildPra#guild_practise{status = NewStatus, day_time = util:unixtime()}},
                    NewRole = role_listener:special_event(Nr, {30017, 1}), %%完成一轮帮会试炼
                    {ok, NewRole};
                {false, _} ->
                    {false, ?L(<<"提交任务失败,请检查背包是否已满">>)}
            end;
        _ ->
            {false, ?L(<<"获取试练数据失败">>)}
    end;
finish(_Role) ->
    {false, ?L(<<"请先接任务并完成">>)}.

%% 放弃任务
give_up(Role = #role{trigger = Trigger, id = Rid, guild_practise = GuildPra = #guild_practise{progress = Progs}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    NewTrigger = del_trigger(Progs, Trigger),
    NewStatus = ?guild_practise_status_commit,
    guild_practise_mgr:apply(async, {update_status, {Gid, Gsrvid}, Rid, NewStatus}),
    {ok, Role#role{trigger = NewTrigger, guild_practise = GuildPra#guild_practise{status = NewStatus, day_time = util:unixtime()}}};
give_up(_Role) ->
    {false, ?L(<<"帮会试练状态不在进行状态">>)}.

%% 奖励计算
calc_reward(Role = #role{lev = Lev, guild_practise = GuildPra, link = #link{conn_pid = ConnPid}}, Quality) ->
    Per = case Quality of
        ?guild_practise_while -> 0.5;
        ?guild_practise_green -> 0.55;
        ?guild_practise_blue -> 0.625;
        ?guild_practise_purple -> 0.75;
        _ -> 1
    end,
    Exp = erlang:round(110 * math:pow(Lev, 1.5) * Per),
    %% Psychic = erlang:round(55 * math:pow(Lev, 1.5) * Per),
    Psychic = 0,
    sys_conn:pack_send(ConnPid, 15154, {Exp, Psychic}),
    {ok, Role#role{guild_practise = GuildPra#guild_practise{exp = Exp, psychic = Psychic}}}.

%% 退出帮会任务取消
exit_guild(#role{guild_practise = #guild_practise{status = ?guild_practise_status_commit}}) ->
    {ok};
exit_guild(#role{guild_practise = #guild_practise{status = ?guild_practise_status_no_look}}) ->
    {ok};
exit_guild(#role{guild_practise = #guild_practise{status = ?guild_practise_status_no_accept}}) ->
    {ok};
exit_guild(Role = #role{trigger = Trigger, guild_practise = #guild_practise{progress = Progs}}) ->
    NewTrigger = del_trigger(Progs, Trigger),
    {ok, Role#role{trigger = NewTrigger, guild_practise = #guild_practise{}}};
exit_guild(_) -> {ok}.

%% 推送任务新进度
push_progress(#role{link = #link{conn_pid = ConnPid}, guild_practise = #guild_practise{progress = [#guild_practise_progress{value = Value, target_value = TargetVal}], status = Status}}) when Status =:= ?guild_practise_status_doing orelse Status =:= ?guild_practise_status_finish ->
    sys_conn:pack_send(ConnPid, 15155, {Value, TargetVal});
push_progress(_Role) -> ok.

%%----------------------------------------
%% 内部方法
%%----------------------------------------

%% 注册触发器，监控任务目标进度
reg_trigger([], Progs, Trigger, _Role) -> {ok, Progs, Trigger};
reg_trigger([P = #guild_practise_progress{status = 0, cond_label = CLabel, trg_label = TrgLabel, target = Target} | T], Progs, Trigger, Role) -> %% 未完成进度且没有注册过触发器
    case role_trigger:add(TrgLabel, Trigger, {guild_practise_progress, CLabel, [Target]}) of 
        {ok, Id, NewTrigger} ->
            reg_trigger(T, [P#guild_practise_progress{id = Id} | Progs], NewTrigger, Role);
        _ ->
            ?DEBUG("创建试练任务进度信息出错:TrgLabel~w, progress:~w", [TrgLabel, P]),
            reg_trigger(T, [P | Progs], Trigger, Role)
    end;
reg_trigger([P | T], Progs, Trigger, Role) -> %% 容错
    reg_trigger(T, [P | Progs], Trigger, Role).

%% 删除相关触发器
del_trigger([], Trigger) -> Trigger;
del_trigger([#guild_practise_progress{id = Tid, status = 0, trg_label = Label} | T], Trigger) ->
    case role_trigger:del(Label, Trigger, Tid) of
        {ok, NewTrigger} -> %% 进度完成 删除触发器成功
            ?DEBUG("删除触发器Label:~w TriggerId:~w", [Label, Tid]),
            del_trigger(T, NewTrigger);
        _ ->
            ?DEBUG("删除触发器失败Label:~w TriggerId:~w", [Label, Tid]),
            del_trigger(T, Trigger)
    end;
del_trigger([_P | T], Trigger) ->
    del_trigger(T, Trigger).


