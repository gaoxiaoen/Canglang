%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十一月 2015 下午8:17
%%%-------------------------------------------------------------------
-module(sign_in).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("sign_in.hrl").
-include("daily.hrl").
-include("tips.hrl").
%% API
-export([
    get_sign_in_info/1,
    sign_in/1,
    get_state/1,
    acc_reward/2,

    check_sign_in_state/1,
    check_acc_reward_state/1
]).

-export([cmd_sign_in/2]).

check_sign_in_state(_Player) ->
    case check_sign_in() of
        {false, _Res} ->
            #tips{};
        {ok, _Today, _SignInSt} ->
            AccCharge = daily:get_count(?DAILY_CHARGE_ACC),
            ?IF_ELSE(AccCharge > 0, #tips{state = 1}, #tips{})
    end.

get_sign_in_info(Player) ->
    SignInSt = lib_dict:get(?PROC_STATUS_SIGN_IN),
    #st_sign_in{
        days = AccDays,
        sign_in = SignIn,
        acc_reward = AccReward
%%        time = Time
    } = SignInSt,
    Now = util:unixtime(),
    MonthDays = util:get_month_days(Now),
    Today = util:get_days(Now),
    F = fun(Days) ->
        SignInState =
            if Today < Days -> 0;
                Today == Days ->
                    case lists:keyfind(Days, 1, SignIn) of
                        false -> 1;
                        {_, Times} ->
                            if Times >= 2 -> 2;
                                true ->
                                    4
%%                                    ?IF_ELSE(daily:get_count(?DAILY_CHARGE_ACC) > 0, 1, 4)
                            end
                    end;
                true ->
                    case lists:keymember(Days, 1, SignIn) of
                        false -> 3;
                        true -> 2
                    end
            end,
        Base = data_sign_in:get(Days),
        [Days, SignInState, Base#base_sign_in.goods_id, Base#base_sign_in.goods_num, Base#base_sign_in.icon]
        end,
    InfoList = lists:map(F, lists:seq(1, MonthDays)),

    F1 = fun(Id) ->
        BaseAcc = data_sign_in_acc:get(Id),
        IsReward =
            if BaseAcc#base_sign_in_acc.days > AccDays -> 0;
                true ->
                    case lists:member(Id, AccReward) of
                        true -> 2;
                        false -> 1
                    end
            end,
        RewardList = goods:pack_goods(BaseAcc#base_sign_in_acc.goods_list),
        [Id, BaseAcc#base_sign_in_acc.days, IsReward, RewardList]
         end,
    AccRewardList = lists:map(F1, data_sign_in_acc:id_list()),
    {ok, Bin} = pt_510:write(51000, {Today, AccDays, InfoList, AccRewardList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

cmd_sign_in(Player, Day) ->
    SignInSt = lib_dict:get(?PROC_STATUS_SIGN_IN),
    #st_sign_in{
        sign_in = SignInList,
        days = AccDays
    } = SignInSt,
    case lists:keytake(Day, 1, SignInList) of
        false ->
            NewSignInSt = SignInSt#st_sign_in{sign_in = [{Day, 1} | SignInList], days = AccDays + 1, is_change = 1},
            lib_dict:put(?PROC_STATUS_SIGN_IN, NewSignInSt),
            Base = data_sign_in:get(Day),
            GiveGoodsList = goods:make_give_goods_list(105,[{Base#base_sign_in.goods_id,Base#base_sign_in.goods_num}]),
            case goods:give_goods(Player, GiveGoodsList) of
                {ok, NewPlayer} ->
                    activity_log:log_get_gift(Player#player.key, Player#player.nickname, Base#base_sign_in.goods_id, Base#base_sign_in.goods_num, 105),
                    activity:get_notice(Player, [54], true),
                    {ok, NewPlayer};
                _ -> ok
            end;
        _ ->
            ok
    end.


sign_in(Player) ->
    case check_sign_in() of
        {false, Res} ->
            {false, Res};
        {ok, Today, SignInSt} ->
            Base = data_sign_in:get(Today),
            GiveGoodsList = goods:make_give_goods_list(105,[{Base#base_sign_in.goods_id,Base#base_sign_in.goods_num}]),
            case goods:give_goods(Player, GiveGoodsList) of
                {ok, NewPlayer} ->
                    lib_dict:put(?PROC_STATUS_SIGN_IN, SignInSt),
                    activity_log:log_get_gift(Player#player.key, Player#player.nickname, Base#base_sign_in.goods_id, Base#base_sign_in.goods_num, 105),
                    activity:get_notice(Player, [54], true),
                    sign_in_load:log_sign_in(Player#player.key, Player#player.nickname, 1, Today),
                    {ok, NewPlayer};
                _ -> {false, 0}
            end
    end.
check_sign_in() ->
    SignInSt = lib_dict:get(?PROC_STATUS_SIGN_IN),
    #st_sign_in{
        sign_in = SignInList,
        days = AccDays
    } = SignInSt,
    Now = util:unixtime(),
    Days = util:get_days(Now),
    case lists:keytake(Days, 1, SignInList) of
        false ->
            NewSignInSt = SignInSt#st_sign_in{sign_in = [{Days, 1} | SignInList], days = AccDays + 1, is_change = 1},
            {ok, Days, NewSignInSt};
        {value, {_, Times}, T} ->
            if Times >= 2 -> {false, 2};
                true ->
                    AccCharge = daily:get_count(?DAILY_CHARGE_ACC),
                    if AccCharge > 0 ->
                        NewSignInSt = SignInSt#st_sign_in{sign_in = [{Days, Times + 1} | T], is_change = 1},
                        {ok, Days, NewSignInSt};
                        true ->
                            {false, 4}
                    end
            end
    end.

%%获取可领取状态
get_state(_Player) ->
    case check_sign_in() of
        {false, _Res} -> 0;
        _ -> 1
    end.

%%领取累登奖励
acc_reward(Player, Id) ->
    SignInSt = lib_dict:get(?PROC_STATUS_SIGN_IN),
    #st_sign_in{
        days = AccDays,
        acc_reward = AccReward
    } = SignInSt,
    case data_sign_in_acc:get(Id) of
        [] -> {4, Player};
        BaseAcc ->
            if BaseAcc#base_sign_in_acc.days > AccDays -> {5, Player};
                true ->
                    case lists:member(Id, AccReward) of
                        true -> {6, Player};
                        false ->
                            NewSignInSt = SignInSt#st_sign_in{acc_reward = [Id | AccReward], is_change = 1},
                            lib_dict:put(?PROC_STATUS_SIGN_IN, NewSignInSt),
                            GoodsList = goods:make_give_goods_list(105, BaseAcc#base_sign_in_acc.goods_list),
                            {ok, NewPlayer} = goods:give_goods(Player, GoodsList),
                            sign_in_load:log_sign_in(Player#player.key, Player#player.nickname, 2, BaseAcc#base_sign_in_acc.days),
                            {1, NewPlayer}
                    end
            end
    end.

check_acc_reward_state(_Player) ->
    SignInSt = lib_dict:get(?PROC_STATUS_SIGN_IN),
    #st_sign_in{
        days = AccDays,
        acc_reward = AccReward
    } = SignInSt,
    F = fun(Id) ->
        case data_sign_in_acc:get(Id) of
            [] -> [];
            BaseAcc ->
                if BaseAcc#base_sign_in_acc.days > AccDays -> [];
                    true ->
                        case lists:member(Id, AccReward) of
                            true -> [1];
                            false -> []
                        end
                end
        end
        end,
    List = lists:flatmap(F, data_sign_in_acc:id_list()),
    if
        List == [] -> #tips{};
        true -> #tips{state = 1}
    end.
