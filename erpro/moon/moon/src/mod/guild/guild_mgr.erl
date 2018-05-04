%%---------------------------------------------------- 
%% 帮会系统管理器
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_mgr).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([create/4                   %% 创建帮会
        ,list/0                     %% 获取帮会列表
        ,spec_list/0
        ,lookup/2                   %% 帮会ETS表(guild_list)查询
        ,is_guild_exist/1           %% 查看帮会是否存在
        ,special/2
        ,lookup_spec/2
        ,lookup_spec/3
        ,offline_join/4
        ,guild_list/2
    ]
).

-export([mgr_info/1, mgr_cast/1, mgr_call/1]).

-export([terminate_all/0
        ,start_all/0
        ,restart_all/0
        ,terminate_specify/1
        ,start_specify/1
        ,restart_specify/1
        ,sync_to_db/2
        ,sync_to_db/1
        ,sync_all_to_db/0
        ,db_to_dets/0
    ]
).
-export([rank/0, listen/2]).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("vip.hrl").
-include("assets.hrl").
%%
-include("attr.hrl").
-include("version.hrl").

-record(state, {next_id = 1, guilds = []}).

-define(unixdaytime, 86400).   %% 一天秒数 86400
-define(max_apply_time, 3600). %% 申请的有效时间最长为1个钟

%% @spec guild_list(Role) -> ok
%% Role = #role{}
%% @doc 获取帮会列表 同时获取 角色的已经申请过的帮会列表
guild_list(#role{id = {Rid, Rsrvid}, link = #link{conn_pid = ConnPid}}, PageNum) ->
    mgr_cast({guild_list, Rid, Rsrvid, ConnPid, PageNum}).

%%-------------------------------------------------------------
%%  ETS: guild_list
%%-------------------------------------------------------------
%% @spec list() -> List 
%% List = [#guild{} | ...]
%% @doc 请求帮会列表
list() ->
    ets:tab2list(guild_list).

%% @spec lookup(Type, Ref) -> false | #guild{}
%% {Type, Ref} = {by_id, {integer(), binary()}} | {by_name, binary()} | {by_pid, pid()}
%% Record = #guild{}
%% @doc 查看帮会信息
lookup(by_id, {Gid, Gsrvid}) when is_integer(Gid) andalso is_binary(Gsrvid) ->
    case ets:lookup(guild_list, {Gid, Gsrvid}) of
        [] ->
            false;
        [H] when is_record(H, guild) ->
            H;
        _Err ->
            ?ERR("ETS帮会数据异常，[Data:~w]", [_Err]),
            false
    end;
lookup(by_name, Gname) when is_binary(Gname) ->
    case ets:match_object(guild_list, #guild{name = Gname, _ ='_'}) of
        [] ->
            false;
        [H] when is_record(H, guild) ->
            H;
        _Err ->
            ?ERR("ETS帮会数据异常，[Data:~w]", [_Err]),
            false
    end;

lookup(by_pid, Gpid) when is_pid(Gpid) ->
    case ets:match_object(guild_list, #guild{pid = Gpid, _ = '_'}) of
        [] ->
            false;
        [H] when is_record(H, guild) ->
            H;
        _Err ->
            ?ERR("ETS帮会数据异常，[Data:~w]", [_Err]),
            false
    end;
lookup(by_role_id, {Rid, Rsrvid}) when is_integer(Rid) andalso is_binary(Rsrvid) ->
    case global:whereis_name({role, Rid, Rsrvid}) of
        undefined -> 
            false;
        Pid ->
            case catch role:apply(sync, Pid, {guild_api, get_role_guild, []}) of
                #role_guild{gid = Gid, srv_id = Gsrvid} ->
                    lookup(by_id, {Gid, Gsrvid});
                Error ->
                    ?ERR("获取角色{~w,~s}的帮会属性时发生异常【~w】", [Rid, Rsrvid, Error]),
                    false
            end
    end;

lookup(by_name_dets, _Name) ->
    ?DEBUG("~n~w~n", [<<"神后女娲">>]),
    case dets:match_object(guild_list, #guild{name = ?L(<<"神后女娲">>), _ ='_'}) of
        [] ->
            false;
        [H] when is_record(H, guild) ->
            H;
        _Err ->
            ?ERR("ETS帮会数据异常，[Data:~w]", [_Err]),
            false
    end;

lookup(_Cmd, _Data) ->
    ?ERR("查询帮会信息时传入错误的参数[Cmd:~w][Ref:~w]",[_Cmd, _Data]),
    false.

%%---------------------------------------------------------------
%% @spec special(_Type, Data) -> ok
%% @doc 操作角色的特殊性帮会属性
%%---------------------------------------------------------------
%% 增加一条申请记录
special(add_applyed, {Gid, Gsrvid, Rid, Rsrvid}) ->
    mgr_cast({add_applyed, Gid, Gsrvid, Rid, Rsrvid});

%% 删除一条申请记录
special(del_applyed, {Gid, Gsrvid, Rid, Rsrvid}) ->     
    mgr_cast({del_applyed, Gid, Gsrvid, Rid, Rsrvid});

%% 增加一条邀请记录
special(add_invited, {Gid, Gsrvid, Gname, Inviter, Rid, Rsrvid}) ->
    mgr_cast({add_invited, Gid, Gsrvid, Gname, Inviter, Rid, Rsrvid});

%% 删除一条邀请记录
special(del_invited, {Gid, Gsrvid, Rid, Rsrvid}) ->
    mgr_cast({del_invited, Gid, Gsrvid, Rid, Rsrvid});

%% 在线加入帮会，批准入帮，创建帮会
special(online_join, {Gid, Gsrvid, Rid, Rsrvid}) ->
    mgr_cast({online_join, Gid, Gsrvid, Rid, Rsrvid});

%% 在线被开除帮会
special(online_fire, {Rid, Rsrvid}) ->
    mgr_cast({online_fire, Rid, Rsrvid});

%% 离线被开除帮会
special(offline_fire, {Rid, Rsrvid}) ->
    mgr_cast({offline_fire, Rid, Rsrvid});

%% 重置清除角色所有特殊帮会属性
special(reset,{Rid, Rsrvid}) ->
    mgr_cast({reset, Rid, Rsrvid});

%% 更新角色下次上线需要清理的数据 帮会技能领用状态，经验俸禄领用状态，藏经阁阅读状态`
special(update_clear, {Vals, Rid, Rsrvid}) ->
    mgr_cast({update_clear, Vals, Rid, Rsrvid});

%% 角色上线清理了数据，重置为默认值
special(clear_update, {Rid, Rsrvid}) ->
    mgr_cast({clear_update, Rid, Rsrvid});

%% 更新一条角色的特殊属性
special(update, Spec) ->
    mgr_cast({update, Spec});

%% 容错
special(_Cmd, _Data) ->
    ?ERR("【~w】的函数 special 调用错误，【Cmd: ~w】【Data: ~w】", [?MODULE, _Cmd, _Data]),
    ok.

%% @spec spec_list() -> [Spec |...]
%% Spec = #special_role_guild{}
%% @doc 查询角色的特殊帮会属性列表
spec_list() ->
    ets:tab2list(special_role_guild).

%% @spec lookup(Rid, Rsrvid) -> false | Spec
%% Rid = integer()
%% Rsrvid = binary()
%% Spec = #special_role_guild{}
%% @doc 查询角色的特殊帮会属性
lookup_spec(Rid, Rsrvid) when is_integer(Rid) andalso is_binary(Rsrvid) ->
    case ets:lookup(special_role_guild, {Rid, Rsrvid}) of
        [] ->
            false;
        [H] when is_record(H, special_role_guild) ->
            H;
        _Err ->
            ?ERR("ETS角色帮会扩展属性数据异常，[Data:~w]", [_Err]),
            false
    end;
lookup_spec(Rid, Rsrvid) ->
    ?ERR("查询角色特殊帮会属性时传入错误的参数类型【Rid is_integer(): ~w】【Srvid is binary(): ~w】", [is_integer(Rid), is_binary(Rsrvid)]),
    false.

%% @spec lookup(Type, Rid, Rsrvid) -> Result
%% Type = applyed | invited 
%% Rid = integer()
%% Rsrvid = binary()
%% Result = term()
%% @doc 查询指定的角色的特殊帮会属性
lookup_spec(applyed, Rid, Rsrvid) ->
    case lookup_spec(Rid, Rsrvid) of
        false ->
            [];
        Spec ->
            handle_role_applyed(Spec)
    end;

lookup_spec(invited, Rid, Rsrvid) ->
    case lookup_spec(Rid, Rsrvid) of
        false ->
            [];
        Spec ->
            handle_role_invited(Spec)
    end.

%% @spec offline_join(Gid, Gsrvid, Rid, Rsrvid) -> true | false
%% Gid = Rid = integer()
%% Gsrviddd = Rsrvid = binary()
%% @doc 同步请求，角色离线加入帮会
offline_join(Gid, Gsrvid, Rid, Rsrvid) ->
    mgr_call({offline_join, Gid, Gsrvid, Rid, Rsrvid}).

%% @spec is_guild_exist(Name) -> true | false
%% Name = binary()
%% @doc 查看帮会是否存在
is_guild_exist(Name) ->
    case lookup(by_name, Name) of
        #guild{} -> 
            true;
        false -> 
            false
    end.

%% @spec rank() -> ok
%% @doc 帮会重新上榜 排行榜进程必须在帮会进程前面启动
rank() -> rank(list()).
rank([]) -> ok;
rank([Guild | Guilds]) -> 
    rank:listener(guild_lev, Guild),
    rank(Guilds).

%% @spec create(Type, Gname, Bulletin, Role) -> {false, Reason} | {true, NewRole}
%% Type = ?create_by_token | ?create_by_coin
%% Gname = binary()
%% Bulletin = binary()
%% Role = #role{}
%% Reason = binary()
%% NewRole = #role{}
%% 建立帮会 使用建帮令
create(?create_by_token, Gname, Bulletin, Role = #role{id = {Rid, Rsrvid}, name = Rname, guild = #role_guild{read = Read, skilled = Skilled, welcome_times = Times}}) ->
    case role_gain:do([#loss{label = gold, val = 88}], Role) of  
        {ok, Role1} ->
            case mgr_call({create, Gname, ?guild_vip, Bulletin, guild_role:convert(Role)}) of
                {true, RoleGuild = #role_guild{gid = Gid, srv_id = Gsrvid, name = Gname}} ->
                    NewRole = guild_role:listener(join, Role1#role{guild = RoleGuild#role_guild{read = Read, skilled = Skilled, welcome_times = Times}}),
                    spawn(guild_log, join_leave, [Rid, Rsrvid, Rname, <<"创建">>, Gid, Gsrvid, Gname, Rid, Rsrvid, Rname]),
                    %%notice:send(52, util:fbin(?L(<<"{role,~w,~s,~s,#87CEFF}创建了帮会{str,~s,#7CFC00}，广募天下仙友加盟 {open, 21, 我要入帮, #7CFC00}">>), [Rid, Rsrvid, Rname, Gname])),
                    random_award:legion(NewRole),
                    {true, NewRole};       
                {false, Reason} ->
                    {false, Reason};
                Error ->
                    ?ERR("角色{~s}创建尝试帮会{~s}时发生错误{~w}", [Rname, Gname, Error]),
                    mgr_cast({failed_create, Gname}),                 %% 清除创建过程中发生异常的帮会
                    {false, ?MSGID(<<"等级不足，请等到20级之后再来建立帮会吧">>)}
            end;
        _ ->
            {false, ?MSGID(<<"晶钻不足">>)}
    end;
%% 建立帮会 使用铜币
create(?create_by_coin, Gname, Bulletin, Role = #role{id = {Rid, Rsrvid}, name = Rname, guild = #role_guild{read = Read, skilled = Skilled, welcome_times = Times}}) ->
    case role_gain:do([#loss{label = coin_all, val = ?create_need_coin}], Role) of 
        {ok, Role1} ->
            case mgr_call({create, Gname, ?guild_piv, Bulletin, guild_role:convert(Role)}) of
                {true, RoleGuild = #role_guild{gid = Gid, srv_id = Gsrvid, name = Gname}} ->
                    NewRole = guild_role:listener(join, Role1#role{guild = RoleGuild#role_guild{read = Read, skilled = Skilled, welcome_times = Times}}),
                    spawn(guild_log, join_leave, [Rid, Rsrvid, Rname, <<"创建">>, Gid, Gsrvid, Gname, Rid, Rsrvid, Rname]),
                    %% notice:send(52, util:fbin(?L(<<"{role,~w,~s,~s,#87CEFF}创建了帮会{str,~s,#7CFC00}，广募天下仙友加盟 {open, 21, 我要入帮, #7CFC00}">>), [Rid, Rsrvid, Rname, Gname])),
                    random_award:legion(NewRole),
                    {true, NewRole};       
                {false, Reason} ->
                    {false, Reason};
                Error ->
                    ?ERR("角色{~s}创建尝试帮会{~s}时发生错误{~w}", [Rname, Gname, Error]),
                    mgr_cast({failed_create, Gname}),                 %% 清除创建过程中发生异常的帮会
                    {false, ?MSGID(<<"创建帮会失败">>)} 
            end;
        _ ->
            {?coin_less, ?MSGID(<<"金币不足">>)}
    end;

create(_Cmd, _Name, _Bul, _Role) ->
    ?ERR("创建帮会时，参数格式错误"),
    {false, <<>>}.

%% @spec listen(guild_rank, Guild) -> ok
%% Guild = #guild{}
%% @doc 帮会数据快照，供帮会列表使用
listen(guild_rank, #guild{status = ?guild_dismiss}) ->
    ok;
listen(guild_rank, #guild{id = {Gid, Srv_id}, name = Gname, gvip = Gvip, chief = Chief, rvip = Rvip, lev = Lev, num = Num, maxnum = MaxNum, realm = Realm}) ->
    mgr_cast({guild_rank, #guild_pic{id = {Gid, Srv_id}, gid = Gid ,srv_id = Srv_id ,name = Gname ,gvip = Gvip ,chief = Chief ,rvip = Rvip ,lev = Lev ,num = Num ,maxnum = MaxNum, realm = Realm}}).

%%-----------------------------------------------------------
%% 帮会数据数据库同步操作
%%-----------------------------------------------------------
%% 同步帮会数据到数据库
sync_all_to_db() ->
    ?INFO("开始回写帮会数据到数据库..."),
    sync_all_to_db(guild, guild_mgr:list()),
    sync_all_to_db(special, guild_mgr:spec_list()),
    ?INFO("帮会数据已经全部回写到数据库").
sync_all_to_db(guild, []) ->
    ok;
sync_all_to_db(guild, [Guild | L]) ->
    sync_to_db(Guild),
    sync_all_to_db(guild, L);
sync_all_to_db(special, []) ->
    ok;
sync_all_to_db(special, [Special | L]) ->
    sync_to_db(Special),
    sync_all_to_db(special, L).

%% 同步单个帮会数据到数据库
sync_to_db(Guild = #guild{}) ->
    guild_db:save(Guild);

%% 同步单个角色帮会特殊属性到数据库
sync_to_db(Special = #special_role_guild{}) ->
    guild_db:save_special_role_guild(Special); 

sync_to_db(_Data) ->
    ?ERR("同步帮会相关数据到数据库时，发现非法数据【~w】", [_Data]),
    ok.

%% @spec sync_to_db(Atom, IDs) -> binary()
%% IDs = [{integer(), binary()} | ...]
%% Atom = by_guild_id | by_role_id
%% @doc 同步指定帮会(by_guild_id)/角色(by_role_id) 帮会相关数据到数据库
sync_to_db(by_guild_id, GuildIds) ->
    ?INFO("开始同步指定帮会数据到数据库中"),
    sync_to_db(by_guild_id, GuildIds, <<>>);
sync_to_db(by_role_id, RoleIds) ->
    ?INFO("开始同步指定角色特殊帮会属性数据到数据库中"),
    sync_to_db(by_role_id, RoleIds, <<>>).

sync_to_db(by_guild_id, [], <<>>) ->
    ?INFO("所有指定帮会的帮会数据都已成功同步到数据库中"),
    ?L(<<"所有指定帮会的帮会数据都已成功同步到数据库中">>);
sync_to_db(by_guild_id, [], Failed) ->
    ?ERR("~s", [Failed]),
    Failed;
sync_to_db(by_guild_id, [{Gid, Gsrvid} | T], Failed) ->
    case lookup(by_id, {Gid, Gsrvid}) of
        false ->
            ?ERR("帮会 [~w, ~s] 数据回写失败，该帮会可能已经解散，找不到数据", [Gid, Gsrvid]),
            sync_to_db(by_guild_id, T, util:fbin(?L(<<"帮会 [~w, ~s] 数据回写失败，该帮会可能已经解散，找不到数据~n~s">>), [Gid, Gsrvid, Failed]));
        Guild = #guild{name = Gname} ->
            case guild_db:save(Guild) of
                true ->
                    sync_to_db(by_guild_id, T, Failed);
                false ->
                    ?ERR("帮会 [~s, ~w, ~s] 数据回写失败", [Gname, Gid, Gsrvid]),
                    sync_to_db(by_guild_id, T, util:fbin(?L(<<"帮会 [~s, ~w, ~s] 基础数据回写失败~n~s">>), [Gname, Gid, Gsrvid, Failed]))
            end
    end;

sync_to_db(by_role_id, [], <<>>) ->
    ?INFO("所有指定角色的特殊帮会数据都已成功同步到数据库中"),
    ?L(<<"所有指定角色的特殊帮会数据都已成功同步到数据库中">>);
sync_to_db(by_role_id, [], Failed) ->
    ?ERR("~s", [Failed]),
    Failed;
sync_to_db(by_role_id, [{Rid,Rsrvid} | T], Failed) ->
    case lookup_spec(Rid, Rsrvid) of
        false ->
            ?ERR("角色{~w, ~s}特殊帮会属性数据回写失败，找不到数据", [Rid, Rsrvid]),
            sync_to_db(by_role_id, T, util:fbin(?L(<<"角色{~w, ~s}特殊帮会属性数据回写失败，找不到数据~n~s">>), [Rid, Rsrvid, Failed]));
        RoleGuildSpec ->
            case guild_db:save_special_role_guild(RoleGuildSpec) of
                true ->
                    sync_to_db(by_role_id, T, Failed);
                false ->
                    ?ERR("角色{~w, ~s}特殊帮会属性数据回写失败", [Rid, Rsrvid]),
                    sync_to_db(by_role_id, T, util:fbin(?L(<<"角色{~w, ~s}的特殊帮会属性数据回写失败~n~s">>), [Rid, Rsrvid, Failed]))
            end
    end.

%% @spec db_to_dets() -> false | ok
%% @doc 从数据库中重载帮会数据转换成DETS文件, 帮会管理进程不存在返回 undefined 
db_to_dets() ->
   mgr_info(load).

%% @spec terminate_all() -> ok
%% @doc 关闭所有帮会进程
terminate_all() ->
   mgr_cast(terminate_all).

%% @spec start_all() -> ok
%% @doc 启动所有的帮会进程
start_all() ->
   mgr_cast(start_all).

%% @spec restart_all() ->
%% @doc 重启所有帮会进程
restart_all() ->
    mgr_cast(restart_all).

%% @spec terminate_guild(GuildIds) -> ok
%% @doc 关闭指定帮会进程
terminate_specify(GuildIds) ->
   mgr_cast({terminate_specify, GuildIds}).

%% @spec start_specify_guild(GuildIds) -> ok
%% @doc 启动指定帮会进程
start_specify(GuildIds) ->
   mgr_cast({start_specify, GuildIds}).

%% @spec restart_specify_guild(GuildIds) -> ok
%% @doc 重启指定帮会进程
restart_specify(GuildIds) ->
   mgr_cast({restart_specify, GuildIds}).

%% @spec mgr_info(Msg) -> false | ok
%% Msg = term()
%% @doc 向帮会管理进程发送一个 handle_info 消息, 当管理进程不存在时返回 false
mgr_info(Msg) ->
    case global:whereis_name(guild_mgr) of
        undefined ->
            false;
        Pid -> 
            Pid ! Msg,
            ok
    end.

%% @spec mgr_cast(Msg) -> ok
%% Msg = term()
%% @doc 向帮会管理进程发送一个 handle_cast 消息
mgr_cast(Msg) ->
    gen_server:cast({global, ?MODULE}, Msg).

%% @spec mgr_call(Msg) -> false | term()
%% Msg = term()
%% @doc 向帮会管理进程发送一个 handle_call 消息
mgr_call(Msg) ->
    try gen_server:call({global, ?MODULE}, Msg) of
        Reply -> Reply 
    catch
        exit:{timeout, _} -> 
            ?ERR("向帮会管理器发起的请求{~w}发生timeout", [Msg]),
            false;
        exit:{noproc, _} -> 
            ?ERR("向帮会管理器发起的请求{~w}发生noproc", [Msg]),
            false;
        Error:Info ->
            ?ERR("向帮会管理器发起的请求{~w}发生异常{~w:~w}", [Msg, Error, Info]),
            false
    end.

%%-----------------------------------------------------------
%% 系统函数
%%-----------------------------------------------------------
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ets:new(guild_list, [set, named_table, public, {keypos, #guild.id}, {read_concurrency, true}]),
    ets:new(special_role_guild, [set, named_table, protected, {keypos, #special_role_guild.id}, {read_concurrency, true}]),
    dets:open_file(guild_list, [{file, "../var/guild.dets"}, {keypos, #guild.id}, {type, set}]),
    dets:open_file(special_role_guild, [{file, "../var/special_role_guild.dets"}, {keypos, #special_role_guild.id}, {type, set}]),
    load_guild(),
    NextID = case get(next_guild_id) of
        undefined -> 1;
        MaxID -> MaxID + 1
    end,
%%    self() ! sync_to_db,              %% 帮会启动不再主动回写数据库
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{next_id = NextID}}.

%%----------------------------------------------------------
%% handle_call
%%----------------------------------------------------------
%% 创建帮会
handle_call({create, Gname, Gvip, Bulletin, #guild_role{pid = Rpid, rid = Rid, srv_id = Rsrvid, name = Rname, lev = Rlev, sex = Rsex, career = Rcareer, vip = Rvip, gravatar = Rgravatar, fight = FC, realm = Realm, pet_fight = PF}},
    _From, State = #state{next_id = Gid}
) ->
    GuildLev = case Gvip of %% 刚创建的VIP帮会，等级为2，普通为1
        ?guild_piv -> 1;
        ?guild_vip -> 2
    end,
    
    {ok, #guild_lev{day_fund =  DF, maxnum = MaxNum}} = guild_data:get(guild_lev, GuildLev),
    Gsrvid = Rsrvid,
    Guild = 
    #guild{id = {Gid, Gsrvid}, gid = Gid, srv_id = Gsrvid, name = Gname, lev = GuildLev, chief = Rname, num = 1, realm = Realm,
        bulletin = {Bulletin, <<>>, <<>>}, store = #guild_store{}, day_fund = DF, maxnum = MaxNum, ver = ?guild_ver, rvip = Rvip, gvip = Gvip,
        members = [#guild_member{pid = Rpid, id = {Rid, Rsrvid}, rid = Rid, srv_id = Rsrvid, name = Rname, lev = Rlev, sex = Rsex, pet_fight = PF,
                career = Rcareer, vip = Rvip, gravatar = Rgravatar, fight = FC, position = ?guild_chief, authority = ?chief_op, date = util:unixtime()}],
        skills = ?guild_skills
        ,rtime = [{1, util:unixtime()}]
        ,target_info = #target_info{target_lst = guild_aim:get_target(GuildLev), is_finish = 0}
        ,shop = 0
        ,wish_pool_lvl = 0
    },

    case guild:start_link(create, Guild) of    %% 创建帮会进程
        {ok, Gpid} ->
            %% role:apply(async, Rpid, {guild_role, init_target_trigger, [Targets]}), %% 团长的触发器
            spawn(?MODULE, sync_to_db, [Guild]),
            spawn(guild_log, log, [Gid, Gsrvid, Gname, Rid, Rsrvid, Rname, <<"帮会创建">>, <<>>]),
            rank:listener(guild_lev, Guild),    %% 帮会等级排行榜监听
            {reply, {true, #role_guild{pid = Gpid, gid = Gid, srv_id = Gsrvid, name = Gname, position = ?guild_chief, 
                        salary = guild_mem:salary(Rlev, 1, ?guild_chief), authority = ?chief_op, join_date = util:unixtime(),
                        shop = #shop{lvl = 0, times = 0},
                        wish = #wish{lvl = 0, times = 0}}}, 
                State#state{next_id = Gid + 1}};
        Reason ->
            ?ERR("无法启动角色[~s]新创建帮会[~s, ~w]进程[~w]", [Rname, Gname, Gid, Reason]),
            {reply, {false, ?L(<<"创建帮会失败">>)}, State}
    end;

%% 离线加入帮会
handle_call({offline_join, Gid, Gsrvid, Rid, Rsrvid}, _From, State) ->
    case lookup_spec(Rid, Rsrvid) of
        false ->
            ?ERR("角色[~w, ~s] 离线被批准加入帮会 [~w, ~s], 但找不到角色的 special_role_guild 数据", [Gid, Gsrvid, Rid, Rsrvid]),
            Data = #special_role_guild{id = {Rid, Rsrvid}, guild = {Gid, Gsrvid, util:unixtime()}, status = ?true},
            update_special_role_guild(Data),
            {reply, true, State};
        Spec = #special_role_guild{status = ?false, applyed = Applyed} ->  %% 离线被批准加入，接着又被开除，接着又被其他帮会批准加入
            %% 这里用回 Spec 是因为如果该角色之前有被开除，那么需要继续保持他被开除的信息
            Data = Spec#special_role_guild{guild = {Gid, Gsrvid, util:unixtime()}, status = ?true, applyed = [], invited = []},
            clear_guild_apply({Rid, Rsrvid}, {Gid, Gsrvid}, Applyed), 
            update_special_role_guild(Data),
            {reply, true, State};
        _ ->
            {reply, false, State}
    end;

%% 下一个帮会ID
handle_call(next_id, _From, State) ->
    {reply, State#state.next_id, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%%----------------------------------------------------------
%% handle_cast
%%----------------------------------------------------------
%% 角色入帮申请被拒绝，更新已申请列表
handle_cast({apply_refused, Rid, Rsrvid, Gid, Gsrvid, Gname}, State) ->
    case lookup_spec(Rid, Rsrvid) of
        Spec = #special_role_guild{applyed = A} ->
            Data = Spec#special_role_guild{applyed = lists:keydelete({Gid, Gsrvid},1, A)},
            update_special_role_guild(Data),
            %% mail:send_system({Rid, Rsrvid}, {?L(<<"帮会拒绝通知">>), util:fbin(?L(<<"帮会【~s】拒绝了您的入帮申请。">>), [Gname])}),
            {noreply, State};
        false ->
            ?ERR("角色{~w, ~s}加入帮会{~s,~w,~s}申请被拒，但找不到角色的特殊帮会属性数据", [Rid, Rsrvid, Gname, Gid, Gsrvid]),
            {noreply, State}
    end;

handle_cast({update, Spec}, State) ->
    case is_record(Spec, special_role_guild) of
        true ->
            update_special_role_guild(Spec),
            {noreply, State};
        false ->
            ?ERR("更新角色的特殊帮会属性，传入错如的数据【~w】, 不是一个 special_role_guild record", [Spec]),
            {noreply, State}
    end;

%% 增加一条申请记录
handle_cast({add_applyed, Gid, Gsrvid, Rid, Rsrvid}, State) ->
    case lookup_spec(Rid, Rsrvid) of
        false ->
            Data = #special_role_guild{id = {Rid, Rsrvid}, applyed = [{{Gid, Gsrvid}, util:unixtime()}]},
            update_special_role_guild(Data),
            {noreply, State};
        Spec = #special_role_guild{applyed = Applyed} ->
            Data = Spec#special_role_guild{applyed = lists:ukeysort(1, [{{Gid, Gsrvid}, util:unixtime()} | Applyed])},
            update_special_role_guild(Data),
            {noreply, State}
    end;

%% 删除一条申请记录
handle_cast({del_applyed, Gid, Gsrvid, Rid, Rsrvid}, State) ->
    case lookup_spec(Rid, Rsrvid) of
        false ->
            ?ERR("尝试删除角色{~w, ~s}的帮会{~w, ~s}的申请记录时找不到角色的特殊帮会属性数据", [Rid, Rsrvid, Gid, Gsrvid]),
            {noreply, State};
        Spec = #special_role_guild{applyed = Applyed} ->
            Data = Spec#special_role_guild{applyed = lists:keydelete({Gid, Gsrvid}, 1, Applyed)},
            update_special_role_guild(Data),
            {noreply, State}
    end;

%% 增加一条邀请记录
handle_cast({add_invited, Gid, Gsrvid, Gname, Inviter, Rid, Rsrvid}, State) ->
    case lookup_spec(Rid, Rsrvid) of
        false ->
            Data = #special_role_guild{id = {Rid, Rsrvid}, invited = [{{Gid, Gsrvid}, Gname, Inviter, util:unixtime()}]},
            update_special_role_guild(Data),
            {noreply, State};
        Spec = #special_role_guild{invited = Invited} ->
            Data = Spec#special_role_guild{invited = [{{Gid, Gsrvid}, Gname, Inviter, util:unixtime()} | Invited]},
            update_special_role_guild(Data),
            {noreply, State}
    end;

%% 删除一条邀请记录
handle_cast({del_invited, Gid, Gsrvid, Rid, Rsrvid}, State) ->
    case lookup_spec(Rid, Rsrvid) of
        false ->
            ?ERR("尝试删除角色{~w, ~s}的帮会{~w, ~s}的邀请记录时找不到角色的特殊帮会属性数据", [Rid, Rsrvid, Gid, Gsrvid]),
            {noreply, State};
        Spec = #special_role_guild{invited = Invited} ->
            Data = Spec#special_role_guild{invited = lists:keydelete({Gid, Gsrvid}, 1, Invited)},
            update_special_role_guild(Data),
            {noreply, State}
    end;

%% 加入帮会
handle_cast({online_join, Gid, Gsrvid, Rid, Rsrvid}, State) ->
    case lookup_spec(Rid, Rsrvid) of
        #special_role_guild{status = ?true} ->  %% 角色离线被批准加入, 角色上线更新
            {noreply, State};
        #special_role_guild{applyed = Applyed} ->
            clear_guild_apply({Rid, Rsrvid}, {Gid, Gsrvid}, Applyed), 
            Data = #special_role_guild{id = {Rid, Rsrvid}, guild = {Gid, Gsrvid, util:unixtime()}, status = ?true},
            update_special_role_guild(Data),
            {noreply, State};
        false ->    %% 创建帮会
            Data = #special_role_guild{id = {Rid, Rsrvid}, guild = {Gid, Gsrvid, util:unixtime()}, status = ?true},
            update_special_role_guild(Data),
            {noreply, State}
    end;

%% 被开除帮会
handle_cast({online_fire, Rid, Rsrvid}, State) ->
    update_special_role_guild(#special_role_guild{id = {Rid, Rsrvid}}),
    {noreply, State};

%% 被开除帮会
handle_cast({offline_fire, Rid, Rsrvid}, State) ->
    Data = #special_role_guild{id = {Rid, Rsrvid}, fire = ?true, status = ?false},
    update_special_role_guild(Data),
    {noreply, State};

%% 重置一条记录     退出帮会
handle_cast({reset, Rid, Rsrvid}, State) ->
    update_special_role_guild(#special_role_guild{id = {Rid, Rsrvid}}),
    {noreply, State};

%% 增加一条更新数据类型, 如 技能类，领用状态类
handle_cast({update_clear, Vals, Rid, Rsrvid}, State) ->
    case lookup_spec(Rid, Rsrvid) of
        false ->
            ?ERR("收到请求对角色{~w,~s}的 special_role_guild 的进行 update_clear 信息，但找不到角色的 special_role_guild 数据", [Rid, Rsrvid]),
            {noreply, State};
        Spec = #special_role_guild{updates = Updates} ->
            Data = Spec#special_role_guild{updates = lists:usort(Vals ++ Updates)},
            update_special_role_guild(Data),
            {noreply, State}
    end;

%% 角色上线清理过诸如 技能，领用状态等数据，重置 updates
handle_cast({clear_update, Rid, Rsrvid}, State) ->
    case lookup_spec(Rid, Rsrvid) of
        false ->
            ?ERR("收到请求对角色{~w,~s}的 special_role_guild 的 clear_update 信息，但找不到角色的 special_role_guild 数据", [Rid, Rsrvid]),
            {noreply, State};
        Spec ->
            Data = Spec#special_role_guild{updates = []},
            update_special_role_guild(Data),
            {noreply, State}
    end;

%% 更新帮会列表数据
handle_cast({guild_rank, Guild}, State = #state{guilds = Guilds}) ->
    NewGuild = lists:reverse(lists:keysort(#guild_pic.lev, lists:keysort(#guild_pic.num, lists:ukeysort(#guild_pic.id, [Guild|Guilds])))),
    {noreply, State#state{guilds = NewGuild}};

%% 获取帮会列表
handle_cast({guild_list, Rid, Rsrvid, ConnPid, PageNum}, State = #state{guilds = Guilds}) ->
    Fun = fun(#guild_pic{lev = Lev1, num = N1}, #guild_pic{lev = Lev2, num = N2}) ->
            case Lev1 > Lev2 of
                true ->
                    true;
                false ->
                    case Lev1 =:= Lev2 of
                        true -> N1 >= N2;
                        false -> false
                    end
            end end,
    Guilds1 = lists:sort(Fun, Guilds),
    ?DEBUG("所有军团>>  ~w", [Guilds1]),
    GuildNum = length(Guilds1),
    AllPages = GuildNum div 7 + case GuildNum rem 7 =:= 0 of true -> 0; false -> 1 end,
    case AllPages =< 0 of
        true -> 
            sys_conn:pack_send(ConnPid, 12701, {AllPages, AllPages, [], []});
        false ->
                if
                    PageNum > AllPages ->
                        skip;
                    PageNum =:= AllPages ->
                        %% 取最后一页
                        sys_conn:pack_send(ConnPid, 12701, {AllPages, AllPages, lists:foldl(fun(N,Sum)-> Sum ++ [lists:nth(N,Guilds1)] end,[], lists:seq((AllPages-1)*7+1, GuildNum)),lookup_spec(applyed, Rid, Rsrvid)});
                    true ->
                        sys_conn:pack_send(ConnPid, 12701, {AllPages, PageNum, lists:foldl(fun(N,Sum)-> Sum ++ [lists:nth(N,Guilds1)] end,[], lists:seq((PageNum-1)*7+1, PageNum*7)),lookup_spec(applyed, Rid, Rsrvid)})
            end
    end,
    {noreply, State};

%% 销毁帮会
handle_cast({dismiss, Gid, Gsrvid, Name}, State = #state{guilds = Guilds} ) ->
    ?INFO("帮会【~s, ~w, ~s】已经销毁", [Name, Gid, Gsrvid]),
    {noreply, State#state{guilds = lists:keydelete({Gid, Gsrvid}, #guild_pic.id, Guilds)}};

%% 关闭所有帮会进程
handle_cast(terminate_all, State) ->
    ?INFO("开始逐个关闭所有帮会进程..."),
    lists:foreach(fun(#guild{id = {Gid, Gsrvid}}) -> guild:guild_cast({Gid, Gsrvid}, you_guy_need_to_shutdown) end, ets:tab2list(guild_list)),
    ?INFO("已向所有帮会进程发送关闭指令"),
    {noreply, State};

%% 重启所有帮会进程
handle_cast(restart_all, State) ->
    ?INFO("开始逐个重启所有帮会进程..."),
    lists:foreach(fun(#guild{pid = Pid}) -> guild:restart(Pid, mgr, <<"上级命令">>) end, ets:tab2list(guild_list)),
    ?INFO("已向所有帮会进程发送重启指令"),
    {noreply, State};

%% 启动所有帮会进程
handle_cast(start_all, State) ->
    start_guilds(),
    {noreply, State};

%% 关闭指定帮会进程
handle_cast({terminate_specify, GuildIds}, State) ->
    ?INFO("开始逐个关闭指定帮会进程..."),
    lists:foreach(fun({Gid, Gsrvid}) -> guild:guild_cast({Gid, Gsrvid}, you_guy_need_to_shutdown) end, GuildIds),
    ?INFO("已向所有指定帮会进程发生关闭指令"),
    {noreply, State};

%% 重启指定帮会进程
handle_cast({restart_specify, GuildIds}, State) ->
    ?INFO("开始逐个重启指定帮会进程..."),
    lists:foreach(fun({Gid, Gsrvid}) -> guild:restart({Gid, Gsrvid}, mgr, <<"上级命令">>) end, GuildIds),
    ?INFO("已向所有指定帮会进程发送重启指令"),
    {noreply, State};

%% 启动指定帮会进程
handle_cast({start_specify, GuildIds}, State) ->
    start_specify(by_mgr, GuildIds),
    {noreply, State};

%% 销毁创建过程中发生异常的帮会
handle_cast({failed_create, Gname}, State) ->                %% 清除创建过程中发生异常的帮会
    case lookup(by_name, Gname) of
        false ->
            {noreply, State};
        #guild{pid = Pid} ->
            ?INFO("帮会{~s}创建过程中发生异常，正在销毁...", [Gname]),
            guild:dismiss_by_mgr(Pid),
            {noreply, State}
    end;

%% 容错
handle_cast(_Data, State) ->
    {noreply, State}.

%%-----------------------------------------------------------
%% handle_info
%%-----------------------------------------------------------
handle_info({'EXIT', _, normal}, State) ->
    {noreply, State};

%% 重启退出的帮会进程
handle_info({'EXIT', Pid, REASON}, State) ->
    case lookup(by_pid, Pid) of
        H = #guild{name = Name} -> 
            ?ERR("收到帮会【~s】 EXIT 消息，【Reason：~w】", [Name, REASON]),
            NewReason = case REASON of
                {shutdown, Msg} -> Msg;
                _ -> REASON
            end,
            case guild:start_link({restart, NewReason}, H) of
                {ok, _Gpid} ->
                    ok;
                _ ->
                    ?ERR("帮会进程重启失败，[Data:~w]",[H])
            end;
        false -> 
            ?ERR("重启帮会进程时找不到数据")
    end,
    {noreply, State};

%% 启动同步所有数据到数据库
handle_info(sync_to_db, State) ->
    spawn(?MODULE, sync_all_to_db, []),
    {noreply, State};

%% 从数据库载入备份数据
handle_info(load, State) ->
    ?INFO("开始从数据库载入帮会数据，转换DETS副本..."),
    load_special_role_guild(),
    load(),
    ?INFO("帮会数据转换DETS副本完成"),
    {noreply, State};

%% 容错
handle_info(_Data , State) ->
    {noreply, State}.

%%-----------------------------------------------------------
%% 系统关闭
%%-----------------------------------------------------------
terminate(_Reason, _State) ->
    dets:close(special_role_guild),
    dets:close(guild_list),
    {noreply, _State}.

%%-----------------------------------------------------------
%% 热代码切换
%%-----------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%-----------------------------------------------------------
%% 私有函数
%%-----------------------------------------------------------
%% 保存角色特殊的帮会属性到ETS/DETS中
update_special_role_guild(Data = #special_role_guild{}) -> 
    ets:insert(special_role_guild, Data),
    dets:insert(special_role_guild, Data);
update_special_role_guild(_Data) -> 
    ?ERR("需要保存的角色特殊帮会属性不是一个[special_role_guild] record"),
    ok.

%% 重载角色帮会扩展属性数据
load_special_role_guild() ->
    case guild_db:load_special_role_guild() of
        error ->
            ?ERR("重载角色帮会扩展数据发生错误"),
            load_special_role_guild_error;
        Data ->
            dets:insert(special_role_guild, Data)
    end.

%% 导入所有帮会到DETS
load() ->
    case guild_db:load() of
        error -> 
            guild_data_load_error;
        GuildList ->
            dets:insert(guild_list, GuildList)
    end.

%% 删除列表中申请超过3个小时的帮会
handle_role_applyed(H = #special_role_guild{applyed = L}) ->
    case handle_role_applyed(L, [], [], false) of
        {L1, L2, true} ->
            special(update, H#special_role_guild{applyed = L2}),
            L1;
        {L1, _, _} ->
            L1
    end.

handle_role_applyed([], L1, L2, Is_Change) ->
    {L1, L2, Is_Change};
handle_role_applyed([H = {ID, Date}| T], L1, L2, Is_Change) ->
    case (util:unixtime() - Date) >= ?max_apply_time of
        true ->
            handle_role_applyed(T, L1, L2, true);
        false ->
            handle_role_applyed(T, [ID | L1], [H | L2], Is_Change)
    end.

%% 删除列表中邀请超过1天的帮会, 每个角色最多有20条有效的邀请记录
handle_role_invited(H = #special_role_guild{invited = L}) ->
    case handle_role_invited(L, [], [], false) of
        {L1, L2, true} ->
            special(update, H#special_role_guild{invited = L2}),
            L1;
        {L1, _, _} ->
            L1
    end.
handle_role_invited([],  L1, L2, Is_Change) ->
    {lists:reverse(L1), lists:reverse(L2), Is_Change};
handle_role_invited([H = {{Gid, Gsrvid}, Name, Inviter, Date}| T], L1, L2, Is_Change) ->
    case (util:unixtime() - Date) >= ?unixdaytime of
        true ->
            handle_role_invited(T, L1, L2, true);
        false ->
            handle_role_invited(T, [{Gid, Gsrvid, Name, Inviter} | L1], [H | L2], Is_Change)
    end.

%% @spec clear_guild_apply(RoleID, GuildID, Applyed) -> ok
%% @doc 清除角色 RoleID 在其他 帮会(GuildID 除外)中的申请记录
clear_guild_apply({Rid, Rsrvid}, {Gid, Gsrvid}, Applyed) ->
    Fun =fun(RID, RsrvID, GID, GsrvID) -> 
            fun({GuildID, _}) -> 
                    case GuildID =/= {GID, GsrvID} of
                        true ->
                            guild_mem:clear_apply(GuildID, {RID, RsrvID});
                        false ->
                            ok
                    end
            end 
    end,
    lists:foreach(Fun(Rid, Rsrvid, Gid, Gsrvid), Applyed).

%% @spec load_guild() -> ok
%% @doc 管理进程启动 重载所有帮会数据 并启动所有帮会进程
load_guild() ->
    case dets:first(guild_list) of
        '$end_of_table' -> ?INFO("没有帮会需要启动");
        _ ->
            dets:traverse(guild_list,
                fun(Guild) ->
                        NewGuild = guild_ver:convert(Guild),
                        case NewGuild#guild.realm of
                            ?role_realm_default ->
                                case util:realm(NewGuild#guild.srv_id) of
                                    {ok, Realm} -> 
                                        start_guild(by_mgr, NewGuild#guild{realm = Realm}),
                                        continue;
                                    {false, Reason} ->
                                        update_next_guild_id(Guild#guild.gid),
                                        ?ERR("转换阵营数据发生错误 ID:~w, SrvId:~w, [Reason: ~s]", [NewGuild#guild.id, NewGuild#guild.srv_id, Reason]),
                                        continue
                                end;
                            _ ->
                                start_guild(by_mgr, NewGuild),
                                continue
                        end
                end
            ),
            ?INFO("所有帮会已启动")
    end,
    case dets:first(special_role_guild) of
        '$end_of_table' -> ok;
        _ ->
            dets:traverse(special_role_guild,
                fun(Special) ->
                        ets:insert(special_role_guild, Special),
                        continue
                end
            ),
            ok
    end.

%% @spec start_guilds() -> binary()
%% @doc 启动所有的帮会进程
start_guilds() ->
    ?INFO("开始逐个启动所有帮会进程..."),
    start_guilds(by_mgr, ets:tab2list(guild_list), <<>>).
start_guilds(by_mgr, [], <<>>) ->
    ?INFO("所有帮会进程都已成功启动"),
    ?L(<<"所有帮会进程已经启动">>);
start_guilds(by_mgr, [], Failed) ->
    ?INFO("~s", [Failed]),
    Failed;
start_guilds(by_mgr, [Guild | T], Failed) ->
    case start_guild(by_mgr, Guild) of
        {ok, _Pid} ->
            start_guilds(by_mgr, T, Failed);
        Reason ->
            start_guilds(by_mgr, T, util:fbin(<<"~s~n~s">>, [Reason, Failed]))
    end.

%% @spec start_specify(by_mgr, GuildIds) -> binary()
%% GuildIds = [{Gid, Gsrvid} | ...]
%% Gid = integer()
%% Gsrvid = binary()
%% @doc 重启指定帮会进程, Gid 是帮会的ID, Gsrvid 是服务器标志
start_specify(by_mgr, GuildIds) ->
    ?INFO("开始启动指定的帮会进程..."),
    start_specify(by_mgr, GuildIds, <<>>).
start_specify(by_mgr, [], <<>>) ->
    ?INFO("所有指定的帮会进程已经启动"),
    ?L(<<"所有指定的帮会进程已经启动">>);
start_specify(by_mgr, [], Failed) ->
    ?INFO("~s", [Failed]),
    Failed;
start_specify(by_mgr, [{Gid, Gsrvid} | T], Failed) ->
    case lookup(by_id, {Gid, Gsrvid}) of
        false ->
            ?INFO("帮会{~w, ~s}重启失败，帮会可能已解散，找不到数据", [Gid, Gsrvid]),
            start_specify(by_mgr, T, util:fbin(?L(<<"帮会{~w, ~s}重启失败，帮会可能已解散，找不到数据~n~s">>), [Gid, Gsrvid, Failed]));
        Guild ->
            case Guild#guild.realm of
                ?role_realm_default ->
                    case util:realm(Guild#guild.srv_id) of
                        {ok, Realm} -> 
                            case start_guild(by_mgr, Guild#guild{realm = Realm}) of
                                {ok, _Pid} ->
                                    start_specify(by_mgr, T, Failed);
                                Result ->
                                    start_specify(by_mgr, T, util:fbin("~s~n~s", [Result, Failed]))
                            end;
                        {false, Reason} -> 
                            update_next_guild_id(Guild#guild.gid),
                            start_specify(by_mgr, T, util:fbin("转换阵营错误 ID:~w, SrvId:~w, [Reason: ~s]~n~s", [Guild#guild.id, Guild#guild.srv_id, Reason, Failed]))
                    end;
                _ ->
                    case start_guild(by_mgr, Guild) of
                        {ok, _Pid} ->
                            start_specify(by_mgr, T, Failed);
                        Result ->
                            start_specify(by_mgr, T, util:fbin("~s~n~s", [Result, Failed]))
                    end
            end
    end.

%% @spec start_guild(by_mgr, Guild) -> {ok, Pid} | Reason
%% Guild = #guild{}
%% Pid  = pid()
%% Reason = binary()
%% @doc 启动一个帮会进程, 成功返回进程的 pid(), 失败返回失败原因
start_guild(by_mgr, #guild{gid = Gid, srv_id = Gsrvid, name = Name, lev = 0}) ->    %% 以前有用等级为0来标志帮会销毁 TODO
    update_next_guild_id(Gid),
    util:fbin(?L(<<"帮会{~w,~s,~s}处于销毁状态，不予启动">>), [Gid, Gsrvid, Name]);

start_guild(by_mgr, #guild{gid = Gid, srv_id = Gsrvid, name = Name, status = ?guild_dismiss}) ->
    update_next_guild_id(Gid),
    util:fbin(?L(<<"帮会{~w,~s,~s}处于销毁状态，不予启动">>), [Gid, Gsrvid, Name]);

start_guild(by_mgr, #guild{gid = Gid, srv_id = Gsrvid, name = Name, members = []}) ->
    update_next_guild_id(Gid),
    util:fbin(?L(<<"帮会{~w,~s,~s}处于没有任何帮会成员状态，不予启动">>), [Gid, Gsrvid, Name]);

start_guild(by_mgr, Guild = #guild{gid = Gid, srv_id = Gsrvid, name = Name}) ->
    update_next_guild_id(Gid),
    case guild:start_link({restart, normal}, Guild) of
        {ok, Pid} -> 
            {ok, Pid};
        Reason ->
            ?ERR("帮会【~s】重启失败, 【~w】",[Name, Reason]),
            util:fbin(?L(<<"帮会{~w,~s,~s}重启失败{Reason:~w}">>), [Gid, Gsrvid, Name, Reason])
    end.

%% 更新帮会的下一个可用ID
update_next_guild_id(Gid) ->
    case get(next_guild_id) of
        undefined -> put(next_guild_id, max(1, Gid));
        ID -> put(next_guild_id, max(ID, Gid))
    end.

