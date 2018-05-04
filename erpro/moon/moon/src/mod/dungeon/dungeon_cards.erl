%% --------------------------------------------------------------------
%% 副本翻牌
%% 目前不支持跨服
%% @author mobin
%% @end
%% --------------------------------------------------------------------
-module(dungeon_cards).

-behaviour(gen_server).

%% export functions
-export([
        start/3
        ,choose/4
        ,get_config_item/2
    ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).


-include("common.hrl").
-include("dungeon.hrl").
-include("dungeon_lang.hrl").
-include("gain.hrl").
-include("role.hrl").
-include("link.hrl").
%%
-include("map.hrl").
-include("pos.hrl").
-include("assets.hrl").
-include("attr.hrl").
-include("item.hrl").

-define(default_item, {221101, 1}).
-define(default_other, {221101, 0, 1, 41, 0, 1}).

%% record
%% role_items = [{rid, #gain}]
%% cards =[{Pos, {ItemId, Quantity, Rid}}]
-record(state, {
        role_items = [],
        cards = [],
        cards_id,
        other_items = [],
        dungeon_roles = [],
        dungeon_id = 0
    }
).

-define(cards_count, 4).

-define(proto_cards_role, 1).
-define(proto_cards_over, 2).

%% for test debug
-define(debug_log(P), ?DEBUG("type=~w, value=~w ", P)).
%%-define(debug_log(P), ok).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start(CardsId, DungeonId, DungeonRoles) ->
    case gen_server:start(?MODULE, [CardsId, DungeonId, DungeonRoles], []) of
        {ok, Pid} ->
            Pid ! init,
            {ok, Pid};
        Other ->
            Other
    end.

%% @spec 
%% 玩家选择卡牌
choose(CardsPid, Rid, ConnPid, Pos) ->
    case is_pid(CardsPid) of
        true ->
            CardsPid ! {choose, Rid, ConnPid, Pos};
        false ->
            sys_conn:pack_send(ConnPid, 13516, {})
    end.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([CardsId, DungeonId, DungeonRoles]) ->
    {ok, #state{role_items = [{Rid, {}} || #dungeon_role{rid = Rid} <- DungeonRoles], cards_id = CardsId, dungeon_roles = DungeonRoles, dungeon_id = DungeonId}}.

%% @spec: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%% @spec: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
handle_cast(_Msg, State) ->
    {noreply, State}.

%% @spec: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%% 初始化
handle_info(init, State = #state{dungeon_roles = DungeonRoles, cards_id = CardsId, dungeon_id = DungeonId}) ->
    RoleItems2 = get_roles_item(DungeonRoles, CardsId, DungeonId), 
    %% [{ItemId, Quantity} | ...]
    OtherItems = get_other_items(RoleItems2, CardsId),
    ?debug_log([init_other_item, OtherItems]),
    ?debug_log([init_role_item, RoleItems2]),

    erlang:send_after(11000, self(), {over}),
    {noreply, State#state{role_items = RoleItems2, other_items = OtherItems}};

%% 选择卡牌
handle_info({choose, Rid, ConnPid, Pos}, State = #state{cards = Cards, role_items = RoleItems, 
        dungeon_id = DungeonId, dungeon_roles = DungeonRoles}) ->
    %% {是否可以选牌, 选择的卡牌是否已被选或玩家是否已选择了}
    NewCards = case {lists:keyfind(Rid, 1, RoleItems), [P || {P, {_, _, I}} <- Cards, (P =:= Pos orelse I =:= Rid)]} of
        {{_, Gain = #gain{val = [ItemId, Bind, Quantity]}}, []} ->
            do_gain(Rid, Gain, DungeonId),
            send_cards(RoleItems, get_proto_cards([{Pos, {ItemId, Quantity, Bind, Rid}}], DungeonRoles), ?proto_cards_role),
            case length(RoleItems) =:= length(Cards) + 1 of 
                true ->
                    erlang:send_after(1000, self(), {over});
                false ->
                    ok
            end,
            [{Pos, {ItemId, Quantity, Rid}} | Cards];
        _ ->
            sys_conn:pack_send(ConnPid, 13516, {}),
            Cards
    end,
    ?debug_log([choosed_cards, NewCards]),
    {noreply, State#state{cards = NewCards}};

%% 选择时间结束
handle_info({over}, State = #state{cards = Cards, role_items = RoleItems, other_items = Oitems,
    dungeon_roles = DungeonRoles}) ->
    NchooseCards = [P || P <- [1,2,3,4], lists:keyfind(P, 1, Cards) =:= false],
    Rchoose = do_roles_choose(RoleItems, NchooseCards, Cards, State),
    ?debug_log([over_role, Rchoose]),
    NewCards = Cards ++ Rchoose,
    NchooseCards2 = [P || P <- [1,2,3,4], lists:keyfind(P, 1, NewCards) =:= false],
    Ochoose = do_other_choose(Oitems, NchooseCards2),
    ?debug_log([over_other, Ochoose]),
    send_cards(RoleItems, get_proto_cards(Rchoose ++ Ochoose, DungeonRoles), 2),
    erlang:send_after(1000, self(), {stop}),
    ?debug_log([over, Cards ++ Rchoose ++ Ochoose]),
    {noreply, State#state{cards = Cards ++ Rchoose ++ Ochoose}};

%% 关闭
handle_info({stop}, State) ->
    ?debug_log([stop, {}]),
    {stop, normal, State};
handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, _State) ->
    ?debug_log([terminate, {}]),
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
get_roles_item(DungeonRoles, CardsId, DungeonId) ->
    get_roles_item(DungeonRoles, CardsId, DungeonId, []).

get_roles_item([], _CardsId, _, Return) ->
    Return;
get_roles_item([#dungeon_role{rid = Rid, clear_count = ClearCount} | T], CardsId, DungeonId, Return) ->
    Rewards = case ClearCount of
        0 ->
            %%首次通关翻牌物品是固定的
            case dungeon_data:get(DungeonId) of
                #dungeon_base{first_cards_rewards = _Rewards} ->
                    _Rewards;
                _ ->
                    undefined
            end;
        _ ->
            undefined
    end,
    Gain = case Rewards of
        undefined ->
            case role_api:lookup(by_id, Rid) of
                {ok, _, Role} ->
                    get_config_item(CardsId, Role);
                _ ->
                    {ItemId, Quantity} = ?default_item,
                    #gain{label = item, val = [ItemId, ?item_unbind, Quantity]}
            end;
        _ ->
            #gain{label = item, val = Rewards}
    end,
    get_roles_item(T, CardsId, DungeonId, [{Rid, Gain} | Return]).
    
%% 获取配置物品
get_config_item(CardsId, Role) ->
    case item_gift_data:get_box(CardsId) of
        {false, _} -> 
            {ItemId, Quantity} = ?default_item,
            #gain{label = item, val = [ItemId, 0, Quantity]};
        {Bind, Type, Num, L} -> 
            Param = item:get_gift_list(Type, Num, Bind, L, Role),
            case item:make_gift_list(Param) of
                {ok, [Gain], _CastItems} ->
                    Gain;
                _ -> 
                    {ItemId, Quantity} = ?default_item,
                    #gain{label = item, val = [ItemId, 0, Quantity]}
            end
    end.

%% 非用户获得的物品
get_other_items(RoleItems, CardsId) ->
    get_other_items(RoleItems, CardsId, []).

get_other_items(RoleItems, _CardsId, Return) when length(RoleItems) + length(Return) > ?cards_count ->
    ?ERR("卡牌数量大于4， 可能存在刷副本宝箱的bug"),
    Return;
get_other_items(RoleItems, _CardsId, Return) when length(RoleItems) + length(Return) =:= ?cards_count ->
    Return;
get_other_items(RoleItems, CardsId, Return) ->
    L2 = case item_gift_data:get_box(CardsId) of
        {false, _} ->
            [];
        {_Bind, 0, _Num, L} ->
            L;
        {_Bind, _Type, _Num, L} ->
            flat(L)
    end,
    L3 = lists:filter(fun({BaseId, _, _, _, _, _}) -> 
                case lists:keyfind(BaseId, 1, Return) of
                    false ->
                        case is_role_item(BaseId, RoleItems) of
                            true ->
                                false;
                            false ->
                                true
                        end;
                    _ ->
                        false
                end
        end, L2),
    Other = case lists:keyfind(2, 2, L3) of
        false ->
            case lists:keyfind(1, 2, L3) of
                false ->
                    case util:rand_list(L3) of
                        null ->
                            ?default_other;
                        _Other ->
                            _Other
                    end;
                CastItem2 ->
                    CastItem2
            end;
        CastItem ->
            CastItem
    end,
    {ItemBaseId, Bind, Q} = item:check_pet_item(Other),
    get_other_items(RoleItems, CardsId, [{ItemBaseId, Bind, Q} | Return]).

is_role_item(_TargetId, []) ->
    false;
is_role_item(TargetId, [{_, #gain{label = item, val = [ItemBaseId, _, _]}}| T]) ->
    case TargetId =:= ItemBaseId of
        true ->
            true;
        false ->
            is_role_item(TargetId, T)
    end.

%%
flat(L) ->
    flat(L, []).

flat([], Return) ->
    ?debug_log([flat, Return]),
    Return;
flat([H | T], Return) ->
    flat(T, Return ++ H).

%% 为未选择的玩家 随机选择卡牌 
do_roles_choose(RoleItems, NchooseCards, Cards, State) ->
    do_roles_choose(RoleItems, NchooseCards, Cards, [], State).

do_roles_choose([], _, _, Return, _State) ->
    Return;
do_roles_choose(_RoleItems = [{Rid, Gain = #gain{val = [ItemId, Bind, Quantity]}} | T], NchooseCards, Cards, Return, State = #state{dungeon_id = DungeonId}) ->
    case [I || {_, {_, _, I}} <- Cards, I == Rid] of 
        [] ->
            case util:rand_list(NchooseCards) of
                null ->
                    do_roles_choose(T, NchooseCards, Cards, Return, State);
                Pos ->
                    do_gain(Rid, Gain, DungeonId),
                    NewNcards = lists:delete(Pos, NchooseCards),
                    do_roles_choose(T, NewNcards, Cards, [{Pos, {ItemId, Quantity, Bind, Rid}} | Return], State)
            end;
        _ ->
            do_roles_choose(T, NchooseCards, Cards, Return, State)
    end.
    
%% 其它卡牌随机打开
do_other_choose(Oitems, NchooseCards) ->
    do_other_choose(Oitems, NchooseCards, []).

do_other_choose([], _, Return) ->
    Return;
do_other_choose(_OItems = [{BaseId, Bind, Quantity} | T], NchooseCards, Return) ->
    case util:rand_list(NchooseCards) of
        null ->
            do_other_choose(T, NchooseCards);
        Pos ->
            NewNcards = lists:delete(Pos, NchooseCards),
            do_other_choose(T, NewNcards, [{Pos, {BaseId, Quantity, Bind, 0}} | Return])
    end.

%% 卡牌被选择后，推送到客户端
send_cards([], _, _) ->
    ok;
send_cards(_RoleItems = [{Rid, _} | T], Cards, Type) ->
    case role_api:c_lookup(by_id, Rid, #role.pid) of 
        {ok, _, RolePid} when is_pid(RolePid) ->
            role:apply(async, RolePid, {fun async_send_cards/3, [Cards, Type]});
        _ ->
            ok
    end,
    send_cards(T, Cards, Type).
    
async_send_cards(#role{pid = Pid}, Cards, Type) ->
    ?debug_log([send_cards, {Pid, Cards, Type}]),
    role:pack_send(Pid, 13517, {Type, Cards}),
    {ok}.

%% 处理卡牌信息，适合协议
get_proto_cards(Cards, DungeonRoles) ->
    get_proto_cards(Cards, DungeonRoles, []).
get_proto_cards([], _DungeonRoles, Return) ->
    Return;
get_proto_cards(_Cards = [{Pos, {ItemId, Quantity, Bind, Rid}} | T], DungeonRoles, Return) ->
    case Rid of 
        0 ->
            get_proto_cards(T, DungeonRoles, [{Pos, ItemId, Quantity, Bind, <<>>} | Return]);
        _ ->
            case lists:keyfind(Rid, #dungeon_role.rid, DungeonRoles) of
                #dungeon_role{name = Name} ->
                    get_proto_cards(T, DungeonRoles, [{Pos, ItemId, Quantity, Bind, Name} | Return]);
                _ ->
                    get_proto_cards(T, DungeonRoles, Return)
            end
    end.

%% 处理用户获益
do_gain(Rid, Gain, DungeonId) ->
    case role_api:c_lookup(by_id, Rid, #role.pid) of
        {ok, _, Pid} when is_pid(Pid) ->
            ?debug_log([do_gain, {Rid, Gain}]),
            role:apply(async, Pid, {fun asyn_gain/3, [Gain, DungeonId]});
        _ ->
            ok
    end.

asyn_gain(Role = #role{id = Rid}, Gain = #gain{val = Value, misc = Misc}, DungeonId) ->
    case lists:keyfind(drop_notice, 1, Misc) of 
        {drop_notice, Cast} ->
            %%传闻
            RoleName = notice:get_role_msg(Role),
            DungeonName = notice:get_dungeon_msg(DungeonId),
            Msg = util:fbin(?dungeon_card_cast, [RoleName, DungeonName, notice:item_msg(Value)]),
            role_group:pack_cast(world, 10932, {7, Cast - 1, Msg});
        _ ->
            ignore
    end,
    case role_gain:do([Gain], Role) of 
        {ok, Role2} ->
            log:log(log_dungeon_box, {Role, DungeonId, Gain}),
            {ok, Role2};
        _ ->
            #dungeon_base{type = DungeonType} = dungeon_data:get(DungeonId),
            AwardId = case DungeonType of
                ?dungeon_type_expedition ->
                    108002;
                _ ->
                    104006
            end,
            award:send(Rid, AwardId, [Gain]),
            notice:alert(error, Role, ?MSGID(<<"背包已满，奖励发送到奖励大厅">>)),
            {ok}
    end.

