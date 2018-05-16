%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 一月 2017 14:06
%%%-------------------------------------------------------------------
-module(magic_weapon_load).
-author("hxming").

-include("magic_weapon.hrl").
%% API
-compile(export_all).

load(Pkey) ->
    Sql = io_lib:format("select stage,exp,bless_cd,weapon_id,skill_list,equip_list,grow_num,spirit_list,last_spirit,spirit from magic_weapon where pkey=~p", [Pkey]),
    db:get_row(Sql).

load_view(Pkey) ->
    Sql = io_lib:format("select stage,cbp,attribute,skill_list,equip_list,grow_num from magic_weapon  where pkey =~p", [Pkey]),
    db:get_row(Sql).


replace(MagicWeapon) ->
    Sql = io_lib:format("replace into magic_weapon set pkey=~p,stage=~p,exp=~p,bless_cd=~p,weapon_id=~p,skill_list='~s',equip_list='~s',grow_num=~p,cbp=~p,attribute='~s',spirit_list='~s',last_spirit=~p,spirit=~p",
        [MagicWeapon#st_magic_weapon.pkey,
            MagicWeapon#st_magic_weapon.stage,
            MagicWeapon#st_magic_weapon.exp,
            MagicWeapon#st_magic_weapon.bless_cd,
            MagicWeapon#st_magic_weapon.weapon_id,
            util:term_to_bitstring(MagicWeapon#st_magic_weapon.skill_list),
            util:term_to_bitstring(MagicWeapon#st_magic_weapon.equip_list),
            MagicWeapon#st_magic_weapon.grow_num,
            MagicWeapon#st_magic_weapon.cbp,
            util:term_to_bitstring(attribute_util:make_attribute_to_key_val(MagicWeapon#st_magic_weapon.attribute)),
            util:term_to_bitstring(MagicWeapon#st_magic_weapon.spirit_list),
            MagicWeapon#st_magic_weapon.last_spirit,
            MagicWeapon#st_magic_weapon.spirit
        ]),
    db:execute(Sql).