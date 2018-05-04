%%----------------------------------------------------
%% 存储系统数据结构定义
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------

-define(storage_bag, 1).     %% 背包
-define(storage_store, 2).   %% 仓库
-define(storage_eqm, 3).     %% 角色身上
-define(storage_collect, 4). %% 采集背包
-define(storage_task, 5).    %% 任务背包
-define(storage_guild, 6).   %% 帮会仓库
-define(storage_casino, 7).  %% 仙境寻宝--开宝箱仓库
-define(storage_dress, 8).  %% 时装衣柜
-define(storage_mount, 10).  %% 坐骑栏
-define(storage_super_boss, 11). %% 盘龙洞仓库
-define(storage_pet_magic, 12).  %% 宠物魔晶背包
-define(storage_pet_eqm, 13).    %% 宠物装备栏
-define(storage_wing, 14).       %% 角色翅膀
-define(storage_sec_eqm, 15).    %% 副职业装备栏
-define(storage_sec_dress, 16).  %% 副职业衣柜 

-define(FREEPOS(M, N), lists:seq(M, N)).  

-define(bag_def_volume, 50).    %% 背包默认容量
-define(bag_max_volume, 100).   %% 背包可扩充最大容量
-define(free_pos, lists:seq(1, 120)).   %% 仓库的大小
%% 背包数据结构
-record(bag, {
        next_id = 1             %% 下个可用ID
        ,volume = ?bag_def_volume            %% 背包容量
        ,free_pos = ?FREEPOS(1, ?bag_def_volume)   %% 可用位置，默认是undefined
        ,items = []             %% 物品数据
    }
).

%% 仓库数据结构
-record(store, {
        next_id = 1             %% 下个可用ID
        ,volume = 42            %% 背包容量
        ,free_pos = ?FREEPOS(1, 42)   %% 可用位置，默认是undefined
        ,items = []             %% 物品数据
    }
).

%% 采集背包数据结构
-record(collect, {
        volume = 72             %% 背包容量
        ,free_pos = ?FREEPOS(1, 72)   %% 可用位置
        ,items = []             %% 物品数据
    }
).

%% 任务背包数据
-record(task_bag, {
        next_id = 1
        ,volume = 500
        ,free_pos = ?FREEPOS(1, 500) 
        ,items = []
    }
).

%% 帮会仓库数据结构
-record(guild_store, {
        next_id = 1             %% 下个可用ID
        ,exten = 0              %% 仓库扩增次数
        ,volume = 42            %% 背包容量
        ,free_pos = ?FREEPOS(1, 42)   %% 可用位置，默认是undefined
        ,items = []             %% 物品数据
    }
).

%% 开封印仓库数据结构
-record(casino, {
        next_id = 1             %% 下个可用ID
        ,volume = 500            %% 背包容量
        ,free_pos = ?FREEPOS(1, 500)   %% 可用位置，默认是undefined
        ,items = []             %% 物品数据
    }
).

%% 坐骑栏数据结构
-record(mounts, {
        next_id = 1             %% 下个可用ID
        ,num = 0                %% 坐骑数量        
        ,items = []             %% 物品(坐骑)数据
        ,skin_id = 0            %% 坐骑正在使用的外观id(物品base_id)
        ,skin_grade = 1         %% 坐骑外观等级(0=只显示普通外观,1=根据强化等级显示外观)
        ,skins = []             %% 坐骑外观id列表(物品base_id)
        ,buff_skin_id = 0       %% BUFF附加外观id
        ,is_buff_skin = 0       %% 是否在使用buff外观:0=否，1=是
    }
).

%% 盘龙仓库数据结构
-record(super_boss_store, {
        next_id = 1                     %% 下个可用ID
        ,volume = 120                   %% 背包容量
        ,free_pos = ?free_pos           %% 可用位置，默认是undefined
        ,items = []                     %% 物品数据
        % ,bomb = 0                       %% 炸弹的数量
    }
).

%% 宠物魔晶背包
-record(pet_magic, {
        next_id = 1             %% 下个可用ID
        ,volume = 18            %% 背包容量
        ,free_pos = ?FREEPOS(1, 18)   %% 可用位置，默认是undefined
        ,items = []             %% 物品数据
    }
).
