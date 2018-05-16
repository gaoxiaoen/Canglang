%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%         功能推送
%%% @end
%%% Created : 21. 十二月 2015 14:55
%%%-------------------------------------------------------------------
-module(psh).
-author("hxming").
-behaviour(gen_server).
-include("common.hrl").
-include("server.hrl").

%% gen_server callbacks
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-define(SERVER, ?MODULE).

%% API
-export([start_link/0, psh_single/3, psh_all/1, login/1]).

%%创建
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


psh_single(Pkey, Type, Time) ->
    ?MODULE ! {set_psh_single, Pkey, Type, Time}.

psh_all(Type) ->
    ?MODULE ! {psh_all, Type}.

login(Player) ->
    ?MODULE ! {login, Player#player.key},
    Player.

init([]) ->
    {ok, ?MODULE}.


handle_call(_Request, _From, State) ->
    {reply, ok, State}.



handle_cast(_Request, State) ->
    {noreply, State}.

%%设置个人推送
handle_info({set_psh_single, Pkey, Type, Time}, State) ->
    set_psh_single(Pkey, Type, Time),
    {noreply, State};

handle_info({psh, Pkey, Type}, State) ->
    %%推送的内容
    case t_psh:get(Type) of
        false -> skip;
        _Msg ->
            case player_util:get_player_pid(Pkey) of
                false ->
                    %%TODO psh
                    ok;
                _ -> skip
            end
    end,
    case get(Pkey) of
        undefined ->
            ok;
        List ->
            put(Pkey, lists:keydelete(Type, 1, List))
    end,
    {noreply, State};

%%玩家登陆
handle_info({login, Pkey}, State) ->
    case get(Pkey) of
        undefined ->
            skip;
        List ->
            util:cancel_ref([Ref || {_, Ref} <- List]),
            erase(Pkey)
    end,
    {noreply, State};

handle_info({psh_all, Type}, State) ->
    case t_psh:get(Type) of
        false -> skip;
        _Msg ->
            ok
    end,
    {noreply, State};

handle_info(_Request, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.


set_psh_single(Pkey, Type, Time) ->
    Ref = erlang:send_after(Time * 1000, self(), {psh, Pkey, Type}),
    case get(Pkey) of
        undefined ->
            put(Pkey, [{Type, Ref}]);
        List ->
            put(Pkey, [{Type, Ref} | List])
    end.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
