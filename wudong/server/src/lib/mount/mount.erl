%% @author and_me
%% @doc @todo Add description to mount.


-module(mount).
-include("common.hrl").
-include("mount.hrl").
-include("goods.hrl").
-include("new_shop.hrl").
-include("scene.hrl").
-include("tips.hrl").
-include("activity.hrl").
-include("achieve.hrl").
-include("relation.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([
    select_image/2,
    check_upgrade_state/0,
    check_upgrade_state/1,
    check_upgrade_jp_state/3,
    check_des_time/2,
    upgrade_star/2,
    have_mount/1,
    have_temp_mount/1,
    get_mount_level/0,
    double_leave_scene/5,
    double_follow/3,
    equip_goods/2,
    use_mount_dan/1,
    get_near_people/1,
    check_use_mount_dan_state/2,
    get_equip_smelt_state/0,
    get_friends/1,
    check_upgrade_star/0,
    activation_stage_lv/2
]).


%% ====================================================================
%% Internal functions
%% ====================================================================

check_upgrade_star() ->
    F = fun(MountId) ->
        Mount = mount_util:get_mount(),
        {Star, _NewStarList} =
            case lists:keytake(MountId, 1, Mount#st_mount.star_list) of
                {value, {_, OldStar}, L} ->
                    {OldStar, [{MountId, OldStar + 1} | L]};
                _ ->
                    {0, [{MountId, 1} | Mount#st_mount.star_list]}
            end,
        case data_mount_star:get(MountId, Star + 1) of
            [] -> [];
            BaseMountStar ->
                case BaseMountStar#base_mount_star.need_goods of
                    [] -> [];
                    [{GoodsId, Num} | _] ->
                        GoodsCount = goods_util:get_goods_count(GoodsId),
                        if GoodsCount < Num -> [];
                            true -> [1]
                        end
                end
        end
    end,
    LL = lists:flatmap(F, data_mount_star:mount_list()),

    F1 = fun(MountId) ->
        Mount = lib_dict:get(?PROC_STATUS_MOUNT),
        case lists:keyfind(MountId, 1, Mount#st_mount.star_list) of
            false ->
                [];
            {MountId, Stage} ->
                StageList = get_stage_list(MountId, Stage),
                case lists:keytake(MountId, 1, Mount#st_mount.activation_list) of
                    {value, {MountId, ActList}, _T} ->
                        NewActivationList = StageList -- ActList,
                        if
                            NewActivationList == [] -> [];
                            true ->
                                [1]
                        end;
                    false ->
                        if
                            StageList == [] -> [];
                            true ->
                                [1]
                        end
                end
        end
    end,
    LL1 = lists:flatmap(F1, data_mount_star:mount_list()),

    ?IF_ELSE(LL ++ LL1 == [], 0, 1).

upgrade_star(Player, MountId) ->
    case lists:member(MountId, data_mount_star:mount_list()) of
        false -> {false, 46};
        true ->
            Mount = mount_util:get_mount(),
            {Star, NewStarList} =
                case lists:keytake(MountId, 1, Mount#st_mount.star_list) of
                    {value, {_, OldStar}, L} ->
                        {OldStar, [{MountId, OldStar + 1} | L]};
                    _ ->
                        {0, [{MountId, 1} | Mount#st_mount.star_list]}
                end,
            case data_mount_star:get(MountId, Star + 1) of
                [] -> {false, 23};
                BaseMountStar ->
                    case BaseMountStar#base_mount_star.need_goods of
                        [] -> {false, 23};
                        [{GoodsId, Num} | _] ->
                            GoodsCount = goods_util:get_goods_count(GoodsId),
                            if GoodsCount < Num -> {false, 3};
                                true ->
                                    goods:subtract_good_throw(Player, [{GoodsId, Num}], 151),
                                    OwnSpecialImage = [{MountId, 0} | lists:keydelete(MountId, 1, Mount#st_mount.own_special_image)],
                                    NewMount = Mount#st_mount{star_list = NewStarList, own_special_image = OwnSpecialImage, is_change = 1},
                                    NewMount1 = mount_attr:calc_mount_attr(NewMount),
                                    mount_util:put_mount(NewMount1),
                                    mount_pack:send_mount_info(NewMount1, Player),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    log_mount_star(Player#player.key, Player#player.nickname, MountId, Star + 1),
                                    {ok, NewPlayer}
                            end
                    end
            end
    end.


log_mount_star(Pkey, Nickname, MountId, Star) ->
    Sql = io_lib:format("insert into log_mount_star set pkey=~p,nickname='~s',mount_id=~p,star=~p,time=~p",
        [Pkey, Nickname, MountId, Star, util:unixtime()]),
    log_proc:log(Sql).

%%查询坐骑是否可升阶
check_upgrade_state() ->
    Mount = mount_util:get_mount(),
    case Mount#st_mount.stage >= data_mount_stage:max_stage() of
        true -> 0;
        false ->
            case data_mount_stage:get(Mount#st_mount.stage) of
                [] -> 0;
                BaseData ->
                    CountList = [{Gid, goods_util:get_goods_count(Gid)} || Gid <- tuple_to_list(BaseData#base_mount_stage.goods_ids)],
                    Num = BaseData#base_mount_stage.num,
                    HasNum = lists:sum([Val || {_, Val} <- CountList]),
                    if HasNum >= Num * 5 -> 1; true -> 0 end
            end
    end.

%%查询坐骑是否可升阶
check_upgrade_state(Tips) ->
    Mount = mount_util:get_mount(),
    case Mount#st_mount.stage >= data_mount_stage:max_stage() of
        true -> Tips;
        false ->
            case data_mount_stage:get(Mount#st_mount.stage) of
                [] -> Tips;
                BaseData ->
                    CountList = [{Gid, goods_util:get_goods_count(Gid)} || Gid <- tuple_to_list(BaseData#base_mount_stage.goods_ids)],
                    Num = BaseData#base_mount_stage.num,
                    HasNum = lists:sum([Val || {_, Val} <- CountList]),
                    if
                        BaseData#base_mount_stage.cd > 0 -> Tips;
                        HasNum >= Num * 1 andalso BaseData#base_mount_stage.cd < 1 -> Tips#tips{state = 1};
                        true -> Tips
                    end
            end
    end.

check_upgrade_jp_state(Player, Tips, GoodsType) ->
    if
        Player#player.lv < GoodsType#goods_type.need_lv ->
            Tips;
        true ->
            NewNum = case catch goods_attr_dan:use_goods_check(GoodsType#goods_type.goods_id, goods_util:get_goods_count(GoodsType#goods_type.goods_id), Player) of
                         N when is_integer(N) ->
                             N;
                         _Other ->
                             0
                     end,
            if
                NewNum > 0 ->
                    Tips#tips{state = 1};
                true ->
                    Tips
            end
    end.

have_mount(MountId) ->
    Mount = mount_util:get_mount(),
    case lists:keyfind(MountId, 1, Mount#st_mount.star_list) of
        false -> {false, 0};
        {MountId, Lv} -> {true, Lv}
    end.


have_temp_mount(MountId) ->
    Mount = mount_util:get_mount(),
    case lists:keyfind(MountId, 1, Mount#st_mount.own_special_image) of
        false -> false;
        {MountId, 0} -> true;
        _ -> temp
    end.

select_image(MountId, Player) ->
    Mount = mount_util:get_mount(),
    ?DEBUG("Mount#st_mount.stage ~p~n", [Mount#st_mount.stage]),
    OwnSpecialImage = Mount#st_mount.own_special_image,
    Now = util:unixtime(),
    case lists:keyfind(MountId, 1, OwnSpecialImage) of
        {MountId, Time} when Time == 0 orelse Time > Now ->
            Base = data_mount:get(MountId),
            SwordImage =
                if Base#base_mount.sword_image =/= 0 ->
                    Base#base_mount.sword_image;
                    true ->
                        Base = data_mount_stage:get(Mount#st_mount.stage),
                        Base#base_mount_stage.sword_image
                end,
            NewOld =
                if
                    Base#base_mount.is_showpic == 0 -> MountId;
                    true ->
                        ?IF_ELSE(Mount#st_mount.old_current_image_id == 0, Mount#st_mount.current_image_id, Mount#st_mount.old_current_image_id)
                end,
            NewMount = Mount#st_mount{current_image_id = MountId, current_sword_id = SwordImage, old_current_image_id = NewOld, is_change = 1},
            mount_util:put_mount(NewMount),
%%             mount_pack:send_mount_info(NewMount, Player),
            NewPlayer = Player#player{mount_id = MountId},
            scene_agent_dispatch:mount_id_update(NewPlayer),
            {ok, NewPlayer};
        {_, _} -> throw({false, 22});
        _ ->
            throw({false, 21})
    end.


%%皮肤过期检查
check_des_time(Player, Now) ->
    Mount = mount_util:get_mount(),
    case lists:keyfind(Mount#st_mount.current_image_id, 1, Mount#st_mount.own_special_image) of
        {_, 0} ->
            Player;
        {_, Time} when Now > Time ->
            BaseData = data_mount_stage:get(1),
            NewMount = Mount#st_mount{current_image_id = BaseData#base_mount_stage.image, current_sword_id = BaseData#base_mount_stage.sword_image, is_change = 1},
            NewMount1 = mount_attr:calc_mount_attr(NewMount),
            mount_util:put_mount(NewMount1),
            mount_pack:send_mount_info(NewMount1, Player),
            NewPlayer = Player#player{mount_id = 0},
            scene_agent_dispatch:mount_id_update(NewPlayer),
            NewPlayer1 = player_util:count_player_attribute(NewPlayer, true),
            NewPlayer1;
        _ ->
            Player
    end.

get_mount_level() ->
    Mount = mount_util:get_mount(),
    Mount#st_mount.stage.

%%检测是否是双人坐骑状态，如果是，解除双人坐骑状态
double_leave_scene(Player, _Scene, _TarCopy, _X, _Y) ->
    if
        Player#player.common_riding#common_riding.state > 0 ->
            Player#player.common_riding#common_riding.common_pid ! cancel_commom_mount,
            Player#player.pid ! cancel_commom_mount,
            Player;
%%             DataScene = data_scene:get(Scene),
%%             if
%%                 DataScene#scene.type =/= 0 ->
%%                     catch Player#player.common_riding#common_riding.common_pid ! cancel_commom_mount,
%%                     CommonRiding = Player#player.common_riding,
%%                     Player1 = Player#player{common_riding = CommonRiding#common_riding{state = 0}},
%%                     scene_agent_dispatch:common_riding(Player1),
%%                     {ok, Bin12307} = pt_120:write(12037, {CommonRiding#common_riding.main_pkey, CommonRiding#common_riding.common_pkey, 0}),
%%                     server_send:send_to_sid(Player1#player.sid, Bin12307),
%%                     {ok, Bin17020} = pt_170:write(17020, {1}),
%%                     server_send:send_to_sid(Player#player.sid, Bin17020),
%%                     Player1;
%%                 true ->
%%                     Player#player.common_riding#common_riding.common_pid ! {commom_mount_leave_scene, Scene, TarCopy, X, Y},
%%                     Player
%%             end;
        true ->
            Player
    end.

%%检测是否是双人坐骑状态，如果是，另外一人要跟着走
double_follow(Player, X2, Y2) ->
    if
        Player#player.common_riding#common_riding.state =:= 1 ->
            Player#player.common_riding#common_riding.common_pid ! {commom_mount_follow, X2, Y2};
        true ->
            ok
    end.


%%穿上装备
equip_goods(Player, GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {13, Player};
        Goods ->
            case data_goods:get(Goods#goods.goods_id) of
                [] -> {13, Player};
                GoodsType ->
                    Mount = mount_util:get_mount(),
                    if GoodsType#goods_type.need_lv > Mount#st_mount.stage -> {37, Player};
                        true ->
                            SubtypeList = [?GOODS_SUBTYPE_EQUIP_MOUNT_1, ?GOODS_SUBTYPE_EQUIP_MOUNT_2, ?GOODS_SUBTYPE_EQUIP_MOUNT_3, ?GOODS_SUBTYPE_EQUIP_MOUNT_4],
                            case lists:member(GoodsType#goods_type.subtype, SubtypeList) of
                                false ->
                                    {16, Player};
                                true ->
                                    NeedGoods = Goods#goods{location = ?GOODS_LOCATION_MOUNT, cell = GoodsType#goods_type.subtype, bind = ?BIND},

                                    GoodsDict = goods_dict:update_goods(NeedGoods, GoodsSt#st_goods.dict),
                                    goods_pack:pack_send_goods_info([NeedGoods], GoodsSt#st_goods.sid),

                                    EquipList =
                                        case lists:keytake(GoodsType#goods_type.subtype, 1, Mount#st_mount.equip_list) of
                                            false ->
                                                _OldGoodsId = 0,
                                                NewGoodsSt = GoodsSt#st_goods{leftover_cell_num = GoodsSt#st_goods.leftover_cell_num + 1, dict = GoodsDict},
                                                [{GoodsType#goods_type.subtype, Goods#goods.goods_id, Goods#goods.key} | Mount#st_mount.equip_list];
                                            {value, {_, _OldGoodsId, OldGoodsKey}, T} ->
                                                case catch goods_util:get_goods(OldGoodsKey, GoodsSt#st_goods.dict) of
                                                    {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
                                                        GoodsDict1 = GoodsDict;
                                                    GoodsOld ->
                                                        NewGoodsOld = GoodsOld#goods{location = ?GOODS_LOCATION_BAG, cell = 0},
                                                        goods_pack:pack_send_goods_info([NewGoodsOld], GoodsSt#st_goods.sid),
                                                        goods_load:dbup_goods_cell_location(NewGoodsOld),
                                                        GoodsDict1 = goods_dict:update_goods(NewGoodsOld, GoodsDict)
                                                end,
                                                NewGoodsSt = GoodsSt#st_goods{dict = GoodsDict1},
                                                [{GoodsType#goods_type.subtype, Goods#goods.goods_id, Goods#goods.key} | T]
                                        end,
                                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                                    goods_load:dbup_goods_cell_location(NeedGoods),
                                    Mount1 = Mount#st_mount{equip_list = EquipList, is_change = 1},
                                    NewMount = mount_attr:calc_mount_attr(Mount1),
                                    mount_util:put_mount(NewMount),
                                    NewPlayer = player_util:count_player_attribute(Player, true),
                                    log_mount_equip(Player#player.key, Player#player.nickname, GoodsType#goods_type.subtype, _OldGoodsId, Goods#goods.goods_id),
                                    {1, NewPlayer}
                            end
                    end
            end
    end.

%% 检查是否有装备可以熔炼
get_equip_smelt_state() ->
    GoodsList = goods_util:get_goods_list_by_type_list(?GOODS_LOCATION_BAG, [?GOODS_TYPE_EQUIP10]),
    Mount = mount_util:get_mount(),
    F = fun(Goods) ->
        if
            Goods#goods.bind /= ?BIND -> false;
            true ->
                GoodsType = data_goods:get(Goods#goods.goods_id),
                case lists:keyfind(GoodsType#goods_type.subtype, 1, Mount#st_mount.equip_list) of
                    false -> false;
                    {_Subtype, _GoodsId, GoodsKey} ->
                        if
                            GoodsKey == Goods#goods.key -> false;
                            true ->
                                WearGoods = goods_util:get_goods(GoodsKey),
                                if
                                    Goods#goods.combat_power > WearGoods#goods.combat_power -> false;
                                    true -> true
                                end
                        end
                end
        end
    end,
    case lists:any(F, GoodsList) of
        false -> 0;
        true -> 1
    end.

log_mount_equip(Pkey, Nickname, Subtype, OldGid, NewGid) ->
    Sql = io_lib:format("insert into log_mount_equip set pkey=~p,nickname='~s',subtype=~p,old_gid=~p,new_gid=~p,time=~p", [Pkey, Nickname, Subtype, OldGid, NewGid, util:unixtime()]),
    log_proc:log(Sql).

%% 使用坐骑成长丹
use_mount_dan(Player) ->
    case data_grow_dan:get(?GOODS_GROW_ID_MOUNT) of
        [] -> {false, 0}; %% 配表错误
        Base ->
            Mount = mount_util:get_mount(), %% 玩家坐骑
            case lists:keyfind(Mount#st_mount.stage, 1, Base#base_grow_dan.stage_max_num) of
                false -> {false, 0};
                {_, MaxNum} ->
                    if
                        Mount#st_mount.grow_num >= MaxNum ->
                            {false, 42}; %% 成长丹已达到使用上限
                        true ->
                            if
                                Base#base_grow_dan.step_lim > Mount#st_mount.stage ->
                                    {false, 43};  %% 未达到使用阶级
                                true ->
                                    GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_MOUNT),
                                    if
                                        GrowNum == 0 ->
                                            goods_util:client_popup_goods_not_enough(Player, Base#base_grow_dan.goods_id, 0, 226),
                                            {false, 44}; %% 成长丹不足
                                        true ->
                                            DeleteGrowNum = min(MaxNum - Mount#st_mount.grow_num, GrowNum),
                                            goods:subtract_good(Player, [{?GOODS_GROW_ID_MOUNT, DeleteGrowNum}], 226), %% 扣除成长丹
                                            NewMount = Mount#st_mount{grow_num = Mount#st_mount.grow_num + DeleteGrowNum, is_change = 1},
                                            NewMount1 = mount_attr:calc_mount_attr(NewMount), %% 重新计算属性
                                            mount_util:put_mount(NewMount1),
                                            mount_pack:send_mount_info(NewMount1, Player),

                                            NewPlayer = player_util:count_player_attribute(Player#player{mount_id = NewMount1#st_mount.current_image_id}, true),
                                            scene_agent_dispatch:attribute_update(NewPlayer),
                                            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1020, 0, DeleteGrowNum),
                                            {ok, NewPlayer}
                                    end
                            end
                    end
            end
    end.

%% 检查坐骑成长
check_use_mount_dan_state(_Player, Tips) ->
    case data_grow_dan:get(?GOODS_GROW_ID_MOUNT) of
        [] -> Tips; %% 配表错误
        Base ->
            Mount = mount_util:get_mount(), %% 玩家坐骑
            {_, MaxNum} = lists:keyfind(Mount#st_mount.stage, 1, Base#base_grow_dan.stage_max_num),
            if
                Mount#st_mount.grow_num >= MaxNum ->
                    Tips; %% 成长丹已达到使用上限
                true ->
                    if
                        Base#base_grow_dan.step_lim > Mount#st_mount.stage ->
                            Tips;  %% 未达到使用阶级
                        true ->
                            GrowNum = goods_util:get_goods_count(?GOODS_GROW_ID_MOUNT),
                            if
                                GrowNum == 0 ->
                                    Tips; %% 成长丹不足
                                true ->
                                    Tips#tips{state = 1}
                            end
                    end
            end
    end.


get_near_people(Player) ->
    ScenePlayerList0 = scene_agent:get_area_scene_player(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y),
    ScenePlayerList1 = make_scene_player(ScenePlayerList0),
    ScenePlayerList2 = lists:keydelete(Player#player.key, 1, ScenePlayerList1),
    CoupleKey = Player#player.marry#marry.couple_key,
    FriendList = relation:get_friend_list(),
    F = fun({Key, NickName, Lv, Avatar, Sex}) ->
        IsFriend = lists:member(Key, FriendList),
        if
            Key == CoupleKey -> [Key, NickName, Lv, Avatar, Sex, 2];
            IsFriend -> [Key, NickName, Lv, Avatar, Sex, 1];
            true -> [Key, NickName, Lv, Avatar, Sex, 0]
        end
    end,
    lists:map(F, ScenePlayerList2).

get_friends(Player) ->
    ScenePlayerList0 = scene_agent:get_area_scene_pkeys(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y),
    ScenePlayerList2 = lists:delete(Player#player.key, ScenePlayerList0),
    CoupleKey = Player#player.marry#marry.couple_key,
    FriendList = relation:get_friend_info_list(),
    F = fun({Key, Nickname, _Career, Sex, _Vip, Lv, _Cbp, Avatar, _Guild}, List) ->
        IsScene = lists:member(Key, ScenePlayerList2),
        case IsScene of
            true ->
                if Key == CoupleKey ->
                    [[Key, Nickname, Lv, Avatar, Sex, 2, 1] | List];
                    true ->
                        [[Key, Nickname, Lv, Avatar, Sex, 1, 1] | List]
                end;
            false ->
                if Key == CoupleKey ->
                    [[Key, Nickname, Lv, Avatar, Sex, 2, 0] | List];
                    true ->
                        [[Key, Nickname, Lv, Avatar, Sex, 1, 0] | List]
                end
        end
    end,
    lists:foldl(F, [], FriendList).


make_scene_player(ScenePlayerList) ->
    F = fun(ScenePlayer) ->
        {ScenePlayer#scene_player.key,
            ScenePlayer#scene_player.nickname,
            ScenePlayer#scene_player.lv,
            ScenePlayer#scene_player.avatar,
            ScenePlayer#scene_player.sex
        }
    end,
    lists:map(F, ScenePlayerList).


activation_stage_lv(Player, MountId) ->
    Mount = lib_dict:get(?PROC_STATUS_MOUNT),
    case lists:keyfind(MountId, 1, Mount#st_mount.star_list) of
        false ->
            {46, Player};
        {MountId, Stage} ->
            StageList = get_stage_list(MountId, Stage),
            case lists:keytake(MountId, 1, Mount#st_mount.activation_list) of
                {value, {MountId, ActList}, T} ->
                    NewActivationList = StageList -- ActList,
                    if
                        NewActivationList == [] -> {49, Player};
                        true ->
                            Mount1 = Mount#st_mount{activation_list = [{MountId, NewActivationList ++ ActList} | T], is_change = 1},
                            NewMount1 = mount_attr:calc_mount_attr(Mount1),
                            mount_util:put_mount(NewMount1),
                            mount_pack:send_mount_info(NewMount1, Player),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            {1, NewPlayer}
                    end;
                false ->
                    if
                        StageList == [] -> {49, Player};
                        true ->
                            Mount1 = Mount#st_mount{activation_list = [{MountId, StageList} | Mount#st_mount.activation_list], is_change = 1},
                            NewMount1 = mount_attr:calc_mount_attr(Mount1),
                            mount_util:put_mount(NewMount1),
                            mount_pack:send_mount_info(NewMount1, Player),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            {1, NewPlayer}
                    end
            end
    end.

get_stage_list(Id, Stage) ->
    F = fun(Stage0, List) ->
        case data_mount_star:get(Id, Stage0) of
            [] -> List;
            #base_mount_star{lv_attr = LvAttr} ->
                if
                    LvAttr == [] -> List;
                    true -> [Stage0 | List]
                end
        end
    end,
    lists:foldl(F, [], lists:seq(1, Stage)).

