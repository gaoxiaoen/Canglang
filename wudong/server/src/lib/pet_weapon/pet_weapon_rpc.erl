%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 三月 2017 15:25
%%%-------------------------------------------------------------------
-module(pet_weapon_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("pet_weapon.hrl").

%% API
-export([handle/3]).

handle(15801, Player, {}) ->
    Data = pet_weapon:get_pet_weapon_info(),
    {ok, Bin} = pt_158:write(15801, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%升阶
handle(15802, Player, {Auto}) ->
    case pet_weapon:upgrade_stage(Player, Auto) of
        {ok, Code, NewPlayer} ->
            {ok, Bin} = pt_158:write(15802, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, pet_weapon, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_158:write(15802, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%切换外观
handle(15803, Player, {Figure}) ->
    {Ret, NewPlayer} = pet_weapon:change_figure(Player, Figure),
    {ok, Bin} = pt_158:write(15803, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, pet_weapon, NewPlayer};

%%激活技能
handle(15804, Player, {Cell}) ->
    {Ret, NewPlayer} = pet_weapon_skill:activate_skill(Player, Cell),
    {ok, Bin} = pt_158:write(15804, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%升级技能
handle(15805, Player, {Cell}) ->
    {Ret, NewPlayer} = pet_weapon_skill:upgrade_skill(Player, Cell),
    {ok, Bin} = pt_158:write(15805, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%更新技能列表
handle(15806, Player, {}) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    Data = pet_weapon_skill:get_pet_weapon_skill_list(PetWeapon#st_pet_weapon.skill_list),
    {ok, Bin} = pt_158:write(15806, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%装备物品
handle(15807, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = pet_weapon:equip_goods(Player, GoodsKey),
    {ok, Bin} = pt_158:write(15807, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%% 使用神兵成长丹
handle(15808, Player, {}) ->
    case pet_weapon:use_pet_weapon_dan(Player) of
        {false, Ret} ->
            {ok, Bin} = pt_158:write(15808, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_158:write(15808, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%领取外观
handle(15809, Player, {}) ->
    NewPlayer = pet_weapon_init:activate(Player),
    {ok, Bin} = pt_158:write(15809, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};



handle(15810, Player, {}) ->
    Data = pet_weapon_spirit:spirit_info(),
    {ok, Bin} = pt_158:write(15810, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(15811, Player, {}) ->
    {Ret, NewPlayer} = pet_weapon_spirit:spirit_upgrade(Player),
    {ok, Bin} = pt_158:write(15811, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attrs, NewPlayer};
        true -> ok
    end;


handle(_cmd, _player, _data) ->
    ok.
