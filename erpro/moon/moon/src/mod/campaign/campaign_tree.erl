%%----------------------------------------------------
%% 散财树浇水互动活动
%% 
%% @author jackguan@jieyou.cn
%% @end
%%----------------------------------------------------
-module(campaign_tree).

-behaviour(gen_server).

-export([start_link/0
        ,seed/2
        ,watering/2
        ,get_tree_info/2
        ,invite/4
        ,invite_all/2
        ,invite_all/5
        ,info/0
    ]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {trees = [], roles = [], used_elem_id = []}).

%% 角色结构
-record(role_data, {
        role_id
        ,watering = 0 %% 当前已浇水次数
        ,last_water = 0 %% 上次浇水时间
        ,maxwater = 15 %% 最大可浇水次数
    }).

%% 树的结构
-record(tree_info, {
        elem_id %% 元素id
        ,elem_base_id %% 元素base_id
        ,role_id %% 树主人
        ,name = <<>> %% 树主人名
        ,pos %% 地点
        ,waters = [] %% 浇水者列表{<<name>>, time}
        ,watering = 0 %% 当前已浇水次数
        ,maxwater = 10 %% 最大可浇水次数
        ,type = 0  %% 0:初级 1:中级 2:高级
        ,start_time = 0 %% 种下时间
        ,end_time = 0 %% 消失时间
    }).

%% include files
-include("common.hrl").
-include("item.hrl").
-include("role.hrl").
-include("pos.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("map.hrl").
-include("sns.hrl").

-ifdef(debug).
%% 活动开始时间
-define(begin_time, util:datetime_to_seconds({{2013, 02, 25}, {0, 0, 1}})).
-else.
%% 活动开始时间
-define(begin_time, util:datetime_to_seconds({{2013, 03, 20}, {0, 0, 1}})).
-endif.

%% 活动结束时间
-define(end_time, util:datetime_to_seconds({{2013, 04, 24}, {23, 59, 59}})).

-define(start_elem_id, 80001).
-define(time_off, 3 * 60). %% 浇水冷却时间 3 * 60
-define(grow_time, 3 * 3600). %% 树成长消失时间 3 * 3600
-define(tree_check, 4). %% 5 秒检测一遍
-define(low_exp, 20000). %% 低级散财树经验
-define(mid_exp, 30000). %% 中级散财树经验
-define(high_exp, 50000). %% 高级散财树经验

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @spec seed(Role, Item) -> {ok, Type} | {false, Reason}
%% @doc
%% <pre>
%% Role = NewRole = #role{} 角色信息
%% Item = #item{} 物品信息
%% Type = integer() 树类型
%% Reason = binary() 失败原因
%% 播种
%% </pre>
seed(Role = #role{id = Rid, name = Name, pos = #pos{map = MapId, x = X, y = Y}, link = #link{conn_pid = ConnPid}}, Item = #item{id = ItemId}) ->
    case is_valid_time() of
        false -> {false, ?L(<<"活动已结束，欢迎下次参加">>)};
        true ->
            case role_gain:do([#loss{label = item_id, val = [{ItemId, 1}]}], Role) of
                {ok, NewRole} ->
                    case ?CALL(?MODULE, {seed, Item, Rid, Name, MapId, X, Y}) of
                        {ok, RType, ElemId} -> 
                            {ok, TreeData} = get_tree_info(ElemId, Role),
                            sys_conn:pack_send(ConnPid, 15868, TreeData),
                            sys_conn:pack_send(ConnPid, 15871, {ElemId}),
                            send_seed_notice(Rid, Name, RType),
                            send_exp_reward(RType, NewRole);
                        {false, R} -> {false, R};
                        _ -> {false, ?L(<<"请稍后操作">>)}
                    end;
                _ -> {false, ?L(<<"请稍后再尝试">>)}
            end
    end.

%% @spec watering(Role, ElemId) -> {ok, Type} | {false, Reason}
%% @doc
%% <pre>
%% Role = #role{} 角色信息
%% ElemId = integer() 元素ID
%% Type = integer() 树类型
%% Reason = binary() 失败原因
%% 浇水
%% </pre>
watering(Role = #role{id = Rid, pid = Pid, name = Name, link = #link{conn_pid = ConnPid}}, ElemId) ->
    case gen_server:call(?MODULE, {watering, Rid, Name, ConnPid, ElemId}) of
        {ok, Type} ->
            GL = case Type of
                0 -> [#gain{label = item, val = [29536, 1, 1]}];
                1 -> [#gain{label = item, val = [29537, 1, 1]}];
                2 -> [#gain{label = item, val = [29538, 1, 1]}];
                _ -> [#gain{label = item, val = []}]
            end,
            case role_gain:do(GL, Role) of
                {ok, NewRole} ->
                    Str = notice:gain_to_item3_inform(GL),
                    notice:inform(Pid, util:fbin(?L(<<"获得~s">>), [Str])),
                    {ok, NewRole};
                _ -> {false, ?L(<<"背包已满">>)}
            end;
        {false, Reason} -> {false, Reason}
    end.

%% @spec get_tree_info(ElemId, Role) -> {ok, TreeData} | {false, Reason}
%% @doc
%% <pre>
%% Role = #role{} 角色信息
%% ElemId = integer() 元素ID
%% TreeData = tuple{} 树消息
%% Reason = binary() 失败原因
%% 获取散财树相关信息
%% </pre>
get_tree_info(ElemId, Role) ->
    gen_server:call(?MODULE, {tree_data, ElemId, Role}).

%% @spec invite(IRid, ISrvId, ElemId, IName) -> {ok} | {false, Reason}
%% @doc
%% <pre>
%% IRid = integer() 被邀请者角色Id
%% ISrvId = binary() SrvId
%% ElemId = integer() 元素ID
%% Name = binary() 邀请者角色名
%% Reason = binary() 失败原因
%% 浇水邀请
%% </pre>
invite(IRid, ISrvId, ElemId, IName) ->
    case role_api:lookup(by_id, {IRid, ISrvId}, #role.link) of
        {ok, _Node, #link{conn_pid = ConnPid}} ->
            gen_server:call(?MODULE, {invite, ElemId, IName, ConnPid});
        _Err -> 
            {false, ?L(<<"你邀请的好友不在线，请稍后再试">>)}
    end.

%% 浇水全部邀请
invite_all(ElemId, IName) ->
    case gen_server:call(?MODULE, {invite_all, ElemId}) of
        {false, Reason} ->
            {false, Reason};
        {TMapId, TX, TY} ->
            Friends = friend:get_friend_list(),
            lists:foreach(fun(#friend{type = Type, role_id = Rid, srv_id = SrvID, online = Online}) -> 
                case Type =:= 0 andalso Online =:= 1 of
                    true ->
                        case global:whereis_name({role, Rid, SrvID}) of
                            Pid when is_pid(Pid) ->
                                catch role:apply(async, Pid, {campaign_tree, invite_all, [IName, TMapId, TX, TY]});
                            _ ->
                                ok
                        end;
                    false ->
                        ok
                end
            end, Friends)
    end.
%%全部邀请浇水的回调函数    
invite_all(#role{link = #link{conn_pid = ConnPid}}, IName, TMapId, TX, TY) ->
    sys_conn:pack_send(ConnPid, 15870, {IName, TMapId, TX, TY}),
    {ok}.




%% 打印进程信息
info() ->
    gen_server:call(?MODULE, {info}).

%% -------------------------------------
%% gen_server callback functions
%% -------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    self() ! tree_check,
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% 种植
handle_call({seed, Item, Rid, Name, MapId, X, Y}, _From, State = #state{trees = Trees, used_elem_id = UsedIds, roles = Roles}) ->
    case lists:keyfind({MapId, X, Y}, #tree_info.pos, Trees) of
        #tree_info{} ->
            {reply, {false, ?L(<<"此处有人在种植，请再等会!">>)}, State};
        _ ->
            case is_valid_pos(Trees, {X, Y}) of %% 检测位置有效性
                true ->
                    ElemId = get_valid_elem_id(UsedIds),
                    ElemBaseId = item_to_elem(Item),
                    Type = item_to_type(Item),
                    StartTime = util:unixtime(),
                    EndTime = StartTime + ?grow_time,
                    Tree = #tree_info{pos = {MapId, X, Y}, role_id = Rid, name = Name, type = Type, start_time = StartTime, end_time = EndTime, elem_id = ElemId, elem_base_id = ElemBaseId},
                    PlantTree = map_data_elem:get(ElemBaseId),
                    seed_tree(Tree, PlantTree, Name), %% 种子进入场景
                    case lists:keyfind(Rid, #role_data.role_id, Roles) of
                        false ->
                            Role = #role_data{role_id = Rid},
                            {reply, {ok, Type, ElemId}, State#state{trees = [Tree | Trees], used_elem_id = [ElemId | UsedIds], roles = [Role | Roles]}};
                        _ ->
                            {reply, {ok, Type, ElemId}, State#state{trees = [Tree | Trees], used_elem_id = [ElemId | UsedIds]}}
                    end;
                false -> {reply, {false, ?L(<<"该地有人在此种植，请换个地方试试吧!">>)}, State}
            end
    end;

%% 浇水
handle_call({watering, Rid, Name, ConnPid, ElemId}, _From, State = #state{trees = Trees, used_elem_id = UseElemId}) ->
    R1 = check_tree_owner(ElemId, State, Rid), %% 检查树归属者
    R2 = check_tree_time(ElemId, State), %% 检查树是否已成长
    R3 = check_tree_water(ElemId, State), %% 检查树是否已浇满水
    R4 = check_same_day(Rid, State), %% 检查是否同一天
    R5 = check_role_water(Rid, State), %% 检查角色浇水次数是否用完
    R6 = check_role_water_timeout(Rid, State), %% 检查角色浇水是否冷却

    case lists:keyfind(ElemId, #tree_info.elem_id, Trees) of
        false ->
            {reply, {false, ?L(<<"该树不存在，请换个目标吧">>)}, State};
        TreeInfo ->
            case {R1, R2, R3, R4, R5, R6} of
                {true, _, _, _, _, _} -> {reply, {false, ?L(<<"不可以对自己的树浇水">>)}, State};
                {_, true, _, _, _, _} ->
                    NewTrees = lists:keydelete(ElemId, #tree_info.elem_id, Trees),
                    NewUsedElemId = UseElemId -- [ElemId],
                    clear_tree(ElemId, State), %% 删除元素
                    NewState = State#state{trees = NewTrees, used_elem_id = NewUsedElemId},
                    {reply, {false, ?L(<<"散财树生长时间已过，不能浇水">>)}, NewState};
                {_, _, true, _, _, _} -> {reply, {false, ?L(<<"该散财树浇水次数已满，换个目标吧">>)}, State};
                {_, _, _, true, true, _} -> {reply, {false, ?L(<<"您的浇水次数已用完，请明天再继续吧！">>)}, State};
                {_, _, _, true, _, false} -> %% 同天
                    {reply, {false, ?L(<<"您的浇水时间尚未冷却，请稍后再试">>)}, State};
                {_, _, _, false, _, false} -> %% 不同天
                    {reply, {false, ?L(<<"您的浇水时间尚未冷却，请稍后再试">>)}, State};
                {false, false, false, true, false, true} -> %% 是同一天 浇水处理
                    {TreeType, NewState} = do_watering(today, ConnPid, ElemId, Rid, Name, TreeInfo, State),
                    {reply, {ok, TreeType}, NewState};
                %% {false, false, false, false, false, true} -> %% 不是同一 浇水处理
                {false, false, false, false, _, true} -> %% 不是同一 浇水处理
                    {TreeType, NewState} = do_watering(notday, ConnPid, ElemId, Rid, Name, TreeInfo, State),
                    {reply, {ok, TreeType}, NewState};
                {_, _, _, _, _, _} ->
                    ?ERR("###### 散财树浇水错误 ######:~w", [{R1, R2, R3, R4, R5, R6}]),
                    {reply, {false, ?L(<<"散财树浇水失败">>)}, State}
            end
    end;

%% 获取散财树相关信息
handle_call({tree_data, ElemId, _Role = #role{id = Rid}}, _From, State = #state{trees = Trees, roles = Roles}) ->
    case lists:keyfind(ElemId, #tree_info.elem_id, Trees) of
        false -> {reply, {false, {0,0,0,0,0,[],<<>>,0,0,0}}, State};
        #tree_info{type = Type, end_time = EndTime, watering = WatTime, maxwater = MaxWater, waters = WterS, name = TName} ->
            Now = util:unixtime(),
            Owner = case check_tree_owner(ElemId, State, Rid) of
                true -> 1;
                false -> 0
            end,
            LeaveTime = case (EndTime - Now) of
                LeaveT when LeaveT > 0 -> LeaveT;
                _ -> 0
            end, 
            TreeData = case lists:keyfind(Rid, #role_data.role_id, Roles) of
                false -> {Owner, Type, LeaveTime, WatTime, MaxWater, WterS, TName, 0, 15, 0};
                #role_data{watering = RWatTime, last_water = RLastWat, maxwater = RMaxWat} ->
                    WatTimeout = case (Now - RLastWat) of
                        WT when WT >= ?time_off -> 0;
                        WS -> (?time_off - WS)
                    end,
                    case check_same_day(Rid, State) of
                        true -> {Owner, Type, LeaveTime, WatTime, MaxWater, WterS, TName, RWatTime, RMaxWat, WatTimeout};
                        false -> {Owner, Type, LeaveTime, WatTime, MaxWater, WterS, TName, 0, RMaxWat, WatTimeout}
                    end
            end,
            {reply, {ok, TreeData}, State}
    end;

%% 浇水邀请
handle_call({invite, ElemId, IName, ConnPid}, _From, State = #state{trees = Trees}) ->
    case lists:keyfind(ElemId, #tree_info.elem_id, Trees) of
        false -> {reply, {false, ?L(<<"该树不存在，请稍后再试">>)}, State};
        #tree_info{pos = {TMapId, TX, TY}} ->
            sys_conn:pack_send(ConnPid, 15870, {IName, TMapId, TX, TY}),
            {reply, {ok}, State}
    end;

%% 浇水全部邀请
handle_call({invite_all, ElemId}, _From, State = #state{trees = Trees}) ->
    case lists:keyfind(ElemId, #tree_info.elem_id, Trees) of
        false -> {reply, {false, ?L(<<"该树不存在，请稍后再试">>)}, State};
        #tree_info{pos = {TMapId, TX, TY}} ->
            {reply, {TMapId, TX, TY}, State}
    end;

%% 打印进程信息
handle_call({info}, _From, State) ->
    {reply, State, State};

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 检查树是否成长
handle_info(tree_check, State = #state{trees = Trees}) ->
    erlang:send_after(?tree_check * 1000, self(), tree_check),
    NewTrees = clear_old_tree(Trees),
    {noreply, State#state{trees = NewTrees}};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, #state{trees = Trees}) ->
    clear_all_tree(Trees),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% 内部处理函数 
%%----------------------------------------------------
%% 检查时间有效性
is_valid_time() ->
    Now = util:unixtime(),
    (Now >= ?begin_time andalso Now =< ?end_time) orelse campaign_adm:is_camp_time(camp_tree).

%% 获取地图元素id
get_valid_elem_id(UsedIds) ->
    do_get_valid_elem_id(UsedIds, ?start_elem_id).
do_get_valid_elem_id(UsedIds, Id) ->
    case lists:member(Id, UsedIds) of
        true ->
            do_get_valid_elem_id(UsedIds, Id + 1);
        false ->
            Id
    end.

%% 转换
item_to_elem(#item{base_id = 33227}) -> 60528;
item_to_elem(#item{base_id = 33228}) -> 60529;
item_to_elem(#item{base_id = 33229}) -> 60530;
item_to_elem(_) -> 60528.

item_to_type(#item{base_id = BaseId}) ->
    case BaseId of
        33227 -> 0;
        33228 -> 1;
        33229 -> 2;
        _ -> 0
    end.

%% 创建一棵树
seed_tree(#tree_info{pos = {MapId, X, Y}, elem_id = ElemId, elem_base_id = ElemBaseId}, PlantTree, Name) ->
    map:elem_enter(MapId, PlantTree#map_elem{id = ElemId, x = X, y = Y, name = util:fbin(get_tree_name(ElemBaseId), [Name])}).

%% 名称转换
get_tree_name(60528) -> ?L(<<"~s 的低级散财树">>);
get_tree_name(60529) -> ?L(<<"~s 的中级散财树">>);
get_tree_name(60530) -> ?L(<<"~s 的高级散财树">>);
get_tree_name(_) -> ?L(<<"~s 的散财树">>).

%% 检查树归属者
%% return true | false
check_tree_owner(ElemId, #state{trees = Trees}, Rid) ->
    case lists:keyfind(ElemId, #tree_info.elem_id, Trees) of
        #tree_info{role_id = RoleId} when RoleId =:= Rid -> true;
        _ -> false
    end.

%% 检查树的生长时间是否已过
%% return true | false
check_tree_time(ElemId, #state{trees = Trees}) ->
    Now = util:unixtime(),
    case lists:keyfind(ElemId, #tree_info.elem_id, Trees) of
        #tree_info{end_time = EndTime} when Now >= EndTime ->
            true;
        _ -> false
    end.

%% 检查树是否已达最大浇水次数
%% return true | false
check_tree_water(ElemId, #state{trees = Trees}) ->
    case lists:keyfind(ElemId, #tree_info.elem_id, Trees) of
        #tree_info{watering = Water, maxwater = MaxWater} when Water >= MaxWater ->
            true;
        _ -> false
    end.

%% 检查角色是否已达最大浇水次数
%% return true | false
check_role_water(Rid, #state{roles = Roles}) ->
    case lists:keyfind(Rid, #role_data.role_id, Roles) of
        #role_data{watering = Water, maxwater = MaxWater} when Water >= MaxWater ->
            true;
        _ -> false
    end.

%% 检查角色浇水冷却时间
%% return true | false
check_role_water_timeout(Rid, #state{roles = Roles}) ->
    Now = util:unixtime(),
    case lists:keyfind(Rid, #role_data.role_id, Roles) of
        #role_data{last_water = LastWater} when (Now - LastWater) >= ?time_off ->
            true;
        #role_data{last_water = LastWater} when (Now - LastWater) < ?time_off ->
            false;
        _ -> true
    end.

%% 清除树
clear_tree(ElemId, #state{trees = Trees}) ->
    case lists:keyfind(ElemId, #tree_info.elem_id, Trees) of
        #tree_info{pos = {MapId, _X, _Y}} ->
            map:elem_leave(MapId, ElemId);
        _ -> ignore
    end.

%% 清除已经成长的树
clear_old_tree(Trees) ->
    clear_old_tree(Trees, []).
clear_old_tree([], NewTrees) ->
    NewTrees;
clear_old_tree([Tree = #tree_info{elem_id = ElemId, pos = {MapId, _X, _Y}, role_id = Rid, maxwater = MaxWat, end_time = ETime, watering = NowWater} | T], NewTrees) ->
    Now = util:unixtime(),
    case (Now >= ETime) of
        true ->
            case NowWater of
                NW when NW >= MaxWat -> 
                    map:elem_leave(MapId, ElemId),
                    clear_old_tree(T, NewTrees);
                _ ->
                    map:elem_leave(MapId, ElemId),
                    Sub = ?L(<<"散财仙树献珍宝">>),
                    Content = ?L(<<"亲爱的仙友，很遗憾您的散财树在三小时之内未得到足够的浇灌而财气消散，您未能获得收成奖励！请记得下次点击自己的散财树邀请好友帮忙浇水哦！">>),
                    mail_mgr:deliver(Rid, {Sub, Content, [], []}),
                    clear_old_tree(T, NewTrees)
            end;
        false ->
            clear_old_tree(T, [Tree | NewTrees])
    end.

%% 清除所有树
clear_all_tree([]) -> [];
clear_all_tree([#tree_info{pos = {MapId, _X, _Y}, elem_id = ElemId} | T]) ->
    map:elem_leave(MapId, ElemId),
    clear_all_tree(T).

%% 检查是否同一天浇水
%% return true |  false
check_same_day(Rid, #state{roles = Roles}) ->
    Now = util:unixtime(),
    case lists:keyfind(Rid, #role_data.role_id, Roles) of
        #role_data{last_water = LastWater} ->
            util:is_same_day2(Now, LastWater);
        _ -> false
    end.

%% 获取不同类型树收成的奖励邮件物品
get_mail_type_item(Type) ->
    case Type of
        0 -> [{29539, 1, 1}];
        1 -> [{29540, 1, 1}];
        2 -> [{29541, 1, 1}];
        _ -> []
    end.

%% 发送奖励邮件物品
send_mail(Rid, Items) ->
    Sub = ?L(<<"散财仙树献珍宝">>),
    Content = ?L(<<"亲爱的仙友，散财仙树献珍宝活动中，您的散财树因受到众多仙友的热情浇灌而财气满满，您获得了以下丰厚收成奖励！请注意查收！">>),
    mail_mgr:deliver(Rid, {Sub, Content, [], Items}).

%% 发送经验奖励
send_exp_reward(RType, Role) ->
    case RType of
        0 ->
            case role_gain:do([#gain{label = exp, val = ?low_exp}], Role) of
                {ok, NewRole} -> {ok, NewRole};
                {false, _} -> {ok, Role}
            end;
        1 ->
            case role_gain:do([#gain{label = exp, val = ?mid_exp}], Role) of
                {ok, NewRole} -> {ok, NewRole};
                {false, _} -> {ok, Role}
            end;
        2 ->
            case role_gain:do([#gain{label = exp, val = ?high_exp}], Role) of
                {ok, NewRole} -> {ok, NewRole};
                {false, _} -> {ok, Role}
            end;
        _ -> {ok, Role}
    end.

%% 发送种树通知
send_seed_notice({Rid, SrvId}, Name, Type) ->
    case Type of
        0 ->
            notice:send(52, util:fbin(?L(<<"~s在洛水城种下了~s，赶紧前往浇水祝福助其早日收获吧，还能获得额外惊喜奖励！">>), [notice:role_to_msg({Rid, SrvId, Name}), notice:item_to_msg([{33227, 1, 1}])]));
        1 ->
            notice:send(52, util:fbin(?L(<<"~s在洛水城种下了~s，赶紧前往浇水祝福助其早日收获吧，还能获得额外惊喜奖励！">>), [notice:role_to_msg({Rid, SrvId, Name}), notice:item_to_msg([{33228, 1, 1}])]));
        2 ->
            notice:send(52, util:fbin(?L(<<"~s在洛水城种下了~s，赶紧前往浇水祝福助其早日收获吧，还能获得额外惊喜奖励！">>), [notice:role_to_msg({Rid, SrvId, Name}), notice:item_to_msg([{33229, 1, 1}])]));
        _ -> ignore
    end.

%% 浇水
do_watering(IsSameDay, ConnPid, WatElemId, WatRid, WatRName, TreeInfo = #tree_info{role_id = OwnerRid = {Rid, SrvId}, waters = Waters, watering = Watering, type = Type, name = TName}, State = #state{trees = Trees, roles = Roles}) ->
    Now = util:unixtime(),
    NewWaters = [{WatRName, Now} | Waters],
    NewWatering = Watering + 1,
    if
        NewWatering >= 10 ->
            MailItem = get_mail_type_item(Type),
            send_mail(OwnerRid, MailItem),
            case Type of
                2 ->
                    notice:send(53, util:fbin(?L(<<"~s的高级散财树在仙友们的浇灌下财气冲天，并获得了~s！">>), [notice:role_to_msg({Rid, SrvId, TName}), notice:item_to_msg([{29541, 1, 1}])]));
                1 ->
                    notice:send(53, util:fbin(?L(<<"~s的中级散财树在仙友们的浇灌下财气冲天，并获得了~s！">>), [notice:role_to_msg({Rid, SrvId, TName}), notice:item_to_msg([{29540, 1, 1}])]));
                _ -> ignore
            end;
        true -> ignore
    end,
    NewTree = TreeInfo#tree_info{waters = NewWaters, watering = NewWatering},
    NewTrees = lists:keyreplace(WatElemId, #tree_info.elem_id, Trees, NewTree),
    case lists:keyfind(WatRid, #role_data.role_id, Roles) of
        false ->
            NewTRole = #role_data{role_id = WatRid, watering = 1, last_water = Now},
            NewState = State#state{trees = NewTrees, roles = [NewTRole | Roles]},
            TreeData = push_tree_info(Now, WatElemId, WatRid, NewTree, NewTRole, NewState),
            sys_conn:pack_send(ConnPid, 15868, TreeData),
            {Type, NewState};
        TRoleData = #role_data{watering = WaterTime} ->
            NewTRole = case IsSameDay of
                today -> 
                    case WaterTime > 15 of
                        true -> ?ERR("散财树数据异常:~s", [WatRName]);
                        _ -> ignore
                    end,
                    TRoleData#role_data{watering = WaterTime + 1, last_water = Now};
                _ -> TRoleData#role_data{watering = 1, last_water = Now}
            end,
            NewState = State#state{trees = NewTrees, roles = lists:keyreplace(WatRid, #role_data.role_id, Roles, NewTRole)},
            TreeData = push_tree_info(Now, WatElemId, WatRid, NewTree, NewTRole, NewState),
            sys_conn:pack_send(ConnPid, 15868, TreeData),
            {Type, NewState}
    end.

%% 检测是否有效位置
%% return true | false
is_valid_pos([], {_, _}) -> true;
is_valid_pos([#tree_info{pos = {_TMap, TX, TY}} | T], {RX, RY}) ->
    case (erlang:abs(RX - TX) > 20) andalso (erlang:abs(RY - TY) > 20) of
        true -> is_valid_pos(T, {RX, RY});
        false -> false
    end.

%% 推送树的信息
push_tree_info(Now, ElemId, Rid, #tree_info{type = Type, end_time = EndTime, watering = WatTime, maxwater = MaxWater, waters = WterS, name = TName}, #role_data{watering = RWatTime, maxwater = RMaxWat}, State) ->
    Owner = case check_tree_owner(ElemId, State, Rid) of
        true -> 1;
        false -> 0
    end,
    LeaveTime = case (EndTime - Now) of
        LeaveT when LeaveT > 0 -> LeaveT;
        _ -> 0
    end, 
    {Owner, Type, LeaveTime, WatTime, MaxWater, WterS, TName, RWatTime, RMaxWat, ?time_off}.
