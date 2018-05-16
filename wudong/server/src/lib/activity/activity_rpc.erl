%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 一月 2016 下午9:05
%%%-------------------------------------------------------------------
-module(activity_rpc).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    handle/3
]).

handle(43000, _Player, _) ->
    ok;

handle(43001, Player, _) ->
    first_charge:get_fir_charge_info(Player),
    ok;

handle(43002, Player, {Days}) ->
    case first_charge:get_gift(Player, Days) of
        {false, Res} ->
            {ok, Bin} = pt_430:write(43002, {Res, Days}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_430:write(43002, {1, Days}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43011, Player, _) ->
    Pid = activity_proc:get_act_pid(),
    Pid ! {get_act_rank, Player#player.sid, Player#player.key},
    ok;

handle(43012, Player, {Type, GiftId}) ->
    case act_rank:buy_act_gift(Player, Type, GiftId) of
        {false, Res} ->
            {ok, Bin} = pt_430:write(43012, {Res, GiftId, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, LimitNum} ->
            {ok, Bin} = pt_430:write(43012, {1, GiftId, LimitNum}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43013, Player, {Type}) ->
    Pid = activity_proc:get_act_pid(),
    Pid ! {get_act_rank_player_info, Type, Player#player.sid, Player#player.key},
    ok;

handle(43014, Player, _) ->
    act_rank:get_act_rank_lim_buy(Player),
    ok;

handle(43015, Player, _) ->
    Pid = activity_proc:get_act_pid(),
    Pid ! {get_hof, Player#player.sid, Player#player.key},
    ok;

handle(43021, Player, _) ->
    daily_charge:get_daily_charge_info(Player),
    ok;

handle(43022, Player, _) ->
    case daily_charge:get_gift(Player) of
        {false, Res} ->
            {ok, Bin} = pt_430:write(43022, {Res, 0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, GoodsId, GoodsNum} ->
            {ok, Bin} = pt_430:write(43022, {1, GoodsId, GoodsNum}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43023, Player, _) ->
    case daily_charge:exchange(Player) of
        {false, Res} ->
            {ok, Bin} = pt_430:write(43023, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_430:write(43023, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 获取累充信息
handle(43031, Player, _) ->
    acc_charge:get_acc_charge_info(Player),
    ok;

%% 领取累充礼包
handle(43032, Player, {Id}) ->
    case acc_charge:get_gift(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_430:write(43032, {Res, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_430:write(43032, {1, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43041, Player, _) ->
    acc_consume:get_acc_consume_info(Player),
    ok;

handle(43042, Player, {Id}) ->
    case acc_consume:get_gift(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_430:write(43042, {Res, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_430:write(43042, {1, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43051, Player, _) ->
    one_charge:get_one_charge_info(Player),
    ok;

handle(43052, Player, {Id}) ->
    case one_charge:get_gift(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_430:write(43052, {Res, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_430:write(43052, {1, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43060, Player, {CardId}) ->
    case card_gift:get_card_gift(Player, CardId) of
        {false, Res} ->
            {ok, Bin} = pt_430:write(43060, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_430:write(43060, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43061, Player, {CardId}) ->
    case card_custom:get_card_gift(Player, CardId) of
        {false, Res} ->
            {ok, Bin} = pt_430:write(43061, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_430:write(43061, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43071, Player, _) ->
    act_rank_goal:get_act_rank_goal_info(Player),
    ok;

handle(43072, Player, {Id}) ->
    case act_rank_goal:get_gift(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_430:write(43072, {Res, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_430:write(43072, {1, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43081, Player, _) ->
    new_daily_charge:get_new_daily_charge_info(Player),
    ok;

handle(43082, Player, _) ->
    case new_daily_charge:get_gift(Player) of
        {false, Res} ->
            {ok, Bin} = pt_430:write(43082, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_430:write(43082, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43090, _Player, {_TypeList}) ->
    ok;

handle(43091, Player, _) ->
    new_one_charge:get_new_one_charge_info(Player),
    ok;

handle(43092, Player, _) ->
    case new_one_charge:get_gift(Player) of
        {false, Res} ->
            {ok, Bin} = pt_430:write(43092, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_430:write(43092, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%藏宝阁
handle(43094, Player, _) ->
    {IsRecv, LoginReward, ActOpenDay, RemainRefreshTime, ShowDay, BuyList} = treasure_hourse:get_act_info(Player),
    {ok, Bin} = pt_430:write(43094, {IsRecv, ActOpenDay, RemainRefreshTime, ShowDay, LoginReward, BuyList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43095, Player, _) ->
    {Res, NewPlayer} = treasure_hourse:recv_login_gift(Player),
    {ok, Bin} = pt_430:write(43095, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(43096, Player, {Id}) ->
    {NewPlayer, Res} = treasure_hourse:buy_gift(Player, Id),
    {ok, Bin} = pt_430:write(43096, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(43097, Player, _) ->
    act_content:get_act_content_list(Player),
    ok;

handle(43098, Player, {Id}) ->
    act_content:get_act_content(Player, Id),
    ok;

handle(43099, Player, {Type}) ->
    case Type of
        0 -> activity:get_all_act_state(Player);
        Type when Type > 0 ->
            activity:get_notice(Player, [Type], true);
        _ -> skip
    end,
    ok;

handle(43101, Player, _) ->
    exchange:get_exchange_info(Player),
    ok;

handle(43102, Player, {ExchangeNum}) ->
    case exchange:get_gift(Player, ExchangeNum) of
        {false, Res} ->
            {ok, Bin} = pt_431:write(43102, {Res, ExchangeNum}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_431:write(43102, {1, ExchangeNum}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43111, Player, _) ->
    online_time_gift:get_online_time_gift_info(Player),
    ok;

handle(43112, Player, _) ->
    case online_time_gift:get_gift(Player) of
        {false, Res} ->
            {ok, Bin} = pt_431:write(43112, {Res, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, List} ->
            {ok, Bin} = pt_431:write(43112, {1, List}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43121, Player, _) ->
    daily_acc_charge:get_acc_charge_info(Player),
    ok;

handle(43122, Player, {Id}) ->
    case daily_acc_charge:get_gift(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_431:write(43122, {Res, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_431:write(43122, {1, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43131, Player, _) ->
    acc_charge_turntable:get_acc_charge_turntable_info(Player),
    ok;

handle(43132, Player, {Times}) ->
    case acc_charge_turntable:get_gift(Player, Times) of
        {false, Res} ->
            {ok, Bin} = pt_431:write(43132, {Res, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, GetGoodsList} ->
            {ok, Bin} = pt_431:write(43132, {1, GetGoodsList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43141, Player, _) ->
    acc_charge_gift:get_acc_charge_info(Player),
    ok;

handle(43142, Player, {Times}) ->
    case acc_charge_gift:get_gift(Player, Times) of
        {false, Res} ->
            {ok, Bin} = pt_431:write(43142, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_431:write(43142, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43151, Player, _) ->
    goods_exchange:get_goods_exchange_info(Player),
    ok;

handle(43152, Player, {Id}) ->
    case goods_exchange:exchange_goods(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_431:write(43152, {Res, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_431:write(43152, {1, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43161, Player, _) ->
    role_d_acc_charge:get_role_d_acc_charge_info(Player),
    ok;

handle(43162, Player, {Id}) ->
    case role_d_acc_charge:get_gift(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_431:write(43162, {Res, 0, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, CurItem} ->
            {ok, Bin} = pt_431:write(43162, {1, CurItem, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43171, Player, _) ->
    con_charge:get_con_charge_info(Player),
    ok;

handle(43172, Player, {Day}) ->
    case con_charge:get_gift(Player, Day) of
        {false, Res} ->
            {ok, Bin} = pt_431:write(43172, {Res, Day}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_431:write(43172, {1, Day}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43181, Player, _) ->
    open_egg:get_open_egg_info(Player),
    ok;

handle(43182, Player, {PosId}) ->
    case open_egg:open_egg(Player, PosId) of
        {false, Res} ->
            {ok, Bin} = pt_431:write(43182, {Res, PosId, 0, 0, 0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, GoodsId, Num, Lv, Mul} ->
            {ok, Bin} = pt_431:write(43182, {1, PosId, GoodsId, Num, Lv, Mul}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43183, Player, _) ->
    case open_egg:refresh(Player) of
        {false, Res} ->
            {ok, Bin} = pt_431:write(43183, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        ok ->
            {ok, Bin} = pt_431:write(43183, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%% 获取GM奖励信息
handle(43187, Player, _) ->
    {AccCharge, Award} = feedback:get_state(),
    {ok, Bin} = pt_431:write(43187, {AccCharge, Award}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 领取GM反馈奖励
%% 暂时不需要领取，直接进背包
handle(43188, Player, _) ->
    case feedback:draw_award(Player) of
        {false, Res} ->
            {ok, Bin} = pt_431:write(43188, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_431:write(43188, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% GM反馈成功
handle(43189, Player, _) ->
    case feedback:feedback_succeed(Player) of
        false ->
            {ok, Bin} = pt_431:write(43189, {0}),
            server_send:send_to_sid(Player#player.sid, Bin);
        {ok, NewPlayer} ->
            {ok, Bin} = pt_431:write(43189, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 获取零元礼包信息
handle(43190, Player, _) ->
    Data = free_gift:get_info(Player),
    LeaveTime = free_gift:get_leave_time(),
    {ok, Bin} = pt_431:write(43190, {LeaveTime, Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 购买零元礼包信息
handle(43191, Player, {Type}) ->
    {Res, NewPlayer} = free_gift:get_gift(Player, Type),
    {ok, Bin} = pt_431:write(43191, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 获取招财猫信息
handle(43192, Player, {}) ->
    Data = act_new_wealth_cat:get_info(Player),
    {ok, Bin} = pt_431:write(43192, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 招财猫抽奖
handle(43193, Player, {}) ->
    case act_new_wealth_cat:draw(Player) of
        {false, Res} ->
            {ok, Bin} = pt_431:write(43193, {Res, 1, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, Id, BGold, NewPlayer} ->
            {ok, Bin} = pt_431:write(43193, {1, Id, BGold}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 获取疯狂砸蛋信息
handle(43194, Player, {}) ->
    Data = act_throw_egg:get_info(Player),
    {ok, Bin} = pt_431:write(43194, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 疯狂砸蛋刷新
handle(43195, Player, {}) ->
    {Res, NewPlayer} = act_throw_egg:reset_info(Player),
    {ok, Bin} = pt_431:write(43195, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 疯狂砸蛋砸蛋
handle(43196, Player, {Id}) ->
    {Res, NewPlayer, EggInfo} = act_throw_egg:draw_reward(Player, Id),
    {ok, Bin} = pt_431:write(43196, {Res, EggInfo}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 疯狂砸蛋-领取次数奖励
handle(43197, Player, {Id}) ->
    {Res, NewPlayer} = act_throw_egg:count_reward(Player, Id),
    {ok, Bin} = pt_431:write(43197, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(43199, Player, _) ->
    ad:get_ad_list(Player),
    ok;

handle(43201, Player, _) ->
    merge_sign_in:get_info(Player),
    ok;

handle(43202, Player, {Type, Day}) ->
    case merge_sign_in:get_gift(Player, Type, Day) of
        {false, Res} ->
            {ok, Bin} = pt_432:write(43202, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_432:write(43202, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43211, Player, _) ->
    charge_mul:get_info(Player),
    ok;

handle(43221, Player, _) ->
    guild_rank:get_info(Player),
    ok;

handle(43231, Player, _) ->
    target_act:get_info(Player),
    ok;

handle(43232, Player, {Type}) ->
    case target_act:get_gift(Player, Type) of
        {false, Res} ->
            {ok, Bin} = pt_432:write(43232, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_432:write(43232, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43241, Player, _) ->
    merge_exp_double:get_info(Player),
    ok;

%% 屏蔽大富翁协议
%% handle(43251, Player, _) ->
%%     monopoly:get_monopoly_info(Player),
%%     ok;
%%
%% handle(43252, Player, {AutoBuy}) ->
%%     case monopoly:player_dice(Player, AutoBuy) of
%%         {false, Res} ->
%%             {ok, Bin} = pt_432:write(43252, {Res, 0, 0, 0, 0, "", 0}),
%%             server_send:send_to_sid(Player#player.sid, Bin),
%%             ok;
%%         {ok, NewPlayer, Point, IsNewRound, CurDice, Type, Msg, CostGold} ->
%%             {ok, Bin} = pt_432:write(43252, {1, Point, IsNewRound, CurDice, Type, Msg, CostGold}),
%%             server_send:send_to_sid(Player#player.sid, Bin),
%%             {ok, NewPlayer}
%%     end;
%%
%% handle(43253, Player, {Type}) ->
%%     case monopoly:player_morra(Player, Type) of
%%         {false, Res} ->
%%             {ok, Bin} = pt_432:write(43253, {Res, 0, 0, 0}),
%%             server_send:send_to_sid(Player#player.sid, Bin),
%%             ok;
%%         {ok, NewPlayer, Type, SysType, GetCoin} ->
%%             {ok, Bin} = pt_432:write(43253, {1, Type, SysType, GetCoin}),
%%             server_send:send_to_sid(Player#player.sid, Bin),
%%             {ok, NewPlayer}
%%     end;
%%
%% handle(43254, Player, _) ->
%%     monopoly:get_task_info(Player),
%%     ok;
%%
%% handle(43255, Player, {Id}) ->
%%     case monopoly:get_task_gift(Player, Id) of
%%         {false, Res} ->
%%             {ok, Bin} = pt_432:write(43255, {Res, 0}),
%%             server_send:send_to_sid(Player#player.sid, Bin),
%%             ok;
%%         {ok, NewPlayer, Num} ->
%%             {ok, Bin} = pt_432:write(43255, {1, Num}),
%%             server_send:send_to_sid(Player#player.sid, Bin),
%%             {ok, NewPlayer}
%%     end;
%%
%% handle(43256, Player, {Round}) ->
%%     case monopoly:get_round_gift(Player, Round) of
%%         {false, Res} ->
%%             {ok, Bin} = pt_432:write(43256, {Res}),
%%             server_send:send_to_sid(Player#player.sid, Bin),
%%             ok;
%%         {ok, NewPlayer} ->
%%             {ok, Bin} = pt_432:write(43256, {1}),
%%             server_send:send_to_sid(Player#player.sid, Bin),
%%             {ok, NewPlayer}
%%     end;

handle(43261, Player, _) ->
    vip_gift:get_info(Player),
    ok;

handle(43262, Player, {VipLv}) ->
    case vip_gift:buy_gift(Player, VipLv) of
        {false, Res} ->
            {ok, Bin} = pt_432:write(43262, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_432:write(43262, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(43265, Player, _) ->
    {LTime, ChargeGold, ProList} = hqg_daily_charge:get_act_info(Player),
    {ok, Bin} = pt_432:write(43265, {LTime, ChargeGold, ProList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43266, Player, {ChargeGold}) ->
    {Res, NewPlayer} = hqg_daily_charge:recv(Player, ChargeGold),
    {ok, Bin} = pt_432:write(43266, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 多倍经验活动通知
handle(43267, Player, _) ->
    {State, LastTime, _Exp, _Reward} = more_exp:get_more_exp_info(),
    {ok, Bin} = pt_432:write(43267, {State, LastTime}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 多倍经验活动信息
handle(43268, Player, _) ->
    {State, LastTime, Exp, Reward} = more_exp:get_more_exp_info(),
    {ok, Bin} = pt_432:write(43268, {State, LastTime, Exp, Reward}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 抽奖转盘活动信息
handle(43270, Player, _) ->
    {LeaveTime, Score, Count, Location, RefreshCost, OneCost, TenCost, MyTurnsList, ExchangeList, TurntableList} = act_draw_turntable:get_goods_exchange_info(Player),
    {ok, Bin} = pt_432:write(43270, {LeaveTime, Score, Count, Location, RefreshCost, OneCost, TenCost, MyTurnsList, ExchangeList, TurntableList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 抽奖转盘抽奖
handle(43271, Player, {Type}) ->
    case act_draw_turntable:draw_lottery(Player, Type) of
        {false, Res} ->
            {ok, Bin} = pt_432:write(43271, {Res, 0, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, Id, GoodsList} ->
            {ok, Bin} = pt_432:write(43271, {1, Id, GoodsList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 抽奖转盘活动兑换
handle(43272, Player, {Id, Num}) ->
    case act_draw_turntable:exchange_goods(Player, Id, Num) of
        {false, Res, Score} ->
            {ok, Bin} = pt_432:write(43272, {Res, Score}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, Score} ->
            {ok, Bin} = pt_432:write(43272, {1, Score}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;


%% 抽奖转盘活动刷新
handle(43273, Player, _) ->
    case act_draw_turntable:refresh(Player) of
        {false, Res} ->
            {ok, Bin} = pt_432:write(43273, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_432:write(43273, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%获取集字活动信息
handle(43274, Player, _) ->
    collect_exchange:get_collect_exchange_info(Player),
    ok;

%%集字活动兑换
handle(43275, Player, {Id}) ->
    case collect_exchange:exchange_goods(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_432:write(43275, {Res, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_432:write(43275, {1, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%获取原石鉴定活动信息
handle(43276, Player, _) ->
    stone_ident:get_stone_ident_info(Player),
    ok;

%%原石鉴定
handle(43277, Player, {Id}) ->
    case stone_ident:stone_ident(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_432:write(43277, {Res, Id, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, GoodsId, GoodsNum} ->
            {ok, Bin} = pt_432:write(43277, {1, Id, [[GoodsId, GoodsNum]]}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;


%%百倍返利信息
handle(43280, Player, {}) ->
    Data = hundred_return:get_hundred_return_info(),
    {ok, Bin} = pt_432:write(43280, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%购买百倍返利
handle(43281, Player, {}) ->
    case hundred_return:bug_hundred_return(Player) of
        {false, Res} ->
            {ok, Bin} = pt_432:write(43281, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_432:write(43281, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%获取消费排行榜信息
handle(43283, Player, {}) ->
    ConsumeGold = consume_rank:get_consume(),
    Pid = activity_proc:get_act_pid(),
    Pid ! {get_consume_rank_info, Player#player.pid, ConsumeGold},
    ok;

%%获取充值排行榜信息
handle(43284, Player, {}) ->
    RechargeGold = recharge_rank:get_recharge(),
    Pid = activity_proc:get_act_pid(),
    Pid ! {get_recharge_rank_info, Player#player.pid, RechargeGold},
    ok;

%%查询跨服消费榜数据
handle(43285, Player, {}) ->
    cross_all:apply(cross_consume_rank, check_info, [node(), config:get_server_num(), Player#player.key, Player#player.sid]),
    ok;

%%查询跨服充值榜数据
handle(43286, Player, {}) ->
    cross_all:apply(cross_recharge_rank, check_info, [node(), config:get_server_num(), Player#player.key, Player#player.sid]),
    ok;

%%获取消费、充值排行榜状态
handle(43287, Player, {}) ->
    State = {
        util:diff_day(config:get_open_days()) + 1,
        consume_rank:get_state(Player),
        recharge_rank:get_state(Player),
        cross_consume_rank:get_state(),
        cross_recharge_rank:get_state(),
        area_consume_rank:get_state(),
        area_recharge_rank:get_state()
    },
    {ok, Bin} = pt_432:write(43287, State),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取连充信息
handle(43288, Player, _) ->
    act_con_charge:get_acc_charge_info(Player),
    ok;

%% 领取累充奖励
handle(43289, Player, {Id}) ->
    case act_con_charge:get_cum_award(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_432:write(43289, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_432:write(43289, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;


%% 领取每日奖励
handle(43290, Player, {Id}) ->
    case act_con_charge:get_daily_award(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_432:write(43290, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_432:write(43290, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 获取金银塔信息
handle(43291, Player, {}) ->
    Data = gold_silver_tower:get_info(),
    {ok, Bin} = pt_432:write(43291, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取金银塔抽奖
handle(43292, Player, {Type}) ->
    case gold_silver_tower:lucky_draw(Player, Type) of
        {false, Res} ->
            {ok, Bin} = pt_432:write(43292, {Res, 1, 1, 1, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, Floor, NewFloor, LuckId, GoodsList} ->
            {ok, Bin} = pt_432:write(43292, {1, Floor, NewFloor, LuckId, GoodsList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 获取天宫寻宝信息
handle(43293, Player, {}) ->
    Data = act_welkin_hunt:get_info(Player),
    {ok, Bin} = pt_432:write(43293, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 天宫寻宝抽奖
handle(43294, Player, {Type, IsAuto}) ->
    {Res, NewPlayer, List} = act_welkin_hunt:draw(Player, Type, IsAuto),
    {ok, Bin} = pt_432:write(43294, {Res, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 天宫寻宝积分兑换
handle(43295, Player, {Type}) ->
    {Res, NewPlayer} = act_welkin_hunt:exchange(Player, Type),
    {ok, Bin} = pt_432:write(43295, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取天宫商城信息
handle(43296, Player, {}) ->
    ExchangeList = act_welkin_hunt:get_exchange_info(),
    {ok, Bin} = pt_432:write(43296, {ExchangeList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 天宫物品购买
handle(43297, Player, {Num}) ->
    {Res, NewPlayer} = act_welkin_hunt:buy_goods(Player, Num),
    {ok, Bin} = pt_432:write(43297, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(43299, Player, {ActId}) ->
    merge_act:get_merge_act(Player, ActId),
    ok;

handle(43300, Player, _) ->
    OpenDay = config:get_open_days(),
    List = get_open_list(Player),
    {ok, Bin} = pt_433:write(43300, {OpenDay, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43301, Player, _) ->
    {LeaveTime, JhList} = open_act_jh_rank:get_act_info(Player),
    {ok, Bin} = pt_433:write(43301, {LeaveTime, JhList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43302, Player, {ActType, Args}) ->
    {Res, NewPlayer} = open_act_jh_rank:recv(Player, ActType, Args),
    {ok, Bin} = pt_433:write(43302, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(43305, Player, _) ->
    {LeaveTime, UpTargetList} = open_act_up_target:get_act_info(Player),
    {ok, Bin} = pt_433:write(43305, {LeaveTime, UpTargetList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43306, Player, {ActType, Args}) ->
    {Res, NewPlayer} = open_act_up_target:recv(Player, ActType, Args),
    {ok, Bin} = pt_433:write(43306, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 首充团购
handle(43311, Player, _) ->
    {LeaveTime, ActList} = open_act_group_charge:get_act_info(Player),
    {ok, Bin} = pt_433:write(43311, {LeaveTime, ActList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43312, Player, {BaseGroupNum, BaseChargeGold}) ->
    {Res, NewPlayer} = open_act_group_charge:recv(Player, BaseGroupNum, BaseChargeGold),
    {ok, Bin} = pt_433:write(43312, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 累充奖励
handle(43315, Player, _) ->
    {LeaveTime, AccChargeGold, ActList} = open_act_acc_charge:get_act_info(Player),
    {ok, Bin} = pt_433:write(43315, {LeaveTime, AccChargeGold, ActList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43316, Player, {BaseChargeGold}) ->
    {Res, NewPlayer} = open_act_acc_charge:recv(Player, BaseChargeGold),
    {ok, Bin} = pt_433:write(43316, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 全服动员3
handle(43317, Player, _) ->
    {LeaveTime, Lv, ActList} = open_act_all_target3:get_act_info(Player),
    {ok, Bin} = pt_433:write(43317, {LeaveTime, Lv, ActList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43318, Player, {ActType, BaseLv, BaseNum}) ->
    {Res, NewPlayer} = open_act_all_target3:recv(Player, ActType, BaseLv, BaseNum),
    {ok, Bin} = pt_433:write(43318, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 全服动员2
handle(43319, Player, _) ->
    {LeaveTime, Lv, ActList} = open_act_all_target2:get_act_info(Player),
    {ok, Bin} = pt_433:write(43319, {LeaveTime, Lv, ActList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43320, Player, {ActType, BaseLv, BaseNum}) ->
    {Res, NewPlayer} = open_act_all_target2:recv(Player, ActType, BaseLv, BaseNum),
    {ok, Bin} = pt_433:write(43320, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 全服动员
handle(43321, Player, _) ->
    {LeaveTime, Lv, ActList} = open_act_all_target:get_act_info(Player),
    {ok, Bin} = pt_433:write(43321, {LeaveTime, Lv, ActList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43322, Player, {ActType, BaseLv, BaseNum}) ->
    {Res, NewPlayer} = open_act_all_target:recv(Player, ActType, BaseLv, BaseNum),
    {ok, Bin} = pt_433:write(43322, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(43325, Player, _) ->
    {LeaveTime, RecvState, ActCost, ActList} = act_invest:get_act_info(Player),
    {ok, Bin} = pt_433:write(43325, {LeaveTime, RecvState, ActCost, ActList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%购买投资计划基金
handle(43326, Player, _) ->
    {Res, NewPlayer} = act_invest:invest(Player),
    {ok, Bin} = pt_433:write(43326, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(43327, Player, {Day}) ->
    {Res, NewPlayer} = act_invest:recv(Player, Day),
    {ok, Bin} = pt_433:write(43327, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 地宫寻宝
handle(43330, Player, _) ->
    {LTime, Step, CostGold, FreeNum, SysPassNum, NeedNum, IdList} = act_map:get_act_info(Player),
    {ok, Bin} = pt_433:write(43330, {LTime, Step, CostGold, FreeNum, SysPassNum, NeedNum, IdList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 寻宝
handle(43331, Player, _) ->
    {NewPlayer, Res, RandStep, RewardList} = act_map:go_map(Player),
    {ok, Bin} = pt_433:write(43331, {Res, RandStep, RewardList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取配置奖励
handle(43332, Player, _) ->
    {BaseList1, BaseList2} = act_map:get_base_reward(),
    {ok, Bin} = pt_433:write(43332, {BaseList1, BaseList2}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取日志记录
handle(43333, Player, _) ->
    {BaseList1, BaseList2} = act_map:get_record(Player),
    {ok, Bin} = pt_433:write(43333, {BaseList1, BaseList2}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取进阶宝箱面板信息
handle(43335, Player, _) ->
    {RemainResetTime, RemainTime, RemainFreeNum, ResetCostGold, OpenCostGold, List1, List2} = uplv_box:get_act_info(Player),
    {ok, Bin} = pt_433:write(43335, {RemainResetTime, RemainTime, RemainFreeNum, ResetCostGold, OpenCostGold, List1, List2}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 重置进阶宝箱
handle(43336, Player, _) ->
    {Res, NewPlayer} = uplv_box:reset_box(Player),
    {ok, Bin} = pt_433:write(43336, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 开启进阶宝箱
handle(43337, Player, {OrderId}) ->
    {Res, NewPlayer} = uplv_box:recv(Player, OrderId),
    {ok, Bin} = pt_433:write(43337, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取个人记录
handle(43338, Player, _) ->
    LogList = uplv_box:get_log(Player),
    {ok, Bin} = pt_433:write(43338, {LogList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 活动开服活动全民冲榜
handle(43341, Player, _) ->
    {LeaveTime, RankType, NickName, Creer, Sex, Avatar, Stage, List1, List2} = open_act_all_rank:get_act_info(Player),
    {ok, Bin} = pt_433:write(43341, {LeaveTime, RankType, NickName, Creer, Sex, Avatar, Stage, List1, List2}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 开服活动全民冲榜领取奖励
handle(43342, Player, {BaseLv}) ->
    {NewPlayer, Code} = open_act_all_rank:recv(Player, BaseLv),
    {ok, Bin} = pt_433:write(43342, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 活动开服活动全民冲榜2
handle(43343, Player, _) ->
    {LeaveTime, RankType, NickName, Creer, Sex, Avatar, Stage, List1, List2} = open_act_all_rank2:get_act_info(Player),
    {ok, Bin} = pt_433:write(43343, {LeaveTime, RankType, NickName, Creer, Sex, Avatar, Stage, List1, List2}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 开服活动全民冲榜2领取奖励
handle(43344, Player, {BaseLv}) ->
    {NewPlayer, Code} = open_act_all_rank2:recv(Player, BaseLv),
    {ok, Bin} = pt_433:write(43344, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 活动开服活动全民冲榜3
handle(43345, Player, _) ->
    {LeaveTime, RankType, NickName, Creer, Sex, Avatar, Stage, List1, List2} = open_act_all_rank3:get_act_info(Player),
    {ok, Bin} = pt_433:write(43345, {LeaveTime, RankType, NickName, Creer, Sex, Avatar, Stage, List1, List2}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 开服活动全民冲榜3领取奖励
handle(43346, Player, {BaseLv}) ->
    {NewPlayer, Code} = open_act_all_rank3:recv(Player, BaseLv),
    {ok, Bin} = pt_433:write(43346, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 开服活动帮派争霸
handle(43351, Player, _) ->
    {LeaveTime, List} = open_act_guild_rank:get_act_info(),
    {ok, Bin} = pt_433:write(43351, {LeaveTime, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 开服活动进阶目标二
handle(43355, Player, _) ->
    {LeaveTime, UpTargetList} = open_act_up_target2:get_act_info(Player),
    {ok, Bin} = pt_433:write(43355, {LeaveTime, UpTargetList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43356, Player, {ActType, Args}) ->
    {Res, NewPlayer} = open_act_up_target2:recv(Player, ActType, Args),
    {ok, Bin} = pt_433:write(43356, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 开服活动进阶目标三
handle(43357, Player, _) ->
    {LeaveTime, UpTargetList} = open_act_up_target3:get_act_info(Player),
    {ok, Bin} = pt_433:write(43357, {LeaveTime, UpTargetList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43358, Player, {ActType, Args}) ->
    {Res, NewPlayer} = open_act_up_target3:recv(Player, ActType, Args),
    {ok, Bin} = pt_433:write(43358, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%获取限时抢购信息
handle(43361, Player, _) ->
    {ActLeaveTime, LeaveTime, OpenTime, TotalBuyNum, List1, List2} = limit_buy:get_act_info(Player),
    {ok, Bin} = pt_433:write(43361, {ActLeaveTime, LeaveTime, OpenTime, TotalBuyNum, List1, List2}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%抢购商品
handle(43362, Player, {ShopId}) ->
    {Code, NewPlayer} = limit_buy:buy(Player, ShopId),
    {ok, Bin} = pt_433:write(43362, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%领取抢购次数奖励
handle(43363, Player, {Num}) ->
    {Code, NewPlayer} = limit_buy:recv(Player, Num),
    {ok, Bin} = pt_433:write(43363, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%读取系统日志
handle(43364, Player, _) ->
    LogList = limit_buy:get_log(),
    {ok, Bin} = pt_433:write(43364, {LogList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取符文寻宝信息
handle(43365, Player, _) ->
    {RemainTime, OneCost, TenCost, Discount, List} = fuwen_map:get_act_info(Player),
    {ok, Bin} = pt_433:write(43365, {RemainTime, OneCost, TenCost, Discount, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%符文寻宝
handle(43366, Player, {GoNum}) ->
    {Code, ChipsNum, NewPlayer, List} = fuwen_map:go_map(Player, GoNum),
    {ok, Bin} = pt_433:write(43366, {Code, ChipsNum, List}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    activity:get_notice(Player, [38], true),
    {ok, NewPlayer};

%%获取剑道寻宝信息
handle(43383, Player, _) ->
    {RemainTime, OneCost, TenCost, Discount, List} = jiandao_map:get_act_info(Player),
    {ok, Bin} = pt_433:write(43383, {RemainTime, OneCost, TenCost, Discount, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%剑道寻宝
handle(43384, Player, {GoNum}) ->
    {Code, ChipsNum, NewPlayer, List} = jiandao_map:go_map(Player, GoNum),
    {ok, Bin} = pt_433:write(43384, {Code, ChipsNum, List}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    activity:get_notice(Player, [193], true),
    {ok, NewPlayer};

%% 登陆有礼获取信息
handle(43367, Player, _) ->
    {LTime, OnlineHour, ChargeGold, LoginGift, LoginRecvStatus, OnlineTime, OnlineGift, OnlineRecvStatus} = login_online:get_act_info(Player),
    {ok, Bin} = pt_433:write(43367, {LTime, OnlineHour, ChargeGold, util:list_tuple_to_list(LoginGift), LoginRecvStatus, OnlineTime, util:list_tuple_to_list(OnlineGift), OnlineRecvStatus}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%登陆有礼领取
handle(43368, Player, {Type}) ->
    {Code, NewPlayer} = login_online:recv(Player, Type),
    {ok, Bin} = pt_433:write(43368, {Code}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    {ok, NewPlayer};

%%获取新兑换活动信息
handle(43370, Player, _) ->
    {OpenTime, EndTime, ExchangeList} = new_exchange:get_act_info(Player),
    {ok, Bin} = pt_433:write(43370, {OpenTime, EndTime, ExchangeList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%兑换
handle(43371, Player, {Id}) ->
    {Code, NewPlayer} = new_exchange:exchange(Player, Id),
    {ok, Bin} = pt_433:write(43371, {Code}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    {ok, NewPlayer};

%%特权炫装，获取面板信息
handle(43372, Player, _) ->
    {LeaveTime, List} = act_equip_sell:get_act_info(Player),
    {ok, Bin} = pt_433:write(43372, {LeaveTime, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%特权炫装，购买
handle(43373, Player, {Id}) ->
    {Code, NewPlayer} = act_equip_sell:buy(Player, Id),
    {ok, Bin} = pt_433:write(43373, {Code}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    {ok, NewPlayer};

%% 护送活动面板信息
handle(43374, Player, _) ->
    {LeaveTime, ConvoyNum, BaseConvoyNum, IsRecv, RewardList} = act_convoy:get_act_info(),
    {ok, Bin} = pt_433:write(43374, {LeaveTime, ConvoyNum, BaseConvoyNum, IsRecv, RewardList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 护送活动领取
handle(43375, Player, _) ->
    {Code, NewPlayer} = act_convoy:recv(Player),
    {ok, Bin} = pt_433:write(43375, {Code}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    {ok, NewPlayer};

%% 获取大额累充信息
handle(43376, Player, _) ->
    acc_charge_d:get_acc_charge_info(Player),
    ok;

%% 领取大额累充礼包
handle(43377, Player, {Id}) ->
    case acc_charge_d:get_gift(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_433:write(43377, {Res, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_433:write(43377, {1, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 消费抽返利活动 面板信息
handle(43378, Player, _) ->
    {LeaveTime, NeedConsumeTime, Num, List1, List2, List3} = consume_back_charge:get_act_info(Player),
    {ok, Bin} = pt_433:write(43378, {LeaveTime, NeedConsumeTime, Num, List1, List2, List3}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 查看今日已获得奖励
handle(43379, _Player, _) ->
    ok;

%% 查看今日奖励
handle(43380, Player, _) ->
    {BackGold, List} = consume_back_charge:get_today_log_list(Player),
    {ok, Bin} = pt_433:write(43380, {BackGold, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取中奖名单
handle(43381, Player, _) ->
    consume_back_charge:get_reward_player_list(Player),
    ok;

%% 抽奖
handle(43382, Player, _) ->
    {Code, ChargeGold, Percent, NewPlayer} = consume_back_charge:draw(Player),
    {ok, Bin} = pt_433:write(43382, {Code, ChargeGold, Percent}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取仙境迷宫面板信息
handle(43385, Player, _) ->
    {LeaveTime, LeaveTime2, Step, RemainFreeNum, OneGoCast, OneGoConsume, RemainResetNum, OneResetCast, List, List2} = xj_map:get_act_info(Player),
    {ok, Bin} = pt_433:write(43385, {LeaveTime, LeaveTime2, Step, RemainFreeNum, OneGoCast, OneGoConsume, RemainResetNum, OneResetCast, List, List2}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 寻宝
handle(43386, Player, {Type}) ->
    {Code, RandStep, ResetRewardList, ProRewardList, NewPlayer} = xj_map:go_map(Player, Type),
    {ok, Bin} = pt_433:write(43386, {Code, RandStep, ProRewardList, ResetRewardList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 重置
handle(43387, Player, _) ->
    {Code, List, NewPlayer} = xj_map:reset(Player),
    {ok, Bin} = pt_433:write(43387, {Code, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 日志
handle(43388, Player, _) ->
    LogList = xj_map:get_log(Player),
    {ok, Bin} = pt_433:write(43388, {LogList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取开服活动之返利抢购面板信息
handle(43389, Player, _) ->
    {LeaTiem, List} = open_act_back_buy:get_act_info(Player),
    {ok, Bin} = pt_433:write(43389, {LeaTiem, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 抢购
handle(43390, Player, {OrderId}) ->
    {Code, NewPlayer} = open_act_back_buy:buy(Player, OrderId),
    {ok, Bin} = pt_433:write(43390, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取红装兑换信息
handle(43391, Player, {}) ->
    {CostId, Data} = red_goods_exchange:get_info(Player),
    {ok, Bin} = pt_433:write(43391, {CostId, Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 红装兑换
handle(43392, Player, {Id}) ->
    case red_goods_exchange:red_exchange(Player, Id) of
        {false, Res} ->
            {ok, Bin} = pt_433:write(43392, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_433:write(43392, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 获取碎片兑换信息
handle(43393, Player, {}) ->
    {CostId, Data} = debris_exchange:get_info(Player),
    {ok, Bin} = pt_433:write(43393, {CostId, Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 碎片兑换
handle(43394, Player, {Id, Num}) ->
    case debris_exchange:red_exchange(Player, Id, Num) of
        {false, Res} ->
            {ok, Bin} = pt_433:write(43394, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, _NewPlayer} ->
            {ok, Bin} = pt_433:write(43394, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%% 获取招财进宝
handle(43395, Player, {}) ->
    ?DEBUG("43395 ~n"),
    Data = act_buy_money:get_act_info(Player),
    {ok, Bin} = pt_433:write(43395, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 招财进宝购买
handle(43396, Player, {CostType, Type}) ->
    {Res, NewPlayer, GoosList} = act_buy_money:recv(Player, CostType, Type),
    {ok, Bin} = pt_433:write(43396, {Res, GoosList}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    {ok, NewPlayer};

%% 获取招财猫信息
handle(43397, Player, {}) ->
    Data = act_wealth_cat:get_info(Player),
    {ok, Bin} = pt_433:write(43397, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 招财猫抽奖
handle(43398, Player, {Val}) ->
    case act_wealth_cat:draw(Player, Val) of
        {false, Res} ->
            {ok, Bin} = pt_433:write(43398, {Res, 1, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, Id, BGold, NewPlayer} ->
            {ok, Bin} = pt_433:write(43398, {1, Id, BGold}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 全名hi协议数据
handle(43801, Player, {}) ->
    Data = act_hi_fan_tian:get_info(Player),
    {ok, Bin} = pt_438:write(43801, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 全名hi翻天领取奖励
handle(43802, Player, {ActId}) ->
    case act_hi_fan_tian:get_award(Player, ActId) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [142], true),
            Res = 1;
        {fail, Res} ->
            NewPlayer = Player
    end,
    {ok, Bin} = pt_438:write(43802, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 转盘
handle(43803, Player, {}) ->
    act_lucky_turn:get_info(Player),
    ok;


%% 转盘
handle(43804, Player, {Type}) ->
    case catch act_lucky_turn:lucky_turn(Player, Type) of
        {ok, NewPlayer, CellList} ->
            activity:get_notice(NewPlayer, [150], true),
            Res = 1;
        {fail, Res} ->
            CellList = [],
            NewPlayer = Player
    end,
    {ok, Bin} = pt_438:write(43804, {Res, CellList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 积分兑换
handle(43805, Player, {ExCellId, ExNum}) ->
    case catch act_lucky_turn:exchange_goods(Player, ExCellId, ExNum) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [150], true),
            Res = 1;
        {fail, Res} ->
            NewPlayer = Player
    end,
    {ok, Bin} = pt_438:write(43805, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 本服转盘
handle(43809, Player, {}) ->
    act_local_lucky_turn:get_info(Player),
    ok;


%% 本服转盘抽奖
handle(43810, Player, {Type}) ->
    case catch act_local_lucky_turn:lucky_turn(Player, Type) of
        {ok, NewPlayer, CellList} ->
            activity:get_notice(NewPlayer, [158], true),
            Res = 1;
        {fail, Res} ->
            CellList = [],
            NewPlayer = Player
    end,
    {ok, Bin} = pt_438:write(43810, {Res, CellList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 积分兑换
handle(43811, Player, {ExCellId, ExNum}) ->
    case catch act_local_lucky_turn:exchange_goods(Player, ExCellId, ExNum) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [158], true),
            Res = 1;
        {fail, Res} ->
            NewPlayer = Player
    end,
    {ok, Bin} = pt_438:write(43811, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 获取水果大战信息
handle(43820, Player, {}) ->
    Data = act_throw_fruit:get_info(Player),
%%     ?DEBUG("data ~p~n",[Data]),
    {ok, Bin} = pt_438:write(43820, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 水果大战刷新
handle(43821, Player, {}) ->
    {Res, NewPlayer} = act_throw_fruit:reset_info(Player),
    {ok, Bin} = pt_438:write(43821, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 水果大战抽奖
handle(43822, Player, {Id}) ->
    {Res, NewPlayer, FruitInfo} = act_throw_fruit:draw_reward(Player, Id),
    {ok, Bin} = pt_438:write(43822, {Res, FruitInfo}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 水果大战-领取次数奖励
handle(43823, Player, {Id}) ->
    {Res, NewPlayer} = act_throw_fruit:count_reward(Player, Id),
    {ok, Bin} = pt_438:write(43823, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 获取充值有礼信息
handle(43825, Player, {}) ->
    Data = recharge_inf:get_info(Player),
    {ok, Bin} = pt_438:write(43825, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 充值有礼领取
handle(43826, Player, {}) ->
    {Res, NewPlayer} = recharge_inf:get_reward(Player),
    {ok, Bin} = pt_438:write(43826, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取在线有礼信息
handle(43828, Player, {}) ->
    Data = online_reward:get_info(Player),
    ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_438:write(43828, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};


%% 在线有礼抽奖
handle(43829, Player, {}) ->
    case online_reward:get_reward(Player) of
        {false, Res} ->
            {ok, Bin} = pt_438:write(43829, {Res, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, Player};
        {ok, NewPlayer, Id} ->
            {ok, Bin} = pt_438:write(43829, {1, Id}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 获取每日任务信息
handle(43831, Player, {}) ->
    Data = act_daily_task:get_info(Player),
    ?DEBUG("data ~p~n", [Data]),
    {ok, Bin} = pt_438:write(43831, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};


%% 每日任务领取
handle(43832, Player, {Id}) ->
    {Res, NewPlayer} = act_daily_task:get_reward(Player, Id),
    {ok, Bin} = pt_438:write(43832, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 获取幸运翻牌信息
handle(43835, Player, {}) ->
    Data = act_flip_card:get_info(Player),
%%     ?DEBUG("data ~p~n", [Data]),
    {ok, Bin} = pt_438:write(43835, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 幸运翻牌翻牌
handle(43836, Player, {Id}) ->
    {Res, NewPlayer} = act_flip_card:flip_card(Player, Id),
    {ok, Bin} = pt_438:write(43836, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 幸运翻牌刷新
handle(43837, Player, {}) ->
    {Res, NewPlayer} = act_flip_card:re_set(Player),
    {ok, Bin} = pt_438:write(43837, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取额外特惠信息
handle(43838, Player, {}) ->
    Data = open_act_other_charge:get_act_info(Player),
    ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_438:write(43838, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 额外特惠领取
handle(43839, Player, {Id}) ->
    {Res, NewPlayer} = open_act_other_charge:recv(Player, Id),
    ?DEBUG("Res ~p~n", [Res]),
    {ok, Bin} = pt_438:write(43839, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 获取超值特惠信息
handle(43840, Player, {}) ->
    Data = open_act_super_charge:get_act_info(Player),
    ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_438:write(43840, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%% 超值特惠领取
handle(43841, Player, {Id}) ->
    {Res, NewPlayer} = open_act_super_charge:recv(Player, Id),
    ?DEBUG("Res ~p~n", [Res]),
    {ok, Bin} = pt_438:write(43841, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 等级返利
handle(43842, Player, {}) ->
    act_lv_back:get_info(Player),
    ok;


%% 等级返利领取奖励
handle(43843, Player, {ID, SubID}) ->
    case catch act_lv_back:get_award(Player, ID, SubID) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [34], true),
            Res = 1;
        {fail, Res} ->
            NewPlayer = Player
    end,
%%    ?PRINT("43843 ================= >>> ~w",[Res]),
    {ok, Bin} = pt_438:write(43843, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 等级返利激活
handle(43844, Player, {ID}) ->
    case catch act_lv_back:active(Player, ID) of
        {ok, NewPlayer} ->
            activity:get_notice(NewPlayer, [34], true),
            Res = 1;
        {fail, Res} ->
            NewPlayer = Player
    end,
%%    ?PRINT("43844 ================= >>> ~w",[Res]),
    {ok, Bin} = pt_438:write(43844, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 秘境神树信息
handle(43845, Player, {}) ->
    Data = act_mystery_tree:get_info(Player),
    {ok, Bin} = pt_438:write(43845, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 秘境神树抽奖
handle(43846, Player, {Type, IsAuto}) ->
    {Res, NewPlayer, List} = act_mystery_tree:draw(Player, Type, IsAuto),
    {ok, Bin} = pt_438:write(43846, {Res, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 秘境神树积分兑换
handle(43847, Player, {Type}) ->
    {Res, NewPlayer} = act_mystery_tree:exchange(Player, Type),
    {ok, Bin} = pt_438:write(43847, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取秘境神树商城信息
handle(43848, Player, {}) ->
    ExchangeList = act_mystery_tree:get_exchange_info(),
    {ok, Bin} = pt_438:write(43848, {ExchangeList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 秘境神树物品购买
handle(43849, Player, {Num}) ->
    {Res, NewPlayer} = act_mystery_tree:buy_goods(Player, Num),
    {ok, Bin} = pt_438:write(43849, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%节日boss 信息
handle(43850, Player, {}) ->
    SendData = act_festive_boss:send_boss_info(Player),
    {ok, Bin} = pt_438:write(43850, SendData),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%邀请码信息
handle(43852, Player, {}) ->
    SendData = act_invitation:get_info(Player),
    {ok, Bin} = pt_438:write(43852, SendData),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%邀请码信息
handle(43853, Player, {Str}) ->
    {Res, NewPlayer} = act_invitation:use_invitation(Player, Str),
    ?DEBUG("Res ~p~n", [Res]),
    {ok, Bin} = pt_438:write(43853, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 集聚英雄
handle(43855, Player, {}) ->
    cross_all:apply(act_collection_hero, get_info, [Player#player.sid, Player#player.accname]),
    ok;

%% 集聚英雄领取
handle(43856, Player, {}) ->
    {Res, NewPlayer} = act_collection_hero:get_reward(Player),
    {ok, Bin} = pt_438:write(43856, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 跃升冲榜-界面信息
handle(43857, Player, {}) ->
    Data = act_cbp_rank:get_info(Player),
    {ok, Bin} = pt_438:write(43857, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 跃升冲榜--排行信息
handle(43858, Player, {}) ->
    Data = act_cbp_rank:get_rank_info(Player),
    {ok, Bin} = pt_438:write(43858, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 跃升冲榜--排行信息
handle(43859, Player, {Id}) ->
    {Res, NewPlayer} = act_cbp_rank:get_up_reward(Player, Id),
    {ok, Bin} = pt_438:write(43859, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取限时奇遇礼包信息
handle(43860, Player, {}) ->
    Data = act_meet_limit:get_info(Player),
    {ok, Bin} = pt_438:write(43860, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取限时奇遇礼包信息
handle(43861, Player, {Type, Id}) ->
    {Res, NewPlayer} = act_meet_limit:get_reward(Player, Type, Id),
    {ok, Bin} = pt_438:write(43861, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取每日奖励信息
handle(43863, Player, {Top}) ->
    Data = act_cbp_rank:get_daily_info(Player, Top),
    {ok, Bin} = pt_438:write(43863, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 获取限时奇遇礼包信息
handle(43864, Player, {}) ->
    {ok, Bin} = pt_438:write(43864, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


%% 获取零元礼包信息
handle(43865, Player, _) ->
    Data = new_free_gift:get_info(Player),
    LeaveTime = new_free_gift:get_leave_time(),
    {ok, Bin} = pt_438:write(43865, {LeaveTime, Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 购买零元礼包信息
handle(43866, Player, {Type}) ->
    {Res, NewPlayer} = new_free_gift:get_gift(Player, Type),
    {ok, Bin} = pt_438:write(43866, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 返利大厅消费
handle(43871, Player, _) ->
    {LeaveTime, Acc, ActList} = act_consume_rebate:get_act_info(Player),
    {ok, Bin} = pt_438:write(43871, {LeaveTime, Acc, ActList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43872, Player, {Index}) ->
    {Res, NewPlayer} = act_consume_rebate:recv(Player, Index),
    {ok, Bin} = pt_438:write(43872, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 累充奖励
handle(43873, Player, _) ->
    {LeaveTime, Acc, ActList} = merge_act_acc_consume:get_act_info(Player),
    {ok, Bin} = pt_438:write(43873, {LeaveTime, Acc, ActList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43874, Player, {Index}) ->
    {Res, NewPlayer} = merge_act_acc_consume:recv(Player, Index),
    {ok, Bin} = pt_438:write(43874, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 活动状态入口
handle(43899, Player, {}) ->
    festival_state:send_all(Player),
    ok;


%%%%%%%%%%%%%%合服活动%%%%%%%%%%%%%
handle(43700, Player, _) ->
    MergeDay = config:get_merge_days(),
    List = get_merge_list(Player),
    {ok, Bin} = pt_437:write(43700, {MergeDay, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 合服活动进阶目标一
handle(43701, Player, _) ->
    {LeaveTime, UpTargetList} = merge_act_up_target:get_act_info(Player),
    {ok, Bin} = pt_437:write(43701, {LeaveTime, UpTargetList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43702, Player, {ActType, Args}) ->
    {Res, NewPlayer} = merge_act_up_target:recv(Player, ActType, Args),
    {ok, Bin} = pt_437:write(43702, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 合服活动进阶目标二
handle(43703, Player, _) ->
    {LeaveTime, UpTargetList} = merge_act_up_target2:get_act_info(Player),
    {ok, Bin} = pt_437:write(43703, {LeaveTime, UpTargetList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43704, Player, {ActType, Args}) ->
    {Res, NewPlayer} = merge_act_up_target2:recv(Player, ActType, Args),
    {ok, Bin} = pt_437:write(43704, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 合服活动进阶目标三
handle(43705, Player, _) ->
    {LeaveTime, UpTargetList} = merge_act_up_target3:get_act_info(Player),
    {ok, Bin} = pt_437:write(43705, {LeaveTime, UpTargetList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43706, Player, {ActType, Args}) ->
    {Res, NewPlayer} = merge_act_up_target3:recv(Player, ActType, Args),
    {ok, Bin} = pt_437:write(43706, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 首充团购
handle(43711, Player, _) ->
    {LeaveTime, ActList} = merge_act_group_charge:get_act_info(Player),
    {ok, Bin} = pt_437:write(43711, {LeaveTime, ActList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43712, Player, {BaseGroupNum, BaseChargeGold}) ->
    {Res, NewPlayer} = merge_act_group_charge:recv(Player, BaseGroupNum, BaseChargeGold),
    {ok, Bin} = pt_437:write(43712, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(43750, Player, _) ->
    merge_day7login:get_day7login_info(Player),
    ok;

handle(43751, Player, {}) ->
    case merge_day7login:get_gift(Player) of
        {false, Res} ->
            {ok, Bin} = pt_437:write(43751, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_437:write(43751, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;


%% 累充奖励
handle(43713, Player, _) ->
    {LeaveTime, AccChargeGold, ActList} = merge_act_acc_charge:get_act_info(Player),
    {ok, Bin} = pt_437:write(43713, {LeaveTime, AccChargeGold, ActList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43714, Player, {BaseChargeGold}) ->
    {Res, NewPlayer} = merge_act_acc_charge:recv(Player, BaseChargeGold),
    {ok, Bin} = pt_437:write(43714, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取合服活动之返利抢购面板信息
handle(43715, Player, _) ->
    {LeaTiem, List} = merge_act_back_buy:get_act_info(Player),
    {ok, Bin} = pt_437:write(43715, {LeaTiem, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 抢购
handle(43716, Player, {OrderId}) ->
    {Code, NewPlayer} = merge_act_back_buy:buy(Player, OrderId),
    {ok, Bin} = pt_437:write(43716, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 合服活动帮派争霸
handle(43717, Player, _) ->
    {LeaveTime, List} = merge_act_guild_rank:get_act_info(),
    {ok, Bin} = pt_437:write(43717, {LeaveTime, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取合服兑换活动信息
handle(43718, Player, _) ->
    {OpenTime, ExchangeList} = merge_exchange:get_act_info(Player),
    {ok, Bin} = pt_437:write(43718, {OpenTime, ExchangeList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%兑换
handle(43719, Player, {Id}) ->
    {Code, NewPlayer} = merge_exchange:exchange(Player, Id),
    {ok, Bin} = pt_437:write(43719, {Code}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    {ok, NewPlayer};

%% 请求神秘商城面板数据
handle(43901, Player, _) ->
    ?DEBUG("43901", []),
    {LeaveTime, RefreshNum, RefreshCost, FreeRefreshTime, OrderList, TargetList, ShowList} = mystery_shop:get_act_info(Player),
    {ok, Bin} = pt_439:write(43901, {LeaveTime, RefreshNum, RefreshCost, FreeRefreshTime, OrderList, TargetList, ShowList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 刷新
handle(43902, Player, {Type}) ->
    ?DEBUG("43902 Type:~p", [Type]),
    {NewPlayer, Code, _, IsRarity, RefreshNum, Cost} = mystery_shop:refresh(Player, Type),
    {ok, Bin} = pt_439:write(43902, {Code, Type, IsRarity, RefreshNum, Cost}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(NewPlayer, [155], true),
    {ok, NewPlayer};

%% 购买
handle(43903, Player, {Order}) ->
    {Code, NewPlayer} = mystery_shop:buy_order(Player, Order),
    {ok, Bin} = pt_439:write(43903, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 领取刷新次数奖励
handle(43904, Player, {BaseRefreshNum}) ->
    {Code, NewPlayer} = mystery_shop:recv(Player, BaseRefreshNum),
    {ok, Bin} = pt_439:write(43904, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    activity:get_notice(NewPlayer, [155], true),
    {ok, NewPlayer};

%%获取限时礼包活动面板信息
handle(43905, Player, _) ->
    {LeaveTime, List} = limit_time_gift:get_act_info(Player),
    {ok, Bin} = pt_439:write(43905, {LeaveTime, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%购买
handle(43906, Player, {Id}) ->
    {Code, NewPlayer} = limit_time_gift:buy(Player, Id),
    {ok, Bin} = pt_439:write(43906, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取小额充值面板信息
handle(43907, Player, _) ->
    {LeaveTime, BaseBuyNum, BuyNum, Rmb, IsRecv, List} = act_small_charge:get_act_info(Player),
    {ok, Bin} = pt_439:write(43907, {LeaveTime, BaseBuyNum, BuyNum, Rmb, IsRecv, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 小额充值活动领取
handle(43908, Player, _) ->
    {Code, NewPlayer} = act_small_charge:recv(Player),
    {ok, Bin} = pt_439:write(43908, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取一元充值活动面板
handle(43909, Player, _) ->
    act_one_gold_buy:get_act_info(Player),
    ok;

%% 一元抢购活动购买
handle(43910, Player, {OrderId, BuyNum}) ->
    {Code, NewPlayer} = act_one_gold_buy:buy(OrderId, BuyNum, Player),
    {ok, Bin} = pt_439:write(43910, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 领取购买次数奖励
handle(43911, Player, {BaseBuyNum}) ->
    {Code, NewPlayer} = act_one_gold_buy:recv_num_reward(BaseBuyNum, Player),
    {ok, Bin} = pt_439:write(43911, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 读取记录
handle(43912, Player, {ActNum}) ->
    act_one_gold_buy:read_log(Player, ActNum),
    ok;

%% 获取主打广告
handle(43913, Player, _) ->
    TT = act_display:get_act_info(),
    {ok, Bin} = pt_439:write(43913, TT),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 节日活动之登陆有礼
handle(43914, Player, _) ->
    {LeaveTime, List} = festival_login_gift:get_act_info(),
    {ok, Bin} = pt_439:write(43914, {LeaveTime, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 领取
handle(43915, Player, {Day}) ->
    {Code, NewPlayer} = festival_login_gift:recv_day(Player, Day),
    {ok, Bin} = pt_439:write(43915, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    festival_state:send_all(NewPlayer),
    {ok, NewPlayer};

%% 累充奖励
handle(43916, Player, _) ->
    {LeaveTime, AccChargeGold, ActList} = festival_acc_charge:get_act_info(Player),
    {ok, Bin} = pt_439:write(43916, {LeaveTime, AccChargeGold, ActList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

handle(43917, Player, {BaseChargeGold}) ->
    {Res, NewPlayer} = festival_acc_charge:recv(Player, BaseChargeGold),
    {ok, Bin} = pt_439:write(43917, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    festival_state:send_all(NewPlayer),
    {ok, NewPlayer};

%% 获取节日活动之返利抢购面板信息
handle(43918, Player, _) ->
    {LeaTiem, List} = festival_back_buy:get_act_info(Player),
    {ok, Bin} = pt_439:write(43918, {LeaTiem, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 抢购
handle(43919, Player, {OrderId}) ->
    {Code, NewPlayer} = festival_back_buy:buy(Player, OrderId),
    {ok, Bin} = pt_439:write(43919, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    festival_state:send_all(NewPlayer),
    {ok, NewPlayer};

%% 财神面板
handle(43920, Player, _) ->
    {LeaveTime, ConsumeGoodsId, ConsumeGoodsNum, ConsumeBgold, ConsumeGold} = festival_challenge_cs:get_act_info(Player),
    {ok, Bin} = pt_439:write(43920, {LeaveTime, ConsumeGoodsId, ConsumeGoodsNum, ConsumeBgold, ConsumeGold}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 财神挑战
handle(43921, Player, {Type}) ->
    {NewPlayer, Type, Code, MyNum, CsNum, RewardNum} = festival_challenge_cs:challenge(Player, Type),
    {ok, Bin} = pt_439:write(43921, {Type, Code, MyNum, CsNum, RewardNum}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%获取新兑换活动信息
handle(43922, Player, _) ->
    {OpenTime, EndTime, ExchangeList} = festival_exchange:get_act_info(Player),
    {ok, Bin} = pt_439:write(43922, {OpenTime, EndTime, ExchangeList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%兑换
handle(43923, Player, {Id}) ->
    {Code, NewPlayer} = festival_exchange:exchange(Player, Id),
    {ok, Bin} = pt_439:write(43923, {Code}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    festival_state:send_all(NewPlayer),
    {ok, NewPlayer};

%% 读取红包雨面板信息
handle(43924, Player, _) ->
    festival_red_gift:get_act_info(Player),
    ok;

%% 读取历史排名
handle(43925, Player, _) ->
    festival_red_gift:get_rank_list(Player),
    ok;

%% 抢红包
handle(43927, Player, {Id}) ->
    festival_red_gift:recv(Player, Id),
    ok;

%% 查看红包手气前10
handle(43928, Player, _) ->
    festival_red_gift:look_10(Player),
    ok;

%%查询区域跨服充值榜数据
handle(43930, Player, {}) ->
    ?DEBUG("43930 "),
    cross_all:apply(area_recharge_rank, check_info, [node(), config:get_server_num(), Player#player.key, Player#player.sid]),
    ok;

%%查询区域跨服消费榜数据
handle(43931, Player, {}) ->
    cross_all:apply(area_consume_rank, check_info, [node(), config:get_server_num(), Player#player.key, Player#player.sid]),
    ok;

%% 获取财神单笔充值面板信息
handle(43932, Player, _) ->
    {LeaveTime, BaseBuyNum, BuyNum, Rmb, IsRecv, List} = cs_charge_d:get_act_info(Player),
    {ok, Bin} = pt_439:write(43932, {LeaveTime, BaseBuyNum, BuyNum, Rmb, IsRecv, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 财神单笔充值活动领取
handle(43933, Player, _) ->
    {Code, NewPlayer} = cs_charge_d:recv(Player),
    {ok, Bin} = pt_439:write(43933, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 聚宝盆读取面板信息
handle(43934, Player, _) ->
    {LeaveTime, Status, List} = act_jbp:get_act_info(Player),
    {ok, Bin} = pt_439:write(43934, {LeaveTime, Status, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 聚宝盆领取奖励
handle(43935, Player, {Id, Day}) ->
    {Code, NewPlayer} = act_jbp:recv(Player, Id, Day),
    {ok, Bin} = pt_439:write(43935, {Code}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    {ok, NewPlayer};

%% 仙装觉醒面板
handle(43936, Player, _) ->
    {LeaveTime, ShowType, OneCost, TenCost, List, List2} = act_limit_xian:get_act_info(Player),
    {ok, Bin} = pt_439:write(43936, {LeaveTime, ShowType, OneCost, TenCost, List, List2}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 读取排名和个人信息
handle(43937, Player, _) ->
    act_limit_xian:get_score_info(Player),
    ok;

%% 抽奖
handle(43938, Player, {Type}) ->
    case Type /= 1 andalso Type /= 10 of
        true -> ok;
        false ->
            {Code, RewardList, NewPlayer} = act_limit_xian:op_draw(Player, Type),
            {ok, Bin} = pt_439:write(43938, {Code, RewardList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 获取消费积分信息
handle(43939, Player, {}) ->
    Data = act_consume_score:get_info(Player),
    {ok, Bin} = pt_439:write(43939, Data),
    ?DEBUG("data ~p~n", [Data]),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 消费积分兑换
handle(43940, Player, {Id}) ->
    case act_consume_score:get_reward(Player, Id) of
        {false, Res} ->
            ?DEBUG("43940 ~p~n", [Res]),
            {ok, Bin} = pt_439:write(43940, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_439:write(43940, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;


%% 限时仙装档位领取
handle(43941, Player, {RecvScore}) ->
    {Code, NewPlayer} = act_limit_xian:recv_score(Player, RecvScore),
    {ok, Bin} = pt_439:write(43941, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 一元抢购获取图标时间
handle(43942, Player, _) ->
    {Status, LeaveTime} = act_one_gold_buy:get_leave_time(),
    {ok, Bin} = pt_439:write(43942, {Status, LeaveTime}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 红装抢购信息
handle(43943, Player, _) ->
    Data = buy_red_equip:get_info(Player),
    ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_439:write(43943, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};


%% 红装抢购购买
handle(43944, Player, {Id}) ->
    {Res, NewPlayer} = buy_red_equip:buy(Player, Id),
    {ok, Bin} = pt_439:write(43944, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 红装抢购刷新
handle(43945, Player, {}) ->
    {Res, NewPlayer} = buy_red_equip:re_set(Player),
    {ok, Bin} = pt_439:write(43945, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取小额单笔充值活动面板信息
handle(43946, Player, _) ->
    ?DEBUG("43946", []),
    {LeaveTime, DataList} = small_charge_d:get_act_info(Player),
    ?DEBUG("LeaveTime:~p, DataList:~p", [LeaveTime, DataList]),
    {ok, Bin} = pt_439:write(43946, {LeaveTime, DataList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 小额单笔充值活动领取
handle(43947, Player, {RecvGold}) ->
    ?DEBUG("43947 RecvGold:~p", [RecvGold]),
    {Code, NewPlayer} = small_charge_d:recv(Player, RecvGold),
    ?DEBUG("Code:~p", [Code]),
    {ok, Bin} = pt_439:write(43947, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 仙宠成长面板
handle(43948, Player, _) ->
    {LeaveTime, OneCost, TenCost, List, List2, List3} = act_limit_pet:get_act_info(Player),
    {ok, Bin} = pt_439:write(43948, {LeaveTime, OneCost, TenCost, List, List2, List3}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 读取排名和个人信息
handle(43949, Player, _) ->
    act_limit_pet:get_score_info(Player),
    ok;

%% 仙宠成长抽奖
handle(43950, Player, {Type}) ->
    case Type /= 1 andalso Type /= 10 of
        true -> ok;
        false ->
            {Code, RewardList, NewPlayer} = act_limit_pet:op_draw(Player, Type),
            {ok, Bin} = pt_439:write(43950, {Code, RewardList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 限时仙宠成长档位领取
handle(43951, Player, {RecvScore}) ->
    {Code, NewPlayer} = act_limit_pet:recv_score(Player, RecvScore),
    {ok, Bin} = pt_439:write(43951, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%----------------------回归活动----------------------
%% 获取充值有礼信息
handle(43953, Player, {}) ->
    Data = re_recharge_inf:get_info(Player),
    {ok, Bin} = pt_439:write(43953, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 充值有礼领取
handle(43954, Player, {}) ->
    {Res, NewPlayer} = re_recharge_inf:get_reward(Player),
    {ok, Bin} = pt_439:write(43954, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%获取新兑换活动信息
handle(43956, Player, _) ->
    {OpenTime, EndTime, ExchangeList} = re_exchange:get_act_info(Player),
    {ok, Bin} = pt_439:write(43956, {OpenTime, EndTime, ExchangeList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%兑换
handle(43957, Player, {Id}) ->
    {Code, NewPlayer} = re_exchange:exchange(Player, Id),
    {ok, Bin} = pt_439:write(43957, {Code}),
    server_send:send_to_sid(NewPlayer#player.sid, Bin),
    {ok, NewPlayer};


%%回归活动广告
handle(43958, Player, {}) ->
    Data = re_notice:get_info(Player),
    {ok, Bin} = pt_439:write(43958, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};


%%获取回归登陆信息
handle(43959, Player, {}) ->
    re_login:get_day7login_info(Player),
    ok;


%%回归登陆领取
handle(43960, Player, {Day}) ->
    case re_login:get_gift(Player, Day) of
        {false, Res} ->
            ?DEBUG("Res ~p~n", [Res]),
            {ok, Bin} = pt_439:write(43960, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            ?DEBUG("111~n"),
            {ok, Bin} = pt_439:write(43960, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;


%% 获取回归活动列表
handle(43965, Player, {}) ->
    List = return_act:get_re_list(Player),
    {ok, Bin} = pt_439:write(43965, {List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 获取双倍充值列表
handle(43966, Player, {}) ->
    NewDoubleGold = new_double_gold:get_mul(),
    DoubleGold = double_gold:get_mul(),
    ?DEBUG("NewDoubleGold ~p~n", [NewDoubleGold]),
    ?DEBUG("DoubleGold ~p~n", [DoubleGold]),
    {ok, Bin} = pt_439:write(43966, {[DoubleGold, NewDoubleGold]}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 获取经验副本投资信息
handle(43967, Player, {}) ->
    Data = act_exp_dungeon:get_info(Player),
    ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_439:write(43967, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, Player};

%% 购买经验副本投资
handle(43968, Player, {}) ->
    {Res, NewPlayer} = act_exp_dungeon:buy(Player),
    ?DEBUG("Res ~p~n", [Res]),
    {ok, Bin} = pt_439:write(43968, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 领取经验副本投资
handle(43969, Player, {Id}) ->
    {Res, NewPlayer} = act_exp_dungeon:get_reward(Player, Id),
    ?DEBUG("res ~p~n", [Res]),
    {ok, Bin} = pt_439:write(43969, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%获取神邸抢购
handle(43970, Player, _) ->
    {LeaveTime, List} = act_godness_limit:get_act_info(Player),
    ?DEBUG("List ~p~n", [List]),
    {ok, Bin} = pt_439:write(43970, {LeaveTime, List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%购买
handle(43971, Player, {Id}) ->
    {Code, NewPlayer} = act_godness_limit:buy(Player, Id),
    {ok, Bin} = pt_439:write(43971, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%获取唤神信息
handle(43972, Player, _) ->
    Data = act_call_godness:get_info(Player),
    ?DEBUG("43972 ~p~n", [Data]),
    {ok, Bin} = pt_439:write(43972, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%唤神
handle(43973, Player, {Type}) ->
    {Res, NewPlayer, GoodsList} = act_call_godness:draw(Player, Type),
    ?DEBUG("43973 ~p~n", [Res]),
    {ok, Bin} = pt_439:write(43973, {Res, GoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%领取次数奖励
handle(43974, Player, {Id}) ->
    {Res, NewPlayer} = act_call_godness:get_count_reward(Player, Id),
    ?DEBUG("43974 ~p~n", [Res]),
    {ok, Bin} = pt_439:write(43974, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%许愿池信息(单)
handle(43978, Player, {Type}) ->
    Data = act_wishing_well:get_info(Player, Type),
%%     ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_439:write(43978, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%许愿池排名(单)
handle(43979, Player, {}) ->
    ?CAST(activity_proc:get_act_pid(), {act_wishing_well, get_rank_info, Player#player.key, Player#player.sid}),
    ok;

%%许愿池抽奖(单)
handle(43980, Player, {Type, Id, IsAuto}) ->
    {Res, Reward, NewPlayer} = act_wishing_well:draw(Player, Type, Id, IsAuto),
    {ok, Bin} = pt_439:write(43980, {Res, Reward}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%许愿池信息(跨)
handle(43981, Player, {Type}) ->
    Data = cross_act_wishing_well:get_info(Player, Type),
%%     ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_439:write(43981, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%许愿池排名(跨)
handle(43982, Player, {}) ->
    cross_all:apply(cross_act_wishing_well, get_rank_info, [node(), Player#player.key, Player#player.sid, Player#player.sn_cur]),
    ok;


%%许愿池抽奖(跨)
handle(43983, Player, {Type, Id, IsAuto}) ->
    {Res, Reward, NewPlayer} = cross_act_wishing_well:draw(Player, Type, Id, IsAuto),
    {ok, Bin} = pt_439:write(43983, {Res, Reward}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};



handle(_cmd, _Player, _Data) ->
    ?ERR("activity_rpc cmd ~p~n", [_cmd]),
    ?ERR("activity_rpc cmd ~p~n", [_Data]),
    ok.

get_open_list(Player) ->
    [
        [1, open_act_jh_rank:get_sub_act_type(), open_act_jh_rank:get_state(Player)],
        [2, open_act_up_target:get_sub_act_type(), open_act_up_target:get_state(Player)],
        [9, open_act_up_target2:get_sub_act_type(), open_act_up_target2:get_state(Player)],
        [10, open_act_up_target3:get_sub_act_type(), open_act_up_target3:get_state(Player)],
        [3, 0, open_act_group_charge:get_state(Player)],
        [4, 0, open_act_acc_charge:get_state(Player)],
        [8, 0, open_act_back_buy:get_state(Player)],
        [17, 0, act_consume_rebate:get_state(Player)],
        [6, open_act_all_rank:get_sub_act_type(), open_act_all_rank:get_state(Player)],
        [11, open_act_all_rank2:get_sub_act_type(), open_act_all_rank2:get_state(Player)],
        [12, open_act_all_rank3:get_sub_act_type(), open_act_all_rank3:get_state(Player)],
        [15, 0, open_act_other_charge:get_state(Player)],
        [16, 0, open_act_super_charge:get_state(Player)],
        [7, 0, open_act_guild_rank:get_state(Player)],
        [5, open_act_all_target:get_sub_act_type(), open_act_all_target:get_state(Player)],
        [13, open_act_all_target2:get_sub_act_type(), open_act_all_target2:get_state(Player)],
        [14, open_act_all_target3:get_sub_act_type(), open_act_all_target3:get_state(Player)]

    ].

get_merge_list(Player) ->
    [
        [9, 0, merge_day7login:get_state(Player)],
        [4, 0, merge_act_group_charge:get_state(Player)],
        [8, 0, merge_exchange:get_state(Player)],
        [1, merge_act_up_target:get_sub_act_type(), merge_act_up_target:get_state(Player)],
        [2, merge_act_up_target2:get_sub_act_type(), merge_act_up_target2:get_state(Player)],
        [3, merge_act_up_target3:get_sub_act_type(), merge_act_up_target3:get_state(Player)],
        [6, 0, merge_act_back_buy:get_state(Player)],
        [5, 0, merge_act_acc_charge:get_state(Player)],
        [7, 0, merge_act_guild_rank:get_state(Player)],
        [10, 0, merge_act_acc_consume:get_state(Player)]
    ].
