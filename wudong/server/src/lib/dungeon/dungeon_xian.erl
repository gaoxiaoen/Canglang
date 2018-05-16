%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. 十月 2017 20:57
%%%-------------------------------------------------------------------
-module(dungeon_xian).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("xian.hrl").
-include("goods.hrl").
-include("dungeon.hrl").

%% API
-export([
    check_enter/2,
    dungeon_xian_ret/3
]).

check_enter(_Player, DunId) ->
    case dungeon_util:is_dungeon_xian(DunId) of
        false ->
            true;
        true ->
            St = lib_dict:get(?PROC_STATUS_XIAN_STAGE),
            TaskId = 3,
            {TaskId, DunNum, Status} =
                lists:keyfind(TaskId, 1, St#st_xian_stage.task_info),
            #base_xian_upgrade{condition = BaseTaskInfo} = data_feixian_upgrade:get(St#st_xian_stage.stage),
            {TaskId, _Type, BaseDunId, BaseDunNum, _desc} = lists:keyfind(TaskId, 1, BaseTaskInfo),
            if
                Status == 1 ->
                    {false, ?T("当前任务已提交")};
                DunId /= BaseDunId ->
                    {false, ?T("非当前任务副本")};
                DunNum >= BaseDunNum ->
                    {false, ?T("当前任务副本已通关")};
                true ->
                    true
            end
    end.

%%副本挑战结果
dungeon_xian_ret(1, Player, DunId) ->
    StXianStage = lib_dict:get(?PROC_STATUS_XIAN_STAGE),
    #st_xian_stage{
        stage = Stage,
        task_info = TaskInfo
    } = StXianStage,
    #base_xian_upgrade{
        pass_goods = PassGoods,
        drop_goods = BaseDropGoods
    } = data_feixian_upgrade:get(Stage),
    DropGoods = drop_goods(BaseDropGoods),
    GoodsList = goods:merge_goods(PassGoods ++ DropGoods),
    {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(238, GoodsList)),
    PackGoodsList = [[Gid, Num, ?DROP_TYPE_PASS] || {Gid, Num} <- PassGoods] ++ [[Gid, Num, ?DROP_TYPE_RATIO] || {Gid, Num} <- DropGoods],
    {ok, Bin} = pt_442:write(44210, {1, DunId, PackGoodsList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    TaskId = 3,
    NewTaskInfo =
        case lists:keytake(TaskId, 1, TaskInfo) of
            false ->
                [{TaskId, 1, 0} | TaskInfo];
            {value, {TaskId, Num, Status}, Rest} ->
                [{TaskId, Num+1, Status} | Rest]
        end,
    NewStXianStage = StXianStage#st_xian_stage{task_info = NewTaskInfo},
    lib_dict:put(?PROC_STATUS_XIAN_STAGE, NewStXianStage),
    xian_load:dbup_xian_upgrade(NewStXianStage),
    NewPlayer;

dungeon_xian_ret(0, Player, DunId) ->
    {ok, Bin} = pt_442:write(44210, {0, DunId, []}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player.

drop_goods(GoodsList) ->
    RatioList = [{Gid, Ratio} || {Gid, _, Ratio} <- GoodsList],
    case util:list_rand_ratio(RatioList) of
        0 -> [];
        Gid ->
            case lists:keyfind(Gid, 1, GoodsList) of
                false -> [];
                {_, Num, _} ->
                    [{Gid, Num}]
            end
    end.