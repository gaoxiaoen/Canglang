%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 一月 2017 14:06
%%%-------------------------------------------------------------------
-module(light_weapon_load).
-author("hxming").

-include("light_weapon.hrl").
%% API
-compile(export_all).

load(Pkey) ->
    Sql = io_lib:format("select stage,exp,bless_cd,weapon_id,skill_list,equip_list,grow_num ,spirit_list,last_spirit ,star_list,own_special_image,spirit,activation_list from light_weapon where pkey=~p", [Pkey]),
    db:get_row(Sql).

load_view(Pkey) ->
    Sql = io_lib:format("select stage,cbp,attribute,skill_list,equip_list,grow_num from light_weapon  where pkey =~p", [Pkey]),
    db:get_row(Sql).


replace(LightWeapon) ->
    Sql = io_lib:format("replace into light_weapon set pkey=~p,stage=~p,exp=~p,bless_cd=~p,weapon_id=~p,skill_list='~s',equip_list='~s',grow_num=~p,cbp=~p,attribute='~s',spirit_list='~s',last_spirit=~p,star_list = '~s',own_special_image='~s',spirit=~p,activation_list='~s' ",
        [LightWeapon#st_light_weapon.pkey,
            LightWeapon#st_light_weapon.stage,
            LightWeapon#st_light_weapon.exp,
            LightWeapon#st_light_weapon.bless_cd,
            LightWeapon#st_light_weapon.weapon_id,
            util:term_to_bitstring(LightWeapon#st_light_weapon.skill_list),
            util:term_to_bitstring(LightWeapon#st_light_weapon.equip_list),
            LightWeapon#st_light_weapon.grow_num,
            LightWeapon#st_light_weapon.cbp,
            util:term_to_bitstring(attribute_util:make_attribute_to_key_val(LightWeapon#st_light_weapon.attribute)),
            util:term_to_bitstring(LightWeapon#st_light_weapon.spirit_list),
            LightWeapon#st_light_weapon.last_spirit,
            util:term_to_bitstring(LightWeapon#st_light_weapon.star_list),
            util:term_to_bitstring(LightWeapon#st_light_weapon.own_special_image),
            LightWeapon#st_light_weapon.spirit,
            util:term_to_bitstring(LightWeapon#st_light_weapon.activation_list)
        ]),
    db:execute(Sql).