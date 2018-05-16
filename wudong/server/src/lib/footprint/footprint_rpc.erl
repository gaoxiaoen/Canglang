%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 15:16
%%%-------------------------------------------------------------------
-module(footprint_rpc).
-author("hxming").


-include("common.hrl").
-include("server.hrl").
-include("footprint_new.hrl").

%% API
-export([handle/3]).

handle(33101, Player, {}) ->
    Data = footprint:get_footprint_info(),
    {ok, Bin} = pt_331:write(33101, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%升阶
handle(33102, Player, {Auto}) ->
    case footprint:upgrade_stage(Player, Auto) of
        {ok, Code, NewPlayer} ->
            {ok, Bin} = pt_331:write(33102, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, footprint, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_331:write(33102, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%切换外观
handle(33103, Player, {Figure}) ->
    {Ret, NewPlayer} = footprint:change_figure(Player, Figure),
    {ok, Bin} = pt_331:write(33103, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, footprint, NewPlayer};

%%激活技能
handle(33104, Player, {Cell}) ->
    {Ret, NewPlayer} = footprint_skill:activate_skill(Player, Cell),
    {ok, Bin} = pt_331:write(33104, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%升级技能
handle(33105, Player, {Cell}) ->
    {Ret, NewPlayer} = footprint_skill:upgrade_skill(Player, Cell),
    {ok, Bin} = pt_331:write(33105, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%更新技能列表
handle(33106, Player, {}) ->
    Footprint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    Data = footprint_skill:get_footprint_skill_list(Footprint#st_footprint.skill_list),
    {ok, Bin} = pt_331:write(33106, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%装备物品
handle(33107, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = footprint:equip_goods(Player, GoodsKey),
    {ok, Bin} = pt_331:write(33107, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%% 使用神兵成长丹
handle(33108, Player, {}) ->
    case footprint:use_footprint_dan(Player) of
        {false, Ret} ->
            {ok, Bin} = pt_331:write(33108, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_331:write(33108, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%领取外观
handle(33109, Player, {}) ->
    NewPlayer = footprint_init:activate(Player),
    {ok, Bin} = pt_331:write(33109, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


handle(33110, Player, {}) ->
    Data = footprint_spirit:spirit_info(),
    {ok, Bin} = pt_331:write(33110, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(33111, Player, {}) ->
    {Ret, NewPlayer} = footprint_spirit:spirit_upgrade(Player),
    {ok, Bin} = pt_331:write(33111, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attrs, NewPlayer};
        true -> ok
    end;


handle(_cmd, _player, _data) ->
    ok.
