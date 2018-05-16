%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 十一月 2017 17:53
%%%-------------------------------------------------------------------
-module(first_login).
-author("Administrator").
-include("server.hrl").
%% API
-export([init/1]).


init(Player) ->
    Lan = version:get_lan_config(),
    if
        Lan == bt ->
            Sql0 = io_lib:format("select state from player_first_login_gift where pkey=~p", [Player#player.key]),
            case db:get_row(Sql0) of
                [State] ->
                    if
                        State == 1 -> skip;
                        true ->
                            Sql = io_lib:format("replace into player_first_login_gift set state=1 ,pkey =~p ", [Player#player.key]),
                            db:execute(Sql),
                            Goodsist = data_version_different:get(1),
                            Sum = lists:sum([Num || {Id, Num} <- Goodsist, Id == 10106]),
                            Player#player.pid ! {give_goods, [{Id0, Num0} || {Id0, Num0} <- Goodsist, Id0 /= 10106], 319},
                            util:sleep(1000), Player#player.pid ! {add_bgold, Sum, 319}
                    end;
                _ ->
                    Sql = io_lib:format("replace into player_first_login_gift set state=1 ,pkey =~p ", [Player#player.key]),
                    db:execute(Sql),
                    Goodsist = data_version_different:get(1),
                    Sum = lists:sum([Num || {Id, Num} <- Goodsist, Id == 10106]),
                    Player#player.pid ! {give_goods, [{Id0, Num0} || {Id0, Num0} <- Goodsist, Id0 /= 10106], 319},
                    util:sleep(1000), Player#player.pid ! {add_bgold, Sum, 319}
            end;
        true -> skip
    end,
    ok.