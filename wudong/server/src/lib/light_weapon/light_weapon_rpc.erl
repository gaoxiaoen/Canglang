%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 一月 2017 17:12
%%%-------------------------------------------------------------------
-module(light_weapon_rpc).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("light_weapon.hrl").

%% API
-export([handle/3]).

handle(35001, Player, {}) ->
    Data = light_weapon:get_light_weapon_info(),
    {ok, Bin} = pt_350:write(35001, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%升阶
handle(35002, Player, {Auto}) ->
    case light_weapon:upgrade_stage(Player, Auto) of
        {ok, Code, NewPlayer} ->
            {ok, Bin} = pt_350:write(35002, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, light_weapon, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_350:write(35002, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%切换外观
handle(35003, Player, {Figure}) ->
    {Ret, NewPlayer} = light_weapon:change_figure(Player, Figure),
    {ok, Bin} = pt_350:write(35003, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, light_weapon, NewPlayer};

%%激活技能
handle(35004, Player, {Cell}) ->
    {Ret, NewPlayer} = light_weapon_skill:activate_skill(Player, Cell),
    {ok, Bin} = pt_350:write(35004, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%升级技能
handle(35005, Player, {Cell}) ->
    {Ret, NewPlayer} = light_weapon_skill:upgrade_skill(Player, Cell),
    {ok, Bin} = pt_350:write(35005, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%%更新技能列表
handle(35006, Player, {}) ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    Data = light_weapon_skill:get_light_weapon_skill_list(LightWeapon#st_light_weapon.skill_list),
    {ok, Bin} = pt_350:write(35006, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%%装备物品
handle(35007, Player, {GoodsKey}) ->
    {Ret, NewPlayer} = light_weapon:equip_goods(Player, GoodsKey),
    {ok, Bin} = pt_350:write(35007, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attr, NewPlayer};
        true ->
            ok
    end;

%% 使用神兵成长丹
handle(35008, Player, {}) ->
    case light_weapon:use_light_weapon_dan(Player) of
        {false, Ret} ->
            {ok, Bin} = pt_350:write(35008, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_350:write(35008, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%领取外观
handle(35009, Player, {}) ->
    NewPlayer = light_weapon_init:activate(Player),
    {ok, Bin} = pt_350:write(35009, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};



handle(35010, Player, {}) ->
    Data = light_weapon_spirit:spirit_info(),
    {ok, Bin} = pt_350:write(35010, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(35011, Player, {}) ->
    {Ret, NewPlayer} = light_weapon_spirit:spirit_upgrade(Player),
    {ok, Bin} = pt_350:write(35011, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, attrs, NewPlayer};
        true -> ok
    end;

%%升星
handle(35012, Player, {WeaponId}) ->
    case catch light_weapon:upgrade_star(Player, WeaponId) of
        {ok, NewPlayer} ->
            fashion_suit:active_icon_push(NewPlayer),
            {ok, Bin} = pt_350:write(35012, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            handle(35001, Player, {}),
            {ok, NewPlayer};
        {false, Code} ->
            {ok, Bin} = pt_350:write(35012, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%激活等级加成
handle(35013, Player, {MountId}) ->
    {Ret, NewPlayer} = light_weapon:activation_stage_lv(Player, MountId),
    ?DEBUG("Ret ~p~n",[Ret]),
    {ok, Bin} = pt_350:write(35013, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _player, _data) ->
    ok.
