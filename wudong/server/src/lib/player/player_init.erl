%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 一月 2015 下午3:02
%%%-------------------------------------------------------------------
-module(player_init).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("achieve.hrl").
%% API
-export([init/1, stop/1]).
-export([save_online/1, do_stop/2, check_login_time/1, send_msg/2]).

check_login_time(Key) ->
    Ltkey = lists:concat(["lt", Key]),
    Lt = cache:get(Ltkey),
    Now = util:unixtime(),
    cache:set(Ltkey, Now),
    ?DEBUG("Now ~p~n", [Now]),
    ?DEBUG("Lt ~p~n", [Lt]),
    case Lt /= [] andalso Now - Lt < 3 of
        true ->
            false;
        false ->
            true
    end.

init(#player{key = Key, socket = Socket} = Player0) ->
    Now = util:unixtime(),
%%    check_duplicate_login(Key),
    Pid = self(),
    Sid = list_to_tuple(lists:map(
        fun(_send) ->
            spawn_link(fun() -> put(send_sid, _send), send_msg(Socket) end)
        end, lists:seq(1, ?SERVER_SEND_MSG))),

    [Accname, _Last_login_time, Total_online_time, LogoutTime, Phone_id, Os, _SettingData, Location, Reg_time, Avatar, RegIp, LoginDays, GameId, GameChannelId]
        = player_load:dbget_player_login_data(Key),
    [Nickname, Lv, Career, Sex, Realm, Gold, Coin, BGold, _BCoin, Exp, Repute, Honor, SmeltValue, _Scene, _X, _Y, Hp, Mp, Sin, MountId,
        LightWeaponId, DesignationBin, ArenaPt, HighestCbp, Xinghun, GM, XingyunPT, Charm, ManorPt, IsInterior, Reiki, SdPt, ExploitPri,
        Oldx, Oldy, OldScene, OldScenePk, MarryKey, Sweet, NewCareer, ReturnTime, ContinueEndTime, EquipPart, ActGold, FairyCrystal] = player_load:dbget_player_state_data(Key),
    PkSt = prison_init:init(Player0#player{logout_time = LogoutTime}),

    EtsBack = scene:in_which_scene(Key, _Scene, _X, _Y, PkSt#pk.pk, Sid, PkSt#pk.value, OldScene, Oldx, Oldy, OldScenePk),
%%    ?DEBUG("EtsBack ~p~n",[EtsBack]),
    #ets_back{scene = Scene, copy = Copy, x = X, y = Y, pk = NewPk, figure = FigureId, group = Group} = EtsBack,
    ExpLim = data_exp:get(Lv),
    Designation = util:bitstring_to_term(DesignationBin),
    PkSt1 = PkSt#pk{pk = NewPk, pk_old = NewPk},

    Flag = util:is_same_date(Now, LogoutTime),
    NewLoginDays = ?IF_ELSE(Flag, LoginDays, LoginDays + 1),
    {Wlv, WlvAdd} = player_util:world_lv_add(Lv),
%%    FigureId =
%%        case scene:is_cross_scuffle_scene(Scene) of
%%            true -> S_Career;
%%            false ->
%%                0
%%        end,
    Player = Player0#player{
        game_id = GameId,
        game_channel_id = GameChannelId,
        pid = Pid,
        sn_cur = config:get_server_num(),
        sn_name = config:get_server_name(),
        node = node(),
        socket = Socket,
        accname = util:to_list(Accname),
        nickname = util:to_list(Nickname),
        last_login_time = Now,
        total_online_time = Total_online_time,
        logout_time = LogoutTime,
        reg_time = Reg_time,
        reg_ip = RegIp,
        opentime = config:get_opening_time(),
        phone_id = util:to_list(Phone_id),
        os = util:to_list(Os),
        location = util:to_list(Location),
        avatar = util:to_list(Avatar),
        sid = Sid,
        exp = Exp,
        exp_lim = ExpLim,
        lv = Lv,
        career = Career,
        new_career = NewCareer,
        sex = Sex,
        realm = Realm,
        gm = GM,
        gold = Gold,
        bgold = BGold,
        coin = Coin,
        bcoin = 0,
        repute = Repute,
        honor = Honor,
        arena_pt = ArenaPt,
        xingyun_pt = XingyunPT,
        equip_part = EquipPart,
        smelt_value = SmeltValue,
        scene = Scene,
        copy = Copy,
        x = X,
        y = Y,
        hp = ?IF_ELSE(Hp =< 0, 1, Hp),
        mp = Mp,
        sin = Sin,
        mount_id = MountId,
        light_weaponid = LightWeaponId,
        design = Designation,
        pk = PkSt1,
        highest_cbp = HighestCbp,
        xinghun = Xinghun,
        charm = Charm,
        manor_pt = ManorPt,
        login_days = NewLoginDays,
        is_interior = IsInterior,
        reiki = Reiki,
        sd_pt = SdPt,
        exploit_pri = ExploitPri,
        x_old = Oldx,
        y_old = Oldy,
        scene_old = OldScene,
        old_scene_pk = OldScenePk,
        world_lv = Wlv,
        world_lv_add = WlvAdd,
        figure = FigureId,
        group = Group,
        sweet = Sweet,
        act_gold = ActGold,
        fairy_crystal = FairyCrystal,
        return_time = ReturnTime,
        continue_end_time = ContinueEndTime,
        marry = #marry{mkey = MarryKey}
    },
    player_handle:daily_login_reward(Player),
    player_load:dbup_player_login(Player, Now, 1),
    spawn(fun() -> player_load:dbup_player_location(Player) end),
    ?IF_ELSE(LogoutTime == 0, self() ! new_role, ok),
    ?IF_ELSE(util:is_same_date(Now, _Last_login_time) == false, self() ! new_day_login, ok),
    player_util:init_lv_attr(Lv),
    Player.



stop(Player) ->
    NowTime = util:unixtime(),
%%    Ltkey = lists:concat(["lt", Player#player.key]),
%%    cache:set(Ltkey, NowTime),
    case get(player_stop_db_up) of
        true -> ok;
        _ ->
            do_stop(Player, NowTime)
    end,
    %%玩家执行完其他操作之后才清理ETS_ONLINE信息,
    delete_online(Player),
    %%这个要放尾部
    [exit(Sid, kill) || Sid <- tuple_to_list(Player#player.sid)],
    ?DEBUG("logout.~n"),
    ok.

%%写库处理
do_stop(Player, NowTime) when Player#player.lv > 0 ->
    player_load:dbup_player_state(Player),
    player_load:dbup_player_login(Player, NowTime, 0),
    player_mask:save(),
    act_cbp_rank:logout(Player),
    mount_rpc:handle(17020, Player, []),
    scene_agent_dispatch:leave_scene(Player),
    prison_init:logout(Player),
    guild_init:logout(Player, NowTime),
    task_init:logout(),
    dungeon:logout(Player),
    team_init:logout(Player, NowTime),
    shadow_proc:set(Player),
    daily_init:logout(),
%%    treasure:logout(),
    player_load:log_login(Player, NowTime),
    player_guide:logout(Player),
    goods_util:offline_save(),
%%    equip_wash:equip_wash_restore_save(Player),
    chat:logout(Player),
    activity_init:logout(Player),
    act_rank:logout(Player),
%%    crazy_click_init:logout(Player),
    online_gift:logout(Player),
    role_goods_count:logout(Player),
    gold_count:logout(Player),
    battlefield:logout(Player),
    online_time_gift:logout(),
    relation:save_recently_contacts(Player),
    guild_skill:logout(),
    res_gift:logout(),
%%    xiulian_init:logout(),
%%    yuanli_init:logout(),
    goods_attr_dan:save(Player),
    cross_battlefield:logout(Player),
    cross_boss:logout(Player),
    cross_elite:logout(Player),
    cross_hunt:logout(Player),
    battlefield_init:logout(),
    cross_arena_init:logout(),
    cross_arena:logout(Player),
    cross_eliminate:logout(Player),
    drop_vitality:logout(Player),
    goods_load:gem_exp_save(Player),
    goods_load:str_exp_save(Player),
    goods_load:db_save_refine_info(Player),
    goods_load:db_save_magic_info(Player),
    goods_load:db_save_soul_info(Player),
    target_act:logout(Player),
    equip_wash:logout(),
    meridian_init:logout(),
    achieve_init:logout(),
    sword_pool_init:logout(),
    cross_dungeon_util:logout(Player),
    cross_dungeon_guard_util:logout(Player),
    cross_1vn:logout(Player),
    hp_pool:logout(),
    sign_in_init:logout(),
    light_weapon_init:logout(),
    pet_weapon_init:logout(),
    footprint_init:logout(),
    magic_weapon_init:logout(),
    god_weapon_init:logout(),
    mon_photo_init:logout(),
    mount_util:logout(),
    wing_init:logout(),
    baby_wing_init:logout(),
    smelt_init:logout(),
    skill_init:logout(),
    findback_src:logout(Player),
    fashion_init:logout(),
    wybq:log_out(Player),
    cross_six_dragon:logout(Player),
    bubble_init:logout(),
    decoration_init:logout(),
    designation_init:logout(),
    buff_init:logout(),
    cross_elite_init:logout(),
    answer:exit_scene(Player),
    cross_eliminate_init:logout(),
    pet_init:logout(),
    cross_fruit:logout(Player),
    head_init:logout(),
    hot_well:logout(Player),
    dungeon_god_weapon:logout(),
    cross_scuffle:logout(Player),
    cross_scuffle_elite:logout(Player),
    cat_init:logout(),
    golden_body_init:logout(),
    god_treasure_init:logout(),
    jade_init:logout(),
    marry_room:logout(Player),
    marry_ring:logout(Player),
    cross_dark_bribe:logout(),
    cross_war:logout(Player),
    baby_init:logout(),
    act_lucky_turn:logout(Player),
    act_local_lucky_turn:logout(Player),
    act_hi_fan_tian:log_out(),
    act_daily_task:log_out(),
    baby_mount_init:logout(),
    baby_weapon_init:logout(),
    fashion_suit_init:logout(),
    xian_upgrade:logout(),
    act_meet_limit:logout(Player),
    pet_war_dun:logout(Player),
    elite_boss:logout(Player),
    buff_proc:logout(Player#player.pid),
    log_cbp:logout(),
    player_fcm:logout(),
    put(player_stop_db_up, true),
    ?DEBUG("do db up.~n"),
    ok;
do_stop(_, _) -> ok.

send_msg(Socket) ->
    send_msg(Socket, []).

send_msg([], _List) ->
    skip;

send_msg(Socket, List) ->
    receive
        {'EXIT', _, _} ->
            exit(self(), normal);
        {send_priority, Bin} ->
            Binary = pack_msg([Bin], <<>>),
            tcp_send(Binary, Socket),
            player_init:send_msg(Socket, List);
        {send, Bin} ->
%%            Binary = pack_msg([Bin], <<>>),
%%            tcp_send(Binary, Socket),
%%            send_msg(Socket,[]);
            player_init:send_msg(Socket, [Bin | List]);
        _ ->
            player_init:send_msg(Socket, List)
    after 20 ->
        Len = length(List),
        if
            Len > 0 andalso Len < 1000 ->
                {L2, L1} = lists:split(Len - min(10, Len), List),
                Binary = pack_msg(L1, <<>>),
                tcp_send(Binary, Socket),
                player_init:send_msg(Socket, L2);
            true ->
%%                ?WARNING("DROP SEND MSG ~p~n",[erlang:process_info(self())]),
                player_init:send_msg(Socket, [])
        end
    end.
tcp_send(_, []) -> skip;
tcp_send(<<>>, _Socket) -> skip;
tcp_send(Binary, Socket) ->
    send(Socket, Binary).

pack_msg([], Binary) -> Binary;
pack_msg([B | L], Binary) ->
    pack_msg(L, <<B/binary, Binary/binary>>).

send(Socket, Bin) ->
    case erlang:is_port(Socket) of
        true -> catch erlang:port_command(Socket, Bin, [force]);
        false -> ignore
    end.

save_online(Player) when is_record(Player, player) ->
    ets:insert(?ETS_ONLINE, #ets_online{
        key = Player#player.key,
        sid = Player#player.sid,
        pid = Player#player.pid,
        lv = Player#player.lv
    });
save_online(_) -> ok.

delete_online(Player) when is_record(Player, player) ->
    ets:delete(?ETS_ONLINE, Player#player.key);

delete_online(_) -> ok.

%%
%%%%检查用户是否登陆了
%%check_duplicate_login(Key) ->
%%    case player_util:get_player_online(Key) of
%%        [] ->
%%            true;
%%        PlayerOnline ->
%%            {ok, Bin} = pt_100:write(10008, {10, 1}),
%%            server_send:send_to_pid(PlayerOnline#ets_online.pid, Bin),
%%            timer:sleep(1000),
%%            ?CALL(PlayerOnline#ets_online.pid, stop),
%%
%%            timer:sleep(4000),
%%            false
%%    end.
