%%----------------------------------------------------
%%  帮会系统
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_adm).
-export([onekey_max/1
        ,update/0
        ,cmd/1                                  %% 向所有帮会进程发送一个命令
        ,cmd_mgr/1                              %% 向帮会管理进程发送一个命令
        ,get_guild_info/2                       %% 查询帮会数据
    ]
).

-export([get_role_pos/1                         %% 获取玩家的 pos 
        ,set_xy/4                               %% 重置玩家的 XY
        ,async_set_xy/3                         %% 角色进程回调，重置 XY 坐标
        ,get_role_guild/1                       %% 获取角色帮会数据
        ,clear_roles_guild/1                    %% 清除角色帮会数据
        ,async_clear_guild/1                    %% 角色进程回调，清除帮会数据
        ,clear_role_guild_update_status/2       %% 清除角色的帮会技能，经验，藏经阁阅读状态
    ]
).

-export([alter/3                                %% 修改帮会数据
        ,sync_alter/3                           %% 帮会进程回调，修改帮会数据
    ]
).

-export([stop/0                                 %% 关闭帮会管理进程
        ,start/0                                %% 启动帮会管理进程
        ,restart/0                              %% 重启帮会管理经常
        ,terminate_all/0                        %% 关闭所有帮会进程
        ,start_all/0                            %% 启动所有帮会进程     从ETS查找数据，启动
        ,restart_all/0                          %% 重启所有帮会进程     从ETS查找数据，启动
        ,terminate_specify/1                    %% 关闭指定帮会进程
        ,start_specify/1                        %% 启动指定帮会进程     从ETS查找数据，启动
        ,restart_specify/1                      %% 重启指定帮会进程     从ETS查找数据，启动
        ,sync_guild_to_db/1                     %% 将指定帮会数据回写数据库
        ,sync_all_guild_to_db/0                 %% 将所有帮会数据回写数据库
        ,sync_spec_role_guild_to_db/1           %% 将指定角色帮会特殊属性回写数据库
    ]
).

-include("guild.hrl").
-include("gain.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("common.hrl").
-include("vip.hrl").
-include("storage.hrl").
-include("assets.hrl").

-define(type2cmd(Type),
    case Type of
        0 -> maintain;
        1 -> dismiss_check;
        _ -> true
    end).

-define(type2mgrcmd(Type),
    case Type of
        _ -> true
    end).

%%-----------------------------------------------------------------------
%% GM命令区
%%-----------------------------------------------------------------------
%% @spec update() -> term()
%% @doc 快捷命令
update() ->
    restart(),
    cmd([1,2]),
    success.

%% @spec cmd(Types) -> ok
%% Types = list()
%% @doc 后台执行帮会命令
cmd(Types) when is_list(Types) ->
    ?INFO("开始执行帮会后台命令..."),
    case guild_mgr:list() of
        [] ->
            [];
        L ->
            cmd_list(Types, L, [])
    end;
cmd(_Types) ->
    [util:fbin(?L(<<"传入非法指令列表格式，【~w】">>), [_Types])].

cmd_list([], _, Result) ->
    ?INFO("帮会后台命令执行完毕"),
    Result;
cmd_list([H | T], L, Result) ->
    cmd_list(T, L, cmd(H, L, Result)).

cmd(_Type, [], Result) ->
    Result;
cmd(Type, [#guild{name = Gname, pid = Pid} | T], Result) ->
    case ?type2cmd(Type) of
        true ->
            cmd(Type, T, [util:fbin(?L(<<"指令【~w】不存在">>), [Type]) |Result]);
        Cmd ->
            case guild:guild_info(Pid, Cmd) of
                ok ->
                    cmd(Type, T, Result);
                _ ->
                    cmd(Type, T, [ util:fbin(?L(<<"向帮会【~s】发送指令【~w】失败，帮会进程不存在">>), [Gname, Cmd]) |Result])
            end
    end.

%% @spec cmd_mgr(Types) -> term()
%% @doc 帮会管理进程发送命令
cmd_mgr(Types) when is_list(Types) ->
    cmd_mgr(Types, []);
cmd_mgr(_Types) ->
    [util:fbin(?L(<<"传入非法指令列表格式，【~w】">>), [_Types])].

cmd_mgr([], Re) ->
    Re;
cmd_mgr([H | T], Re) ->
    case ?type2mgrcmd(H) of
        true ->
            cmd_mgr(T, [util:fbin(?L(<<"指令【~w】不存在">>), [H]) |Re]);
        Cmd ->
            guild_mgr:mgr_cast(Cmd),
            cmd_mgr(T, Re)
    end.

%% @spec onekey_max(GuildId) -> ok
%% GuildId = {integer(), binary()}
%% @doc 一键盘最强
onekey_max(GuildId) ->
    alter(GuildId, stove, 20),
    alter(GuildId, weal, 20),
    alter(GuildId, skills, {fun alter_guild_skill/1}),
    alter(GuildId, fund, 99999999),
    alter(GuildId, lev, 50),
    ok.

%% ------------------------------------------------------------------------
%% API 接口 针对角色
%% ------------------------------------------------------------------------
%% @spec get_role_pos(Name) -> term()
%% Name = binary()
%% @doc 获取玩家的 pos
get_role_pos(Name) ->
    case role_api:lookup(by_name, Name) of
        {ok, _, #role{pos = Pos}} -> Pos;
        _ -> false
    end.

%% @spec set_xy(Name) -> term()
%% Name = binary()
%% @doc 重置玩家的 XY 坐标
set_xy(pos, Name, X, Y) ->
    case role_api:lookup(by_name, Name) of
        {ok, _, #role{pid = Pid}} ->
            role:apply(async, Pid, {guild_adm, async_set_xy, [X, Y]});
        _ ->
            false
    end.

%% @spec get_role_guild(RoleId) -> term()
%% @doc 获取某个角色的帮会数据
get_role_guild(RoleId) ->
    try
        case role_api:lookup(by_id, RoleId) of
            {ok, _, #role{guild = Guild}} ->
                Guild;
            _ ->
                false
        end
    catch
        _:_ ->
            false
    end.

%% @spec clear_role_guild(Names) -> term()
%% Names = [binary() | ..]
%% @doc 清楚角色帮会属性
clear_roles_guild([]) ->
    success;
clear_roles_guild([Name | Roles]) ->
    case role_api:lookup(by_name, Name, to_guild_role) of
        {ok, _, #guild_role{pid = Pid}} ->
            catch role:apply(async, Pid, {guild_adm, async_clear_guild, []}),
            clear_roles_guild(Roles);
        _ ->
            clear_roles_guild(Roles)
    end.
%% @spec clear_role_guild_update_status(Rid, Srvid) -> term()
%% Rid = integer()
%% Srvid = binary()
%% @doc 清除角色的帮会技能，经验，藏经阁阅读状态
clear_role_guild_update_status(Rid, Srvid) ->
    case global:whereis_name({role, Rid, Srvid}) of
        undefined -> 
            util:fbin(?L(<<"角色 [~w, ~s] 不在线，清除失败">>), [Rid, Srvid]);
        Pid ->
            role:apply(async, Pid, {guild_api, set, [clear]}),
            <<"success">>
    end.

%% ------------------------------------------------------------------------
%% API 接口 针对帮会
%% ------------------------------------------------------------------------
%% @spec restart() -> ok
%% @doc 重启帮会管理进程
restart() ->
    stop(),
    start(),
    ok.

%% @spec stop() -> term()
%% @doc 关闭帮会管理进程 TODO 警告：这会关闭所有的帮会进程， 帮会ETS会不存在
stop() ->
    supervisor:terminate_child(sup_master, guild_mgr).

%% @spec start() -> term()
%% @doc 启动帮会管理进程
start() ->
    supervisor:restart_child(sup_master, guild_mgr).

%% @spec terminate_all() -> term()
%% @doc 关闭所有的帮会进程, 管理进程不会被关闭
terminate_all() ->
    guild_mgr:terminate_all().

%% @spec start_all() -> term()
%% @doc 启动所有帮会进程
start_all() ->
    guild_mgr:start_all().

%% @spec restart_all() -> term()
%% @doc 重启所有的帮会进程
restart_all() ->
    guild_mgr:restart_all().

%% @spec terminate_specify(GuildIds) -> term()
%% GuildIds = [{integer(), binary()} | ..]
%% @doc 关闭指定帮会进程
terminate_specify(GuildIds) ->
    Fun = fun({Gid, Gsrvid}) -> is_integer(Gid) andalso is_binary(Gsrvid) andalso Gid > 0 end,
    case catch lists:all(Fun, GuildIds) of
        true ->
            guild_mgr:terminate_specify(GuildIds);
        _ ->
            ?INFO("关闭指定帮会进程时，传入错误的参数"),
            ?L(<<"传入帮会ID参数有误">>)
    end.

%% @spec start_specify(GuildIds) -> term()
%% GuildIds = [{integer(), binary()} | ..]
%% @doc 启动指定帮会
start_specify(GuildIds) ->
    Fun = fun({Gid, Gsrvid}) -> is_integer(Gid) andalso is_binary(Gsrvid) andalso Gid > 0 end,
    case catch lists:all(Fun, GuildIds) of
        true ->
            guild_mgr:start_specify(GuildIds);
        _ ->
            ?INFO("启动指定帮会进程时，传入错误的参数"),
            ?L(<<"传入帮会ID参数有误">>)
    end.

%% @spec restart_specify(GuildIds) -> term()
%% GuildIds = [{integer(), binary()} | ..]
%% @doc 重启指定帮会进程
restart_specify(GuildIds) ->
    Fun = fun({Gid, Gsrvid}) -> is_integer(Gid) andalso is_binary(Gsrvid) andalso Gid > 0 end,
    case catch lists:all(Fun, GuildIds) of
        true ->
            guild_mgr:restart_specify(GuildIds);
        _ ->
            ?INFO("重启指定帮会进程时，传入错误的参数"),
            ?L(<<"传入帮会ID参数有误">>)
    end.

%% @spec sync_guild_to_db(GuildIds) -> term()
%% GuildIds = [{integer(), binary()} | ..]
%% @doc 将指定帮会数据回写数据库
sync_guild_to_db(GuildIds) ->
    Now = util:unixtime(),
    case erlang:get(adm_guild_op) of
        Time when is_integer(Time) andalso (Now - Time) =< 5 ->
            ?L(<<"请不要频繁操作">>);
        _ ->
            erlang:put(adm_guild_op, Now),
            Fun = fun({Gid, Gsrvid}) -> is_integer(Gid) andalso is_binary(Gsrvid) andalso Gid > 0 end,
            case catch lists:all(Fun, GuildIds) of
                true ->
                    guild_mgr:sync_to_db(by_guild_id, GuildIds);
                _ ->
                    ?INFO("指定帮会数据回写数据库时，传入错误的参数"),
                    ?L(<<"传入帮会ID参数有误">>)
            end
    end.

%% @spec sync_spec_role_guild_to_db(RoleIds) -> term()
%% RoleIds = [{integer(), binary()} | ..]
%% @doc 将指定的角色的特殊帮会属性数据回写到数据库
sync_spec_role_guild_to_db(RoleIds) ->
    Fun = fun({Rid, Rsrvid}) -> is_integer(Rid) andalso is_binary(Rsrvid) end,
    case catch lists:all(Fun, RoleIds) of
        true ->
            guild_mgr:sync_to_db(by_role_id, RoleIds);
        _ ->
            ?INFO("指定角色特殊帮会属性数据回写数据库时，传入错误的参数"),
            ?L(<<"传入角色ID参数有误">>)
    end.

%% @spec sync_all_guild_to_db() -> term()
%% 将所有帮会数据回写数据库
sync_all_guild_to_db() ->
    guild_mgr:sync_all_to_db().

%% @spec alter(Type, GuildId, Value) -> term()
%% GuildId= {integer(), binary()}
%% Type = atom()
%% Value = term()
%% @doc 修改帮会数据
alter(GuildId, Type, Value) ->
    case is_valid_type_value(Type, Value) of
        true -> guild:apply(sync, GuildId, {?MODULE, sync_alter, [Type, Value]});
        {false, Reason} -> Reason
    end.

%% @spec get_guild_info(GuildId, Indexs) -> term()
%% GuildId = {integer(), binary()}
%% Cmd = atom()
%% Indexs = [integer() | ..]
%% @doc 查询指定帮会数据
get_guild_info({Gid, Gsrvid}, Indexs) ->
    case lists:all(fun(Index) -> is_integer(Index) andalso Index > 1 andalso Index =< record_info(size, guild) end, Indexs) of
        true ->
            case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
                false -> error_guild_not_exist;
                Guild  ->
                    case file:open("../var/query_guild_data.erl", [write]) of
                        {ok, IoDev} ->
                            Fun = fun(Index) -> file:write(IoDev, io_lib:format("~w~n:~p~n~n", [lists:nth(Index - 1, record_info(fields, guild)), element(Index, Guild)])) end,
                            lists:foreach(Fun, Indexs),
                            file:close(IoDev),
                            'the query result had been saved as ../var/query_guild_data.erl';
                        {error, Reason} ->
                            Reason
                    end
            end;
        false -> error_index_value
    end.

%% ------------------------------------------------------------------------
%% 角色进程同步回调
%% ------------------------------------------------------------------------
%% ========================================================================
%% @spec async_clear_guild(Role) -> {ok, NewRole}
%% Role = NewRole = #role{}
%% @doc 清除角色帮会属性
async_clear_guild(Role = #role{id = {Rid, Rsrvid}}) ->
    guild_mgr:special(reset,{Rid, Rsrvid}),
    {ok, Role#role{guild = #role_guild{}}}.

%% @spec async_set_xy(Role, X, Y) -> {ok, NewRole}
%% Role = NewRole = #role{}
%% @doc 重置玩家的 X Y 坐标
async_set_xy(Role = #role{pos = Pos}, X, Y) ->
    {ok, Role#role{pos = Pos#pos{x = X, y = Y}}}.

%% ------------------------------------------------------------------------
%% 帮会进程同步回调
%% ------------------------------------------------------------------------
%%=========================================================================
%% @spec sync_alter(Guild, Data) -> {ok, term(), NewGuild} | {ok, term()}
%% Guild = NewGuild = #guild{}
%% @doc 修改帮会数据
%%=========================================================================
%% 修改帮会VIP类型
sync_alter(Guild, vip, Vip) when Vip =:= ?guild_vip orelse Vip =:= ?guild_piv ->
    {ok, success, Guild#guild{gvip = Vip}};
sync_alter(_Guild, vip, _Vip) ->
    {ok, error_realm_value};
%% 修改帮会名字
sync_alter(Guild, guild_name, Name) when is_binary(Name) ->
    {ok, success, Guild#guild{name = Name}};
sync_alter(_Guild, guild_name, _Name) ->
    {ok, error_guild_name_value};
%% 修改帮会等级
sync_alter(Guild, lev, Lev) when Lev > 0 andalso Lev =< ?max_guild_lev andalso is_integer(Lev) ->
    {ok, success, Guild#guild{lev = Lev}};
sync_alter(_Guild, lev, _Lev) ->
    {ok, error_guild_lev_value};
%% 修改帮主名字
sync_alter(Guild, chief_name, Name) when is_binary(Name) ->
    {ok, success, Guild#guild{chief = Name}};
sync_alter(_Guild, chief_name, _Name) ->
    {ok, error_chief_name_value};
%% 修改帮主VIP
sync_alter(Guild, chief_vip, Vip) ->
    case lists:member(Vip, ?vip_list) of
        true -> {ok, success, Guild#guild{rvip = Vip}};
        false -> {ok, error_chief_vip_value}
    end;
%% 修改帮会成员数据
sync_alter(Guild = #guild{members = Mems}, member, {F}) ->
    try erlang:apply(F, [Mems]) of
        NewMems when is_list(NewMems) ->
            case lists:all(fun(Member) -> is_record(Member, guild_member) end, NewMems) of
                true ->
                    {ok, success, Guild#guild{members = NewMems}};
                false ->
                    {ok, error_return_value_of_the_mfa_fun_for_guild_members}
            end;
        _ ->
            {ok, error_return_value_of_the_mfa_fun_for_guild_members}
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会成员数据
sync_alter(Guild = #guild{members = Mems}, member, {F, A}) ->
    try erlang:apply(F, [Mems | A]) of
        NewMems when is_list(NewMems) ->
            case lists:all(fun(Member) -> is_record(Member, guild_member) end, NewMems) of
                true ->
                    {ok, success, Guild#guild{members = NewMems}};
                false ->
                    {ok, error_return_value_of_the_mfa_fun_for_guild_members}
            end;
        _ ->
            {ok, error_return_value_of_the_mfa_fun_for_guild_members}
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会成员数据
sync_alter(Guild = #guild{members = Mems}, member, {M, F, A}) ->
    try erlang:apply(M, F, [Mems | A]) of
        NewMems when is_list(NewMems) ->
            case lists:all(fun(Member) -> is_record(Member, guild_member) end, NewMems) of
                true ->
                    {ok, success, Guild#guild{members = NewMems}};
                false ->
                    {ok, error_return_value_of_the_mfa_fun_for_guild_members}
            end;
        _ ->
            {ok, error_return_value_of_the_mfa_fun_for_guild_members}
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会成员数据
sync_alter(_Guild, members, _Value) ->
    {ok, error_members_mfa_value};
%% 修改帮会福利等级
sync_alter(Guild, weal, Lev) when Lev > 0 andalso Lev =< ?max_weal_lev andalso is_integer(Lev) ->
    {ok, success, Guild#guild{weal = Lev}};
sync_alter(_Guild, weal, _Lev) ->
    {ok, error_weal_lev_value};
%% 修改帮会仓库数据
sync_alter(Guild = #guild{store = Store}, store, {F}) ->
    try erlang:apply(F, [Store]) of
        NewStore when is_record(NewStore, guild_store) ->
            {ok, success, Guild#guild{store = NewStore}};
        _ ->
            {ok, error_return_value_of_the_mfa_fun_for_guild_store}
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会仓库数据
sync_alter(Guild = #guild{store = Store}, store, {F, A}) ->
    try erlang:apply(F, [Store | A]) of
        NewStore when is_record(NewStore, guild_store) ->
            {ok, success, Guild#guild{store = NewStore}};
        _ ->
            {ok, error_return_value_of_the_mfa_fun_for_guild_store}
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会仓库数据
sync_alter(Guild = #guild{store = Store}, store, {M, F, A}) ->
    try erlang:apply(M, F, [Store | A]) of
        NewStore when is_record(NewStore, guild_store) ->
            {ok, success, Guild#guild{store = NewStore}};
        _ ->
            {ok, error_return_value_of_the_mfa_fun_for_guild_store}
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会仓库数据
sync_alter(_Guild, store, _Value) ->
    {ok, error_store_mfa_value};
%% 清空帮会仓库日志
sync_alter(Guild, store_log, []) ->
    {ok, success, Guild#guild{store_log = []}};
sync_alter(_Guild, store_log, _Value) ->
    {ok, error_store_log_only_support_empty_log};
%% 修改帮会 神炉 等级
sync_alter(Guild, stove, Lev) when Lev > 0 andalso Lev =< ?max_stove_lev andalso is_integer(Lev) ->
    {ok, success, Guild#guild{stove = Lev}};
sync_alter(_Guild, stove, _Lev) ->
    {ok, error_stove_lev_value};
%% 修改帮会资金
sync_alter(Guild, fund, Fund) when is_integer(Fund) ->
    {ok, success, Guild#guild{fund = Fund}};
sync_alter(_Guild, fund, _Fund) ->
    {ok, error_fund_value};
%% 清空帮会捐献日志
sync_alter(Guild, donation_log, []) ->
    {ok, success, Guild#guild{donation_log = []}};
sync_alter(_Guild, donation_log, _Value) ->
    {ok, error_donation_log_only_support_empty_log};
%% 修改帮会目标数据
sync_alter(Guild = #guild{aims = Aims}, aims, {F}) ->
    try erlang:apply(F, [Aims]) of
        Newaims when is_record(Newaims, guild_aims) ->
            {ok, success, Guild#guild{aims = Newaims}};
        _ ->
            {ok, error_return_value_of_the_mfa_fun_for_guild_aims}
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会目标数据
sync_alter(Guild = #guild{aims = Aims}, aims, {F, A}) ->
    try erlang:apply(F, [Aims | A]) of
        Newaims when is_record(Newaims, guild_aims) ->
            {ok, success, Guild#guild{aims = Newaims}};
        _ ->
            {ok, error_return_value_of_the_mfa_fun_for_guild_aims}
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会目标数据
sync_alter(Guild = #guild{aims = Aims}, aims, {M, F, A}) ->
    try erlang:apply(M, F, [Aims | A]) of
        Newaims when is_record(Newaims, guild_aims) ->
            {ok, success, Guild#guild{aims = Newaims}};
        _ ->
            {ok, error_return_value_of_the_mfa_fun_for_guild_aims}
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会目标数据
sync_alter(_Guild, aims, _Value) ->
    {ok, error_aims_mfa_value};
%% 修改帮会技能数据
sync_alter(Guild = #guild{skills = Skills}, skills, {F}) ->
    try erlang:apply(F, [Skills]) of
        NewSkills ->
            case is_valid_guild_skill(NewSkills) of
                true -> {ok, success, Guild#guild{skills = NewSkills}};
                false -> {ok, error_return_value_of_the_mfa_fun_for_guild_Skills}
            end
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会技能s据
sync_alter(Guild = #guild{skills = Skills}, skills, {F, A}) ->
    try erlang:apply(F, [Skills | A]) of
        NewSkills ->
            case is_valid_guild_skill(NewSkills) of
                true -> {ok, success, Guild#guild{skills = NewSkills}};
                false -> {ok, error_return_value_of_the_mfa_fun_for_guild_Skills}
            end
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会技能数据
sync_alter(Guild = #guild{skills = Skills}, skills, {M, F, A}) ->
    try erlang:apply(M, F, [Skills | A]) of
        NewSkills ->
            case is_valid_guild_skill(NewSkills) of
                true -> {ok, success, Guild#guild{skills = NewSkills}};
                false -> {ok, error_return_value_of_the_mfa_fun_for_guild_Skills}
            end
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会技能数据
sync_alter(_Guild, skills, _Value) ->
    {ok, error_Skills_mfa_value};
%% 修改帮会弹劾数据
sync_alter(Guild = #guild{impeach = Impeach}, impeach, {F}) ->
    try erlang:apply(F, [Impeach]) of
        NewImpeach when is_record(NewImpeach, impeach) ->
            {ok, success, Guild#guild{impeach = NewImpeach}};
        _ ->
            {ok, error_return_value_of_the_mfa_fun_for_impeach}
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会弹劾数据
sync_alter(Guild = #guild{impeach = Impeach}, impeach, {F, A}) ->
    try erlang:apply(F, [Impeach | A]) of
        NewImpeach when is_record(NewImpeach, impeach) ->
            {ok, success, Guild#guild{impeach = NewImpeach}};
        _ ->
            {ok, error_return_value_of_the_mfa_fun_for_impeach}
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会弹劾数据
sync_alter(Guild = #guild{impeach = Impeach}, impeach, {M, F, A}) ->
    try erlang:apply(M, F, [Impeach | A]) of
        NewImpeach when is_record(NewImpeach, impeach) ->
            {ok, success, Guild#guild{impeach = NewImpeach}};
        _ ->
            {ok, error_return_value_of_the_mfa_fun_for_impeach}
    catch
        Err:Info ->
            {ok, util:fbin("~s:~s", [Err, Info])}
    end;
%% 修改帮会弹劾数据
sync_alter(_Guild, impeach, _Value) ->
    {ok, error_impeach_mfa_value};
%% 修改帮会阵营
sync_alter(Guild, realm, Realm) ->
    case lists:member(Realm, ?role_realms) of
        true ->
            {ok, success, Guild#guild{realm = Realm}};
        false ->
            {ok, error_realm_value}
    end;

sync_alter(_Guild, _Type, _value) ->
    {ok, error_unknow_type}.

%% -------------------------------------------------------------------------
%% 私有函数
%% -------------------------------------------------------------------------
%% 修改帮会VIP类型
is_valid_type_value(vip, Vip) when Vip =:= ?guild_vip orelse Vip =:= ?guild_piv ->
    true;
is_valid_type_value(vip, _Vip) ->
    {false, error_vip_value};
%% 修改帮会名称
is_valid_type_value(guild_name, Name) when is_binary(Name) ->
    true;
is_valid_type_value(guild_name, _Name) ->
    {false, error_guild_name_value};
%% 修改帮会等级
is_valid_type_value(lev, Lev) when Lev > 0 andalso Lev =< ?max_guild_lev andalso is_integer(Lev) ->
    true;
is_valid_type_value(lev, _Lev) ->
    {false, error_guild_lev_value};
%% 修改帮主名称
is_valid_type_value(chief_name, Name) when is_binary(Name) ->
    true;
is_valid_type_value(chief_name, _Name) ->
    {false, error_chief_name_value};
%% 修改帮主VIP类型
is_valid_type_value(chief_vip, Vip) ->
    case lists:member(Vip, ?vip_list) of
        true -> true;
        false -> {false, error_chief_vip_value}
    end;
%% 修改帮会成员数据
is_valid_type_value(member, MFA) ->
    case is_valid_mfa(MFA) of
        true -> true;
        false -> {false, error_mfa_value}
    end;
%% 修改帮会公告内容
is_valid_type_value(bulletin, {Msg, QQ, YY}) when is_binary(Msg) andalso is_binary(QQ) andalso is_binary(YY) ->
    true;
is_valid_type_value(bulletin, _Bulletin) ->
    {false, error_bulletin_value};
%% 修改福利等级
is_valid_type_value(weal, Lev) when Lev > 0 andalso Lev =< ?max_weal_lev andalso is_integer(Lev) ->
    true;
is_valid_type_value(weal, _Lev) ->
    {false, error_weal_lev_value};
%% 修改帮会成员数据
is_valid_type_value(store, MFA) ->
    case is_valid_mfa(MFA) of
        true -> true;
        false -> {false, error_mfa_value}
    end;
%% 清空帮会仓库日志
is_valid_type_value(store_log, []) ->
    true;
is_valid_type_value(store_log, _Value) ->
    {false, error_store_log_only_support_empty_log};
%% 修改神炉等级
is_valid_type_value(stove, Lev) when Lev > 0 andalso Lev =< ?max_stove_lev andalso is_integer(Lev) ->
    true;
is_valid_type_value(stove, _Lev) ->
    {false, error_stove_lev_value};
%% 修改帮会资金
is_valid_type_value(fund, Fund) when is_integer(Fund) ->
    true;
is_valid_type_value(fund, _Fund) ->
    {false, error_fund_value};
%% 清空帮会捐献日志
is_valid_type_value(donation_log, []) ->
    true;
is_valid_type_value(donation_log, _Value) ->
    {false, error_donation_log_only_support_empty_log};
%% 修改帮会目标
is_valid_type_value(aims, MFA) ->
    case is_valid_mfa(MFA) of
        true -> true;
        false -> {false, error_mfa_value}
    end;
%% 修改帮会目标
is_valid_type_value(skills, MFA) ->
    case is_valid_mfa(MFA) of
        true -> true;
        false -> {false, error_mfa_value}
    end;
%% 修改帮会弹劾数据
is_valid_type_value(impeach, MFA) ->
    case is_valid_mfa(MFA) of
        true -> true;
        false -> {false, error_mfa_value}
    end;
%% 修改帮会阵营
is_valid_type_value(realm, Realm) ->
    case lists:member(Realm, ?role_realms) of
        true -> true;
        false -> {false, error_realm_value}
    end;
is_valid_type_value(_Type, _Value) ->
    {false, error_unknow_type}.

%% 检测 MFA 的有效性
is_valid_mfa({F}) when is_function(F) -> true;
is_valid_mfa({F, A}) when is_function(F) andalso is_list(A) -> true;
is_valid_mfa({M, F, A}) when is_atom(M) andalso is_atom(F) andalso is_list(A) -> true;
is_valid_mfa(_Mfa) -> false.

%% 检测帮会技能数据是否正常
is_valid_guild_skill(Skills) when is_list(Skills) andalso length(Skills) =:= length(?guild_skills)->
    try [Type || {Type, _Value} <- Skills] -- [Type || {Type, _Value} <- ?guild_skills] of
        [] ->
            Levs = [Lev || {_Type, Lev} <- Skills],
            lists:min(Levs) >= 0 andalso lists:max(Levs) =< ?max_skill_lev;
        _ ->
            false
    catch
        _ -> false
    end;
is_valid_guild_skill(_Skills) ->
    false.

alter_guild_skill(Skills) ->
    [{Type, 20} || {Type, _} <- Skills].

