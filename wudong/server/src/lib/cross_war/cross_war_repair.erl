%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 数据修复模块，专门处理服务器重启，游戏服数据加载至跨父节点
%%% @end
%%% Created : 16. 八月 2017 14:59
%%%-------------------------------------------------------------------
-module(cross_war_repair).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("cross_war.hrl").
-include("guild.hrl").

%% API
-export([
    reload/0,
    repair_guild_data/8, %% 修复单服到跨服节点公会数据
    repair_player_data/3, %% 修复单服到块节点玩家数据

    repair_king/0, %% 远程通知修复王者及城主数据
    repair_king_center/0,
    repair_king_center_cast/1,
    update_king/1,
    gm_update_king/0,
    update_king_center/0,
    repair_player_con_center/2,
    repair_guild_con/1,
    timer/0,
    timer_day1/0
]).

timer_day1() ->
    case config:is_center_node() of
        false -> skip;
        true ->
            WeekDay = util:get_day_of_week(),
            {{_Y, _M, _D}, {H, _Min, _S}} = erlang:localtime(),
            case WeekDay == 1 andalso H == 5 of
                true ->
                    AllCrossWarGuildList = cross_war_util:get_all_guild(),
                    F = fun(CrossWarGuild) ->
                        cross_war_util:update_war_guild(CrossWarGuild#cross_war_guild{is_main = 0})
                    end,
                    lists:map(F, AllCrossWarGuildList);
                _ ->
                    ok
            end
    end.

timer() ->
    case config:is_center_node() of
        true -> skip;
        false ->
            OpenLimitDay = data_cross_war_time:get_limit_open_day(),
            OpenDay = config:get_open_days(),
            IsConn = cross_area:check_cross_war_state(),
            if
                OpenLimitDay >= OpenDay -> skip;
                IsConn == false -> skip;
                true ->
                    TodayTime = util:unixdate(),
                    Now = util:unixtime(),
                    if
                        Now - TodayTime < 100 -> skip;
                        true ->
                            IsDebug = config:is_debug(),
                            Rand = ?IF_ELSE(IsDebug == true, 5, util:rand(1, 1800)),
                            timer:sleep(Rand * 1000),
                            reload(),
                            repair_king()
                    end
            end
    end.

load_guild_sign() ->
    Sql = io_lib:format("select gkey, sign, change_time from guild_cross_war_sign", []),
    case db:get_all(Sql) of
        [] -> [];
        Rows ->
            F = fun([GuildKey, Sign, ChangeTime]) ->
                {GuildKey, Sign, ChangeTime}
            end,
            lists:map(F, Rows)
    end.

load_player_guild_key() ->
    Sql = io_lib:format("select guild_key from player_cross_war where guild_key > 0 GROUP BY guild_key", []),
    case db:get_all(Sql) of
        [] -> [];
        Rows ->
            Rows
    end.

get_all_guild_sign() ->
    GuildSignList = load_guild_sign(),
    AllGuildKeyList = load_player_guild_key(),
    F = fun([GuildKey]) ->
        case lists:keyfind(GuildKey, 1, GuildSignList) of
            false -> [{GuildKey, ?CROSS_WAR_TYPE_ATT, 0}];
            _ -> []
        end
    end,
    FilterList = lists:flatmap(F, AllGuildKeyList),
    GuildSignList ++ FilterList.

reload() ->
    Sql = io_lib:format("select pkey, contrib_list, op_time, guild_key from player_cross_war", []),
    case db:get_all(Sql) of
        [] -> skip;
        Rows ->
            GuildSignList = get_all_guild_sign(),
            F = fun([_Pkey, ContribListBin, _OpTime, GuildKey], AccList) ->
                case GuildKey /= 0 of
                    true ->
                        ContribList = util:bitstring_to_term(ContribListBin),
                        Contrib = cacl(ContribList),
                        {Sign, ChangeTime} =
                            case lists:keyfind(GuildKey, 1, GuildSignList) of
                                false -> {?CROSS_WAR_TYPE_ATT, 0};
                                {_, Sign0, ChangeTime0} -> {Sign0, ChangeTime0}
                            end,
                        case lists:keytake(GuildKey, 1, AccList) of
                            false ->
                                [{GuildKey, Contrib, Sign, ChangeTime} | AccList];
                            {value, {GuildKey, OldContrib, _Sign, _ChangeTime}, Rest} ->
                                [{GuildKey, Contrib + OldContrib, Sign, ChangeTime} | Rest]
                        end;
                    false ->
                        AccList
                end
            end,
            GuildInfoList = lists:foldl(F, [], Rows),
            send_guild_to_center(GuildInfoList),
            F2 = fun([Pkey, ContribListBin, _OpTime, GuildKey], AccList) ->
                ContribList = util:bitstring_to_term(ContribListBin),
                Contrib = cacl(ContribList),
                [{Pkey, Contrib, GuildKey} | AccList]
            end,
            PlayerInfoList = lists:foldl(F2, [], Rows),
            send_player_to_center(PlayerInfoList)
    end.

cacl([]) -> 0;
cacl(List) ->
    F = fun({Id, Num}) ->
        data_cross_war_exchange:get(Id) * Num
    end,
    lists:sum(lists:map(F, List)).

send_guild_to_center(GuildInfoList) ->
    F = fun({GuildKey, Contrib, Sign, ChangeTime}) ->
        case guild_ets:get_guild(GuildKey) of
            false -> skip;
            Guild ->
                #guild{pkey = Pkey, gkey = GKey, name = GuildName} = Guild,
                MainShadow = shadow_proc:get_shadow(Pkey),
                MainCoupleKey = MainShadow#player.marry#marry.couple_key,
                MainCoupleShadow = ?IF_ELSE(MainCoupleKey == 0, #player{}, shadow_proc:get_shadow(MainCoupleKey)),
                cross_area:war_apply(cross_war_repair, repair_guild_data, [MainShadow, MainCoupleShadow, GKey, GuildName, Contrib, node(), Sign, ChangeTime])
        end
    end,
    lists:map(F, GuildInfoList).

%% 修复公会数据
repair_guild_data(MainShadow, MainCoupleShadow, Gkey, GuildName, Contrib, Node, Sign, ChangeTime) ->
    SnName = config:get_server_name(MainShadow#player.sn),
    case cross_war_util:get_by_g_key(Gkey) of
        #cross_war_guild{} = RR ->
            cross_war_util:update_war_guild(RR#cross_war_guild{sign = Sign, sn_name = SnName});
        _ ->
            IsKingGuild = cross_war_util:is_king_guild(Gkey),
            ConMult = data_cross_war_other_reward:get_king_con_mult(),
            CrossWarGuild =
                #cross_war_guild{
                    sign = Sign,
                    g_key = Gkey,
                    g_name = GuildName,
                    sn = MainShadow#player.sn,
                    sn_name = SnName,
                    node = Node,
                    g_pkey = MainShadow#player.key,
                    g_main_name = MainShadow#player.nickname,
                    g_main_sex = MainShadow#player.sex,
                    g_main_wing_id = MainShadow#player.wing_id,
                    g_main_wepon_id = MainShadow#player.equip_figure#equip_figure.weapon_id,
                    g_main_clothing_id = MainShadow#player.equip_figure#equip_figure.clothing_id,
                    g_main_light_wepon_id = MainShadow#player.light_weaponid,
                    g_main_fashion_cloth_id = MainShadow#player.fashion#fashion_figure.fashion_cloth_id,
                    g_main_fashion_head_id = MainShadow#player.fashion#fashion_figure.fashion_head_id,
                    contrib_val = ?IF_ELSE(IsKingGuild > 0, round(Contrib*ConMult), Contrib),
                    change_sign_time = ChangeTime
                },
            cross_war_util:update_war_guild(CrossWarGuild),
            repair_player_data(MainShadow, MainCoupleShadow, 0)
    end.

send_player_to_center(PlayerInfoList) ->
    F = fun({Pkey, Contrib, GuildKey}) ->
        case guild_ets:get_guild(GuildKey) of
            false ->
                skip;
            _ ->
                Player = shadow_proc:get_shadow(Pkey),
                CoupleKey = Player#player.marry#marry.couple_key,
                PlayerCouple = ?IF_ELSE(CoupleKey == 0, #player{}, shadow_proc:get_shadow(CoupleKey)),
                cross_area:war_apply(cross_war_repair, repair_player_data, [Player, PlayerCouple, Contrib])
        end
    end,
    lists:map(F, PlayerInfoList),
    ok.

%% 修复玩家数据
repair_player_data(Player, PlayerCouple, Contrib) ->
    SnName = config:get_server_name(Player#player.sn),
    case cross_war_util:get_by_pkey(Player#player.key) of
        #cross_war_player{} = CrossWarPlayer ->
            CrossWarGuild = cross_war_util:get_by_g_key(Player#player.guild#st_guild.guild_key),
            NewCrossWarPlayer =
                CrossWarPlayer#cross_war_player{
                    sign = ?IF_ELSE(CrossWarGuild == [], ?CROSS_WAR_TYPE_ATT, CrossWarGuild#cross_war_guild.sign),
                    sn_name = SnName
                },
            cross_war_util:update_war_player(NewCrossWarPlayer),
            skip;
        _ ->
            CrossWarGuild = cross_war_util:get_by_g_key(Player#player.guild#st_guild.guild_key),
            CrossWarPlayer =
                #cross_war_player{
                    pkey = Player#player.key,
                    sn = Player#player.sn,
                    career = Player#player.career,
                    sex = Player#player.sex,
                    nickname = Player#player.nickname,
                    wing_id = Player#player.wing_id,
                    wepon_id = Player#player.equip_figure#equip_figure.weapon_id,
                    clothing_id = Player#player.equip_figure#equip_figure.clothing_id,
                    light_wepon_id = Player#player.light_weaponid,
                    fashion_cloth_id = Player#player.fashion#fashion_figure.fashion_cloth_id,
                    fashion_head_id = Player#player.fashion#fashion_figure.fashion_head_id,
                    couple_pkey = Player#player.marry#marry.couple_key,
                    couple_sex = Player#player.marry#marry.couple_sex,
                    couple_nickname = Player#player.marry#marry.couple_name,
                    couple_wing_id = PlayerCouple#player.wing_id,
                    couple_wepon_id = PlayerCouple#player.equip_figure#equip_figure.weapon_id,
                    couple_clothing_id = PlayerCouple#player.equip_figure#equip_figure.clothing_id,
                    couple_light_wepon_id = PlayerCouple#player.light_weaponid,
                    couple_fashion_cloth_id = PlayerCouple#player.fashion#fashion_figure.fashion_cloth_id,
                    couple_fashion_head_id = PlayerCouple#player.fashion#fashion_figure.fashion_head_id,
                    node = Player#player.node,
                    position = Player#player.guild#st_guild.guild_position, %% 帮派职位
                    g_key = Player#player.guild#st_guild.guild_key,
                    g_name = Player#player.guild#st_guild.guild_name,
                    contrib_val = Contrib,
                    sign = ?IF_ELSE(CrossWarGuild == [], ?CROSS_WAR_TYPE_ATT, CrossWarGuild#cross_war_guild.sign),
                    sn_name = SnName
                },
            cross_war_util:update_war_player(CrossWarPlayer)
    end,
    ok.

gm_update_king() ->
    cross_area:war_apply(?MODULE, update_king_center, []).

update_king_center() ->
    ?CAST(cross_war_proc:get_server_pid(), gm_update_king).

repair_king() ->
    NowStartTime = util:unixdate(),
    Now = util:unixtime(),
    if
        Now - NowStartTime < 300 -> skip;
        true -> cross_area:war_apply(?MODULE, repair_king_center, [])
    end.

repair_king_center() ->
    ?CAST(cross_war_proc:get_server_pid(), repair_king).

repair_king_center_cast(State) when State#sys_cross_war.open_state == ?CROSS_WAR_STATE_START orelse State#sys_cross_war.open_state == ?CROSS_WAR_STATE_CLOSE ->
    State;

repair_king_center_cast(State) ->
    case cross_war_load:load_king(node()) of
        {0, 0, 0, 0, 0, 0, [], [], [], []} ->
            State;
        {Gkey, _Pkey, Sign, LastPkey, LastGkey, AccWin, KillWarDoorList, KillKingDoorList, DefGkeyList, AttGkeyList} ->
            CrossWarGuild99 = cross_war_util:get_by_g_key(Gkey),
            NState =
                case CrossWarGuild99 == [] of
                    true -> State;
                    false ->
                        case cross_war_util:get_by_pkey(CrossWarGuild99#cross_war_guild.g_pkey) of
                            [] -> State;
                            KingCrossWarPlayer ->
                                KingInfo = player_to_king(KingCrossWarPlayer),
                                NewKingInfo =
                                    KingInfo#cross_war_king{
                                        acc_win = AccWin,
                                        war_info = ?IF_ELSE(Sign == ?CROSS_WAR_TYPE_DEF, make_war_info(DefGkeyList, Gkey), make_war_info(AttGkeyList, Gkey))
                                    },
                                case cross_war_util:get_by_pkey(LastPkey) of
                                    [] -> State#sys_cross_war{king_info = NewKingInfo};
                                    LastKingCrossWarPlayer ->
                                        LastKingInfo = player_to_king(LastKingCrossWarPlayer),
                                        State#sys_cross_war{
                                            king_info = NewKingInfo,
                                            last_king_info = LastKingInfo
                                        }
                                end
                        end
                end,
            F = fun({LogPkey, LogRank}) ->
                case cross_war_util:get_by_pkey(LogPkey) of
                    [] -> [];
                    LogCrossWarPlayer ->
                        [cross_war_util:to_cross_war_log(LogRank, LogCrossWarPlayer)]
                end
            end,
            KillWarDoorLogList = lists:flatmap(F, KillWarDoorList),
            KillKingDoorLogList = lists:flatmap(F, KillKingDoorList),
            NewState =
                NState#sys_cross_war{
                    win_sign = Sign,
                    kill_king_door_list = KillKingDoorLogList,
                    kill_war_door_list = KillWarDoorLogList
                },
            %% 修复城主仙盟数据
            case cross_war_util:get_by_g_key(Gkey) of
                [] ->
                    skip;
                KingCrossWarGuild ->
                    cross_war_util:update_war_guild(KingCrossWarGuild#cross_war_guild{is_main = 1, sign = ?CROSS_WAR_TYPE_DEF})
            end,
            %% 修复复仇仙盟数据
            case cross_war_util:get_by_g_key(LastGkey) of
                [] ->
                    skip;
                LastKingCrossWarGuild ->
                    if %% 处理当前城主和上届城主一致的问题
                        Gkey == LastGkey -> skip;
                        true ->
                            cross_war_util:update_war_guild(LastKingCrossWarGuild#cross_war_guild{is_main = 2, sign = ?CROSS_WAR_TYPE_ATT})
                    end
            end,
            NewState
    end.

player_to_king(CrossWarPlayer) ->
    #cross_war_player{
        pkey = Pkey, %% 城主key
        nickname = NickName,
        sex = Sex,
        wing_id = WingId,
        wepon_id = WeponId,
        clothing_id = ClothingId,
        light_wepon_id = LightWeponId,
        fashion_cloth_id = FashionClothId,
        fashion_head_id = FashionHeadId,
        couple_pkey = CouplePkey, %% 城主夫人key
        couple_nickname = CoupleNickname,
        couple_sex = CoupleSex,
        couple_wing_id = CoupleWingId,
        couple_wepon_id = CoupleWeponId,
        couple_clothing_id = CoupleClothingId,
        couple_light_wepon_id = CoupleLightWeponId,
        couple_fashion_cloth_id = CoupleFashionClothId,
        couple_fashion_head_id = CouleFashionHeadId,
        node = Node,
        sn = Sn,
        sn_name = SnName,
        g_key = GuildKey,
        g_name = GuildName
    } = CrossWarPlayer,
    #cross_war_king{
        pkey = Pkey, %% 城主key
        nickname = NickName,
        sex = Sex,
        wing_id = WingId,
        wepon_id = WeponId,
        clothing_id = ClothingId,
        light_wepon_id = LightWeponId,
        fashion_cloth_id = FashionClothId,
        fashion_head_id = FashionHeadId,
        couple_key = CouplePkey, %% 城主夫人key
        couple_nickname = CoupleNickname,
        couple_sex = CoupleSex,
        couple_wing_id = CoupleWingId,
        couple_wepon_id = CoupleWeponId,
        couple_clothing_id = CoupleClothingId,
        couple_light_wepon_id = CoupleLightWeponId,
        couple_fashion_cloth_id = CoupleFashionClothId,
        couple_fashion_head_id = CouleFashionHeadId,
        node = Node,
        sn = Sn,
        sn_name = SnName,
        g_key = GuildKey,
        g_name = GuildName
    }.
make_war_info(GkeyList, MainGkey) ->
    F = fun(Gkey) ->
        case cross_war_util:get_by_g_key(Gkey) of
            [] -> [];
            CrossWarGuild -> cross_war_util:make_war_info([CrossWarGuild], MainGkey)
        end
    end,
    lists:flatmap(F, GkeyList).

update_king(State) ->
    #sys_cross_war{
        win_sign = Sign,
        king_info = KingInfo,
        last_king_info = LastKingInfo,
        kill_king_door_list = KillKingDoorList,
        kill_war_door_list = KillWarDoorList,
        def_guild_list = DefGuildList,
        att_guild_list = AttGuildList
    } = State,
    #cross_war_king{
        g_key = Gkey,
        pkey = Pkey,
        acc_win = AccWin
    } = KingInfo,
    #cross_war_king{pkey = LastPkey, g_key = LastGkey} = LastKingInfo,
    F = fun(#cross_war_log{rank = LogRank, pkey = Pkey0}) ->
        {Pkey0, LogRank}
    end,
    KillWarDoorPkeyList = lists:map(F, KillWarDoorList),
    KillKingDoorPkeyList = lists:map(F, KillKingDoorList),
    F2 = fun(#cross_war_guild{g_key = Gkey0}) ->
        Gkey0
    end,
    DefGuildKeyList = lists:map(F2, DefGuildList),
    AttGuildKeyList = lists:map(F2, AttGuildList),
    cross_war_load:update_king([Gkey, Pkey, Sign, LastPkey, LastGkey, AccWin, KillWarDoorPkeyList, KillKingDoorPkeyList, DefGuildKeyList, AttGuildKeyList]),
    ok.

repair_player_con_center(Player, PlayerCon) ->
    CrossWarPlayer = cross_war_util:get_by_pkey(Player#player.key),
    #cross_war_player{contrib_val = ConVal} = CrossWarPlayer,
    if
        PlayerCon == ConVal -> skip;
        true ->
            NewCrossWarPlayer = CrossWarPlayer#cross_war_player{contrib_val = PlayerCon},
            cross_war_util:update_war_player(NewCrossWarPlayer)
    end.

repair_guild_con(Gkey) ->
    case cross_war_util:get_by_g_key(Gkey) of
        [] -> skip;
        CrossWarGuild ->
            AllCrossWarPlayerList = cross_war_util:get_all_player(),
            F = fun(CrossWarPlayer, AccVal) ->
                case CrossWarPlayer#cross_war_player.g_key == Gkey of
                    true -> AccVal + CrossWarPlayer#cross_war_player.contrib_val;
                    false -> AccVal
                end
            end,
            GuildCon = lists:foldl(F, 0, AllCrossWarPlayerList),
            NewCrossWarGuild = CrossWarGuild#cross_war_guild{contrib_val = GuildCon},
            cross_war_util:update_war_guild(NewCrossWarGuild)
    end.
