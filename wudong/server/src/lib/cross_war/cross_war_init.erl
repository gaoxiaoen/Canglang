%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2017 11:21
%%%-------------------------------------------------------------------
-module(cross_war_init).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("cross_war.hrl").
-include("scene.hrl").
-include("goods.hrl").
-include("rank.hrl").

%% API
-export([
    init/1,
    init_ets/0,
    init_mon/0,
    init_mon_lv/0,

    get_max_lv/0
]).

init_ets() ->
    ets:new(?ETS_CROSS_WAR_GUILD, [{keypos, #cross_war_guild.g_key} | ?ETS_OPTIONS]),
    ets:new(?ETS_CROSS_WAR_PLAYER, [{keypos, #cross_war_player.pkey} | ?ETS_OPTIONS]),
    ok.

init(#sys_cross_war{} = StCrossWar) ->
    case config:is_center_node() of
        true -> skip;
        false -> spawn(fun() -> timer:sleep(30000), cross_war_repair:timer() end)
    end,
    StCrossWar;

init(#player{key = Pkey} = Player) ->
    StCrossWar =
        case player_util:is_new_role(Player) of
            true -> #st_cross_war{pkey = Pkey};
            false -> cross_war_load:load(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_CROSS_WAR, StCrossWar),
    cross_war:update_player_cross_war(),
    Player.

init_mon() ->
    MonIdList = data_cross_war_mon:ids(),
    F = fun(Id) ->
        {MonId, X, Y} = data_cross_war_mon:get_xy(Id),
        case data_mon:get(MonId) of
            [] -> [];
            Mon ->
                {Key, Pid} = mon_agent:create_mon([MonId, ?SCENE_ID_CROSS_WAR, X, Y, 0, 1, [{return_id_pid, true}, {group, ?CROSS_WAR_TYPE_DEF}]]),
                [{Key, Pid, Mon#mon{hp = Mon#mon.hp_lim, x = X, y = Y, group = ?CROSS_WAR_TYPE_DEF}}]
        end
    end,
    lists:flatmap(F, MonIdList).

init_mon_lv() ->
    KfNodes = center:get_war_nodes(),
    F = fun(Node) ->
        case center:apply_call(Node, ?MODULE, get_max_lv, []) of
            Lv when is_integer(Lv) -> [Lv];
            [] -> []
        end
    end,
    LvList = lists:flatmap(F, KfNodes),
    LvMax = if
                LvList == [] -> 60;
                true -> round(lists:max(LvList) * 0.8)
            end,
    case mon_agent:get_scene_mon_pids(?SCENE_ID_CROSS_WAR, 0) of
        List when is_list(List) ->
            [MonPid ! {change_attr, [{world_lv, LvMax}]} || MonPid <- List];
        _ ->
            ok
    end,
    ok.

%% 到游戏服中来拿数据
get_max_lv() ->
    case rank:get_rank_top_N(?RANK_TYPE_LV,1) of
        [] ->
            [];
        [#a_rank{rp = Rp}] ->
            Rp#rp.lv
    end.