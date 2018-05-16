%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 十一月 2015 17:21
%%%-------------------------------------------------------------------
-module(arena_handle).
-author("hxming").
-include("arena.hrl").
-include("common.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

%%竞技场购买次数
handle_call({arena_buy_times, Player}, _From, State) ->
    Ret = arena:buy_times(Player),
    {reply, Ret, State};

%%清除CD
handle_call({clean_cd, Player}, _From, State) ->
    Ret = arena:clean_cd(Player),
    {reply, Ret, State};

handle_call({get_rank_pkey, Pkey, MinRank, MaxRank}, _From, State) ->
    Ret = arena:get_rank_pkey(Pkey, MinRank, MaxRank),
    {reply, Ret, State};

handle_call({get_arena_rank, KeyList}, _From, State) ->
    Ret = arena:get_arena_rank(KeyList),
    {reply, Ret, State};

handle_call({get_arena_for_rank, Num}, _From, State) ->
    Data = arena:get_arena_for_rank(Num),
    {reply, Data, State};

handle_call({get_arena_info, Pkey}, _From, State) ->
    {reply, arena_init:get_arena(Pkey), State};


%%handle_call({rank_reward, Pkey, Id}, _from, State) ->
%%    Ret = arena:rank_reward(Pkey, Id),
%%    {reply, Ret, State};

%% 调用接口 player:apply
handle_call({apply, {Module, Function, Args}}, _From, State) ->
    case Module:Function(Args) of
        {ok, Reply} ->
            {reply, Reply, State};
        ok ->
            {reply, State};
        _Err ->
            ?ERR("ERR ~p~n", [_Err]),
            {noreply, State}
    end;

handle_call(_Request, _From, State) ->
    ?DEBUG("udef msg ~p~n", [_Request]),
    {reply, ok, State}.

%%竞技场信息
handle_cast({arena_info, Player, IsScoreReward}, State) ->
    arena:arena_info(Player, IsScoreReward),
    {noreply, State};

%%竞技场刷新
handle_cast({arena_refresh, Player}, State) ->
    arena:arena_refresh(Player),
    {noreply, State};

%%竞技场挑战
handle_cast({arena_challenge, Player, Pkey}, State) ->
    arena:arena_challenge(Player, Pkey),
    {noreply, State};

handle_cast({get_notice_player, Player, Pkey}, State) ->
    arena:get_notice_player(Player, Pkey),
    {noreply, State};

handle_cast({arena_log, Pkey, Sid}, State) ->
    arena:arena_log(Pkey, Sid),
    {noreply, State};

%%排行榜挑战
handle_cast({arena_rank_challenge, Player, Pkey}, State) ->
    arena:arena_rank_challenge(Player, Pkey),
    {noreply, State};

handle_cast({get_rank_list, Key, Sid, Page}, State) ->
    arena:get_rank_list(Key, Sid, Page),
    {noreply, State};


handle_cast({career, Pkey, Career}, State) ->
    case arena_init:get_arena(Pkey) of
        false -> skip;
        Arena ->
            NewArena = Arena#arena{career = Career},
            arena_init:set_arena(NewArena)
    end,
    {noreply, State};

%% 调用接口 player:apply
handle_cast({apply, {Module, Function, Args}}, State) ->
    case Module:Function(Args) of
        {ok, NewState} ->
            {noreply, NewState};
        ok ->
            {noreply, State};
        _Err ->
            {noreply, State}
    end;

handle_cast(_Request, State) ->
    ?DEBUG("udef msg ~p~n", [_Request]),
    {noreply, State}.


handle_info({load_arena}, State) ->
    arena_init:load_arena(),
    {noreply, State};

%%竞技场挑战结果
handle_info({arena_challenge_ret, PkeyA, NicknameA, PkeyB, NicknameB, Ret}, State) ->
    arena:arena_challenge_ret(PkeyA, NicknameA, PkeyB, NicknameB, Ret),
    {noreply, State};

%%竞技场每日奖励
handle_info({arena_daily_reward, NowTime}, State) ->
    arena:arena_daily_reward(NowTime),
    {noreply, State};

handle_info({init_robot}, State) ->
    arena_init:init_robot(),
    {noreply, State};

handle_info(timer_update, State) ->
    misc:cancel_timer(timer_update),
    arena_init:timer_update(),
    Ref = erlang:send_after(180 * 1000, self(), timer_update),
    put(timer_update, Ref),
    {noreply, State};

handle_info({cmd_rank, Pkey, Rank1}, State) ->
    case arena_init:get_arena(Pkey) of
        false -> ok;
        Arena ->
            RankDict = arena_init:get_rank(),
            case dict:is_key(Rank1, RankDict) of
                false -> ok;
                true ->
                    Key = dict:fetch(Rank1, RankDict),
                    if Key == Pkey -> ok;
                        true ->
                            case arena_init:get_arena(Key) of
                                false -> ok;
                                KeyArena ->
                                    NewArena = Arena#arena{rank = Rank1, challenge = []},
                                    arena_init:set_arena(NewArena),
                                    NewKeyArena = KeyArena#arena{rank = Arena#arena.rank, challenge = []},
                                    arena_init:set_arena(NewKeyArena),
                                    RankDict1 = dict:store(Rank1, Pkey, RankDict),
                                    RankDict2 = dict:store(Arena#arena.rank, Key, RankDict1),
                                    arena_init:set_rank(RankDict2)
                            end
                    end
            end
    end,
    {noreply, State};

%% 调用接口 player:apply
handle_info({apply, {Module, Function, Args}}, State) ->
    case Module:Function(Args) of
        {ok, NewState} ->
            {noreply, NewState};
        ok ->
            {noreply, State};
        _Err ->
            {noreply, State}
    end;

handle_info(_Msg, State) ->
    ?DEBUG("udef msg ~p~n", [_Msg]),
    {noreply, State}.