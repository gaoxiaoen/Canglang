%%%=======================================================================
%%% 数据配置结构定义
%%%=======================================================================

%% mnesia 表结构
%% table_name 表名
%% copies_type ram_copies|disc_copies|disc_only_copies
%% type set|bag
%% record_name 结构名
%% index_list 字段索引列表|is a list of attribute names (atoms)
-record(r_tab,{table_name,copies_type,type,record_name,record_fields,index_list=[]}).


%% 保存在玩家进程的表结构
%% table_name 表名
%% store_type 存储类型 ets|dist
%% load_type 加载类型 auto|custom
%% dump_type 转储类型 auto|custom
-record(r_role_tab,{table_name,store_type,load_type,dump_type}).

%%%=======================================================================
%%% 定义游戏表和表结构
%%%=======================================================================

%% 角色 id 计数器
-define(DB_ROLE_ID, db_role_id).
%% 计数器统一 record 结构 key为服id last_id为最大的可用的用户id
-record(r_counter,{key=0,last_id=1}).


%% 帐号表
-define(DB_ACCOUNT, db_account).
-record(r_account, {account_name, create_time = 0, role_num = 0, role_list=[]}).
-record(r_account_sub,{role_id = 0,server_id = 0,create_time = 0}).
%% 角色名表
-define(DB_ROLE_NAME, db_role_name).
-record(r_role_name, {role_name, role_id}).

%% 角色信息表
-define(DB_ROLE_BASE, db_role_base).
-define(DB_ROLE_ATTR, db_role_attr).
-define(DB_ROLE_POS, db_role_pos).
-record(r_role_pos,{role_id=0,
                    map_id=0,                               %% 当前地图id
                    pos=undefined,                          %% 当前位置 #p_pos{}
                    map_process_name=undefined,             %% 当前地图进程名称 term() | string
                    group_id=0,                             %% 玩家分组id
                    last_map_id=0,                          %% 上次地图id
                    last_pos=undefined,                     %% 上次位置 #p_pos{}
                    last_map_process_name=undefined,        %% 上次地图进程名称 term() | string
                    last_group_id=0                         %% 上次玩家分组id
                   }).
-define(DB_ROLE_EXT, db_role_ext).
-define(DB_ROLE_STATE, db_role_state).
-record(r_role_state, {role_id, status = 0}).


%% 背包表
-define(DB_ROLE_BAG_BASIC, db_role_bag_basic).
-record(r_role_bag_basic,{role_id=0,bag_id_list = [],max_goods_id = 0}).
-define(DB_ROLE_BAG, db_role_bag).
%% role_bag_key = {role_id,bag_id},相当于联合主键
-record(r_role_bag,{role_bag_key,grid_number=0, bag_goods = []}).

%% 玩家装备表
-define(DB_ROLE_EQUIP,db_role_equip).
%% suit_id 装备当前使用id 1:对应equip_a_list 2:对应equip_b_list 3:对应equip_c_list
-record(r_role_equip,{role_id=0,suit_id=1,equip_a_list=[],equip_b_list=[],equip_c_list=[]}).


%% 宠物id计数器
-define(DB_PET_COUNTER, db_pet_counter).
%% 玩家宠物表
-define(DB_ROLE_PET,db_role_pet).
%% battle_id 出战宠物id
%% battle_cd 宠物出战CD
%% last_battle_id 最后出战宠物id
%% attack_skill 物法修炼，功击修炼
%% phy_defence_skill 物防修炼
%% magic_defence_skill 魔防修炼
%% seal_skill 抗封修炼
%% is_has 是否拥有过宠物 0未拥有 1已经拥有过
-record(r_role_pet,{role_id=0,battle_id=0,battle_cd=0,last_battle_id=0,is_has=0,
        attack_skill=0,phy_defence_skill=0,magic_defence_skill=0,seal_skill=0}).
%% 宠物表
-define(DB_PET,db_pet).
-record(r_pet,{ pet_id= 0,                          %% 宠物id
                via= 0,                             %% 宠物来源，即宠物通过什么来获得
                create_time= 0,                     %% 宠物创建时间
                role_id= 0,                         %% 宠物属于玩家id
                pet_name= "",                       %% 宠物名称
                type_id= 0,                         %% 宠物类型id
                status= 0,                          %% 宠物状态 0正常 1出战
                bind= 0,                            %% 是否绑定 0未绑定 1绑定
                life= 0,                            %% 宠物寿命，影响宠物是否能出战
                inborn= 0,                          %% 天赋影响宠物的成长，即影响宠物的所有属性
                exp= 0,                             %% 经验值
                next_level_exp= 0,                  %% 升级经验
                level= 0,                           %% 宠物等级
                hp_aptitude= 0,                     %% 血资质
                mp_aptitude= 0,                     %% 魔资质
                phy_attack_aptitude= 0,             %% 物攻资质
                magic_attack_aptitude= 0,           %% 魔攻资质
                phy_defence_aptitude= 0,            %% 物防资质
                magic_defence_aptitude= 0,          %% 魔防资质
                miss_aptitude= 0,                   %% 闪避资质
                i_power= 0,                         %% 初始力量
                i_magic= 0,                         %% 初始魔力
                i_body= 0,                          %% 初始体质
                i_spirit= 0,                        %% 初始念力
                i_agile= 0,                         %% 初始敏捷
                b_power= 0,                         %% 基本的力量,增加物理攻击
                b_magic= 0,                         %% 基本的魔力,增加魔法攻击
                b_body= 0,                          %% 基本的体质,增加生命上限、物理防御
                b_spirit= 0,                        %% 基本的念力,增加魔法上限、魔法防御、坚韧
                b_agile= 0,                         %% 基本的敏捷,增加闪避
                add_attr_dot= 0,                    %% 剩余可分配的属性点,升级可获得属性点
                power= 0,                           %% 总的力量 
                magic= 0,                           %% 总的魔力
                body= 0,                            %% 总的体质
                spirit= 0,                          %% 总的念力
                agile= 0,                           %% 总的敏捷
                attr= undefined,                    %% 属性 #p_fight_attr{}
                skills=[],                          %% 技能 [#p_actor_skill{},..]
                buffs=[]                            %% buff [#r_buff{}...]
               }).
%% 玩家宠物背包表
-define(DB_PET_BAG,db_pet_bag).
%% pet_bag_key = {role_id,bag_id} 即 bag_id=1随身宠物背包 bag_id=2宠物仓库
%% pets 宠物id列表
-record(r_pet_bag,{pet_bag_key,grid_number=0,pets = []}).

%% 玩家怪物记录表 特殊的怪物一般指BOSS怪物，玩家每天打一定的次数之后就不会获得掉落物奖励记录
-define(DB_ROLE_MONSTER,db_role_monster).
-record(r_role_monster,{role_id=0,monsters=[]}).
%% type_id 怪物类型id 
%% kill_times 怪物死亡次数
%% kill_time 最后一次杀死时间
-record(r_role_monster_item,{type_id=0,kill_times=0,kill_time=0}).


%% 玩家副本数据
-define(DB_ROLE_FB,db_role_fb).
-record(r_role_fb,{role_id,fbs=[]}).
%% fb_id 副本id
%% fb_times 副本次数
%% fb_time 副本时间，最后一次
%% count 总的副本次数
-record(r_role_fb_item,{fb_id=0,fb_times=0,fb_time=0,count=0}).

%% 系统配置信息表
-define(DB_SYSTEM_CONFIG, db_system_config).
%% 系统配置record结构
%% key: fcm 游戏防沉迷是否开启
-record(r_system_config, {key, value}).

%% 角色配置表
-define(DB_ROLE_SYS_CONF,db_role_sys_conf).
-record(r_role_sys_conf,{role_id=0,conf_list=[]}).

%% 玩家快捷栏
-define(DB_SHORTCUT_BAR, db_shortcut_bar).
-record(r_shortcut_bar, {role_id, shortcut_list, selected}).

%% 技能表
-define(DB_ROLE_SKILL, db_role_skill).
%% skill_list 技能列表[#p_actor_skill{},..]
-record(r_role_skill,{role_id=0, skill_list = []}).

%% 玩家BUFF表
-define(DB_ROLE_BUFF,db_role_buff).
%% buff_list buff列表[#r_buff{},...]
-record(r_role_buff,{role_id=0,buff_list = []}).

%% 防沉迷表
-define(DB_FCM_DATA, db_fcm_data).
-record(r_fcm_data, {account, card, truename, offline_time=0,  total_online_time=0, passed=false}).


%%当前在线用户表
-define(DB_ROLE_ONLINE, db_role_online).
-record(r_role_online,{role_id, role_name, account_name, faction_id, family_id, login_time, login_ip, port}).

%% 全局ETS表定义，用于共享玩家的基本数据，
%% 只能在玩家逻辑进程mgeew_role.erl下执行写操作
%% 其它地方只读取数据即可
%% 此表只保存在线玩家的数据，相关联的数据必须放在一个key，减少多次读取操作表
%% role_global_ets 表的结构为 key value
-define(ROLE_GLOBAL_ETS,role_global_ets).
%% key是组合key，一般为{RoleId,base},{RoleId,attr},
%% value 为各种数据结构的数据 
-record(r_dict,{key,value}).

%%%%%% 公共信件内容表
-define(DB_COMMON_LETTER_COUNTER,db_common_letter_counter).

-define(DB_COMMON_LETTER,db_common_letter).
%% id:int() 公共信件id
%% sender:string() 发件人
%% title:string() 公共信件内容
%% send_time:date() 发送时间
%% out_time:date() 过期时间
%% type:int() 信件类型：私人，帮派，系统，gm ，后台
%% text:string() 信件内容
-record(r_common_letter,{id,send_time,out_time,title,text=""}).

%% 信件
-define(DB_ROLE_LETTER,db_role_letter).
%% letter_list:list(r_letter_info:record()) 收件箱
%% count:int() 信件计数器  收件箱和发件箱用同一个
-record(r_role_letter,{role_id=0,role_name="",letter_list=[],count=0}).
%% 收件箱信息
%% id:int() 信件唯一标识
%% send_role_id:int() 发件人id
%% send_role_name:string() 发件人名字
%% send_time:int() 发件时间
%% out_time:int() 过期时间戳
%% title:string() 信件标题
%% type:int() 1.字符串，2.数据库模板 3.配置模板
%% content 内容
%% if content_type == 1 then content:string() 
%% if content_type == 2 then content:int() 公共信件id 
%% if content_type == 3 then content:int() 信件模板id
%% goods_list:list(p_goods:record()) 物品列表
%% state 收信信件状态   是否已读 1.信件没有打开 2. 信件读过了
%% type 信件类型 0.私人 1.宗族 2.系统  4.gm
%% is_send:boolean() true 是发信箱信件
-record(r_letter_info,{id=0,
                       role_id=0,role_name="",
                       send_time=0,out_time=0,
                       content_type,title,content,goods_list=[],
                       state=1,type=0,
                       is_send=true}).

%% 充值请求记录
-define(DB_PAY_REQUEST,db_pay_request).
%% 充值请求 key为组合key={order_id,account_name}
%% status 请求处理状态 ,0未处理,1充值成功,2充值失败
-record(r_pay_request,{key = "",order_id = "",account_name = "",account_via = "",
                         pay_time = 0,pay_money = 0,pay_gold = 0,server_id = 0,status = 0}).

%% 玩家任务表
-define(DB_ROLE_MISSION,db_role_mission).
%% mission_list 正在做的任务，可接任务列表 [#p_mission_info,...]
%% listener_list 侦听器列表  [#r_mission_listener,...]
%% counter_list 统计列表 #r_mission_counter{}
%% recolor_list 任务刷新颜色列表 #r_mission_recolor{}
%% auto_list 委托任务列表 #p_mission_auto{}
-record(r_role_mission,{role_id=0,mission_list=[],listener_list= [],counter_list=[],recolor_list = [],auto_list = []}).
%% Key {Type,SubType} 统一触发器标识
%% mission_id_list 任务id列表
%% ext_list 扩展列表
-record(r_mission_listener,{key,type=0,sub_type=0,mission_id_list=[]}).
%% key {0,MissionId} | {3,MissionBigGroup},主线，支线|循环
%% commit_times 提交次数
%% succ_times 成功提交次数
%% op_time 操作时间 
%% op_data 操作数据，现在只使用在任务模型为5时，玩家操作数据
-record(r_mission_counter,{key,id=0,commit_times=0,succ_times=0,op_time=0,op_data}).
%% 任务刷新记录
%% big_group 任务分组
%% color 任务颜色
%% do_times 刷新次数
%% coin_times 铜钱刷新次数
%% last_coin_time 上次铜钱刷新时间
-record(r_mission_recolor,{big_group=0,color=1,do_times=0,op_time=0,coin_times=0,last_coin_time=0}).


%% 消息广播
-define(DB_BROADCAST_MESSAGE,db_broadcast_message).
%% 后台消息广播记录定义
%% id 消息唯一标记
%% msg_type 消息类型 1:广播消息，在底部显示 2:聊天频道
%% msg_sub_type 消息子类型 msg_type=2 时 msg_sub_type 对应聊天频道的频道类型
%% send_strategy 发送策略 0:立即,1:特定日期时间范围, 2:星期 3:开服后,4:持续一段时间内间隔发送
%% start_date 如果是日期，即格式为：yyyy-MM-dd  开服后发送策略表示开始天数 星期发送策略即表示开始星期几
%% end_date 如果是日期，即格式为：yyyy-MM-dd 开服后发送策略表示结束天数 星期发送策略即表示结束星期几
%% start_time 如果为时间，即格式为：HH:mm:ss
%% end_time 如果为时间，即格式为：HH:mm:ss
%% interval 间隔时间 单位：秒
%% msg 消息内容
-record(r_broadcast_message,{id,msg_type = 0,msg_sub_type=0,send_strategy = 0,start_date = 0,end_date = 0,
                             start_time = 0,end_time = 0,interval = 0,msg = ""}).

%% 封禁帐号
-define(DB_LIMIT_ACCOUNT,db_limit_account).
%% limit_time 封禁时间，0表示永久封禁
-record(r_limit_account,{account_name ="",limit_time = 0}).
%% 封禁IP
-define(DB_LIMIT_IP,db_limit_ip).
%% limit_time 封禁时间，0表示永久封禁
-record(r_limit_ip,{ip ="",limit_time=0}).

%% 封禁设备Id
-define(DB_LIMIT_DEVICE_ID,db_limit_device_id).
%% limit_time 封禁时间，0表示永久封禁
-record(r_limit_device_id,{device_id ="",limit_time=0}).

%% 终级玩家组队信息结构
%% team_id玩家创建队伍的时间时间戳
%% process_name 玩家队伍进程名称
%% role_list 队伍成员信息 [p_team_role,...]
%% next_bc_time 玩家下次通知组队进程时间
%% pick_type 物品拾取模式，1：自由拾取，2：独自拾取
%% invite_list 邀请列表[r_role_team_invite,...]
%% do_status 玩家当前处理状态 0正常，1邀请，2加入队伍
%% team_code 队伍编码 0正常队伍 参考说明
%% team_code_map_id 队伍编码
-record(r_role_team,{role_id,team_id = 0,process_name,role_list = [],next_bc_time = 0,
                     pick_type = 1,invite_list = [],do_status = 0,team_code = 0,team_code_map_id = 0}).
%% role_id 玩家id
%% invite_id 被邀请的玩家id
%% invite_type 玩家邀请类型  0 正常情况 1收徒 2 拜师
%% invite_time 邀请时间 
%% invite_status 邀请状态 0:合法，1:队长转移时队长之前的邀请，9:非法状态
-record(r_role_team_invite,{role_id,team_id = 0,invite_id,invite_type = 0,invite_time = 0,invite_status = 0}).

%% 禁言表
-define(DB_BAN_CHAT_USER,db_ban_chat_user).
-define(DB_BAN_CONFIG,db_ban_config).
-record(r_ban_user,{rolename,deadline,adminid}).
-record(r_ban_ip,{ip,deadline,adminid}).
%%禁言记录
    %% duration - integer() - 封禁时长，单位：分钟
    %% type - integer() - 禁言者(0:GM/神眼/后台;1国王/皇帝
-record(r_ban_chat_user,{role_id,role_name="",time_start=0,time_end=0,duration=0,reason="",type=0}).
    %% type - integer() - 禁言类型(0:GM/神眼/后台;1国王/皇帝
-record(bankey,{type=1,role_id}).
-record(r_ban_config,{ban_key=#bankey{role_id=0},ban_times=0,todays}).

%% 客服系统
-define(DB_ROLE_CUSTOMER_SERVICE,db_role_customer_service).
%% max_id 最大id
%% data_list 客服内容
-record(r_role_customer_service,{role_id=0,max_id=1,content_list=[]}).
%% id 主题唯一id
%% reply_id 回复主题Id,0表示属性主题
%% type 类型,1:Bug,2:投诉,3:建议,4:其它
%% title 标题
%% content 内容
%% op_time 操作时间
%% status 状态,1未读,2已读
%% reply_time 管理平台最后回复时间
%% reply_list 回复列表[#r_role_customer_service_sub{},...]
-record(r_role_customer_service_sub,{id=0,reply_id=0,type=0,title="",content="",op_time=0,status=1,reply_time=0,reply_list=[]}).


%% 帮派系统

%% 帮派id计数器
-define(DB_FAMILY_COUNTER, db_family_counter).
%% 帮派名表
-define(DB_FAMILY_NAME, db_family_name).          
-record(r_family_name, {family_name="", family_id=0}).
%% 帮派表
-define(DB_FAMILY, db_family).                    
-record(r_family,{family_id=0,                        %% 帮派Id
                  family_name="",                     %% 帮派名称
                  create_role_id=0,                   %% 创建者Id
                  create_role_name="",                %% 创建者名称
                  owner_role_id=0,                    %% 帮派团长id
                  owner_role_name="",                 %% 帮派团长名称
                  faction_id=0,                       %% 国家Id
                  level=1,                            %% 帮派等级
                  create_time=0,                      %% 创建时间
                  cur_pop=0,                          %% 当前人口
                  max_pop=0,                          %% 最大人口
                  icon_level=1,                       %% 军微等级
                  total_contribute=0,                 %% 总贡献度
                  public_notice="",                   %% 对外公告
                  private_notice="",                  %% 对内公告（暂时未使用）
                  qq="",                              %% 帮派QQ群
                  member_list=[],                     %% 帮派成员列表[RoleId,...]
                  request_list=[],                    %% 申请列表 [#r_family_request{},...]
                  status=0                           %% 帮派状态,0正常
                 }).
%% src_role_id 邀请玩家id,0表示自己申请的
-record(r_family_request,{role_id=0,role_name="",role_level=0,op_time=0,src_role_id=0}).
%% 帮派成员表
-define(DB_FAMILY_MEMBER, db_family_member).
-record(r_family_member,{role_id=0,
                         role_name="",                %% 玩家名称
                         sex=0,                       %% 玩家性别
                         level=0,                     %% 玩家等级
                         category=0,                  %% 玩家职业
                         vip_level=0,                 %% VIP等级
                         last_login_time=0,           %% 最后登录时间
                         is_online=0,                 %% 是否在线,0不在线,1在线
                         join_time=0,                 %% 加入帮派时间
                         office_code=0,               %% 官职编码
                         cur_contribute=0,            %% 当强帮派贡献度,
                         total_contribute=0,          %% 总帮派贡献度,
                         qq="",                       %% QQ号码
                         day_total_donate=0,          %% 今日积累捐献值
                         total_donate=0,              %% 积累捐献值
                         donate_time=0                %% 捐献时间
                         }).


%% 角色榜
-define(DB_ROLE_RANK,db_role_rank).
%% role_id 角色将领ID
%% role_name 角色名
%% role_level 角色等级
-record(r_role_rank,{role_id=0,role_name="",role_level=0}).
