%%----------------------------------------------------
%% 称号管理进程 用于管理称号变化信息 
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(honor_mgr).
-behaviour(gen_server).
-export([
        start_link/0
        ,replace_honor_gainer/2
        ,replace_honor_gainer/3
        ,login/1
        ,lookup/0
        ,gm/2
        ,check_honor_time/2
    ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
        ver = 0
        ,replace = []    %% [{Key,[{Rid, Honor}]}, {Key,[{Rid, Honor}], Time}...] Key:各系统标志 
    }
).

-include("common.hrl").
-include("role.hrl").
-include("achievement.hrl").

gm(Role, ID) ->
    replace_honor_gainer(honor_mgr_test, [{Role#role.id, ID}]).
    

%% @doc 角色称号替换
%% @spec replace_honor_gainer(Key, Gainers)
%% Key = atom() | tuple() | integer() 唯一值 尽量使用名称清楚的原子值
%% Gainers = list() 当前应该获得者列表 [{Rid, Honor}...]
%% Rid = {RoleId, SrvId}  角色ID组合
%% Honor = integer()  称号ID值
replace_honor_gainer(Key, Gainers) when is_list(Gainers) ->
    gen_server:cast(?MODULE, {replace, Key, Gainers});
replace_honor_gainer(_Key, _Gainers) -> 
    ?ERR("替换称号获得者参数不正确:[key:~w][gainer:~w]", [_Key, _Gainers]),
    ok.

replace_honor_gainer(Key, Gainers, Time) when is_list(Gainers) ->
    gen_server:cast(?MODULE, {replace, Key, Gainers, Time});
replace_honor_gainer(_Key, _Gainers, _Time) -> 
    ?ERR("替换称号获得者参数不正确:[key:~w][gainer:~w][Time:~p]", [_Key, _Gainers, _Time]),
    ok.

%% 角色登录检测是否获得相关称号 
%% 采用先删除 再重新获得方式
login(Role = #role{id = Rid, achievement = Ach = #role_achievement{honor_all = All}}) ->
    Now = util:unixtime(),
    All0 = [Honor || Honor <- All, check_honor_time(Honor, Now)],
    All1 = [{HonorId, HonorName, Time} || {HonorId, HonorName, Time} <- All0, no_server_uniqueness(HonorId)], 
    NewAll = gain_honor(Rid, All1), 
    Role#role{achievement = Ach#role_achievement{honor_all = NewAll}}.

%% 检查称号是否过期
check_honor_time({_HonorId, _HonorName, 0}, _Now) -> true;
check_honor_time({_HonorId, _HonorName, Time}, Now) when Time > Now -> true;
check_honor_time(_Honor, _Now) -> false.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("开始启动..."), 
    State = lookup(),
    ?INFO("启动完成"),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 称号获得者替换
handle_cast({replace, Key, NewGainers}, State = #state{replace = L}) ->
    {OldGainers, NewL} = case lists:keyfind(Key, 1, L) of
        {Key, OldG, _OldTime} ->
            {OldG, lists:keyreplace(Key, 1, L, {Key, NewGainers})};
        {Key, OldG} ->
            {OldG, lists:keyreplace(Key, 1, L, {Key, NewGainers})};
        _ ->
            {[], [{Key, NewGainers} | L]}
    end,
    replace(OldGainers, NewGainers),
    NewState = State#state{replace = NewL},
    save_state(NewState),
    {noreply, NewState};

handle_cast({replace, Key, NewGainers, Time}, State = #state{replace = L}) ->
    {OldGainers, NewL} = case lists:keyfind(Key, 1, L) of
        {Key, OldG, _OldTime} ->
            {OldG, lists:keyreplace(Key, 1, L, {Key, NewGainers, Time})};
        {Key, OldG} ->
            {OldG, lists:keyreplace(Key, 1, L, {Key, NewGainers, Time})};
        _ ->
            {[], [{Key, NewGainers, Time} | L]}
    end,
    replace(OldGainers, NewGainers, Time),
    NewState = State#state{replace = NewL},
    save_state(NewState),
    {noreply, NewState};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%------------------------------------------
%% 内部函数
%%------------------------------------------

%% 获取当前系统分配称号情况
lookup() ->
    case sys_env:get(honor_mgr_state) of 
        State = #state{replace = L} -> 
            Now = util:unixtime(),
            NewL1 = [{Key, Gainers} || {Key, Gainers} <- L, Gainers =/= []],
            NewL2 = [{Key, Gainers, Time} || {Key, Gainers, Time} <- L, Gainers =/= [], Time >= Now],
            State#state{replace = NewL1 ++ NewL2};
        _ -> #state{}
    end.

%% 保存状态
save_state(State) ->
    sys_env:save(honor_mgr_state, State).

%% 称号替换
replace(OldGainers, NewGainers) ->
    DelGainers = OldGainers -- NewGainers,
    AddGainers = NewGainers -- OldGainers,
    [achievement:del_honor(Rid, Honor) || {Rid, Honor} <- DelGainers],
    [achievement:add_and_use_honor(Rid, Honor) || {Rid, Honor} <- AddGainers].

replace(OldGainers, NewGainers, Time) ->
    [achievement:del_honor(Rid, HonorId) || {Rid, HonorId} <- OldGainers],
    [achievement:add_and_use_honor(Rid, {HonorId, <<>>, Time}) || {Rid, HonorId} <- NewGainers].

%% 历遍各列表 重新发放称号
gain_honor(Rid, All) ->
    #state{replace = L} = lookup(),
    gain_honor(Rid, All, L).
gain_honor(_Rid, All, []) -> All;
gain_honor(Rid, All, [{_Key, Gainers} | T]) ->
    NewAll = do_gain_honor(Rid, All, Gainers),
    gain_honor(Rid, NewAll, T);
gain_honor(Rid, All, [{_Key, Gainers, Time} | T]) ->
    Now = util:unixtime(),
    case Time > Now of
        true ->
            NewGainers = [{Rid1, HonorId, Time} || {Rid1, HonorId} <- Gainers],
            NewAll = do_gain_honor(Rid, All, NewGainers),
            gain_honor(Rid, NewAll, T);
        false -> %% 过期称号 不再使用
            gain_honor(Rid, All, T)
    end;
gain_honor(Rid, All, [_H | T]) -> %% 容错
    ?ERR("称号奖励数据有问题:~w", [_H]),
    gain_honor(Rid, All, T).

%% 实行称号重新发放
do_gain_honor(_Rid, All, []) ->
    All;
do_gain_honor(Rid, All, [{Rid, HonorId} | T]) ->
    case lists:keyfind(HonorId, 1, All) of
        false -> do_gain_honor(Rid, [{HonorId, <<>>, 0} | All], T);
        _ -> do_gain_honor(Rid, All, T)
    end;
do_gain_honor(Rid, All, [{Rid, HonorId, Time} | T]) ->
    case lists:keyfind(HonorId, 1, All) of
        false -> do_gain_honor(Rid, [{HonorId, <<>>, Time} | All], T);
        _ -> do_gain_honor(Rid, All, T)
    end;
do_gain_honor(Rid, All, [_ | T]) ->
    do_gain_honor(Rid, All, T).

%% 检查是否不是全服唯一称号
no_server_uniqueness(HonorId) -> 
    case achievement_data_honor:get(HonorId) of
        {ok, #honor_base{is_only = 1}} -> false;
        _ -> true
    end.

