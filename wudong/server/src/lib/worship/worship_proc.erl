%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 膜拜
%%% @end
%%% Created : 18. 三月 2016 上午11:36
%%%-------------------------------------------------------------------
-module(worship_proc).
-author("fengzhenlin").

-behaviour(gen_server).

-include("worship.hrl").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("rank.hrl").
-include("guild.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([
    get_worship_pid/0,
    new_copy_create_mon/0  %%场景分线创建城主
]).

-define(SERVER, ?MODULE).


%%%===================================================================
%%% API
%%%===================================================================

get_worship_pid() ->
    case get(worship_pid) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    put(worship_pid, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

%%场景新线，创建城主
new_copy_create_mon() ->
    catch get_worship_pid() ! {new_copy_create}.

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    process_flag(trap_exit,true),
    erlang:send_after(20000,self(), check_change_people), %%避免关服等问题导致没换城主
    Worship = worship_load:dbget_worhisp(),
    {ok, Worship}.

handle_call(Request, _From, State) ->
    case catch call(Request, State) of
        {reply, Reply, State} ->
            {reply, Reply, State};
        _Err ->
            ?ERR("worship call err ~p~n",[_Err]),
            {reply, ok, State}
    end.

call(_Requst, State) ->
    ?ERR("worship unknow call ~p~n",[_Requst]),
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(Info, State) ->
    case catch info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        _Err ->
            ?ERR("worship handle info return err ~p~n",[_Err]),
            {noreply, State}
    end.

info(check_change_people, State) ->
    OpenDay = config:get_open_days(),
    if
        OpenDay =< 1 -> {noreply, State};
        true ->
            Now = util:unixtime(),
            F = fun(Type, AccWorship) ->
                    case lists:keyfind(Type, #worship_player.type, State#worship.worship_list) of
                        false ->
                            change_people(Type, AccWorship);
                        WorshipPlayer ->
                            case util:is_same_date(Now, WorshipPlayer#worship_player.update_time) of
                                true ->
                                    {MonId, _X, _Y} = get_type_mon(Type),
                                    case mon_agent:get_scene_mon_by_mid(?WORSHIP_SCENE, 0, MonId) of
                                        [] -> %%没有，创建
                                            change_people(Type, AccWorship);
                                        _ ->
%%                                             AccWorship
                                            change_people(Type, AccWorship)
                                    end;
                                false ->
                                    change_people(Type, AccWorship)
                            end
                    end
                end,
            NewWorship = lists:foldl(F, State, lists:seq(1, 3)),
            {noreply, NewWorship}
    end;
info(gm_refresh, State) ->
    %%换人
    F = fun(Type, AccWorship) ->
        change_people(Type, AccWorship)
    end,
    NewWorship = lists:foldl(F, State, lists:seq(1, 3)),
    {noreply, NewWorship};

info({new_copy_create}, State) ->
    CopyList = scene_copy_proc:get_scene_copy_ids(?WORSHIP_SCENE),
    F1= fun(Type) ->
            case lists:keyfind(Type, #worship_player.type, State#worship.worship_list) of
                false -> skip;
                WorshipPlayer ->
                    {MonId,_X,_Y} = get_type_mon(Type),
                    F = fun(Copy) ->
                        case mon_agent:get_scene_mon_by_mid(?WORSHIP_SCENE, Copy, MonId) of
                            [] -> %%没有，创建
                                create_worship_mon(WorshipPlayer#worship_player.pkey, Type, Copy);
                            _ ->
                                skip
                        end
                    end,
                    lists:foreach(F, CopyList)
            end
        end,
    lists:foreach(F1, lists:seq(1, 3)),
    {noreply, State};

info(_Info, State) ->
    ?ERR("worship unknow handle_info ~p~n",[_Info]),
    {noreply, State}.

terminate(_Reason, State) ->
    worship_load:dbup_worship(State),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%%更换城主
change_people(Type, Worship) ->
    WorshipPlayer =
    case Type of
        1 ->
            case guild_util:get_guild_top_n_list(1) of
                [] -> [];
                [Guild|_] ->
                    #guild{
                        pkey = GPkey
                    } = Guild,
                    #worship_player{
                        type = Type,
                        pkey = GPkey
                    }
            end;
        2 ->
            case rank:get_rank_top_N(1, 1) of
                [] -> [];
                [ARank|_] ->
                    #a_rank{
                        pkey = CPkey
                    } = ARank,
                    #worship_player{
                        type = Type,
                        pkey = CPkey
                    }
            end;
        3 ->
            case rank:get_rank_top_N(2, 1) of
                [] -> [];
                [ARank|_] ->
                    #a_rank{
                        pkey = LPkey
                    } = ARank,
                    #worship_player{
                        type = Type,
                        pkey = LPkey
                    }
            end
    end,
    case WorshipPlayer of
        [] ->
            Worship;
        _ ->
            {MonId, _X, _Y} = get_type_mon(Type),
            %%先杀掉以前的城主怪物
            kill_worship_mon(MonId),
            %%创建城主怪物
            create_worship_mon(WorshipPlayer#worship_player.pkey, Type),
            WorshipPlayer1 = WorshipPlayer#worship_player{update_time = util:unixtime()},
            NewWorshipList = [WorshipPlayer1|lists:keydelete(Type, #worship_player.type, Worship#worship.worship_list)],
            Worship#worship{
                worship_list = NewWorshipList
            }
    end.

%%杀掉城主怪物
kill_worship_mon(MonId) ->
    CopyList = scene_copy_proc:get_scene_copy_ids(?WORSHIP_SCENE),
    F = fun(Copy) ->
            case mon_agent:get_scene_mon_by_mid(?WORSHIP_SCENE, Copy, MonId) of
                [] -> %%没有
                    skip;
                MonList ->
                    F = fun(Mon) ->
                        monster:stop_broadcast(Mon#mon.pid)
                    end,
                    lists:foreach(F,MonList)
            end
        end,
    lists:foreach(F, CopyList).
create_worship_mon(Pkey, Type) ->
    create_worship_mon(Pkey, Type, 0).
create_worship_mon(Pkey, Type,CopyId) ->
    SceneId = ?WORSHIP_SCENE,
    {MonId,X,Y} = get_type_mon(Type),
    Player =
        case player_util:get_player(Pkey) of
            [] -> %%玩家离线
                shadow_proc:get_shadow(Pkey);
            Player0 ->
                Player0
        end,
    MountId =
        case Type of
            1 ->
                case data_mount:get(Player#player.mount_id) of
                    [] ->
                        Sql = io_lib:format("select current_image_id from mount where pkey = ~p",[Pkey]),
                        case db:get_row(Sql) of
                            [] -> 100001;
                            [CurMountId] -> CurMountId
                        end;
                    _ ->
                        Player#player.mount_id
                end;
            _ -> %%后面的雕像显示飞行器
                Sql = io_lib:format("select current_sword_id from mount where pkey = ~p",[Pkey]),
                case db:get_row(Sql) of
                    [] -> 1;
                    [CurMountId] -> CurMountId
                end
        end,
    DesId = get_type_des_id(Type),
    Shadow = shadow_init:init_shadow(Player#player{nickname = Player#player.nickname, mount_id = MountId, design = [DesId], pet = #fpet{}}),
    %%需要创建的房间列表
    CopyList =
        case CopyId == 0 of
            true -> scene_copy_proc:get_scene_copy_ids(?WORSHIP_SCENE);
            false -> [CopyId]
        end,
    lists:foreach(
        fun(Copy) ->
            shadow:create_shadow_for_worship(Shadow, MonId, SceneId, Copy, X, Y, [{mount_id, MountId}])
        end,CopyList
    ).


get_type_mon(Type) ->
    case Type of
        1 -> {50001, 37, 47};
        2 -> {50002, 40, 36};
        3 -> {50003, 26, 50}
    end.

get_type_des_id(Type) ->
    case Type of
        1 -> 10010;
        2 -> 10011;
        3 -> 10012
    end.

