%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 九月 2017 14:59
%%%-------------------------------------------------------------------
-module(baby_weapon_load).
-author("hxming").


-include("common.hrl").
-include("baby_weapon.hrl").


%% API
-compile(export_all).

load(Pkey) ->
    Sql = io_lib:format("select stage,exp,bless_cd,baby_weapon_id,skill_list,equip_list,grow_num,spirit_list,last_spirit,spirit from baby_weapon where pkey=~p", [Pkey]),
    db:get_row(Sql).

load_view(Pkey) ->
    Sql = io_lib:format("select stage,cbp,attribute,skill_list,equip_list,grow_num from baby_weapon  where pkey =~p", [Pkey]),
    db:get_row(Sql).


replace(BabyWeapon) ->
    Sql = io_lib:format("replace into baby_weapon set pkey=~p,stage=~p,exp=~p,bless_cd=~p,baby_weapon_id=~p,skill_list='~s',equip_list='~s',grow_num=~p,cbp=~p,attribute='~s',spirit_list='~s',last_spirit=~p,spirit=~p",
        [BabyWeapon#st_baby_weapon.pkey,
            BabyWeapon#st_baby_weapon.stage,
            BabyWeapon#st_baby_weapon.exp,
            BabyWeapon#st_baby_weapon.bless_cd,
            BabyWeapon#st_baby_weapon.baby_weapon_id,
            util:term_to_bitstring(BabyWeapon#st_baby_weapon.skill_list),
            util:term_to_bitstring(BabyWeapon#st_baby_weapon.equip_list),
            BabyWeapon#st_baby_weapon.grow_num,
            BabyWeapon#st_baby_weapon.cbp,
            util:term_to_bitstring(attribute_util:make_attribute_to_key_val(BabyWeapon#st_baby_weapon.attribute)),
            util:term_to_bitstring(BabyWeapon#st_baby_weapon.spirit_list),
            BabyWeapon#st_baby_weapon.last_spirit,
            BabyWeapon#st_baby_weapon.spirit
        ]),
    db:execute(Sql).