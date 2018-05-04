%%%----------------------------------------------------------------------
%%% File    : reason_code.hrl
%%% Author  : Haiming Li
%%% Created : 2012-03-30
%%% Description: Reason code
%%%             保存接口里面的错误代号
%%% 
%%% 命名规定:
%%% 		1.必须全部以 _RC_ 开头
%%% 		2.紧接着是 3位错误代号
%%% 		3.后面必需加上错误描述
%%%----------------------------------------------------------------------

-define(_RC_SUCC,0).                                 %% 成功

-define(_RC_GAME_000,100).                           %% 游戏维护中，详情请查看官网
-define(_RC_GAME_001,101).                           %% 该功能维护中，详情请见官方公告
-define(_RC_GAME_002,102).                           %% 系统没有此项服务，请使用官方，版本快乐游戏！

-define(_RC_GLOBAL_MONEY_000,1000).                  %% 扣费操作，获取玩家数据出错
-define(_RC_GLOBAL_MONEY_001,1001).                  %% 元宝不足
-define(_RC_GLOBAL_MONEY_002,1002).                  %% 金币不足
-define(_RC_GLOBAL_MONEY_003,1003).                  %% 银币不足
-define(_RC_GLOBAL_MONEY_004,1004).                  %% 扣费操作，扣费类型出错
-define(_RC_GLOBAL_MONEY_005,1005).                  %% 扣费操作出错

-define(EC_PORTAL_ERROR, 88888888).                  %% 入口内部错误
-define(EC_PARAM_ERROR, 80000000).                   %% 参数错误
-define(EC_VERIFY_ERROR, 80000001).                  %% 签名验证失败
-define(EC_PLAYER_ALIAS_EXISTED, 80000002).          %% 玩家别名已被注册
-define(EC_PLAYER_ALIAS_BINDED, 80000003).           %% 玩家已绑定别名
-define(EC_PLAYER_EMPTY, 80000004).                  %% 玩家不存在
-define(EC_PLAYER_ACCOUNT_EXISTED, 80000005).        %% 玩家账号已被注册
-define(EC_INVALID_ACCOUNT_ALIAS, 80000006).         %% 不合法的账号或者别名
-define(EC_WRONG_ACCOUNT_PASSWORD, 80000007).        %% 账号密码错误
-define(EC_PERMISSION_DENY, 80000008).               %% 无此权限
-define(EC_PLATFORM_LOGIN, 80000009).                %% 平台登录态验证失败

%% 验证
-define(_RC_AUTH_QUICK_000, 102000).                 %% 快速登录验证出错
-define(_RC_AUTH_QUICK_001, 102001).                 %% 游戏平台入口未开放
-define(_RC_AUTH_QUICK_002, 102002).                 %% 游戏入口未开放
-define(_RC_AUTH_QUICK_003, 102003).                 %% 帐号已经被封禁
-define(_RC_AUTH_QUICK_004, 102004).                 %% IP被封禁
-define(_RC_AUTH_QUICK_005, 102005).                 %% 设备被封禁
-define(_RC_AUTH_QUICK_006, 102006).                 %% 超过快速登录保护时间
-define(_RC_AUTH_QUICK_007, 102007).                 %% 快速登录KEY不合法
-define(_RC_AUTH_QUICK_008, 102008).                 %% 快速登录KEY为空
-define(_RC_AUTH_QUICK_009, 102009).                 %% 注册新的网关进程失败
-define(_RC_AUTH_QUICK_010, 102010).                 %% 防沉迷处理失败
-define(_RC_AUTH_QUICK_011, 102011).                 %% 旧网关进程关闭失败

%% 聊天
-define(_RC_CHAT_IN_CHANNEL_001,501001).             %% 你处于禁言状态，无法聊天
-define(_RC_CHAT_IN_CHANNEL_002,501002).             %% 你的等级不足，无法聊天
-define(_RC_CHAT_IN_CHANNEL_003,501003).             %% 参数错误，无法发言
-define(_RC_CHAT_IN_CHANNEL_004,501004).             %% 你尚未加入门派频道，无法聊天
-define(_RC_CHAT_IN_CHANNEL_005,501005).             %% 你尚未加入帮派频道，无法聊天
-define(_RC_CHAT_IN_CHANNEL_006,501006).             %% 你说话慢点，人家还没看清呢
-define(_RC_CHAT_IN_CHANNEL_007,501007).             %% 你没有加入此频道，无法愉快的聊天
-define(_RC_CHAT_IN_CHANNEL_008,501008).             %% 活力值不足，无法聊天

-define(_RC_CHAT_GET_GOODS_000,504000).              %% 物品已经过时，无法查看详细信息


%% 创建角色
-define(_RC_ROLE_CREATE_000, 801000).                %% 创建角色出错
-define(_RC_ROLE_CREATE_001, 801001).                %% 账号服务器异常，请联系GM
-define(_RC_ROLE_CREATE_002, 801002).                %% 服务器火爆，创建角色超时，请拼命重试
-define(_RC_ROLE_CREATE_003, 801003).                %% 创建角色时发生系统错误，请联系客服
-define(_RC_ROLE_CREATE_004, 801004).                %% 角色名称不合法
-define(_RC_ROLE_CREATE_005, 801005).                %% 角色性别不合法
-define(_RC_ROLE_CREATE_006, 801006).                %% 国家不合法
-define(_RC_ROLE_CREATE_007, 801007).                %% 角色职业不合法
-define(_RC_ROLE_CREATE_008, 801008).                %% 角色头像出错
-define(_RC_ROLE_CREATE_009, 801009).                %% 登录游戏服务器出错
-define(_RC_ROLE_CREATE_010, 801010).                %% 玩家帐号来源和帐号类型组合不合法
-define(_RC_ROLE_CREATE_011, 801011).                %% 创建角色出错，游客模式的进入游戏功能维护中
-define(_RC_ROLE_CREATE_012, 801012).                %% 创建角色出错，角色出生点位置出错
-define(_RC_ROLE_CREATE_013, 801013).                %% 创建角色出错，角色名已存在
-define(_RC_ROLE_CREATE_014, 801014).                %% 创建角色出错，系统角色id出现异常，请马上联系GM，感谢您的支持
-define(_RC_ROLE_CREATE_015, 801015).                %% 创建角色出错，此帐号对应的服务器已经有角色了
-define(_RC_ROLE_CREATE_016, 801016).                %% 此游戏服已经关闭创建角色功能，详情请查看官网

-define(_RC_ROLE_RELIVE_000,810000).                 %% 复活参数出错
-define(_RC_ROLE_RELIVE_001,810001).                 %% 复活失败
-define(_RC_ROLE_RELIVE_002,810002).                 %% 未死亡不可复活

-define(_RC_ROLE_CURE_000,811000).                   %% 无法治疗
-define(_RC_ROLE_CURE_001,811001).                   %% 死亡状态下无法治疗
-define(_RC_ROLE_CURE_002,811002).                   %% 当前场景无法使用治疗

%% 战斗
-define(_RC_FIGHT_ATTACK_000, 1401000).              %% 释放技能出错
-define(_RC_FIGHT_ATTACK_001, 1401001).              %% 技能CD错误
-define(_RC_FIGHT_ATTACK_002, 1401002).              %% 目标不存在
-define(_RC_FIGHT_ATTACK_003, 1401003).              %% 攻击距离不够
-define(_RC_FIGHT_ATTACK_004, 1401004).              %% 技能数据不存在
-define(_RC_FIGHT_ATTACK_005, 1401005).              %% 攻击者信息不存在
-define(_RC_FIGHT_ATTACK_006, 1401006).              %% 技能不存在
-define(_RC_FIGHT_ATTACK_007, 1401007).              %% 魔法不足
-define(_RC_FIGHT_ATTACK_008, 1401008).              %% 技能公共CD错误
-define(_RC_FIGHT_ATTACK_009, 1401009).              %% 释放技能参数错误
-define(_RC_FIGHT_ATTACK_010, 1401010).              %% 当前状态，无法使用技能
-define(_RC_FIGHT_ATTACK_011, 1401011).              %% 怒气不足
-define(_RC_FIGHT_ATTACK_012, 1401012).              %% 目标不能被攻击
-define(_RC_FIGHT_ATTACK_013, 1401013).              %% 技能配置出错，请联系策划
-define(_RC_FIGHT_ATTACK_014, 1401014).              %% 此技能只能针对敌方释放
-define(_RC_FIGHT_ATTACK_015, 1401015).              %% 此技能只能针对友方释放
-define(_RC_FIGHT_ATTACK_016, 1401016).              %% 技能攻击目标点不存在

%% 进入地图
-define(_RC_MAP_ENTER_000, 201000).                  %% 进入地图出错
-define(_RC_MAP_ENTER_001, 201001).                  %% 等级不够，不可进入此地图
-define(_RC_MAP_ENTER_002, 201002).                  %% 进入地图出错，当前地图不可以跳转到目标地图
-define(_RC_MAP_ENTER_003, 201003).                  %% 进入地图出错，目标地图不存在
-define(_RC_MAP_ENTER_004, 201004).                  %% 进入地图出错，地图类型不合法
-define(_RC_MAP_ENTER_005, 201005).                  %% 进入地图出错，信息处理失败
-define(_RC_MAP_ENTER_006, 201006).                  %% 进入地图出错，目标地图进程不存

-define(_RC_MAP_CHANGE_MAP_000, 204000).             %% 跳转地图出错
-define(_RC_MAP_CHANGE_MAP_001, 204001).             %% 目标地图不存在
-define(_RC_MAP_CHANGE_MAP_002, 204002).             %% 目标地图出错，无法进入
-define(_RC_MAP_CHANGE_MAP_003, 204003).             %% 等级不足，无法进入
-define(_RC_MAP_CHANGE_MAP_004, 204004).             %% 无法获取出生点，无法进入

-define(_RC_MAP_QUERY_000, 206000).                  %% 查询出错误
-define(_RC_MAP_QUERY_001, 206001).                  %% 查询出错误，参数出错
-define(_RC_MAP_QUERY_002, 206002).                  %% 查询出错误，玩家当前位置不合法

%% 寻路
-define(_RC_MOVE_WALK_PATH_000, 301000).             %% 寻路路径出错
-define(_RC_MOVE_WALK_PATH_001, 301001).             %% 寻路路径出错，参数出错
-define(_RC_MOVE_WALK_PATH_002, 301002).             %% 寻路路径出错，玩家当前位置信息出错
-define(_RC_MOVE_WALK_PATH_003, 301003).             %% 寻路路径出错，宠物当前位置信息出错

%% 玩家配置表
-define(_RC_SYS_CONF_UPDATE_001,407001).             %% 参数错误

%% 物品
-define(_RC_GOODS_QUERY_000,701000).                 %% 参数错误，查询类型出错
-define(_RC_GOODS_QUERY_001,701001).                 %% 查找不到物品信息
-define(_RC_GOODS_QUERY_002,701002).                 %% 查找不到仓库信息
-define(_RC_GOODS_SWAP_000,702000).                  %% 查找不到移动的物品
-define(_RC_GOODS_SWAP_001,702001).                  %% 目标仓库不合法
-define(_RC_GOODS_SWAP_002,702002).                  %% 目标仓库格子不合法
-define(_RC_GOODS_SWAP_003,702003).                  %% 查找不到仓库信息
-define(_RC_GOODS_SWAP_004,702004).                  %% 此仓库不能放入物品
-define(_RC_GOODS_SWAP_005,702005).                  %% 操作异常

-define(_RC_GOODS_DESTROY_000,703000).               %% 销毁物品出错
-define(_RC_GOODS_DESTROY_001,703001).               %% 参数错误，销毁类型出错
-define(_RC_GOODS_DESTROY_002,703002).               %% 销毁物品出错，查找不到此物品

-define(_RC_GOODS_TIDY_000,706000).                  %% 整理仓库物品出错，查找不到仓库信息
-define(_RC_GOODS_TIDY_001,706001).                  %% 整理仓库物品异常

-define(_RC_GOODS_SHOW_000,707000).                  %% 展示物品出错，查找不到物品
-define(_RC_GOODS_SHOW_001,707001).                  %% 展示物品出错

-define(_RC_GOODS_SEND_GOODS_000,700000).            %% 发关物品出错，op_type参数出错
-define(_RC_GOODS_SEND_GOODS_001,700001).            %% 发关物品出错，role_id_list 为空
-define(_RC_GOODS_SEND_GOODS_002,700002).            %% 发关物品出错，e_title 为空
-define(_RC_GOODS_SEND_GOODS_003,700003).            %% 发关物品出错，e_content 为空
-define(_RC_GOODS_SEND_GOODS_004,700004).            %% 发关物品出错，没有此道具

-define(_RC_GOODS_ADD_GRID_000,709000).              %% 扩展仓库格子出错
-define(_RC_GOODS_ADD_GRID_001,709001).              %% 扩展仓库格子出错，参数出错
-define(_RC_GOODS_ADD_GRID_002,709002).              %% 仓库容量已扩展到最大
-define(_RC_GOODS_ADD_GRID_003,709003).              %% 扩展仓库格子出错，策划配置又出错了，请马上联系GM
-define(_RC_GOODS_ADD_GRID_004,709004).              %% 费用不足

%% 信件
-define(_RC_LETTER_P2P_SEND_000,  901000).           %% 今天发送信件数量已经达到50封上限
-define(_RC_LETTER_P2P_SEND_001,  901001).           %% 该玩家不存在
-define(_RC_LETTER_P2P_SEND_002,  901002).           %% 信件内容超过140个字符
-define(_RC_LETTER_P2P_SEND_003,  901003).           %% 信件内容不能为空
-define(_RC_LETTER_P2P_SEND_004,  901004).           %% 发送信件出错
-define(_RC_LETTER_P2P_SEND_005,  901005).           %% 附件错误，找不到物品
-define(_RC_LETTER_P2P_SEND_006,  901006).           %% 铜币不足不能发送附件
-define(_RC_LETTER_P2P_SEND_007,  901007).           %% 绑定物品不能当附件


-define(_RC_LETTER_OPEN_000,  903000).               %% 找不到信件

-define(_RC_LETTER_DELETE_000,  904000).             %% 请选择要删除的信件
-define(_RC_LETTER_DELETE_001,  904001).             %% 系统繁忙，请稍后再试
-define(_RC_LETTER_DELETE_002,  904002).             %% 没有需要删除的信件

-define(_RC_LETTER_ACCEPT_GOODS_000,  905000).       %% 系统繁忙，请稍后再试
-define(_RC_LETTER_ACCEPT_GOODS_001,  905001).       %% 提取附件失败，找不到信件
-define(_RC_LETTER_ACCEPT_GOODS_002,  905002).       %% 提取附件失败，物品不存在
-define(_RC_LETTER_ACCEPT_GOODS_003,  905003).       %% 提取附件失败，物品位置参数错误
-define(_RC_LETTER_ACCEPT_GOODS_004,  905004).       %% 仓库空间不足
-define(_RC_LETTER_ACCEPT_GOODS_005,  905005).       %% 提取附件失败

%% 游戏接口错误码
-define(_RC_ADMIN_API_000,90000000).                 %% 查询角色信息出错，参数出错 op_type
-define(_RC_ADMIN_API_001,90000001).                 %% 查询角色信息出错，参数出错 op_sub_type
-define(_RC_ADMIN_API_002,90000002).                 %% 查询角色信息出错，查找不到此信息
-define(_RC_ADMIN_API_003,90000003).                 %% 此IP没有访问权限
-define(_RC_ADMIN_API_004,90000004).                 %% 接口加密验证失败
-define(_RC_ADMIN_API_005,90000005).                 %% 接口参数出错
-define(_RC_ADMIN_API_006,90000006).                 %% 充值服务出错，暂时不处理充值请求
-define(_RC_ADMIN_API_007,90000007).                 %% 充值出错
-define(_RC_ADMIN_API_008,90000008).                 %% 充值服务失败，此帐号没有角色
-define(_RC_ADMIN_API_009,90000009).                 %% 充值服务失败，此订单号重复
-define(_RC_ADMIN_API_010,90000010).                 %% 接口超时
-define(_RC_ADMIN_API_011,90000011).                 %% 游戏连接出错
-define(_RC_ADMIN_API_012,90000012).                 %% 当前没有角色，需要创建
-define(_RC_ADMIN_API_013,90000013).                 %% 获取随机角色名称，参数出错
-define(_RC_ADMIN_API_014,90000014).                 %% 游戏维护中，详情请查看官网
-define(_RC_ADMIN_API_015,90000015).                 %% 游戏维护中，详情请查看官网
-define(_RC_ADMIN_API_016,90000016).                 %% 没有此角色
-define(_RC_ADMIN_API_017,90000017).                 %% 此游戏服已经关闭创建角色功能，详情请查看官
-define(_RC_ADMIN_API_018,90000018).                 %% 接口参数出错，服Id出错
-define(_RC_ADMIN_API_019,90000019).                 %% 客服回复消息内容超长
-define(_RC_ADMIN_API_020,90000020).                 %% 查找不到要回复的消息
-define(_RC_ADMIN_API_021,90000021).                 %% 当前服务不是DEBUG模式不可以使用GM命
-define(_RC_ADMIN_API_022,90000022).                 %% 执行GM命令出错，没有找到此玩家
-define(_RC_ADMIN_API_023,90000023).                 %% 执行GM命令出错，命令不合法
-define(_RC_ADMIN_API_024,90000024).                 %% 帐号登录状态不合法，请重新登录
-define(_RC_ADMIN_API_025,90000025).                 %% 服务器爆满，请选择其它服务器登录
-define(_RC_ADMIN_API_026,90000026).                 %% 服务器拥挤，请耐心等待


%% 任务错误码
-define(_RC_MISSION_QUERY_000, 1001000).             %% 查询任务信息出错
-define(_RC_MISSION_QUERY_001, 1001001).             %% 查询任务信息失败，参数出错
-define(_RC_MISSION_QUERY_002, 1001002).             %% 查询任务信息失败，获取任务信息出错
-define(_RC_MISSION_QUERY_003, 1001003).             %% 查询任务信息失败，查找不到相应的任务信息

-define(_RC_MISSION_DO_000, 1002000).                %% 做任务出错，查找不到任务信息
-define(_RC_MISSION_DO_001, 1002001).                %% 接受任务出错，玩家信息查找不到
-define(_RC_MISSION_DO_002, 1002002).                %% 等级不足，努力升级吧
-define(_RC_MISSION_DO_003, 1002003).                %% 接受任务出错，玩家任务信息查找不到
-define(_RC_MISSION_DO_004, 1002004).                %% 先把前置任务完成了吧
-define(_RC_MISSION_DO_005, 1002005).                %% 接受任务出错，任务次数上限
-define(_RC_MISSION_DO_006, 1002006).                %% 任务已经接受
-define(_RC_MISSION_DO_007, 1002007).                %% 接受任务失败，任务需要的道具不足
-define(_RC_MISSION_DO_008, 1002008).                %% 做任务出错
-define(_RC_MISSION_DO_009, 1002009).                %% 完成任务失败，任务奖励出错
-define(_RC_MISSION_DO_010, 1002010).                %% 完成任务失败，循环任务奖励出错
-define(_RC_MISSION_DO_011, 1002011).                %% 做任务出错，
-define(_RC_MISSION_DO_012, 1002012).                %% 任务道具出错
-define(_RC_MISSION_DO_013, 1002013).                %% 仓库空间不足
-define(_RC_MISSION_DO_014, 1002014).                %% 正在委托任务，不可再接受任务
-define(_RC_MISSION_DO_015, 1002015).                %% 接受任务出错，玩家前置任务选择项不合法

-define(_RC_MISSION_CANCEL_000, 1003000).            %% 取消任务出错
-define(_RC_MISSION_CANCEL_001, 1003001).            %% 取消任务出错，查找不到任务信息
-define(_RC_MISSION_CANCEL_002, 1003002).            %% 取消任务出错，任务未接受

-define(_RC_MISSION_DO_COMPLETE_001, 1005001).       %% 立即完成任务出错
-define(_RC_MISSION_DO_COMPLETE_002, 1005002).       %% 立即完成任务出错，任务不合法
-define(_RC_MISSION_DO_COMPLETE_003, 1005003).       %% 立即完成任务出错，没有此任务
-define(_RC_MISSION_DO_COMPLETE_004, 1005004).       %% 立即完成任务出错，此任务不能立即完成
-define(_RC_MISSION_DO_COMPLETE_005, 1005005).       %% 立即完成任务出错，仙石不足
-define(_RC_MISSION_DO_COMPLETE_006, 1005006).       %% 立即完成任务出错，仙石不足
-define(_RC_MISSION_DO_COMPLETE_007, 1005007).       %% 立即完成任务出错，礼金不足
-define(_RC_MISSION_DO_COMPLETE_008, 1005008).       %% 立即完成任务出错，此任务未接受
-define(_RC_MISSION_DO_COMPLETE_009, 1005009).       %% 立即完成任务出错，此任务已完成
-define(_RC_MISSION_DO_COMPLETE_010, 1005010).       %% 立即完成任务出错，金币不足

-define(_RC_MISSION_DO_SUBMIT_001, 1006001).         %% 立即完成任务出错
-define(_RC_MISSION_DO_SUBMIT_002, 1006002).         %% 立即完成任务出错，任务不合法
-define(_RC_MISSION_DO_SUBMIT_003, 1006003).         %% 立即完成任务出错，没有此任务
-define(_RC_MISSION_DO_SUBMIT_004, 1006004).         %% 立即完成任务出错，此任务不能立即完成
-define(_RC_MISSION_DO_SUBMIT_005, 1006005).         %% 立即完成任务出错，仙石不足
-define(_RC_MISSION_DO_SUBMIT_006, 1006006).         %% 立即完成任务出错，仙石不足
-define(_RC_MISSION_DO_SUBMIT_007, 1006007).         %% 立即完成任务出错，礼金不足
-define(_RC_MISSION_DO_SUBMIT_008, 1006008).         %% 立即完成任务出错，此任务未接受
-define(_RC_MISSION_DO_SUBMIT_009, 1006009).         %% 立即完成任务出错，此任务已完成
-define(_RC_MISSION_DO_SUBMIT_010, 1006010).         %% 立即完成任务出错，金币不足
-define(_RC_MISSION_DO_SUBMIT_011, 1006011).         %% 立即完成任务出错，完成次数不合法
-define(_RC_MISSION_DO_SUBMIT_012, 1006012).         %% 立即完成任务出错，任务次数不够
-define(_RC_MISSION_DO_SUBMIT_013, 1006013).         %% 立即完成任务出错，一次最多只能完成10次
-define(_RC_MISSION_DO_SUBMIT_014, 1006014).         %% 立即完成任务出错，一次最多只能完成10次
-define(_RC_MISSION_DO_SUBMIT_015, 1006015).         %% 立即完成任务出错，玩家不能接受此任务

-define(_RC_MISSION_RECOLOR_000, 1007000).           %% 刷新任务品质出错
-define(_RC_MISSION_RECOLOR_001, 1007001).           %% 刷新任务品质出错，参数出错
-define(_RC_MISSION_RECOLOR_002, 1007002).           %% 刷新任务品质出错，玩家任务信息出错
-define(_RC_MISSION_RECOLOR_003, 1007003).           %% 刷新任务品质出错，任务信息出错
-define(_RC_MISSION_RECOLOR_004, 1007004).           %% 刷新任务品质出错，品质已经是最高
-define(_RC_MISSION_RECOLOR_005, 1007005).           %% 刷新任务品质出错，未接受的任务才可以刷新品质
-define(_RC_MISSION_RECOLOR_006, 1007006).           %% 刷新任务品质出错，此任务不能刷新品质
-define(_RC_MISSION_RECOLOR_007, 1007007).           %% 刷新任务品质出错，要刷新到的品质出错
-define(_RC_MISSION_RECOLOR_008, 1007008).           %% 刷新任务品质出错，当前不可以使用铜币刷新
-define(_RC_MISSION_RECOLOR_009, 1007009).           %% 刷新任务品质出错，铜币不足
-define(_RC_MISSION_RECOLOR_010, 1007010).           %% 刷新任务品质出错，金币不足
-define(_RC_MISSION_RECOLOR_011, 1007011).           %% 刷新任务品质出错，此任务委托中不可以刷新

-define(_RC_MISSION_AUTO_000, 1008000).              %% 委托任务出错
-define(_RC_MISSION_AUTO_001, 1008001).              %% 委托任务出错，参数出错
-define(_RC_MISSION_AUTO_002, 1008002).              %% 委托任务出错，委托不合法
-define(_RC_MISSION_AUTO_003, 1008003).              %% 委托任务出错，委托等级不足
-define(_RC_MISSION_AUTO_004, 1008004).              %% 委托任务出错，不在委托中
-define(_RC_MISSION_AUTO_005, 1008005).              %% 委托任务出错，委托完成处理中
-define(_RC_MISSION_AUTO_006, 1008006).              %% 委托任务出错，查询不到委托信息
-define(_RC_MISSION_AUTO_007, 1008007).              %% 委托任务出错，金币不足
-define(_RC_MISSION_AUTO_008, 1008008).              %% 委托任务出错，未委托不可以加速
-define(_RC_MISSION_AUTO_009, 1008009).              %% 委托任务出错，已经完成不能加速
-define(_RC_MISSION_AUTO_010, 1008010).              %% 委托任务出错，委托次数超过最大次数
-define(_RC_MISSION_AUTO_011, 1008011).              %% 委托任务出错，VIP等级不足


%% 玩家获得经验
-define(_RC_ROLE_EXP_CHANGE_000,  804000).           %% 获得经验出错
-define(_RC_ROLE_EXP_CHANGE_001,  804001).           %% 获得经验出错，储存经验已满
-define(_RC_ROLE_EXP_CHANGE_002,  804002).           %% 获得经验出错，此状态下不能获得经验
-define(_RC_ROLE_EXP_CHANGE_003,  804003).           %% 获得经验出错，储存经验已满，请升级

%% 客服系统
-define(_RC_CUSTOMER_SERVICE_QUERY_000,1101000).     %% 查询信息出错
-define(_RC_CUSTOMER_SERVICE_QUERY_001,1101001).     %% 查询信息出错，参数出错
-define(_RC_CUSTOMER_SERVICE_QUERY_002,1101002).     %% 查询信息出错，查找不到些信息

-define(_RC_CUSTOMER_SERVICE_DO_000,1102000).        %% 提交内容出错
-define(_RC_CUSTOMER_SERVICE_DO_001,1102001).        %% 提交内容出错，参数出错
-define(_RC_CUSTOMER_SERVICE_DO_002,1102002).        %% 内容不能为空
-define(_RC_CUSTOMER_SERVICE_DO_003,1102003).        %% 内容不得超过140个字符
-define(_RC_CUSTOMER_SERVICE_DO_004,1102004).        %% 提交内容出错，没要查找到消息
-define(_RC_CUSTOMER_SERVICE_DO_005,1102005).        %% 设置可读出错，没有查找到此消息
-define(_RC_CUSTOMER_SERVICE_DO_006,1102006).        %% 信件列表信息过多
-define(_RC_CUSTOMER_SERVICE_DO_007,1102007).        %% 内容不得超过140个字符

-define(_RC_CUSTOMER_SERVICE_DEL_000,1104000).       %% 删除记录出错
-define(_RC_CUSTOMER_SERVICE_DEL_001,1104001).       %% 删除记录出错，参数出错


%% 帮派
-define(_RC_FAMILY_QUERY_000,1201000).               %% 查询帮派列表出错
-define(_RC_FAMILY_QUERY_001,1201001).               %% 查询帮派列表出错，参数出错

-define(_RC_FAMILY_CREATE_000,1202000).              %% 创建帮派出错
-define(_RC_FAMILY_CREATE_001,1202001).              %% 创建帮派出错，参数出错
-define(_RC_FAMILY_CREATE_002,1202002).              %% 金币不足，创建帮派需2金币
-define(_RC_FAMILY_CREATE_003,1202003).              %% 银币不足，创建帮派需20银币
-define(_RC_FAMILY_CREATE_004,1202004).              %% 你已经加入帮派，不能再创建帮派
-define(_RC_FAMILY_CREATE_005,1202005).              %% 请输入帮派名称
-define(_RC_FAMILY_CREATE_006,1202006).              %% 帮派名称错误，请重新输入
-define(_RC_FAMILY_CREATE_007,1202007).              %% 创建帮派需达到25级
-define(_RC_FAMILY_CREATE_008,1202008).              %% 每天只能创建一次帮派
-define(_RC_FAMILY_CREATE_009,1202009).              %% 帮派名称已经存在
-define(_RC_FAMILY_CREATE_010,1202010).              %% 创建帮派出错，帮派Id出错，请联系GM

-define(_RC_FAMILY_REQUEST_000,1203000).             %% 申请加入帮派出错
-define(_RC_FAMILY_REQUEST_001,1203001).             %% 你已拥有帮派，不能加入其他帮派
-define(_RC_FAMILY_REQUEST_002,1203002).             %% 加入帮派需达到25级
-define(_RC_FAMILY_REQUEST_003,1203003).             %% 申请失败，帮派不存在
-define(_RC_FAMILY_REQUEST_004,1203004).             %% 已成功申请，等待帮派长批注
-define(_RC_FAMILY_REQUEST_005,1203005).             %% 申请加入帮派出错，帮派不合法

-define(_RC_FAMILY_INVITE_000,1204000).              %% 邀请加入帮派出错
-define(_RC_FAMILY_INVITE_001,1204001).              %% 邀请加入帮派出错，参数出错
-define(_RC_FAMILY_INVITE_002,1204002).              %% 没有加入帮派不能邀请
-define(_RC_FAMILY_INVITE_003,1204003).              %% 邀请失败，对方不在线
-define(_RC_FAMILY_INVITE_004,1204004).              %% 对方已拥有帮派
-define(_RC_FAMILY_INVITE_005,1204005).              %% 不同国家不能邀请
-define(_RC_FAMILY_INVITE_006,1204006).              %% 邀请成功，等待对方确定
-define(_RC_FAMILY_INVITE_007,1204007).              %% 不能重复加入帮派
-define(_RC_FAMILY_INVITE_008,1204008).              %% 对方等级不足30级
-define(_RC_FAMILY_INVITE_009,1204009).              %% 30级才能加入帮派
-define(_RC_FAMILY_INVITE_010,1204010).              %% 该帮派已经解散
-define(_RC_FAMILY_INVITE_011,1204011).              %% 同意邀请加入帮派出错
-define(_RC_FAMILY_INVITE_012,1204012).              %% 同意邀请加入帮派出错，帮派不合法
-define(_RC_FAMILY_INVITE_013,1204013).              %% 同意邀请加入帮派出错，你已经申请过加入此帮派

-define(_RC_FAMILY_ACCEPT_000,1205000).              %% 通过加入帮派出错
-define(_RC_FAMILY_ACCEPT_001,1205001).              %% 通过加入帮派出错，参数出错
-define(_RC_FAMILY_ACCEPT_002,1205002).              %% 只有帮派长才能同意
-define(_RC_FAMILY_ACCEPT_003,1205003).              %% 此玩家不在申请列表中
-define(_RC_FAMILY_ACCEPT_004,1205004).              %% 申请列表没有玩家
-define(_RC_FAMILY_ACCEPT_005,1205005).              %% 对方今天已加入一次帮派，再次加入需等明天

-define(_RC_FAMILY_REFUSE_000,1206000).              %% 拒绝加入帮派出错
-define(_RC_FAMILY_REFUSE_001,1206001).              %% 拒绝加入帮派出错，参数出错
-define(_RC_FAMILY_REFUSE_002,1206002).              %% 只有帮派长才能拒绝
-define(_RC_FAMILY_REFUSE_003,1206003).              %% 此玩家不在申请列表中
-define(_RC_FAMILY_REFUSE_004,1206004).              %% 申请列表没有玩家

-define(_RC_FAMILY_DISBAND_000,1207000).             %% 解散帮派出错
-define(_RC_FAMILY_DISBAND_001,1207001).             %% 解散帮派失败，你不在帮派中
-define(_RC_FAMILY_DISBAND_002,1207002).             %% 你没有权限解散帮派
-define(_RC_FAMILY_DISBAND_003,1207003).             %% 清空成员才能解散帮派

-define(_RC_FAMILY_FIRE_000,1208000).                %% 开除成员出错
-define(_RC_FAMILY_FIRE_001,1208001).                %% 开除成员失败，你不在帮派中
-define(_RC_FAMILY_FIRE_002,1208002).                %% 只有帮派战才能开除成员
-define(_RC_FAMILY_FIRE_003,1208003).                %% 不能开除自己
-define(_RC_FAMILY_FIRE_004,1208004).                %% 成员已经不在帮派中

-define(_RC_FAMILY_LEAVE_000,1208000).               %% 成员离开出错
-define(_RC_FAMILY_LEAVE_001,1208001).               %% 你已不在帮派中，请重登游戏

-define(_RC_FAMILY_SET_000,1211000).                 %% 设置帮派信息出错
-define(_RC_FAMILY_SET_001,1211001).                 %% 你已不在帮派中
-define(_RC_FAMILY_SET_002,1211002).                 %% 没有权限设置帮派信息
-define(_RC_FAMILY_SET_003,1211003).                 %% 设置帮派信息出错，参数出错
-define(_RC_FAMILY_SET_004,1211004).                 %% 设置帮派信息出错，查不到此帮派
-define(_RC_FAMILY_SET_005,1211005).                 %% 公告不得超过50个字符


-define(_RC_FAMILY_TURN_000,1212000).                %% 转让团长出错
-define(_RC_FAMILY_TURN_001,1212001).                %% 转让团长失败，你不在帮派中
-define(_RC_FAMILY_TURN_002,1212002).                %% 你没有帮派长职位
-define(_RC_FAMILY_TURN_003,1212003).                %% 不能转让给本人
-define(_RC_FAMILY_TURN_004,1212004).                %% 转让团长出错，转让的成员不合法


-define(_RC_FAMILY_GET_000,1218000).                 %% 查询帮派信息出错
-define(_RC_FAMILY_GET_001,1218001).                 %% 查询帮派信息出错，参数出错
-define(_RC_FAMILY_GET_002,1218002).                 %% 你已不在帮派中

-define(_RC_ROLE_GET_INFO_000, 806000).              %% 查询玩家信息出错
-define(_RC_ROLE_GET_INFO_001, 806001).              %% 查询玩家信息出错，查找不到此玩家

-define(_RC_ROLE_SET_000, 807000).                   %% 设置玩家信息出错
-define(_RC_ROLE_SET_001, 807001).                   %% 设置玩家信息出错，参数不合法
-define(_RC_ROLE_SET_002, 807002).                   %% 设置玩家信息出错，不支持修改此参数
-define(_RC_ROLE_SET_003, 807003).                   %% 设置玩家信息出错，修改的值不合法
-define(_RC_ROLE_SET_004, 807004).                   %% 不可以重复选择国家


%% 宠物系统
-define(_RC_PET_000,1500000).                        %% 没有些类型的宠物，无法获得宠物
-define(_RC_PET_CREATE_001,1500001).                 %% 创建宠物出错，宠物Id出错，请联系GM
-define(_RC_PET_CREATE_002,1500002).                 %% 宠物背包已经满，创建宠物失败
-define(_RC_PET_CREATE_003,1500003).                 %% 宠物背包数据出错

-define(_RC_PET_QUERY_000,1501000).                  %% 查询类型参数出错
-define(_RC_PET_QUERY_001,1501001).                  %% 无法获取玩家宠物背包信息
-define(_RC_PET_QUERY_002,1501002).                  %% 无法获取玩家宠物仓库信息
-define(_RC_PET_QUERY_003,1501003).                  %% 无法获取宠物信息

-define(_RC_PET_BATTLE_000,1502000).                 %% 宠物出战失败
-define(_RC_PET_BATTLE_001,1502001).                 %% 宠物出战出错，参数出错
-define(_RC_PET_BATTLE_002,1502002).                 %% 此宠物已经出战，请重新选择要出战的宠物
-define(_RC_PET_BATTLE_003,1502003).                 %% 背包没有此宠物，无法出战
-define(_RC_PET_BATTLE_004,1502004).                 %% 出战CD未到，无法出战
-define(_RC_PET_BATTLE_005,1502005).                 %% 请回收当前出战宠物，再操作
-define(_RC_PET_BATTLE_006,1502006).                 %% 正在处理上一次操作，请稍后在尝试
-define(_RC_PET_BATTLE_007,1502007).                 %% 不能再次出战此宠物

-define(_RC_PET_BACK_000,1503000).                   %% 当前没有找到出战宠物，收回宠物失败

-define(_RC_PET_FREE_000,1504000).                   %% 参数出错
-define(_RC_PET_FREE_001,1504001).                   %% 查找不到此宠物，无法放生
-define(_RC_PET_FREE_002,1504002).                   %% 出战宠物不能放生


%% 副本系统
-define(_RC_FB_000,1600000).                         %% 副本出错

-define(_RC_FB_ENTER_000,1601000).                   %% 进入副本出错,无法进入
-define(_RC_FB_ENTER_001,1601001).                   %% 没有此副本，无法进入
-define(_RC_FB_ENTER_002,1601002).                   %% 副本ID出错，无法进入
-define(_RC_FB_ENTER_003,1601003).                   %% 副本次数已满，请副本重新开始时再进入
-define(_RC_FB_ENTER_004,1601004).                   %% 正在处理上一次操作，请稍后在尝试
-define(_RC_FB_ENTER_005,1601005).                   %% 等级不足，无法进入
-define(_RC_FB_ENTER_006,1601006).                   %% 创建副本地图失败，无法进入
-define(_RC_FB_ENTER_007,1601007).                   %% 没有此地图，无法进入
-define(_RC_FB_ENTER_008,1601008).                   %% 地图没有配置出生点，无法进入
-define(_RC_FB_ENTER_009,1601009).                   %% 在副本地图，无法进入副本

-define(_RC_FB_QUIT_000,1602000).                    %% 退出副本出错
-define(_RC_FB_QUIT_001,1602001).                    %% 没有些副本，无法退出
-define(_RC_FB_QUIT_002,1602002).                    %% 不在此副本内，无法退出

-define(_RC_FB_QUERY_000,1603000).                   %% 查询副本信息出错

-define(_RC_FB_MONSTER_000,1605000).                 %% 当前地图无法查询怪物位置信息

%% 队伍系统
-define(_RC_TEAM_000,1800000).                       %% 队伍出错

-define(_RC_TEAM_CREATE_000,1801000).                %% 创建队伍出错
-define(_RC_TEAM_CREATE_001,1801001).                %% 已经存在队伍，无法创建新队伍
-define(_RC_TEAM_CREATE_002,1801002).                %% 创建队伍出错
-define(_RC_TEAM_CREATE_003,1801003).                %% 创建队伍出错