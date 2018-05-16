%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 下午1:57
%%%-------------------------------------------------------------------
-module(vip).
-author("fengzhenlin").
-include("server.hrl").
-include("vip.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("pet.hrl").


%% 协议接口
-export([
    get_player_vip/1,
    buy_gift/2,
    get_week_gift/1
]).

%% 内部接口
-export([
    use_vip_card/3,
    use_free_vip_card/2,
    calc_vip_lv/1,
    add_vip_exp/2,  %%充值增加vip经验
    get_vip_attr/0,
    calc_player_vip_lv/1,
    get_vip_gift_state/1,
    get_real_vip/0,
    vip_send_mail/0
]).

-export([
    fix/0
]).

%%获取玩家vip信息
get_player_vip(Player) ->
    VipSt = lib_dict:get(?PROC_STATUS_VIP),
    #st_vip{
        lv = Lv,
        sum_val = Exp,
        free_lv = FreeLv,
        free_time = FreeTime,
        week_num = WeekNum
    } = VipSt,
    LeaveTime = max(0, FreeTime - util:unixtime()),
    StateList = get_state_list(Player),
    ?DEBUG("~p~n", [{Lv, Exp, WeekNum, FreeLv, LeaveTime}]),
    {ok, Bin} = pt_470:write(47001, {Lv, Exp, StateList, WeekNum, FreeLv, LeaveTime}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_state_list(_Player) ->
    VipSt = lib_dict:get(?PROC_STATUS_VIP),
    #st_vip{
        lv = Lv,
        buy_list = BuyList
    } = VipSt,
    F = fun(VipLv) ->
        State =
            case lists:member(VipLv, BuyList) of
                true -> 2;
                false ->
                    case Lv >= VipLv of
                        true -> 1;
                        false -> 0
                    end
            end,
        [VipLv, State]
    end,
    lists:map(F, lists:seq(1, data_vip_args:get_max_lv())).

%%领取VIP礼包
buy_gift(Player, VipLv) ->
    case check_buy_gift(Player, VipLv) of
        {false, Res} ->
            {false, Res};
        {ok, AwardList0, Cost} ->
            NewPlayer = money:add_no_bind_gold(Player, -Cost, 235, 0, 0),
            case goods:give_goods(NewPlayer, goods:make_give_goods_list(235, AwardList0)) of
                {ok, NewPlayer1} ->
                    VipSt = lib_dict:get(?PROC_STATUS_VIP),
                    NewVipSt = VipSt#st_vip{buy_list = VipSt#st_vip.buy_list ++ [VipLv]},
                    lib_dict:put(?PROC_STATUS_VIP, NewVipSt),
                    vip_load:dbup_vip_info(NewVipSt),
                    activity:get_notice(NewPlayer, [77, 127, 128], true),
                    {ok, NewPlayer1};
                _ ->
                    {false, 0}
            end;
        _Other ->
            {false, 0}
    end.
check_buy_gift(Player, VipLv) ->
    VipSt = lib_dict:get(?PROC_STATUS_VIP),
    #st_vip{
        lv = Lv
    } = VipSt,
    if
        Lv < VipLv -> {false, 2};
        true ->
            case lists:member(VipLv, VipSt#st_vip.buy_list) of
                true -> {false, 4};
                false ->
                    case data_vip_args:get(52, VipLv) of
                        [] ->
                            {false, 0};
                        {AwardList, Cost} ->
                            case money:is_enough(Player, Cost, gold) of
                                false -> {false, 3};
                                true ->
                                    {ok, AwardList, Cost}
                            end
                    end
            end
    end.


%%领取每周vip礼包
get_week_gift(Player) ->
    case check_get_week_gift(Player) of
        {false, Res} ->
            {false, Res};
        {ok, AwardList0, Num} ->
            AwardList = goods:make_give_goods_list(236, AwardList0),
            case give_goods_list(Player, AwardList, Num) of
                {ok, NewPlayer} ->
                    VipSt = lib_dict:get(?PROC_STATUS_VIP),
                    NewVipSt = VipSt#st_vip{
                        week_num = VipSt#st_vip.lv,
                        week_get_time = util:unixtime()
                    },
                    lib_dict:put(?PROC_STATUS_VIP, NewVipSt),
                    vip_load:dbup_vip_info(NewVipSt),
                    activity:get_notice(Player, [88], true),
                    {ok, NewPlayer};
                {false, _} ->
                    {false, 0}
            end
    end.

check_get_week_gift(_Player) ->
    VipSt = lib_dict:get(?PROC_STATUS_VIP),
    #st_vip{
        lv = Lv,
        week_num = WeekNum
    } = VipSt,
    if
        WeekNum >= Lv -> {false, 4};
        true ->
            case data_vip_args:get(53, 1) of
                [] ->
                    {false, 0};
                AwardList ->
                    {ok, AwardList, Lv - WeekNum}
            end
    end.


%%使用vip卡
use_vip_card(Player, BaseGoods, Num) ->
    AddExp = BaseGoods#goods_type.special_param_list,
    SumExp = round(AddExp * Num),
    VipSt = lib_dict:get(?PROC_STATUS_VIP),
    #st_vip{
        charge_val = CVal,
        other_val = OVal
    } = VipSt,
    NewSumVal = CVal + OVal + SumExp,
    NewLv = calc_vip_lv(NewSumVal),
    NewVipSt = VipSt#st_vip{
        other_val = OVal + SumExp,
        sum_val = NewSumVal,
        lv = NewLv
    },
    lib_dict:put(?PROC_STATUS_VIP, NewVipSt),
    vip_load:dbup_vip_info(NewVipSt),
    get_player_vip(Player),
    Player1 =
        case NewLv > VipSt#st_vip.lv of
            true ->
                %%同步场景vip信息
                self() ! sync_vip_data,
                player_util:count_player_attribute(Player, true);
            false ->
                Player
        end,
    update_free_vip(Player1),
    calc_player_vip_lv(Player1).

calc_vip_lv(Exp) ->
    All = lists:seq(1, data_vip_args:get_max_lv()),
    calc_vip_lv_helper(All, Exp, 0).
calc_vip_lv_helper([], _Exp, AccLv) -> AccLv;
calc_vip_lv_helper([Lv | Tail], Exp, AccLv) ->
    NeedExp = data_vip_args:get(0, Lv),
    case NeedExp > Exp of
        true -> AccLv;
        false ->
            calc_vip_lv_helper(Tail, Exp, Lv)
    end.

%%玩家VIP等级
calc_player_vip_lv(Player) ->
    VipSt = lib_dict:get(?PROC_STATUS_VIP),
    #st_vip{
        lv = Lv,
        free_lv = FreeLv
    } = VipSt,
    Player#player{vip_lv = max(Lv, FreeLv)}.

%%充值增加VIP经验
add_vip_exp(Player, Exp) ->
    VipSt = lib_dict:get(?PROC_STATUS_VIP),
    #st_vip{
        charge_val = CVal,
        other_val = OVal
    } = VipSt,
    NewSumVal = CVal + OVal + Exp,
    NewLv = calc_vip_lv(NewSumVal),
    NewVipSt = VipSt#st_vip{
        charge_val = CVal + Exp,
        sum_val = NewSumVal,
        lv = NewLv
    },
    lib_dict:put(?PROC_STATUS_VIP, NewVipSt),
    vip_load:dbup_vip_info(NewVipSt),
    get_player_vip(Player),
    Player1 =
        case NewLv > VipSt#st_vip.lv of
            true ->
                %%同步场景vip信息
                self() ! sync_vip_data,
                equip_soul:update_soul_all(NewLv),
%%                goods_util:vip_add_bag_cell(Player, NewVipSt#st_vip.lv, VipSt#st_vip.lv),
                player_util:count_player_attribute(Player, true);
            false ->
                Player
        end,
    update_free_vip(Player1),
    calc_player_vip_lv(Player1).

%%获取vip属性
get_vip_attr() ->
    VipSt = lib_dict:get(?PROC_STATUS_VIP),
    #st_vip{
        lv = VipLv
    } = VipSt,
    case data_vip_args:get(4, VipLv) of
        [] -> #attribute{};
        Attrs -> attribute_util:make_attribute_by_key_val_list(Attrs)
    end.

%%使用vip体验卡
use_free_vip_card(Player, [ToVipLv, EffectTime]) ->
    VipSt = lib_dict:get(?PROC_STATUS_VIP),
    NewVipSt =
        case Player#player.vip_lv >= ToVipLv of
            true -> %%本来的vip等级已经超过体验等级
                %%增加10点VIP经验
                NewOtherVal = VipSt#st_vip.other_val,
                NewSumVal = VipSt#st_vip.charge_val + NewOtherVal,
                NewLv = calc_vip_lv(NewSumVal),
                VipSt#st_vip{
                    other_val = NewOtherVal,
                    lv = NewLv
                };
            false ->
                VipSt#st_vip{
                    free_lv = ToVipLv,
                    free_time = util:unixtime() + EffectTime
                }
        end,
    lib_dict:put(?PROC_STATUS_VIP, NewVipSt),
    get_player_vip(Player),
    case NewVipSt#st_vip.free_lv > 0 of
        true ->
            {ok, Bin} = pt_470:write(47003, {1, ToVipLv}),
            server_send:send_to_sid(Player#player.sid, Bin);
        false ->
            skip
    end,
    vip_load:dbup_vip_info(NewVipSt),
    %%同步场景vip信息
    self() ! sync_vip_data,
    calc_player_vip_lv(Player).

%%更新体验VIP
update_free_vip(Player) ->
    vip_init:update(Player).

get_vip_gift_state(Player) ->
    F = fun([_, State]) ->
        ?IF_ELSE(State == 1, 1, 0)
    end,
    OpenDay = config:get_open_days(),
    Args =
        case OpenDay >= 3 of
            true -> [{show_pos, 1}];
            false -> []
        end,
    case lists:sum(lists:map(F, get_state_list(Player))) > 0 of
        true -> {1, Args};
        false -> {0, Args}
    end.




fix() ->
    Title = ?T("全民抓Bug福利"),
    Content = ?T("亲爱的勇者们，感谢你们支持和配合抓bug大行动,帮助我们修复了宝石的重大bug,现特发福利鼓励！欢迎勇者们以后继续积极提bug，将获得更多的福利和奖励（核实之后视bug的严重程度，奖励500~10000元宝）。举报途径：好友GM、客服Q2850296076或搜索加入武动九天官方群反馈."),
    spawn(fun() -> gm_all(1, [Title, Content], 0) end),
    ok.
gm_all(Start, Row, LastLoginTime) ->
    Num = 100,
    [Title, Content] = Row,
    Sql = io_lib:format("select a.pkey,b.vip_lv from player_login a left join player_state b on a.pkey = b.pkey where a.last_login_time > ~p order by a.reg_time asc limit ~p ,~p ", [LastLoginTime, Start, Num]),
    L = db:get_all(Sql),
    F = fun([Pkey, VipLv]) ->
        case lists:member(Pkey, []) of
            true -> skip;
            false ->
                GoodsList =
                    if
                        VipLv >= 12 -> [{20116, 1}, {20126, 1}, {20136, 1}, {20146, 1}];
                        VipLv >= 9 andalso VipLv =< 11 -> [{20115, 1}, {20125, 1}, {20135, 1}, {20145, 1}];
                        VipLv >= 5 andalso VipLv =< 8 -> [{20114, 1}, {20124, 1}, {20134, 1}, {20144, 1}];
                        VipLv >= 4 -> [{4104009, 1}];
                        true -> []
                    end,
                case GoodsList of
                    [] -> skip;
                    _ -> mail:sys_send_mail([Pkey], Title, Content, GoodsList)
                end
        end
    end,
    lists:foreach(F, L),
    End = Start + Num,
    timer:sleep(2000),
    case L of
        [] -> skip;
        _ -> gm_all(End, Row, LastLoginTime)
    end.

get_real_vip() ->
    St = lib_dict:get(?PROC_STATUS_VIP),
    St#st_vip.lv.


give_goods_list(Player, _AwardList, 0) -> {ok, Player};
give_goods_list(Player, AwardList, Num) ->
    NewAwardList0 = lists:duplicate(Num, AwardList),
    NewAwardList = lists:append(NewAwardList0),
    case goods:give_goods(Player, NewAwardList) of
        {ok, NewPlayer} ->
            {ok, NewPlayer};
        _ ->
            {false, 0}
    end.

vip_send_mail() ->
    Title = ?T("VIP礼包调整"),
    Content = ?T("亲爱的玩家，vip4奖励火岩狼星级有所调整，特地补发vip4及以上的玩家一只4星火岩狼，感谢您的支持！祝您游戏愉快！"),
    spawn(fun() -> gm_all_vip(1, [Title, Content], 0) end), ok.
gm_all_vip(Start, Row, LastLoginTime) ->
    Num = 100,
    [Title, Content] = Row,
    Sql = io_lib:format("select a.pkey,b.vip_lv from player_login a left join player_state b on a.pkey = b.pkey where a.last_login_time > ~p order by a.reg_time asc limit ~p ,~p ", [LastLoginTime, Start, Num]),
    L = db:get_all(Sql),
    F = fun([Pkey, VipLv]) ->
        case lists:member(Pkey, []) of
            true -> skip;
            false ->
                GoodsList =
                    if
                        VipLv >= 4 -> [{4104009, 1}];
                        true -> []
                    end,
                case GoodsList of
                    [] -> skip;
                    _ -> mail:sys_send_mail([Pkey], Title, Content, GoodsList)
                end
        end
    end,
    lists:foreach(F, L),
    End = Start + Num,
    timer:sleep(2000),
    case L of
        [] -> skip;
        _ -> gm_all_vip(End, Row, LastLoginTime)
    end.

