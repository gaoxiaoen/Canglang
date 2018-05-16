%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 充值多倍
%%% @end
%%% Created : 04. 七月 2016 下午3:52
%%%-------------------------------------------------------------------
-module(charge_mul).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").

%% API
-export([
    get_info/1,
    get_charge_mul/1,
    get_state/1
]).

get_info(Player) ->
    case activity:get_work_list(data_charge_mul) of
        [] -> skip;
        [Base | _] ->
            #base_charge_mul{
                open_info = OpenInfo,
                charge_list = ChargeList
            } = Base,
            LeaveTime = activity:calc_act_leave_time(OpenInfo),
            Data = {LeaveTime, [tuple_to_list(Info) || Info <- ChargeList]},
            {ok, Bin} = pt_432:write(43211, Data),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.

get_charge_mul(PayGold) ->
    case activity:get_work_list(data_charge_mul) of
        [] -> 0;
        [Base | _] ->
            get_charge_mul_1(Base#base_charge_mul.charge_list, PayGold)
    end.
get_charge_mul_1([], _PayGold) -> 0;
get_charge_mul_1([{Min, Max, Mul} | Tail], PayGold) ->
    case PayGold >= Min andalso PayGold =< Max of
        true -> Mul;
        false -> get_charge_mul_1(Tail, PayGold)
    end.

get_state(_Player) ->
    case activity:get_work_list(data_charge_mul) of
        [] -> -1;
        [Base | _] ->
            Args = activity:get_base_state(Base#base_charge_mul.act_info),
            {0, Args}
    end.