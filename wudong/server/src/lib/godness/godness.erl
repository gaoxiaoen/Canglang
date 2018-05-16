%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 神祇
%%% @end
%%% Created : 29. 十二月 2017 15:10
%%%-------------------------------------------------------------------
-module(godness).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("godness.hrl").
-include("goods.hrl").
-include("skill.hrl").

-export([
    get_godness_list/1 %% 读取神祇列表
    , act_godness/2 %% 激活神祇
    , up_star/2 %% 升星神祇
    , on_war/2 %% 出战
    , up_lv/3 %% 升级
    , act_skill/2 %% 通灵激活技能
]).

%% 内部接口
-export([
    add_godness/2 %% 获得神祇
    , init_act_godness/2 %% %% 激活神祇
    , send_godness_to_client/2 %% 更新客户端数据
    , cacl_suit_skill/1 %% 计算神祇神魂套装激活
    , recalc_godness_suit/1 %% 计算神祇套装属性
    , update_skill/1 %% 更新神祇技能列表
    , get_war_godness_icon/0 %% 获取神祇图标
    , get_war_godness_skill/0 %% 获取出战神祇技能
]).

get_war_godness_skill() ->
    St = lib_dict:get(?PROC_STATUS_GODNESS),
    #st_godness{godness_list = GodnessList} = St,
    case lists:keyfind(1, #godness.is_war, GodnessList) of
        false -> [];
        #godness{skill_list = SkillList} ->
            SkillList
    end.

get_war_godness_icon() ->
    St = lib_dict:get(?PROC_STATUS_GODNESS),
    #st_godness{godness_list = GodnessList} = St,
    case lists:keyfind(1, #godness.is_war, GodnessList) of
        false -> [];
        #godness{godness_id = GodnessId} ->
            #godness{icon = Icon} = data_godness:get(GodnessId),
            Icon
    end.

act_skill(Player, GodnessKey) ->
    StGodness = lib_dict:get(?PROC_STATUS_GODNESS),
    #st_godness{godness_list = GodnessList} = StGodness,
    case lists:keytake(GodnessKey, #godness.key, GodnessList) of
        false -> {4, Player};
        {value, Godness, Rest} ->
            #godness{skill_list = SkillList, godness_id = GodnessId, star = Star} = Godness,
            F = fun(SkillId) ->
                F0 = fun(LimitStar) ->
                    case data_godness_skill:get(GodnessId, SkillId, LimitStar) of
                        [] -> [];
                        SkillId -> [];
                        NextSkillId ->
                            [{SkillId, LimitStar, NextSkillId}]
                    end
                end,
                lists:flatmap(F0, lists:seq(1, Star))
            end,
            LL = lists:flatmap(F, SkillList),
            if
                LL == [] -> {11, Player}; %% 技能全部满级
                true ->
                    case check_act_skill(Player) of
                        false -> {3, Player}; %% 材料不足
                        true ->
                            {RandSkillId, _LimitStar, NextSkillId} = util:list_rand(LL),
                            NSkillList = lists:delete(RandSkillId, SkillList),
                            NewSkillList = [NextSkillId | NSkillList],
                            NewGodness = Godness#godness{skill_list = util:list_filter_repeat(NewSkillList)},
                            godness_load:update(NewGodness),
                            NStGodness = StGodness#st_godness{godness_list = [NewGodness | Rest]},
                            NStGodness00 = godness_attr:calc_player_attribute(NStGodness),
                            NewStGodness = godness:update_skill(NStGodness00),
                            lib_dict:put(?PROC_STATUS_GODNESS, NewStGodness),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            send_godness_to_client(NewPlayer#player.sid, NewGodness),
                            Sql = io_lib:format("insert into log_godness_skill set pkey=~p,godness_id=~p,godness_key=~p,befor_skill_list='~s',after_skill_list='~s',time=~p",
                                [Player#player.key, Godness#godness.godness_id, Godness#godness.key, util:term_to_bitstring(Godness#godness.skill_list), util:term_to_bitstring(NewGodness#godness.skill_list), util:unixtime()]),
                            log_proc:log(Sql),
                            {1, NewPlayer#player{
                                godness_skill = NewStGodness#st_godness.skill_list,
                                passive_skill = NewStGodness#st_godness.godsoul_skill_list ++ Player#player.passive_skill
                            }}
                    end
            end
    end.

check_act_skill(Player) ->
    TatalCount = goods_util:get_goods_count(?GODNESS_SKILL_COST_GOOODSID),
    if
        TatalCount > 0 ->
            {ok, _} = goods:subtract_good(Player, [{?GODNESS_SKILL_COST_GOOODSID, 1}], 743),
            true;
        true -> false
    end.

up_lv(Player, GodnessKey, Consume) ->
    StGodness = lib_dict:get(?PROC_STATUS_GODNESS),
    #st_godness{godness_list = GodnessList} = StGodness,
    case lists:keytake(GodnessKey, #godness.key, GodnessList) of
        false ->
            {0, Player};
        {value, Godness, Rest} ->
            case check_up_lv(Godness) of
                {fail, Code} ->
                    {Code, Player};
                true ->
                    case get_exp(Player, Consume, Godness) of
                        0 -> {3, Player};
                        AddExp ->
                            ?DEBUG("AddExp:~p", [AddExp]),
                            NGodness = cacl_godness(Godness, AddExp),
                            NewGodness = godness_attr:cacl_singleton_godness_attribute(NGodness),
                            godness_load:update(NewGodness),
                            NStGodness = StGodness#st_godness{godness_list = [NewGodness | Rest]},
                            NewStGodness = godness_attr:calc_player_attribute(NStGodness),
                            lib_dict:put(?PROC_STATUS_GODNESS, NewStGodness),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            send_godness_to_client(NewPlayer#player.sid, NewGodness),
                            Sql = io_lib:format("insert into log_godness_uplv set pkey=~p,godness_id=~p,godness_key=~p,befor_exp=~p,after_exp=~p,befor_lv=~p,after_lv=~p, cost='~s', time=~p",
                                [Player#player.key, Godness#godness.godness_id, Godness#godness.key, Godness#godness.exp, NewGodness#godness.exp, Godness#godness.lv, NewGodness#godness.lv, util:term_to_bitstring(Consume), util:unixtime()]),
                            log_proc:log(Sql),
                            {1, NewPlayer}
                    end
            end
    end.

check_up_lv(Godness) ->
    #godness{star = Star, godness_id = GodnessId} = Godness,
    #godness{max_lv = MaxLv} = data_godness:get(GodnessId),
    Lv =
        case lists:keyfind(Star, 1, MaxLv) of
            false -> 0;
            {_Star, Lv0} -> Lv0
        end,
    if
        Lv > Godness#godness.lv -> true;
        true -> {fail, 10} %% 已经最高级
    end.


cacl_godness(Godness, 0) -> Godness;

cacl_godness(Godness, AddExp) ->
    #godness{exp = Exp, lv = Lv} = Godness,
    case data_godness_uplv:get(Godness#godness.lv) of
        [] ->
            Godness#godness{exp = Godness#godness.exp + AddExp};
        CostExp ->
            if
                Godness#godness.exp + AddExp < CostExp ->
                    Godness#godness{exp = Godness#godness.exp + AddExp};
                true ->
                    cacl_godness(Godness#godness{exp = 0, lv = Lv + 1}, AddExp - CostExp + Exp)
            end
    end.

get_exp(Player, Consume, Godness) ->
    #godness{exp = Exp, lv = Lv} = Godness,
    CostExp = data_godness_uplv:get(Lv),
    NeedExp = CostExp - Exp,

    F = fun([CostGoodsId, _CostNum], {AccExp, AccFlag}) ->
        case AccFlag of
            false ->
                #goods_type{special_param_list = BaseExp} = data_goods:get(CostGoodsId),
                TatalCount = goods_util:get_goods_count(CostGoodsId),
                if
                    NeedExp - AccExp > TatalCount * BaseExp ->
                        {ok, _} = goods:subtract_good(Player, [{CostGoodsId, TatalCount}], 744),
                        {TatalCount * BaseExp + AccExp, false};
                    true ->
                        CostNum = (NeedExp - AccExp) div BaseExp + 1,
                        {ok, _} = goods:subtract_good(Player, [{CostGoodsId, CostNum}], 744),
                        {CostNum * BaseExp + AccExp, true}
                end;
            true ->
                {AccExp, AccFlag}
        end
    end,
    {AddExp, _} = lists:foldl(F, {0, false}, Consume),
    AddExp.


%% 出战
on_war(Player, GodnessKey) ->
    StGodness = lib_dict:get(?PROC_STATUS_GODNESS),
    #st_godness{godness_list = GodnessList} = StGodness,
    case lists:keyfind(1, #godness.is_war, GodnessList) of
        #godness{key = GodnessKey} -> {5, Player}; %% 已经出战
        false ->
            case lists:keytake(GodnessKey, #godness.key, GodnessList) of
                false -> {0, Player};
                {value, Godness, Rest} ->
                    NGodness = Godness#godness{is_war = 1},
                    NewGodness = godness_attr:cacl_singleton_godness_attribute(NGodness),
                    godness_load:update(NewGodness),
                    NStGodness = StGodness#st_godness{godness_list = [NewGodness | Rest]},
                    NStGodness00 = godness_attr:calc_player_attribute(NStGodness),
                    NewStGodness = godness:update_skill(NStGodness00),
                    lib_dict:put(?PROC_STATUS_GODNESS, NewStGodness),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    send_godness_to_client(NewPlayer#player.sid, NewGodness),
                    {1, NewPlayer#player{
                        godness_skill = NewStGodness#st_godness.skill_list,
                        passive_skill = NewStGodness#st_godness.godsoul_skill_list ++ Player#player.passive_skill
                    }}
            end;
        OldGodness -> %% 替换掉之前出战的
            OldGodness99 = godness_attr:cacl_singleton_godness_attribute(OldGodness#godness{is_war = 0}),
            NewGodnessList = lists:keyreplace(OldGodness#godness.key, #godness.key, GodnessList, OldGodness99),
            case lists:keytake(GodnessKey, #godness.key, NewGodnessList) of
                false -> {0, Player};
                {value, Godness, Rest} ->
                    NGodness = Godness#godness{is_war = 1},
                    NewGodness = godness_attr:cacl_singleton_godness_attribute(NGodness),
                    godness_load:update(OldGodness99),
                    godness_load:update(NewGodness),
                    NStGodness = StGodness#st_godness{godness_list = [NewGodness | Rest]},
                    NStGodness00 = godness_attr:calc_player_attribute(NStGodness),
                    NewStGodness = godness:update_skill(NStGodness00),
                    lib_dict:put(?PROC_STATUS_GODNESS, NewStGodness),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    send_godness_to_client(NewPlayer#player.sid, OldGodness99),
                    send_godness_to_client(NewPlayer#player.sid, NewGodness),
                    {1, NewPlayer#player{
                        godness_skill = NewStGodness#st_godness.skill_list,
                        passive_skill = NewStGodness#st_godness.godsoul_skill_list ++ Player#player.passive_skill
                    }}
            end
    end.

%% 升星
up_star(Player, GodnessKey) ->
    StGodness = lib_dict:get(?PROC_STATUS_GODNESS),
    #st_godness{godness_list = GodnessList} = StGodness,
    case lists:keytake(GodnessKey, #godness.key, GodnessList) of
        false -> {4, Player}; %% 未激活
        {value, #godness{godness_id = GodnessId, star = Star} = Godness, Rest} ->
            case check_up_star_godness(Star + 1, GodnessId) of
                {fail, Code} ->
                    {Code, Player};
                {true, CostGoodsId, CostNum} ->
                    case goods:subtract_good(Player, [{CostGoodsId, CostNum}], 745) of
                        {ok, _} ->
                            Godness1 = update_godness_skill(Godness#godness{star = Star + 1}),
                            NewGodness = godness_attr:cacl_singleton_godness_attribute(Godness1),
                            godness_load:update(NewGodness),
                            StGodness0 = StGodness#st_godness{godness_list = [NewGodness | Rest]},
                            StGodness1 = godness:update_skill(StGodness0),
                            NewStGodness = godness_attr:calc_player_attribute(StGodness1),
                            lib_dict:put(?PROC_STATUS_GODNESS, NewStGodness),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            send_godness_to_client(NewPlayer#player.sid, NewGodness),
                            Sql = io_lib:format("insert into log_godness_upstar set pkey=~p,godness_id=~p,godness_key=~p,cost='~s',befor_star=~p,after_star=~p,time=~p",
                                [Player#player.key, Godness#godness.godness_id, Godness#godness.key, util:term_to_bitstring([CostGoodsId, CostNum]), Godness#godness.star, NewGodness#godness.star, util:unixtime()]),
                            log_proc:log(Sql),
                            {1, NewPlayer};
                        _ -> %% 扣除未成功
                            {0, Player}
                    end
            end
    end.

%% 升星激活技能
update_godness_skill(Godness) ->
    #godness{star = Star, godness_id = GodnessId, skill_list = SkillList} = Godness,
    #godness{init_skill = InitSkill} = data_godness:get(GodnessId),
    F = fun({BaseStar, SkillId}) ->
        ?IF_ELSE(Star /= BaseStar, [], [SkillId])
    end,
    AddSkillList = lists:flatmap(F, InitSkill),
    Godness#godness{skill_list = SkillList ++ AddSkillList}.

%% 激活神祇
act_godness(Player, GodnessId) ->
    StGodness = lib_dict:get(?PROC_STATUS_GODNESS),
    #st_godness{godness_list = GodnessList} = StGodness,
    case lists:keyfind(GodnessId, #godness.godness_id, GodnessList) of
        #godness{} -> {2, Player}; %% 已经激活
        false ->
            case check_up_star_godness(1, GodnessId) of
                {fail, Code} ->
                    {Code, Player};
                {true, CostGoodsId, CostNum} ->
                    case goods:subtract_good(Player, [{CostGoodsId, CostNum}], 746) of
                        {ok, _} ->
                            Godness = add_godness(Player#player.key, GodnessId),
                            NStGodness = StGodness#st_godness{godness_list = [Godness | GodnessList]},
                            NewStGodness = godness_attr:calc_player_attribute(NStGodness),
                            lib_dict:put(?PROC_STATUS_GODNESS, NewStGodness),
                            NewPlayer = player_util:count_player_attribute(Player, true),
                            send_godness_to_client(NewPlayer#player.sid, Godness),
                            {1, NewPlayer};
                        _ -> %% 扣除未成功
                            {0, Player}
                    end
            end
    end.

%% 激活神祇
init_act_godness(Player, GodnessId) ->
    StGodness = lib_dict:get(?PROC_STATUS_GODNESS),
    #st_godness{godness_list = GodnessList} = StGodness,
    case GodnessList == [] of
        false -> ok;
        true ->
            Godness = add_godness(Player#player.key, GodnessId),
            NStGodness = StGodness#st_godness{godness_list = [Godness | GodnessList]},
            NewStGodness = godness_attr:calc_player_attribute(NStGodness),
            lib_dict:put(?PROC_STATUS_GODNESS, NewStGodness)
    end.

%% 检查进阶
check_up_star_godness(TargeStar, GodnessId) ->
    case data_godness:get(GodnessId) of
        #godness{up_star_cost = UpStarCost} ->
            case lists:keyfind(TargeStar, 1, UpStarCost) of
                false -> {fail, 9};
                {_Star, CostGoodsId, CostNum} ->
                    TatalCount = goods_util:get_goods_count(CostGoodsId),
                    if
                        CostNum == 0 -> {fail, 0}; %% 配置错误
                        TatalCount < CostNum -> {fail, 3}; %% 材料不足
                        true -> {true, CostGoodsId, CostNum}
                    end
            end;
        _ -> {fail, 0}
    end.

send_godness_to_client(Sid, Godness) ->
    Data = pack_godness(Godness),
%%     ?DEBUG("Data:~p", [Data]),
    {ok, Bin} = pt_444:write(44403, list_to_tuple(Data)),
    server_send:send_to_sid(Sid, Bin).

%% 读取神祇列表
get_godness_list(_Player) ->
    StGodness = lib_dict:get(?PROC_STATUS_GODNESS),
    #st_godness{
        godness_list = GodnessList
    } = StGodness,
    F = fun(Godness) ->
        pack_godness(Godness)
    end,
    lists:map(F, GodnessList).

add_godness(Pkey, GodnessId) ->
    case data_godness:get(GodnessId) of
        [] -> [];
        #godness{init_skill = InitSkillList} = Godness ->
            F = fun({Star, SkillId}) ->
                if
                    Star == 1 -> [SkillId];
                    true -> []
                end
            end,
            SkillList = lists:flatmap(F, InitSkillList),
            Key = misc:unique_key(),
            NewGodness = Godness#godness{pkey = Pkey, key = Key, skill_list = SkillList},
            NewGodness99 = godness_attr:cacl_singleton_godness_attribute(NewGodness),
            godness_load:update(NewGodness99),
            NewGodness99
    end.

pack_godness(Godness) ->
    #godness{
        key = Key,
        godness_id = GodnessId,
        lv = Lv,
        star = Star,
        is_war = IsWar,
        exp = Exp,
        skill_list = SkillList,
        war_attr = WarAttr,
        sum_attr = SumAttr,
        wear_god_soul_attr = SumGodSoulAttr,
        suit_skill_list = SuitSkillList,
        suit_attr = SuitAttr,
        suit_percent_attr = SuitPercentAttr
    } = Godness,
    AttrList1 = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- attribute_util:make_attribute_to_key_val(SumAttr)],
    AttrList2 = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- attribute_util:make_attribute_to_key_val(WarAttr)],
    AttrList3 = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- attribute_util:make_attribute_to_key_val(SumGodSoulAttr)],
    AttrList4 = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- attribute_util:make_attribute_to_key_val(SuitAttr)],
    AttrList5 = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- attribute_util:make_attribute_to_key_val(SuitPercentAttr)],
    ProSuitSkillList = util:list_tuple_to_list(SuitSkillList),
    StGoods = lib_dict:get(?PROC_STATUS_GOODS),
    F = fun(#weared_god_soul{wear_key = WearKey, goods_key = GoodsKey}) ->
        if
            WearKey == Key -> [GoodsKey];
            true -> []
        end
    end,
    WearKeyList = lists:flatmap(F, StGoods#st_goods.weared_god_soul),
    [Key, GodnessId, Lv, IsWar, Star, Exp, SkillList, AttrList1, AttrList2, AttrList3, ProSuitSkillList, WearKeyList, AttrList4, AttrList5].

%% 计算激活套装列表 [{SuitId, N, SkillId}]
cacl_suit_skill(Godness) ->
    #godness{key = Key} = Godness,
    StGoods = lib_dict:get(?PROC_STATUS_GOODS),
    F = fun(#weared_god_soul{wear_key = WearKey, goods_id = GoodsId}) ->
        if
            WearKey == Key -> [GoodsId];
            true -> []
        end
    end,
    GoodsIdList = lists:flatmap(F, StGoods#st_goods.weared_god_soul),
    AllSuitId = data_god_soul_suit:get_all(),
    F1 = fun(SuitId) ->
        F2 = fun(GoodsId) ->
            if
                GoodsId div 10 rem 10 == SuitId - 1 -> [GoodsId];
                true -> []
            end
        end,
        LL = lists:flatmap(F2, GoodsIdList),
        ConditionList = data_god_soul_suit:get(SuitId),
        F3 = fun({N, SkillId}) ->
            if
                length(LL) >= N -> [{SuitId, N, SkillId}];
                true -> []
            end
        end,
        lists:flatmap(F3, ConditionList)
    end,
    SuitSkillList = lists:flatmap(F1, AllSuitId),
    F4 = fun({_SuitId, _N, SkillId}) ->
        case data_skill:get(SkillId) of
            [] -> [];
            #skill{attrs = Attrs} ->
                [attribute_util:make_attribute_by_key_val_list(Attrs)]
        end
    end,
    SuitAttr = attribute_util:sum_attribute(lists:flatmap(F4, SuitSkillList)),
    Godness#godness{suit_skill_list = SuitSkillList, suit_attr = SuitAttr}.

recalc_godness_suit(GodnessKey) ->
    StGodness = lib_dict:get(?PROC_STATUS_GODNESS),
    #st_godness{godness_list = GodnessList} = StGodness,
    case lists:keytake(GodnessKey, #godness.key, GodnessList) of
        false ->
            ok;
        {value, Godness, Rest} ->
            NewGodness = cacl_suit_skill(Godness),
            NewGodnessList = [NewGodness | Rest],
            NewStGodness = StGodness#st_godness{godness_list = NewGodnessList},
            lib_dict:put(?PROC_STATUS_GODNESS, NewStGodness)
    end.

update_skill(StGodness) ->
    #st_godness{godness_list = GodnessList} = StGodness,
    F = fun(Godness) ->
        #godness{is_war = IsWar, skill_list = SkillList} = Godness,
        if
            IsWar == 0 -> [];
            true -> %% 只有出战时生效
                SkillList
        end
    end,
    GodnessSkillList = lists:flatmap(F, GodnessList),

    F1 = fun(Godness) ->
        #godness{is_war = IsWar, suit_skill_list = SuitSkillList} = Godness,
        if
            IsWar == 0 -> [];
            true -> %% 只有出战时生效
                lists:map(fun({_SuitId, _N, SkillId}) -> {SkillId, ?PASSIVE_SKILL_TYPE_GODSOUL_SUIT} end, SuitSkillList)
        end
    end,
    GodnessWarSkillList = lists:flatmap(F1, GodnessList),
    StGodness#st_godness{skill_list = GodnessSkillList, godsoul_skill_list = GodnessWarSkillList}.