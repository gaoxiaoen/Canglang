%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2017 13:51
%%%-------------------------------------------------------------------
-module(cross_war_util).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("cross_war.hrl").
-include("scene.hrl").

%% API
-export([
    get_by_pkey/1,
    update_war_player/1,
    delete_war_player/1,
    get_by_g_key/1,
    update_war_guild/1,
    delete_war_guild/1,
    get_all_player/0,
    get_all_guild/0,
    delete_war_player_all/0,
    delete_war_guild_all/0,
    delete_war_guild_all_week_1/0, %% 周一清除数据
    delete_war_player_all_week_1/0, %% 周一清除数据
    get_type_all_player/1, %% 获取 防御/攻击 玩家
    get_type_all_guild/1, %% 获取 防御/攻击 公会
    update_player_kill_num/2, %% 更新连杀
    clean_player_kill_num/1, %% 清除连杀
    clean_player_bomb/1 %% 清除炸弹
]).

-export([ %% 内部接口
    get_guild_contrib_sort/1, %% 提取防御/攻击阵营公会贡献排名
    get_player_contrib_sort/1, %% 提取防御/攻击阵营玩家贡献排名

    add_guild_contrib/2, %% 增加公会攻击方贡献值
    add_player_contrib/2, %% 增加玩家攻击方贡献值

    clean_node_data/0, %% 清除非同跨服节点内的数据
    add_to_list/3,
    add_guild_score/2, %% 增加公会积分
    add_player_score/2, %% 增加个人积分

    get_player_score_sort/1, %% 获取 防御/攻击 个人积分排名
    get_guild_score_sort/1, %% 攻击 防御/攻击 积分排序

    to_cross_war_log/2,
    make_war_info/2,
    set_player_crown/2,

    change_sign_player/2, %% 切换阵营更改所有阵营玩家
    add_materis_player/2, %% 增加攻城资源

    guild_quit/2, %% 退出公会
    guild_dismiss/1, %% 解散公会
    guild_quit_center/2,
    guild_dismiss_center/1,

    get_main_by_gkey/1, %% 获取城主信息
    get_main_by_gkey_center/1,

    is_king_guild/1
]).

-export([
    sys_notice/1,
    sys_notice/2,
    sys_cross_notice/2,
    sys_notice_43099/0,
    notice_43099/0,
    add_exp_data/1
]).

guild_quit(Gkey, Pkey) ->
    cross_area:war_apply(?MODULE, guild_quit_center, [Gkey, Pkey]).

guild_quit_center(Gkey, Pkey) ->
    case get_by_pkey(Pkey) of
        [] -> skip;
        RR ->
            cross_war_repair:repair_guild_con(Gkey),
            delete_war_player(RR)
    end.

guild_dismiss(Gkey) ->
    cross_area:war_apply(?MODULE, guild_dismiss_center, [Gkey]).

guild_dismiss_center(Gkey) ->
    case get_by_g_key(Gkey) of
        [] -> skip;
        RR ->
            delete_war_guild(RR),
            delete_war_player_by_gkey(Gkey)
    end.

delete_war_player_by_gkey(Gkey) ->
    AllCrossWarPlayer = cross_war_util:get_all_player(),
    F = fun(CrossWarPlayer) ->
        if
            CrossWarPlayer#cross_war_player.g_key /= Gkey -> skip;
            true -> delete_war_player(CrossWarPlayer)
        end
    end,
    lists:map(F, AllCrossWarPlayer).

change_sign_player(GuildKey, Sign) ->
    AllCrossWarPlayer = get_all_player(),
    Now = util:unixtime(),
    F = fun(CrossWarPlayer) ->
        if
            GuildKey /= CrossWarPlayer#cross_war_player.g_key ->
                skip;
            true ->
                NewCrossWarPlayer =
                    CrossWarPlayer#cross_war_player{
                        sign = Sign,
                        contrib_time = Now
                    },
                update_war_player(NewCrossWarPlayer)
        end
    end,
    lists:map(F, AllCrossWarPlayer).

get_by_pkey(Pkey) ->
    case ets:lookup(?ETS_CROSS_WAR_PLAYER, Pkey) of
        [] -> [];
        [Ets] -> Ets
    end.

update_war_player(CrossWarPlayer) ->
    ets:insert(?ETS_CROSS_WAR_PLAYER, CrossWarPlayer).

delete_war_player_all() ->
    ets:delete_all_objects(?ETS_CROSS_WAR_PLAYER).

delete_war_player(CrossWarPlayer) ->
    ets:delete_object(?ETS_CROSS_WAR_PLAYER, CrossWarPlayer).

get_all_player() ->
    ets:tab2list(?ETS_CROSS_WAR_PLAYER).

get_by_g_key(Gkey) ->
    case ets:lookup(?ETS_CROSS_WAR_GUILD, Gkey) of
        [] -> [];
        [Ets] -> Ets
    end.

delete_war_guild_all() ->
    ets:delete_all_objects(?ETS_CROSS_WAR_GUILD).

delete_war_guild_all_week_1() ->
    AllCrossWarGuildList = get_all_guild(),
    F = fun(#cross_war_guild{is_main = IsMain} = R) ->
        if
            IsMain > 0 ->
                update_war_guild(
                    R#cross_war_guild{
                        contrib_val = 0, %% 捐献值
                        contrib_time = 0, %% 捐献时间
                        contrib_rank = 0, %% 捐献值排名
                        score = 0,
                        score_rank = 0
                    });
            true ->
                delete_war_guild(R)
        end
    end,
    lists:map(F, AllCrossWarGuildList),
    ok.

delete_war_player_all_week_1() ->
    AllCrossWarPlayerList = get_all_player(),
    F = fun(#cross_war_player{g_key = Gkey} = RR) ->
        case cross_war_util:get_by_g_key(Gkey) of
            [] -> delete_war_player(RR);
            _ ->
                update_war_player(
                    RR#cross_war_player{
                        contrib_val = 0, %% 捐献值
                        contrib_time = 0, %% 捐献时间
                        contrib_rank = 0, %% 捐献值排名
                        score = 0,
                        score_rank = 0
                    })
        end
    end,
    lists:map(F, AllCrossWarPlayerList).


delete_war_guild(CrossWarGuild) ->
    ets:delete_object(?ETS_CROSS_WAR_GUILD, CrossWarGuild).

update_war_guild(CrossWarGuild) ->
    ets:insert(?ETS_CROSS_WAR_GUILD, CrossWarGuild).

get_all_guild() ->
    ets:tab2list(?ETS_CROSS_WAR_GUILD).

get_type_all_guild(Type) ->
    AllGuildList = get_all_guild(),
    F = fun(#cross_war_guild{sign = Sign}) ->
        Sign == Type
    end,
    lists:filter(F, AllGuildList).

get_guild_contrib_sort(Type) ->
    guild_contrib_sort(get_type_all_guild(Type)).

guild_contrib_sort(GuildList) ->
    F = fun(#cross_war_guild{is_main = IsMain1, contrib_val = ContribVal, contrib_time = ContribTime},
        #cross_war_guild{is_main = IsMain2, contrib_val = ContribVal2, contrib_time = ContribTime2}) ->
        if
            IsMain1 > IsMain2 -> true;
            IsMain1 < IsMain2 -> false;
            ContribVal > ContribVal2 orelse ContribVal == ContribVal2 andalso ContribTime < ContribTime2 -> true;
            true -> false
        end
    end,
    NGuildList = lists:sort(F, GuildList),
    F1 = fun(GuildWar, {Count, AccList}) ->
        NewGuildWar = GuildWar#cross_war_guild{contrib_rank = Count},
        update_war_guild(NewGuildWar),
        {Count + 1, [NewGuildWar | AccList]}
    end,
    {_count, NewGuildList} = lists:foldl(F1, {1, []}, NGuildList),
    lists:reverse(NewGuildList).

get_type_all_player(Type) ->
    AllPlayerList = get_all_player(),
    F = fun(#cross_war_player{g_key = Gkey}) ->
        case get_by_g_key(Gkey) of
            [] -> false;
            #cross_war_guild{sign = Sign} ->
                Sign == Type
        end
    end,
    lists:filter(F, AllPlayerList).

get_player_contrib_sort(Type) ->
    player_contrib_sort(get_type_all_player(Type)).

player_contrib_sort(PlayerList) ->
    F = fun(#cross_war_player{contrib_val = ContribVal, contrib_time = ContribTime},
        #cross_war_player{contrib_val = ContribVal2, contrib_time = ContribTime2}) ->
        ContribVal > ContribVal2 orelse
            ContribVal == ContribVal2 andalso ContribTime < ContribTime2
    end,
    NPlayerList = lists:sort(F, PlayerList),
    F1 = fun(PlayerWar, {Count, AccList}) ->
        NewPlayerWar = PlayerWar#cross_war_player{contrib_rank = Count},
        update_war_player(NewPlayerWar),
        {Count + 1, [NewPlayerWar | AccList]}
    end,
    {_count, NewPlayerList} = lists:foldl(F1, {1, []}, NPlayerList),
    lists:reverse(NewPlayerList).

add_guild_contrib(GKey, AddVal) ->
    GuildWar = get_by_g_key(GKey),
    NewGuildWar =
        GuildWar#cross_war_guild{
            contrib_val = GuildWar#cross_war_guild.contrib_val + AddVal,
            contrib_time = util:unixtime()
        },
    update_war_guild(NewGuildWar).

add_player_contrib(PKey, AddVal) ->
    PlayerWar = get_by_pkey(PKey),
    NewPlayerWar =
        PlayerWar#cross_war_player{
            contrib_val = PlayerWar#cross_war_player.contrib_val + AddVal,
            contrib_time = util:unixtime()
        },
    update_war_player(NewPlayerWar).


%% 清除非同跨服节点内的数据
clean_node_data() ->
    GuildList = get_all_guild(),
    PlayerList = get_all_player(),
    Nodes = center:get_war_nodes(),
    F = fun(#cross_war_guild{node = Node} = R) ->
        case lists:member(Node, Nodes) of
            false -> delete_war_guild(R);
            true -> ok
        end
    end,
    lists:map(F, GuildList),
    F2 = fun(#cross_war_player{node = Node} = R) ->
        case lists:member(Node, Nodes) of
            false -> delete_war_player(R);
            true -> true
        end
    end,
    lists:map(F2, PlayerList).

add_to_list(GoodsId, GoodsNum, List) ->
    case lists:keytake(GoodsId, 1, List) of
        false -> [{GoodsId, GoodsNum} | List];
        {value, {GoodsId, OldGoodsNum}, Rest} ->
            [{GoodsId, OldGoodsNum + GoodsNum} | Rest]
    end.

add_guild_score(Gkey, AddScore) ->
    case get_by_g_key(Gkey) of
        [] -> skip;
        CrossWarGuild ->
            NewCrossWarGuild =
                CrossWarGuild#cross_war_guild{
                    score = CrossWarGuild#cross_war_guild.score + AddScore,
                    score_time = util:unixtime()
                },
            update_war_guild(NewCrossWarGuild)
    end.

add_player_score(Pkey, AddScore) ->
    case get_by_pkey(Pkey) of
        [] -> skip;
        CrossWarPlayer ->
            NewCrossWarPlayer =
                CrossWarPlayer#cross_war_player{
                    score = CrossWarPlayer#cross_war_player.score + AddScore,
                    score_time = util:unixtime()
                },
            if
                AddScore == 0 -> skip;
                true -> send_online_score_reward(NewCrossWarPlayer, CrossWarPlayer)
            end,
            update_war_player(NewCrossWarPlayer)
    end.

get_player_score_sort(Type) ->
    PlayerList0 = get_type_all_player(Type),
    F99 = fun(#cross_war_player{g_key = GKey}) ->
        case cross_war_util:get_by_g_key(GKey) of
            [] -> false;
            #cross_war_guild{score_rank = ScoreRank} ->
                ScoreRank > 0
        end
    end,
    PlayerList = lists:filter(F99, PlayerList0),
    F = fun(#cross_war_player{score = S1, score_time = AddT1}, #cross_war_player{score = S2, score_time = AddT2}) ->
        S1 > S2 orelse S1 == S2 andalso AddT1 < AddT2
    end,
    NewPlayerList = lists:sort(F, PlayerList),
    F2 = fun(CrossWarPlayer, {Count, Acc}) ->
        NewCrossWarPlayer = CrossWarPlayer#cross_war_player{score_rank = Count},
        update_war_player(NewCrossWarPlayer),
        {Count + 1, [NewCrossWarPlayer | Acc]}
    end,
    {_Rank, List} = lists:foldl(F2, {1, []}, NewPlayerList),
    lists:reverse(List).

get_guild_score_sort(Type) ->
    GuildList0 = get_type_all_guild(Type),
    Now = util:unixtime(),
    F99 = fun(#cross_war_guild{change_sign_time = Time, is_main = IsMain}) ->
        IsMain > 0 orelse util:is_same_week(Now, Time) orelse Time == 0
    end,
    GuildList = lists:filter(F99, GuildList0),
    F = fun(#cross_war_guild{score = S1, score_time = AddT1}, #cross_war_guild{score = S2, score_time = AddT2}) ->
        S1 > S2 orelse S1 == S2 andalso AddT1 < AddT2
    end,
    NewGuildList = lists:sort(F, GuildList),
    F2 = fun(CrossWarGuild, {Count, Acc}) ->
        NewCrossWarGuild = CrossWarGuild#cross_war_guild{score_rank = Count},
        update_war_guild(NewCrossWarGuild),
        {Count + 1, [NewCrossWarGuild | Acc]}
    end,
    {_Rank, List} = lists:foldl(F2, {1, []}, NewGuildList),
    lists:reverse(List).

to_cross_war_log(Rank, CrossWarPlayer) ->
    #cross_war_player{
        nickname = Name,
        sex = Sex,
        sn = Sn,
        g_name = GuildName,
        sn_name = SnName,
        wing_id = WingId,
        wepon_id = WeponId,
        clothing_id = ClothingId,
        light_wepon_id = LightWeponId,
        fashion_cloth_id = FashionClothId,
        fashion_head_id = FashionHeadId
    } = CrossWarPlayer,
    #cross_war_log{
        rank = Rank, %% 积分排名
        nickname = Name,
        sex = Sex,
        sn = Sn,
        g_name = GuildName,
        sn_name = SnName,
        wing_id = WingId,
        wepon_id = WeponId,
        clothing_id = ClothingId,
        light_wepon_id = LightWeponId,
        fashion_cloth_id = FashionClothId,
        fashion_head_id = FashionHeadId
    }.

make_war_info(CrossWarGuildList, GKey) ->
    F = fun(OldCrossWarGuild) ->
        CrossWarGuild = cross_war_util:get_by_g_key(OldCrossWarGuild#cross_war_guild.g_key),
        #cross_war_guild{
            g_key = GuildKey,
            g_name = GuildName,
            sn = Sn,
            sn_name = SnName,
            g_pkey = GuildPkey, %% 帮主
            g_main_name = GuildMainName, %% 帮主名字
            g_main_sex = GuildMainSex,
            g_main_wing_id = GuildMainWingId,
            g_main_wepon_id = GuildMainWeponId,
            g_main_clothing_id = GuildMainClothingId,
            g_main_light_wepon_id = GuildMainLightWeponId,
            g_main_fashion_cloth_id = GuildMainFashionClothId,
            g_main_fashion_head_id = GuildMainFashionHeadId,
            score_rank = ScoreRank %% 积分排名
        } = CrossWarGuild,
        if
            GKey == GuildKey -> [];
            true ->
                [#cross_war_log{
                    rank = ScoreRank,
                    pkey = GuildPkey,
                    nickname = GuildMainName,
                    sex = GuildMainSex,
                    g_name = GuildName,
                    sn = Sn,
                    sn_name = SnName,
                    wing_id = GuildMainWingId,
                    wepon_id = GuildMainWeponId,
                    clothing_id = GuildMainClothingId,
                    light_wepon_id = GuildMainLightWeponId,
                    fashion_cloth_id = GuildMainFashionClothId,
                    fashion_head_id = GuildMainFashionHeadId
                }]
        end
    end,
    lists:sublist(lists:flatmap(F, CrossWarGuildList), ?CROSS_WAR_SIGN_GUILD_MAX_NUM - 1).

set_player_crown(Pkey, IsCrown) ->
    case IsCrown == 1 of
        true ->
            [{kill_sarah, AddMarteris}] = data_cross_war_materis_condition:get(4),
            cross_war_util:add_materis_player(Pkey, AddMarteris);
        false -> skip
    end,
    CrossWarPlayer = get_by_pkey(Pkey),
    update_war_player(CrossWarPlayer#cross_war_player{crown = IsCrown}).


sys_notice_43099() ->
    Nodes = center:get_war_nodes(),
    F = fun(Node) ->
        center:apply(Node, ?MODULE, notice_43099, [])
    end,
    lists:map(F, Nodes),
    ok.

notice_43099() ->
    PlayerList = ets:tab2list(?ETS_ONLINE),
    F = fun(#ets_online{pid = Pid}) ->
        Pid ! cross_war_43099
    end,
    lists:map(F, PlayerList),
    ok.

%% 公告通知
sys_notice(Type) ->
    Nodes = center:get_war_nodes(),
    F = fun(Node) ->
        center:apply(Node, notice_sys, add_notice, [Type, []])
    end,
    lists:map(F, Nodes),
    ok.

sys_notice(Type, Args) ->
    Nodes = center:get_war_nodes(),
    F = fun(Node) ->
        center:apply(Node, notice_sys, add_notice, [Type, Args])
    end,
    lists:map(F, Nodes),
    ok.

sys_cross_notice(Type, Args) ->
    notice_sys:add_notice(Type, Args),
    ok.

update_player_kill_num(Pkey, N) ->
    case get_by_pkey(Pkey) of
        [] -> ok;
        CrossWarPlayer ->
            NewCrossWarPlayer =
                CrossWarPlayer#cross_war_player{acc_kill_num = CrossWarPlayer#cross_war_player.acc_kill_num + N},
            update_war_player(NewCrossWarPlayer)
    end.

clean_player_kill_num(Pkey) ->
    case get_by_pkey(Pkey) of
        [] -> ok;
        CrossWarPlayer ->
            NewCrossWarPlayer =
                CrossWarPlayer#cross_war_player{acc_kill_num = 0},
            update_war_player(NewCrossWarPlayer)
    end.

clean_player_bomb(Pkey) ->
    case get_by_pkey(Pkey) of
        [] -> ok;
        CrossWarPlayer ->
            NewCrossWarPlayer =
                CrossWarPlayer#cross_war_player{has_bomb = 0},
            update_war_player(NewCrossWarPlayer)
    end.

add_materis_player(Pkey, AddMateris) ->
    case get_by_pkey(Pkey) of
        [] -> skip;
        CrossWarGuild ->
            NewCrossWarGuild =
                CrossWarGuild#cross_war_player{
                    has_materis = max(0, CrossWarGuild#cross_war_player.has_materis + AddMateris)
                },
            update_war_player(NewCrossWarGuild)
    end.

send_online_score_reward(CrossWarPlayer, OldCrossWarPlayer) ->
    Id1 = data_cross_war_score_target:get_by_score(CrossWarPlayer#cross_war_player.score),
    Id2 = data_cross_war_score_target:get_by_score(OldCrossWarPlayer#cross_war_player.score),
    if
        Id1 == Id2 -> skip;
        Id2 == 0 -> skip;
        Id1 == 0 -> skip;
        true ->
            RewardList = data_cross_war_score_target:get(Id2),
            center:apply(CrossWarPlayer#cross_war_player.node, cross_war_battle, send_to_client_reward, [CrossWarPlayer#cross_war_player.pkey, RewardList, 686]),
            ok
    end.

get_main_by_gkey(Gkey) ->
    cross_area:war_apply_call(?MODULE, get_main_by_gkey_center, [Gkey]).

get_main_by_gkey_center(Gkey) ->
    case cross_war_util:get_by_g_key(Gkey) of
        [] -> 0;
        CrossWarGuild ->
            CrossWarGuild#cross_war_guild.sign
    end.

add_exp_data(State) when State#sys_cross_war.open_state == ?CROSS_WAR_STATE_START ->
    KeyList = scene_agent:get_scene_player_key_pid(?SCENE_ID_CROSS_WAR, 0),
    F = fun({Pkey, Pid}) ->
        case cross_war_util:get_by_pkey(Pkey) of
            [] -> skip;
            #cross_war_player{node = Node, score = Score} ->
                Mult = data_cross_war_exp_mult:get_by_score(Score),
                if
                    Mult == 0 -> skip;
                    true ->
                        server_send:send_node_pid(Node, Pid, {cross_war_kill_mon_exp, 52002, Mult})
                end
        end
    end,
    lists:map(F, KeyList),
    ok;
add_exp_data(_State) -> ok.

is_king_guild(Gkey) ->
    Sql = io_lib:format("select pkey from cross_war_king where gkey = ~p", [Gkey]),
    case db:get_row(Sql) of
        [Pkey] when is_integer(Pkey) -> Pkey;
        _ -> 0
    end.