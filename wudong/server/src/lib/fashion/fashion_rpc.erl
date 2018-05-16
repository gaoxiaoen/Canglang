%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 一月 2015 下午3:55
%%%-------------------------------------------------------------------
-module(fashion_rpc).
-author("fancy").
-include("common.hrl").
-include("server.hrl").

-export([handle/3]).

%%获取时装列表
handle(33001, Player, _) ->
    Data = fashion:fashion_list(Player),
    {ok, Bin} = pt_330:write(33001, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%使用时装
handle(33002, Player, {Type, FashionId}) ->
    {Ret, NewPlayer} =
        case Type of
            0 ->
                fashion:put_off_fashion(Player, FashionId);
            _1 ->
                fashion:use_fashion(Player, FashionId)
        end,
    {ok, Bin} = pt_330:write(33002, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, fashion, NewPlayer};
        true -> ok
    end;

%%激活
handle(33003, Player, {FashionId}) ->
    {Ret, NewPlayer} = fashion:activate_fashion(Player, FashionId),
    {ok, Bin} = pt_330:write(33003, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, fashion, NewPlayer};
        true -> ok
    end;

%%升级
handle(33004, Player, {FashionId}) ->
    {Ret, NewPlayer} = fashion:upgrade_fashion(Player, FashionId),
    {ok, Bin} = pt_330:write(33004, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%获取赠送列表
handle(33006, Player, {}) ->
    Data = fashion:get_present_list(),
    {ok, Bin} = pt_330:write(33006, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%时装赠送
handle(33007, Player, {Pkey, Gkey, Content}) ->
    case fashion:present_fashion(Player, Pkey, Gkey, Content) of
        {false, Res} ->
            {ok, Bin} = pt_330:write(33007, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        ok ->
            {ok, Bin} = pt_330:write(33007, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%表示感谢
handle(33009, Player, {Pkey}) ->
    case player_util:get_player_online(Pkey) of
        [] ->
            {ok, Bin} = pt_330:write(33009, {14}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        OnLine ->
            {ok, Bin1} = pt_330:write(33009, {1}),
            server_send:send_to_sid(Player#player.sid, Bin1),
            OtherPlayer = relation:get_player_info(Player, Player#player.key),
            {ok, Bin33010} = pt_330:write(33010, OtherPlayer),
            server_send:send_to_sid(OnLine#ets_online.sid, Bin33010),
            ok
    end;


%%激活等级加成
handle(33011, Player, {FashionId}) ->
    {Ret, NewPlayer} = fashion:activation_stage_lv(Player, FashionId),
    {ok, Bin} = pt_330:write(33011, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
    ?PRINT("ErrorCode ~p ~p~n", [_cmd, _Data]),
    ok.
