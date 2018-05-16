%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 十二月 2016 17:55
%%%-------------------------------------------------------------------
-module(hp_pool_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
%% API
-export([handle/3]).

%%血池信息
handle(13201, Player, {}) ->
    Data = hp_pool:get_hp_pool(),
    {ok, Bin} = pt_132:write(13201, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%设置恢复阈值
handle(13202, Player, {Recover}) ->
    Ret = hp_pool:set_recover(Recover),
    {ok, Bin} = pt_132:write(13202, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%使用血包
handle(13203, Player, {GoodsId, Num}) ->
    Data = hp_pool:use_goods(Player, GoodsId, Num),
    {ok, Bin} = pt_132:write(13203, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%购买血包
handle(13204, Player, {GoodsId, Num}) ->
    {Ret, Hp, NewPlayer} = hp_pool:buy_goods(Player, GoodsId, Num),
    {ok, Bin} = pt_132:write(13204, {Ret, Hp}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%回复血量
handle(13205, _Player, {}) ->
    ok;
%%    {Ret, Hp, NewPlayer} = hp_pool:recover_hp(Player),
%%    {ok, Bin} = pt_132:write(13205, {Ret, Hp}),
%%    server_send:send_to_sid(Player#player.sid, Bin),
%%    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
    ok.
