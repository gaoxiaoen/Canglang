%%----------------------------------------------------
%% 触发器数据结构
%% 主要用于需要动态增减触发器的情况，对于固定的调用请写入代码中
%% 每种触发器类型都应该注明Arg的类型
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------

%% 与role_trigger.erl和role_listener.erl一一对应，增加一项时，应在这两文件增加相应的方法
%% 每种类型都应注明Arg的类型及含意。 Arg 为role_listener:apply/4 的第四个参数，也就是回调函数的第二个参数
-record(trigger, {
         next_id = 0        %% 下一个触发器ID
        %% 金币变化时触发
        %% Arg = Num
        %% Num = integer() 涉及变化金币的数据
        ,coin = []
        %% VIP状态变化时触发
        %% Arg = Vip
        %% Vip = #vip{}
        ,vip = []
        %% 得到铜币时触发
        %% Arg = Coin
        %% Coin = integer() 得到铜币数量
        ,get_coin = []
        %% 杀死NPC时触发
        %% Arg = {NpcBaseId, Num}
        %% NpcBaseId = integer() Npc Base Id 
        %% Num = integer() 数量
        ,kill_npc = []
        %% 获得物品时触发 
        %% Arg = {ItemBaseId, Num}
        %% ItemBaseId = integer() 物品基础ID
        %% Num = integer() 数量
        ,get_item = []      
        %% 使用物品
        %% Arg = {ItemBaseId, Num}
        %% ItemBaseId = integer() 物品基础ID
        %% Num = integer() 数量
        ,use_item = []
        %% 完成任务触发器
        %% Arg = TaskId
        %% TaskId = integer() 任务ID
        ,finish_task = []   
        %% 获取某个任务
        %% Arg = TaskId
        %% TaskId = integer() 任务ID
        ,get_task = []      
        %% 在商店购买物品 
        %% Arg = {ItemBaseId, Num}
        %% ItemBaseId = integer() 物品基础ID
        %% Num = integer() 数量
        ,buy_item_store =[]
        %% 在商城购买物品
        %% Arg = {ItemBaseId, Num}
        %% ItemBaseId = integer() 物品基础ID 
        %% Num = integer() 数量
        ,buy_item_shop =[]
        %% 特殊事件
        %% 处理少数事件，事件列表:
        %% 1001 : 选择职业
        %% Arg = {Key, OtherArg}
        %% Key = integer() 事件ID，用于识别不同的事件
        %% OtherArg = term() 对应具体某个事件的参数
        ,special_event = [] 
        %% 添加好友
        %% Arg = Friend
        %% Friend = #friend{} 好友信息
        ,make_friend = []
        %% 累计类特殊事件 成就目标系统使用
        %% 处理累计类事件 如运镖多少次
        %% Arg = {Key, OtherArg}
        %% Key = integer() 用于识别不同事件 每次事件触发当前值增加1
        %% OtherArg = term() 扩展参数，预留作用
        ,acc_event = []
        %% 等级改变
        %% Arg = Lev
        %% Lev = integer() 当前角色等级
        ,lev = []
        %% 装备加工 装备品质改变 装备穿上
        %% Arg = {Pos, Enchant, Quality, Bind}
        ,eqm_event = []

        %% 扫荡副本
        %% Arg = {DunId, Num}
        ,sweep_dungeon = []

        %%悠闲副本
        %% Arg = {DunId, Num}
        ,ease_dungeon = []

        %% 曾经通关副本
        %% arg = {DunId, Num}
        ,once_dungeon = []

        %% 星级副本
        ,star_dungeon = []
%% 军团目标触发        
        %% 军团许愿
        ,guild_wish = []

        %% 军团商城购买
        ,guild_buy = []

        %% 猎杀海盗事件
        ,guild_kill_pirate = []

        %% 中庭战神中挑战他人次数
        ,guild_chleg = []

        %% 攻城伐龙次数
        ,guild_gc = []

        %% 通关普通副本次数
        ,guild_dungeon = []

        %% 参加世界树
        ,guild_tree = []

        %% 活跃人数
        ,guild_activity = []

        %% 领用技能人数
        ,guild_skill = []

        %% 通关多人副本人数
        ,guild_multi_dun = []
    }
).
