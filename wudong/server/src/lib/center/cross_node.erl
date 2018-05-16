%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 六月 2016 14:15
%%%-------------------------------------------------------------------
-module(cross_node).
-author("hxming").

-include("common.hrl").
-include("server.hrl").

%% API
-compile(export_all).

-define(AREA_LEN, 4).
-define(AREA_Mb_LEN, 500).

u() ->
    SelfNode = node(),
    u_code(),
    F = fun(Node) ->
        case Node == SelfNode of
            true -> u:u2();
            false ->
                center:apply(Node, cross_node, u_code, [])
        end
        end,
    lists:foreach(F, center:get_center_nodes()).

u_code() -> u:u2().

load(Files) ->
    SelfNode = node(),
    u_load(Files),
    F = fun(Node) ->
        case Node == SelfNode of
            true -> u_load(Files);
            false ->
                center:apply(Node, cross_node, u_load, [Files])
        end
        end,
    lists:foreach(F, center:get_center_nodes()).

u_load(Files) -> u:u(Files).


funtion(Module, Method) ->
    SelfNode = node(),
    u_funtion(Module, Method),
    F = fun(Node) ->
        case Node == SelfNode of
            true -> u_funtion(Module, Method);
            false ->
                center:apply(Node, cross_node, u_funtion, [Module, Method])
        end
        end,
    lists:foreach(F, center:get_center_nodes()).

u_funtion(Module, Method) ->
    Module:Method(),
    ok.


%%获取全跨服节点
cross_all_node() ->
    Lan = version:get_lan_config(),
    Sn = config:get_server_num(),
    case config:is_debug() of
        true ->
            case config:get_config_ip() of
                "120.92.142.38" ->
                    data_cross_all:get_by_sn(Sn, Lan);
                "211.215.19.168" ->
                    data_cross_all:get_by_sn(Sn, Lan);
                "120.92.159.155" ->
                    data_cross_all:get_by_sn(Sn, Lan);
                _ ->
                    data_cross_all:get_by_sn(0, Lan)
            end;
        false ->
            data_cross_all:get_by_sn(Sn, Lan)
    end.

%%获取全区域节点列表
cross_all_nodes() ->
    F = fun(Group) -> data_cross_all:get_by_group(Group) end,
    lists:map(F, data_cross_all:group_list()).

%%获取区域跨服所在的全跨服节点
get_cross_area_to_all() ->
    Group = data_cross_area:node2group(node()),
    data_cross_all:get_by_group(Group).



test() ->
%%    F = fun(Sn) ->
%%        Node = lists:concat(["arpg", Sn, "@127.0.0.1"]),
%%        KfNode = #ets_kf_nodes{key = {Node, ?CROSS_NODE_TYPE_NORMAL}, sn = Sn, node = Node, type = ?CROSS_NODE_TYPE_NORMAL, cbp = Sn * 100},
%%        ets:insert(?ETS_KF_NODES, KfNode)
%%        end,
%%    lists:foreach(F, lists:seq(1, 10)),
    ok.


%%分配区域跨服
assign_cross_area(Type) ->
    case data_cross_all:get_group(node()) of
        [] -> ok;
        Group ->
            LockList = http_lock_list(),
            F = fun(Node) ->
                if Node#ets_kf_nodes.type =/= ?CROSS_NODE_TYPE_NORMAL -> [];
                    true ->
                        case lists:keymember(Node#ets_kf_nodes.sn, 1, LockList) of
                            true -> [];
                            false ->
                                case ets:lookup(?ETS_CROSS_NODE, Node#ets_kf_nodes.sn) of
                                    [] -> [Node];
                                    [CrossNode] ->
                                        if CrossNode#ets_cross_node.node_area == none -> [Node];
                                            true -> []
                                        end
                                end
                        end
                end
                end,
            case lists:flatmap(F, ets:tab2list(?ETS_KF_NODES)) of
                [] -> ok;
                L ->
                    NodeList =
                        lists:filter(fun(Node) ->
                            lists:keymember(Node, 2, LockList) == false
                                     end, data_cross_area:get(Group)),
                    L1 = lists:reverse(lists:keysort(#ets_kf_nodes.cbp, L)),
                    ?DEBUG("L1 ~p~n", [L1]),
                    loop_assign_cross_area(NodeList, L1, Type),
                    ok
            end
    end.


loop_assign_cross_area([], _, _Type) ->
    ok;
loop_assign_cross_area(_, [], _Type) ->
    ok;
loop_assign_cross_area([Node | List], NodeList, Type) ->
    case check_node_assign(Node, Type) of
        false ->
            loop_assign_cross_area(List, NodeList, Type);
        {true, AccNode, AccMb} ->
            Midnight = util:get_today_midnight(),
            {NewNodeList, FindList} = filter_node(NodeList, AccNode, AccMb, []),
            F = fun(KfNode) ->
                Ets =
                    case ets:lookup(?ETS_CROSS_NODE, KfNode#ets_kf_nodes.sn) of
                        [] ->
                            #ets_cross_node{sn = KfNode#ets_kf_nodes.sn, node_area = Node, node_area_time = Midnight, is_change = 1};
                        [E] ->
                            E#ets_cross_node{node_area = Node, node_area_time = Midnight, is_change = 1}
                    end,
                ets:insert(?ETS_CROSS_NODE, Ets)
                end,
            lists:foreach(F, FindList),
            loop_assign_cross_area(List, NewNodeList, Type)
    end.

filter_node([], _AccNode, _AccMb, FilterList) ->
    {[], FilterList};
filter_node([Node | T], 0, AccMb, FilterList) ->
    if AccMb > 0 ->
        NewAccMb = AccMb - get_acc_mb(Node#ets_kf_nodes.sn),
        filter_node(T, 0, NewAccMb, [Node | FilterList]);
        true ->
            {[Node | T], FilterList}
    end;
filter_node([Node | T], AccNode, AccMb, FilterList) ->
    NewAccMb = AccMb - get_acc_mb(Node#ets_kf_nodes.sn),
    filter_node(T, AccNode - 1, NewAccMb, [Node | FilterList]).

check_node_assign(Node, Type) ->
    Data = ets:match_object(?ETS_CROSS_NODE, #ets_cross_node{node_area = Node, _ = '_'}),
    F = fun(CrossNode) ->
        case center:get_node_by_sn(CrossNode#ets_cross_node.sn) of
            false -> [];
            _ -> [CrossNode]
        end
        end,
    Len = length(lists:flatmap(F, Data)),
    F1 = fun(EtsNode) -> get_acc_mb(EtsNode#ets_cross_node.sn) end,
    MbLen = lists:sum(lists:map(F1, Data)),
    if Len >= ?AREA_LEN ->
        if MbLen >= ?AREA_Mb_LEN orelse Type == new ->
            false;
            true ->
                {true, ?AREA_LEN - Len, ?AREA_Mb_LEN - MbLen}
        end;
        true ->
            {true, ?AREA_LEN - Len, ?AREA_Mb_LEN - MbLen}
    end.


get_acc_mb(Sn) ->
    case ets:match_object(?ETS_KF_NODES, #ets_kf_nodes{sn = Sn, _ = '_'}) of
        [] -> 0;
        [Ets] ->
            Ets#ets_kf_nodes.cbp_len
    end.

%%分配城战跨服
assign_cross_war(Type) ->
    case data_cross_all:get_group(node()) of
        [] -> ok;
        Group ->
            LockList = http_lock_list(),
            F = fun(Node) ->
                if Node#ets_kf_nodes.type =/= ?CROSS_NODE_TYPE_NORMAL -> [];
                    true ->
                        case lists:keymember(Node#ets_kf_nodes.sn, 1, LockList) of
                            true -> [];
                            false ->
                                case ets:lookup(?ETS_CROSS_NODE, Node#ets_kf_nodes.sn) of
                                    [] -> [Node];
                                    [CrossNode] ->
                                        if CrossNode#ets_cross_node.node_war == none -> [Node];
                                            true ->
                                                []
                                        end
                                end
                        end
                end
                end,
            case lists:flatmap(F, ets:tab2list(?ETS_KF_NODES)) of
                [] -> ok;
                L ->
                    NodeList =
                        lists:filter(fun(Node) ->
                            lists:keymember(Node, 3, LockList) == false
                                     end, data_cross_area:get(Group)),
                    L1 = lists:reverse(lists:keysort(#ets_kf_nodes.cbp, L)),
                    loop_assign_cross_war(NodeList, L1, Type),
                    ok
            end
    end.



loop_assign_cross_war([], _, _Type) ->
    ok;
loop_assign_cross_war(_, [], _Type) ->
    ok;
loop_assign_cross_war([Node | List], NodeList, Type) ->
    case check_war_node_assign(Node, Type) of
        false ->
            loop_assign_cross_war(List, NodeList, Type);
        {true, AccNode, AccMb} ->
            Midnight = util:get_today_midnight(),
            {NewNodeList, FindList} = filter_node(NodeList, AccNode, AccMb, []),
            F = fun(KfNode) ->
                Ets =
                    case ets:lookup(?ETS_CROSS_NODE, KfNode#ets_kf_nodes.sn) of
                        [] ->
                            #ets_cross_node{sn = KfNode#ets_kf_nodes.sn, node_war = Node, node_war_time = Midnight, is_change = 1};
                        [E] ->
                            E#ets_cross_node{node_war = Node, node_war_time = Midnight, is_change = 1}
                    end,
                ets:insert(?ETS_CROSS_NODE, Ets)
                end,
            lists:foreach(F, FindList),
            loop_assign_cross_war(List, NewNodeList, Type)
    end.


check_war_node_assign(Node, Type) ->
    Data = ets:match_object(?ETS_CROSS_NODE, #ets_cross_node{node_war = Node, _ = '_'}),
    F = fun(CrossNode) ->
        case center:get_node_by_sn(CrossNode#ets_cross_node.sn) of
            false -> [];
            _ -> [CrossNode]
        end
        end,
    Len = length(lists:flatmap(F, Data)),
    F1 = fun(EtsNode) -> get_acc_mb(EtsNode#ets_cross_node.sn) end,
    MbLen = lists:sum(lists:map(F1, Data)),
    if Len >= ?AREA_LEN ->
        if MbLen >= ?AREA_Mb_LEN orelse Type == new ->
            false;
            true ->
                {true, ?AREA_LEN - Len, ?AREA_Mb_LEN - MbLen}
        end;
        true ->
            {true, ?AREA_LEN - Len, ?AREA_Mb_LEN - MbLen}
    end.

db_cross_node() ->
    L = ets:match_object(?ETS_CROSS_NODE, #ets_cross_node{is_change = 1, _ = '_'}),
    F = fun(Node) ->
        http_up_to_center(Node),
        ets:insert(?ETS_CROSS_NODE, Node#ets_cross_node{is_change = 0}),
        center_init:replace_cross_area(Node)
        end,
    lists:foreach(F, L),
    ok.

http_up_to_center(Node) ->
%%    ApiUrl = "http://localhost",

    ApiUrl = config:get_api_url(),
    Url = lists:concat([ApiUrl, "/cross_server.php"]),
    Now = util:unixtime(),
    Key = "cross_server_key",
    Sign = util:md5(io_lib:format("~p~s", [Now, Key])),
    U0 = io_lib:format("?act=push&sid=~p&area1=~p&node1=~s&t1=~p&area2=~p&node2=~s&t2=~p&area3=~p&node3=~s&t3=~p&time=~p&key=~s",
        [Node#ets_cross_node.sn, 0, node(), util:get_today_midnight(), 1, Node#ets_cross_node.node_area, Node#ets_cross_node.node_area_time, 2, Node#ets_cross_node.node_war, Node#ets_cross_node.node_war_time, Now, Sign]),
    U = lists:concat([Url, U0]),
    Ret = httpc:request(get, {U, []}, [{timeout, 2000}], []),
    ?DEBUG("http ret ~p~n", [Ret]),
    ok.


check_node_clean() ->
    F = fun(Node) ->
        case ets:match_object(?ETS_KF_NODES, #ets_kf_nodes{sn = Node#ets_cross_node.sn, _ = '_'}) of
            [] ->
                del_cross_node(Node#ets_cross_node.sn);
            _ -> skip
        end
        end,
    lists:foreach(F, ets:tab2list(?ETS_CROSS_NODE)),
    ok.


del_cross_node(Sn) ->
    center_init:del_cross_area(Sn),
    ets:delete(?ETS_CROSS_NODE, Sn),
    http_del_to_center(Sn),
    ok.

http_del_to_center(Sn) ->
    ApiUrl =
%%        "http://localhost",
    config:get_api_url(),
    Url = lists:concat([ApiUrl, "/cross_server.php"]),
    Now = util:unixtime(),
    Key = "cross_server_key",
    Sign = util:md5(io_lib:format("~p~s", [Now, Key])),
    U0 = io_lib:format("?act=delete&sid=~p&time=~p&key=~s", [Sn, Now, Sign]),
    U = lists:concat([Url, U0]),
    Ret = httpc:request(get, {U, []}, [{timeout, 2000}], []),
    ?DEBUG("http ret ~p~n", [Ret]),
    ok.


http_lock_list() ->
    ApiUrl =
%%        "http://localhost",
    config:get_api_url(),
    Url = lists:concat([ApiUrl, "/cross_server.php"]),
    U0 = io_lib:format("?act=lock", []),
    U = lists:concat([Url, U0]),
    Result = httpc:request(get, {U, []}, [{timeout, 2000}], []),
%%    ?DEBUG("http ret ~p~n", [Result]),
    case Result of
        {ok, {_, _, Body}} ->
            case rfc4627:decode(Body) of
                {ok, {obj, Data}, _} ->
%%                    ?DEBUG("Data:~p", [Data]),
                    case lists:keyfind("data", 1, Data) of
                        {_, List} ->
                            make_lock_list(List, []);
                        _ -> []
                    end;
                _ -> []
            end;
        _ ->
            []
    end.

make_lock_list([], L) -> L;
make_lock_list([{obj, InfoList} | T], L) ->
    Sn =
        case lists:keyfind("sid", 1, InfoList) of
            false -> 0;
            {_, Val0} ->
                util:to_integer(Val0)
        end,
    Node2 =
        case lists:keyfind("node2", 1, InfoList) of
            false -> none;
            {_, Val} ->
                util:to_atom(Val)
        end,
    Node3 =
        case lists:keyfind("node3", 1, InfoList) of
            false -> none;
            {_, Val1} ->
                util:to_atom(Val1)
        end,
    make_lock_list(T, [{Sn, Node2, Node3} | L]).



