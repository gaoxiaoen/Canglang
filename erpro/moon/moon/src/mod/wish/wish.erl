%% ******************************
%% 许愿池服务进程
%% @author wpf (wprehard@qq.com)
%% ******************************

-module(wish).
-behaviour(gen_server).
-export([start_link/0 
        ,add_coin/2
        ,lucky/1
        ,trans/2
        ,role_login/1
        ,get_role_num/1
        ,get_count/0
        ,get_state/0
        %% 管理指令
        ,adm_gm_start/0
        ,adm_gm_stop/0
        ,adm_gm_set/2
        ,adm_cancel/0
        ,adm_restart/0
    ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("map.hrl").
-include("pos.hrl").
-include("buff.hrl").
%%

%% 许愿池数据缓存
-record(state, {
        index = 0           %% 目前已投币参与活动玩家
        ,ver = 0            %% 是否大平台 1:大 2:小
        ,is_cancel = 0      %% 是否取消活动:0-正常 1-取消
        ,status = 0         %% 当前活动状态
        ,endtime = 0        %% 当前状态结束时间:0-表示无倒计时
        ,count = 0          %% 总参与投币数
    }).
%% 角色投币信息
-record(wish_role, {
        id = 0              %% 角色ID
        ,pid = 0            %% 角色PID
        ,count = 0          %% 已投入币数
        ,lucky = 0          %% 0 - 未使用幸运仙泉 1 - 使用了幸运仙泉
    }).

%% 当前活动状态
-define(WISH_CLOSE, 0).         %% 关闭
-define(WISH_INFORM, 1).        %% 通知阶段
-define(WISH_PREPARE, 2).       %% 准备
-define(WISH_ING, 3).           %% 开始
%% 许愿池活动时间定义
%% -define(WISH_INFORM_CD, 180).          %% 通知时间
-define(WISH_PREPARE_CD,600).          %% 准备时间s
-define(WISH_ING_CD,    900).         %% 活动时间
-define(WISH_GAIN_CD,   40).           %% 活动奖励计算间隔
-define(WISH_PREPARE_MIN, 10).         %% 准备时间分钟数
%% 活动开启星期数
-define(WISH_START_WEEK, [2, 4, 6]).
-define(INFORM_TIME, 75300).           %% 通知时间戳秒数: 21点相对当天凌晨
-define(PREPARE_TIME, 75900).          %% 准备时间戳秒数
%% 投币相关
-define(MAX_WISH_COIN, 2000).   %% 活动投币总数上限
-define(MAX_SINGLE_WISH, 10).   %% 单个角色投币数上限
%% 投币奖励限制和等级 -- 有平台区分
-ifdef(debug).
-define(TO_VER(RoleNum), case RoleNum of
        %% RoleNum when RoleNum > 4 -> ?VER_4;
        %% RoleNum when RoleNum > 3 -> ?VER_3;
        %% RoleNum when RoleNum > 2 -> ?VER_3;
        RoleNum when RoleNum > 200 -> ?VER_4;
        RoleNum when RoleNum > 100 -> ?VER_3;
        RoleNum when RoleNum > 50 -> ?VER_3;
        _ -> ?VER_1
    end).
-else.
-define(TO_VER(RoleNum), case RoleNum of
        RoleNum when RoleNum > 200 -> ?VER_4;
        RoleNum when RoleNum > 100 -> ?VER_3;
        RoleNum when RoleNum > 50 -> ?VER_3;
        _ -> ?VER_1
    end).
-endif.
-define(VER_1, 1).       %% 在线人数分限制
-define(VER_2, 2).       %% 
-define(VER_3, 3).       %% 
-define(VER_4, 4).       %% 
%% 场景相关
-define(WISH_MAP_ID,        10003). %% 活动地图ID
-define(WISH_ELEM_SPRING,   60231). %% 许愿池水汽ID
-define(WISH_ELEM_G1,       60216). %% 许愿池小精灵ID
-define(WISH_ELEM_G2,       60217). %% 许愿池小精灵ID
-define(WISH_ELEM_SPRING_X, 5040).
-define(WISH_ELEM_SPRING_Y, 3480).
-define(WISH_ELEM_POS1,     [{60216, 5160, 3210}, {60216, 4980, 3210}, {60217, 5040, 3180}]). %% 许愿池小精灵元素位置
-define(WISH_ELEM_POS2,     [{60235, 5040, 3210}]). %% 许愿池小精灵元素位置
-define(WISH_ELEM_POS3,     [{60236, 5092, 3322}]). %% 许愿池小精灵元素位置
-define(WISH_ELEM_POS4,     [{60237, 5085, 3257}]). %% 许愿池小精灵元素位置
-define(WISH_TRANS_POINT_VER1, [
        {5040, 2970}, {3960, 3390}, {5520, 3870}, {5880, 3120},
        {6900, 6630}, {6960, 6660}, {5040, 1290}, {5460, 930}]).   %% 许愿池传送点 -- 大平台
-define(WISH_TRANS_POINT_VER2, [
        {5040, 2970}, {3960, 3390}, {5520, 3870}, {5880, 3120}]).   %% 许愿池传送点 -- 小平台
%% 幸运仙泉加倍数
-define(WISH_LUCKY, 1.5).
-define(WISH_LUCKY_END_DATE, {21, 30, 00}).

%% @spec add_coin(Role) -> {ok} | {false, Reason}
%% @doc 向许愿池投币
add_coin(_, #role{lev = Lev}) when Lev < 40 ->
    {false, ?L(<<"40级以后才能参加许愿活动哦，亲">>)};
add_coin(Num, #role{id = Rid, pid = Pid}) when Num =< 10 ->
    gen_server:call(?MODULE, {add_coin, Rid, Pid, Num});
add_coin(_, _) ->
    {false, ?L(<<"一个人只能投币许愿10次哦">>)}.
do_add_coin(Rid, Pid, Num) ->
    case ets:lookup(wish_role, Rid) of
        [#wish_role{count = Count}] when Count >= ?MAX_SINGLE_WISH ->
            {false, ?L(<<"一个人只能投币许愿10次哦">>)};
        [W = #wish_role{count = Count}] when Count + Num =< ?MAX_SINGLE_WISH ->
            ets:insert(wish_role, W#wish_role{pid = Pid, count = Count + Num}),
            {ok, 0};
        [#wish_role{count = Count}] ->
            {false, util:fbin(?L(<<"您只能再投~w个许愿币">>), [?MAX_SINGLE_WISH - Count])};
        [] ->
            ets:insert(wish_role, #wish_role{id = Rid, pid = Pid, count = Num}), 
            {ok, 1}
    end.

%% @spec lucky(Role) -> {ok, BuffBase} | {false, Reason}
%% @doc 使用幸运仙泉，只有投过币的玩家才能使用并有效
lucky(#role{lev = Lev}) when Lev < 40 ->
    {false, ?L(<<"40级以后才能参加许愿活动哦，亲">>)};
lucky(#role{id = Rid, pid = Pid}) ->
    gen_server:call(?MODULE, {lucky, Rid, Pid}).
do_lucky(Rid, Pid) ->
    case ets:lookup(wish_role, Rid) of
        [W = #wish_role{lucky = ?false}] ->
            ets:insert(wish_role, W#wish_role{pid = Pid, lucky = ?true}),
            ok;
        [#wish_role{lucky = ?true}] ->
            {false, ?L(<<"本次活动已使用过幸运仙泉">>)};
        _ ->
            {false, ?L(<<"在许愿时间内您没有投币，不能使用幸运仙泉">>)}
    end.

%% @spec role_login(Role) -> ok
%% @doc 角色登陆更新PID；防止活动期间玩家重新登陆PID失效
role_login(#role{id = Rid, pid = Pid}) ->
    case catch ets:lookup(wish_role, Rid) of
        [W = #wish_role{}] ->
            ets:insert(wish_role, W#wish_role{pid = Pid});
        _ -> ok
    end,
    ok.

%% @spec get_role_num(Rid) -> num
%% @doc 获取个人投币数
get_role_num(Rid) ->
    case catch ets:lookup(wish_role, Rid) of
        [#wish_role{count = Count}] -> Count;
        _ -> 0
    end.

%% @spec trans(Type, Role) -> {ok, NewRole} | {false, Reason}
%% @doc 活动时间内传送
trans(_Type, #role{lev = Lev}) when Lev < 40 ->
    {false, ?L(<<"40级以后才能参加许愿活动哦，亲">>)};
trans(Type, Role) ->
    case get_state() of
        {Ver, ?WISH_PREPARE, _, _} ->
            ToTrans = to_trans(Type, Ver),
            role_api:trans_hook(free, ToTrans, Role);
        {Ver, ?WISH_ING, _, _} ->
            ToTrans = to_trans(Type, Ver),
            role_api:trans_hook(free, ToTrans, Role);
        _ -> {false, ?L(<<"许愿活动已经结束">>)}
    end.
to_trans(1, _) -> %% 传至主城
    case map:get_revive(?WISH_MAP_ID) of
        {ok, {X, Y}} -> {?WISH_MAP_ID, X, Y};
        Other -> Other
    end;
to_trans(2, Ver) when Ver >= ?VER_2 -> %% 传至许愿池
    {X, Y} = util:rand_list(?WISH_TRANS_POINT_VER1),
    {?WISH_MAP_ID, X, Y};
to_trans(2, _Ver) -> %% 传至许愿池
    {X, Y} = util:rand_list(?WISH_TRANS_POINT_VER2),
    {?WISH_MAP_ID, X, Y};
to_trans(_, _) -> ignore.

%% @spec get_state() -> {Ver, NowState, NextState, EndTime}
%% @doc 获取当前许愿池的状态
get_state() ->
    gen_server:call(?MODULE, get_state).

%% @spec get_count() -> Count::integer()
%% @doc 获取当前许愿池的投币数
get_count() ->
    gen_server:call(?MODULE, get_count).

%% @spec adm_gm_start() -> ok | {false, Reason}
%% @doc 管理服务开启关闭
adm_gm_start() ->
    gen_server:call(?MODULE, gm_start).

%% @spec adm_gm_stop() -> ok | {false, Reason}
%% @doc 活动关闭
adm_gm_stop() ->
    gen_server:call(?MODULE, gm_stop).

%% @spec adm_gm_stop() -> ok | {false, Reason}
%% @doc 管理服务关闭
adm_cancel() ->
    gen_server:call(?MODULE, cancel).

%% @spec adm_cancel() -> ok | {false, Reason}
%% @doc 管理服务重开启
adm_restart() ->
    supervisor:terminate_child(sup_master, wish),
    supervisor:restart_child(sup_master, wish).

%% @spec adm_gm_set(Type, Min) -> ok | {false, Reason}
%% Type = inform | prepare | ing
%% @doc 设置cd时间
adm_gm_set(Type, {Num, Min}) ->
    gen_server:call(?MODULE, {gm_set, Type, Num, Min}).

%% @spec start_link() -> pid()
%% @doc 创建许愿池服务进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% --------------------------------
%% 内部函数
%% --------------------------------
%% 获取当天本地时间的星期天数
get_day_of_week() ->
    {Date, _} = calendar:local_time(),
    calendar:day_of_the_week(Date).

%% 是否在当天活动时间前
is_exceed(Today, Now, ToTime) ->
    (Today + ToTime) > Now.

%% 活动时间是每星期二、四、六的21点
%% 获取下次活动准备的间隔时间(s秒)
to_next_sec() ->
    Now = util:unixtime(),
    Today = util:unixtime(today),
    Day = get_day_of_week(),
    if
        Day =:= 1 -> (Today + 86400 - Now) + ?PREPARE_TIME;
        Day =:= 3 -> (Today + 86400 - Now) + ?PREPARE_TIME;
        Day =:= 5 -> (Today + 86400 - Now) + ?PREPARE_TIME;
        Day =:= 7 -> (Today + 86400 - Now) + 86400 + ?PREPARE_TIME;
        true ->
            case is_exceed(Today, Now, ?PREPARE_TIME) of
                true -> Today + ?PREPARE_TIME - Now;
                false ->
                    if
                        Day =:= 6 -> (Today + 86400 - Now) + (86400 * 2) + ?PREPARE_TIME;
                        true -> (Today + 86400 - Now) + 86400 + ?PREPARE_TIME
                    end
            end
    end.
%% 测试期间开启时间每天21点
to_next_sec_test() ->
    Now = util:unixtime(),
    Today = util:unixtime(today),
    case is_exceed(Today, Now, ?PREPARE_TIME) of
        true ->
            Today + ?PREPARE_TIME - Now;
        false ->
            Today + 86400 + ?PREPARE_TIME - Now
    end.

%% 获取本地节点服务器在线人数
to_ver() ->
    I = ets:info(role_online, size),
    ?TO_VER(I).

%% 获取人数控制版本对应的最低投币数
-ifdef(debug).
ver_to_min_coin(?VER_4) -> 200;
ver_to_min_coin(?VER_3) -> 200;
ver_to_min_coin(?VER_2) -> 150;
ver_to_min_coin(?VER_1) -> 100;
ver_to_min_coin(_) -> 100.
-else.
ver_to_min_coin(?VER_4) -> 200;
ver_to_min_coin(?VER_3) -> 200;
ver_to_min_coin(?VER_2) -> 150;
ver_to_min_coin(?VER_1) -> 100;
ver_to_min_coin(_) -> 100.
-endif.

%% 获取下个状态
%% next_state(?WISH_CLOSE) -> ?WISH_INFORM;
%% next_state(?WISH_INFORM) -> ?WISH_PREPARE;
next_state(?WISH_CLOSE) -> ?WISH_PREPARE;
next_state(?WISH_PREPARE) -> ?WISH_ING;
next_state(?WISH_ING) -> ?WISH_CLOSE;
next_state(_) -> ?WISH_CLOSE.

%% 生成幸运泉buff
get_buff() ->
    ED = {date(), ?WISH_LUCKY_END_DATE},
    {ok, BaseBuff} = buff_data:get(wish_lucky),
    BaseBuff#buff{end_date = ED}.

%% 活动结束清空幸运泉水的buff
clean_lucky_buff() ->
    case ets:match_object(wish_role, #wish_role{_ = '_', lucky = ?true}) of
        L when is_list(L) ->
            ?DEBUG("处理幸运泉水BUFF:~w", [L]),
            do_clean_buff(L);
        _ -> ignore
    end.
clean_lucky_buff(List) ->
    L = [W || W = #wish_role{pid = Pid, lucky = ?true} <- List, is_pid(Pid) andalso is_process_alive(Pid)],
    do_clean_buff(L).
do_clean_buff([]) -> ignore;
do_clean_buff([#wish_role{pid = Pid} | T]) ->
    role:apply(async, Pid, {fun del_lucky_buff/1, []}),
    do_clean_buff(T);
do_clean_buff([_ | T]) ->
    do_clean_buff(T).

%% 删除幸运泉buff
del_lucky_buff(Role) ->
    case buff:del_buff_by_label(Role, wish_lucky) of
        {ok, NewRole} -> {ok, NewRole};
        _ -> {ok}
    end.

%% 场景元素处理
%% handle_scene(wish_prepare, _) ->
%%     Elem = #map_elem{
%%         id = ?WISH_ELEM_SPRING, base_id = ?WISH_ELEM_SPRING, type = 12, x = ?WISH_ELEM_SPRING_X, y = ?WISH_ELEM_SPRING_Y
%%     },
%%     map:elem_enter(?WISH_MAP_ID, Elem);
handle_scene(wish_start, {Ver, Count}) ->
    Elems = count_lev_to_elem(Ver, Count),
    put(wish_elem_ghosts, Elems),
    [map:elem_enter(?WISH_MAP_ID, Elem) || Elem = #map_elem{} <- Elems];
handle_scene(wish_close, _) ->
    %% map:elem_leave(?WISH_MAP_ID, ?WISH_ELEM_SPRING),
    case get(wish_elem_ghosts) of
        undefined -> ignore;
        Elems ->
            [map:elem_leave(?WISH_MAP_ID, Id) || #map_elem{id = Id} <- Elems]
    end;
handle_scene(_, _) -> ignore.

%% 个人根据投币数奖励
coin_to_award(1, Val) ->    Val * 0.55;
coin_to_award(2, Val) ->    Val * 0.60;
coin_to_award(3, Val) ->    Val * 0.65;
coin_to_award(4, Val) ->    Val * 0.70;
coin_to_award(5, Val) ->    Val * 0.75;
coin_to_award(6, Val) ->    Val * 0.80;
coin_to_award(7, Val) ->    Val * 0.85;
coin_to_award(8, Val) ->    Val * 0.90;
coin_to_award(9, Val) ->    Val * 0.95;
coin_to_award(10, Val) ->   Val * 1.00;
coin_to_award(_, Val) ->    Val * 0.55.

%% 发放奖励
handle_wish_award([], _Ver, _Count) -> ok;
handle_wish_award([#wish_role{pid = Pid} | T], Ver, Count) ->
    case is_pid(Pid) andalso is_process_alive(Pid) of
        true ->
            role:apply(async, Pid, {fun do_wish_award/3, [Ver, Count]}),
            handle_wish_award(T, Ver, Count);
        false ->
            handle_wish_award(T, Ver, Count)
    end;
handle_wish_award([_ | T], Ver, Count) ->
    handle_wish_award(T, Ver, Count).
%% 异步回调
do_wish_award(Role = #role{id = Rid, lev = Lev, pos = #pos{map = MapId}}, Ver, TotalCount)
when MapId =:= ?WISH_MAP_ID ->
    ValExp = role_exp_data:get_wish_exp(Lev),
    %% ValP = role_exp_data:get_wish_spirit(Lev),
    {Ve, _Vp} = count_to_award(Ver, TotalCount, ValExp, 0),
    {G, Msg} = case ets:lookup(wish_role, Rid) of
        [#wish_role{count = Count, lucky = ?true}] ->
            ExpVal = erlang:round(coin_to_award(Count, Ve) * ?WISH_LUCKY),
            %% PsyVal = erlang:round(coin_to_award(Count, Vp) * ?WISH_LUCKY),
            {[#gain{label = exp, val = ExpVal}], util:fbin(?L(<<"许愿池奖励x1.5（幸运泉水加成）\n{str,经验,#00FF00} ~w">>), [ExpVal])};
        [#wish_role{count = Count}] ->
            ExpVal = erlang:round(coin_to_award(Count, Ve)),
            %% PsyVal = erlang:round(coin_to_award(Count, Vp)),
            {[#gain{label = exp, val = ExpVal}], util:fbin(?L(<<"许愿池奖励\n{str,经验,#00FF00} ~w">>), [ExpVal])};
        _ ->
            {[], <<"">>}
    end,
    case role_gain:do(G, Role) of
        {false, _} -> {ok};
        {ok, NewRole} ->
            notice:inform(Msg),
            {ok, NewRole}
    end;
do_wish_award(_, _, _) ->
    {ok}.

%% 许愿池祝福等级奖励
count_to_award(?VER_4, Count, Ve, Vp) ->
    if
        Count >= 2000 ->
            {Ve * 1.5, Vp * 1.5};
        Count >= 1000 andalso Count < 2000 ->
            {Ve * 1.3, Vp * 1.3};
        Count >= 500 andalso Count < 1000 ->
            {Ve * 1.15, Vp * 1.15};
        Count >= 200 andalso Count < 500 ->
            {Ve, Vp};
        true -> {Ve, Vp}
    end;
count_to_award(?VER_3, Count, Ve, Vp) ->
    if
        Count >= 1000 ->
            {Ve * 1.5, Vp * 1.5};
        Count >= 600 andalso Count < 1000 ->
            {Ve * 1.3, Vp * 1.3};
        Count >= 400 andalso Count < 600 ->
            {Ve * 1.15, Vp * 1.15};
        Count >= 200 andalso Count < 400 ->
            {Ve, Vp};
        true -> {Ve, Vp}
    end;
count_to_award(?VER_2, Count, Ve, Vp) ->
    if
        Count >= 600 ->
            {Ve * 1.5, Vp * 1.5};
        Count >= 400 andalso Count < 600 ->
            {Ve * 1.3, Vp * 1.3};
        Count >= 250 andalso Count < 400 ->
            {Ve * 1.15, Vp * 1.15};
        Count >= 150 andalso Count < 250 ->
            {Ve, Vp};
        true -> {Ve, Vp}
    end;
count_to_award(?VER_1, Count, Ve, Vp) ->
    if
        Count >= 400 ->
            {Ve * 1.5, Vp * 1.5};
        Count >= 300 andalso Count < 400 ->
            {Ve * 1.3, Vp * 1.3};
        Count >= 200 andalso Count < 300 ->
            {Ve * 1.15, Vp * 1.15};
        Count >= 100 andalso Count < 200 ->
            {Ve, Vp};
        true -> {Ve, Vp}
    end;
count_to_award(_, _, Ve, Vp) -> {Ve, Vp}.

%% 根据平台和币数，显示场景元素
count_lev_to_elem(?VER_4, Count) ->
    if
        Count >= 2000 ->
            do_lev_to_elem(?WISH_ELEM_POS4, []);
        Count >= 1000 andalso Count < 2000 ->
            do_lev_to_elem(?WISH_ELEM_POS3, []);
        Count >= 500 andalso Count < 1000 ->
            do_lev_to_elem(?WISH_ELEM_POS2, []);
        Count >= 200 andalso Count < 500 ->
            do_lev_to_elem(?WISH_ELEM_POS1, []);
        true ->
            do_lev_to_elem(?WISH_ELEM_POS1, [])
    end;
count_lev_to_elem(?VER_3, Count) ->
    if
        Count >= 1000 ->
            do_lev_to_elem(?WISH_ELEM_POS4, []);
        Count >= 600 andalso Count < 1000 ->
            do_lev_to_elem(?WISH_ELEM_POS3, []);
        Count >= 400 andalso Count < 600 ->
            do_lev_to_elem(?WISH_ELEM_POS2, []);
        Count >= 200 andalso Count < 400 ->
            do_lev_to_elem(?WISH_ELEM_POS1, []);
        true ->
            do_lev_to_elem(?WISH_ELEM_POS1, [])
    end;
count_lev_to_elem(?VER_2, Count) ->
    if
        Count >= 600 ->
            do_lev_to_elem(?WISH_ELEM_POS4, []);
        Count >= 400 andalso Count < 600 ->
            do_lev_to_elem(?WISH_ELEM_POS3, []);
        Count >= 250 andalso Count < 400 ->
            do_lev_to_elem(?WISH_ELEM_POS2, []);
        Count >= 150 andalso Count < 250 ->
            do_lev_to_elem(?WISH_ELEM_POS1, []);
        true ->
            do_lev_to_elem(?WISH_ELEM_POS1, [])
    end;
count_lev_to_elem(?VER_1, Count) ->
    if
        Count >= 400 ->
            do_lev_to_elem(?WISH_ELEM_POS4, []);
        Count >= 300 andalso Count < 400 ->
            do_lev_to_elem(?WISH_ELEM_POS3, []);
        Count >= 200 andalso Count < 300 ->
            do_lev_to_elem(?WISH_ELEM_POS2, []);
        Count >= 150 andalso Count < 250 ->
            do_lev_to_elem(?WISH_ELEM_POS1, []);
        true ->
            do_lev_to_elem(?WISH_ELEM_POS1, [])
    end;
count_lev_to_elem(_, _) -> ignore.

do_lev_to_elem([], Elems) -> Elems;
do_lev_to_elem([{BaseId, X, Y} | T], Elems) ->
    Fun = fun() ->
            case map_data_elem:get(BaseId) of
                Elem = #map_elem{} ->
                    Elem#map_elem{id = (BaseId * 10 + length(Elems) + 1), x = X, y = Y};
                _ ->
                    undefined
            end
    end,
    do_lev_to_elem(T, [Fun() | Elems]).

%% 系统通知
cast(wish_inform, Sec) ->
    M = Sec div 60,
    notice:send(54, util:fbin(?L(<<"许愿活动将在{str, ~w, #ff6600}分钟后开启，各位仙友可回城参加活动">>), [M]));
cast(wish_prepare, 0) -> ignore;
cast(wish_prepare, Ver) ->
    Msg = util:fbin(?L(<<"许愿池已经开启，当投币总数达到~w个时所有投币的仙友都可获得祝福，快去投币许愿吧">>), [ver_to_min_coin(Ver)]),
    notice:send(54, Msg);
cast(wish_start, {?VER_4, Count}) ->
    if
        Count >= 2000 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 至尊许愿祝福, #FFF000} 奖励众人">>));
        Count >= 1000 andalso Count < 2000 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 超级许愿祝福, #FFF000} 奖励众人">>));
        Count >= 500 andalso Count < 1000 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 高级许愿祝福, #FFF000} 奖励众人">>));
        Count >= 200 andalso Count < 500 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 许愿祝福, #FFF000} 奖励众人">>));
        true ->
            notice:send(54, ?L(<<"许愿池投币总数不够, 本次活动无法获得祝福奖励">>))
    end;
cast(wish_start, {?VER_3, Count}) ->
    if
        Count >= 1000 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 至尊许愿祝福, #FFF000} 奖励众人">>));
        Count >= 600 andalso Count < 1000 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 超级许愿祝福, #FFF000} 奖励众人">>));
        Count >= 400 andalso Count < 600 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 高级许愿祝福, #FFF000} 奖励众人">>));
        Count >= 200 andalso Count < 400 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 许愿祝福, #FFF000} 奖励众人">>));
        true ->
            notice:send(54, ?L(<<"许愿池投币总数不够, 本次活动无法获得祝福奖励">>))
    end;
cast(wish_start, {?VER_2, Count}) ->
    if
        Count >= 600 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 至尊许愿祝福, #FFF000} 奖励众人">>));
        Count >= 400 andalso Count < 600 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 超级许愿祝福, #FFF000} 奖励众人">>));
        Count >= 250 andalso Count < 400 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 高级许愿祝福, #FFF000} 奖励众人">>));
        Count >= 150 andalso Count < 250 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 许愿祝福, #FFF000} 奖励众人">>));
        true ->
            notice:send(54, ?L(<<"许愿池投币总数不够, 本次活动无法获得祝福奖励">>))
    end;
cast(wish_start, {?VER_1, Count}) ->
    if
        Count >= 400 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 至尊许愿祝福, #FFF000} 奖励众人">>));
        Count >= 300 andalso Count < 400 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 超级许愿祝福, #FFF000} 奖励众人">>));
        Count >= 200 andalso Count < 300 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 高级许愿祝福, #FFF000} 奖励众人">>));
        Count >= 100 andalso Count < 200 ->
            notice:send(54, ?L(<<"许愿池精灵被各位仙友诚心许愿感动，特施加 {str, 许愿祝福, #FFF000} 奖励众人">>));
        true ->
            notice:send(54, ?L(<<"许愿池投币总数不够, 本次活动无法获得祝福奖励">>))
    end;
cast(wish_start, _Count) -> ignore;
cast(wish_close, _) ->
    notice:send(54, ?L(<<"许愿活动已经结束">>));
cast(wish_close_coin, _) ->
    notice:send(54, ?L(<<"许愿池投币总数不够, 本次活动已结束">>));
cast(_, _) -> ignore.

%% -----------------------------------------------------
%% 内部处理
%% -----------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ets:new(wish_role, [public, named_table, set, {keypos, #wish_role.id}]),
    self() ! wish_init,
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% 投币
handle_call({add_coin, _Rid, _Pid, _CountAdd}, _From, State = #state{is_cancel = ?true}) ->
    {reply, {false, ?L(<<"今天的许愿活动已取消">>)}, State};
handle_call({add_coin, Rid, Pid, CountAdd}, _From, State = #state{status = ?WISH_PREPARE, index = Index, count = Count}) ->
    case do_add_coin(Rid, Pid, CountAdd) of
        {false, Reason} ->
            {reply, {false, Reason}, State};
        {ok, IndexAdd} ->
            NewCount = Count + CountAdd,
            NewIndex = Index + IndexAdd,
            NewState = State#state{index = NewIndex, count = NewCount},
            %% 广播全服，币数增长
            role_group:pack_cast(world, 14400, {NewIndex, NewCount}),
            {reply, {ok}, NewState}
    end;
handle_call({add_coin, _Rid, _Pid, _CountAdd}, _From, State = #state{status = ?WISH_ING}) ->
    {reply, {false, ?L(<<"投币许愿已结束，许愿精灵已开始施加祝福">>)}, State};
handle_call({add_coin, _Rid, _Pid, _CountAdd}, _From, State) ->
    {reply, {false, ?L(<<"许愿池还未开启，无法许愿投币">>)}, State};

%% 幸运泉水
handle_call({lucky, _Rid, _Pid}, _From, State = #state{is_cancel = ?true}) ->
    {reply, {false, ?L(<<"今天的许愿活动已取消">>)}, State};
handle_call({lucky, Rid, Pid}, _From, State = #state{status = Status})
when Status =:= ?WISH_ING orelse Status =:= ?WISH_PREPARE ->
    case do_lucky(Rid, Pid) of
        {false, M} -> {reply, {false, M}, State};
        ok ->
            BuffBase = get_buff(),
            {reply, {ok, BuffBase}, State}
    end;
handle_call({lucky, _Rid, _Pid}, _From, State) ->
    {reply, {false, ?L(<<"浪费可耻！幸运仙泉很宝贵，等许愿池开启了再用吧">>)}, State};

%% 获取状态
handle_call(get_state, _From, State = #state{ver = Ver, status = Status, endtime = EndTime}) ->
    Next = next_state(Status),
    {reply, {Ver, Status, Next, EndTime}, State};

%% 获取币数
handle_call(get_count, _From, State = #state{index = Index, count = Count}) ->
    {reply, {Index, Count}, State};

%% gm手动开启活动
handle_call(gm_start, _From, State = #state{status = Status}) when Status =/= ?WISH_CLOSE ->
    {reply, {false, ?L(<<"活动已经开启了">>)}, State};
handle_call(gm_start, _From, State = #state{ver = Ver}) ->
    clean_lucky_buff(),
    catch ets:delete_all_objects(wish_role),
    case get(wish_timer) of
        undefined -> ignore;
        Ref -> erlang:cancel_timer(Ref)
    end,
    ToTime = util:unixtime() + 20,
    put(wish_timer, erlang:send_after(20 * 1000, self(), wish_prepare)),
    role_group:pack_cast(world, 14401, {Ver, ?WISH_INFORM, ?WISH_PREPARE, ToTime}),
    ?DEBUG("许愿活动已开启，时间戳：~w", [ToTime]),
    {reply, ok, State#state{is_cancel = ?false, index = 0, count = 0, endtime = 0, status = ?WISH_INFORM}};

%% gm关闭活动
handle_call(gm_stop, _From, State = #state{ver = Ver, status = Status}) when Status =/= ?WISH_CLOSE ->
    case get(wish_timer) of
        undefined -> ignore;
        Ref -> erlang:cancel_timer(Ref)
    end,
    case get(wish_gain_timer) of
        undefined -> ignore;
        Ref1 ->
            erlang:cancel_timer(Ref1)
    end,
    role_group:pack_cast(world, 14401, {Ver, ?WISH_CLOSE, ?WISH_CLOSE, 0}), %% 广播活动结束
    clean_lucky_buff(),
    handle_scene(wish_close, 0),
    cast(wish_close, 0),
    self() ! wish_init,
    ?DEBUG("许愿活动结束"),
    {reply, ok, State};
handle_call(gm_stop, _From, State) ->
    {reply, ok, State};

%% 取消许愿进程服务
handle_call(cancel, _From, State = #state{is_cancel = ?true}) ->
    {reply, ok, State};
handle_call(cancel, _From, State) ->
    {reply, ok, State#state{is_cancel = ?true}};

%% 开启进程服务
handle_call(restart, _From, State) ->
    self() ! wish_init,
    {reply, ok, State#state{is_cancel = ?false}};

%% 设置时间
handle_call({gm_set, _Type, _Num, _Time}, _From, State = #state{is_cancel = ?true}) ->
    {reply, {false, ?L(<<"服务已停止">>)}, State};
handle_call({gm_set, inform, _Num, Time}, _From, State) ->
    put(wish_cd_inform, Time * 60),
    {reply, ok, State};
handle_call({gm_set, prepare, Num, Time}, _From, State) ->
    put(wish_cd_prepare, Time * 60),
    {reply, ok, State#state{count = Num}};
handle_call({gm_set, ing, _Num, Time}, _From, State) ->
    put(wish_cd_ing, Time * 60),
    {reply, ok, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Data, State) ->
    {noreply, State}.

%% 初始化服务定时器
handle_info(wish_init, State) ->
    %% 时间初始化
    %% put(wish_cd_inform, ?WISH_INFORM_CD),
    put(wish_cd_prepare, ?WISH_PREPARE_CD),
    put(wish_cd_ing, ?WISH_ING_CD),
    %% 定时器
    ToSec = to_next_sec(),
    _ = to_next_sec_test(), %% TODO: 
    case get(wish_timer) of
        undefined -> ignore;
        Ref -> erlang:cancel_timer(Ref)
    end,
    case get(wish_gain_timer) of
        undefined -> ignore;
        Ref1 -> erlang:cancel_timer(Ref1)
    end,
    catch ets:delete_all_objects(wish_role),
    put(wish_timer, erlang:send_after(ToSec * 1000, self(), wish_prepare)),
    put(ver_float, 3), %% 定义小平台投币扩展倍数--2012/12/3版本停用
    ?DEBUG("许愿池进程初始化完成(还有~w秒活动开始)", [ToSec]),
    {noreply, State#state{index = 0, count = 0, endtime = 0, status = ?WISH_CLOSE}};

%% 通知阶段 -- 12/02/29停用
%% handle_info(wish_inform, State = #state{is_cancel = ?false, status = ?WISH_CLOSE}) ->
%%     CdSec = get(wish_cd_inform),
%%     ToTime = util:unixtime() + CdSec,
%%     role_group:pack_cast(world, 14401, {?WISH_INFORM, ?WISH_PREPARE, ToTime}),
%%     cast(wish_inform, CdSec),
%%     put(wish_timer, erlang:send_after(CdSec * 1000, self(), wish_prepare)),
%%     NewState = State#state{status = ?WISH_INFORM, endtime = ToTime},
%%     ?DEBUG("许愿活动开始通知阶段"),
%%     {noreply, NewState};
%% handle_info(wish_inform, State) ->
%%     self() ! wish_init, %% 重置
%%     {noreply, State};

%% 活动准备
handle_info(wish_prepare, State = #state{is_cancel = ?false}) ->
    CdSec = get(wish_cd_prepare),
    ToTime = util:unixtime() + CdSec,
    Ver = to_ver(),
    role_group:pack_cast(world, 14401, {Ver, ?WISH_PREPARE, ?WISH_ING, ToTime}),
    cast(wish_prepare, Ver),
    NewState = State#state{ver = Ver, status = ?WISH_PREPARE, endtime = ToTime},
    erlang:send_after((CdSec div ?WISH_PREPARE_MIN) * 1000, self(), wish_prepare_notice),
    put(wish_timer, erlang:send_after(CdSec * 1000, self(), wish_start)),
    handle_scene(wish_prepare, 0),
    ?DEBUG("许愿活动准备阶段，下个时间戳:~w", [ToTime]),
    {noreply, NewState};
handle_info(wish_prepare, State) ->
    ?ERR("活动准备失败:~w", [State]),
    self() ! wish_init, %% 重置
    {noreply, State};

%% 活动准备分时通知: 每分钟发一次
handle_info(wish_prepare_notice, State = #state{status = ?WISH_PREPARE, ver = Ver, count = Count}) ->
    case Count < ver_to_min_coin(Ver) of
        true ->
            cast(wish_prepare, Ver),
            CdSec = get(wish_cd_prepare),
            erlang:send_after((CdSec div ?WISH_PREPARE_MIN) * 1000, self(), wish_prepare_notice);
        false -> ignore
    end,
    {noreply, State};
handle_info(wish_prepare_notice, State) ->
    {noreply, State};

%% 活动开始
handle_info(wish_start, State = #state{is_cancel = ?false, status = ?WISH_PREPARE, ver = Ver, count = Count}) ->
    case Count >= ver_to_min_coin(Ver) of
        true ->
            CdSec = get(wish_cd_ing),
            ToTime = util:unixtime() + CdSec,
            role_group:pack_cast(world, 14401, {Ver, ?WISH_ING, ?WISH_CLOSE, ToTime}),
            put(wish_gain_timer, erlang:send_after(?WISH_GAIN_CD * 1000, self(), wish_gain)), %% 许愿收益
            put(wish_timer,  erlang:send_after(CdSec * 1000, self(), wish_close)), %% 定时活动结束
            NewState = State#state{status = ?WISH_ING, endtime = ToTime},
            cast(wish_start, {Ver, Count}),
            handle_scene(wish_start, {Ver, Count}),
            ?DEBUG("许愿活动开始阶段"),
            {noreply, NewState};
        false ->
            clean_lucky_buff(),
            handle_scene(wish_close, 0),
            cast(wish_close_coin, 0),
            role_group:pack_cast(world, 14401, {Ver, ?WISH_CLOSE, ?WISH_CLOSE, 0}),
            ?DEBUG("活动币数不够, 开始失败:~w", [State]),
            self() ! wish_init,
            {noreply, State}
    end;
handle_info(wish_start, State) ->
    ?DEBUG("活动开始失败:~w", [State]),
    self() ! wish_init, %% 重置
    {noreply, State};

%% 活动结束
handle_info(wish_close, State = #state{status = ?WISH_ING, ver = Ver, count = Count}) ->
    RL = ets:tab2list(wish_role), %% 避免有玩家下线，此处必须实时获取
    handle_wish_award(RL, Ver, Count),
    role_group:pack_cast(world, 14401, {Ver, ?WISH_CLOSE, ?WISH_CLOSE, 0}), %% 广播活动结束
    case get(wish_gain_timer) of
        undefined -> ignore;
        Ref ->
            erlang:cancel_timer(Ref)
    end,
    clean_lucky_buff(RL),
    handle_scene(wish_close, 0),
    cast(wish_close, 0),
    self() ! wish_init,
    ?DEBUG("许愿活动结束"),
    {noreply, State#state{status = ?WISH_CLOSE, endtime = 0}};

%% 奖励发放
handle_info(wish_gain, State = #state{status = ?WISH_ING, ver = Ver, count = Count}) ->
    RL = ets:tab2list(wish_role), %% 避免有玩家下线，此处必须实时获取
    handle_wish_award(RL, Ver, Count),
    put(wish_gain_timer, erlang:send_after(?WISH_GAIN_CD * 1000, self(), wish_gain)), %% 许愿收益
    {noreply, State};

%% 容错
handle_info(_Data, State) ->
    ?ELOG("错误的异步消息处理：DATA:~w, State:~w", [_Data, State]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ?DEBUG("许愿池进程关闭:~w", [_Reason]),
    {noreply, _State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
