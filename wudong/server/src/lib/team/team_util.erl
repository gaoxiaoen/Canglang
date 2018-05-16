%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. 十一月 2015 11:44
%%%-------------------------------------------------------------------
-module(team_util).
-author("hxming").

-include("server.hrl").
-include("team.hrl").
-include("common.hrl").
-include("scene.hrl").
-include("relation.hrl").

%% API
-compile(export_all).

%%创建队伍
create_team(Player) ->
    TeamKey = misc:unique_key(),
    Copy = ?IF_ELSE(is_integer(Player#player.copy), Player#player.copy + 1, 1),
    Mb = #t_mb{
        pkey = Player#player.key,
        sn_cur = Player#player.sn_cur,
        nickname = Player#player.nickname,
        pid = Player#player.pid,
        career = Player#player.career,
        lv = Player#player.lv,
        realm = Player#player.realm,
        vip = Player#player.vip_lv,
        power = Player#player.cbp,
        join_time = util:unixtime(),
        is_online = 1,
        team_leader = 1,
        team_key = TeamKey,
        scene = Player#player.scene,
        copy = Copy,
        x = Player#player.x,
        y = Player#player.y,
        hp = Player#player.hp,
        hp_lim = Player#player.attribute#attribute.hp_lim,
        fashion_cloth_id = Player#player.fashion#fashion_figure.fashion_cloth_id,
        light_weaponid = Player#player.light_weaponid,
        wing_id = Player#player.wing_id,
        clothing_id = Player#player.equip_figure#equip_figure.clothing_id,
        weapon_id = Player#player.equip_figure#equip_figure.weapon_id,
        pet_type_id = Player#player.pet#fpet.type_id,
        pet_figure = Player#player.pet#fpet.figure,
        pet_name = Player#player.pet#fpet.name,
        avatar = Player#player.avatar,
        guild_name = Player#player.guild#st_guild.guild_name,
        head_id = Player#player.fashion#fashion_figure.fashion_head_id,
        sex = Player#player.sex
    },
    {ok, TeamPid} = team:start(Mb),
    NewPlayer = Player#player{team_key = TeamKey, team = TeamPid, team_leader = 1},
    refresh_team(TeamKey),
    NewPlayer.


%%获取场景队伍列表
get_scene_team(Scene, Copy, Node) ->
    TeamKeyList = scene_agent:get_scene_team(Scene, Copy, Node),
    SortList = scene_team_bag(TeamKeyList),
    [tuple_to_list(Item) || Item <- SortList].

%%场景队伍信息
scene_team_bag(TeamKeyList) ->
    F = fun(Key) ->
        case get_team(Key) of
            false -> [];
            Team ->
                if Team#team.num >= ?TEAM_MAX_NUM -> [];
                    true ->
                        case get_team_mb(Team#team.pkey) of
                            false -> [];
                            Mb ->
                                [{Team#team.key, Team#team.name, Team#team.pkey, Mb#t_mb.career,
                                    Mb#t_mb.lv, Mb#t_mb.power, Team#team.num, ?TEAM_MAX_NUM, Mb#t_mb.avatar, Mb#t_mb.guild_name}]
                        end
                end
        end
    end,
    TeamList = lists:flatmap(F, TeamKeyList),
    lists:keysort(5, TeamList).


%%获取无队伍玩家
get_scene_not_team(Player, Type, Scene, Copy, Node) ->
    OpenLv = ?TEAM_LIM_LV,
    KeyList =
        case Type of
            0 -> %% 附近玩家
                scene_agent:get_scene_not_team(Scene, Copy, Node, OpenLv);
            1 -> %% 好友
                relation:get_friend_info_list_for_team(OpenLv);
            2 -> %% 仙盟
                guild_util:get_member_for_team(Player#player.guild#st_guild.guild_key, OpenLv);
            _ -> []
        end,
    NewKeyList0 = util:list_unique(KeyList),
    NewKeyList1 = lists:delete(Player#player.key, NewKeyList0),%% 去除自身
    player_bag(NewKeyList1).

%%无队伍玩家信息
player_bag(KeyList) ->
    F = fun(Key) ->
        case player_util:get_player(Key) of
            [] -> [];
            Player ->
                if Player#player.team_key == 0 ->
                    [[
                        Player#player.key,
                        Player#player.nickname,
                        Player#player.vip_lv,
                        Player#player.lv,
                        Player#player.cbp,
                        Player#player.avatar,
                        Player#player.guild#st_guild.guild_name,
                        Player#player.sex
                    ]];
                    true -> []
                end
        end
    end,
    lists:flatmap(F, KeyList).

%%跨服场景队伍信息
get_cross_scene_team(Node, Sid, Scene, Copy) ->
    TeamList = scene_agent:get_scene_team(Scene, Copy, Node),
    center:apply(Node, team_util, cross_team_ret, [Sid, TeamList]),
    ok.

%%跨服场景无队伍玩家信息
get_cross_scene_not_team(Node, Sid, Scene, Copy, Lv) ->
    KeyList = scene_agent:get_scene_not_team(Scene, Copy, Node, Lv),
    center:apply(Node, team_util, cross_not_team_ret, [Sid, KeyList]),
    ok.

%%跨服队伍结果
cross_team_ret(Sid, TeamKeyList) ->
    SortList = scene_team_bag(TeamKeyList),
    {ok, Bin} = pt_220:write(22001, {[tuple_to_list(Item) || Item <- SortList]}),
    catch server_send:send_to_sid(Sid, Bin).

%%跨服无队伍玩家结果
cross_not_team_ret(Sid, KeyList) ->
    PlayerInfo = player_bag(KeyList),
    {ok, Bin} = pt_220:write(22012, {PlayerInfo}),
    catch server_send:send_to_sid(Sid, Bin).


%%加入队伍
enter_team(Player, Team) ->
    NewTeam = Team#team{num = Team#team.num + 1},
    set_team(NewTeam),
    Copy = ?IF_ELSE(is_integer(Player#player.copy), Player#player.copy + 1, 1),
    Mb = #t_mb{
        pkey = Player#player.key,
        sn_cur = Player#player.sn_cur,
        join_time = util:unixtime(),
        nickname = Player#player.nickname,
        pid = Player#player.pid,
        career = Player#player.career,
        lv = Player#player.lv,
        realm = Player#player.realm,
        vip = Player#player.vip_lv,
        power = Player#player.cbp,
        team_key = Team#team.key,
        team_pid = Team#team.pid,
        is_online = 1,
        scene = Player#player.scene,
        copy = Copy,
        x = Player#player.x,
        y = Player#player.y,
        hp = Player#player.hp,
        hp_lim = Player#player.attribute#attribute.hp_lim,
        fashion_cloth_id = Player#player.fashion#fashion_figure.fashion_cloth_id,
        light_weaponid = Player#player.light_weaponid,
        wing_id = Player#player.wing_id,
        clothing_id = Player#player.equip_figure#equip_figure.clothing_id,
        weapon_id = Player#player.equip_figure#equip_figure.weapon_id,
        pet_type_id = Player#player.pet#fpet.type_id,
        pet_figure = Player#player.pet#fpet.figure,
        pet_name = Player#player.pet#fpet.name,
        avatar = Player#player.avatar,
        guild_name = Player#player.guild#st_guild.guild_name,
        head_id = Player#player.fashion#fashion_figure.fashion_head_id,
        sex = Player#player.sex
    },
    set_team_mb(Mb),
    refresh_team(Team#team.key),
    NewPlayer = Player#player{team_key = Team#team.key, team = Team#team.pid},
    team_util:update_team_player(NewPlayer#player.team_key, ?JOIN_TEAM, NewPlayer#player.key, NewPlayer#player.nickname),
    NewPlayer.

%%离开队伍
leave_team(Player) ->
    team_util:update_team_player(Player#player.team_key, ?QUIT_TEAM, Player#player.key, Player#player.nickname),
    case get_team(Player#player.team_key) of
        false ->
            erase_team_mb(Player#player.key);
        Team ->
            do_leave_team(Player#player.key, Team)
    end,
    Player#player{team = undefined, team_key = 0, team_leader = 0}.

do_leave_team(Pkey, Team) ->
    erase_team_mb(Pkey),
    if Team#team.num == 1 ->
        %%一人的队伍
        team:stop(Team#team.pid);
        true ->
            %%队长离队，换队长
            if Team#team.pkey == Pkey ->
                Mbs = get_team_mbs(Team#team.key),
                case [Mb || Mb <- Mbs, Mb#t_mb.is_online == 1, Mb#t_mb.pkey /= Pkey] of
                    [] ->
                        %%没人了，解散队伍
                        team:stop(Team#team.pid);
                    NewMbs ->
                        %%按照入队先后任下一个队长
                        LMb = hd(lists:keysort(#t_mb.join_time, NewMbs)),
                        NewLMb = LMb#t_mb{team_leader = 1},
                        set_team_mb(NewLMb),
                        catch NewLMb#t_mb.pid ! {update_team, Team#team.key, Team#team.pid, 1},
                        NewTeam = Team#team{pkey = NewLMb#t_mb.pkey, name = team_name(NewLMb#t_mb.nickname), num = Team#team.num - 1},
                        set_team(NewTeam),
                        refresh_team(Team#team.key)
                end;
                true ->
                    NewTeam = Team#team{num = Team#team.num - 1},
                    set_team(NewTeam),
                    refresh_team(Team#team.key)
            end
    end.


%%踢出队伍
kickout_team(Team, Mb) ->
    team_util:update_team_player(Mb#t_mb.team_key, ?KICK_TEAM, Mb#t_mb.pkey, Mb#t_mb.nickname),
    erase_team_mb(Mb#t_mb.pkey),
    if Mb#t_mb.is_online == 1 ->
        Mb#t_mb.pid ! {update_team, 0, undefined, 0};
        true -> skip
    end,
    NewTeam = Team#team{num = Team#team.num - 1},
    set_team(NewTeam),
    refresh_team(Team#team.key),
    ok.

%%转让队长
change_leader(Team, OldLeader, NewLeader) ->
    OldLeader1 = OldLeader#t_mb{team_leader = 0},
    set_team_mb(OldLeader1),
    NewLeader1 = NewLeader#t_mb{team_leader = 1},
    set_team_mb(NewLeader1),
    NewTeam = Team#team{pkey = NewLeader#t_mb.pkey, name = team_name(NewLeader#t_mb.nickname)},
    set_team(NewTeam),
    catch NewLeader#t_mb.pid ! {update_team, Team#team.key, Team#team.pid, 1},
    refresh_team(Team#team.key),
    ok.

%%玩家下线
logout(Pkey, NowTime, Player) ->
    case get_team_mb(Pkey) of
        false ->
            skip;
        Mb ->
            NewMb = Mb#t_mb{logout_time = NowTime, is_online = 0},
            team_util:set_team_mb(NewMb),
            ?CAST(Player#player.team, {player_logout, Player})
    end,
    ok.

%%玩家下线
logout111(Team, Pkey, _NowTime) ->
    if Team#team.num == 1 ->
        %%一人的队伍
        team:stop(Team#team.pid);
        true ->
            %%队长下线，换队长
            if Team#team.pkey == Pkey ->
                Mbs = get_team_mbs(Team#team.key),
                case [Mb || Mb <- Mbs, Mb#t_mb.is_online == 1, Mb#t_mb.pkey /= Pkey] of
                    [] ->
                        %%没人了，解散队伍
                        team:stop(Team#team.pid);
                    NewMbs ->
                        %%按照入队先后任下一个队长
                        LMb = hd(lists:keysort(#t_mb.join_time, NewMbs)),
                        NewLMb = LMb#t_mb{team_leader = 1},
                        catch NewLMb#t_mb.pid ! {update_team, Team#team.key, Team#team.pid, 1},
                        set_team_mb(NewLMb),
                        NewTeam = Team#team{pkey = NewLMb#t_mb.pkey, name = team_name(NewLMb#t_mb.nickname), num = Team#team.num - 1},
                        set_team(NewTeam),
                        erase_team_mb(Pkey),
                        refresh_team(Team#team.key)
                end;
                true ->
                    erase_team_mb(Pkey),
                    NewTeam = Team#team{num = Team#team.num - 1},
                    set_team(NewTeam),
                    refresh_team(Team#team.key)
            end
    end.


team_name(Name) ->
    io_lib:format(?T("~s"), [Name]).
%% io_lib:format(?T("~s的队伍"), [Name]).


%%根据队伍PID获取队伍KEY
get_team_key_by_pid(TeamPid) ->
    case get_team_by_pid(TeamPid) of
        false -> 0;
        Team -> Team#team.key
    end.

%%更新队伍成员信息
refresh_team(TeamKey) ->
    Mbs = get_team_mbs(TeamKey),
    MbList = pack_team_mb_list(Mbs),
    {ok, Bin} = pt_220:write(22003, {MbList}),
    F = fun(Mb) ->
        if Mb#t_mb.is_online == 1 ->
            server_send:send_to_pid(Mb#t_mb.pid, Bin);
            true -> skip
        end
    end,
    Team = get_team(TeamKey),
    erlang:send_after(2 * 1000, Team#team.pid, {update_team_num}),
    lists:foreach(F, Mbs).


%%更新队伍成员信息
refresh_team(TeamKey, Pkey) ->
    Mbs = get_team_mbs(TeamKey),
    MbList = pack_team_mb_list(Mbs),
    {ok, Bin} = pt_220:write(22003, {MbList}),
    F = fun(Mb) ->
        if Mb#t_mb.is_online == 1 andalso Mb#t_mb.pkey /= Pkey ->
            server_send:send_to_pid(Mb#t_mb.pid, Bin);
            true -> skip
        end
    end,
    Team = get_team(TeamKey),
    erlang:send_after(2 * 1000, Team#team.pid, {update_team_num}),
    lists:foreach(F, Mbs).

%%成员变更
update_team_player(TeamKey, Code, Pkey, Pname) ->
    Mbs = get_team_mbs(TeamKey),
    {ok, Bin22018} = pt_220:write(22018, {Code, Pkey, Pname}),
    F = fun(Mb) ->
        if Mb#t_mb.is_online == 1 ->
            server_send:send_to_pid(Mb#t_mb.pid, Bin22018);
            true -> skip
        end
    end,
    lists:foreach(F, Mbs).

%%成员等级变更
update_player_lv(NewPlayer) ->
    case get_team_mb(NewPlayer#player.key) of
        false ->
            skip;
        Mbs ->
            NewMbs = Mbs#t_mb{lv = NewPlayer#player.lv},
            set_team_mb(NewMbs),
            refresh_team(NewPlayer#player.team_key, NewPlayer#player.key)
    end,
    ok.

pack_team_mb_list(Mbs) ->
    [[
        Mb#t_mb.pkey
        , Mb#t_mb.sn_cur
        , Mb#t_mb.nickname
        , Mb#t_mb.realm
        , Mb#t_mb.career
        , Mb#t_mb.power
        , Mb#t_mb.lv
        , Mb#t_mb.guild_name
        , Mb#t_mb.vip
        , Mb#t_mb.team_leader
        , Mb#t_mb.is_online
        , Mb#t_mb.scene
        , Mb#t_mb.copy
        , Mb#t_mb.x
        , Mb#t_mb.y
        , Mb#t_mb.hp
        , Mb#t_mb.hp_lim
        , Mb#t_mb.fashion_cloth_id
        , Mb#t_mb.light_weaponid
        , Mb#t_mb.wing_id
        , Mb#t_mb.clothing_id
        , Mb#t_mb.weapon_id
        , Mb#t_mb.pet_type_id
        , Mb#t_mb.pet_figure
        , Mb#t_mb.pet_name
        , Mb#t_mb.avatar
        , Mb#t_mb.head_id
        , Mb#t_mb.sex
    ]
        || Mb <- Mbs].

%%获取队伍在线成员PID
get_team_mb_pids(TeamKey) ->
    Mbs = get_team_mbs(TeamKey),
    [Mb#t_mb.pid || Mb <- Mbs, Mb#t_mb.is_online == 1].

%%检查是否在队伍中
in_team(TeamPid, Pkey) ->
    case get_team_mbs(TeamPid) of
        [] -> false;
        Mbs ->
            lists:keymember(Pkey, #t_mb.pkey, Mbs)
    end.

%%队伍广播我的位置
broadcast_position(Player, Now) ->
    if Player#player.team_key == 0 -> skip;
        true ->
            Key = broadcast_position_to_team,
            case get(Key) of
                undefined ->
                    put(Key, Now),
                    position(Player);
                Time ->
                    case Now - Time >= 3 of
                        true ->
                            put(Key, Now),
                            position(Player);
                        false -> false
                    end
            end
    end.
broadcast_position(Player) ->
    if Player#player.team_key == 0 -> skip;
        true ->
            position(Player)
    end.

position(Player) ->
    catch Player#player.team ! {position, Player#player.key, Player#player.scene, Player#player.copy, Player#player.x, Player#player.y, Player#player.hp, Player#player.attribute#attribute.hp_lim}.

%%============================team ets==============================
%%获取队伍
get_team(Key) ->
    case ets:lookup(?ETS_TEAM, Key) of
        [] -> false;
        [Team] -> Team
    end.

get_team_by_pid(TeamPid) ->
    case ets:match_object(?ETS_TEAM, #team{pid = TeamPid, _ = '_'}) of
        [] -> false;
        [Team | _] ->
            Team
    end.

%%存储队伍
set_team(Team) ->
    if Team#team.key /= 0 ->
        ets:insert(?ETS_TEAM, Team);
        true -> skip
    end.

%%清除队伍
erase_team(Key) ->
    ets:delete(?ETS_TEAM, Key).

%%获取队伍成员
get_team_mb(Pkey) ->
    case ets:lookup(?ETS_TEAM_MB, Pkey) of
        [] -> false;
        [Mb] -> Mb
    end.

%%获取队伍成员列表
get_team_mbs(TeamKey) ->
    ets:match_object(?ETS_TEAM_MB, #t_mb{team_key = TeamKey, _ = '_'}).

%%存储队伍成员
set_team_mb(Mb) ->
    ets:insert(?ETS_TEAM_MB, Mb).

%%清除单个队伍成员
erase_team_mb(Pkey) ->
    ets:delete(?ETS_TEAM_MB, Pkey).

%%清除队伍成员列表
erase_team_mbs(TeamKey) ->
    ets:match_delete(?ETS_TEAM_MB, #t_mb{team_key = TeamKey, _ = '_'}).


cmd_test(Type) ->
    case Type of
        1 ->
            ets:tab2list(?ETS_TEAM);
        2 ->
            ets:tab2list(?ETS_TEAM_MB);
        _ -> []

    end.

quick_join(Player) ->
    if
        Player#player.team_key /= 0 -> {2, Player};
        true ->
            TeamEts = ets:tab2list(?ETS_TEAM),
            TeamList = [Team || Team <- TeamEts, Team#team.num < ?TEAM_MAX_NUM],
            case TeamList of
                [] ->
                    skip;
                _ ->
                    F = fun(Team) ->
                        apply_join_team(Player, Team#team.key)
                    end,
                    lists:map(F, TeamList)
            end,
            erlang:send_after(1000, Player#player.pid, {check_team}),
            {1, Player}
    end.

apply_join_team(Player, TeamKey) ->
    case team_util:get_team(TeamKey) of
        false -> {5, Player};
        Team ->
            OpenLv = ?TEAM_LIM_LV,
            if
                Player#player.team_key /= 0 -> {2, Player};
                Player#player.lv < OpenLv -> {14, Player}; %% 等级不足
                Team#team.num >= ?TEAM_MAX_NUM -> {7, Player};
            %%没有队伍，直接入队
                true ->
                    %%Player1 = team_util:enter_team(Player, Team),
                    {ok, Bin22016} = pt_220:write(22016, {Player#player.key, Player#player.nickname, Player#player.guild#st_guild.guild_name, Player#player.lv, Player#player.cbp}),
                    server_send:send_to_key(Team#team.pkey, Bin22016),
                    {1, Player}
            end
    end.

%%==============end==================================================