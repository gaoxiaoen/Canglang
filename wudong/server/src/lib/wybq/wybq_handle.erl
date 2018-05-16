%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 三月 2017 16:40
%%%-------------------------------------------------------------------
-module(wybq_handle).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("wybq.hrl").

%% API
-export([
    handle_cast/2, handle_info/2, handle_call/3
]).

handle_cast({update_ets, StWybq}, State) ->
    Min100Cbp = State#wybq_state.min_100_cbp,
    Cbp = StWybq#st_wybq.cbp,
    if
        Cbp < Min100Cbp -> ok;
        true ->
            update_ets(StWybq),
            {noreply, State}
    end;

handle_cast({get_data, StWybq, Player}, State) ->
    UpdateTime = State#wybq_state.update_time,
    Now = util:unixtime(),
    if
        Now - UpdateTime > 300  -> NewState = cacl_state();
        true -> NewState = State
    end,
%%     ?DEBUG("State: ~p~n", [NewState]),
    spawn(fun() -> send_to_client(Player, StWybq, NewState) end),
    {noreply, NewState};

handle_cast({compare, StWybq, Player, OtherKey}, State) ->
    spawn(fun() -> compare(StWybq, Player, OtherKey) end),
    {noreply, State};

handle_cast(_, _State) ->
    ok.

handle_call(_, _, _State) ->
    ok.

handle_info(_, _State) ->
    ok.

update_ets(StWybq) ->
    EtsSysWybq =
        #ets_sys_wybq{
            pkey = StWybq#st_wybq.pkey,
            cbp = StWybq#st_wybq.cbp,
            cbp_list = StWybq#st_wybq.cbp_list,
            lv = StWybq#st_wybq.lv
        },
    ets:insert(?ETS_SYS_WYBQ, EtsSysWybq),
    ok.

cacl_state() ->
    List = ets:tab2list(?ETS_SYS_WYBQ),
    F = fun(#ets_sys_wybq{cbp = Cbp1}, #ets_sys_wybq{cbp = Cbp2}) ->
        Cbp1 > Cbp2
    end,
    NList = lists:sort(F, List),
    Len = length(NList),
    if
        Len < ?WYBQ_TOTAL_NUM ->
            NewList = NList,
            ClearList = [];
        true ->
            NewList = lists:sublist(NList, 1, ?WYBQ_TOTAL_NUM),
            ClearList = lists:sublist(NList, ?WYBQ_TOTAL_NUM+1, Len)
    end,
    if
        Len > ?WYBQ_TOTAL_NUM + 30 ->
            spawn(fun() -> clear(ClearList) end);
        true -> ok
    end,
    Ets = lists:last(NewList),
    {TotaCbpList, TotalLv} = cacl_cbp_lv_list(NewList),
    #wybq_state{
        min_100_cbp = Ets#ets_sys_wybq.cbp,
        update_time = util:unixtime(),
        total_cbp_list = TotaCbpList,
        lv = TotalLv
    }.

cacl_cbp_lv_list(EtsSysWybqList) ->
    Len = length(EtsSysWybqList),
    F = fun(Type) ->
        F1 = fun(#ets_sys_wybq{cbp_list = CbpList}, AccCbp) ->
            case lists:keyfind(Type, 1, CbpList) of
                false ->
                    AccCbp;
                {Type, Cbp} ->
                    AccCbp + Cbp
            end
        end,
        TotalCbp = lists:foldl(F1, 0, EtsSysWybqList),
        {Type, round(TotalCbp / Len)}
    end,
    TotaCbpList = lists:map(F, data_wybq:get_all()),
    F2 = fun(#ets_sys_wybq{lv = Lv}) -> Lv end,
    TotalLv = lists:sum(lists:map(F2, EtsSysWybqList)) div Len,
    {TotaCbpList, TotalLv}.

clear(ClearList) ->
    F = fun(Ets) ->
        ets:delete_object(?ETS_SYS_WYBQ, Ets)
    end,
    lists:map(F, ClearList).

cbp_compare(Player) ->
    Percent = shadow_proc:cbp_percent(Player#player.cbp),
    {Player#player.cbp, Percent}.

send_to_client(#player{key = Pkey} = Player, StWybq, State) ->
    TotalCbpList = State#wybq_state.total_cbp_list,
    F = fun({Type, Cbp}, {AccList, AccScore, SysAccScore}) ->
        #base_wybq{percent = Percent} = data_wybq:get(Type),
        case lists:keyfind(Type, 1, TotalCbpList) of
            false ->
                {Type, 0, SysAccScore};
            {Type, SysCbp} ->
                %% 超出期望值给满分100
                if
                    SysCbp == 0 orelse Cbp == 0 ->
                        SysSS = 0,
                        S = 0; %% 系统无人达到给0分
                    true ->
                        SysSS = 100,
                        S = min(round(Cbp/SysCbp*100), 100)
                end,
                {[{Type, Cbp, get_type(S)} | AccList], AccScore + S * Percent, SysAccScore + SysSS * Percent}
        end
    end,
    {MyList, TotalScore, SysTotalScore} = lists:foldl(F, {[], 0, 0}, StWybq#st_wybq.cbp_list),
    SysScore = max(round(SysTotalScore / 10000), 1),
    MyScore0 = round(TotalScore / 10000),
    MyScore = min(round(MyScore0 / SysScore * 100), 100),
    ?DEBUG("SysScore:~p MyScore:~p~n", [SysScore, MyScore0]),
    {PlayerCbp, SnPercent} = cbp_compare(Player),
    TotalNum = length(MyList),
    SysList = State#wybq_state.total_cbp_list,
    ScoreType = get_type(MyScore),
    F2 = fun({_Type, _Cbp, SType}, {AccNum1, AccNum2, AccNum3}) ->
        case SType of
            5 ->
                {AccNum1+1, AccNum2, AccNum3};
            4 ->
                {AccNum1+1, AccNum2, AccNum3};
            3 ->
                {AccNum1, AccNum2+1, AccNum3};
            2 ->
                {AccNum1, AccNum2, AccNum3+1};
            1 ->
                {AccNum1, AccNum2, AccNum3+1}
        end
    end,
    {Num1, Num2, Num3} = lists:foldl(F2, {0, 0, 0}, MyList),
    ProtoMylist = lists:map(fun(T) -> tuple_to_list(T) end, MyList),
    ProtoSyslist = lists:map(fun(T) -> tuple_to_list(T) end, SysList),
    {ok, Bin} = pt_434:write(43401, {PlayerCbp, SnPercent, TotalNum, Num1, Num2, Num3, ScoreType, Player#player.lv, State#wybq_state.lv, ProtoSyslist, ProtoMylist}),
    server_send:send_to_key(Pkey, Bin),
    ok.

get_type(MyScore) ->
    if
        MyScore >= 90 -> 1; %% S级
        MyScore >= 75 -> 2; %% A级
        MyScore >= 60 -> 3; %% B级
        MyScore >= 40 -> 4; %% C级
        true -> 5 %% D级
    end.

compare(StWybq, Player, OtherKey) ->
    CbpList1 = lists:map(fun(T) -> tuple_to_list(T) end, StWybq#st_wybq.cbp_list),
    case wybq_load:get_by_key(OtherKey) of
        {NickName, Career, Sex, Cbp, Lv, CbpList} ->
            CbpList2 = lists:map(fun(T) -> tuple_to_list(T) end, CbpList),
            Avatar = player_load:dbget_player_avatar(OtherKey),
            {ok, Bin} = pt_434:write(43402, {NickName, Career, Sex, Cbp, Lv, Avatar, CbpList1, CbpList2}),
            server_send:send_to_sid(Player#player.sid, Bin);
        _ ->
            ?ERR("no player pkey:~p~n", [OtherKey])
    end.