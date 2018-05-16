%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 一月 2017 17:12
%%%-------------------------------------------------------------------
-module(magic_weapon_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("magic_weapon.hrl").
%% API
-export([handle/3]).

handle(15501, Player, {}) ->
    Data = magic_weapon:get_magic_weapon_info(),
    {ok, Bin} = pt_155:write(15501, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%升阶
handle(15502, Player, {Auto}) ->
    case magic_weapon:upgrade_stage(Player, Auto) of
        {ok, Code, NewPlayer} ->
            {ok, Bin} = pt_155:write(15502, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_155:write(15502, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%切换外观
handle(15503, Player, {Figure}) ->
    {Ret, NewPlayer} = magic_weapon:change_figure(Player, Figure),
    {ok, Bin} = pt_155:write(15503, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%激活技能
handle(15504, Player, {Cell}) ->
    {Ret, NewPlayer} = magic_weapon_skill:activate_skill(Player, Cell),
    {ok, Bin} = pt_155:write(15504, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%升级技能
handle(15505, Player, {Cell}) ->
    {Ret, NewPlayer} = magic_weapon_skill:upgrade_skill(Player, Cell),
    {ok, Bin} = pt_155:write(15505, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%更新技能列表
handle(15506, Player, {}) ->
    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    Data = magic_weapon_skill:get_magic_weapon_skill_list(MagicWeapon#st_magic_weapon.skill_list),
    {ok, Bin} = pt_155:write(15506, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(15507, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = magic_weapon:equip_goods(Player, GoodsKey),
    {ok, Bin} = pt_155:write(15507, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%% 使用法宝成长丹
handle(15508, Player, {}) ->
    case magic_weapon:use_magic_weapon_dan(Player) of
        {false, Ret} ->
            {ok, Bin} = pt_155:write(15508, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_155:write(15508, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%领取外观
handle(15509, Player, {}) ->
    NewPlayer = magic_weapon_init:activate(Player),
    {ok, Bin} = pt_155:write(15509, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};



handle(15510, Player, {}) ->
    Data = magic_weapon_spirit:spirit_info(),
    {ok, Bin} = pt_155:write(15510, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(15511, Player, {}) ->
    {Ret, NewPlayer} = magic_weapon_spirit:spirit_upgrade(Player),
    {ok, Bin} = pt_155:write(15511, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attrs, NewPlayer};
        true -> ok
    end;


handle(_cmd, _player, _data) ->
    ok.
