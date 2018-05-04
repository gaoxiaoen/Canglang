%%----------------------------------------------------
%% 列表操作模块
%% 
%% @author qingxuan
%% @end
%%----------------------------------------------------
-module(lists2).
-export([
    rsort/1
]).

rsort(List) ->
    lists:reverse(lists:sort(List)).
  
