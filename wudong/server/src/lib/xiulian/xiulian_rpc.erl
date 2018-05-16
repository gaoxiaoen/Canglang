%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 二月 2016 下午9:04
%%%-------------------------------------------------------------------
-module(xiulian_rpc).
-author("fengzhenlin").

%% API
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    handle/3
]).

%%获取普通商店信息
handle(28000, Player, _) ->
    xiulian:get_xiulian_info(Player),
    ok;

%%购买商店商品
handle(28001, Player, {IsAuto}) ->
    case xiulian:xiulian_up(Player, IsAuto) of
		{false, 2}-> %%物品不足，客户端弹出不足面板
			goods_util:client_popup_goods_not_enough(Player,28400,1,130),
			{ok, Bin} = pt_280:write(28001, {2,0}),
			server_send:send_to_sid(Player#player.sid, Bin),
			ok;
        {false, Res} ->
            {ok, Bin} = pt_280:write(28001, {Res,0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, TupoRes} ->
            {ok, Bin} = pt_280:write(28001, {1,TupoRes}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%清CD
handle(28002, Player, _) ->
    case xiulian:clear_cd(Player) of
        {false, Res} ->
            {ok, Bin} = pt_280:write(28002, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_280:write(28002, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(_Cmd, _Player, _Data) ->
    ok.
