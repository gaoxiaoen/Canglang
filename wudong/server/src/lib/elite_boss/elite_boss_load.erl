%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 一月 2018 17:15
%%%-------------------------------------------------------------------
-module(elite_boss_load).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("elite_boss.hrl").

%% API
-export([
    load_all/0,
    delete/2,
    update/4
]).

load_all() ->
    Sql = io_lib:format("select pkey,node,sn,scene_id,back_list from player_elite_boss_back", []),
    db:get_all(Sql).

delete(Pkey, SceneId) ->
    DeleteSql = io_lib:format("delete from player_elite_boss_back where pkey=~p and scene_id=~p", [Pkey, SceneId]),
    db:execute(DeleteSql).

update(#f_damage{pkey = Pkey, sn = Sn, node = Node}, SceneId, Back, Now) ->
    Sql = io_lib:format("replace into player_elite_boss_back set pkey=~p, scene_id=~p,node='~s',sn=~p,back_list='~s',`time`=~p",
        [Pkey, SceneId, Node, Sn, util:term_to_bitstring(Back), Now]),
    db:execute(Sql).