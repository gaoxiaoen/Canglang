%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 二月 2017 17:06
%%%-------------------------------------------------------------------
-module(guild_manor_load).
-author("hxming").

-include("guild_manor.hrl").
-include("common.hrl").
%% API
-compile(export_all).

%%更新家园
replace_guild_manor(Manor) ->
    Sql = io_lib:format("replace into guild_manor set gkey=~p,lv =~p,exp=~p,building_list='~s',retinue_list='~s',time=~p ",
        [Manor#g_manor.gkey,
            Manor#g_manor.lv,
            Manor#g_manor.exp,
            guild_manor_init:building2string(Manor#g_manor.building_list),
            guild_manor_init:retinue2string(Manor#g_manor.retinue_list),
            Manor#g_manor.time
        ]),
    db:execute(Sql).

%%加载家园信息
load_guild_manor() ->
    Sql = "select gkey,lv,exp,building_list,retinue_list,time from guild_manor",
    db:get_all(Sql).

%%删除家园
del_guild_manor(Gkey) ->
    Sql = io_lib:format("delete from guild_manor where gkey=~p", [Gkey]),
    db:execute(Sql).