%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 三月 2017 10:34
%%%-------------------------------------------------------------------
-module(pet_load).
-author("hxming").
-include("common.hrl").
-include("pet.hrl").

%% API
-compile(export_all).

load_pet(Pkey) ->
    Sql = io_lib:format("select figure,stage,stage_lv,stage_exp,pic_list,egg_list from pet_info  where pkey=~p", [Pkey]),
    db:get_row(Sql).


replace_pet(StPet) ->
    replace_pet_list(StPet#st_pet.pkey, StPet#st_pet.stage, StPet#st_pet.pet_list),
    EggList = pet_egg:egg2list(StPet#st_pet.egg_list),
    Sql = io_lib:format("replace into pet_info set pkey=~p,figure=~p,stage=~p,stage_lv=~p,stage_exp=~p,pic_list='~s',egg_list='~s'",
        [StPet#st_pet.pkey,
            StPet#st_pet.figure,
            StPet#st_pet.stage,
            StPet#st_pet.stage_lv,
            StPet#st_pet.stage_exp,
            util:term_to_bitstring(StPet#st_pet.pic_list),
            util:term_to_bitstring(EggList)
        ]
    ),
    db:execute(Sql).




load_pet_list(Pkey) ->
    Sql = io_lib:format("select pet_key,type_id,name,figure,star,star_exp,state,assist_cell,time,skill from pet where pkey=~p ", [Pkey]),
    db:get_all(Sql).


replace_pet_list(_Pkey, _Stage, []) -> ok;
replace_pet_list(Pkey, Stage, PetList) ->
    F = fun(Pet, L) ->
        Sql = io_lib:format("replace into pet set pet_key=~p,pkey=~p,type_id=~p,name = '~s',figure=~p,stage=~p,star=~p,star_exp=~p,state=~p,assist_cell=~p,time=~p,skill='~s',cbp=~p,attribute='~s'",
            [
                Pet#pet.key,
                Pkey,
                Pet#pet.type_id,
                Pet#pet.name,
                Pet#pet.figure,
                Stage,
                Pet#pet.star,
                Pet#pet.star_exp,
                Pet#pet.state,
                Pet#pet.assist_cell,
                Pet#pet.time,
                util:term_to_bitstring(Pet#pet.skill),
                Pet#pet.cbp,
                util:term_to_bitstring(attribute_util:make_attribute_to_key_val(Pet#pet.attribute))
            ]),
        [Sql | L]
        end,
    case lists:foldl(F, [], PetList) of
        [] -> ok;
        SqlList ->
            NewSqlList = string:join(SqlList, ";"),
            db:execute(NewSqlList)
    end.


del_pet(PetKey) ->
    Sql = io_lib:format("delete from pet where pet_key=~p", [PetKey]),
    db:execute(Sql).