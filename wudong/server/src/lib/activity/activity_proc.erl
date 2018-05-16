%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 十二月 2015 下午6:10
%%%-------------------------------------------------------------------
-module(activity_proc).
-author("fengzhenlin").
-include("activity.hrl").
-include("common.hrl").

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([
    get_act_pid/0
]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================
get_act_pid() ->
    case get(?PROC_GLOBAL_ACT) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    put(?PROC_GLOBAL_ACT, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
    {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
    {ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term()} | ignore).
init([]) ->
    process_flag(trap_exit, true),
    %%冲榜活动
    Dict = activity_load:dbget_act_rank(),
    ActRank = #rank_act{
        dict = Dict
    },
    %%冲榜活动
    ActRef = erlang:send_after(3000, self(), act_rank_refresh),
    %%抢购商店
    LimShop = lim_shop:init_global_lim_shop(),
    %%每日充值
    erlang:send_after(5000, self(), daily_charge_init),
    erlang:send_after(7000, self(), acc_charge_turntable_init),
    %%全民福利
    %% 创建开服活动团购首充活动ets表
    open_act_group_charge:init_ets(),
    %% 创建开服活动全服目标活动ets表
    open_act_all_target:init_ets(),
    %% 创建开服活动全服目标2活动ets表
    open_act_all_target2:init_ets(),
    %% 创建开服活动全服目标3活动ets表
    open_act_all_target3:init_ets(),
    %% 创建开服活动返利抢购ets表
    open_act_back_buy:init_ets(),
    %% 创建合服活动团购首充活动ets表
    merge_act_group_charge:init_ets(),
    %% 创建合服活动返利抢购ets表
    merge_act_back_buy:init_ets(),
    %% 创建迷宫寻宝活动ets表
    act_map:init_ets(),
    %% 创建进阶升级日志ets表
    uplv_box:init_ets(),
    %% 创建限时抢购ets数据表
    limit_buy:init_ets(),
    %% 守护副本排行榜
    dungeon_guard:init_rank(),
    %% 金银塔记录
    gold_silver_tower:init_ets(),
    %% 仙境玩家ets数据表
    xj_map:init_ets(),
    %%消费榜活动
    ConsumeRankRef = erlang:send_after(3000, self(), consume_rank_refresh),
    %%充值榜活动
    RechargeRankRef = erlang:send_after(3000, self(), recharge_rank_refresh),
    %% 结婚排行榜活动
    MarryRankRef = erlang:send_after(3000, self(), marry_rank_refresh),
    %% 初始化招财猫ets
    act_wealth_cat:init_ets(),
    %% 初始化新招财猫ets
    act_new_wealth_cat:init_ets(),
    %% 疯狂砸蛋
    act_throw_egg:init_ets(),
    %% 水果大战
    act_throw_fruit:init_ets(),
    %% 天宫寻宝
    act_welkin_hunt:init_ets(),
    %% 一元夺宝
    act_one_gold_buy:init_ets(),
    %% 创建节日活动返利抢购ets表
    festival_back_buy:init_ets(),
    %% 创建节日活动红包ets表
    festival_red_gift:init_ets(),
    %% 初始化节日活动积分数据
    erlang:send_after(100, self(), {festival_red_gift, init_data}),
    %% 初始化系统活动开启信息
    act_open_info:init_ets(),
    %% 初始化玩家活动参与数据
    campaign_join:init_ets(),
    %% 限时仙装活动
    act_limit_xian:init_ets(),
    %% 限时仙宠活动
    act_limit_pet:init_ets(),
    %% 1vn商城配置初始化
    erlang:send_after(1000, self(), {cross_1vn, init_data}),
    spawn(fun() -> timer:sleep(1000), open_act_all_target:init() end),
    spawn(fun() -> timer:sleep(1000), open_act_all_target2:init() end),
    spawn(fun() -> timer:sleep(1000), open_act_all_target3:init() end),
    spawn(fun() -> timer:sleep(1500), open_act_group_charge:init() end),
    spawn(fun() -> timer:sleep(1800), act_map:init() end),
    spawn(fun() -> timer:sleep(2200), open_act_back_buy:init() end),
    spawn(fun() -> timer:sleep(1500), merge_act_group_charge:init() end),
    spawn(fun() -> timer:sleep(2200), merge_act_back_buy:init() end),
    spawn(fun() -> timer:sleep(3000), act_one_gold_buy:init_data() end),
    spawn(fun() -> timer:sleep(1000), campaign_join:load_join_log() end),
    spawn(fun() -> timer:sleep(45000), act_limit_xian:init_data() end),
    spawn(fun() -> timer:sleep(10000), act_wishing_well:init_data() end),
    spawn(fun() -> timer:sleep(10000), cross_act_wishing_well:init_data() end),
    spawn(fun() -> timer:sleep(2000), act_cbp_rank:init_data() end),
    spawn(fun() -> timer:sleep(45000), act_limit_pet:init_data() end),
    spawn(fun() -> timer:sleep(3000), activity_area_group:init_area_group_all() end),
    {ok, #state{refresh_times = 0, act_rank = ActRank, act_rank_ref = ActRef, lim_shop = LimShop, consume_rank_ref = ConsumeRankRef, recharge_rank_ref = RechargeRankRef, marry_rank_ref = MarryRankRef}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
    State :: #state{}) ->
    {reply, Reply :: term(), NewState :: #state{}} |
    {reply, Reply :: term(), NewState :: #state{}, timeout() | hibernate} |
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), Reply :: term(), NewState :: #state{}} |
    {stop, Reason :: term(), NewState :: #state{}}).
handle_call(Request, From, State) ->
    case catch activity_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("activity_handle handle_call ~p~n", [Reason]),
            {reply, error, State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #state{}) ->
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), NewState :: #state{}}).
handle_cast(Request, State) ->
    case catch activity_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("activity_handle handle_cast ~p~n", [Reason]),
            {noreply, State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #state{}) ->
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), NewState :: #state{}}).
handle_info(Info, State) ->
    case catch activity_handle:handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("activity_handle handle_info ~p~n", [Reason]),
            {noreply, State}
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #state{}) -> term()).
terminate(_Reason, State) ->
    activity_load:dbup_lim_shop(State#state.lim_shop),
    limit_buy:logout(),
    act_open_info:logout(),
    act_one_gold_buy:sys_logout(),
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
    Extra :: term()) ->
    {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
