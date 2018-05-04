%%----------------------------------------------------
%% 跨服战斗管理器（通用）
%% Z
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(c_combat_mgr).

-behaviour(gen_server).

-export([
        start/0,
        start_link/0,
        start_combat/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("combat.hrl").
-include("attr.hrl").
-include("role.hrl").

-record(state, {
        
    }
).


%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
start() ->
    gen_server:start({local, ?MODULE}, ?MODULE, [], []).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 发起战斗
%% Args = list()
start_combat(Args) ->
    gen_server:cast(?MODULE, {start_combat, Args}).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------
init([]) ->
    process_flag(trap_exit, true),
    ?INFO("[~w] 正在启动...", [?MODULE]),

    State = #state{},
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({start_combat, Args}, State) ->
    spawn(fun() -> do_start_combat(Args) end),
    {noreply, State};

handle_cast(_Msg, State) ->
    %% ?ERR("收到未知消息: ~w", [Msg]),
    {noreply, State}.

handle_info(_Info, State) ->
    %%?ERR("收到未知消息: ~w", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% 发起战斗
do_start_combat([CombatType, AtkRoleIdList, DfdRoleIdList]) ->
    {L1, _Fails1} = roles_to_fighters(AtkRoleIdList),
    {L2, _Fails2} = roles_to_fighters(DfdRoleIdList),
    %% RoleIds = RoleIds1 ++ RoleIds2,
    %% SuccessRoleIds = [{Rid, SrvId} || #converted_fighter{fighter = #fighter{rid = Rid, srv_id = SrvId}} <- (L1 ++ L2)],
    %% FailedRoleIds = RoleIds -- SuccessRoleIds,
    %% FailedReasons = Fails1 ++ Fails2,
    case combat:start(CombatType, L1, L2) of
        {ok, _CombatPid} -> ok;
        _Why -> ?ERR("[~w]与[~w]发起type=~w的战斗失败:~w", [AtkRoleIdList, DfdRoleIdList, CombatType, _Why])
    end.

%% 转换角色成参战者 -> {[#converted_fighter{}], [{RoleId, FailedReason}]}
%% FailedReason = event|timeout|offline|term()
%% RoleIds = [{Rid, SrvId}]
roles_to_fighters(RoleIds) ->
    %% 因为偶尔会timeout，所以加入多次尝试
    RoleIds1 = [{RoleId, 0} || RoleId <- RoleIds],
    roles_to_fighters(RoleIds1, [], []).
roles_to_fighters([], Result, Fails) -> {Result, Fails};
roles_to_fighters([{RoleId = {Rid, SrvId}, TryNum}|T], Result, Fails) when TryNum < 3 ->
    case catch c_proxy:role_lookup(by_id, RoleId, to_fighter) of
        {ok, _, CF} ->
            roles_to_fighters(T, [CF|Result], Fails);
        {error, timeout} -> %% 超时，重试3次
            %% ?INFO("查找并转换跨服角色[~w, ~s]超时，正在重试第~w次", [Rid, SrvId, TryNum+1]),
            roles_to_fighters([{RoleId, TryNum+1}|T], Result, Fails);
        {error, not_found} -> %% 掉线
            %% ?INFO("[~w, ~s]掉线，查找不到了", [Rid, SrvId]),
            roles_to_fighters(T, Result, [{RoleId, offline}|Fails]);
        _Err -> 
            ?ERR("查找并转换跨服角色[~w, ~s]出错:~w", [Rid, SrvId, _Err]),
            roles_to_fighters(T, Result, [{RoleId, _Err}|Fails])
    end.
