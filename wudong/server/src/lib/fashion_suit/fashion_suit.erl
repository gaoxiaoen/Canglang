%%%-------------------------------------------------------------------
%%% @author lzx
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%             %% 时装套装
%%% @end
%%% Created : 10. 十月 2017 15:14
%%%-------------------------------------------------------------------
-module(fashion_suit).
-include("server.hrl").
-include("fashion_suit.hrl").
-include("common.hrl").
-include("skill.hrl").
-author("lzx").

%% API
-export([
    get_state/0,
    fashion_suit_list/1,
    fashion_suit_info/2,
    active_suit_id/2,
    active_icon_push/1,
    active_suit_lv_attr/2,
    filter_skill_for_battle/1
]).


%% @doc 套装列表
fashion_suit_list(#player{key = _Pkey, sid = Sid}) ->
    #st_fashion_suit{
        fashion_suit_ids = ActFsIds,
        fashion_act_suit_ids = ActFsSuitIds,
        attribute = AttriButeList,
        cbp = Cbp
    } = lib_dict:get(?PROC_STATUS_PLAYER_FASHION_SUIT),
    PackActIds = pack_act_suit_ids(ActFsIds, ActFsSuitIds),
    AllSuitIds = data_fashion_suit:ids(),
    UnActIds = AllSuitIds -- ActFsIds,
    UnPackActIds = pack_act_un_suit_ids(UnActIds),
    SendData = {Cbp, attribute_util:pack_attr(AttriButeList), PackActIds, UnPackActIds},
    {ok, BinData} = pt_441:write(44101, SendData),
    server_send:send_to_sid(Sid, BinData).


%% @doc 单个套装信息
fashion_suit_info(#player{key = _Pkey, sid = Sid}, GoodsId) ->
    #st_fashion_suit{
        fashion_suit_ids = ActFsIds,
        fashion_act_suit_ids = ActFsSuitIds
    } = lib_dict:get(?PROC_STATUS_PLAYER_FASHION_SUIT),
    #base_goods_to_suit{suitId = SuitIds} = data_goods_to_fashion_suit:get(GoodsId),
    SendData = lists:map(fun(SuitId) ->
        IsActive = case lists:member(SuitId, ActFsIds) of
                       true -> 1;
                       _ -> 0
                   end,
        PackSuitList0 = one_suit_pack_list(SuitId),
        PackSuitList = [[TypeId, FashionId, Ret, Lv] || [TypeId, FashionId, Ret, _IsInAct, _FunID, _FunID2, Lv] <- PackSuitList0],
        IndexLv =
            case PackSuitList0 of
                [] -> 0;
                _ -> max(0, lists:min([Lv0 || [_, _, _, _, _, _, Lv0] <- PackSuitList0]))
            end,
        AllLv = case lists:keyfind(SuitId, 1, ActFsSuitIds) of
                    false -> 0;
                    {_, Lv1} -> Lv1
                end,

        [SuitId, IndexLv, AllLv, IsActive, PackSuitList]
    end, SuitIds),

    ?PRINT("44104 ============  Player_id :~w,~w", [_Pkey, SendData]),
    {ok, BinData} = pt_441:write(44104, {SendData}),
    server_send:send_to_sid(Sid, BinData).

pack_act_suit_ids(ActFsIds, ActFsSuitIds) ->
    lists:map(fun(SuitId) ->
        #base_fashion_suit{tar_list = TarList} = data_fashion_suit:get(SuitId),
        PackSuitList0 = one_suit_pack_list(SuitId),
        PackTypeList =
            lists:map(fun({Type, ICon, ShowGoodsID}) ->
                #base_goods_to_suit{funid = FunList} = data_goods_to_fashion_suit:get(ShowGoodsID),
                {IsInAct, FunID, FunID2} = get_act_funid(FunList),
                Lv0 =
                    case [Lv || [_, Id, _, _, _, _, Lv] <- PackSuitList0, Id == ICon] of
                        [] -> 0;
                        LvList -> hd(LvList)
                    end,
                [Type, ICon, IsInAct, FunID, FunID2, Lv0]
            end, TarList),
        IndexLv =
            case PackSuitList0 of
                [] -> 0;
                _ -> max(0, lists:min([Lv0 || [_, _, _, _, _, _, Lv0] <- PackSuitList0]))
            end,

        OldLv =
            case lists:keyfind(SuitId, 1, ActFsSuitIds) of
                false -> 0;
                {SuitId, OldLv0} -> OldLv0
            end,

        Lvs0 = data_fashion_suit_star:get_lvs(SuitId),
        Lvs = [Lv || Lv <- Lvs0, Lv =< IndexLv],

        State = case Lvs of
                    [] -> 0;
                    _ ->
                        MaxLv = lists:max(Lvs),
                        ?IF_ELSE(OldLv >= MaxLv, 0, 1)
                end,
        [SuitId, IndexLv, OldLv, State, PackTypeList]
    end, ActFsIds).


get_act_funid([]) -> {0, 0, 0};
get_act_funid([{ActModule, FunId, FunId2} | T]) ->
    case activity:get_work_list(ActModule) of
        [_Base | _] ->
            {1, FunId, FunId2};
        _ ->
            get_act_funid(T)
    end.


%% 未激活
pack_act_un_suit_ids(UnActFsIds) ->
    lists:map(fun(SuitId) ->
        PackTypeList = one_suit_pack_list(SuitId),
        IsActive2 = check_active_suit_id(SuitId),
        [SuitId, 0, 0, IsActive2, PackTypeList]
    end, UnActFsIds).



one_suit_pack_list(SuitId) ->
    SuitRecord = data_fashion_suit:get(SuitId),
    lists:map(fun({1, FashionId, ShowGoodsID}) ->
        {IsActive, Lv} = fashion:is_activate2(FashionId),
        Ret = ?IF_ELSE(IsActive, 1, 0),
        #base_goods_to_suit{funid = FunList} = data_goods_to_fashion_suit:get(ShowGoodsID),
        {IsInAct, FunID, FunID2} = get_act_funid(FunList),
        [1, FashionId, Ret, IsInAct, FunID, FunID2, Lv];
        ({2, BubbleId, ShowGoodsID}) ->
            {IsActive, Lv} = bubble:is_activate2(BubbleId),
            Ret = ?IF_ELSE(IsActive, 1, 0),
            #base_goods_to_suit{funid = FunList} = data_goods_to_fashion_suit:get(ShowGoodsID),
            {IsInAct, FunID, FunID2} = get_act_funid(FunList),
            [2, BubbleId, Ret, IsInAct, FunID, FunID2, Lv];
        ({3, DecoraId, ShowGoodsID}) ->
            {IsActive, Lv} = decoration:is_activate2(DecoraId),
            Ret = ?IF_ELSE(IsActive, 1, 0),
            #base_goods_to_suit{funid = FunList} = data_goods_to_fashion_suit:get(ShowGoodsID),
            {IsInAct, FunID, FunID2} = get_act_funid(FunList),
            [3, DecoraId, Ret, IsInAct, FunID, FunID2, Lv];
        ({4, DesId, ShowGoodsID}) ->
            {IsActive, Lv} = designation:is_activate2(DesId),
            Ret = ?IF_ELSE(IsActive, 1, 0),
            #base_goods_to_suit{funid = FunList} = data_goods_to_fashion_suit:get(ShowGoodsID),
            {IsInAct, FunID, FunID2} = get_act_funid(FunList),
            [4, DesId, Ret, IsInAct, FunID, FunID2, Lv];
        ({5, MountId, ShowGoodsID}) ->
            {IsActive, Lv} = mount:have_mount(MountId),
            Ret = ?IF_ELSE(IsActive, 1, 0),
            #base_goods_to_suit{funid = FunList} = data_goods_to_fashion_suit:get(ShowGoodsID),
            {IsInAct, FunID, FunID2} = get_act_funid(FunList),
            [5, MountId, Ret, IsInAct, FunID, FunID2, Lv];

        ({6, WeaponId, ShowGoodsID}) ->
            {IsActive, Lv} = light_weapon:have_light_weapon(WeaponId),
            Ret = ?IF_ELSE(IsActive, 1, 0),
            #base_goods_to_suit{funid = FunList} = data_goods_to_fashion_suit:get(ShowGoodsID),
            {IsInAct, FunID, FunID2} = get_act_funid(FunList),
            [6, WeaponId, Ret, IsInAct, FunID, FunID2, Lv];

        ({7, WingId, ShowGoodsID}) ->
            {IsActive, Lv} = wing:have_wing(WingId),
            Ret = ?IF_ELSE(IsActive, 1, 0),
            #base_goods_to_suit{funid = FunList} = data_goods_to_fashion_suit:get(ShowGoodsID),
            {IsInAct, FunID, FunID2} = get_act_funid(FunList),
            [7, WingId, Ret, IsInAct, FunID, FunID2, Lv];

        ({8, PetIMageId, ShowGoodsID}) -> %%加了
            {IsActive, Lv} = pet_pic:is_active(PetIMageId),
            Ret = ?IF_ELSE(IsActive, 1, 0),
            #base_goods_to_suit{funid = FunList} = data_goods_to_fashion_suit:get(ShowGoodsID),
            {IsInAct, FunID, FunID2} = get_act_funid(FunList),
            [8, PetIMageId, Ret, IsInAct, FunID, FunID2, Lv];

        ({9, HeadId, ShowGoodsID}) -> %% 加了
            {IsActive, Lv} = head:is_activate2(HeadId),
            Ret = ?IF_ELSE(IsActive, 1, 0),
            #base_goods_to_suit{funid = FunList} = data_goods_to_fashion_suit:get(ShowGoodsID),
            {IsInAct, FunID, FunID2} = get_act_funid(FunList),
            [9, HeadId, Ret, IsInAct, FunID, FunID2, Lv]
    end, SuitRecord#base_fashion_suit.tar_list).


%%  检查能否激活
check_active_suit_id(_SuitId) ->
    SuitStates = one_suit_pack_list(_SuitId),
    Ret = lists:foldl(fun([_, _, Ret, _, _, _, _], AccState) ->
        case Ret =< 0 of
            true -> false;
            _ ->
                AccState
        end
    end, true, SuitStates),
    ?IF_ELSE(Ret, 1, 0).

%%  检查能否升级
check_active_suit_id_up(SuitId) ->
    #st_fashion_suit{
        fashion_act_suit_ids = ActFsIds
    } = lib_dict:get(?PROC_STATUS_PLAYER_FASHION_SUIT),
    PackSuitList0 = one_suit_pack_list(SuitId),
    IndexLv =
        case PackSuitList0 of
            [] -> 0;
            _ -> max(0, lists:min([Lv0 || [_, _, _, _, _, _, Lv0] <- PackSuitList0]))
        end,
    Lvs0 = data_fashion_suit_star:get_lvs(SuitId),
    Lvs = [Lv || Lv <- Lvs0, Lv =< IndexLv],
    case Lvs of
        [] -> 0;
        _ ->
            MaxLv = lists:max(Lvs),
            case lists:keyfind(SuitId, 1, ActFsIds) of
                false ->
                    1;
                {_, OldLv} ->
                    ?IF_ELSE(OldLv >= MaxLv, 0, 1)
            end
    end.


%% @doc 激活
active_suit_id(Player, SuitId) ->
    #st_fashion_suit{
        fashion_suit_ids = ActFsIds
    } = FsSt = lib_dict:get(?PROC_STATUS_PLAYER_FASHION_SUIT),
    ?ASSERT_TRUE(lists:member(SuitId, ActFsIds), {fail, 2}),
    IsActive = check_active_suit_id(SuitId),
    ?ASSERT_TRUE(IsActive =< 0, {fail, 3}),
    NewFaSt = FsSt#st_fashion_suit{fashion_suit_ids = [SuitId | ActFsIds], is_change = 1},
    fashion_suit_init:cal_fashion_suit_attrbute(NewFaSt),
    log_fashion_suit(Player#player.key, SuitId, NewFaSt#st_fashion_suit.fashion_suit_ids),
    NewPlayer = player_util:count_player_attribute(Player, true),
    {ok, NewPlayer}.


%% 日志
log_fashion_suit(Pkey, SuitId, AllIds) ->
    NowTime = util:unixtime(),
    Sql = io_lib:format("insert into log_fashion_suit set pkey = ~p,act_suit_id = ~p,all_ids = '~s',time = ~p",
        [Pkey, SuitId, util:term_to_bitstring(AllIds), NowTime]),
    log_proc:log(Sql).


%% @doc 红圈
get_state() ->
    #st_fashion_suit{
        fashion_suit_ids = ActFsIds
    } = lib_dict:get(?PROC_STATUS_PLAYER_FASHION_SUIT),
    AllSuitIds = data_fashion_suit:ids(),
    UnActIds = AllSuitIds -- ActFsIds,
    Ret = lists:any(fun(SuitId) ->
        IsActive = check_active_suit_id(SuitId),
        ?IF_ELSE(IsActive > 0, true, false)
    end, UnActIds),

    Ret2 = lists:any(fun(SuitId) ->
        IsActive2 = check_active_suit_id_up(SuitId),
        ?IF_ELSE(IsActive2 > 0, true, false)
    end, AllSuitIds),

    ?IF_ELSE(Ret orelse Ret2, 1, 0).


%% 套装可激活推送
active_icon_push(Player) ->
    case get_state() of
        1 ->
            activity:get_notice(Player, [164], true),
            {ok, BinData} = pt_441:write(44103, {}),
            server_send:send_to_sid(Player#player.sid, BinData);
        _ ->
            ok
    end.

active_suit_lv_attr(Player, SuitId) ->
    #st_fashion_suit{
        fashion_act_suit_ids = ActFsIds
    } = FsSt = lib_dict:get(?PROC_STATUS_PLAYER_FASHION_SUIT),
    PackSuitList0 = one_suit_pack_list(SuitId),
    IndexLv =
        case PackSuitList0 of
            [] -> 0;
            _ -> max(0, lists:min([Lv0 || [_, _, _, _, _, _, Lv0] <- PackSuitList0]))
        end,
    Lvs0 = data_fashion_suit_star:get_lvs(SuitId),
    MaxLv00 =
        case Lvs0 of
                  [] -> 0;
                  _ -> lists:max(Lvs0)
              end,
    Lvs = [Lv || Lv <- Lvs0, Lv =< IndexLv],
    ?DEBUG("Lvs ~p~n", [Lvs]),
    case Lvs of
        [] -> {4, Player};
        _ ->
            MaxLv = lists:max(Lvs),
            case lists:keytake(SuitId, 1, ActFsIds) of
                false ->



                    NewFaSt = FsSt#st_fashion_suit{fashion_act_suit_ids = [{SuitId, MaxLv} | ActFsIds], is_change = 1},
                    fashion_suit_init:cal_fashion_suit_attrbute(NewFaSt),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    {SkillList0, OldId} =
                        case data_fashion_suit_star:get(SuitId, MaxLv) of
                            [] -> {[], 0};
                            #base_fashion_suit_star{skill = Skill} ->
                                case lists:keytake(SuitId, 1, FsSt#st_fashion_suit.skill_list) of
                                    false ->
                                        {[{SuitId, Skill} | FsSt#st_fashion_suit.skill_list], 0};
                                    {value, {SuitId, OldId0}, T} ->
                                        {[{SuitId, Skill} | T], OldId0}
                                end
                        end,
                    SkillList = [Skill0 || {_, Skill0} <- SkillList0],
                    St1 = lib_dict:get(?PROC_STATUS_PLAYER_FASHION_SUIT),
                    lib_dict:put(?PROC_STATUS_PLAYER_FASHION_SUIT, St1#st_fashion_suit{skill_list = SkillList0}),
                    NewPassiveSkill = lists:keydelete(OldId, 1, NewPlayer#player.passive_skill),
                    PassiveSkillList = [{Sid, Type} || {Sid, Type} <- NewPassiveSkill, Type /= ?PASSIVE_SKILL_TYPE_FASHION_SUIT] ++ filter_skill_for_battle(SkillList),
                    scene_agent_dispatch:passive_skill(NewPlayer, PassiveSkillList),
                    ?DEBUG("PassiveSkillList ~p~n",[PassiveSkillList]),
                    {1, NewPlayer#player{passive_skill = PassiveSkillList}};
                {value, {SuitId, OldLv}, T} ->
                    ?DEBUG(" ~p ~p~n",[OldLv,MaxLv00]),
                    ?DEBUG("~p~n",[MaxLv]),
                    if
                        OldLv == MaxLv00 -> {5, Player};
                        OldLv >= MaxLv -> {4, Player};
                        true ->
                            NewFaSt = FsSt#st_fashion_suit{fashion_act_suit_ids = [{SuitId, MaxLv} | T], is_change = 1},
                            fashion_suit_init:cal_fashion_suit_attrbute(NewFaSt),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            {SkillList0, OldId} =
                                case data_fashion_suit_star:get(SuitId, MaxLv) of
                                    [] -> {[], 0};
                                    #base_fashion_suit_star{skill = Skill} ->
                                        case lists:keytake(SuitId, 1, FsSt#st_fashion_suit.skill_list) of
                                            false ->
                                                {[{SuitId, Skill} | FsSt#st_fashion_suit.skill_list], 0};
                                            {value, {_, OldId011}, T0} ->
                                                {[{SuitId, Skill} | T0], OldId011}
                                        end
                                end,
                            SkillList = [Skill0 || {_, Skill0} <- SkillList0],
                            St1 = lib_dict:get(?PROC_STATUS_PLAYER_FASHION_SUIT),
                            lib_dict:put(?PROC_STATUS_PLAYER_FASHION_SUIT, St1#st_fashion_suit{skill_list = SkillList0}),
                            NewPassiveSkill = lists:keydelete(OldId, 1, NewPlayer#player.passive_skill),
                            PassiveSkillList = [{Sid, Type} || {Sid, Type} <- NewPassiveSkill, Type /= ?PASSIVE_SKILL_TYPE_FASHION_SUIT] ++ filter_skill_for_battle(SkillList),
                            scene_agent_dispatch:passive_skill(NewPlayer, PassiveSkillList),
                            ?DEBUG("PassiveSkillList ~p~n",[PassiveSkillList]),
                            {1, NewPlayer#player{passive_skill = PassiveSkillList}}
                    end
            end
    end.

%%过滤战斗技能
filter_skill_for_battle(SkillList) ->
    F = fun(SkillId) ->
        case data_skill:get(SkillId) of
            [] -> [];
            Skill ->
                if Skill#skill.type == ?SKILL_TYPE_PASSIVE ->
                    [{SkillId, ?PASSIVE_SKILL_TYPE_FASHION_SUIT}];
                    true -> []
                end
        end
    end,
    lists:flatmap(F, SkillList).


