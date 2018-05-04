%% --------------------------------------------------------------------
%% 帮战元素的处理
%% @author abu@jieyou.cn
%% @end
%% --------------------------------------------------------------------
-module(guild_war_elem).
-behaviour(gen_server).

%% export functions
-export([
        start_link/2
        ,click/3
        ,disturb/2
        ,refresh/1
        ,destroy/1
    ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

%% include files
-include("common.hrl").
-include("role.hrl").
-include("looks.hrl").
-include("guild_war.hrl").
%%
-include("map.hrl").

%% elem id
-define(elem_sword_id, 60226).
-define(elem_stone_id, [602291, 602292, 60227]).
-define(elem_stone_blue, 60227).

%% record
-record(state, {
                war_pid = 0
                ,war_map
                ,clickers = []
                ,elems = []
                }).
-record(clicker, {rid, pid = 0, elem_id = 0, click_time = 0}).
-record(guild_war_elem, {elem_id = 0, hp = 0, last_clicker}).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link(Wmap, WarPid) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Wmap, WarPid], []).

%% @spec click(Pid, GuildRole, ElemId) 
%% Pid = pid()
%% GuildRole = #guild_war_role{}
%% ElemId = integer()
%% 点击帮战元素
click(Pid, #guild_war_role{id = Rid, pid = Rpid}, ElemId) when is_pid(Pid) ->
    Pid ! {click, Rid, Rpid, ElemId};
click(_, _, _) ->
    ok.

%% @spec disturb(Pid, GuildRole} 
%% Pid = pid()
%% GuildRole = [#guild_war_role{}, ...]
%% 打断某位玩家的打击帮战元素的行为
disturb(Pid, Groles) when is_list(Groles) andalso is_pid(Pid) ->
    Pid ! {disturb, Groles};
disturb(Pid, Grole) when is_record(Grole, guild_war_role) andalso is_pid(Pid) ->
    Pid ! {disturb, [Grole]};
disturb(Pid, ElemId) when is_integer(ElemId) andalso is_pid(Pid) ->
    Pid ! {disturb, ElemId};
disturb(_Pid, _) ->
    ok.

%% @spec refresh(Pid) 
%% Pid = pid()
%% 重新刷新帮战元素，回到初始状态
refresh(Pid) when is_pid(Pid) ->
    Pid ! {refresh};
refresh(_) ->
    ok.

%% @spec destroy(ElemNo) 
%% ElemNo = integer()
%% 直接破坏晶石
destroy(ElemNo) ->
    ElemId = case ElemNo of
        1 -> 602291;
        2 -> 60227;
        3 -> 602292;
        _ -> 0
    end,
    case whereis(?MODULE) of
        Pid when is_pid(Pid) ->
            ?MODULE ! {destroy, ElemId};
        _ ->
            ok
    end.

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([Wmap, WarPid]) ->
    process_flag(trap_exit, true),
    ElemSword = #guild_war_elem{elem_id = ?elem_sword_id, hp = 0},
    ElemStones = [#guild_war_elem{elem_id = ElemId, hp = ?guild_war_elem_stone_hp} || ElemId <- ?elem_stone_id],
    erlang:send_after(1000, self(), {check}),
    {ok, #state{elems = [ElemSword | ElemStones], war_map = Wmap, war_pid = WarPid}}.

%% @spec: handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

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
%% 点击元素
handle_info({click, Rid, Rpid, ElemId = ?elem_sword_id}, State = #state{clickers = Clickers}) ->
    ?debug_log([click, {Rid, ElemId}]),
    case lists:keyfind(ElemId, #clicker.elem_id, Clickers) of
        false ->
            Clicker = #clicker{elem_id = ElemId, rid = Rid, pid = Rpid, click_time = util:unixtime()},
            guild_war_util:asyn_apply(Rpid, fun apply_click/3, [Clicker, on]),
            {noreply, State#state{clickers = [Clicker | Clickers]}};
        _ ->
            guild_war_util:send_notice(Rpid, ?L(<<"已经有帮主在夺取封印神剑">>), 2),
            {noreply, State}
    end;
handle_info({click, Rid, Rpid, ElemId}, State = #state{clickers = Clickers, elems = Elems}) ->
    ?debug_log([click, {Rid, ElemId}]),
    case lists:keyfind(Rid, #clicker.rid, Clickers) of
        false ->
            case lists:keyfind(ElemId, #guild_war_elem.elem_id, Elems) of
                false ->
                    ?debug_log([not_found, {ElemId, Elems}]),
                    {noreply, State};
                #guild_war_elem{hp = Hp} when Hp =< 0 ->
                    {noreply, State};
                _ ->
                    Clicker = #clicker{elem_id = ElemId, rid = Rid, pid = Rpid, click_time = util:unixtime()},
                    guild_war_util:asyn_apply(Rpid, fun apply_click/3, [Clicker, on]),
                    {noreply, State#state{clickers = [Clicker | Clickers]}}
            end;
        _ ->
            {noreply, State}
    end;
%% 打断
handle_info({disturb, ElemId}, State = #state{clickers = Clickers}) when is_integer(ElemId) ->
    ?debug_log([disturb, ElemId]),
    NewState = do_disturb(elem, ElemId, Clickers, State),
    {noreply, NewState};
handle_info({disturb, Groles}, State) ->
    ?debug_log([disturb, {}]),
    NewState = do_disturb(Groles, State),
    {noreply, NewState};
handle_info({refresh}, State = #state{war_map = Wmap}) ->
    ElemSword = #guild_war_elem{elem_id = ?elem_sword_id, hp = 0},
    ElemStones = [#guild_war_elem{elem_id = ElemId, hp = ?guild_war_elem_stone_hp} || ElemId <- ?elem_stone_id],
    do_refresh(Wmap, ?elem_stone_id),
    {noreply, State#state{elems = [ElemSword | ElemStones], clickers = []}};
handle_info({check}, State) ->
    erlang:send_after(1000, self(), {check}),
    Now = util:unixtime(),
    {NewClickers, NewElems} = do_check(Now, State),
    {noreply, State#state{clickers = NewClickers, elems = NewElems}};

%% 直接破坏晶石
handle_info({destroy, ElemId}, State = #state{elems = Elems}) ->
    NewElems = case lists:keyfind(ElemId, #guild_war_elem.elem_id, Elems) of
        #guild_war_elem{hp = 0} ->
            Elems;
        Elem = #guild_war_elem{} ->
            NewElem = do_npc_hurt_stone(Elem, State),
            Nes = lists:keyreplace(ElemId, #guild_war_elem.elem_id, Elems, NewElem),
            check_allstone_dead(Nes),
            Nes;
        _ ->
            Elems
    end,
    {noreply, State#state{elems = NewElems}};

handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, _State) ->
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
%% 检查攻击帮战元素是否有效
do_check(Now, State = #state{clickers = Clickers, elems = Elems}) ->
    do_check(Now, Clickers, Elems, [], State).

do_check(_Now, [], Elems, Back, _State) ->
    {Back, Elems};
do_check(Now, [H = #clicker{click_time = Ctime, pid = Rpid, elem_id = ElemId} | T], Elems, Back, State) ->
    case Now - Ctime >= ?guild_war_elem_wait of
        true ->
            NewElems = do_check_done(lists:keyfind(ElemId, #guild_war_elem.elem_id, Elems), H, Elems, State),
            guild_war_util:asyn_apply(Rpid, fun apply_click/3, [H, off]),
            do_check(Now, T, NewElems, Back, State);
        false ->
            do_check(Now, T, Elems, [H | Back], State)
    end.

do_check_done(false, _H, Elems, _State) ->
    ?debug_log([do_check, elem_not_found]),
    Elems;
do_check_done(#guild_war_elem{elem_id = ?elem_sword_id}, _Clicker = #clicker{rid = Rid}, Elems, _State = #state{war_pid = Wpid}) ->
    guild_war:credit(Wpid, Rid, sword),
    guild_war_flow:end_war2(),
    Elems;
do_check_done(#guild_war_elem{hp = Hp}, _H, Elems, _State) when Hp =< 0 ->
    Elems;
do_check_done(E = #guild_war_elem{elem_id = ElemId, hp = Hp}, H = #clicker{rid = Rid}, Elems, State = #state{war_pid = Wpid}) ->
    ReduceHp = case ElemId of
        ?elem_stone_blue ->
            ?guild_war_elem_stone_hurt;
        _ ->
            ?guild_war_elem_stone_hurt
    end,
    NewElems = case Hp - ReduceHp of
        R when R > 0 ->
            NewE = E#guild_war_elem{hp = R},
            do_hurt_stone(H, NewE, ReduceHp, State),
            guild_war:credit(Wpid, Rid, stone),
            lists:keyreplace(ElemId, #guild_war_elem.elem_id, Elems, NewE);
        _ ->
            NewE = E#guild_war_elem{hp = 0},
            do_hurt_stone(H, NewE, Hp, State),
            guild_war:credit(Wpid, Rid, stone),
            disturb(self(), ElemId),
            Es = lists:keyreplace(ElemId, #guild_war_elem.elem_id, Elems, NewE),
            check_allstone_dead(Es),
            Es
    end,
    NewElems;
do_check_done(_, _, Elems, _) ->
    Elems.

%% 处理打断
do_disturb([], State) ->
    State;
do_disturb([#guild_war_role{id = Rid, pid = Rpid} | T], State = #state{clickers = Clickers}) ->
    case lists:keyfind(Rid, #clicker.rid, Clickers) of
        false ->
            ?debug_log([do_disturb, {Rid, false}]),
            do_disturb(T, State);
        C ->
            ?debug_log([do_disturb, {Rid, true}]),
            guild_war_util:asyn_apply(Rpid, fun apply_click/3, [C, off]),
            do_disturb(T, State#state{clickers = lists:keydelete(Rid, #clicker.rid, Clickers)})
    end.
do_disturb(elem, _ElemId, _Clicker = [], State) ->
    State;
do_disturb(elem, ElemId, [C = #clicker{rid = Rid, pid = Rpid, elem_id = Eid} | T], State = #state{clickers = Clickers}) when ElemId =:= Eid ->
    guild_war_util:asyn_apply(Rpid, fun apply_click/3, [C, off]),
    do_disturb(elem, ElemId, T, State#state{clickers = lists:keydelete(Rid, #clicker.rid, Clickers)});
do_disturb(elem, ElemId, [_ | T], State) ->
    do_disturb(elem, ElemId, T, State).


%% 点击后玩家的广播处理
apply_click(Role = #role{looks = Looks}, _Clicker, on) ->
    ?debug_log([apply_click, on]),
    NewRole = Role#role{looks = [{?LOOKS_TYPE_GUILD_WAR, 0, 0} | Looks]},
    map:role_update(NewRole),
    {ok, NewRole};

apply_click(Role = #role{looks = Looks}, _Clicker, off) ->
    ?debug_log([apply_click, off]),
    NewRole = Role#role{looks = lists:keydelete(?LOOKS_TYPE_GUILD_WAR, 1, Looks)},
    map:role_update(NewRole),
    {ok, NewRole}.

%% 晶石受到损害时的处理
do_hurt_stone(_Clicker, _Elem = #guild_war_elem{elem_id = ElemId, hp = 0}, _ReduceHp, #state{war_map = {Mpid, Mid}}) ->
    ?debug_log([do_hurt_done, ElemId]),
    case map:elem_info(Mid, ElemId) of
        MapElem = #map_elem{} ->
            case get_broken_stone(ElemId) of
                false ->
                    ok;
                #map_elem{base_id = BaseId, name = Name} ->
                    map:elem_update(Mpid, MapElem#map_elem{status = 0, base_id = BaseId, name = Name})
            end;
        _ ->
            ok
    end;
do_hurt_stone(_Clicker = #clicker{pid = Rpid}, _Elem = #guild_war_elem{elem_id = ElemId, hp = Hp}, ReduceHp, #state{war_map = {Mpid, _}}) ->
    ?debug_log([do_hurt, {Hp, ReduceHp}]),
    guild_war_util:send_notice(Rpid, util:fbin(?L(<<"已破坏封印仙石~w点耐久，继续努力">>), [ReduceHp]), 2),
    map:elem_change(Mpid, ElemId, Hp),
    ok.

%% 机器人破坏晶石
do_npc_hurt_stone(E = #guild_war_elem{elem_id = ElemId, hp = Hp}, #state{war_map = {Mpid, _}}) ->
    %?debug_log([do_npc_hurt_stone, ElemId]),
    ReduceHp = case ElemId of
        ?elem_stone_blue ->
            ?guild_war_elem_stone_hurt;
        _ ->
            ?guild_war_elem_stone_hurt
    end,
    NewElem = case Hp - ReduceHp of
        R when R > 0 ->
            NewE = E#guild_war_elem{hp = R},
            NewE;
        _ ->
            NewE = E#guild_war_elem{hp = 0},
            disturb(self(), ElemId),
            NewE
    end,
    map:elem_change(Mpid, ElemId, NewElem#guild_war_elem.hp),
    NewElem.

%% 重新刷新
do_refresh(_, []) ->
    ok;
do_refresh({Mpid, Mid}, [H | T]) ->
    case map:elem_info(Mid, H) of
        MapElem = #map_elem{} ->
            case get_completed_stone(H) of
                false ->
                    do_refresh({Mpid, Mid}, T);
                #map_elem{base_id = BaseId, name = Name} ->
                    map:elem_update(Mpid, MapElem#map_elem{status = ?guild_war_elem_stone_hp, base_id = BaseId, name = Name}),
                    do_refresh({Mpid, Mid}, T)
            end;
        _ ->
            do_refresh({Mpid, Mid}, T)
    end.

%% 取得破碎的晶石
get_broken_stone(?elem_stone_blue) ->
    map_data_elem:get(60228);
get_broken_stone(_) ->
    map_data_elem:get(60230).

%% 取得完整的晶石
get_completed_stone(?elem_stone_blue) ->
    map_data_elem:get(60227);
get_completed_stone(_) ->
    map_data_elem:get(60229).

%% 检查是否所有碑石都挂掉了
check_allstone_dead([]) ->
    %% TODO
    guild_war_flow:end_war1();
check_allstone_dead([#guild_war_elem{elem_id = ?elem_sword_id} | T]) ->
    check_allstone_dead(T);
check_allstone_dead([#guild_war_elem{hp = Hp} | T]) ->
    case Hp =< 0 of
        true ->
            check_allstone_dead(T);
        false ->
            ok
    end.

