%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十二月 2016 10:11
%%%-------------------------------------------------------------------
-module(manor_war_load).
-author("hxming").

-include("manor_war.hrl").

%% API
-compile(export_all).

%%加载领地
load_manor() ->
    Sql = "select m.scene_id,m.gkey,m.time,g.name from manor AS m left join guild as g on m.gkey = g.gkey ",
    db:get_all(Sql).

%%清除占领信息
clean_manor() ->
    db:execute("truncate manor").

%%清除领地
delete_manor(SceneId) ->
    Sql = io_lib:format("delete from manor where scene_id=~p", [SceneId]),
    db:execute(Sql).

%%领地战信息
replace_manor(Manor) ->
    Sql = io_lib:format("replace into manor set scene_id=~p,gkey=~p,time=~p",
        [Manor#manor.scene_id, Manor#manor.gkey, Manor#manor.time]),
    db:execute(Sql).

%%加载参战信息
load_manor_war() ->
    Sql = "select m.gkey,m.time,m.scene_list,m.mb_list,m.party_time,m.party_lv,m.party_exp,m.party_scene,m.party_full,m.party_mbs,g.name from manor_war AS m left join guild as g on m.gkey = g.gkey ",
    db:get_all(Sql).

clean_manor_war() ->
    db:execute("truncate manor_war").

replace_manor_war(ManorWar) ->
    Sql = io_lib:format("replace into manor_war set gkey=~p,time=~p,scene_list='~s',mb_list='~s',party_time=~p,party_lv=~p,party_exp=~p,party_scene=~p,party_full=~p,party_mbs='~s' ",
        [ManorWar#manor_war.gkey,
            ManorWar#manor_war.time,
            util:term_to_bitstring(ManorWar#manor_war.scene_list),
            manor_war_init:mb2list(ManorWar#manor_war.mb_list),
            ManorWar#manor_war.party_time,
            ManorWar#manor_war.party_lv,
            ManorWar#manor_war.party_exp,
            ManorWar#manor_war.party_scene,
            ManorWar#manor_war.party_full,
            manor_war_init:partymb2list(ManorWar#manor_war.party_mbs)
        ]),
    db:execute(Sql).

delete_manor_war(Gkey) ->
    Sql = io_lib:format("delete from manor_war where gkey=~p", [Gkey]),
    db:execute(Sql).