%%----------------------------------------------------
%% @doc 悬赏任务相关数据结构
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-record(task_wanted_data, {
        id = 0, %% 任务id
        type = 0,   %% 任务类型:1经验，2宝图，精英怪
        owner_id = {0, <<>>}, %% 接受者id
        owner_name = <<>>, %% 接受者名字
        owner_pid = 0,     %% 接受者pid
        npc_id = 0,     %% 经验怪任务则此项为npcId
        npc_base_id = 0, %% 怪物类型id
        map_id = 0,     %% 精英怪位置
        x = 0,     %% 精英怪位置
        y = 0,     %% 精英怪位置
        accepted = 0, %% 接任务时间
        reward = 0,     %% 经验值或物品id
        status = 0 %% 0进行中，1完成，2已领奖
    }).
