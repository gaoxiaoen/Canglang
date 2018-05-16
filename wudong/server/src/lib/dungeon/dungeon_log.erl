%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 七月 2017 16:03
%%%-------------------------------------------------------------------
-module(dungeon_log).
-author("li").

%% API
-export([log/1]).
-include("common.hrl").
-include("server.hrl").
-include("dungeon.hrl").

log(LogDungeon) ->
    Sql = sql(LogDungeon),
    spawn(fun() -> db:execute(Sql) end),
    ok.

sql(LogDungeon) ->
    #log_dungeon{
        pkey = Pkey,
        nickname = NickName,
        cbp = Cbp,
        dungeon_id = DungeonId,
        dungeon_type = DungeonType,
        dungeon_desc = DungeonDesc,
        layer = Layer,
        layer_desc = LayerDesc,
        sub_layer = SubLayer,
        time = Time
    } = LogDungeon,
    io_lib:format("insert into log_dungeon_pass_info set pkey=~p,nickname='~s',cbp=~p,dungeon_id=~p, dungeon_type=~p,dungeon_desc='~s',layer=~p,layer_desc='~s',sub_layer=~p,time=~p ",
        [Pkey, NickName, Cbp, DungeonId, DungeonType, DungeonDesc, Layer, LayerDesc, SubLayer, Time]).
