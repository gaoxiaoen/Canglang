%%----------------------------------------------------
%% 帮会历练管理
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(guild_practise_mgr).
-behaviour(gen_server).
-export([
        apply/2
        ,lookup/2
        ,lookup/3
        ,list_all/0
        ,start_link/0
        ,rand_luck/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
    }).

-include("common.hrl").
-include("role.hrl").
-include("guild.hrl").
-include("guild_practise.hrl").
-include("gain.hrl").
-include("link.hrl").
%%

%% 获取指定帮会试练数据
lookup(Gid, Gsrvid) ->
    case catch ets:lookup(guild_practise_list, {Gid, Gsrvid}) of
        [] ->
            false;
        [H] when is_record(H, guild_practise_list) ->
            H;
        _Err ->
            ?ERR("ETS帮会试练数据异常，[Data:~w]", [_Err]),
            false
    end.

lookup(Gid, Gsrvid, Rid) ->
    case lookup(Gid, Gsrvid) of
        false -> %% 帮会历练数据不存在
            {false, ?L(<<"帮会试练数据不存在">>)};
        #guild_practise_list{list = Members} ->
            case lists:keyfind(Rid, #guild_practise_role.id, Members) of
                false -> %% 角色历练数据不存在
                    {false, ?L(<<"角色帮会试练数据不存在">>)};
                Data -> %% 角色已存在
                    {ok, Data}
            end
    end.

%% 所有帮会试练数据
list_all() ->
    case catch ets:tab2list(guild_practise_list) of
        L when is_list(L) -> L;
        _ -> []
    end.

apply(async, Args) ->
    gen_server:cast(?MODULE, Args);
apply(sync, Args) ->
    gen_server:call(?MODULE, Args).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    case guild_practise_dao:load_all() of
        {ok, L} ->
            ets:new(guild_practise_list, [set, named_table, protected, {keypos, #guild_practise_list.id}]),
            update_ets(L),
            erlang:send_after(util:unixtime({nexttime, 10}) * 1000, self(), reset),
            ?INFO("[~w] 启动完成", [?MODULE]),
            {ok, #state{}};
        _Reason ->
            ?DEBUG("===帮会试练数据加载失败:~w", [_Reason]),
            ?ERR("帮会试练数据加载失败"),
            {stop, load_failure}
    end.

%% 查看玩家自己数据
handle_call({self, {Gid, Gsrvid}, {Rid, Srvid}, #guild_practise{day_time = DayTime, status = NewStatus, quality = Quality, task_id = TaskId}}, _From, State) ->
    Now = util:unixtime(),
    Flag = util:is_same_day2(Now, DayTime),
    case lookup(Gid, Gsrvid) of
        false -> %% 帮会历练数据不存在
            {reply, {false, ?L(<<"帮会试练数据不存在">>)}, State};
        G = #guild_practise_list{list = Members} ->
            case lists:keyfind({Rid, Srvid}, #guild_practise_role.id, Members) of
                false -> %% 角色历练数据不存在
                    {reply, {false, ?L(<<"角色帮会试练数据不存在">>)}, State};
                My = #guild_practise_role{status = OldStatus} when NewStatus =/= OldStatus andalso Flag =:= true -> %% 当天数据不一致 同步
                    NewMy = My#guild_practise_role{status = NewStatus, quality = Quality, task_id = TaskId, online = 1},
                    NewMembers = lists:keyreplace({Rid, Srvid}, #guild_practise_role.id, Members, NewMy),
                    NewG = G#guild_practise_list{list = NewMembers},
                    update_ets_db(NewG),
                    {reply, {ok, NewMy}, State};
                My -> %% 角色已存在
                    {reply, {ok, My}, State}
            end
    end; 

%% 玩家首次查看任务
handle_call({look_task, {Gid, Gsrvid}, Role = #role{id = RoleId}}, _From, State) ->
    case lookup(Gid, Gsrvid) of
        false -> %% 帮会历练数据不存在
            {reply, {false, ?L(<<"帮会试练数据不存在">>)}, State};
        G = #guild_practise_list{list = Members} ->
            case lists:keyfind(RoleId, #guild_practise_role.id, Members) of
                false -> %% 角色历练数据不存在
                    {reply, {false, ?L(<<"角色帮会试练数据不存在">>)}, State};
                My = #guild_practise_role{luck = Luck, status = Status, task_id = OldTaskId} when Status =:= ?guild_practise_status_no_look orelse OldTaskId =:= 0 -> %% 第一次查看 生成任务类型
                    Quality = rand_quality(Luck),
                    TaskId = rand_task(Role),
                    NewMy = My#guild_practise_role{
                        status = ?guild_practise_status_no_accept, quality = Quality, task_id = TaskId
                        ,refresh_time = util:unixtime() + ?guild_practise_refresh_time_out, online = 1
                    },
                    guild:pack_send({Gid, Gsrvid}, 15152, {[NewMy]}),
                    NewMembers = lists:keyreplace(RoleId, #guild_practise_role.id, Members, NewMy),
                    NewG = G#guild_practise_list{list = NewMembers},
                    update_ets_db(NewG),
                    {reply, {ok, NewMy}, State};
                My ->
                    {reply, {ok, My}, State}
            end
    end;

%% 帮别人刷新任务品质
handle_call({help_other, {Gid, Gsrvid}, {{MyRid, MySrvId}, MyName}, {OtherRid, OtherSrvid}}, _From, State) ->
    case lookup(Gid, Gsrvid) of
        false -> %% 帮会历练数据不存在
            {reply, {false, ?L(<<"帮会试练数据不存在">>)}, State};
        G = #guild_practise_list{list = Members} ->
            case {lists:keyfind({MyRid, MySrvId}, #guild_practise_role.id, Members), lists:keyfind({OtherRid, OtherSrvid}, #guild_practise_role.id, Members)} of
                {false, _} ->
                    {reply, {false, ?L(<<"角色帮会试练数据不存在">>)}, State};
                {_, false} ->
                    {reply, {false, ?L(<<"对方帮会试练数据不存在">>)}, State};
                {#guild_practise_role{help_others = N}, _Other} when N >= ?guild_practise_max_help_refresh ->
                    {reply, {false, ?L(<<"帮助他人刷新次数已使用完">>)}, State};
                {_My, #guild_practise_role{refresh_self = M}} when M >= ?guild_practise_max_refresh_self ->
                    {reply, {false, ?L(<<"对方已被刷新超过次数">>)}, State};
                {_My, #guild_practise_role{quality = ?guild_practise_orange}} ->
                    {reply, {false, ?L(<<"对方品质已是最高级别,无需刷新">>)}, State};
                {_My, #guild_practise_role{status = ?guild_practise_status_no_look}} ->
                    {reply, {false, ?L(<<"对方试练任务未查看,不能刷新">>)}, State};
                {_My, #guild_practise_role{status = ?guild_practise_status_doing}} ->
                    {reply, {false, ?L(<<"对方试练任务正在进行中,不能刷新">>)}, State};
                {_My, #guild_practise_role{status = ?guild_practise_status_finish}} ->
                    {reply, {false, ?L(<<"对方试练任务已完成,不能刷新">>)}, State};
                {_My, #guild_practise_role{status = ?guild_practise_status_commit}} ->
                    {reply, {false, ?L(<<"对方试练任务已提交,不能刷新">>)}, State};
                {My = #guild_practise_role{help_others = N, luck = Luck}, Other = #guild_practise_role{refresh_self = M, refresh_list = RList}} ->
                    NewMy = My#guild_practise_role{help_others = N + 1, online = 1},
                    Quality = rand_quality(Luck),
                    NewRef = {MyRid, MySrvId, MyName, Quality},
                    NewOther = Other#guild_practise_role{
                        quality = Quality, refresh_self = M + 1, refresh_list = [NewRef | RList]
                    },
                    guild:pack_send({Gid, Gsrvid}, 15152, {[NewMy, NewOther]}),
                    Members0 = lists:keyreplace({MyRid, MySrvId}, #guild_practise_role.id, Members, NewMy),
                    NewMembers = lists:keyreplace({OtherRid, OtherSrvid}, #guild_practise_role.id, Members0, NewOther),
                    NewG = G#guild_practise_list{list = NewMembers},
                    update_ets_db(NewG),
                    {reply, {ok, NewRef}, State}
            end
    end;

%% 刷新自己的任务类型
handle_call({refresh_task, {Gid, Gsrvid}, Type, Role = #role{id = RoleId}}, _From, State) ->
    Now = util:unixtime(),
    case lookup(Gid, Gsrvid) of
        false -> %% 帮会历练数据不存在
            {reply, {false, ?L(<<"帮会试练数据不存在">>)}, State};
        G = #guild_practise_list{list = Members} ->
            case lists:keyfind(RoleId, #guild_practise_role.id, Members) of
                false -> %% 角色历练数据不存在
                    {reply, {false, ?L(<<"角色帮会试练数据不存在">>)}, State};
                #guild_practise_role{refresh_time = RT} when Type =:= 0 andalso Now < RT ->
                    {reply, {false, ?L(<<"CD时间未到,刷新失败">>)}, State};
                My -> 
                    TaskId = rand_task(Role),
                    Time = Now + ?guild_practise_refresh_time_out,
                    NewMy = My#guild_practise_role{task_id = TaskId, refresh_time = Time, online = 1},
                    guild:pack_send({Gid, Gsrvid}, 15152, {[NewMy]}),
                    NewMembers = lists:keyreplace(RoleId, #guild_practise_role.id, Members, NewMy),
                    NewG = G#guild_practise_list{list = NewMembers},
                    update_ets_db(NewG),
                    {reply, {ok, TaskId, Time}, State}
            end
    end;

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 角色历练数据状态更新
handle_cast({update_status, {Gid, Gsrvid}, {Rid, Srvid}, Status}, State) ->
    case lookup(Gid, Gsrvid) of
        false -> %% 帮会历练数据不存在
            {noreply, State};
        G = #guild_practise_list{list = Members} ->
            case lists:keyfind({Rid, Srvid}, #guild_practise_role.id, Members) of
                false -> %% 角色历练数据不存在
                    {noreply, State};
                My = #guild_practise_role{task_id = TaskId} -> %% 角色已存在
                    NewStatus = case TaskId =:= 0 of
                        true -> ?guild_practise_status_no_look;
                        false -> Status 
                    end,
                    NewMy = My#guild_practise_role{status = NewStatus},
                    NewMembers = lists:keyreplace({Rid, Srvid}, #guild_practise_role.id, Members, NewMy),
                    NewG = G#guild_practise_list{list = NewMembers},
                    update_ets_db(NewG),
                    guild:pack_send({Gid, Gsrvid}, 15152, {[NewMy]}),
                    {noreply, State}
            end
    end;

%% 角色上线状态变化
handle_cast({update_online, {Gid, Gsrvid}, {Rid, Srvid}, Online}, State) ->
    case lookup(Gid, Gsrvid) of
        false -> %% 帮会历练数据不存在
            {noreply, State};
        G = #guild_practise_list{list = Members} ->
            case lists:keyfind({Rid, Srvid}, #guild_practise_role.id, Members) of
                false -> %% 角色历练数据不存在
                    {noreply, State};
                My -> %% 角色已存在
                    NewMy = My#guild_practise_role{online = Online, login_time = util:unixtime()},
                    NewMembers = lists:keyreplace({Rid, Srvid}, #guild_practise_role.id, Members, NewMy),
                    NewG = G#guild_practise_list{list = NewMembers},
                    guild:pack_send({Gid, Gsrvid}, 15152, {[NewMy]}),
                    update_ets(NewG),
                    {noreply, State}
            end
    end;

%% 帮会进程启动
handle_cast({load, Guild = #guild{gid = Gid, srv_id = Gsrvid}}, State) ->
    case lookup(Gid, Gsrvid) of
        false -> %% 帮会历练数据不存在 新帮会
            G = #guild_practise_list{id = {Gid, Gsrvid}},
            NewG = reset_guild(G, Guild),
            update_ets(NewG),
            {noreply, State};
        G ->
            NewG = sync_guild(G, Guild),
            update_ets(NewG),
            {noreply, State}
    end;

%% 角色入帮
handle_cast({in_guild, {Gid, Gsrvid}, {Rid, Srvid, Name}}, State) ->
    case lookup(Gid, Gsrvid) of
        false -> %% 帮会历练数据不存在
            {noreply, State};
        G = #guild_practise_list{list = Members} ->
            case lists:keyfind({Rid, Srvid}, #guild_practise_role.id, Members) of
                false ->
                    Luck = rand_luck(),
                    NewR = #guild_practise_role{
                        id = {Rid, Srvid}, rid = Rid, srv_id = Srvid, name = Name, luck = Luck
                        ,online = 1, login_time = util:unixtime()
                    },
                    guild:pack_send({Gid, Gsrvid}, 15151, {[NewR]}),
                    NewG = G#guild_practise_list{list = [NewR | Members]},
                    update_ets_db(NewG),
                    {noreply, State};
                _ -> %% 角色已存在
                    {noreply, State}
            end
    end;

%% 角色退帮
handle_cast({out_guild, {Gid, Gsrvid}, {Rid, Srvid}}, State) ->
    case lookup(Gid, Gsrvid) of
        false -> %% 帮会历练数据不存在
            {noreply, State};
        G = #guild_practise_list{list = Members} ->
            case lists:keyfind({Rid, Srvid}, #guild_practise_role.id, Members) of
                false -> %% 角色不存在
                    {noreply, State};
                _ -> %% 角色已存在
                    NewMembers = lists:keydelete({Rid, Srvid}, #guild_practise_role.id, Members),
                    NewG = G#guild_practise_list{list = NewMembers},
                    update_ets_db(NewG),
                    guild:pack_send({Gid, Gsrvid}, 15150, {Rid, Srvid}),
                    case role_api:lookup(by_id, {Rid, Srvid}, #role.pid) of
                        {ok, _Node, Pid} ->
                            role:apply(async, Pid, {guild_practise, exit_guild, []});
                        _ ->
                            ok
                    end,
                    {noreply, State}
            end
    end;

%% 角色入帮
handle_cast({union_guild, #guild{id = {Gid1, Gsrvid1}}, #guild{id = {Gid2, Gsrvid2}}}, State) ->
    case {lookup(Gid1, Gsrvid1), lookup(Gid2, Gsrvid2)} of
        {false, _} -> {noreply, State};
        {_, false} -> {noreply, State};
        {G1 = #guild_practise_list{list = Members1}, G2 = #guild_practise_list{list = Members2}} ->
            NewG1 = G1#guild_practise_list{list = Members1 ++ Members2},
            NewG2 = G2#guild_practise_list{list = []},
            update_ets_db(NewG1),
            update_ets_db(NewG2),
            guild:pack_send({Gid1, Gsrvid1}, 15151, {Members2}),
            guild:pack_send({Gid2, Gsrvid2}, 15151, {Members1}),
            {noreply, State}
    end;

%% 角色历练数据重置 GM命令使用
handle_cast({reset, {Gid, Gsrvid}, {Rid, Srvid}}, State) ->
    case lookup(Gid, Gsrvid) of
        false -> %% 帮会历练数据不存在
            {noreply, State};
        G = #guild_practise_list{list = Members} ->
            case lists:keyfind({Rid, Srvid}, #guild_practise_role.id, Members) of
                false -> %% 角色历练数据不存在
                    {noreply, State};
                #guild_practise_role{name = Name, online = Online, login_time = LTime} -> %% 角色已存在
                    Luck = rand_luck(),
                    NewMy = #guild_practise_role{
                        id = {Rid, Srvid}, rid = Rid, srv_id = Srvid, name = Name, luck = Luck,
                        online = Online, login_time = LTime
                    },
                    NewMembers = lists:keyreplace({Rid, Srvid}, #guild_practise_role.id, Members, NewMy),
                    NewG = G#guild_practise_list{list = NewMembers},
                    update_ets_db(NewG),
                    guild:pack_send({Gid, Gsrvid}, 15152, {[NewMy]}),
                    {noreply, State}
            end
    end;

%% 重置所有帮会数据
handle_cast(reset_all, State) ->
    L = list_all(),
    NewL = reset_all_guild(L, []),
    update_ets(NewL),
    {noreply, State};

%% 保存帮会历练数据
handle_cast(save_all, State) ->
    L = list_all(),
    guild_practise_dao:save_all(L),
    {noreply, State};

%% 清空所有帮会历练数据
handle_cast(remove_all, State) ->
    ets:delete_all_objects(guild_practise_list),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 0点数据更新
handle_info(reset, State) -> 
    erlang:send_after(util:unixtime({nexttime, 10}) * 1000, self(), reset),
    erlang:send_after(util:unixtime({nexttime, 900}) * 1000, self(), save_all),
    L = list_all(),
    NewL = reset_all_guild(L, []),
    update_ets(NewL),
    {noreply, State};

%% 每天15分保存帮会历练数据
handle_info(save_all, State) ->
    L = list_all(),
    guild_practise_dao:save_all(L),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%------------------------------------
%% 内部方法
%%-----------------------------------

%% 12点数据更新重置
reset_all_guild([], L) -> 
    Guilds = guild_mgr:list(),
    do_new_guild(Guilds, L);
reset_all_guild([G = #guild_practise_list{id = {Gid, Gsrvid}} | T], L) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false -> %% 帮会已不存在
            reset_all_guild(T, L);
        Guild ->
            NewG = reset_guild(G, Guild),
            reset_all_guild(T, [NewG | L])
    end.

%% 新帮会数据生成
do_new_guild([], L) -> L;
do_new_guild([Guild = #guild{gid = Gid, srv_id = Gsrvid} | T], L) ->
   case lists:keyfind({Gid, Gsrvid}, #guild_practise_list.id, L) of
        false -> %% 帮会历练数据不存在 新帮会
            G = #guild_practise_list{id = {Gid, Gsrvid}},
            NewG = reset_guild(G, Guild),
            %% guild_practise_dao:save(NewG),
            do_new_guild(T, [NewG | L]);
        _G ->
            do_new_guild(T, L)
    end.

%% 重置一个帮会数据
reset_guild(G = #guild_practise_list{list = Members0}, Guild) ->
    %% ?DEBUG("~w", [Mems]),
    NewMembers = do_reset_guild(Members0, []),
    NewG = G#guild_practise_list{list = NewMembers},
    sync_guild(NewG, Guild).

%% 同步角色帮会数据
sync_guild(G = #guild_practise_list{list = Members0}, #guild{members = Mems}) ->
    %% ?DEBUG("~w", [Mems]),
    Members1 = do_delete(Mems, Members0, []),
    NewMembers = do_add_member(Mems, Members1),
    G#guild_practise_list{list = NewMembers}.

%% 同步删除
do_delete(_Mems, [], L) -> L;
do_delete(Mems, [I = #guild_practise_role{id = Id} | T], L) ->
    case lists:keyfind(Id, #guild_member.id, Mems) of
        false -> do_delete(Mems, T, L);
        _ -> do_delete(Mems, T, [I | L])
    end.

%% 同步增加
do_add_member([], L) -> L;
do_add_member([#guild_member{rid = Rid, srv_id = Srvid, name = Name} | T], L) ->
    case lists:keyfind({Rid, Srvid}, #guild_practise_role.id, L) of
        false -> %% 新成员
            Luck = rand_luck(),
            NewR = #guild_practise_role{
                id = {Rid, Srvid}, rid = Rid, srv_id = Srvid, name = Name, luck = Luck, login_time = util:unixtime()
            },
            do_add_member(T, [NewR | L]);
        _ ->
            do_add_member(T, L)
    end.

%% 执行0点重置
do_reset_guild([], L) -> L;
do_reset_guild([I = #guild_practise_role{status = Status, task_id = TaskId} | T], L) when TaskId =/= 0 andalso (Status =:= ?guild_practise_status_doing orelse Status =:= ?guild_practise_status_finish) -> %% 正在进行中 未领取奖励 不改变
    Luck = rand_luck(I),
    do_reset_guild(T, [I#guild_practise_role{luck = Luck, help_others = 0} | L]);
do_reset_guild([I = #guild_practise_role{rid = Rid, srv_id = Srvid, name = Name, online = Online, login_time = LTime} | T], L) ->
    Luck = rand_luck(I),
    NewI = #guild_practise_role{
        id = {Rid, Srvid}, rid = Rid, srv_id = Srvid
        ,name = Name, luck = Luck, online = Online, login_time = LTime
    },
    do_reset_guild(T, [NewI | L]).

%% 更新ETS数据
update_ets([]) -> ok;
update_ets([I | T]) ->
    update_ets(I),
    update_ets(T);
update_ets(GuildList) when is_record(GuildList, guild_practise_list) ->
    ets:insert(guild_practise_list, GuildList);
update_ets(_) -> ok.

%% 更新ETS和数据库
update_ets_db(GuildList) ->
    guild_practise_dao:save(GuildList),
    update_ets(GuildList).

%%---------------------------------------------
%% 随机处理 随机运势 随机品质 随机任务
%%---------------------------------------------

%% 随机生成角色运势类型
rand_luck() -> rand_luck(0).
rand_luck(#guild_practise_role{online = Online, login_time = LTime}) ->
    UnOnlineDay = case Online =:= 1 of %% 计算玩家不在线天数
        true -> 0;
        false -> 
            Now = util:unixtime(),
            (Now - LTime) div 86400
    end,
    rand_luck(UnOnlineDay);
rand_luck(N) when N >= 5 -> 1; %% 玩家超过五天不在线
rand_luck(N) when N >= 3 -> %% 玩家大于三天不在线
    util:rand(1, 2);
rand_luck(_) ->
    LuckL = guild_practise_data:list_luck(),
    LuckDataL = [guild_practise_data:get_luck(Luck) || Luck <- LuckL],
    RandValL = [Rand || {_, #guild_practise_luck{rand = Rand}} <- LuckDataL],
    MaxVal = lists:sum(RandValL),
    RandVal = util:rand(1, MaxVal),
    do_rand_luck(RandVal, LuckDataL).
do_rand_luck(_RandVal, []) -> 1;
do_rand_luck(_RandVal, [{_, #guild_practise_luck{type = Type}}]) -> Type;
do_rand_luck(RandVal, [{_, #guild_practise_luck{rand = Rand}} | T]) when RandVal > Rand ->
    do_rand_luck(RandVal - Rand, T);
do_rand_luck(_RandVal, [{_, #guild_practise_luck{type = Type}} | _]) -> Type.

%% 根据运势类型随机生成角色任务品质
rand_quality(Luck) ->
    case guild_practise_data:get_luck(Luck) of
        {ok, #guild_practise_luck{quality_list = QList}} ->
            RandValL = [Rand || {_, Rand} <- QList],
            MaxVal = lists:sum(RandValL),
            RandVal = util:rand(1, MaxVal),
            do_rand_quality(RandVal, QList);
        _ ->
            ?ERR("获取运势基础数据失败[~p]", [Luck]),
            2
    end.
do_rand_quality(_RandVal, []) -> 2;
do_rand_quality(_RandVal, [{Quality, _Rand}]) -> Quality;
do_rand_quality(RandVal, [{_Quality, Rand} | T]) when RandVal > Rand ->
    do_rand_quality(RandVal - Rand, T);
do_rand_quality(_RandVal, [{Quality, _Rand} | _T]) -> Quality.

%% 随机生成任务类型
rand_task(Role) ->
    TaskIdL = guild_practise_data:list_task(),
    AllTaskL = [guild_practise_data:get_task(TaskId) || TaskId <- TaskIdL],
    CanAcceptTaskL = [Task || {_, Task = #guild_practise_task{accept_cond = Conds, rand = Rand}} <- AllTaskL, Rand > 0, role_cond:check(Conds, Role) =:= true],
    RandValL = [Rand || #guild_practise_task{rand = Rand} <- CanAcceptTaskL],
    MaxVal = lists:sum(RandValL),
    RandVal = util:rand(1, MaxVal),
    do_rand_task(RandVal, CanAcceptTaskL).
do_rand_task(_RandVal, []) -> 1;
do_rand_task(_RandVal, [#guild_practise_task{id = TaskId}]) -> TaskId;
do_rand_task(RandVal, [#guild_practise_task{rand = Rand} | T]) when RandVal > Rand ->
    do_rand_task(RandVal - Rand, T);
do_rand_task(_RandVal, [#guild_practise_task{id = TaskId} | _T]) -> TaskId.

