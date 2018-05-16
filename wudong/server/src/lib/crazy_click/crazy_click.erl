%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2016 下午3:56
%%%-------------------------------------------------------------------
-module(crazy_click).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").
-include("crazy_click.hrl").
-include("drop.hrl").
-include("task.hrl").

%% 协议接口
-export([
    get_crazy_click_info/1,
    att_mon/1,
    get_notice_state/1
]).

%% API
-export([
    refresh_mon/0,
    update_att_cd/1,
    pack_mon/1,
    get_max_att_times/1,
    check_click_state/1
]).

-define(MON_ID_LIST, [101, 102, 103, 104, 105, 106]).  %%怪物id列表
-define(MON_HP, 30).   %%怪物血量
-define(INIT_TIMES, 20).  %%初始上限
-define(CD_TIME, 3600).
-define(CD_ADD_TIMES, 30).  %%每次CD增加的攻击次数
-define(MUL_PRO, [{2, 20}, {5, 5}, {1, 75}]).  %%暴击概率

get_crazy_click_info(Player) ->
    update_att_cd(Player),
    MonInfo = pack_mon(Player),
    {ok, Bin} = pt_390:write(39000, {MonInfo}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.
pack_mon(Player) ->
    ClickSt = lib_dict:get(?PROC_STATUS_CRAZY_CLICK),
    #st_click{
        att_times = AttTimes,
        cd_time = CdTime,
        mon_hp = MonHp,
        mon_id = MonId
    } = ClickSt,
    MaxAttTimes = get_max_att_times(Player),
    LeaveCdTimes =
        case AttTimes >= MaxAttTimes of
            true -> 0;
            false ->
                Now = util:unixtime(),
                max(0, CdTime + ?CD_TIME - Now)

        end,
    [MonId, MonHp, ?MON_HP, AttTimes, MaxAttTimes, LeaveCdTimes].

att_mon(Player) ->
    update_att_cd(Player),
    case check_att_mon(Player) of
        {false, Res} ->
            {false, Res};
        ok ->
            ClickSt = lib_dict:get(?PROC_STATUS_CRAZY_CLICK),
            #st_click{
                att_times = AttTimes,
                mon_hp = MonHp
            } = ClickSt,
            %%暴击倍数
            Mul = util:list_rand_ratio(?MUL_PRO),
            %%vip双倍
            VipMul =
                case data_vip_args:get(48, Player#player.vip_lv) of
                    [] -> 1;
                    VipMul0 -> VipMul0
                end,
            SumMul = Mul * VipMul,
            Hurt = SumMul * 1,
            NewMonHp = max(0, MonHp - Hurt),
            NewAttTimes = AttTimes - 1,
            NewClickSt = ClickSt#st_click{
                att_times = NewAttTimes,
                mon_hp = NewMonHp
            },
            lib_dict:put(?PROC_STATUS_CRAZY_CLICK, NewClickSt),
            task_event:event(?TASK_ACT_CLICK, {1}),
            %%掉落
            BaseClick = data_crazy_click:get(Player#player.lv),
            #base_click{
                coin = Coin,
                exp = Exp,
                drop_id = DropId
            } = BaseClick,
            SumCoin = Coin * SumMul,
            SumExp = Exp * SumMul,
            NewPlayer = money:add_coin(Player, SumCoin, 127, 0, 0),
            NewPlayer1 = player_util:add_exp(NewPlayer, SumExp, 11),
            MonState = ?IF_ELSE(NewMonHp =< 0, 1, 0),
            case NewMonHp =< 0 of
                true -> %%怪物死亡
                    %%怪物掉落
                    DropInfo = #drop_info{lvdown = Player#player.lv, lvup = Player#player.lv, career = Player#player.career, order = 1, rank = 1, perc = 100},
                    GoodsList = drop:get_goods_from_drop_rule(DropId, DropInfo),
                    {ok, NewPlayer2} = goods:give_goods(NewPlayer1, goods:make_give_goods_list(127, GoodsList)),
                    %%刷新怪物
                    refresh_mon();
                false ->
                    GoodsList = [],
                    NewPlayer2 = NewPlayer1
            end,
            NewMon = pack_mon(Player),
            PackGoodsList = goods:pack_goods(GoodsList),
            {ok, NewPlayer2, Hurt, Mul, SumCoin, SumExp, MonState, PackGoodsList, NewMon}
    end.
check_att_mon(Player) ->
    ClickSt = lib_dict:get(?PROC_STATUS_CRAZY_CLICK),
    #st_click{
        att_times = AttTimes,
        mon_hp = MonHp
    } = ClickSt,
    BaseClick = data_crazy_click:get(Player#player.lv),
    if
        AttTimes =< 0 -> {false, 2};
        MonHp =< 0 -> {false, 3};
        BaseClick == [] -> {false, 0};
        true ->
            ok
    end.

%%更新怪物
refresh_mon() ->
    ClickSt = lib_dict:get(?PROC_STATUS_CRAZY_CLICK),
    #st_click{
        mon_id = MonId
    } = ClickSt,
    MonList = lists:delete(MonId, ?MON_ID_LIST),
    NewMonId = util:list_rand(MonList),
    NewClickSt = ClickSt#st_click{
        mon_id = NewMonId,
        mon_hp = ?MON_HP
    },
    lib_dict:put(?PROC_STATUS_CRAZY_CLICK, NewClickSt),
    crazy_click_load:dbup_crazy_click(NewClickSt),
    ok.

%%更新攻击cd
update_att_cd(Player) ->
    ClickSt = lib_dict:get(?PROC_STATUS_CRAZY_CLICK),
    #st_click{
        att_times = AttTimes,
        cd_time = CdTime
    } = ClickSt,
    Now = util:unixtime(),
    PassTime = max(0, Now - CdTime),
    CDTimes = PassTime div ?CD_TIME,
    AddAttTimes = CDTimes * ?CD_ADD_TIMES,
    MaxAttTimes = get_max_att_times(Player),
    NewAttTimes = min(MaxAttTimes, AttTimes + AddAttTimes),
    NewCdTime =
        case NewAttTimes >= MaxAttTimes of
            true -> Now;
            false -> CdTime + CDTimes * ?CD_TIME
        end,
    NewClickSt = ClickSt#st_click{
        att_times = NewAttTimes,
        cd_time = NewCdTime
    },
    lib_dict:put(?PROC_STATUS_CRAZY_CLICK, NewClickSt),
    ok.

get_max_att_times(Player) ->
    data_vip_args:get(28, Player#player.vip_lv).

get_notice_state(_Player) ->
    ClickSt = lib_dict:get(?PROC_STATUS_CRAZY_CLICK),
    #st_click{
        att_times = AttTimes
    } = ClickSt,
    ?IF_ELSE(AttTimes > 0, {1, []}, {0, []}).

check_click_state(Player) ->
    update_att_cd(Player),
    ClickSt = lib_dict:get(?PROC_STATUS_CRAZY_CLICK),
    #st_click{
        att_times = AttTimes
    } = ClickSt,
    ?IF_ELSE(AttTimes >= 40, 1, 0).
