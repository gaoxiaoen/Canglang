%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 一月 2017 15:36
%%%-------------------------------------------------------------------
-module(god_weapon_load).
-author("hxming").

-include("common.hrl").
-include("god_weapon.hrl").
%% API
-compile(export_all).


load(Pkey) ->
    Sql = io_lib:format("select weapon_list,skill_id,weapon_id,star_list from god_weapon where pkey=~p", [Pkey]),
    db:get_row(Sql).

replace(GodWeapon) ->
    WeaponList = god_weapon_init:record2list(GodWeapon#st_god_weapon.weapon_list),
    StarList = god_weapon_init:star_record2list(GodWeapon#st_god_weapon.weapon_star),
    Sql = io_lib:format("replace into god_weapon set pkey=~p,weapon_list='~s',skill_id=~p,weapon_id=~p,star_list='~s'",
        [GodWeapon#st_god_weapon.pkey,
            WeaponList,
            GodWeapon#st_god_weapon.skill_id,
            GodWeapon#st_god_weapon.weapon_id,
            StarList]),
    db:execute(Sql).




