%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2016 下午7:57
%%%-------------------------------------------------------------------
-module(act_content).
-author("fengzhenlin").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    get_act_content_list/1,
    get_act_content/2,
    get_state/0
]).

-define(GT(M), activity:get_leave_time(M)).
-define(GI(M), activity:get_act_info(M)).


get_act_content_list(Player) ->
    All = data_act_content:get_all(),
    F = fun(Id) ->
            {LeaveTime, _ActInfo} = get_act_info(Id),
            case LeaveTime == -1 of
                true -> [];
                false ->
                    Base = data_act_content:get(Id),
                    [Base]
            end
        end,
    ActList = lists:flatmap(F, All),
    SortList = lists:keysort(#base_act_content.order, ActList),
    L = [[Base#base_act_content.id, Base#base_act_content.name]||Base<-SortList],
    {ok, Bin} = pt_430:write(43097, {L}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_act_content(Player, Id) ->
    Base = data_act_content:get(Id),
    case Base of
        [] -> skip;
        _ ->
            get_act_content(Player,Id,Base)
    end.
get_act_content(Player,Id,Base) ->
    {LeaveTime, ActInfo} = get_act_info(Id),
    case is_record(ActInfo, act_info) of
        true ->
            #act_info{
                act_name = Name,
                act_desc = Desc,
                show_goods_list = GoodsList
            } = ActInfo;
        false ->
            #base_act_content{
                name = Name,
                desc = Desc,
                goods_list = GoodsList
            } = Base
    end,
    {ok, Bin} = pt_430:write(43098, {Id, LeaveTime, Name, Desc, GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_act_info(Id) ->
    case Id of
        1 -> %%首冲
            {-2, ?GI(data_fir_charge)};
        2 -> %%冲榜
            {?GT(data_act_rank),?GI(data_act_rank)};
        3 -> %%每日充值
            {?GT(data_daily_charge),?GI(data_daily_charge)};
        4 -> %%累计充值
            {?GT(data_acc_charge),?GI(data_acc_charge)};
        5 -> %%累计消费
            {?GT(data_acc_consume),?GI(data_acc_consume)};
        6 -> %%单笔充值
            {?GT(data_one_charge),?GI(data_one_charge)};
        7 -> %%新每日充值
            {?GT(data_new_daily_charge),?GI(data_new_daily_charge)};
        8 -> %%新单笔充值
            {?GT(data_new_one_charge),?GI(data_new_one_charge)};
        9 -> %%冲榜返利
            {?GT(data_act_rank_goal),?GI(data_act_rank_goal)};
        10 -> %%兑换活动
            {?GT(data_exchange),?GI(data_exchange)};
        11 -> %%冲榜抢购
            {?GT(data_act_rank),?GI(data_act_rank)};
        12 -> %%在线时长奖励
            {?GT(data_online_time_gift),?GI(data_online_time_gift)};
        13 -> %%13每日累充
            {?GT(data_daily_acc_charge),?GI(data_daily_acc_charge)};
        14 -> %%14抢购商店
            {?GT(data_lim_shop),?GI(data_lim_shop)};
        15 -> %%15定时奖励
            {?GT(data_online_gift),?GI(data_online_gift)};
        16 -> %%16累充转盘
            {?GT(data_acc_charge_turntable),?GI(data_acc_charge_turntable)};
        17 -> %%17每日首冲返还
            {?GT(data_daily_fir_charge_return),?GI(data_daily_fir_charge_return)};
        18 -> %%18累充礼包
            {?GT(data_acc_charge_gift),?GI(data_acc_charge_gift)};
        80 -> %%月卡
            {-2, []};
        79 -> %%投资计划
            LeaveTime0 = invest:remaining_time(),
            LeaveTime =
                case LeaveTime0 > 0 of
                    true -> LeaveTime0;
                    false -> -1
                end,
            {LeaveTime, []};
        _ ->
            {0, []}
    end.

get_state() ->
    OpenDay = config:get_open_days(),
    if
        OpenDay > 7 -> -1;
        true -> 0
    end.