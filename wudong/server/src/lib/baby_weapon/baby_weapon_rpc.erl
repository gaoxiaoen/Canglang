%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 九月 2017 14:59
%%%-------------------------------------------------------------------
-module(baby_weapon_rpc).


-author("hxming").


-include("common.hrl").
-include("server.hrl").
-include("baby_weapon.hrl").

%% API
-export([handle/3]).

handle(35101, Player, {}) ->
    Data = baby_weapon:get_baby_weapon_info(),
    {ok, Bin} = pt_351:write(35101, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%升阶
handle(35102, Player, {Auto}) ->
    case baby_weapon:upgrade_stage(Player, Auto) of
        {ok, Code, NewPlayer} ->
            {ok, Bin} = pt_351:write(35102, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, baby_weapon, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_351:write(35102, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%切换外观
handle(35103, Player, {Figure}) ->
    {Ret, NewPlayer} = baby_weapon:change_figure(Player, Figure),
    {ok, Bin} = pt_351:write(35103, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, baby_weapon, NewPlayer};

%%激活技能
handle(35104, Player, {Cell}) ->
    {Ret, NewPlayer} = baby_weapon_skill:activate_skill(Player, Cell),
    {ok, Bin} = pt_351:write(35104, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%升级技能
handle(35105, Player, {Cell}) ->
    {Ret, NewPlayer} = baby_weapon_skill:upgrade_skill(Player, Cell),
    {ok, Bin} = pt_351:write(35105, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%更新技能列表
handle(35106, Player, {}) ->
    BabyWeapon = lib_dict:get(?PROC_STATUS_BABY_WEAPON),
    Data = baby_weapon_skill:get_baby_weapon_skill_list(BabyWeapon#st_baby_weapon.skill_list),
    {ok, Bin} = pt_351:write(35106, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%装备物品
handle(35107, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = baby_weapon:equip_goods(Player, GoodsKey),
    {ok, Bin} = pt_351:write(35107, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%% 使用神兵成长丹
handle(35108, Player, {}) ->
    case baby_weapon:use_baby_weapon_dan(Player) of
        {false, Ret} ->
            {ok, Bin} = pt_351:write(35108, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_351:write(35108, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%领取外观
handle(35109, Player, {}) ->
    NewPlayer = baby_weapon_init:activate(Player),
    {ok, Bin} = pt_351:write(35109, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};



handle(35110, Player, {}) ->
    Data = baby_weapon_spirit:spirit_info(),
    {ok, Bin} = pt_351:write(35110, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(35111, Player, {}) ->
    {Ret, NewPlayer} = baby_weapon_spirit:spirit_upgrade(Player),
    {ok, Bin} = pt_351:write(35111, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true -> ok
    end;


handle(_cmd, _player, _data) ->
    ok.
