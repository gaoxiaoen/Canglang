%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. 二月 2017 19:41
%%%-------------------------------------------------------------------
-module(designation_rpc).
-author("hxming").


-include("common.hrl").
-include("server.hrl").

-export([handle/3]).

%%获取列表
handle(44001, Player, _) ->
    Data = designation:designation_list(Player),
    ?IF_ELSE(Player#player.key == 300010029, ?DEBUG("Data ~p~n", [Data]), skip),
    {ok, Bin} = pt_440:write(44001, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%使用
handle(44002, Player, {Type, DesignationId}) ->
    {Ret, NewPlayer} =
        case Type of
            1 ->
                designation:put_on_designation(Player, DesignationId);
            _ ->
                designation:put_off_designation(Player, DesignationId)
        end,
    {ok, Bin} = pt_440:write(44002, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, designation, NewPlayer};
        true -> ok
    end;

%%激活
handle(44003, Player, {DesignationId}) ->
    {Ret, NewPlayer} = designation:activate_designation(Player, DesignationId),
    {ok, Bin} = pt_440:write(44003, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true -> ok
    end;

%%升级
handle(44004, Player, {DesignationId}) ->
    {Ret, NewPlayer} = designation:upgrade_designation(Player, DesignationId),
    {ok, Bin} = pt_440:write(44004, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, attr, NewPlayer};

%%使用称号不激活
handle(44005, Player, {GoodsId}) ->
    case designation:activate_by_goods_1(Player, GoodsId) of
        {false, Res} ->
            {ok, Bin} = pt_440:write(44005, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        NewPlayer ->
            {ok, Bin} = pt_440:write(44005, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, attr, NewPlayer}
    end;


%%激活等级加成
handle(44007, Player, {DesignationId}) ->
    {Ret, NewPlayer} = designation:activation_stage_lv(Player, DesignationId),
    {ok, Bin} = pt_440:write(44007, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
    ?PRINT("ErrorCode ~p ~p~n", [_cmd, _Data]),
    ok.
