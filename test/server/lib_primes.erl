%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 生成指定数字内的所有质数
%%% @end
%%% Created : 09. 五月 2018 14:35
%%%-------------------------------------------------------------------
-module(lib_primes).
-author("Administrator").

%% API
-export([make_prime/1]).

primes(Prime, Max, Primes,Integers) when Prime > Max ->
    lists:reverse([Prime|Primes]) ++ Integers;
primes(Prime, Max, Primes, Integers) ->
    [NewPrime|NewIntegers] = [ X || X <- Integers, X rem Prime =/= 0 ],
    primes(NewPrime, Max, [Prime|Primes], NewIntegers).

make_prime(N) ->
    primes(2, round(math:sqrt(N)), [], lists:seq(3,N,2)). % skip odds