%%----------------------------------------------------
%% 目标系统记录 
%% @author 252563398@qq.com
%%----------------------------------------------------

-define(ACHIEVEMENT_VER, 5). %% 版本号

-define(target_system_type, 1). %% 目标系统
-define(achievement_system_type, 2). %% 成就系统
-define(target_type_everyday, 3). %% 日常目标系统

-define(achievement_status_progress, 0). %% 正在进行中
-define(achievement_status_finish, 1).   %% 已完成
-define(achievement_status_rewarded, 2). %% 已领取奖励

-define(honor_common, 0).    %% 普通称号
-define(honor_rank, 1).      %% 排行榜十大称号
-define(honor_celebrity, 2). %% 名人榜称号
-define(honor_society, 3).   %% 社交称号
-define(honor_card, 4).      %% 称号卡 同时只能拥有一个 使用物品[称号卡]获得
-define(honor_glory, 5).     %% 荣誉称号

-define(init_medal, 10001).      %% 开始修炼的勋章
-define(condition_num, 12).     %% 条件个数
-define(page_num, 3).           %% 一页个数
-define(status_finish, 1).      %% 完成
-define(status_unclaimed, 2).   %% 待领取
-define(status_unfinish, 3).    %% 未完成

%% 成就基本数据
-record(achievement_base, {
        id                  %% 标志
        ,name = <<>>        %% 名称
        ,system_type        %% 系统类型(1:目标系统 2:成就系统)
        ,type               %% 系统类型下一级分类
        ,extends            %% 继承ID号
        ,accept_cond = []   %% 接受条件
        ,finish_cond = []   %% 完成条件
        ,rewards = []       %% 奖励
    }).

%% 成就称号基础数据
-record(honor_base, {
        id            %% 标志
        ,name         %% 称号名称
        ,type         %% 类型 0:普通称号 1:十大称号 2:名人称号
        ,picture = 1  %% 0:文字称号 1:图片称号
        ,is_only      %% 是否全服唯一称号 0:不是 1:是 全服唯一即同时只有一个或某几个人有
        ,buff         %% BUFF对应Label 
        ,modify = 0   %% 0:不支持修改 1:可修改(文字类型称号)
        ,career = 0   %% 职业要求 0:无限制
        ,sex = 99     %% 性别要求 99:无限制
    }).

%% 成就进度数据结构
-record(achievement_progress, {
        ver = 0
        ,id = -1                     %% 对应触发器ID
        ,code                       %% 进度代号 
        ,trg_label                  %% 类型标识 值与trigger的字段名对应，role_trigger:del/3 使用到
        ,cond_label                 %% 类型标识 值与task_cond标签一致 
        ,target       ::integer()    
        ,target_ext                 %% 目标扩展 用于特殊事件 普通事件使用不到 如将任意N个技能修炼至X级 则可用target_ext表示X
        ,target_value ::integer()   %% 目标值
        ,value        ::integer()   %% 当前值
        ,status = 0                 %% 进度状态(0:未完成 1:完成)
    }).

%% 成就信息数据
-record(achievement, {
        ver = 0
        ,id   %% 标志 来自#achievement_base.id
        ,status = 0        %% 进度状态(0:未完成 1:完成 2:已领取)
        ,system_type       %% 系统类型(1:目标系统 2:成就系统)
        ,accept_time = 0   %% 领取时间
        ,finish_time = 0   %% 完成时间
        ,reward_time = 0   %% 奖励领取时间
        ,progress = []     %% 进度信息 #achievement_progress{}
    }).

%% 角色成就信息存储
-record(role_achievement, {
        ver = ?ACHIEVEMENT_VER
        ,value = 0           %% 成就值
        ,honor_use = []      %% 当前使用称号[HonorId]
        ,honor_all = []      %% 所有称号列表[{HonorId, HonorName, Time}] HonorId--称号ID HonorName--称号名称 Time--到期时间 0:无期限
        ,d_list = []         %% 所有成就目标数据列表
        ,finish_list = []    %% 已领取奖励列表[Id]
        ,day_reward = 0      %% 日常目标奖励状态
        ,day_list = []       %% 日常目标列表
        ,srv_open_7day = []  %% 7日目标列表
    }).

%% 角色竞技勋章信息
-record(medal_compete, {
        wearid = 0                    %% 当前佩戴的竞技勋章
        ,medals = []                  %% 已获的竞技勋章
        ,honors = []                  %% 勋章对应的称号
        ,special = []                 %% ::[{type, result, times}...] type:2v2|..., result:win|loss|..., times::integer()
    }).
%%　竞技勋章信息
-record(compete_medal, {
        id = 0                    %% 竞技勋章id
        ,attr = []                %% 勋章属性
    }).


%% 角色勋章信息存储
-record(medal, {
        wearid = 0                      %% 当前佩戴的勋章 ::{id,medal_id}
        ,cur_medal_id = 0               %% 当前正在完成的勋章 cur_medal_id :: int 
        ,cur_rep = 0                    %% 当前声望值
        ,need_rep = 0                   %% 扔需要的声望值
        ,gain = []                      %% 已获得的勋章列表 ::[{id,medal_id}]
        ,condition = []                 %% 勋章的条件列表 [status] :: status:: 1:finished, 2:unclaimed, 3:unfinished 
        ,pass = []                      %%已经通关的试炼场
        ,compete = #medal_compete{}     %% 竞技勋章信息   
    }).

%% 勋章基础信息存储
-record(medal_base, {
        medal_id = 0            %% 当前正在完成的勋章 medal_id :: int 
        ,need_rep = 0           %% 需要的声望值
        ,condition = []         %% 勋章的条件列表 [#medal_cond{label,target,target_value,rep}] 
        ,dungeon = 0            %% 开启试炼场id
        ,next_id = 0            %% 下一个勋章id
        % ,special                %% 勋章开启的特权 ::[case_id]
    }).
%% 勋章特权信息存储
-record(medal_special, {
        medal_id = 0            %% 勋章 medal_id :: int 
        ,attr = []              %% 勋章加成属性 ::[{hp,300},{mp,200}]
        ,npc = []               %% 勋章可招募庄园npc ::[id]
        ,map = []               %% 勋章可进入的地图 ::[id]
        ,func = []              %% 勋章开启功能 ::[id]
    }).
%% 勋章特权信息存储
-record(medal_cond, {
        id = 0                  %% 条件的id，第n个条件     
        ,label                  %% 条件 label :: atom 
        ,target = 0             %% 条件达成目标
        ,target_value = 0       %% 条件目标所需值
        ,rep = 0                %% 条件完成获得的声望值
        ,stone = 0              %% 条件完成获得的符石

        ,need_value = 0         %% 需要达到目标的总数
        ,cur_value = 0          %% 当前已达到目标的数量
    }).

