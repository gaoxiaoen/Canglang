%%%-------------------------------------------------------------------
%%% File        :common_validation.erl
%%%-------------------------------------------------------------------
-module(common_validation).

%% API
-export([
         valid_username/1
        ]).


valid_username(UserName) ->    
    case re:run(unicode:characters_to_binary(UserName), "^[\\x{4e00}-\\x{9fa5}a-zA-Z0-9_]+\$", [unicode, notempty]) of
        nomatch ->
            false;
        _ ->
            true
    end.
