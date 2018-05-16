%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 八月 2017 14:28
%%%-------------------------------------------------------------------
-module(cross_war_map).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("cross_war.hrl").
-include("scene.hrl").

%% API
-export([
    init_map/2,
    update/2,
    update_king_gold/4,
    update_king_gold_x_y/1,

    get_war_map/2,
    get_war_map_cast/3
]).

init_map(SysWarMap, MonList) ->
    F = fun({_MonKey, _Pid, Mon}, AccSysWarMap) ->
        case Mon#mon.kind of
            ?MON_KIND_CROSS_WAR_BANNER ->
                AccSysWarMap#cross_war_map{
                    banner_info_list = [{Mon#mon.x, Mon#mon.y, Mon#mon.group} | AccSysWarMap#cross_war_map.banner_info_list]
                };
            ?MON_KIND_CROSS_WAR_TOWER ->
                AccSysWarMap#cross_war_map{
                    jt_info_list = [{Mon#mon.x, Mon#mon.y, Mon#mon.hp_lim, Mon#mon.hp_lim} | AccSysWarMap#cross_war_map.jt_info_list]
                };
            ?MON_KIND_CROSS_WAR_KING_GOLD ->
                AccSysWarMap#cross_war_map{
                    king_gold_x = Mon#mon.x,
                    king_gold_y = Mon#mon.y,
                    king_gold_pkey = 0
                };
            _ -> AccSysWarMap
        end
    end,
    NewSysWarMap = lists:foldl(F, SysWarMap, MonList),
    NewSysWarMap.

update(State, Mon) ->
    #sys_cross_war{map = Map} = State,
    #cross_war_map{
        banner_info_list = BannerInfoList,
        jt_info_list = JtInfoList
    } = Map,
    NewState =
        case Mon#mon.kind of
            ?MON_KIND_CROSS_WAR_BANNER ->
                F = fun({X, Y, _Group}) ->
                    Mon#mon.x /= X andalso Mon#mon.y /= Y
                end,
                NBannerInfoList = lists:filter(F, BannerInfoList),
                NewBannerInfoList = [{Mon#mon.x, Mon#mon.y, Mon#mon.group} | NBannerInfoList],
                State#sys_cross_war{
                    map = Map#cross_war_map{banner_info_list = NewBannerInfoList}
                };
            ?MON_KIND_CROSS_WAR_TOWER ->
                F = fun({X, Y, _Hp, _HpLim}) ->
                    Mon#mon.x /= X andalso Mon#mon.y /= Y
                end,
                NJtInfoList = lists:filter(F, JtInfoList),
                NewJtInfoList = [{Mon#mon.x, Mon#mon.y, Mon#mon.hp, Mon#mon.hp_lim} | NJtInfoList],
                State#sys_cross_war{
                    map = Map#cross_war_map{jt_info_list = NewJtInfoList}
                };
            _ ->
                State
        end,
    NewState.

update_king_gold(CrossWarMap, X, Y, Pkey) ->
    CrossWarMap#cross_war_map{king_gold_x = X, king_gold_y = Y, king_gold_pkey = Pkey}.

update_king_gold_x_y(CrossWarMap) ->
    case CrossWarMap#cross_war_map.king_gold_pkey == 0 of
        true -> CrossWarMap;
        false ->
            case scene_agent:get_scene_player(?SCENE_ID_CROSS_WAR, 0, CrossWarMap#cross_war_map.king_gold_pkey) of
                [] -> CrossWarMap;
                ScenePlayer ->
                    CrossWarMap#cross_war_map{
                        king_gold_x = ScenePlayer#scene_player.x,
                        king_gold_y = ScenePlayer#scene_player.y
                    }
            end
    end.

get_war_map(Node, Sid) ->
    ?CAST(cross_war_proc:get_server_pid(), {get_war_map, Node, Sid}).

get_war_map_cast(State, Node, Sid) ->
    #sys_cross_war{
        map = CrossWarMap
    } = State,
    KingGoldX = CrossWarMap#cross_war_map.king_gold_x,
    KingGoldY = CrossWarMap#cross_war_map.king_gold_y,
    BannerInfoList = CrossWarMap#cross_war_map.banner_info_list,
    JtInfoList = CrossWarMap#cross_war_map.jt_info_list,
    {ok, Bin} = pt_601:write(60127, {KingGoldX, KingGoldY, util:list_tuple_to_list(BannerInfoList), util:list_tuple_to_list(JtInfoList)}),
    server_send:send_to_sid(Node, Sid, Bin),
    ok.