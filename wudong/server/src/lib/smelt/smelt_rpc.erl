%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 二月 2017 17:44
%%%-------------------------------------------------------------------
-module(smelt_rpc).
-author("hxming").

-include("achieve.hrl").
-include("server.hrl").
-include("smelt.hrl").
%% API
-export([handle/3]).

%%熔炼信息
handle(15701, Player, {}) ->
    OpenLv = ?SMELT_OPEN_LV,
    if Player#player.lv >= OpenLv ->
        case smelt:smelt_info(Player) of
            [] -> ok;
            Data ->
                {ok, Bin} = pt_157:write(15701, Data),
                server_send:send_to_sid(Player#player.sid, Bin),
                ok
        end;
        true -> ok
    end;


%%熔炼
handle(15702, Player, {EquipKeyList}) ->
    OpenLv = ?SMELT_OPEN_LV,
    if Player#player.lv >= OpenLv ->
        {Ret, NewPlayer, Count} = smelt:smelt(Player, util:list_filter_repeat(EquipKeyList)),
        {ok, Bin} = pt_157:write(15702, {Ret}),
        server_send:send_to_sid(Player#player.sid, Bin),
        if Ret == 1 ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1008, 0, Count),
            {ok, attr, NewPlayer};
            true -> ok
        end;
        true -> ok
    end;

handle(_cmd, _player, _) ->
    ok.