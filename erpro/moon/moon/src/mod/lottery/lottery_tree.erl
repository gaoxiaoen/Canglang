%%----------------------------------------------------
%% @doc 摇钱树功能（晶钻换金币）都是福利彩，统一放lottery系列
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-module(lottery_tree).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% 外部接口
-export([
        get_free_time/2,
        get_rest_time/2,
        get_logs/1,
        get_info/1,
        shake/1,
        shake_all/1,
        login/1,
        logout/1
    ]).

-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("lottery_tree.hrl").
%%
-include("vip.hrl").

%% 内部状态
-record(state, {
        ver = 0,    %% 版本号
        log = [],   %% 要钱记录
        big_money = [], %% 大奖记录
        pool = 0,  %% 系统总奖池
        is_open = 1 %% 系统是否开放
    }).

-define(lottery_tree_max_time, 11). %% 每天最多可摇多少次
-define(lottery_tree_free_time, 1). %% 每天可免费摇多少次
-define(lottery_tree_list_size, 20). %% 返回多少条记录给界面
-define(lottery_tree_base_cost, pay:price(?MODULE, lottery_tree_base_cost, null)). %% 摇钱树扣除晶钻基数
-define(lottery_tree_switch_lev, 40). %% 摇钱树等级限定开关
-define(lottery_tree_log_size, 100). %% 摇钱日志长度

%%%----------------- 外部函数定义-------------------

%% @spec get_free_time(MoneyTree, Vip) -> Times
%% MoneyTree = record(money_tree)
%% Vip = #vip{}
%%  Times = integer()
%% @doc 获取玩家的免费摇钱次数
get_free_time(#money_tree{times = Times, last_shaked = OldLastShaked}, Vip) ->
    VipFree = get_vip_free(Vip),
    case util:is_same_day2(util:unixtime(), OldLastShaked) of
        true ->
            max(0, ?lottery_tree_free_time + VipFree - Times);
        _ -> ?lottery_tree_free_time + VipFree
    end;
get_free_time(_, _) ->
    0.

%% @spec get_rest_time(MoneyTree) -> Times
%% MoneyTree = record(money_tree)
%%  Times = integer()
%% @doc 获取摇钱树剩余次数
get_rest_time(#money_tree{times = Times, last_shaked = OldLastShaked}, Vip) ->
    VipFree = get_vip_free(Vip),
    case util:is_same_day2(util:unixtime(), OldLastShaked) of
        true ->
            max(0, ?lottery_tree_max_time + VipFree - Times);
        _ ->
            ?lottery_tree_max_time + VipFree
    end;
get_rest_time(_, _) ->
    0.

%% @spec get_logs(Role) -> {Times, Logs}
%% Role = record(role)
%% Times = integer()
%% Logs = list()
%% @doc 获取个人剩余次数和摇钱树界面的摇钱记录
get_logs(#role{money_tree = MoneyTree, vip = Vip}) ->
    RestTime = get_rest_time(MoneyTree, Vip),
    Logs = case sync_call({info, logs}) of
        [] -> [];
        List -> lists:sublist(List, 1, ?lottery_tree_list_size)
    end,
    {RestTime, Logs}.

%% @spec shake(Role) -> {ok, NewRole} | {fail, Why}
%% Role = NewRole = record(role)
%% @doc 摇一下树
%% 等级不够
shake(#role{lev = Lev}) when Lev < ?lottery_tree_switch_lev ->
    lev_not;
%% 玩家免费摇钱获得的金币数目固定为：获得金币数 = 90% * [1300 *（玩家等级-10）]
shake(Role = #role{id = Id, name = Name, lev = Lev, money_tree = MoneyTree = #money_tree{times = Times, last_shaked = OldLastShaked}, vip = Vip}) ->
    Now = util:unixtime(),
    VipFree = get_vip_free(Vip),
    case util:is_same_day2(Now, OldLastShaked) of
        %%次数用完
        true  when Times >= ?lottery_tree_max_time + VipFree ->
            over_time;
        %% 免费一次
        true  when ?lottery_tree_free_time + VipFree > Times ->
            NewLv = max(0, Lev - 10),
            Coin = round(0.9 * (1300 * NewLv)),
            case role_gain:do([#gain{label = coin_bind, val = Coin}], Role) of
                {ok, NewRole} ->
                    NewMoneyTree = MoneyTree#money_tree{times = Times + 1, last_shaked = Now},
                    {ok, NewRole#role{money_tree = NewMoneyTree}, ?lottery_tree_max_time + VipFree - Times - 1, Coin, 0};
                _ ->
                    error
            end;
        true ->
            %% 玩家使用晶钻摇钱每次获得的金币数公式为：获得金币数 = 90% ~ 110% * [1300 *（玩家等级-10）]  (在特定值的基础上下波动10%)，同时玩家有2%概率获得双倍金币奖励。
            Cost = (Times - ?lottery_tree_free_time - VipFree) * ?lottery_tree_base_cost + ?lottery_tree_base_cost,
            case role_gain:do([#loss{label = gold, val = Cost}], Role) of
                {ok, NR} ->
                    NewLv = max(0, Lev - 10),
                    Ratio = util:rand(9, 11) / 10,
                    Coin = round(Ratio * (1300 * NewLv)),
                    {NewCoin, Double} = case util:rand(1, 100) < 2 of
                        true -> {Coin * 2, 1};
                        _ -> {Coin, 0}
                    end,
                    case role_gain:do([#gain{label = coin_bind, val = NewCoin}], NR) of
                        {ok, NewRole} ->
                            NewMoneyTree = MoneyTree#money_tree{times = Times + 1, last_shaked = Now},
                            sync_call({shake, 1, Id, Name, NewCoin, Now, Double}),
                            case Double of
                                1 ->
                                    {Rid, RSrvId} = Id,
                                    Msg = util:fbin(?L(<<"~s在摇钱时幸运的获得双倍金币奖励，获得了~w绑定金币。{open, 31, 我要摇钱, ffe100}">>), [notice:role_to_msg({Rid, RSrvId, Name}), NewCoin]),
                                    notice:send(52, Msg);
                                _ ->
                                    ok
                            end,
                            {ok, NewRole#role{money_tree = NewMoneyTree}, ?lottery_tree_max_time + VipFree - Times - 1, NewCoin, Double};
                        _R ->
                            ?DEBUG("摇钱树增加铜币 ~w", [_R]),
                            error
                    end;
                _R ->
                    ?DEBUG("摇钱树扣除晶钻结果 ~w", [_R]),
                    gold_lack
            end;
        %% 跨天从第一次开始
        _ ->
            NewLv = max(0, Lev - 10),
            Coin = round(0.9 * (1300 * NewLv)),
            case role_gain:do([#gain{label = coin_bind, val = Coin}], Role) of
                {ok, NewRole} ->
                    NewMoneyTree = MoneyTree#money_tree{times = 1, last_shaked = Now},
                    {ok, NewRole#role{money_tree = NewMoneyTree}, ?lottery_tree_max_time + VipFree - 1, Coin, 0};
                _ ->
                    error
            end
    end.

%% @spec shake_all(Role) -> {ok, NewRole} | {fail, Why}
%% Role = NewRole = record(role)
%% @doc 一键摇树
%% 等级不够
shake_all(#role{lev = Lev}) when Lev < ?lottery_tree_switch_lev ->
    lev_not;
shake_all(Role = #role{id = Id, name = Name, lev = Lev, money_tree = MoneyTree = #money_tree{times = Times, last_shaked = OldLastShaked}, vip = Vip}) ->
    Now = util:unixtime(),
    VipFree = get_vip_free(Vip),
    case util:is_same_day2(Now, OldLastShaked) of
        %% 次数用完
        true when Times >= ?lottery_tree_max_time + VipFree ->
            over_time;
        true ->
            case get_loss_and_gain(Lev, Times, 0, 0, VipFree) of
                {Gold, Coin} when Gold =/= 0 andalso Coin =/= 0 ->
                    case role_gain:do([#loss{label = gold, val = Gold}], Role) of
                        {ok, NR} ->
                            case role_gain:do([#gain{label = coin_bind, val = Coin}], NR) of
                                {ok, NewRole} ->
                                    NewMoneyTree = MoneyTree#money_tree{times = ?lottery_tree_max_time + VipFree, last_shaked = Now},
                                    %% 只剩一次时就用12来代替，以便区分普通摇一次的效果
                                    LogTimes = case ?lottery_tree_max_time + VipFree - Times of
                                        1 -> ?lottery_tree_max_time + VipFree + 1;
                                        TT -> TT
                                    end,
                                    sync_call({shake, LogTimes, Id, Name, Coin, Now, 0}),
                                    {Rid, RSrvId} = Id,
                                    Msg = util:fbin(?L(<<"~s人品大爆发，使用一键摇钱获得了~w绑定金币的巨款。{open, 31, 我要摇钱, ffe100}">>), [notice:role_to_msg({Rid, RSrvId, Name}), Coin]),
                                    notice:send(52, Msg),
                                    {ok, NewRole#role{money_tree = NewMoneyTree}, 0, Coin};
                                _R ->
                                    ?DEBUG("摇钱树增加铜币 ~w", [_R]),
                                    error
                            end;
                        _R ->
                            ?DEBUG("摇钱树扣除晶钻结果 ~w", [_R]),
                            gold_lack
                    end
            end;
        %% 跨天从第一次开始
        _ ->
            case get_loss_and_gain(Lev, 0, 0, 0, VipFree) of
                {Gold, Coin} when Gold =/= 0 andalso Coin =/= 0 ->
                    case role_gain:do([#loss{label = gold, val = Gold}], Role) of
                        {ok, NR} ->
                            case role_gain:do([#gain{label = coin_bind, val = Coin}], NR) of
                                {ok, NewRole} ->
                                    NewMoneyTree = MoneyTree#money_tree{times = ?lottery_tree_max_time + VipFree, last_shaked = Now},
                                    %% 只剩一次时就用12来代替，以便区分普通摇一次的效果
                                    sync_call({shake, ?lottery_tree_max_time + VipFree, Id, Name, Coin, Now, 0}),
                                    {Rid, RSrvId} = Id,
                                    Msg = util:fbin(?L(<<"~s人品大爆发，使用一键摇钱获得了~w绑定金币的巨款。{open, 31, 我要摇钱, ffe100}">>), [notice:role_to_msg({Rid, RSrvId, Name}), Coin]),
                                    notice:send(52, Msg),
                                    {ok, NewRole#role{money_tree = NewMoneyTree}, 0, Coin};
                                _R ->
                                    ?DEBUG("摇钱树增加铜币 ~w", [_R]),
                                    error
                            end;
                        _R ->
                            ?DEBUG("摇钱树扣除晶钻结果 ~w", [_R]),
                            gold_lack
                    end
            end
    end.

%% @spec get_info(all) -> State
%% State = record(state)
%% @doc 获取系统状态
get_info(all) ->
    sync_call({info, all}).

%% @spec login(Role) -> NewRole
%% Role = NewRole = record(role)
%% @doc 要钱树登录，处理个人要钱次数（每天清理）
login(Role = #role{money_tree = _M = #money_tree{last_shaked = LastShaked}}) ->
    ?DEBUG("摇钱树信息 ~w", [_M]),
    Now = util:unixtime(),
    case util:is_same_day2(Now, LastShaked) of
        true -> Role;
        _ -> Role#role{money_tree = #money_tree{times = 0}}
    end;
login(Role) ->
    Role#role{money_tree = #money_tree{}}.

%% @spec logout(Role) -> NewRole
%% Role = NewRole = record(role)
%% @doc 玩家退出登录时处理
logout(Role) ->
    Role.

%% -----------otp框架体定义从这里开始------------

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    State = #state{},
    {ok, State}.

%% 每次摇树要记录一下
handle_call({shake, Type, {Id, SrvId}, Name, Coin, Time, Double}, _From, State = #state{log = Log, pool = Pool}) ->
    Shaked = #money_tree_shaked{
        rid = Id,
        srv_id = SrvId,
        name = Name,
        times = Type,
        money = Coin,
        last_shaked = Time,
        is_double = Double
    }, 
    %% 对日志记录数量做限制
    {NewPool, NewLogs} = case Pool > ?lottery_tree_log_size of
        %% 以触发公告的操作作为临界点吧
        true when Type > 1 orelse Double =:= 1 ->
            {?lottery_tree_log_size, lists:sublist([Shaked | Log], 1, ?lottery_tree_log_size)};
        _ ->
            {Pool + 1, [Shaked | Log]}
    end,
    {reply, ok, State#state{log = NewLogs, pool = NewPool}};

%% 获取摇钱记录
handle_call({info, logs}, _From, State = #state{log = Log}) ->
    {reply, Log, State};

%% 返回所有信息
handle_call({info, all}, _From, State) ->
    {reply, State, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------- 内部方法定义开始---------

%% 计算一键摇树应扣晶钻数和获得金币数
get_loss_and_gain(Lev, Times, Gold, OldCoin, VipFree) when ?lottery_tree_free_time + VipFree > Times ->
    NewLv = max(0, Lev - 10),
    Coin = round(0.9 * (1300 * NewLv)),
    get_loss_and_gain(Lev, Times + 1, Gold, OldCoin + Coin, VipFree);
get_loss_and_gain(Lev, Times, Gold, OldCoin, VipFree) when Times < ?lottery_tree_max_time + VipFree ->
    Cost = (Times - ?lottery_tree_free_time - VipFree) * ?lottery_tree_base_cost + ?lottery_tree_base_cost,
    NewLv = max(0, Lev - 10),
    Ratio = util:rand(9, 11) / 10,
    Coin = round(Ratio * (1300 * NewLv)),
    NewCoin = case util:rand(1, 100) < 2 of
        true -> Coin * 2;
        _ -> Coin
    end,
    get_loss_and_gain(Lev, Times + 1, Cost + Gold, NewCoin + OldCoin, VipFree);
get_loss_and_gain(_, _, Gold, Coin, _) ->
    {Gold, Coin}.

get_vip_free(#vip{type = ?vip_month}) -> 1;
get_vip_free(#vip{type = ?vip_half_year}) -> 2;
get_vip_free(_) -> 0.

%% 同步和异步调用
sync_call(Arg) ->
    gen_server:call(?MODULE, Arg).
