%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 二月 2016 下午2:25
%%%-------------------------------------------------------------------
-module(yuanli_rpc).
-author("fengzhenlin").

-include("common.hrl").
-include("server.hrl").

%% API
-export([
    handle/3
]).

%%获取普通商店信息
handle(29000, Player, _) ->
    yuanli:get_yuanli_info(Player),
    ok;

%%购买商店商品
handle(29001, Player, {IsAuto}) ->
    case yuanli:yuanli_up(Player, IsAuto) of
		{false, 2} ->  %%物品不足，客户端弹出不足面板
			goods_util:client_popup_goods_not_enough(Player,28400,1,130),
			{ok, Bin} = pt_290:write(29001, {2,0}),
			server_send:send_to_sid(Player#player.sid, Bin),
			ok;
        {false, Res} ->
            {ok, Bin} = pt_290:write(29001, {Res,0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, TupoRes} ->
            {ok, Bin} = pt_290:write(29001, {1,TupoRes}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%清CD
handle(29002, Player, _) ->
    case yuanli:clear_cd(Player) of
        {false, Res} ->
            {ok, Bin} = pt_290:write(29002, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_290:write(29002, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(_Cmd, _Player, _Data) ->
    ok.
