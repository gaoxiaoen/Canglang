%% @filename mod_team.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-02-14 
%% @doc 
%% 组队模块.

-module(mod_team).

-include("mgeew.hrl").

-export([
         handle/1
        ]).


handle(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).