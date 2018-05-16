%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 跨服水果大作战
%%% @end
%%% Created : 03. 五月 2017 上午10:22
%%%-------------------------------------------------------------------
-module(cross_fruit_proc).
-author("fengzhenlin").

-behaviour(gen_server).
-include("common.hrl").
-include("cross_fruit.hrl").

%% API
-export([start_link/0,
    get_server_pid/0,
    apply_match/3,
    apply_match_invite/2,
    continue/2,
    get_fight_info/1,
    operate/3,
    exit/1,
    week_rank_reward/0,
    get_week_gift_res/1,
    get_week_rank_gift_info/3,
    get_week_rank/3
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================
get_server_pid() ->
    case get(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local,?MODULE) of
                Pid when is_pid(Pid) ->
                    put(?MODULE,Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

%%申请匹配
apply_match(FruitPlayer, Type, IsInvite) ->
    ?CAST(get_server_pid(), {apply_match, FruitPlayer, Type, IsInvite}).

%%进行邀请匹配
apply_match_invite(MyPkey, Pkey) ->
    ?CAST(get_server_pid(), {apply_match_invite, MyPkey, Pkey}).

%%继续
continue(MyPkey, Pkey) ->
    ?CAST(get_server_pid(), {continue, MyPkey, Pkey}).

%%获取当前比赛信息
get_fight_info(Pkey) ->
    ?CAST(get_server_pid(), {get_fight_info, Pkey}).

%%操作
operate(Pkey, Type, Pos) ->
    ?CAST(get_server_pid(), {operate, Pkey, Type, Pos}).

%%周排行结算
week_rank_reward() ->
    get_server_pid() ! week_reward.

%%离开
exit(Pkey) ->
    ?CAST(get_server_pid(), {exit, Pkey}).

%%周排行奖励领取反馈
get_week_gift_res(Pkey) ->
    ?CAST(get_server_pid(), {get_week_gift_res, Pkey}).

%%获取周排行奖励信息
get_week_rank_gift_info(Pkey, Node, Sid) ->
    ?CAST(get_server_pid(), {get_week_rank_gift_info, Pkey, Node, Sid}).

get_week_rank(Pkey, Node, Sid) ->
    ?CAST(get_server_pid(), {get_week_rank, Pkey, Node, Sid}).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
    {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    ets:new(?ETS_CROSS_FRUIT, [{keypos, #cross_fruit.fkey} | ?ETS_OPTIONS]),
    ets:new(?ETS_CROSS_FRUIT_PLAYER, [{keypos, #cross_fruit_player.pkey} | ?ETS_OPTIONS]),
    Ref = erlang:send_after(?MATCH_TIME*1000, self(), time_to_match),
    spawn(fun() -> cross_fruit_load:dbget_cross_fruit_player() end),
    erlang:send_after(5000, self(), init),
    {ok, #cf_state{match_ref = Ref}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
handle_call(Request, From, State) ->
    case catch cross_fruit_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("cross_fruit_handle handle_call ~p~n", [Reason]),
            {reply, error, State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
handle_cast(Request, State) ->
    case catch cross_fruit_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross_fruit_handle handle_cast ~p~n", [Reason]),
            {noreply, State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #cf_state{}) ->
    {noreply, NewState :: #cf_state{}} |
    {noreply, NewState :: #cf_state{}, timeout() | hibernate} |
    {stop, Reason :: term(), NewState :: #cf_state{}}).
handle_info(Info, State) ->
    case catch cross_fruit_handle:handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross_fruit_handle handle_info ~p~n", [Reason]),
            {noreply, State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #cf_state{}) -> term()).
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #cf_state{},
    Extra :: term()) ->
    {ok, NewState :: #cf_state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
