%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 八月 2016 16:52
%%%-------------------------------------------------------------------
-module(panic_buying_rpc).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
%% API
-export([handle/3]).

%% 获取活动状态
handle(15301, Player, {}) ->
    case config:get_open_days() > 3 of
        true ->
            cross_all:apply(panic_buying, check_state, [node(), Player#player.sid]),
            ok;
        false -> ok
    end;


%%获取一元夺宝物品列表
handle(15302, Player, {}) ->
    case config:get_open_days() > 3 of
        true ->
            cross_all:apply(panic_buying, check_goods_list, [node(), Player#player.key, Player#player.sid]),
            ok;
        false ->
            {ok, Bin} = pt_153:write(15302, {3, 0, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%查看往期记录
handle(15303, Player, {Type, Page}) ->
    cross_all:apply(panic_buying, review_goods_list, [node(), Player#player.sid, Type, Page]),
    ok;

%%查看我的订单
handle(15304, Player, {Page}) ->
    cross_all:apply(panic_buying, check_my_pay, [node(), Player#player.key, Player#player.sid, Page]),
    ok;

%%购买
handle(15305, Player, {Id, Num}) ->
    case config:get_open_days() > 3 of
        true ->
            case panic_buying:check_pay(Player, Num) of
                false ->
                    {ok, Bin} = pt_153:write(15305, {4}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                {true, PayList} ->
                    cross_all:apply(panic_buying, pay_goods, [node(), config:get_server_num(), Player#player.key, Player#player.pid, Player#player.nickname, Player#player.sid, Id, Num, PayList]),
                    ok
            end;
        false ->
            {ok, Bin} = pt_153:write(15305, {3}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

handle(_cmd, _Player, _Data) ->
    ok.




