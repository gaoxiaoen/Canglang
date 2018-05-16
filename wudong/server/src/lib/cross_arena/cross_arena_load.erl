%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 六月 2016 10:46
%%%-------------------------------------------------------------------
%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 十一月 2015 16:44
%%%-------------------------------------------------------------------
-module(cross_arena_load).
-author("hxming").
-include("cross_arena.hrl").
%% API
-compile(export_all).

%%加载竞技场数据
load_cross_arena() ->
    Sql = io_lib:format("select pkey,nickname,career,sex,lv,cbp,rank,shadow,time,vs from cross_arena where node = '~s'", [node()]),
    db:get_all(Sql).

select_shadow(Pkey) ->
    Sql = io_lib:format("select nickname,career,sex,lv,cbp,shadow from cross_arena where node = '~s' and pkey=~p", [node(), Pkey]),
    db:get_row(Sql).

insert_cross_arena(Arena) ->
    Shadow = shadow_init:player_to_backup(Arena#cross_arena.shadow),
    Sql = io_lib:format(<<"insert into cross_arena set pkey = ~p,node = '~s',nickname = '~s',career = ~p,sex=~p,lv=~p,cbp=~p,rank = ~p,shadow = '~s',time = ~p ,vs=~p">>,
        [
            Arena#cross_arena.pkey,
            node(),
            Arena#cross_arena.nickname,
            Arena#cross_arena.career,
            Arena#cross_arena.sex,
            Arena#cross_arena.lv,
            Arena#cross_arena.cbp,
            Arena#cross_arena.rank,
            util:term_to_bitstring(Shadow),
            Arena#cross_arena.time,
            Arena#cross_arena.vs
        ]),
    db:execute(Sql).

update_cross_arena(Arena) ->
    Shadow = shadow_init:player_to_backup(Arena#cross_arena.shadow),
    Sql = io_lib:format(<<"update cross_arena set nickname = '~s',career = ~p,sex=~p,lv=~p,cbp=~p,rank = ~p,shadow = '~s',time = ~p,vs=~p where pkey = ~p and node = '~s' ">>,
        [
            Arena#cross_arena.nickname,
            Arena#cross_arena.career,
            Arena#cross_arena.sex,
            Arena#cross_arena.lv,
            Arena#cross_arena.cbp,
            Arena#cross_arena.rank,
            util:term_to_bitstring(Shadow),
            Arena#cross_arena.time,
            Arena#cross_arena.vs,
            Arena#cross_arena.pkey,
            node()
        ]),
    db:execute(Sql).

clean_cross_arena() ->
    db:execute("truncate cross_arena ").

%%玩家次数信息
load_arena_mb(Pkey) ->
    Sql = io_lib:format("select times,reset_time,buy_times,in_cd,cd,time ,score,score_reward from cross_arena_mb where pkey = ~p", [Pkey]),
    db:get_row(Sql).

%%更新玩家次数信息
replace_arena_mb(Mb) ->
    Sql = io_lib:format("replace into cross_arena_mb set pkey = ~p,times = ~p,reset_time=~p,buy_times=~p,in_cd=~p,cd=~p,time =~p,score=~p,score_reward='~s'",
        [Mb#cross_arena_mb.pkey,
            Mb#cross_arena_mb.times,
            Mb#cross_arena_mb.reset_time,
            Mb#cross_arena_mb.buy_times,
            Mb#cross_arena_mb.in_cd,
            Mb#cross_arena_mb.cd,
            Mb#cross_arena_mb.time,
            Mb#cross_arena_mb.score,
            util:term_to_bitstring(Mb#cross_arena_mb.score_reward)
        ]),
    db:execute(Sql).