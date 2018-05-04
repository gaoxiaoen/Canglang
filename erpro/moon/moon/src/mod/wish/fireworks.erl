%% ******************************
%% 七夕烟花服务进程
%% @author lishen (105326073@qq.com)
%% ******************************

-module(fireworks).
-behaviour(gen_server).
-export([
        light_fire/2
        ,get_state/0
        ,get_count/0
        ,trans/2
        ,gm_start/0
        ,gm_stop/0
        ,gm_start_at_once/0
        ,gm_init/0
        ,gm_set_count/1
        ,pick_box/2
    ]).

-export([init/1, start_link/0, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
%%
-include("role.hrl").
-include("pos.hrl").
-include("map.hrl").
-include("role_online.hrl").

%% 烟花数据缓存
-record(state, {
        ver = 0
        ,state = 0           %% 烟花活动状态
        ,count = 0          %% 总放烟花数
        ,nexttime = 0       %% 离下一个状态时间
    }).

-record(fireworks_role, {
        id = {0, <<>>}      %% 角色id
        ,count = 0          %% 玩家放烟花数
        ,box = 0            %% 拾取宝盒数
    }).

-define(VER_1, 1).       %% 大平台
-define(VER_2, 2).       %% 小平台
-define(VER_ONLINE_NUM, 200).   %% 大小平台在线人数临界值
-define(VER_FLOAT, 4).   %% 小平台烟花数倍数
%% 当前活动状态
-define(FIRE_CLOSE, 0).     %% 关闭
-define(FIRE_PREPARE, 1).   %% 准备
-define(FIRE_ING, 2).       %% 进行

-define(START_DATA,     {{2013, 2, 7},{0, 0, 1}}).   %% 活动进程开始时间
-define(END_DATA,       {{2013, 2,11},{23, 59, 0}}). %% 活动进程结束时间
-define(START_TIME,     75420).  %% 活动当天开始时间 20:57 - 21:30
-define(PREPARE_TIME,   180).    %% 准备时间(秒)
-define(NOTICE_CD,      60).     %% 通知时间间隔
-define(ING_TIME,       1800).   %% 活动进行时间
%% 场景相关
-define(FIRE_MAP_ID,    10003). %% 活动地图ID
-define(BOX_ELEM_ID,    60516). %% 宝箱场景ID
-define(WISH_TRANS_POINT_VER1, [
        {4680, 3180}, {4380, 3570}, {5580, 3180}, {5580, 3360},
        {5100, 900}, {5400, 1500}, {6000, 1200},
        {6420, 6270}, {7320, 6330}, {6900, 6600}]).   %% 传送点 -- 大平台
-define(WISH_TRANS_POINT_VER2, [
        {4680, 3180}, {4380, 3570}, {5580, 3180}, {5580, 3360}]).   %% 传送点 -- 小平台
%% 物品相关
-define(BOX_BASE_ID, 29497).    %% 宝箱物品ID

light_fire(_, #role{lev = Lev}) when Lev < 40 ->
    {false, ?L(<<"40级以后才能参加烟花活动哦，亲">>)};
light_fire(Type, #role{id = Rid, name = Name, pos = #pos{map_pid = MapPid, x = X, y = Y}}) ->
    Now = util:unixtime(),
    case util:datetime_to_seconds(?END_DATA) of
        EndTime when is_integer(EndTime) andalso Now < EndTime ->
            notice:effect({Type, MapPid, X, Y}, <<>>),
            gen_server:call(?MODULE, {light_fire_role, Rid, Name}),
            gen_server:call(?MODULE, {light_fire, Rid, Name, Type});
        _ ->
            {false, ?L(<<"活动时间已过，不能燃放烟火">>)}
    end.

get_state() ->
    gen_server:call(?MODULE, {get_state}).

get_count() ->
    gen_server:call(?MODULE, {get_count}).

gm_start() ->
    gen_server:call(?MODULE, gm_start).

gm_stop() ->
    gen_server:call(?MODULE, gm_stop).

gm_start_at_once() ->
    gen_server:call(?MODULE, gm_start_at_once).

gm_init() ->
    gen_server:cast(?MODULE, gm_init).

gm_set_count(Count) ->
    gen_server:call(?MODULE, {gm_set_count, Count}).

trans(_Type, #role{lev = Lev}) when Lev < 40 ->
    {false, ?L(<<"40级以后才能参加烟花活动哦，亲">>)};
trans(Type, Role) ->
    {Ver, _, _, _} = get_state(),
    ToTrans = to_trans(Type, Ver),
    role_api:trans_hook(free, ToTrans, Role).

to_trans(1, _) -> %% 传至主城
    case map:get_revive(?FIRE_MAP_ID) of
        {ok, {X, Y}} -> {?FIRE_MAP_ID, X, Y};
        Other -> Other
    end;
to_trans(2, ?VER_1) -> %% 传至许愿池
    {X, Y} = util:rand_list(?WISH_TRANS_POINT_VER1),
    {?FIRE_MAP_ID, X, Y};
to_trans(2, ?VER_2) -> %% 传至许愿池
    {X, Y} = util:rand_list(?WISH_TRANS_POINT_VER2),
    {?FIRE_MAP_ID, X, Y}.

pick_box(Role = #role{id = Rid, lev = Lev, pid = Pid}, _ElemId) when Lev >= 40 ->
    case pick_box_check(Rid) of
        true ->
            case storage:make_and_add_fresh(?BOX_BASE_ID, 1, 1, Role) of
                {ok, NewRole, _} ->
                    notice:inform(Pid, util:fbin(<<"获得 {item3, ~w, 1, 1}">>, [?BOX_BASE_ID])),
                    {ok, NewRole};
                _Any ->
                    {false, ?L(<<"手慢了，宝盒被人抢了">>)}
            end;
        false ->
            {false, ?L(<<"别太贪心了，给其他仙友留点吧！">>)}
    end;
pick_box(_, _) -> {false, ?L(<<"等级未达到40，不能拾取宝盒！">>)}.

pick_box_check(Rid) ->
    case ets:lookup(fireworks_role, Rid) of
        [FR = #fireworks_role{box = Count}] ->
            case Count < 10 of
                true ->
                    ets:insert(fireworks_role, FR#fireworks_role{box = Count + 1}),
                    true;
                false ->
                    false
            end;
        [] ->
            ets:insert(fireworks_role, #fireworks_role{id = Rid, box = 1}),
            true;
        _ ->
            false
    end.

%% 获取烟花名字
%% 13=我喜欢你，14=求包养，15=七夕快乐，16=今夜私奔，17=永结同心
%% 19-我要脱光 20-光棍万岁
get_name(13) -> ?L(<<"我喜欢你">>);
get_name(14) -> ?L(<<"求包养">>);
get_name(15) -> ?L(<<"七夕快乐">>);
get_name(16) -> ?L(<<"今夜私奔">>);
get_name(17) -> ?L(<<"永结同心">>);
get_name(19) -> ?L(<<"我要脱光">>);
get_name(20) -> ?L(<<"光棍万岁">>);
get_name(22) -> ?L(<<"元旦快乐">>);
get_name(23) -> ?L(<<"蛇年吉祥">>);
get_name(24) -> ?L(<<"情定2013">>);
get_name(25) -> ?L(<<"求桃花运">>);
get_name(26) -> ?L(<<"2012走你">>);
get_name(27) -> ?L(<<"春节快乐">>);
get_name(28) -> ?L(<<"金蛇献瑞">>);
get_name(29) -> ?L(<<"恭贺新禧">>);

get_name(_) -> <<>>.

%% 获取下个状态
next_state(?FIRE_CLOSE) -> ?FIRE_PREPARE;
next_state(?FIRE_PREPARE) -> ?FIRE_ING;
next_state(?FIRE_ING) -> ?FIRE_CLOSE;
next_state(_) -> ?FIRE_CLOSE.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    ets:new(fireworks_role, [public, named_table, set, {keypos, #fireworks_role.id}]),
    dets:open_file(qixi_fire_role, [{file, "../var/qixi_fire_role.dets"}, {keypos, #fireworks_role.id}, {type, set}]),
    dets:to_ets(qixi_fire_role, fireworks_role),
    self() ! fireworks_init,
    put(box_all_count, 0),
    put(box_elems, []),
    erlang:send_after(util:unixtime({nexttime, 0}) * 1000, self(), fireworks_role_zero),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% 烟花晚会放烟花
handle_call({light_fire, Rid, Name, Type}, _From, State = #state{ver = Ver, state = ?FIRE_ING, count = Count}) ->
    NewCount = case Ver =:= ?VER_2 of
        true ->
            Count + ?VER_FLOAT;
        false ->
            Count + 2
    end,
    %% 玩家放烟花随机公告
    case NewCount rem 10 =:= 0 of
        true ->
            cast(light_fire, {Rid, Name, Type});
        false ->
            ignore
    end,
    %% 璀璨度奖励
    handle_award_by_light(NewCount),
    %% 璀璨度公告
    role_group:pack_cast(world, 14411, {NewCount}),
    {reply, ok, State#state{count = NewCount}};
handle_call({light_fire, _, _, _}, _From, State) ->
    {reply, ok, State};

%% 获取State数据
handle_call({get_state}, _From, State = #state{ver = Ver, state = S, nexttime = NextTime}) ->
    Now = util:unixtime(),
    RemainTime = case NextTime > Now of
        true -> NextTime - Now;
        false -> 0
    end,
    {reply, {Ver, S, next_state(S), RemainTime}, State};
%% 获取烟花燃放总数量
handle_call({get_count}, _From, State = #state{count = Count}) ->
    {reply, {Count}, State};
%% 手动开启活动
handle_call(gm_start, _From, State = #state{state = S}) when S =/= ?FIRE_CLOSE ->
    {reply, {false, ?L(<<"烟花晚会活动已经开启了">>)}, State};
handle_call(gm_start, _From, State) ->
    case get(fireworks_timer) of
        undefined -> ignore;
        Ref -> erlang:cancel_timer(Ref)
    end,
    self() ! fireworks_prepare,
    {reply, ok, State};
handle_call(gm_start_at_once, _From, State = #state{state = S}) when S =/= ?FIRE_PREPARE ->
    {reply, {false, ?L(<<"烟花晚会还没进入准备状态">>)}, State};
handle_call(gm_start_at_once, _From, State) ->
    case get(fireworks_timer) of
        undefined -> ignore;
        Ref -> erlang:cancel_timer(Ref)
    end,
    self() ! fireworks_start,
    {reply, ok, State};
%% 手动关闭活动
handle_call(gm_stop, _From, State = #state{state = S}) when S =/= ?FIRE_CLOSE ->
    case get(fireworks_timer) of
        undefined -> ignore;
        Ref -> erlang:cancel_timer(Ref)
    end,
    self() ! fireworks_close,
    {reply, ok, State};
handle_call(gm_stop, _From, State) ->
    {reply, ok, State};
handle_call({gm_set_count, Count}, _From, State) ->
    role_group:pack_cast(world, 14411, {Count}),
    {reply, ok, State#state{count = Count}};
%% 玩家放烟花
handle_call({light_fire_role, Rid, Name}, _From, State) ->
    do_light_fire(Rid, Name),
    {reply, ok, State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(gm_init, State) ->
    self() ! fireworks_init,
    {noreply, State};

handle_cast(_Data, State) ->
    {noreply, State}.

%% 初始化烟花活动
handle_info(fireworks_init, State) ->
    case get(fireworks_timer) of
        undefined -> ignore;
        Ref -> erlang:cancel_timer(Ref)
    end,
    init_timer(),
    ?INFO("重置定时器成功"),
    {noreply, State#state{state = ?FIRE_CLOSE}};

%% 活动准备
handle_info(fireworks_prepare, State = #state{state = ?FIRE_CLOSE}) ->
    role_group:pack_cast(world, 14409, {?FIRE_PREPARE, ?FIRE_ING, ?PREPARE_TIME}),
    cast(fireworks_prepare, ?PREPARE_TIME),
    put(fireworks_timer, erlang:send_after(?PREPARE_TIME * 1000, self(), fireworks_start)),
    erlang:send_after(?NOTICE_CD * 1000, self(), fireworks_prepare_notice),
    put(box_all_count, 0),
    put(box_elems, []),
    Ver = case get_online_num_local() of
        Num when is_integer(Num) andalso Num > ?VER_ONLINE_NUM ->
            ?VER_1;
        _ ->
            ?VER_2
    end,
    ?DEBUG("烟花活动准备阶段"),
    {noreply, State#state{ver = Ver, state = ?FIRE_PREPARE, count = 0, nexttime = util:unixtime() + ?PREPARE_TIME}};
handle_info(fireworks_prepare, State) ->
    ?ERR("活动准备失败:~w", [State]),
    self() ! fireworks_init,
    {noreply, State};

%% 活动准备时通知
handle_info(fireworks_prepare_notice, State = #state{state = ?FIRE_PREPARE, nexttime = NextTime}) ->
    RemainTime = NextTime - util:unixtime(),
    cast(fireworks_prepare, RemainTime),
    erlang:send_after(?NOTICE_CD * 1000, self(), fireworks_prepare_notice),
    {noreply, State};
handle_info(fireworks_prepare_notice, State) ->
    {noreply, State};

%% 活动开始
handle_info(fireworks_start, State = #state{state = ?FIRE_PREPARE}) ->
    role_group:pack_cast(world, 14409, {?FIRE_ING, ?FIRE_CLOSE, ?ING_TIME}),
    cast(fireworks_start, 0),
    handle_pour_box_timer(0),
    put(fireworks_timer, erlang:send_after(?ING_TIME * 1000, self(), fireworks_close)),
    put(light_count_award, []),
    ?DEBUG("烟花活动开始阶段"),
    {noreply, State#state{state = ?FIRE_ING, nexttime = util:unixtime() + ?ING_TIME}};
handle_info(fireworks_start, State) ->
    ?DEBUG("活动开始失败:~w", [State]),
    self() ! fireworks_init,
    {noreply, State};

%% 活动结束
handle_info(fireworks_close, State = #state{state = ?FIRE_ING}) ->
    role_group:pack_cast(world, 14409, {?FIRE_CLOSE, ?FIRE_CLOSE, 0}),
    cast(fireworks_close, 0),
    put(box_all_count, 0),
    put(light_count_award, []),
    erlang:send_after(300 * 1000, self(), fireworks_box_remove),
    self() ! fireworks_init,
    ?DEBUG("烟花活动结束"),
    {noreply, State#state{state = ?FIRE_CLOSE, count = 0, nexttime = 0}};

%% 活动定时出宝箱
handle_info({fireworks_box_timer, Circle}, State = #state{state = ?FIRE_ING}) ->
    handle_pour_box_timer(Circle),
    {noreply, State};

%% 活动结束后5分钟清出宝箱元素
handle_info(fireworks_box_remove, State) ->
    Elems = get(box_elems),
    remove_elem(Elems),
    put(box_elems, []),
    {noreply, State};

%% 玩家烟花数据清零
handle_info(fireworks_role_zero, State) ->
    ets:delete_all_objects(fireworks_role),
    erlang:send_after(util:unixtime({nexttime, 0}) * 1000, self(), fireworks_role_zero),
    {noreply, State};
%% 容错
handle_info(_Data, State) ->
    ?ERR("错误的异步消息处理：DATA:~w, State:~w", [_Data, State]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ets:to_dets(fireworks_role, qixi_fire_role),
    dets:close(qixi_fire_role),
    ?DEBUG("许愿池进程关闭:~w", [_Reason]),
    {noreply, _State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% -------------------------------------------------------------------
%% 内部函数
%% -------------------------------------------------------------------

%% 针对活动期间每天定时开放
init_timer() ->
    Now = util:unixtime(),
    StartSec = util:datetime_to_seconds(?START_DATA),
    EndSec = util:datetime_to_seconds(?END_DATA),
    if
        Now =< StartSec ->
            ThatDay = util:unixtime({today, StartSec}),
            %% TODO: 避免超过2^32限制
            T = (ThatDay + ?START_TIME - Now),
            ?INFO("定时器倒计时：~w", [T]),
            put(fireworks_timer, erlang:send_after(T * 1000, self(), fireworks_prepare));
        Now < EndSec ->
            T = util:unixtime({nexttime, ?START_TIME}),
            case Now + T > EndSec of
                true -> %% 已过期
                    skip;
                false ->
                    ?INFO("定时器倒计时：~w", [T]),
                    put(fireworks_timer, erlang:send_after(T * 1000, self(), fireworks_prepare))
            end;
        true ->
            skip
    end.

cast(fireworks_prepare, Sec) when Sec > 0 ->
    M = Sec div 60,
    notice:send(54, util:fbin(?L(<<"烟火晚会活动将在~w分钟后开启，请40级以上玩家前往许愿池准备。">>), [M]));
cast(fireworks_start, _) ->
    notice:send(54, ?L(<<"烟花晚会已经开启，活动期间燃放烟花会增加洛水主城璀璨度，当璀璨度达到2013时，全服玩家将会获得惊喜奖励！{open, 35, 我要燃放烟花, #00ff24}">>));
cast(light_fire, {{Id, SrvId}, Name, Type}) ->
    Info = notice:role_to_msg({Id, SrvId, Name}),
    notice:send(54, util:fbin(?L(<<"~s在春节来临之际，通过烟花传情真情流露，表达出“~s”的愿景！{open, 37, 我要燃放烟花, #00ff24}。">>), [Info, get_name(Type)]));
cast(fireworks_close, _) ->
    notice:send(54, ?L(<<"烟花晚会活动已结束。">>));
cast(fireworks_box_appear, Num) ->
    notice:send(54, util:fbin(?L(<<"当前璀璨度达到~w，许愿池周围出现大量宝盒，快快拾取吧！">>), [Num]));
cast(fireworks_box_appear_timer, _Num) ->
    notice:send(54, ?L(<<"烟花活动如火如荼，许愿池周围出现了大量新年红包，各位仙友们快快拾取吧！">>));
cast(fireworks_full, _) ->
    notice:send(54, ?L(<<"当前烟花晚会璀璨度达到2013，本服40级以上的在线玩家都将获得【璀璨礼包*1】！">>));
cast(_, _) -> ignore.

%% 玩家放烟花统计
do_light_fire(Rid = {Id, SrvId}, Name) ->
    case ets:lookup(fireworks_role, Rid) of
        [FR = #fireworks_role{count = Count}] ->
            NewCnt = Count + 1,
            case NewCnt =:= 10 of
                true ->
                    do_mail_reward(fire_10, {Id, SrvId, Name});
                false ->
                    ignore
            end,
            ets:insert(fireworks_role, FR#fireworks_role{count = NewCnt});
        [] ->
            ets:insert(fireworks_role, #fireworks_role{id = Rid, count = 1})
    end.

%% 获取本地节点服务器在线人数
get_online_num_local() ->
    ets:info(role_online, size).

%% 许愿池出宝箱
do_pour(undefined, {BaseId, Num}, MapId, PosList, Elems, Rand) ->
    do_pour(0, {BaseId, Num}, MapId, PosList, Elems, Rand);
do_pour(Index, {BaseId, Num}, MapId, PosList, Elems, Rand) ->
    AllElems = do_pour(Index, MapId, PosList, [], BaseId, Num, Elems, Rand),
    AllElems.
do_pour(_Index, _MapId, _PosList, _TempList, _BaseId, 0, AllElems, _Rand) -> AllElems;
do_pour(Index, MapId, [], TempList, BaseId, N, AllElems, Rand) ->
    do_pour(Index, MapId, lists:reverse(TempList), [], BaseId, N, AllElems, Rand);
do_pour(Index, MapId, [H = {X, Y} | T], TempList, BaseId, N, Elems, Rand) ->
    {DetX, DetY} = get_rand_unblocked_pos(0, MapId, X, Y, Rand),
    case map_data_elem:get(BaseId) of
        E = #map_elem{} ->
            Id = (BaseId * 10000 + Index + N),
            Elem = E#map_elem{id = Id, x = DetX, y = DetY},
            map:elem_enter(MapId, Elem),
            do_pour(Index, MapId, T, [H | TempList], BaseId, N - 1, [Id | Elems], Rand);
        _ -> 
            do_pour(Index, MapId, T, [H | TempList], BaseId, N - 1, Elems, Rand)
    end.

%% 最高5次机会，在中心点附近一定像素内随机位置
get_rand_unblocked_pos(5, _MapId, X, Y, _Rand) -> %% 随机一定次数后不出则用默认点
    ?DEBUG("经过5次投掷,仍落在无法行走区域"),
    {X, Y};
get_rand_unblocked_pos(N, MapId, X, Y, Rand) ->
    Rand2 = Rand * 2,
    NewX = X + Rand - util:rand(1, Rand2),
    NewY = Y + Rand - util:rand(1, Rand2),
    case map_mgr:is_blocked(MapId, NewX, NewY) of
        false -> {NewX, NewY};
        _ -> get_rand_unblocked_pos(N + 1, MapId, X, Y, Rand)
    end.

%% 删除一组元素
remove_elem([]) -> ok;
remove_elem([ElemId | T]) ->
    map:elem_leave(?FIRE_MAP_ID, ElemId),
    remove_elem(T).

%% 获取烟花晚会宝箱数
%% get_box_num_by_light(300) -> 30;
%% get_box_num_by_light(600) -> 40;
%% get_box_num_by_light(900) -> 50;
%% get_box_num_by_light(1200) -> 60;
%% get_box_num_by_light(_) -> 0.

get_box_num_by_time(1) -> 30;
get_box_num_by_time(2) -> 40;
get_box_num_by_time(3) -> 45;
get_box_num_by_time(4) -> 50;
get_box_num_by_time(5) -> 55;
get_box_num_by_time(6) -> 60;
get_box_num_by_time(_) -> 0.

%% 处理烟花璀璨度的奖励
handle_award_by_light(LightCount) when LightCount >= 2013 ->
    case get(light_count_award) of
        L when is_list(L) ->
            case lists:member(2013, L) of
                true -> ignore;
                false ->
                    put(light_count_award, [2013 | L]),
                    cast(fireworks_full, null),
                    lists:foreach(fun(#role_online{id = {Rid, SrvId}, name = Name, lev = Lev}) ->
                                case Lev >= 40 of
                                    true -> do_mail_reward(fireworks_full, {Rid, SrvId, Name});
                                    false -> ignore
                                end
                        end, ets:tab2list(role_online))
            end;
        _ ->
            put(light_count_award, [2013]),
            cast(fireworks_full, null),
            lists:foreach(fun(#role_online{id = {Rid, SrvId}, name = Name, lev = Lev}) ->
                        case Lev >= 40 of
                            true -> do_mail_reward(fireworks_full, {Rid, SrvId, Name});
                            false -> ignore
                        end
                end, ets:tab2list(role_online))
    end;
handle_award_by_light(LightCount) when LightCount >= 0 ->
    ignore;
handle_award_by_light(_LightCount) ->
    ignor.
    %% %% 其他情况场景产出宝盒
    %% case LightCount rem 300 =:= 0 andalso LightCount =< 2013 of
    %%     true ->
    %%         cast(fireworks_box_appear, LightCount),
    %%         Index = get(box_all_count),
    %%         Elems = get(box_elems),
    %%         Num = get_box_num_by_light(LightCount),
    %%         NewElems = do_pour(Index, {?BOX_ELEM_ID, Num}, ?FIRE_MAP_ID, ?WISH_TRANS_POINT_VER2, Elems, 150),
    %%         put(box_all_count, Index + length(NewElems) - length(Elems)),
    %%         put(box_elems, NewElems);
    %%     false ->
    %%         ignore
    %% end.

%% 处理烟花活动定时产出宝盒元素
%% 默认5次
handle_pour_box_timer(Circle) when Circle > 6->
    ignore;
handle_pour_box_timer(Circle) when Circle =< 0 ->
    erlang:send_after(util:rand(290, 300) * 1000, self(), {fireworks_box_timer, Circle + 1});
handle_pour_box_timer(Circle) ->
    %% 每5分钟产出一批宝盒元素
    erlang:send_after(util:rand(290, 300) * 1000, self(), {fireworks_box_timer, Circle + 1}),
    cast(fireworks_box_appear_timer, null),
    Index = get(box_all_count),
    Elems = get(box_elems),
    Num = get_box_num_by_time(Circle),
    NewElems = do_pour(Index, {?BOX_ELEM_ID, Num}, ?FIRE_MAP_ID, ?WISH_TRANS_POINT_VER2, Elems, 150),
    put(box_all_count, Index + length(NewElems) - length(Elems)),
    put(box_elems, NewElems),
    ok.

%% 烟花晚会璀璨度满奖励
do_mail_reward(fireworks_full, To) ->
    Subject = ?L(<<"春节活动之烟花盛会">>),
    Content = ?L(<<"亲爱的玩家，烟花盛会活动期间，您所在的服务器全城璀璨度达到了2013，因此您获得了以下额外奖励！\n感谢您在过去的一年中对梦幻飞仙的鼎力支持，梦幻飞仙祝您在新的一年里大吉大利，战力快涨！">>),
    Items = [{29245, 1, 1}],
    mail_mgr:deliver(To, {Subject, Content, [], Items});
%% 玩家每天放烟花数达到10次奖励
do_mail_reward(fire_10, To) ->
    Subject = ?L(<<"春节活动之烟花绽放">>),
    Content = ?L(<<"亲爱的玩家，烟花盛会活动期间，您燃放的【春节烟花】超过10次，因此您获得了以下额外奖励！\n感谢您在过去的一年中对梦幻飞仙的鼎力支持，梦幻飞仙祝您在新的一年里大吉大利，战力快涨！">>),
    Items = [{33003, 1, 1}],
    mail_mgr:deliver(To, {Subject, Content, [], Items});
%% 容错
do_mail_reward(_, _) -> ok.

