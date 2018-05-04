%%----------------------------------------------------
%% 跨服旅行中央服管理器
%% @author yankai@jieyou.cn
%% @end
%%----------------------------------------------------
-module(c_trip_mgr).

-behaviour(gen_server).

-export([
        start_link/0,
        enter_center_city/1,
        leave_center_city/1,
        confirm_kick_expire_role/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("map.hrl").
-include("role.hrl").

-record(state, {
        is_enter_limited = true,    %% 是否禁止进入
        center_city_role_ids = []   %% 进入中心城的角色id列表
    }
).

-define(CENTER_CITY_MAX_POPULATION, 2000).  %% 中心城人口限制
-define(CENTER_CITY_POPULATION_SAFE, 1900).  %% 中心城人口安全线（降低到这个水平才撤销限制）
-define(CENTER_CITY_STAY_TIME, 60 * 30).  %% 中心城允许的停留时间（秒）
-define(CENTER_CITY_STAY_TIME_CHECK_TIME, 1000*60*3).  %% 中心城允许的停留时间的检查时间 （毫秒）

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 进入中心城
enter_center_city(RoleId) ->
    gen_server:cast(?MODULE, {enter_center_city, RoleId}).

%% 离开中心城
leave_center_city(RoleId) ->
    gen_server:cast(?MODULE, {leave_center_city, RoleId}).

%% 确定踢走超时停留的角色
confirm_kick_expire_role(RoleId) ->
    gen_server:cast(?MODULE, {confirm_kick_expire_role, RoleId}).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    State = #state{},
    Len = length(map:role_list(36031)),
    sys_env:save(center_city_population, Len),
    erlang:send_after(?CENTER_CITY_STAY_TIME_CHECK_TIME, self(), check_center_city_expire_role),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({enter_center_city, RoleId}, State = #state{is_enter_limited = IsLimited, center_city_role_ids = RoleIds}) ->
    Num1 = case sys_env:get(center_city_population) of
        Num when is_integer(Num) ->
            sys_env:save(center_city_population, Num+1),
            Num+1;
        _ ->
            sys_env:save(center_city_population, 1),
            1
    end,
    RoleIds1 = [{RoleId, util:unixtime()}|lists:keydelete(RoleId, 1, RoleIds)],
    case IsLimited =:= false andalso Num1 >= ?CENTER_CITY_MAX_POPULATION of
        true ->
            c_mirror_group:cast(all, trip_mgr, limit_enter, [true]),
            {noreply, State#state{is_enter_limited = true, center_city_role_ids = RoleIds1}};
        false ->
            {noreply, State#state{center_city_role_ids = RoleIds1}}
    end;

handle_cast({leave_center_city, RoleId}, State = #state{is_enter_limited = IsLimited, center_city_role_ids = RoleIds}) ->
    Num2 = case sys_env:get(center_city_population) of
        Num when is_integer(Num) ->
            Num1 = util:check_range(Num-1, 0, Num),
            sys_env:save(center_city_population, Num1),
            Num1;
        _ ->
            sys_env:save(center_city_population, 0),
            0
    end,
    RoleIds1 = lists:keydelete(RoleId, 1, RoleIds),
    case IsLimited =:= true andalso Num2 =< ?CENTER_CITY_POPULATION_SAFE of
        true ->
            c_mirror_group:cast(all, trip_mgr, limit_enter, [false]),
            {noreply, State#state{is_enter_limited = false, center_city_role_ids = RoleIds1}};
        false ->
            {noreply, State#state{center_city_role_ids = RoleIds1}}
    end;

handle_cast({confirm_kick_expire_role, RoleId}, State = #state{center_city_role_ids = RoleIds}) ->
    RoleIds1 = lists:keydelete(RoleId, 1, RoleIds),
    case sys_env:get(center_city_population) of
        Num when is_integer(Num) ->
            Num1 = util:check_range(Num-1, 0, Num),
            sys_env:save(center_city_population, Num1);
        _ ->
            sys_env:save(center_city_population, 0)
    end,
    {noreply, State#state{center_city_role_ids = RoleIds1}};

handle_cast(Msg, State) ->
    ?ERR("收到未知消息: ~w", [Msg]),
    {noreply, State}.

handle_info(check_center_city_expire_role, State = #state{center_city_role_ids = RoleIds}) ->
    ?DEBUG("检查停留时间:~w", [RoleIds]),
    kick_expire_role(RoleIds),
    erlang:send_after(?CENTER_CITY_STAY_TIME_CHECK_TIME, self(), check_center_city_expire_role),
    {noreply, State};

handle_info(_Info, State) ->
    %% ?ERR("收到未知消息: ~w", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

kick_expire_role([]) -> ok;
kick_expire_role([{RoleId = {_, SrvId}, EnterTime}|T]) ->
    case EnterTime + ?CENTER_CITY_STAY_TIME =< util:unixtime() of
        true ->
            ?DEBUG("[~w]停留时间到，踢走", [RoleId]),
            c_mirror_group:cast(node, SrvId, trip_mgr, kick_expire_role, [RoleId]);
        false ->
            ignore
    end,
    kick_expire_role(T).
