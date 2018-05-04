%%----------------------------------------------------
%%  军团 成员管理模块
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_mem).

-export([start/1
        ,start/4
        ,invite/2
        ,handle_invitation/4
        ,sync_accepted_invitation/2
        ,apply_for/3
        ,auto_apply/1
        ,async_new_apply/2
        ,apply_inform/2
        ,cancel_apply/3
        ,clear_apply/2
        ,async_clear_apply/3
        ,async_cancel_apply/2
        ,approve/3
        ,sync_approve/6
        ,refuse/3
        ,async_refuse/3
        ,quit/1
        ,sync_quit/3
        ,sync_chief_quit/3
        ,fire/3
        ,sync_fire/5
        ,async_be_fired/1
        ,retire/1
        ,sync_retire/3
        ,transfer/3
        ,sync_transfer/5
        ,appoint/5
        ,sync_appoint/6
        ,members/1
        ,members_online/1
        ,applys/1
        ,limit_member_manage/2
        ,async_limit_member_manage/2
        ,update/2
        ,async_update/2
        ,async_timing_update/1
        ,async_refresh_members/1
        ,async_maintain/1
        ,async_clear_status/1
        ,async_clear_skill/1
        ,async_clear_exp/1
        ,async_clear_read/1
        ,salary/3
        ,authority/1        %% 计算权限
        ,async_init_impeach/1
        ,active_impeach/1
        ,sync_active_impeach/2
        ,async_impeach_success/2
        ,reject_impeach/1
        ,async_reject_impeach/2
        ,add_member/2
        ,welcome_require/2
        ,do_welcome_require/2
        ,welcome/2
        ,welcome_mail/2
        ,clean_welcome/1
        ,clean_role_welcome/1
        ,online_pid/1
        ,pick_up_chief/1
        ,get_chief/1
        ,get_ol_chief/1
        ,sync_auto_join/2
    ]
).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("link.hrl").
-include("vip.hrl").
%%
-include("chat_rpc.hrl").
-include("attr.hrl").
-include("gain.hrl").
-include("mail.hrl").
-include("notification.hrl").


-define(UNIXDAYTIME, 86400).                                            %% unixtime 一天86400秒
-define(member_update, 600).                                            %% 成员数据更新频度, 10分钟一次
-define(guild_mem_impeach_active, 3 * 86400).                           %% 3天未登录可以被军团成员主动弹劾
-define(guild_mem_impeach_cancel, 2 * 86400).                           %% 两天内帮主有上线则取消弹劾
-define(guild_mem_impeach_warn, 7 * 86400).                             %% 7天未登录被系统自动进入弹劾状态
-define(guild_mem_impeach_auto, 2 * 86400).                             %% 2天未登录被系统自动弹劾
-define(guild_mem_newchief_online_limit, 3 * 86400).            

%% @spec start(Guild) -> ok
%% Guild = #guild{}
%% @doc 军团进程启动监听函数
start(#guild{id = {Gid, Gsrvid}, members = Mems, pid = Pid, entrance = {MapId, _Ex, _Ey}}) -> 
    spawn(?MODULE, start, [{Gid, Gsrvid}, Mems, Pid, MapId]),
    guild:reg_maintain_callback(Pid, {?MODULE,  async_maintain, []}),
    %% guild:apply(async, Pid, {?MODULE, async_init_impeach, []}),
    ok.

%% @spec start(GuildID, GuildMembers, GuildPid, GuildMapID) -> ok
%% GuildID = gid() = {integer(), binary()}
%% GuildMembers = [#guild_member{} | ...]
%% GuildPid = pid()
%% GuildMapID = integer()
%% @doc 军团进程启动后需对该军团执行操作
start({Gid, Gsrvid}, Mems, Pid, MapId) ->
    timing_update({Gid, Gsrvid}),               %% 注册定时更新事件
    inform_to_members(Mems, Pid, MapId),        %% 更新军团数据到成员
    ok.

%% @spec timing_update({Gid, Gsrvid}) -> ok
%% Gid = integer()
%% Gsrvid = binary()
%% @doc 注册定时更新成员数据事件
timing_update({Gid, Gsrvid}) ->
    guild:event_callback({Gid, Gsrvid}, ?member_update, {?MODULE, async_timing_update, []}).

%% @spec async_timing_update(State) -> {ok}
%% State = #guild{}
%% @doc 通知军团成员更新军团数据到帮会, 帮会进程
async_timing_update(#guild{members = Mems}) ->
    guild:event_callback(?member_update, {?MODULE, async_timing_update, []}),
    guild:event_callback(10, {?MODULE, async_refresh_members, []}),  %% 开始进行数据更新后 10秒统一刷新成员列表
    Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:apply(async, Pid, {guild_api, sync_to_guild, []});
        (_GuildMember) -> ok 
    end,
    lists:foreach(Fun, Mems),
    {ok}.

%% @spec async_refresh_members(State) -> {ok}
%% State = #guild{}
%% @doc 更新一次数据到客户端, 军团进程
async_refresh_members(#guild{members = Mems}) ->
    TMems = lists:foldl(fun(M = #guild_member{pid = Pid}, Acc) ->
                case is_pid(Pid) of
                    false -> [M|Acc];
                    true -> [M#guild_member{pid = 1} | Acc]
                end
        end, [], Mems),
    Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> catch role:pack_send(Pid, 12719, {TMems});
        (_GuildMember) -> ok
    end,
    lists:foreach(Fun, Mems),
    {ok}.

%% @spec async_midnight_update(State) -> {ok}
%% State = #guild{}
%% @doc 午夜数据状态重置, 军团进程
async_maintain(State) ->
    async_clear_status(State),
    %% NewState = auto_impeach(State),
    async_limit_member_manage(State, able),
    {ok, State}.

%% @spec async_clear_status(State) -> {ok}
%% State = #guild{}
%% @doc 清除所有状态, 军团进程
async_clear_status(#guild{members = Mems}) ->
    clear_role_guild_status(Mems),
    {ok}.

%% @spec async_clear_skill(State) -> {ok}
%% State = #guild{}
%% @doc 清除技能领用状态, 军团进程
async_clear_skill(#guild{members = Mems}) ->
    clear_guild_skill_buf(Mems),
    {ok}.

%% @spec async_clear_exp(State) -> {ok}
%% State = #guild{}
%% @doc 清除经验领用状态, 军团进程
async_clear_exp(#guild{members = Mems}) ->
    clear_guild_claim_exp(Mems),
    {ok}.

%% @spec async_clear_read(State) -> {ok}
%% State = #guild{}
%% @doc 清除藏经阁阅读状态, 军团进程
async_clear_read(#guild{members = Mems}) ->
    clear_guild_claim_read(Mems),
    {ok}.

%% @spec invite(Name, Role) -> {false, Reason} | {ok, Msg}
%% Name = Reason = Msg = binary()
%% Role = #role{}
%% @doc 推荐好友入帮
invite(_Name, #role{guild = #role_guild{authority = Auth}}) when Auth < ?recommend  ->
    {false, ?MSGID(<<"堂主以上才可以推荐好友">>)};
invite(Name, #role{name = Name}) ->
    {false, ?MSGID(<<"您推荐您自己去干啥子！">>)};
invite(Name, #role{name = Rname, guild = #role_guild{gid = Gid, name = Gname, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false ->
            ?ERR("角色 [~s] 推荐 [~s] 入帮，找不到军团 [~s,~w,~s] 的数据", [Rname, Name, Gname, Gid, Gsrvid]),
            {false, <<>>};
        Guild = #guild{name = Gname} ->
            case guild_cond:condition(recommend_guild, Guild) of
                {false, Reason} ->
                    {false, Reason};
                true ->
                    case role_api:lookup(by_name, Name, to_guild_role) of 
                        {ok, _Node, GuildRole} ->
                            case guild_cond:condition(recommend_role, GuildRole) of
                                {false, Reason} ->
                                    {false, Reason};
                                true ->
                                    case guild_cond:condition(Guild, GuildRole) of
                                        true ->
                                            case guild_role:add_invite(GuildRole, Gid, Gsrvid, Gname, Rname) of
                                                true ->
                                                    {ok, ?MSGID(<<"推荐成功">>)};
                                                {false, Reason} ->
                                                    {false, Reason}
                                            end;
                                        {false, Reason} ->
                                            {false, Reason}
                                    end
                            end;
                        {_Error, not_found} ->
                            {false, ?MSGID(<<"推荐失败，角色不在线或不存在">>)};
                        _ ->
                            {false, <<>>}
                    end
            end
    end.

%% @spec handle_invitation(Gid, Gsrvid, Choose, Role) -> {ok} | {ok, NewRole} | {false, Reason}
%% Gid = integer()
%% Gsrvid = Reason = binary()
%% Choose = 0 | 1
%% Role = NewRole = #role{}
%% @doc 角色处理军团邀请
handle_invitation(Gid,Gsrvid, ?false, #role{id = {Rid, Rsrvid}, link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 13703, {Gid, Gsrvid}),
    guild_mgr:special(del_invited, {Gid, Gsrvid, Rid, Rsrvid}),
    {ok};
handle_invitation(_Gid, _Gsrvid, ?true, #role{guild = #role_guild{gid = Gid}}) when Gid =/= 0 ->
    {false, ?MSGID(<<"您已经有军团了">>)};
handle_invitation(Gid, Gsrvid, ?true, Role = #role{id = {Rid, Rsrvid}, name = Rname, guild = #role_guild{read = Read, skilled = Skilled, welcome_times = Times}}) ->
    Inviteds = guild_mgr:lookup_spec(invited, Rid, Rsrvid),
    case lists:any(fun({IGid,IGsrvid, _,_}) -> Gid =:= IGid andalso Gsrvid =:= IGsrvid end, Inviteds) of
        false ->
            {false, ?MSGID(<<"您没有收到过该军团的邀请，或邀请已失效">>)};
        true ->
            case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
                false ->
                    {false, <<>>};
                Guild ->
                    case guild_cond:condition(recommend_guild, Guild) of
                        {false, Reason} ->
                            {false, Reason};
                        true ->
                            case guild_cond:condition(Guild, Role) of
                                true ->
                                    case guild:apply(sync, {Gid, Gsrvid}, {?MODULE, sync_accepted_invitation, [guild_role:convert(Role)]}) of
                                        {true, RoleGuild = #role_guild{name = Gname}} ->
                                            spawn(guild_log, join_leave, [Rid, Rsrvid, Rname, <<"邀请">>, Gid, Gsrvid, Gname, Rid, Rsrvid, Rname]),
                                            {ok, guild_role:listener(join, Role#role{guild = RoleGuild#role_guild{read = Read, skilled = Skilled, welcome_times = Times}})};
                                        {false, Reason} ->
                                            {false, Reason};
                                        _ ->
                                            {false, ?MSGID(<<"请稍候再试！">>)}
                                    end;
                                {false, Reason} ->
                                    {false, Reason}
                            end
                    end
            end
    end.

%% @spec sync_accepted_invitation(Guild, GuildRole) -> {ok, {true, RoleGuild}, NewGuild} | {ok, {false, Reason}}
%% Guild = #guild{}
%% GuildRole = #guild_role{}
%% RoleGuild = #role_guild{}
%% Reason = binary()
%% @doc 角色接受邀请入帮
sync_accepted_invitation(#guild{members = Mems, maxnum = MaxNum}, _GuildRole)  when length(Mems) >= MaxNum ->
    {ok, {false, ?L(<<"操作失败，军团人数已满">>)}};
sync_accepted_invitation(Guild = #guild{id = {Gid, Gsrvid}, name = Gname}, GuildRole = #guild_role{rid = Rid, srv_id = Rsrvid, name = Rname}) ->
    RoleGuild = to_role_guild(GuildRole, Guild),
    Guild1 = add_member(to_new_member(GuildRole), Guild),
    spawn(guild_log, log, [Gid, Gsrvid, Gname, Rid, Rsrvid, Rname, <<"增加成员">>, <<"接受邀请">>]),
    case find(apply, {Rid, Rsrvid}, Guild) of
        false ->
            {ok, {true, RoleGuild}, Guild1};
        _ ->
            NewGuild = delete_apply({Rid, Rsrvid}, Guild1),
            {ok, {true, RoleGuild}, NewGuild}
    end.

%% @spec apply_for(Type, ID, Role) -> {false, Reason} | {ok, gid(), Msg}
%% Type = by_guild | by_role
%% ID = gid() | rid()
%% Reason = Msg = binary()
%% Role = #role{}
%% @doc 角色申请入军团
apply_for(by_guild, {Gid, Gsrvid}, Role = #role{lev = RoleLev, attr = #attr{fight_capacity = RoleZdl}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false ->
            {false, ?MSGID(<<"你申请的军团不存在">>)};
        Guild = #guild{id = {Gid, Gsrvid}, join_limit = #join_limit{lev = Lev, zdl = Zdl}} when (Lev > 0  orelse Zdl > 0 ), (RoleLev >= Lev andalso RoleZdl >= Zdl) ->
            Conds = [{role_apply, Role}, {role_applyed, {Gid, Gsrvid, Role}}, {apply_guild, Guild}, {Guild, Role}, {quit_date, Role}], %% , {quit_date, Role}
            case do_condition(Conds) of
                true ->
                    auto_join({Gid, Gsrvid}, Role);
                Other ->
                    Other
            end;
        %% #guild{join_limit = #join_limit{lev = Lev, zdl = Zdl}} when (Lev > 0 orelse Zdl > 0 ), (RoleLev =< Lev orelse RoleZdl =< Zdl) ->
        %%    {false, ?MSGID(<<"等级或战力不足">>)};
        Guild ->
            apply_for(Guild, Role)
    end;

%% 根据对方角色来申请入帮
apply_for(by_role, {Rid, Rsrvid}, Role) ->
    case guild_mgr:lookup(by_role_id, {Rid, Rsrvid}) of
        false -> {false, ?MSGID(<<"找不到对方军团信息，申请失败">>)};
        Guild -> apply_for(Guild, Role)
    end.

apply_for(Guild = #guild{id = {Gid, Gsrvid}}, Role = #role{id = {Rid, Rsrvid}}) ->
    Conds = [{role_apply, Role}, {role_applyed, {Gid, Gsrvid, Role}}, {apply_guild, Guild}, {Guild, Role}, {quit_date, Role}],  %% {quit_date, Role}
    case do_condition(Conds) of
        true ->
            guild_mgr:special(add_applyed, {Gid, Gsrvid, Rid, Rsrvid}),
            guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_new_apply, [guild_role:convert(Role)]}),
            {ok, {Gid, Gsrvid}, ?MSGID(<<"申请成功">>)};
        Ret -> Ret
    end.

do_condition([]) -> true;
do_condition([{L, A} | T]) ->
    case guild_cond:condition(L, A) of
       Ret = {false, _} -> Ret;
       true -> do_condition(T)
    end.

filter_guild([], _Role, Res) -> Res;
filter_guild([Guild = #guild{id = {Gid, Gsrvid}}| T], Role, Res) ->
    Filters = [{role_apply, Role}, {role_applyed, {Gid, Gsrvid, Role}}, {apply_guild, Guild}, {Guild, Role}, {guild_limit, {Role, Guild}}],
    case do_condition(Filters) of
        true -> filter_guild(T, Role, [Guild|Res]);
        {false, _MsgId} -> ?DEBUG("  MsgId : ~w", [_MsgId]), filter_guild(T, Role, Res)
    end.

%% 智能申请
%% -> {ok, MsgId, NewRole} ,自动进入军团了
%% -> {applyed, MsgId, Applyed} , 成功申请了军团
%% -> {false, MsgId}, 申请失败  MsgId为错误号
auto_apply(#role{guild = #role_guild{gid = Gid}}) when Gid =/= 0 ->
    {false, ?MSGID(<<"您已加入军团">>)};
auto_apply(Role = #role{id = {Rid, Rsrvid}}) ->
    case guild_cond:condition(quit_date, Role) of
        true ->
            Guilds = guild_mgr:list(),
            Filtered = filter_guild(Guilds, Role, []),
            case length(Filtered) =< 0 of
                true ->
                    {false, ?MSGID(<<"当前没有可申请的军团喔">>)};
                false ->
                    case guild_mgr:lookup_spec(Rid, Rsrvid) of
                        false ->
                            do_auto_apply(Filtered, 5, Role);
                            %% {false, ?MSGID(<<"申请错误">>)};
                        #special_role_guild{applyed = Applyed} when length(Applyed) >= ?max_apply ->
                            {false, ?MSGID(<<"您已申请军团数过多">>)};
                        #special_role_guild{applyed = Applyed} ->
                            Num = ?max_apply - length(Applyed),
                            do_auto_apply(Filtered, Num, Role)
                    end
            end;       
        Err = {false, _Reason} ->
            Err
    end.

do_auto_apply(Guilds, Num, Role) ->
    case try_join(Guilds, Role) of
        Ret = {ok, _MsgId, _Role1} ->
            Ret;
        false ->
            Guilds1 =
            case Num >= length(Guilds) of
                true -> Guilds;
                false -> get_rand_guild(Guilds, Num)
            end,
            apply_guild(Guilds1, Role, [])
    end.

%% -> {applyed, [{Gid,GSrvid} | ]}
apply_guild([], _Role, Ret) -> {applyed, ?MSGID(<<"申请成功">>), Ret};
apply_guild([Guild | T], Role, Ret) ->
    case apply_for(Guild, Role) of
        {ok, Applyed, _} ->
            apply_guild(T, Role, [Applyed | Ret]);
        _ ->
            apply_guild(T, Role, Ret)
    end.

%% 遍历所有军团，尝试直接加入军团
try_join([], _Role) -> false;
try_join([#guild{join_limit = #join_limit{lev = 0, zdl = 0}} | T], Role) ->
    try_join(T, Role);
try_join([#guild{id = {Gid, Gsrvid}} | T], Role) ->
    case auto_join({Gid, Gsrvid}, Role) of
        Ret = {ok, _MsgId, _Role1} -> Ret;
        {false, _} -> try_join(T, Role)
    end.

%% 随机获取军团
get_rand_guild(Guilds, Num) ->
    do_get_rand(Guilds, Num, []).
do_get_rand(_Guilds, 0, Res) -> Res;
do_get_rand(Guilds, Num, Res) ->
    Rand = util:rand(1, length(Guilds)),
    Get = lists:nth(Rand, Guilds),
    Res1 = [Get | Res],
    Guilds1 = Guilds -- [Get],
    do_get_rand(Guilds1, Num-1, Res1).



%% @spec async_new_apply(Guild, GuildRole) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% GuildRole = #guild_role{}
%% @doc 申请入军团
async_new_apply(State = #guild{members = Mems, id = _Gid}, GuildRole = #guild_role{rid = Rid, srv_id = Rsrvid}) ->
    case find(apply, {Rid, Rsrvid}, State) of
        false ->
            NewState = add_apply(GuildRole, State),
            spawn(?MODULE, apply_inform, [GuildRole, Mems]),
            guild_common:pack_send_notice(NewState),
            %Chiefs = get_chief(Gid),
            %Msg = util:fbin(?L(<<"~s想加入你的军团">>), [RoleName]),
            %[notification:send(offline, Id, ?notify_type_wanted, Msg, []) || Id <- Chiefs ],
            {ok, NewState};
        _ ->
            {ok}
    end.

%% @spec apply_inform(GuildRole, GuildMembers) -> ok
%% GuildRole = #guild_role{}
%% GuildMembers = [#guild_member{} | ...]
%% @doc 军团申请 通知
apply_inform(#guild_role{name = Rname}, Mems) ->
    Msg = util:fbin(?L(<<"~s想加入你的军团">>), [Rname]),
    Fun = fun(#guild_member{pid = _Pid, rid = Rid, srv_id = SrvId, authority = Auth}) when Auth >= ?guild_apply_handle  -> 
            %% role:pack_send(Pid, 10932, {?chat_guild, 61, Msg});
            notification:send(offline, {Rid, SrvId}, ?notify_type_wanted, Msg, []);
        (_Member) -> ok
    end, 
    lists:foreach(Fun,  Mems).

%% @spec cancel_apply(Gid, Gsrvid, Role) -> ok | {false, Reason}
%% Gid = integer()
%% Gsrvid = binary()
%% Role = #role{}
%% @doc 取消申请
cancel_apply(Gid, Gsrvid, #role{id = {Rid, Rsrvid}, guild = #role_guild{gid = 0}}) ->
    guild_mgr:special(del_applyed, {Gid, Gsrvid, Rid, Rsrvid}),
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_cancel_apply, [{Rid, Rsrvid}]});

cancel_apply(_Gid, _Gsrvid, _Role) ->
    {false, ?L(<<"取消失败，您已经加入了军团">>)}.

%% @spec async_cancel_apply(State, RoleId) -> {ok} | {ok, NewState}
%% State = NewState = #guild{}
%% RoleId = rid()
%% @doc 取消申请
async_cancel_apply(State, RoleId) ->
    NewState = delete_apply(RoleId, State),
    {ok, NewState}.

%% @spec clear_apply({Gid, Gsrvid}, {Rid, Rsrvid}) -> ok
%% Gid = Rid = integer()
%% Gsrvid = Rsrvid = binary()
%% @doc 清理角色{Rid, Rsrvid} 在军团 {Gid, Gsrvid} 的申请
clear_apply({Gid, Gsrvid}, {Rid, Rsrvid}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_clear_apply, [Rid, Rsrvid]}).

%% @spec async_clear_apply(State, Rid, Rsrvid) -> {ok, NewState}
%% State = NewState = #guild{}
%% Rid = integer()
%% Rsrvid = binary()
%% @doc 清掉已经加入到其他军团的申请
async_clear_apply(State, Rid, Rsrvid) ->
    NewState = delete_apply({Rid, Rsrvid}, State),
    {ok, NewState}.

%% @spec approve(Rid, Rsrvid, Role) -> {ok, Msg} | {false, Reason}
%% Rid = integer()
%% Rsrvid = Msg = Reason = binary()
%% Role = #role{}
%% @doc 入帮申请处理
approve(_Rid, _Rsrvid, #role{guild = #role_guild{authority = Auth}}) when Auth < ?guild_apply_handle ->
    {false, ?MSGID(<<"权限不足">>)};
approve(Rid, Rsrvid, #role{id = {Eid, Esrvid}, name = Ename, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild:apply(sync, {Gid, Gsrvid}, {?MODULE, sync_approve, [Rid, Rsrvid, Eid, Esrvid, Ename]}) of
        {true, _Msg} ->
            {ok, ?MSGID(<<"处理成功!">>)};
        {false, Reason} -> {false, Reason};
        _ -> {false, ?MSGID(<<"请稍候再试！">>)}
    end.

%% @spec sync_approve(State, Rid, Rsrvid, Eid, Esrvid, Ename) -> {ok, {false, Reason}} | {ok, {true, Msg}, NewState}
%% @doc 批准加入军团
sync_approve(#guild{members = Mems, maxnum = MaxNum}, _Rid, _Rsrvid, _Eid, _Esrvid, _Ename) when length(Mems) >= MaxNum ->
    {ok, {false, ?MSGID(<<"操作失败，军团人数已满">>)}};
sync_approve(State = #guild{id = {Gid, Gsrvid}, name = Gname}, Rid, Rsrvid, Eid, Esrvid, Ename) ->
    case find(apply, {Rid, Rsrvid}, State) of
        false -> {ok, {false, ?MSGID(<<"该申请已取消或处理过，请勿重复操作!">>)}};
        ApplyRole = #apply_list{name = Rname} ->
            case role_api:lookup(by_id, {Rid, Rsrvid}, to_guild_role) of
                {ok, _, #guild_role{gid = RGid}} when RGid =/= 0 ->
                    {ok, {false, ?MSGID(<<"对方已加入其他军团">>)}};
                {ok, _, GuildRole = #guild_role{pid = Pid}} when is_pid(Pid) ->
                    State1 = delete_apply({Rid, Rsrvid}, State),
                    guild_common:pack_send_notice(State1),
                    case role:apply(sync, Pid, {guild_api, join, [to_role_guild(GuildRole, State1)]}) of
                        true ->
                            NewState = add_member(to_new_member(GuildRole), State1),
                            %% spawn(mail, send_system, [{Rid, Rsrvid}, {?L(<<"入团通知">>), util:fbin(?L(<<"恭喜您已加入军团【~s】">>), [Gname])}]),
                            spawn(guild_log, join_leave, [Rid, Rsrvid, Rname, <<"批准">>, Gid, Gsrvid, Gname, Eid, Esrvid, Ename]),
                            spawn(guild_log, log, [Gid, Gsrvid, Gname, Eid, Esrvid, Ename, <<"增加成员">>, util:fbin(<<"[~w,~s,~s] 被批准入帮">>, [Rid, Rsrvid, Rname])]),
                            {ok, {true, ?MSGID(<<"添加团员成功">>)}, NewState};
                        false ->
                            {ok, {false, ?MSGID(<<"对方已加入其他军团">>)}, State1};
                        _ -> 
                            {ok, {false, ?MSGID(<<"请稍候再试！">>)}}
                    end;
                {ok, _, #guild_role{pid = Pid}} ->                          
                    ?ERR("处理入帮申请时，查找到角色的{~w,~s}的PID为 ~w , 处理被忽略", [Rid, Rsrvid, Pid]),
                    {ok, {false, ?MSGID(<<"处理失败">>)}};
                {_Error, not_found} ->
                    State1 = delete_apply({Rid, Rsrvid}, State),
                    guild_common:pack_send_notice(State1),
                    case guild_mgr:offline_join(Gid, Gsrvid, Rid, Rsrvid) of
                        false ->
                            {ok, {false, ?MSGID(<<"对方已加入其他军团">>)}, State1};
                        true ->
                            NewState = add_member(to_new_member(ApplyRole), State1),
                            %% spawn(mail, send_system, [{Rid, Rsrvid}, {?L(<<"入帮通知">>), util:fbin(?L(<<"恭喜您已加入军团【~s】">>), [Gname])}]),
                            spawn(guild_log, join_leave, [Rid, Rsrvid, Rname, <<"离线批准">>, Gid, Gsrvid, Gname, Eid, Esrvid, Ename]),
                            spawn(guild_log, log, [Gid, Gsrvid, Gname, Eid, Esrvid, Ename, <<"增加成员">>, util:fbin(<<"[~w,~s,~s] 被批准入帮">>, [Rid, Rsrvid, Rname])]),
                            {ok, {true, ?L(<<"添加团员成功">>)}, NewState}
                    end;
                _ ->
                    {ok, {false, ?MSGID(<<"对方已加入其他军团">>)}, delete_apply({Rid, Rsrvid}, State)}
            end
    end.

auto_join({Gid, Gsrvid}, Role) ->
    case guild:apply(sync, {Gid, Gsrvid}, {?MODULE, sync_auto_join, [Role]}) of
        {true, _Msg, RoleGuild} ->
            {ok, true, Role1} = guild_api:join(Role, RoleGuild),
            guild_common:pack_send_notice(Role),
            {ok, ?MSGID(<<"成功加入军团">>), Role1};
        {false, Reason} -> {false, Reason};
        _R -> ?DEBUG(" ** 错误值 : ~w", [_R]), {false, ?MSGID(<<"请稍候再试！">>)}
    end.

%% 马上加入军团
sync_auto_join(#guild{members = Mems, maxnum = MaxNum}, #role{}) when length(Mems) >= MaxNum ->
    {ok, {false, ?MSGID(<<"操作失败，军团人数已满">>)}};
sync_auto_join(State = #guild{}, Role = #role{id = {Rid, Rsrvid}}) ->
    case role_convert:do(to_guild_role, Role) of
        {ok, #guild_role{gid = RGid}} when RGid =/= 0 ->
            {ok, {false, ?MSGID(<<"您已加入其他军团">>)}};
        {ok, GuildRole = #guild_role{pid = Pid}} when is_pid(Pid) ->
          %%  case role:apply(sync, Pid, {guild_api, join, [to_role_guild(GuildRole, State)]}) of
          %%      true ->
                    State1 = delete_apply({Rid, Rsrvid}, State),
                    State2 = add_member(to_new_member(GuildRole), State1),
                    {ok, {true, ?MSGID(<<"已加入军团">>), to_role_guild(GuildRole, State2)}, State2}
           %%     _ -> 
           %%         {ok, {false, ?MSGID(<<"加入失败">>)}}
           %% end
    end.

%% @spec refuse(Rid, Rsrvid, Role) -> {false, Reason} | ok
%% Rid = integer()
%% Rsrvid = Reason = binary()
%% Role = #role{}
%% @doc 拒绝申请
refuse(_Rid, _Rsrvid, #role{guild = #role_guild{authority = Auth}}) when Auth < ?guild_apply_handle ->
    {false, ?L(<<"权限不足">>)};
refuse(Rid, Rsrvid, #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_refuse, [Rid, Rsrvid]}).

%% @spec async_refuse(State, Rid, Rsrvid) -> {ok} | {ok, NewState}
%% State = NewState = #guild{}
%% Rid = integer()
%% Rsrvid = binar()
%% @doc 拒绝入帮申请
async_refuse(State = #guild{id = {Gid, Gsrvid}, name = Gname}, Rid, Rsrvid) ->
    case find(apply, {Rid, Rsrvid}, State) of
        false ->
            {ok};
        _ ->
            NewState = delete_apply({Rid, Rsrvid}, State),
            guild_mgr:mgr_cast({apply_refused, Rid, Rsrvid, Gid, Gsrvid, Gname}),
            {ok, NewState}
    end.

%% @spec quit(Role) -> {ok, NewRole} | {false, Reason}
%% Role = NewRole = #role{}
%% Reason = binary()
%% @doc 退出军团
quit(Role = #role{id = {Rid, Rsrvid}, name = Rname, guild = #role_guild{gid = Gid, srv_id = Gsrvid, name = Gname, position = ?guild_chief}}) ->
    case guild:apply(sync, {Gid, Gsrvid}, {?MODULE, sync_chief_quit, [Rid, Rsrvid]}) of
        true ->
            spawn(guild_log, join_leave, [Rid, Rsrvid, Rname, <<"退出">>, Gid, Gsrvid, Gname, Rid, Rsrvid, Rname]),
            {ok, guild_role:listener(quit, Role)};
        {false, Reason} ->
            {false, Reason};
        _ ->
            case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
                false ->    %% 军团销毁了
                    spawn(guild_log, join_leave, [Rid, Rsrvid, Rname, <<"退出noproc">>, Gid, Gsrvid, Gname, Rid, Rsrvid, Rname]),
                    {ok, guild_role:listener(quit, Role)};
                _ ->
                    {false, ?MSGID(<<"请稍候再试！">>)}
            end
    end;
quit(Role = #role{id = {Rid, Rsrvid}, name = Rname, guild = #role_guild{gid = Gid, srv_id = Gsrvid, name = Gname}}) ->
    case guild:apply(sync, {Gid, Gsrvid},{?MODULE, sync_quit, [Rid, Rsrvid]}) of 
        true ->
            spawn(guild_log, join_leave, [Rid, Rsrvid, Rname, <<"退出">>, Gid, Gsrvid, Gname, Rid, Rsrvid, Rname]),
            Role1 = guild_role:listener(quit, Role),
            {ok, guild_role:listener(quit, Role1)};
        {false, Reason} ->
            {false, Reason};
        _ ->
            case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
                false ->    %% 军团销毁了
                    spawn(guild_log, join_leave, [Rid, Rsrvid, Rname, <<"退出noproc">>, Gid, Gsrvid, Gname, Rid, Rsrvid, Rname]),
                    Role1 = guild_role:listener(quit, Role),
                    {ok, guild_role:listener(quit, Role1)};
                _ ->
                    {false, ?MSGID(<<"请稍候再试！">>)}
            end
    end.

%% @spec sync_chief_quit(State, Rid, Rsrvid) -> {ok, {false, Reason}} | {ok, true} | {ok, true, NewState}
%% State = #guild{}
%% Rid = integer()
%% Rsrvid = Reason = binary()
%% @doc 帮主退出军团
sync_chief_quit(State = #guild{id = {Gid, Gsrvid}, name = Gname, members = Mems}, Rid, Rsrvid) ->
    case get(member_manage) of
        undefined ->
            case length(Mems) of
                0 ->
                    ?ERR("军团{~s,~w,~s}数据异常，没有成员", [Gname, Gid, Gsrvid]),
                    {ok, {false, <<>>}};
                1 ->
                    case find(member, {Rid, Rsrvid}, State) of
                        false ->
                            ?ERR("收到帮主{~w, ~s}退出军团请求，但与最后一位成员{~w}不对应", [Rid, Rsrvid, Mems]),
                            {ok, {false, <<>>}};
                        #guild_member{name = Rname} ->
                            guild:dismiss(Rid, Rsrvid, Rname),
                            {ok, true, State#guild{members = []}}
                    end;
                _ ->
                    case pick_up_chief(State) of
                        false ->
                            {ok, {false, ?L(<<"没有合适的团长">>)}};
                        #guild_member{id = {NewChiefRid, NewChiefSrvid}} ->
                            State1 = appoint(NewChiefRid, NewChiefSrvid, ?guild_chief, State),
                            State2 = delete_member({Rid, Rsrvid}, State1),
                            {ok, true, State2}
                    end
            end;
        _ ->
            {ok, {false, ?L(<<"军团集体性活动中，禁止退出军团">>)}}
    end.

%% @spec sync_quit(State, Rid, Rsrvid) -> {ok true} | {ok, true, NewState} | {ok, {false, Reason}}
%% State = NewState = #guild{}
%% Rsrvid = Reason = binary()
%% Rid = integer()
%% @doc 退出军团
sync_quit(State = #guild{id = {Gid, Gsrvid}, members = Mems, name = Gname}, Rid, Rsrvid) ->
    case get(member_manage) of
        undefined ->
            case find(member,{Rid, Rsrvid}, State) of
                false ->
                    ?ERR("收到角色 [~w, ~s] 退出军团请求，军团成员列表中找不到该成员", [Rid, Rsrvid]),
                    {ok, true};
                #guild_member{name = Rname} ->
                    NewState = delete_member({Rid, Rsrvid}, State),
                    guild:guild_chat(Mems, util:fbin(?L(<<"很遗憾，{role, ~w,~s,~s,#FFFF66}已主动退出军团。">>), [Rid, Rsrvid, Rname])),
                    spawn(guild_log, log, [Gid, Gsrvid, Gname, Rid, Rsrvid, Rname, <<"主动退帮">>, <<>>]),
                    {ok, true, NewState}
            end;
        _ ->
            {ok, {false, ?L(<<"军团集体性活动中，禁止退出军团">>)}}
    end.

%% @spec fire(Rid, Rsrvid, Role) -> {ok, Msg} | {false, Reason}
%% Rid = integer()
%% Rsrvid = Reason = Msg = binary()
%% Role = #role{}
%% @doc 开除军团成员
fire(Rid, Rsrvid, #role{id = {Rid, Rsrvid}, name = Rname, guild = #role_guild{name = Gname}}) ->
    ?ERR("角色 [~s, ~w,~s] 企图把自己从军团 [~s] 开除", [Rname, Rid, Rsrvid, Gname]),
    {false, <<>>};

fire(_Rid, _Rsrvid, #role{guild = #role_guild{authority = Auth}}) when Auth < ?fire_member ->
    {false, ?L(<<"权限不足">>)};

fire(FRid, FSrvid, #role{id = {Rid, Rsrvid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild:apply(sync, {Gid, Gsrvid}, {?MODULE, sync_fire, [FRid, FSrvid, Rid, Rsrvid]}) of
        true ->
            {ok, ?L(<<"开除成功">>)};
        {false, Reason} ->
            {false, Reason};
        _ ->
            {false, ?L(<<"操作失败">>)}
    end.

%% @spec sync_fire(Rid, Rsrvid, Role) -> {ok, {false, Reason}} | {ok, true, NewRole}
%% Rid = integer()
%% Rsrvid = Reason = binay()
%% Role = NewRole = #role{}
%% @doc 开除成员
sync_fire(State = #guild{id = {Gid, Gsrvid}, name = Gname, members = _Mems}, Trid, Tsrvid, Rid, Rsrvid) ->
    case get(member_manage) of
        undefined ->
            case find(member, {Trid, Tsrvid}, State) of
                false -> {ok, {false, ?L(<<"对方不是本帮成员，操作失败">>)}};
                #guild_member{position = ?guild_chief, name = Tname} ->
                    ?ERR("错误操作，角色【~w,~s】开除军团【~s】帮主【~w, ~s, ~s】", [Rid, Rsrvid, Gname, Trid, Tsrvid, Tname]),
                    {ok, {false, ?L(<<"禁止开除帮主">>)}};
                #guild_member{pid = Tpid, name = Tname, authority = Tauth} ->
                    case find(member, {Rid, Rsrvid}, State) of
                        false -> 
                            {ok, {false, ?L(<<"您不是本帮成员，操作失败">>)}};
                        #guild_member{authority = Auth} when Auth =< Tauth -> 
                            {ok, {false, ?L(<<"权限不足">>)}};
                        #guild_member{name = Rname} ->
                            case is_pid(Tpid) of
                                true-> 
                                    spawn(guild_log, join_leave, [Trid, Tsrvid, Tname, <<"开除">>, Gid, Gsrvid, Gname, Rid, Rsrvid, Rname]),
                                    role:apply(async, Tpid, {?MODULE, async_be_fired, []}),
                                    guild_mgr:special(online_fire, {Trid, Tsrvid}); 
                                false -> 
                                    spawn(guild_log, join_leave, [Trid, Tsrvid, Tname, <<"离线开除">>, Gid, Gsrvid, Gname, Rid, Rsrvid, Rname]),
                                    guild_mgr:special(offline_fire, {Trid, Tsrvid})
                            end,
                            %% guild:guild_chat(Mems, util:fbin(?L(<<"{role, ~w, ~s, ~s,#FFFF66}已被{role, ~w, ~s, ~s,#FFFF66}开除军团">>), [Trid, Tsrvid, Tname, Rid, Rsrvid, Rname])), 
                            NewState = delete_member({Trid, Tsrvid}, State),
                            %% spawn(mail, send_system, [{Trid, Tsrvid}, {?L(<<"军团开除">>), util:fbin(?L(<<"您已经被【~s】开除【~s】军团会籍">>), [Rname, Gname])}]),
                            spawn(guild_log, log, [Gid, Gsrvid, Gname, Rid, Rsrvid, Rname, <<"开除成员">>, util:fbin(<<"[~w,~s,~s] 被开除军团">>, [Trid, Tsrvid, Tname])]),
                            {ok, true, NewState}
                    end
            end;
        _ ->
            {ok, {false, ?L(<<"军团集体性活动中，禁止开除成员">>)}}
    end.

%% @spec async_be_fired(Role) -> {ok, NewRole}
%% @doc 被开除军团
async_be_fired(Role) ->
    {ok, guild_role:listener(quit, Role)}.

%% @spec retire(Role) -> {ok, NewRole} | {false, Reason}
%% Role = NewRole = #role{}
%% Reason = binary()
%% @doc 卸任
retire(#role{guild = #role_guild{position = ?guild_disciple}}) ->
    {false, ?MSGID(<<"团员不能进行该项操作">>)};
retire(Role = #role{id = Rid = {_, Rsrvid}, name = Rname, guild = #role_guild{position = ?guild_chief, gid = Gid, srv_id = Gsrvid, name = Gname}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{members = Mems} when length(Mems) =:= 1 ->
            {false, ?MSGID(<<"没有团员，不能卸任">>)};
        #guild{members = Mems} ->
            Mems1 = [M || M = #guild_member{id = Rid1} <- Mems, Rid1 =/= Rid], %% 剔除掉团长
            Fun = 
            fun(#guild_member{donation = Don, fight = F}, #guild_member{donation = Don1, fight = F1}) ->
                    case Don =:= Don1 of
                        true ->
                            F > F1;
                        false ->
                            Don > Don1
                    end end,
            Mems2 = lists:sort(Fun, Mems1),            
            #guild_member{id = {Tid, TSrvid}} = lists:nth(1, Mems2),
            transfer(Tid, TSrvid, Role);   
        _ ->
            ?ERR("角色 [~s,~w,~s] 请求卸任，找不到军团 [~s,~w,~s] 数据", [Rname, Rid, Rsrvid, Gname, Gid, Gsrvid]),
            {false, <<>>}
    end;

retire(Role = #role{id = {Rid, Rsrvid}, lev = Lev, name = Rname, guild = #role_guild{gid = Gid, srv_id = Gsrvid, name = Gname}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{weal = Weal} ->
            guild:apply(async, {Gid, Gsrvid}, {?MODULE, sync_retire, [Rid, Rsrvid]}),
            NewRole = guild_role:alters([{position, ?guild_disciple}, {salary, salary(Lev, Weal, ?guild_disciple)}], Role),
            {ok, NewRole};
        _ ->
            ?ERR("角色 [~s,~w,~s] 请求卸任，找不到军团 [~s,~w,~s] 数据", [Rname, Rid, Rsrvid, Gname, Gid, Gsrvid]),
            {false, <<>>}
    end.

%% @spec sync_retire(State, Rid, Rsrvid) -> {ok} | {ok, NewState}
%% State = NewState = #guild{}
%% Rid = integer()
%% Rsrvid = binary()
%% @doc 卸任
sync_retire(State = #guild{id = {Gid, Gsrvid}, members = Mems, name = Gname}, Rid, Rsrvid) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Mems) of
        false ->
            {ok};
        M = #guild_member{name = Rname, position = Job} ->
            M1 = M#guild_member{authority = ?disciple_op, position = ?guild_disciple},
            NewMems = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Mems, M1),
            guild_refresh:refresh(13729, M1, NewMems),
            guild:guild_chat(Mems, util:fbin(?L(<<"{str,~s, #CDB5CD} {role, ~w, ~s, ~s,#FFFF66}已卸任，退居基层">>), [guild:position_name(Job), Rid, Rsrvid, Rname])),
            spawn(guild_log, log, [Gid, Gsrvid, Gname, Rid, Rsrvid, Rname, <<"卸任">>, guild:position_name(Job)]),
            {ok, State#guild{members = NewMems}}
    end.

%% @spec transfer(Rid, Rsrvid, Role) -> {false, Reason} | {ok, NewRole}
%% Rid = integer()
%% Rsrvid = Reason = binary()
%% Role = NewRole = #role{}
%% @doc 转让职位
transfer(Rid, Rsrvid, #role{id = {Rid, Rsrvid}}) ->
    {false, ?MSGID(<<"别玩了，自己转让团长给自己有意思么!">>)};
transfer(_TRid, _TSrvid, #role{guild = #role_guild{position = Position}}) when Position =/= ?guild_chief  ->
    {false, ?MSGID(<<"您不是军团长，不能进行该项操作">>)};
transfer(TRid, TSrvid, Role = #role{id = {Rid, Rsrvid}, lev = Lev, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        false ->
            {false, <<>>};
        #guild{weal = Weal} ->
            case guild:apply(sync, {Gid, Gsrvid}, {?MODULE, sync_transfer, [TRid, TSrvid, Rid, Rsrvid]}) of
                true ->
                    NewRole = guild_role:alters([{position, ?guild_disciple}, {salary, salary(Lev, Weal, ?guild_disciple)}], Role),
                    {ok, NewRole};
                {false, Reason} ->
                    {false, Reason};
                _ ->
                    {false, ?MSGID(<<"请稍候再试！">>)}
            end
    end.

%% @spec sync_transfer(State, TRid, TSrvid, Rid, Rsrvid) -> {ok, {false, Reason}} || {ok, true, NewState}
%% State = NewState = #guild{}
%% TRid = Rid = integer()
%% TSrvid = Rsrvid = Reason = binary()
%% @doc 转让帮主
sync_transfer(State = #guild{members = Mems, id = {Gid, Gsrvid}, name = Gname}, TRid, TSrvid, Rid, Rsrvid) ->
    case find(member, {TRid, TSrvid}, State) of
        false ->
            {ok, {false, ?MSGID(<<"转让失败，请确认您指定对象是否还在军团内!">>)}};
        #guild_member{name = TName, vip = Vip} ->
            case find(member, {Rid, Rsrvid}, State) of
                false ->
                    {ok, {false, ?MSGID(<<"您不是本团成员，操作失败">>)}};
                #guild_member{name = Rname, position = ?guild_chief} ->
                    State1 = appoint(TRid, TSrvid, ?guild_chief, State),
                    State2 = appoint(Rid, Rsrvid, ?guild_disciple, State1),
                    NewState = State2#guild{chief = TName, rvip = Vip},
                    guild:guild_chat(Mems, util:fbin(?L(<<"英明神武的团长{role, ~w, ~s, ~s,#FFFF66}已卸任，退居基层\n恭喜{role,~w,~s,~s,#FFFF66}成为新任帮主">>), [Rid, Rsrvid, Rname, TRid, TSrvid, TName])),
                    spawn(guild_rss, transfer, [NewState]),
                    spawn(guild_log, log, [Gid, Gsrvid, Gname, Rid, Rsrvid, Rname, <<"转让团长">>, util:fbin(<<"~s 转让团长给 [~w,~s,~s]">>, [Rname, TRid, TSrvid, TName])]),
                    guild_refresh:refresh(13722, [{30, TName}], Mems),
                    guild_refresh:refresh(13721, [{0, Vip}], Mems),
                    {ok, true, NewState};
                _ ->
                    {ok, {false, ?MSGID(<<"您不是军团长">>)}}
            end
    end.

%% @spec appoint(Trid, Tsrvid, PreJob, NextJob, Role) -> {false, Reason} | {ok, Msg} 
%% Trid = PreJob = NextJob = integer()
%% Tsrvid = Reason = Msg = binary()
%% Role = #role{}
%% @doc 任命职位
appoint(_Tid, _Tsrvid, _PreJob, _NextJob, #role{guild = #role_guild{authority = ?disciple_op}}) ->
    {false, ?MSGID(<<"权限不足">>)};
appoint(Tid, Tsrvid, _PreJob, NextJob, #role{id = {Rid, Rsrvid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild:apply(sync, {Gid, Gsrvid}, {?MODULE, sync_appoint, [Rid, Rsrvid, Tid, Tsrvid, NextJob]}) of
        {false, Reason} ->
            {false, Reason};
        true ->
            {ok, ?MSGID(<<"任命成功">>)};
        _ ->
            {false, ?MSGID(<<"任命失败">>)}
    end.

%% @spec sync_appoint(State, Rid, Rsrvid, Tid, Tsrvid, NextJob) -> {ok, false, Reason} | {ok, true, NewState}
%% State = NewState = #guild{}
%% Rid = Tid = NextJob = integer()
%% Rsrvid = Tsrvid = Reason = binary()
%% @doc 任命成员
sync_appoint(State = #guild{members = Mems, id = {Gid, Gsrvid}, name = Gname}, Rid, Rsrvid, Trid, Tsrvid, NextJob) ->
    case find(member, {Rid, Rsrvid}, State) of
        false ->
            {ok, {false, ?MSGID(<<"您不是本帮成员，操作失败">>)}};
        #guild_member{authority = Auth, name = Rname} ->
            case find(member, {Trid, Tsrvid}, State) of
                false ->
                    {ok, {false, ?MSGID(<<"指定对象不是本帮成员，任命失败!">>)}};
                #guild_member{authority = Tauth, name = Tname, position = TJob} ->
                    case appoint_auth_check(Auth, Tauth, authority(NextJob)) of
                        false ->
                            {ok, {false, ?MSGID(<<"权限不足">>)}};
                        true when NextJob =:= TJob ->
                            {ok, {false, ?MSGID(<<"请勿重复操作">>)}};
                        true when NextJob =:= ?guild_disciple  ->     %% 任命弟子，没有人数限制
                            NewState = appoint(Trid, Tsrvid, NextJob, State),
                            spawn(guild_log, log, [Gid, Gsrvid, Gname, Rid, Rsrvid, Rname, <<"任命">>, util:fbin(<<"[~w,~s,~s] 被任命为弟子">>, [Trid, Tsrvid, Tname])]),
                            guild:sys_msg(right_able, Mems, util:fbin(?L(<<"{role,~w,~s,~s,#FFFF66}已被降职为弟子">>), [Trid, Tsrvid, Tname])), 
                            {ok, true, NewState};
                        true ->
                            Num = keynum(NextJob, #guild_member.position, Mems),
                            case is_position_ok(NextJob, Num) of
                                false ->
                                    {ok, {false, ?MSGID(<<"该职位人数已满">>)}};
                                true ->
                                    NewState = appoint(Trid, Tsrvid, NextJob, State),
                                    spawn(guild_log, log, [Gid, Gsrvid, Gname, Rid, Rsrvid, Rname, <<"任命">>, util:fbin(<<"[~w,~s,~s] 被任命为 ~s">>, [Trid, Tsrvid, Tname, guild:position_name(NextJob)])]),
                                    guild:guild_chat(Mems, util:fbin(?L(<<"恭喜{role,~w,~s,~s,#FFFF66}成为 {str, ~s, #CDB5CD}">>), [Trid, Tsrvid, Tname, guild:position_name(NextJob)])), 
                                    {ok, true, NewState}
                            end
                    end
            end
    end.

%% @spec members(Role) -> [#guild_member{} | ...]
%% Role = #role{}
%% @doc 获取军团成员列表
members(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{members = Members} ->
            Members;
        _ ->
            []
    end.

%% @spec members(Role) -> [#guild_member{} | ...]
%% Role = #role{}
%% @doc 获取军团团长，副团，ID
get_chief({Gid, Gsrvid}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{members = Members} ->
            [Rid || #guild_member{id = Rid, position = Pos} <- Members, Pos >= ?guild_elder];
        _ ->
            []
    end.

%% 获取在线团长副团长 PID
get_ol_chief({Gid, Gsrvid}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{members = Members} ->
            [Pid || #guild_member{position = Pos, pid = Pid} <- Members, Pos >= ?guild_elder, is_pid(Pid)];
        _ ->
            []
    end.


%% @spec members_online(Role) -> [Data | ...]
%% Role = #role{}
%% Data = {Id, SrvId, Name, Lev, Career, Sex}
%% @doc 获取军团成员列表
members_online(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    L = case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{members = Members} ->
            Members;
        _ ->
            []
    end,
    [{Id, SrvId, Name, Lev, Career, Sex, Fight} || #guild_member{pid = Pid, id = {Id, SrvId}, name = Name, lev = Lev, career = Career, sex = Sex, fight = Fight} <- L, is_pid(Pid)].

online_pid(#role{id = Rid, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    L = case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{members = Members} ->
            Members;
        _ ->
            []
    end,
    [Pid || #guild_member{pid = Pid, id = MemRid} <- L, MemRid =/= Rid, is_pid(Pid)].


%% @spec applys(Role) -> ApplyList
%% Role = #role{}
%% @doc 军团已有申请列表
applys(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{apply_list = AL} ->
            AL;
        _ ->
            []
    end.

%% @spec limit_member_manage({Gid, Gsrvid}, Type) -> ok
%% Gid = integer()
%% Gsrvid = binary()
%% Type = unable | able
%% @doc 指定禁止成员管理操作
limit_member_manage({Gid, Gsrvid}, Type) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_limit_member_manage, [Type]}).

%% @spec async_limit_member_manage(State, Type) -> {ok}
%% State = #guild{}
%% Type = able | unable
%% @doc 锁定进行成员管理操作
async_limit_member_manage(_State, unable) ->
    case get(member_manage) of
        undefined ->
            put(member_manage, unable);     %% erlang:send_after(3600*1000, self(), member_manage_able);
        _ ->
            erase(member_manage)
    end,
    {ok};

%% 解锁成员管理操作
async_limit_member_manage(_State, able) ->
    erase(member_manage),
    {ok}.

%% @spec async_init_impeach(Guild) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% @doc 初始化弹劾信息
async_init_impeach(Guild = #guild{impeach = Impeach = #impeach{status = ?guild_impeach_role, time = Time, id = Rid, srv_id = Rsrvid}}) ->
    Rem = case Time + ?guild_mem_impeach_cancel - util:unixtime() of
        Diff when Diff > 0 -> 
            Diff;
        _ -> 600
    end,
    case guild:send_after(Rem, {?MODULE, async_impeach_success, [{Rid, Rsrvid}]}) of
        error ->
            {ok};
        Ref ->
            {ok, Guild#guild{impeach = Impeach#impeach{ref = Ref}}}
    end;
async_init_impeach(_Guild) -> 
    {ok}.

%% @spec active_impeach(Role) -> {ok, NewRole} | {false, Reason}
%% @doc 军团成员主动弹劾帮主
active_impeach(#role{guild = #role_guild{position = ?guild_chief}}) ->
    {false, ?L(<<"自己弹劾自己，不合适吧!">>)};
active_impeach(Role = #role{id = {Rid, Rsrvid},  guild = #role_guild{pid = Pid}}) ->
    role:send_buff_begin(),
    case role_gain:do([#loss{label = item, val = [33043, 0, 1]}], Role) of
        {ok, Role1} ->
            case guild:apply(sync, Pid, {?MODULE, sync_active_impeach, [{Rid, Rsrvid}]}) of
                true ->
                    role:send_buff_flush(),
                    {ok, Role1, ?L(<<"成功发起弹劾。若两天内帮主仍未上线，您将成为新一任帮主。">>)};
                {false, Reason} ->
                    role:send_buff_clean(),
                    {false, Reason};
                _ ->
                    role:send_buff_clean(),
                    {false, ?L(<<"请稍候再试！">>)}
            end;
        _ ->
            role:send_buff_clean(),
            {false, ?L(<<"没有弹劾令">>)}
    end.

sync_active_impeach(#guild{impeach = #impeach{status = ?guild_impeach_sys}}, _RoleID) ->
    {ok, {false, ?L(<<"发起弹劾失败，帮主正接受系统自动弹劾">>)}};
sync_active_impeach(#guild{impeach = #impeach{status = ?guild_impeach_role, id = Rid, srv_id = Rsrvid}}, {Rid, Rsrvid}) ->
    {ok, {false, ?L(<<"请勿重复操作">>)}};
sync_active_impeach(#guild{impeach = #impeach{status = ?guild_impeach_role, name = Rname}}, _RoleID) ->
    {ok, {false, util:fbin(?L(<<"太迟了, ~s 先提交了弹劾申请">>), [Rname])}};
sync_active_impeach(Guild = #guild{members = Mems, id = {Gid, Gsrvid}, name = Gname}, {Rid, Rsrvid}) ->
    ?DEBUG("11111111111"),
    case find(member, {Rid, Rsrvid}, Guild) of
        #guild_member{name = Rname} ->
            case lists:keyfind(?guild_chief, #guild_member.position, Mems) of
                #guild_member{id = Crid, srv_id = Csrvid, pid = Pid, date = Date} ->
                    case ((util:unixtime() - Date) > ?guild_mem_impeach_active) andalso Pid =:=0 of %% 帮主长期不在线
                        true ->
                            case guild:send_after(?guild_mem_impeach_cancel, {?MODULE, async_impeach_success, [{Rid, Rsrvid}]}) of
                                error ->
                                    {ok, {false, ?L(<<"请稍候再试！">>)}};
                                Ref ->
                                    guild:sys_msg(right_able, Mems, util:fbin(?L(<<"帮主连续超过 3 天没上线，{role,~w,~s,~s,#87CEFF} 选择了对帮主进行弹劾，若两天内帮主仍未上线，{role,~w,~s,~s,#87CEFF} 将成为新一任帮主。">>), [Rid, Rsrvid, Rname, Rid, Rsrvid, Rname])),
                                    spawn(mail, send_system, [{Crid, Csrvid}, {?L(<<"弹劾警告">>), util:fbin(?L(<<"您连续三天没上线，【~s】已向系统对您发起弹劾申请！">>), [Rname])}]),
                                    Time = util:unixtime(),
                                    spawn(guild, pack_send, [Mems, 12778, {?guild_impeach_role, Time, Rname, Date}]),
                                    {ok, true, Guild#guild{impeach = #impeach{ref = Ref, status = ?guild_impeach_role, time = Time, id = Rid, srv_id = Rsrvid, name = Rname}}}
                            end;
                        false ->
                            {ok, {false, ?L(<<"帮主这几天有上线哟，亲。等下次弹劾机会吧!">>)}}
                    end;
                _ ->
                    ?ERR("军团 [~w,~s,~s] 数据有误，找不到帮主数据", [Gid, Gsrvid, Gname]),
                    {ok, {false, ?L(<<"请稍候再试！">>)}}
            end;
        _ ->
            {ok, {false, ?L(<<"您不是本帮成员，操作失败">>)}}
    end.

async_impeach_success(#guild{impeach = #impeach{status = Status}}, _) when Status =/= ?guild_impeach_role ->
    {ok};
async_impeach_success(Guild = #guild{members = Mems, id = {Gid, Gsrvid}, name = Gname, impeach = #impeach{id = Rid, srv_id = Rsrvid}}, RoleID) ->
    case {Rid, Rsrvid} =:= RoleID of
        true ->
            case find(member, {Rid, Rsrvid}, Guild) of
                #guild_member{position = ?guild_chief} ->
                    {ok, Guild#guild{impeach = #impeach{}}};
                #guild_member{name = Rname, vip = Vip, date = Date} ->
                    case lists:keyfind(?guild_chief, #guild_member.position, Mems) of
                        #guild_member{rid = Crid, srv_id = Csrvid, name = Cname} ->
                            Guild1 = appoint(Crid, Csrvid, ?guild_disciple, Guild),
                            Guild2 = appoint(Rid, Rsrvid, ?guild_chief, Guild1),
                            guild:sys_msg(right_able, Mems, util:fbin(?L(<<"{role,~w,~s,~s,#87CEFF}弹劾帮主{role,~w,~s,~s,#87CEFF}成功，成为新任帮主">>), [Rid, Rsrvid, Rname, Crid, Csrvid, Cname])),
                            spawn(mail, send_system, [{Crid, Csrvid}, {?L(<<"弹劾通知">>), util:fbin(?L(<<"您的帮主身份已被【~s】弹劾。 2 天内可进行反对弹劾，否则帮主身份会被取代。">>), [Rname])}]),
                            spawn(guild, pack_send, [Mems, 12778, {?guild_impeach_normal, 0, <<>>, Date}]),
                            guild_refresh:refresh(13722, [{30, Rname}], Mems),
                            guild_refresh:refresh(13721, [{0, Vip}], Mems),
                            {ok, Guild2#guild{impeach = #impeach{}, chief = Rname, rvip = Vip}};
                        _ ->
                            ?ERR("军团 [~w,~s,~s] 数据有误，找不到帮主数据", [Gid, Gsrvid, Gname]),
                            {ok, Guild#guild{impeach = #impeach{}}}
                    end;
                _ ->
                    {ok, Guild#guild{impeach = #impeach{}}}
            end;
        false ->
            {ok}
    end.

%% @spec reject_impeach(Role) -> ok | {fasle, Reason}
%% Role = #role{}
%% Reason = binary()
%% @doc 帮主反对弹劾
reject_impeach(#role{guild = #role_guild{position = Job}}) when Job =/= ?guild_chief ->
    {false, ?MSGID(<<"您不是帮主，或您已经被弹劾了">>)};
reject_impeach(#role{id = {Rid, Rsrvid}, guild = #role_guild{pid = Pid}, link = #link{conn_pid = ConnPid}}) ->
    guild:apply(async, Pid, {?MODULE, async_reject_impeach, [{Rid, Rsrvid, ConnPid}]}).

%% @spec async_reject_impeach(Guild, {Rid, Rsrvid, ConnPid}) -> {ok} | {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% Rid = integer()
%% Rsrvid = binary()
%% ConnPid = pid()
%% @doc 军团反对弹劾
async_reject_impeach(#guild{impeach = #impeach{status = ?guild_impeach_normal}}, {_, _, ConnPid}) ->
    sys_conn:pack_send(ConnPid, 10931, {58, ?MSGID(<<"找不到弹劾信息，或您已经被弹劾了">>), []}),   %% TODO
    {ok};
async_reject_impeach(Guild = #guild{members = Mems}, {Rid, Rsrvid, ConnPid}) ->
    case find(member, {Rid, Rsrvid}, Guild) of
        #guild_member{position = ?guild_chief} ->
            guild:sys_msg(right_able, Mems, ?L(<<"弹劾帮主申请已被帮主驳回! 本次弹劾帮主失败!">>)),
            spawn(guild, pack_send, [Mems, 12778, {0, 0, <<>>, util:unixtime()}]),
            {ok, Guild#guild{impeach = #impeach{}}};
        false ->
            sys_conn:pack_send(ConnPid, 10931, {58, ?MSGID(<<"对方不是本帮成员，操作失败">>), []}),   %% TODO
            {ok};
        _ ->
            sys_conn:pack_send(ConnPid, 10931, {58, ?MSGID(<<"太晚了，您已经被弹劾了">>), []}),   %% TODO
            {ok}
    end.

%% 系统检测弹劾帮主
%auto_impeach(Guild = #guild{impeach = #impeach{status = ?guild_impeach_role}}) ->
%    Guild;
%auto_impeach(Guild = #guild{members = Mems, impeach = #impeach{status = ?guild_impeach_normal}}) ->
%    case lists:keyfind(?guild_chief, #guild_member.position, Mems) of
%        false ->
%            ?ERR("军团 [~s] 的数据有误，找不到帮主"),
%            Guild;
%        #guild_member{id = {Rid, Rsrvid}, pid = 0, date = Date} when length(Mems) > 1 ->    %% 军团成员多于一个，且帮主不在线
%            case (util:unixtime() - Date) >= ?guild_mem_impeach_active of
%                true ->
%                    guild:sys_msg(right_able, Mems, ?L(<<"帮主已经连续3天没上线，对军团整体运作造成了较大的影响，军团有志之士可以通过弹劾帮主，成为新一任帮主。">>)),
%                    case (util:unixtime() - Date) >= ?guild_mem_impeach_warn of
%                        true ->
%                            guild:sys_msg(right_able, Mems, ?L(<<"帮主已经连续7天没上线，对军团整体运作造成了较大的影响，系统已经自动对帮主进行弹劾。2天内帮主仍未上线，系统将自动另立帮主。">>)),
%                            spawn(mail, send_system, [{Rid, Rsrvid}, {?L(<<"弹劾警告">>), ?L(<<"您连续超过 7 天没上线，您已进入系统弹劾状态! 2 天内可进行反对弹劾，否则帮主身份会被取代。">>)}]),
%                            Guild#guild{impeach = #impeach{status = ?guild_impeach_sys, time = util:unixtime()}};
%                        false ->
%                            Guild
%                    end;
%                false ->
%                    Guild
%            end;
%        _ ->
%            Guild
%    end;

%auto_impeach(Guild = #guild{members = Mems, impeach = #impeach{status = ?guild_impeach_sys}}) ->
%    case lists:keyfind(?guild_chief, #guild_member.position, Mems) of
%        false ->
%            ?ERR("军团 [~s] 的数据有误，找不到帮主"),
%            Guild#guild{impeach = #impeach{}};
%        #guild_member{id = {Rid, Rsrvid}, name = Chief, pid = 0, date = Date} when length(Mems) > 1 ->
%            case (util:unixtime() - Date) >= ?guild_mem_impeach_auto of
%                true ->
%                    case pick_up_chief(Guild) of
%                        false ->                                %% 没有合适的人选
%                            Guild#guild{impeach = #impeach{}};
%                        #guild_member{id = {NewChiefId, NewChiefSrvid}, name = NewChief, vip = Vip, date = NewChiefDate} ->
%                            Guild1 = appoint(Rid, Rsrvid, ?guild_disciple, Guild),
%                            Guild2 = appoint(NewChiefId, NewChiefSrvid, ?guild_chief, Guild1),
%                            spawn(mail, send_system, [{Rid, Rsrvid}, {?L(<<"弹劾通知">>), ?L(<<"您连续超过 9 天没上线，已被系统弹劾帮主职位!">>)}]),
%                            spawn(mail, send_system, [{NewChiefId, NewChiefSrvid}, {?L(<<"升任帮主通知">>), util:fbin(?L(<<"前任帮主【~s】已被系统弹劾，恭喜您被系统选为新任帮主!">>), [Chief])}]),
%                            guild:sys_msg(right_able, Mems, util:fbin(?L(<<"帮主{role,~w,~s,~s,#87CEFF}连续超过 9 天 没上线，已被系统弹劾! 恭喜对军团卓有贡献的{role,~w,~s,~s,#87CEFF}被系统挑选为新任帮主">>), [Rid, Rsrvid, Chief, NewChiefId, NewChiefSrvid, NewChief])),
%                            guild_refresh:refresh(13722, [{30, NewChief}], Mems),
%                            guild_refresh:refresh(13721, [{0, Vip}], Mems),
%                            spawn(guild, pack_send, [Mems, 12778, {0, 0, <<>>, NewChiefDate}]),
%                            Guild2#guild{impeach = #impeach{}, chief = NewChief, rvip = Vip}
%                    end;
%                false ->
%                    Guild
%            end;
%        _ ->    %% 军团若只有帮主一个人，或帮主在线，忽略
%            Guild#guild{impeach = #impeach{}}
%    end.

pick_up_chief(#guild{members = Mems})  when length(Mems) =:= 0 -> false;
pick_up_chief(#guild{members = Mems}) ->
    Mems1 = [M || M = #guild_member{position = Pos} <- Mems, Pos =/= ?guild_chief], %% 剔除掉团长
    Fun = 
    fun(#guild_member{donation = Don, fight = F}, #guild_member{donation = Don1, fight = F1}) ->
            case Don =:= Don1 of
                true ->
                    F > F1;
                false ->
                    Don > Don1
            end end,
    case Mems1 of
        [] ->
            false;
        _ ->
            Mems2 = lists:sort(Fun, Mems1),            
            lists:nth(1, Mems2)
    end.

%%------------------------------------------------------------------------
%% @spec update(Cmd, Role) -> ok
%% Cmd = logout | guild_role | lev | sex | career | vip | fight | donation 
%% Role = #role{}
%% @doc 包含更新角色数据到军团进程中的缓存 
%%------------------------------------------------------------------------
%% 上线更新PID
update(pid, #role{id = {Rid, Rsrvid}, pid = Pid, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_update, [{pid, Pid, Rid, Rsrvid}]});

%% 下线通知军团进程
update(reset_pid, #role{id = {Rid, Rsrvid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_update, [{reset_pid, Rid, Rsrvid}]});

%% 更新角色在军团中所有数据
update(guild_role, Role = #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_update, [{guild_role, guild_role:convert(Role)}]});

%% 更新等级
update(lev, #role{id = {Rid, Rsrvid}, lev = Lev, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_update, [{lev, Lev, Rid, Rsrvid}]});

%% 更新职业
update(career, #role{id = {Rid, Rsrvid}, career = Career, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_update, [{career, Career, Rid, Rsrvid}]});

%% 更新性别
update(sex, #role{id = {Rid, Rsrvid}, sex = Sex, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_update, [{sex, Sex, Rid, Rsrvid}]});

%% 更新vip
update(vip, #role{id = {Rid, Rsrvid}, vip = #vip{type = Type, portrait_id = Gravatar}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_update, [{vip, Type, Gravatar, Rid, Rsrvid}]});

%% 更新战斗力
update(fight, #role{id = {Rid, Rsrvid}, attr = #attr{fight_capacity = Fight}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_update, [{fight, Fight, Rid, Rsrvid}]});

%% 更新头像
update(icon, #role{id = {Rid, Rsrvid}, vip = #vip{portrait_id = Gravatar}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, async_update, [{icon, Gravatar, Rid, Rsrvid}]});

%% 容错
update(_Cmd, _Data) ->
    ?ERR("错误的军团成员数据更新命令{~w}", [_Cmd]),
    ok.

%% 清空欢迎数据
clean_role_welcome(Role = #role{login_info = #login_info{last_logout = LastLogout}}) ->
    Now = util:unixtime(),
    Today = util:unixtime({today, Now}),
    Tomorrow = Today + 86400,
    case LastLogout < Today of
        true ->
            role_timer:set_timer(clean_guild_welcome, (Tomorrow - Now) * 1000, {guild_mem, clean_welcome, []}, 1, clean_welcome_role(Role));
        false ->
            role_timer:set_timer(clean_guild_welcome, (Tomorrow - Now) * 1000, {guild_mem, clean_welcome, []}, 1, Role)
    end.

clean_welcome(Role) ->
    Now = util:unixtime(),
    Tomorrow = util:unixtime({today, Now}) + 86400,
    {ok, role_timer:set_timer(clean_guild_welcome, (Tomorrow - Now) * 1000, {guild_mem, clean_welcome, []}, 1, clean_welcome_role(Role))}.

clean_welcome_role(Role = #role{guild = Guild}) ->
    Role#role{guild = Guild#role_guild{welcome_times = 0, welcome_list = [], send_welcome_times = 0}}.

%------------------------
%% 处理角色在军团的数据更新
%%------------------------
%% 上线更新
async_update(State = #guild{members = Members}, {pid, Pid, Rid, Rsrvid}) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Members) of
        false ->
            {ok};
        M ->
            M1 = M#guild_member{pid = Pid, date = util:unixtime()},
            NewState = State#guild{members = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Members, M1)},
            guild_refresh:refresh(13729, M1, Members),
            {ok, NewState}
    end;

%% 下线更新
async_update(State = #guild{members = Members}, {reset_pid, Rid, Rsrvid}) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Members) of
        false ->
            {ok};
        M ->
            M1 = M#guild_member{pid = 0, date = util:unixtime()},
            NewState = State#guild{members = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Members, M1)},
            guild_refresh:refresh(13729, M1, Members),
            {ok, NewState}
    end;

%% 更新帮众在军团数据
async_update(State = #guild{members = Members}, {guild_role, #guild_role{pid = Rpid, rid = Rid, srv_id = Rsrvid, lev = Lev, career = Career, sex = Sex, 
            vip = Vip, gravatar = Gravatar, fight = Fight, name = Rname, pet_fight = PetFight, donation = Donation}}
) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Members) of
        false ->
            {ok};
        M = #guild_member{pet_fight = PF} ->
            %% TODO 借新加 宠物战斗力同步更新玩家的帮贡问题
            M1 = case PF of
                0 ->    %% 第一次更新宠物数据，搭车更新军团贡献数据
                    M#guild_member{pid = Rpid, lev = Lev, career = Career, sex = Sex, vip = Vip, gravatar = Gravatar, date = util:unixtime(), 
                        fight = Fight, name = Rname, pet_fight = PetFight, donation = Donation};
                _ ->    %% 不是第一次更新宠物数据，不搭车更新军团贡献数据
                    M#guild_member{pid = Rpid, lev = Lev, career = Career, sex = Sex, vip = Vip, gravatar = Gravatar, date = util:unixtime(), 
                        fight = Fight, name = Rname, pet_fight = PetFight}
            end,
            NewState = State#guild{members = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Members, M1)},
            guild_refresh:refresh(13729, M1, Members),
            {ok, NewState}
    end;

%% 更新等级
async_update(State = #guild{members = Members}, {lev, Lev, Rid, Rsrvid}) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Members) of
        false ->
            {ok};
        M ->
            M1 = M#guild_member{lev = Lev},
            NewState = State#guild{members = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Members, M1)},
            guild_refresh:refresh(13729, M1, Members),
            {ok, NewState}
    end;

%% 更新职业
async_update(State = #guild{members = Members}, {career, Career, Rid, Rsrvid}) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Members) of
        false ->
            {ok};
        M ->
            M1 = M#guild_member{career = Career},
            NewState = State#guild{members = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Members, M1)},
            guild_refresh:refresh(13729, M1, Members),
            {ok, NewState}
    end;

%% 更新性别
async_update(State = #guild{members = Members}, {sex, Sex, Rid, Rsrvid}) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Members) of
        false ->
            {ok};
        M ->
            M1 = M#guild_member{sex = Sex},
            NewState = State#guild{members = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Members, M1)},
            guild_refresh:refresh(13729, M1, Members),
            {ok, NewState}
    end;

%% 更新Vip
async_update(State = #guild{members = Members}, {vip, Vip, Gravatar, Rid, Rsrvid}) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Members) of
        false ->
            {ok};
        M = #guild_member{position = ?guild_chief} ->
            M1 =  M#guild_member{vip = Vip, gravatar = Gravatar},
            NewMems = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Members, M1),
            NewState = State#guild{rvip = Vip, members = NewMems},
            guild_refresh:refresh(13729, M1, NewMems),
            {ok, NewState};
        M ->
            M1 =  M#guild_member{vip = Vip, gravatar = Gravatar},
            NewMems = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Members, M1),
            NewState = State#guild{members = NewMems},
            guild_refresh:refresh(13729, M1, NewMems),
            {ok, NewState}
    end;

%% 更新角色战斗力
async_update(State = #guild{members = Members}, {fight, Fight, Rid, Rsrvid}) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Members) of
        false ->
            {ok};
        M ->
            M1 =  M#guild_member{fight = Fight},
            NewState = State#guild{members = M2 = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Members, M1)},
            guild_refresh:refresh(13729, M1, Members),
            F = lists:foldl(fun(#guild_member{fight = Fc}, Sum) -> Sum + Fc end, 0, M2),
            rank:listener(guild_fc, NewState, F),
            {ok, NewState}
    end;

%% 更新角色头像
async_update(State = #guild{members = Members}, {icon, Gravatar, Rid, Rsrvid}) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Members) of
        false ->
            {ok};
        M ->
            M1 =  M#guild_member{gravatar = Gravatar},
            NewMems = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Members, M1),
            NewState = State#guild{members = NewMems},
            guild_refresh:refresh(13729, M1, NewMems),
            {ok, NewState}
    end.

%% 俸禄计算
salary(RLev, 0, Job) -> round( ((math:pow((1 * 1), 0.77) / 120) + 0.2 ) * factor(Job) * role_exp_data:get_guild_exp(RLev));
salary(RLev, Weal, Job) -> round( ((math:pow((Weal * Weal), 0.77) / 120) + 0.2) * factor(Job) * role_exp_data:get_guild_exp(RLev)).

%% 职业经验因子
factor(?guild_chief) -> ?chief_factor;
factor(?guild_elder) -> ?elder_factor;
factor(?guild_lord)  -> ?lord_factor;
factor(_Job) -> ?disciple_factor.

%% 根据角色职位获取对应权限
authority(?guild_chief) -> ?chief_op;
authority(?guild_elder) -> ?elder_op;
authority(?guild_lord) -> ?lord_op;
authority(_Job) -> ?disciple_op.

%% 清除角色经验领用状态，技能领用状态，藏经阁阅读状态
clear_role_guild_status(Mems) -> 
    Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:apply(async, Pid, {guild_api, set, [clear]});
        (#guild_member{rid = Rid, srv_id = Rsrvid}) -> guild_mgr:special(update_clear, {[1,2,3], Rid, Rsrvid})
    end,
    lists:foreach(Fun, Mems).

%% 清理军团成员的军团技能buf
clear_guild_skill_buf(Mems) ->
    Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:apply(async, Pid, {guild_api, set, [clear_skill]});
        (#guild_member{rid = Rid, srv_id = Rsrvid}) -> guild_mgr:special(update_clear, {[2], Rid, Rsrvid})
    end,
    lists:foreach(Fun, Mems).

%% 清理军团成员  经验俸禄状态
clear_guild_claim_exp(Mems) ->
    Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:apply(async, Pid, {guild_api, set, [{claim_exp, ?false}]});
        (#guild_member{rid = Rid, srv_id = Rsrvid}) -> guild_mgr:special(update_clear, {[1], Rid, Rsrvid})
    end,
    lists:foreach(Fun, Mems).

%% 清理军团成员  阅历兑换状态
clear_guild_claim_read(Mems) ->
    Fun = fun(#guild_member{pid = Pid}) when is_pid(Pid) -> role:apply(async, Pid, {guild_api, set, [{read, 0}]});
        (#guild_member{rid = Rid, srv_id = Rsrvid}) -> guild_mgr:special(update_clear, {[3], Rid, Rsrvid})
    end,
    lists:foreach(Fun, Mems).

%% 军团进程重启，检测在地图上的成员
inform_to_members(Mems, Pid, MapId) ->
    inform_to_member(Mems, Pid, MapId).
inform_to_member([] , _Pid, _MapId) ->
    ok;
inform_to_member([#guild_member{id = {Rid, Rsrvid}} | T], Pid, MapId) ->
    case global:whereis_name({role, Rid, Rsrvid}) of
        undefined -> 
            inform_to_member(T, Pid, MapId);
        RolePid ->
            role:apply(async, RolePid, {guild_api, set, [{guild_restart, Pid, MapId}]}),
            inform_to_member(T, Pid, MapId)
    end.

to_new_member(#guild_role{pid = Pid, rid = Rid, srv_id = Rsrvid, name = Name, pet_fight = PetFight,
        lev = Lev, sex = Sex, career = Career, vip = Vip, gravatar = Icon, fight = Fight}
) ->
    #guild_member{pid = Pid, id = {Rid, Rsrvid}, rid = Rid, srv_id = Rsrvid, name = Name, position = ?guild_disciple, authority = authority(?guild_disciple), 
        lev = Lev, sex = Sex, career = Career, vip = Vip, gravatar = Icon, date = util:unixtime(), fight = Fight, pet_fight = PetFight};
to_new_member(#apply_list{id = {Rid, Rsrvid}, name = Name, lev = Lev, career = Career, sex = Sex, vip = Vip, fight = Fight, gravatar = Gravatar}) ->
    #guild_member{id = {Rid, Rsrvid}, rid = Rid, srv_id = Rsrvid, name = Name, position = ?guild_disciple, authority = authority(?guild_disciple),
        lev = Lev, sex = Sex, career = Career, vip = Vip, date = util:unixtime(), fight = Fight, gravatar = Gravatar}.

to_role_guild(#guild_role{lev = Lev}, #guild{id = {Gid, Gsrvid}, pid = Pid, name = Gname, weal = Weal, shop = ShopLvl,wish_pool_lvl=WishLvl}) ->
    #role_guild{pid = Pid, gid = Gid, srv_id = Gsrvid, name = Gname, position = ?guild_disciple, authority = authority(?guild_disciple),
        salary = salary(Lev, Weal, ?guild_disciple), join_date = util:unixtime(), wish = #wish{times = guild_role:get_max_wish_time(WishLvl), lvl = WishLvl},
        shop = #shop{times = guild_role:get_max_shop_time(ShopLvl), lvl = ShopLvl}}.

%%-----------------------------------------------------------------------
%% guild 修改函数
%%-----------------------------------------------------------------------
%% 查找一条申请
find(apply, {Rid, Rsrvid}, #guild{apply_list = List}) ->
    lists:keyfind({Rid, Rsrvid}, #apply_list.id, List);
%% 查找一名成员
find(member, {Rid, Rsrvid}, #guild{members = Members}) ->
    lists:keyfind({Rid, Rsrvid}, #guild_member.id, Members).

%% 对指定成员任命
appoint(Rid, Rsrvid, Job, State = #guild{weal = Weal, members = Mems}) ->
    case find(member, {Rid, Rsrvid}, State) of
        false ->
            State;
        #guild_member{position = Job} ->
            State;
        M = #guild_member{pid = Pid, name = Name} ->
            catch role:apply(async, Pid, {guild_api, set, [{change_position, Job, Weal}]}),
            M1 = M#guild_member{authority = authority(Job), position = Job},
            NewMems = lists:keyreplace({Rid, Rsrvid}, #guild_member.id, Mems, M1),
            guild_refresh:refresh(13729, M1, NewMems),
            case Job of
                ?guild_chief ->
                    Text = util:fbin("玩家~s被委任为军团团长", [Name]),
                    [notification:send(offline, Id, ?notify_type_wanted, Text, []) || #guild_member{id = Id, position = Pos} <- NewMems, Pos =/= ?guild_chief andalso Pos =/= ?guild_elder ];
                ?guild_elder ->
                    Text = util:fbin("玩家~s被委任为军团副团长", [Name]),
                    [notification:send(offline, Id, ?notify_type_wanted, Text, []) || #guild_member{id = Id, position = Pos} <- NewMems, Pos =/= ?guild_chief andalso Pos =/= ?guild_elder ];
                _ ->
                    skip
            end,
            State#guild{members = NewMems};
        _ ->
            State
    end.

%% 成员任命，权限检测
appoint_auth_check(?chief_op, _Tauth, Nauth) when Nauth < ?chief_op -> true;
appoint_auth_check(?elder_op, Tauth, Nauth) when Tauth < ?elder_op andalso Nauth < ?elder_op -> true;
appoint_auth_check(?lord_op, Tauth, Nauth) when Tauth < ?lord_op andalso Nauth < ?lord_op -> true;
appoint_auth_check(_Auth, _Tauth, _Nauth) -> false.

%% 新增成员
add_member(Member = #guild_member{pid = Pid, rid = Rid, srv_id = Rsrvid, name = Rname, gravatar = FaceId}, State = #guild{members = Mems}) ->
    NewMems = [Member|Mems],
    guild:guild_chat(NewMems, util:fbin(?L(<<"恭喜{role, ~w, ~s, ~s, FFFF66}加入军团，双端列队欢迎！">>), [Rid, Rsrvid, Rname])),
    case is_pid(Pid) of
        true ->
            role:apply(async, Pid, {guild_mem, welcome_require, [{Mems, FaceId}]});
        false ->
            skip
    end,
    guild_refresh:refresh(13729, Member, Mems),
    guild_refresh:refresh(13721, [{2, length(NewMems)}], Mems),
    State1 = State#guild{num = length(NewMems), members = NewMems},
    guild_mgr:listen(guild_rank, State1),    %% 军团管理进程 数据副本监听
    State1.

%% 发送欢迎请求
welcome_require(#role{id = Id, name = Name, lev = Lev, career = Career, guild = #role_guild{welcome_times = Times}}, {Mems, FaceId}) when Times < 30 ->
    [role:apply(async, Pid, {guild_mem, do_welcome_require, [{Id, Name, Lev, Career, FaceId}]}) || #guild_member{pid = Pid} <- Mems, is_pid(Pid)],
    {ok};
welcome_require(_, _) -> {ok}.

do_welcome_require(Role = #role{pid = Pid, guild = Guild = #role_guild{welcome_list = List, send_welcome_times = Times}}, {{Rid, SrvId}, Name, Lev, Career, FaceId}) when Times < 10 ->
    NewList = case lists:keyfind({Rid, SrvId}, 1, List) of
        false ->
            [{{Rid, SrvId}, Name} | List];
        _ ->
            List
    end,
    role:pack_send(Pid, 12789, {Rid, SrvId, Name, Lev, Career, FaceId}),
    {ok, Role#role{guild = Guild#role_guild{welcome_list = NewList}}};
do_welcome_require(_, _) -> {ok}.

%% 欢迎新成员加入
welcome(Role = #role{name = RoleName, guild = Guild = #role_guild{gid = Gid, name = GuildName, welcome_list = List, send_welcome_times = Times}}, MemId) when Times < 10 ->
    case lists:keyfind(MemId, 1, List) of
        false ->
            {false, <<>>};
        {{MemRoleId, MemSrvId}, MemName} ->
            Type = util:rand(1, 3),
            Role1 = Role#role{guild = Guild#role_guild{welcome_list = lists:keydelete(MemId, 1, List), send_welcome_times = Times + 1}},
            case global:whereis_name({role, MemRoleId, MemSrvId}) of
                Pid when is_pid(Pid) ->
                    case role:apply(sync, Pid, {guild_mem, welcome_mail, [{Type, GuildName, RoleName, Gid}]}) of
                        {ok} ->
                            Exp = 3888,
                            case role_gain:do([#gain{label = exp, val = Exp}], Role1) of
                                {ok, NewRole} ->
                                    notice:inform(util:fbin(?L(<<"获得{str,经验,#00ff24} ~w">>),[Exp])),
                                    {ok, NewRole, Type, MemName};
                                _ ->
                                    {ok, Role1, Type, MemName}
                            end;
                        {false, Reason} ->
                            {false, Role1, Reason}
                    end;
                _ ->
                    {false, Role1, util:fbin(?L(<<"【~s】不在线，无法接受您的欢迎">>), [MemName])}
            end
    end;
welcome(_, _) -> {false, ?L(<<"您的欢迎次数已达到上限，无法再发送欢迎">>)}.

%% 新成员欢迎邮件
welcome_mail(#role{name = Name, guild = #role_guild{welcome_times = Times}}, _) when Times >= 30 -> 
    {ok, {false, util:fbin(?L(<<"【~s】接受欢迎次数已达上限，无法接受您的欢迎">>), [Name])}};
welcome_mail(#role{name = Name, guild = #role_guild{gid = Gid1}}, {_, _, _, Gid2}) when Gid1 =/= Gid2 ->
    {ok, {false, util:fbin(?L(<<"【~s】已不在您的军团，无法接受您的欢迎">>), [Name])}};
welcome_mail(Role = #role{id = {Rid, SrvId}, name = Name, guild = Guild = #role_guild{welcome_times = Times}}, {Type, GuildName, RoleName, _}) ->
    {Content, Assets, Items} = case Type of
        1 ->
            {util:fbin(?L(<<"恭喜您成功加入【~s】，获得【~s】送上的欢迎之礼，888点经验！">>), [GuildName, RoleName]), [{?mail_exp, 888}], []};
        2 ->
            {util:fbin(?L(<<"恭喜您成功加入【~s】，获得【~s】送上的欢迎之礼，888绑定金币！">>), [GuildName, RoleName]), [{?mail_coin_bind, 888}], []};
        3 ->
            {util:fbin(?L(<<"恭喜您成功加入【~s】，获得【~s】送上的欢迎之礼，1朵鲜花！">>), [GuildName, RoleName]), [], [{33002, 1, 1}]}
    end,
    mail_mgr:deliver({Rid, SrvId, Name}, {?L(<<"欢迎新成员加入帮派">>), Content, Assets, Items}),
    {ok, {ok}, Role#role{guild = Guild#role_guild{welcome_times = Times + 1}}}.

%% 删除一个成员
delete_member({Rid, Rsrvid}, State = #guild{members = Mems}) ->
    case lists:keyfind({Rid, Rsrvid}, #guild_member.id, Mems) of
        false ->
            State;
        _ ->
            NewMems = lists:keydelete({Rid, Rsrvid}, #guild_member.id, Mems),
            guild_refresh:refresh(13728, {Rid, Rsrvid}, NewMems), 
            guild_refresh:refresh(13721, [{2, length(NewMems)}], Mems),
            State1 = delete_member_clean(State#guild{num = length(NewMems), members = NewMems}, {Rid, Rsrvid}),
            guild_mgr:listen(guild_rank, State1),    %% 军团管理进程 数据副本监听
            State1
    end.

%% 清掉一个成员对军团需要的清理操作
delete_member_clean(State = #guild{members = Mems, impeach = #impeach{status = ?guild_impeach_role, ref = Ref, id = Rid, srv_id = Rsrvid}}, {Rid, Rsrvid}) ->
    catch erlang:cancel_timer(Ref),
    spawn(guild, pack_send, [Mems, 12778, {?guild_impeach_normal, 0, <<>>, util:unixtime()}]),
    State#guild{impeach = #impeach{}};
delete_member_clean(State, _) ->
    State.

%% 删除申请
delete_apply({Rid, Rsrvid}, State = #guild{apply_list = List, members = Mems}) ->
    guild_refresh:refresh(13726, {Rid, Rsrvid}, Mems),
    NewList = lists:keydelete({Rid, Rsrvid}, #apply_list.id, List),
    State1 = State#guild{apply_list = NewList},
    guild_common:pack_send_notice(State1),
    State1.

%% 增加一条申请
add_apply(#guild_role{rid = Rid, srv_id = Rsrvid, name = Name, lev = Lev, career = Career, sex = Sex, fight = Fight, vip = Vip, gravatar = Gravatar}, 
    State = #guild{apply_list = List, members = Mems}) ->
    guild_refresh:refresh(13727, {Rid, Rsrvid, Name, Lev, Career, Sex, Fight, Vip}, Mems),
    NewList = [#apply_list{id = {Rid, Rsrvid}, rid = Rid, srv_id = Rsrvid, name = Name, lev = Lev, career = Career, sex = Sex, fight = Fight, vip = Vip, gravatar = Gravatar} |List],
    State1 = State#guild{apply_list = NewList},
    guild_common:pack_send_notice(State1),
    State1.   

%%
is_position_ok(Position, Num) ->
    case Position of
        ?guild_elder when Num < ?guild_elder_num -> true;
        ?guild_lord when Num < ?guild_lord_num -> true;
        ?guild_elite when Num < ?guild_elite_num -> true;
        ?guild_disciple -> true;
        _ -> false
    end.

%% 求一个tuple_list中含有某个键值的数目
keynum(Key, Nth, List) ->
    keynum_count(Key, Nth, List, 0).
keynum_count(_Key, _Nth, [], Num) ->
    Num;
keynum_count(Key, Nth, [Tuple | List], Num) ->
    case Key =:= erlang:element(Nth, Tuple) of
        true -> keynum_count(Key, Nth, List, Num + 1);
        false -> keynum_count(Key, Nth, List, Num)
    end.
