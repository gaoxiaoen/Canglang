%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 百倍返利
%%% @end
%%% Created : 10. 五月 2017 15:07
%%%-------------------------------------------------------------------
-module(hundred_return).
-author("Administrator").
-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").
%% API
-export([
    notice/2
    , init/1
    , update/1
    , get_hundred_return_info/0
    , bug_hundred_return/1
    , get_state/1
    , rehr/1
]).

init(Player) ->
    StHundredRe = activity_load:dbget_hundred_return(Player),
    put_dict(StHundredRe),
    update(Player),
    Player.

update(Player) ->
    HundredReSt = get_dict(Player),
    #st_hundred_return{
        act_id = ActId
    } = HundredReSt,
    NewHundredReStSt =
        case activity:get_work_list(data_hundred_return) of
            [] -> HundredReSt;
            [Base | _] ->
                case Base#base_hundred_return.act_id == ActId of
                    false ->
                        HundredReSt;
                    true ->
                        HundredReSt#st_hundred_return{
                            act_id = Base#base_hundred_return.act_id,
                            state = 0
                        }
                end
        end,
    put_dict(NewHundredReStSt),
    ok.

get_hundred_return_info() ->
    AccHundredSt = lib_dict:get(?PROC_STATUS_HUNDRED_RETURN),
    ActList = activity:get_work_list(data_hundred_return),
    #st_hundred_return{
        state = State
    } = AccHundredSt,
    case ActList of
        [] -> {0, 0, 0, 0, []};  %%没有活动
        [Base | _] ->
            #base_hundred_return{
                cost = Cost,
                value = Value,
                get_list = GetList
            } = Base,
            %%计算活动剩余时间
            LeaveTime = get_leave_time(),
            {LeaveTime, State, Cost, Value, goods:pack_goods(GetList)}
    end.

bug_hundred_return(Player) ->
    case check_hundred_return(Player) of
        {false, Res} -> {false, Res};
        {ok, Cost, GetList, AccHundredSt} ->
            NewPlayer = money:add_no_bind_gold(Player, -Cost, 261, 0, 0),
            Goodslist = goods:make_give_goods_list(261, GetList),
            NewAccHundredSt = AccHundredSt#st_hundred_return{state = 1},
            put_dict(NewAccHundredSt),
            activity_log:log_get_goods(GetList, Player#player.key, Player#player.nickname, 261),
            activity_load:dbup_hundred_return(NewAccHundredSt),
            activity:get_notice(Player, [113], true),
            Content = io_lib:format(t_tv:get(206), [t_tv:pn(Player)]),
            notice:add_sys_notice(Content, 206),
            {ok, NewPlayer1} = goods:give_goods(NewPlayer, Goodslist),
            {ok, NewPlayer1}
    end.

check_hundred_return(Player) ->
    AccHundredSt = lib_dict:get(?PROC_STATUS_HUNDRED_RETURN),
    ActList = activity:get_work_list(data_hundred_return),
    #st_hundred_return{
        state = State
    } = AccHundredSt,
    if
        State =/= 0 ->
            {false, 14};
        true ->
            case ActList of
                [] ->
                    {false, 0};  %%没有活动
                [Base | _] ->
                    #base_hundred_return{
                        cost = Cost,
                        get_list = GetList
                    } = Base,
                    case money:is_enough(Player, Cost, gold) of
                        false ->
                            {false, 5};
                        true ->
                            {ok, Cost, GetList, AccHundredSt}
                    end
            end
    end.

get_leave_time() ->
    ActList = activity:get_work_list(data_hundred_return),
    case ActList of
        [] -> -1;
        [Base | _] ->
            activity:calc_act_leave_time(Base#base_hundred_return.open_info)
    end.


notice(Player, Lv) ->
    State = hundred_return:get_state(Player),
    if
        Lv == 29 ->
            if
                State == -1 -> skip;
                true ->
                    activity:get_notice(Player, [113], true),
                    {ok, Bin} = pt_432:write(43282, {1}),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end;
        true ->
            ok
    end.

get_dict(Player) ->
    case lib_dict:get(?PROC_STATUS_HUNDRED_RETURN) of
        St when is_record(St, st_hundred_return) ->
            St;
        _ ->
            init(Player),
            get_dict(Player)
    end.

put_dict(HundredReStSt) ->
    lib_dict:put(?PROC_STATUS_HUNDRED_RETURN, HundredReStSt).

get_state(Player) ->
    LeaveTime = get_leave_time(),
    AccHundredSt = lib_dict:get(?PROC_STATUS_HUNDRED_RETURN),
    #st_hundred_return{
        state = State
    } = AccHundredSt,
    Check =
        case check_hundred_return(Player) of
            {false, _} -> false;
            _ -> true
        end,
    if
        LeaveTime =< 0 -> -1;
        State == 1 -> -1;
        Check -> 1;
        true -> 0
    end.

rehr(Player) ->
    St = get_dict(Player),
    put_dict(St#st_hundred_return{state = 0}),
    ok.
