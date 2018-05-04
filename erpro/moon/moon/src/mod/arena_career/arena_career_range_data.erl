%% *********************
%% 中庭战神取对手方差数据
%% *********************
-module(arena_career_range_data).
-export([
    get/2
]).

get(_Rank, 0) when _Rank =< 10 -> 1; 
get(_Rank, 1) when _Rank =< 10 -> 1; 
get(_Rank, 2) when _Rank =< 10 -> 1; 
get(_Rank, 3) when _Rank =< 10 -> 1; 
get(_Rank, 4) when _Rank =< 10 -> 1; 
get(_Rank, 5) when _Rank =< 10 -> 1; 
get(_Rank, 0) when _Rank =< 100 -> 1; 
get(_Rank, 1) when _Rank =< 100 -> 2; 
get(_Rank, 2) when _Rank =< 100 -> 3; 
get(_Rank, 3) when _Rank =< 100 -> 3; 
get(_Rank, 4) when _Rank =< 100 -> 3; 
get(_Rank, 5) when _Rank =< 100 -> 3; 
get(_Rank, 0) when _Rank =< 300 -> 3; 
get(_Rank, 1) when _Rank =< 300 -> 5; 
get(_Rank, 2) when _Rank =< 300 -> 10; 
get(_Rank, 3) when _Rank =< 300 -> 15; 
get(_Rank, 4) when _Rank =< 300 -> 15; 
get(_Rank, 5) when _Rank =< 300 -> 15; 
get(_Rank, 0) when _Rank =< 500 -> 3; 
get(_Rank, 1) when _Rank =< 500 -> 5; 
get(_Rank, 2) when _Rank =< 500 -> 10; 
get(_Rank, 3) when _Rank =< 500 -> 20; 
get(_Rank, 4) when _Rank =< 500 -> 20; 
get(_Rank, 5) when _Rank =< 500 -> 20; 
get(_Rank, 0) when _Rank =< 1000 -> 3; 
get(_Rank, 1) when _Rank =< 1000 -> 5; 
get(_Rank, 2) when _Rank =< 1000 -> 10; 
get(_Rank, 3) when _Rank =< 1000 -> 20; 
get(_Rank, 4) when _Rank =< 1000 -> 30; 
get(_Rank, 5) when _Rank =< 1000 -> 30; 
get(_Rank, 0) when _Rank =< 3000 -> 5; 
get(_Rank, 1) when _Rank =< 3000 -> 10; 
get(_Rank, 2) when _Rank =< 3000 -> 20; 
get(_Rank, 3) when _Rank =< 3000 -> 30; 
get(_Rank, 4) when _Rank =< 3000 -> 50; 
get(_Rank, 5) when _Rank =< 3000 -> 50; 
get(_Rank, 0) when _Rank =< 5000 -> 10; 
get(_Rank, 1) when _Rank =< 5000 -> 20; 
get(_Rank, 2) when _Rank =< 5000 -> 30; 
get(_Rank, 3) when _Rank =< 5000 -> 50; 
get(_Rank, 4) when _Rank =< 5000 -> 75; 
get(_Rank, 5) when _Rank =< 5000 -> 100; 
get(_Rank, 0) -> 20; 
get(_Rank, 1) -> 40; 
get(_Rank, 2) -> 60; 
get(_Rank, 3) -> 100; 
get(_Rank, 4) -> 150; 
get(_Rank, 5) -> 200; 
get(_, _) ->1.

