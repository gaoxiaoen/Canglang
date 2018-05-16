%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 仙阶
%%% @end
%%% Created : 16. 十月 2017 16:49
%%%-------------------------------------------------------------------
-module(xian_upgrade).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("xian.hrl").
-include("goods.hrl").
-include("battle.hrl").
-include("scene.hrl").
-include("task.hrl").

%% API
-export([
    init/1,
    get_task_info/1,
    commit_task/2,
    upgrage/1,
    get_task_id/0,
    init_task_info/1
]).

-export([
    get_attr/1,
    check_kill_mon/1,
    kill_mon/1,
    logout/0,
    gm/1
]).

gm(TaskId) ->
    StXianStage = lib_dict:get(?PROC_STATUS_XIAN_STAGE),
    #st_xian_stage{task_info = TaskInfo} = StXianStage,
    NewTaskInfo = lists:keyreplace(TaskId, 1, TaskInfo, {TaskId, 718, 1}),
    lib_dict:put(?PROC_STATUS_XIAN_STAGE, StXianStage#st_xian_stage{task_info = NewTaskInfo}),
    ok.

init(#player{key = Pkey, lv = Lv} = Player) ->
    StXianStage =
        case player_util:is_new_role(Player) of
            true -> #st_xian_stage{pkey = Pkey};
            false -> xian_load:dbget_xian_upgrade(Pkey)
        end,
    NStXianStage = cacl_attr(StXianStage),
    NewStXianStage =
        if
            NStXianStage#st_xian_stage.task_info == [] ->
                NStXianStage#st_xian_stage{task_info = [{1, 0, 0}, {2, 0, 0}, {3, 0, 0}]};
            true ->
                NStXianStage
        end,
    lib_dict:put(?PROC_STATUS_XIAN_STAGE, NewStXianStage),
    OpenLv = data_menu_open:get(71),
    Stage = ?IF_ELSE(Lv < OpenLv - 10, 0, NewStXianStage#st_xian_stage.stage),
    Player#player{xian_stage = Stage}.

cacl_attr(StXianStage) ->
    #st_xian_stage{stage = Stage} = StXianStage,
    #base_xian_upgrade{
        attr = AttrList
    } = data_feixian_upgrade:get(Stage),
    StXianStage#st_xian_stage{
        attr = attribute_util:make_attribute_by_key_val_list(AttrList)
    }.

get_attr(Player) ->
    Lv = data_menu_open:get(71),
    if
        Player#player.lv < Lv -> #attribute{};
        true ->
            StXianStage = lib_dict:get(?PROC_STATUS_XIAN_STAGE),
            #st_xian_stage{attr = Attr} = StXianStage,
            Attr
    end.

get_task_info(Player) ->
    StXianStage = lib_dict:get(?PROC_STATUS_XIAN_STAGE),
    #st_xian_stage{
        stage = Stage,
        task_info = TaskInfo
    } = StXianStage,
    F = fun({TaskId, Num, Status}) ->
        case data_feixian_upgrade:get(Stage) of
            [] -> [];
            #base_xian_upgrade{condition = Condition} ->
                case lists:keyfind(TaskId, 1, Condition) of
                    false -> [];
                    {TaskId, get_goods, GoodsId, BaseNum, _Desc} ->
                        HasNum = goods_util:get_goods_count(GoodsId),
                        [[TaskId, HasNum, BaseNum, Status]];
                    {TaskId, kill_mon, _MonId, BaseNum, _Desc, _Id} ->
                        [[TaskId, Num, BaseNum, Status]];
                    {TaskId, pass_dungeon, _DunId, BaseNum, _Desc} ->
                        [[TaskId, Num, BaseNum, Status]];
                    _EE ->
                        []
                end
        end
        end,
    LL = lists:flatmap(F, TaskInfo),
    OpenLv = data_menu_open:get(71),
    ProStage = ?IF_ELSE(Player#player.lv < OpenLv, 0, Stage),
    {ProStage, LL}.

%% 任务提交
commit_task(Player, TaskId) ->
    StXianStage = lib_dict:get(?PROC_STATUS_XIAN_STAGE),
    #st_xian_stage{
        stage = Stage,
        task_info = TaskInfo
    } = StXianStage,
    case check_commit(TaskInfo, Player, TaskId, Stage) of
        {false, Code} ->
            Code;
        {true, NewTaskInfo} ->
            if
                NewTaskInfo == TaskInfo -> skip;
                true ->
                    NewStXianStage = StXianStage#st_xian_stage{task_info = NewTaskInfo},
                    lib_dict:put(?PROC_STATUS_XIAN_STAGE, NewStXianStage),
                    xian_load:dbup_xian_upgrade(NewStXianStage)
            end,
            task_xian:refresh_task(Player, true),
            1
    end.

check_commit(TaskInfo, Player, TaskId, Stage) ->
    case lists:keytake(TaskId, 1, TaskInfo) of
        false -> {false, 0};
        {value, {TaskId, HasNum, Status}, Ret} ->
            if
                Status == 1 -> {true, TaskInfo};
                true ->
                    case data_feixian_upgrade:get(Stage) of
                        [] -> {false, 0};
                        #base_xian_upgrade{condition = Condition} ->
                            case lists:keyfind(TaskId, 1, Condition) of
                                false -> {false, 0};
                                {TaskId, get_goods, GoodsId, BaseNum, _Desc} ->
                                    GoodsCount = goods_util:get_goods_count(GoodsId),
                                    if
                                        GoodsCount >= BaseNum ->
                                            NewTaskInfo = [{TaskId, GoodsCount, 1} | Ret],
                                            {ok, _} = goods:subtract_good(Player, [{GoodsId, BaseNum}], 718),
                                            {true, NewTaskInfo};
                                        true ->
                                            {false, 5}
                                    end;
                                {TaskId, kill_mon, _MonId, BaseNum, _Desc, _Id} ->
                                    if
                                        HasNum >= BaseNum ->
                                            NewTaskInfo = [{TaskId, HasNum, 1} | Ret],
                                            {true, NewTaskInfo};
                                        true ->
                                            {false, 9}
                                    end;
                                {TaskId, pass_dungeon, _DunId, BaseNum, _Desc} ->
                                    if
                                        HasNum >= BaseNum ->
                                            NewTaskInfo = [{TaskId, HasNum, 1} | Ret],
                                            {true, NewTaskInfo};
                                        true ->
                                            {false, 10}
                                    end
                            end
                    end
            end
    end.

upgrage(Player) ->
    StXianStage = lib_dict:get(?PROC_STATUS_XIAN_STAGE),
    #st_xian_stage{
        task_info = TaskInfo
    } = StXianStage,
    F = fun({TaskId, _HasNum, Status}) ->
        ?IF_ELSE(Status == 1, [], [TaskId])
        end,
    LL = lists:flatmap(F, TaskInfo),
    if
        LL /= [] ->
            {0, Player};
        true ->
            upgrage2(StXianStage, Player)
    end.

upgrage2(StXianStage, Player) ->
    #st_xian_stage{stage = Stage} = StXianStage,
    NStXianStage = StXianStage#st_xian_stage{stage = Stage + 1, task_info = [{1, 0, 0}, {2, 0, 0}, {3, 0, 0}]},
    NewStXianStage = cacl_attr(NStXianStage),
    lib_dict:put(?PROC_STATUS_XIAN_STAGE, NewStXianStage),
    xian_load:dbup_xian_upgrade(NewStXianStage),
    NewPlayer = player_util:count_player_attribute(Player, true),
    Sql = io_lib:format("insert into log_xian_upgrade set pkey=~p, stage=~p, time=~p",
        [Player#player.key, Stage + 1, util:unixtime()]),
    log_proc:log(Sql),
    NewPlayer99 = NewPlayer#player{xian_stage = Stage + 1},
    player_handle:sync_data(xian_stage, NewPlayer99),
    task_xian:refresh_task(NewPlayer99, true),
    {1, NewPlayer99}.

get_mon_ids() ->
    F = fun(N) ->
        case data_feixian_upgrade:get(N) of
            #base_xian_upgrade{condition = Condition} when Condition /= [] ->
                {_TaskId, _Type, MonId, _desc, _Id1, _Id2} = lists:keyfind(kill_mon, 2, Condition),
                [MonId];
            _ -> []
        end
        end,
    lists:flatmap(F, lists:seq(1, 15)).

%%kill_mon(Mon, Attacker) ->
%%    case get(is_xian_mon) of
%%        true ->
%%            #attacker{pid = Pid} = Attacker,
%%            Pid ! {xian_kill_mon, Mon#mon.mid};
%%        _ ->
%%            MonIdList = get_mon_ids(),
%%            case lists:member(Mon#mon.mid, MonIdList) of
%%                true ->
%%                    put(is_xian_mon, true),
%%                    #attacker{pid = Pid} = Attacker,
%%                    Pid ! {xian_kill_mon, Mon#mon.mid};
%%                _ ->
%%                    skip
%%            end
%%    end.

check_kill_mon(Mid) ->
    MonIdList =
        case get(xian_mon_ids) of
            undefined ->
                Ids = get_mon_ids(),
                put(xian_mon_ids, Ids),
                Ids;
            L -> L
        end,
    case lists:member(Mid, MonIdList) of
        true ->
            kill_mon(Mid);
        _ ->
            skip
    end.

kill_mon(Mid) ->
    StXianStage = lib_dict:get(?PROC_STATUS_XIAN_STAGE),
    #st_xian_stage{
        task_info = TaskInfo,
        stage = Stage
    } = StXianStage,
    case data_feixian_upgrade:get(Stage) of
        #base_xian_upgrade{condition = Condition} when Condition /= [] ->
            TaskId = 2,
            {TaskId, kill_mon, BaseMonId, _desc, _Id, _Id2} = lists:keyfind(TaskId, 1, Condition),
            if
                Mid == BaseMonId ->
                    NewTaskInfo =
                        case lists:keytake(TaskId, 1, TaskInfo) of
                            false ->
                                [{TaskId, 1, 0} | TaskInfo];
                            {value, {TaskId, Num, Status}, Ret} ->
                                [{TaskId, Num + 1, Status} | Ret]
                        end,
                    NewSt =
                        StXianStage#st_xian_stage{
                            task_info = NewTaskInfo,
                            is_db = 1
                        },
                    lib_dict:put(?PROC_STATUS_XIAN_STAGE, NewSt);
                true ->
                    ok
            end;
        _ ->
            skip
    end.

logout() ->
    StXianStage = lib_dict:get(?PROC_STATUS_XIAN_STAGE),
    ?IF_ELSE(StXianStage#st_xian_stage.is_db == 1, xian_load:dbup_xian_upgrade(StXianStage), skip).

get_task_id() ->
    StXianStage = lib_dict:get(?PROC_STATUS_XIAN_STAGE),
    #st_xian_stage{
        stage = Stage,
        task_info = TaskInfo
    } = StXianStage,
    F = fun({_TaskId, _Num, Status}) ->
        Status /= 1
        end,
    LL = lists:filter(F, lists:sort(TaskInfo)),
    if
        LL == [] ->
            [];
        true ->
            {TaskId, _, _} = hd(LL),
            max(Stage - 1, 0) * 3 + TaskId + 1300000
    end.

%% 承接活动时初始化活动数据
init_task_info(Task) ->
    StXianStage = lib_dict:get(?PROC_STATUS_XIAN_STAGE),
    #st_xian_stage{
        task_info = TaskInfo
    } = StXianStage,
    F = fun({Id, Num, Status}) ->
        if
            Status == 1 -> false;
            true ->
                #task{finish = Finish} = data_task_xian:get(Task#task.taskid),
                case Id of
                    1 ->
                        {getgoods, GoodsId, _GoodsNum} = hd(Finish),
                        GoodsCount = goods_util:get_goods_count(GoodsId),
                        task_event:event(?TASK_ACT_GET_GOODS, {GoodsId, GoodsCount});
                    2 ->
                        {kill, MonId, _MonNum} = hd(Finish),
                        task_event:event(?TASK_ACT_KILL, {MonId, Num});
                    3 ->
                        {dungeon, DunId, _DunNum} = hd(Finish),
                        task_event:event(?TASK_ACT_DUNGEON, {DunId, Num})
                end,
                true
        end
        end,
    lists:any(F, lists:sort(TaskInfo)),
    Task.