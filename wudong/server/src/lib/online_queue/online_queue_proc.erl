%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 一月 2018 15:46
%%%-------------------------------------------------------------------
-module(online_queue_proc).
-author("li").

-behaviour(gen_server).

-include("common.hrl").
-include("server.hrl").

%% API
-export([
    start_link/0
    , get_server_pid/0
    , get_token/2
    , get_token/1
    , delete/1
    , change_s/1
    , change_e/1
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

-define(S_LIMIT_NUM, 1200). %% 开始排队在线人数
-define(E_LIMIT_NUM, 1500). %% 终止进入在线人数
-define(TIME, 5). %% 5秒钟更新一次
-define(TIME_ONLINE, 60). %%  队列中60秒没有更新自动退出

-record(state, {
    start_limit_num = ?S_LIMIT_NUM %% 开启排队机制
    , end_limit_num = ?E_LIMIT_NUM %% 关闭登陆机制
    , queue = [] %% [#pp{}]
    , count = 1 %% 计数器
}).

-record(pp, {
    count = 0 %% 令牌ID
    , account = 0 %% 账号
    , time = 0 %% 时间
}).

%%%===================================================================
%%% API
%%%===================================================================

get_token(Account) ->
    get_token(Account, #client{}).

get_token(Account, Client) ->
    ?CAST(get_server_pid(), {get_token, Account, Client}).

delete(Account) ->
    ?CAST(get_server_pid(), {delete_player_info, Account}).

%% 修改排队起始人数
change_s(Num) ->
    ?CAST(get_server_pid(), {change_s, Num}).

%% 修改排队终止人数
change_e(Num) ->
    ?CAST(get_server_pid(), {change_e, Num}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%获取进程PID
get_server_pid() ->
    case get(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    put(?MODULE, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

init([]) ->
    erlang:send_after(?TIME*1000,self(),auto_update),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast({get_token, Account, Client}, State) ->
    Now = util:unixtime(),
    case get(online_num) of
        {Num, Time} when Now - Time < ?TIME ->
            Num;
        _ ->
            Num = ets:info(?ETS_ONLINE, size),
            put(online_num, {Num, Now})
    end,
    spawn(fun() ->
        if
            State#state.start_limit_num > Num ->
                Replay = {0, 1};
            State#state.end_limit_num =< Num ->
                ?CAST(get_server_pid(),{update_player_info, Account}),
                {C, _S} = get_token(Account, State#state.queue, Now),
                Replay = {C, 3};
            true ->
                Replay = get_token(Account, State#state.queue, Now)
        end,
        {ok, Bin} = pt_100:write(10010, Replay),
        server_send:send_one(Client#client.socket, Bin)
    end),
    {noreply, State};

handle_cast({change_s, Num}, State) ->
    {noreply, State#state{start_limit_num = Num}};

handle_cast({change_e, Num}, State) ->
    {noreply, State#state{end_limit_num = Num}};

handle_cast({delete_player_info, Account}, State) ->
    NewState = delete_player_info(Account, State),
    {noreply, NewState};

handle_cast({update_player_info, Account}, State) ->
    NewState = update_player_info(Account, State),
    {noreply, NewState};

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(auto_update, State) ->
%%     ?DEBUG("State:~p", [State]),
    NewState = auto_update(State),
    erlang:send_after(?TIME*1000,self(),auto_update),
    {noreply, NewState};

handle_info(_Info, State) ->
    {noreply, State}.


terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

get_token(Account, Queue, Now) ->
    case lists:keyfind(Account, #pp.account, Queue) of
        false ->
            {PreCount, Status} = {length(Queue), 0};
        _ ->
            {PreCount, Status} = cacl_status(Account, Queue, Now, {0, 0})
    end,
    ?IF_ELSE(Status == 0, ?CAST(get_server_pid(),{update_player_info, Account}), skip),
    {PreCount, Status}.

%% Statue 0、前面没有合格队友拦路 1、直接放行 2、前面有拦路虎玩家
cacl_status(_Account, [], _Now, {PreCount, Status}) ->
    {PreCount, Status};

cacl_status(Account, [PP | Queue], Now, {PreCount, Status}) ->
    if
        PP#pp.account == Account andalso Status == 0 ->
            {PreCount, 1};
        PP#pp.account == Account ->
            {PreCount, 2};
        Now - PP#pp.time >= 10 -> %% 玩家不在线了,跳过他的限制
            cacl_status(Account, Queue, Now, {PreCount+1, Status});
        true ->
            cacl_status(Account, Queue, Now, {PreCount+1, 2})
    end.

delete_player_info(Account, State) ->
    #state{queue = Queue} = State,
    case lists:keytake(Account, #pp.account, Queue) of
        false ->
            NewQueue = Queue;
        {value, _PP, Rest} ->
            NewQueue = Rest
    end,
    State#state{queue = NewQueue}.

update_player_info(Account, State) ->
    #state{queue = Queue, count = Count} = State,
    Now = util:unixtime(),
    case lists:keyfind(Account, #pp.account, Queue) of
        false ->
            NewCount = Count + 1,
            NewQueue = Queue ++ [#pp{account = Account, count = Count, time = Now}];
        PP ->
            NewCount = Count,
            NewQueue = lists:keyreplace(PP#pp.count, #pp.count, Queue, PP#pp{time = Now})
    end,
    State#state{queue = NewQueue, count = NewCount}.

auto_update(State) ->
    Now = util:unixtime(),
    #state{queue = Queue} = State,
    F = fun(#pp{time = Time} = PP) ->
        if
            Now - Time >= ?TIME_ONLINE -> [];
            true -> [PP]
        end
    end,
    NewQueue = lists:flatmap(F, Queue),
    State#state{queue = lists:sort(NewQueue)}.