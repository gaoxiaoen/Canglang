%%----------------------------------------------------
%% 军团系统相关数据结构定义
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------

-define(OPEN_TASK, 10560).      %% 开启军团需要完成的任务

-define(guild_piv, 0).                  %% 非VIP军团
-define(guild_vip, 1).                  %% vip军团
-define(guild_skills, [{7,0},{6,0},{5,0},{4,0},{3,0},{2,0},{1,0}]).
-define(guild_dismiss, 0).              %% 军团处于销毁状态
-define(guild_normal, 1).               %% 军团状态正常
-define(guild_impeach_normal, 0).       %% 非弹劾状态
-define(guild_impeach_sys, 1).          %% 系统弹劾状态
-define(guild_impeach_role, 2).         %% 军团成员弹劾状态
-define(guild_treasure_war, 1).         %% 圣战
-define(guild_treasure_arean, 2).       %% 帮战
-define(guild_treasure_guild_boss, 3).  %% 军团boss

%% 军团职位
-define(guild_chief, 20).               %% 团长
-define(guild_elder, 30).               %% 副团长
-define(guild_lord, 40).                %% 
-define(guild_elite, 50).               %% 精英弟子
-define(guild_disciple, 60).            %% 团员
-define(guild_elder_num, 1).            %% 副团长1个
-define(guild_lord_num, 4).             %% 堂主四个
-define(guild_elite_num, 8).            %% 精英弟子8个

%% 权限级别
-define(disciple_op, 0).                %% 弟子级别
-define(lord_op, 1).                    %% 堂主级别
-define(elder_op, 2).                   %% 长老级别
-define(chief_op, 3).                   %% 帮主级别

%% 军团权限操作级别设置
%% 弟子级别
-define(leave_note, ?disciple_op).      %% 帮内留言
-define(in_store, ?disciple_op).        %% 放入仓库

%% 堂主级别
-define(recommend, ?lord_op).           %% 推荐好友
-define(guild_apply_handle, ?lord_op).  %% 处理入帮申请
-define(fire_member, ?lord_op).         %% 开除成员
-define(out_store, ?lord_op).           %% 仓库取出
-define(tidy_store, ?lord_op).          %% 仓库整理

%% 长老级别
-define(alter_bulletin, ?elder_op).     %% 修改公告
-define(delete_note, ?elder_op).        %% 删除留言
-define(delete_item, ?elder_op).        %% 删除物品

%% 帮主级别
-define(appoint_chief, ?chief_op).      %% 转让帮主
-define(update_guild, ?chief_op).       %% 升级军团
-define(update_warehouse, ?chief_op).   %% 升级仓库
-define(update_num, ?chief_op).         %% 升级军团操作
-define(update_weal, ?chief_op).        %% 升级军团福利
-define(alter_permission, ?chief_op).    %% 修改权限值

%% 系统级别操作标识
-define(failed_op, 0).                  %% 失败操作(系统忽略操作)
-define(success_op, 1).                 %% 请求成功处理

%% 创建帮派信息
-define(create_by_token, 0).            %% 使用88晶钻创建帮派,这样创建出来的帮派等级为2级
-define(create_by_coin, 1).             %% 使用铜币创建帮派
-define(create_lev_limit, 20).          %% 军团创建等级限制
-define(create_need_coin, 150000).      %% 建帮所需铜币
-define(create_name_length, 15).        %% 军团名字最长5个汉字
-define(create_bulletin_length, 300).   %% 军团公告长度
-define(note_length, 240).              %% 留言长度80个字
-define(qqsize, 54).                    %% QQ 18个字
-define(yysize, 54).                    

%% 申请入帮
-define(join_lev_limit, 29).            %% 申请入帮最低等级限制
-define(guild_invited_num, 20).         %% 收到军团邀请数上限
-define(max_apply, 5).                  %% 角色申请军团数上限
-define(max_applyed, 200).              %% 军团收到申请数上限

%% 升级类
-define(upgrade_guild, 0).              %% 军团升级
-define(upgrade_weal, 1).               %% 福利升级
-define(upgrade_stove, 2).              %% 神炉升级
-define(upgrade_shop, 3).               %% 商城升级
-define(upgrade_wish, 4).               %% 许愿池升级


%% 等级限制
-define(max_guild_lev, 50).             %% 军团最高等级
-define(limit_weal, 5).                 %% 福利启用军团等级限制
-define(max_weal_lev, 20).              %% 福利最高等级
-define(limit_stove, 5).                %% 神炉启用军团等级限制
-define(max_stove_lev, 20).             %% 神炉最高等级
-define(limit_store, 5).                %% 仓库启用军团等级限制
-define(max_skill_lev, 20).             %% 技能等级限制

%%军团修炼
-define(pool_id, 10).                   %% 仙池ID
-define(chair_c, 11).                   %% 帮主椅子
-define(chair_e1, 12).                  %% 1号长老椅子
-define(chair_e2, 13).                  %% 2号长老椅子
-define(chair_l1, 14).                  %% 1号堂主椅子
-define(chair_l2, 15).                  %% 2号堂主椅子
-define(chair_l3, 16).                  %% 3号堂主椅子
-define(chair_l4, 17).                  %% 4号堂主椅子
-define(pool_able, 13).                 %% 仙泉开启特效
-define(pool_unable, 0).                %% 仙泉未开启
-define(pool_count, 30000).             %% 30秒计算一次

%% 军团地图
-define(guild_vip_map, {10011, 2000, 300}). 
-define(guild_novip_map, {10021, 1800, 500}). 
-define(guild_piv_mapid, 10021).              %% 非VIP地图
-define(guild_vip_mapid, 10011).              %% Vip地图
-define(piv_entrance, {1100, 750}).      %% 地图进入点
-define(vip_entrance, {1550, 580}).     %% 地图进入点
-define(guild_exit_mapid, 300).
-define(guild_exit_x, 1550).
-define(guild_exit_y, 600).            %% 军团领地出口

%% 职业因子
-define(chief_factor, 1.5).
-define(elder_factor, 1.3).
-define(lord_factor, 1.2).
-define(disciple_factor, 1).

%% 军团等级目标类型
-define(guild_aim_lev_5, 0).
-define(guild_aim_lev_10, 1).
-define(guild_aim_lev_15, 2).
-define(guild_aim_lev_20, 3).
-define(guild_aim_lev_25, 4).
-define(guild_aim_lev_30, 5).
-define(guild_aim_lev_35, 6).
-define(guild_aim_lev_40, 7).
-define(guild_aim_lev_45, 8).
-define(guild_aim_lev_50, 9).
-define(guild_aim_levs, [?guild_aim_lev_5, ?guild_aim_lev_10, ?guild_aim_lev_15, ?guild_aim_lev_20, ?guild_aim_lev_25, ?guild_aim_lev_30, ?guild_aim_lev_35, ?guild_aim_lev_40, ?guild_aim_lev_45, ?guild_aim_lev_50]).

%% 军团技能学习目标类型
-define(guild_aim_skill_learn_one, 10).
-define(guild_aim_skill_learn_five, 11).
-define(guild_aim_skill_learn_all, 12).
-define(guild_aim_skill_learns, [?guild_aim_skill_learn_one, ?guild_aim_skill_learn_five, ?guild_aim_skill_learn_all]).

%% 军团技能升级目标类型
-define(guild_aim_skill_lev_5_one, 20).
-define(guild_aim_skill_lev_10_one, 21).
-define(guild_aim_skill_lev_10_five, 22).
-define(guild_aim_skill_lev_10_all, 23).
-define(guild_aim_skill_levs, [?guild_aim_skill_lev_5_one, ?guild_aim_skill_lev_10_one, ?guild_aim_skill_lev_10_five, ?guild_aim_skill_lev_10_all]).

%% 军团福利目标类型
-define(guild_aim_weal_5, 30).
-define(guild_aim_weal_10, 31).
-define(guild_aim_weals, [?guild_aim_weal_5, ?guild_aim_weal_10]).

%% 军团神炉目标类型
-define(guild_aim_stove_5, 40).
-define(guild_aim_stove_10, 41).
-define(guild_aim_stoves, [?guild_aim_stove_5, ?guild_aim_stove_10]).

%% 军团招募目标类型
-define(guild_aim_members_20, 50).
-define(guild_aim_members_30, 51).
-define(guild_aim_members_40, 52).
-define(guild_aim_members_50, 53).
-define(guild_aim_members, [?guild_aim_members_20, ?guild_aim_members_30, ?guild_aim_members_40, ?guild_aim_members_50]).
-define(guild_aims, [0,1,2,3,4,5,6,7,8,9,10,11,12,20,21,22,23,30,31,40,41,50,51,52,53]).

%% 通知类型
-define(notice_type_apply, 1).
-define(notice_type_claim, 2).
-define(notice_type_skill, 3).

%% 竞拍状态
-define(JINGPAI_IDLE, 0).       %% 还没开始竞拍
-define(JINGPAI_ING, 1).        %% 正在进行竞拍
-define(JINGPAI_DONE, 2).       %% 已完成竞拍

-define(wish_cost, 50).         %% 许愿一次消耗的团贡

%% 军团目标
-record(guild_aims, {
        lev = ?guild_aim_levs 
        ,weal = ?guild_aim_weals 
        ,stove = ?guild_aim_stoves 
        ,members = ?guild_aim_members
        ,skill_lev = ?guild_aim_skill_levs 
        ,skill_learn = ?guild_aim_skill_learns 
        ,lev_claim = ?guild_aim_levs 
        ,weal_claim = ?guild_aim_weals 
        ,stove_claim = ?guild_aim_stoves 
        ,members_claim = ?guild_aim_members
        ,skill_lev_claim = ?guild_aim_skill_levs 
        ,skill_learn_claim = ?guild_aim_skill_learns 
    }
).

%% 军团目标奖励数据结构
-record(guild_aim_data, {
        type =  0                           %% 目标类型
        ,column = 0                         %% 目标栏目分类（供客户端分类显示）
        ,name = <<>>                        %% 目标名称
        ,fund = 0                           %% 目标奖励资金
        ,items = []                         %% 目标奖励物品
        ,subject = <<>>                     %% 邮件主题
        ,text = <<>>                        %% 邮件内容
    }
).

%% 军团成员列表
-record(guild_member, {
        pid = 0                         %% 角色进程Pid
        ,id = {0, <<>>}                 %% 角色ID
        ,rid = 0                        %% 角色ID
        ,srv_id = <<>>                  %% 服务器标识
        ,name = <<>>                    %% 角色名称
        ,lev = 0                        %% 角色等级
        ,career = 0                     %% 角色职业
        ,sex = 0                        %% 角色性别
        ,position = 0                   %% 角色职位
        ,gravatar = 0                   %% 角色头像
        ,vip = 0                        %% Vip类型
        ,fight = 0                      %% 战斗力
        ,authority = 0                  %% 军团权限
        ,donation = 0                   %% 角色军团累积贡献
        ,coin = 0                       %% 角色军团贡献铜币数
        ,gold = 0                       %% 角色军团贡献晶钻数
        ,date = 0                       %% 角色登陆时间
        ,pet_fight = 0                  %% 宠物战斗力
    }
).

%% 申请入军团列表
-record(apply_list, {
        id = {0, <<>>}              %% 申请人ID/服务器标识  用于处理后删除申请
        ,rid = 0                    %% 申请人ID
        ,srv_id = <<>>              %% 军团服务器标识
        ,name = <<>>                %% 申请人名称
        ,vip = 0                    %% 申请人Vip类型
        ,gravatar = 0               %% 玩家头像
        ,lev = <<>>                 %% 申请人等级
        ,career = 0                 %% 申请人职业
        ,sex = 0                    %% 申请人性别
        ,fight  = 0                 %% 申请人战斗力
    }
).

%% 弹劾帮主
-record(impeach, {
        ref = 0                     %% 用于取消弹劾
        ,status = 0                 %% 弹劾状态(0:正常, 1:被系统弹劾，2:被玩家弹劾)
        ,time = 0                   %% 弹劾发起时间
        ,id = 0                     %% 发起弹劾者ID
        ,srv_id = <<>>              %% 发起弹劾者服务器标志
        ,name = <<>>                %% 发起弹劾者名字
    }
).

%% 军团任务(军团目标)中的一个任务内容
-record(target, {
        id = 0              %% 任务ID
        ,cur_val = 0        %% 当前进度值
    }
).

%% 成员更新任务数据
-record(mem_task_update_data, {
        id = 0
        ,update_val     %% 要更新的进度
    }
).

%% 军团目标-包括了这次目标所有的任务信息
-record(target_info, {
        is_finish = 0           %% 是否所有目标已经完成 0-未,1-完成
        ,target_lst = []        %% 此次目标的所有任务 格式为 [#target{} | ]
    }
).

%% 加入军团限制，军团长启用限制，符合条件的玩家，申请将直接加入军团
-record(join_limit, {
        lev = 0
        ,zdl = 0
    }
).

%%　兑拍人信息
-record(jingpai_role, {
        role_id
        ,money          %% 出价
        ,money_time     %% 出价时间
        ,role_pid       %% pid
    }).

%% 竞拍
-record(jingpai_item, {
        id = 0                          %% 物品唯一ID
        ,item                           %% {base_id, bind, num}
        ,birthday   = 0                 %% 物品进入仓库时间
        ,status     = 0                 %% 竞拍状态 0-空闲(可以发起兑拍), 1-正在竞拍 2-竞拍完成，待处理（玩家拍下了，但掉线了）
        ,timer_ref                      %% 物品过期定时器引用
        ,jingpai_role                   %% 最后出价人信息 #jingpai_role{}
    }).

-record(jingpai, {
        next_id = 0
        ,items = []      %% 兑拍物品  [ #jingpai_item{}, #jingpai_item{}, ... ]
    }).

%% 军团属性
-record(guild, {
        pid = 0                     %% 军团pid
        ,id = {0, <<>>}             %% 军团ID 格式:{Gid, SrvId}
        ,gid = 0                    %% 军团id
        ,srv_id = <<>>              %% 服务器标识
        ,ver = 0                    %% 军团数据版本
        ,gvip = 0                   %% 军团vip类型
        ,name = <<>>                %% 军团名称
        ,lev = 1                    %% 军团等级
        ,chief = <<>>               %% 帮主名称
        ,rvip = 0                   %% 帮主Vip类型
        ,members = []               %% 军团成员
        ,treasure = {{1, [], []}, {1, [], []}, {1, [], []}}%% 军团宝库 {圣战宝库，帮战宝库, 神兽宝库}
        ,num = 0                    %% 军团成员数
        ,maxnum = 0                 %% 军团最高成员数
        ,bulletin = {<<>>,<<>>,<<>>}%% 军团公告 {Msg, QQ, YY}
        ,weal = 0                   %% 军团福利等级
        ,store                      %% 仓库 #store{}
        ,store_log =[]              %% 仓库操作记录
        ,stove = 0                  %% 神炉等级
        ,fund = 0                   %% 军团资金
        ,day_fund = 0               %% 每日所需维护资金
        ,apply_list = []            %% 申请加入本帮的申请列表 #apply_list{}
        ,treasure_log = []          %% 宝库分配日志 已经移至 treasure
        ,note_list = []             %% 军团留言板列表 
        ,donation_log = []          %% 贡献日志 {名字, 财富，贡献，时间}
        ,aims = #guild_aims{}       %% 军团目标 
        ,skills = []                %% 军团技能列表
        ,chairs = []                %% 上座列表
        ,permission = {0, 0, 0}     %% 权限数值限制操作 [技能，神炉，仓库]
        ,map = 0                    %% 地图进程pid
        ,entrance = {0, 0, 0}       %% 军团进入点
        ,rtime = []                 %% 军团等级变动记录 [{lev, time()}]
        ,contact_image = []         %% 军团通讯录映射关系，如果有记录表示有名片: [#member_book{} | ...]
        ,status = 1                 %% 军团状态(0: 销毁 1: 正常)
        ,impeach = #impeach{}       %% {弹劾事件的引用，弹劾发起时间, 弹劾者}   %% 时间为 0 非弹劾状态
        ,realm = 0                  %% 阵营
        ,shop = 0                   %% 商城等级
        ,exp = 0                    %% 军团经验
        ,wish_item_log = []         %% 许愿获得大奖列表 {name, itemid, time}
        ,wish_pool_lvl = 0          %% 许愿池等级
        ,target_info = #target_info{}     %% 军团目标
        ,join_limit = #join_limit{} %% 加入限制
        ,jingpai = #jingpai{}       %% 军团副本竞拍
    }
).

%% 成员名片交换关系
-record(member_contact, {
        role_id = 0     %% 成员ID
        ,show = 1       %% 是否显示名片0:不显示 1:显示
        ,list = []      %% [Aid, Bid, Cid]
    }).

-record(wish, {
        lvl = 0                 %% 许愿池等级
        ,times = 0              %% 可以许愿次数
        ,last_time = 0          %% 上次许愿时间
        ,type = 0               %% 抽到的物品类型
        ,item = 0               %% 物品具体值，根据type定义具体意义
        ,num = 0                %% 物品数量
    }
).

-record(day_donation, {
        timestamp = 0                       %% 时间点
        ,donation = 0                       %% 今日贡献
    }
).

-record(shop, {
        lvl = 0             %% 商城等级
        ,times = 0          %% 可以购买次数
        ,last_time = 0      %%上次购买时间
    }
).


%% 个人军团属性
-record(role_guild, {
        pid = 0                             %% 军团PID
        ,gid = 0                            %% 军团id
        ,srv_id = <<>>                      %% 军团服务器标识
        ,name = <<>>                        %% 军团名称
        ,position = 0                       %% 军团职位
        ,authority = 0                      %% 军团权限级别
        ,devote = 0                         %% 军团贡献
        ,donation = 0                       %% 军团累积贡献
        ,salary = 0                         %% 俸禄 (已没用)
        ,claim_exp = 0                      %% 是否领取了每日奖励(0:没有，1:有)
        ,claim_tea = 0                      %% 是否领取了香茶(0:没有，1:有)
        ,skilled = []                       %% 领用过的军团技能 {技能ID，领用时间}
        ,quit_date = 0                      %% 上次退帮时间，用于24小时的限制
        ,join_date = 0                      %% 角色入帮时间
        ,read = 0                           %% 藏经阁已阅读次数
        ,welcome_times = 0                  %% 被欢迎次数
        ,welcome_list = []                  %% 欢迎新成员列表 [{{Rid, SrvId}, Name}, ...]
        ,send_welcome_times = 0             %% 发送欢迎次数
        ,wish = #wish{}                     %% 许愿 #wish{}
        ,day_donation = #day_donation{}     %% 今日贡献
        ,shop = #shop{}                     %% 军团商城数据
    }
).

%% 角色一些特殊的军团属性
-record(special_role_guild, {
        id = {0, <<>>}              %% 角色组合ID
        ,applyed = []               %% 角色申请过的军团 {{gid, srv_id},date}
        ,invited = []               %% 角色收到的军团邀请{{gid, srv_id}, name, inviter, date}
        ,guild = {0, <<>>, 0}       %% 角色离线加入的军团, {帮会ID， 帮会服务器标识，加入时间}
        ,fire = 0                   %% 角色是否被开除
        ,status = 0                 %% 角色是否有军团， 0 没有， 1 有
        ,updates = []               %% 角色军团数据需要更新的项目
    }
).

%% 军团仓库操作事件
-record(store_log, {
        id = 0                      %% 角色ID
        ,name = <<>>                %% 角色名称
        ,item = <<>>                %% 物品名称
        ,type = 0                   %% 操作类型 0 存，1 取
        ,quality = 0                %% 物品品质
        ,num = 0                    %% 物品数量
        ,date = 0                   %% 操作时间
    }
).

%% 军团升级数据记录
-record(guild_lev, {
        lev = 0
        ,cost_fund = 0
        ,day_fund = 0
        ,maxnum = 0
        ,desc = <<>>
    }
).

%% 福利升级数据记录
-record(weal_lev, {
        lev = 0
        ,glev = 0
        ,fund = 0
        ,desc = <<>>
    }
).

%% 神炉升级数据记录
-record(stove_lev, {
        lev = 0
        ,glev = 0
        ,fund = 0
        ,ratio = 0
        ,desc = <<>>
    }
).

%% 技能升级数据
-record(guild_skill, {
        id = {0, 0}
        ,type = 0
        ,lev = 0
        ,name = <<>>
        ,icon = 0
        ,glev = 0
        ,fund = 0
        ,desc = <<>>
        ,buff 
    }
).
        
%% 角色属性转换入帮时需要的信息，%% 非存储数据，实时中间数据
-record(guild_role, {
        rid = 0                 %% 角色ID
        ,srv_id = <<>>          %% 服务器标志
        ,lev = 0                %% 玩家等级
        ,name = <<>>            %% 玩家名字
        ,sex = 0                %% 性别
        ,career = 0             %% 玩家职业
        ,vip = 0                %% 玩家VIP
        ,gravatar = 0           %% 玩家头像
        ,pid = 0                %% 进程PID
        ,conn_pid = 0           %% 连接器
        ,gid = 0                %% 军团ID，用于判定玩家是否有军团
        ,date = 0               %% 角色上一次退帮时间
        ,fight = 0              %% 角色战斗力
        ,realm = 0              %% 阵营
        ,pet_fight = 0          %% 宠物战斗力
        ,donation = 0           %% 搭车宠物战斗力，更新军团贡献问题
    }
).

%% 军团列表数据，按等级，人数排序
-record(guild_pic, {
        id = {0, <<>>}
        ,gid = 0
        ,srv_id = <<>>
        ,name = <<>>
        ,gvip = 0
        ,chief = <<>>
        ,rvip = 0
        ,lev = 0
        ,num = 0
        ,maxnum = 0
        ,realm = 0
    }
).

%% 捐献
-define(ratio_coin_fund, 10).                                  %% 1000 铜币 = 1 军团资金
-define(ratio_gold_fund, 0.01).                                  %% 1000 铜币 = 1 军团资金
-define(ratio_coin_devote, 100).                                %% 1000 铜币 = 1 军团贡献
-define(ratio_gold_devote, 0.1).                                  %% 1000 铜币 = 1 军团资金
-define(coin2fund(Coin), round(Coin/?ratio_coin_fund)).         %% 铜币转换军团资金
-define(gold2fund(Gold), round(Gold/?ratio_gold_fund)).         %% 铜币转换军团资金
-define(coin2devote(Coin), round(Coin/?ratio_coin_devote)).         %% 铜币转换军团贡献
-define(gold2devote(Gold), round(Gold/?ratio_gold_devote)).         %% 铜币转换军团贡献

%% 技能领用消费
-define(skill_cost(Num), Num * 10).                 %% 军团技能消费

