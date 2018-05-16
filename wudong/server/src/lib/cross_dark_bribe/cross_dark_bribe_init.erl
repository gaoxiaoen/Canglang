%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 七月 2017 11:37
%%%-------------------------------------------------------------------
-module(cross_dark_bribe_init).
-author("lzx").
-include("server.hrl").
-include("common.hrl").
-include("cross_dark_bribe.hrl").

%% API
-export([
%%    do_init/0,
    init_server/3,
    calc_max_lv/1,
    refresh_mon_attribute/1,
    db_update/1
]).
-export([test/0]).

%% 初始化
%%do_init() ->
%%    Nodes = center:get_all_nodes(),
%%    Ids = lists:sort([SNId || #ets_kf_nodes{sn = SNId} <- Nodes]),
%%    EnterLvList = reset_enter_lv_list(Nodes),
%%    ServerDict =
%%        lists:foldl(fun(#ets_kf_nodes{sn = ServerId, sn_name = Sn_Name}, ServerDict) ->
%%            util:sleep(100),
%%            ServerInfo = init_server(ServerId, Sn_Name),
%%            dict:store(ServerId, ServerInfo, ServerDict)
%%                    end, dict:new(), Nodes),
%%    #cross_dark_bribe_state{scene_open_lv = EnterLvList, server_dict = ServerDict, ids = Ids}.

%%
%%%%检测是否有新服加入
%%check_new_server(#cross_dark_bribe_state{ids = Ids, server_dict = ServerDict} = State) ->
%%    Nodes = center:get_all_nodes(),
%%    NowIds = lists:sort([SNId || #ets_kf_nodes{sn = SNId} <- Nodes]),
%%    if NowIds == Ids -> State;
%%        true ->
%%            ?PRINT("new server join in ~w", [NowIds]),
%%            DiffIds = NowIds -- Ids,
%%            NewDict =
%%                lists:foldl(fun(ServerId, Dict) ->
%%                    util:sleep(100),
%%                    Sn_Name = center:get_sn_name_by_sn(ServerId),
%%                    ServerInfo = init_server(ServerId, Sn_Name),
%%                    dict:store(ServerId, ServerInfo, Dict)
%%                            end, ServerDict, DiffIds),
%%            EnterLvList = reset_enter_lv_list(Nodes),
%%            update_scene_mon_attr(EnterLvList),
%%
%%            %%删除切区的服
%%            F = fun(SnIdOld, D) ->
%%                case lists:member(SnIdOld, NowIds) of
%%                    true -> D;
%%                    false ->
%%                        Sql = io_lib:format("delete from cross_dark_bribe where id=~p", [SnIdOld]),
%%                        db:execute(Sql),
%%                        dict:erase(SnIdOld, D)
%%                end
%%                end,
%%            NewDict1 = lists:foldl(F, NewDict, Ids),
%%            State#cross_dark_bribe_state{ids = NowIds, server_dict = NewDict1, scene_open_lv = EnterLvList}
%%    end.



calc_max_lv(Dict) ->
    case [ServerInfo#server_info.plv || {_, ServerInfo} <- dict:to_list(Dict)] of
        [] -> 0;
        List ->
            Len = length(List),
            lists:sum(List) / Len
    end.


init_server(ServerId, Sn_Name, Plv) ->
    MidNight = util:unixdate(),
    Sql = io_lib:format("select id,p_num,t_val,task_list,time from cross_dark_blibe where id = ~p and time > ~p limit 1", [ServerId, MidNight]),
    case db:get_row(Sql) of
        [Id, NumList, T_Val, TaskListBin, Time] ->
            NumList2 = util:bitstring_to_term(NumList),
            #server_info{id = Id, s_n = Sn_Name, plv = Plv, p_list = NumList2, t_val = T_Val, task_list = util:bitstring_to_term(TaskListBin), time = Time};
        _ ->
            InitTask = [{?TASK_SUB_TYPE_KILL_MON, 0}, {?TASK_SUB_TYPE_KILL_PLAYER, 0}, {?TASK_SUBTYPE_TAKE_VALUE, 0}],
            ServerInfo = #server_info{id = ServerId, s_n = Sn_Name, plv = Plv, time = util:unixtime(), task_list = InitTask},
            db_update(ServerInfo),
            ServerInfo
    end.

%% db 更新
db_update(#server_info{id = ServerId, p_list = PList, t_val = TVal, task_list = TaskList,time = Time}) ->
    InsertSql = io_lib:format("replace into cross_dark_blibe set id = ~p,p_num = '~s',t_val = ~p,task_list = '~s',time = ~p",
        [ServerId, util:term_to_bitstring(PList), TVal, util:term_to_bitstring(TaskList), Time]),
    db:execute(InsertSql).


refresh_mon_attribute(MaxLv) ->
    EnterLvList = reset_enter_lv_list(MaxLv),
    update_scene_mon_attr(EnterLvList),
    EnterLvList.


reset_enter_lv_list(MaxLv) ->
    SceneIds = data_cross_dark_scene_lv:ids(),
    lists:map(fun(SceneId) ->
        #config_darak_bribe_scene_lv{min_rate = MinRate, max_rate = MaxRate, lv_min = LvMin} = data_cross_dark_scene_lv:get(SceneId),
        Min1 = round(MinRate * MaxLv / 100),
        Max1 = round(MaxRate * MaxLv / 100),
        Max2 =
            case LvMin > Max1 of
                true ->
                    case data_cross_dark_scene_lv:get(SceneId + 1) of
                        #config_darak_bribe_scene_lv{lv_min = Lv2} -> Lv2;
                        _ ->
                            MaxLv
                    end;
                _ -> Max1
            end,
        Min2 = max(Min1, LvMin),
        Max22 = max(Min2,Max2),
        {SceneId, Min2, Max22}
              end, SceneIds).




%% 场景怪物更新
update_scene_mon_attr([]) -> ok;
update_scene_mon_attr([{SceneId, MinLv, MaxLv} | T]) ->
    DiffLv = MinLv + round((MaxLv - MinLv) * 0.8),
    lists:foreach(fun(CopyId) ->
        case mon_agent:get_scene_mon_pids(SceneId, CopyId) of
            List when is_list(List) ->
                [MonPid ! {change_attr, [{world_lv, DiffLv}]} || MonPid <- List];
            _ ->
                ok
        end
                  end,lists:seq(0,1)),
    update_scene_mon_attr(T).

test() ->
    Nodes = center:get_all_nodes(),
    L = reset_enter_lv_list(Nodes),
    update_scene_mon_attr(L).











