%%%-------------------------------------------------------------------
%%% @author lzx
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%             宝宝系统
%%% @end
%%%-------------------------------------------------------------------
-module(baby).
-include("baby.hrl").
-include("server.hrl").
-include("skill.hrl").
-include("goods.hrl").
-include("common.hrl").
-include("tips.hrl").
-include("player_mask.hrl").
-include("daily.hrl").

%% API
-export([
    pack_data/1,
    go_fight/1,
    change_name/3,
    upgrade_step/2,
    feed_baby/2,
    change_sex/1,
    create_baby/3,
    check_baby_born/2,
    check_baby_born_time_icon/2,
    upgrade_skill/2,
    change_figure/2,
    pic_list/1,
    active_pic/2,
    equip_goods/2,
    signin_info_list/1,
    sign_up/3,
    couple_upgrade/1,
    get_kill_award/2,
    kill_mon/2,
    check_skill_state/0,
    check_update_step_state/1,
    check_kill_award_state/0,
    check_update_lv_state/0,
    check_sign_up_state/1,
    check_pic_active_state/0,
    time_speed/2,
    couple_speed_up/1,
    check_equip_state/1,
    time_icon_push/1,
    baby_equip_attr_view/0,
    pack_baby_skill_13041/3
]).


%% @doc 打包宝宝数据
pack_data(#player{} = Player) ->
    #baby_st{
        type_id = TypeId, step = Step, step_exp = StepExp, lv = Lv, lv_exp = LvExp,
        name = BabyName, figure_id = FigureId, state = State, cbp = Cbp, attribute = AttrList, skill_list = SkillList,
        equip_list = EquipList
    } = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    TodayKill = daily:get_count(?DAILY_BABY_KILL_TIMES, 0),
    KillList = pack_baby_daily_kill(),
    PackSkillList = pack_baby_skill(TypeId, Step, SkillList),
    PackEquipList = pack_equip_list(EquipList),
    {MyLv, CoupleLv, TarLv, Per1, Per2} = pack_couple_love_attr(Lv, Player),
    SignState = check_sign_up_state(Player),
    ActiveState = check_pic_active_state(),
    {TypeId, Step, StepExp, Lv, LvExp, BabyName, FigureId, State, Cbp, attribute_util:pack_attr(AttrList), PackSkillList, PackEquipList, MyLv, CoupleLv, TarLv, Per1, Per2, TodayKill, KillList, SignState, ActiveState}.


%%
pack_couple_love_attr(Lv, #player{marry = #marry{couple_key = Couple_key}}) ->
    CoupleLv =
        case Couple_key > 0 of
            true ->
                baby_util:get_couple_lv(Couple_key);
            false ->
                0
        end,
    Ids = data_baby_love_attri:ids(),
    TarLv = get_next_per(Ids, Lv),
    MinLv = min(Lv, CoupleLv),
    Per1 = data_baby_love_attri:get(MinLv),
    Per2 = data_baby_love_attri:get(TarLv),
    {Lv, CoupleLv, TarLv, Per1, Per2}.

get_next_per([], _Lv) -> hd(lists:reverse(data_baby_love_attri:ids()));
get_next_per([H | T], Lv) ->
    Per1 = data_baby_love_attri:get(H),
    Per2 = data_baby_love_attri:get(Lv),
    case Per1 /= Per2 andalso H >= Lv of
        true ->
            H;
        false ->
            get_next_per(T, Lv)
    end.


%% @doc 技能信息
pack_baby_skill(BabyTypeId, CurStep, BabySkillList) ->
    case data_baby:get(BabyTypeId) of
        #base_baby{skill_list = SkillList} ->
            lists:map(fun({Cell, Step, SkillId}) ->
                case lists:keyfind(Cell, 1, BabySkillList) of
                    {_, CurSkillId} ->
                        case data_skill:get(CurSkillId) of
                            #skill{goods = {GoodsId, Num}, next_skillid = NextSkillId} ->
                                case NextSkillId > 0 of
                                    true ->
                                        Count = goods_util:get_goods_count(GoodsId),
                                        if Count >= Num ->
                                            [Cell, CurSkillId, 2, Step];
                                            true -> %%已学习
                                                [Cell, CurSkillId, 3, Step]
                                        end;
                                    false ->%%满级
                                        [Cell, CurSkillId, 4, Step]
                                end;
                            _ ->
                                [Cell, CurSkillId, 0, Step]
                        end;
                    _ ->
                        #skill{goods = {GoodsId, Num}} = data_skill:get(SkillId),
                        case CurStep >= Step of
                            true ->
                                Count = goods_util:get_goods_count(GoodsId),
                                if Count >= Num -> %%可激活有红圈
                                    [Cell, SkillId, 5, Step];
                                    true ->
                                        [Cell, SkillId, 1, Step] %%1可激活没红圈
                                end;
                            false ->
                                [Cell, SkillId, 0, Step]
                        end
                end
                      end, SkillList);
        _ ->
            []
    end.

%% 打包装备信息
pack_equip_list(EquipList) ->
    [[SubTypeId, GoodsTypeId] || {SubTypeId, GoodsTypeId, _} <- EquipList].


%% 打包击杀信息
pack_baby_daily_kill() ->
    KillList = data_baby_daily_kill:ids(),
    TodayKillNum = daily:get_count(?DAILY_BABY_KILL_TIMES, 0),
    GetList = daily:get_count(?DAILY_BABY_GET_KILL_LIST, []),
    lists:map(fun(KillId) ->
        #base_baby_kill_daily{num = Num, goods = GoodsList} = data_baby_daily_kill:get(KillId),
        PackGoodsList = [[GoodsTypeId, GoodsNum] || {GoodsTypeId, GoodsNum} <- GoodsList],
        case lists:member(KillId, GetList) of
            true ->
                [KillId, 2, Num, PackGoodsList];
            false ->
                case TodayKillNum >= Num of
                    true ->
                        [KillId, 1, Num, PackGoodsList];
                    false ->
                        [KillId, 0, Num, PackGoodsList]
                end
        end
              end, KillList).


%% @doc 宝宝出战力 4宝宝不存在
go_fight(#player{} = Player) ->
    #baby_st{type_id = TypeId, state = State} = BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case TypeId > 0 of
        true ->
            NewState = ?IF_ELSE(State == 1, 0, 1),
            NewBaby = BabySt#baby_st{state = NewState, is_change = 1},
            lib_dict:put(?PROC_STATUS_PLAYER_BABY, NewBaby),
            {ok, Player};
        _ ->
            {fail, 4}
    end.

%% @doc 改名
%%change_name(#player{} = Player, NewBabyName) ->
%%    #baby_st{type_id = TypeId} = BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
%%    ?ASSERT_TRUE(TypeId =< 0, {fail, 4}),
%%    case baby_util:validate_name(len, NewBabyName) of
%%        true -> %% 名字合法
%%            GoodsNum = goods_util:get_goods_count(?CHANGE_NAME_GOODS_ID),
%%            ?ASSERT_TRUE(GoodsNum < 0, {fail, 5}),
%%            goods:subtract_good(Player, [{?CHANGE_NAME_GOODS_ID, 1}], 526),
%%            NewBabySt = BabySt#baby_st{name = NewBabyName, is_change = 1},
%%            baby_log:log_change_name(NewBabySt),
%%            NewPlayer = baby_attr:update_baby_attr(Player, NewBabySt, change_name),
%%            {ok, Bin1} = pt_130:write(13001, player_pack:trans13001(NewPlayer)),
%%            server_send:send_to_sid(NewPlayer#player.sid, Bin1),
%%            {ok, NewPlayer};
%%        _R ->
%%            ?PRINT("change name err ~w", [_R]),
%%            {fail, 6}
%%    end.

change_name(#player{} = Player, FigureId, FigureName) ->
    #baby_st{type_id = TypeId, name = UseName, figure_id = CurFigure, figure_list = FigureList} = BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    ?ASSERT_TRUE(TypeId =< 0, {fail, 4}),
    case baby_util:validate_name(len, FigureName) of
        {fail, Err} -> {fail, Err};
        true -> %% 名字合法
            case lists:keytake(FigureId, 1, FigureList) of
                false -> {fail, 19};
                {value, {_FigureId, Star, _OldName, Acc}, T} ->
                    case check_name_price(Player, Acc) of
                        false -> {fail, 5};
                        true ->
                            NewFigureList = [{FigureId, Star, FigureName, Acc + 1} | T],
                            IsSame = check_same_figure(TypeId, FigureId, CurFigure),
                            SceneName = ?IF_ELSE(IsSame, FigureName, UseName),
                            NewBabySt = BabySt#baby_st{name = SceneName, figure_list = NewFigureList, is_change = 1},
                            lib_dict:put(?PROC_STATUS_PLAYER_BABY, NewBabySt),
                            baby_log:log_change_name(NewBabySt),
                            case IsSame of
                                true ->
                                    NewPlayer = baby_attr:update_baby_attr(Player, NewBabySt, change_name),
                                    {ok, Bin1} = pt_130:write(13001, player_pack:trans13001(NewPlayer)),
                                    server_send:send_to_sid(NewPlayer#player.sid, Bin1),
                                    {ok, NewPlayer};
                                false ->
                                    {ok, Player}
                            end
                    end
            end
    end.

check_same_figure(TypeId, FigureId, CurFigure) ->
    if FigureId == CurFigure -> true;
        true ->
            case data_baby:get(TypeId) of
                [] -> false;
                #base_baby{figure = FigureList} ->
                    lists:keymember(FigureId, 1, FigureList) andalso lists:keymember(CurFigure, 1, FigureList)
            end
    end.

check_name_price(Player, Acc) ->
    if Acc == 0 ->
        true;
        true ->
            case goods_util:get_goods_count(?CHANGE_NAME_GOODS_ID) > 0 of
                true ->
                    goods:subtract_good(Player, [{?CHANGE_NAME_GOODS_ID, 1}], 526),
                    true;
                false ->
                    false
            end
    end.

%% @doc 宝宝升阶级
upgrade_step(#player{} = Player, IsAuto) ->
    #baby_st{type_id = TypeId, step = Step} = BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    ?ASSERT_TRUE(TypeId =< 0, {fail, 4}),
    BaseStep = data_baby_step:get(TypeId, Step),
    ?ASSERT_TRUE(BaseStep == [], {fail, 9}),
    ?ASSERT_TRUE(BaseStep#base_baby_step.exp == 0, {fail, 10}),
    upgrade_step(Player, BabySt, IsAuto, BaseStep).


%% 进阶
upgrade_step(Player, BabySt, Auto, BaseStep) ->
    {GoodsId, Num} = BaseStep#base_baby_step.goods,
    Count = goods_util:get_goods_count(GoodsId),
    if Count < Num andalso Auto == 0 ->
        %%物品不足 并且 不自动购买
        goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 122),
        throw({fail, 5}),
        CostNum = Num, CostMoney = {0, 0};
    %%物品不足 自动购买的
        Count < Num andalso Auto == 1 ->
            GoodsPrice = new_shop:get_goods_price(GoodsId),
            ?ASSERT_TRUE(GoodsPrice == false, {fail, 12}),
            {ok, Type, Price} = GoodsPrice,
            Money = Price * (Num - Count),
            ?ASSERT(money:is_enough(Player, Money, Type), {fail, 11}),
            CostNum = Count, CostMoney = {Money, Type};
        true ->
            CostNum = Num, CostMoney = {0, 0}
    end,
    goods:subtract_good(Player, [{GoodsId, CostNum}], 528),
    {NeedMoney, CostType} = CostMoney,
    Player1 = ?IF_ELSE(NeedMoney > 0, money:cost_money(Player, CostType, -NeedMoney, 528, GoodsId, Num - Count), Player),
    do_stage(Player1, BabySt, BaseStep).


%% 升阶处理
do_stage(Player, StBaby, BaseStep) ->
    StBaby1 = calc_step_exp(StBaby, BaseStep#base_baby_step.exp, BaseStep#base_baby_step.add_exp),
    baby_log:log_do_stage(StBaby1),
    if StBaby1#baby_st.step /= StBaby#baby_st.step ->
%%        %%升阶了,技能处理
        BaseBay = data_baby:get(StBaby#baby_st.type_id),
%%        NewSkillList = [{Cell, SkillId} || {Cell, Step, SkillId} <- BaseBay#base_baby.skill_list, StBaby1#baby_st.step >= Step],
        %%升阶了，形象处理
        AddList = [{FigureId, 1, data_baby_pic:get_name(FigureId), 0} || {FigureId, Step} <- BaseBay#base_baby.figure,
            StBaby1#baby_st.step >= Step, not lists:keymember(FigureId, 1, StBaby1#baby_st.figure_list)],
        NewFigureList = AddList ++ StBaby1#baby_st.figure_list,
        StBaby2 = StBaby1#baby_st{figure_list = NewFigureList, is_change = 1},
        NewPlayer = baby_attr:update_baby_attr(Player, StBaby2, upgrade_step),
        {ok, NewPlayer};
        true ->
            lib_dict:put(?PROC_STATUS_PLAYER_BABY, StBaby1),
            {ok, Player}
    end.


%%计算进阶经验 TODO 这里有问题
calc_step_exp(StBaby, ExpLim, Add) ->
    Exp = StBaby#baby_st.step_exp + Add,
    if Exp >= ExpLim ->
        Lv = StBaby#baby_st.step + 1,
        MaxLv = data_baby_step:get_max_step(StBaby#baby_st.type_id),
        if MaxLv >= Lv ->
            StBaby#baby_st{step = Lv, step_exp = 0, is_change = 1};
            true ->
                %%满级情况
                StBaby#baby_st{step_exp = Exp, is_change = 1}
        end;
        true ->
            StBaby#baby_st{step_exp = Exp, is_change = 1}
    end.


%% @doc 喂养
feed_baby(#player{} = Player, _IsAuto) ->
    #baby_st{type_id = TypeId, lv = Lv} = BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    ?ASSERT_TRUE(TypeId =< 0, {fail, 4}),
    BaseExp = data_baby_exp:get(Lv),
    ?ASSERT_TRUE(BaseExp == [], {fail, 9}),
    ?ASSERT_TRUE(BaseExp#base_baby_exp.exp == 0, {fail, 13}),
    {GoodsId, Num} = BaseExp#base_baby_exp.goods,
    Count = goods_util:get_goods_count(GoodsId),
    if Count < Num ->
        %%物品不足 并且 不自动购买
        goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 122),
        throw({fail, 5});
        true ->
            ok
    end,
    {StBaby1, DelNum} = do_feed_baby(Player, BabySt, Count, GoodsId, Num, 0),
    goods:subtract_good(Player, [{GoodsId, DelNum}], 529),
    baby_log:log_upgrade_lv(StBaby1),
    if StBaby1#baby_st.lv /= BabySt#baby_st.lv ->
        NewPlayer = baby_attr:update_baby_attr(Player, StBaby1, feed_baby),
        notify_couple_re_count_attr(NewPlayer, StBaby1),
        {ok, NewPlayer};
        true ->
            lib_dict:put(?PROC_STATUS_PLAYER_BABY, StBaby1),
            {ok, Player}
    end.


do_feed_baby(Player, BabySt, LeftNum, CostGoodsId, CostNum, SumCost) when LeftNum >= CostNum ->
    case data_baby_exp:get(BabySt#baby_st.lv) of
        #base_baby_exp{exp = ExpLimit, add_exp = AddExp} when ExpLimit > 0 -> %% 没到上限
            Baby2 = BabySt#baby_st{lv_exp = AddExp + BabySt#baby_st.lv_exp, is_change = 1},
            NewBaby = calc_new_lv_exp(Baby2),
            do_feed_baby(Player, NewBaby, LeftNum - CostNum, CostGoodsId, CostNum, SumCost + CostNum);
        _ ->
            {BabySt, SumCost}
    end;
do_feed_baby(_Player, BabySt, _LeftNum, _CostGoodsId, _CostNum, SumCost) ->
    {BabySt, SumCost}.



calc_new_lv_exp(#baby_st{lv = Lv, lv_exp = LvExp} = BabySt) ->
    case data_baby_exp:get(Lv) of
        #base_baby_exp{exp = ExpLimit} when ExpLimit > 0 ->
            case LvExp >= ExpLimit of
                true ->
                    calc_new_lv_exp(BabySt#baby_st{lv = Lv + 1, lv_exp = LvExp - ExpLimit});
                false ->
                    BabySt
            end;
        _ ->
            BabySt
    end.


%% 通知对方
notify_couple_re_count_attr(Player, StBaby1) ->
    ?GLOBAL_DATA_RAM:set(?BABY_COUPLE_LOVE_LV(Player#player.key), StBaby1#baby_st.lv),
    CoupleKey = Player#player.marry#marry.couple_key,
    case CoupleKey > 0 of
        true ->
            case misc:get_player_process(CoupleKey) of
                Pid when is_pid(Pid) ->
                    gen_server:cast(Pid, couple_upgrade);
                _ ->
                    skip
            end;
        _ ->
            ok
    end.

%% 重新计算属性
couple_upgrade(Player) ->
    case lib_dict:get(?PROC_STATUS_PLAYER_BABY) of
        #baby_st{type_id = TypeId} = StBaby when TypeId > 0 ->
            NewPlayer = baby_attr:update_baby_attr(Player, StBaby, couple_upgrade),
            NewPlayer;
        _ ->
            Player
    end.


%% @doc 改变性别
change_sex(#player{} = Player) ->
    Baby = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    ?ASSERT_TRUE(Baby#baby_st.type_id =< 0, {fail, 4}),
    OtherTypeId = get_other_sex_id(Baby),
    case OtherTypeId > 0 of
        true ->
            Count = goods_util:get_goods_count(?CHANGE_BABY_SEX_GOODS_ID),
            ?ASSERT_TRUE(Count =< 0, {fail, 5}),
            goods:subtract_good(Player, [{?CHANGE_BABY_SEX_GOODS_ID, 1}], 530),
            {NewFigureId, NewFigureList} = change_baby_figure_list(OtherTypeId, Baby),
            NewSillList = change_baby_skill_list(OtherTypeId, Baby),
            #base_baby{sex = NewSex} = data_baby:get(OtherTypeId),
            change_equip_sex(Baby#baby_st.equip_list, NewSex),
            NewBaby = Baby#baby_st{
                type_id = OtherTypeId,
                figure_id = NewFigureId,
                figure_list = NewFigureList,
                skill_list = NewSillList,
                is_change = 1
            },
            NewPlayer = baby_attr:update_baby_attr(Player, NewBaby, change_sex),
            {ok, Bin1} = pt_130:write(13001, player_pack:trans13001(NewPlayer)),
            server_send:send_to_sid(NewPlayer#player.sid, Bin1),
            baby_log:log_change_sex(NewBaby),
            {ok, NewPlayer};
        _ ->
            {fail, 14}
    end.


%% 改变装备性别
change_equip_sex(EquipList, NewSex) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsDict2 =
        lists:foldl(fun({_, _, GoodsKey}, GoodsDict) ->
            case catch goods_util:get_goods(GoodsKey, GoodsDict) of
                #goods{sex = OldSex} = GoodsOld when OldSex > 0 -> %% 有性别才转
                    NewGoodsOld = GoodsOld#goods{sex = NewSex},
                    goods_load:dbup_equip_sex(NewGoodsOld),
                    goods_pack:pack_send_goods_info([NewGoodsOld], GoodsSt#st_goods.sid),
                    GoodsDict1 = goods_dict:update_goods(NewGoodsOld, GoodsDict);
                _R2 ->
                    GoodsDict1 = GoodsDict
            end,
            GoodsDict1
                    end, GoodsSt#st_goods.dict, EquipList),
    NewGoodsSt = GoodsSt#st_goods{dict = GoodsDict2},
    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt).



acc_skill_list(SkillId, AccSkillList) ->
    NewAccList = [SkillId | AccSkillList],
    case data_skill:get(SkillId) of
        #skill{next_skillid = NextId} when NextId > 0 ->
            acc_skill_list(NextId, NewAccList);
        _ ->
            NewAccList
    end.


%% 转换技能
change_baby_skill_list(NewTypeId, Baby) ->
    #base_baby{skill_list = NewSkillList} = data_baby:get(NewTypeId),
    #base_baby{skill_list = OldSkillList} = data_baby:get(Baby#baby_st.type_id),
    List1 = lists:foldl(fun(SkillId, AccList) ->
        acc_skill_list(SkillId, AccList)
                        end, [], OldSkillList),
    List2 = lists:foldl(fun(SkillId, AccList) ->
        acc_skill_list(SkillId, AccList)
                        end, [], NewSkillList),
    ZipList = lists:zip(List1, List2),
    lists:map(fun({CellId, SkillId}) ->
        case lists:keyfind(SkillId, 1, ZipList) of
            {_, NewId} -> {CellId, NewId};
            _ ->
                {CellId, SkillId}
        end
              end, Baby#baby_st.skill_list).


%% 转换形象列表
change_baby_figure_list(NewTypeId, Baby) ->
    #base_baby{figure = NewFigureList} = data_baby:get(NewTypeId),
    #base_baby{figure = OldFigureList} = data_baby:get(Baby#baby_st.type_id),
    OldList = [FigureId || {FigureId, _} <- OldFigureList],
    NewList = [FigureId || {FigureId, _} <- NewFigureList],
    NewPicList = data_baby_pic:get_all(NewTypeId),
    OldPicList = data_baby_pic:get_all(Baby#baby_st.type_id),
    List1 = NewPicList ++ NewList,
    List2 = OldPicList ++ OldList,
    case length(List1) /= length(List2) of
        true ->
            ?ERR("change baby sex figure no match ~w ~w", [List1, List2]),
            throw({fail, 17});
        false ->
            ZipList = lists:zip(List2, List1),
            case lists:keyfind(Baby#baby_st.figure_id, 1, ZipList) of
                {_, NewFigureId} -> ok;
                _ ->
                    NewFigureId = Baby#baby_st.figure_id,
                    ?ERR("find not match figure id ~w", [Baby#baby_st.figure_id])
            end,
            ChangeFigureList =
                lists:map(fun({FigureId, Star, Name, Acc}) ->
                    case lists:keyfind(FigureId, 1, ZipList) of
                        {_, NewId} -> {NewId, Star, Name, Acc};
                        _ ->
                            {FigureId, Star, Name, Acc}
                    end
                          end, Baby#baby_st.figure_list),
            {NewFigureId, ChangeFigureList}
    end.


%% 获取另外性别ID
get_other_sex_id(Baby) ->
    AllIds = data_baby:get_all(),
    case lists:delete(Baby#baby_st.type_id, AllIds) of
        [OtherIds | _] -> OtherIds;
        _ ->
            0
    end.


%% @doc 创建宝宝
create_baby(_Player, Sex, _BabyName) ->
    Baby = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    ?ASSERT_TRUE(Baby#baby_st.type_id > 0, {fail, 15}),
    NowTime = util:unixtime(),
    ?ASSERT_TRUE(NowTime =< Baby#baby_st.born_time, {fail, 15}),
    AccIdList =
        lists:foldl(fun(Id, AccId) ->
            case data_baby:get(Id) of
                #base_baby{sex = Sex} -> [Id | AccId];
                _ ->
                    AccId
            end
                    end, [], data_baby:get_all()),
    case AccIdList of
        [_BabyTypeId | _] ->
            case baby_util:validate_name(len, _BabyName) of
                true -> ok;
                _R ->
                    throw({fail, 6})
            end,
            BaseBaby = data_baby:get(_BabyTypeId),
            FigureId = get_baby_figure_id(_BabyTypeId, 1),
            %% 默认开启
            SkillList = case lists:keyfind(1, 1, BaseBaby#base_baby.skill_list) of
                            {_, _NeedStep, SkillId} ->
                                [{1, SkillId}];
                            _ ->
                                []
                        end,
            NewBaby = Baby#baby_st{
                type_id = _BabyTypeId,
                name = _BabyName,
                step = 1,
                lv = 1,
                figure_id = FigureId,
                figure_list = [{FigureId, 1, _BabyName, 0}],
                skill_list = SkillList,
                is_change = 1
            },
            baby_log:log_create_baby(NewBaby),
            Player1 = baby_attr:update_baby_attr(_Player, NewBaby, crate_baby),
            Player2 = baby_wing_init:check_upgrade_lv(Player1),
            Player3 = baby_mount_init:upgrade_lv(Player2),
            NewPlayer = baby_weapon_init:upgrade_lv(Player3),
            {ok, Bin1} = pt_130:write(13001, player_pack:trans13001(NewPlayer)),
            server_send:send_to_sid(NewPlayer#player.sid, Bin1),
            {ok, NewPlayer};
        _ ->
            {fail, 16}
    end.


%%
get_baby_figure_id(TypeId, Step) ->
    BaseBaby = data_baby:get(TypeId),
    F = fun({FigureId1, Stage1}) ->
        if Stage1 =< Step -> [FigureId1];true -> [] end
        end,
    hd(lists:flatmap(F, BaseBaby#base_baby.figure)).


%% @doc 出生图标推送
check_baby_born_time_icon(Player, NowTime) ->
    #baby_st{type_id = TypeId, born_time = BornTime} = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    if
        TypeId =< 0 andalso BornTime > NowTime ->
            LeftTime = (BornTime - NowTime) div 60,
            case lists:member(LeftTime, ?BABY_BORN_LEFT_TIME_TIPS) of
                true ->
                    {ok, BinData} = pt_163:write(16308, {LeftTime * 60}),
                    server_send:send_to_sid(Player#player.sid, BinData);
                _ ->
                    ?PRINT("baby LeftTime ~w", [LeftTime])
            end;
        true ->
            ok
    end.


%% @doc 每5秒检查出生
check_baby_born(Player, NowTime) ->
    #baby_st{type_id = TypeId, born_time = BornTime} = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case get(push_time) of
        undefined -> LastTime = NowTime - 20;
        LastTime -> ok
    end,
    %% 不频繁推送
    if TypeId =< 0 andalso NowTime >= BornTime andalso BornTime /= 0 andalso NowTime - LastTime >= 20 ->
        put(push_time, NowTime),
        {ok, BinData} = pt_163:write(16309, {}),
        server_send:send_to_sid(Player#player.sid, BinData);
        true ->
            ok
    end.


%% @doc 检查出战宠物是否有技能可升级
check_skill_state() ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case BabySt#baby_st.type_id > 0 of
        true ->
            #base_baby{skill_list = SkillList} = data_baby:get(BabySt#baby_st.type_id),
            NewSkillList = [{Cell, SkillId} || {Cell, Step, SkillId} <- SkillList, BabySt#baby_st.step >= Step],
            case length(NewSkillList) /= length(BabySt#baby_st.skill_list) of
                true ->
                    Ret =
                        lists:any(fun({CellId, SkillId}) ->
                            case lists:keyfind(CellId, 1, BabySt#baby_st.skill_list) of
                                false ->
                                    #skill{goods = {GoodsId, Num}} = data_skill:get(SkillId),
                                    Count = goods_util:get_goods_count(GoodsId),
                                    Count >= Num;
                                _ ->
                                    false
                            end
                                  end, NewSkillList),
                    case Ret of
                        true -> 1;
                        _ -> 0
                    end;
                false ->
                    F1 = fun({_Cell, SkillId}) ->
                        case data_skill:get(SkillId) of
                            [] -> false;
                            Skill ->
                                if Skill#skill.next_skillid == 0 -> false;
                                    true ->
                                        case Skill#skill.goods of
                                            {} -> false;
                                            {GoodsId, Num} ->
                                                Count = goods_util:get_goods_count(GoodsId),
                                                if Count > Num -> true;
                                                    true -> false

                                                end
                                        end
                                end
                        end
                         end,
                    case lists:any(F1, BabySt#baby_st.skill_list) of
                        true -> 1;
                        false -> 0
                    end
            end;
        _ ->
            0
    end.


%% @doc 是否进阶
check_update_step_state(_Player) ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case BabySt#baby_st.type_id > 0 of
        true ->
            case data_baby_step:get(BabySt#baby_st.type_id, BabySt#baby_st.step) of
                #base_baby_step{exp = Exp, goods = NeedGoods} ->
                    case Exp == 0 of
                        true -> 0;
                        _ ->
                            {GoodsId, Num} = NeedGoods,
                            Count = goods_util:get_goods_count(GoodsId),
                            ?IF_ELSE(Count >= Num, 1, 0)
                    end;
                _ ->
                    ?DEBUG("get baby step err player_id:~w type_id:~w,step:~w", [_Player#player.key, BabySt#baby_st.type_id, BabySt#baby_st.step]),
                    0
            end;
        false ->
            0
    end.


%% @doc 等级升级
check_update_lv_state() ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case BabySt#baby_st.type_id > 0 of
        true ->
            case data_baby_exp:get(BabySt#baby_st.lv) of
                #base_baby_exp{goods = {GoodsId, Num}} ->
                    Count = goods_util:get_goods_count(GoodsId),
                    ?IF_ELSE(Count >= Num, 1, 0);
                _ ->
                    0
            end;
        false ->
            0
    end.


%%
check_sign_up_state(Player) ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case BabySt#baby_st.type_id > 0 of
        true ->
            NowTime = util:unixtime(),
            Ret =
                lists:any(fun(SignType) ->
                    case SignType of
                        ?BABY_SINGLE_SIGN_TYPE ->
                            {SignTime, _ContineTime} = player_mask:get(?BABY_SINGLE_SIGN_UP_MASK, {0, 0});
                        _ ->
                            {SignTime, _ContineTime} = player_mask:get(?BABY_DOUBLE_SIGN_UP_MASK, {0, 0})
                    end,
                    #marry{couple_key = CoupleKey} = Player#player.marry,
                    case CoupleKey =< 0 andalso SignType == ?BABY_SINGLE_DOUBLE_TYPE of
                        true -> false;
                        false ->
                            case util:is_same_date(SignTime, NowTime) of
                                true -> false;
                                _ -> true
                            end
                    end
                          end, [?BABY_SINGLE_SIGN_TYPE, ?BABY_SINGLE_DOUBLE_TYPE]),
            case Ret of
                true -> 1;
                _ -> 0
            end;
        false ->
            0
    end.

check_equip_state(Player) ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case BabySt#baby_st.type_id > 0 of
        true ->
            GoodsList = goods_util:get_goods_list_by_type_list(?GOODS_LOCATION_BAG, [?GOODS_TYPE_EQUIP10]),
            F = fun(Goods) ->
                GoodsType = data_goods:get(Goods#goods.goods_id),
                case lists:keyfind(GoodsType#goods_type.subtype, 1, BabySt#baby_st.equip_list) of
                    false -> false;
                    {_Subtype, _GoodsId, GoodsKey} ->
                        if
                            GoodsKey == Goods#goods.key -> false;
                            Player#player.sex =/= Goods#goods.sex -> false;
                            true ->
                                WearGoods = goods_util:get_goods(GoodsKey),
                                if
                                    Goods#goods.combat_power > WearGoods#goods.combat_power -> true;
                                    true -> false
                                end
                        end
                end
                end,
            case lists:any(F, GoodsList) of
                false -> 0;
                true -> 1
            end;
        _ ->
            0
    end.

%%
check_pic_active_state() ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case BabySt#baby_st.type_id > 0 of
        true ->
            FigureIds = data_baby_pic:get_all(BabySt#baby_st.type_id),
            Ret =
                lists:any(fun(FigureId) ->
                    case lists:keymember(FigureId, 1, BabySt#baby_st.figure_list) of
                        true -> false;
                        false ->
                            case data_baby_pic:get(FigureId, 1) of
                                #base_baby_pic{goods = {GoodsId, GoodsNum}} ->
                                    Count = goods_util:get_goods_count(GoodsId),
                                    Count >= GoodsNum;
                                _ ->
                                    false
                            end
                    end
                          end, FigureIds),
            case Ret of
                true -> 1;
                _ -> 0
            end;
        _ ->
            0
    end.


%% @doc 检查是否有击杀奖励领取
check_kill_award_state() ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case BabySt#baby_st.type_id > 0 of
        true ->
            GetList = daily:get_count(?DAILY_BABY_GET_KILL_LIST, []),
            TodayKillNum = daily:get_count(?DAILY_BABY_KILL_TIMES, 0),
            Ids = data_baby_daily_kill:ids(),
            Ret =
                lists:any(fun(KillId) ->
                    #base_baby_kill_daily{num = Num} = data_baby_daily_kill:get(KillId),
                    case lists:member(KillId, GetList) of
                        true -> false;
                        false ->
                            ?IF_ELSE(TodayKillNum >= Num, true, false)
                    end
                          end, Ids),
            case Ret of
                true -> 1;
                _ -> 0
            end;
        false ->
            0
    end.


%% @doc 升级技能
upgrade_skill(Player, Cell) ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    ?ASSERT_TRUE(BabySt#baby_st.type_id =< 0, {fail, 4}),
    case lists:keytake(Cell, 1, BabySt#baby_st.skill_list) of
        false ->
            %% 技能激活
            #base_baby{skill_list = SkillList} = data_baby:get(BabySt#baby_st.type_id),
            case lists:keyfind(Cell, 1, SkillList) of
                {_, NeedStep, SKillId} when BabySt#baby_st.step >= NeedStep ->
                    Skill = data_skill:get(SKillId),
                    ?ASSERT_TRUE(Skill == [], {fail, 9}),
                    ?ASSERT_TRUE(Skill#skill.goods == {}, {fail, 9}),
                    {GoodsId, Num} = Skill#skill.goods,
                    Count = goods_util:get_goods_count(GoodsId),
                    if Count < Num ->
                        goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 191),
                        {fail, 5};
                        true ->
                            goods:subtract_good(Player, [{GoodsId, Num}], 527),
                            NewBaby = BabySt#baby_st{skill_list = [{Cell, SKillId} | BabySt#baby_st.skill_list], is_change = 1},
                            baby_log:log_upgrade_skill(NewBaby),
                            NewPlayer = baby_attr:update_baby_attr(Player, NewBaby, upgrade_skill),
                            {ok, NewPlayer}
                    end;
                _ ->
                    {fail, 7}
            end;
        {value, {_, SkillId}, L} ->
            Skill = data_skill:get(SkillId),
            ?ASSERT_TRUE(Skill == [], {fail, 9}),
            ?ASSERT_TRUE(Skill#skill.next_skillid == 0, {fail, 8}),
            ?ASSERT_TRUE(Skill#skill.goods == {}, {fail, 9}),
            {GoodsId, Num} = Skill#skill.goods,
            Count = goods_util:get_goods_count(GoodsId),
            if Count < Num ->
                goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 191),
                {fail, 5};
                true ->
                    goods:subtract_good(Player, [{GoodsId, Num}], 527),
                    NewBaby = BabySt#baby_st{skill_list = [{Cell, Skill#skill.next_skillid} | L], is_change = 1},
                    baby_log:log_upgrade_skill(NewBaby),
                    NewPlayer = baby_attr:update_baby_attr(Player, NewBaby, upgrade_skill),
                    {ok, NewPlayer}
            end
    end.


%% @doc 幻化
change_figure(Player, FigureId) ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    ?ASSERT_TRUE(BabySt#baby_st.type_id =< 0, {fail, 4}),
    ?ASSERT_TRUE(BabySt#baby_st.figure_id == FigureId, {fail, 18}),
%%    ?ASSERT(lists:keymember(FigureId, 1, BabySt#baby_st.figure_list), {fail, 19}),
    case lists:keyfind(FigureId, 1, BabySt#baby_st.figure_list) of
        false ->
            {fail, 19};
        {_FigureId, _Star, Name, _} ->
            NewName = match_name(BabySt#baby_st.type_id, FigureId, Name, BabySt#baby_st.figure_list),
            NewBabySt = BabySt#baby_st{figure_id = FigureId, name = NewName, is_change = 1},
            NewPlayer = baby_attr:update_baby_attr(Player, NewBabySt, change_figure),
            baby_log:log_change_figure(NewBabySt),
            {ok, NewPlayer}
    end.

match_name(10001, Figure, Name, PicList) ->
    #base_baby{figure = FigureList} = data_baby:get(10001),
    case lists:keymember(Figure, 1, FigureList) of
        false ->
            Name;
        true ->
            case lists:keyfind(10001, 1, PicList) of
                false -> Name;
                {_, _, Name1, _} ->
                    Name1
            end
    end;
match_name(20001, Figure, Name, PicList) ->
    #base_baby{figure = FigureList} = data_baby:get(20001),
    case lists:keymember(Figure, 1, FigureList) of
        false ->
            Name;
        true ->
            case lists:keyfind(20001, 1, PicList) of
                false -> Name;
                {_, _, Name1, _} ->
                    Name1
            end
    end;
match_name(_, _Figure, Name, _PicList) ->
    Name.

%% @doc 图鉴列表
pic_list(_Player) ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case data_baby_pic:get_all(BabySt#baby_st.type_id) of
        [] -> [];
        List ->
            lists:map(fun(FigureId) ->
                case lists:keyfind(FigureId, 1, BabySt#baby_st.figure_list) of
                    false ->
                        IsUp = check_up_state(FigureId, 1),
                        Name = data_baby_pic:get_name(FigureId),
                        [FigureId, IsUp, 0, Name, 0];
                    {_, Star, Name, Acc} ->
                        IsUp = check_up_state(FigureId, Star + 1),
                        [FigureId, IsUp, Star, Name, Acc]
                end
                      end, List)
    end.

check_up_state(FigureId, Star) ->
    case data_baby_pic:get(FigureId, Star) of
        #base_baby_pic{goods = {GoodsId, GoodsNum}, chip_goods = ChipGoods} ->
            Count = goods_util:get_goods_count(GoodsId),
            Con1 = Count >= GoodsNum,
            Enough =
                case ChipGoods of
                    {} -> Con1;
                    {ChipGoodsId, ChipGoodsNum} ->
                        Count2 = goods_util:get_goods_count(ChipGoodsId),
                        Con2 = Count2 >= ChipGoodsNum,
                        Con1 orelse Con2
                end,
            ?IF_ELSE(Enough, 1, 0);
        _ ->
            0
    end.


%% @doc 激活图鉴
active_pic(Player, FigureId) ->
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    ?ASSERT_TRUE(BabySt#baby_st.type_id =< 0, {fail, 4}),
%%    ?ASSERT_TRUE(lists:keymember(FigureId, 1, BabySt#baby_st.figure_list), {fail, 17}), %%已经激活
    {Star, NewName, NewAcc} =
        case lists:keyfind(FigureId, 1, BabySt#baby_st.figure_list) of
            false ->
                {1, data_baby_pic:get_name(FigureId), 0};
            {_, OldStar, OldName, OldAcc} ->
                {OldStar + 1, OldName, OldAcc}
        end,
    case data_baby_pic:get(FigureId, Star) of
        #base_baby_pic{goods = {GoodsId, GoodsNum}, chip_goods = ChipGoods} ->
            Count = goods_util:get_goods_count(GoodsId),
            {CostGoodsId, CostGoodsNum} =
                if Count < GoodsNum ->
                    case ChipGoods of
                        {ChipGoodsId, ChipGoodsNum} ->
                            Count2 = goods_util:get_goods_count(ChipGoodsId),
                            ?IF_ELSE(Count2 >= ChipGoodsNum, {ChipGoodsId, ChipGoodsNum}, {0, 0});
                        _ ->
                            {0, 0}
                    end;
                    true ->
                        {GoodsId, GoodsNum}
                end,
            case CostGoodsId == 0 of
                true ->
                    goods_util:client_popup_goods_not_enough(Player, GoodsId, GoodsNum, 520),
                    {fail, 5};
                _ ->
                    goods:subtract_good(Player, [{CostGoodsId, CostGoodsNum}], 520),

                    FigureList = [{FigureId, Star, NewName, NewAcc} | lists:keydelete(FigureId, 1, BabySt#baby_st.figure_list)],
                    NewBaby = BabySt#baby_st{figure_list = FigureList, is_change = 1},
                    baby_log:log_active_pic(NewBaby),
                    NewPlayer = baby_attr:update_baby_attr(Player, NewBaby, active_pic),
                    {ok, NewPlayer}
            end;
        _ ->
            {fail, 32}
    end.


%% @doc 穿上装备
equip_goods(Player, GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {fail, 20};
        Goods ->
            BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
            ?ASSERT_TRUE(BabySt#baby_st.type_id =< 0, {fail, 4}),
            GoodsType = data_goods:get(Goods#goods.goods_id),
            ?ASSERT_TRUE(GoodsType == [], {fail, 9}),
            Baby = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
            %% TODO 转职业，装备性别怎么处理
            #base_baby{sex = Sex} = data_baby:get(BabySt#baby_st.type_id),
            ?ASSERT_TRUE(GoodsType#goods_type.need_lv > Baby#baby_st.lv, {fail, 21}),
            case Goods#goods.sex == 0 orelse Goods#goods.sex == Sex of
                true -> ok;
                _ ->
                    throw({fail, 28})
            end,
            ?ASSERT(lists:member(GoodsType#goods_type.subtype, ?GOODS_SUBTYPE_EQUIP_BABY_LIST), {fail, 22}),
            NeedGoods = Goods#goods{location = ?GOODS_LOCATION_BABY, cell = GoodsType#goods_type.subtype, bind = ?BIND},
            GoodsDict = goods_dict:update_goods(NeedGoods, GoodsSt#st_goods.dict),
            goods_pack:pack_send_goods_info([NeedGoods], GoodsSt#st_goods.sid),
            EquipList =
                case lists:keytake(GoodsType#goods_type.subtype, 1, Baby#baby_st.equip_list) of
                    false ->
                        _OldGoodsId = 0,
                        NewGoodsSt = GoodsSt#st_goods{leftover_cell_num = GoodsSt#st_goods.leftover_cell_num + 1, dict = GoodsDict},
                        [{GoodsType#goods_type.subtype, Goods#goods.goods_id, Goods#goods.key} | Baby#baby_st.equip_list];
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
            NewBaby1 = Baby#baby_st{equip_list = EquipList, is_change = 1},
            NewPlayer = baby_attr:update_baby_attr(Player, NewBaby1, equip_goods),
            baby_log:log_equip_goods(NewBaby1),
            {ok, NewPlayer}
    end.

baby_equip_attr_view() ->
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BABY),
    [#baby_equip_attr_view{
        goods_id = Goods#goods.goods_id,
        goods_lv = Goods#goods.goods_lv,
        color = Goods#goods.color,
        star = Goods#goods.star,
        fix_attrs = Goods#goods.fix_attrs,
        random_attrs = Goods#goods.random_attrs,
        sex = Goods#goods.sex,
        cbp = Goods#goods.combat_power
    } || Goods <- GoodsList].


%% 签到信息
signin_info_list(_Player) ->
    SingleList = data_baby_sign:get_all(?BABY_SINGLE_SIGN_TYPE),
    {SignTime, ContineTime} = player_mask:get(?BABY_SINGLE_SIGN_UP_MASK, {0, 0}),
    PackAList = pack_sign_info(?BABY_SINGLE_SIGN_TYPE, SingleList, SignTime, ContineTime),
    DoubleList = data_baby_sign:get_all(?BABY_SINGLE_DOUBLE_TYPE),
    {SignTime2, ContineTime2} = player_mask:get(?BABY_DOUBLE_SIGN_UP_MASK, {0, 0}),
    PackBList = pack_sign_info(?BABY_SINGLE_DOUBLE_TYPE, DoubleList, SignTime2, ContineTime2),
    {ContineTime, PackAList, ContineTime2, PackBList}.


pack_sign_info(SignType, SingleList, SignTime, ContineTime) ->
    NowTime = util:unixtime(),
    {HasSign, NowTimes} =
        case util:is_same_date(SignTime, NowTime) of
            true -> {1, ContineTime};
            false ->
                %%昨日有签到
                case util:is_same_date(SignTime + ?ONE_DAY_SECONDS, NowTime) of
                    true ->
                        Len = (ContineTime + 1) rem length(SingleList),
                        {0, ?IF_ELSE(Len == 0, length(SingleList), Len)};
                    false ->
                        {0, 1}
                end
        end,
    lists:map(fun(DayId) ->
        #base_baby_sign{award = GoodsList} = data_baby_sign:get(SignType, DayId),
        PackGoodsList = [[GoodsId, GoodsNum] || {GoodsId, GoodsNum} <- GoodsList],
        case HasSign of
            1 ->
                ?IF_ELSE(DayId =< NowTimes, [DayId, 2, PackGoodsList], [DayId, 0, PackGoodsList]);
            0 ->
                if DayId < NowTimes ->
                    [DayId, 2, PackGoodsList];
                    DayId == NowTimes ->
                        [DayId, 1, PackGoodsList];
                    true ->
                        [DayId, 0, PackGoodsList]
                end
        end
              end, SingleList).

%% 签到
sign_up(Player, SignType, SignDay) ->
    case SignType of
        ?BABY_SINGLE_SIGN_TYPE ->
            {SignTime, ContineTime} = player_mask:get(?BABY_SINGLE_SIGN_UP_MASK, {0, 0}),
            SingleList = data_baby_sign:get_all(?BABY_SINGLE_SIGN_TYPE);
        _ ->
            #marry{couple_key = CoupleKey} = Player#player.marry,
            ?ASSERT_TRUE(CoupleKey =< 0, {fail, 27}), %%没有夫妻不能签到
            {SignTime, ContineTime} = player_mask:get(?BABY_DOUBLE_SIGN_UP_MASK, {0, 0}),
            SingleList = data_baby_sign:get_all(?BABY_SINGLE_DOUBLE_TYPE)
    end,
    NowTime = util:unixtime(),
    {HasSign, NewContinue} =
        case util:is_same_date(SignTime, NowTime) of
            true -> {1, ContineTime};
            false ->
                %%昨日有签到
                case util:is_same_date(SignTime + ?ONE_DAY_SECONDS, NowTime) of
                    true ->
                        Len = (ContineTime + 1) rem length(SingleList),
                        {0, ?IF_ELSE(Len == 0, length(SingleList), Len)};
                    false ->
                        {0, 1}
                end
        end,
    ?ASSERT_TRUE(HasSign == 1, {fail, 23}),
    ?ASSERT_TRUE(SignDay /= NewContinue, {fail, 24}),
    case data_baby_sign:get(SignType, SignDay) of
        #base_baby_sign{award = AwardGoods} ->
            case SignType of
                ?BABY_SINGLE_SIGN_TYPE ->
                    player_mask:set(?BABY_SINGLE_SIGN_UP_MASK, {NowTime, NewContinue});
                _ ->
                    player_mask:set(?BABY_DOUBLE_SIGN_UP_MASK, {NowTime, NewContinue})
            end,
            GiveGoodsList = goods:make_give_goods_list(532, AwardGoods),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            {ok, NewPlayer};
        _ ->
            {fail, 9}
    end.


%% @doc 获取击杀奖励
get_kill_award(Player, KillId) ->
    KillData = data_baby_daily_kill:get(KillId),
    ?ASSERT_TRUE(KillData == [], {fail, 9}),
    #base_baby_kill_daily{goods = AwardGoods, num = Num} = KillData,
    GetList = daily:get_count(?DAILY_BABY_GET_KILL_LIST, []),
    ?ASSERT_TRUE(lists:member(KillId, GetList), {fail, 25}),
    TodayKillNum = daily:get_count(?DAILY_BABY_KILL_TIMES, 0),
    ?ASSERT_TRUE(Num > TodayKillNum, {fail, 26}),
    daily:set_count(?DAILY_BABY_GET_KILL_LIST, [KillId | GetList]),
    GiveGoodsList = goods:make_give_goods_list(531, AwardGoods),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    {ok, NewPlayer}.


%% @doc 宝宝击杀怪物
kill_mon(KillNum, _Player) ->
    case lib_dict:get(?PROC_STATUS_PLAYER_BABY) of
        #baby_st{type_id = TypeId} when TypeId > 0 -> %%有宝宝才算击杀
            daily:increment(?DAILY_BABY_KILL_TIMES, KillNum);
        _ ->
            ok
    end,
    ok.


%% @doc 加速
time_speed(Player, GoodsId) ->
    NowTime = util:unixtime(),
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    ?ASSERT_TRUE(BabySt#baby_st.type_id > 0 orelse NowTime >= BabySt#baby_st.born_time, {fail, 30}),
    case data_baby_time_speed:get(GoodsId) of
        #base_baby_time_speed{cost = CostNum, cost_type = CostType, time = SpeedTime} ->
            case money:is_enough(Player, CostNum, CostType) of
                false ->
                    if CostType == coin -> throw({fail, 30});
                        CostType == bgold -> throw({fail, 31});
                        true -> throw({fail, 11})
                    end;
                _ -> ok
            end,
            NewPlayer = money:cost_money(Player, CostType, -CostNum, 534, GoodsId, 1),
            NewBornTime = max(BabySt#baby_st.born_time - SpeedTime, NowTime),
            NewBabySt = BabySt#baby_st{born_time = NewBornTime, is_change = 1},
            lib_dict:put(?PROC_STATUS_PLAYER_BABY, NewBabySt),
            CoupleKey = Player#player.marry#marry.couple_key,
            case CoupleKey > 0 of
                true ->
                    case misc:get_player_process(CoupleKey) of
                        CouplePid when is_pid(CouplePid) ->
                            player:apply_info(CouplePid, {?MODULE, couple_speed_up, [SpeedTime]});
                        _ ->
                            couple_speed_up_off_line(CoupleKey, SpeedTime)
                    end;
                _ ->
                    skip
            end,
            LeftTime = max(0, NewBornTime - NowTime),
            {ok, NewPlayer, LeftTime};
        _ ->
            {fail, 9}
    end.


%% @doc 夫妻加速
couple_speed_up(SpeedTime) ->
    NowTime = util:unixtime(),
    BabySt = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    case BabySt#baby_st.type_id > 0 orelse NowTime >= BabySt#baby_st.born_time of
        true -> ok;
        _ ->
            NewBornTime = max(BabySt#baby_st.born_time - SpeedTime, NowTime),
            NewBabySt = BabySt#baby_st{born_time = NewBornTime, is_change = 1},
            lib_dict:put(?PROC_STATUS_PLAYER_BABY, NewBabySt)
    end.


%% @doc 离线加速
couple_speed_up_off_line(_PKey, _SpeedTime) ->
    NowTime = util:unixtime(),
    BabySt = baby_init:init_baby(_PKey),
    case BabySt#baby_st.type_id > 0 orelse NowTime >= BabySt#baby_st.born_time of
        true -> ok;
        _ ->
            NewBornTime = max(BabySt#baby_st.born_time - _SpeedTime, NowTime),
            NewBabySt = BabySt#baby_st{born_time = NewBornTime, is_change = 1},
            baby_load:replace_baby(NewBabySt)
    end.


%% @doc  剩余时间推送
time_icon_push(Player) ->
    NowTime = util:unixtime(),
    #baby_st{type_id = TypeId, born_time = BornTime} = lib_dict:get(?PROC_STATUS_PLAYER_BABY),
    if
        TypeId =< 0 andalso BornTime > NowTime ->
            LeftTime = BornTime - NowTime,
            {ok, BinData} = pt_163:write(16308, {LeftTime}),
            server_send:send_to_sid(Player#player.sid, BinData);
        true ->
            ok
    end.

pack_baby_skill_13041(BabyTypeId, CurStep, BabySkillList) ->
    case data_baby:get(BabyTypeId) of
        #base_baby{skill_list = SkillList} ->
            lists:map(fun({Cell, Step, SkillId}) ->
                case lists:keyfind(Cell, 1, BabySkillList) of
                    {_, CurSkillId} ->
                        case data_skill:get(CurSkillId) of
                            #skill{goods = {_GoodsId, _Num}, next_skillid = _NextSkillId} ->
                                [Cell, CurSkillId, 1, Step];
                            _ ->
                                [Cell, CurSkillId, 0, Step]
                        end;
                    _ ->
                        #skill{goods = {_GoodsId, _Num}} = data_skill:get(SkillId),
                        case CurStep >= Step of
                            true ->
                                [Cell, SkillId, 1, Step];
                            false ->
                                [Cell, SkillId, 0, Step]
                        end
                end
                      end, SkillList);
        _ ->
            []
    end.