%%----------------------------------------------------
%% 跨服旅行管理（出入境登记）
%%
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(cross_trip).
-behaviour(gen_server).
-export([
        start_link/0,
        login/1,
        role_switch/1,
        enter_cross_srv/5
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("center.hrl").
-include("role.hrl").
-include("pos.hrl").


-record(state, {
    }).

%% ----------------------------------------------------
%% 对外接口
%% ----------------------------------------------------
%% @spec start_link() -> {ok, Pid} | {error, Reason}
%% @doc 创建镜像服务器群组管理进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 登陆
login(Role = #role{cross_srv_id = <<>>}) -> Role;
login(Role = #role{cross_srv_id = <<"center">>, pos = #pos{map_base_id = MapBaseId}}) ->
    LocalMapBaseIds = map_data:startup(),
    case lists:member(MapBaseId, LocalMapBaseIds) of
        true -> %% 有跨服标志但却不在跨服地图
            Role#role{cross_srv_id = <<>>};
        false -> 
            Role
    end;
login(Role = #role{cross_srv_id = CrossSrvId, pos = Pos = #pos{map_pid = MapPid}}) when is_pid(MapPid) ->
    case cross_util:is_local_srv(CrossSrvId) of
        true -> Role#role{cross_srv_id = <<>>};
        false ->
            case util:is_process_alive(MapPid) of
                true -> Role;
                false ->
                    Role#role{event = ?event_no, cross_srv_id = <<>>, pos = Pos#pos{map = 10003, x = 7140, y = 690}}
            end
    end;
login(Role) -> Role.

%% @spec role_switch(Role) -> ok
%% Role = #role{}
%% @doc 角色顶号事件处理
role_switch(Role = #role{cross_srv_id = <<>>}) -> Role;
role_switch(Role = #role{cross_srv_id = <<"center">>}) -> Role;
role_switch(Role = #role{cross_srv_id = CrossSrvId, pos = Pos = #pos{map_pid = MapPid}}) when is_pid(MapPid) ->
    case cross_util:is_local_srv(CrossSrvId) of
        true -> Role#role{cross_srv_id = <<>>};
        false ->
            case util:is_process_alive(MapPid) of
                true -> Role;
                false ->
                    Role#role{event = ?event_no, cross_srv_id = <<>>, pos = Pos#pos{map = 10003, x = 7140, y = 690}}
            end
    end;
role_switch(Role) -> Role.

%% 角色进入其他远端服务器的地图
enter_cross_srv(RolePid, SrvId, MapId, X, Y) ->
    gen_server:cast(?MODULE, {enter_cross_srv, RolePid, SrvId, MapId, X, Y}).

%% ----------------------------------------------------
%% 内部处理
%% ----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({enter_cross_srv, RolePid, SrvId, MapId, X, Y}, State) ->
    catch role:apply(async, RolePid, {fun do_enter_cross_srv/5, [SrvId, MapId, X, Y]}),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    %%?INFO("[~s]的镜像进程已经退出", [Node]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------
do_enter_cross_srv(Role = #role{name = _Name, event = ?event_no}, SrvId, MapId, X, Y) ->
    CrossSrvId = util:to_binary(SrvId),
    CrossSrvId1 = case cross_util:is_local_srv(SrvId) of
        true -> <<>>;
        false -> CrossSrvId
    end,
    %% ?DEBUG("[~s] CrossSrvId1=~s", [_Name, CrossSrvId1]),
    case catch map:role_enter(MapId, X, Y, Role#role{cross_srv_id = CrossSrvId1}) of
        {ok, NewRole} ->
            {ok, NewRole#role{cross_srv_id = CrossSrvId1}};
        _Other ->
            ?ERR("[~s]进入其他服的地图失败:~w", [_Name, _Other]),
            {ok, Role}
    end;
do_enter_cross_srv(Role, _, _, _, _) ->
    {ok, Role}.
