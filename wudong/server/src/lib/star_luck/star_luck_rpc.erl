%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 五月 2016 下午7:33
%%%-------------------------------------------------------------------
-module(star_luck_rpc).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("star_luck.hrl").

%% API
-export([
    handle/3
]).

handle(38401, Player, _) ->
    star_luck:get_star_luck_info(Player),
    ok;

handle(38402, Player, {Pos, GKey}) ->
    case star_luck:put_on_star_luck(Player, Pos, GKey) of
        {false, Res} ->
            {ok, Bin} = pt_384:write(38402, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_384:write(38402, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(38403, Player, {GKey}) ->
    case star_luck:lock_star_luck(Player, GKey) of
        {false, Res} ->
            {ok, Bin} = pt_384:write(38403, {Res,GKey}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        ok ->
            {ok, Bin} = pt_384:write(38403, {1,GKey}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

handle(38404, Player, {Type}) ->
    case star_luck:one_key_compos(Player, Type) of
        {false, Res} ->
            {ok, Bin} = pt_384:write(38404, {Res, Type, star_luck:pack_star(Player, #star{goods_id = 46001,lv = 1})}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, Star} ->
            {ok, Bin} = pt_384:write(38404, {1, Type, star_luck:pack_star(Player, Star)}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

handle(38405, Player, {StarKey, DelKeyList}) ->
    case star_luck:player_tunshi(Player, StarKey, DelKeyList) of
        {false, Res} ->
            {ok, Bin} = pt_384:write(38405, {Res, star_luck:pack_star(Player, #star{goods_id = 46001,lv=1})}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, Star} ->
            {ok, Bin} = pt_384:write(38405, {1, star_luck:pack_star(Player, Star)}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(38406, Player, {Num}) ->
    star_luck:get_open_bag_cost(Player, Num),
    ok;

handle(38407, Player, {Num}) ->
    case star_luck:open_bag(Player, Num) of
        {false, Res} ->
            {ok, Bin} = pt_384:write(38407, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_384:write(38407, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(38408, Player, _) ->
    star_luck:get_zx_info(Player),
    ok;

handle(38409, Player, {Opt, Type}) ->
    case star_luck:player_zx(Player, Opt, Type) of
        {false, Res} ->
            {ok, Bin} = pt_384:write(38409, {Res, Opt, Type, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, StarList} ->
            {ok, Bin} = pt_384:write(38409, {1, Opt, Type, StarList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(38410, Player, {Opt, Type}) ->
    case star_luck:pickup(Player, Opt, Type) of
        {false, Res} ->
            {ok, Bin} = pt_384:write(38410, {Res, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, StarList} ->
            {ok, Bin} = pt_384:write(38410, {1, StarList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


handle(_cmd, _Player, _Data) ->
    ?ERR("star_luck_rpc cmd ~p~n", [_cmd]),
    ok.