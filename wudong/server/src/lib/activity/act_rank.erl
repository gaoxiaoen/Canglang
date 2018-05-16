%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 一月 2016 下午4:40
%%%-------------------------------------------------------------------
-module(act_rank).
-author("fengzhenlin").
-include("common.hrl").
-include("activity.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("daily.hrl").
-include("g_daily.hrl").

-define(RANK_NUM, 20).

%%协议接口
-export([
    get_act_rank_info/3,
    get_act_rank_lim_buy/1,
    buy_act_gift/3,
    get_rank_player/4,
    get_hof/3 %%获取名人堂
]).

%% API
-export([
    init/1,
    logout/1,
    reload_rank/1,
    reward/1,
    get_state/0,
    get_buy_state/0,
    get_type_list/0,
    get_leave_time/1,
    get_leave_time/0,
    notice/2,
    notice_2/3,
    get_rank_state/1
]).

%% 更新排行数据
-export([
    update_player_rank_data/3
]).

%%获取今天是活动第几天
get_act_day() ->
    case get_act() of
        [] -> 0;
        [Base | _] ->
            #base_act_rank{
                open_info = OpenInfo
            } = Base,
            #open_info{
                open_day = OpenDay,
                end_day = EndDay,
                start_time = StartTime1,
                end_time = EndTime1,
                merge_st_day = MergeStDay,
                merge_et_day = MergeEtDay
            } = OpenInfo,
            StartTime = ?IF_ELSE(StartTime1 > 0, util:unixtime(StartTime1), 0),
            EndTime = ?IF_ELSE(EndTime1 > 0, util:unixtime(EndTime1), 0),
            NowOpenDay = config:get_open_days(),
            Now = util:unixtime(),
            MergeDay = config:get_merge_days(),
            if
                OpenDay > 0 andalso NowOpenDay >= OpenDay andalso NowOpenDay =< EndDay ->
                    NowOpenDay - (OpenDay - 1);
                StartTime > 0 andalso Now >= StartTime andalso Now =< EndTime ->
                    util:get_diff_days(Now, StartTime) + 1;
                MergeStDay > 0 andalso MergeDay >= MergeStDay andalso MergeDay =< MergeEtDay ->
                    MergeDay - (MergeStDay - 1);
                true -> 0
            end
    end.

%%获取排行榜信息
get_act_rank_info(RankDict, Sid, Pkey) ->
    case get_act() of
        [] -> skip;
        _ ->
            Openday = get_act_day(),
            GetDay = max(1, Openday),
            L0 = activity:get_work_list(data_act_rank),
            ActList = lists:sublist(L0, 6),
            TypeList = get_type_list(),
            SubL = lists:sublist(TypeList, GetDay),
            DataList = get_act_rank_info_helper(SubL, RankDict, Pkey, ActList, []),
            {ok, Bin} = pt_430:write(43011, {Openday, lists:reverse(DataList)}),
            server_send:send_to_sid(Sid, Bin),
            ok
    end.
get_act_rank_info_helper([], _RankDict, _Pkey, _ActList, AccList) -> lists:reverse(AccList);
get_act_rank_info_helper([Type | Tail], RankDict, Pkey, ActList, AccList) ->
    ResData =
        case dict:find(Type, RankDict) of
            error ->
                [Type, 0, 0, [], [], []];
            {ok, Ar} ->
                #ar{
                    rank = RankList,
                    reward_list = RewardList
                } = Ar,
                MyRank =
                    case lists:keyfind(Pkey, #pinfo.pkey, RankList) of
                        false -> 0;
                        MyPinfo -> MyPinfo#pinfo.rank
                    end,
                case lists:keyfind(Type, #base_act_rank.type, ActList) of
                    false -> [Type, 0, 0, [], [], []];
                    BaseActRank ->
                        #base_act_rank{
                            gift_list = GiftList
                        } = BaseActRank,
                        GiftList1 = [[R, G] || {R, G} <- GiftList],
                        RandPinfoList =
                            case RewardList == [] of
                                true ->  %%还没结算，获取排行榜信息
                                    lists:sublist(RankList, 10);
                                false -> %%已结算，获取结算面板信息
                                    F = fun(Pkey0, AccL) ->
                                        case lists:keyfind(Pkey0, #pinfo.pkey, RankList) of
                                            false -> AccL;
                                            Pinfo -> AccL ++ [Pinfo]
                                        end
                                        end,
                                    lists:foldl(F, [], RewardList)
                            end,
                        Fp = fun(P) ->
                            #pinfo{
                                pkey = Pkey0,
                                rank = Rank,
                                info = Info,
                                sn = Sn,
                                pf = Pf,
                                name = Name,
                                lv = Lv,
                                career = Career,
                                vip = Vip,
                                realm = Realm
                            } = P,
                            [Rank, Info, [Pkey0, Sn, Pf, Name, Lv, Career, Vip, Realm]]
                             end,
                        RewardInfoList = lists:map(Fp, RandPinfoList),
                        LeaveTime = get_leave_time(Type),
                        [Type, LeaveTime, MyRank, GiftList1, RewardInfoList]
                end
        end,
    LTime = lists:nth(2, ResData),
    NewAccList =
        if
            LTime == -1 -> [ResData];
            LTime > 0 andalso LTime =< ?ONE_DAY_SECONDS -> [ResData | AccList];
            true ->
                AccList
        end,
    get_act_rank_info_helper(Tail, RankDict, Pkey, ActList, NewAccList).

%%获取冲榜抢购
get_act_rank_lim_buy(Player) ->
    Openday = get_act_day(),
    GetDay = max(1, Openday),
    L0 = activity:get_work_list(data_act_rank),
    ActList = lists:sublist(L0, 6),
    TypeList = get_type_list(),
    case GetDay > length(TypeList) of
        true -> skip;
        false ->
            Type = lists:nth(GetDay, TypeList),
            case lists:keyfind(Type, #base_act_rank.type, ActList) of
                false -> skip;
                BaseActRank ->
                    #base_act_rank{
                        sell_goods = SellGoods
                    } = BaseActRank,
                    F1 = fun(GoodsInfo) ->
                        {G, MaxNum, P, OP} = GoodsInfo,
                        Index = util:get_list_elem_index(GoodsInfo, SellGoods),
                        Count = daily:get_count(?DAILY_ACT_RANK(Type, Index)),
                        LeaveNum = max(0, MaxNum - Count),
                        [G, LeaveNum, P, OP]
                         end,
                    SellGoods1 = lists:map(F1, SellGoods),
                    LeaveTime = get_leave_time(Type),
                    {ok, Bin} = pt_430:write(43014, {Type, LeaveTime, SellGoods1}),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end
    end.

%%购买礼包
buy_act_gift(Player, Type, GiftId) ->
    case check_buy_act_gift(Player, Type, GiftId) of
        {false, Res} ->
            {false, Res};
        {ok, Count, DailyCountType, CostBGold, CostGold, LeaveBuyNum} ->
            NewPlayer =
                case CostBGold > 0 of
                    true -> money:add_gold(Player, -CostBGold, 112, GiftId, 1);
                    false -> money:add_no_bind_gold(Player, -CostGold, 112, GiftId, 1)
                end,
            GiveGoodsList = goods:make_give_goods_list(112, [{GiftId, 1}]),
            case goods:give_goods(NewPlayer, GiveGoodsList) of
                {ok, NewPlayer1} ->
                    NewCount = Count + 1,
                    daily:set_count(DailyCountType, NewCount),
                    activity_log:log_get_gift(Player#player.key, Player#player.nickname, GiftId, 1, 112),
                    {ok, NewPlayer1, LeaveBuyNum};
                _Err ->
                    ?ERR("act_rank give act_gift err ~p~n", [_Err]),
                    {false, 0}
            end
    end.
check_buy_act_gift(Player, Type, GiftId) ->
    ActList = activity:get_work_list(data_act_rank),
    case lists:keyfind(Type, #base_act_rank.type, ActList) of
        false -> {false, 4};
        BaseActRank ->
            #base_act_rank{
                sell_goods = GoodsList
            } = BaseActRank,
            case lists:keyfind(GiftId, 1, GoodsList) of
                false -> {false, 0};
                GoodsInfo ->
                    {GiftId, MaxNum, CostGold, _OldCostGold} = GoodsInfo,
                    Index = util:get_list_elem_index(GoodsInfo, GoodsList),
                    DailyCountType = ?DAILY_ACT_RANK(Type, Index),
                    %%全用非绑元宝
                    Gold = CostGold,
                    BGold = 0,
%%                     case Type == 6 of
%%                         true -> Gold = CostGold,BGold = 0;
%%                         false -> Gold = 0,BGold = CostGold
%%                     end,
                    IsEnough = money:is_enough(Player, BGold, bgold),
                    IsEnough1 = money:is_enough(Player, Gold, gold),
                    Count = daily:get_count(DailyCountType),
                    if
                        not IsEnough -> {false, 5};
                        not IsEnough1 -> {false, 5};
                        Count >= MaxNum -> {false, 6};
                        true ->
                            {ok, Count, DailyCountType, BGold, Gold, MaxNum - Count - 1}
                    end
            end
    end.

%%获取排行玩家信息
get_rank_player(RankDict, Type, Sid, _Pkey) ->
    case dict:find(Type, RankDict) of
        error -> [Type, 0, [], [], []];
        {ok, Ar} ->
            #ar{
                rank = RankList
            } = Ar,
            F = fun(Pinfo, AccL) ->
                #pinfo{
                    rank = Rank,
                    info = Info,
                    pkey = PPkey,
                    sn = Sn,
                    pf = Pf,
                    name = Name,
                    lv = Lv,
                    career = Career,
                    vip = Vip,
                    realm = Realm
                } = Pinfo,
                [[Rank, Info, [PPkey, Sn, Pf, Name, Lv, Career, Vip, Realm]] | AccL]
                end,
            List = lists:foldl(F, [], RankList),
            {ok, Bin} = pt_430:write(43013, {List}),
            server_send:send_to_sid(Sid, Bin),
            ok
    end.

%%获取名人堂
get_hof(RankDict, Sid, _Pkey1) ->
    %%针对合服名人堂永久不消失做特殊处理
    OpenDay0 = get_act_day(),
    OpenDay =
        case OpenDay0 == 0 of
            true ->
                case config:get_merge_days() > 7 of
                    true -> 6;
                    false -> OpenDay0
                end;
            false -> OpenDay0
        end,
    TypeList0 = get_type_list(),
    TypeList = ?IF_ELSE(TypeList0 == [], [6, 1, 2, 4, 5, 3], TypeList0),
    TypeList1 = lists:sublist(TypeList, OpenDay),
    F = fun(Type) ->
        case dict:find(Type, RankDict) of
            error -> [];
            {ok, Ar} ->
                #ar{
                    reward_list = RewardList,
                    rank = RankList
                } = Ar,
                case RewardList == [] orelse RankList == [] of
                    true -> [];
                    false ->
                        Top1 = hd(lists:keysort(#pinfo.rank, RankList)),
                        #pinfo{
                            pkey = Pkey
                        } = Top1,
                        Player = shadow_proc:get_shadow(Pkey),
                        #player{
                            nickname = NickName,
                            realm = Realm,
                            career = Career,
                            cbp = Cbp,
                            wing_id = WingId,
                            vip_lv = VipLv
                        } = Player,
                        DesignList =
                            case Type of
                                ?ACT_RANK_EQUIP_STREN -> [5001];
                                ?ACT_RANK_PET -> [5002];
                                ?ACT_RANK_BAOSHI -> [5003];
                                ?ACT_RANK_MOUNT -> [5004];
                                ?ACT_RANK_WING -> [5005];
                                ?ACT_RANK_COMBATPOWER -> [5006]
                            end,
                        [[Type, Pkey, NickName, VipLv, Realm, Career, Cbp, WingId,
                            Player#player.equip_figure#equip_figure.weapon_id,
                            Player#player.equip_figure#equip_figure.clothing_id,
                            Player#player.light_weaponid,
                            Player#player.fashion#fashion_figure.fashion_cloth_id,
                            Player#player.footprint_id,
                            Player#player.mount_id,
                            DesignList
                        ]]
                end
        end
        end,
    TypeInfoList = lists:flatmap(F, TypeList1),
    {ok, Bin} = pt_430:write(43015, {TypeInfoList}),
    server_send:send_to_sid(Sid, Bin),
    ok.

%%初始化，获取数据
init(Player) ->
    ActRankSt = activity_load:dbget_player_act_rank(Player),
    lib_dict:put(?PROC_STATUS_ACT_RANK, ActRankSt),
    Player.

%%退出保存
logout(Player) ->
    ActRankSt = lib_dict:get(?PROC_STATUS_ACT_RANK),
    activity_load:dbup_player_act_rank(ActRankSt),
    Player.

%%重载排行榜
reload_rank(_RankDict) ->
    BaseList = get_act(),
    Pid = self(),
    F = fun(Type) ->
        case lists:keyfind(Type, #base_act_rank.type, BaseList) of
            false -> skip;
            Base ->
                load_rank(Type, Pid, Base#base_act_rank.min_val),
                timer:sleep(500)
        end
        end,
    Openday = get_act_day(),
    TypeList = get_type_list(),
    GetDay = max(1, Openday),
    Len = length(TypeList),
    %%只更新今天及后面的榜
    ReloadTypeList =
        case GetDay > Len of
            true -> [];
            false -> lists:sublist(TypeList, GetDay, Len - GetDay + 1)
        end,
    spawn(fun() -> lists:foreach(F, ReloadTypeList) end),
    ok.

load_rank(Type, Pid, MinVal) ->
    %%equip,pet,baoshi,mount,wing,power
    case Type of
        ?ACT_RANK_EQUIP_STREN -> %%装备强化等级
            RankTime = 1470412800, %%根据策划要求，装备排行榜要这个时间段以后上线的玩家才能上榜
            Sql = io_lib:format("select a.pkey,a.equip_stren_lv,p.sn,p.pf,p.lv,p.career,p.nickname,p.realm,p.vip_lv from player_act_rank a left join player_state p on a.pkey = p.pkey left join player_login l on a.pkey = l.pkey where a.equip_stren_lv >= ~p and l.status = 0 and l.last_login_time > ~p order by a.equip_stren_lv desc,a.equip_stren_lv_time asc limit ~p", [MinVal, RankTime, ?RANK_NUM]);
        ?ACT_RANK_PET -> %%宠物战力
            Sql = io_lib:format("select a.pkey,a.cbp,p.sn,p.pf,p.lv,p.career,p.nickname,p.realm,p.vip_lv from pet a left join player_state p on a.pkey = p.pkey left join player_login l on a.pkey = l.pkey where a.state = 2 and a.cbp >= ~p and l.status = 0 order by a.cbp desc limit ~p", [MinVal, ?RANK_NUM]);
        ?ACT_RANK_BAOSHI ->  %%宝石榜
            Sql = io_lib:format("select a.pkey,a.baoshi_lv,p.sn,p.pf,p.lv,p.career,p.nickname,p.realm,p.vip_lv from player_act_rank a left join player_state p on a.pkey = p.pkey left join player_login l on a.pkey = l.pkey where a.baoshi_lv >= ~p and l.status = 0 order by a.baoshi_lv desc,a.baoshi_lv_time asc limit ~p", [MinVal, ?RANK_NUM]);
        ?ACT_RANK_MOUNT -> %%坐骑榜
            Sql = io_lib:format("select a.pkey,a.`stage`,p.sn,p.pf,p.lv,p.career,p.nickname,p.realm,p.vip_lv from mount a left join player_state p on a.pkey = p.pkey left join player_login l on a.pkey = l.pkey where p.combat_power > 0 and a.`stage` >= ~p and l.status = 0 order by a.`stage` desc,a.cbp desc limit ~p", [MinVal, ?RANK_NUM]);
        ?ACT_RANK_WING -> %%翅膀榜
            Sql = io_lib:format("select a.pkey,a.combatpower,p.sn,p.pf,p.lv,p.career,p.nickname,p.realm,p.vip_lv from wing a left join player_state p on a.pkey = p.pkey left join player_login l on a.pkey = l.pkey where a.combatpower >= ~p and l.status = 0 order by a.combatpower desc limit ~p", [MinVal, ?RANK_NUM]);
        ?ACT_RANK_COMBATPOWER -> %%战力榜
            Sql = io_lib:format("select p.pkey,p.combat_power,p.sn,p.pf,p.lv,p.career,p.nickname,p.realm,p.vip_lv from player_state p left join player_login l on p.pkey = l.pkey where p.combat_power > 70000 and l.status = 0 order by p.combat_power desc limit ~p", [?RANK_NUM])
    end,
    Data =
        case db:get_all(Sql) of
            [] ->
                {Type, [#pinfo{pkey = 1234567890123456789012, sn = 1, pf = 1, name = util:to_list(?T("虚位以待")), career = 1, lv = 10, info = 100, realm = 0, rank = 1, vip = 0}]};
            L ->
                F = fun([Pkey, Info, Sn, Pf, Lv, Career, Nickname, Realm, VipLv], Order) ->
                    {#pinfo{
                        pkey = Pkey,
                        sn = Sn,
                        pf = Pf,
                        name = util:to_list(Nickname),
                        lv = Lv,
                        career = Career,
                        vip = VipLv,
                        realm = Realm,
                        info = Info,
                        rank = Order
                    }, Order + 1}

                    end,
                {L1, _} = lists:mapfoldl(F, 1, L),
                %%记录最后的排名数据，方便对比
                Pinfo = lists:last(L1),
                g_daily:set_count(?G_DAILY_ACT_RANK(Type), Pinfo#pinfo.info),
                {Type, L1}
        end,
    Pid ! {act_rank, Data}.

%%发放奖励
reward(RankDict) ->
    Openday = get_act_day(),
    TypeList =
        case Openday < 2 orelse Openday > 8 of
            true -> [];
            false ->
                RewardNum = min(Openday - 1, 6),
                TypeIdList = get_type_list(),
                case RewardNum > length(TypeIdList) of
                    true -> [];
                    false -> [lists:nth(RewardNum, TypeIdList)]
                end
        end,
    F = fun(Type, AccDict) ->
        reward(AccDict, Type)
        end,
    lists:foldl(F, RankDict, TypeList).
reward(RankDict, RewardType) ->
    case dict:find(RewardType, RankDict) of
        error -> RankDict;
        {ok, Ar} ->
            #ar{
                type = Type,
                rank = RankList0,
                reward_list = OldRewardList
            } = Ar,
            case OldRewardList =/= [] of
                true -> RankDict;
                false ->
                    RankList = lists:sublist(lists:keysort(#pinfo.rank, RankList0), 9),

                    L0 = activity:get_work_list(data_act_rank),
                    ActList = lists:sublist(L0, 6),
                    case lists:keyfind(RewardType, #base_act_rank.type, ActList) of
                        false ->
                            GiftList = [];
                        BaseActRank ->
                            #base_act_rank{
                                gift_list = GiftList
                            } = BaseActRank
                    end,
                    RewardList = reward_helper(RankList, GiftList, [], Type),
                    NewAr = Ar#ar{
                        reward_list = RewardList
                    },
                    dict:store(RewardType, NewAr, RankDict)
            end
    end.
reward_helper([], _GiftList, AccRewardList, _Type) -> AccRewardList;
reward_helper([Pinfo | Tail], GiftList, AccRewardList, Type) ->
    #pinfo{
        rank = Rank,
        pkey = Pkey,
        name = Name
    } = Pinfo,
    GiftRank =
        if
            Rank == 1 -> 1;
            Rank >= 2 andalso Rank =< 3 -> 2;
            Rank >= 4 andalso Rank =< 6 -> 3;
            Rank >= 7 andalso Rank =< 9 -> 4;
            true -> 0
        end,
    case lists:keyfind(GiftRank, 1, GiftList) of
        false ->
            ?ERR("can not find act_rank gift ~p~n", [{Rank, GiftList}]),
            reward_helper(Tail, GiftList, AccRewardList, Type);
        {GiftRank, GiftId} ->
            %%奖励邮件
            {Title, Content0} = t_mail:mail_content(9),
            Content = io_lib:format(Content0, [get_rank_name(Type)]),
            mail:sys_send_mail([Pkey], Title, Content, [{GiftId, 1}]),
            activity_log:log_get_gift(Pkey, Name, GiftId, 1, 118),
            reward_helper(Tail, GiftList, [Pkey | AccRewardList], Type)
    end.

%%更新玩家装强化等级
update_player_rank_data(_Player, Type, IsForce) ->
    Data = g_daily:get_count(?G_DAILY_ACT_RANK(Type)),
    ActRankSt = lib_dict:get(?PROC_STATUS_ACT_RANK),
    #st_act_rank{
        equip_stren_lv = ELv,
        equip_stren_lv_time = _ETime,
        baoshi_lv = BLv,
        baoshi_lv_time = _BTime
    } = ActRankSt,
    Now = util:unixtime(),
    {NewActRankSt, NewData} =
        case Type of
            ?ACT_RANK_EQUIP_STREN -> %%装备强化等级
                StrenLvSum = equip_stren:get_equip_stren_sum_lv(),
                NewSt =
                    case StrenLvSum =/= ELv of
                        true -> ActRankSt#st_act_rank{equip_stren_lv = StrenLvSum, equip_stren_lv_time = Now};
                        false -> ActRankSt
                    end,
                {NewSt, StrenLvSum};
            ?ACT_RANK_BAOSHI -> %%身上宝石等级
                BaoshiMaxLv = equip_inlay:get_equip_inlay_stone_lv_total(),
                NewSt =
                    case BaoshiMaxLv =/= BLv of
                        true -> ActRankSt#st_act_rank{baoshi_lv = BaoshiMaxLv, baoshi_lv_time = Now};
                        false -> ActRankSt
                    end,
                {NewSt, BaoshiMaxLv};
%%         ?ACT_RANK_WING -> %%翅膀阶级
%%             WingLv = wing:get_wing_lv(),
%%             NewSt =
%%                 case WingLv =/= WLv of
%%                     true -> ActRankSt#st_act_rank{wing_stage = WingLv,wing_stage_time = Now};
%%                     false -> ActRankSt
%%                 end,
%%             {NewSt, WingLv};
            _ ->
                {ActRankSt, 0}
        end,
    lib_dict:put(?PROC_STATUS_ACT_RANK, NewActRankSt),
    State = get_state(),
    if
        State == -1 -> skip;
        true ->
            case NewData >= Data orelse IsForce of %%避免更新数据库过频繁，只有在数值进入前100名才实时更新数据库，否则只在玩家下线才更新
                true ->
                    activity_load:dbup_player_act_rank(NewActRankSt);
                false ->
                    skip
            end
    end.

%%获取活动状态
get_state() ->
    case get_act() of
        [] -> -1;
        [Base|_] ->
            #base_act_rank{act_info = ActInfo} = Base,
            Args = activity:get_base_state(ActInfo),
            {0,Args}
    end.

get_buy_state() ->
    LeaveTime = activity:get_leave_time(data_act_rank),
    if
        LeaveTime < ?ONE_DAY_SECONDS -> -1;
        true -> 0
    end.

get_act() ->
    activity:get_work_list(data_act_rank).

%%获取活动类型列表
get_type_list() ->
    L0 = activity:get_work_list(data_act_rank),
    ActList = lists:sublist(L0, 6),
    [B#base_act_rank.type || B <- ActList].

get_leave_time(Type) ->
    OpenDay = get_act_day(),
    TypeList = get_type_list(),
    Index = util:get_list_elem_index(Type, TypeList),
    ActOpenDay = Index,
    case ActOpenDay >= OpenDay of
        true -> ?ONE_DAY_SECONDS - (util:unixtime() - util:unixdate()) + (ActOpenDay - OpenDay) * ?ONE_DAY_SECONDS;
        false -> -1
    end.

get_leave_time() ->
    OpenDay = get_act_day(),
    max(0, (7 - OpenDay) * ?ONE_DAY_SECONDS).

notice(Time, RankDict) ->
    Time1 = Time - Time rem 60 - util:unixdate(),
    TimeList = [{1, [6 * 3600, 9 * 3600, 12 * 3600, 15 * 3600, 18 * 3600]}, {2, [19 * 3600, 20 * 3600, 21 * 3600, 22 * 3600]}, {3, [22 * 3600 + 1800, 23 * 3600, 23 * 3600 + 1800]}],
    case check_notice_time(TimeList, Time1) of
        [] -> skip;
        NoticeType ->
            OpenDay = get_act_day(),
            List = get_type_list(),
            case OpenDay > length(List) orelse OpenDay == 0 of
                true -> skip;
                false ->
                    Type = lists:nth(OpenDay, List),
                    case get_rank_first(Type, RankDict) of
                        [] -> skip;
                        _Pinfo ->
%%                             _Name = get_rank_name(Type),
%%                             #pinfo{
%%                                 name = PName,
%%                                 pkey = Pkey,
%%                                 vip = Vip
%%                             } = Pinfo,
%%                             _Player = #player{nickname = PName, key = Pkey, vip_lv = Vip},
                            case NoticeType of
%%                                 1 -> notice_sys:add_notice(act_rank_1, [Name]);
%%                                 2 -> notice_sys:add_notice(act_rank_2, [Name, Player]);
%%                                 3 -> notice_sys:add_notice(act_rank_3, [Name, Player]);
                                _ -> skip
                            end
                    end
            end
    end.

check_notice_time([], _Time) -> [];
check_notice_time([{Type, TimeList} | Tail], Time) ->
    case check_notice_time_1(TimeList, Time) of
        [] -> check_notice_time(Tail, Time);
        _ -> Type
    end.
check_notice_time_1([], _Time) -> [];
check_notice_time_1([Time | _], Time) -> Time;
check_notice_time_1([_ | Tail], Time) ->
    check_notice_time_1(Tail, Time).

notice_2(Type, RankDict, OldRankDict) ->
    OpenDay = get_act_day(),
    List = get_type_list(),
    case OpenDay > length(List) orelse OpenDay == 0 of
        true -> skip;
        false ->
            NowType = lists:nth(OpenDay, List),
            case NowType == Type of
                false -> skip;
                true ->
                    _Name = get_rank_name(Type),
                    case get_rank_first(Type, RankDict) of
                        [] -> skip;
                        Pinfo ->
                            case get_rank_first(Type, OldRankDict) of
                                [] -> skip;
                                OldPinfo ->
                                    #pinfo{
%%                                         name = PName,
                                        pkey = Pkey
%%                                         vip = Vip
                                    } = Pinfo,
%%                                     _Player = #player{nickname = PName, key = Pkey, vip_lv = Vip},
                                    #pinfo{
%%                                         name = OldName,
                                        pkey = OldPkey
%%                                         vip = OldVip
                                    } = OldPinfo,
%%                                     _OldPlayer = #player{nickname = OldName, key = OldPkey, vip_lv = OldVip},
                                    case Pkey =/= OldPkey of
                                        true -> skip;%notice_sys:add_notice(act_rank_4, [Name, Player, OldPlayer]);
                                        false -> skip
                                    end
                            end
                    end
            end
    end.

get_rank_name(Type) ->
    case Type of
        ?ACT_RANK_EQUIP_STREN -> %%装备强化等级
            ?T("装备榜");
        ?ACT_RANK_PET -> %%宠物战力
            ?T("宠物榜");
        ?ACT_RANK_BAOSHI ->  %%宝石榜
            ?T("宝石榜");
        ?ACT_RANK_MOUNT -> %%坐骑榜
            ?T("坐骑榜");
        ?ACT_RANK_WING -> %%翅膀榜
            ?T("光翼榜");
        ?ACT_RANK_COMBATPOWER -> %%战力榜
            ?T("战神榜");
        _ ->
            ?T("")
    end.

get_rank_first(Type, RankDict) ->
    case dict:find(Type, RankDict) of
        error ->
            [];
        {ok, Ar} ->
            #ar{
                rank = RankList
            } = Ar,
            RankList1 = lists:keysort(#pinfo.rank, RankList),
            case RankList1 of
                [] -> [];
                [Pinfo | _] ->
                    Pinfo
            end
    end.

%%获取指定类型榜的活动状态
get_rank_state(Type) ->
    case get_act() of
        [] -> -1;
        _RankList ->
            TypeList = get_type_list(),
            Openday = get_act_day(),
            TypeList = get_type_list(),
            case Openday > length(TypeList) of
                true ->
                    case Type == lists:last(TypeList) of
                        true -> [0, 0];
                        false -> -1
                    end;
                false ->
                    CurType = lists:nth(Openday, TypeList),
                    case CurType == Type of
                        true -> [0, ?ONE_DAY_SECONDS - (util:unixtime() - util:unixdate())];
                        false ->
                            case Openday == 1 of
                                true -> -1;
                                false ->
                                    LastType = lists:nth(Openday - 1, TypeList),
                                    case LastType == Type of
                                        true -> [0, 0];
                                        false -> -1
                                    end
                            end
                    end
            end
    end.