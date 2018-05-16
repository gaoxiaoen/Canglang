%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 玩家战斗数据返回
%%% @end
%%% Created : 19. 八月 2015 下午7:44
%%%-------------------------------------------------------------------
-module(player_battle).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("task.hrl").
-include("skill.hrl").
-include("field_boss.hrl").
-include("daily.hrl").
-include("achieve.hrl").
-include("cross_dark_bribe.hrl").
%% API
-export([
    update_battle_info/2,
    update_battle_die/2,
    revive/3,
    conjure/1,
    unconjure/1,
    pk_change/3,
    pk_change_sys/3,
    kill_mon_exp/4
]).

-export([cmd_check_exp/0]).

%%更新战斗信息
update_battle_info(Player, {Hp, Mp, X, Y, IsMove, Sin, Speed, LongTime, TimeMark, _BuffList, KillList, SkillId, Damage}) when Player#player.sync_time < LongTime ->
    Player2 = handle_kill_list(KillList, Player),
    Attribute = Player#player.attribute,
    LongTime2 = util:longunixtime(),
    {NewX, NewY} = ?IF_ELSE(IsMove /= 0, {X, Y}, {Player#player.x, Player#player.y}),
    %%更新技能熟练度
    Player3 = skill:update_skill_exp(SkillId, Player2),
    BuffList = scene_agent_info:upgrade_buff_list(_BuffList, Player#player.buff_list),
    Player3#player{
        hp = Hp,
        mp = Mp,
        x = NewX,
        y = NewY,
        sin = Sin,
        time_mark = TimeMark,
        sync_time = LongTime2,
        buff_list = BuffList,
        attribute = Attribute#attribute{speed = Speed},
        acc_damage = Player#player.acc_damage + Damage
    };
update_battle_info(Player, _) -> Player.

handle_kill_list(KillList, Player) ->
    do_handle_kill_list(KillList, Player, 0).

%%处理击杀列表
do_handle_kill_list([], Player, AccMon) ->
    %%宝宝击杀
    ?DO_IF(AccMon > 0 andalso scene:is_normal_scene(Player#player.scene), baby:kill_mon(AccMon, Player)),
    Player;
do_handle_kill_list([[?SIGN_PLAYER, _PKey, _Mid] | L], Player, AccMon) ->
    do_handle_kill_list(L, Player, AccMon);
do_handle_kill_list([[?SIGN_MON, _Mkey, Mid] | L], Player, AccMon) ->
    case data_mon:get(Mid) of
        [] ->
            do_handle_kill_list(L, Player, AccMon);
        Mon ->
            {ok, Player1} = mon_photo:kill_mon(Player, Mon),
            Player2 =
                case data_evil:get(Mid) of
                    0 -> Player1;
                    Evil ->
                        prison:sub_evil(Player1, Evil)
                end,
            task_event:event(?TASK_ACT_MLV, {Mon#mon.lv}),
            ?DO_IF(Player#player.lv - Mon#mon.lv < 10, achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4017, 0, 1)),
            xian_upgrade:check_kill_mon(Mid),
            do_handle_kill_list(L, Player2, AccMon + 1)
    end.

%%击杀怪物获得经验
kill_mon_exp(Player, Mid, Mlv, Percent) ->
    case data_mon:get(Mid) of
        [] ->
            Player;
        Mon ->
            Lv = abs(Mon#mon.lv - Player#player.lv),
            ExpPer = data_exp_decay:get(Lv),
            IsDark = scene:is_cross_dark_blibe(Player#player.scene),
            BaseExp0 =
                case IsDark of
                    true ->
                        Lan = version:get_lan_config(),
                        DarkExp =
                            if
                                Lan == korea ->
                                    if
                                        Mlv >= 150 -> (0.0273 * math:pow(Mlv, 2) - 1.9484 * Mlv + 41.232) * Percent * 3;
                                        true -> (0.0273 * math:pow(Mlv, 2) - 1.9484 * Mlv + 41.232) * Percent
                                    end;
                                true ->
                                    (0.0273 * math:pow(Mlv, 2) - 1.9484 * Mlv + 41.232) * Percent
                            end,
                        Pk = Player#player.pk,
                        case Pk#pk.pk of
                            ?PK_TYPE_PEACE -> %%和平模式
                                util:floor(DarkExp / 3);
                            _ ->
                                util:floor(DarkExp)
                        end;
                    false ->
                        util:floor(Mon#mon.exp * Percent * ExpPer)
                end,
            BaseExp = max(1, BaseExp0), %%保底经验
            ExpSceneList = get_exp_scene(), %% 可加成场景
            %%组队情况下，有5%的经验加成
            TeamAdd = if Player#player.team_key == 0 -> 0;true -> 0.05 end,
            TeamAddExp = ?IF_ELSE(
                lists:member(Player#player.scene, ExpSceneList),
                util:floor(BaseExp * TeamAdd * (Player#player.team_num - 1)),
                0
            ),
            %%vip经验加成
            VipAddExp = ?IF_ELSE(
                lists:member(Player#player.scene, ExpSceneList),
                round(BaseExp * data_vip_args:get(5, Player#player.vip_lv) / 100),
                0
            ),
            %%经验加成
            FuwenExp = round(Player#player.attribute#attribute.exp_add * BaseExp / 100),
            IsField = scene:is_normal_scene(Player#player.scene),
            ?DO_IF(IsDark == true orelse IsField ==true, act_meet_limit:kill_mon(Player)),

            MoreExpReward = max(0, more_exp:get_reward(Player#player.lv) - 1),
            ActivityAddExp = ?IF_ELSE(IsField, util:floor(BaseExp * MoreExpReward), 0),%% 多倍经验加成
            BuffExp = util:floor(BaseExp * buff_init:exp_buff(Player)),
            SumExp0 = BaseExp + TeamAddExp + VipAddExp + ActivityAddExp + BuffExp + FuwenExp,
            WlvExp = ?IF_ELSE(IsField orelse IsDark, round(SumExp0 * Player#player.world_lv_add), 0),
            SumExp = SumExp0 + WlvExp,
            AddExpList = [[1, WlvExp], [2, TeamAddExp], [3, VipAddExp], [4, ActivityAddExp], [5, BuffExp], [6, FuwenExp]],
            ?DO_IF(IsField, more_exp:update(Player, SumExp)), %% 多倍经验更新
%%          ?DO_IF(SumExp > 20000, ?WARNING("mon exp ~p scene ~p mid ~p mlv ~p~n", [SumExp, Player#player.scene, Mid, Mlv])),
            player_util:add_exp(Player, SumExp, 0, AddExpList)
    end.

cmd_check_exp() ->
    F = fun(Mid) ->
        case data_mon:get(Mid) of
            [] -> ok;
            Mon ->
                if Mon#mon.exp > 10000 ->
                    ?DEBUG("mid ~p exp ~p~n", [Mid, Mon#mon.exp]);
                    true -> ok
                end
        end
    end,
    lists:foreach(F, lists:seq(1, 999999)),
    ok.

%%战斗死亡
update_battle_die(Player, {_Hp, Mp, X, Y, IsMove, LongTime, Attacker, Damage}) ->
    IsDungeonScene = scene:is_dungeon_scene(Player#player.scene),
    IsCrossBattlefieldScene = scene:is_cross_battlefield_scene(Player#player.scene),
    IsCrossEliteScene = scene:is_cross_elite_scene(Player#player.scene),
%%    IsCrossArenaScene = scene:is_cross_arena_scene(Player#player.scene),
%%    IsCrossWarScene = scene:is_cross_war_scene(Player#player.scene),
    IsCrossNormal = scene:is_cross_normal_scene(Player#player.scene),
    IsCrossSixDragon = scene:is_six_dragon_scene(Player#player.scene),
    IsNormalScene = scene:is_normal_scene(Player#player.scene),
    IsFieldBossScene = scene:is_field_boss_scene(Player#player.scene),
    IsCrossScuffleScene = scene:is_cross_scuffle_scene(Player#player.scene),
    IsCrossScuffleEliteScene = scene:is_cross_scuffle_elite_scene(Player#player.scene),
    IsCrossBossScene = scene:is_cross_boss_scene(Player#player.scene),
    ISCrossDarkScene = scene:is_cross_dark_blibe(Player#player.scene),
    IsCrossWarScene = scene:is_cross_war_scene(Player#player.scene),
    IsCross1vn = scene:is_cross_1vn_scene(Player#player.scene),
    %%击杀提示
    Gold = get_revive_gold(Player#player.key, Player#player.scene, LongTime),
    {S_Career, CareerList} =
        if
            IsCrossScuffleScene == true ->
                case data_cross_scuffle_career:figure2career(Attacker#attacker.figure) of
                    [] ->
                        {0, cross_scuffle:get_s_career_list()};
                    FigureCareer ->
                        {FigureCareer, cross_scuffle:get_s_career_list()}
                end;
            IsCrossScuffleEliteScene == true ->
                case data_cross_scuffle_elite_career:figure2career(Attacker#attacker.figure) of
                    [] ->
                        {0, cross_scuffle_elite:get_s_career_list()};
                    FigureCareer ->
                        {FigureCareer, cross_scuffle_elite:get_s_career_list()}
                end;
            true -> {0, []}
        end,

    {ok, BinDie} = pt_200:write(20011, {Attacker#attacker.key, Attacker#attacker.name, Gold, Attacker#attacker.sn, S_Career, CareerList}),
    server_send:send_to_sid(Player#player.sid, BinDie),
    if IsDungeonScene ->
        %%副本死亡
        Player#player.copy ! role_die;
        IsCrossBattlefieldScene ->
            cross_battlefield:role_die(Player#player.scene, Player#player.copy, Player#player.key, Attacker#attacker.key);
        IsCrossEliteScene ->
            cross_elite:role_die(Player#player.copy, Player#player.key);
%%        IsCrossArenaScene ->
%%            cross_arena_room:role_die(Player#player.copy);
        IsCrossSixDragon ->
            cross_six_dragon:role_die(Player#player.copy, Player#player.key, Attacker#attacker.key);
        IsCrossNormal andalso Attacker#attacker.sign == ?SIGN_PLAYER ->
            task_kill:check_die(Player, Attacker);
        IsNormalScene andalso Attacker#attacker.sign =/= ?SIGN_MON andalso Attacker#attacker.key =/= 0 -> %%野外被击杀
            spawn(fun() -> die_msg(Player, Attacker) end),
            manor_war:check_kill_role(Player, Attacker);
        IsFieldBossScene andalso Attacker#attacker.sign =/= ?SIGN_MON andalso Attacker#attacker.key =/= 0 ->
            spawn(fun() -> die_msg(Player, Attacker) end);
        IsCrossScuffleScene ->
            cross_scuffle:kill_role(Player, Attacker, Player#player.acc_damage + Damage);
        IsCrossScuffleEliteScene ->
            cross_scuffle_elite:kill_role(Player, Attacker, Player#player.acc_damage + Damage);
        IsCross1vn ->
            cross_1vn:kill_role(Player, Attacker, Player#player.acc_damage + Damage);
        IsCrossBossScene ->
            ?IF_ELSE(Attacker#attacker.sign =/= ?SIGN_MON, cross_boss:kill_player(Player, Attacker), skip),
            cross_boss:clean_cross_player(Player#player.key);
        IsCrossWarScene ->
            ?IF_ELSE(Attacker#attacker.sign =/= ?SIGN_MON, cross_area:war_apply(cross_war_battle, kill_player, [Player, Attacker]), skip);
        ISCrossDarkScene ->
            cross_dark_bribe:kill_player(Player, Attacker);
        true ->
            skip
    end,
    Player1 = ?IF_ELSE(Attacker#attacker.sign /= ?SIGN_MON, task_convoy:convoy_die(Player, Attacker), Player),
    if Attacker#attacker.sign /= ?SIGN_MON ->
%%            task_goods:role_die(Player, Attacker#attacker.pid),
        PlayerConvoy = task_convoy:convoy_die(Player, Attacker),
        PlayerConvoy;
        true -> Player
    end,
    TimeMark = Player1#player.time_mark,
    NewTimeMark = TimeMark#time_mark{ldt = LongTime div 1000},
    {NewX, NewY} = ?IF_ELSE(IsMove /= 0, {X, Y}, {Player#player.x, Player#player.y}),
    Player3 = prison:check_pk_value(Player1, Attacker),
    Player4 = buff:check_clean_buff(Player3),
    {ok, Player5} = player_evil:cancel_evil(Player4),
    NewPlayer = Player5,
    %%成就
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4001, 0, 1),
    NewPlayer#player{
        hp = 0,
        mp = Mp,
        x = NewX,
        y = NewY,
        sync_time = util:longunixtime(),
        time_mark = NewTimeMark,
        acc_damage = 0
    }.

%%死亡信息
die_msg(Player, Attacker) ->
    if Attacker#attacker.sign == ?SIGN_PLAYER ->
        if Attacker#attacker.gkey /= 0 ->
            {Title, Content} = t_mail:mail_content(80),
            Msg = io_lib:format(Content, [t_tv:cl(Attacker#attacker.gname, 1), t_tv:pn(#player{key = Attacker#attacker.key, nickname = Attacker#attacker.name, vip_lv = Attacker#attacker.vip})]);
            true ->
                {Title, Content} = t_mail:mail_content(81),
                Msg = io_lib:format(Content, [t_tv:pn(#player{key = Attacker#attacker.key, nickname = Attacker#attacker.name, vip_lv = Attacker#attacker.vip})])
        end,
        mail:sys_send_mail([Player#player.key], Title, Msg),
        {ok, Bin} = pt_490:write(49001, {[[0, Msg, [7]]]}),
        server_send:send_to_sid(Player#player.sid, Bin);
        true ->
            ok
    end.

%%复活
revive(Player, Rtype, S_Career) ->
    IsCrossBattlefieldScene = scene:is_cross_battlefield_scene(Player#player.scene),
    Now = util:unixtime(),
    case check_revive(Player, Rtype, IsCrossBattlefieldScene, Now) of
        {false, Code} ->
            {ok, BinRevive} = pt_200:write(20010, {Code, Rtype, Player#player.scene, Player#player.x, Player#player.y, Player#player.hp, Player#player.mp, Player#player.gold, Player#player.bgold, 0}),
            server_send:send_to_sid(Player#player.sid, BinRevive),
            Player;
        {ok, Player2} ->
            Player33 = ?IF_ELSE(Player2#player.scene =/= ?SCENE_ID_CROSS_SCUFFLE, Player2, cross_scuffle:change_career(Player2, S_Career)),
            Player3 = ?IF_ELSE(Player2#player.scene =/= ?SCENE_ID_CROSS_SCUFFLE_ELITE, Player33, cross_scuffle_elite:change_career(Player33, S_Career)),
            [NewHp, NewMp] =
                case Rtype of
                    0 ->
                        %%复活点复活
                        scene_agent_dispatch:hide(Player),
                        if Player3#player.scene == ?SCENE_ID_GUILD_WAR ->
                            [round(Player3#player.attribute#attribute.hp_lim * 0.2), round(Player3#player.attribute#attribute.mp_lim * 0.2)];
                            IsCrossBattlefieldScene orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_ONE orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_TWO orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_THREE orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_FOUR orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_FIVE ->
                                [round(Player3#player.attribute#attribute.hp_lim), round(Player3#player.attribute#attribute.mp_lim)];
                            Player#player.scene == ?SCENE_ID_CROSS_SCUFFLE ->
                                [round(Player3#player.scuffle_attribute#attribute.hp_lim), round(Player3#player.attribute#attribute.mp_lim)];
                            Player#player.scene == ?SCENE_ID_CROSS_SCUFFLE_ELITE ->
                                [round(Player3#player.scuffle_elite_attribute#attribute.hp_lim), round(Player3#player.attribute#attribute.mp_lim)];
                            Player3#player.scene == ?SCENE_ID_CROSS_ELITE ->
                                [round(Player3#player.attribute#attribute.hp_lim), round(Player3#player.attribute#attribute.mp_lim)];
                            Player3#player.scene == ?SCENE_ID_SIX_DRAGON_FIGHT ->
                                [round(Player3#player.attribute#attribute.hp_lim * 0.8), round(Player3#player.attribute#attribute.mp_lim * 0.8)];
                            Player3#player.scene == ?SCENE_ID_DUN_GUARD ->
                                [round(Player3#player.attribute#attribute.hp_lim * 0.7), round(Player3#player.attribute#attribute.mp_lim * 0.7)];
                            true ->
                                [round(Player3#player.attribute#attribute.hp_lim * 0.3), round(Player3#player.attribute#attribute.mp_lim * 0.3)]
                        end;
                    1 ->
                        [Player3#player.attribute#attribute.hp_lim, Player3#player.attribute#attribute.mp_lim];
                    2 ->
                        [Player3#player.attribute#attribute.hp_lim, Player3#player.attribute#attribute.mp_lim];
                    3 ->
                        [round(Player3#player.scuffle_elite_attribute#attribute.hp_lim), round(Player3#player.attribute#attribute.mp_lim)]
                end,
            %%复活保护时间
            Protect = 5,
            Player4 = Player3#player{hp = NewHp, mp = NewMp, time_mark = Player2#player.time_mark#time_mark{godt = Protect + Now}, enter_sid_time = Now},
            if Player#player.scene == Player4#player.scene ->
                scene_agent_dispatch:revive(Player4, Player4#player.x, Player4#player.y, Player4#player.hp, Player4#player.mp, Protect + Now, Player#player.show_golden_body);
                true ->
                    scene_agent_dispatch:leave_scene(Player),
                    %%跨场景复活
                    SceneData = data_scene:get(Player4#player.scene),
                    {ok, Bin} = pt_120:write(12005, {Player4#player.scene, Player4#player.x, Player3#player.y, SceneData#scene.sid, SceneData#scene.name}),
                    server_send:send_to_sid(Player4#player.sid, Bin)
            end,
            %%战场复活,触发无敌BUFF
            if
                IsCrossBattlefieldScene ->
                    cross_area:apply(cross_battlefield, check_layer, [Player4#player.key, Rtype]);
                true ->
                    skip
            end,
            {ok, BinRevive} = pt_200:write(20010, {1, Rtype, Player4#player.scene, Player4#player.x, Player4#player.y, NewHp, NewMp, Player3#player.gold, Player4#player.bgold, Protect}),
            server_send:send_to_sid(Player4#player.sid, BinRevive),
            Player4
    end.
%%revive(Player, Rtype) ->
%%    {ok, BinRevive} = pt_200:write(20010, {1, Rtype, Player#player.scene, Player#player.x, Player#player.y, Player#player.hp, Player#player.mp, Player#player.gold, Player#player.bgold, 0}),
%%    server_send:send_to_sid(Player#player.sid, BinRevive),
%%    Player.


%%获取复活费用
get_revive_gold(_Pkey, _SceneId, _Now) -> 10.

check_revive(Player, Rtype, IsCrossBattlefieldScene, _Now) ->
    Scene = data_scene:get(Player#player.scene),
    #scene{
        revive_type = ReviveType
    } = Scene,
    case Rtype of
        0 ->
            IsSixDragonScene = scene:is_six_dragon_scene(Player#player.scene),
            IsDarkScene = scene:is_cross_dark_blibe(Player#player.scene),
            if
                not(ReviveType == 1 orelse ReviveType == 2) ->
                    {false, 38};
                Player#player.convoy_state > 0 ->
                    {ok, Player};
                IsCrossBattlefieldScene ->
                    {X, Y} = cross_battlefield:get_revive(Player#player.cross_bf_layer),
                    {ok, Player#player{x = X, y = Y}};
                Player#player.scene == ?SCENE_ID_CROSS_BOSS_ONE orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_TWO orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_THREE orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_FOUR orelse Player#player.scene == ?SCENE_ID_CROSS_BOSS_FIVE->
                    cross_boss:clean_cross_player(Player#player.key),
                    LL = data_cross_boss_p_born:get(Player#player.scene),
                    {X, Y} = util:list_rand(LL),
                    {ok, Player#player{x = X, y = Y}};
                Player#player.scene == ?SCENE_ID_CROSS_WAR ->
                    {X, Y} = cross_war:get_revice(Player),
                    {ok, Player#player{x = X, y = Y}};
                Player#player.scene == ?SCENE_ID_CROSS_SCUFFLE ->
                    {X, Y} = cross_scuffle:get_revive(Player#player.group),
                    {ok, Player#player{x = X, y = Y}};
                Player#player.scene == ?SCENE_ID_CROSS_SCUFFLE_ELITE ->
                    {X, Y} = cross_scuffle_elite:get_revive(Player#player.group),
                    {ok, Player#player{x = X, y = Y}};
                IsSixDragonScene ->
                    {X, Y} = cross_six_dragon:get_fight_scene_xy(Player#player.group),
                    {ok, Player#player{x = X, y = Y}};
                IsDarkScene ->
                    #config_darak_bribe_scene_lv{xy = PoseList} = data_cross_dark_scene_lv:get(Player#player.scene),
                    {X, Y} = util:list_rand(PoseList),
                    {ok, Player#player{x = X, y = Y}};
                true ->
                    Scene = data_scene:get(Player#player.scene),
                    X = Scene#scene.x,
                    Y = Scene#scene.y,
                    {ok, Player#player{x = X, y = Y}}
            end;
        1 ->
            if
                not(ReviveType == 1 orelse ReviveType == 3) ->
                    {false, 38};
                true ->
                    case money:is_enough(Player, 10, gold) of
                        false ->
                            {false, 2};
                        true ->
                            NewPlayer = money:add_no_bind_gold(Player, -10, 63, 1007000, 1),
                            {ok, NewPlayer}
                    end
            end;
        2 ->
            GoodsId = 1007000,
            GoodsCount = goods_util:get_goods_count(GoodsId),
            if
                not(ReviveType == 1 orelse ReviveType == 3) ->
                    {false, 38};
                GoodsCount =< 0 -> {false, 37};
                true ->
                    goods:subtract_good(Player, [{GoodsId, 1}], 511),
                    {ok, Player}
            end;
        3 ->
            cross_scuffle_elite:situ_revive(Player#player.copy, Player#player.key),
            {ok, Player}
    end.


%%施法
conjure(Player) ->
    Now = util:unixtime(),
    {ok, Bin} = pt_200:write(20012, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player#player{conjure = Now}.
%%    Conjure = Player#player.conjure,
%%    Now = util:unixtime(),
%%    if
%%        Now - Conjure > 20 ->
%%            {ok, Bin} = pt_200:write(20012, {1}),
%%            server_send:send_to_sid(Player#player.sid, Bin),
%%            Player#player{conjure = Now};
%%        true ->
%%            Player
%%    end.

%%施法结束
unconjure(Player) ->
    {ok, Bin} = pt_200:write(20013, {1, Player#player.key}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player#player{conjure = 0}.
%%    Conjure = Player#player.conjure,
%%    if
%%        Conjure > 0 ->
%%            {ok, Bin} = pt_200:write(20013, {1, Player#player.key}),
%%            server_send:send_to_sid(Player#player.sid, Bin),
%%            Player#player{conjure = 0};
%%        true ->
%%            Player
%%    end.

%%pk状态修改
pk_change(Player, Pk, Type) ->
    PkSt = Player#player.pk,
    Now = util:unixtime(),
    if
        PkSt#pk.pk /= Pk ->
            case
            begin
                DataScene = data_scene:get(Player#player.scene),
                InPeaceScenes = lists:member(DataScene#scene.type, [?SCENE_TYPE_NORMAL, ?SCENE_TYPE_DUNGEON, ?SCENE_TYPE_CROSS_ANSWER, ?SCENE_TYPE_MARRY]),
                IsDark = scene:is_cross_dark_blibe(Player#player.scene),
                IsPk2 = lists:member(Pk, [?PK_TYPE_GUILD, ?PK_TYPE_SERVER]),
                if
                    DataScene#scene.pk_can_change == 0 ->
                        {err, 25};
                    DataScene#scene.sid =:= ?SCENE_ID_KINDOM_GUARD_ID ->
                        {err, 25};
                    Player#player.convoy_state > 0 ->
                        {err, 8};
                    Pk == ?PK_TYPE_PEACE andalso not InPeaceScenes ->
                        {err, 21};
                %% 和平魔宫不能切模式
                    IsDark andalso PkSt#pk.pk == ?PK_TYPE_PEACE andalso Pk /= ?PK_TYPE_PEACE ->
                        {err, 25};
                %% 杀戮魔宫模式限制
                    IsDark andalso (PkSt#pk.pk == ?PK_TYPE_GUILD orelse PkSt#pk.pk == ?PK_TYPE_SERVER)
                        andalso not IsPk2 ->
                        {err, 42};
                    Pk == ?PK_TYPE_PEACE andalso PkSt#pk.change_time + 600 < Now -> %切和平
                        {ok, PkSt#pk{pk = Pk, pk_old = Player#player.pk#pk.pk}};
                    Pk == ?PK_TYPE_PEACE ->
                        {fail, max(0, PkSt#pk.change_time + 600 - Now)};
                    PkSt#pk.pk == ?PK_TYPE_PEACE ->
                        {ok, PkSt#pk{pk = Pk, pk_old = Player#player.pk#pk.pk, change_time = Now}};
                    true ->
                        {ok, PkSt#pk{pk = Pk, pk_old = Player#player.pk#pk.pk}}

                end
            end
            of
                {ok, PkSt2} ->
                    {ok, Bin} = pt_200:write(20014, {Player#player.key, Pk, 0, 1}),
                    if Type == 1 -> server_send:send_to_sid(Player#player.sid, Bin);
                        true ->
                            server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin)
                    end,
                    Player1 =
                        case PkSt2#pk.protect_time > Now andalso Pk =/= ?PK_TYPE_PEACE of
                            true -> prison:del_protect(Player);
                            false -> Player
                        end,
                    Player1#player{pk = PkSt2};
                {fail, Time} ->
                    {ok, Bin} = pt_200:write(20014, {Player#player.key, PkSt#pk.pk, Time, 7}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    Player;
                {err, Err} ->
                    {ok, Bin} = pt_200:write(20014, {Player#player.key, PkSt#pk.pk, 0, Err}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    Player
            end;
        true ->
            Player
    end.

%%系统切换PK模式
pk_change_sys(Player, Pk, Type) ->
    PkSt = Player#player.pk,
    if
        PkSt#pk.pk /= Pk ->
            PkSt2 = PkSt#pk{pk = Pk, pk_old = Player#player.pk#pk.pk},
            {ok, Bin} = pt_200:write(20014, {Player#player.key, Pk, 0, 1}),
            if Type == 1 ->
                server_send:send_to_sid(Player#player.sid, Bin);
                true ->
                    server_send:send_to_scene(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Bin)
            end,
            NewPlayer = Player#player{pk = PkSt2},
            scene_agent_dispatch:pk_value(NewPlayer),
            NewPlayer;
        true ->
            Player
    end.


get_exp_scene() ->
    [10001, 10002, 10003, 10004, 10005, 10006, 10007, 10008, 13003, 60601, 60602, 60603, 60604,
        60605, 60606, 60607, 60608, 60609, 22001, 22002, 22003, 22004, 22005].


