%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十月 2017 18:05
%%%-------------------------------------------------------------------
-module(cross_scuffle_elite).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("relation.hrl").
-include("guild.hrl").
-include("cross_scuffle_elite.hrl").
-include("scene.hrl").
-include("daily.hrl").
-include("battle.hrl").
-include("skill.hrl").

-define(WIN, 1).
-define(LOSE, 2).

%% API
-export([
    check_state/2
    , get_invite_list/2
    , invite/2
    , get_info/3
    , check_team_state/1
    , match_team/5
    , get_s_career/0
    , scuffle_elite_quit/2
    , erase_scuffle_record/1
    , career2figure/2
    , get_revive/1
    , scuffle_reward/2
    , reward_msg/2
    , get_s_career_list/0
    , kill_role/3
    , do_kill_role/4
    , situ_revive/2
    , do_situ_revive/2
    , acc_damage/1
    , sync_acc_damage/3
    , recover_hp/1
    , change_career/2
    , filter_skill/1
    , scuffle_elite_info/2
    , logout/1
    , do_logout/3
    , quit_team/2
    , crash_buff/7
    , do_quit_team/2
    , get_local_player_list/2
    , check_enter_scuffle_ellite_wait_scene/1
    , get_wait_scene_xy/0
    , get_ready_info/2
    , get_war_map/2
    , final_war_reward/4
    , get_player_info/5
    , get_state/0
    , collect_count/1
    , get_local_player_list2/2
    , kill_mon/2
    , sendout_scene/1
    , get_final_key_list/0
    , get_final_list/0
    , final_mail/3
    , repair/0
    , repair_name/1
    , repair_name_1/3
    , tttest/0
    , get_bet_info/4
    , bet_war_team/6
    , get_bet_base/2
]).

get_state() ->
    ?CALL(cross_scuffle_elite_proc:get_server_pid(), get_scfflie_elite_state).

get_final_key_list() ->
    ?CALL(cross_scuffle_elite_proc:get_server_pid(), get_final_key_list).

get_final_list() ->
    ?CALL(cross_scuffle_elite_proc:get_server_pid(), get_final_list).

collect_count(Pkey) ->
    ?CALL(cross_scuffle_elite_proc:get_server_pid(), {collect_count, Pkey}).

%%查询活动状态
check_state(Node, Sid) ->
    ?CAST(cross_scuffle_elite_proc:get_server_pid(), {check_state, Node, Sid}),
    ok.

get_bet_info(Sid, Node, FightNum, Pkey) ->
    ?CAST(cross_scuffle_elite_proc:get_server_pid(), {get_bet_info, Node, Sid, FightNum, Pkey}),
    ok.

bet_war_team(Sid, Node, Pkey, FightNum, WtKey, Id) ->
    ?CALL(cross_scuffle_elite_proc:get_server_pid(), {bet_war_team, Node, Sid, Pkey, FightNum, WtKey, Id}).

%% 获取精英赛页面信息
get_info(Player, AllMember, WarTeam) ->
    F = fun(Role) ->
        get_player_info(Player, Role#wt_member.pkey, WarTeam#war_team.pkey, Role, node)
    end,
    RoleList = lists:map(F, AllMember),
    Data = {Player#player.match_state, Player#player.war_team#st_war_team.war_team_key, Player#player.war_team#st_war_team.war_team_name, WarTeam#war_team.score, WarTeam#war_team.rank, WarTeam#war_team.win, WarTeam#war_team.lose, RoleList},
    {ok, Bin} = pt_585:write(58502, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.


scuffle_elite_info(Pkey, Copy) ->
    catch Copy ! {info, Pkey},
    ok.
%%
%%  %%查看自己数据
%%  get_player_info(Player, Sn, Pkey) when Player#player.key =:= Pkey ->
%%     Data = player_pack:trans13013(Player, Sn),
%%     {ok, Bin} = pt_130:write(13013, Data),
%%     server_send:send_to_sid(Player#player.sid, Bin),
%%     ok;

get_player_info(Player, Pkey, LeaderKey, Role, _Node) when Player#player.key =:= Pkey ->
    trans58502(Player, Role, LeaderKey);

get_player_info(_Player0, Pkey, LeaderKey, Role, Node) ->
%%     case player_util:get_player(Pkey) of
%%         [] ->
    case shadow_proc:get_shadow(Pkey, Node) of
        Player when is_record(Player, player) ->
            trans58502(Player, Role, LeaderKey);
        Shadow ->
            ?PRINT("58502 error Player ~p ~n", [Shadow]),
            []
%%         Player ->
%%             trans58502(Player, Role)
    end.

get_role(RoleList) ->
    if
        RoleList == [] -> 0;
        true ->
            {Role, _Count} = hd(lists:reverse(lists:keysort(2, RoleList))),
            Role
    end.

trans58502(Player, Role, LeaderKey) ->
    [Player#player.key,
        ?IF_ELSE(LeaderKey == Player#player.key, ?WAR_TEAM_POSITION_CHAIRMAN, ?WAR_TEAM_POSITION_NORMAL),
        Player#player.nickname,
        Player#player.career,
        Player#player.sex,
        Player#player.avatar,
        Role#wt_member.count,
        Role#wt_member.kill,
        Role#wt_member.der,
        Role#wt_member.rank,
        get_role(Role#wt_member.use_role),
        Player#player.wing_id,
        Player#player.equip_figure#equip_figure.weapon_id,
        Player#player.equip_figure#equip_figure.clothing_id,
        Player#player.light_weaponid,
        Player#player.fashion#fashion_figure.fashion_cloth_id,
        Player#player.fashion#fashion_figure.fashion_head_id].

%%怪物死亡
kill_mon(Mon, AttKey) ->
    case scene:is_cross_scuffle_elite_scene(Mon#mon.scene) of
        false -> skip;
        true ->
            catch Mon#mon.copy ! {mon_die, Mon#mon.key, AttKey}
    end.

%%获取可邀请列表
get_invite_list(Player, Type) ->
    case Type of
        1 -> get_area_scene_list(Player); %% 附近
        2 -> get_friend_list(Player); %% 好友
        3 -> get_guild_list(Player) %% 仙盟
    end.


get_friend_list(Player) ->
    RelationsSt = lib_dict:get(?PROC_STATUS_RELATION),
    FriendList = RelationsSt#st_relation.friends,
    F = fun(Friend) ->
        case ets:lookup(?ETS_ONLINE, Friend#relation.pkey) of
            [] -> [];
            _ ->
                if
                    Friend#relation.pkey == Player#player.key -> [];
                    Friend#relation.lv < 65 andalso Friend#relation.lv /= 0 -> [];
                    true ->
                        Player1 = shadow_proc:get_shadow(Friend#relation.pkey),
                        [[Player1#player.key, Player1#player.nickname, Player1#player.cross_scuffle_elite#cross_scuffle_elite_info.rank]]
                end
        end
    end,
    lists:flatmap(F, FriendList).

get_guild_list(Player) ->
    case guild_ets:get_guild(Player#player.guild#st_guild.guild_key) of
        false -> [];
        _Guild ->
            MemberList = guild_ets:get_guild_member_list(Player#player.guild#st_guild.guild_key),
            F = fun(M) ->
                if
                    M#g_member.pkey == Player#player.key -> [];
                    M#g_member.lv < 65 andalso M#g_member.lv /= 0 -> [];
                    true ->
                        case ets:lookup(?ETS_ONLINE, M#g_member.pkey) of
                            [] -> [];
                            _ ->
                                Player1 = shadow_proc:get_shadow(M#g_member.pkey),
                                [[Player1#player.key, Player1#player.nickname, Player1#player.cross_scuffle_elite#cross_scuffle_elite_info.rank]]
                        end
                end
            end,
            lists:flatmap(F, MemberList)
    end.

get_area_scene_list(Player) ->
    KeyList = scene_agent:get_area_scene_pkeys(Player#player.scene, Player#player.copy, Player#player.x, Player#player.y),
    F = fun(Key) ->
        if
            Key == Player#player.key -> [];
            Player#player.lv < 65 andalso Player#player.lv /= 0 -> [];
            true ->
                Player1 = shadow_proc:get_shadow(Key),
                [[Player1#player.key, Player1#player.nickname, Player1#player.cross_scuffle_elite#cross_scuffle_elite_info.rank]]
        end
    end,
    lists:flatmap(F, KeyList).

%%退出
scuffle_elite_quit(Pkey, Copy) ->
    catch Copy ! {quit, Pkey},
    ok.

%%buff碰撞
crash_buff(Node, Pid, Sid, Mkey, Copy, X, Y) ->
    Copy ! {crash_buff, Node, Pid, Sid, Mkey, X, Y},
    ok.

invite(_Player, Key) ->
    case player_util:get_player(Key) of
        [] -> 17;
        OtherPlayer ->
            if
                OtherPlayer#player.war_team#st_war_team.war_team_key /= 0 ->
                    18;
                true ->
                    {ok, Bin} = pt_585:write(58507, {}),
                    server_send:send_to_sid(OtherPlayer#player.sid, Bin),
                    1
            end
    end.

%%检查队友状态
check_team_state(Player) ->
    TeamMbList = cross_all:apply_call(cross_scuffle_elite_war_team_ets, get_war_team_member_key_list, [Player#player.war_team#st_war_team.war_team_key]),
    Len = length(TeamMbList),
    if
        Len < 4 ->
            {false, 27, <<>>};
        true ->
            case check_team_state_loop(TeamMbList, Player#player.key, []) of
                {true, MbList} ->
                    Times = daily:get_count(?DAILY_CROSS_SCUFFLE_ELITE_TIMES),
                    Mb = make_mb(Player, Player#player.war_team#st_war_team.war_team_key),
                    {true, [Mb#scuffle_elite_mb{times = Times, is_agree = 1} | MbList]};
                {false, Err, Nickname} ->
                    {false, Err, Nickname}
%%             end
            end
    end.

check_team_state_loop([], _MyKey, MbList) -> {true, MbList};
check_team_state_loop([Key | T], MyKey, MbList) when Key == MyKey -> check_team_state_loop(T, MyKey, MbList);
check_team_state_loop([Key | T], _MyKey, MbList) ->
    case player_util:get_player(Key) of
        [] ->
            Name = shadow_proc:get_name(Key),
            {false, 26, Name};
        OtherPlayer ->
            case scene:is_normal_scene(OtherPlayer#player.scene) of
                false -> {false, 11, OtherPlayer#player.nickname};
                true ->
                    if
                        OtherPlayer#player.convoy_state /= 0 -> {false, 22, OtherPlayer#player.nickname};
                        true ->
                            ScuffleMb = make_mb(#player{
                                key = OtherPlayer#player.key,
                                nickname = OtherPlayer#player.nickname,
                                pid = OtherPlayer#player.pid,
                                career = OtherPlayer#player.career,
                                sex = OtherPlayer#player.sex,
                                avatar = OtherPlayer#player.avatar
                            }, OtherPlayer#player.war_team#st_war_team.war_team_key),
                            check_team_state_loop(T, _MyKey, [ScuffleMb | MbList])
                    end
            end
    end.

make_mb(Player, TeamKey) ->
    #scuffle_elite_mb{
        node = node(),
        sn = config:get_server_num(),
        pkey = Player#player.key,
        nickname = Player#player.nickname,
        pid = Player#player.pid,
        career = Player#player.career,
        sex = Player#player.sex,
        avatar = Player#player.avatar,
        time = Player#player.cross_scuffle_elite#cross_scuffle_elite_info.count,
        team_key = TeamKey,
        team_name = Player#player.war_team#st_war_team.war_team_name,
        position = Player#player.war_team#st_war_team.war_team_position
    }.

%%小队匹配
match_team(Node, Pkey, Sid, TeamKey, MbList) ->
    ?CAST(cross_scuffle_elite_proc:get_server_pid(), {match_team, Node, Pkey, Sid, TeamKey, MbList}),
    ok.

%%随机职业
get_s_career() ->
    case data_cross_scuffle_elite_career:career_list() of
        [] -> 1;
        CareerList ->
            util:list_rand(CareerList)
    end.

get_s_career_list() ->
%%    [4,util:rand(1,6)].
    util:get_random_list(data_cross_scuffle_elite_career:career_list(), 2).

career2figure(Career, Figure) ->
    case data_cross_scuffle_elite_career:get(Career) of
        [] -> Figure;
        Base -> Base#base_scuffle_elite_career.figure
    end.

erase_scuffle_record(Pkey) ->
    ets:delete(?ETS_CROSS_SCUFFLE_ELITE_RECORD, Pkey),
    ok.

%%获取复活/出生点
get_revive(Group) ->
    case data_cross_scuffle_elite_revive:get_revive(Group) of
        [] ->
            Scene = data_scene:get(?SCENE_ID_CROSS_SCUFFLE_ELITE),
            {Scene#scene.x, Scene#scene.y};
        ReviveList ->
            util:list_rand(ReviveList)
    end.

scuffle_reward(Player, GoodsList) ->
    GiveGoodList = goods:make_give_goods_list(313, GoodsList),
    {ok, NewPlayer} = goods:give_goods(Player, GiveGoodList),
    daily:increment(?DAILY_CROSS_SCUFFLE_ELITE_TIMES, 1),
    ets:delete(?ETS_CROSS_SCUFFLE_ELITE_RECORD, Player#player.key),
    NewPlayer.

%%奖励发放
reward_msg(Pkey, GoodsList) ->
    ets:delete(?ETS_CROSS_SCUFFLE_ELITE_RECORD, Pkey),
    case ets:lookup(?ETS_ONLINE, Pkey) of
        [] ->
%%            mail:sys_send_mail([Pkey], ?T("乱斗战场"), ?T("您参与了乱斗战场,获得奖励,请查收!"), GoodsList),
            ok;
        [Online] ->
            Online#ets_online.pid ! {scuffle_elite_reward, GoodsList}
    end,
    ok.

%%击杀玩家
kill_role(Player, Attacker, AccDamage) ->
    if Attacker#attacker.sign == ?SIGN_PLAYER ->
        cross_all:apply(cross_scuffle_elite, do_kill_role, [Player#player.copy, Player#player.key, Attacker#attacker.key, AccDamage]);
        true ->
            skip
    end.

do_kill_role(Copy, DieKey, AttackKey, AccDamage) ->
    catch Copy ! {role_die, DieKey, AttackKey, AccDamage},
    ok.

%%玩家原地复活
situ_revive(Copy, Pkey) ->
    cross_all:apply(cross_scuffle_elite, do_situ_revive, [Copy, Pkey]).

do_situ_revive(Copy, Pkey) ->
    catch Copy ! {situ_revive, Pkey},
    ok.


%%累计伤害同步
acc_damage(Player) ->
    if Player#player.scene /= ?SCENE_ID_CROSS_SCUFFLE_ELITE -> Player;
        Player#player.acc_damage == 0 -> Player;
        true ->
            cross_all:apply(cross_scuffle_elite, sync_acc_damage, [Player#player.copy, Player#player.key, Player#player.acc_damage]),
            Player#player{acc_damage = 0}
    end.

sync_acc_damage(Copy, Pkey, AccDamage) ->
    catch Copy ! {acc_damage, Pkey, AccDamage}.


%%安全区回血
recover_hp(Player) ->
    if Player#player.scene /= ?SCENE_ID_CROSS_SCUFFLE_ELITE -> Player;
        Player#player.hp >= Player#player.scuffle_elite_attribute#attribute.hp_lim -> Player;
        true ->
            case scene_mark:is_safe({Player#player.scene, Player#player.x, Player#player.y}) of
                false ->
                    Player;
                true ->
                    SafeGroup = ?IF_ELSE(Player#player.x < 26, 2, 1),
                    if Player#player.group == SafeGroup ->
                        Rhp = round(Player#player.scuffle_elite_attribute#attribute.hp_lim * 0.25),
                        Hp = min(Player#player.scuffle_elite_attribute#attribute.hp_lim, Player#player.hp + Rhp),
                        {ok, Bin} = pt_200:write(20004, {[[?SIGN_PLAYER, Player#player.key, 1, Rhp, Hp]]}),
                        server_send:send_to_sid(Player#player.sid, Bin),
                        Player2 = Player#player{hp = Hp},
                        scene_agent_dispatch:hpmp_update(Player2),
                        Player2;
                        true -> Player
                    end
            end
    end.

%%切换职业
change_career(Player, Career) ->
    cross_all:apply(cross_scuffle_elite_war_team_ets, war_final_member_update, [Player#player.key, [{use_role, Career}]]),
    Player1 = Player#player{figure = career2figure(Career, Player#player.figure), scuffle_elite_state = true},
    Player2 = player_util:count_player_attribute(Player1, true),
    scene_agent_dispatch:figure(Player2),
    scene_agent_dispatch:attribute_update(Player2),
    scene_agent_dispatch:passive_skill(Player2, Player2#player.scuffle_passive_skill),
    cross_all:apply(cross_scuffle_elite_play, change_career, [Player#player.key, Player#player.copy, Career]),
    Player2.

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

%%玩家离线
logout(Player) ->
    IsScuffleEliteScene = scene:is_cross_scuffle_elite_scene(Player#player.scene),
    if IsScuffleEliteScene orelse Player#player.war_team#st_war_team.war_team_key /= 0 orelse Player#player.match_state == ?MATCH_STATE_CROSS_SCUFFLE_ELITE ->
        cross_all:apply(cross_scuffle_elite, do_logout, [Player#player.key, Player#player.war_team#st_war_team.war_team_key, Player#player.copy]);
        true ->
            ok
    end.

do_logout(Pkey, TeamKey, Copy) ->
    ?CAST(cross_scuffle_elite_proc:get_server_pid(), {logout, Pkey, TeamKey, Copy}),
    ok.

%%玩家离队
quit_team(Pkey, TeamKey) ->
    cross_all:apply(cross_scuffle_elite, do_quit_team, [Pkey, TeamKey]),
    ok.

do_quit_team(Pkey, TeamKey) ->
    ?CAST(cross_scuffle_elite_proc:get_server_pid(), {quit_team, Pkey, TeamKey}),
    ok.

get_local_player_list([], MbList) -> {true, MbList};
get_local_player_list([Key | T], MbList) ->
    case player_util:get_player(Key) of
        [] ->
            Name = shadow_proc:get_name(Key),
            {false, 26, Name};
        OtherPlayer ->
            case scene:is_cross_scuffle_elite_ready_scene(OtherPlayer#player.scene) of
                false -> {false, 11, OtherPlayer#player.nickname};
                true ->
                    ScuffleMb = make_mb(#player{
                        key = OtherPlayer#player.key,
                        nickname = OtherPlayer#player.nickname,
                        pid = OtherPlayer#player.pid,
                        career = OtherPlayer#player.career,
                        sex = OtherPlayer#player.sex,
                        avatar = OtherPlayer#player.avatar
                    }, OtherPlayer#player.war_team#st_war_team.war_team_key),
                    get_local_player_list(T, [ScuffleMb | MbList])
            end
    end.

get_local_player_list2([], MbList) -> {true, MbList};
get_local_player_list2([Key | T], MbList) ->
    ?DEBUG("MbList ~p~n", [MbList]),
    ?DEBUG("Key ~p~n", [Key]),
    case player_util:get_player(Key) of
        [] ->
            ?DEBUG("[] ~n"),
            {true, MbList};
        OtherPlayer ->
            case scene:is_cross_scuffle_elite_ready_scene(OtherPlayer#player.scene) of
                false ->
                    ?DEBUG("false ~n"),
                    {true, MbList};
                true ->
                    ScuffleMb = make_mb(#player{
                        key = OtherPlayer#player.key,
                        nickname = OtherPlayer#player.nickname,
                        pid = OtherPlayer#player.pid,
                        career = OtherPlayer#player.career,
                        sex = OtherPlayer#player.sex,
                        avatar = OtherPlayer#player.avatar
                    }, OtherPlayer#player.war_team#st_war_team.war_team_key),
                    get_local_player_list2(T, [ScuffleMb | MbList])
            end
    end.


sendout_scene(Player) ->
    {State, _} = cross_all:apply_call(cross_scuffle_elite, get_state, []),
    if
        State == ?CROSS_SCUFFLE_ELITE_STATE_FAINAL_START ->
            {X, Y} = get_wait_scene_xy(),
            Copy = scene_copy_proc:get_scene_copy(?SCENE_ID_CROSS_SCUFFLE_ELITE_READY, 0),
            Player#player.pid ! {enter_dungeon_scene, ?SCENE_ID_CROSS_SCUFFLE_ELITE_READY, Copy, X, Y, 0},
            Player;
        true ->
            scene_change:change_scene_back(Player)
    end.

%%检查进入乱斗精英等待场景
check_enter_scuffle_ellite_wait_scene(_Player) ->
    get_wait_scene_xy().

%%后去进入等待场景xy
get_wait_scene_xy() ->
    L = [{8, 27}, {28, 27}, {18, 18}, {18, 37}, {18, 27}, {11, 20}, {24, 20}, {11, 34}, {25, 34}],
    util:list_rand(L).

get_ready_info(Sid, Node) ->
    ?CAST(cross_scuffle_elite_proc:get_server_pid(), {get_ready_info, Node, Sid}),
    ok.

get_war_map(Sid, Node) ->
    ?CAST(cross_scuffle_elite_proc:get_server_pid(), {get_war_map, Node, Sid}),
    ok.

final_war_reward(WinTeamKey, LoseTeamKey, _WinKey, FightNum) ->
    spawn(fun() -> final_mail(WinTeamKey, FightNum, ?WIN) end),%% 胜者
    spawn(fun() -> final_mail(LoseTeamKey, FightNum, ?LOSE) end), %% 败者
    ok.

%% Type 2输 1赢
final_mail(0, _, _) -> skip;
final_mail(TeamKey, FightNum, ?WIN) ->
    KeyList = cross_scuffle_elite_war_team_ets:get_war_team_member_key_list(TeamKey),
    WarTeam =
        case cross_scuffle_elite_war_team_ets:get_war_team(TeamKey) of
            false ->
                ?ERR("WinTeamKey ~p~n", [TeamKey]),
                #war_team{};
            Other -> Other
        end,
    {Title, Content} = t_mail:mail_content(get_mail_id(FightNum, ?WIN)),
    Reward =
        if FightNum == 15 ->
            Msg = io_lib:format(Content, [WarTeam#war_team.name]),
            spawn(fun() ->
                F = fun(Key, Str0) ->
                    Member = cross_scuffle_elite_war_team_ets:get_war_team_member(Key),
                    cross_scuffle_elite_log:log_final_war(WarTeam#war_team.wtkey, WarTeam#war_team.name, WarTeam#war_team.score, Member#wt_member.pkey, Member#wt_member.name, 1, util:unixtime()),
                    cross_scuffle_elite_war_team_ets:war_final_member_update(Key, [{rank, 1}]),
                    Str1 = io_lib:format(?T(" ~s "), [Member#wt_member.name]),
                    string:concat(Str0, Str1)
                end,
                NameStr = lists:foldl(F, "", KeyList),
                F1 = fun(Node) ->
                    center:apply(Node, notice_sys, add_notice, [cross_scuffle_elite_final_first, [WarTeam#war_team.sn, WarTeam#war_team.name, NameStr]])
                end,
                lists:foreach(F1, center:get_nodes())
            end),
            cross_scuffle_elite_war_team_ets:set_war_team(WarTeam#war_team{win = WarTeam#war_team.win + 1, rank = 1}),
            goods:pack_goods(data_cross_scuffle_elite_final_reward:get(1));
            true ->
                Msg = Content,
                []
        end,
    if
        WarTeam#war_team.sn == 0 -> skip;
        true ->
            center:apply_sn(WarTeam#war_team.sn, mail, sys_send_mail, [KeyList, Title, Msg, lists:reverse(Reward)])
    end,
    ok;

%% Type 2输 1赢
final_mail(TeamKey, FightNum, ?LOSE) ->
    KeyList = cross_scuffle_elite_war_team_ets:get_war_team_member_key_list(TeamKey),
    WarTeam =
        case cross_scuffle_elite_war_team_ets:get_war_team(TeamKey) of
            false ->
                ?ERR("WinTeamKey ~p~n", [TeamKey]),
                #war_team{};
            Other -> Other
        end,
    {Title, Content} = t_mail:mail_content(get_mail_id(FightNum, ?LOSE)),
    Reward = goods:pack_goods(data_cross_scuffle_elite_final_reward:get(get_id(FightNum))),
    F1 = fun(Key1) ->
        Member = cross_scuffle_elite_war_team_ets:get_war_team_member(Key1),
        cross_scuffle_elite_log:log_final_war(WarTeam#war_team.wtkey, WarTeam#war_team.name, WarTeam#war_team.score, Member#wt_member.pkey, Member#wt_member.name, get_circle_num(FightNum), util:unixtime()),
        cross_scuffle_elite_war_team_ets:war_final_member_update(Key1, [{rank, get_circle_num(FightNum)}])
    end,
    lists:foreach(F1, KeyList),
    cross_scuffle_elite_war_team_ets:set_war_team(WarTeam#war_team{lose = WarTeam#war_team.lose + 1, rank = get_circle_num(FightNum)}),
    if
        WarTeam#war_team.sn == 0 -> skip;
        true ->
            center:apply_sn(WarTeam#war_team.sn, mail, sys_send_mail, [KeyList, Title, Content, lists:reverse(Reward)])
    end,
    ok.

get_mail_id(FightNum, ?WIN) when FightNum =< 8 andalso FightNum >= 1 -> 139;
get_mail_id(FightNum, ?WIN) when FightNum =< 12 andalso FightNum >= 9 -> 141;
get_mail_id(FightNum, ?WIN) when FightNum =< 14 andalso FightNum >= 13 -> 143;
get_mail_id(FightNum, ?WIN) when FightNum == 15 -> 145;
get_mail_id(FightNum, ?LOSE) when FightNum =< 8 andalso FightNum >= 1 -> 138;
get_mail_id(FightNum, ?LOSE) when FightNum =< 12 andalso FightNum >= 9 -> 140;
get_mail_id(FightNum, ?LOSE) when FightNum =< 14 andalso FightNum >= 13 -> 142;
get_mail_id(FightNum, ?LOSE) when FightNum == 15 -> 144;
get_mail_id(_FightNum, _Type) ->
    ?ERR("_FightNum ~p // _Type ~p~n", [_FightNum, _Type]),
    0.

get_circle_num(FightNum) when FightNum =< 8 andalso FightNum >= 1 -> 16;
get_circle_num(FightNum) when FightNum =< 12 andalso FightNum >= 9 -> 8;
get_circle_num(FightNum) when FightNum =< 14 andalso FightNum >= 13 -> 4;
get_circle_num(FightNum) when FightNum =< 15 andalso FightNum >= 14 -> 2;
get_circle_num(_FightNum) ->
    ?ERR("_FightNum ~p~n", [_FightNum]),
    16.

get_id(FightNum) when FightNum =< 8 andalso FightNum >= 1 -> 5;
get_id(FightNum) when FightNum =< 12 andalso FightNum >= 9 -> 4;
get_id(FightNum) when FightNum =< 14 andalso FightNum >= 13 -> 3;
get_id(FightNum) when FightNum == 15 -> 2;
get_id(_FightNum) ->
    ?ERR("_FightNum ~p~n", [_FightNum]),
    8.

repair() ->
    AllWarTeam = cross_scuffle_elite_war_team_ets:get_all_war_team(),
    F = fun(WarTeam) ->
        KeyList = cross_scuffle_elite_war_team_ets:get_war_team_member_key_list(WarTeam#war_team.wtkey),
        Len = length(KeyList),
        if
            Len == 0 ->
                ?DEBUG("wtkey ~p~n", [WarTeam#war_team.wtkey]),
                cross_scuffle_elite_war_team_ets:del_war_team(WarTeam#war_team.wtkey),
                cross_scuffle_elite_load:del_war_team(WarTeam#war_team.wtkey);
            WarTeam#war_team.num == Len -> skip;
            true ->
                ?DEBUG("wtkey ~p~n", [WarTeam#war_team.wtkey]),
                cross_scuffle_elite_war_team_ets:set_war_team(WarTeam#war_team{num = Len}),
                cross_scuffle_elite_load:replace_war_team(WarTeam#war_team{num = Len})
        end
    end,
    lists:foreach(F, AllWarTeam),
    ok.

repair_name(Player) ->
    cross_all:apply(cross_scuffle_elite, repair_name_1, [Player#player.key, Player#player.nickname, Player#player.sn_cur]),
    ok.

repair_name_1(Pkey, Pname, Sn) ->
    case cross_scuffle_elite_war_team_ets:get_war_team_member(Pkey) of
        false -> skip;
        Member ->
            if
                Pname == Member#wt_member.name -> skip;
                true ->
                    cross_scuffle_elite_war_team_ets:set_war_team_member(Member#wt_member{name = Pname, is_change = 1})
            end,
            case cross_scuffle_elite_war_team_ets:get_war_team(Member#wt_member.wtkey) of
                false -> skip;
                WarTeam ->
                    if
                        WarTeam#war_team.sn /= Sn ->
                            NewWarTeam = WarTeam#war_team{sn = Sn},
                            NewWarTeam1 = ?IF_ELSE(WarTeam#war_team.pkey == Pkey, NewWarTeam#war_team{pname = Pname}, NewWarTeam),
                            cross_scuffle_elite_war_team_ets:set_war_team(NewWarTeam1);
                        true ->
                            if
                                WarTeam#war_team.pkey == Pkey andalso Pname /= WarTeam#war_team.pname ->
                                    cross_scuffle_elite_war_team_ets:set_war_team(WarTeam#war_team{pname = Pname});
                                true -> skip
                            end
                    end
            end
    end,
    ok.

tttest() ->
    PlayerList = scene_agent:get_scene_player(12007),
    F = fun(ScenePlayer) ->
        ?DEBUG("ScenePlayer ~p~n", [ScenePlayer#scene_player.hp]),
        ?DEBUG("ScenePlayer ~p~n", [ScenePlayer#scene_player.attribute#attribute.hp_lim])
    end,
    lists:foreach(F, PlayerList),
    ok.

get_bet_base(FightNum, Id) ->
    if
        FightNum == 15 ->
            BaseList = data_cross_scuffle_elite_bet:get(1),
            case lists:keyfind(Id, #base_cross_scuffle_elite_bet.id, BaseList) of
                false -> #base_cross_scuffle_elite_bet{};
                Base -> Base
            end;
        true ->
            BaseList = data_cross_scuffle_elite_bet:get(2),
            case lists:keyfind(Id, #base_cross_scuffle_elite_bet.id, BaseList) of
                false -> #base_cross_scuffle_elite_bet{};
                Base -> Base
            end
    end.

