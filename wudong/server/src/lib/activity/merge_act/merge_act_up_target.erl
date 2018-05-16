%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 进阶目标
%%% @end
%%% Created : 25. 二月 2017 14:26
%%%-------------------------------------------------------------------
-module(merge_act_up_target).
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
-include("god_treasure.hrl").
-include("jade.hrl").
-include("baby_wing.hrl").
-include("baby_mount.hrl").
-include("baby_weapon.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_act_info/1,
    recv/3,
    get_state/1,
    get_act/0,
    get_sub_act_type/0,
    get_status/3
]).

init(#player{key = Pkey} = Player) ->
    StMergeActUpTarget =
        case player_util:is_new_role(Player) of
            true -> #st_merge_act_up_target{pkey = Pkey};
            false -> activity_load:dbget_merge_act_up_target(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_MERGE_ACT_UP_TARGET, StMergeActUpTarget),
    update_merge_act_up_target(),
    Player.

update_merge_act_up_target() ->
    StMergeActUpTarget = lib_dict:get(?PROC_STATUS_MERGE_ACT_UP_TARGET),
    #st_merge_act_up_target{
        pkey = Pkey,
        act_id = ActId
    } = StMergeActUpTarget,
    case get_act() of
        [] ->
            NewStMergeActUpTarget = #st_merge_act_up_target{pkey = Pkey};
        #base_merge_up_target{act_id = BaseActId} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewStMergeActUpTarget = #st_merge_act_up_target{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStMergeActUpTarget = StMergeActUpTarget
            end
    end,
    lib_dict:put(?PROC_STATUS_MERGE_ACT_UP_TARGET, NewStMergeActUpTarget).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_merge_act_up_target().

get_act_info(Player) ->
    update_merge_act_up_target(),
    StMergeActUpTarget = lib_dict:get(?PROC_STATUS_MERGE_ACT_UP_TARGET),
    #st_merge_act_up_target{
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
                L = lists:map(fun({GoodsId, GoodsNum, Time}) -> [GoodsId, GoodsNum, Time] end, RewardList),
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

get_status(_Player, ?MERGE_UP_TARGET_MOUNT, Args) ->
    Mount = mount_util:get_mount(),
    ?IF_ELSE(Mount#st_mount.stage >= Args, 1, 0);

get_status(_Player, ?MERGE_UP_TARGET_WING, Args) ->
    WingSt = lib_dict:get(?PROC_STATUS_WING),
    ?IF_ELSE(WingSt#st_wing.stage >= Args, 1, 0);

get_status(_Player, ?MERGE_UP_TARGET_MAGIC_WEAPON, Args) ->
    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    ?IF_ELSE(MagicWeapon#st_magic_weapon.stage >= Args, 1, 0);

get_status(_Player, ?MERGE_UP_TARGET_LIGHT_WEAPON, Args) ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    ?IF_ELSE(LightWeapon#st_light_weapon.stage >= Args, 1, 0);

get_status(_Player, ?MERGE_UP_TARGET_PET_WEAPON, Args) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    ?IF_ELSE(PetWeapon#st_pet_weapon.stage >= Args, 1, 0);

get_status(_Player, ?MERGE_UP_TARGET_PET_UP_LV, Args) ->
    PetSt = lib_dict:get(?PROC_STATUS_PET),
    TotalLv = PetSt#st_pet.stage,
    ?IF_ELSE(TotalLv >= Args, 1, 0);

get_status(_Player, ?MERGE_UP_TARGET_PET_UP_STAR, Args) ->
    PetSt = lib_dict:get(?PROC_STATUS_PET),
    PetList = PetSt#st_pet.pet_list,
    F = fun(#pet{star = Lv}) -> Lv end,
    TotalLv = lists:map(F, PetList),
    ?IF_ELSE(lists:max([0] ++ TotalLv) >= Args, 1, 0);

get_status(_Player, ?MERGE_UP_TARGET_FOOTPRINT, Args) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    ?IF_ELSE(PetWeapon#st_footprint.stage >= Args, 1, 0);

get_status(_Player, ?MERGE_UP_TARGET_CAT_UP_LV, Args) ->
    Cat = lib_dict:get(?PROC_STATUS_CAT),
    ?IF_ELSE(Cat#st_cat.stage >= Args, 1, 0);

get_status(_Player, ?MERGE_UP_TARGET_GOLDEN_BODY_UP_LV, Args) ->
    GoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
    ?IF_ELSE(GoldenBody#st_golden_body.stage >= Args, 1, 0);
get_status(_Player, ?MERGE_UP_TARGET_GOD_TREASURE_UP_LV, Args) ->
    GoldTreasure = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
    ?IF_ELSE(GoldTreasure#st_god_treasure.stage >= Args, 1, 0);
get_status(_Player, ?MERGE_UP_TARGET_JADE_UP_LV, Args) ->
    Jade = lib_dict:get(?PROC_STATUS_JADE),
    ?IF_ELSE(Jade#st_jade.stage >= Args, 1, 0);

get_status(_Player, ?MERGE_UP_TARGET_BABY_WING, Args) ->
    BabyWing = lib_dict:get(?PROC_STATUS_BABY_WING),
    ?IF_ELSE(BabyWing#st_baby_wing.stage >= Args, 1, 0);
get_status(_Player, ?MERGE_UP_TARGET_BABY_MOUNT, Args) ->
    BabyMount = lib_dict:get(?PROC_STATUS_BABY_MOUNT),
    ?IF_ELSE(BabyMount#st_baby_mount.stage >= Args, 1, 0);
get_status(_Player, ?MERGE_UP_TARGET_BABY_WEAPON, Args) ->
    BabyWeapon = lib_dict:get(?PROC_STATUS_BABY_WEAPON),
    ?IF_ELSE(BabyWeapon#st_baby_weapon.stage >= Args, 1, 0);

get_status(_Player, _ActType, _Args) ->
    0.

recv(Player, ActType, Args) ->
    StMergeActUpTarget = lib_dict:get(?PROC_STATUS_MERGE_ACT_UP_TARGET),
    #st_merge_act_up_target{
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
                                        goods:make_give_goods_list(652, [{GoodId, GoodsNum}]);
                                    false ->
                                        goods:make_give_goods_list(652, [{GoodId, GoodsNum, 0, ExpireTime * ?ONE_HOUR_SECONDS + Now}])
                                end
                            end,
                            GiveGoodsList = lists:flatmap(F1, RewardList),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            NewStMergeActUpTarget = StMergeActUpTarget#st_merge_act_up_target{recv_list = [{ActType, Args} | RecvList]},
                            lib_dict:put(?PROC_STATUS_MERGE_ACT_UP_TARGET, NewStMergeActUpTarget),
                            activity_load:dbup_merge_act_up_target(NewStMergeActUpTarget),
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
    case activity:get_work_list(data_merge_up_target) of
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