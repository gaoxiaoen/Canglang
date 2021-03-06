%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_arena_rank_reward
	%%% @Created : 2017-01-06 10:27:59
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_arena_rank_reward).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").
-include("arena.hrl").

    ids() ->
    [1,2,3,4,5,6,7,8,9,10,11,12,13].

    get(1) ->[1,1,[{10106,500},{10299,50},{10109,50000},{27057,10}]];
    get(2) ->[2,3,[{10106,300},{10299,50},{10109,50000},{27057,5}]];
    get(3) ->[4,5,[{10106,200},{10299,50},{10109,50000},{27057,5}]];
    get(4) ->[6,10,[{10106,100},{10299,50},{10109,50000},{27050,5}]];
    get(5) ->[11,20,[{10106,100},{10299,50},{10109,50000},{27050,3}]];
    get(6) ->[21,50,[{10106,100},{10299,50},{10109,50000},{27050,3}]];
    get(7) ->[51,100,[{10106,100},{10299,50},{10109,50000},{27050,2}]];
    get(8) ->[101,200,[{10106,100},{10299,50},{10109,50000},{27050,2}]];
    get(9) ->[201,500,[{10106,100},{10299,50},{10109,50000},{27050,1}]];
    get(10) ->[501,1000,[{10106,100},{10299,50},{10109,50000},{27050,1}]];
    get(11) ->[1001,2000,[{10106,100},{10299,50},{10109,50000},{27050,1}]];
    get(12) ->[2001,3000,[{10106,100},{10299,50},{10109,50000},{27050,1}]];
    get(13) ->[3001,5000,[{10106,100},{10299,50},{10109,50000},{27050,1}]];get(_) -> [].