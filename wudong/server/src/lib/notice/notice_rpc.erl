%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十二月 2015 上午11:34
%%%-------------------------------------------------------------------
-module(notice_rpc).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("chat.hrl").

%% API
-export([
    handle/3
]).

%%获取所有公告内容
handle(49000, Player, {}) ->
    gen_server:cast(notice_proc:get_notice_pid(), {get_all_notice, Player#player.sid}),
    ok;

%%发喇叭
handle(49010, Player, {BugleType, Content, IsAuto}) ->
    {Ret, NewPlayer} = notice:use_bugle(Player, BugleType, Content, IsAuto),
    {ok, Bin} = pt_490:write(49010, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ?IF_ELSE(Ret == 1, chat:pack_chat_data(Player, ?CHAT_TYPE_PUBLIC, Content, "", 1), ok),
    {ok, NewPlayer};

%%获取广播状态信息
handle(49012, Player, {}) ->
    gen_server:cast(notice_proc:get_notice_pid(), {get_bugle_state_info, Player#player.sid}),
    ok;

handle(_cmd, _Player, _Data) ->
    ?ERR("unknow proto cmd ~p~n", [_cmd]),
    ok.