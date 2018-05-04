%% ------------------------------------
%% 许愿墙活动及相关处理
%% @author wpf(wprehard@qq.com)
%% ------------------------------------

-module(wish_wall).
-export([
        start_link/0
        %% 节点服
        ,get_wall/1
        ,get_wall_rand/0
        ,add_wish/7
        ,local_luck/5
        %% 中央服
        ,get_wall/2
        ,get_wall_rand/1
        ,add_wish/1
        ,add_wish/2
    ]).
%% debug functions
-export([debug/1, info/1]).
%% adm functions
-export([gm_status/0, gm/1]).
%% gen_fsm callbacks
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
%% state functions
-export([idel/2, active/2]).

-include("common.hrl").
-include("center.hrl").
-include("role.hrl").
-include("map.hrl").

%% 许愿、表白内容
-record(wish_cont, {
        id = 0
        ,role_id = {0, <<>>}
        ,name = <<>>
        ,type = 0                   %% 1-许愿 2-表白/祝福
        ,nickname = <<>>            %% 昵称(1-5字)，为空默认显示角色名
        ,to_role_id = 0             %% 对象角色ID和服务器标识，0表示无对象
        ,to_name = <<>>             %% 对象角色名
        ,content = <<>>              %% 内容(1-20字)
        ,ctime = 0                  %% 时间戳
    }).

%% 活动系统结构:节点服、中央服共用
-record(state, {
        ts = 0              %% 当前活动状态切换时间戳
        ,t_cd = 0           %% 当前活动持续时间
        ,is_center = 0      %% 是否中央服，节点服运行只做本服幸运抽取
        ,roles = []         %% 参加许愿的ID映射列表[{RoleId, IdList} | ...]
        ,to_roles = []      %% 接受许愿的ID映射列表[{RoleId, IdList} | ...]
        ,srvs = []          %% 玩家参加许愿的平台映射列表[{SrvId, IdList} | ...]
        ,ids_1 = []         %% 许愿ID列表
        ,ids_2 = []         %% 表白、祝福ID列表
        ,lucks = []         %% 幸运表白列表，用于中央服缓存
        ,next_id = 1        %% 下个ID
    }).

%% 宏定义
%% 活动更新：1、修改时间 2、全服抽取时间CD和次数({center_luck, TimeCd/LuckCd})
-define(START_TIME, {{2013, 4, 28}, {0, 0, 0}}). %% 开始时间
-define(END_TIME, {{2013, 5, 3}, {23, 59, 0}}). %% 结束时间
-define(IDEL_CD, 3600). %% 空闲IDEL的CD时间
-define(LUCK_CD, 120). %% 幸运抽取时间CD，单位秒
-define(DEBUG_CD, 3600). %% 活动测试持续时间

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

pack_proto(L) ->
    [{Rid, SrvId, Name, Type, ToRid, ToSrvId, ToName, NickName, Cont, Ct} || #wish_cont{type = Type, role_id = {Rid, SrvId}, name = Name, to_role_id = {ToRid, ToSrvId}, to_name = ToName, nickname = NickName, content = Cont, ctime = Ct} <- L].

%% @spec get_wall_rand() -> list()
get_wall_rand() ->
    case center:call(wish_wall, get_wall_rand, [10]) of
        List when is_list(List) ->
            {pack_proto(List)};
        _ -> {[]}
    end.

%% @spec get_wall_rand(N) -> list()
%% 获取许愿墙
%% 随机读取N条内容
get_wall_rand(N) ->
    Max = ets:info(ets_wish_wall_list, size),
    case Max > 0 of
        true ->
            do_get_wall_page(N, Max, []);
        false -> []
    end.

%% @spec get_wall(RoleId, N) -> {list(), list()}
%% 获取许愿墙显示信息
get_wall(#role{id = RoleId, pid = _RolePid}) ->
    case center:call(wish_wall, get_wall, [RoleId, 10]) of
        {_Rands, Lucks, MyL} ->
            %% role:pack_send(RolePid, 14421, {pack_proto(Rands)}),
            {pack_proto(Lucks), pack_proto(MyL)};
        _ -> {[], []}
    end.

%% @spec get_wall(RoleId, N) -> {list(), list(), list()}
%% 获取许愿墙显示信息
%% 随机读取N条内容
get_wall(RoleId, N) when N > 0 ->
    %% Rands = get_wall_rand(10),
    {Lucks, IdL} = case gen_fsm:sync_send_all_state_event(?MODULE, {get_wall, RoleId}) of
        {ok, Data} -> Data;
        _ -> {[], []}
    end,
    MyL = do_get_my_wish(IdL, []),
    {[], Lucks, MyL};
    %% {Rands, Lucks, MyL};
get_wall(_, _) -> {[], [], []}.

do_get_my_wish([], Back) -> Back;
do_get_my_wish([Id | T], Back) ->
    case ets:lookup(ets_wish_wall_list, Id) of
        [WC] -> do_get_my_wish(T, [WC | Back]);
        _ -> do_get_my_wish(T, Back)
    end.

%% @spec add_wish(Type, RoleId, Name, ToRoleId, ToName, NickName, Cont) -> ok | {false, Msg}
%% 增加表白或许愿
add_wish(Type, _RoleId, _Name, _ToRoleId, _ToName, _NickName, _Cont) when Type =/= 1 andalso Type =/= 2 ->
    {false, ?L(<<"目前许愿墙仅支持许愿、表白或祝福">>)};
add_wish(_Type, _RoleId, _Name, _ToRoleId, ToName, NickName, Cont)
when byte_size(NickName) > 30 orelse byte_size(Cont) > 150 orelse byte_size(ToName) > 60 ->
    {false, ?L(<<"输入的昵称或内容过长，浓缩的才是精华">>)};
add_wish(Type, RoleId, Name, ToRoleId, ToName, NickName, Cont) ->
    TextList = ["爱", "结婚", "嫁", "娶", "喜欢", "老公", "老婆", "情", "一起", "想", "心", "祝", "希望", "情窦", "炽热", "鸽哨", "天际", "琼浆", "尘缘", "抵挡", "平行线"],
    WC = #wish_cont{role_id = RoleId, name = Name, to_role_id = ToRoleId, to_name = ToName, nickname = NickName, type = Type, content = Cont},
    case util:text_banned(Cont, TextList) andalso byte_size(Cont) >= 24 of
        true ->
            center:call(wish_wall, add_wish, [true, WC]);
        false ->
            center:call(wish_wall, add_wish, [WC])
    end.

%% @spec add_wish(Wc) -> ok | {false, Msg}
%% 增加表白或许愿
add_wish(Wish) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {add_wish, Wish}).

%% @spec add_wish(Wc) -> ok | {false, Msg}
%% 增加表白或许愿
add_wish(true, Wish) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {add_wish_luck, Wish});
add_wish(_, Wish) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {add_wish, Wish}).

%% 节点处理单服幸运表白
local_luck(role_id, RoleId = {Rid, SrvId}, Name, {ToRid, ToSrvId}, ToName) ->
    notice:send(53, util:fbin(?L(<<"~s对~s的表白情深意切，被选为幸运表白者！敬请期待21:00全平台幸运表白！{handle, 49, 赠花祝福, #00ff24, ~w, ~s, ~s}">>), [notice:role_to_msg({Rid, SrvId, Name}), notice:role_to_msg({ToRid, ToSrvId, ToName}), Rid, SrvId, Name])),
    Cont1 = ?L(<<"亲爱的玩家，深情表白活动期间，与你有关的表白被选为本服服“幸运表白”，您是表白者，因此获得了以下额外奖励！\n感谢您在过去的一年中对梦幻飞仙的鼎力支持，梦幻飞仙祝您在新的一年里大吉大利，战力快涨！">>),
    mail_mgr:deliver(RoleId, {?L(<<"春节快乐之深情表白">>), Cont1, [], [{29241, 1, 1}]}),
    ok;
local_luck(to_role_id, _RoleId, _Name, ToRoleId, _ToName) ->
    Cont2 = ?L(<<"亲爱的玩家，深情表白活动期间，与你有关的表白被选为本服“幸运表白”，您是被表白者，因此获得了以下额外奖励！\n感谢您在过去的一年中对梦幻飞仙的鼎力支持，梦幻飞仙祝您在新的一年里大吉大利，战力快涨！">>),
    mail_mgr:deliver(ToRoleId, {?L(<<"春节快乐之深情表白">>), Cont2, [], [{29241, 1, 1}]}),
    ok.

%% 中央服处理随机幸运表白&祝福
center_luck(#wish_cont{role_id = {Rid, SrvId}, to_role_id = {ToRid, ToSrvId}, name = Name, to_name = ToName}) ->
    Title = ?L(<<"春节快乐之深情表白">>),
    Cont1 = ?L(<<"亲爱的玩家，深情表白活动期间，与你有关的表白被选为全服“幸运表白”，您是表白者，因此获得了以下额外奖励！\n感谢您在过去的一年中对梦幻飞仙的鼎力支持，梦幻飞仙祝您在新的一年里大吉大利，战力快涨！">>),
    Cont2 = ?L(<<"亲爱的玩家，深情表白活动期间，与你有关的表白被选为全服“幸运表白”，您是被表白者，因此获得了以下额外奖励！\n感谢您在过去的一年中对梦幻飞仙的鼎力支持，梦幻飞仙祝您在新的一年里大吉大利，战力快涨！">>),
    c_mirror_group:cast(node, SrvId, mail_mgr, deliver, [{Rid, SrvId}, {Title, Cont1, [], [{33045, 1, 1}, {33046, 1, 88}]}]),
    c_mirror_group:cast(node, ToSrvId, mail_mgr, deliver, [{ToRid, SrvId}, {Title, Cont2, [], [{33045, 1, 1}, {29240, 1, 1}]}]),
    Msg = util:fbin(?L(<<"琴瑟合鸣，情比金坚，~s对~s的深情表白感动了飞仙世界，快快祝福TA吧！{handle, 49, 赠花祝福, #00ff24, ~w, ~s, ~s}">>), [notice:role_to_msg({Rid, SrvId, Name}), notice:role_to_msg({ToRid, ToSrvId, ToName}), Rid, SrvId, Name]),
    c_mirror_group:cast(all, notice, send, [53, Msg]),
    ok.

%% gm命令
gm_status() ->
    gen_fsm:send_event(?MODULE, debug_timeout).

%% @spec gm(Data) -> any()
gm(Data) ->
    info({gm, Data}).

%% @spec info(Msg) -> any()
%% Msg = term()
info(Msg) ->
    gen_fsm:send_all_state_event(?MODULE, Msg).

%% 测试/打印信息
debug(Msg) ->
    info({debug, Msg}).

%% 计算下个状态和持续时间
get_next_act_sec() ->
    Start = util:datetime_to_seconds(?START_TIME),
    End = util:datetime_to_seconds(?END_TIME),
    Now = util:unixtime(),
    case Now >= Start andalso Now < End of
        true ->
            {active, End - Now};
        false when Now < Start ->
            {idel, Start - Now};
        _ ->
            {idel, ?IDEL_CD}
    end.

%% 初始化表
init_table() ->
    case center:is_cross_center() of
        true ->
            dets:open_file(dets_wish_wall_list, [{file, "../var/wish_wall_list_cache.dets"}, {keypos, #wish_cont.id}, {type, set}]),
            ets:new(ets_wish_wall_list, [public, named_table, set, {keypos, #wish_cont.id}]);
        false -> ignore
    end.

%% 导入数据
load_data(active) ->
    case center:is_cross_center() of
        true ->
            dets:to_ets(dets_wish_wall_list, ets_wish_wall_list),
            State = case sys_env:get(wish_wall_state) of
                Data = #state{} -> Data;
                _ -> #state{}
            end,
            ?INFO("中央服活动中重启，读取数据完毕:~w", [ets:info(ets_wish_wall_list, size)]),
            State#state{is_center = ?true};
        false ->
            #state{lucks = []}
    end;
load_data(_) ->
    case center:is_cross_center() of
        true ->
            #state{is_center = ?true};
        false ->
            #state{}
    end.

%% 保存数据
save_cache(State = #state{is_center = ?true}) ->
    ets:to_dets(ets_wish_wall_list, dets_wish_wall_list),
    sys_env:save(wish_wall_state, State);
save_cache(#state{is_center = ?false}) ->
    ok.

%% 隔天清过期缓冲数据
clean_cache(State = #state{is_center = ?true}) ->
    State#state{srvs = [], roles = [], to_roles = []};
clean_cache(State) -> State.
    
%% 清空数据
clean_data(#state{is_center = ?true}) ->
    dets:delete_all_objects(dets_wish_wall_list),
    ets:delete_all_objects(ets_wish_wall_list),
    sys_env:save(wish_wall_state, undefined),
    #state{is_center = ?true};
clean_data(State) ->
    State.

%% 以下是幸运抽取的每天定时器
%% 活动开始初始化定时器:节点服、中央服
init_timer(#state{is_center = ?false}) ->
    Now = util:unixtime(),
    Today = util:unixtime(today),
    ToTime = (Today + 20*3600 + 30*60),
    case Now < ToTime of
        true -> %% 20:30单服幸运抽取
            put(local_luck_timer, erlang:send_after((ToTime - Now)*1000, self(), local_luck));
        false ->
            put(local_luck_timer, erlang:send_after((86400 - (Now - ToTime))*1000, self(), local_luck))
    end;
init_timer(#state{is_center = ?true}) ->
    %% 全平台幸运抽取 定时器
    Now = util:unixtime(),
    Today = util:unixtime(today),
    ToTimeS = (Today + 21*3600),
    ToTimeE = (Today + 21*3600 + 30*60),
    %% 21:00开始中央服每隔2分钟幸运抽取
    if
        Now < ToTimeS ->
            put(center_luck_timer, erlang:send_after((ToTimeS - Now)*1000, self(), {center_luck, 10}));
        Now < ToTimeE ->
            self() ! {center_luck, 10};
        true ->
            put(center_luck_timer, erlang:send_after((86400 - (Now - ToTimeS))*1000, self(), {center_luck, 10}))
    end.

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------

%% Func: init/1
%% Returns: {ok, StateName, StateData}          |
%%          {ok, StateName, StateData, Timeout} |
%%          ignore                              |
%%          {stop, StopReason}
init([]) ->
    ?INFO("~w 正在启动", [?MODULE]),
    init_table(),
    %% 若是上次活动中重启，读取缓存数据
    Now = util:unixtime(),
    CdTomorrow = 20 + util:unixtime({tomorrow, Now}) - Now,
    erlang:send_after(CdTomorrow*1000, self(), clean_cache), %% 清一次过期数据
    case get_next_act_sec() of
        {idel, CdSec} ->
            State = load_data(idel),
            ?INFO("~w 启动完成", [?MODULE]),
            %% 默认idel
            {ok, idel, State#state{ts = util:unixtime(), t_cd = CdSec}, CdSec*1000};
        {active, CdSec} ->
            State = load_data(active),
            ?INFO("许愿树进程活动开始：~w", [State#state.next_id]),
            %% 初始化定时器
            erlang:send_after(3600 * 1000, self(), save_cache), %% 定时缓存数据，预防强制关机
            init_timer(State),
            create_elem(State),
            ?INFO("~w 启动完成", [?MODULE]),
            {ok, active, State#state{ts = util:unixtime(), t_cd = CdSec}, CdSec*1000}
    end.

%% Func: handle_event/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

handle_event({local_luck, SrvId, SrvIdList}, active, State = #state{srvs = SL}) ->
    spawn(fun() ->
                LuckIdList = rand_srv_luck(SrvIdList, SL, []),
                case length(LuckIdList) =< 0 of
                    true ->
                        ?DEBUG("许愿墙抽取本服幸运表白异常，列表为空[Srvs:~w]", [SL]),
                        ignore;
                    false ->
                        LuckId = util:rand_list(LuckIdList),
                        case ets:lookup(ets_wish_wall_list, LuckId) of
                            [#wish_cont{type = 2, role_id = RoleId, to_role_id = ToRoleId = {_, ToSrvId}, name = Name, to_name = ToName}] ->
                                ?INFO("许愿墙抽取单服幸运表白[ID:~w WC:~w]", [LuckId, {RoleId, ToRoleId}]),
                                c_mirror_group:cast(node, SrvId, wish_wall, local_luck, [role_id, RoleId, Name, ToRoleId, ToName]),
                                c_mirror_group:cast(node, ToSrvId, wish_wall, local_luck, [to_role_id, RoleId, Name, ToRoleId, ToName]);
                            _ -> ignore
                        end
                end
        end),
    continue(active, State);

%% 重置幸运定时器
handle_event(init_timer, active, State) ->
    init_timer(State),
    ?INFO("重置完成"),
    continue(active, State);
handle_event(init_timer, StateName, State) ->
    ?INFO("重置忽略StateName:~w", [StateName]),
    continue(StateName, State);

%% ---------------------------------------------
%% 手动添加幸运玩家或幸运表白ID
handle_event({gm, {add_pre_luck, List}}, StateName, State) ->
    lists:foreach(fun({_Rid, _SrvId}) ->
                ignore;
            (LuckId) ->
                del_pre_luck(LuckId),
                add_pre_luck(LuckId)
        end, List),
    continue(StateName, State);
handle_event({gm, _}, StateName, State) ->
    ?INFO("无效的GM命令"),
    continue(StateName, State);

%% 测试
handle_event({debug, local_luck}, StateName, State = #state{is_center = ?false}) ->
    %% (节点服匹配执行)
    self() ! local_luck,
    continue(StateName, State);

handle_event({debug, center_luck}, StateName, State = #state{is_center = ?true}) ->
    %% (中央服匹配执行)
    self() ! {center_luck, erlang:trunc(1800 / ?LUCK_CD)},
    continue(StateName, State);

handle_event({debug, state}, StateName, State = #state{next_id = NextId, ids_1 = Ids1, ids_2 = Ids2}) ->
    ?INFO("全服许愿墙状态：~w，共保存 ~w 条", [StateName, NextId-1]),
    ?INFO("全服许愿墙保存许愿 ~w 条", [length(Ids1)]),
    ?INFO("全服许愿墙保存表白 ~w 条", [length(Ids2)]),
    ?INFO("全服许愿墙幸运表白预存：~w", [get(luck_list_ids)]),
    case get(center_luck_timer) of
        undefined -> ignore;
        Ref ->
            ?INFO("全服幸运奖励定时器：~w", [catch erlang:read_timer(Ref)])
    end,
    case get(local_luck_timer) of
        undefined -> ignore;
        LocRef ->
            ?INFO("单服幸运奖励定时器：~w", [catch erlang:read_timer(LocRef)])
    end,
    continue(StateName, State);
handle_event({debug, state2}, StateName, State = #state{next_id = NextId, ids_1 = Ids1, ids_2 = Ids2, srvs = SrvS}) ->
    ?INFO("全服许愿墙共保存 ~w 条", [NextId-1]),
    ?INFO("全服许愿墙保存许愿 ~w", [Ids1]),
    ?INFO("全服许愿墙保存表白 ~w", [Ids2]),
    ?INFO("单服许愿墙保存表白 ~w", [SrvS]),
    continue(StateName, State);

%% ---------------------------------------------

handle_event(_Event, StateName, State) ->
    ?DEBUG("系统许愿树进程在状态~w下收到消息：~w", [StateName, _Event]),
    continue(StateName, State).

%% Func: handle_sync_event/4
%% Returns: {next_state, NextStateName, NextStateData}            |
%%          {next_state, NextStateName, NextStateData, Timeout}   |
%%          {reply, Reply, NextStateName, NextStateData}          |
%%          {reply, Reply, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}                          |
%%          {stop, Reason, Reply, NewStateData}

handle_sync_event({get_wall, RoleId}, _From, active, State = #state{roles = Roles, to_roles = ToRoles, lucks = Lucks}) ->
    IdL1 = case lists:keyfind(RoleId, 1, Roles) of
        false -> [];
        {_, L1} -> L1
    end,
    IdL2 = case lists:keyfind(RoleId, 1, ToRoles) of
        false -> [];
        {_, L2} -> L2
    end,
    continue({ok, {Lucks, IdL1++IdL2}}, active, State);

%% 中央服收集许愿、表白/祝福
handle_sync_event({add_wish_luck, LuckWish}, _From, active, State = #state{is_center = ?true}) ->
    NewState = do_add_wish_luck(LuckWish, State),
    Reply = ok,
    continue(Reply, active, NewState);
handle_sync_event({add_wish, LuckWish}, _From, active, State = #state{is_center = ?true}) ->
    NewState = do_add_wish(LuckWish, State),
    Reply = ok,
    continue(Reply, active, NewState);
handle_sync_event({add_wish, _LuckWish}, _From, StateName, State) ->
    Reply = {false, ?L(<<"现在不是许愿活动时间">>)},
    continue(Reply, StateName, State);

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    continue(Reply, StateName, State).

%% Func: handle_info/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

handle_info(local_luck, active, State = #state{is_center = ?false}) ->
    SrvId = util:to_binary(sys_env:get(srv_id)),
    L = case sys_env:get(srv_ids) of
        undefined -> [];
        [] -> [SrvId];
        SrvIdList -> [util:to_binary(SrvStr) || SrvStr <- SrvIdList]
    end,
    ?DEBUG("SrvId:~w, L:~w", [SrvId, L]),
    center:cast(wish_wall, info, [{local_luck, SrvId, L}]),
    init_timer(State),
    continue(active, State);

handle_info({center_luck, 0}, StateName, State) ->
    init_timer(State),
    continue(StateName, State);
handle_info({center_luck, Circle}, active, State = #state{is_center = ?true, ids_2 = Ids2, lucks = Lucks}) ->
    put(center_luck_timer, erlang:send_after(?LUCK_CD * 1000, self(), {center_luck, Circle - 1})),
    NewState = case Ids2 =:= [] of
        true -> State;
        false ->
            PreLuck = case get(luck_list_ids) of
                L when is_list(L) -> L;
                _ -> []
            end,
            case rand_luck(PreLuck, util:unixtime(today), 20) of
                WC = #wish_cont{id = Id, type = 2} ->
                    del_pre_luck(Id),
                    ?INFO("许愿墙抽取全服幸运表白：~w", [WC]),
                    center_luck(WC),
                    State#state{lucks = [WC | Lucks]};
                _ ->
                    %% 预留20次随机，抽取今日的
                    case rand_luck(Ids2, util:unixtime(today), 20) of
                        WC = #wish_cont{type = 2} ->
                            ?INFO("许愿墙抽取全服幸运表白：~w", [WC]),
                            center_luck(WC),
                            State#state{lucks = [WC | Lucks]};
                        _ -> State
                    end
            end
    end,
    continue(active, NewState);
handle_info(center_luck, StateName, State) ->
    continue(StateName, State);

handle_info(save_cache, active, State) ->
    erlang:send_after(3600 * 1000, self(), save_cache), %% 定时缓存数据，预防强制关机
    save_cache(State),
    continue(active, State);

handle_info(clean_cache, _, State) ->
    Now = util:unixtime(),
    CdTomorrow = 20 + util:unixtime({tomorrow, Now}) - Now,
    erlang:send_after(CdTomorrow*1000, self(), clean_cache), %% 清一次过期数据
    NewState = clean_cache(State),
    continue(active, NewState);

handle_info(_Info, StateName, State) ->
    ?DEBUG("许愿进程[CENTER:~w]受到异常消息:~w", [State#state.is_center, _Info]),
    continue(StateName, State).

%% Func: terminate/3
%% Purpose: Shutdown the server
%% Result: any
terminate(_Reason, active, State = #state{is_center = ?true}) ->
    ?INFO("活动中关机，中央服保存缓存"),
    save_cache(State),
    ok;
terminate(_Reason, _StateName, State = #state{is_center = ?true}) ->
    ?INFO("许愿树进程结束[StateName:~w, Reason: ~w, StateDta:~w]", [_StateName, _Reason, State#state.next_id]),
    clean_data(State),
    ok;
terminate(_Reason, _StateName, _State) ->
    ?INFO("许愿树进程结束[StateName:~w, Reason: ~w]", [_StateName, _Reason]),
    ok.

%% Func: code_change/4
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState, NewStateData}
code_change(_OldVsn, StateName, StateData, _Extra) ->
    {ok, StateName, StateData}.


%% ---------------------------------------------------
%% StateName Function
%% ---------------------------------------------------

%% Func: StateName/2
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

%% 空闲状态
idel(timeout, State) ->
    case get_next_act_sec() of
        {idel, CdSec} ->
            ?INFO("许愿树进程活动开始异常CdSec:~w, StateId:~w", [CdSec, {State#state.next_id, State#state.is_center}]),
            continue(idel, State#state{ts = util:unixtime(), t_cd = CdSec});
        {active, CdSec} ->
            ?INFO("许愿树进程活动开始CDSec:~w, StateId~w", [CdSec, {State#state.next_id, State#state.is_center}]),
            erlang:send_after(3600 * 1000, self(), save_cache), %% 定时缓存数据，预防强制关机
            init_timer(State), %% 初始化定时器
            create_elem(State),
            continue(active, State#state{ts = util:unixtime(), t_cd = CdSec})
    end;
idel(debug_timeout, State) ->
    CdSec = ?DEBUG_CD,
    ?INFO("【测试】许愿树进程活动开始CDSec:~w, StateId~w", [CdSec, {State#state.next_id, State#state.is_center}]),
    erlang:send_after(3600 * 1000, self(), save_cache), %% 定时缓存数据，预防强制关机
    init_timer(State),
    create_elem(State),
    continue(active, State#state{ts = util:unixtime(), t_cd = CdSec});
idel(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [state_idel, _Event]),
    continue(idel, State).

%% 活动状态
active(timeout, State) ->
    ?INFO("许愿树进程活动结束"),
    del_timer(),
    clean_pre_luck(),
    remove_elem(State),
    NewState = clean_data(State),
    {NextStateName, CdSec} = get_next_act_sec(),
    continue(NextStateName, NewState#state{ts = util:unixtime(), t_cd = CdSec});
active(debug_timeout, State) ->
    ?DEBUG("许愿树进程活动结束"),
    del_timer(),
    clean_pre_luck(),
    remove_elem(State),
    NewState = clean_data(State),
    {NextStateName, CdSec} = get_next_act_sec(),
    continue(NextStateName, NewState#state{ts = util:unixtime(), t_cd = CdSec});
active(_Event, State) ->
    ?INFO("~w 状态下收到消息 ~w", [state_active, _Event]),
    continue(active, State).

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------

%%% 同步调用
%call(Msg) ->
%    gen_fsm:sync_send_all_state_event(?MODULE, Msg).
%
%%% 异步事件调用
%info_state(Msg) ->
%    gen_fsm:send_event(?MODULE, Msg).

%% 同步单状态调用
%call_state(Msg) ->
%    gen_fsm:sync_send_event(?MODULE, Msg).

%% 状态机的持续执行
continue(StateName, State = #state{ts = Ts, t_cd = Tcd}) ->
    Now = util:unixtime(),
    Timeout = case Ts + Tcd - Now of
        T1 when T1 > 0 ->
            T1 * 1000;
        _ ->
            100
    end,
    {next_state, StateName, State, Timeout}.
continue(Reply, StateName, State = #state{ts = Ts, t_cd = Tcd}) ->
    Now = util:unixtime(),
    Timeout = case Ts + Tcd - Now of
        T1 when T1 > 0 ->
            T1 * 1000;
        _ ->
            1
    end,
    {reply, Reply, StateName, State, Timeout}.

%% ----------------------------------------------------------
%% private functions
%% ----------------------------------------------------------

%% 移除定时器
del_timer() ->
    case get(local_luck_timer) of
        undefined -> ok;
        Ref ->
            erlang:cancel_timer(Ref),
            put(local_luck_timer, undefined)
    end,
    case get(center_luck_timer) of
        undefined -> ok;
        CenRef ->
            erlang:cancel_timer(CenRef),
            put(center_luck_timer, undefined)
    end.

%% 随机单服抽取幸运表白
rand_srv_luck([], _SL, Back) -> Back;
rand_srv_luck([SrvId | T], SL, Back) ->
    case lists:keyfind(SrvId, 1, SL) of
        {_, IdList} when is_list(IdList) ->
            rand_srv_luck(T, SL, IdList ++ Back);
        _ ->
            rand_srv_luck(T, SL, Back)
    end.

%% 在许愿列表中抽取今日幸运项
rand_luck([], _Today, _N) -> false;
rand_luck(Ids2, _Today, 0) ->
    LuckId = util:rand_list(Ids2),
    case ets:lookup(ets_wish_wall_list, LuckId) of
        [WC = #wish_cont{type = 2}] -> WC;
        _ -> false
    end;
rand_luck(Ids2, Today, N) ->
    LuckId = util:rand_list(Ids2),
    case ets:lookup(ets_wish_wall_list, LuckId) of
        [WC = #wish_cont{type = 2, ctime = Ctime}] when Ctime >= Today -> WC;
        _ -> rand_luck(Ids2, Today, N - 1)
    end.

%% 随机N条不重复列表
%% 此处考虑到不能重复，采用特殊方法处理，有待验证算法的效率
%% 方法二：采用M/N分段随机
do_get_wall_page(0, _Max, Back) ->
    Back;
do_get_wall_page(N, Max, _Back) when N >= Max ->
    ets:tab2list(ets_wish_wall_list);
do_get_wall_page(N, Max, _Back) when Max < (N * 20) ->
    %% TODO: 避免随机重复，造成大循环
    L = lists:seq(1, Max),
    rand_list(N, L, []);
do_get_wall_page(N, Max, Back) ->
    RandId = util:rand(1, Max),
    case ets:lookup(ets_wish_wall_list, RandId) of
        [WC = #wish_cont{id = Id}] ->
            case is_in_list(Id, Back) of
                true -> %% 此处假定在“较大范围内随机N条有重复”是小概率
                    do_get_wall_page(N - 1, Max, Back); %% TODO:避免极端情况（无限循环），直接忽略
                false ->
                    do_get_wall_page(N - 1, Max, [WC | Back])
            end;
        _ -> do_get_wall_page(N - 1, Max, Back)
    end.

%% 在列表中随机不重复的N条
rand_list(_, [], Back) -> Back;
rand_list(0, _L, Back) -> Back;
rand_list(N, L, Back) ->
    RandId = util:rand_list(L),
    NewBack = case ets:lookup(ets_wish_wall_list, RandId) of
        [WC] -> [WC | Back];
        _ -> Back
    end,
    rand_list(N - 1, L -- [RandId], NewBack).

%% 是否在列表中
is_in_list(Id, WallList) ->
    case lists:keyfind(Id, #wish_cont.id, WallList) of
        false -> false;
        _ -> true
    end.

%% 更新列表
update_list({Key, Val}, L) ->
    case lists:keyfind(Key, 1, L) of
        false ->
            [{Key, [Val]} | L];
        {_, OldVal} when is_list(OldVal) ->
            lists:keyreplace(Key, 1, L, {Key, [Val | OldVal]});
        _ ->
            lists:keyreplace(Key, 1, L, {Key, [Val]})
    end.

%% TODO:进程字典操作
%% 增加Id至幸运列表，供抽取
add_pre_luck(Id) ->
    case get(luck_list_ids) of
        undefined ->
            put(luck_list_ids, [Id]);
        L when is_list(L) ->
            put(luck_list_ids, [Id | L]);
        _ ->
            put(luck_list_ids, [Id])
    end.
%% 删除
del_pre_luck(Id) ->
    case get(luck_list_ids) of
        L when is_list(L) ->
            put(luck_list_ids, lists:delete(Id, L));
        _ ->
            skip
    end.
%% 清空
clean_pre_luck() ->
    put(luck_list_ids, []).

do_add_wish_luck(WC = #wish_cont{type = Type, role_id = {Rid, SrvId}, to_role_id = {ToRid, ToSrvId}}, 
    State = #state{roles = Roles, to_roles = ToRoles, srvs = Srvs, ids_1 = Ids1, ids_2 = Ids2, next_id = NextId}) ->
    ets:insert(ets_wish_wall_list, WC#wish_cont{id = NextId, ctime = util:unixtime()}),
    case Type of
        1 -> %% 许愿
            State#state{
                next_id = NextId + 1,
                roles = update_list({{Rid, SrvId}, NextId}, Roles),
                to_roles = update_list({{ToRid, ToSrvId}, NextId}, ToRoles),
                ids_1 = [NextId | Ids1]
            };
        2 -> %% 表白&祝福
            add_pre_luck(NextId),
            State#state{
                next_id = NextId + 1,
                roles = update_list({{Rid, SrvId}, NextId}, Roles),
                to_roles = update_list({{ToRid, ToSrvId}, NextId}, ToRoles),
                srvs = update_list({SrvId, NextId}, Srvs),
                ids_2 = [NextId | Ids2]
            };
        _ -> State#state{next_id = NextId + 1}
    end.
do_add_wish(WC = #wish_cont{type = Type, role_id = {Rid, SrvId}, to_role_id = {ToRid, ToSrvId}}, 
    State = #state{roles = Roles, to_roles = ToRoles, srvs = Srvs, ids_1 = Ids1, ids_2 = Ids2, next_id = NextId}) ->
    ets:insert(ets_wish_wall_list, WC#wish_cont{id = NextId, ctime = util:unixtime()}),
    case Type of
        1 -> %% 许愿
            State#state{
                next_id = NextId + 1,
                roles = update_list({{Rid, SrvId}, NextId}, Roles),
                to_roles = update_list({{ToRid, ToSrvId}, NextId}, ToRoles),
                ids_1 = [NextId | Ids1]
            };
        2 -> %% 表白&祝福
            State#state{
                next_id = NextId + 1,
                roles = update_list({{Rid, SrvId}, NextId}, Roles),
                to_roles = update_list({{ToRid, ToSrvId}, NextId}, ToRoles),
                srvs = update_list({SrvId, NextId}, Srvs),
                ids_2 = [NextId | Ids2]
            };
        _ -> State#state{next_id = NextId + 1}
    end.

%% 显示元素
create_elem(#state{is_center = ?false}) ->
    case map_data_elem:get(60450) of
        Elem = #map_elem{} ->
            map:elem_enter(10003, Elem#map_elem{id = 60450, x = 5175, y = 2911});
        _ -> ?ERR("许愿墙创建失败")
    end;
create_elem(_) -> ok.

%% 移出元素
remove_elem(#state{is_center = ?false}) ->
    map:elem_leave(10003, 60450);
remove_elem(_) -> ok.
