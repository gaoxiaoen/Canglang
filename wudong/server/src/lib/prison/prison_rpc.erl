%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 九月 2016 17:26
%%%-------------------------------------------------------------------
-module(prison_rpc).
-author("hxming").

-include("server.hrl").
-include("common.hrl").

%% API
-export([handle/3]).

%%请求退出监狱
handle(12401, Player, {}) ->
    {Ret, NewPlayer} = prison:quit_prison(Player),
    {ok, Bin} = pt_124:write(12401, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%洗刷杀戮值
handle(12402, Player, {}) ->
    {Ret, NewPlayer} = prison:clean_evil(Player),
    {ok, Bin} = pt_124:write(12402, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%放狗
handle(12403, Player, {}) ->
    {Ret, NewPlayer} = prison:release_dog(Player),
    {ok, Bin} = pt_124:write(12403, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%贿赂
handle(12404, Player, {}) ->
    {Ret, NewPlayer} = prison:bribe(Player),
    {ok, Bin} = pt_124:write(12404, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
    ok.