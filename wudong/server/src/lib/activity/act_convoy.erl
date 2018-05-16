%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 护送称号活动
%%% @end
%%% Created : 01. 六月 2017 18:18
%%%-------------------------------------------------------------------
-module(act_convoy).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("goods.hrl").

%% API
-export([
    init/1,
    get_act/0,
    midnight_refresh/1,
    add_convoy/1,
    gm/1,

    get_act_info/0,
    recv/1,
    get_state/1
]).

init(#player{key = Pkey} = Player) ->
    StActConvoy =
        case player_util:is_new_role(Player) of
            true -> #st_act_convoy{pkey = Pkey};
            false -> activity_load:dbget_act_convoy(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_ACT_CONVOY, StActConvoy),
    update_act_convoy(),
    Player.


update_act_convoy() ->
    StActConvoy = lib_dict:get(?PROC_STATUS_ACT_CONVOY),
    #st_act_convoy{
        pkey = Pkey,
        act_id = ActId
%%        op_time = OpTime
    } = StActConvoy,
    case get_act() of
        [] ->
            NewStActConvoy = #st_act_convoy{pkey = Pkey};
        #base_act_convoy{act_id = BaseActId} ->
%%             Flag = util:is_same_date(OpTime, util:unixtime()),
            if
                BaseActId =/= ActId ->
                    NewStActConvoy = #st_act_convoy{pkey = Pkey, act_id = BaseActId, op_time = util:unixtime()};
%%                 Flag == false ->
%%                     NewStActConvoy = #st_act_convoy{pkey = Pkey, act_id = BaseActId, op_time = util:unixtime()};
                true ->
                    NewStActConvoy = StActConvoy
            end
    end,
    lib_dict:put(?PROC_STATUS_ACT_CONVOY, NewStActConvoy).

get_act() ->
    case activity:get_work_list(data_act_convoy) of
        [] -> [];
        [Base | _] -> Base
    end.

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_act_convoy().

gm(N) ->
    ?DEBUG("N:~p~n", [N]),
    StActConvoy = lib_dict:get(?PROC_STATUS_ACT_CONVOY),
    #st_act_convoy{convoy_num = ConvoyNum} = StActConvoy,
    NewStActConvoy = StActConvoy#st_act_convoy{convoy_num = ConvoyNum + N},
    activity_load:dbup_act_convoy(NewStActConvoy),
    lib_dict:put(?PROC_STATUS_ACT_CONVOY, NewStActConvoy).

%% 护送任务完成后出发
add_convoy(Player) ->
    case get_act() of
        [] ->
            ok;
        _ ->
            StActConvoy = lib_dict:get(?PROC_STATUS_ACT_CONVOY),
            #st_act_convoy{convoy_num = ConvoyNum} = StActConvoy,
            NewStActConvoy = StActConvoy#st_act_convoy{convoy_num = ConvoyNum + 1},
            activity_load:dbup_act_convoy(NewStActConvoy),
            lib_dict:put(?PROC_STATUS_ACT_CONVOY, NewStActConvoy),
            activity:get_notice(Player, [42], true)
    end.

%% 获取面板 LeaveTime, ConvoyNum, BaseConvoyNum, IsRecv, RewardList
get_act_info() ->
    StActConvoy = lib_dict:get(?PROC_STATUS_ACT_CONVOY),
    #st_act_convoy{
        convoy_num = ConvoyNum,
        is_recv = IsRecv0
    } = StActConvoy,
    case get_act() of
        [] ->
            {0, 0, 0, 0, []};
        #base_act_convoy{open_info = OpenInfo, convoy_num = BaseConvoyNum, reward_list = RewardList0} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            if
                ConvoyNum < BaseConvoyNum -> IsRecv = 0; %% 未达成
                IsRecv0 > 0 -> IsRecv = 2; %% 已领取
                true -> IsRecv = 1 %% 可领
            end,
            RewardList =
                lists:map(fun({GoodsId, GoodsNum}) -> [GoodsId, GoodsNum] end, RewardList0),
            {LTime, ConvoyNum, BaseConvoyNum, IsRecv, RewardList}
    end.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        #base_act_convoy{act_info = ActInfo, convoy_num = BaseConvoyNum} ->
            StActConvoy = lib_dict:get(?PROC_STATUS_ACT_CONVOY),
            #st_act_convoy{
                convoy_num = ConvoyNum,
                is_recv = IsRecv0
            } = StActConvoy,
            if
                ConvoyNum < BaseConvoyNum -> IsRecv = 0; %% 未达成
                IsRecv0 > 0 -> IsRecv = 2; %% 已领取
                true -> IsRecv = 1 %% 可领
            end,
            Args = activity:get_base_state(ActInfo),
            if
                IsRecv == 1 -> {1, Args};
                IsRecv == 2 -> -1;
                true -> {0, Args}
            end
    end.

%% 领取奖励
recv(Player) ->
    case get_act() of
        [] -> {0, Player};
        #base_act_convoy{reward_list = RewardList, convoy_num = BaseConvoyNum} ->
            StActConvoy = lib_dict:get(?PROC_STATUS_ACT_CONVOY),
            #st_act_convoy{
                convoy_num = ConvoyNum,
                is_recv = IsRecv
            } = StActConvoy,
            if
                ConvoyNum < BaseConvoyNum -> {2, Player}; %% 未达成
                IsRecv > 0 -> {3, Player}; %% 已领取
                true ->
                    NewStActConvoy = StActConvoy#st_act_convoy{is_recv = 1, op_time = util:unixtime()},
                    activity_load:dbup_act_convoy(NewStActConvoy),
                    lib_dict:put(?PROC_STATUS_ACT_CONVOY, NewStActConvoy),
                    GiveGoodsList = goods:make_give_goods_list(635, RewardList),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    activity:get_notice(Player, [42], true),
                    {1, NewPlayer}
            end
    end.