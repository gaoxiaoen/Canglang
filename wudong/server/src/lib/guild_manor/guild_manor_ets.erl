%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 二月 2017 17:08
%%%-------------------------------------------------------------------
-module(guild_manor_ets).
-author("hxming").

-include("guild_manor.hrl").
%% API
-compile(export_all).

%%获取家园数据
get_guild_manor(Gkey) ->
    case ets:lookup(?ETS_GUILD_MANOR, Gkey) of
        [] -> [];
        [Manor] -> Manor
    end.

%%获取所有的家园数据
get_guild_manor_all() ->
    ets:tab2list(?ETS_GUILD_MANOR).

get_update_guild_manor_list() ->
    ets:match_object(?ETS_GUILD_MANOR, #g_manor{is_change = 1, _ = '_'}).

%%存储家园信息
set_guild_manor(Manor) ->
    ets:insert(?ETS_GUILD_MANOR, Manor).

%%删除家园
del_guild_manor(Gkey) ->
    ets:delete(?ETS_GUILD_MANOR, Gkey).
