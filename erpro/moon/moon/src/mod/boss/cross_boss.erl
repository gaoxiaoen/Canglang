%% --------------------------------------------------------------------
%% 跨服boss相关接口
%% @author wpf (wprehard@qq.com)
%% @end
%% --------------------------------------------------------------------
-module(cross_boss).
-export([
        role_enter/1
        ,role_leave/1
        ,inform_center/1
        ,get_looks/1
        ,get_hall/1
        ,get_status/0
        ,get_enter_count/2
        ,get_enter_count/1
        ,get_boss_ids/0
        ,get_boss_fight/1
        ,get_boss_default/1
        ,get_room_pos/0
        ,handle_lose/2
        ,handle_award/3
        ,handle_award_offline/4
    ]).

-include("common.hrl").
-include("boss.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("attr.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("npc.hrl").

%% 获取boss的ID列表
get_boss_ids() ->
    [25500, 25501, 25502, 25503, 25504, 25505, 25506]. %% , 25506, 25507, 25508, 25509].

%% 获取跨服boss房间的站位列表
get_room_pos() ->
    [{900,870}, {1080,750}, {1260,900}, {1440,720}, {1620,870}].

%% 获取boss对应的战力区间
get_boss_fight(25500) -> {8000, 10000};
get_boss_fight(25501) -> {10001, 12000};
get_boss_fight(25502) -> {12001, 15000};
get_boss_fight(25503) -> {15001, 18000};
get_boss_fight(25504) -> {18001, 22000};
get_boss_fight(25505) -> {22001, 30000};
get_boss_fight(25506) -> {30001, 100000}.

%% 根据战力，获取对应boss
get_boss_default(FightCapacity) ->
    get_boss_default(FightCapacity, get_boss_ids()).

%% @spec role_enter(Role) -> {false, Msg} | ok
%% Role = #role{}
role_enter(Role = #role{id = RoleId, pid = Pid, attr = #attr{fight_capacity = FightCapacity}}) ->
    case check_enter_pre(Role) of
        {false, Msg} -> {false, Msg};
        ok ->
            center:cast(cross_boss_mgr, role_enter, [RoleId, Pid, FightCapacity]),
            ok
    end.

%% @spec role_leave(Role) -> {false, Msg} | ok
%% Role = #role{}
role_leave(#role{event = ?event_hall}) ->
    {false, ?L(<<"在大厅之中，暂时不能离开准备区">>)};
role_leave(#role{id = RoleId, pid = Pid, pos = #pos{map = MapId}}) ->
    center:cast(cross_boss_mgr, role_leave, [RoleId, Pid, MapId]),
    ok.

%% @spec inform_center(Msg) -> any()
%% @doc 通知中央服跨服boss进程
inform_center(Msg) ->
    center:cast(cross_boss_mgr, info, [Msg]).

%% @spec get_hall(Role) -> {ok, HallId::integer()} | {false, Msg::bitstring()}
%% Role = #role{}
get_hall(#role{id = RoleId, attr = #attr{fight_capacity = FightCapacity}}) ->
    case center:call(cross_boss_mgr, get_hall, [RoleId, FightCapacity]) of
        {ok, Hall} -> {ok, Hall};
        {false, Msg} -> {false, Msg};
        _ -> {false, ?L(<<"当前网络环境不稳定，请稍后重试进入！">>)}
    end.

%% @spec get_looks(RoleId) -> Looks :: list()
%% @doc 节点服调用，获取外观
get_looks(RoleId) ->
    case role_api:lookup(by_id, RoleId, #role.looks) of
        {ok, _, Looks} -> Looks;
        _ ->
            case role_data:fetch_role(by_id, RoleId) of
                {ok, Role} ->
                    #role{looks = Looks} = setting:dress_login_init(Role),
                    Looks;
                _ ->
                    []
            end
    end.

%% @spec get_status() -> {Status, Time} | false
%% Status = Time = integer()
get_status() ->
    case center:call(cross_boss_mgr, get_status, []) of
        {ok, {StatusId, Time}} -> {StatusId, Time};
        _ -> {0, 0}
    end.

%% @spec get_enter_count(Role) -> {ok, LeftCnt::integer()} | {badrpc, term()}
%% Role = #role{} | {integer(), bitstring()}
%% @doc 获取剩余挑战次数以及总可进入次数
get_enter_count(#role{id = RoleId}) ->
    get_enter_count(RoleId);
get_enter_count(RoleId) ->
    case center:call(cross_boss_mgr, get_enter_count, [RoleId]) of
        Cnt when is_integer(Cnt) -> Cnt;
        _ ->
            ?DEBUG("*****************"),
            0
    end.

%% @spec get_enter_count(HallPid, Role) -> {ok, LeftCnt::integer()} | {badrpc, term()}
%% Role = #role{} | {integer(), bitstring()}
%% @doc 获取剩余挑战次数以及总可进入次数
get_enter_count(HallPid, #role{id = RoleId}) ->
    get_enter_count(HallPid, RoleId);
get_enter_count(HallPid, RoleId) ->
    case node(HallPid) =:= node() of
        true -> 0;
        false ->
            case center:call(cross_boss_mgr, get_enter_count, [RoleId]) of
                Cnt when is_integer(Cnt) -> Cnt;
                _ -> 0
            end
    end.

%% 异步回调：战斗失败
handle_lose(_Role = #role{link = #link{conn_pid = ConnPid}}, _) ->
    sys_conn:pack_send(ConnPid, 16811, {?false, ?L(<<"挑战BOSS失败，挑战失败时不消耗挑战次数，可以再次选择BOSS挑战">>)}),
    sys_conn:pack_send(ConnPid, 16810, {0, []}),
    {ok}.

%% 异步回调: 发放奖励、广播
%% Items = [{Id, Bind, Num} | ...]
handle_award(Role = #role{id = {Rid, SrvId}, name = RoleName, link = #link{conn_pid = ConnPid}}, BossId, CelebrityData) ->
    %% 激活名人榜
    rank_celebrity:listener(cross_boss, CelebrityData, BossId),
    %% 奖励
    {L, NoticeL} = rand_items(BossId),
    {ok, #npc_base{name = BossName}} = npc_data:get(BossId),
    Coin = calc_gain_coin(BossId),
    GL1 = [#gain{label = coin_bind, val = Coin}],
    GL2 = [#gain{label = item, val = [Id, Bind, Num]} || {Id, Bind, Num} <- L],
    RoleMsg = notice:role_to_msg(Role),
    case role_gain:do(GL1, Role) of
        {false, _} -> {ok};
        {ok, NewRole} ->
            log:log(log_coin, {<<"天位之战">>, BossName, Role, NewRole}),
            notice_cast(RoleMsg, BossName, NoticeL),
            case role_gain:do(GL2, NewRole) of
                {false, _} ->
                    sys_conn:pack_send(ConnPid, 16810, {1, [{Rid, SrvId, to_gain_ui(Coin, 0, [])}]}),
                    Cont = util:fbin(?L(<<"您在天位之战中打败了~s，获得了 ~w绑定铜币，已发放背包，珍稀物品请查收附件！">>), [BossName, Coin]),
                    mail:send_system(Role, {?L(<<"天位之战奖励">>), Cont, [], L}),
                    log_drop({Rid, SrvId}, RoleName, BossId, L),
                    {ok, NewRole};
                {ok, NewRole1} ->
                    sys_conn:pack_send(ConnPid, 16810, {1, [{Rid, SrvId, to_gain_ui(Coin, 0, L)}]}),
                    notice:inform(util:fbin(?L(<<"天位挑战\n获得 {str,绑定金币,#FFD700}~w\n~s">>), [Coin, notice:baseid_item3_to_inform(L)])),
                    log_drop({Rid, SrvId}, RoleName, BossId, L),
                    {ok, NewRole1}
            end
    end.

%% 处理离线角色的奖励发放
handle_award_offline(RoleId, RoleName, BossId, CelebrityData) ->
    %% 处理奖励
    do_handle_award_offline(RoleId, RoleName, BossId),
    %% 激活名人榜
    rank_celebrity:listener(cross_boss, CelebrityData, BossId),
    ok.
do_handle_award_offline({Rid, SrvId}, RoleName, BossId) ->
    {L, NoticeL} = rand_items(BossId),
    {ok, #npc_base{name = BossName}} = npc_data:get(BossId),
    Coin = calc_gain_coin(BossId),
    RoleMsg = notice:role_to_msg({Rid, SrvId, RoleName}),
    Cont = util:fbin(?L(<<"您在天位之战中打败了~s，获得了~w铜币，已发放背包，珍稀物品请查收附件！">>), [BossName, Coin]),
    mail_mgr:deliver({Rid, SrvId, RoleName}, {?L(<<"天位之战奖励">>), Cont, [], L}),
    notice_cast(RoleMsg, BossName, NoticeL),
    log_drop({Rid, SrvId}, RoleName, BossId, L).

%% -----------------------------------------------
%% internal functions
%% -----------------------------------------------

%% 检测是否可进入准备区
check_enter_pre(#role{status = Status}) when Status =/= ?status_normal ->
    {false, ?L(<<"状态异常，不能进入">>)};
check_enter_pre(#role{event = Event}) when Event =/= ?event_no ->
    {false, ?L(<<"当前状态不能进入">>)};
check_enter_pre(#role{team_pid = TeamPid}) when is_pid(TeamPid) ->
    {false, ?L(<<"组队的时候无法参加此活动，请退出队伍重新进入！">>)};
check_enter_pre(#role{ride = ?ride_fly}) ->
    {false, ?L(<<"飞行状态不能进入">>)};
check_enter_pre(#role{lev = Lev, attr = #attr{fight_capacity = FightCapacity}}) when Lev < 52 orelse FightCapacity < 8000 ->
    {false, ?L(<<"很可惜，参加天位之战需要52级8000战斗力，请努力修炼再来吧！">>)};
check_enter_pre(_) -> ok.

%% 选中默认的BOSS
get_boss_default(_F, []) -> 25500;
get_boss_default(F, [Id | T]) ->
    {FMin, FMax} = get_boss_fight(Id),
    case F >= FMin andalso F < FMax of
        true -> Id;
        _ -> get_boss_default(F, T)
    end.

%% 根据bossID随机独立的物品列表
rand_items(BossId) ->
    L = cross_boss_data:get(BossId),
    rand_items(L, [], []).
rand_items([], BackL1, BackL2) -> {BackL1, BackL2};
rand_items([{L, Rand, Bind, IsNotice} | T], BackL1, BackL2) when is_list(L) ->
    case util:rand(1, 100) =< Rand of
        true when IsNotice =:= 1 ->
            XI = rand_items_2(L),
            rand_items(T, [{XI, Bind, 1} | BackL1], [{XI, Bind, 1} | BackL2]);
        true when IsNotice =:= 0 ->
            XI = rand_items_2(L),
            rand_items(T, [{XI, Bind, 1} | BackL1], BackL2);
        false ->
            rand_items(T, BackL1, BackL2)
    end;
rand_items([{ItemId, Rand, Bind, IsNotice} | T], BackL1, BackL2) ->
    case util:rand(1, 100) =< Rand of
        true when IsNotice =:= 1 ->
            rand_items(T, [{ItemId, Bind, 1} | BackL1], [{ItemId, Bind, 1} | BackL2]);
        true when IsNotice =:= 0 ->
            rand_items(T, [{ItemId, Bind, 1} | BackL1], BackL2);
        false ->
            rand_items(T, BackL1, BackL2)
    end.

%% 子项随机
rand_items_2(L = [H | _]) when is_integer(H) ->
    util:rand_list(L);
rand_items_2(L = [{_, _} | _]) ->
    TR = rand_all(L, 0),
    Rs = util:rand(1, TR),
    do_rand_items_2(L, Rs).

do_rand_items_2([], _Rs) -> 0;
do_rand_items_2([{Id, Rand} | T], Rs) ->
    case Rs =< Rand of
        true -> Id;
        false ->
            do_rand_items_2(T, Rs - Rand)
    end.

rand_all([], N) -> N;
rand_all([{_, Rand} | T], N) ->
    rand_all(T, N+Rand).

%% 计算金币奖励
%%erlang:round(math:pow(BossLev,1.5) * 30),
calc_gain_coin(25500) -> 200000;
calc_gain_coin(25501) -> 300000;
calc_gain_coin(25502) -> 400000;
calc_gain_coin(25503) -> 500000;
calc_gain_coin(25504) -> 600000;
calc_gain_coin(25505) -> 700000;
calc_gain_coin(25506) -> 900000;
calc_gain_coin(_BossId) -> 900000.

%% 结算面板显示的收益(参考战斗协议)
to_gain_ui(Coin, _Exp, Items) ->
    to_gain_item_ui(Items, [{3, 3, Coin, 0}]).
to_gain_item_ui([], BackL) -> BackL;
to_gain_item_ui([{ItemId, Bind, Num} | T], BackL) ->
    case Bind =:= 0 of
        true ->
            to_gain_item_ui(T, [{10, ItemId, Num, 0} | BackL]);
        false ->
            to_gain_item_ui(T, [{11, ItemId, Num, 0} | BackL])
    end.

%% 处理掉落日志
log_drop(_RoleId, _RoleName, _NpcId, []) -> ok;
log_drop({Rid, SrvId}, RoleName, NpcId, List) when is_list(List) ->
    DropList = [{NpcId, BaseId} || {BaseId, _, _} <- List],
    log:log(log_item_drop, {DropList, Rid, SrvId, RoleName});
log_drop(_, _, _, _) -> ignore.

%% 公告
notice_cast(_RoleMsg, _BossName, []) -> ignore;
notice_cast(RoleMsg, BossName, NoticeL) ->
    ItemMsg = notice:item_to_msg(NoticeL),
    notice:send(53, util:fbin(?L(<<"~s在 天位之战 中挑战超级BOSS{npc,~s,#f65e6a}，将其成功斩杀后幸运的获得了~s！">>), [RoleMsg, BossName, ItemMsg])).
