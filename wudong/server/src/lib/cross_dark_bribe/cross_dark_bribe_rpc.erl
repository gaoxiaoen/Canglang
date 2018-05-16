%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 七月 2017 11:39
%%%-------------------------------------------------------------------
-module(cross_dark_bribe_rpc).
-author("lzx").
-export([handle/3]).

-include("server.hrl").
-include("common.hrl").
-include("cross_dark_bribe.hrl").
-include("scene.hrl").

%%获取面板信息
handle(40301, Player, {}) ->
    case cross_dark_bribe_proc:get_server_pid() of
        Pid when is_pid(Pid) ->
            #player_info{task_list = TaskLit, get_task_ids = GetTaskIds} = lib_dict:get(?PROC_STATUS_CROSS_DARK_BRIBE),
            TList2 = cross_dark_bribe:get_task_list(TaskLit),
            gen_server:cast(Pid, {get_panel_info, [Player#player.sid, Player#player.key, Player#player.sn_cur, TList2, GetTaskIds]});
        _ ->
            ?WARNING("get_panel_info fail"),
            ok
    end,
    ok;

%% 请求个人排行榜
handle(40302, Player, {}) ->
    case cross_dark_bribe_proc:get_server_pid() of
        Pid when is_pid(Pid) ->
            gen_server:cast(Pid, {get_person_rank, Player#player.key, Player#player.sid});
        _ ->
            ?WARNING("get_person_rank fail"),
            ok
    end,
    ok;

%% 请求全服排行榜
handle(40303, Player, {}) ->
    case cross_dark_bribe_proc:get_server_pid() of
        Pid when is_pid(Pid) ->
            gen_server:cast(Pid, {get_server_rank, Player#player.sid, Player#player.sn_cur});
        _ ->
            ?WARNING("get_server_rank fail"),
            ok
    end;

%% 请求场景进入信息
handle(40304, Player, {}) ->
    case cross_dark_bribe_proc:get_server_pid() of
        Pid when is_pid(Pid) ->
            gen_server:cast(Pid, {get_scene_lv, Player#player.sid});
        _ ->
            ?WARNING("get_scene_lv fail"),
            ok
    end;


%% 请求领取奖励
handle(40305, Player, {Task_ID}) ->
    {Res, NewPlayer} = cross_dark_bribe:get_award(Player, Task_ID),
    ?DEBUG("reward task ~p res ~p~n",[Task_ID,Res]),
    {ok, Bin} = pt_403:write(40305, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Res == 1 ->
        handle(40301, NewPlayer, {}),
        activity:get_notice(Player, [141], true);
        true -> ok
    end,
    {ok, NewPlayer};


%%请求进入跨服深渊
handle(40306, Player, {SceneId,IsPeace}) ->
    {Ret, NewPlayer} =
        if
            Player#player.convoy_state > 0 -> {2, Player};
            Player#player.marry#marry.cruise_state > 0 -> {3, Player};
            Player#player.match_state > 0 -> {4, Player};
            true ->
%%                case scene:is_normal_scene(Player#player.scene) of
%%                    false -> {5,Player};
%%                    true ->
                DarkPid = cross_dark_bribe_proc:get_server_pid(),
                case ?CALL(DarkPid, {check_enter_scene, SceneId, Player#player.lv}) of
                    ECode when is_integer(ECode) ->
                        case ECode of
                            1 ->
                                CopyId = ?IF_ELSE(IsPeace == 1,1,0),
                                #config_darak_bribe_scene_lv{xy = PoseList} = data_cross_dark_scene_lv:get(SceneId),
                                {X,Y} = util:list_rand(PoseList),
                                Player1 = scene_change:change_scene(Player, SceneId,CopyId,X,Y,true),
                                Player2 = cross_dark_bribe:refresh_buff_enter(Player1, Player#player.scene),
                                PkStatus = ?IF_ELSE(IsPeace == 1,?PK_TYPE_PEACE,?PK_TYPE_SERVER),
                                Player3 = player_battle:pk_change_sys(Player2, PkStatus, 1),
                                {1, Player3};
                            _ ->
                                {ECode, Player}
                        end;
                    _ ->
                        {7, Player}
                end
        end,
    {ok, Bin} = pt_403:write(40306, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%请求退出
handle(40307, Player, {}) ->
    {Ret, NewPlayer} =
        case scene:is_cross_dark_blibe(Player#player.scene) of
            true ->
                Player0 = cross_dark_bribe:del_buff_quit(Player),
                Player1 = scene_change:change_scene_back(Player0),
                Player2 = player_battle:pk_change(Player1, Player#player.pk#pk.pk_old, 1),
                {1, Player2};
            _ ->
                {8, Player}
        end,
    {ok, Bin} = pt_403:write(40307, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%% 请求跨服深渊数据
handle(40308, Player, {}) ->
    case scene:is_cross_dark_blibe(Player#player.scene) of
        true ->
            #player_info{task_list = TaskLit, get_task_ids = GetTaskIds, t_val = S_Val} = lib_dict:get(?PROC_STATUS_CROSS_DARK_BRIBE),
            DarkPid = cross_dark_bribe_proc:get_server_pid(),
            TList2 = cross_dark_bribe:get_task_list(TaskLit),
            ?CAST(DarkPid, {get_cross_dark_scene_info,
                [Player#player.key, Player#player.sn_cur, Player#player.sid, TList2, GetTaskIds, S_Val]});
        _ ->
            ok
%%            ?WARNING("Player not in cross dark blibe scene ~w", [Player#player.key])
    end;


handle(_CMD, _Player, _) ->
    ?ERR("no match cmd:~w", [_CMD]),
    ok.






