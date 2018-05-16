%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 全民冲榜
%%% @end
%%% Created : 25. 三月 2017 14:39
%%%-------------------------------------------------------------------
-module(open_act_all_rank).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("mount.hrl").
-include("light_weapon.hrl").
-include("magic_weapon.hrl").
-include("wing.hrl").
-include("rank.hrl").
-include("arena.hrl").
-include("pet.hrl").
-include("footprint_new.hrl").
-include("cat.hrl").
-include("pet_weapon.hrl").
-include("golden_body.hrl").
-include("god_treasure.hrl").
-include("jade.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    sys_midnight_cacl/0,
    sys_midnight_cacl2/0,
    get_act/0,
    get_reward_pkey/3,
    get_1_data/1,
    get_stage/2,
    get_recv_status/3,
    get_str/1,

    get_state/1,
    get_act_info/1,
    recv/2,
    gm_reward/0,
    get_sub_act_type/0
]).

init(#player{key = Pkey} = Player) ->
    StOpenActAllRank =
        case player_util:is_new_role(Player) of
            true ->
                #st_open_act_all_rank{pkey = Pkey};
            false ->
                activity_load:dbget_open_act_all_rank(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_OPEN_ALL_RANK, StOpenActAllRank),
    update_open_act_all_rank(),
    Player.

update_open_act_all_rank() ->
    StOpenActAllRank = lib_dict:get(?PROC_STATUS_OPEN_ALL_RANK),
    #st_open_act_all_rank{
        pkey = Pkey,
        act_id = ActId,
        op_time = OpTime
    } = StOpenActAllRank,
    case get_act() of
        [] ->
            NewStOpenActAllRank = #st_open_act_all_rank{pkey = Pkey};
        #base_open_act_all_rank{act_id = BaseActId} ->
            Now = util:unixtime(),
            Flag = util:is_same_date(Now, OpTime),
            if
                BaseActId =/= ActId ->
                    NewStOpenActAllRank = #st_open_act_all_rank{pkey = Pkey, act_id = BaseActId, op_time = Now};
                Flag == false ->
                    NewStOpenActAllRank = #st_open_act_all_rank{pkey = Pkey, act_id = BaseActId, op_time = Now};
                true ->
                    NewStOpenActAllRank = StOpenActAllRank
            end
    end,
    lib_dict:put(?PROC_STATUS_OPEN_ALL_RANK, NewStOpenActAllRank).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_open_act_all_rank().

gm_reward() ->
    sys_midnight_cacl2().

%% 凌晨邮件结算
sys_midnight_cacl() ->
    {{_Y, _Mon, _D}, {H, M, _S}} = erlang:localtime(),
    if
        H == 23 andalso M == 58 -> sys_midnight_cacl2();
        true -> ok
    end.

sys_midnight_cacl2() ->
    case get_act() of
        [] ->
            ok;
        #base_open_act_all_rank{list = BaseList, open_info = OpenInfo} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            IsCenter = config:is_center_node(),
            if
                LTime > 150 -> skip;
                IsCenter == true -> skip;
                true ->
                    F = fun({RandType, SendType, RankMin, RankMax, _BaseLv, GiftId}) ->
                        case SendType of
                            2 ->
                                ok;
                            1 ->
                                List = get_reward_pkey(RandType, RankMin, RankMax),
                                F2 = fun(#a_rank{rp = Rp, rank = Rank}) ->
                                    Pkey = Rp#rp.pkey,
                                    {Title0, Content0} = t_mail:mail_content(69),
                                    Title = io_lib:format(Title0, [get_str(RandType)]),
                                    Content = io_lib:format(Content0, [get_str(RandType), Rank]),
                                    mail:sys_send_mail([Pkey], Title, Content, [{GiftId, 1}]),
                                    {Pkey, Rank}
                                end,
                                List2 = lists:map(F2, List),
                                Sql = io_lib:format("insert into log_act_all_rank set rank_type=~p,rank_min=~p,rank_max=~p,rank_list='~s',time=~p",
                                    [RandType, RankMin, RankMax, util:term_to_bitstring(List2), util:unixtime()]),
                                log_proc:log(Sql)
                        end
                    end,
                    spawn(fun() -> timer:sleep(150000), lists:map(F, BaseList) end)
            end
    end.

get_str(1) ->
    ?T("坐骑升级");
get_str(2) ->
    ?T("仙羽升级");
get_str(3) ->
    ?T("法器升级");
get_str(4) ->
    ?T("神兵升级");
get_str(5) ->
    ?T("妖灵进阶");
get_str(6) ->
    ?T("宠物进阶");
get_str(7) ->
    ?T("宠物升星");
get_str(8) ->
    ?T("足迹进阶");
get_str(9) ->
    ?T("灵猫进阶");
get_str(10) ->
    ?T("金身进阶").

get_reward_pkey(RandType, RankMin, RankMax) ->
    RankList =
        case RandType of
            ?OPEN_ALL_RANK_MOUNT ->
                rank:get_rank_top_N(?RANK_TYPE_MOUNT, RankMax);
            ?OPEN_ALL_RANK_WING ->
                rank:get_rank_top_N(?RANK_TYPE_WING, RankMax);
            ?OPEN_ALL_RANK_MAGIC_WEAPON ->
                rank:get_rank_top_N(?RANK_TYPE_FABAO, RankMax);
            ?OPEN_ALL_RANK_LIGHT_WEAPON ->
                rank:get_rank_top_N(?RANK_TYPE_SB, RankMax);
            ?OPEN_ALL_RANK_PET_WEAPON ->
                rank:get_rank_top_N(?RANK_TYPE_YL, RankMax);
            ?OPEN_ALL_RANK_PET_UP_LV ->
                rank:get_rank_top_N(?RANK_TYPE_PET_STAGE, RankMax);
            ?OPEN_ALL_RANK_PET_UP_STAR ->
                rank:get_rank_top_N(?RANK_TYPE_PET_STAR, RankMax);
            ?OPEN_ALL_RANK_FOOTPRINT ->
                rank:get_rank_top_N(?RANK_TYPE_FOOT, RankMax);
            ?OPEN_ALL_RANK_CAT_UP_LV ->
                rank:get_rank_top_N(?RANK_TYPE_CAT, RankMax);
            ?OPEN_ALL_RANK_GOLDEN_BODY_UP_LV ->
                rank:get_rank_top_N(?RANK_TYPE_GOLDEN_BODY, RankMax);
            ?OPEN_ALL_RANK_GOD_TREASURE_UP_LV ->
                rank:get_rank_top_N(?RANK_TYPE_GOD_TREASURE, RankMax);
            ?OPEN_ALL_RANK_JADE_UP_LV ->
                rank:get_rank_top_N(?RANK_TYPE_JADE, RankMax)
        end,
    if
        length(RankList) < RankMin -> [];
        true -> lists:sublist(RankList, RankMin, RankMax - RankMin + 1)
    end.

get_state(Player) ->
    update_open_act_all_rank(),
    StOpenActAllRank = lib_dict:get(?PROC_STATUS_OPEN_ALL_RANK),
    #st_open_act_all_rank{recv_list = RecvList} = StOpenActAllRank,
    case get_act() of
        [] ->
            -1;
        #base_open_act_all_rank{list = BaseList} ->
            F = fun({RankType, SendType, _RankMin, _RankMax, BaseLv, _GiftId}) ->
                RecvStatus = lists:keyfind(BaseLv, 2, RecvList),
                if
                    SendType == ?OPEN_ALL_RANK_MAIL_SEND ->
                        [];
                    RecvStatus =/= false ->
                        [];
                    true ->
                        ?IF_ELSE(get_recv_status(Player, RankType, BaseLv) == true, [1], [])
                end
            end,
            List = lists:flatmap(F, BaseList),
            ?IF_ELSE(List == [], 0, 1)
    end.

get_act_info(Player) ->
    case get_act() of
        [] ->
            {0, 0, "", 0, 0, 0, 0, [], []};
        #base_open_act_all_rank{open_info = OpenInfo, list = BaseList} ->
            RankType = element(1, hd(BaseList)),
            LTime = activity:calc_act_leave_time(OpenInfo),
            {NickName, Creer, Sex, Avatar} = get_1_data(RankType),
            %% 邮件发送奖励
            F1 = fun({_RankType1, SendType1, MinRank1, MaxRank1, _BaseLv1, GiftId1}) ->
                ?IF_ELSE(SendType1 == 1, [[MinRank1, MaxRank1, GiftId1]], [])
            end,
            BaseList1 = lists:flatmap(F1, BaseList),
            %% 手动领取奖励
            F2 = fun({RankType2, SendType2, _MinRank2, _MaxRank2, BaseLv2, GiftId2}) ->
                ?IF_ELSE(SendType2 == 2, [[BaseLv2, GiftId2, get_recv(Player, RankType2, BaseLv2)]], [])
            end,
            BaseList2 = lists:flatmap(F2, BaseList),
            Stage = get_stage(Player, RankType),
            {LTime, RankType, NickName, Creer, Sex, Avatar, Stage, BaseList1, BaseList2}
    end.

get_recv(Player, RankType, BaseLv) ->
    StOpenActAllRank = lib_dict:get(?PROC_STATUS_OPEN_ALL_RANK),
    #st_open_act_all_rank{recv_list = RecvList} = StOpenActAllRank,
    RecvStatus = lists:keyfind(BaseLv, 2, RecvList),
    if
        RecvStatus =/= false ->
            2;
        true ->
            ?IF_ELSE(get_recv_status(Player, RankType, BaseLv) == true, 1, 0)
    end.

recv(Player, BaseLv) ->
    case get_act() of
        [] ->
            {Player, 0};
        #base_open_act_all_rank{list = BaseList, act_id = BaseActId} ->
            RankType = element(1, hd(BaseList)),
            StOpenActAllRank = lib_dict:get(?PROC_STATUS_OPEN_ALL_RANK),
            #st_open_act_all_rank{recv_list = RecvList} = StOpenActAllRank,
            RecvStatus = lists:keyfind(BaseLv, 2, RecvList),
            IsRecvStaus = get_recv_status(Player, RankType, BaseLv),
            if
                RecvStatus =/= false ->
                    {Player, 3}; %% 已经领取
                IsRecvStaus =/= true ->
                    {Player, 2}; %% 未达成
                true ->
                    F = fun({_RankType, SendType, _MinRank, _MaxRank, BaseLv0, _GiftId}) ->
                        BaseLv0 == BaseLv andalso SendType == 2
                    end,
                    [{_RankType, _SendType, _MinRank, _MaxRank, _BaseLv, GiftId} | _] = lists:filter(F, BaseList),
                    NewRecvList = [{RankType, BaseLv} | RecvList],
                    NewStOpenActAllRank = StOpenActAllRank#st_open_act_all_rank{recv_list = NewRecvList, op_time = util:unixtime(), act_id = BaseActId},
                    lib_dict:put(?PROC_STATUS_OPEN_ALL_RANK, NewStOpenActAllRank),
                    activity_load:dbup_open_act_all_rank(NewStOpenActAllRank),
                    GiveGoodsList = goods:make_give_goods_list(616, [{GiftId, 1}]),
                    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                    activity:get_notice(Player, [33], true),
                    {NewPlayer, 1}
            end
    end.

get_1_data(RankType) ->
    RankInfo =
        case RankType of
            ?OPEN_ALL_RANK_MOUNT ->
                rank:get_rank_top_N(?RANK_TYPE_MOUNT, 1);
            ?OPEN_ALL_RANK_WING ->
                rank:get_rank_top_N(?RANK_TYPE_WING, 1);
            ?OPEN_ALL_RANK_MAGIC_WEAPON ->
                rank:get_rank_top_N(?RANK_TYPE_FABAO, 1);
            ?OPEN_ALL_RANK_LIGHT_WEAPON ->
                rank:get_rank_top_N(?RANK_TYPE_SB, 1);
            ?OPEN_ALL_RANK_PET_WEAPON ->
                rank:get_rank_top_N(?RANK_TYPE_YL, 1);
            ?OPEN_ALL_RANK_PET_UP_LV ->
                rank:get_rank_top_N(?RANK_TYPE_PET_STAGE, 1);
            ?OPEN_ALL_RANK_PET_UP_STAR ->
                rank:get_rank_top_N(?RANK_TYPE_PET_STAR, 1);
            ?OPEN_ALL_RANK_FOOTPRINT -> %% 先拿别的排行榜数据顶
                rank:get_rank_top_N(?RANK_TYPE_FOOT, 1);
            ?OPEN_ALL_RANK_CAT_UP_LV ->
                rank:get_rank_top_N(?RANK_TYPE_CAT, 1);
            ?OPEN_ALL_RANK_GOLDEN_BODY_UP_LV ->
                rank:get_rank_top_N(?RANK_TYPE_GOLDEN_BODY, 1);
            ?OPEN_ALL_RANK_GOD_TREASURE_UP_LV ->
                rank:get_rank_top_N(?RANK_TYPE_GOD_TREASURE, 1);
            ?OPEN_ALL_RANK_JADE_UP_LV ->
                rank:get_rank_top_N(?RANK_TYPE_JADE, 1)
        end,
    case RankInfo of
        [#a_rank{rp = Rp}] ->
            ShadowInfo =
                case shadow_proc:get_shadow(Rp#rp.pkey) of
                    #player{nickname = NickName, career = Career, sex = Sex, avatar = Avatar} ->
                        {NickName, Career, Sex, Avatar};
                    _ ->
                        {"", 0, 0, ""}
                end,
            ShadowInfo;
        _ ->
            {"", 0, 0, ""}
    end.

get_stage(_Player, ?OPEN_ALL_RANK_MOUNT) ->
    Mount = mount_util:get_mount(),
    Mount#st_mount.stage;
get_stage(_Player, ?OPEN_ALL_RANK_WING) ->
    WingSt = lib_dict:get(?PROC_STATUS_WING),
    WingSt#st_wing.stage;
get_stage(_Player, ?OPEN_ALL_RANK_MAGIC_WEAPON) ->
    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    MagicWeapon#st_magic_weapon.stage;
get_stage(_Player, ?OPEN_ALL_RANK_LIGHT_WEAPON) ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    LightWeapon#st_light_weapon.stage;
get_stage(_Player, ?OPEN_ALL_RANK_PET_WEAPON) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    PetWeapon#st_pet_weapon.stage;
get_stage(_Player, ?OPEN_ALL_RANK_PET_UP_LV) ->
    PetSt = lib_dict:get(?PROC_STATUS_PET),
    PetSt#st_pet.stage;
get_stage(_Player, ?OPEN_ALL_RANK_PET_UP_STAR) ->
    PetSt = lib_dict:get(?PROC_STATUS_PET),
    PetList = PetSt#st_pet.pet_list,
    F = fun(#pet{star = Lv}) -> Lv end,
    TotalLv = lists:map(F, PetList),
    lists:max([0] ++ TotalLv);
get_stage(_Player, ?OPEN_ALL_RANK_FOOTPRINT) ->
    StFootPrint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    StFootPrint#st_footprint.stage;
get_stage(_Player, ?OPEN_ALL_RANK_CAT_UP_LV) ->
    Cat = lib_dict:get(?PROC_STATUS_CAT),
    Cat#st_cat.stage;
get_stage(_Player, ?OPEN_ALL_RANK_GOLDEN_BODY_UP_LV) ->
    GoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
    GoldenBody#st_golden_body.stage;
get_stage(_Player, ?OPEN_ALL_RANK_GOD_TREASURE_UP_LV) ->
    GodTreasure = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
    GodTreasure#st_god_treasure.stage;
get_stage(_Player, ?OPEN_ALL_RANK_JADE_UP_LV) ->
    Jade = lib_dict:get(?PROC_STATUS_JADE),
    Jade#st_jade.stage;

get_stage(_Player, _type) ->
    1.

get_recv_status(_Player, ?OPEN_ALL_RANK_MOUNT, BaseLv) ->
    Mount = mount_util:get_mount(),
    Mount#st_mount.stage >= BaseLv;
get_recv_status(_Player, ?OPEN_ALL_RANK_WING, BaseLv) ->
    WingSt = lib_dict:get(?PROC_STATUS_WING),
    WingSt#st_wing.stage >= BaseLv;
get_recv_status(_Player, ?OPEN_ALL_RANK_MAGIC_WEAPON, BaseLv) ->
    MagicWeapon = lib_dict:get(?PROC_STATUS_MAGIC_WEAPON),
    MagicWeapon#st_magic_weapon.stage >= BaseLv;
get_recv_status(_Player, ?OPEN_ALL_RANK_LIGHT_WEAPON, BaseLv) ->
    LightWeapon = lib_dict:get(?PROC_STATUS_LIGHT_WEAPON),
    LightWeapon#st_light_weapon.stage >= BaseLv;
get_recv_status(_Player, ?OPEN_ALL_RANK_PET_WEAPON, BaseLv) ->
    PetWeapon = lib_dict:get(?PROC_STATUS_PET_WEAPON),
    PetWeapon#st_pet_weapon.stage >= BaseLv;
get_recv_status(_Player, ?OPEN_ALL_RANK_PET_UP_LV, BaseLv) ->
    PetSt = lib_dict:get(?PROC_STATUS_PET),
    PetSt#st_pet.stage >= BaseLv;
get_recv_status(_Player, ?OPEN_ALL_RANK_PET_UP_STAR, BaseLv) ->
    PetSt = lib_dict:get(?PROC_STATUS_PET),
    PetList = PetSt#st_pet.pet_list,
    F = fun(#pet{star = Lv}) -> Lv end,
    TotalLv = lists:map(F, PetList),
    lists:max([0] ++ TotalLv) >= BaseLv;
get_recv_status(_Player, ?OPEN_ALL_RANK_FOOTPRINT, BaseLv) ->
    StFootPrint = lib_dict:get(?PROC_STATUS_FOOTPRINT),
    StFootPrint#st_footprint.stage >= BaseLv;
get_recv_status(_Player, ?OPEN_ALL_RANK_CAT_UP_LV, BaseLv) ->
    Cat = lib_dict:get(?PROC_STATUS_CAT),
    Cat#st_cat.stage >= BaseLv;
get_recv_status(_Player, ?OPEN_ALL_RANK_GOLDEN_BODY_UP_LV, BaseLv) ->
    GoldenBody = lib_dict:get(?PROC_STATUS_GOLDEN_BODY),
    GoldenBody#st_golden_body.stage >= BaseLv;
get_recv_status(_Player, ?OPEN_ALL_RANK_GOD_TREASURE_UP_LV, BaseLv) ->
    GodTreasure = lib_dict:get(?PROC_STATUS_GOD_TREASURE),
    GodTreasure#st_god_treasure.stage >= BaseLv;
get_recv_status(_Player, ?OPEN_ALL_RANK_JADE_UP_LV, BaseLv) ->
    Jade = lib_dict:get(?PROC_STATUS_JADE),
    Jade#st_jade.stage >= BaseLv;

get_recv_status(_Player, _type, _BaseLv) ->
    false.

get_act() ->
    case activity:get_work_list(data_open_all_rank) of
        [] -> [];
        [Base | _] -> Base
    end.

get_sub_act_type() ->
    case get_act() of
        [] ->
            0;
        #base_open_act_all_rank{list = BaseList} ->
            {ActType, _, _, _, _, _} = hd(BaseList),
            ActType
    end.