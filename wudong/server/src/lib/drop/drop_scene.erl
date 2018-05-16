%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 掉落场景服务
%%% @end
%%% Created : 04. 十一月 2015 下午2:02
%%%-------------------------------------------------------------------
-module(drop_scene).
-author("fancy").

-behaviour(gen_server).
-include("common.hrl").
-include("drop.hrl").
-include("server.hrl").

%% API
-export([
    start_link/0,
    drop_to_scene/1,
    drop_to_cross_scene/1,
    get_drop_pid/0,
    get_scene_drop_list/3,
    get_cross_scene_drop_list/5,
    dungeon_pickup/3,
    cross_pickup/11,
    pickup/7,

    gm_clean_scene_drop/1
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {ref = none}).

%%%===================================================================
%%% API
%%%===================================================================
gm_clean_scene_drop(Scene) ->
    get_drop_pid() ! {gm_clean_scene_drop, Scene}.

get_drop_pid() ->
    misc:whereis_name(local, ?MODULE).

%%掉落到场景
drop_to_scene(DropGoods) ->
    case scene:is_cross_scene(DropGoods#drop_goods.scene) andalso DropGoods#drop_goods.node /= none of
        true ->
            cross_area:apply(drop_scene, drop_to_cross_scene, [DropGoods]);
        false ->
            get_drop_pid() ! {drop, DropGoods}
    end.

drop_to_cross_scene(DropGoods) ->
    get_drop_pid() ! {drop, DropGoods}.

%%获取场景掉落列表
get_scene_drop_list(Scene, Copy, Pkey) ->
    ?CALL(get_drop_pid(), {get_drop_list, Scene, Copy, Pkey}).

get_cross_scene_drop_list(Node, Pid, Scene, Copy, Pkey) ->
    ?CAST(get_drop_pid(), {get_cross_drop_list, Node, Pid, Scene, Copy, Pkey}).

dungeon_pickup(_Scene, _Copy, _Pkey) ->
    ok.
%%    ?CAST(get_drop_pid(), {dungeon_pickup, Scene, Copy, Pkey}).

cross_pickup(Node, Pid, Scene, Copy, X, Y, Key, Pkey, Lv, DropHasNum, Sid) ->
    ?CAST(get_drop_pid(), {cross_pickup, Node, Pid, Scene, Copy, X, Y, Key, Pkey, Lv, DropHasNum, Sid}).
%%拾取
pickup(Scene, Copy, X, Y, Key, Pkey, DailyPickUpRedDrop) ->
    ?CALL(get_drop_pid(), {pickup, Scene, Copy, X, Y, Key, Pkey, DailyPickUpRedDrop}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server

init([]) ->
    Ref = erlang:send_after(5000, self(), clean_scene_drop),
    {ok, #state{ref = Ref}}.

%%获取掉落列表
handle_call({get_drop_list, Scene, TarCopy, Pkey}, _From, State) ->
    F = fun(DropGoods) ->
        case DropGoods#drop_goods.scene == Scene andalso
            DropGoods#drop_goods.copy == TarCopy andalso
            (DropGoods#drop_goods.owner == Pkey orelse DropGoods#drop_goods.owner == 0) andalso
            (DropGoods#drop_goods.hurt_share == [] orelse lists:member(Pkey, DropGoods#drop_goods.hurt_share) == true) of
            true ->
                [[DropGoods#drop_goods.key, DropGoods#drop_goods.goodstype, DropGoods#drop_goods.num, DropGoods#drop_goods.x, DropGoods#drop_goods.y]];
            false -> []
        end
        end,
    GoodsList = lists:flatmap(F, get_drop_list()),
    {reply, GoodsList, State};

%%拾取掉落
handle_call({pickup, Scene, Copy, X, Y, Key, Pkey, DailyPickUpRedDrop}, _From, State) ->
    DropList = get_drop_list(),
    Reply =
        case lists:keytake(Key, #drop_goods.key, DropList) of
            false -> {fail, 2};
            {value, DropGoods, NewDropList} ->
                %%红名掉落限制
                case DropGoods#drop_goods.from == 307 andalso DailyPickUpRedDrop >= data_prison:get_daily_pick_up() of
                    true ->
                        {fail, 25};
                    false ->
                        case DropGoods#drop_goods.scene == Scene andalso DropGoods#drop_goods.copy == Copy of
                            false ->
                                {fail, 3};
                            true ->
                                case abs(X - DropGoods#drop_goods.x) < 4 andalso abs(Y - DropGoods#drop_goods.y) < 4 of
                                    false ->
                                        {fail, 3};
                                    true ->
                                        case DropGoods#drop_goods.owner == 0 orelse Pkey == DropGoods#drop_goods.owner of
                                            false -> {fail, 12};
                                            true ->
                                                case DropGoods#drop_goods.hurt_share == [] orelse lists:member(Pkey, DropGoods#drop_goods.hurt_share) of
                                                    false -> {fail, 13};
                                                    true ->
                                                        set_drop_list(NewDropList),
                                                        %%广播消失
                                                        {ok, Bin} = pt_120:write(12022, {[Key]}),
                                                        server_send:send_to_scene(Scene, Copy, DropGoods#drop_goods.x, DropGoods#drop_goods.y, Bin),
                                                        {ok, DropGoods}
                                                end
                                        end
                                end
                        end
                end

        end,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.


%%副本掉落捡取
handle_cast({dungeon_pickup, Scene, Copy, Pkey}, State) ->
    F = fun(DropGoods, {DropList, FetchList}) ->
        if DropGoods#drop_goods.scene == Scene andalso DropGoods#drop_goods.copy == Copy andalso (DropGoods#drop_goods.owner == 0 orelse Pkey == DropGoods#drop_goods.owner) ->
            {DropList, [DropGoods | FetchList]};
            true ->
                {[DropGoods | DropList], FetchList}
        end
        end,
    {DropList1, FetchList} = lists:foldl(F, {[], []}, get_drop_list()),
    set_drop_list(DropList1),
    case [{DG#drop_goods.goodstype, DG#drop_goods.num} || DG <- FetchList] of
        [] -> skip;
        GoodsList ->
            case player_util:get_player_online(Pkey) of
                [] ->
                    {Title, Content} = t_mail:mail_content(36),
                    mail:sys_send_mail([Pkey], Title, Content, GoodsList),
                    ok;
                OnLine ->
                    OnLine#ets_online.pid ! {dungeon_pickup, GoodsList}
            end
    end,
    {noreply, State};


%%跨服获取掉落物品列表
handle_cast({get_cross_drop_list, Node, Pid, Scene, TarCopy, Pkey}, State) ->
    F = fun(DropGoods) ->
        case DropGoods#drop_goods.scene == Scene andalso
            DropGoods#drop_goods.copy == TarCopy andalso
            (DropGoods#drop_goods.owner == Pkey orelse DropGoods#drop_goods.owner == 0) andalso
            (DropGoods#drop_goods.hurt_share == [] orelse lists:member(Pkey, DropGoods#drop_goods.hurt_share) == true) of
            true ->
                [[DropGoods#drop_goods.key, DropGoods#drop_goods.goodstype, DropGoods#drop_goods.num, DropGoods#drop_goods.x, DropGoods#drop_goods.y]];
            false -> []
        end
        end,
    GoodsList = lists:flatmap(F, get_drop_list()),
    {ok, Bin} = pt_120:write(12021, {GoodsList}),
    center:apply(Node, server_send, send_to_pid, [Pid, Bin]),
    {noreply, State};

handle_cast({cross_pickup, Node, Pid, Scene, Copy, X, Y, Key, Pkey, Lv, DropHasNum, _Sid}, State) ->
    DropList = get_drop_list(),
    Now = util:unixtime(),
    Reply =
        case lists:keytake(Key, #drop_goods.key, DropList) of
            false -> {fail, 2};
            {value, DropGoods, NewDropList} ->
                case DropGoods#drop_goods.scene == Scene andalso DropGoods#drop_goods.copy == Copy of
                    false ->
                        {fail, 3};
                    true ->
                        case abs(X - DropGoods#drop_goods.x) < 4 andalso abs(Y - DropGoods#drop_goods.y) < 4 of
                            false ->
                                {fail, 3};
                            true ->
                                case DropGoods#drop_goods.owner == 0 orelse Pkey == DropGoods#drop_goods.owner of
                                    false -> {fail, 12};
                                    true ->
                                        case DropGoods#drop_goods.hurt_share == [] orelse lists:member(Pkey, DropGoods#drop_goods.hurt_share) of
                                            false -> {fail, 13};
                                            true ->
                                                case lists:keyfind(drop_pickup_time, 1, DropGoods#drop_goods.args) of
                                                    {_drop_pickup_time, Time} when Time > Now -> %% 掉落领取时间限制
                                                        case lists:keyfind(drop_has_pkey, 1, DropGoods#drop_goods.args) of
                                                            {drop_has_pkey, HasPkey, StartRecvTime} when HasPkey == Pkey -> %% 只有归属玩家才能领取
                                                                if
                                                                    StartRecvTime > Now -> {fail, 21}; %% 归属主人，领取时间没达到
                                                                    true ->
                                                                        case lists:keyfind(drop_pickup_limit_lv, 1, DropGoods#drop_goods.args) of
                                                                            false ->
                                                                                set_drop_list(NewDropList),
                                                                                %%广播消失
                                                                                {ok, Bin} = pt_120:write(12022, {[Key]}),
                                                                                case scene:is_broadcast_scene(Scene) of
                                                                                    true ->
                                                                                        server_send:rpc_node_apply(Node, server_send, send_to_scene, [Scene, Copy, Bin]);
                                                                                    false ->
                                                                                        server_send:rpc_node_apply(Node, server_send, send_to_scene, [Scene, Copy, X, Y, Bin])
                                                                                end,
                                                                                {ok, DropGoods};
                                                                            {drop_pickup_limit_lv, LimitLv} ->
                                                                                if
                                                                                    LimitLv < Lv ->
                                                                                        {fail, 26}; %% 拾取等级限制
                                                                                    true ->
                                                                                        set_drop_list(NewDropList),
                                                                                        %%广播消失
                                                                                        {ok, Bin} = pt_120:write(12022, {[Key]}),
                                                                                        case scene:is_broadcast_scene(Scene) of
                                                                                            true ->
                                                                                                server_send:rpc_node_apply(Node, server_send, send_to_scene, [Scene, Copy, Bin]);
                                                                                            false ->
                                                                                                server_send:rpc_node_apply(Node, server_send, send_to_scene, [Scene, Copy, X, Y, Bin])
                                                                                        end,
                                                                                        {ok, DropGoods}
                                                                                end
                                                                        end
                                                                end;
                                                            _ ->
                                                                {fail, 22} %% 掉落领取时间限制
                                                        end;
                                                    _ -> %% 限制时间到，全部玩家key领取
                                                        BaseHasNum = data_cross_boss_has_num:get(),
                                                        if
                                                            DropHasNum >= BaseHasNum ->
                                                                {fail,24};
%%                                                                 {ok, Bin} = pt_120:write(12023, {24, Key, 0, 0, 0}),
%%                                                                 server_send:send_to_sid(Sid, Bin),
%%                                                                 ok;
                                                            true ->
                                                                case lists:keyfind(drop_pickup_limit_lv, 1, DropGoods#drop_goods.args) of
                                                                    false ->
                                                                        set_drop_list(NewDropList),
                                                                        %%广播消失
                                                                        {ok, Bin} = pt_120:write(12022, {[Key]}),
                                                                        case scene:is_broadcast_scene(Scene) of
                                                                            true ->
                                                                                server_send:rpc_node_apply(Node, server_send, send_to_scene, [Scene, Copy, Bin]);
                                                                            false ->
                                                                                server_send:rpc_node_apply(Node, server_send, send_to_scene, [Scene, Copy, X, Y, Bin])
                                                                        end,
                                                                        {ok, DropGoods};
                                                                    {drop_pickup_limit_lv, LimitLv} ->
                                                                        if
                                                                            LimitLv < Lv ->
                                                                                {fail, 26}; %% 拾取等级限制
                                                                            true ->
                                                                                set_drop_list(NewDropList),
                                                                                %%广播消失
                                                                                {ok, Bin} = pt_120:write(12022, {[Key]}),
                                                                                case scene:is_broadcast_scene(Scene) of
                                                                                    true ->
                                                                                        server_send:rpc_node_apply(Node, server_send, send_to_scene, [Scene, Copy, Bin]);
                                                                                    false ->
                                                                                        server_send:rpc_node_apply(Node, server_send, send_to_scene, [Scene, Copy, X, Y, Bin])
                                                                                end,
                                                                                {ok, DropGoods}
                                                                        end
                                                                end
                                                        end
                                                end
                                        end
                                end
                        end
                end
        end,
    case Reply of
        {fail, Err} ->
            {ok, Bin1} = pt_120:write(12023, {Err, Key, 0, 0, 0}),
            center:apply(Node, server_send, send_to_pid, [Pid, Bin1]);
        {ok, NewDropGoods} ->
            server_send:send_node_pid(Node, Pid, {cross_pickup, NewDropGoods})

    end,
    {noreply, State};

handle_cast(_Request, State) ->
    {noreply, State}.

%%掉落
handle_info({drop, DropGoods}, State) ->
    DropList = [DropGoods | lists:keydelete(DropGoods#drop_goods.key, #drop_goods.key, get_drop_list())],
    set_drop_list(DropList),
    X = DropGoods#drop_goods.x,
    Y = DropGoods#drop_goods.y,
    X1 = max(0, util:list_rand([X - 1, X, X + 1])),
    Y1 = max(0, util:list_rand([Y - 1, Y, Y + 1])),
    {ok, Bin} = pt_120:write(12021, {[[DropGoods#drop_goods.key, DropGoods#drop_goods.goodstype, DropGoods#drop_goods.num, X1, Y1]]}),
    if
        DropGoods#drop_goods.owner == 0 ->
            case scene:is_broadcast_scene(DropGoods#drop_goods.scene) orelse scene:is_cross_scene(DropGoods#drop_goods.scene) of
                true ->
                    server_send:rpc_node_apply(DropGoods#drop_goods.node, server_send, send_to_scene, [DropGoods#drop_goods.scene, DropGoods#drop_goods.copy, Bin]);
                false ->
                    server_send:rpc_node_apply(DropGoods#drop_goods.node, server_send, send_to_scene, [DropGoods#drop_goods.scene, DropGoods#drop_goods.copy, DropGoods#drop_goods.x, DropGoods#drop_goods.y, Bin])
            end;
        true ->
            server_send:rpc_node_apply(DropGoods#drop_goods.node, server_send, send_to_key, [DropGoods#drop_goods.owner, Bin])
    end,
    {noreply, State};

%%定时清理
handle_info(clean_scene_drop, State) ->
        catch erlang:cancel_timer(State#state.ref),
    Ref = erlang:send_after(5000, self(), clean_scene_drop),
    Now = util:unixtime(),
    Node = node(),
    F = fun(DropGoods) ->
        if Now > DropGoods#drop_goods.expire ->
            {ok, Bin} = pt_120:write(12022, {[DropGoods#drop_goods.key]}),
            case DropGoods#drop_goods.node == Node of
                true ->
                    server_send:send_to_scene(DropGoods#drop_goods.scene, DropGoods#drop_goods.copy, DropGoods#drop_goods.x, DropGoods#drop_goods.y, Bin);
                false ->
                    server_send:rpc_node_apply(DropGoods#drop_goods.node, server_send, send_to_scene, [DropGoods#drop_goods.scene, DropGoods#drop_goods.copy, DropGoods#drop_goods.x, DropGoods#drop_goods.y, Bin])
            end,
            [];
            true ->
                [DropGoods]
        end
        end,
    DropList = lists:flatmap(F, get_drop_list()),
    set_drop_list(DropList),
    {noreply, State#state{ref = Ref}};

handle_info({gm_clean_scene_drop, Scene}, State) ->
    DropList = get_drop_list(),
    F = fun(#drop_goods{scene = Scene0}) ->
        Scene /= Scene0
        end,
    NewDropList = lists:filter(F, DropList),
    set_drop_list(NewDropList),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.


terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
get_drop_list() ->
    case get(drop_list) of
        undefined -> [];
        DropList -> DropList
    end.
set_drop_list(DropList) ->
    put(drop_list, DropList).

