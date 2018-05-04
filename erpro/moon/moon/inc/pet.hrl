%%---------------------------------------------
%% 宠物数据结构
%% @author 252563398@qq.com
%%---------------------------------------------

-define(PET_VER, 12).  %% 宠物版本
-define(PET_BAG_VER, 8).  %% 宠物背包版本

%% 宠物数据限制
-define(pet_default_num, 8). %% 最多支持宠物个数
%% -define(pet_max_lev, 60).  %% 宠物最高等级
-define(pet_max_happy, 100). %% 最大快乐值 
-define(pet_min_potential, 0). %% 最小潜力值
-define(pet_max_potential, 800). %% 最大潜力值
-define(pet_asc_free, 3).

-define(pet_max_eqm, 6). %% 最大装备数
-define(pet_max_skill, 10). %% 最大技能数


-define(pet_happy_time, 180). %% 宠物快乐值下降速度

%% 宠物类型
-define(pet_type_white, 0).  %% 白宠
-define(pet_type_green, 1).  %% 绿宠
-define(pet_type_blue, 2).   %% 蓝宠
-define(pet_type_purple, 3). %% 紫宠
-define(pet_type_orange, 4). %% 橙宠
-define(pet_type_golden, 5). %% 金宠（新技能）

%% 宠物蛋
-define(pet_egg_green, 23010).  %% 绿蛋
-define(pet_egg_blue, 23011).   %% 蓝蛋
-define(pet_egg_purple, 23012). %% 紫蛋
-define(pet_egg_orange, 23013). %% 橙蛋
-define(pet_egg_golden, 33241). %% 金蛋（新技能蛋）

%% 宠物状态
-define(pet_rest, 0). %% 休息状态
-define(pet_war, 1). %%  出战状态
-define(pet_deposit, 2). %% 寄养中 

-define(pet_food_item, [23000]).

-define(pet_wash_num, 5). %% 批洗数量

%% 日志类型
-define(pet_log_type_free_egg, 1).  %% 免费砸蛋
-define(pet_log_type_send_bless, 2).%% 祝福发起
-define(pet_log_type_bless, 3).     %% 祝福接收
-define(pet_log_type_magic, 4).     %% 猎魔免费次数

-define(pet_new_id, 124040).  %% 新手宠物ID

-define(pet_skill_type_dmg, 1).  %% 宠物攻击类技能
-define(pet_skill_type_def, 2).  %% 宠物防御类技能
-define(pet_skill_type_help, 3).    %% 宠物辅助类技能
-define(pet_skill_type_buff, 4).  %% 宠物技能buff类，增加反击效果

-define(pet_skill_args_rate, 0).    %% 宠物技能参数 触发概率
-define(pet_skill_args_talent, 1).  %% 宠物天赋技能星级参数
-define(pet_skill_args_effect, 2).  %% 宠物技能效果

-define(pet_101_normal_skill, 600120).  %% 宠物攻击技能1
-define(pet_102_normal_skill, 600121).  %% 宠物攻击技能2
-define(pet_103_normal_skill, 600122).  %% 宠物攻击技能3

%% 宠物属性数据
-record(pet_attr, {
        xl = 5   %% 仙力(系统分配)
        ,tz = 5  %% 体质(系统分配)
        ,js = 5  %% 精神(系统分配)
        ,lq = 5  %% 灵巧(系统分配)
        ,xl_val = 0 %% 攻潜力
        ,tz_val = 0 %% 体潜力
        ,js_val = 0 %% 防潜力
        ,lq_val = 0 %% 巧潜力
        ,step = 1     %%平均潜力所属阶
        %% 上面属性不能通过计算得出 以下属性通过计算得出
        ,avg_val = 0 %% 平均潜力
        %% 宠物战斗属性 通过上面属性转换计算得出
        ,hp = 0       %% 当前血量
        ,mp = 0       %% 当前法力
        ,hp_max = 0   %% 生命
        ,mp_max = 0   %% 魔法
        ,dmg = 0      %% 攻击力
        ,critrate = 0 %% 暴击率 单位：千分率
        ,defence = 0  %% 防御值
        ,tenacity = 0 %% 坚韧
        ,hitrate = 0  %% 命中
        ,evasion = 0  %% 闪躲
        %% 新增属性 2012/07/11
        ,dmg_magic = 0      %% 法伤
        ,anti_js = 0        %% 精神
        ,anti_attack = 0    %% 反击
        ,anti_seal = 0      %% 抗封印
        ,anti_stone = 0     %% 抗石化
        ,anti_stun = 0      %% 抗眩晕
        ,anti_sleep = 0     %% 抗睡眠
        ,anti_taunt = 0     %% 抗嘲讽
        ,anti_silent = 0    %% 抗遗忘
        ,anti_poison = 0    %% 搞中毒
        ,blood = 0          %% 吸血
        ,rebound = 0        %% 宠物反弹
        ,resist_metal = 0   %% 金抗
        ,resist_wood = 0    %% 木抗
        ,resist_water = 0   %% 水抗
        ,resist_fire = 0    %% 火抗
        ,resist_earth = 0   %% 土抗
        ,xl_max = 0       %% 攻潜力上限
        ,tz_max = 0       %% 体潜力上限
        ,js_max = 0       %% 防潜力上限
        ,lq_max = 0       %% 巧潜力上限
    }
).

%% 系统分配属性比例
-record(pet_attr_sys, {
        xl_per = 25 
        ,tz_per = 25
        ,js_per = 25
        ,lq_per = 25
    }
).

%% 宠物双天赋
-record(pet_double_talent, {
        switch = 0 %% 是否开启
        ,use_id = 1 %% 当前使用天赋ID
        ,cooldown = 0 %% 剩余冷却时间:S
        ,attr_list = [] %% 天赋列表
    }
).

%% 宠物数据
-record(pet, {
        ver = ?PET_VER
        ,id = 0
        ,name = <<>>                %% 名称
        ,base_id = 0                %% 宠物形象标志        
        ,type = 0                   %% 宠物类型(0:白宠 1:绿宠 2:蓝宠 3:紫宠 4:橙宠)
        ,lev = 1                    %% 等级
        ,mod = 0                    %% 0:休息 1:出战 2:寄养
        ,grow_val = 0               %% 成长值
        ,happy_val = 100            %% 当前快乐值
        ,exp = 0                    %% 经验
        ,attr = #pet_attr{}         %% 宠物属性数据
        ,attr_sys = #pet_attr_sys{} %% 系统分配属性比例
        ,skill = []                 %% 宠物技能列表 {SkillId, Exp, Loc,[]}
        ,skill_num = 0              %% 可拥有技能数量
        ,wash_list = []             %% 洗髓数据
        ,fight_capacity = 0         %% 宠物战斗力 
        ,bind = 0                   %% 是否绑定 0:非绑定 1:绑定 (标志此宠物是否可练魂交易)
        ,append_attr = []           %% 宠物附加属性
        ,wish_val = 0               %% 成长祝福值
        ,evolve = 0                 %% 进化程度[0:未进化过 1:进化一次 2:进化2次]
        ,buff = []                  %% 宠物BUFF
        ,double_talent = #pet_double_talent{}  %% 双天赋列表
        ,skin_id = 0                %% 正在使用外观Id
        ,skin_grade = 0             %% 正在使用外观级数
        ,eqm_num = 0                %% 装备数
        ,eqm = []                   %% 宠物装备列表[#item{}]
        ,ext_attr = []              %% 宠物累加属性
        ,cloud_lev = 0              %% 宠物云朵等级
        ,ext_attr_limit = []        %% 宠物累加属性上限[{Type, Val}]
        ,ascended = 0               %% 仙宠是否飞升
        ,ascend_num = 0             %% 飞升丹使用数量

        %%宠物每天潜力提升的规则
        ,asc_times = ?pet_asc_free  %%宠物潜力提升每天前n次100%成功，时间周期为一天
        ,last_asc_time = 0          %%最近一次潜力提升的时间
        ,skill_slot = []            %%可用的技能槽
        ,lucky_value = 0            %%宠物幸运值
        ,devout_value = 0           %%宠物虔诚值
        ,explore_once = 0           %%探寻一次的结果
        ,explore_list = []          %%批量探寻结果
        ,tab = 0                    %%批量探寻来自哪个表
    }
).


%% 宠物装备属性
-record(pet_eqm_attr, {
        pet_id            %% 宠物id
        ,eqm_id            %% 装备id
        ,name = <<>>      %% 装备名称
        ,location         %% 装备部位
        ,lev              %% 装备等级
        ,attrs = []       %% 属性列表[{key,value}]:[{生命，xx}][{防御，xx}]
    }
).


%% 宠物基础数据
-record(pet_base, {
        id                %% 宠物形象ID
        ,name = <<>>      %% 名称
        ,refresh = 0      %% 随机出现类型(0:白 1:绿 2:蓝 3:紫 4:橙)
        ,npc_id = 0       %% 对应NPC_ID (捉宠使用)
        ,skills = []      %% 技能ID
    }
).

%% 龙族遗迹物品数据结构by bwang
-record(pet_dragon_item, {
        item_id = 0                    %% 物品id
        ,item_name = <<>>              %% 物品名称
        ,price = 0                     %% 购买的价格
        ,weight = 0                    %% 权重
        ,lucky = 0                     %% 幸运值
        ,high_lev = 0                  %% 1为极品，0为普通
    }
).

%% 宠物技能数据
-record(pet_skill, {
        id                              %% 技能标志
        ,name = <<>>                    %% 技能名称
        ,mutex                          %% 相同表示：互斥关系
        ,type                           %% 1:攻击 2:防御 3:辅助 4:BUFF类
        ,step                           %% 技能阶数
        ,lev                            %% 技能等级
        ,exp                            %% 经验值
        ,next_id                        %% 下一级技能ID 0:表示满级
        ,cost = []                      %% 技能释放损耗
        ,script_id = undefined          %% 技能脚本编号(模板编号)  
        ,args = []                      %% 技能参数
        ,buff_self = []                 %% 作用于自身的BUFF
        ,buff_target = []               %% 作用于目标的BUFF      
        ,cd = 0                         %% 冷却时间
        ,desc = <<>>                    %% 描述
        ,n_args = []                    %% 天赋参数 [Star, []]
    }
).

%% 猎魔数据信息
-record(pet_hunt, {
        npc_ids =  []           %% 当前激活[{NpcId, 0|1},...]
        ,next_id = 1            %% 猎魔ID 可认为是猎魔次数
        ,items = []             %% 猎魔物品缓存区 可以拾取和售出 [{NextId, BaseId, Num}...]
        ,acc_gold = {label, 0}  %% 猎魔累计消耗晶钻
    }
).

%% 筋斗云数据
-record(pet_cloud, {
        lev = 0         %% 等级
        ,exp = 0        %% 经验
    }
).

%% 玩家宠物数据
-record(pet_bag, {
        ver = ?PET_BAG_VER              %% 宠物包版本 
        ,pets = []                      %% 非出战宠物：玩家宠物列表 [#pet{}]
        
        ,active                         %% 出战宠物：#pet{}
        ,deposit = {0, 0, 0}            %% 帮会寄养宠物 {#pet{}, Time, BeginTime}
        ,next_id = 1                    %% 下一个宠物ID 确保ID维一值
        ,last_time = 0                  %% 最后一次计算经验/快乐值时间 1秒等于1点经验
        ,rename_num = 3                 %% 剩余重命名次数
        ,exp_time = 100                 %% 宠物经验加成
        ,catch_pet = 0                  %% 捉宠次数
        ,log = []                       %% 相关类型日志{Type, Other} 
        ,skins = []                     %% 可用外观列表
        ,skin_id = 0                    %% 正在使用外观Id(暂时不用)
        ,skin_grade = 0                 %% 正在使用外观级数(暂时不用)
        ,skin_time = 0                  %% 下次可更换外观时间
        ,hunt = #pet_hunt{}             %% 猎魔物品
        ,custom_speak = []              %% 自定义说话:[{id, <<>>}, ...]
        ,cloud = #pet_cloud{}           %% 筋斗云数据
        ,pet_limit_num = ?pet_default_num  %% 宠物上限
    }
).

%% 成长基础数据
-record(pet_grow_base, {
        lev = 0          %% 成长等级
        ,base_suc = 0   %% 基础成功率
        ,max_wish = 1    %% 祝福上限
        ,min_wish = 0    %% 祝福下限 低于此值不可能成功
        ,attr_val = 0    %% 获得属性点
        ,cli_base_suc = 0 %% 客户端基础成功率
        ,cli_max_wish = 0 %% 客户端祝福上限值
    }
).

%% 宠物对话数据
-record(pet_speak, {
        id = 0                  %% ID
        ,type = 0               %% 类型
        ,custom = 0             %% 是否可自定义（0=不可，1=可）
        ,broadcast = 0          %% 是否广播（0=否，1=是）
        ,condition = []         %% 条件 [{条件目标，条件属性，条件关系，条件数值}]
        ,prob = 0               %% 说话概率
        ,condition_desc = <<>>  %% 条件描述
        ,content = <<>>         %% 说话内容
    }
).

%% 宠物BUFF
-record(pet_buff, {
        id = 0                  %% ID 
        ,label = buff           %% 标志
        ,name = <<>>            %% BUFF名称
        ,baseid                 %% 基础ID
        ,icon = 0               %% 图标
        ,multi = 0              %% 存在多个同类BUFF时的处理方式(0:不允许多个 1:跟据互斥设置而定 2:时间累加, 3:覆盖)
        ,type = 0               %% 0:代表数值 1:时间(下线不计时) 2:时间(下线计时)
        ,effect = []            %% BUFF效果
        ,duration = 0           %% 剩余结束时间、-1表示永久有效
        ,endtime = 0            %% BUFF结束时间
        ,msg = <<>>             %% 提示信息   
    }
).

%%------------------------------------------------
%% 宠物魔晶系统 （装备）
%%------------------------------------------------

%% 猎魔NPC
-record(pet_npc, {
        id = 0           %% NPC标志
        ,npc_name = <<>> %% NPC名称
        ,coin = 0        %% 猎魔金币
        ,gold = 0        %% 猎魔晶钻
        ,rand = {0, 0, 0}%% 猎魔事件概率 {不变, 消失, 跳到下一个NPC}
    }
).

%% 猎魔NPC产出物品信息
-record(pet_npc_item, {
        id  = 0          %% NPC标志
        ,base_id = 0     %% 物品基础ID
        ,item_name = <<>>%% 物品名称
        ,rand = 0        %% 产出概率
        ,is_notice = 0   %% 是否需要公告
    }
).

%% 魔晶物品数据等级属性数据
-record(pet_item_attr, {
        base_id = 0       %% 物品基础ID
        ,name = <<>>      %% 物品名称
        ,lev = 0          %% 等级
        ,exp = 0          %% 升级下一级所需经验 [0:表示不能继续升级]
        ,attr = []        %% 附加属性数据
        ,polish = {0, 0}  %% 洗练条数范围{Min, Max}
        ,polish_list = [] %% 洗练属性 {Label, N, [Min, Max], Rand}
    }
).
