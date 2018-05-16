%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 进阶目标2
%%% @end
%%% Created : 25. 二月 2017 14:26
%%%-------------------------------------------------------------------
-module(merge_act_up_target2).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("mount.hrl").
-include("wing.hrl").
-include("magic_weapon.hrl").
-include("light_weapon.hrl").
-include("pet.hrl").
-include("pet_weapon.hrl").
-include("footprint_new.hrl").
-include("goods.hrl").
-include("cat.hrl").
-include("golden_body.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_act_info/1,
    recv/3,
    get_state/1,
    get_act/0,
    get_sub_act_type/0
]).

init(#player{key = Pkey} = Player) ->
    StMergeActUpTarget =
        case player_util:is_new_role(Player) of
            true -> #st_merge_act_up_target2{pkey = Pkey};
            false -> activity_load:dbget_merge_act_up_target2(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_MERGE_ACT_UP_TARGET2, StMergeActUpTarget),
    update_merge_act_up_target(),
    Player.

update_merge_act_up_target() ->
    StMergeActUpTarget = lib_dict:get(?PROC_STATUS_MERGE_ACT_UP_TARGET2),
    #st_merge_act_up_target2{
        pkey = Pkey,
        act_id = ActId
    } = StMergeActUpTarget,
    case get_act() of
        [] ->
            NewStMergeActUpTarget = #st_merge_act_up_target2{pkey = Pkey};
        #base_merge_up_target{act_id = BaseActId} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewStMergeActUpTarget = #st_merge_act_up_target2{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStMergeActUpTarget = StMergeActUpTarget
            end
    end,
    lib_dict:put(?PROC_STATUS_MERGE_ACT_UP_TARGET2, NewStMergeActUpTarget).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_merge_act_up_target().

get_act_info(Player) ->
    update_merge_act_up_target(),
    StMergeActUpTarget = lib_dict:get(?PROC_STATUS_MERGE_ACT_UP_TARGET2),
    #st_merge_act_up_target2{
        recv_list = RecvList
    } = StMergeActUpTarget,
    case get_act() of
        [] ->
            {0, []};
        #base_merge_up_target{
            list = BaseList,
            open_info = OpenInfo
        } ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            F = fun({ActType, Args, RewardList}) ->
                L =  lists:map(fun({GoodsId, GoodsNum, Time}) -> [GoodsId, GoodsNum, Time] end, RewardList),
                case lists:member({ActType, Args}, RecvList) of
                    false ->
                        Status = get_status(Player, ActType, Args),
                        [ActType, Args, Status, L];
                    _ ->
                        [ActType, Args, 2, L]
                end
            end,
            List = lists:map(F, BaseList),
            {LTime, List}
    end.

get_status(_Player, _ActType, _Args) ->
    merge_act_up_target:get_status(_Player, _ActType, _Args).

recv(Player, ActType, Args) ->
    StMergeActUpTarget = lib_dict:get(?PROC_STATUS_MERGE_ACT_UP_TARGET2),
    #st_merge_act_up_target2{
        recv_list = RecvList
    } = StMergeActUpTarget,
    case get_act() of
        [] ->
            {4, Player}; %% 活动未开启
        #base_merge_up_target{list = BaseList} ->
            IsRecv = lists:member({ActType, Args}, RecvList),
            Status = get_status(Player, ActType, Args),
            if
                IsRecv == true ->
                    {3, Player}; %% 已经领取
                Status == 0 ->
                    {2, Player}; %% 未达条件
                true ->
                    F = fun({ActType0, Args0, _GidtId0}) ->
                        ActType0 == ActType andalso Args0 == Args
                    end,
                    case lists:filter(F, BaseList) of
                        [] ->
                            {0, Player}; %% 配置参数错误
                        [{_ActType, _Args, RewardList} | _] ->
                            Now = util:unixtime(),
                            F1 = fun({GoodId, GoodsNum, ExpireTime}) ->
                                case ExpireTime == 0 of
                                    true ->
                                        goods:make_give_goods_list(653, [{GoodId, GoodsNum}]);
                                    false ->
                                        goods:make_give_goods_list(653, [{GoodId, GoodsNum, 0, ExpireTime * ?ONE_HOUR_SECONDS + Now}])
                                end
                            end,
                            GiveGoodsList = lists:flatmap(F1, RewardList),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            NewStMergeActUpTarget = StMergeActUpTarget#st_merge_act_up_target2{recv_list = [{ActType, Args} | RecvList]},
                            lib_dict:put(?PROC_STATUS_MERGE_ACT_UP_TARGET2, NewStMergeActUpTarget),
                            activity_load:dbup_merge_act_up_target2(NewStMergeActUpTarget),
                            activity:get_notice(Player, [46], true),
                            {1, NewPlayer}
                    end
            end
    end.

get_state(Player) ->
    case get_act() of
        [] ->
            -1; %% 活动未开启
        _ ->
            {_LeaveTime, List} = get_act_info(Player),
            F = fun([_ActType, _Args, Status, _RewardList]) ->
                Status == 1
            end,
            L = lists:filter(F, List),
            ?IF_ELSE(L == [], 0, 1)
    end.

get_act() ->
    case activity:get_work_list(data_merge_up_target2) of
        [] -> [];
        [Base | _] -> Base
    end.

get_sub_act_type() ->
    case get_act() of
        [] ->
            0;
        #base_merge_up_target{list = BaseList} ->
            {ActType, _, _} = hd(BaseList),
            ActType
    end.