%%----------------------------------------------------
%%  帮会仙泉
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_pool).
-behaviour(gen_fsm).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export([start_link/0]).
-export([idle/2 ,pre/2 ,open/2]).
-export([idle/3 ,pre/3 ,open/3]).
-export([pool_pre/1, pool_close/3, pool_open/2, count_exp/3, new_guild/1]).
-export([envelope_begin/5, monster_begin/5, combat_over/1, monster_reward/1, clear_monster/4, clear/1]).
-export([restart/0, state/0, start/0, stop/0, next/0]).
-export([pool_effect/2]).

-include("role.hrl").
-include("gain.hrl").
-include("common.hrl").
-include("guild.hrl").
%%
-include("chat_rpc.hrl").
-include("map.hrl").
-include("combat.hrl").
-include("link.hrl").

-define(ts(Time), calendar:time_to_seconds(Time)).
-define(st(Seconds), calendar:seconds_to_time(Seconds)).
-define(UNIXDAYTIME, 86400).                %% unixtime 一天86400秒
-define(guild_pool_pre, ?ts({19, 35, 0})).  %% 仙泉预告时间
-define(guild_pool_pre_last, 300).          %% 预告持续时间 5   分钟
-define(guild_pool_last, 1200).             %% 仙泉持续时间 20  分钟
-define(guild_pool_count, 30).              %% 30秒计算一次

-define(guild_pool_envelope, 360).          %% 开启仙泉后，6分钟后开始出现红包
-define(guild_pool_envelope_gap, 360).      %% 每隔6分钟出现一次
-define(guild_pool_monster, 180).           %% 开启仙泉后，3分钟 后开始 出现怪物
-define(guild_pool_monster_gap, 360).       %% 每隔6分钟出现一次 怪物

-define(guild_pool_id, 10).                 %% 仙池ID
-define(guild_pool_able, 13).               %% 仙泉开启特效
-define(guild_pool_unable, 0).              %% 仙泉未开启
-define(guild_pool_special_factor, 1.5).    %% 仙泉加成 1.5, 30 分钟缩短到 20分钟
-define(guild_pool_envelop_id, 60500).      %% 红包ID
-define(guild_pool_envelop_num, 20).        %% 红包数量
-define(guild_pool_envelop_lev, 15).        %% 等级限制，红包
-define(guild_pool_envelop_id_beg, 605001). %% 红包元素开始ID

-define(guild_pool_monster_ids, [25200, 25201, 25202, 25203, 25204, 25205]).      %% 怪ID
-define(guild_pool_monster_lev, 15).        %% 等级限制，怪物
-define(guild_pool_monster_clear, (?guild_pool_last - 60)).    %% 仙泉结束前1分钟清理怪物
-define(guild_pool_monster_loss, 10).       %% 每个怪物扣 20 帮会资金
-define(guild_pool_monster_gain, 15).       %% 每个帮会贡献 帮会资金
-define(guild_pool_monster_num, 15).        %% 怪物数量

-record(state, {
        status = normal     %% 当前帮会仙泉状态 normal | temp
        ,last = 0           %% 上次计算时间
        ,next = 0           %% 下个状态切换时间
        ,sec = 0            %% 超时时间
    }
).

%%-----------------------------------------------------------------------------
%% @spec pool_effect(Role, Factor) -> {ok, NewRole}
%% Role = NewRole = #role{}
%% Factor = float()
%% @doc 帮会温泉加成
%%-----------------------------------------------------------------------------
%% 增加角色经验
pool_effect(Role = #role{event = ?event_guild, lev = Lev}, Factor) ->
    Role1 = role_listener:special_event(Role, {30001, 1}),
    {BaseExp, _} = role_exp_data:get_guild_pool(Lev),
    Exp = round(Factor * BaseExp * ?guild_pool_special_factor),
    notice:inform(util:fbin(?L(<<"获得 {str, 仙泉经验, #00ff24} ~w">>), [Exp])),
    role_gain:do([#gain{label = exp, val = Exp}], Role1);
pool_effect(_Role, _Factor) ->
    {ok}.

%% @spec restrat() -> term()
%% @doc 重启帮会仙泉
restart() ->
    supervisor:terminate_child(sup_master, guild_pool),
    supervisor:restart_child(sup_master, guild_pool).

%% @spec start() -> term()
%% @doc 启动
start() ->
    supervisor:restart_child(sup_master, guild_pool).

%% @spec stop() -> term()
%% @doc 关闭
stop() ->
    supervisor:terminate_child(sup_master, guild_pool).

%% @spec state() -> atom()
%% @doc 获取当前机状态
state() ->
    gen_fsm:sync_send_all_state_event({global, ?MODULE}, get_state).

%% @spec next() -> ok
%% @doc 帮会仙泉进入下一个状态
next() ->
    gen_fsm:send_event({global, ?MODULE}, next).

%% @spec new_guild(#guild{}) -> ok
%% @doc 监听新创建帮会
new_guild(#guild{map = MapPid}) ->
    gen_fsm:send_event({global, ?MODULE}, {new_guild, MapPid}).

%% @spec combat_over(Combat) -> ok
%% Combat = #combat{}
%% @doc 击杀帮会怪物，战斗结束
combat_over(#combat{winner = Winner}) ->
    case [Pid || #fighter{pid = Pid} <- Winner] of
        [] -> 
            ok;
        RolePids ->
            lists:foreach(fun(Pid) -> catch role:apply(async, Pid, {?MODULE, monster_reward, []}) end, RolePids),
            ok
    end.

%% @spec monster_reward(Role) -> {ok, NewRole}
%% Role = NewRole = #role{}
%% @doc 帮会怪物奖励
monster_reward(Role = #role{link = #link{conn_pid = ConnPid}}) ->
    sys_conn:pack_send(ConnPid, 10931, {55, util:fbin(?L(<<"您赶跑了入侵的流寇，获得了 ~w 帮贡, 增加了 ~w 帮会资金!">>), [?guild_pool_monster_gain, ?guild_pool_monster_gain]), []}),
    role_gain:do(#gain{label = guild_devote, val = ?guild_pool_monster_gain}, Role).

%% @spec state() -> atom()
%% @doc 获取当前机状态
clear(monsters) ->
    gen_fsm:send_all_state_event({global, ?MODULE}, clear_monster).

%%-----------------------------------------------------------
%% 系统函数
%%-----------------------------------------------------------
start_link() ->
    gen_fsm:start_link({global, ?MODULE}, ?MODULE, [], []).

%% 初始化
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    check_extra_factor(),
    Now = ?ts(time()),
    Pre = ?guild_pool_pre,
    Beg = Pre + ?guild_pool_pre_last,
    End = Beg + ?guild_pool_last,
    {State, Next} = case Now < Beg of
        true ->
            case Now < Pre of
                true -> {idle, Pre};    %% 预告之前
                false -> {pre, Beg}     %% 预告时间段
            end;
        false ->
            case Now < End of
                true -> 
                    timer_count(),
                    timer_envelope(init),
                    timer_monster(init),
                    timer_clear_monster(Beg + ?guild_pool_monster_clear - Now),
                    {open, End};        %% 活动中
                false -> {idle, Pre}    %% 活动后
            end
    end,
    erlang:register(guild_pool, self()), 
    Sec = timeout(Now, Now, Next, 0),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State, #state{last = Now, next = Next, sec = Sec}, Sec}.

%%----------------------------------------------------------------------
%% idle
%%----------------------------------------------------------------------
%% 开启一个临时性帮会仙泉
idle(next, StateData) ->
    ?INFO("帮会仙泉预告"),
    announce(pre),
    Now = ?ts(time()),
    TPre = next_time(Now, ?guild_pool_pre_last),
    case is_normal_open_time(TPre) of
        true ->
            continue(pre, StateData#state{last = Now, next = ?guild_pool_pre, status = temp});
        false ->
            continue(pre, StateData#state{last = Now, next = TPre, status = temp})
    end;

idle(timeout, StateData) ->
    ?INFO("帮会仙泉预告"),
    announce(pre),
    Now = ?ts(time()),
    continue(pre, StateData#state{last = Now, next = Now + ?guild_pool_pre_last, status = normal});

idle(_Event, StateData) ->
    continue(idle, StateData).

%% ---------------------------------------------------------------------
%% 预告状态
%% ---------------------------------------------------------------------
pre(next, StateData = #state{status = temp}) ->
    Now = ?ts(time()),
    continue(pre, StateData#state{last = Now, next = Now, sec = 0});

pre(timeout, StateData = #state{status = temp}) ->
    ?INFO("帮会仙泉开启"),
    timer_count(),
    timer_envelope(init),
    timer_monster(init),
    timer_clear_monster(?guild_pool_monster_clear),
    announce(open),
    check_extra_factor(),
    Now = ?ts(time()),
    TEnd = next_time(Now, ?guild_pool_last),
    case is_normal_open_time(TEnd) of
        true ->
            continue(open, StateData#state{last = Now, next = ?guild_pool_pre});
        false ->
            continue(open, StateData#state{last = Now, next = TEnd})
    end;

pre(next, StateData) ->
    continue(pre, StateData);

pre(timeout, StateData) ->
    ?INFO("帮会仙泉开启"),
    timer_count(),
    timer_envelope(init),
    timer_monster(init),
    timer_clear_monster(?guild_pool_monster_clear),
    announce(open),
    check_extra_factor(),
    Now = ?ts(time()),
    continue(open, StateData#state{last = Now, next = Now + ?guild_pool_last});

pre(_Event, StateData) ->
    continue(pre, StateData).

%%------------------------------------------------------------------------
%% open
%%------------------------------------------------------------------------
%% 计算经验
open(count, StateData) ->
    timer_count(),
    count_exp(),
    continue(open, StateData);

%% 产出红包
open(envelope, StateData) ->
    timer_envelope(open),
    spawn(fun envelope/0),
    continue(open, StateData);

%% 产出怪物
open(monster, StateData) ->
    timer_monster(open),
    spawn(fun monster/0),
    continue(open, StateData);

%% 清理怪物
open(clear_monster, StateData) ->
    cancel_timer(monster),
    spawn(fun clear_monster/0),
    continue(open, StateData);

%% 监听活动中创建的帮会
open({new_guild, MapPid}, StateData) ->
    map:elem_change(MapPid, ?guild_pool_id, ?guild_pool_able),
    continue(open, StateData);

open(next, StateData = #state{status = temp}) ->
    gen_fsm:send_event(self(), clear_monster),
    cancel_timer(clear_monster),
    Now = ?ts(time()),
    continue(open, StateData#state{last = Now, next = Now, sec = 0});

open(next, StateData) ->
    continue(open, StateData);

open(timeout, StateData) ->
    ?INFO("帮会仙泉结束"),
    announce(over),
    cancel_timer(),
    continue(idle, StateData#state{last = ?ts(time()), next = ?guild_pool_pre, status = normal});

open(_Event, StateData) ->
    continue(open, StateData).

%%--------------------------------------------------------------------
%% 状态回调函数
%%-------------------------------------------------------------------
idle(_Event, _From, StateData) ->
    continue(idle, StateData).

pre(_Event, _From, StateData) ->
    continue(pre, StateData).

open(_Event, _From, StateData) ->
    continue(open, StateData).

handle_event(clear_monster, StateName, StateData) ->
    spawn(fun clear_monster/0),
    continue(StateName, StateData);

handle_event(_Event, StateName, StateData) ->
    continue(StateName, StateData).
 
handle_sync_event(get_state, _From, StateName, StateData = #state{last = Last, next = Next}) ->
    ReState = StateData#state{last = calendar:seconds_to_time(Last), next = calendar:seconds_to_time(Next)},
    case continue(StateName, StateData) of
        {next_state, StateName, NewStateData} ->
            ReNewState = NewStateData#state{last = calendar:seconds_to_time(?ts(time())), next = calendar:seconds_to_time(Next)},
            {reply, {StateName, ReState, ReNewState, 0}, StateName, NewStateData};
        {next_state, StateName, NewStateData, Timeout} ->
            ReNewState = NewStateData#state{last = calendar:seconds_to_time(?ts(time())), next = calendar:seconds_to_time(Next)},
            {reply, {StateName, ReState, ReNewState, Timeout}, StateName, NewStateData, Timeout}
    end;

handle_sync_event(_Event, _From, StateName, StateData) ->
    continue(StateName, StateData).

handle_info(_Info, StateName, StateData) ->
    continue(StateName, StateData).
 
%%-----------------------------------------------------------
%% 系统关闭
%%-----------------------------------------------------------
terminate(_Reason, _StateName, _StatData) ->
    ok.
 
%%-----------------------------------------------------------
%% 热代码切换
%%-----------------------------------------------------------
code_change(_OldVsn, StateName, StateData, _Extra) ->
    {ok, StateName, StateData}.

%%----------------------------------------------------------
%% 私有函数
%%----------------------------------------------------------
timer_count() ->
    Ref = gen_fsm:send_event_after(?guild_pool_count * 1000, count),
    put(count_ref, Ref).

timer_envelope(init) ->
    Ref = gen_fsm:send_event_after(?guild_pool_envelope * 1000, envelope),
    put(envelope_ref, Ref);

timer_envelope(_) ->
    Ref = gen_fsm:send_event_after(?guild_pool_envelope_gap * 1000, envelope),
    put(envelope_ref, Ref).

timer_monster(init) ->
    Ref = gen_fsm:send_event_after(?guild_pool_monster * 1000, monster),
    put(monster_ref, Ref);

timer_monster(_) ->
    Ref = gen_fsm:send_event_after(?guild_pool_monster_gap * 1000, monster),
    put(monster_ref, Ref).

timer_clear_monster(Time) ->
    Ref = gen_fsm:send_event_after(Time * 1000, clear_monster),
    put(clear_monster_ref, Ref).

%% 取消所有相关定时器
cancel_timer() ->
    cancel_timer(count),
    cancel_timer(envelope),
    cancel_timer(monster),
    cancel_timer(clear_monster).

cancel_timer(count) ->
    case get(count_ref) of
        CountRef when is_reference(CountRef) ->
            erase(count_ref),
            gen_fsm:cancel_timer(CountRef);
        _ -> ok
    end;
cancel_timer(envelope) ->
    case get(envelope_ref) of
        EnvelopeRef when is_reference(EnvelopeRef) ->
            erase(envelope_ref),
            gen_fsm:cancel_timer(EnvelopeRef);
        _ -> ok
    end;
cancel_timer(monster) ->
    case get(monster_ref) of
        MonsterRef when is_reference(MonsterRef) ->
            erase(monster_ref),
            gen_fsm:cancel_timer(MonsterRef);
        _ -> ok
    end;
cancel_timer(clear_monster) ->
    case get(clear_monster_ref) of
        Ref when is_reference(Ref) ->
            erase(clear_monster_ref),
            gen_fsm:cancel_timer(Ref);
        _ -> ok
    end.

%% @spec timeout(PreTime, Now, NextTime, Sec) -> NewSec
%% PreTime = integer()  上一次计算 timeout 时间
%% NextTime = integer() 下一次状态切换时间点
%% Sec = integer()      上次计算 timeout 后，到下一次状态切换的超时时间 Sec 也是本函数的返回值
%% Now = integer()      本次计算 timeout 当前时间
%% @doc 重新计算timeout值
%% TODO 系统启动时  timeout(_PreTime, NextTime, -1, Now) when NextTime < Now ->
%% TODO 系统启动时      (?UNIXDAYTIME + NextTime - Now) * 1000;
%% TODO 系统启动时  timeout(_PreTime, NextTime, -1, Now) ->
%% TODO 系统启动时      (NextTime - Now) * 1000;
timeout(_LastTime, Now, NextTime, _Sec) when NextTime > Now ->
    (NextTime - Now) * 1000;
timeout(_LastTime, Now, NextTime, _Sec) when NextTime =:= Now ->
    0;
timeout(LastTime, Now, NextTime, Sec) ->
    case (Now - LastTime) * 1000 > Sec of
        true -> 0;
        false -> (?UNIXDAYTIME + NextTime - Now) * 1000
    end.

%% 
continue(NextState, StateData = #state{last = Last, next = Next, sec = Sec}) ->
    Time = time(),
    Date = date(),
    Now = ?ts(Time),
    case timeout(Last, Now, Next, Sec) of
        0 ->
            case get(continue_timout_pre) of
                Val when Val =:= {Date, Time} ->
                    ok;
                _ ->
                    put(continue_timout_pre, {Date, Time}),
                    gen_fsm:send_event(self(), timeout) %% 避免同一时间点重复
            end,
            {next_state, NextState, StateData#state{last = Now, next = Next, sec = 0}};
        NewSec ->
            {next_state, NextState, StateData#state{last = Now, next = Next, sec = NewSec}, NewSec}
    end.

%% 计算下一个切换时间点
next_time(Beg, Last) ->
    End = Beg + Last,
    case End >= 86400 of
        false -> End;
        true -> End - 86400
    end.

%% 计算是不是正常的开放时间
is_normal_open_time(Time) ->
    Time >= ?guild_pool_pre andalso Time =< (?guild_pool_pre_last + ?guild_pool_last).

%% 根据座位号获取对应的仙池加成因子
pool(?chair_c) -> ?chief_factor;
pool(Chair) when Chair >= ?chair_e1, Chair =< ?chair_e2 -> ?elder_factor;
pool(Chair) when Chair >= ?chair_l1, Chair =< ?chair_l4 -> ?lord_factor;
pool(_Chair) -> ?disciple_factor.

%% 仙池经验计算 
count_exp() ->
    case guild_mgr:list() of
        false ->
            ok;
        Guilds ->
            Fun = fun(#guild{members = Mems, chairs = Chairs}) -> spawn(?MODULE, count_exp, [Mems, Chairs, get_ext_factor()]) end,
            lists:foreach(Fun, Guilds)
    end.

count_exp([], _Chairs, _Factor) ->
    ok;
count_exp([#guild_member{pid = Pid} | T], [], Factor) when is_pid(Pid) ->
    role:apply(async, Pid, {guild_pool, pool_effect, [?disciple_factor * Factor]}),
    count_exp(T, [], Factor);
count_exp([#guild_member{pid = Pid, rid = Rid, srv_id = Rsrvid} | T], Chairs, Factor) when is_pid(Pid) ->
    case lists:keyfind({Rid, Rsrvid}, 2, Chairs) of
        false ->
            role:apply(async, Pid, {guild_pool, pool_effect, [?disciple_factor * Factor]}),
            count_exp(T, Chairs, Factor);
        {Chair, _ } ->
            role:apply(async, Pid, {guild_pool, pool_effect, [pool(Chair) * Factor]}),
            count_exp(T, lists:keydelete(Chair, 1, Chairs), Factor)
    end;
count_exp([_ | T], Chairs, Factor) ->
    count_exp(T, Chairs, Factor).

%% 预告通知
announce(pre) -> 
    case guild_mgr:list() of
        false ->
            ok;
        Guilds ->
            Fun = fun(#guild{members = Mems}) -> spawn(?MODULE, pool_pre, [Mems]) end,
            lists:foreach(Fun, Guilds)
    end;

%% 开启通知
announce(open) -> 
    case guild_mgr:list() of
        false ->
            ok;
        Guilds ->
            Fun = fun(#guild{map = MapPid, members = Mems}) -> spawn(?MODULE, pool_open, [MapPid, Mems]) end,
            lists:foreach(Fun, Guilds)
    end;
%% 结束通知
announce(over) -> 
    case guild_mgr:list() of
        false ->
            ok;
        Guilds ->
            Fun = fun(#guild{map = MapPid, members = Mems, entrance = {MapId, _, _}}) -> spawn(?MODULE, pool_close, [MapPid, Mems, MapId]) end,
            lists:foreach(Fun, Guilds)
    end.

%% 预告提示
pool_pre(Mems) ->
    Fun = fun(#guild_member{pid = Pid}) -> 
                catch role:pack_send(Pid, 10932, {?chat_guild, 61, ?L(<<"帮会仙泉将于 19:40 点开启，持续20分钟, 在帮会领地可获得仙泉经验！">>)}) 
        end,
    lists:foreach(Fun, Mems). 

%% 开启提示
pool_open(MapPid, Mems) ->
    map:elem_change(MapPid, ?guild_pool_id, ?guild_pool_able),
    Fun = fun(#guild_member{pid = Pid}) -> 
                catch role:pack_send(Pid, 10932, {?chat_guild, 61, ?L(<<"帮会仙泉已经开启，请帮主、长老和堂主等人上座位，会有额外效果经验加成">>)}),
                catch role:pack_send(Pid, 10932, {?chat_right, 0, ?L(<<"{str, 仙泉已开启, #00ff24}">>)}) 
        end,
    lists:foreach(Fun, Mems).

%% 结束提示 以及清理工作
pool_close(MapPid, Mems, MapId) ->
    map:elem_change(MapPid, ?guild_pool_id, ?guild_pool_unable),
    Fun = fun(#guild_member{pid = Pid}) -> 
                catch role:pack_send(Pid, 10932, {?chat_guild, 61, ?L(<<"帮会仙泉已经关闭">>)}),
                catch role:pack_send(Pid, 10932, {?chat_right, 0, ?L(<<"{str, 仙泉已关闭, #00ff24}">>)}) 
        end,
    lists:foreach(Fun, Mems),
    RemEnvelopes = [ID || #map_elem{id = ID} <- map:lookup_elems(MapId, ?guild_pool_envelop_id)],
    lists:foreach(fun(ElemID) -> map:elem_leave(MapId, ElemID) end, RemEnvelopes).

%% 获取活动外部因子
get_ext_factor() ->
    case get(guild_pool_ext_factor) of
        Ratio when is_integer(Ratio) -> Ratio;
        _ -> 1
    end.

%% 保存外部活动因子
check_extra_factor() ->
    case campaign_data:get_camp_pool_time() of
        true -> put(guild_pool_ext_factor, 2);
        false -> put(guild_pool_ext_factor, 1)
    end.

%% ----------------------------------------------------------
%% 产出红包
%% ----------------------------------------------------------
envelope() ->
    case guild_mgr:list() of
        false ->
            ok;
        Guilds ->
            Fun = fun(#guild{map = MapPid, members = Mems, lev = Lev, gvip = Gvip, entrance = {MapId, _, _}}) -> spawn(?MODULE, envelope_begin, [MapPid, Mems, Lev, Gvip, MapId]) end,
            lists:foreach(Fun, Guilds)
    end.

envelope_begin(_MapPid, _Members, Lev, _Vip, _MapId) when Lev < ?guild_pool_envelop_lev ->
    ok;
envelope_begin(MapPid, Mems, _Lev, Gvip, MapId) ->
    Fun = fun(#guild_member{pid = Pid}) -> 
            catch role:pack_send(Pid, 10932, {?chat_guild, 61, <<"帮会仙泉附近掉落了一批帮会宝箱，捡取可以增加帮会资金，还能获得帮贡。果断捡了吧！">>})
    end,
    lists:foreach(Fun, Mems),
    MapBaseId = case Gvip of
        ?guild_vip -> ?guild_vip_mapid;
        _ -> ?guild_piv_mapid
    end,
    #map_data{width = Width, height = Height} = map_data:get(MapBaseId),
    Envelope = map_data_elem:get(?guild_pool_envelop_id),
    RemEnvelopes = [ID || #map_elem{id = ID} <- map:lookup_elems(MapId, ?guild_pool_envelop_id)],
    lists:foreach(fun(ElemID) -> map:elem_leave(MapId, ElemID) end, RemEnvelopes),
    create_envelope(Gvip, MapBaseId, MapPid, Envelope, Width, Height, ?guild_pool_envelop_id_beg, 0).

%% 生成红包元素
create_envelope(_Gvip, _MapBaseId, _MapPid, _Envelope, _Width, _Height, _NextID, ?guild_pool_envelop_num) ->
    ok;
create_envelope(Gvip, MapBaseId, MapPid, Envelope, Width, Height, NextID, Index) ->
    H = util:rand(1, Height-1),
    W = util:rand(1, Width-1),
    case is_allow_point(Gvip, H, W) of
        true ->
            case map_mgr:is_blocked(MapBaseId, W, H) of
                true ->
                    create_envelope(Gvip, MapBaseId, MapPid, Envelope, Width, Height, NextID, Index);
                false ->
                    map:elem_enter(MapPid, Envelope#map_elem{id = NextID, x = W, y = H}),
                    create_envelope(Gvip, MapBaseId, MapPid, Envelope, Width, Height, NextID + 1, Index + 1)
            end;
        _ ->
            create_envelope(Gvip, MapBaseId, MapPid, Envelope, Width, Height, NextID, Index)
    end.

%% 限定红包的地图位置
is_allow_point(?guild_vip, H, W) -> H >= 300 andalso H =< 900 andalso W >= 1320 andalso W =< 2460;
is_allow_point(_, H, W) -> H >= 300 andalso H =< 810 andalso W >= 1740 andalso W =< 2520.


%% ----------------------------------------------------------
%% 产出怪物
%% ----------------------------------------------------------
monster() ->
    case guild_mgr:list() of
        false ->
            ok;
        Guilds ->
            Fun = fun(#guild{map = MapPid, members = Mems, lev = Lev, gvip = Gvip, entrance = {MapId, _, _}}) -> spawn(?MODULE, monster_begin, [MapPid, Mems, Lev, Gvip, MapId]) end,
            lists:foreach(Fun, Guilds)
    end.

monster_begin(_MapPid, _Members, Lev, _Vip, _MapId) when Lev < ?guild_pool_monster_lev ->
    ok;
monster_begin(MapPid, Mems, _Lev, Gvip, MapId) ->
    Fun = fun(#guild_member{pid = Pid}) -> 
            catch role:pack_send(Pid, 10932, {?chat_guild, 61, <<"一批流寇来到了帮会领地，妄图窃取帮会资金，快拿起武器赶走它们吧，否则流寇会抢走帮会资金。">>})
    end,
    lists:foreach(Fun, Mems),
    MapBaseId = case Gvip of
        ?guild_vip -> ?guild_vip_mapid;
        _ -> ?guild_piv_mapid
    end,
    #map_data{width = Width, height = Height} = map_data:get(MapBaseId),
    case get_rem_monsters(MapPid) of
        Num when Num >= ?guild_pool_monster_num ->
            ok;
        Num ->
            create_monster(Gvip, MapBaseId, MapId, MapPid, Width, Height, ?guild_pool_monster_num - Num)
    end.

%% 生成 帮会怪物
create_monster(_Gvip, _MapBaseId, _MapId, _MapPid, _Width, _Height, Index) when Index =< 0 ->
    ok;
create_monster(Gvip, MapBaseId, MapId, MapPid, Width, Height, Index) ->
    H = util:rand(1, Height-1),
    W = util:rand(1, Width-1),
    case is_monster_point(Gvip, H, W) of
        true ->
            case map_mgr:is_blocked(MapBaseId, W, H) of
                true ->
                    create_monster(Gvip, MapBaseId, MapId, MapPid, Width, Height, Index);
                false ->
                    map:create_npc(MapId, lists:nth(util:rand(1, length(?guild_pool_monster_ids)), ?guild_pool_monster_ids), W, H),
                    create_monster(Gvip, MapBaseId, MapId, MapPid, Width, Height, Index - 1)
            end;
        _ ->
            create_monster(Gvip, MapBaseId, MapId, MapPid, Width, Height, Index)
    end.

%% 限定红包的地图位置
is_monster_point(?guild_vip, H, W) ->
    H >= 300 andalso H =< 900 andalso W >= 1320 andalso W =< 2460;
is_monster_point(_, H, W) ->
    H >= 300 andalso H =< 810 andalso W >= 1740 andalso W =< 2520.

%% -------------------------------
%% 清理怪物
%% -------------------------------
clear_monster() ->
    case guild_mgr:list() of
        false ->
            ok;
        Guilds ->
            Fun = fun(#guild{pid = GuildPid, map = MapPid, members = Mems, entrance = {MapId, _, _}}) -> spawn(?MODULE, clear_monster, [GuildPid, MapPid, Mems, MapId]) end,
            lists:foreach(Fun, Guilds)
    end.

clear_monster(GuildPid, MapPid, Mems, _MapId) ->
    try map:npc_list(MapPid) of
        NpcList when is_list(NpcList) ->
            RemMonsters = get_guild_pool_monster(NpcList),
            Fun = fun(Msg) -> fun(#guild_member{pid = Pid}) -> catch role:pack_send(Pid, 10932, {?chat_guild, 61, Msg}) end end,
            MapPid ! {clear_guild_monster},
            Num = length(RemMonsters),
            Lost = Num * ?guild_pool_monster_loss,
            if
                Lost > 0 ->
                    lists:foreach(Fun(util:fbin(<<"很遗憾, ~w 个流寇潜入帮会，抢走了 ~w 帮会资金!">>, [Num, Lost])), Mems),
                    guild:guild_loss(GuildPid, Lost);
                true ->
                    lists:foreach(Fun(<<"在帮会成员的努力下, 成功赶走了入侵的流寇!">>), Mems)
            end;
        _ -> ok
    catch
        _Error:_Info -> ok
    end.

get_guild_pool_monster(NpcList) ->
    get_guild_pool_monster(NpcList, []).
get_guild_pool_monster([], Monsters) -> Monsters;
get_guild_pool_monster([#map_npc{id = Nid, base_id = Bid} | NpcList], Monsters) ->
    case lists:member(Bid, ?guild_pool_monster_ids) of
        true -> get_guild_pool_monster(NpcList, [Nid | Monsters]);
        _ -> get_guild_pool_monster(NpcList, Monsters)
    end;
get_guild_pool_monster([_ | NpcList], Monsters) ->
    get_guild_pool_monster(NpcList, Monsters).

%% 获取怪物数量
get_rem_monsters(MapPid) ->
    try map:npc_list(MapPid) of
        NpcList when is_list(NpcList) ->
            length(get_guild_pool_monster(NpcList));
        _ -> 0
    catch
        _Error:_Info -> 0
    end.
