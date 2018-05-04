%%-------------------------------------------------------------------
%% File              :hook_pet.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015?11?17?
%% @doc
%%     Add description
%% @end
%%-------------------------------------------------------------------


-module(hook_pet).

-include("mgeew.hrl").

-export([hook_pet_dead/1]).

%% 宠物死亡
hook_pet_dead(PetId) ->
    ?TRY_CATCH(mod_pet:pet_dead(PetId),ErrPet),
    ok.



