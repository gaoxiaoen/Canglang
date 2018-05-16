%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 六月 2017 14:07
%%%-------------------------------------------------------------------
-module(cross_scuffle).
-author("hxming").

-include("common.hrl").
-include("cross_scuffle.hrl").
-include("server.hrl").
-include("team.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("daily.hrl").
-include("skill.hrl").

%% API
-export([
    check_state/2,
    check_match_state/4,
    match_single/1,
    match_team/5,
    cancel_match/1,
    team_agree/3,
    crash_buff/7,
    scuffle_info/2,
    scuffle_quit/2,
    erase_scuffle_record/1
]).

-export([
    make_mb/2,
    check_team_state/1,
    get_revive/1,
    get_s_career/0,
    get_s_career_list/0,
    logout/1,
    do_logout/3,
    quit_team/2,
    do_quit_team/2,
    kill_mon/2,
    kill_role/3,
    do_kill_role/4,
    reward_msg/2,
    scuffle_reward/2,
    change_career/2,
    recover_hp/1,
    career2figure/2,
    filter_skill/1,
    acc_damage/1,
    sync_acc_damage/3
]).

%%查询活动状态
check_state(Node, Sid) ->
    ?CAST(cross_scuffle_proc:get_server_pid(), {check_state, Node, Sid}),
    ok.

%%获取匹配状态
check_match_state(Node, Pkey, Sid, Times) ->
    ?CAST(cross_scuffle_proc:get_server_pid(), {check_match_state, Node, Pkey, Sid, Times}),
    ok.

%%个人匹配
match_single(Mb) ->
    ?CAST(cross_scuffle_proc:get_server_pid(), {match_single, Mb}),
    ok.

%%小队匹配
match_team(Node, Pkey, Sid, TeamKey, MbList) ->
    ?CAST(cross_scuffle_proc:get_server_pid(), {match_team, Node, Pkey, Sid, TeamKey, MbList}),
    ok.

%%取消匹配
cancel_match(Pkey) ->
    ?CAST(cross_scuffle_proc:get_server_pid(), {cancel_match, Pkey}),
    ok.

%%小队匹配确认
team_agree(Pkey, TeamKey, IsAgree) ->
    case IsAgree of
        0 ->
            ?CAST(cross_scuffle_proc:get_server_pid(), {team_refuse, Pkey, TeamKey});
        _ ->
            ?CAST(cross_scuffle_proc:get_server_pid(), {team_agree, Pkey, TeamKey})
    end,
    ok.

%%活动统计
scuffle_info(Pkey, Copy) ->
    catch Copy ! {info, Pkey},
    ok.

%%退出
scuffle_quit(Pkey, Copy) ->
        catch Copy ! {quit, Pkey},
    ok.

%%buff碰撞
crash_buff(Node, Pid, Sid, Mkey, Copy, X, Y) ->
    Copy ! {crash_buff, Node, Pid, Sid, Mkey, X, Y},
    ok.

%%玩家离线
logout(Player) ->
    IsScuffleScene = scene:is_cross_scuffle_scene(Player#player.scene),
    if IsScuffleScene orelse Player#player.team_key /= 0 orelse Player#player.match_state == ?MATCH_STATE_CROSS_SCUFFLE ->
        cross_all:apply(cross_scuffle, do_logout, [Player#player.key, Player#player.team_key, Player#player.copy]);
        true ->
            ok
    end.

do_logout(Pkey, TeamKey, Copy) ->
    ?CAST(cross_scuffle_proc:get_server_pid(), {logout, Pkey, TeamKey, Copy}),
    ok.

%%玩家离队
quit_team(Pkey, TeamKey) ->
    cross_all:apply(cross_scuffle, do_quit_team, [Pkey, TeamKey]),
    ok.

do_quit_team(Pkey, TeamKey) ->
    ?CAST(cross_scuffle_proc:get_server_pid(), {quit_team, Pkey, TeamKey}),
    ok.


%%击杀玩家
kill_role(Player, Attacker, AccDamage) ->
    if Attacker#attacker.sign == ?SIGN_PLAYER ->
        cross_all:apply(cross_scuffle, do_kill_role, [Player#player.copy, Player#player.key, Attacker#attacker.key, AccDamage]);
        true ->
            skip
    end.

do_kill_role(Copy, DieKey, AttackKey, AccDamage) ->
        catch Copy ! {role_die, DieKey, AttackKey, AccDamage},
    ok.

%%怪物死亡
kill_mon(Mon, AttKey) ->
    case scene:is_cross_scuffle_scene(Mon#mon.scene) of
        false -> skip;
        true ->
                catch Mon#mon.copy ! {mon_die, Mon#mon.key, AttKey}
    end.

%%
make_mb(Player, TeamKey) ->
    #scuffle_mb{
        node = node(),
        sn = config:get_server_num(),
        pkey = Player#player.key,
        nickname = Player#player.nickname,
        pid = Player#player.pid,
        career = Player#player.career,
        sex = Player#player.sex,
        avatar = Player#player.avatar,
        team_key = TeamKey
    }.


%%检查队友状态
check_team_state(Player) ->
    TeamMbList = team_util:get_team_mbs(Player#player.team_key),
    case check_team_state_loop(TeamMbList, Player#player.key, []) of
        {true, MbList} ->
            Times = daily:get_count(?DAILY_CROSS_SCUFFLE_TIMES),
            Mb = make_mb(Player, Player#player.team_key),
            {true, [Mb#scuffle_mb{times = Times, is_agree = 1} | MbList]};
        {false, Err, Nickname} ->
            {false, Err, Nickname}
    end.

check_team_state_loop([], _LeaderKey, MbList) -> {true, MbList};
check_team_state_loop([Mb | T], LeaderKey, MbList) ->
    if Mb#t_mb.pkey == LeaderKey ->
        check_team_state_loop(T, LeaderKey, MbList);
        Mb#t_mb.is_online /= 1 ->
            {false, 10, Mb#t_mb.nickname};
        true ->
            case scene:is_normal_scene(Mb#t_mb.scene) of
                false -> {false, 11, Mb#t_mb.nickname};
                true ->
                    Times =
                        case ?CALL(Mb#t_mb.pid, get_scuffle_times) of
                            [] -> ?DAILY_CROSS_SCUFFLE_TIMES_LIM;
                            V -> V
                        end,
                    ScuffleMb = make_mb(#player{
                        key = Mb#t_mb.pkey,
                        nickname = Mb#t_mb.nickname,
                        pid = Mb#t_mb.pid,
                        career = Mb#t_mb.career,
                        sex = Mb#t_mb.sex,
                        avatar = Mb#t_mb.avatar
                    }, Mb#t_mb.team_key),
                    check_team_state_loop(T, LeaderKey, [ScuffleMb#scuffle_mb{times = Times} | MbList])
            end
    end.

%%获取复活/出生点
get_revive(Group) ->
    case data_cross_scuffle_revive:get_revive(Group) of
        [] ->
            Scene = data_scene:get(?SCENE_ID_CROSS_SCUFFLE),
            {Scene#scene.x, Scene#scene.y};
        ReviveList ->
            util:list_rand(ReviveList)
    end.

%%随机职业
get_s_career() ->
    case data_cross_scuffle_career:career_list() of
        [] -> 1;
        CareerList ->
            util:list_rand(CareerList)
    end.

get_s_career_list() ->
%%    [4,util:rand(1,6)].
    util:get_random_list(data_cross_scuffle_career:career_list(), 2).


career2figure(Career, Figure) ->
    case data_cross_scuffle_career:get(Career) of
        [] -> Figure;
        Base -> Base#base_scuffle_career.figure
    end.

filter_skill(SkillList) ->
    F = fun(SkillId, {L1, L2}) ->
        case data_skill:get(SkillId) of
            [] -> {L1, L2};
            Skill ->
                if Skill#skill.type == ?SKILL_TYPE_PASSIVE -> {L1, [{SkillId, ?PASSIVE_SKILL_TYPE_SCUFFLE} | L2]};
                    true ->
                        {[SkillId | L1], L2}
                end
        end
        end,
    lists:foldl(F, {[], []}, SkillList).

%%切换职业
change_career(Player, Career) ->
    Player1 = Player#player{figure = career2figure(Career, Player#player.figure), scuffle_state = true},
    Player2 = player_util:count_player_attribute(Player1, true),
    scene_agent_dispatch:figure(Player2),
    scene_agent_dispatch:attribute_update(Player2),
    scene_agent_dispatch:passive_skill(Player2, Player2#player.scuffle_passive_skill),
    cross_all:apply(cross_scuffle_play, change_career, [Player#player.key, Player#player.copy, Career]),
    Player2.

%%奖励发放
reward_msg(Pkey, GoodsList) ->
    ets:delete(?ETS_CROSS_SCUFFLE_RECORD, Pkey),
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] ->
%%            mail:sys_send_mail([Pkey], ?T("乱斗战场"), ?T("您参与了乱斗战场,获得奖励,请查收!"), GoodsList),
            ok;
        [Online] ->
            Online#ets_online.pid ! {scuffle_reward, GoodsList}
    end,
    ok.

erase_scuffle_record(Pkey) ->
    ets:delete(?ETS_CROSS_SCUFFLE_RECORD, Pkey),
    ok.

scuffle_reward(Player, GoodsList) ->
    GiveGoodList = goods:make_give_goods_list(265, GoodsList),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodList),
    daily:increment(?DAILY_CROSS_SCUFFLE_TIMES, 1),
    ets:delete(?ETS_CROSS_SCUFFLE_RECORD, Player#player.key),
    NewPlayer.

%%安全区回血
recover_hp(Player) ->
    if Player#player.scene /= ?SCENE_ID_CROSS_SCUFFLE -> Player;
        Player#player.hp >= Player#player.scuffle_attribute#attribute.hp_lim -> Player;
        true ->
            case scene_mark:is_safe({Player#player.scene, Player#player.x, Player#player.y}) of
                false -> Player;
                true ->
                    SafeGroup = ?IF_ELSE(Player#player.x < 26, 2, 1),
                    if Player#player.group == SafeGroup ->
                        Rhp = round(Player#player.scuffle_attribute#attribute.hp_lim * 0.25),
                        Hp = min(Player#player.scuffle_attribute#attribute.hp_lim, Player#player.hp + Rhp),
                        {ok, Bin} = pt_200:write(20004, {[[?SIGN_PLAYER, Player#player.key, 1, Rhp, Hp]]}),
                        server_send:send_to_sid(Player#player.sid, Bin),
                        Player2 = Player#player{hp = Hp},
                        scene_agent_dispatch:hpmp_update(Player2),
                        Player2;
                        true -> Player
                    end
            end
    end.

%%累计伤害同步
acc_damage(Player) ->
    if Player#player.scene /= ?SCENE_ID_CROSS_SCUFFLE -> Player;
        Player#player.acc_damage == 0 -> Player;
        true ->
            cross_all:apply(cross_scuffle, sync_acc_damage, [Player#player.copy, Player#player.key, Player#player.acc_damage]),
            Player#player{acc_damage = 0}
    end.

sync_acc_damage(Copy, Pkey, AccDamage) ->
        catch Copy ! {acc_damage, Pkey, AccDamage}.