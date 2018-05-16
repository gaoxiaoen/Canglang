%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 八月 2016 11:39
%%%-------------------------------------------------------------------
-module(shadow_proc).
-author("hxming").

%% API
-behaviour(gen_server).

-include("server.hrl").
-include("common.hrl").

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

-record(state, {
    power_dict = dict:new()
}).

%% API
-export([
    start_link/0
    , get_server_pid/0
    , get_shadow/1
    , get_shadow/2
    , set/1
    , match_shadow_by_cbp/4
    , get_name/1
    , cbp_percent/1
    , syc_cross/1
    , cross_set/1
]).
-export([cmd_cross_arena/0]).


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


%%创建
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

get_shadow(Pkey) ->
    get_shadow(Pkey, node()).

get_shadow(Pkey, Node) ->
    shadow_init:get_shadow(Pkey, Node).

syc_cross(Player) ->
    cross_all:apply(shadow_proc, cross_set, [Player]).


set(Player) ->
    if Player#player.lv >= 30 andalso Player#player.cbp > 0 ->
        NewPlayer = shadow_init:init_shadow(Player),
        cross_arena:add_new_arena(Player),
        ?CAST(?MODULE, {set_shadow, NewPlayer});
        true -> skip
    end.

%%存储跨服镜像
cross_set(Player) ->
    ?CAST(?MODULE, {set_cross_shadow, Player}),
    ok.

%%FilterList 需要过滤的玩家KEY列表
match_shadow_by_cbp(Power, Amount, FilterList,Lv) ->
    ?CALL(?MODULE, {match_shadow_by_cbp, Power, Amount, FilterList,Lv}).

%%获取玩家名字
get_name(Pkey) ->
    Shadow = get_shadow(Pkey),
    Shadow#player.nickname.

%%获取战力百分比
cbp_percent(Power) ->
    ?CALL(?MODULE, {cbp_percent, Power}).

cmd_cross_arena() ->
    ?CAST(?MODULE, cmd_cross_arena).

init([]) ->
    case center:is_center_all() of
        false ->
            erlang:send_after(1000, self(), load_shadow);
        true ->
            erlang:send_after(1000, self(), load_cross_shadow)
    end,
    {ok, #state{}}.


handle_call({get_shadow, Pkey}, _From, State) ->
    Shadow = shadow_init:get_shadow(Pkey,node()),
    {reply, Shadow, State};

%%战力匹配玩家
handle_call({match_shadow_by_cbp, Power, Amount, FilterList,Lv}, _From, State) ->
    ShadowList = shadow_init:priv_match_shadow_by_cbp(State#state.power_dict, Power, Amount, FilterList,Lv),
    {reply, ShadowList, State};

%%获取战力领先百分比
handle_call({cbp_percent, Power}, _From, State) ->
    Index = shadow_init:cbp_index(Power),
    F = fun({Key, Val}, {Count, Total}) ->
        Len = length(Val),
        if Index > Key ->
            {Count + Len, Total + Len};
            true ->
                {Count, Total + Len}
        end
        end,
    {NewCount, NewTotal} = lists:foldl(F, {0, 0}, dict:to_list(State#state.power_dict)),
    {reply, util:floor(NewCount / (NewTotal + 1) * 100), State};


handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast({set_shadow, Shadow}, State) ->
    cache:set({shadow,Shadow#player.key},Shadow,?FIFTEEN_MIN_SECONDS),
    Dict = shadow_init:update_cbp_index(State#state.power_dict, Shadow#player.key, Shadow#player.cbp,Shadow#player.lv),
    {noreply, State#state{power_dict = Dict}};


handle_cast({set_cross_shadow, Shadow}, State) ->
    cache:set({shadow,Shadow#player.key},Shadow,?FIFTEEN_MIN_SECONDS),
    shadow_init:player_to_shadow_backup(Shadow),
    Dict = shadow_init:update_cbp_index(State#state.power_dict, Shadow#player.key, Shadow#player.cbp,Shadow#player.lv),
    {noreply, State#state{power_dict = Dict}};


handle_cast(cmd_cross_arena, State) ->
    F = fun({_, Keys}) -> Keys end,
    List = lists:flatmap(F, dict:to_list(State#state.power_dict)),
    F1 = fun(_, L) ->
        case L of
            [] -> L;
            [Key | T] ->
                Shadow = shadow_init:get_shadow(Key,node()),
                cross_arena:add_new_arena(Shadow),
                T
        end
         end,
    lists:foldl(F1, List, lists:seq(1, 1000)),
    {noreply, State};

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(load_shadow, State) ->
    Dict = shadow_init:load_shadow(State#state.power_dict),
    {noreply, State#state{power_dict = Dict}};

handle_info(load_cross_shadow, State) ->
    Dict = shadow_init:load_cross_shadow(State#state.power_dict),
    {noreply, State#state{power_dict = Dict}};

handle_info(_Request, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
