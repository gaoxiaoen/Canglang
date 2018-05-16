%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 一月 2015 下午2:03
%%%-------------------------------------------------------------------
-module(mail_rpc).
-author("fancy").

-include("server.hrl").
-include("common.hrl").
%% API
-export([handle/3]).


handle(19001, Player, _) ->
    mail:get_mail_list(Player),
    ok;

handle(19002, Player, {Mkey}) ->
    mail:get_mail_content(Player, Mkey),
    ok;

handle(19003, Player, {Mkey}) ->
    mail:delete_mail(Player, Mkey),
    ok;

handle(19004, Player, {Mkey}) ->
    case catch mail:get_mail_goods(Player, Mkey) of
        {ok, Player2} ->
            {ok, Bin} = pt_190:write(19004, {1, Mkey}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, Player2};
        {false, Code} ->
            {ok, Bin} = pt_190:write(19004, {Code, Mkey}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%提取全部邮件附件
handle(19005, Player, {}) ->
    {Ret, KeyList, NewPlayer} = mail:get_mail_goods_all(Player),
    {ok, Bin} = pt_190:write(19005, {Ret, KeyList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%一键删除
handle(19006, Player, {}) ->
    {Ret, KeyList} = mail:delete_mail_all(Player),
    {ok, Bin} = pt_190:write(19006, {Ret, KeyList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(_cmd, _Player, _Data) ->
    ok.
