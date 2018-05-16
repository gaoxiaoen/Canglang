%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 五月 2016 上午10:45
%%%-------------------------------------------------------------------
-module(daily_fir_charge_return).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    update/0,
    add_charge_val/3,
    get_return_info/0,
    get_state/1
]).

init(Player) ->
    DFChargeReturnSt = activity_load:dbget_d_fir_charge_return(Player),
    lib_dict:put(?PROC_STATUS_D_F_CHARGE_RETURN, DFChargeReturnSt),
    update(),
    Player.

update() ->
    DFChargeReturnSt = lib_dict:get(?PROC_STATUS_D_F_CHARGE_RETURN),
    #st_d_f_charge_return{
        get_time = GetTime
    } = DFChargeReturnSt,
    Now = util:unixtime(),
    NewDFChargeReturnSt =
        case util:is_same_date(Now, GetTime) of
            true -> DFChargeReturnSt;
            false ->
                DFChargeReturnSt#st_d_f_charge_return{
                    get_time = 0
                }
        end,
    lib_dict:put(?PROC_STATUS_D_F_CHARGE_RETURN, NewDFChargeReturnSt),
    ok.

add_charge_val(Player, ChargeGold, ChargePrice) ->
    case activity:get_work_list(data_daily_fir_charge_return) of
        [] -> skip;
        [Base | _] ->
            #base_d_f_charge_return{
                min_charge = MinCharge,
                pro = Pro
            } = Base,
            case ChargeGold > MinCharge of
                false -> skip;
                true ->
                    Now = util:unixtime(),
                    DFChargeReturnSt = lib_dict:get(?PROC_STATUS_D_F_CHARGE_RETURN),
                    #st_d_f_charge_return{
                        get_time = GetTime
                    } = DFChargeReturnSt,
                    case util:is_same_date(Now, GetTime) of
                        true ->
                            skip; %%今天已领取
                        false ->
                            NewDFChargeReturnSt =
                                DFChargeReturnSt#st_d_f_charge_return{
                                    get_time = Now
                                },
                            lib_dict:put(?PROC_STATUS_D_F_CHARGE_RETURN, NewDFChargeReturnSt),
                            activity_load:dbup_d_fir_charge_return(NewDFChargeReturnSt),
                            GetGold = round(ChargeGold * Pro / 100),
                            Title = ?T("每日充值返钻"),
                            Content = io_lib:format(?T("您充值了~p元，获得元宝返还~p钻"), [ChargePrice, GetGold]),
                            notice_sys:add_notice(fir_charge_return, Player),
                            mail:sys_send_mail([Player#player.key], Title, Content, [{10199, GetGold}])
                    end
            end
    end.

%%获取翻钻信息 返回{最低充值元宝,返还比例}
get_return_info() ->
    case activity:get_work_list(data_daily_fir_charge_return) of
        [] -> {0, 0};
        [Base | _] ->
            #base_d_f_charge_return{
                min_charge = MinCharge,
                pro = Pro
            } = Base,
            {MinCharge, Pro}
    end.

get_state(_Player) ->
    case activity:get_work_list(data_daily_fir_charge_return) of
        [] -> -1;
        [Base | _] ->
            Args = activity:get_base_state(Base#base_d_f_charge_return.act_info),
            {0, Args}
    end.