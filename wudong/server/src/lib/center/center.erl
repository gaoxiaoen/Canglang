%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 跨服中心服务
%%% @end
%%% Created : 11. 五月 2015 下午2:09
%%%-------------------------------------------------------------------
-module(center).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("g_daily.hrl").
-behaviour(gen_server).

%% API
-export([
    start_link/0
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([
    get_pid/0,
    apply/4,  %%cast
    apply_sn/4,  %% cast
    apply_call/4,  %%call
    game_all_to_center/9,
    game_area_to_center/8,
    game_war_to_center/7,
    add_center_node/1,
    center_del_node/2,
    get_nodes/0,
    get_all_nodes/0,
    get_war_nodes/0,
    get_node_by_sn/1,
    get_center_nodes/0,
    get_sn_list/0,
    get_sn_node_list/0,
    world_lv/0,
    is_center_all/0,
    is_center_area/0,
    get_cross_cookie/0,
    check_by_sn/2,
    get_cross_area_group_list/0,
    get_sn_name_by_sn/1
]).

-export([
    reset_all/0,
    reset_area/1,
    reset_war/1,
    calc_cross_war_area_time/1,
    reset_war_time/0
]).

-export([get_rg_node/0]).

-define(SERVER, ?MODULE).

-define(RTIME, 60000).

-define(ASSGIN_TIMER, 300000).



-record(state, {
    heartbeat = none
}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

get_pid() ->
    case get(?MODULE) of
        undefined ->
            Pid = misc:whereis_name(local, ?MODULE),
            if
                is_pid(Pid) ->
                    put(?MODULE, Pid);
                true ->
                    skip
            end,
            Pid;
        Pid ->
            Pid
    end.

%%跨服中心增加节点
game_all_to_center(Sn, SnName, Node, OpenTime, IsDebug, WorldLv, SnList, Cbp, CbpLen) ->
    KfNode = #ets_kf_nodes{key = {Node, ?CROSS_NODE_TYPE_NORMAL}, sn = Sn, sn_name = SnName, node = Node, open_time = OpenTime, is_debug = IsDebug, world_lv = WorldLv, type = ?CROSS_NODE_TYPE_NORMAL, cbp = Cbp, cbp_len = CbpLen},
    ets:insert(?ETS_KF_NODES, KfNode),
    F = fun(OldSn) ->
        ets:insert(?ETS_KF_MERGE_SN, #ets_kf_merge_sn{sn = OldSn, new_sn = Sn})
        end,
    lists:foreach(F, SnList),
    ok.

game_area_to_center(Sn, SnName, Node, OpenTime, IsDebug, WorldLv, MaxLv, SnList) ->
    KfNode = #ets_kf_nodes{key = {Node, ?CROSS_NODE_TYPE_NORMAL}, sn = Sn, sn_name = SnName, node = Node, open_time = OpenTime, is_debug = IsDebug, world_lv = WorldLv, p_max_lv = MaxLv, type = ?CROSS_NODE_TYPE_NORMAL},
    ets:insert(?ETS_KF_NODES, KfNode),
    F = fun(OldSn) ->
        ets:insert(?ETS_KF_MERGE_SN, #ets_kf_merge_sn{sn = OldSn, new_sn = Sn})
        end,
    lists:foreach(F, SnList),
    IsCenterAll = is_center_all(),
    Now = util:unixtime(),
    if IsCenterAll orelse OpenTime > Now orelse MaxLv == 0 -> ok;
        true -> cross_dark_bribe_proc:get_server_pid() ! {check_new_server, Sn, SnName, MaxLv}
    end,
    ok.


game_war_to_center(Sn, SnName, Node, OpenTime, IsDebug, WorldLv, SnList) ->
    KfNode = #ets_kf_nodes{key = {Node, ?CROSS_NODE_TYPE_WAR}, sn = Sn, sn_name = SnName, node = Node, open_time = OpenTime, is_debug = IsDebug, world_lv = WorldLv, type = ?CROSS_NODE_TYPE_WAR},
    ets:insert(?ETS_KF_NODES, KfNode),
    F = fun(OldSn) ->
        ets:insert(?ETS_KF_MERGE_SN, #ets_kf_merge_sn{sn = OldSn, new_sn = Sn})
        end,
    lists:foreach(F, SnList),
    ok.

%%增加跨服节点到跨服中心点
add_center_node(Node) ->
    ets:insert(?ETS_KF_NODES, #ets_kf_nodes{key = {Node, ?CROSS_NODE_TYPE_AREA}, node = Node, type = ?CROSS_NODE_TYPE_AREA}).

get_cross_cookie() ->
    'cl168arpg'.

%%检查是否可区域跨服
%%check_cross_area(Node, IsCenterAll) ->
%%    if IsCenterAll ->
%%        Days = get_open_days(Node#ets_kf_nodes.open_time),
%%        AreaNode = cross_node:cross_area_node(Node#ets_kf_nodes.sn, Node#ets_kf_nodes.is_debug, Days),
%%        apply(Node#ets_kf_nodes.node, cross_area, cross_area_node, [AreaNode]),
%%        AreaNode;
%%        true -> none
%%    end.

%%get_open_days(Time) ->
%%    OpenDate = util:unixdate(Time),
%%    Today = util:unixdate(),
%%    OpenDay = round((Today - OpenDate) / ?ONE_DAY_SECONDS + 1),
%%    case OpenDay =< 0 of
%%        true -> 1;
%%        false -> OpenDay
%%    end.


%%检查城战跨服区域
%%check_cross_war_area(Node, IsCenterAll, Now) ->
%%    if IsCenterAll ->
%%        NextTime = get_cross_war_area_time(Now),
%%        NewDays =
%%            case ets:lookup(?ETS_WAR_NODES, Node#ets_kf_nodes.sn) of
%%                [] ->
%%                    Days = get_open_days(Node#ets_kf_nodes.open_time),
%%                    center_init:update_cross_war_area(Node#ets_kf_nodes.sn, Days, NextTime),
%%                    Days;
%%                [WarNode] ->
%%                    if Now > WarNode#ets_war_nodes.time ->
%%                        Days = get_open_days(Node#ets_kf_nodes.open_time),
%%                        center_init:update_cross_war_area(Node#ets_kf_nodes.sn, Days, NextTime),
%%                        Days;
%%                        true ->
%%                            WarNode#ets_war_nodes.day
%%                    end
%%            end,
%%        case is_integer(NewDays) of
%%            true ->
%%                AreaNode =
%%                    cross_node:cross_war_area_node(Node#ets_kf_nodes.sn, Node#ets_kf_nodes.is_debug, NewDays),
%%                apply(Node#ets_kf_nodes.node, cross_area, cross_war_node, [AreaNode]);
%%            false -> skip
%%        end;
%%        true -> skip
%%    end.

%%获取城战分区时间点
%%get_cross_war_area_time(Now) ->
%%    case g_forever:get_count(?G_FOREVER_TYPE_CROSS_WAR) of
%%        0 ->
%%            Time = calc_cross_war_area_time(Now),
%%            g_forever:set_count(?G_FOREVER_TYPE_CROSS_WAR, Time),
%%            Time;
%%        Time ->
%%            if Time > Now -> Time;
%%                true ->
%%                    Time2 = calc_cross_war_area_time(Now),
%%                    g_forever:set_count(?G_FOREVER_TYPE_CROSS_WAR, Time2),
%%                    Time2
%%            end
%%    end.

calc_cross_war_area_time(Now) ->
    Week = util:get_day_of_week(Now),
    Days =
        case Week of
            1 -> 5;
            2 -> 4;
            3 -> 3;
            4 -> 2;
            5 -> 1;
            6 -> 7;
            7 -> 6
        end,
    Midnight = util:get_today_midnight(Now),
    Midnight + Days * ?ONE_DAY_SECONDS + 21 * ?ONE_DAY_SECONDS.

%%跨服中心删除节点
center_del_node(Node, Type) ->
    ets:delete(?ETS_KF_NODES, {Node, Type}).

%%跨服中心到游戏节点
apply(Node, Module, Method, Args) ->
    case Node of
        none ->
            ?ERR("center apply error ~p ~n", [{Module, Method, Args}]);
        _ ->
            rpc:cast(Node, Module, Method, Args)
    end.

%%跨服中心到游戏节点
apply_sn(Sn, Module, Method, Args) ->
    case center:get_node_by_sn(Sn) of
        false ->
            ?ERR("center apply_sn error ~p ~n", [{Sn, Module, Method, Args}]),
            skip;
        Node ->
            apply(Node, Module, Method, Args)
    end.


%%跨服中心到游戏节点
apply_call(Node, Module, Method, Args) ->
    case Node of
        none ->
            ?ERR("center apply error ~p ~n", [{Module, Method, Args}]),
            [];
        _ ->
            rpc:call(Node, Module, Method, Args)
    end.

get_sn_name_by_sn(Sn) ->
    NewSn =
        case ets:lookup(?ETS_KF_MERGE_SN, Sn) of
            [] -> Sn;
            [Ets] -> Ets#ets_kf_merge_sn.new_sn
        end,
    case ets:match_object(?ETS_KF_NODES, #ets_kf_nodes{sn = NewSn, type = ?CROSS_NODE_TYPE_NORMAL, _ = '_'}) of
        [] -> ?T("未知");
        [Node | _] ->
            case Node#ets_kf_nodes.sn_name of
                <<>> -> ?T("未知");
                null -> ?T("未知");
                _ -> Node#ets_kf_nodes.sn_name
            end
    end.

%%获取跨服节点列表
get_nodes() ->
    Nodes = ets:tab2list(?ETS_KF_NODES),
    [Node#ets_kf_nodes.node || Node <- Nodes, Node#ets_kf_nodes.type == ?CROSS_NODE_TYPE_NORMAL].

%%获取节点信息
get_all_nodes() ->
    Nodes = ets:tab2list(?ETS_KF_NODES),
    [Node || Node <- Nodes, Node#ets_kf_nodes.type == ?CROSS_NODE_TYPE_NORMAL].


%%获取城战跨服节点列表
get_war_nodes() ->
    Nodes = ets:tab2list(?ETS_KF_NODES),
    [Node#ets_kf_nodes.node || Node <- Nodes, Node#ets_kf_nodes.type == ?CROSS_NODE_TYPE_WAR].


%%根据服务器号获取单服节点
get_node_by_sn(Sn) ->
    NewSn =
        case ets:lookup(?ETS_KF_MERGE_SN, Sn) of
            [] -> Sn;
            [Ets] -> Ets#ets_kf_merge_sn.new_sn
        end,
    case ets:match_object(?ETS_KF_NODES, #ets_kf_nodes{sn = NewSn, type = ?CROSS_NODE_TYPE_NORMAL, _ = '_'}) of
        [] -> false;
        [Node | _] ->
            Node#ets_kf_nodes.node
    end.


%%获取跨服节点
get_center_nodes() ->
    Nodes = ets:tab2list(?ETS_KF_NODES),
    [Node#ets_kf_nodes.node || Node <- Nodes, Node#ets_kf_nodes.type == ?CROSS_NODE_TYPE_AREA].

%%获取区域跨服服务器号列表
get_sn_list() ->
    Nodes = ets:tab2list(?ETS_KF_NODES),
    [Node#ets_kf_nodes.sn || Node <- Nodes, Node#ets_kf_nodes.type == ?CROSS_NODE_TYPE_NORMAL].

%%获取区域跨服服务器号、节点名列表
get_sn_node_list() ->
    Nodes = ets:tab2list(?ETS_KF_NODES),
    [{Node#ets_kf_nodes.sn, Node#ets_kf_nodes.node} || Node <- Nodes, Node#ets_kf_nodes.type == ?CROSS_NODE_TYPE_NORMAL].

%%获取跨服区域服务器分组列表
%%get_cross_area_group_list() ->
%%    F = fun(Node, L) ->
%%        if Node#ets_kf_nodes.type /= ?CROSS_NODE_TYPE_NORMAL -> L;
%%            true ->
%%                case lists:keytake(Node#ets_kf_nodes.area_node, 1, L) of
%%                    false ->
%%                        [{Node#ets_kf_nodes.area_node, [Node#ets_kf_nodes.sn]} | L];
%%                    {value, {_, SnList}, T} ->
%%                        [{Node#ets_kf_nodes.area_node, [Node#ets_kf_nodes.sn | SnList]} | T]
%%                end
%%        end
%%        end,
%%    lists:foldl(F, [], ets:tab2list(?ETS_KF_NODES)).

get_cross_area_group_list() ->
%%    Node = node(),
%%    Lan = version:get_lan_config(),
    F = fun(CrossNode) ->
        if CrossNode#ets_cross_node.node_area == none -> [];
            true ->
                [{CrossNode#ets_cross_node.sn, CrossNode#ets_cross_node.node_area}]
        end
        end,
    List = lists:flatmap(F, ets:tab2list(?ETS_CROSS_NODE)),
%%    List = lists:flatmap(F, config:get_server_list()),
    F1 = fun({Sn, AreaNode}, L) ->
        case lists:keytake(AreaNode, 1, L) of
            false ->
                [{AreaNode, [Sn]} | L];
            {value, {_, SnList}, T} ->
                [{AreaNode, [Sn | SnList]} | T]
        end
         end,
    lists:foldl(F1, [], List).

world_lv() ->
    case ets:tab2list(?ETS_KF_NODES) of
        [] -> 45;
        Nodes ->
            round(lists:sum([Node#ets_kf_nodes.world_lv || Node <- Nodes]) / length(Nodes))
    end.

%%是否全跨服
is_center_all() ->
    lists:member(node(), cross_node:cross_all_nodes()).

%%是否区域跨服
is_center_area() ->
    not is_center_all() andalso config:is_center_node().


%%根据服务器号回去跨服信息
check_by_sn(Sn, _Type) ->
    ets:lookup(?ETS_CROSS_NODE, Sn).

%%重置全部跨服节点
reset_all() ->
    case is_center_all() of
        true ->
            get_pid() ! reset_all;
        false ->
            ok
    end.

%%重置区域跨服
reset_area(Now) ->
    case is_center_all() of
        false -> skip;
        true ->
            %%每周一重置
            case util:get_day_of_week(Now) of
                1 -> get_pid() ! reset_area;
                _ -> skip
            end
    end.

%%重置城战
reset_war(Now) ->
    case is_center_all() of
        false -> skip;
        true ->
            LastTime = g_forever:get_count(?G_FOREVER_TYPE_CROSS_WAR),
            if Now > LastTime ->
                Time = calc_cross_war_area_time(Now),
                g_forever:set_count(?G_FOREVER_TYPE_CROSS_WAR, Time),
                get_pid() ! reset_war;
                true -> skip
            end
    end.

reset_war_time() ->
    case is_center_all() of
        false -> skip;
        true ->
            LastTime = g_forever:get_count(?G_FOREVER_TYPE_CROSS_WAR),
            g_forever:set_count(?G_FOREVER_TYPE_CROSS_WAR, LastTime - 2 * ?ONE_DAY_SECONDS)
    end.

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    Hb = erlang:send_after(?RTIME, self(), heartbeat),
%%    center_init:init_cross_war_area(),
    center_init:init(),
    case is_center_all() of
        true ->
            put(timer, erlang:send_after(?ASSGIN_TIMER, self(), timer));
        false -> ok
    end,
    io:format("center init finish~n"),

    {ok, #state{heartbeat = Hb}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.


handle_info(_Info, State) ->
    case catch do_info(_Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("center info err ~p~n", [Reason]),
            {noreply, State}
    end.


terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
do_info(heartbeat, State) ->
    Hb = erlang:send_after(?RTIME, self(), heartbeat),
    spawn(fun heartbeat/0),
    {noreply, State#state{heartbeat = Hb}};

do_info(timer, State) ->
    misc:cancel_timer(timer),
    put(timer, erlang:send_after(?ASSGIN_TIMER, self(), timer)),
    cross_node:assign_cross_area(new),
    cross_node:assign_cross_war(new),
    cross_node:db_cross_node(),
    {noreply, State};


%%重置全部跨服节点
do_info(reset_all, State) ->
    ets:delete_all_objects(?ETS_CROSS_NODE),
    center_init:clean_cross_area(),
    cross_node:assign_cross_area(reset),
    cross_node:assign_cross_war(reset),
    cross_node:db_cross_node(),
    {noreply, State};

%%重置区域跨服节点
do_info(reset_area, State) ->
    F = fun(CrossNode) ->
        ets:insert(?ETS_CROSS_NODE, CrossNode#ets_cross_node{node_area = none, node_area_time = 0})
        end,
    lists:foreach(F, ets:tab2list(?ETS_CROSS_NODE)),
    cross_node:assign_cross_area(reset),
    cross_node:db_cross_node(),
    {noreply, State};

%%重置城战跨服节点
do_info(reset_war, State) ->
    F = fun(CrossNode) ->
        ets:insert(?ETS_CROSS_NODE, CrossNode#ets_cross_node{node_war = none, node_war_time = 0})
        end,
    lists:foreach(F, ets:tab2list(?ETS_CROSS_NODE)),
    cross_node:assign_cross_war(reset),
    cross_node:db_cross_node(),
    {noreply, State};


do_info(_Info, State) ->
    {noreply, State}.





heartbeat() ->
    AllNodes = ets:tab2list(?ETS_KF_NODES),
    F = fun(Node) ->
        case net_adm:ping(Node#ets_kf_nodes.node) of
            pang ->
                ?PRINT("node:~p disconnected!", [Node#ets_kf_nodes.node]),
                ets:delete(?ETS_KF_NODES, {Node#ets_kf_nodes.node, Node#ets_kf_nodes.type});
            _ -> ok
        end
        end,
    lists:map(F, AllNodes),
    check_rg_state(),
    ok.

check_rg_state() ->
    case version:get_lan_config() of
        chn ->
            case config:is_debug() of
                true ->
                    center_node_update();
                false ->
                    center_node_update1()
            end;
        _ ->
            center_node_update()
    end.

%%跨服中心集合
center_node_update() ->
    case is_center_all() of
        true -> skip;
        false ->
            case cross_node:get_cross_area_to_all() of
                none -> skip;
                Node ->
                    case net_adm:ping(Node) of
                        pang ->
                            Cookie = get_cross_cookie(),
                            erlang:set_cookie(Node, Cookie),
                            case net_kernel:connect_node(Node) of
                                true ->
                                    rpc:cast(Node, center, add_center_node, [node()]);
                                _ERR ->
                                    net_kernel:disconnect(Node)
                            end;
                        pong ->
                            rpc:cast(Node, center, add_center_node, [node()])
                    end
            end
    end.

center_node_update1() ->
    case get_rg_node() of
        none -> skip;
        Node ->
            case Node == node() of
                true -> skip;
                false ->
                    case net_adm:ping(Node) of
                        pang ->
                            Cookie = get_cross_cookie(),
                            erlang:set_cookie(Node, Cookie),
                            case net_kernel:connect_node(Node) of
                                true ->
                                    rpc:cast(Node, center, add_center_node, [node()]);
                                _ERR ->
                                    net_kernel:disconnect(Node)
                            end;
                        pong ->
                            rpc:cast(Node, center, add_center_node, [node()])
                    end
            end
    end.

%%热更集合 节点
get_rg_node() ->
    IsDebug = config:is_debug(),
    if IsDebug -> none;
        true ->
            case version:get_lan_config() of
                chn -> 'center_chn0@120.92.142.38';
                fanti -> 'center_tw0@120.92.142.38';
                _ -> none
            end
    end.
