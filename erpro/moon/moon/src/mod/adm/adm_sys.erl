%%----------------------------------------------------
%% 后台管理对应进程
%%
%% @author yjbgwxf@gmail.com
%%----------------------------------------------------
-module(adm_sys).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([str2term/1, cmd/1, restart/0, start/0, stop/0]).
-export([stats_local_online_num/0]).

-include("common.hrl").
-include("node.hrl").
-include("role.hrl").

-define(bg_minute, 60000).      %% 每分钟60000毫秒
-define(BJ_GMT, 28800).         %% 北京时间与格林威治时间差 28800 = 8*60*60 秒
-define(UNIXDAYTIME, 86400).    %% unixtime 一天86400秒

-define(avg_day_online_stats, {4, 50, 0}).                              %% 在线统计 平均，峰值
-define(clean_online_stats, {4, 55, 0}).                                %% 清理统计数据
-define(user_lost_stats, {5, 0, 0}).                                    %% 玩家流失率统计时间
-define(user_active_stats, {5, 05, 0}).                                 %% 玩家活跃度统计时间
-define(reg_role_lost_stats, {5, 10, 0}).                               %% 新注册玩家流失率统计
-define(gold_stats, {5, 15, 0}).                                        %% 晶钻数值统计
-define(gold_stats_first_charge, {5, 20, 0}).                           %% 晶钻首冲统计
-define(lev_lost_stats, {5, 25, 0}).                                    %% 等级流失率
-define(mystery_consume_stats, {5, 30, 0}).                             %% 神秘商店消耗统计
-define(casino_stats, {5, 35, 0}).                                      %% 仙境寻宝
-define(coin_stats, {5, 40, 0}).                                        %% 金币统计
-define(big_rmb_stats, {4, 0, 0}).                                      %% 大R信息收集

%% @spec restart() -> ok
%% @doc 重启后台管理进程
restart() -> 
    stop(),
    start(),
    ok.

%% @spec start() -> Result
%% @doc 启动管理系统
start() ->
    supervisor:restart_child(sup_master, adm_sys).

%% @spec stop() -> Result
%% @doc 关闭管理系统
stop() ->
    supervisor:terminate_child(sup_master, adm_sys).

%% @spec str2term(BitStr) -> term()
%% BitStr = bitstring()
%% @doc 供后台数据转换
str2term(Term) ->
    {ok, Result} = util:string_to_term(Term),
    Result.

%% @spec cmd(List) -> ok
%% @doc 向管理进程发送命令
cmd([]) -> success;
cmd([H | T]) ->
    Msg = type2msg(H),
    gen_server:cast({global, ?MODULE}, Msg),
    cmd(T).

%% 转换指令消息
type2msg(1) -> avg_day_online_stats_op;
type2msg(2) -> clean_online_stats_op;
type2msg(3) -> user_lost_stats_op;
type2msg(4) -> user_active_stats_op;
type2msg(5) -> reg_role_lost_stats_op;
type2msg(6) -> gold_stats_op;
type2msg(7) -> lev_lost_stats_op;
type2msg(8) -> gold_stats_first_charge_op;
type2msg(9) -> mystery_consume_stats_op;
type2msg(10) -> casino_stats_op;
type2msg(11) -> coin_stats_op;
type2msg(_) -> ok.

%%-----------------------------------------------------------
%% 系统启动接口
%%-----------------------------------------------------------
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%%-----------------------------------------------------------
%% 系统初始化
%%-----------------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    self() ! start,
    erlang:register(adm_sys, self()), 
    ?INFO("[~w] 启动完成...", [?MODULE]),
    {ok, []}.

%%-----------------------------------------------------------
%% handle_call
%%-----------------------------------------------------------
handle_call(_Msg, _From, _State) ->
    {reply, ok, _State}.

%%-----------------------------------------------------------
%% handle_cast
%%-----------------------------------------------------------
handle_cast(avg_day_online_stats_op, _State) ->
    avg_day_online_num(),
    {noreply, _State};
handle_cast(clean_online_stats_op, _State) ->
    clean_online_num_realtime(),
    {noreply, _State};
handle_cast(user_lost_stats_op, _State) ->
    stats_churn_rate(),
    {noreply, _State};
handle_cast(user_active_stats_op, _State) ->
    stats_role_active(),
    {noreply, _State};
handle_cast(reg_role_lost_stats_op, _State) ->
    stats_reg_role_lost(),
    {noreply, _State};
handle_cast(gold_stats_op, _State) ->
    gold_stats(),
    {noreply, _State};
handle_cast(gold_stats_first_charge_op, _State) ->
    gold_stats_first_charge(),
    {noreply, _State};
handle_cast(lev_lost_stats_op, _State) ->
    lev_lost_stats(),
    {noreply, _State};

handle_cast(_Msg, _State) ->
    {noreply, _State}.

%%-----------------------------------------------------------
%% handle_info
%%-----------------------------------------------------------
%% 系统启动后定时操作
handle_info(start, _State) ->
    self() ! online_stats,
    self() ! avg_day_online_stats,
    self() ! clean_online_stats,
    self() ! user_lost_stats,
    self() ! user_active_stats,
    self() ! reg_role_lost_stats,
    self() ! gold_stats,
    self() ! lev_lost_stats,
    self() ! gold_stats_first_charge,
    self() ! mystery_consume_stats,
    self() ! casino_stats,
    self() ! coin_stats,
    self() ! big_rmb_stats,
    {noreply, _State};

%% 大R信息收集
%% 角色名 坐骑阶数	翅膀阶数	仙宠平均潜力	仙宠成长	元神境界均值	八门精纯均值	套装等级
handle_info(big_rmb_stats, _State) ->
    correct(big_rmb_stats_op, ?big_rmb_stats),
    {noreply, _State};

handle_info(big_rmb_stats_op, _State) ->
    %% erlang:send_after(?UNIXDAYTIME * 1000, self(), big_rmb_stats_op),
    erlang:send_after(?UNIXDAYTIME * 1000, self(), big_rmb_stats_op),
    catch big_rmb_stats_collect(),
    {noreply, _State};

%% 校准在线统计平均
handle_info(avg_day_online_stats, _State) ->
    correct(avg_day_online_stats_op, ?avg_day_online_stats),
    {noreply, _State};

handle_info(avg_day_online_stats_op, _State) ->
    erlang:send_after(?UNIXDAYTIME * 1000, self(), avg_day_online_stats_op),
    avg_day_online_num(),
    {noreply, _State};

%% 清理超过三天统计数据
handle_info(clean_online_stats, _State) ->
    correct(clean_online_stats_op, ?clean_online_stats),
    {noreply, _State};

handle_info(clean_online_stats_op, _State) ->
    erlang:send_after(?UNIXDAYTIME * 1000, self(), clean_online_stats_op),
%%    clean_online_num_realtime(),
    {noreply, _State};

%% 统计玩家流失率
handle_info(user_lost_stats, _State) ->
    correct(user_lost_stats_op, ?user_lost_stats),
    {noreply, _State};

handle_info(user_lost_stats_op, _State) ->
    erlang:send_after(?UNIXDAYTIME * 1000, self(), user_lost_stats_op),
    stats_churn_rate(),
    {noreply, _State};

%% 定时统计在线人数
handle_info(online_stats, _State) ->
    erlang:send_after(?bg_minute, self(), online_stats),
    stats_online_num(),
    {noreply, _State};

%% 玩家活跃度统计
handle_info(user_active_stats, _State) ->
    correct(user_active_stats_op, ?user_active_stats),
    {noreply, _State};

handle_info(user_active_stats_op, _State) ->
    erlang:send_after(?UNIXDAYTIME * 1000, self(), user_active_stats_op),
    stats_role_active(),
    {noreply, _State};

%% 新注册玩家流失率统计
handle_info(reg_role_lost_stats, _State) ->
    correct(reg_role_lost_stats_op, ?reg_role_lost_stats),
    {noreply, _State};

handle_info(reg_role_lost_stats_op, _State) ->
    erlang:send_after(?UNIXDAYTIME * 1000, self(), reg_role_lost_stats_op),
    stats_reg_role_lost(),
    {noreply, _State};

%% 晶钻数值统计
handle_info(gold_stats, _State) ->
    correct(gold_stats_op, ?gold_stats),
    {noreply, _State};

handle_info(gold_stats_op, _State) ->
    erlang:send_after(?UNIXDAYTIME * 1000, self(), gold_stats_op),
    gold_stats(),
    {noreply, _State};

%% 晶钻首冲统计
handle_info(gold_stats_first_charge, _State) ->
    correct(gold_stats_first_charge_op, ?gold_stats_first_charge),
    {noreply, _State};

handle_info(gold_stats_first_charge_op, _State) ->
    erlang:send_after(?UNIXDAYTIME * 1000, self(), gold_stats_first_charge_op),
    gold_stats_first_charge(),
    {noreply, _State};

%% 等级流失率
handle_info(lev_lost_stats, _State) ->
    correct(lev_lost_stats_op, ?lev_lost_stats),
    {noreply, _State};

handle_info(lev_lost_stats_op, _State) ->
    erlang:send_after(?UNIXDAYTIME * 1000, self(), lev_lost_stats_op),
    lev_lost_stats(),
    {noreply, _State};

%% 神秘商店消费统计
handle_info(mystery_consume_stats, _State) ->
    correct(mystery_consume_stats_op, ?mystery_consume_stats),
    {noreply, _State};

handle_info(mystery_consume_stats_op, _State) ->
    erlang:send_after(?UNIXDAYTIME * 1000, self(), mystery_consume_stats_op),
    mystery_consume_stats(),
    {noreply, _State};

%% 仙境寻宝
handle_info(casino_stats, _State) ->
    correct(casino_stats_op, ?casino_stats),
    {noreply, _State};

handle_info(casino_stats_op, _State) ->
    erlang:send_after(?UNIXDAYTIME * 1000, self(), casino_stats_op),
    casino_stats(),
    {noreply, _State};

%% 金币统计
handle_info(coin_stats, _State) ->
    correct(coin_stats_op, ?coin_stats),
    {noreply, _State};

handle_info(coin_stats_op, _State) ->
    erlang:send_after(?UNIXDAYTIME * 1000, self(), coin_stats_op),
    coin_stats(),
    {noreply, _State};

%% 容错
handle_info(_Msg, _State) ->
    {noreply, _State}.

%%-----------------------------------------------------------
%% 系统关闭
%%-----------------------------------------------------------
terminate(_Reason, _State) ->
    {noreply, _State}.

%%-----------------------------------------------------------
%% 热代码切换
%%-----------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%-----------------------------------------------------------
%% 私有函数
%%-----------------------------------------------------------
correct(Msg, Op_Time) ->
    Now = calendar:time_to_seconds(time()),
    Time = calendar:time_to_seconds(Op_Time),
    case Now < Time of
        true ->
            erlang:send_after((Time - Now) * 1000, self(), Msg);
        false when Now > Time ->
            erlang:send_after((Time + ?UNIXDAYTIME - Now) * 1000, self(), Msg);
        _ ->
            self() ! Msg
    end.

%% 统计在线人数
stats_online_num() ->
    stats_online_num(sys_node_mgr:list(), util:unixtime()).
stats_online_num([], _Time) ->
    ok;
stats_online_num([#node{name = Node} | T], Time) ->
    case rpc:call(Node, ?MODULE, stats_local_online_num, []) of
        {ok, Num} ->
            adm_sys_db:save_online_num(Time, Node, Num),
            stats_online_num(T, Time);
        _ ->
            stats_online_num(T, Time)
    end.
stats_local_online_num() ->
    {ok, length(ets:tab2list(role_online))}.

%% 求平均在线人数和峰值
avg_day_online_num() ->
    avg_day_online_num(sys_node_mgr:list()).
avg_day_online_num([]) ->
    ok;
avg_day_online_num([#node{name = Node} | T]) ->
    catch adm_sys_db:calc_avg_day_online_num(Node),
    avg_day_online_num(T).

%% 清理在线统计表三天前数据
clean_online_num_realtime() ->
    catch adm_sys_db:clean_online_num_realtime().

%% 统计流失率
stats_churn_rate() ->
    catch adm_sys_db:stats_churn_rate().

%% 玩家活跃度统计
stats_role_active() ->
    catch adm_sys_db:stats_role_active().

%% 新注册玩家流失统计
stats_reg_role_lost() ->
    catch adm_sys_db:stats_reg_role_lost().

%% 晶钻数值统计
gold_stats() ->
    catch adm_sys_db:gold_stats().

%% 晶钻首冲统计
gold_stats_first_charge() ->
    catch adm_sys_db:gold_stats_first_charge().

%% 等级流失率
lev_lost_stats() ->
    catch adm_sys_db:lev_lost_stats().

%% 神秘商店晶钻统计
mystery_consume_stats() ->
    catch adm_sys_db:mystery_consume_stats().

%% 仙境寻宝
casino_stats() ->
    catch adm_sys_db:casino_stats().

%% 金币分析
coin_stats() ->
    catch adm_sys_db:coin_stats().

%% 大R信息收集
big_rmb_stats_collect() ->
    List = adm_sys_db:big_rmb_roles(),
    big_rmb_stats_collect(List).
big_rmb_stats_collect([]) ->
    ?INFO("本服大R信息采集完成并保存镜像数据"),
    ok;
big_rmb_stats_collect([[Rid, SrvId, SumGold] | T]) when SumGold > 10000 ->
    case role_api:lookup(by_id, {Rid, SrvId}) of
        {ok, _, Role} ->
            case catch collect_info(Role) of
                InfoList when is_list(InfoList) ->
                    adm_sys_db:big_rmb_role_image(InfoList);
                _ -> ?ERR("采集数据时发生错误，可能是数据不匹配")
            end;
        _ ->
            case role_data:fetch_role(by_id, {Rid, SrvId}) of
                {ok, Role} ->
                    case catch collect_info(Role) of
                        InfoList when is_list(InfoList) ->
                            adm_sys_db:big_rmb_role_image(InfoList);
                        _ -> ?ERR("采集数据时发生错误，可能是数据不匹配")
                    end;
                _ -> ?ERR("LOAD角色数据出错")
            end
    end,
    big_rmb_stats_collect(T);
big_rmb_stats_collect([_ | T]) ->
    big_rmb_stats_collect(T).

collect_info(Role = #role{id = {Rid, SrvId}, name = Name}) ->
    MountVal = mount:gm_get_mount_grade(Role),
    WingVal = wing:gm_get_wing_grade(Role),
    {PetGrow, PetAvg} = pet:gm_get_pet_info(Role),
    ChannelState = channel:gm_get_channel_state_avg(Role),
    Suit40Num = eqm_api:adm_get_set_num(40, Role) + eqm_api:adm_get_set_num(45, Role),
    Suit50Num = eqm_api:adm_get_set_num(50, Role) + eqm_api:adm_get_set_num(55, Role),
    Suit60Num = eqm_api:adm_get_set_num(60, Role) + eqm_api:adm_get_set_num(65, Role),
    Suit70Num = eqm_api:adm_get_set_num(70, Role) + eqm_api:adm_get_set_num(75, Role),
    Suit80Num = eqm_api:adm_get_set_num(80, Role) + eqm_api:adm_get_set_num(85, Role),
    Suit90Num = eqm_api:adm_get_set_num(90, Role) + eqm_api:adm_get_set_num(95, Role), %% TODO: 90套装待后续扩充
    DemonLev = demon_api:get_demon_lev(Role),
    Ascend = ascend:get_ascend_str(Role),
    %% Info = util:fbin(<<"坐骑阶数:~w,翅膀阶数:~w,仙宠成长:~w,仙宠潜力:~w,元神境界均值:~w,八门精纯均值:~w,40套装:~w,50套件数:~w,60套件数:~w,70套件数:~w,80套件数:~w,副职业:~w,守护等级:~w,进阶方向:~w">>, [MountVal, WingVal, PetGrow, PetAvg, ChannelState, Suit40Num, Suit50Num, Suit60Num, Suit70Num, Suit80Num, SecCareer, DemonLev, Ascend]),
    Info = util:fbin(<<"进阶方向:~s,90套件数:~w">>, [Ascend, Suit90Num]), %% 2012/12/27 修改为text字段记录，方便扩充
    [Rid, SrvId, Name, MountVal, WingVal, PetGrow, PetAvg, ChannelState, Suit40Num, Suit50Num, Suit60Num, Suit70Num, Suit80Num, DemonLev, Info];
collect_info(_) -> error.
