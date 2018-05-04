%%----------------------------------------------------
%% 任务相关数据结构
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------


-define(task_type_zhux,      1).             %% 任务类型:主线
-define(task_type_zhix,      2).             %% 任务类型:支线
-define(task_type_fb,        3).             %% 任务类型:副本
-define(task_type_sm,        4).             %% 任务类型:师门
-define(task_type_bh,        5).             %% 任务类型:帮会
-define(task_type_zrc,       6).             %% 任务类型:周日常
-define(task_type_rc,        7).             %% 任务类型:日常
-define(task_type_xx,        8).             %% 任务类型:修行任务
-define(task_type_spec,      9).             %% 特殊任务，不在客户端显示
-define(task_type_star_dun,    10).          %% 星级通关副本任务
-define(task_type_nolimit,  99).             %% 任务类型:不限制


-define(task_daily_type_gx,      1).         %% 周日常任务类型:工资 
-define(task_daily_type_xw,      2).         %% 周日常任务类型:修为
-define(task_daily_type_hy,      3).         %% 周日常任务类型:好友
-define(task_daily_type_xy,      4).         %% 周日常任务类型:降妖
-define(task_daily_type_fe,      5).         %% 周日常任务类型:罚恶
-define(task_daily_type_xb,      6).         %% 周日常任务类型:寻宝
-define(task_daily_type_zy,      7).         %% 周日常任务类型:诛妖
-define(task_daily_type_nolimit, 9).         %% 周日常任务类型:不限制

-define(task_week_task_length,   7).         %% 周日常任务长度

-define(task_kind_normal,       1).         %% 普通
-define(task_kind_item,         2).         %% 物品
-define(task_kind_xiuxing,      3).         %% 修行任务

%% 修行任务类型
-define(task_xx_attainment,    1).     %% 阅历
-define(task_xx_exp,           2).     %% 经验
-define(task_xx_coin,          3).     %% 金币
-define(task_xx_psychic,       4).     %% 灵力
-define(task_xx_map,           5).     %% 宝图
-define(task_xx_pet,           6).     %% 仙宠
-define(task_xx_other,         9).     %% 其它

%% 修行任务品质
-define(task_quality_white,  0).
-define(task_quality_green,  1).
-define(task_quality_blue,   2).
-define(task_quality_purple, 3).
-define(task_quality_orange, 4).

%% 免费刷新次数
-define(task_xx_free_num, 2).           %% 免费刷新次数
-define(task_xx_fresh_time, 1200).      %% 一小时刷新一次
-define(task_xx_sec_type_num, 4).       %% 同种任务可完成次数

%% 修行任务状态
-define(task_xx_status_unfinish, 0).    %% 未完成
-define(task_xx_status_finished, 1).    %% 已完成
-define(task_xx_status_unaccept, 2).    %% 未接受
-define(task_xx_status_commit, 3).      %% 已提交

%% 修行任务刷新类型
-define(task_fresh_free, 0).            %% 免费刷新
-define(task_fresh_pay, 1).             %% 付费刷新

%% 菜集仙宠ID
-define(task_pet_base_id, 124016).

%% 投票任务截止时间
%% -define(task_poll_end, util:datetime_to_seconds({{2012, 12,23},{23,59,0}})).
-define(task_poll_end, 1356278340).

%% 任务基础数据结构
-record(task_base, {
        task_id                %% 任务编号
        ,name                  %% 任务名称
        ,kind = 1              %% 类别[1:普通 2:扣除物品 3:修行任务]
        ,type = 9              %% 类型(1:主线，2:支线，3:副本，4:师门，5:帮会 6:周日常, 7:日常, 9:不限制)
        ,sec_type = 9          %% 二级任务类型(1:工资 2:修为 3:好友 4:降妖 5:罚恶 6:寻宝 7:诛妖 9:不限制)
        ,career = 9            %% 职业
        ,lev = 0               %% 任务等级
        ,prev = []             %% 前置任务列表          
        ,delegate = 0          %% 是否可委托(0:不可委托 1:可以委托)
        ,time_begin = 0        %% 任务开放时间，自动开启(用于某些活动类任务)
        ,time_end = 0          %% 任务结束时间，自动关闭(用于某些活动类任务)
        ,npc_accept            %% 发布任务的NPC
        ,npc_commit            %% 可提交任务的NPC
        ,describe = <<>>       %% 任务描述
        ,accept_talk = []      %% 接收任务对白 [{npc, language:get(<<"NPC对白">>)},{role, language:get(<<"角色对白">>)}, ...]
        ,unfinish_talk = []    %% 未完成任务对白[{npc, language:get(<<"NPC对白">>)},{role, language:get(<<"角色对白">>)}, ...]
        ,finish_talk = []      %% 完成任务对白[{npc, language:get(<<"NPC对白">>)},{role, language:get(<<"角色对白">>)}, ...]
        ,cond_accept = []      %% [#condition{} | ...] 接受任务的条件
        ,accept_rewards = []   %% list() | #gain{} | #loss{} 奖励内容(也包括回收物品或扣除钱币等)
        ,cond_finish = []      %% [#condition{} | ...] 完成任务的条件
        ,finish_rewards = []   %% list() | #gain{} | #loss{} 奖励内容(也包括回收物品或扣除钱币等)
        ,times = 1             %% 针对日常任务，该任务可重复多少次
        ,accept_open_map = []  %% 接受任务开启地图 [{xxx, yyy} | T] 具体看配置
        ,delegate_gain  =   [] %% 委托获得
    }
).

%% 已接任务数据结构
-record(task, {
        task_id             %% 任务编号
        ,status             %% 任务状态(0:未完成, 1:已完成)
        ,type               %% 类型(1:主线，2:支线，3:副本，4:师门，5:帮会 6:周日常, 7:日常， 9:特殊任务)
        ,sec_type           %% 二级任务类型(1:工资 2:修为 3:好友 4:降妖 5:罚恶 6:寻宝 7:诛妖 9:特殊任务)
        ,owner = 0          %% 委托人（委托任务中使用）
        ,accept_time = 0    %% 接收任务时间
        ,finish_time = 0    %% 完成任务时间
        ,progress = []      %% 任务进度信息[#task_progress{}]
        ,accept_num = 1     %% 重复任务的第几次,与环任务的奖励有关
        ,item_base_id = 0   %% 物品ID
        ,item_num = 0       %% 物品数量
        ,quality = 0        %% 任务品质
        ,attr_list = []     %% 附加信息
    }
).

%% 任务进度数据结构(任务进度是从任务条件转换过来的)
%% 中间四个字段容易搞错，故增加类型声明
-record(task_progress, {
         id                             %% 进度ID，跟触发器ID是同一个
        ,code                           %% 进度代号 
        ,trg_label                      %% 类型标识 值与trigger的字段名对应，role_trigger:del/3 使用到
        ,cond_label                     %% 类型标识 值与task_cond标签一致
        ,target         ::integer()     %% 目标，参照策划文档
        ,target_value   ::integer()     %% 目标值
        ,value          ::integer()     %% 当前值
        ,status = 0     ::integer()     %% 进度状态(0:未完成, 1:已完成)
        ,map_id = 0                     %% 场景ID
    }
).

%% 判定条件数据结构
%% 目标信息根据不同的条件有着不同的意义:
%% 详细信息查看策划文件
-record(task_cond, {
         code               %% 代号
        ,label              %% 标签
        ,target = 0         %% 目标信息 不一定是整形
        ,target_value       %% 目标值
        ,msg = <<>>         %% 判定失败时的返回消息
        ,map_id = 0         %% 当label为杀怪或者取物品时，这字段指定场景ID
    }
).

%% 任务掉落信息
-record(task_drop, {
        npc_id = 0          %% Npc基础Id
        ,item_id = 0        %% 物品基础Id
        ,prob = 100         %% 掉率
        ,map_id = 0         %% 场景Id
    }
).

%% 已完成任务记录
-record(task_finish, {
        task_id = 0         %% 任务编号
        ,type = 0           %% 类型类型
        ,sec_type = 0       %% 二级任务类型
        ,accept_time = 0    %% 接任务时间
        ,finish_time = 0    %% 完成任务时间
        ,finish_num = 0     %% 已完成次数
        ,week_num = 0       %% 周数
    }
).

%% 任务过滤参数
-record(task_fparam, {
        type = 0            %% 任务类型
        ,is_ring = 0        %% 是否为环任务
        ,finish_task_list = [] %% 已完成任务列表[#task_finish{}]
        ,accept_task_list = [] %% 已接任务列表[integer()]
    }
).

%% 任务奖励
-record(task_gain, {
        base_id = 0         %% 基础Id
        ,lev = 0            %% 级别
        ,list = []          %% 奖励内容
    }
).

%% 检查参数
-record(task_param_accept, {
        role                %% 角色信息#role{}
        ,task_id = 0        %% 任务id
        ,npc_id_accept = 0  %% 接受npc id(动态Id)
        ,task_base          %% 任务基础数据#task_base{}
        ,litem_id = 0       %% 扣除物品ID
        ,litem_num = 0      %% 扣除物品数量
        ,escort_type = 0    %% 运镖类型[绑定/非绑定]
        ,quality = 0        %% 品质
    }
).

%% 提交任务参数
-record(task_param_commit, {
        role                %% 角色信息
        ,task_id = 0        %% 任务id
        ,npc_id_commit = 0  %% 提交任务npc
        ,task_base          %% 任务基础数据
        ,update_role = 0    %% 是否需要更新角色信息
        ,reason = <<>>      %% 原因
        ,task               %% 提交的任务
        ,finish_imm = 0     %% 是否立即完成[0:否 1:是]
    }
).

%% 放弃任务参数
-record(task_param_giveup, {
        role                %% 角色信息
        ,task_id = 0        %% 任务ID
        ,task_base          %% 任务基础信息
    }
).

%% 扣除物品任务行为
-record(task_act, {
        label               %% 标签
        ,val                %% 描述,不同的标签有不同的值
    }
).

%% 物品行为信息
-record(task_base_item, {
        task_id = 0         %% 任务ID
        ,item_base_id = 0   %% 物品基础ID
        ,item_num = 0       %% 物品数量
        ,finish_rewards = []%% 完成奖励
    }
).

%% 修行任务
-record(task_xiuxing, {
        task_id = 0         %% 任务ID
        ,priority = 0       %% 优先级
        ,gold = 0           %% 完成晶钻
    }
).

%% 修行任务奖励
-record(task_xx_rewards, {
        lev = 0             %% 等级
        ,sec_type = 0       %% 类型
        ,quality = 0        %% 品质
        ,rewards = []       %% 奖励
    }
).

-define(daily_task_mail1, 1).
-define(daily_task_mail2, 2).
-define(daily_task_mail3, 3).
-define(daily_task_mail4, 4).
-define(daily_task_mail5, 5).
-define(daily_task_mail6, 6).
-define(daily_task_mail7, 7).
-define(daily_task_mail8, 8).
-define(daily_task_mail9, 9).
-define(daily_task_mail10, 10).
-define(daily_task_mail11, 11).
-define(daily_task_mail12, 12).
-define(daily_task_mail13, 13).

-define(unopen, 0).
-define(open, 1).

%-record(daily_task_info, {
%        task_id = 0    %% 
%        ,is_open = ?unopen  %% 打开状态
%    }
%).

%% 委托任务
-record(delegate_task, {
        id = 0          %% 委托任务ID
        ,time = 0       %% 委托时间
        ,rid = 0        %% 角色ID
        ,srv_id  = <<>> %% 服务器ID
        ,mail_id = 0    %% 这是任务ID，名字有误的
        ,quality = 0    %% 邮件品质
    }
).

-record(daily_task, {
        id      %% 日常任务唯一ID
        ,task_id        %% 任务ID
        ,is_open        %% 是否打开
        ,accept_time    %% 接到此任务的时间
    }
).

%% 日常任务信息
-record(daily_info, {
        login_time = 0              %% 时间
        ,online_time = 0            %% 在线时长，凌晨重置0
        ,fresh_time = 0             %% 上一次刷新时间
        ,fresh_cnt = 0              %% 刷新次数
        ,accept_delegate_time = 0   %% 上次接受委托任务时间
        ,accept_delegate_cnt = 0    %% 当天接受委托任务计数,一天只能接五个别人委托的日常任务
        ,task = []                  %% 刷出的任务 [{rid, srv_id, task_id}| ] 
        ,task_mail = []             %% 还没接受的日常任务 #daily_task{}，已接的日常任务存在#role.task中
    }
).

%% 任务系统个人信息
-define(task_role_ver,       5).    %% #task_role{}记录版本号
-record(task_role, {
        ver = ?task_role_ver        %% 版本号
        ,xx_free_num = {0, 0}       %% 修行任务免费刷新次数{零点时间, 次数}
        ,xx_orange = {0, 0}         %% 当天完成橙色修行任务次数{Today, Num}
        ,elem_list = []             %% 候选任务列表[#task_xx_elem{}]}] 
        ,has_post_mail = []         %% 今天已经投送了的日常任务信件
        ,daily_info = #daily_info{} %% 日常任务信息
    }
).

%% 任务页
-record(task_xx_elem, {
        type = 2                %% 当前刷新类型 {1:阅历 2:经验 9:其它}
        ,fresh_time = 0         %% 刷新时间
        ,list = []              %% 候选任务列表[{TaskId, Quality, Status}]
    }
).

