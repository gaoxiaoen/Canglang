%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% gm测试命令板块
%%% @end
%%% Created : 01. 九月 2017 13:51
%%%-------------------------------------------------------------------
-module(cross_war_gm).
-author("li").
-include("common.hrl").
-include("server.hrl").
-include("cross_war.hrl").

-export([
    gm_day_1/0 %% 周1重置
    , gm_king/1 %% 将自己设置成王者
    , gm_midnight_refresh/0
    , gm_center_king/1
    , gm_center_king_cast/2
    , gm_sys_midnight_refresh_cast/1
    , gm_ready/0
    , gm_ready_center/0
    , gm_sys_midnight_refresh_center/0
    , gm_add_materis/1
    , gm_add_materis/2
    , gm_add_score/2
    , gm_add_score_center/2
]).

gm_day_1() ->
    gm_sys_midnight_refresh(),
    ok.

gm_king(Player) ->
    cross_area:war_apply(cross_war_gm, gm_center_king, [Player]).

gm_center_king(Player) ->
    ?CAST(cross_war_proc:get_server_pid(), {gm_center_king, Player}).

gm_center_king_cast(State, Player) ->
    NewKingInfo =
        #cross_war_king{
            pkey = Player#player.key,
            nickname = Player#player.nickname,
            sex = Player#player.sex,
            couple_key = Player#player.marry#marry.couple_key, %% 城主夫人key
            couple_nickname = Player#player.marry#marry.couple_name,
            couple_sex = Player#player.marry#marry.couple_sex,
            acc_win = 5, %% 连续占领次数
            node = Player#player.node,
            sn = Player#player.sn,
            sn_name = ?IF_ELSE(Player#player.sn_name == null, ?T("测试服"), Player#player.sn_name),
            g_key = Player#player.guild#st_guild.guild_key, g_name = Player#player.guild#st_guild.guild_name,
            war_info = gm_war_info()
        },
    State#sys_cross_war{king_info = NewKingInfo}.

gm_war_info() ->
    AllCrossWarPlayer = cross_war_util:get_all_player(),
    F = fun(CrossWarPlayer, {Count, AccList}) ->
        {Count + 1, [cross_war_util:to_cross_war_log(Count, CrossWarPlayer) | AccList]}
    end,
    {_, LL} = lists:foldl(F, {1, []}, AllCrossWarPlayer ++ AllCrossWarPlayer ++ AllCrossWarPlayer ++ AllCrossWarPlayer ++ AllCrossWarPlayer),
    LL.

gm_midnight_refresh() ->
    StCrossWar = lib_dict:get(?PROC_STATUS_CROSS_WAR),
    lib_dict:put(?PROC_STATUS_CROSS_WAR, #st_cross_war{pkey = StCrossWar#st_cross_war.pkey}).


gm_sys_midnight_refresh() ->
    Sql = io_lib:format("update guild_cross_war_sign set change_time=0", []),
    db:execute(Sql),
    Sql2 = io_lib:format("update player_cross_war set contrib=0,contrib_list='[]',is_recv_king=0,is_recv_member=0", []),
    db:execute(Sql2),
    cross_area:war_apply(?MODULE, gm_sys_midnight_refresh_center, []),
    OnlineList = ets:tab2list(?ETS_ONLINE),
    F = fun(#ets_online{pid = Pid}) ->
        Pid ! gm_cross_war_clean_data
    end,
    lists:map(F, OnlineList),
    skip.

gm_sys_midnight_refresh_center() ->
    cross_war_proc:get_server_pid() ! gm_sys_midnight_refresh.

gm_sys_midnight_refresh_cast(State) ->
    #sys_cross_war{king_info = KingInfo, last_king_info = LastKingInfo} = State,
    if
        KingInfo#cross_war_king.g_key /= 0 -> cross_war:set_sign(KingInfo#cross_war_king.g_key, ?CROSS_WAR_TYPE_DEF);
        true -> skip
    end,
    if
        KingInfo#cross_war_king.g_key == LastKingInfo#cross_war_king.g_key -> skip;
        LastKingInfo#cross_war_king.g_key /= 0 ->
            cross_war:set_sign(LastKingInfo#cross_war_king.g_key, ?CROSS_WAR_TYPE_ATT);
        true -> skip
    end,
    spawn(fun() ->
        cross_war_util:delete_war_guild_all_week_1(),
        cross_war_util:delete_war_player_all_week_1()
    end),
    State#sys_cross_war{
        def_guild_list = [],
        att_guild_list = [],
        def_player_list = [],
        att_player_list = [],
        mon_list = [],
        collect_num = 0
    }.

gm_add_materis(Player) ->
    cross_area:war_apply(?MODULE, gm_add_materis, [Player, 99999]).

gm_add_materis(Player, Val) ->
    CrossWarPlayer = cross_war_util:get_by_pkey(Player#player.key),
    cross_war_util:update_war_player(CrossWarPlayer#cross_war_player{has_materis = Val}).

gm_add_score(Player, N) ->
    cross_area:war_apply(?MODULE, gm_add_score_center, [Player, N]).

gm_add_score_center(Player, Val) ->
    CrossWarPlayer = cross_war_util:get_by_pkey(Player#player.key),
    cross_war_util:update_war_player(CrossWarPlayer#cross_war_player{score = Val}).

gm_ready() ->
    cross_area:war_apply(cross_war_gm, gm_ready_center, []).

gm_ready_center() ->
    cross_war_proc:get_server_pid() ! gm_ready_center.