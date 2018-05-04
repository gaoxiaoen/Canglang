-module(beer).
-behaviour(gen_server).

-export([
            start_link/0,
            enter_beer/1,
            get_current_status/0,
            get_beer_info/0,
            login/1,
            throw/4,
            leave/1,
            send_wait_info/1
        ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("rank.hrl").
-include("role.hrl").
-include("guild.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("achievement.hrl").
-include("beer.hrl").
-include("gain.hrl").
-include("map.hrl").
-include("unlock_lev.hrl").
-include("role_online.hrl").

-record(state, {
        status = finish,
        map_baseid = 0,
        maps = []
    }).

%% 活动期间下线登录时重新更新状态
login(Role = #role{id = Rid, event = Event, pid = Pid, link = #link{conn_pid = ConnPid}, pos = Pos = #pos{last = {LastMapId, LastX, LastY}}, beer_guide = Guide}) ->
    NRole = 
    case Event of 
        ?event_beer ->
            Status = get_current_status(),
            case Status of 
                finish -> 
                    Role#role{pos = Pos#pos{map = LastMapId, x = LastX, y = LastY}, event = ?event_no, event_pid = 0};
                _ -> 
                    case find_role_in_beer(Rid) of 
                        #beer_role{} ->
                            beer ! {login, Rid, Pid, ConnPid, Guide},

                            role_timer:set_timer(send14430, 10, {?MODULE, send_wait_info, []}, 1, Role); %% 请求14430信息
                        _ -> 
                            Role#role{pos = Pos#pos{map = LastMapId, x = LastX, y = LastY}, event = ?event_no, event_pid = 0}
                    end
            end;
        _ -> 
            Role
    end,
    beer_mgr:login(NRole).

%% 启动进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [?MAPBASEID], []).

% @spec enter_beer(Role) -> {Waittime, Ntitle}
% Role :: #role
% @doc 进入场景
enter_beer(Role) ->
    beer ! {enter_beer_area, to_beer_role(Role)}.

% @spec leave(Role) -> ok
% Role :: #role
% @doc 离开场景场景
leave(_Role = #role{id = Rid}) ->
    beer ! {leave, Rid}.


% @spec get_current_status() -> finish | waitting | running
% @doc获取当前的状态
get_current_status() ->
    gen_server:call(?MODULE, {status}).

% @spec get_beer_info() -> tuple()
% @doc 获取当前的信息
get_beer_info() ->
    case ets:lookup(beer_info, info) of 
        [{info, Status, NextTime, AllTitle, NextTitle, NextTitleSt, NextTitleFt, Nth}]->
            {Status, NextTime, AllTitle, NextTitle, NextTitleSt, NextTitleFt, Nth};
        _ -> 
            {finish, 0, 0, 0, 0, 0, 0}
    end.

%%丢鲜花 或者 鸡蛋
throw(Kind, IfAward, Role = #role{id = Id, name = Name}, PointDatas = {_, _, _, _Y1, _X2}) when Kind =:= 1 orelse Kind =:= 2 -> 
    case find_role_in_beer(Id) of
        #beer_role{map_id = _MapId, map_pid = MapPid} ->
            map:pack_send_to_all(MapPid, 14438, PointDatas), %% 广播丢鲜花或者鸡蛋的事件
            case IfAward of 
                1 ->
                    deal_hit_somebody_flower_egg(_MapId, MapPid, Id, Kind, Name, {_Y1, _X2}),
                    {ok, NRole} = role_gain:do([#gain{label = coin, val = 1000}], Role),
                    notice:alert(succ, NRole, ?MSGID(<<"+1000金币">>)),
                    % beer_mgr:update_role_reward(Id, {2, 1000, 0}),
                    NRole;
                _ ->
                    Role
            end;
        undefined ->
            notice:alert(error, Role, ?MSGID(<<"不在酒桶节区域">>)),
            error
    end;
throw(_Kind = 3, _IfAward, Role = #role{id = Id, name = Name}, PointDatas = {_, _, _X1, _Y1, _X2}) ->
    case find_role_in_beer(Id) of
        #beer_role{map_id = _MapId, map_pid = MapPid} ->
            notice:alert(succ, Role, ?MSGID(<<"+30000金币">>)),
            map:pack_send_to_all(MapPid, 14438, PointDatas), %% 广播烟花事件，大家都收到金币
            deal_hit_all_firework(MapPid, Id, Name),
            {ok, NRole} = role_gain:do([#gain{label = coin, val = 30000}], Role),
            % beer_mgr:update_role_reward(Id, {2, 30000, 0}),
            NRole;
        undefined ->
            notice:alert(error, Role, ?MSGID(<<"不在酒桶节区域">>)),
            error
    end;
throw(_, _, _Role, _PointDatas) -> 
    error.

send_wait_info(#role{id = Id = {_Rid, _}, link = #link{conn_pid = ConnPid}, beer_guide = Guide}) ->
    beer ! {info_14430, Id, ConnPid, Guide},
    {ok}.
    
deal_hit_all_firework(MapPid, Rid, Name) ->    
    case ets:lookup(beer_info, area_info) of
        [{_, Areas}] ->
            case lists:keyfind(MapPid, #beer_map.map_pid, Areas) of 
                #beer_map{roles = Roles} -> 
                    RoleMsg = notice:role_to_msg(Name),                    
                    Msg = util:fbin(?L(<<"~s为全场每个人再添啤酒，大家举杯为他欢呼吧!">>), [RoleMsg]),
                    map:pack_send_to_all(MapPid, 10932, {7, 1, Msg}),

                    NRoles = lists:keydelete(Rid, #beer_role.rid, Roles),
                    [role:apply(async, Rpid, {fun hit_by_firework/1, []})||#beer_role{pid = Rpid} <- NRoles],
                    ok;
                _ -> 
                    ?ERR("酒桶节没有地图信息~n"),
                    ignore
            end;
        _ -> 
            ?ERR("酒桶节没有地图信息~n"),
            ignore
    end.

hit_by_firework(Role = #role{id = _Id}) -> 
    case role_gain:do([#gain{label = coin, val = 3000}], Role) of 
        {ok, NRole} -> 
            notice:alert(succ, Role, ?MSGID(<<"+3000金币">>)),
            % beer_mgr:update_role_reward(Id, {2, 3000, 0}),
            {ok, NRole};
        _ -> 
            {ok, Role}
    end.


deal_hit_somebody_flower_egg(_MapId, MapPid, {Rid, _}, Kind, Name, {_Y, _X}) ->
    Rand = util:rand(1, 100),
    ?DEBUG("---------------Rand-----------------~p~n~n", [Rand]),
    ConfigRand = case Kind of 
                1 -> ?FLOWER_RAND;
                2 -> ?EGG_RAND;
                _ -> 0
            end,

    case Rand =< ConfigRand of 
        true -> 
            MapRoles = get_roles(MapPid, _X, _Y),
            % NMapRoles = lists:keydelete(Rid, #map_role.rid, MapRoles),
            % IDPos = [{Rid1, X, Y}||#map_role{rid = Rid1, dest_x = X, dest_y = Y} <- NMapRoles],
            % ?DEBUG("IDPos:~p~n~n", [IDPos]),
            ?DEBUG("---map roles after select---:~p~n~n", [MapRoles]),
            NMapRoles = lists:keydelete(Rid, #map_role.rid, MapRoles),
            case erlang:length(NMapRoles) > 0 of 
                true ->
                    Nth = util:rand(1, erlang:length(NMapRoles)),
                    #map_role{pid = Rpid} = lists:nth(Nth, NMapRoles),
                    role:apply(async, Rpid, {fun hit_by_flower_or_egg/4, [Kind, MapPid, Name]});
                false -> 
                    %% 发送世界消息,没有人捡到鲜花或者被鸡蛋砸中
                    send_nobody_hit(Name, MapPid, Kind),
                    ok
            end;
        false -> 
            %% 发送世界消息,没有人捡到鲜花或者被鸡蛋砸中
            send_nobody_hit(Name, MapPid, Kind),
            ok
    end.
send_nobody_hit(Name, MapPid, Kind) -> 
    ?DEBUG("send_nobody_hit kind :~p~n", [Kind]),
    RoleMsg = notice:role_to_msg(Name),                    
    Msg = 
        case Kind of 
            1-> util:fbin(?L(<<"~s在答题大厅抛出一朵鲜花，可惜没有人接到">>), [RoleMsg]);
            2-> util:fbin(?L(<<"~s在答题大厅丢出了一个鸡蛋，没有砸到人">>), [RoleMsg]);
            _ -> <<"">>
        end,
    map:pack_send_to_all(MapPid, 10932, {7, 5, Msg}).
    
hit_by_flower_or_egg(Role = #role{id = _Id, name = Name}, Kind, MapPid, FromName) -> 
    Gain = 
        case Kind of 
            1 -> %% 鲜花
                [#gain{label = coin, val = 1000}];
            2 ->%%鸡蛋
                [#loss{label = coin, val = 500}]
        end,
    case role_gain:do(Gain, Role) of 
        {ok, NRole} -> 
            %% 发送世界消息， xxx被鲜花或者鸡蛋砸中了
            %% 给自己发送 捡到500 金币的飘字 或者 被鸡蛋砸中的飘字
            RoleMsg = notice:role_to_msg(Name),                    
            FromRoleMsg = notice:role_to_msg(FromName),                    
            Msg = 
                case Kind of 
                    1 -> 
                        notice:alert(succ, Role, ?MSGID(<<"接到鲜花+1000金币">>)),
                        util:fbin(?L(<<"~s在答题大厅幸运地接到了~s抛出的鲜花，获得了1000金币">>), [RoleMsg, FromRoleMsg]);
                    2 -> 
                        notice:alert(succ, Role, ?MSGID(<<"被砸鸡蛋-500金币">>)),
                        util:fbin(?L(<<"~s在答题大厅被~s丢出的鸡蛋砸中了脑袋，不幸损失了500金币">>), [RoleMsg, FromRoleMsg])
                end,
            map:pack_send_to_all(MapPid, 10932, {7, 5, Msg}),
            case Kind of 
                1 -> 
                    % beer_mgr:update_role_reward(Id, {2, 1000, 0}),
                    ok;
                _  -> ok
            end,
            {ok, NRole};
        _ -> 
            {ok, Role}
    end.

%%
find_role_in_beer(Rid) -> 
    gen_server:call(?MODULE, {find_role, Rid}).

%%----------------------------------------------------
%% 系统函数
%%----------------------------------------------------

init_dict() -> 
       %% dict的内容需要与next_timer中的初始化保持同步,不封装能比较清晰看出初始化的内容
    % put(beer_area, []),
    put(activity_npc_pair, 0), %%设置初始的npc
    put(nth, 0), %% 当前为第几次活动
    put(next_time, 0), %% 下一次活动时间
    put(all_titles, 0), %% 下一次活动题目总的数量
    put(rank_title, []), %% 本次活动已随机出来的题目
    put(rank_nth_title, 0), %% 记录每次随机出来的题目的序号

    put(next_title, 0), %% 服务端定时器每隔一段时间自动增加
    put(next_title_st, 0), %% 下一道题开始的时间
    put(curr_title_ft, 0). %% 当前道题结束的时间


init([MapBaseId]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    ets:new(beer_info, [public, set, named_table, {keypos, 1}]),
    ets:insert(beer_info, {info, finish, 0, 0, 0, 0, 0, 0}), %% 之后对ets的写操作都是update_element

    init_dict(),
 
    State = #state{map_baseid = MapBaseId},

    put(beer_area, []),
    create_map(State), %% 先创建一个可用区域，之后根据角色进入地图逐步创建区域

    erlang:send_after(5000, self(), next_timer), %加载活动时间，启动定时器

    process_flag(trap_exit, true), 
    ?INFO("[~w] 酒桶节活动进程启动完成", [?MODULE]),
    {ok, State}.


%% 进入酒桶节场景
handle_info({enter_beer_area, BRole = #beer_role{rid = Rid, pid = Rpid, conn_pid = ConnPid, guide = Guide}}, State = #state{status = Status}) ->
    case get_available_area(State) of
        undefined ->
            notice:alert(error, ConnPid, ?MSGID(<<"没有可进入的战斗区域">>));
        Area = #beer_map{map_id = MapId, map_pid = MapPid} ->
            case Status of 
                finish ->
                    notice:alert(error, ConnPid, ?MSGID(<<"活动尚未开始！">>));
                _ ->
                    Reply = calc_wait_time_reward(Rid, Status, Guide),

                    sys_conn:pack_send(ConnPid, 14430, Reply), %%成功进入

                    beer_mgr:add_role_join(Rid),

                    role:apply(async, Rpid, {fun async_enter_beer_area/4, [MapId, {?INIT_X, ?INIT_Y}, self()]}),
                    BRole1 = BRole#beer_role{map_id = MapId, map_pid = MapPid},
                    %%更新区域
                    add_role_to_area(Area, BRole1)
            end
    end,
    {noreply, State};

handle_info({leave, Rid}, State) -> 
    delete_from_area(Rid), 
    {noreply, State};


%% 每次都从这里重新读配置，这样不需要重启服务器也可以更改活动时间点
handle_info(next_timer, State) -> 

    init_dict(),
    
    AllTimes = beer_data:get_all_times(),
    {Nth, Special, TitleNum} = get_next_timer(AllTimes), %% 返回第N个时间点
    put(nth, Nth),
    update_nth(Nth),
    Duration = calc_duration(AllTimes, Nth), %% 返回距离还有多少毫秒
    Now = util:unixtime(),
    NextTime = Now + Duration div 1000,
    put(next_time, NextTime), %% 下一次开始的时间点，距离还有多少秒
    update_next_time(NextTime),
    put(all_titles, TitleNum), %% 下一次活动题目的数量
    
    update_all_title(TitleNum),

    ?DEBUG("开始计算下一个酒桶节时间点~n~n"),
    ?DEBUG("计算下一个酒桶节时间点结果第~p个,是否加倍~p~n~n", [Nth, Special]),
    ?DEBUG("下一个酒桶节时间点还有~p秒~n~n", [Duration div 1000]),

    case Special of
        1 ->
            if 
                Duration > 180000 ->
                    erlang:send_after(Duration - 180000, self(), {send_notice, 3}); %发送传闻
                true ->
                    ok
            end,
            if 
                Duration > 120000 ->
                    erlang:send_after(Duration - 120000, self(), {send_notice, 2}); %发送传闻
                true ->
                    ok
            end,
            if 
                Duration > 60000 ->
                    erlang:send_after(Duration - 60000, self(), {send_notice, 1}); %发送传闻
                true ->
                    ok
            end;
        0 ->
            ok
    end,    
    erlang:send_after(Duration, self(), {start_activity, Special}), % 活动开始 调试期间改为收到开始活动
    {noreply, State};

handle_info(test, State) ->
    init_dict(),
    put(nth, 1),
    update_nth(1),
    put(all_titles, 20), %% 下一次活动题目的数量
    update_all_title(20),
    beer_mgr!clear_role_beer_info,

    Now = util:unixtime(),
    put(next_time, Now), %%
    update_next_time(Now),
    erlang:send_after(10, self(), {start_activity, util:rand(0, 1)}), % 活动开始 调试期间改为收到开始活动
    {noreply, State};

handle_info({send_notice, Min}, State) ->
    ?DEBUG("~n~n发送消息提醒:~p分钟后开始酒桶节~n~n", [Min]),
    Msg = util:fbin(<<"双倍答题活动将在~w分钟之后开始，想要参加的小伙伴准时到主城等待哦">>, [Min]), %% 之后会考虑将这句话放到客户端实现
    broadcast_alert_message(Msg),
    {noreply, State};

handle_info({start_activity, Special}, State) ->
    %% 通知客户端开始进入等待
    ?DEBUG("酒桶节活动进入等待状态~n~n"),
    NState = State#state{status = waitting},
    update_status(waitting),
    erlang:send_after(?WAIT_TIME + 3000, self(), really_start), %3分钟的等待时间
    case Special of 
        1 -> 
            broadcast_start_signal(); % 广播开始消息,客户端显示小面板
        _ -> ignore
    end,
    {noreply, NState};

handle_info(really_start, State) ->
    %% 真正开始
    ?DEBUG("酒桶节活动真正开始~n~n"),
    NState = State#state{status = running},
    update_status(running),

    erlang:send_after(20, self(), {update_next_title, 1}), %自动更新当前第几题

    {noreply, NState};

handle_info({update_next_title, N}, State) ->
    ?DEBUG("准备广播第~p道题目~n", [N]),
    Now = util:unixtime() * 1000,
    update_next_title(N),
    put(next_title, N),
    put(next_title_st, Now + ?EFFECT_TIME + ?THINKING_TIME),
    put(curr_title_ft, Now + ?THINKING_TIME),

    %% 随机一道题目，广播出去
    Have = get(rank_title),
    {NTitle, MayAnswer} = get_rank_title(Have),
    put(rank_title, [NTitle] ++ Have),
    put(rank_nth_title, NTitle),

    broadcast_n_title(N, NTitle, MayAnswer),
    
    AllTitle = get(all_titles),
    case N =:= AllTitle of 
        false -> 
            erlang:send_after(?EFFECT_TIME + ?THINKING_TIME + 20, self(), {update_next_title, N + 1}); %20表示服务端的延迟，
         true ->
            erlang:send_after(?EFFECT_TIME + ?THINKING_TIME + 1500, self(), finish_activity)  %最后借结束的时候时间长点可以显示答题结束
    end,
    {noreply, State};

handle_info(finish_activity, State) ->
    NState = State#state{status = finish},
    update_status(finish),
    broadcast_finish_signal(), %% 广播结束消息

    erlang:send_after(15000, self(), force_role_exit), %% 切换场景

    erlang:send_after(20000, self(), clear_map), %% 清除地图, 因为地图的怪需要重新加载且下一次活动还有一段时间才开始
    erlang:send_after(500, self(), next_timer), %% 计算下一次活动
    {noreply, NState};

handle_info(clear_map, State) ->
    beer_mgr:clear_role_reward(),
    clear_map(),
    {noreply, State};

handle_info(force_role_exit, State) ->
    force_exit_area(),
    % beer_mgr:clear_role_reward(),
    beer_mgr:update_role_beer_times(), %% 更新参加活动的次数
    {noreply, State};

handle_info({exit_area, Pid}, State) ->
    case is_pid(Pid) andalso erlang:is_process_alive(Pid) of 
        true ->
            role:apply(async, Pid, {fun async_exit_area/1, []});
        _ -> ignore
    end,
    {noreply, State};

handle_info({login, Rid, Pid, ConnPid, Guide}, State) ->
    update_role_in_area(Rid, Pid, ConnPid, Guide),
    {noreply, State};

handle_info({info_14430, Rid, ConnPid, Guide}, State = #state{status = Status}) ->
    ?DEBUG("send_14430:~p~n", [Guide]),
    send_14430(Rid, ConnPid, Status, Guide),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}. 

handle_call({status}, _From, State = #state{status = Status}) ->
    {reply, Status, State};

handle_call({find_role, Rid}, _From, State) ->
    Reply = find_role_in_area(Rid),
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {reply, _From, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

% -------------------------------------------------------------------------------------
%  internal api
% -------------------------------------------------------------------------------------
send_14430(Id, ConnPid, Status, Guide) when is_pid(ConnPid)->
    Reply = calc_wait_time_reward(Id, Status, Guide),
    sys_conn:pack_send(ConnPid, 14430, Reply),
    ok;
    
send_14430(_, _, _, _)->
    ignore.

calc_wait_time_reward(Id, Status, [Guide]) ->
    Now = util:unixtime() * 1000,
    Curr_title_ft = get(curr_title_ft),
    {Rights, Wrongs, Coin, Exp} = beer_mgr:get_role_reward_info(Id),
    #beer_role_info{flower_times = Flower, egg_times = Egg, firework_times = FireWork} = beer_mgr:get_beer_info(Id),
    case Status of
        running ->
            case Curr_title_ft > Now of 
                false ->
                    ?DEBUG("播放答案特效期间进入~n"),
                    Next_title_ft = get(next_title_st),
                    {0, (Next_title_ft - Now) div 1000, get(next_title), get(rank_nth_title), Rights, Wrongs, Coin, Exp, Flower, Egg, FireWork, Guide};
                true ->
                    ?DEBUG("答题期间进入~n"),
                    NextTitleSt = get(next_title_st),
                    {1, (NextTitleSt - Now) div 1000, get(next_title), get(rank_nth_title), Rights, Wrongs, Coin, Exp, Flower, Egg, FireWork, Guide}
            end;
        waitting ->
            NextTime = get(next_time), 
            {0, ?WAIT_TIME div 1000 - (Now div 1000 - NextTime), 0, 0, 0, 0, 0, 0, Flower, Egg, FireWork, Guide}; %% 计算等待的时间
        _ ->
            ?ERR("进入酒桶节场景，当前状态有误:~p", [Status]),
            {0, 86400, 0, 0, 0, 0, 0, 0, 0, 0, 0, Guide}
    end.

%% 异步进入场景
async_enter_beer_area(Role = #role{id = _Rid, name = _Name, pos = #pos{map = LastMapId, x = LastX, y = LastY}}, MapId, {NewX, NewY}, EventPid) ->
    
    Role1 = Role#role{event = ?event_beer, event_pid = EventPid},
    Role2 = case map:role_enter(MapId, NewX, NewY, Role1) of
        {ok, NewRole = #role{pos = NewPos}} -> 
            ?DEBUG("[~s]进入酒桶节区域成功", [_Name]),
            NewRole#role{pos = NewPos#pos{last = {LastMapId, LastX, LastY}}};
        {false, _Why} -> 
            ?ERR("[~s]进入酒桶节区域失败:~s", [_Name, _Why]),
            Role
    end,
    {ok, Role2}.

%% 异步离开场景
async_exit_area(Role = #role{name = _Name, pos = #pos{last = {LastMapId, LastX, LastY}}}) ->
    Role1 = Role#role{event = ?event_no, event_pid = 0},
    Role2 = case map:role_enter(LastMapId, LastX, LastY, Role1) of
        {ok, NewRole} -> 
            ?DEBUG("[~s]退出酒桶节区域成功", [_Name]),
            NewRole;
        {false, _Why} -> 
            ?ERR("[~s]退出酒桶节区域失败:~s", [_Name, _Why]),
            Role1
    end,

    %% 飘奖励结算处理都可以在这里操作,或者发消息到另一个进程去推送奖励总结
    put(beer_role_info, []),
    {ok, Role2}.

%% 广播活动开始消息
broadcast_alert_message(Msg) ->
    % L = get(beer_area),
    % ?DEBUG("~n~n已创建的酒桶节活动区域~p~n~n", [L]),
    %% 使用地图进程来进行消息广播
    %% 代替notice:alert(succ, ConnPid, Msg)
    % [map:pack_send_to_all(MapPid, 11111, {Msg})||#beer_map{map_pid = MapPid} <- L].
    % [map:pack_send_to_all(MapPid, 11111, {Msg})||#beer_map{map_pid = MapPid} <- L].
    role_group:pack_cast(world, 11111, {Msg}).

clear_map() ->
    L = get(beer_area),
    [map_mgr:stop({?map_def_line, MapId})||#beer_map{map_id = MapId} <- L],
    put(beer_area, []).


%% 广播开始活动消息
broadcast_start_signal() ->
    % L = get(beer_area),
    % ?DEBUG("~n~n已创建的酒桶节活动区域~p~n~n", [L]),
    ?DEBUG("广播世界消息, 通知酒桶节活动开始~n"),
    List = ets:tab2list(role_online),
    check_and_send_start_signal(List).         
    % role_group:pack_cast(world, 14431, {}).

check_and_send_start_signal([]) -> ok;
check_and_send_start_signal([#role_online{id = Id, pid = Pid, lev = Lev}|T]) -> 
    #beer_role_info{beer_times = Times} = beer_mgr:get_beer_info(Id),
    case Times > 0 andalso Lev >= ?beer_unlock_lev andalso is_pid(Pid) andalso erlang:is_process_alive(Pid) of 
        true -> 
            role:pack_send(Pid, 14431, {});
        false -> ok
    end,
    check_and_send_start_signal(T).

%% 广播结束活动消息
broadcast_finish_signal() ->
    % L = get(beer_area),
    % ?DEBUG("~n~n已创建的酒桶节活动区域~p~n~n", [L]),
    % [map:pack_send_to_all(MapPid, 14432, {})||#beer_map{map_pid = MapPid} <- L].
    role_group:pack_cast(world, 14432, {}).

%% 广播第几道题目
broadcast_n_title(N, Nth, Answer) -> %% N 表示当前为第几次题目1-20， Nth表示题目的号码-随机产生
    L = get(beer_area),
    ?DEBUG("~n~n已创建的酒桶节活动区域~p~n~n", [L]),
    ?DEBUG("正在广播第~p道题目,可能的答案~w~n", [N, Answer]),
    [map:pack_send_to_all(MapPid, 14436, {N, Nth, Answer})||#beer_map{map_pid = MapPid} <- L].

%% 添加角色到区域
add_role_to_area(Area = #beer_map{map_id = MapId, role_num = RoleNum, roles = Roles}, 
    AreaRole = #beer_role{rid = Rid}) ->
    L = get(beer_area),
    %%这里RoleNum和Roles可能存在不同步
    Roles2 = [AreaRole | lists:keydelete(Rid, #beer_role.rid, Roles)],
    Areas2 = lists:keyreplace(MapId, #beer_map.map_id, L,
        Area#beer_map{role_num = RoleNum + 1, roles = Roles2}),
    put(beer_area, Areas2),
    ets:delete(beer_info, area_info),
    ets:insert(beer_info, {area_info, Areas2}).

%%更新角色在区域的信息
update_role_in_area(Rid, Pid, ConnPid, Guide) -> 
    case find_role_in_area(Rid) of 
        #beer_role{map_id = MapId} ->
            L = get(beer_area),
            case lists:keyfind(MapId, #beer_map.map_id, L) of 
                BeerMap = #beer_map{roles = Roles} -> 
                    %%这里RoleNum和Roles可能存在不同步
                    AreaRole = #beer_role{rid = Rid, pid = Pid, conn_pid = ConnPid, map_id = MapId, guide = Guide},
                    Roles2 = [AreaRole | lists:keydelete(Rid, #beer_role.rid, Roles)],
                    Areas2 = lists:keyreplace(MapId, #beer_map.map_id, L,
                        BeerMap#beer_map{roles = Roles2}),
                    put(beer_area, Areas2),
                    ets:delete(beer_info, area_info),
                    ets:insert(beer_info, {area_info, Areas2});
                _ -> ignore
            end;
        _ -> ignore
    end.
  
%% 将角色从区域中删除
delete_from_area(Rid) ->
    L = get(beer_area),
    NewArea = do_delete(Rid, L, []), 
    put(beer_area, NewArea),
    ets:delete(beer_info, area_info),
    ets:insert(beer_info, {area_info, NewArea}).    

do_delete(_Rid, [], Rest)-> Rest;
do_delete(Rid, [Area = #beer_map{roles = Roles}|T], Rest)->
    case lists:keyfind(Rid, #beer_role.rid, Roles) of 
        #beer_role{} -> 
            NRoles = lists:keydelete(Rid, #beer_role.rid, Roles),
            NewArea = Area#beer_map{roles = NRoles},
            [NewArea] ++ T ++ Rest;
        false -> 
            do_delete(Rid, T, [Area|Rest])
    end.

get_rank_title(Have) -> 
    Max = beer_data:get_title_count(),
    Rand = do_rand(Have, Max), 
    Answer = get_answer_when_is_celebrity(Rand),
    {Rand, Answer}.
do_rand(Have, Max) ->
    Rank = util:rand(1, Max),
    case lists:member(Rank, Have) of 
        true -> 
            do_rand(Have, Max);
        false -> 
            Rank
    end.

get_answer_when_is_celebrity(Rand) ->
    T = beer_data:check_if_celebrity(Rand),
    case T > 0 of
        true -> 
            NowList = rank:list(?rank_celebrity),
            CelebrityId = beer_data:get_celebrity_id(Rand),
            case lists:keyfind(CelebrityId, #rank_global_celebrity.id, NowList) of
                false -> 
                    ?L(<<"还没人达到">>);
                #rank_global_celebrity{r_list = Rlist} -> 
                    case erlang:length(Rlist) > 0 of 
                        true -> 
                            [#rank_celebrity_role{name = Name}|_] = Rlist,
                            Name;
                        false -> 
                            ?L(<<"还没人达到">>)
                    end 
            end;
        _ ->
            ?L(<<"!!">>)
    end.


%% 在各个area中查找角色
find_role_in_area(Rid) ->
    L = get(beer_area),
    do_find(Rid, L).

do_find(_Rid, []) -> undefined;
do_find(Rid, [#beer_map{roles = Roles}|T]) -> 
    case lists:keyfind(Rid, #beer_role.rid, Roles) of 
        BRole = #beer_role{} ->
            BRole;
        _ -> 
            do_find(Rid, T)
    end.
    
%% 活动结束，强制退出场景
force_exit_area() ->
    lists:foreach(fun(#beer_map{roles = Roles}) ->
                lists:foreach(fun(#beer_role{pid = Rpid}) -> 
                            self() ! {exit_area, Rpid}
                    end, Roles)
        end, get(beer_area)).


%%增加一个区域，在活动结束时需要清除掉，下一次活动时重新创建
add_area(Area) ->
    case get(beer_area) of
        undefined -> 
            put(beer_area, [Area]);
        L -> 
            put(beer_area, [Area | L])
    end.

% 创建玩家区域
create_map(#state{map_baseid = MapBaseId}) ->
    case map_mgr:create(MapBaseId) of
        {false, Reason} ->
            ?ERR("创建酒桶节区域地图[MapBaseId=~w]失败: ~s", [MapBaseId, Reason]),
            undefined;
        {ok, MapPid, MapId} ->
            % register(testmap, MapPid),
            NewArea = #beer_map{map_id = MapId, map_pid = MapPid, role_num = 0, roles = []},
            npc_enter(MapPid, MapBaseId),
            add_area(NewArea),
            ?DEBUG("创建酒桶节区域成功~n~n~n"),
            NewArea
    end.

npc_enter(MapPid, MapBaseId) ->
    {NpcbaseLeft, NpcbaseRight} =
        case get(activity_npc_pair) of 
            {Lnpc, Rnpc} -> {Lnpc, Rnpc};
            _ -> rand_activity_npc()
        end,

    case npc_data:get(NpcbaseLeft) of
        {ok, NpcBaseL} ->
            NpcPosL = #pos{
                map = MapBaseId,
                x = ?beer_npc_left_pos_x, 
                y = ?beer_npc_left_pos_y
            },
            NpcL = npc_convert:base_to_npc(1, NpcBaseL, NpcPosL),
            MapNpcL = npc_convert:do(to_map_npc, NpcL),
            map:npc_enter(MapPid, MapNpcL);
        _ -> 
            ?ERR("找不到npc基础数据:~p~n", [NpcbaseLeft])
    end,
    case npc_data:get(NpcbaseRight) of
        {ok, NpcBaseR} ->
            NpcPosR = #pos{
                map = MapBaseId,
                x = ?beer_npc_right_pos_x, 
                y = ?beer_npc_right_pos_y
            },
            NpcR = npc_convert:base_to_npc(2, NpcBaseR, NpcPosR),
            MapNpcR = npc_convert:do(to_map_npc, NpcR),
            map:npc_enter(MapPid, MapNpcR);
        _ -> 
            ?ERR("找不到npc基础数据:~p~n", [NpcbaseRight])
    end.

%% 随机一对npc
rand_activity_npc() ->    
    ALL = beer_data:get_all_npc(),
    Rand = util:rand(1, erlang:length(ALL)),
    Pair = lists:nth(Rand, ALL),
    put(activity_npc_pair, Pair),
    Pair.

%% 获取当前可用的区域
get_available_area(State) ->
    get_available_area(get(beer_area), State).
get_available_area([], State) ->
    create_map(State);
get_available_area([Area = #beer_map{map_pid = MapPid, role_num = RoleNum} | T], State) ->
    case is_pid(MapPid) andalso erlang:is_process_alive(MapPid) of 
        true -> 
            case RoleNum < ?AREA_ROLE_MAX of
                true -> 
                    Area;
                false -> 
                    get_available_area(T, State)
            end;
        false -> 
            get_available_area(T, State)
    end.

%% #role 转化为 #beer_role
to_beer_role(#role{id = Rid, pid = Rpid, link = #link{conn_pid = ConnPid}, beer_guide = BeerGuide}) ->
    #beer_role{rid = Rid, pid = Rpid, conn_pid = ConnPid, guide = BeerGuide}.


%% 获取临近的下一个时间点
get_next_timer(AllTimes) -> %% 返回第N个时间点
    Now = util:unixtime() - util:unixtime(today), %% 当前距离今天0时的秒数
    TimeSeconds = trans(AllTimes), %% 转化为秒的表示
    First = get_nearest(Now, TimeSeconds, 1),
    case beer_data:get_activity(First) of
        #beer_data{special = Special, title_num = TitleNum} ->
            {First, Special, TitleNum};
        _ ->
            ?ERR("酒桶节活动数据不存在：~s", [First]),
            {0, 0, 0}
    end.

get_nearest(_Now, [], _) -> 1; %% 已经过了最后一个时间，则取第一个
get_nearest(Now, [H|T], N) ->
    case Now < H of
        true -> N;
        false ->
            get_nearest(Now, T, N + 1)
    end.

trans(AllTimes) when is_list(AllTimes)->
    [Hour * 3600 + Min * 60 + Sec||{Hour, Min, Sec} <- AllTimes];
trans(_) -> [].
    
%% 返回距离下一个时间点还有多少毫秒
calc_duration(AllTimes, Nth) -> 
    case lists:nth(Nth, AllTimes) of
        {Hour, Min, Sec} ->
            get_next_duration({Hour, Min, Sec});
        _ ->
            ?ERR("计算下一个时间距离有误:~s:~s", [AllTimes, Nth]),
            86400 * 1000
    end.

%% 获取距离下一次活动的剩余时间
get_next_duration({Hour, Min, Sec}) ->
    Time = Hour * 3600 + Min * 60 + Sec,
    Duration = util:unixtime({nexttime, Time}),
    Duration * 1000.


update_status(Status) ->
    ets:update_element(beer_info, info, {2, Status}).

update_next_time(NextTime) ->
    ets:update_element(beer_info, info, {3, NextTime}).

update_all_title(AllTitle) ->
    ets:update_element(beer_info, info, {4, AllTitle}).

update_next_title(Nexttitle) ->
    ets:update_element(beer_info, info, {5, Nexttitle}).

update_nth(Nth) ->
    ets:update_element(beer_info, info, {8, Nth}).

get_roles(MapPid, X0, Y0) -> 
    Roles = map:role_in_slice(MapPid, X0, Y0),
    case Roles of
        [ok] -> [];
        ok ->[];
        _ ->
            ?DEBUG("get_roles Roles :~p~n~n", [Roles]),
            Roles1 = [R||R<-Roles, is_record(R, map_role) == true],
            {X1, X2} = calc_X_range(X0),
            {Y1, Y2} = calc_Y_range(Y0),
            ?DEBUG("Roles in slice X0:~p", [X0]),
            ?DEBUG("Roles in slice Y0:~p", [Y0]),
            ?DEBUG("Roles in slice X1:~p", [X1]),
            ?DEBUG("Roles in slice X2:~p", [X2]),
            ?DEBUG("Roles in slice Y1:~p", [Y1]),
            ?DEBUG("Roles in slice Y2:~p", [Y2]),
            ?DEBUG("Roles in slice:~p", [Roles1]),
            [R1||R1 = #map_role{x = X, y = Y} <- Roles1, X >= X1, X =< X2, Y >= Y1, Y =< Y2]
    end.

-define(AX, 100).
-define(AY, 100).

calc_X_range(X) ->  
    if 
        X > 640 -> 
            X1 = if X >= (640 + ?AX) -> X - ?AX; true -> 640 end,      
            X2 = if X =< (1280 - ?AX) -> X + ?AX; true -> 1280 end,
            {X1, X2};
        X < 640 -> 
            X1 = if X >= (0 + ?AX) -> X - ?AX; true -> 0 end,      
            X2 = if X =< (640 - ?AX )-> X + ?AX; true -> 640 end,
            {X1, X2};
        true -> 
            {0, 0}
    end.    

calc_Y_range(Y) ->  
    Y1 = if Y >= ?AY -> Y- ?AY; true -> 0 end,
    Y2 = if Y >= (640 - ?AY) -> 640; true -> Y + ?AY end,
    {Y1, Y2}.  