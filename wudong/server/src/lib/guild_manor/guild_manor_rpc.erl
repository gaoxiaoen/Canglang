%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 二月 2017 17:02
%%%-------------------------------------------------------------------
-module(guild_manor_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
%% API
-export([handle/3]).
%%家园总览
handle(40101, Player, {}) ->
    case guild_manor:manor_info(Player) of
        [] -> ok;
        Data ->
            {ok, Bin} = pt_401:write(40101, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%随从列表
handle(40102, Player, {}) ->
    Data = guild_manor:retinue_list(Player),
    {ok, Bin} = pt_401:write(40102, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%建筑任务信息
handle(40103, Player, {Type}) ->
    Data = guild_manor:building_task(Player, Type),
    {ok, Bin} = pt_401:write(40103, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%发布任务
handle(40104, Player, {Type, TaskId, RetinueKeys}) ->
    Ret = guild_manor:start_task(Player, Type, TaskId, RetinueKeys),
    {ok, Bin} = pt_401:write(40104, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%领取宝箱奖励
handle(40105, Player, {Type, Key}) ->
    {Ret, NewPlayer} = guild_manor:box_reward(Player, Type, Key),
    {ok, Bin} = pt_401:write(40105, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%获取商店列表
handle(40106, Player, {}) ->
    Data = guild_manor:shop_list(Player),
    {ok, Bin} = pt_401:write(40106, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%商店购买
handle(40107, Player, {GoodsId, Num}) ->
    {Ret, NewPlayer} = guild_manor:buy_goods(Player, GoodsId, Num),
    {ok, Bin} = pt_401:write(40107, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%激活随从
handle(40108, Player, {GoodsId}) ->
    Ret = guild_manor:activate_retinue(Player, GoodsId),
    {ok, Bin} = pt_401:write(40108, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%修正随从状态
handle(40109, Player, {Key}) ->
    {Ret,GoodsList, NewPlayer} = guild_manor:reset_retinue(Player, Key),
    {ok, Bin} = pt_401:write(40109, {Ret,GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%============end===============



handle(_cmd, _Player, _Data) ->
    ?DEBUG("cmd ~p~n",[_cmd]),
    ok.