%%%-------------------------------------------------------------------
%%% @author lzx
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 九月 2017 15:02
%%%-------------------------------------------------------------------
-module(dvip_rpc).
-author("lzx").

-include("common.hrl").
-include("server.hrl").

%% API
-export([handle/3]).

%% @doc 钻石vip信息
handle(40401, Player, {}) ->
    dvip:send_d_info(Player),
    ok;



%% @doc 请求成为永久vip信息
handle(40402, Player, {}) ->
    dvip:get_f_vip(Player),
    ok;




%% @doc
handle(40403, Player, {}) ->
    case catch dvip:get_today_award(Player) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [160], true),
            {ok, Bin} = pt_404:write(40403, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {fail, Res} ->
            ?PRINT("40403 =============== >>> Res ~w",[Res]),
            {ok, Bin} = pt_404:write(40403, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%% @doc
handle(40404, Player, {}) ->
    case catch dvip:buy_dvip(Player) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [160], true),
            {ok, Bin} = pt_404:write(40404, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {fail, Res} ->
            {ok, Bin} = pt_404:write(40404, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%% @doc 请求钻石商城信息
handle(40405, Player, {}) ->
    dvip:get_diamond_market_info(Player),
    ok;



%% 积分兑换
handle(40406, Player, {ExCellId,ExNum}) ->
    case catch dvip:exchange_diamond_market(Player, ExCellId,ExNum) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [160], true),
            Res = 1;
        {fail, Res} ->
            NewPlayer = Player
    end,
    {ok, Bin} = pt_404:write(40406, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%
%% @doc 元宝兑换信息
handle(40407, Player, {}) ->
    dvip:get_gold_exchange_info(Player),
    ok;


%% @doc 元宝兑换信息
handle(40408, Player, {ExTime}) ->
    case catch dvip:exchange_gold(Player, ExTime) of
        {ok, NewPlayer} ->
%%            activity:get_notice(NewPlayer, [160], true),
            Res = 1;
        {fail, Res} ->
            NewPlayer = Player
    end,
    {ok, Bin} = pt_404:write(40408, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% @doc 进阶丹兑换信息
handle(40409, Player, {}) ->
    dvip:get_step_exchange_info(Player),
    ok;


%% @doc 进阶丹兑换
handle(40410, Player, {Index,Num}) ->
    case catch dvip:exchange_step_goods(Player, Index,Num) of
        {ok, NewPlayer} ->
%%            activity:get_notice(NewPlayer, [160], true),
            Res = 1;
        {fail, Res} ->
            NewPlayer = Player
    end,
    {ok, Bin} = pt_404:write(40410, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


handle(_CMD, _Player, _Bin) ->
    ?ERR("_Cmd not match ~w",[_CMD]),
    ok.







