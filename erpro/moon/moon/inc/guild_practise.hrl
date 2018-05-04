%% 帮会历练数据结构

-define(guild_practise_max_help_refresh, 5).     %% 最大助人刷新次数
-define(guild_practise_max_refresh_self, 5).     %% 最大被刷新次数
-define(guild_practise_refresh_time_out, 1800).  %% 刷新超时时间 CD时间

-define(GUILD_PRAC_DICT, {guild_practise, Gid, Gsrvid}). %% 进程字典名称

-define(guild_practise_status_no_look, 0).  %% 未查看
-define(guild_practise_status_no_accept, 1). %% 未领取
-define(guild_practise_status_doing, 2).  %% 进行中
-define(guild_practise_status_finish, 3).  %% 完成未提交
-define(guild_practise_status_commit, 4).  %% 已提交

%% 品质
-define(guild_practise_while, 0). %% 白色
-define(guild_practise_green, 1). %% 绿色
-define(guild_practise_blue, 2).  %% 蓝色
-define(guild_practise_purple, 3). %% 紫色
-define(guild_practise_orange, 4). %% 橙色

-define(guild_practise_min_lev, 40). %% 等级限制

%%-------------------------
%% 基础数据
%%-------------------------

%% 帮会历练任务数据
-record(guild_practise_task, {
        id = 0             %% 任务ID
        ,name = <<>>       %% 任务名称
        ,rand = 0          %% 出现概率
        ,accept_cond = []  %% 接受条件
        ,finish_cond = []  %% 任务完成条件
        ,desc = <<>>       %% 任务描述
    }
).

%% 帮会历练运气基础数据
-record(guild_practise_luck, {
        type = 0           %% 1:运势平平 2:小有运道 3:大吉大利 4:鸿运当头 5:吉星高照
        ,name = <<>>       %% 名称
        ,rand = 0          %% 概率
        ,quality_list = [] %% 品质出现概率列表
    }
).

%% 帮会历练奖励基础数据
-record(guild_practise_reward, {
        task_id = 0       %% 任务ID
        ,task_name = <<>> %% 任务名称
        ,quality = 0      %% 任务品质[0:白 1:绿 2:蓝 3:紫 4:橙]
        ,rewards = []     %% 奖励数据
    }
).

%%-------------------------------------
%% 历练进程管理数据
%%-------------------------------------

-record(guild_practise_list, {
        id = {0, <<>>}     %% 帮会标志
        ,list = []         %% 成员数据列表 [#guild_practise_role{}]
    }
).

%% 角色刷新任务品质数据 单角色数据
-record(guild_practise_role, {
        ver = 0
        ,id = {0, <<>>}     %% 角色标志
        ,rid = 0            %% 角色ID
        ,srv_id = <<>>      %% 服务器标志
        ,name = <<>>        %% 角色名称
        ,luck = 0           %% 运势 1:运势平平 2:小有运道 3:大吉大利 4:鸿运当头 5:吉星高照
        ,refresh_time = 0   %% 最后刷新任务类型时间
        ,status = 0         %% 状态 0:未查看 1:未领取 2:进行中 3:已完成 4:已领取奖励
        ,help_others = 0    %% 助人次数
        ,refresh_self = 0   %% 被刷次数
        ,quality = 0        %% 任务品质 影响奖励 [0:白 1:绿 2:蓝 3:紫 4:橙]
        ,refresh_list = []  %% 当天刷新列表 [{Rid, Srvid, Name, Quality}]
        ,task_id = 0        %% 任务ID
        ,login_time = 0     %% 最后一次登录/退出时间
        ,online = 0         %% 当前是否在线 0:不在线 1:在线
    }
).

%%-------------------------------------
%% 角色#role{}附加数据
%%------------------------------------
-record(guild_practise, {
        ver = 0
        ,task_id = 0   %% 帮会历经任务ID
        ,day_time = 0  %% 任务时间 
        ,num = 0       %% 历练次数 扩展字段 未使用
        ,quality = 0   %% 任务品质 影响奖励 [0:白 1:绿 2:蓝 3:紫 4:橙]
        ,status = 1    %% 1:未领取 2:进行中 3:已完成 4:已领取奖励
        ,progress = []  %% 任务进度列表 #guild_practise_progress{}
        ,exp = 0        %% 经验奖励
        ,psychic = 0    %% 灵力奖励
    }
).

%% 历练任务进度数据结构
-record(guild_practise_progress, {
        id = -1                     %% 对应触发器ID
        ,code                       %% 进度代号 
        ,trg_label                  %% 类型标识 值与trigger的字段名对应，role_trigger:del/3 使用到
        ,cond_label                 %% 类型标识 值与task_cond标签一致 
        ,target       ::integer()    
        ,target_ext                 %% 目标扩展 用于特殊事件 普通事件使用不到 如将任意N个技能修炼至X级 则可用target_ext表示X
        ,target_value ::integer()   %% 目标值
        ,value        ::integer()   %% 当前值
        ,status = 0                 %% 进度状态(0:未完成 1:完成)
    }
).
