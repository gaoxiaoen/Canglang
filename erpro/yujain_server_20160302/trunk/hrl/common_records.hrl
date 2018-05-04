%%%-------------------------------------------------------------------
%%% File        :common_records.hrl
%%% @doc
%%%     定义公共的record文件
%%% @end
%%%-------------------------------------------------------------------

%%==========================道具相关配置文件 begin=================================
%% 属性 装备配置是这个记录的赋值是不同的，是一个列表表示最小，最大值如,[100,200]
-record(r_property,{
                    hp            = 0,      %% 气血上线
                    phy_attack    = 0,      %% 物理攻击力
                    magic_attack  = 0,      %% 魔法攻击力
                    phy_defence   = 0,      %% 物理防御
                    magic_defence = 0,      %% 魔法防御
                    hit           = 0,      %% 命中
                    miss          = 0,      %% 闪避
                    double_attack = 0,      %% 暴击
                    tough         = 0,      %% 坚韧
                    seal          = 0,      %% 封印
                    anti_seal     = 0,      %% 抗封
                    cure_effect   = 0       %% 治疗强度
                   }).
%% 装备基本属性
-record(r_equip_info,{
                      type_id = 0,         %% 装备标识
                      name = "",           %% 装备名
                      slot_num = 0,        %% 装备使用的位置
                      kind = 0,            %% 装备类型,如刀,剑，法杖等
                      endurance = 0,       %% 最大耐久度
                      use_sex = 0,         %% 使用性别 0不限制 1男,2女
                      use_min_level = 0,   %% 最小使用等级
                      property,            %% 装备固定附加属性 r_property
                      sell_type = 1,       %% 出售类型 0不可卖,1卖金币,2卖银币
                      sell_price = 0,      %% 售卖价格
                      stall_type = 0,      %% 市场分类类型
                      high_quality = 0     %% 高品质，真品 0不是 1真品   
                     }).
%% 道具基本属性
-record(r_item_info,{
                     type_id = 0,          %% 道具类型id
                     name = "",            %% 道具名
                     kind = 0,             %% 药品、书籍、原料、包裹、灵符等
                     is_overlap = 0,       %% 是否可以重叠，1表示可重叠，2表示不可重叠
                     use_num = 0,          %% 使用次数，1表示可叠放只能使用一个
                     use_sex = 0,          %% 使用性别 0不限制 1男,2女
                     use_min_level = 0,    %% 最小使用等级
                     sell_type = 1,        %% 出售类型 0不可卖,1卖金币,2卖银币
                     sell_price = 0,       %% 售卖价格
                     cd_type = 0,          %% CD类型
                     stall_type = 0,       %% 市场分类类型
                     main_effect_id = 0,   %% 主使用效果id
                     sub_effect_id = 0     %% 子使用效果id
                    }).
%% 宝石基本属性
-record(r_stone_info,{
                      type_id = 0,         %% 宝石类型id
                      name = "",           %% 宝石名
                      kind = 0,            %% 宝石种类
                      is_overlap = 0,      %% 是否可以重叠，1表示可重叠，2表示不可重叠
                      level = 0,           %% 宝石等级
                      embe_equip_list = [],%% 可以镶嵌的装备的类型
                      use_min_level = 0,   %% 最小使用等级
                      property,            %% 宝石属性r_property
                      sell_type = 1,       %% 出售类型 0不可卖,1卖金币,2卖银币
                      sell_price = 0,      %% 售卖价格
                      stall_type = 0,      %% 市场分类类型
                      next_type_id = 0     %% 下一级别宝石类型id,0表示满
                     }).

%% 创建道具的通用结构
-record(r_goods_create_info,{
                             via = 0,       %%获得来源
                             item_type = 0, %%道具类型 
                             type_id = 0,   %%道具类型id
                             item_num = 0,  %%道具数量
                             start_time = 0,%%开始时间 时间截
                             end_time = 0,  %%结束时间 时间截
                             days = 0,      %%创建此道具时 有效期多少天
                             punch_num = 0, %%孔数 1,2,3,4,5,6
                             stones = []   %%[typeId,...] 要配置宝石就必须配置孔位
                             }).
%%==========================道具相关配置文件 end====================================

%% 聊天需要的玩家的数据
-record(r_chat_role_param,{
                           role_id = 0,             %% 玩家id
                           role_name = "",          %% 玩家名称
                           faction_id = 0,          %% 国家id
                           level = 0,               %% 玩家等级
                           sex = 0,                 %% 性别
                           head = 0,                %% 头像id
                           team_id = 0,             %% 组队id
                           family_id = 0,           %% 帮派id  
						   family_name = 0,         %% 帮派名称 
                           office_id = 0,           %% 官职id
                           office_name = "",        %% 官职名称
                           signature = "",          %% 玩家签名
                           realm= 0                %% 玩家境界
                          }).

%% 广播记录结构
-record(r_unicast, {module, method, role_id, record}).

%% 玩家进程state
-record(r_role_world_state,{role_id=0,gateway_pid=undefined,gateway=0,state=0,offline_time=0,
                            client_ip ="",info=undefined,quick_key=undefined}).

%%==========================地图相关配置 Begin==================================
%% 玩家跳转地图数据结构定义
%% role_pid 玩家角色PId，即玩家世界进程PId
%% map_role 角色信息 #p_map_role{},
%% map_pet 宠物信息 #p_map_pet{}
%% map_actors 地图属性 [#r_map_actor{},...]
%% ext_info 扩展信息 结构为[{key,value},..]
-record(r_map_param,{role_id=0,role_pid=undefined,faction_id=0,map_role=undefined,map_pet=undefined,map_actors=[],ext_info = []}).
%% 地图进程state
-record(r_map_state,{map_id=0,map_type=0,map_process_name="",map_pid=undefined,fb_id=0,
					 offset_x=0,offset_y=0,mcm_module=undefined,status=0,
                     create_time=0}).
%% 地图角色信息结构
%% actor_id 角色id 可以是玩家id,宠物id,怪物id
%% actor_type 角色类型 1玩家，2宠物，3怪物
%% skill_delay 延迟技能 undefined | {TimerRef,SkillId,DelayType}
%% fight_buff 角色战斗buff列表 [] | [#r_buff{}]
%% add_mp_time 自动恢复魔法值时间，0表示不需要恢复
%% last_walk_path_time 最后寻路时间
%% skill_state 结构为 p_actor_skill_state
-record(r_map_actor,{actor_id=0,actor_type=0,skill_delay=undefined,fight_buff=[],
                     add_mp_time=0,last_walk_path_time=0,skill_state=undefined,
                     temp_attr = undefined,attr=undefined,skill=[],ext=undefined}).

%% 地图玩家宠物信息记录
%% display_type 宠物显示类型 0：所有地图显示 1：只在副本地图显示
-record(r_map_role_pet,{role_id=0,battle_id=0,battle_cd=0,display_type=0}).

%% 同屏广播的玩家人数
-define(MAX_SLICE_BROADCAST_ROLE,50).


%% 地图的特殊定义
%% 地图格子大小 100cm
-define(MAP_TILE_SIZE, 100). 
-define(MAP_TILE_SIZE_MIDDLE,50).

%% 地图九宫格大小
-define(MAP_SLICE_WIDTH, 1000).
-define(MAP_SLICE_HEIGHT, 1000).

%% 地图类型
-define(MAP_TYPE_NORMAL,0).                %% 正常地图
-define(MAP_TYPE_FB,1).                    %% 副本地图
-define(MAP_TYPE_CROSS,2).                 %% 跨服地图

%% 地图进程状态
-define(MAP_PROCESS_STATUS_INIT,1).        %% 1：初始
-define(MAP_PROCESS_STATUS_RUNNING,2).     %% 2：进行中
-define(MAP_PROCESS_STATUS_CLOSE,3).       %% 3：关闭
-define(MAP_PROCESS_STATUS_COUNTDOWN,4).   %% 4：关闭倒记时中

%% 地图点类型
-define(MAP_REF_TYPE_WALK,0).              %% 可行走
-define(MAP_REF_TYPE_NOT_WALK,1).          %% 怪物不可行走

%% 地图资源点类型
-define(MAP_ELEMENT_BORN_POINT,3).         %% 出生点
-define(MAP_ELEMENT_NPC_POINT,4).          %% NPC
-define(MAP_ELEMENT_MONSTER_POINT,5).      %% 怪物
-define(MAP_ELEMENT_JUMP_POINT,6).         %% 跳转点

%% 跳转地图类型
-define(MAP_CHANGE_TYPE_NORMAL, 0).              %% 普通
-define(MAP_CHANGE_TYPE_ENTER_FB, 1).            %% 进入副本传送
-define(MAP_CHANGE_TYPE_QUIT_FB, 1).             %% 退出副本传送

%% 地图进入类型
-define(MAP_ENTER_TYPE_NORMAL,0).                %% 普通
-define(MAP_ENTER_TYPE_FIRST,1).                 %% 第一次进入
%% 退出地图类型
-define(MAP_QUIT_TYPE_NORMAL,0).                 %% 普通
-define(MAP_QUIT_TYPE_ROLE_LOGOUT_GAME,0).       %% 玩家退出游戏

%% 地图数据配置
%% map_id 地图id
%% map_name 地图名称
%% map_type 地图类型,0正常地图,1副本地图,2跨服地图
%% sub_type 是否直接出生怪物 0不出生，1出生
%% faction_id 地图国家,0不限制,1,2,3国家,4中产区
%% level 地图进入最小等级 0不限制
-record(r_map_info,{map_id=0,map_name="",
                    map_type=0,sub_type=0,
					tile_row=0,tile_col=0,
					offset_x=0,offset_y=0,
					width=0,height=0,
					faction_id=0,level=0,
					mcm_module=undefined}).
%% 地图切换数据字典
%% take_data 需要携带跳转地图的数据[{key,Value},....]
-record(r_role_change_map,{role_id=0,map_id=0,map_process_name="",map_pid=undefined,
                           tx=0,ty=0,x=0,y=0,change_type=0,group_id=0,take_data=[]}).

%% 地图资配置
%% res_type 资源类型,3出生点,4NPC,5怪物,6跳转点
%% 当res_type=4时res_id表示NPC ID
%% 当res_type=5时res_id表示怪物Id
%% 当res_type=6时extra={DestMapId,DestTx,DestTy}
%% dir 表示方向
-record(r_map_res,{map_id=0,res_type=0,res_id=0,tx=0,ty=0,dir=0,extra=undefined}).
%% 地图点配置
%% type 地图点类型,1安全区,2绝对安全区,3不安全区
-record(r_map_ref,{tx=0,ty=0,type=0}).
%% slice_name 地图slice_name规则为"slice_name_Tx_Ty"
%% slice_9_list 当前地图点所在的九宫格列表
-record(r_map_slice,{tx=0,ty=0,type=0,slice_name="",slice_9_list=[],slice_16_list=[]}).

%%==========================地图相关配置 End====================================
%%==========================技能相关配置 Begin==================================
%% 技能基本配置记录
-record(r_skill_info,{skill_id=0,               %% 技能id
                      type=0,                   %% 技能类型 0系统技能 1职业技能 2宠物技能 3怪物技能 4帮派技能
                      level=0,                  %% 等级,技能初始等级
                      min_level=0,              %% 最小使用等级
                      category=0,               %% 职业，0无职业 1
                      contain_base_attack=0,    %% 是否包含普通攻击伤害 0不包含 1包含
                      attack_mode=0,            %% 攻击模式 0主动 2被动
                      distance=0,               %% 攻击距离 单位：厘米
                      move_type=0,              %% 技能位移类型 0无位移 1有位移
                      consume_anger=0,          %% 每一次技能使用消耗怒气值
                      consume_mp=0,             %% 每一次技能使用消耗魔法值
                      consume_mp_index=0,       %% 消耗魔法系数
                      chant_time=0,             %% 吟唱时间
                      delay_time=0,             %% 延迟时间
                      cd=0,                     %% 技能CD
                      common_cd=0,              %% 公共CD
                      calc_index=0,             %% 技能计算系数，战斗公式中需要使用
                      target_type=0,            %% 施法目标
                      target_w=0,               %% 技能作用目标范围，单位：厘米
                      target_h=0,               %% 技能作用目标范围，单位：厘米
                      target_kind=0,            %% 作用目标类型
                      target_number=0,          %% 技能作用目标数量
                      self_effects=[],          %% 技能自身效果id列表
                      target_effects=[]         %% 技能作用目标效果id列表
                     }).
%% 技能效果记录
-record(r_skill_effect,{effect_id=0,            %% 效果id
                        type=0,                 %% 效果类型 定义技能的各种效果类型
                        a=0,                    %% 值 不同【效果类型】表示不同作用的值
                        b=0,                    %% 值
                        c=0,                    %% 值
                        d=0,                    %% 值
                        e=0                     %% 值
                        }).
%% buff 记录
-record(r_buff_info,{
                buff_id=0,                      %% buff id
                type=0,                         %% 类型 加血 减血等buff效果
                kind=0,                         %% 类别 0系统 1技能
                group_id=0,                     %% 组ID, 0 不分组
                level=0,                        %% BUFF等级，同一分组的BUFF，高级的覆盖低级的
                overlap=0,                      %% 是否可叠加 0不可叠加 1可叠加
                remove=0,                       %% 是否可被驱散 0不可驱散 1可驱散
                toc=0,                          %% 是否需要通知前端 0不通知 1通知
                is_debuff=0,                    %% 是否是减益buff 0不是 1是
                target_type=0,                  %% 目标类型 0目标 1地面
                keep_type=0,                    %% 持续类型 1：普通的持续一定的时间,2：没有时间限制
                keep_value=0,                   %% 每次触发值
                keep_interval=0,                %% 触发间隔
                duration=0,                     %% 持续时间 单位：毫秒，毫秒，毫秒
                value_type=0,                   %% 数值类型 0绝对值 1万分比
                a=0,                            %% 值a
                b=0,                            %% 值b
                c=0                             %% 值c
                }).

%% BUFF 实体
-record(r_buff, {
                buff_id=0,                      %% BUFF ID
                type=0,                         %% 类型 加血 减血等buff效果
                group_id=0,                     %% 组ID, 0 不分组
                level=0,                        %% BUFF等级
                toc=0,                          %% 是否需要通知前端 0不通知 1通知
                skill_id=0,                     %% 如果技能产生的BUFF,表示技能id
                skill_level=0,                  %% 技能等级
                start_time=0,                   %% 开始时间，时间戳
                end_time=0,                     %% 结束时间，时间戳 0表示永久有效
                remain_life=0,                  %% 剩余时间，单位：毫秒，毫秒，毫秒
                next_time=0,                    %% 下次触发时间,0即没有下一次触发时间
                trigger_times=0                 %% 触发次数 0即表示不需要间隔时间触发
                }).

%%==========================技能相关配置 End  ==================================
%%==========================宠物相关配置 Begin==================================
-record(r_pet_info,{type_id=0,                   %% 宠物类型id
                    name="",                     %% 宠物名称
                    attack_type=0,               %% 攻击类型 1物理 2法术
                    carry_level=0,               %% 携带等级
                    sex=0,                       %% 性别 1雄,2雌
                    life=0,                      %% 寿命
                    inborn=[],                   %% 天赋值，格式[{Value,Weight},...]
                    hp_aptitude=[],              %% 血资质，格式[{Min,Max}]
                    mp_aptitude=[],              %% 魔资质，格式[{Min,Max}]
                    phy_attack_aptitude=[],      %% 物攻资质，格式[{Min,Max}]
                    magic_attack_aptitude=[],    %% 魔攻资质，格式[{Min,Max}]
                    phy_defence_aptitude=[],     %% 物防资质，格式[{Min,Max}]
                    magic_defence_aptitude=[],   %% 魔防资质，格式[{Min,Max}]
                    miss_aptitude=[],            %% 闪避资质，格式[{Min,Max}]
                    base_attr_dot=0,             %% 宠物1级时总的属性点，按一定的计算公式来计算出5个基础属性的值
                    skills=[],                   %% 宠物初始技能id列表
                    display_type=0               %% 宠物显示类型 0：所有地图显示 1：只在副本地图显示
                   }).
%%==========================宠物相关配置 End====================================
%%==========================怪物相关配置 Begin==================================
%% 怪物地图记录
-record(r_monster_state,{  id=0,                      %% 怪物id 一张地图中不会重复
                           type_id=0,                 %% 怪物类型id
                           create_time = 0,           %% 创建时间
                           reborn_type=0,             %% 重生类型 0不重生 1怪物死亡之后重新
                           last_status=0,             %% 上一次状态
                           status=0,                  %% 当前状态
                           is_skill_delay=0,          %% 是否进行技能延迟释放
                           effect_status=0,           %% 眩晕状态
                           dead_time = 0,             %% 死亡时间
                           dead_fun=undefined,        %% 怪物死亡调用函数 Fun
                           next_tick=0,               %% 怪物下一个触发时间
                           next_action=undefined,     %% 怪物下一个动作 loop ignore
                           next_data=undefined,       %% 怪物下一个动作数据
                           group_id=0,                %% 分组id,0无分组【用于区分敌方和友方】
                           base_skill=undefined,      %% 怪物基础技能 {SkillId,SkillLevel}
                           born_pos=undefined,        %% 出生位置 #p_pos{}
                           born_dir=0,                %% 出生方向
                           pos=undefined,             %% 当前位置 #p_pos{}
                           dir=0,                     %% 怪物方向
                           dest_pos=undefined,        %% 怪物寻路终点 #p_map_pos{}
                           walk_list=[],              %% 怪物寻路路径[#p_map_tile{}....]
                           fight_time=0,              %% 怪物进入战斗时间,单位：毫秒
                           be_attack_time=0,          %% 被攻击时间，单位：毫秒，此后一段时间内不能发出攻击
                           last_target_time=0,        %% 切换攻击目标时间，单位：毫秒
                           ai_data=[],                %% 怪物ai
                           enemy_list=[]              %% 仇恨列表 [#r_enemy{}...]
                        }).
%% 仇恨记录
%% key = {ActorId,ActorType}
-record(r_enemy,{key=undefined,last_attack_time=0,total_hurt=0}).
%% 创建怪物参数记录
%% born_type 出生类型，0正常出生 1立即出生
-record(r_monster_param,{born_type=0,type_id=0,reborn_type=0,dead_fun=undefined,group_id=-1,pos=undefined,dir=0}).
%% 怪物出生点记录
-record(r_monster_pos,{type_id=0,x=0,y=0,tx=0,ty=0,dir=0}).
%% 怪物配置表
-record(r_monster_info,{type_id=0,                %% 怪物类型id type_id=(type_code * 1000 + level)
                        type_code=0,              %% 怪物编码
                        level=0,                  %% 怪物等级
                        name="",                  %% 怪物名称
                        type=1,                   %% 怪物类型 1普通 2精英 3BOSS
                        body_radius=0,            %% 怪物身体半径，技能攻击距离判断需要加上这个半径
                        attack_mode=0,            %% 攻击类型 1物理 2法术
                        exp=0,                    %% 怪物掉落经验
                        silver=0,                 %% 怪物掉落金币
                        coin=0,                   %% 怪物掉落银币
                        attr=undefined,           %% 怪物属性 #p_fight_attr{}
                        ai_attack_type=0,         %% AI攻击类型 0：不攻击 1：被动攻击 2：主动攻击
                        ai_id=0,                  %% ai标识id
                        ai_move_type=0,           %% AI移动类型 0：不会移动 1：会移动
                        guard_radius=0,           %% 警戒半径 单位：厘米
                        trace_radius=0,           %% 追踪半径 单位：厘米
                        base_skill=undefined,     %% 怪物基础技能 {SkillId,SkillLevel}        
                        max_drop_times=0,         %% 掉落次数，0不限制，1...N限制每人每天最多掉落的次数
                        drops=[]                  %% 掉落规则
                        }).
%% 怪物死亡获取奖励配置
%% weight 权值 计算些掉落是不是掉落
%% calc_number 计算次数
%% drop_type 掉落类型
%%              0：权重，按所有物品的概率总数为总概率，概率高的先判断，此掉落类型每一次掉落一个物品
%%              1：每一个物品单独计算是否掉落
-record(r_monster_drop,{drop_type=0,weight=0,calc_number=0,items=[]}).
-record(r_monster_drop_item,{type_id=0,type=0,number=1,weight=0}).
%% AI记录
-record(r_ai,{ai_id=0,ai_list=[]}).
%% AI触发记录
%% priority 优先级 0...N 从小到大 0是最高优先级
%% trigger_type 触发类型
%%     1：技能CD
%%     2：血量从上往下经过x%线,触发值A表示当前血量的占总血量百分比
%%     3：被攻击时概率触发,触发值A表示触发万分比
%%     4：攻击时概率触发,触发值A表示触发万分比
%%     5：首次攻击状态触发
%%     6：怪物死亡触发
%% event_type 事件类型
%%     1：触发技能，事件值A表示技能ID,事件值B表示技能等级 
%%     2：怪物自杀，事件A表示命中万分比
%%     3：怪物逃跑，逃跑到出生点，事件A表示命中万分比
-record(r_ai_trigger,{priority=0,trigger_type=0,trigger_val_1=0,trigger_val_2=0,event_type=0,event_val_1=0,event_val_2=0}).
%%==========================怪物相关配置 end====================================

%%==========================副本相关配置 Begin==================================
%% 副本配置
-record(r_fb_info,{fb_id=0,                   %% 副本id,唯一标识，一类副本用同一个id,用于副本记录次数使用
                   map_id=0,                  %% 副本地图id
                   fb_module=undefined,       %% 副本处理模块,各不同的副本逻辑相应的实现代码模块
                   create_map_process_type=0, %% 创建地图进程类型,0进入副本创建 1游戏启动创建
                   fb_type=0,                 %% 副本类型 0未知 1个人副本 2组队副本
                   create_avatar=0,           %% 进入副本时，是否需要创建虚像在入口地图显示 0不创建 1创建
                   min_number=1,              %% 副本最少开启人数
                   times_type=1,              %% 副本次数类型 0未知 1每天清零 2周清零[自然周]
                   enter_times=0,             %% 副本进入最大次数 0不限制
                   min_level=0,               %% 进入副本的最小等级，0为不限制
                   max_time=0,                %% 副本最长时间，到这个时间即自动关闭 单位：秒
                   protect_time=0,            %% 副本内下线保护时间 单位：秒
                   countdown=0                %% 副本完成自动倒计时并踢人关闭副本，单位：秒
                   }).
-record(r_fb_dict,{fb_id=0,monster_level=0,fb_roles=[]}).
%% offline_time 玩家离线时间 0表示未离线
-record(r_fb_role_dict,{role_id=0,from_map_id=0,from_map_pid=undefined,
                        from_map_process_name="",from_pos=undefined,offline_time=0}).
%% 副本怪物配置
%% born_type 出生类型 
%%                 0：直接全部怪物出生 
%%                 1：一波一波出生，一波怪物被清光，立即出生下一波怪物 
%%                 2：一波一波出生，按每一波怪的出生时间间隔，出生下一波怪物 
%%                 3：一波一波出生，一波怪清光，等待间隔时间，出生下一波怪物 
%%                 4：一波一波出生，一波怪物被清光，立即出生下一波怪物，同时间隔时间到了，也出生下一波怪物
%% monster_level 怪物等级 0使用默认等级
%% wait_interval 副本创建后等待时间之后才开始出生怪物，单位：秒
%% born_interval 一波一波怪物出生间隔时间，单位：秒
-record(r_fb_monster,{fb_id=0,born_type=0,wait_interval=0,born_interval=0,monster_level=0,monsters=[]}).
%% order_id 次序Id 0无序，全部
-record(r_fb_monster_sub,{order_id=0,monsters=[]}).
%% type_id 怪物类型id
-record(r_fb_monster_item,{type_code=0,x=0,y=0,dir=0}).
%% 副本怪物进程数据
%% born_status 副本怪物出生状态，0未开始 1进行中 2已经全部出生
-record(r_fb_monster_dict,{born_type=0,born_time=0,born_interval=0,monster_level=0,order_id=0,born_status=0}).
%%==========================副本相关配置 end====================================

%%==========================任务相关配置 end====================================
-record(r_mission_base_info,{id=0,name ="",
                             type=0,show_type=0,model=0,big_group=0,group_desc="",color=0,
                             pre_mission_id_list=[],min_level=0,max_level=0,max_do_times=0,star_level=0,sort_id=0,
                             next_mission_id_list = [],
                             need_item_list=[],listener_list=[],
                             model_status_list=[],max_model_status = 0,
                             reward_info,reward_item_list=[]}).
-record(r_mission_need_item,{item_type_id = 0,item_num=0}).
-record(r_mission_base_listener,{type=0, sub_type=0, value=0,need_num=0}).
-record(r_mission_model_status,{npc_list=[],ext_list=[]}).
-record(r_mission_reward,{rollback_times=0,is_category=0,formula_base=0,formula_item=0,
                          exp=0,silver=0,coin=0}).
-record(r_mission_reward_item,{item_type_id=0,item_type=0,item_num=0}).

%% 任务委托配置
%% big_group 任务分组
%% min_level 可委托的最小玩家等级
%% need_time 每一环任务委托需要的时间，单位：秒
%% op_fee 每一一次任务委托需要的费用，单位：金币
%% do_fee 立即完成费用，单位：金币
-record(r_mission_base_auto,{big_group=0,name="",min_level=0,need_time=0,op_fee=0,do_fee=0}).

%%==========================任务相关配置 end====================================
%% 玩家等级经验配置记录
-record(r_level_exp, {level = 0, exp = 0}).




%% 游戏循环消息广播定义
%% key 唯一编码
%% msg_type 消息类型 1:广播消息,2:聊天频道消息,
%% msg_sub_type 消息子类型 msg_type=2 时 msg_sub_type 对应聊天频道的频道类型
%% start_time 开始时间 格式为：common_tool:now()
%% end_time  结束时间 格式为：common_tool:now()
%% interval 间隔时间 单位：秒
%% is_world 是否全服广播
%% category 此消息的接收者，门派
%% famliy_id 此消息的接收者，帮派
%% team_id 此消息的接收者，队伍
%% role_id_list
%% content 消息内容
-record(r_broadcast_message_param,{msg_type = 0,msg_sub_type = 0,start_time = 0,end_time = 0, 
                                  interval = 0,is_world = false, category = 0,famliy_id = 0, 
                                  team_id = 0,role_id_list = [], msg = ""}).

%% 每天固定时间循环广播消息配置
%% bc_time:广播时间{HH,MM,SS}
%% msg_type 消息类型 1:广播消息,2:聊天频道消息,
%% msg_sub_type 消息子类型 msg_type=2 时 msg_sub_type 对应聊天频道的频道类型
%% content 广播的消息内容
-record(r_broadcast_message_config,{id=0,bc_time=undefined,msg_type=0,msg_sub_type=0,msg=""}).


%% 锻造配置
%% stone_level 宝石等级
%% exp 当前等初始经验 
%% next_level_exp 下一等级经验
-record(r_stone_exp_info,{stone_level = 0, exp = 0,next_level_exp = 0}).

%% NPC 信息
%% id NPC id
%% name NPC 名称
%% map_id NPC所在地图
%% tx,ty NPC所在位置
%% npc_level NPC 等级
-record(r_npc_info,{id=0,name="",map_id=0,npc_level=0,tx=0,ty=0}).

%% 帮派进程状态
-record(r_family_state,{family_id=0}).



%% 排行榜配置
%% rank_id 排行榜ID
%% capacity 排行榜长度
%% refresh_interval 刷新间隔
%% refresh_type 刷新类型
%% rank_module 排行榜模块
-record(p_ranking,{rank_id=0,capacity=0,refresh_interval=0,refresh_type=0,rank_module}).


%% ETS阵营人数表
-define(ETS_FACTION_ROLE,ets_faction_role).
-record(r_faction_role, {faction_id, number}).

-record(r_cfg_tuitu_barrier,{next_barrier_id=0,
                             group_id= 0,
                             group_name = "",
                             is_boss=0,
                             add_exp=0,
                             add_coin=0,
                             cost_energy=0,
                             monster_id=0,
                             drop_list=[]}).

%%==========================属性相关配置 Begin==================================
%% 对象（人物/怪物/宠物）战斗属性属性
%% 地图存储用于战斗的属性
%% -record(r_fight_attr, {
%%             max_hp = 0,                 %%最大生命上限
%%             hp = 0,                     %%生命值
%%             max_mp = 0,                 %%最大魔法上限
%%             mp = 0,                     %%魔法值
%%             max_anger = 0,              %%最大怒气
%%             anger = 0,                  %%怒气
%%             phy_attack = 0,             %%物理攻击力
%%             magic_attack = 0,           %%魔法攻击力
%%             phy_defence = 0,            %%物理防御
%%             magic_defence = 0,          %%魔法防御
%%             hit = 0,                    %%命中
%%             miss = 0,                   %%闪避
%%             double_attack = 0,          %%暴击
%%             tough = 0,                  %%坚韧
%%             seal = 0,                   %%封印
%%             anti_seal = 0,              %%抗封
%%             cure_effect = 0,            %%治疗强度
%%             attack_skill = 0,           %%物法修炼，功击修炼
%%             phy_defence_skill = 0,      %%物防修炼
%%             magic_defence_skill = 0,    %%魔防修炼
%%             seal_skill = 0              %%抗封修炼
%%         }).

%% 基础属性
-record(r_base_attr, {
            power = 0,                  %%力量
            magic = 0,                  %%魔力
            body = 0,                   %%体质
            spirit = 0,                 %%念力
            agile = 0                   %%敏捷
        }).

%%==========================属性相关配置 End  ==================================

%%==========================组队相关配置 Begin==================================
%% 队伍信息
%% team_id:队伍id
%% process_name:队伍进程名称
%% leader_id:队长角色id
%% team_list:队员列表 [#p_team_member{},...]
%% auto_id:用于自动匹配队伍，一般用于副本id来表示
-record(r_team,{team_id=0,process_name="",leader_id=0,team_list=[],auto_id=0}).

%%==========================组队相关配置 End  ==================================