%% --------------------------
%% 执行活动流程 
%% @author shawnoyc@vip.qq.com
%% --------------------------

-module(campaign_execute).
-export([
        when_begin/2
        ,when_end/2
        ,when_login/2
        ,when_logout/2
        ,when_charge/3
        ,when_task/3
        ,check_srv/1
        ,check_record/5
]).

-include("common.hrl").
-include("buff.hrl").
-include("campaign.hrl").
-include("role.hrl").
-include("mail.hrl").
-include("vip.hrl").
-include("assets.hrl").

-define(vip_any,       100). %%  不限制VIP类型 

%% 活动开始时触发
%% @return void()
when_begin(Camp, {_, CampPid}) ->
    NewCamp = check_special(Camp, CampPid),
    case NewCamp#campaign.do_login =:= [] of
        true -> skip;
        false ->
            case role_api:lookup_all_online(by_pid) of
                {error, Reason} -> ?ERR("查询ets_online_role出错:~w", [Reason]);
                {ok, L} -> 
                    lists:foreach(
                        fun([Pid])->
                                role:apply(async, Pid, {campaign_execute, when_login, [NewCamp]});
                            (_) ->
                                skip
                        end, L)
            end
    end.

%% 活动结束时触发
%% @return void()
when_end(_Camp, _DateTime) ->
    ok.

%% 登录游戏时触发
%% @return {ok, #role}
when_login(Role = #role{name = Name, id = {Rid, SrvId}}, Camp = #campaign{id = CampId, mode = Mode, do_login = DoLogin}) ->
    %% 执行Login模块的东西
    NowDay = util:unixtime(today),
    case check_record(Mode, Rid, SrvId, CampId, NowDay) of
        true -> %%可以参加
            role:send_buff_begin(),
            case do_execute(DoLogin, Camp, Role) of
                {normal, _Reason} ->
                    ?DEBUG("Reason:~w",[_Reason]),
                    role:send_buff_flush(),
                    {ok};
                {false, _Reason} ->
                    role:send_buff_clean(),
                    {ok};
                {ok, NewRole} ->
                    Flag = campaign_dao:insert(Rid, SrvId, Name, NowDay, CampId), 
                    role:send_buff_flush(),
                    case Flag of
                        ok -> {ok, NewRole};
                        false -> {ok}
                    end
            end;
        false -> %%不可以参加
            {ok}
    end.

%% 完成任务时触发
%% @return {ok, #role}
when_task(Role = #role{name = Name, id = {Rid, SrvId}}, Camp = #campaign{id = CampId, mode = Mode}, _TaskId) ->
    %% 执行Login模块的东西
    NowDay = util:unixtime(today),
    case check_record(Mode, Rid, SrvId, CampId, NowDay) of
        true -> %%可以参加
            case campaign_dao:insert(Rid, SrvId, Name, NowDay, CampId) of
                ok ->
                    send_item(Role, Camp, [{23018, 1, 1}, {24101, 1, 1}, {24110, 1, 1}]);
                _ ->
                    ok
            end,
            {ok};
        false -> %%不可以参加
            {ok}
    end.

%% 退出游戏时触发
%% @return {ok, #role}
when_logout(Role, _Camp) ->
    {ok, Role}.

%% 充值时触发
%% @return {ok, #role}
when_charge(Role = #role{name = Name, id = {Rid, SrvId}}, Camp = #campaign{id = CampId, mode = Mode, do_charge = DoCharge}, Charge) when Charge > 0 ->
    NowDay = util:unixtime(today),
    NewDoCharge = check_charge(DoCharge, Charge),
    case NewDoCharge =:= [] of
        true ->
            ?DEBUG("无活动可以参加"),
            {ok};
        false ->
            case check_record(Mode, Rid, SrvId, CampId, NowDay) of
                true -> %% 可以参加
                    role:send_buff_begin(),
                    case do_execute(NewDoCharge, Camp, Role, Charge) of
                        {normal, _Reason} ->
                            ?DEBUG("Reason:~w",[_Reason]),
                            role:send_buff_flush(),
                            {ok};
                        {false, _Reason} ->
                            ?ERR("Rid:~w,SrvId:~s充值领取发送礼包出错,原因:~w",[Rid, SrvId, _Reason]),
                            role:send_buff_clean(),
                            {ok};
                        {ok, NewRole} ->
                            Flag = campaign_dao:insert(Rid, SrvId, Name, NowDay, CampId),
                            role:send_buff_flush(),
                            case Flag of
                                ok -> {ok, NewRole};
                                false ->
                                    ?ERR("插入活动日志失败"),
                                    {ok}
                            end
                    end;
                false -> %% 已经参加过
                    {ok}
            end
    end;
when_charge(_Role, _Camp, _Charge) ->
    {ok}.

%% ------------内部函数-------------
%% 
%% 检查符合参加的充值活动
ratio_list(Ratio, BaseList) ->
    ratio_list(Ratio, BaseList, []).
ratio_list(_Ratio, [], NewBaseList) -> NewBaseList;
ratio_list(Ratio, [{BaseId, Num} | T], NewBaseList) ->
    ratio_list(Ratio, T, [{BaseId, Num * Ratio} | NewBaseList]).

check_charge(DoCharge, Charge) ->
    check_charge(DoCharge, Charge, []).
check_charge([], _Charge, NewDoCharge) -> NewDoCharge;
check_charge([{Type, Args} | T], Charge, NewDoCharge) ->
    case do_check_charge(Type, Args, Charge) of
        [] -> check_charge(T, Charge, NewDoCharge);
        {Type, L} -> check_charge(T, Charge, [{Type, L} | NewDoCharge])
    end.
do_check_charge(Type, Args, Charge) ->
    case do_check_charge(Type, Args, Charge, []) of
        [] -> [];
        L -> {Type, L}
    end.

do_check_charge(item, [], _Charge, NewArgs) -> NewArgs;
do_check_charge(item, [{round_charge, RoundLine, BaseList} | T], Charge, NewArgs) ->
    case Charge >= RoundLine of
        true ->
            NewRatio =  Charge div RoundLine,
            NewBaseList = ratio_list(NewRatio, BaseList),
            do_check_charge(item, T, Charge, [{round_charge, RoundLine, NewBaseList} | NewArgs]);
        false ->
            do_check_charge(item, T, Charge, NewArgs)
    end;
do_check_charge(item, [{single_charge_2, LastLine, BaseList} | T], Charge, NewArgs) ->
    case Charge >= LastLine of
        true ->
            do_check_charge(item, T, Charge, [{single_charge_2, LastLine, BaseList} | NewArgs]);
        false ->
            do_check_charge(item, T, Charge, NewArgs)
    end;
do_check_charge(item, [{single_charge_2, Line1, Line2, BaseList} | T], Charge, NewArgs) ->
    case Charge >= Line1 andalso Charge =< Line2 of
        true -> 
            do_check_charge(item, T, Charge, [{single_charge_2, Line1, Line2, BaseList} | NewArgs]);
        false ->
            do_check_charge(item, T, Charge, NewArgs)
    end;
do_check_charge(item, [{single_charge, LastLine, BaseList} | T], Charge, NewArgs) ->
    case Charge >= LastLine of
        true -> 
            do_check_charge(item, T, Charge, [{single_charge, LastLine, BaseList} | NewArgs]);
        false ->
            do_check_charge(item, T, Charge, NewArgs)
    end;
do_check_charge(item, [{single_charge, Line1, Line2, BaseList} | T], Charge, NewArgs) ->
    case Charge >= Line1 andalso Charge =< Line2 of
        true -> 
            do_check_charge(item, T, Charge, [{single_charge, Line1, Line2, BaseList} | NewArgs]);
        false ->
            do_check_charge(item, T, Charge, NewArgs)
    end;
do_check_charge(item, [L | T], Charge, NewArgs) ->
    do_check_charge(item, T, Charge, [L | NewArgs]).


%% 检查特殊的活动
check_special(Camp = #campaign{do_begin = DoBegin}, CampPid) ->
    case lists:keyfind(special, 1, DoBegin) of
        {special, Data} -> 
            case util:datetime_to_seconds(Camp#campaign.end_time) of
                false ->
                    ?ERR("活动日期时间设置错误");
                EndTime ->
                    ?DEBUG("Data:~w, EndTime:~w",[Data, EndTime]),
                    CampPid ! {special, Data, EndTime}
            end,
            Camp#campaign{do_begin = lists:keydelete(special, 1, DoBegin)};
        false -> Camp
    end.

check_record(?ONLYONE, Rid, SrvId, CampId, _Time) ->
    case campaign_dao:has_record(Rid, SrvId, CampId) of
        true -> false;
        false -> true
    end;

check_record(?EVERYDAY, Rid, SrvId, CampId, Time) ->
    case campaign_dao:has_record(Rid, SrvId, CampId, Time) of
        true -> false;
        false -> true
    end.

do_execute(DoLogin, Camp, Role) ->
    do_execute(DoLogin, Camp, Role, 0).

do_execute([], _, Role, _Charge) -> {ok, Role};
do_execute([{Type, Args} | T], Camp, Role, Charge) ->
    case execute(Type, Args, Camp, Role, Charge) of
        {false, _Reason} -> {false, _Reason};
        {normal, Reason} -> {normal, Reason};
        {skip, NewRole} -> do_execute(T, Camp, NewRole, Charge);
        {ok, NewRole} -> do_execute(T, Camp, NewRole, Charge)
    end.

execute(buff, {BuffLabel, Duration}, #campaign{end_time = EndTime}, Role, _CurCharge) ->
    {ok, BuffBase} = buff_data:get(BuffLabel),
    case buff:add(Role, BuffBase#buff{duration = Duration, end_date = EndTime}) of
        {false, _R} -> {false, _R};
        {ok, NewRole} -> {ok, NewRole}
    end;

execute(item, [], _, Role, _CurCharge) -> {skip, Role};
execute(item, [{srv, 1, List} | T], Camp, Role = #role{id = {_, SrvId}, lev = Lev}, _CurCharge) ->
    case check_srv(SrvId) =:= 1 of
        true ->
            case Lev >= 40 of
                true ->
                    Items = make_list(List, []),
                    case send_item(Role, Camp, Items) of
                        {false, Reason} -> {false, Reason};
                        ok -> execute(item, T, Camp, Role, _CurCharge)
                    end;
                false -> {normal, ?L(<<"等级不足,不算参与">>)}
            end;
        false -> execute(item, T, Camp, Role, _CurCharge)
    end;

execute(item, [{srv, 2, List} | T], Camp, Role = #role{id = {_, SrvId}, lev = Lev}, _CurCharge) ->
    case check_srv(SrvId) =:= 2 of
        true ->
            case Lev >= 40 of
                true ->
                    Items = make_list(List, []),
                    case send_item(Role, Camp, Items) of
                        {false, Reason} -> {false, Reason};
                        ok -> execute(item, T, Camp, Role, _CurCharge)
                    end;
                false -> {normal, ?L(<<"等级不足,不算参与">>)}
            end;
        false -> execute(item, T, Camp, Role, _CurCharge)
    end;

execute(item, [{normal, List} | T], Camp, Role = #role{lev = Lev}, _CurCharge) ->
    case Lev >= 40 of
        true ->
            Items = make_list(List, []),
            case send_item(Role, Camp, Items) of
                {false, Reason} -> {false, Reason};
                ok -> execute(item, T, Camp, Role, _CurCharge)
            end;
        false -> {normal, ?L(<<"等级不足,不算参与">>)}
    end;

execute(item, [{normal45, List} | T], Camp, Role = #role{lev = Lev}, _CurCharge) ->
    case Lev >= 45 of
        true ->
            Items = make_list(List, []),
            case send_item(Role, Camp, Items) of
                {false, Reason} -> {false, Reason};
                ok -> execute(item, T, Camp, Role, _CurCharge)
            end;
        false -> {normal, ?L(<<"等级不足,不算参与">>)}
    end;

execute(item, [{vip, _, _} | _T], _Camp, _Role = #role{vip = #vip{type = ?vip_no}}, _CurCharge) ->
    {normal, ?L(<<"非VIP,不算参与活动">>)};
execute(item, [{vip, VipType, BaseIdList} | T], Camp, Role = #role{vip = #vip{type = VipType}}, _CurCharge) ->
    Items = make_list(BaseIdList, []),
    case send_item(Role, Camp, Items) of
        {false, Reason} -> {false, Reason};
        ok -> execute(item, T, Camp, Role, _CurCharge)
    end;
execute(item, [{charge, BaseId, Bind, Quantity} | T], Camp, Role = #role{assets = #assets{charge = Charge}, lev = Lev}, _CurCharge) when Charge > 0 ->
    case Lev >= 40 of
        true ->
            case send_item(Role, Camp, {BaseId, Bind, Quantity}) of
                {false, Reason} -> {false, Reason};
                ok -> execute(item, T, Camp, Role, _CurCharge)
            end;
        false -> {normal, ?L(<<"等级不足,不算参与">>)}
    end;

execute(item, [{charge_no, BaseId, Bind, Quantity} | T], Camp, Role = #role{assets = #assets{charge = 0}, lev = Lev}, _CurCharge) ->
    case Lev >= 40 of
        true ->
            case send_item(Role, Camp, {BaseId, Bind, Quantity}) of
                {false, Reason} -> {false, Reason};
                ok -> execute(item, T, Camp, Role, _CurCharge)
            end;
        false -> {normal, ?L(<<"等级不足, 不算参与">>)}
    end;

execute(item, [{round_charge, _Round, List} | _T], Camp, Role, _CurCharge) ->
    Items= make_list(List, []),
    case send_item(Role, Camp, Items) of
        {false, Reason} -> {false, Reason};
        ok -> {normal, ?L(<<"可重复参加的活动">>)} 
    end;
execute(item, [{do_charge, BaseId, Bind, Quantity} | T], Camp, Role, _CurCharge) ->
    case send_item(Role, Camp, {BaseId, Bind, Quantity}) of
        {false, Reason} ->
            {false, Reason};
        ok -> execute(item, T, Camp, Role, _CurCharge)
    end;
execute(item, [{do_charge_line, Line, List} | T], Camp, Role, _CurCharge) ->
    case calc_role_charge(day, Role, Line, Camp#campaign.begin_time, Camp#campaign.end_time) of
        true ->
            Items = make_list(List, []),
            case send_item(Role, Camp, Items) of
                {false, Reason} -> {false, Reason};
                ok -> execute(item, T, Camp, Role, _CurCharge)
            end;
        false -> {normal, ?L(<<"未达到条件">>)}
    end;
execute(item, [{do_charge_line_all, Line, List} | T], Camp, Role = #role{career = Career}, Charge) ->
    case calc_role_charge(all, Role, Line, Camp#campaign.begin_time, Camp#campaign.end_time) of
        true ->
            Items = make_list(List, Career, []),
            case send_item(Role, Camp, Items) of
                {false, Reason} -> {false, Reason};
                ok -> execute(item, T, Camp, Role, Charge)
            end;
        false ->
            case Charge >= Line of
                true ->
                    Items = make_list(List, Career, []),
                    case send_item(Role, Camp, Items) of
                        {false, Reason} -> {false, Reason};
                        ok -> execute(item, T, Camp, Role, Charge)
                    end;
                _ ->
                    {normal, ?L(<<"未达到条件">>)}
            end
    end;

execute(item, [{single_charge, _, BaseList} | _T], Camp, Role, _CurCharge) ->
    Items = make_list(BaseList, []),
    case send_item(Role, Camp, Items) of
        {false, Reason} -> {false, Reason};
        ok -> {normal, ?L(<<"可重复参加类活动">>)}
    end;
execute(item, [{single_charge, _, _, BaseList} | _T], Camp, Role, _CurCharge) ->
    Items = make_list(BaseList, []),
    case send_item(Role, Camp, Items) of
        {false, Reason} -> {false, Reason};
        ok -> {normal, ?L(<<"可重复参加的活动">>)}
    end;
execute(item, [{single_charge_2, _, BaseList} | T], Camp, Role, _CurCharge) ->
    Items = make_list(BaseList, []),
    case send_item(Role, Camp, Items) of
        {false, Reason} -> {false, Reason};
        ok -> execute(item, T, Camp, Role, _CurCharge) 
    end;
execute(item, [{single_charge_2, _, _, BaseList} | T], Camp, Role, _CurCharge) ->
    Items = make_list(BaseList, []),
    case send_item(Role, Camp, Items) of
        {false, Reason} -> {false, Reason};
        ok -> execute(item, T, Camp, Role, _CurCharge)
    end;
execute(item, [{_, _, _} | T], Camp, Role, _CurCharge) ->
    execute(item, T, Camp, Role, _CurCharge);
execute(item, [{_, _, _, _} | T], Camp, Role, _CurCharge) ->
    execute(item, T, Camp, Role, _CurCharge);

execute(gold, 0, _, Role, _CurCharge) -> {skip, Role};
execute(gold, Num, Camp, Role, _CurCharge) ->
    case send_assets(Role, Camp, [{?mail_gold, Num}]) of
        {false, Reason} -> {false, Reason};
        ok -> {ok, Role}
    end;
execute(lilian, Val, Camp, Role = #role{lev = Lev}, _CurCharge) ->
    case Lev >= 55 of
        true ->
            case send_assets(Role, Camp, [{?mail_lilian, Val}]) of
                {false, Reason} -> {false, Reason};
                ok -> {ok, Role}
            end;
        false ->
            {normal, ?L(<<"等级不足, 不算参与">>)}
    end;

execute(_Label, _Args, _Camp, Role, _CurCharge) ->
    ?ELOG("不存在的活动数据:~p,~w", [_Label, _Args]),
    {skip, Role}.

check_srv(SrvId) ->
    [SrvSn | _] = lists:reverse(re:split(bitstring_to_list(SrvId), "_", [{return, list}])),
    List = lists:sort(get_srv_list()),
    Num = do_check_srv(list_to_integer(SrvSn), List),
    case Num =:= 0 of
        true -> 0;
        false -> 
            case length(List) div Num >= 2 of
                true -> 1;
                false -> 2
            end
    end.

do_check_srv(SrvSn, List) ->
    do_check_srv(SrvSn, List, 0).
do_check_srv(_SrvSn, [], _Num) -> 0;
do_check_srv(SrvSn, [SrvSn | _], Num) -> Num + 1;
do_check_srv(SrvSn, [_ | T], Num) ->
    do_check_srv(SrvSn, T, Num + 1).

get_srv_list() ->
    SrvList = sys_env:get(srv_ids),
    do_get_srv(SrvList).

do_get_srv(SrvList) ->
    do_get_srv(SrvList, []).
do_get_srv([], SrvNumList) -> SrvNumList;
do_get_srv([SrvId | T], SrvNumList) ->
    [SrvSn | _] = lists:reverse(re:split(SrvId, "_", [{return, list}])),
    do_get_srv(T, [list_to_integer(SrvSn) | SrvNumList]).

send_assets(Role, Camp, Assets) ->
    mail_mgr:deliver(Role, {Camp#campaign.title, Camp#campaign.desc, Assets, []}),
    ok.
    %% case mail:send_system(Role, {Camp#campaign.title, Camp#campaign.desc, Assets, []}) of
    %%     ok -> ok;
    %%     {false, _R} ->
    %%         ?ERR("活动赠送资产发送邮件失败:~w,原因:~s",[Assets, _R]),
    %%         {false, ?L(<<"赠送礼物失败">>)}
    %% end.

send_item(Role, Camp, ItemList) when is_list(ItemList) andalso length(ItemList) > 10 -> 
    {SendItems, LeftItems} = lists:split(5, ItemList),
    send_item(Role, Camp, SendItems),
    send_item(Role, Camp, LeftItems);
send_item(Role, Camp, ItemList) when is_list(ItemList) -> 
    mail_mgr:deliver(Role, {Camp#campaign.title, Camp#campaign.desc, [], ItemList}),
    ok;
    %% case mail:send_system(Role, {Camp#campaign.title, Camp#campaign.desc,
    %%             [], ItemList}) of
    %%     ok -> ok;
    %%     {false, _R} ->
    %%         ?ERR("活动赠送发送邮件失败,原因:~s",[_R]),
    %%         {false, ?L(<<"赠送礼物失败">>)}
    %% end;

send_item(Role, Camp, {BaseId, Bind, Quantity}) ->
    mail_mgr:deliver(Role, {Camp#campaign.title, Camp#campaign.desc, [], [{BaseId, Bind, Quantity}]}),
    ok.
    %% case mail:send_system(Role, {Camp#campaign.title, Camp#campaign.desc,
    %%             [], {BaseId, Bind, Quantity}}) of
    %%     ok -> ok;
    %%     {false, _R} ->
    %%         ?ERR("活动赠送发送邮件失败,原因:~s",[_R]),
    %%         {false, ?L(<<"赠送礼物失败">>)}
    %% end.

calc_role_charge(day, #role{id = {Rid, SrvId}}, Line, BeginTime, EndTime) ->
    Now = util:unixtime(),
    NowDay = util:unixtime(today) - 30,
    TmrDay = util:unixtime(today) + 86430,
    Begin = util:datetime_to_seconds(BeginTime),
    End = util:datetime_to_seconds(EndTime),
    Charge = campaign_dao:calc_charge(Rid, SrvId, NowDay, TmrDay),
    ?DEBUG("Charge:~w",[Charge]),
    case Now >= Begin andalso Now =< End of
        true ->
            case Charge >= Line of
                true -> true;
                false -> false
            end;
        false -> false
    end;
calc_role_charge(all, #role{id = {Rid, SrvId}}, Line, BeginTime, EndTime) ->
    Now = util:unixtime(),
    Begin = util:datetime_to_seconds(BeginTime),
    End = util:datetime_to_seconds(EndTime),
    Charge = campaign_dao:calc_charge(Rid, SrvId, Begin, End),
    ?DEBUG("All_Charge:~w",[Charge]),
    case Now >= Begin andalso Now =< End of
        true ->
            case Charge >= Line of
                true -> true;
                false -> false
            end;
        false -> false
    end.

make_list([], Items) -> Items;
make_list([{BaseId, Num} | T], Items) ->
    case item:make(BaseId, 1, Num) of
        false -> make_list(T, Items);
        {ok, MakeItems} ->
            make_list(T, MakeItems ++ Items)
    end.

make_list([], _Career, Items) -> Items;
make_list([{BaseId, Num} | T], Career, Items) ->
    case item:make(BaseId, 1, Num) of
        false -> make_list(T, Career, Items);
        {ok, MakeItems} ->
            make_list(T, Career, MakeItems ++ Items)
    end;
make_list([{BaseId, Num, Career} | T], Career, Items) ->
    case item:make(BaseId, 1, Num) of
        false -> make_list(T, Career, Items);
        {ok, MakeItems} ->
            make_list(T, Career, MakeItems ++ Items)
    end;
make_list([_ | T], Career, Items) ->
    make_list(T, Career, Items).
