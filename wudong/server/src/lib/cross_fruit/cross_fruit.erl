%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2017 上午11:02
%%%-------------------------------------------------------------------
-module(cross_fruit).
-author("fengzhenlin").
-include("cross_fruit.hrl").
-include("common.hrl").
-include("server.hrl").
-include("rank.hrl").

%% API
-compile([export_all]).

init(Player) ->
    St = cross_fruit_load:dbget_fruit_info(Player),
    put_dict(St),
    update(Player),
    Player.

logout(Player) ->
    St = get_dict(),
    case St#st_cross_fruit.state == 1 of
    %case true of
        true ->
            cross_all:apply(cross_fruit_proc, exit, [Player#player.key]);
        false  ->
            skip
    end.

update(_Player) ->
    St = get_dict(),
    Now = util:unixtime(),
    NewSt =
        case util:is_same_date(Now, St#st_cross_fruit.update_time) of
            true -> St;
            false ->
                St#st_cross_fruit{
                    get_times = 0,
                    update_time = Now
                }
        end,
    LastRewardTime = util:get_last_time(7, 23, 0),
    NewSt1 =
        case St#st_cross_fruit.win_update_time < LastRewardTime of
            true -> %%已经结算过了
                NewSt#st_cross_fruit{
                    win_times = 0,
                    win_update_time = Now
                };
            false ->
                NewSt
        end,
    put_dict(NewSt1),
    ok.

%%获取玩家水果大作战信息
get_my_fruit_info(Player) ->
    St = get_dict(),
    #st_cross_fruit{
        get_times = GetTimes
    } = St,
    LeaveTimes = max(0, ?MAX_GET_GIFT_TIEMS - GetTimes),
    {ok, Bin} = pt_582:write(58201, {LeaveTimes}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

%%申请匹配
apply_match(Player, Type) ->
    apply_match(Player, Type, 0).
apply_match(Player, Type, IsInvite) ->
    OpenLv = data_menu_open:get(44),
    Res =
        if
            Player#player.lv < OpenLv -> {false, 6};
            true ->
                ok
        end,
    case Res of
        {fasle, Reason} ->
            {ok, Bin} = pt_582:write(58202, {Reason}),
            server_send:send_to_sid(Player#player.sid, Bin);
        ok ->
            St = get_dict(),
            NewSt = St#st_cross_fruit{
                state = 1
            },
            put_dict(NewSt),
            cross_all:apply(cross_fruit_proc, apply_match, [cross_fruit:make_fruit_record(Player), Type, IsInvite]),
            ok
    end.

%%邀请玩家
invite(Player, PkeyList) ->
    FP = make_fruit_record(Player),
    Data = cross_fruit_handle:pack_player(FP),
    {ok, Bin} = pt_582:write(58221, {Data}),
    F = fun(Pkey) ->
            case player_util:get_player_online(Pkey) of
                [] ->
                    {ok, Bin1} = pt_582:write(58220, {0, ?T("对方不在线")}),
                    server_send:send_to_sid(Player#player.sid, Bin1);
                Online ->
                    Online#ets_online.pid ! {apply_state, {cross_fruit, invite_1, [Bin, Player#player.sid]}}
            end
        end,
    lists:foreach(F, PkeyList),
    %%自动开始邀请匹配
    apply_match(Player, 1, 1),
    ok.
%%被邀请处理
invite_1([Bin, Sid], Player) ->
    {Code, Res} =
        case scene:is_normal_scene(Player#player.scene) of
            false -> {0, io_lib:format(?T("~s处于特殊地图无法邀请"),[Player#player.nickname])};
            true ->
                server_send:send_to_sid(Player#player.sid, Bin),
                {1, ?T("成功")}
        end,
    {ok, Bin1} = pt_582:write(58220, {Code, Res}),
    server_send:send_to_sid(Sid, Bin1),
    ok.

%%邀请回应
invite_res(Player, Pkey, Res) ->
    case Res of
        0 ->
            Msg = io_lib:format(?T("~s拒绝你的邀请"),[Player#player.nickname]),
            {ok, Bin} = pt_582:write(58222, {Msg}),
            server_send:send_to_key(Pkey, Bin),
            ok;
        _ ->
            %%先进入匹配
            apply_match(Player, 1, 1),
            %%进行邀请匹配
            cross_all:apply(cross_fruit_proc, apply_match_invite, [Player#player.key, Pkey])
    end,
    ok.

%%继续
continue(Player, Pkey) ->
    %%先进入匹配
    apply_match(Player, 1, 1),
    %%进行邀请匹配
    cross_all:apply(cross_fruit_proc, continue, [Player#player.key, Pkey]),
    {ok, Bin} = pt_582:write(58223, {?T("成功")}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.

get_dict() ->
    lib_dict:get(?PROC_STATUS_CROSS_FRUIT).

put_dict(St) ->
    lib_dict:put(?PROC_STATUS_CROSS_FRUIT, St).

make_fruit_record(Player) ->
    WinTimes =
        case catch get_dict() of
            St when is_record(St, st_cross_fruit) -> St#st_cross_fruit.win_times;
            _ -> 0
        end,
    #cross_fruit_player{
        pkey = Player#player.key,
        sn = Player#player.sn,
        node = Player#player.node,
        name = Player#player.nickname,
        career = Player#player.career,
        sex = Player#player.sex,
        vatar = Player#player.avatar,
        sid = Player#player.sid,
        win_times = WinTimes
    }.

%%结算
reward(Pkey, Res, WinTimes) ->
    case player_util:get_player_online(Pkey) of
        [] -> skip;
        Online ->
            Online#ets_online.pid ! {apply_state, {cross_fruit, reward_1, [Res, WinTimes]}}
    end,
    ok.
reward_1([Res, WinTimes], Player) ->
    St = get_dict(),
    case St#st_cross_fruit.get_times >= ?MAX_GET_GIFT_TIEMS of
        true ->
            {ok, Bin} = pt_582:write(58206, {Res, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            Now = util:unixtime(),
            NewSt = St#st_cross_fruit{
                win_times = WinTimes,
                win_update_time = Now,
                update_time = Now
            },
            put_dict(NewSt),
            cross_fruit_load:dbup_fruit_info(NewSt),
            {ok, Player};
        false ->
            {WinGoodsList, FailGoodsList} = data_fruit_one_reward:get(Player#player.lv),
            GoodsList =
                case Res of
                    0 -> FailGoodsList;
                    _ -> WinGoodsList
                end,
            GiveGoods = goods:make_give_goods_list(513, GoodsList),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoods),
            {ok, Bin} = pt_582:write(58206, {Res, util:list_tuple_to_list(GoodsList)}),
            server_send:send_to_sid(Player#player.sid, Bin),
            Now = util:unixtime(),
            NewSt = St#st_cross_fruit{
                get_times = St#st_cross_fruit.get_times + 1,
                win_times = WinTimes,
                win_update_time = Now,
                update_time = Now
            },
            put_dict(NewSt),
            cross_fruit_load:dbup_fruit_info(NewSt),
            activity:get_notice(Player, [125], true),
            {ok, NewPlayer}
    end.

%%排行结算
week_rank_reward(Pkey, Pname, Order) ->
    case data_fruit_rank_reward:get(Order) of
        [] -> skip;
        Base ->
            #base_week_rank{
                goods_list = GoodsList
            } = Base,
            case player_util:get_player_online(Pkey) of
                [] ->
                    Title = ?T("水果大作战"),
                    Content = io_lib:format(?T("水果大作战周排行奖励，排名~p，请查收！"),[Order]),
                    mail:sys_send_mail([Pkey], Title, Content, GoodsList),
                    activity_log:log_get_goods(GoodsList, Pkey, Pname, 514),
                    cross_all:apply(cross_fruit_proc, get_week_gift_res, [Pkey]);
                Online ->
                    Online#ets_online.pid ! {apply_state, {cross_fruit, week_rank_reward_1, [Pkey, Order]}}
            end
    end,
    ok.
week_rank_reward_1([Pkey, Order], Player) ->
    Base = data_fruit_rank_reward:get(Order),
    #base_week_rank{
        goods_list = GoodsList
    } = Base,
    GiveGoodsList = goods:make_give_goods_list(514, GoodsList),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
    activity_log:log_get_goods(GoodsList, Pkey, Player#player.nickname, 514),
    cross_all:apply(cross_fruit_proc, get_week_gift_res, [Pkey]),
    {ok, NewPlayer}.


%%获取机器人
get_robot(Pkey) ->
    RankList = rank:get_rank_top_N(1, 20),
    case RankList of
        [] -> [];
        _ ->
            RankList1 = lists:keydelete(Pkey, #a_rank.pkey, RankList),
            R = util:list_rand(RankList1),
            #a_rank{
                pkey = Pkey1
            } = R,
            Player = shadow_proc:get_shadow(Pkey1),
            FP = make_fruit_record(Player),
            FP
    end.

%%获取客户端红点状态
get_state() ->
    St = get_dict(),
    #st_cross_fruit{
        get_times = GetTimes
    } = St,
    case GetTimes >= ?MAX_GET_GIFT_TIEMS of
        true -> 0;
        false -> 1
    end.