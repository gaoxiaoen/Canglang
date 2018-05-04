%%%-------------------------------------------------------------------
%%% File        :hook_map.erl
%%% @doc
%%%     地图hook接口
%%%     处理每个地图进程的init,terminate和循环
%%% @end
%%%-------------------------------------------------------------------

-module(hook_map).

-include("mgeem.hrl").


%% API
-export([
         loop/3,
         loop_ms/0,
         init/5,
         terminate/0
        ]).


%%地图每秒钟的循环
loop(_MapId,MapType,FbId) ->
    _Now = common_tool:now(),
    case MapType of
        ?MAP_TYPE_FB ->
            ?TRY_CATCH(mod_map_monster:loop(),ErrMonster),
            case cfg_fb:find(FbId) of
                undefined ->
                    next;
                _ ->
                    ?TRY_CATCH(mod_common_fb:loop(),ErrFb)
            end,
            next;
        _ ->
            ?TRY_CATCH(mod_map_role:auto_recovery_mp(),ErrRole),
            next
    end,
    ok.

loop_ms() ->
    #r_map_state{map_type=MapType} = mgeem_map:get_map_state(),
    ?TRY_CATCH(mod_map:flush_all_role_msg_queue(), ErrFlushMsg),
    ?TRY_CATCH(mod_map_monster:loop_ms(),ErrMonster),
    case MapType of
        ?MAP_TYPE_FB ->
            ?TRY_CATCH(mod_map_role:auto_recovery_mp(),ErrRole);
        _ ->
            next
    end,
    ok.
    

init(MapId,_MapProcessName,MapType,FbId,CreateTime) ->
    mod_map:init_in_map_role(),
    case MapType of
        ?MAP_TYPE_FB ->
            mod_map_monster:init_monster_id_list(),
            case cfg_fb:find(FbId) of
                undefined ->
                    next;
                _ ->
                    mod_common_fb:init(FbId)
            end;
        _ ->
            next
    end,
    ?TRY_CATCH(mod_map_chat:hook_map_init(MapId, MapType, FbId, CreateTime),ErrChat),
    ok.

terminate() ->
    ?TRY_CATCH(mod_map_chat:hook_map_terminate(),ErrChat),
    ok.

