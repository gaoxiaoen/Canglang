%%----------------------------------------------------
%% 角色管理器
%% 
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(role_mgr).
-behaviour(gen_server).
-export([
        start_link/0
        ,fetch/2
        ,sync/1
        ,sync_to_db/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("role.hrl").
-record(state, {}).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

%% 启动管理器
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @spec sync(Role) -> ok
%% Role = #role{}
%% @doc 同步角色数据到DETS中
sync(Role) when is_record(Role, role) ->
    dets:insert(role_data, Role).

%% 从DETS中获取指定角色的数据
%% Rid = integer()
%% SrvId = bitstring()
%% @spec fetch(Rid, SrvId) -> {ok, #role{}} | {false, not_found}
fetch(Rid, SrvId) ->
    case dets:lookup(role_data, {Rid, SrvId}) of
        [Role] when is_record(Role, role) -> {ok, Role};
        _ ->
            {false, not_found}
    end.

%% @spec sync(Key) -> ok
%% Key = all | {integer(), bitstring()}
%% @doc将DETS中的数据同步到数据库

%% 同步所有数据
sync_to_db(all) ->
    case dets:first(role_data) of
        '$end_of_table' -> ?INFO("没有数据需要执行同操作");
        _ ->
            dets:traverse(role_data,
                fun(Role) ->
                        sync_to_db(Role),
                        continue
                end
            ),
            ?INFO("所有角色数据已经执行同步操作")
    end;

%% 根据ID同步指定角色的数据
%% @spec sync_to_db(R) -> ok | ignore | {false, term()}
%% R = {integer(), bitstring()} | #role{}
sync_to_db({Rid, SrvId}) ->
    case dets:lookup(role_data, {Rid, SrvId}) of
        [Role] -> sync_to_db(Role);
        _ -> ignore
    end;

%% 同步单个角色数据
sync_to_db(Role = #role{id = {Rid, SrvId}}) ->
    case role_data:save_role(Role) of
        {false, Why} -> {false, Why};
        true ->
            dets:delete(role_data, {Rid, SrvId}),
            ok
    end.

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    %% 角色数据存储器
    dets:open_file(role_data, [{file, "../var/role.dets"}, {keypos, #role.id}, {type, set}]),
    sync_to_db(all),
    State = #state{},
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% 私有函数
%%----------------------------------------------------
