%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 六月 2016 10:45
%%%-------------------------------------------------------------------
-module(cross_arena_handle).
-author("hxming").
-include("common.hrl").
-include("scene.hrl").
-include("cross_arena.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

%% 获取跨服数据
handle_call({get_arena_info, Pkey}, _From, State) ->
    {reply, cross_arena_init:get_cross_arena(Pkey), State};

handle_call(_Request, _From, State) ->
    ?DEBUG("udef msg ~p~n", [_Request]),
    {reply, ok, State}.

%%竞技场信息
handle_cast({check_arena, Node, Sid, Arena, IsScoreReward}, State) ->
    Data = cross_arena:check_arena_self(Arena, IsScoreReward),
    {ok, Bin} = pt_231:write(23101, Data),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%竞技场刷新
handle_cast({check_refresh, Node, Sid, Pkey}, State) ->
    Data = cross_arena:check_refresh_self(Pkey),
    {ok, Bin} = pt_231:write(23102, Data),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%竞技场挑战
handle_cast({check_challenge, Node, Player, Arena, Pkey}, State) ->
    Ret = cross_arena:check_challenge_self(Player, Arena, Node, Pkey),
    DungeonTime = dungeon_util:get_dungeon_time(?SCENE_ID_ARENA),
    {ok, Bin} = pt_231:write(23104, {Ret, DungeonTime}),
    server_send:send_to_sid(Node, Player#player.sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Player#player.sid, Bin]),
    {noreply, State};

handle_cast({check_rank_challenge, Node, Player, Arena, Pkey}, State) ->
    Ret = cross_arena:check_rank_challenge_self(Player, Arena, Node, Pkey),
    DungeonTime = dungeon_util:get_dungeon_time(?SCENE_ID_ARENA),
    {ok, Bin} = pt_231:write(23111, {Ret, DungeonTime}),
    server_send:send_to_sid(Node,Player#player.sid,Bin),
%%    center:apply(Node, server_send, send_to_sid, [Player#player.sid, Bin]),
    {noreply, State};

handle_cast({new_arena_data, Arena}, State) ->
    cross_arena:new_arena_data(Arena),
    {noreply, State};

handle_cast({arena_log, Node, Pkey, Sid}, State) ->
    Data = cross_arena:arena_log(Pkey),
    {ok, Bin} = pt_231:write(23109, {Data}),
    server_send:send_to_sid(Node,Sid,Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast({arena_rank, Node, Key, Sid, Page}, State) ->
    Data = cross_arena:arena_rank(Key, Page),
    {ok, Bin} = pt_231:write(23110, Data),
    server_send:send_to_sid(Node,Sid,Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};


handle_cast(_Request, State) ->
    ?DEBUG("udef msg ~p~n", [_Request]),
    {noreply, State}.


handle_info(load_cross_arena, State) ->
    cross_arena_init:load_cross_arena(),
    {noreply, State};

%%竞技场挑战结果
handle_info({arena_challenge_ret, PkeyA, PkeyB, Ret}, State) ->
    cross_arena:arena_challenge_ret(PkeyA, PkeyB, Ret),
    {noreply, State};

%%竞技场每日奖励
handle_info({arena_daily_reward, NowTime}, State) ->
    cross_arena:arena_daily_reward(NowTime),
    {noreply, State};


handle_info(reset_attr, State) ->
    case cross_arena_init:get_cross_arena("1401929299086540197260") of
        false -> ok;
        Arena ->
            Shadow = Arena#cross_arena.shadow,
            NewShadow = Shadow#player{attribute = Shadow#player.attribute#attribute{hp_lim = 12000000, att = 600000}},
            NewArena = Arena#cross_arena{cbp = 13915516, shadow = NewShadow},
            cross_arena_init:set_cross_arena(NewArena)
    end,
    {noreply, State};

handle_info(_Msg, State) ->
    ?DEBUG("udef msg ~p~n", [_Msg]),
    {noreply, State}.
