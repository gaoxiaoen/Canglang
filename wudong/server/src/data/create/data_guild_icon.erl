%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02.
%%%-------------------------------------------------------------------
-module(data_guild_icon).
-author("Administrator").
-include("guild.hrl").

%% API
-export([get/1, get_all/0]).

get(1) -> #base_guild_icon{id = 1, icon = 1001, limit = 1};
get(2) -> #base_guild_icon{id = 2, icon = 1002, limit = 3};
get(3) -> #base_guild_icon{id = 3, icon = 1003, limit = 5};
get(4) -> #base_guild_icon{id = 4, icon = 1004, limit = 6};
get(5) -> #base_guild_icon{id = 5, icon = 1005, limit = 7};
get(6) -> #base_guild_icon{id = 6, icon = 1006, limit = 8};
get(7) -> #base_guild_icon{id = 7, icon = 1007, limit = 9};
get(8) -> #base_guild_icon{id = 8, icon = 1008, limit = 10};
get(_) -> [].

get_all() -> [1, 2, 3,4,5,6,7,8,9,10].

