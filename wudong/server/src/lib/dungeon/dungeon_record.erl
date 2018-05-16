%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 副本信息记录器
%%% @end
%%% Created : 23. 九月 2015 下午4:42
%%%-------------------------------------------------------------------
-module(dungeon_record).
-author("fancy").
-include("common.hrl").
-include("dungeon.hrl").

-behaviour(gen_server).

%% API
-export([start_link/0,
    set/2,
    get/1,
    erase/1,
    reset_board_praise/0,
    set_history/2,
    clean_history/1,
    midnight/0
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {
    dun_dict = dict:new()
}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

set(Pkey, DungeonRecord) ->
    ?CAST(?MODULE, {set, Pkey, DungeonRecord}).

get(Pkey) ->
    ?CALL(?MODULE, {get, Pkey}).

erase(Pkey) ->
    ?CAST(?MODULE, {erase, Pkey}).

reset_board_praise() ->
    ?MODULE ! reset_board_praise.

set_history(Pid, Now) ->
    ?CAST(?MODULE, {set_history, Pid, Now}).

clean_history(Pid) ->
    ?CAST(?MODULE, {clean_history, Pid}).

midnight() ->
    ?MODULE ! midnight.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    process_flag(trap_exit, true),
    Ref = erlang:send_after(30 * 1000, self(), check_timeout),
    put(check_timeout, Ref),
    {ok, #state{}}.

handle_call({get, Pkey}, _From, State) ->
    Reply =
        case erlang:get(Pkey) of
            undefined ->
                [];
            Data ->
                Data
        end,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast({set, Pkey, Dungeon}, State) ->
    erlang:put(Pkey, Dungeon),
    {noreply, State};

handle_cast({erase, Pkey}, State) ->
    erlang:erase(Pkey),
    {noreply, State};

handle_cast({set_history, Pid, Now}, State) ->
    Dict = dict:store(Pid, Now, State#state.dun_dict),
    {noreply, State#state{dun_dict = Dict}};

handle_cast({clean_history, Pid}, State) ->
    Dict = dict:erase(Pid, State#state.dun_dict),
    {noreply, State#state{dun_dict = Dict}};

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(check_timeout, State) ->
    Ref = erlang:send_after(30 * 1000, self(), check_timeout),
    put(check_timeout, Ref),
    Now = util:unixtime(),
    F = fun({Pid, Time}, Dict) ->
        if Now - Time > 300 ->
            case misc:is_process_alive(Pid) of
                false -> skip;
                true ->
                    Pid ! {close_dungeon}
            end,
            Dict;
            true ->
                dict:store(Pid, Time, Dict)
        end
        end,
    DunDict = lists:foldl(F, dict:new(), dict:to_list(State#state.dun_dict)),
    {noreply, State#state{dun_dict = DunDict}};

handle_info(midnight, State) ->
    F = fun({_Key, Val}) ->
        case is_record(Val, dungeon_record) of
            false -> ok;
            true ->
                IsDunExp = dungeon_util:is_dungeon_exp(Val#dungeon_record.dun_id),
                IsDunDemon = dungeon_util:is_dungeon_demon(Val#dungeon_record.dun_id),
                case IsDunExp orelse IsDunDemon of
                    false -> ok;
                    true ->
                        case misc:is_process_alive(Val#dungeon_record.dungeon_pid) of
                            true ->
                                Val#dungeon_record.dungeon_pid ! {close_dungeon};
                            false -> ok
                        end
                end
        end
        end,
    lists:foreach(F, get()),
    {noreply, State};


handle_info(_Info, State) ->
    {noreply, State}.


terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
