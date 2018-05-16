%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 七月 2017 17:07
%%%-------------------------------------------------------------------
-module(god_treasure_rpc).
-author("hxming").



-include("common.hrl").
-include("server.hrl").
-include("god_treasure.hrl").

%% API
-export([handle/3]).

handle(65301, Player, {}) ->
    Data = god_treasure:get_god_treasure_info(),
    {ok, Bin} = pt_653:write(65301, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%升阶
handle(65302, Player, {Auto}) ->
    case god_treasure:upgrade_stage(Player, Auto) of
        {ok, Code, NewPlayer} ->
            {ok, Bin} = pt_653:write(65302, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, god_treasure, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_653:write(65302, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%%%切换外观
handle(65303, Player, {Figure}) ->
    {Ret, NewPlayer} = god_treasure:change_figure(Player, Figure),
    {ok, Bin} = pt_653:write(65303, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, god_treasure, NewPlayer};

%%激活技能
handle(65304, Player, {Cell}) ->
    {Ret, NewPlayer} = god_treasure_skill:activate_skill(Player, Cell),
    {ok, Bin} = pt_653:write(65304, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%升级技能
handle(65305, Player, {Cell}) ->
    {Ret, NewPlayer} = god_treasure_skill:upgrade_skill(Player, Cell),
    {ok, Bin} = pt_653:write(65305, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%更新技能列表
handle(65306, Player, {}) ->
    GoldenBody = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
    Data = god_treasure_skill:get_god_treasure_skill_list(GoldenBody#st_god_treasure.skill_list),
    {ok, Bin} = pt_653:write(65306, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%装备物品
handle(65307, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = god_treasure:equip_goods(Player, GoodsKey),
    {ok, Bin} = pt_653:write(65307, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%% 使用神兵成长丹
handle(65308, Player, {}) ->
    case god_treasure:use_god_treasure_dan(Player) of
        {false, Ret} ->
            {ok, Bin} = pt_653:write(65308, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_653:write(65308, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%领取外观
handle(65309, Player, {}) ->
    NewPlayer = god_treasure_init:activate(Player),
    {ok, Bin} = pt_653:write(65309, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};



handle(65310, Player, {}) ->
    Data = god_treasure_spirit:spirit_info(),
    {ok, Bin} = pt_653:write(65310, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(65311, Player, {}) ->
    {Ret, NewPlayer} = god_treasure_spirit:spirit_upgrade(Player),
    {ok, Bin} = pt_653:write(65311, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attrs, NewPlayer};
        true -> ok
    end;


handle(_cmd, _player, _data) ->
    ok.
