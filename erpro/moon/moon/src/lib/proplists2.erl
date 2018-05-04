%%----------------------------------------------------
%% 属性列表操作模块
%% 
%% @author qingxuan
%% @end
%%----------------------------------------------------
-module(proplists2).
-export([
    group/2
]).

group(List, N) ->
    group(lists:keysort(N, List), N, [], what_ever, []).
  
group([H|T], N, L, _LastKey, []) ->
    group(T, N, L, erlang:element(N, H), [H]);
group([H|T], N, L, LastKey, Acc) ->
    case erlang:element(N, H) of
        LastKey ->
            group(T, N, L, LastKey, [H|Acc]);
        Key ->
            group(T, N, [{LastKey, Acc}|L], Key, [H])
    end;
group([], _N, L, _LastKey, []) ->
    L;
group([], _N, L, LastKey, Acc) ->
    [{LastKey, Acc}|L].

