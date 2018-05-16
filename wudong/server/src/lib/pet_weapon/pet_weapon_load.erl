%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 三月 2017 15:24
%%%-------------------------------------------------------------------
-module(pet_weapon_load).

-author("hxming").

-include("pet_weapon.hrl").
%% API
-compile(export_all).

load(Pkey) ->
    Sql = io_lib:format("select stage,exp,bless_cd,weapon_id,skill_list,equip_list,grow_num,spirit_list,last_spirit,spirit from pet_weapon where pkey=~p", [Pkey]),
    db:get_row(Sql).

load_view(Pkey) ->
    Sql = io_lib:format("select stage,cbp,attribute,skill_list,equip_list,grow_num from pet_weapon  where pkey =~p", [Pkey]),
    db:get_row(Sql).


replace(PetWeapon) ->
    Sql = io_lib:format("replace into pet_weapon set pkey=~p,stage=~p,exp=~p,bless_cd=~p,weapon_id=~p,skill_list='~s',equip_list='~s',grow_num=~p,cbp=~p,attribute='~s',spirit_list='~s',last_spirit=~p,spirit=~p",
        [PetWeapon#st_pet_weapon.pkey,
            PetWeapon#st_pet_weapon.stage,
            PetWeapon#st_pet_weapon.exp,
            PetWeapon#st_pet_weapon.bless_cd,
            PetWeapon#st_pet_weapon.weapon_id,
            util:term_to_bitstring(PetWeapon#st_pet_weapon.skill_list),
            util:term_to_bitstring(PetWeapon#st_pet_weapon.equip_list),
            PetWeapon#st_pet_weapon.grow_num,
            PetWeapon#st_pet_weapon.cbp,
            util:term_to_bitstring(attribute_util:make_attribute_to_key_val(PetWeapon#st_pet_weapon.attribute)),
            util:term_to_bitstring(PetWeapon#st_pet_weapon.spirit_list),
            PetWeapon#st_pet_weapon.last_spirit,
            PetWeapon#st_pet_weapon.spirit
        ]),
    db:execute(Sql).