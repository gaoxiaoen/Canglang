%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 六月 2016 11:11
%%%-------------------------------------------------------------------
-module(cross_eliminate).
-author("hxming").

-include("daily.hrl").
-include("cross_eliminate.hrl").
-include("server.hrl").
-include("common.hrl").
-include("achieve.hrl").

%% API
-compile(export_all).

get_eliminate_state() ->
    ?IF_ELSE(get_eliminate_times() < ?CROSS_ELIMINATE_MAX_TIMES, 1, 0).

get_notice_state() ->
    ?IF_ELSE(get_eliminate_times() == 0, 1, 0).

get_state() ->
    Time = get_eliminate_times(),
    ?IF_ELSE(Time >= ?CROSS_ELIMINATE_MAX_TIMES, 0, 1).

logout(Player) ->
    Key = Player#player.key,
    case ets:lookup(?ETS_CROSS_ELIMINATE, Key) of
        [] ->
            case scene:is_cross_eliminate_scene(Player#player.scene) of
                false -> skip;
                true ->
                    cross_all:apply(cross_eliminate, check_logout, [Key])
            end;
        _ ->
            ets:delete(?ETS_CROSS_ELIMINATE, Key),
            cross_all:apply(cross_eliminate, check_logout, [Key])
    end.

check_logout(Key) ->
    ?CAST(cross_eliminate_proc:get_server_pid(), {check_logout, Key}).

%%获取今日消消乐已用次数
get_eliminate_times() ->
    Record = lib_dict:get(?PROC_STATUS_ELIMINATE),
    Record#player_eliminate.times.


set_eliminate_times() ->
    Record = lib_dict:get(?PROC_STATUS_ELIMINATE),
    lib_dict:put(?PROC_STATUS_ELIMINATE, Record#player_eliminate{times = 0, is_change = 1}).

%%增加次数
add_eliminate_times(Player) ->
    Record = lib_dict:get(?PROC_STATUS_ELIMINATE),
    NewRecord = Record#player_eliminate{times = Record#player_eliminate.times + 1, is_change = 1},
    lib_dict:put(?PROC_STATUS_ELIMINATE, NewRecord),
    activity:get_notice(Player, [59], true),
    ok.

%%匹配数据
make_mb(Player, From) ->
    RandTime = ?IF_ELSE(From == 0, util:rand(10, 30), util:rand(20, 30)),
    Now = util:unixtime(),
    RelaTime = ?IF_ELSE(From == 0, 0, Now + 10),
    #eliminate_mb{
        pkey = Player#player.key,
        sn = config:get_server_num(),
        node = node(),
        nickname = Player#player.nickname,
        career = Player#player.career,
        sex = Player#player.sex,
        avatar = Player#player.avatar,
        lv = Player#player.lv,
        vip = Player#player.vip_lv,
        cbp = Player#player.cbp,
        fashion_cloth_id = Player#player.fashion#fashion_figure.fashion_cloth_id,
        light_weaponid = Player#player.light_weaponid,
        wing_id = Player#player.wing_id,
        clothing_id = Player#player.equip_figure#equip_figure.clothing_id,
        weapon_id = Player#player.equip_figure#equip_figure.weapon_id,
        pid = Player#player.pid,
        sid = Player#player.sid,
        hp_lim = Player#player.attribute#attribute.hp_lim,
        times = get_eliminate_times(),
        time = Now + RandTime,
        rela_time = RelaTime
    }.

make_sys_mb(Cbp) ->
    Career = player_util:rand_career(),
    Attribute = #attribute{hp_lim = 100},
    Player = shadow:shadow_ai_for_eliminate(Career),
    NickName = player_util:rand_name(),
    Pkey = misc:unique_key_auto(),
    Sn = config:get_server_num(),
    #eliminate_mb{
        type = ?CROSS_ELIMINATE_MB_TYPE_ROBOT,
        sn = Sn,
        pkey = Pkey,
        nickname = NickName,
        career = Player#player.career,
        sex = Player#player.sex,
        fashion_cloth_id = Player#player.fashion#fashion_figure.fashion_cloth_id,
        light_weaponid = Player#player.light_weaponid,
        wing_id = Player#player.wing_id,
        clothing_id = Player#player.equip_figure#equip_figure.clothing_id,
        weapon_id = Player#player.equip_figure#equip_figure.weapon_id,
        cbp = Cbp + util:rand(-100, 10000),
        shadow = Player#player{key = Pkey, nickname = NickName, pet = #fpet{}, sn = Sn, attribute = Attribute}
    }.

%%匹配
check_match(Mb) ->
    ?CAST(cross_eliminate_proc:get_server_pid(), {check_match, Mb}).

%%取消匹配
check_cancel(Node, Pkey, Sid) ->
    ?CAST(cross_eliminate_proc:get_server_pid(), {check_cancel, Node, Pkey, Sid}).

check_cancel_only(Pkey) ->
    cross_all:apply(cross_eliminate, do_check_cancel_only, [Pkey]).

do_check_cancel_only(Pkey) ->
    ?CAST(cross_eliminate_proc:get_server_pid(), {check_cancel_only, Pkey}).

%%排行榜
check_rank(Node, Key, Sid, Page) ->
    ?CAST(cross_eliminate_proc:get_server_pid(), {check_rank, Node, Key, Sid, Page}).

%%邀请
check_invite(Player, Key, Name, Avatar, Sex) ->
    case scene:is_normal_scene(Player#player.scene) of
        false -> skip;
        true ->
            if Player#player.lv < ?CROSS_ELIMINATE_LV -> skip;
                true ->
                    {ok, Bin} = pt_590:write(59005, {Key, Name, Avatar, Sex}),
                    server_send:send_to_sid(Player#player.sid, Bin)
            end
    end.

%%回应邀请
check_respond(Mb, Key) ->
    ?CAST(cross_eliminate_proc:get_server_pid(), {check_respond, Mb, Key}).

get_last_week_reward(Node, Key, Pid) ->
    ?CAST(cross_eliminate_proc:get_server_pid(), {get_last_week_reward, Node, Key, Pid}).

week_reward(RankList) ->
    F = fun(Log, L) ->
        case data_cross_eliminate_reward:get(Log#eliminate_log.rank) of
            [] -> L;
            GoodsList ->
                case center:get_node_by_sn(Log#eliminate_log.sn) of
                    false ->
                        [#elimination_reward{pkey = Log#eliminate_log.pkey, rank = Log#eliminate_log.rank, time = util:unixtime()} | L];
                    Node ->
                        center:apply(Node, cross_eliminate, week_reward_msg, [Log#eliminate_log.pkey, Log#eliminate_log.rank, tuple_to_list(GoodsList)]),
                        L
                end
        end
        end,
    RewardList = lists:foldl(F, [], RankList),
    cross_eliminate_load:insert_reward(RewardList),
    RewardList.

week_reward_msg(Pkey, Rank, GoodsList) ->
    {Title, Content} = t_mail:mail_content(46),
    NewContent = io_lib:format(Content, [Rank]),
    mail:sys_send_mail([Pkey], Title, NewContent, GoodsList),
    ok.

%%奖励信息
reward_msg(Pkey, Ret, GoodsList, IsMail) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] ->
            {Title, Content} = ?IF_ELSE(Ret == 1, t_mail:mail_content(45), t_mail:mail_content(47)),
            mail:sys_send_mail([Pkey], Title, Content, GoodsList),
            update_eliminate_offline(Pkey, Ret),
            ok;
        [Online] ->
            Online#ets_online.pid ! {eliminate_reward, Ret, GoodsList, IsMail}
    end,
    ok.

%%更新消消乐挑战结果
eliminate_ret(Pkey, Ret) ->
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] ->
            update_eliminate_offline(Pkey, Ret);
        [Online] ->
            Online#ets_online.pid ! {update_eliminate_online, Ret}
    end.


update_eliminate_offline(Pkey, Ret) ->
    PlayerEliminate = cross_eliminate_init:init_data(Pkey, util:unixtime()),
    Wins =
        if Ret == 1 ->
            achieve:trigger_achieve(Pkey, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4018, 0, PlayerEliminate#player_eliminate.wins + 1),
            PlayerEliminate#player_eliminate.wins + 1;
            true ->
                PlayerEliminate#player_eliminate.wins
        end,
    WinningStreak =
        if Ret == 1 ->
            achieve:trigger_achieve(Pkey, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4019, 0, PlayerEliminate#player_eliminate.winning_streak + 1),
            PlayerEliminate#player_eliminate.winning_streak + 1;
            true -> 0
        end,
    LosingStreak =
        if Ret == 1 -> 0;
            true ->
                achieve:trigger_achieve(Pkey, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4020, 0, PlayerEliminate#player_eliminate.losing_streak + 1),
                PlayerEliminate#player_eliminate.losing_streak + 1
        end,
    NewPlayerEliminate = PlayerEliminate#player_eliminate{wins = Wins, winning_streak = WinningStreak, losing_streak = LosingStreak, is_change = 1},
    cross_eliminate_load:replace_player_eliminate(NewPlayerEliminate),
    ok.

update_eliminate_online(Player, Ret) ->
    PlayerEliminate = lib_dict:get(?PROC_STATUS_ELIMINATE),
    Wins =
        if Ret == 1 ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4018, 0, PlayerEliminate#player_eliminate.wins + 1),
            PlayerEliminate#player_eliminate.wins + 1;
            true ->
                PlayerEliminate#player_eliminate.wins
        end,
    WinningStreak =
        if Ret == 1 ->
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4019, 0, PlayerEliminate#player_eliminate.winning_streak + 1),
            PlayerEliminate#player_eliminate.winning_streak + 1;
            true -> 0
        end,
    LosingStreak =
        if Ret == 1 -> 0;
            true ->
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4020, 0, PlayerEliminate#player_eliminate.losing_streak + 1),
                PlayerEliminate#player_eliminate.losing_streak + 1
        end,
    NewPlayerEliminate = PlayerEliminate#player_eliminate{wins = Wins, winning_streak = WinningStreak, losing_streak = LosingStreak, is_change = 1},
    lib_dict:put(?PROC_STATUS_ELIMINATE, NewPlayerEliminate).

%%消消乐在线奖励
eliminate_reward(Player, Ret, GoodsList, IsMail) ->
    if IsMail ->
        {Title, Content} = ?IF_ELSE(Ret == 1, t_mail:mail_content(45), t_mail:mail_content(47)),
        mail:sys_send_mail([Player#player.key], Title, Content, GoodsList),
        NewPlayer = Player;
        true ->
            NewGoodsList = goods:make_give_goods_list(91, GoodsList),
            {ok, NewPlayer} = goods:give_goods(Player, NewGoodsList)
    end,
    update_eliminate_online(Player, Ret),
    NewPlayer.


%%领取上周排名奖励
eliminate_week_reward(Player, GoodsList) ->
    NewGoodsList = goods:make_give_goods_list(91, GoodsList),
    {ok, NewPlayer} = goods:give_goods(Player, NewGoodsList),
    {ok, Bin} = pt_590:write(59016, {1, goods:pack_goods(GoodsList)}),
    server_send:send_to_sid(Player#player.sid, Bin),
    NewPlayer.

%%消消乐更新亲密度
update_qinmidu(Mb1, Mb2) ->
    if
        Mb1#eliminate_mb.node == none orelse Mb1#eliminate_mb.type == 1 orelse Mb1#eliminate_mb.pid == none -> skip;
        Mb2#eliminate_mb.node == none orelse Mb2#eliminate_mb.type == 1 orelse Mb2#eliminate_mb.pid == none -> skip;
        true ->
            server_send:send_node_pid(Mb1#eliminate_mb.node, Mb1#eliminate_mb.pid, {cross_eliminate_add_qinmidu, Mb2#eliminate_mb.pkey})
    end,
    ok.