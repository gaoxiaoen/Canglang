%%----------------------------------------------------
%% NPC管理器
%% 
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(npc_mgr).
-behaviour(gen_server).
-export([
        create/4
        ,create/5
        ,create/6
        ,create/7
        ,remove/1
        ,reload/0
        ,lookup/2
        ,get_npc/2
        ,start_link/0
        ,handle_special_npc/2
        ,role_login/1
        ,update_honour_npc/1
        ,update_rank_npc/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {next_id = 1, special_npc = []}).
-include("common.hrl").
-include("npc.hrl").
-include("pos.hrl").
-include("role.hrl").
-include("offline_exp.hrl").

-define(sync_honour_npc_interval, 60000 * 120). %% 两个小时更新荣耀npc的装备
%%-define(update_honour_npc_interval, 60000 * 60 * 24). %% 24小时更新荣耀npc

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

%% @spec create(BaseId, MapId, X, Y) -> false | {ok, NpcId}
%% BaseId = integer()
%% MapId = integer() | {Line, MapId}
%% X = integer()
%% Y = integer()
%% NpcId = integer()
%% @doc 创建一个NPC，并将此NPC传送到指定地图的指定地点(可选择指定巡逻路径)
create(NpcBase, MapGid, X, Y) when is_record(NpcBase, npc_base) -> create(NpcBase, MapGid, X, Y, []);
create(BaseId, MapGid, X, Y) -> create(BaseId, MapGid, X, Y, []).

create(NpcBase, MapGid, X, Y, Paths) when is_record(NpcBase, npc_base) -> create(NpcBase, MapGid, X, Y, <<>>, Paths);
create(BaseId, MapGid, X, Y, Paths) -> create(BaseId, MapGid, X, Y, <<>>, Paths).

create(NpcBase = #npc_base{}, MapGid, X, Y, Disabled, Paths) ->
    create(NpcBase, MapGid, X, Y, Disabled, Paths, <<"">>);
create(BaseId, MapGid, X, Y, Disabled, Paths) ->
    create(BaseId, MapGid, X, Y, Disabled, Paths, <<"">>).
    
create(NpcBase = #npc_base{id = NpcBaseId, type = Type}, MapGid = {Line, MapId}, X, Y, Disabled, Paths, Name) ->
    Id = case catch ets:update_counter(npc_counter, next_id, 1) of
        Uid when is_integer(Uid) -> 
            gen_server:cast(?MODULE, {update_id, Uid + 1}),
            Uid;
        _Err ->
            ?ERR("npc_mgr获取npc id出错了:~w", [_Err]),
            gen_server:call(?MODULE, fetch_id)
    end,
    Npc2 = #npc{pos = Pos} = npc_convert:base_to_npc(Id, NpcBase, #pos{map = MapId, x = X, y = Y, line = Line}),
    Npc = case Name of 
        <<"">> ->
            Npc2;
        _ ->
            Npc2#npc{name = Name}
    end,
    case Type of
        0 -> %% 固定NPC
            case map:npc_enter(MapGid, npc_convert:do(to_map_npc, Npc)) of
                false -> ets:insert(npc_online, Npc);
                {MapBaseId, MapPid} -> ets:insert(npc_online, Npc#npc{disabled = Disabled, pos = Pos#pos{map_pid = MapPid, map_base_id = MapBaseId}})
            end,
            {ok, Id};
        1 -> %% 活动NPC
            case catch npc:start_link(Npc#npc{disabled = Disabled, paths = Paths}) of
                {ok, _Pid} -> {ok, Id};
                E ->
                    ?ERR("创建NPC进程发生异常: ~w", [E]),
                    false
            end;
        _ ->
            ?ERR("NPC数据中的类型值异常[BaseId:~w, Type:~w]", [NpcBaseId, Type]),
            false
    end;
create(NpcBase, MapId, X, Y, Disabled, Paths, Name) when is_integer(MapId) ->
    create(NpcBase, {1, MapId}, X, Y, Disabled, Paths, Name);
create(BaseId, MapGid, X, Y, Disabled, Paths, Name) -> 
    case npc_data:get(BaseId) of
        {ok, Base} ->
            create(Base, MapGid, X, Y, Disabled, Paths, Name);
        false ->
            ?ERR("不存在的NPC:~w", [BaseId]),
            false
    end.

%% @spec remove(NpcId) -> ok
%% NpcId = integer()
%% @doc 根据Npc唯一ID清除指定的NPC
remove(NpcId) ->
    case lookup(by_id, NpcId) of
        false -> ok;
        #npc{pid = Pid} when is_pid(Pid) ->
            npc:stop(Pid);
        #npc{pos = #pos{map = MapId, line = Line}} ->
            ets:delete(npc_online, NpcId),
            map:npc_leave({Line, MapId}, NpcId)
    end.

%% @spec reload() -> ok
%% @doc 重新加载所有的NPC数据
reload() ->
    ?MODULE ! {reload, all}.

%% @spec lookup(T, Id) -> false | #npc{} | [#npc{}]
%% T = by_id | by_base_id
%% Id = integer()
%% @doc 查询某个或某些Npc的在线信息，返回完整的NPC属性
lookup(by_id, Id) ->
    case ets:lookup(npc_online, Id) of
        [Npc = #npc{}] -> Npc;
        _ -> false
    end;
lookup(by_base_id, Id) ->
    case ets:match_object(npc_online, #npc{base_id = Id, _ = '_'}) of
        [] -> false;
        L -> L
    end.

%% @spec get_npc(CrossSrvId, NpcId) -> false | [#npc{}]
%% CrossSrvId = bitstring
%% NpcId = integer()
%% 根据CrossSrvId与NpcId获取npc信息
get_npc(<<>>, NpcId) ->
    lookup(by_id, NpcId);
get_npc(_CrossSrvId, NpcId) ->
    center:call(npc_mgr, lookup, [by_id, NpcId]).

%% @spec start_link() -> ok
%% @doc 启动NPC进程管理器
start_link() ->
    case gen_server:start_link({local, ?MODULE}, ?MODULE, [], []) of
        {ok, Pid} ->
            Pid ! init,
            {ok, Pid};
        Other ->
            Other
    end.

%% @spec handle_special_npc(ConnPid, Npcs)
%% 角色进入地图场景时，推送特殊npc的特效给玩家
handle_special_npc(ConnPid, NpcIds) ->
    ?MODULE ! {handle_special_npc, ConnPid, NpcIds}.

%% 用户登录检测，师门弟子发系统传闻
role_login(#role{id = Rid, offline_exp = #offline_exp{last_logout_time = Lltime}}) ->
    case util:unixtime() - Lltime of
        Ltime when Ltime > 10800 ->
            ?DEBUG("荣耀NPC登录: ~w", [Ltime]),
            ?MODULE ! {role_login, Rid};
        _T ->
            ?DEBUG("荣耀NPC登录: ~w", [_T]),
            ok
    end;
role_login(_) ->
    ok.

%% update_honour_npc(MaxPowers) -> 
%% MaxPowers = [{Career, rid()}, ...]
%% Career = integer() 职业
%% 更新首席弟子
update_honour_npc(MaxPowers) ->
    ?MODULE ! {update_honour_npc, MaxPowers}.

update_rank_npc(Ranks) ->
    ?MODULE ! {update_rank_npc, Ranks}.

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ets:new(npc_online, [set, named_table, public, {keypos, #npc.id}]),
    ets:new(npc_counter, [set, public, named_table]), %% Npc计数表
    ets:insert(npc_counter, {next_id, 0}),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% 申请Npc ID编号
handle_call(fetch_id, _From, State = #state{next_id = Id}) ->
    {reply, Id, State#state{next_id = Id + 1}};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({update_id, Uid}, State = #state{next_id = Id}) ->
    NewId = case Uid >= Id of
        true -> Uid;
        false -> 
            %% ?ERR("npc_mgr更新next_id有误[Id:~w, Uid:~w]", [Id, Uid]),
            Id
    end,
    {noreply, State#state{next_id = NewId}};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 重新载入npc
handle_info({reload, all}, State) ->
    do_reload(ets:tab2list(npc_online), 0),
    {noreply, State};

%% init
handle_info(init, State) ->
    Snpcs1 = npc_special:get_special_npc(1),
    Snpcs2 = npc_special:get_special_npc(2),
    Snpcs3 = npc_special:get_special_npc(3),
    Snpcs4 = npc_special:get_special_npc(4),
    %erlang:send_after(npc_special:time_update_honour_npc(), self(), {update_honour_npc}),
    erlang:send_after(?sync_honour_npc_interval, self(), {sync_honour_npc}),
    {noreply, State#state{special_npc = Snpcs1 ++ Snpcs2 ++ Snpcs3 ++ Snpcs4}};

%% 更新 荣耀NPC
handle_info({update_honour_npc, MaxPowers}, State = #state{special_npc = Snpcs}) ->
    NewSnpcs = npc_special:update_npc(MaxPowers),
    NewS = [Npcs || Npcs = #npc_special{npc_base_id = BaseId} <- Snpcs, lists:member(BaseId, [11218, 11219, 11220, 11221]) =:= true],
    {noreply, State#state{special_npc = NewSnpcs ++ NewS}};

%% 更新 达人
handle_info({update_rank_npc, Ranks}, State = #state{special_npc = Snpcs}) ->
    NewSnpcs = npc_special:update_npc(rank, Ranks),
    NewS = [Npcs || Npcs = #npc_special{npc_base_id = BaseId} <- Snpcs, lists:member(BaseId, [11021, 11022, 11023, 11024, 11025]) =:= true],
    {noreply, State#state{special_npc = NewSnpcs ++ NewS}};

%% 更新 npc的特效
handle_info({sync_honour_npc}, State = #state{special_npc = Snpcs}) ->
    NewSnpcs = npc_special:sync_npc(Snpcs),
    erlang:send_after(?sync_honour_npc_interval, self(), {sync_honour_npc}),
    {noreply, State#state{special_npc = NewSnpcs}};

%% 发送系统消息
handle_info({send_notice, [H | T]}, State) ->
    catch notice:send(54, H),
    case length(T) of 
        0 ->
            {noreply, State};
        _ ->
            erlang:send_after(10000, self(), {send_notice, T}),
            {noreply, State}
    end;

handle_info({send_notice2, [H | T]}, State) ->
    catch notice:send(54, H),
    case length(T) of 
        0 ->
            {noreply, State};
        _ ->
            erlang:send_after(10000, self(), {send_notice2, T}),
            {noreply, State}
    end;

%% gm命令同步
handle_info({sync_honour_npc2}, State = #state{special_npc = Snpcs}) ->
    NewSnpcs = npc_special:sync_npc(Snpcs),
    {noreply, State#state{special_npc = NewSnpcs}};

%% 玩家进入场景，推送特殊npc的特效
handle_info({handle_special_npc, ConnPid, NpcIds}, State) ->
    erlang:send_after(1000, self(), {handle_special_npc2, ConnPid, NpcIds}),
    {noreply, State};
handle_info({handle_special_npc2, ConnPid, NpcIds}, State = #state{special_npc = Snpcs}) ->
    npc_special:role_enter_map(ConnPid, NpcIds, Snpcs),
    {noreply, State};

%% 用户登录检测，师门弟子发系统传闻
handle_info({role_login, Rid}, State = #state{}) ->
    erlang:send_after(10000, self(), {role_login2, Rid}),
    {noreply, State};
handle_info({role_login2, Rid}, State = #state{special_npc = Snpcs}) ->
    npc_special:role_login(Rid, Snpcs),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% 私有函数
%%----------------------------------------------------

%% 执行重载
do_reload([], Count) ->
    ?INFO("所有在线NPC的属性已经重载，共 ~w 个", [Count]),
    ok;
do_reload([#npc{pid = Pid} | T], Count) when is_pid(Pid) ->
    npc:reload(Pid),
    do_reload(T, Count + 1);
do_reload([Npc = #npc{id = Id, name = Name, base_id = BaseId, pos = #pos{map = MapId, line = Line}} | T], Count) ->
    case npc_data:get(BaseId) of
        false -> remove(Id); %% 该NPC已经不存在于npc_data.erl中了
        {ok, NpcBase = #npc_base{
                type = Type, name = Name, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax,
                lev = Lev, nature = Nature, speed = Speed, slave = Slave, talk = Talk,
                attr = Attr, guard_range = GuardRange, t_trace = Ttrace, t_patrol = {Tmin, Tmax}
            }
        } ->
            N = Npc#npc{
                type = Type, name = Name, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax,
                lev = Lev, nature = Nature, speed = Speed, slave = Slave, talk = Talk,
                attr = Attr, guard_range = GuardRange, t_trace = Ttrace, base = NpcBase,
                t_patrol = util:rand(Tmin, Tmax)
            },
            case Type of
                0 ->
                    ets:insert(npc_online, N),
                    map:npc_update({Line, MapId}, npc_convert:do(to_map_npc, N)); %% 更新地图上的角色信息
                1 ->
                    ?INFO("NPC[~s]已经转换成了活动NPC", [Name]),
                    remove(Id), %% 清除原来的NPC
                    npc:start_link(N) %% 重新创建一个新的NPC, （ TODO 在这创建可能会导致副本退出，怪物进程不死）
            end;
        _Other ->
            ?DEBUG("not match: ~w", [_Other]),
            ok
    end,
    do_reload(T, Count + 1).
