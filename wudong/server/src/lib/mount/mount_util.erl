%% @author and_me
%% @doc @todo Add description to mount_util.


-module(mount_util).
-include("common.hrl").
-include("mount.hrl").
-include("error_code.hrl").

%% ====================================================================
%% API functions
%% ====================================================================
-export([get_mount/0, put_mount/1, get_off/1, get_on/1]).
-export([
    get_mount_level/0,
    get_mount_image/1
]).

-export([timer_update/0, logout/0]).

get_mount() ->
    lib_dict:get(?PROC_STATUS_MOUNT).


put_mount(Mount) ->
    lib_dict:put(?PROC_STATUS_MOUNT, Mount).

timer_update() ->
    MountSt = lib_dict:get(?PROC_STATUS_MOUNT),
    if MountSt#st_mount.is_change == 1 ->
        NewMount = MountSt#st_mount{is_change = 0},
        lib_dict:put(?PROC_STATUS_MOUNT, NewMount),
        mount_load:replace_mount(MountSt);
        true -> ok
    end.

logout() ->
    MountSt = lib_dict:get(?PROC_STATUS_MOUNT),
    if MountSt#st_mount.is_change == 1 ->
        mount_load:replace_mount(MountSt);
        true -> ok
    end.

%%下坐骑，游戏内部调用
get_off(Player) ->
    if Player#player.mount_id > 0 ->
        NewPlayer = Player#player{mount_id = 0},
        {ok, Bin} = pt_170:write(17006, {?ER_SUCCEED, 0}),
        server_send:send_to_sid(Player#player.sid, Bin),
        {ok, MountBin} = pt_120:write(12012, {Player#player.key, 0}),
        server_send:send_to_sid(Player#player.sid, MountBin),
        scene_agent_dispatch:mount_id_update(NewPlayer),
        NewPlayer;
        true -> Player
    end.

get_on(Player) ->
    if Player#player.mount_id == 0 ->
        MountId = mount_util:get_mount_image(?MOUNT_TYPE_NORMAL),
        NewPlayer = Player#player{mount_id = MountId},
        {ok, Bin} = pt_170:write(17006, {?ER_SUCCEED, 0}),
        server_send:send_to_sid(Player#player.sid, Bin),
        {ok, MountBin} = pt_120:write(12012, {Player#player.key, 0}),
        server_send:send_to_sid(Player#player.sid, MountBin),
        scene_agent_dispatch:mount_id_update(NewPlayer),
        NewPlayer;
        true -> Player
    end.

%%获取坐骑阶级
get_mount_level() ->
    Mount = get_mount(),
    Mount#st_mount.stage.


%%获取坐骑形象
get_mount_image(MountType) ->
    Mount = get_mount(),
    case MountType of
        ?MOUNT_TYPE_NORMAL ->
            %%普通坐骑
            Mount#st_mount.current_image_id;
        _ ->
            Mount#st_mount.current_sword_id
    end.

%% ====================================================================
%% Internal functions
%% ====================================================================


