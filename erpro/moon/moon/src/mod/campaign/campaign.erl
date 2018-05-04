%% --------------------------
%% 活动控制器 
%% @author shawnoyc@vip.qq.com
%% --------------------------
-module(campaign).
-behaviour(gen_server).
-export([
        start_link/0
       ,get_camps/1
       ,on_login/1
       ,on_login_callback/1
       ,on_logout/1
       ,on_logout_callback/1
       ,on_charge/2
       ,on_charge_callback/2
       ,on_task/2
       ,reload/0
       ,prompt/2
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("campaign.hrl").
-include("role.hrl").
-include("npc.hrl").
-include("pos.hrl").
-include("link.hrl").

%% ---对外接口------------
%% 启动服务器
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).
    
%% 获取指定的类型的活动
%% @spec get_camps(Flag) -> List
%% Flag =  login | logout | charge
%% @doc 通过Flag类型获取指定类型活动列表
get_camps(Flag) ->
   CampList = get_cams_from_date(),
   do_get_camps(Flag, CampList, []). 

%% 
reload() ->
    CampList = get_camps(do_begin), %% 获取中途开启的活动
    case global:whereis_name(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid ! {reload, CampList},
            ok;
        _ -> 
            ?ERR("活动管理进程不存在"),
            ok
    end. 

%% 登录触发
on_login(Role = #role{pid = Pid}) ->
    role:apply(async, Pid, {?MODULE, on_login_callback, []}),
    {ok, Role}.

on_login_callback(#role{pid = Pid}) ->
    Now = util:unixtime(),
    lists:map(fun(Camp) ->
                case util:datetime_to_seconds(Camp#campaign.begin_time) of
                    false -> skip;
                    BeginTime ->
                        case util:datetime_to_seconds(Camp#campaign.end_time) of
                            false -> skip;
                            EndTime ->
                                case Now >= BeginTime andalso Now =< EndTime of
                                    true -> role:apply(async, Pid, {campaign_execute, when_login, [Camp]});
                                    false -> skip
                                end
                        end
                end
        end, get_camps(login)),
    {ok}.

%% 退出时触发
on_logout(Role) ->
    {ok, Role}.

on_logout_callback(Role) ->
    NewRole = lists:foldl(fun(_Camp, R) ->
                try apply(campaign_execute, when_logout, [R]) of
                    R1 when is_record(R1, role) ->
                        R1;
                    Else ->
                        ?ERR("活动错误,角色退出非法值:~w",[Else])
                    catch A:B ->
                        ?ERR("活动错误,角色退出非法值:~p:~p",[A,B]),
                        R
                end
        end, Role, get_camps(logout)),
    {ok, NewRole}.

%% 充值时触发
on_charge(Role = #role{name = _Name, pid = Pid}, Charge) ->
    ?DEBUG("~s进行了充值:~w晶钻",[_Name, Charge]),
    role:apply(async, Pid, {?MODULE, on_charge_callback, [Charge]}),
    {ok, Role}.

on_charge_callback(Role = #role{pid = Pid}, Charge) ->
    Now = util:unixtime(),
    lists:map(fun(Camp = #campaign{begin_time = Bt, end_time = Et}) ->
                case util:datetime_to_seconds(Bt) of
                    false ->
                        ?ELOG("活动日期设置错误:~p",[Camp#campaign.title]),
                        skip;
                    BeginTime ->
                        case util:datetime_to_seconds(Et) of
                            false -> skip;
                            EndTime ->
                                case Now >= BeginTime andalso Now =< EndTime of
                                    true ->
                                        role:apply(async, Pid, {campaign_execute, when_charge, [Camp, Charge]});
                                    false ->
                                        skip
                                end
                        end
                end
        end, get_camps(charge)),
    %% prompt(Role, Charge),  //没有这需求，暂时去掉，by qingxuan, 2014/2/11
    % campaign_repay_relation:repay_single(Role, Charge), %% 充值返现，惠及好友家人
    % campaign_repay_charge:repay_single(Role, Charge), %% 活动期间单笔充值500以上
    % catch campaign_repay_bystages:charge(Role, Charge),       %% 充值返现，分十天返还
    %% catch campaign_repay_bystages2:charge(Role, Charge),       %% 充值返现，分十天返还
    %% catch campaign_repay_bystages3:charge(Role, Charge),       %% 充值返现，分十天返还
    % NewRole = campaign_suit:charge(Role, Charge),       %% 充值套装活动
    {ok, Role}.

%% 7.5夏日清爽活动，目前只支持修行任务
on_task(#role{pid = Pid}, TaskId) ->
    Now = util:unixtime(),
    %% change_time
    case Now >= 1341432000 andalso Now =< 1341676799 of
    %%case Now >= 1341273600 andalso Now =< 1341676799 of
        true ->
            case campaign_data:get(31) of
                {ok, Camp} ->
                    role:apply(async, Pid, {campaign_execute, when_task, [Camp, TaskId]}),
                    ok;
                _ ->
                    ok
            end;
        false ->
            ok
    end.

%% 活动有累积充值弹出面板提示
prompt(#role{id = {Rid, SrvId}, link = #link{conn_pid = ConnPid}}, Charge) ->
    CampId = case campaign_data:get_campaign_charge_ids() of
        [] -> 0;
        [Cid] -> Cid
    end,
    case lists:keyfind(CampId, 1, campaign_data:start_list()) of
        {CampId, Bt, Et} ->
            case util:datetime_to_seconds(Bt) of
                false -> skip;
                BeginTime ->
                    case util:datetime_to_seconds(Et) of
                        false -> 
                            sys_conn:pack_send(ConnPid, 15802, {?false, 0, 0, 0, <<>>});
                        EndTime ->
                            Now = util:unixtime(),
                            case Now >= BeginTime andalso Now =< EndTime of
                                true ->
                                    NowCharge = campaign_dao:calc_charge(Rid, SrvId, begin_time, BeginTime),
                                    sys_conn:pack_send(ConnPid, 15802, {?true, EndTime - Now, Charge, NowCharge, <<>>});
                                false ->
                                    sys_conn:pack_send(ConnPid, 15802, {?false, 0, 0, 0, <<>>})
                            end
                    end
            end;
        false ->
            sys_conn:pack_send(ConnPid, 15802, {?false, 0, 0, 0, <<>>})
    end.

%% ----服务器内部实现--------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    erlang:send_after(5000, self(), start_tick),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, true}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Info, State) ->
    {noreply, State}.

handle_info(start_tick, State) ->
    Sec = 60 - (util:unixtime() rem 60),
    erlang:send_after(Sec*1000, self(),  tick),
    ?DEBUG("活动进程~w秒后 start tick",[Sec]),
    {noreply, State};

handle_info(tick, State) ->
    erlang:send_after(60000, self(), tick),
    Time = {Hour, Min, _} = erlang:time(),
    Date = erlang:date(),
    [triger(Camp, Event, {Date, Time}) || {Camp, Event} <- get_events({Date, {Hour, Min, 0}})],
    {noreply, State};

% handle_info({special, {create_npc, {InterVal, NpcBaseIds, CreateNum, MaxNum}}, EndTime}, State) ->
%     case util:unixtime() =< EndTime of
%         true ->
%             Locates1 = [L || L = {M, _, _} <- item_treasure_data:get_locates(2), M =:= 10002],
%             Locates2 = [L || L = {M, _, _} <- item_treasure_data:get_locates(2), M =:= 10004],
%             for_create(10002, NpcBaseIds, Locates1, CreateNum, MaxNum),
%             for_create(10004, NpcBaseIds, Locates2, CreateNum, MaxNum),
%             notice:send(52, util:fbin("忽然间风云变幻，原来是一些无人拜祭的孤魂野鬼出现在{map, ~w, #ffff00}、{map, ~w, #ffff00}捣乱，请各位仙友速速去超渡它们吧！", [10002, 10004])),
%             erlang:send_after(InterVal * 1000, self(),
%                 {special, {create_npc, {InterVal, NpcBaseIds, CreateNum, MaxNum}}, EndTime}),
%             {noreply, State};
%         false -> %% 活动结束
%             {noreply, State}
%     end;

handle_info({reload, CampList}, State) ->
    do_reload(CampList, self()),
    ?INFO("重载已经开启的活动成功"),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% ---------内部函数---------
do_reload([], _CampPid) -> ok;
do_reload([Camp = #campaign{do_begin = DoBegin} | T], CampPid) ->
    case lists:keyfind(special, 1, DoBegin) of
        {special, Data} -> 
            case util:datetime_to_seconds(Camp#campaign.end_time) of
                false ->
                    ?ERR("活动日期时间设置错误");
                EndTime ->
                    ?DEBUG("Data:~w, EndTime:~w",[Data, EndTime]),
                    CampPid ! {special, Data, EndTime}
            end;
        false -> skip
    end,
    do_reload(T, CampPid).

% for_create(_MapId, [], _Locates, _BaseNum, _MaxNum) -> ok;
% for_create(MapId, [BaseId | T], Locates, BaseNum, MaxNum) ->
%     case do_create(MapId, BaseId, Locates, BaseNum, MaxNum) of
%         ok -> ok;
%         false ->
%             ?DEBUG("BaseId:~w创建已达上限",[BaseId]),
%             false
%     end,
%     for_create(MapId, T, Locates, BaseNum, MaxNum).
% 
% do_create(MapId, NpcBaseId, Locates, BaseNum, MaxNum) ->
%     case npc_mgr:lookup(by_base_id, NpcBaseId) of
%         false ->
%             create(MapId, NpcBaseId, Locates, BaseNum);
%         Npcs ->
%             case [BaseId || #npc{base_id = BaseId, pos = #pos{map = Mid}} <- Npcs, Mid =:= MapId] of
%                 [] ->
%                     create(MapId, NpcBaseId, Locates, BaseNum);
%                 Exists when is_list(Exists) andalso length(Exists) < MaxNum ->
%                     create(MapId, NpcBaseId, Locates, min(BaseNum, MaxNum - length(Exists)));
%                 _X ->
%                     false
%             end
%     end.
% 
% create(_MapId, _NpcBaseId, _, 0) -> ok;
% create(MapId, NpcBaseId, Locates, Num) ->
%     {MapId, X, Y} = util:rand_list(Locates),
%     map:create_npc(MapId, NpcBaseId, X, Y),
%     create(MapId, NpcBaseId, Locates, Num - 1).

get_events(DateTime) ->
    CampList = get_cams_from_date(),
    get_events(DateTime, CampList, []).
get_events(_DateTime, [], FindList) -> FindList;
get_events(Date, [Camp = #campaign{do_begin = DoBegin, begin_time = {Bdate, {Bh, Bm, _}}, end_time = {Edate, {Eh, Em, _}}} | T], FindList) ->
    %% 有开始活动的列表
    L = case Date =:= {Bdate, {Bh, Bm, 0}} andalso DoBegin =/= [] of
        true -> [{Camp, when_begin} | FindList];
        false -> FindList
    end,
    %% 有结束活动的列表
    NewL = case Date =:= {Edate, {Eh, Em, 0}} of
        true -> [{Camp, when_end} | L];
        false -> L
    end,
    get_events(Date, T, NewL).

do_get_camps(login, [], LoginList) -> LoginList;
do_get_camps(login, [#campaign{do_login = []} | T], LoginList) ->
    do_get_camps(login, T, LoginList);
do_get_camps(login, [Camp | T], LoginList) ->
    do_get_camps(login, T, [Camp | LoginList]);

do_get_camps(charge, [], ChargeList) -> ChargeList;
do_get_camps(charge, [#campaign{do_charge = []} | T], ChargeList) ->
    do_get_camps(charge, T, ChargeList);
do_get_camps(charge, [Camp | T], ChargeList) ->
    do_get_camps(charge, T, [Camp | ChargeList]);

do_get_camps(do_begin, [], BeginList) -> BeginList;
do_get_camps(do_begin, [#campaign{do_begin = []} | T], BeginList) ->
    do_get_camps(do_begin, T, BeginList);
do_get_camps(do_begin, [Camp | T], BeginList) ->
    do_get_camps(do_begin, T, [Camp | BeginList]).

%% clean_special(DoBegin) ->
%%     case lists:keyfind(special, 1, DoBegin) of
%%         {special, _} -> 
%%             lists:keydelete(special, 1, DoBegin);
%%         _ -> DoBegin
%%     end.

get_camp_list(CampData) ->
    case sys_env:get(merge_time) of
        Time when is_integer(Time) ->
            get_camp_list(CampData, Time, []);
        _ ->
            %% ?ERR("无法获取合服时间"),
            []
    end.
get_camp_list([], _, MergeCamp) -> MergeCamp;
get_camp_list([{?STARTMODE_2, Id, KeepTime} | T], MergeTime, MergeCamp) ->
    Btime = util:unixtime({today, MergeTime}) + ?STARTMODE_2,
    BeginTime = util:seconds_to_datetime(Btime),
    EndTime = util:seconds_to_datetime(Btime + KeepTime),
    case campaign_data:get(Id) of
        {false, _Reason} -> get_camp_list(T, MergeTime, MergeCamp);
        {ok, CampBase} ->
            Camp = CampBase#campaign{begin_time = BeginTime, end_time = EndTime},
            get_camp_list(T, MergeTime, [Camp | MergeCamp])
    end;
get_camp_list([{?STARTMODE_1, Id, KeepTime} | T], MergeTime, MergeCamp) ->
    BeginTime = util:seconds_to_datetime(MergeTime),
    EndTime = util:seconds_to_datetime(util:unixtime({today, MergeTime + KeepTime}) + 86399),
    case campaign_data:get(Id) of
        {false, _Reason} -> get_camp_list(T, MergeTime, MergeCamp);
        {ok, CampBase} ->
            Camp = CampBase#campaign{begin_time = BeginTime, end_time = EndTime},
            get_camp_list(T, MergeTime, [Camp | MergeCamp])
    end.

get_cams_from_date() ->
    StartList = campaign_data:start_list(),
    case sys_env:get(srv_ids) of
        [] ->
            list_to_campaign(StartList);
        SrvList when is_list(SrvList) ->
            case util:is_merge() of
                true ->
                    MergeCamp = get_camp_list(campaign_data:get_merge_camp()),
                    list_to_campaign(StartList) ++ MergeCamp;
                _ ->
                    list_to_campaign(StartList)
            end
    end.

list_to_campaign(L) ->
    list_to_campaign(L, []).
list_to_campaign([], CampList) -> CampList;
list_to_campaign([{Id, BeginTime, EndTime} | T], CampList) ->
    case campaign_data:get(Id) of
        {false, _Reason} -> list_to_campaign(T, CampList);
        {ok, CampBase} ->
            Camp = CampBase#campaign{begin_time = BeginTime, end_time = EndTime},
            list_to_campaign(T, [Camp | CampList])
    end.

triger(Camp, when_begin, DateTime) ->
    notice:send(54, util:fbin(?L(<<"好消息，【~s】活动正式开启！">>), [Camp#campaign.title])),
    Pid = self(),
    spawn(campaign_execute, when_begin, [Camp, {DateTime, Pid}]);
triger(Camp, when_end, DateTime) ->
    notice:send(54, util:fbin(?L(<<"【~s】活动已经关闭，感谢大家的踊跃参与！">>), [Camp#campaign.title])),
    spawn(campaign_execute, when_end, [Camp, DateTime]);
triger(Camp, Event, DateTime) ->
    spawn(campaign_execute, Event, [Camp, DateTime]).
