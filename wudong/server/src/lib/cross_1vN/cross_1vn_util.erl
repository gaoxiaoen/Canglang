%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2017 15:04
%%%-------------------------------------------------------------------
-module(cross_1vn_util).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("cross_1vN.hrl").
-include("scene.hrl").

%% API
-export([
    get_act_state/0,
    get_act_state_cache/0,
    make_player/1,
    set_act_state/2,
    get_group/1,
    match/4,
    play_sort/1,
    final_match/6,
    get_shop_state/1,
    get_shop_notice_state/1,
    make_winner_bet_info/1,
    make_robot_player/1]).

%% 获取活动状态
get_act_state() ->
    case cache:get(cross_1vn_state) of
        [] -> 0;
        {State, _Time} -> State
    end.

%% 获取活动状态
set_act_state(State, Time) ->
    Now = util:unixtime(),
    ExpireTime = max(0, util:unixdate(Now + ?ONE_DAY_SECONDS) - Now),
    cache:set(cross_1vn_state, {State, Time}, ExpireTime).

%% 获取活动状态/剩余时间
get_act_state_cache() ->
    case cache:get(cross_1vn_state) of
        [] -> {0, 0};
        {State, Time} -> {State, Time}
    end.

make_player(Player) ->
    #cross_1vn_mb{
        node = node(),
        sn = config:get_server_num(),
        pkey = Player#player.key,
        pid = Player#player.pid,
        nickname = Player#player.nickname,
        career = Player#player.career,
        sex = Player#player.sex,
        avatar = Player#player.avatar,
        lv = Player#player.lv,
        cbp = Player#player.cbp,
        guild_name = Player#player.guild#st_guild.guild_name,
        guild_key = Player#player.guild#st_guild.guild_key,
        guild_position = Player#player.guild#st_guild.guild_position,
        mount_id = Player#player.mount_id,
        wing_id = Player#player.wing_id,
        head_id = Player#player.fashion#fashion_figure.fashion_head_id,
        wepon_id = Player#player.equip_figure#equip_figure.weapon_id,
        clothing_id = Player#player.equip_figure#equip_figure.clothing_id,
        light_wepon_id = Player#player.light_weaponid,
        fashion_cloth_id = Player#player.fashion#fashion_figure.fashion_cloth_id,
        vip = util:rand(1, 5)
    }.

make_robot_player(Player) ->
    #cross_1vn_mb{
        sn = Player#player.sn,
        pkey = Player#player.key,
        nickname = Player#player.nickname,
        career = Player#player.career,
        sex = Player#player.sex,
        robot_state = 1,
        avatar = Player#player.avatar,
        lv = Player#player.lv,
        cbp = Player#player.cbp,
        guild_name = Player#player.guild#st_guild.guild_name,
        guild_key = Player#player.guild#st_guild.guild_key,
        guild_position = Player#player.guild#st_guild.guild_position
    }.

make_winner_bet_info(MbList) ->
    F = fun(Mb) ->
        [
            Mb#cross_1vn_mb.pkey,
            util:floor(Mb#cross_1vn_mb.ratio * 100),
            Mb#cross_1vn_mb.sn,
            Mb#cross_1vn_mb.nickname,
            Mb#cross_1vn_mb.is_lose,
            Mb#cross_1vn_mb.career,
            Mb#cross_1vn_mb.sex,
            Mb#cross_1vn_mb.guild_name,
            Mb#cross_1vn_mb.cbp,
            Mb#cross_1vn_mb.head_id,
            Mb#cross_1vn_mb.avatar
        ]
    end,
    lists:map(F, MbList).

%% 获取分区
get_group(Lv) -> data_cross_1vn_group:get(Lv).


%% 资格赛匹配
match(Type, SignList, Floor, PlayList) ->
    ScenePlayerList = scene_agent:get_scene_player(?SCENE_ID_CROSS_1VN_READY), %% 场景玩家
    F = fun(GroupList, PlayList0) ->
        PlayerList = [X || X <- GroupList#cross_1vn_group.mb_list, X#cross_1vn_mb.times < 6], %%  选出符合条件报名玩家
        F0 = fun(ScenePlayer) ->
            case lists:keyfind(ScenePlayer#scene_player.key, #cross_1vn_mb.pkey, PlayerList) of
                false -> [];
                Role ->
                    [Role#cross_1vn_mb{pid = ScenePlayer#scene_player.pid, node = ScenePlayer#scene_player.node, hp = ScenePlayer#scene_player.attribute#attribute.hp_lim, attribute = ScenePlayer#scene_player.attribute}]
            end
        end,
        PlayerList1 = lists:flatmap(F0, ScenePlayerList),
        NewPlayList = match_help(Type, PlayerList1, PlayList0, Floor),
        NewPlayList
    end,
    lists:foldl(F, PlayList, SignList).

match_help(_Type, PlayerList, PidList, Floor) ->
    PlayerList1 = lists:keysort(#cross_1vn_mb.cbp, PlayerList), %% 按照战力排序
    Len = length(PlayerList1),
    SpLen = Len * 5 div 100,
    ?DEBUG("Len ~p~n", [Len]),
    ?DEBUG("SpLen ~p~n", [SpLen]),
    SpList = lists:sublist(PlayerList1, SpLen), %% 特殊列表
    OtherList = lists:sublist(PlayerList1, SpLen + 1, length(PlayerList1)), %% 其余玩家
    NewSpList = play_sort(SpList),
    NewOtherList = play_sort(OtherList),
    case match_help2(NewSpList, NewOtherList, PidList, Floor) of
        {ok, PidList1} -> PidList1;
        {List, PidList1} ->
            match_help3(List, PidList1, Floor)
    end.

%%
play_sort(MbList) ->
    F = fun(Mb1, Mb2) ->
        if
            Mb1#cross_1vn_mb.win > Mb2#cross_1vn_mb.win -> true; %%  胜场
            Mb1#cross_1vn_mb.win < Mb2#cross_1vn_mb.win -> false;
            Mb1#cross_1vn_mb.lose < Mb2#cross_1vn_mb.lose -> true; %% 败场
            Mb1#cross_1vn_mb.lose > Mb2#cross_1vn_mb.lose -> false;
            Mb1#cross_1vn_mb.cbp < Mb2#cross_1vn_mb.cbp -> false; %% 战力
            true -> true
        end
    end,
    lists:sort(F, MbList).

%% 前5%与后95%玩家匹配
match_help2([], [], PlayList, _Floor) -> {ok, PlayList};
match_help2([], List2, PlayList, _Floor) -> {List2, PlayList};
match_help2(List1, [], PlayList, _Floor) -> {List1, PlayList};
match_help2([H1 | T1], [H2 | T2], PlayList, Floor) ->
    {ok, Pid} = cross_1vn_play:start([H1], [H2], ?CROSS_1VN_PLAY_TYPE_0, Floor),
    match_help2(T1, T2, [Pid | PlayList], Floor).

%% 剩余玩家匹配
match_help3([], PlayList, _Floor) -> PlayList;
match_help3(List, PlayList, Floor) ->
    Len = length(List),
    if
        Len >= 2 ->
            [H1, H2 | T] = List,
            ?DEBUG("H1 ~p~n", [H1]),
            ?DEBUG("H2 ~p~n", [H2]),
            {ok, Pid} = cross_1vn_play:start([H1], [H2], ?CROSS_1VN_PLAY_TYPE_0, Floor),
            match_help3(T, [Pid | PlayList], Floor);
        Len == 1 ->
            [H1 | T] = List,
            Shadow0 = shadow:shadow_ai(6),
            Random = util:random(4, 6),
            Attribute = #attribute{
                hp_lim = util:floor(H1#cross_1vn_mb.attribute#attribute.hp_lim * 11 * 0.1),
                att = util:floor(H1#cross_1vn_mb.attribute#attribute.att * 4 * 0.1),
                def = util:floor(H1#cross_1vn_mb.attribute#attribute.def * Random * 0.1),
                hit = util:floor(H1#cross_1vn_mb.attribute#attribute.hit * Random * 0.1),
                dodge = util:floor(H1#cross_1vn_mb.attribute#attribute.dodge * Random * 0.1),
                crit = util:floor(H1#cross_1vn_mb.attribute#attribute.crit * Random * 0.1),
                ten = util:floor(H1#cross_1vn_mb.attribute#attribute.ten * Random * 0.1)
            },
            NickName = player_util:rand_name(),
            Pkey = misc:unique_key_auto(),
            Sn = config:get_server_num(),
            Shadow1 = Shadow0#player{key = Pkey, lv = util:floor(H1#cross_1vn_mb.lv + util:rand(1, 5)), nickname = NickName, sn = Sn, attribute = Attribute, cbp = util:floor(H1#cross_1vn_mb.cbp * Random * 0.1), group = ?CROSS_1VN_GROUP_BLUE},
            RobotMb = make_player(Shadow1),
            RobotMb1 = RobotMb#cross_1vn_mb{robot_state = 1, shadow = Shadow1, group = ?CROSS_1VN_GROUP_BLUE},
            {ok, Pid} = cross_1vn_play:start([H1], [RobotMb1], ?CROSS_1VN_PLAY_TYPE_0, Floor),
            match_help3(T, [Pid | PlayList], Floor);
        true ->
            PlayList
    end.


%% 决赛匹配
final_match(_Type, FinalList, SignList, Floor, PlayList, BetInfoList) ->
    ScenePlayerList = scene_agent:get_scene_player(?SCENE_ID_CROSS_1VN_FINAL_READY), %% 场景玩家
    F = fun(GroupList, {PlayList0, OtherList0, NotInSceneList0, BetInfoList0}) ->
        ?DEBUG("Floor ~p~n", [Floor]),
        PlayerList = [X || X <- GroupList#cross_1vn_group.mb_list, X#cross_1vn_mb.final_floor >= Floor], %%  选出擂主
        ?DEBUG("PlayerList ~p~n", [length(PlayerList)]),
        case lists:keyfind(GroupList#cross_1vn_group.group, #cross_1vn_group.group, SignList) of
            false -> ChallengeList = [];
            SignList1 ->
                F00 = fun(Mb, List) ->
                    case lists:keytake(Mb#cross_1vn_mb.pkey, #cross_1vn_mb.pkey, List) of
                        false -> List;
                        {value, _, T} -> T
                    end
                end,
                ChallengeList = lists:foldl(F00, SignList1#cross_1vn_group.mb_list, PlayerList)
        end,
        F0 = fun(Mb, {PlayerList0, NotInSceneList1}) ->
            case lists:keyfind(Mb#cross_1vn_mb.pkey, #scene_player.key, ScenePlayerList) of
                false -> {PlayerList0, [Mb#cross_1vn_mb{is_lose = 1} | NotInSceneList1]};
                Role ->
                    {[Mb#cross_1vn_mb{pid = Role#scene_player.pid, node = Role#scene_player.node, attribute = Role#scene_player.attribute} | PlayerList0], NotInSceneList1}
            end
        end,
        {PlayerList1, NotInSceneList} = lists:foldl(F0, {[], NotInSceneList0}, PlayerList),
        F1 = fun(Mb) ->
            case lists:keyfind(Mb#cross_1vn_mb.pkey, #scene_player.key, ScenePlayerList) of
                false -> [];
                Role ->
                    [Mb#cross_1vn_mb{pid = Role#scene_player.pid, node = Role#scene_player.node, attribute = Role#scene_player.attribute}]
            end
        end,
        ChallengeList1 = lists:flatmap(F1, ChallengeList),
        {NewPlayList, OtherList, NewBetInfoList} = final_match_help(Floor, PlayerList1, ChallengeList1, PlayList0, BetInfoList0),
        {NewPlayList, OtherList ++ OtherList0, NotInSceneList, NewBetInfoList}
    end,
    lists:foldl(F, {PlayList, [], [], BetInfoList}, FinalList).


final_match_help(Floor, WinnerList, ChallengeList, PidList, BetInfoList) ->
    WinnerList1 = lists:keysort(#cross_1vn_mb.cbp, WinnerList), %% 按照战力排序
    ChallengeList1 = lists:keysort(#cross_1vn_mb.cbp, ChallengeList), %% 按照战力排序
    ?DEBUG("WinnerList1 ~p~n", [length(WinnerList1)]),
    case final_match_help2(Floor, WinnerList1, ChallengeList1, PidList, BetInfoList) of
        {ok, List2, PidList1, NewBetInfoList} -> {PidList1, List2, NewBetInfoList};
        _ ->
            {PidList, [], []}
    end.

final_match_help2(_Floor, [], _List2, PlayList, BetInfoList) -> {ok, _List2, PlayList, BetInfoList};
%% final_match_help2(_Floor, List1, [], PlayList) -> {List1, PlayList};
final_match_help2(Floor, [H1 | T1], L1, PlayList, BetInfoList) ->
    ?DEBUG("111111111~n"),
    case get_num(Floor) of
        [] ->
            ?ERR(" floor err ! ~p~n", [Floor]),
            {ok, L1, PlayList};
        Num ->
            Len = length(L1),
            if
                Len >= Num ->
                    List1 = lists:sublist(L1, Num), %% 挑战者
                    List2 = lists:sublist(L1, Num + 1, Len + 1), %% 剩余挑战者
                    {ok, Pid} = cross_1vn_play:start([H1], List1, ?CROSS_1VN_PLAY_TYPE_1, Floor),
                    NewBetInfoList =
                        case lists:keytake(H1#cross_1vn_mb.pkey, #cross_1vn_bet_info.pkey, BetInfoList) of
                            false -> BetInfoList;
                            {value, BetInfo, BetT} ->
                                [BetInfo#cross_1vn_bet_info{
                                    challenge_list = List1
                                } | BetT]
                        end,
                    final_match_help2(Floor, T1, List2, [Pid | PlayList], NewBetInfoList);
                true ->
                    RobotNum = Num - Len,
                    F0 = fun(_Id) ->
                        Shadow0 = shadow:shadow_ai(6),
                        Random = util:random(4, 6),
                        Attribute = #attribute{
                            hp_lim = util:floor(H1#cross_1vn_mb.attribute#attribute.hp_lim * 11 * 0.1),
                            att = util:floor(H1#cross_1vn_mb.attribute#attribute.att * 4 * 0.1),
                            def = util:floor(H1#cross_1vn_mb.attribute#attribute.def * Random * 0.1),
                            hit = util:floor(H1#cross_1vn_mb.attribute#attribute.hit * Random * 0.1),
                            dodge = util:floor(H1#cross_1vn_mb.attribute#attribute.dodge * Random * 0.1),
                            crit = util:floor(H1#cross_1vn_mb.attribute#attribute.crit * Random * 0.1),
                            ten = util:floor(H1#cross_1vn_mb.attribute#attribute.ten * Random * 0.1)
                        },
                        NickName = player_util:rand_name(),
                        Pkey = misc:unique_key_auto(),
                        Sn = config:get_server_num(),
                        Shadow0#player{key = Pkey, lv = util:floor(H1#cross_1vn_mb.lv + util:rand(1, 5)), nickname = NickName, sn = Sn, attribute = Attribute, cbp = util:floor(H1#cross_1vn_mb.cbp * Random * 0.1 + util:random(1, 10000)), group = ?CROSS_1VN_GROUP_BLUE}
                    end,
                    ShadowList = lists:map(F0, lists:seq(1, RobotNum)),
                    F = fun(Shadow) ->
                        RobotMb = make_player(Shadow),
                        RobotMb#cross_1vn_mb{robot_state = 1, shadow = Shadow, group = ?CROSS_1VN_GROUP_BLUE}
                    end,
                    RobotMbs = lists:map(F, ShadowList),
                    {ok, Pid} = cross_1vn_play:start([H1], L1 ++ RobotMbs, ?CROSS_1VN_PLAY_TYPE_1, Floor),
                    NewBetInfoList =
                        case lists:keytake(H1#cross_1vn_mb.pkey, #cross_1vn_bet_info.pkey, BetInfoList) of
                            false -> BetInfoList;
                            {value, BetInfo, BetT} ->
                                [BetInfo#cross_1vn_bet_info{
                                    challenge_list = L1 ++ RobotMbs
                                } | BetT]
                        end,
                    final_match_help2(Floor, T1, [], [Pid | PlayList], NewBetInfoList)
            end
    end.

%% 决赛匹配人数
get_num(Floor) when Floor == 1 -> 2;
get_num(Floor) when Floor == 2 -> 4;
get_num(Floor) when Floor == 3 -> 6;
get_num(Floor) when Floor == 4 -> 10;
get_num(Floor) when Floor == 5 -> 15;
get_num(Floor) when Floor == 6 -> 20;
get_num(_) -> [].

get_shop_state(_Player) ->
    Now = util:unixtime(),
    if
        Now < 1514822400 -> -1;
        true ->
            Week = util:get_day_of_week(),
            if
                Week == 1 -> -1;
                Week == 2 ->
                    {{_Year, _Month, _Day}, {Hour, Minute, _Second}} = calendar:now_to_local_time({util:unixtime() div 1000000, util:unixtime() rem 1000000, 0}),
                    if
                        Hour < 21 -> -1;
                        Hour =< 21 andalso Minute =< 15 -> -1;
                        true -> 0
                    end;
                true ->
                    0
            end
    end.

get_shop_notice_state(_Player) ->
    Now = util:unixtime(),
    if
        Now < 1514822400 -> -1;
        true ->
            Week = util:get_day_of_week(),
            if
                Week == 1 -> -1;
                Week == 2 ->
                    {{_Year, _Month, _Day}, {Hour, Minute, _Second}} = calendar:now_to_local_time({util:unixtime() div 1000000, util:unixtime() rem 1000000, 0}),
                    if
                        Hour < 21 -> -1;
                        Hour =< 21 andalso Minute =< 15 -> -1;
                        true -> 0
                    end;
                Week == 3 ->
                    {0, [{show_pos, 0}]};
                true ->
                    {0, [{show_pos, 1}]}
            end
    end.

