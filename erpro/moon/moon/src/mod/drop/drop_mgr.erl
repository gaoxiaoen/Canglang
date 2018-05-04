%%----------------------------------------------------
%% @doc drop
%%
%% 掉落系统全局进程
%% @author yqhuang(QQ:19123767)
%% @end 
%%----------------------------------------------------
-module(drop_mgr).

-behaviour(gen_server).
-export([
        start_link/0
        ,produce/1
        ,get_global_drop_rules/0
        ,update_kill_num/1
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("drop.hrl").

-define(TIME_TICK, 3600 * 1000).      %% TICK时间间隔一小时

%% 进程状态数据
-record(drop_rule_state, {
        superb_prog = []        %% 极品装备掉落进度 list of #drop_rule_superb_prog{}
        ,global_drop_rule = []  %% 全局掉落规则 list of #drop_rule_prog{}
    }
).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

%% @spec start_link() ->
%% 启动掉落系统进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 根据杀死的NPCID列表，产出装备
%% @spec produce(NpcBaseIdList) -> ItemList
%% NpcBaseIdList = list() of integer() NPCID列表
%% ItemList = list() of {integer(), integer()} NPCID,物品ID列表
produce(NpcBaseIdList) when is_list(NpcBaseIdList)->
    gen_server:call(?MODULE, {produce, NpcBaseIdList}).

%% 获取全局掉落概率
get_global_drop_rules() ->
    gen_server:call(?MODULE, {get_global_drop_rules}).

%% 更新怪物被杀次数
update_kill_num(NpcBaseIdList) ->
    gen_server:call(?MODULE, {update_kill_num, NpcBaseIdList}).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    State = do_reload(#drop_rule_state{}),
    self() ! tick,
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

%% 根据杀死的NPCID列表，产出装备
handle_call({produce, NpcBaseIdList}, _From, State) when not is_list(NpcBaseIdList) ->
    ?ERR("传入的NpcBaseIdlist不是List类型~w", [NpcBaseIdList]),
    {reply, [], State};

handle_call({produce, NpcBaseIdList}, _From, State) ->
    {NpcItemList, NewState} = do_produce(NpcBaseIdList, State),
    {reply, NpcItemList, NewState};

%% 获取全局掉落概率
handle_call({get_global_drop_rules}, _From, State = #drop_rule_state{global_drop_rule = DropRules}) ->
    {reply, {DropRules}, State};

%% 更新怪物被杀次数
handle_call({update_kill_num, NpcBaseIdList}, _From, State) ->
    NewState = update_kill_num(npc, NpcBaseIdList, State),
    {reply, {ok}, NewState};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(tick, State) ->
    NewState = save(State),
    erlang:send_after(1200 * 1000, self(), tick),
    {noreply, NewState};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    save(State),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% 私有函数
%%----------------------------------------------------
%% 加载极品物品进度信息
do_reload(State) ->
    case drop_dao:get_all() of
        {false, _} ->
            State;
        {true, Data} ->
            load_data(Data, State)
    end.

load_data([[NpcId, ItemId, TimeStart, DropNum, KillNum] | T], State = #drop_rule_state{superb_prog = SuperbProg}) ->
    case drop_data_mgr:get_superb(NpcId, ItemId) of
        {ok, #drop_rule_superb_base{time_limit = BTimeLimt, upper_limit = BUpLimit, num_limit = BNumLimit}} ->
            Prog = #drop_rule_superb_prog{npc_id = NpcId, item_id = ItemId, time_limit = BTimeLimt, time_start = TimeStart, upper_limit = BUpLimit, drop_num = DropNum, num_limit = BNumLimit, kill_num = KillNum, modified = 0},
            load_data(T, State#drop_rule_state{superb_prog = [Prog | SuperbProg]});
        {false, _Reason} ->
            load_data(T, State)
    end;
load_data([], State) ->
    State.

%% 保存数据
save(State = #drop_rule_state{superb_prog = SuperbProg}) ->
    save_data(SuperbProg, State),
    update_flag(State).

save_data([Prog = #drop_rule_superb_prog{modified = Modified} | T], State) ->
    case Modified =:= 1 of
        true ->
            drop_dao:save(Prog);
        false ->
            unsave
    end,
    save_data(T, State);
save_data([], State) ->
    State.

update_flag(State = #drop_rule_state{superb_prog = SuperbProg}) ->
        NewSuperbProg = update_flag_prog(SuperbProg),
        State#drop_rule_state{superb_prog = NewSuperbProg}.
update_flag_prog([Prog | T]) ->
    Progs = update_flag_prog(T),
    [Prog#drop_rule_superb_prog{modified = 0} | Progs];
update_flag_prog([]) ->
    [].


%% 根据杀死的NPCID列表，产出装备, 这里不需要再判断5/10000的概率
%% @spec do_produce(NpcBaseIdList, State) -> {NpcItemList, NewState}
%% NpcBaseIdList = list() of integer() NPCID列表
%% NpcItemList = list() of {NpdId = integer(), ItemId = integer()} 物品ID列表
%% State = #drop_rule_state{} 掉落状态
do_produce([NpcId | T], State) ->
    ItemId = drop:get_domain_item(superb, NpcId), %% 根据区间信息计算出NpcId掉落物品ItemId
    case drop_data_mgr:get_superb(NpcId, ItemId) of
        {ok, SuperbBase} ->
            {SuperbProg, NewState} = get_superb_prob_record(SuperbBase, State), 
            case check_superb(all, SuperbProg) of
                true -> %% 该怪物可以产生极品装备ItemId
                    NewState2 = update_state(true, NpcId, ItemId, NewState),
                    {DropList, NewState3} = do_produce(T, NewState2),
                    {[{NpcId, ItemId} | DropList], NewState3};
                false ->
                    NewState2 = update_state(false, NpcId, ItemId, NewState),
                     {DropList, NewState3} = do_produce(T, NewState2),
                    {[{NpcId, -1} | DropList], NewState3}
            end;
        {false, _Reason} ->
            ?DEBUG("不存在极品装备掉落数据[NPCID:~w, ItemId:~w]", [NpcId, ItemId]),
            do_produce(T, State)
    end;
do_produce([], State) ->
    {[], State}.

%% 检查指定极品物品掉落进程是否允许掉落物品
%% @check_superb(Type, SuperbProg) -> true | false
%% Type = atom() 检查类型，all | upper_limit | num_limit = 全部 | 指定时间掉落次数限制 | 杀怪物次数限制
%% SuperbProg = #drop_rule_superb_prog{} 极品物品掉落进度
check_superb(all, SuperbProg) ->
    case {check_superb(upper_limit, SuperbProg), check_superb(num_limit, SuperbProg)} of
        {true, true} ->
            true;
        _IDontCare ->
            false
    end;
%% 检查时间内产生极品物品上限
check_superb(upper_limit, #drop_rule_superb_prog{time_limit = TimeLimit, time_start = TimeStart, upper_limit = UpperLimit, drop_num = DropNum}) ->
    Now = util:unixtime(),
    case {(TimeStart + TimeLimit) > Now, UpperLimit > DropNum} of
        {true, true} ->
            true;
        {true, false} ->
            false;
        {false, _} ->
            true
    end;
%% 在限制斩杀怪物次数内不可以掉第二个极品物品
check_superb(num_limit, #drop_rule_superb_prog{num_limit = NumLimit, kill_num = KillNum}) ->
    NumLimit =< KillNum.

%% 获取极品装备掉落进度记录，如果状态信息中存在，则直接取状态信息中，否则新增加一条
%% @spec get_superb_prob_record(SuperbBase, State) -> {SuperbProg, NewState}
get_superb_prob_record(#drop_rule_superb_base{npc_id = NpcId, item_id = ItemId, time_limit = TimeLimit, upper_limit = UpperLimit, num_limit = NumLimit}, State = #drop_rule_state{superb_prog = SuperbProgList}) ->
    MatchList = [Elem || Elem = #drop_rule_superb_prog{npc_id = MNpcId, item_id = MItemId} <- SuperbProgList, MNpcId =:= NpcId, MItemId =:= ItemId],
    case length(MatchList) > 0 of
        true ->
            [SuperbProg | _] = MatchList,
            {SuperbProg#drop_rule_superb_prog{time_limit = TimeLimit, upper_limit = UpperLimit, num_limit = NumLimit}, State};
        false ->
            NewSuperbProg = #drop_rule_superb_prog{npc_id = NpcId, item_id = ItemId, time_limit = TimeLimit, time_start = util:unixtime(), upper_limit = UpperLimit, drop_num = 0, num_limit = NumLimit, kill_num = NumLimit},
            {NewSuperbProg, State#drop_rule_state{superb_prog = [NewSuperbProg | SuperbProgList]}}
    end.

%% 斩杀怪物并判断最终是否产生极品物品后，更新状态信息, 不重新杀怪次数，它单独更新（不掉落装备时也应该更新杀怪次数）
%% @spec update_date(Flag, NpcId, ItemId, State) -> NewState
%% Flag = boolean() 是否产生极品物品
%% NpcId = integer() 怪物ID
%% ItemId = integer() 物品ID
%% State = #drop_rule_state{} 进程状态
%% NewState = #drop_rule_state{} 新进程状态
update_state(true, NpcId, ItemId, State = #drop_rule_state{superb_prog = SuperbProg}) ->
    Progs = [Prog || Prog = #drop_rule_superb_prog{npc_id = PNpcId, item_id = PItemId} <- SuperbProg, PNpcId =:= NpcId, PItemId =:= ItemId],
    case length(Progs) > 0 of
        true ->
            [SuperbP = #drop_rule_superb_prog{time_limit = TimeLimit, time_start = TimeStart, drop_num = DropNum} | _] = Progs,
            Now = util:unixtime(),
            {NewTimeStart, NewDropNum} =
                case (TimeStart + TimeLimit) > Now of
                    true ->
                        {TimeStart, DropNum + 1};
                    false ->
                        {Now, 1}
                end,
            NewKillNum = 0, %% 重置
            NewSuperb = SuperbP#drop_rule_superb_prog{time_start = NewTimeStart, drop_num = NewDropNum, kill_num = NewKillNum, modified = 1},
            NewSuperbProg = [replace_superb_prog(NewSuperb, P) || P <- SuperbProg],
            State#drop_rule_state{superb_prog = NewSuperbProg};
        false ->
            ?ERR("掉落系统找不到掉落进度信息[NpcId:~w ItemId:~w]", [NpcId, ItemId]),
            State
    end;

update_state(false, NpcId, ItemId, State = #drop_rule_state{superb_prog = SuperbProg}) ->
    Progs = [Prog || Prog = #drop_rule_superb_prog{npc_id = PNpcId, item_id = PItemId} <- SuperbProg, PNpcId =:= NpcId, PItemId =:= ItemId],
    case length(Progs) > 0 of
        true ->
            [SuperbP = #drop_rule_superb_prog{time_limit = TimeLimit, time_start = TimeStart, drop_num = DropNum} | _] = Progs,
            Now = util:unixtime(),
            {NewTimeStart, NewDropNum} =
                case (TimeStart + TimeLimit) > Now of
                    true ->
                        {TimeStart, DropNum};
                    false ->
                        {Now, 0}
                end,
            NewSuperb = SuperbP#drop_rule_superb_prog{time_start = NewTimeStart, drop_num = NewDropNum, modified = 1},
            NewSuperbProg = [replace_superb_prog(NewSuperb, P) || P <- SuperbProg],
            State#drop_rule_state{superb_prog = NewSuperbProg};
        false ->
            ?ERR("掉落系统找不到掉落进度信息[NpcId:~w ItemId:~w]", [NpcId, ItemId]),
            State
    end.

%% 更新怪物被杀死次数
%% @spec update_kill_num(Type, NpcList, State) -> NewState
update_kill_num(npc, [NpcId | T], State = #drop_rule_state{superb_prog = SuperbProg}) ->
    case length(SuperbProg) > 0 of
        true ->
            NewProgs = update_kill_num(prog, SuperbProg, NpcId),
            update_kill_num(npc, T, State#drop_rule_state{superb_prog = NewProgs});
        false ->
%%             ?ERR("掉落系统找不到掉落进度信息[NpcId:~w]", [NpcId]),
            update_kill_num(npc, T, State)
    end;
update_kill_num(npc, [], State) ->
    State;

%% 更新指定NPC掉落进度
update_kill_num(prog, [Prog = #drop_rule_superb_prog{npc_id = TNpcId, kill_num = KillNum} | T], NpcId) ->
    case NpcId =:= TNpcId of
        true ->
            NewProgs = update_kill_num(prog, T, NpcId),
            [Prog#drop_rule_superb_prog{kill_num = KillNum + 1, modified = 1} | NewProgs];
        false ->
            NewProgs = update_kill_num(prog, T, NpcId),
            [Prog | NewProgs]
    end;
update_kill_num(prog, [], _NpcId) ->
    [].

replace_superb_prog(NewProg = #drop_rule_superb_prog{npc_id = TNpcId, item_id = TItemId}, Prog = #drop_rule_superb_prog{npc_id = PNpcId, item_id = PItemId}) ->
    case {TNpcId =:= PNpcId, TItemId =:= PItemId} of
        {true, true} ->
            NewProg;
        _Other ->
            Prog
    end.
