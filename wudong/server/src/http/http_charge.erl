%% @author zj
%% @doc http 充值请求处理


-module(http_charge).
-include("common.hrl").
-include("server.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([
         notice/1
        ]).

%%充值通知
notice(QueryParam) ->
    Pkey = util:to_integer(proplists:get_value("pid", QueryParam)),
    case player_util:get_player_online(Pkey) of
        [] ->
            Ret = 0;
        OnlinePlayer ->
            OnlinePlayer#ets_online.pid ! 'recharge_notice',
            Ret = 1
    end,
    {ok,Ret}.


%% ====================================================================
%% Internal functions
%% ====================================================================


