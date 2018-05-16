%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 十一月 2016 17:37
%%%-------------------------------------------------------------------
-module(player_bless).
-author("hxming").

-include("mount.hrl").
-include("wing.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-compile(export_all).

%%查询祝福列表
check_bless_list(_Player, Now) ->
    %%坐骑祝福信息
    MountBless = mount_stage:check_bless_state(Now),
    %%翅膀祝福信息
    WingBless = wing_stage:check_bless_state(Now),
    %%法宝祝福
    MagicWeaponBless = magic_weapon:check_bless_state(Now),
    %%神兵祝福
    LightWeaponBless = light_weapon:check_bless_state(Now),
    %%妖灵祝福
    PetWeaponBless = pet_weapon:check_bless_state(Now),
    %%足迹祝福
    FootprintBless = footprint:check_bless_state(Now),
    CatBless = cat:check_bless_state(Now),
    GoldenBody = golden_body:check_bless_state(Now),
    GodTreasure = god_treasure:check_bless_state(Now),
    Jade = jade:check_bless_state(Now),
    BabyWing = baby_wing_stage:check_bless_state(Now),
    BabyMount = baby_mount:check_bless_state(Now),
    BabyWeapon = baby_weapon:check_bless_state(Now),
    MountBless ++ WingBless ++ MagicWeaponBless ++ LightWeaponBless
        ++ PetWeaponBless ++ FootprintBless ++ CatBless ++ GoldenBody ++
        BabyWing ++ BabyMount ++ BabyWeapon ++ Jade ++ GodTreasure.

%%刷新祝福信息
refresh_bless(Sid, Type, Time) ->
    {ok, Bin} = pt_130:write(13024, {[[Type, Time]]}),
    server_send:send_to_sid(Sid, Bin),
    ok.

%%定时器
timer(Player, Now) ->
    Data = check_bless_list(Player, Now),
    {ok, Bin} = pt_130:write(13024, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.


bless_reset(Player, Now) ->
    Player1 = player_util:check_player_view_func(Player),
    PlayerMount = mount_stage:bless_cd_reset(Player1, Now),
    PlayerWing = wing_stage:bless_cd_reset(PlayerMount, Now),
    PlayerMagicWeapon = magic_weapon:bless_cd_reset(PlayerWing, Now),
    PlayerLightWeapon = light_weapon:bless_cd_reset(PlayerMagicWeapon, Now),
    PlayerPetWeapon = pet_weapon:bless_cd_reset(PlayerLightWeapon, Now),
    PlayerFootprint = footprint:bless_cd_reset(PlayerPetWeapon, Now),
    PlayerCat = cat:bless_cd_reset(PlayerFootprint, Now),
    PlayerGoldenBody = golden_body:bless_cd_reset(PlayerCat, Now),
    PlayerBabyWing = baby_wing_stage:bless_cd_reset(PlayerGoldenBody, Now),
    PlayerBabyMount = baby_mount:bless_cd_reset(PlayerBabyWing, Now),
    PlayerBabyWeapon = baby_weapon:bless_cd_reset(PlayerBabyMount, Now),
    PlayerJade = jade:bless_cd_reset(PlayerBabyWeapon, Now),
    PlayerGodTreasure = god_treasure:bless_cd_reset(PlayerJade, Now),
    PlayerGodTreasure.