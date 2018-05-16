%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 七月 2016 17:35
%%%-------------------------------------------------------------------
-module(center_init).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
%% API
-compile(export_all).


%%初始化
init_cross_war_area() ->
    Sql = "select sn,day,time from cross_war_area",
    F = fun([Sn, Day, Time]) ->
        ets:insert(?ETS_WAR_NODES, #ets_war_nodes{sn = Sn, day = Day, time = Time})
        end,
    lists:foreach(F, db:get_all(Sql)).

%%清除
clean_cross_war_area() ->
    ets:delete_all_objects(?ETS_WAR_NODES),
    db:execute("truncate cross_war_area ").

%%更新
update_cross_war_area(Sn, Day, Time) ->
%%    {_, Time} = util:get_week_time(Now),
    ets:insert(?ETS_WAR_NODES, #ets_war_nodes{sn = Sn, day = Day, time = Time}),
    Sql = io_lib:format("replace into cross_war_area set sn= ~p,day=~p,time =~p", [Sn, Day, Time]),
    db:execute(Sql).


init() ->
    Sql = "select sn,node_area,node_area_time,node_war,node_war_time from cross_node",
    F = fun([Sn, NodeArea, NodeAreaTime, NodeWar, NodeWarTime]) ->
        Node = #ets_cross_node{sn = Sn, node_area = util:to_atom(NodeArea), node_area_time = NodeAreaTime, node_war = util:to_atom(NodeWar), node_war_time = NodeWarTime},
        ets:insert(?ETS_CROSS_NODE, Node)
        end,
    lists:foreach(F, db:get_all(Sql)).


replace_cross_area(Node) ->
    Sql = io_lib:format("replace into cross_node set sn= ~p,node_area ='~s',node_area_time =~p,node_war='~s',node_war_time=~p",
        [Node#ets_cross_node.sn, Node#ets_cross_node.node_area, Node#ets_cross_node.node_area_time, Node#ets_cross_node.node_war, Node#ets_cross_node.node_war_time]),
    db:execute(Sql).

del_cross_area(Sn) ->
    Sql = io_lib:format("delete from cross_node where sn =~p", [Sn]),
    db:execute(Sql).


clean_cross_area() ->
    db:execute("truncate cross_node").