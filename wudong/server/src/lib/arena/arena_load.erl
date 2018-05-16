%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 十一月 2015 16:44
%%%-------------------------------------------------------------------
-module(arena_load).
-author("hxming").
-include("arena.hrl").
%% API
-compile(export_all).

%%加载竞技场数据
load_arena() ->
    Sql = "select pkey,type,realm,career,sex,rank,max_rank,times,reset_time,buy_times,cd ,wins,combo,reward,time ,rank_reward from arena",
    db:get_all(Sql).


replace_arena_sql(Arena) ->
    io_lib:format(<<"replace into arena set pkey = ~p,type = ~p,realm = ~p,career = ~p,sex=~p,rank = ~p,max_rank= ~p,times = ~p,reset_time =~p,buy_times = ~p,cd = ~p,wins = ~p,combo=~p,reward = '~s',time = ~p,rank_reward = '~s' ">>,
        [
            Arena#arena.pkey,
            Arena#arena.type,
            Arena#arena.realm,
            Arena#arena.career,
            Arena#arena.sex,
            Arena#arena.rank,
            Arena#arena.max_rank,
            Arena#arena.times,
            Arena#arena.reset_time,
            Arena#arena.buy_times,
            Arena#arena.cd,
            Arena#arena.wins,
            Arena#arena.combo,
            util:term_to_bitstring(Arena#arena.reward),
            Arena#arena.time,
            util:term_to_bitstring(Arena#arena.rank_reward)
        ]).


%%竞技场新增数据
replace_arena(Arena) when Arena#arena.type == ?ARENA_TYPE_PLAYER ->
    Sql = replace_arena_sql(Arena),
    db:execute(Sql);
replace_arena(_) -> ok.


clean_arena() ->
    db:execute("truncate arena ").


log_arena(Pkey, Ret, OldRank, NewRank, Time) ->
    Sql = io_lib:format(<<"insert into log_arena set pkey=~p,nickname='~s',ret=~p,old_rank=~p,new_rank=~p,`time`=~p">>,
        [Pkey, shadow_proc:get_name(Pkey), Ret, OldRank, NewRank, Time]),
    log_proc:log(Sql),
    ok.