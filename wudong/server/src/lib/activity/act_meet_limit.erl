%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 奇遇礼包
%%% @end
%%% Created : 19. 三月 2018 上午9:57
%%%-------------------------------------------------------------------
-module(act_meet_limit).
-author("luobaqun").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    get_act/0,
    get_leave_time/0,
    get_info/1,
    get_reward/3,
    init/1,
    logout/1,
    update/1,
    update_list/1,
    get_state/1,
    kill_mon/1,
    add_recharge_val/2,
    record_to_lists/1,
    lists_to_record/1,
    timer_touch/1,
    update_online_time/1]).


init(Player) ->
    St = activity_load:dbget_player_act_meet_limit(Player#player.key),
    lib_dict:put(?PROC_STATUS_ACT_MEET_LIMIT, St),
    update(Player),
    ok.

add_recharge_val(Player, Val) ->
    case get_act() of
        [] -> [];
        #base_act_meet_limit{c_act_list = ActChildList} ->
            St = lib_dict:get(?PROC_STATUS_ACT_MEET_LIMIT),
            #st_act_meet_limit{
                child_list = ChildList
            } = St,
            Now = util:unixtime(),
            F = fun(BaseChild) ->
                if
                    BaseChild#base_child_list.end_time =< Now -> BaseChild;
                    BaseChild#base_child_list.state =/= 0 -> BaseChild;
                    true ->
                        case [X || X <- ActChildList, X#base_child_act_meet_limit.type == BaseChild#base_child_list.type, X#base_child_act_meet_limit.id == BaseChild#base_child_list.id] of
                            [] -> BaseChild;
                            BaseChildActMeetLimit0 ->
                                BaseChildActMeetLimit = hd(BaseChildActMeetLimit0),
                                NewBaseChild0 = BaseChild#base_child_list{gold = BaseChild#base_child_list.gold + Val},
                                 if
                                    BaseChildActMeetLimit#base_child_act_meet_limit.gold =< NewBaseChild0#base_child_list.gold ->
                                        NewBaseChild0#base_child_list{state = 1};
                                    true ->
                                        NewBaseChild0
                                end
                        end
                end
            end,
            NewChildList = lists:map(F, ChildList),
            NewSt = St#st_act_meet_limit{child_list = NewChildList},
            lib_dict:put(?PROC_STATUS_ACT_MEET_LIMIT, NewSt),
            activity_load:dbup_player_act_meet_limit(NewSt),
            update_list(Player)
    end.

update(Player) ->
    St = lib_dict:get(?PROC_STATUS_ACT_MEET_LIMIT),
    #st_act_meet_limit{
        pkey = Pkey,
        act_id = ActId,
        child_list = ChildList
    } = St,
    case get_act() of
        [] ->
%%             send_mail(Player, ChildList),
            NewSt = #st_act_meet_limit{pkey = Pkey},
            activity_load:dbup_player_act_meet_limit(NewSt);
        #base_act_meet_limit{act_id = BaseActId, c_act_list = ActBaseList} ->
            if
                BaseActId =/= ActId ->
                    OpenDay = config:get_open_days(),
                    MergeDays = config:get_merge_days(),
%%                     send_mail(Player, ChildList),
                    List = [X || X <- ActBaseList, X#base_child_act_meet_limit.id == 1],
                    F = fun(BaseChild) ->
                        case get_next(Player, ActBaseList, BaseChild#base_child_act_meet_limit.type, BaseChild#base_child_act_meet_limit.id, OpenDay, MergeDays) of
                            [] ->
                                [];
                            NewInfo ->
                                [NewInfo]
                        end
                    end,
                    NewChildList = lists:flatmap(F, List),
                    NewSt = #st_act_meet_limit{pkey = Pkey, act_id = BaseActId, child_list = NewChildList},
                    activity_load:dbup_player_act_meet_limit(NewSt);
                true ->
                    {NewChildList,NewGetList} = send_mail(Player, ChildList),
                    NewSt = St#st_act_meet_limit{child_list = NewChildList,get_list = NewGetList ++ St#st_act_meet_limit.get_list},
                    activity_load:dbup_player_act_meet_limit(NewSt),
                    NewSt
            end
    end,
    lib_dict:put(?PROC_STATUS_ACT_MEET_LIMIT, NewSt),
    update_list(Player).

send_mail(Player, ChildList) ->
    Now = util:unixtime(),
    OpenDay = config:get_open_days(),
    MergeDays = config:get_merge_days(),
    F = fun(BaseChild,{ChildList0,GetList0}) ->
        if
            BaseChild#base_child_list.end_time =< Now ->
                if
                    BaseChild#base_child_list.state == 1  ->
                        {Title, Content0} = t_mail:mail_content(181),
                        mail:sys_send_mail([Player#player.key], Title, Content0, BaseChild#base_child_list.goods_list);
                    true -> skip
                end,
                case get_next(Player, [BaseChild], BaseChild#base_child_list.type, BaseChild#base_child_list.id, OpenDay, MergeDays) of
                    [] ->
                        {ChildList0,[{BaseChild#base_child_list.type, BaseChild#base_child_list.id}|GetList0]};
                    NewInfo ->
                        {[NewInfo]++ChildList0,[{BaseChild#base_child_list.type, BaseChild#base_child_list.id}|GetList0]}
                end;
            true ->
                {[BaseChild|ChildList0],GetList0}
        end
    end,
    lists:foldl(F,{[],[]}, ChildList).


timer_touch(Player) ->
    case get_act() of
        [] -> [];
        Base ->
            St = lib_dict:get(?PROC_STATUS_ACT_MEET_LIMIT),
            #st_act_meet_limit{child_list = ChildList} = St,
            Now = util:unixtime(),
            OpenDay = config:get_open_days(),
            MergeDays = config:get_merge_days(),
            F = fun(BaseChild, {NewChildList0, GoodsList0}) ->
                #base_child_list{
                    type = Type,
                    id = Id,
                    state = State,
                    end_time = EndTime,
                    goods_list = GoodsList1
                } = BaseChild,
                if
                    EndTime =< Now andalso State == 1 ->
                        {Title, Content0} = t_mail:mail_content(181),
                        mail:sys_send_mail([Player#player.key], Title, Content0, GoodsList1),
                        case get_next(Player, Base#base_act_meet_limit.c_act_list, Type, Id + 1, OpenDay, MergeDays) of
                            [] ->
                                {NewChildList0, GoodsList1 ++ GoodsList0};
                            NewInfo ->
                                {[NewInfo | NewChildList0], GoodsList1}
                        end;
                    EndTime =< Now andalso (State == 0 orelse State == 2) ->
                        case get_next(Player, Base#base_act_meet_limit.c_act_list, Type, Id + 1, OpenDay, MergeDays) of
                            [] ->
                                {NewChildList0, GoodsList0};
                            NewInfo ->
                                {[NewInfo | NewChildList0], GoodsList0}
                        end;
                    true ->
                        [BaseChild | NewChildList0]
                end
            end,
            {NewChildList, _GoodsList} = lists:foldl(F, {[], []}, ChildList),
            NewSt = St#st_act_meet_limit{child_list = NewChildList},
            lib_dict:put(?PROC_STATUS_ACT_MEET_LIMIT, NewSt),
            activity_load:dbup_player_act_meet_limit(NewSt)
%%             {Title, Content0} = t_mail:mail_content(181),
%%             mail:sys_send_mail([Player#player.key], Title, Content0, GoodsList)
    end.


get_info(_Player) ->
    activity:get_notice(_Player, [147], true),

    case get_act() of
        [] -> {0, []};
        Base ->
            St = lib_dict:get(?PROC_STATUS_ACT_MEET_LIMIT),
            F = fun(BaseChild) ->
                #base_child_list{
                    type = Type,
                    id = Id,
                    gold = Gold,
                    state = State,
                    end_time = EndTime
                } = BaseChild,
                Now = util:unixtime(),
                if
                    EndTime =< Now andalso EndTime =/= 0 -> [];
                    true ->
                        case [X || X <- Base#base_act_meet_limit.c_act_list, X#base_child_act_meet_limit.type == Type, X#base_child_act_meet_limit.id == Id] of
                            [] -> [];
                            List0 ->
                                Base0 = hd(List0),
                                [[
                                    Type,
                                    Id,
                                    State,
                                    max(0, EndTime - Now),
                                    Gold,
                                    Base0#base_child_act_meet_limit.gold,
                                    Base0#base_child_act_meet_limit.title,
                                    goods:pack_goods(Base0#base_child_act_meet_limit.goods_list)
                                ]]
                        end
                end
            end,
            List = lists:flatmap(F, St#st_act_meet_limit.child_list),
            {get_leave_time(), List}
    end.


get_reward(Player, Type, Id) ->
    case get_act() of
        [] -> {0, Player};
        Base ->
            OpenDay = config:get_open_days(),
            MergeDays = config:get_merge_days(),
            St = lib_dict:get(?PROC_STATUS_ACT_MEET_LIMIT),
            case lists:keytake({Type, Id}, #base_child_list.key, St#st_act_meet_limit.child_list) of
                false -> {0, Player};
                {value, #base_child_list{type = Type, id = Id, state = State, end_time = EndTime, goods_list = GoodsList}, T} ->
                    Now = util:unixtime(),
                    if
                        EndTime < Now andalso EndTime =/= 0 -> {23, Player};
                        State == 0 -> {24, Player};
                        State == 2 -> {23, Player};
                        true ->
                            NewChildList =
                                case get_next(Player, Base#base_act_meet_limit.c_act_list, Type, Id + 1, OpenDay, MergeDays) of
                                    [] ->
                                        T;
                                    NewInfo ->
                                        [NewInfo | T]
                                end,
                           NewGetList =
                                case lists:keytake(Type, 1, St#st_act_meet_limit.get_list) of
                                    false -> [{Type, Id} | St#st_act_meet_limit.get_list];
                                    Other ->
                                        {value, {Type, Id0}, T0} = Other,
                                        ?IF_ELSE(Id0 >= Id, St#st_act_meet_limit.get_list, [{Type, Id} | T0])
                                end,
                            NewSt = St#st_act_meet_limit{child_list = NewChildList, get_list = NewGetList},
                            lib_dict:put(?PROC_STATUS_ACT_MEET_LIMIT, NewSt),
                            activity_load:dbup_player_act_meet_limit(NewSt),
                            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(354, GoodsList)),
                            activity:get_notice(Player, [191], true),
                            Content = io_lib:format(t_tv:get(307), [t_tv:cl(Player#player.nickname, 1)]),
                            notice:add_sys_notice(Content, 307),
                            log_act_meet_limit(Player#player.key, Player#player.nickname, 1, GoodsList),
                            {1, NewPlayer}
                    end
            end
    end.

get_next(Player, ChildActList, Type, Id, OpenDay, MergeDays) ->
    case [X || X <- ChildActList, X#base_child_act_meet_limit.type == Type, X#base_child_act_meet_limit.id == Id] of
        [] -> [];
        BaseList ->
            Base = hd(BaseList),
            F = fun(OpenLimit) ->
                case OpenLimit of
                    {lv, Lv} -> ?IF_ELSE(Player#player.lv >= Lv, true, false);
                    {vip, Vip} -> ?IF_ELSE(Player#player.vip_lv >= Vip, true, false);
                    {open, Open} ->
                        lists:member(OpenDay, Open);
                    {merge, Res} ->
                        lists:member(MergeDays, Res);
                    _ -> false
                end
            end,
            case lists:all(F, Base#base_child_act_meet_limit.open_limit) of
                false -> [];
                true ->
                    Now = util:unixtime(),
                    LeaveTime = get_leave_time(),
                    #base_child_list{
                        key = {Type, Id},
                        type = Type,
                        id = Id,
                        start_time = Now,
                        end_time = ?IF_ELSE(Base#base_child_act_meet_limit.limit_timer == 0, 0, min(Now + LeaveTime, Now + Base#base_child_act_meet_limit.limit_timer)),
                        goods_list = Base#base_child_act_meet_limit.goods_list
                    };
                _ ->
                    []
            end
    end.

get_act() ->
    case activity:get_work_list(data_act_meet_limit) of
        [] -> [];
        [Base | _] -> Base
    end.

get_leave_time() ->
    activity:get_leave_time(data_act_meet_limit).

update_online_time(Player) ->
    case get_act() of
        [] -> [];
        #base_act_meet_limit{c_act_list = ChildActList} ->
            St = lib_dict:get(?PROC_STATUS_ACT_MEET_LIMIT),
            Now = util:unixtime(),
            F = fun(BaseChildList) ->
                NewBase = BaseChildList#base_child_list{online_time = BaseChildList#base_child_list.online_time + 60},
                case [X || X <- ChildActList, X#base_child_act_meet_limit.type == BaseChildList#base_child_list.type, X#base_child_act_meet_limit.id == BaseChildList#base_child_list.id] of
                    [] -> [];
                    BaseList ->
                        Base = hd(BaseList),
                        if
                            Base#base_child_act_meet_limit.online_time =< NewBase#base_child_list.online_time andalso NewBase#base_child_list.is_notice == 0 andalso NewBase#base_child_list.end_time >= Now ->
                                {ok, Bin} = pt_438:write(43864, {NewBase#base_child_list.type}),
                                server_send:send_to_sid(Player#player.sid, Bin),
                                [NewBase#base_child_list{is_notice = 1}];
                            true ->
                                [NewBase]
                        end
                end
            end,
            NewChildList = lists:flatmap(F, St#st_act_meet_limit.child_list),
            lib_dict:put(?PROC_STATUS_ACT_MEET_LIMIT, St#st_act_meet_limit{child_list = NewChildList}),
            act_meet_limit:update_list(Player)
%%             activity_load:dbup_player_act_meet_limit(NewChildList)
    end.

logout(_Player) ->
    St = lib_dict:get(?PROC_STATUS_ACT_MEET_LIMIT),
    activity_load:dbup_player_act_meet_limit(St),
    ok.

record_to_lists(ChildList) ->
    F = fun(BaseChild) ->
        {
            BaseChild#base_child_list.type,
            BaseChild#base_child_list.id,
            BaseChild#base_child_list.gold,
            BaseChild#base_child_list.state,
            BaseChild#base_child_list.kill_mon,
            BaseChild#base_child_list.start_time,
            BaseChild#base_child_list.online_time,
            BaseChild#base_child_list.end_time,
            BaseChild#base_child_list.is_notice,
            BaseChild#base_child_list.goods_list
        }
    end,
    lists:map(F, ChildList).

lists_to_record(ChildList) ->
    F = fun({Type, Id, Gold, State, KillMon, StartTime, OnlineTime, EndTime, IsNotice, GoodsList}) ->
        #base_child_list{
            key = {Type, Id},
            type = Type,
            id = Id,
            gold = Gold,
            state = State,
            kill_mon = KillMon,
            start_time = StartTime,
            online_time = OnlineTime,
            end_time = EndTime,
            is_notice = IsNotice,
            goods_list = GoodsList
        }
    end,
    lists:map(F, ChildList).

get_state(_Player) ->
   case get_act() of
        [] -> -1;
        _Base ->
            St = lib_dict:get(?PROC_STATUS_ACT_MEET_LIMIT),
            Now = util:unixtime(),
            F = fun(BaseChild, {State0, Time0}) ->
                if
                    BaseChild#base_child_list.state =/= 2 ->
                        if
                            BaseChild#base_child_list.end_time =/= 0 ->
                                {max(State0, BaseChild#base_child_list.state), max(BaseChild#base_child_list.end_time - Now, Time0)};
                            true ->
                                {max(State0, BaseChild#base_child_list.state), max(0, Time0)}
                        end;
                    true -> {State0, Time0}
                end
            end,
            case lists:foldl(F, {-1, 0}, St#st_act_meet_limit.child_list) of
                {-1, 0} -> -1;
                [] -> -1;
                Other ->
                    {State, Time} = Other,
                    {State, [{time, Time}]}
            end
    end.

%% 刷新激活列表
update_list(Player) ->
    case get_act() of
        [] -> skip;
        #base_act_meet_limit{c_act_list = ChildActList} ->
            St = lib_dict:get(?PROC_STATUS_ACT_MEET_LIMIT),
            TypeList = [X#base_child_act_meet_limit.type || X <- ChildActList, X#base_child_act_meet_limit.id == 1],
            Now = util:unixtime(),
            OpenDay = config:get_open_days(),
            MergeDays = config:get_merge_days(),

            %% 过期活动
            F1 = fun(BaseChildList, {ChildList0, GetList0}) ->
                if
                    BaseChildList#base_child_list.end_time =< Now andalso BaseChildList#base_child_list.end_time =/= 0 ->
                        case lists:keytake(BaseChildList#base_child_list.type, 1, GetList0) of
                            false ->
                                {ChildList0, [{BaseChildList#base_child_list.type, BaseChildList#base_child_list.id} | GetList0]};
                            {value, {Type0, Id0}, T0} ->
                                {ChildList0, [{Type0, max(Id0, BaseChildList#base_child_list.id)} | T0]}
                        end;
                    true ->
                        {[BaseChildList | ChildList0], GetList0}
                end
            end,
            {NewChildList, NewGetList} = lists:foldl(F1, {[], St#st_act_meet_limit.get_list}, St#st_act_meet_limit.child_list),

            F2 = fun({Type0,Id0})->
                case [Id0||{Type1,Id1}<-NewGetList,Type1== Type0,Id1>Id0] of
                     [] ->[{Type0,Id0}];
                        _ ->[]
                end
            end,
            NewGetList0 =  lists:flatmap(F2,NewGetList),

            %% 是有有可激活
            F = fun({Type, Id}) ->
                case lists:keyfind({Type, Id + 1}, #base_child_list.key, NewChildList) of
                    false ->
                        case get_next(Player, ChildActList, Type, Id + 1, OpenDay, MergeDays) of
                            [] -> [];
                            Info -> [Info]
                        end;
                    _ ->
                        []
                end
            end,
            InfoList1 = lists:flatmap(F, NewGetList0),

            %% 是否有新活动
            F0 = fun(Type) ->
                case lists:keyfind(Type, 1, NewGetList) of
                    false ->
                        case lists:keyfind(Type, #base_child_list.type, NewChildList) of
                            false ->
                                case get_next(Player, ChildActList, Type, 1, OpenDay, MergeDays) of
                                    [] -> [];
                                    Info -> [Info]
                                end;
                            _ -> []
                        end;
                    _ -> []
                end
            end,
            InfoList2 = lists:flatmap(F0, TypeList),
            NewSt = St#st_act_meet_limit{child_list = InfoList1 ++ InfoList2 ++ NewChildList, get_list = NewGetList},
            lib_dict:put(?PROC_STATUS_ACT_MEET_LIMIT, NewSt),
%%             activity_load:dbup_player_act_meet_limit(NewSt),
            activity:get_notice(Player, [191], true)
    end.

kill_mon(Player) ->
    case get_act() of
        [] -> [];
        #base_act_meet_limit{c_act_list = ChildActList} ->
            St = lib_dict:get(?PROC_STATUS_ACT_MEET_LIMIT),
            F = fun(BaseChildList) ->
                NewBase = BaseChildList#base_child_list{kill_mon = BaseChildList#base_child_list.kill_mon + 1},
                case [X || X <- ChildActList, X#base_child_act_meet_limit.type == BaseChildList#base_child_list.type, X#base_child_act_meet_limit.id == BaseChildList#base_child_list.id] of
                    [] -> [];
                    BaseList ->
                        Base = hd(BaseList),
                        if
                            Base#base_child_act_meet_limit.kill_mon =< NewBase#base_child_list.kill_mon andalso NewBase#base_child_list.is_notice == 0 ->
                                {ok, Bin} = pt_438:write(43864, {NewBase#base_child_list.type}),
                                server_send:send_to_sid(Player#player.sid, Bin),
                                [NewBase#base_child_list{is_notice = 1}];
                            true ->
                                [NewBase]
                        end
                end
            end,
            NewChildList = lists:flatmap(F, St#st_act_meet_limit.child_list),
            lib_dict:put(?PROC_STATUS_ACT_MEET_LIMIT, St#st_act_meet_limit{child_list = NewChildList})
%%             activity_load:dbup_player_act_meet_limit(NewChildList)
    end.

log_act_meet_limit(Pkey, Nickname, Type, GoodsList) ->
    Sql = io_lib:format("insert into  log_act_meet_limit (pkey, nickname,type,goods_list,time) VALUES(~p,'~s',~p,'~s',~p)",
        [Pkey, Nickname, Type, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.

