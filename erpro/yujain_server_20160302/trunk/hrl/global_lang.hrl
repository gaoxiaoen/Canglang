%% -*- coding: latin-1 -*-
%%%----------------------------------------------------------------------
%%% File    : global_lang.hrl
%%% Description: Language constant
%%%				多国语言支持，只需要修改这个文件就行。
%%%				程序中所有需要直接使用字符串（特别是中文）输出结果的，
%%%				务必得设置成这个文件里的常量。
%%%	
%%% 命名规定 :  1. 必须全部以 _LANG_ 开头
%%%			   2. 紧接着是 模块名
%%%			   3. 接着是操作名
%%%			   4. 最后是成功 OK， 失败 FAIL，跟着的是原因
%%% 这个文件只可以定义通用的文字描述，其它特殊的语言资源请在lang.config配置
%%%----------------------------------------------------------------------


%%% 公共基础
-define(_LANG_GAME_NAME,"游戏名称").

-define(_LANG_SUCCESS,"成功").
-define(_LANG_FAILURE,"失败").
-define(_LANG_EXP,"经验").
-define(_LANG_GOLD,"金币").
-define(_LANG_SILVER,"银两").
-define(_LANG_PRESTIGE,"声望").
-define(_LANG_COIN,"铜钱").
-define(_LANG_RES_WOOD,"木材").
-define(_LANG_RES_STONE,"石料").
-define(_LANG_RES_IRON,"铁矿").
-define(_LANG_REPUTE,"军功").

-define(_LANG_GAME_MAINTAIN,"游戏维护中，详情请查看官网").
-define(_LANG_SERVER_LOG_INFO,"信息报告").
-define(_LANG_SERVER_LOG_ERROR,"错误报告").


%%% 防沉迷模块
-define(_LANG_FCM_000,"系统错误").
-define(_LANG_FCM_001,"未满十八周岁").
-define(_LANG_FCM_002,"参数不全").
-define(_LANG_FCM_003,"验证失败").
-define(_LANG_FCM_004,"登记防沉迷资料失败，请稍后重试").
-define(_LANG_FCM_005,"提供的身份证号码不合法").
-define(_LANG_FCM_006,"您的累计下线时间不满5小时，为了保证您能正常游戏，请您稍后登陆。还需要等待~p时~p分").

%%% 网关模块
-define(_LANG_GATEWAY_000,"系统错误").
-define(_LANG_GATEWAY_001,"维护中，详情请查看官网").
-define(_LANG_GATEWAY_002,"账号在别处登录").
-define(_LANG_GATEWAY_003,"认证出错").
-define(_LANG_GATEWAY_004,"认证信息过期").
-define(_LANG_GATEWAY_005,"您已进入不健康游戏时间，请您暂离游戏进行适当休息和运动，合理安排您的游戏时间").
-define(_LANG_GATEWAY_006,"您的网络不稳定，已断开服务器连接").
-define(_LANG_GATEWAY_007,"您触犯游戏守则，被管理员踢下线").
-define(_LANG_GATEWAY_008,"您的累计下线时间不满5小时，为了保证您能正常游戏，请您稍后登陆").
-define(_LANG_GATEWAY_009,"仓库数据异常，请联系GM！").
-define(_LANG_GATEWAY_010,"重复登陆时等待上一个玩家下线超时").
-define(_LANG_GATEWAY_011,"重复登录时出错").
-define(_LANG_GATEWAY_012,"2分钟无心跳").
-define(_LANG_GATEWAY_013,"账号被封禁，请联系GM").
-define(_LANG_GATEWAY_014,"IP被封禁，请联系GM").
-define(_LANG_GATEWAY_015,"设备被封禁，请联系GM").
-define(_LANG_GATEWAY_016,"该功能维护中，详情请见官方公告").

%%% 玩家TCP连接模块
-define(_LANG_TCP_CLIENT_000,"获取玩家IP失败").
-define(_LANG_TCP_CLIENT_001,"收到意外消息，玩家socket进程强制终止").
-define(_LANG_TCP_CLIENT_002,"接收工作开始消息超时，强制结束进程").
-define(_LANG_TCP_CLIENT_003,"角色网关进程退出").
-define(_LANG_TCP_CLIENT_004,"网关收到不能处理消息").
-define(_LANG_TCP_CLIENT_005,"请求平台验证防沉迷出错").
-define(_LANG_TCP_CLIENT_006,"退出原因").
-define(_LANG_TCP_CLIENT_007,"停止玩家逻辑进程出错").
-define(_LANG_TCP_CLIENT_008,"网关账号退出原因异常").
-define(_LANG_TCP_CLIENT_009,"退出时尚未发出auth_key请求").
-define(_LANG_TCP_CLIENT_010,"退出时尚未发出enter_map请求").
-define(_LANG_TCP_CLIENT_011,"退出时没有创建角色").
-define(_LANG_TCP_CLIENT_012,"退出时已经收到enter_map请求，但是没有分线进程还没确认进入地图，可能是进入地图时出错").
-define(_LANG_TCP_CLIENT_013,"未知的状态收到socket数据").
-define(_LANG_TCP_CLIENT_014,"玩家登录到已经不存的地图").
-define(_LANG_TCP_CLIENT_015,"创建角色出错").
-define(_LANG_TCP_CLIENT_016,"需要创建角色").
-define(_LANG_TCP_CLIENT_017,"登录KEY验证出错").
-define(_LANG_TCP_CLIENT_018,"等待玩家信息写入完成").
-define(_LANG_TCP_CLIENT_019,"初始化玩家进程数据出错").
-define(_LANG_TCP_CLIENT_020,"重复登录时收到意外消息").
-define(_LANG_TCP_CLIENT_021,"T掉已经登录的角色").

%%% 地图模块
-define(_LANG_MAP_000,"玩家下线退出地图处理").
-define(_LANG_MAP_001,"玩家进入地图出错").
-define(_LANG_MAP_002,"跳转地图，目标地图进程 ~w 不存在！！！").
-define(_LANG_MAP_003,"进入地图失败").
-define(_LANG_MAP_004,"进入地图函数无法处理此消息").
-define(_LANG_MAP_005,"退出地图函数无法处理此消息").
-define(_LANG_MAP_006,"更新玩家#p_map_role信息出错").
-define(_LANG_MAP_007,"创建地图").
-define(_LANG_MAP_008,"地图进程出错").


%%% 玩家模块
-define(_LANG_ROLE_000,"玩家下线，处理玩家数据出错").
-define(_LANG_ROLE_001,"角色加经验出错").
-define(_LANG_ROLE_002,"玩家获得经验出错").
-define(_LANG_ROLE_003,"创建用户失败").
-define(_LANG_ROLE_004,"根据选择的阵营查找出生点出错").
-define(_LANG_ROLE_005,"创建角色进程失败了").
-define(_LANG_ROLE_006,"等待 Auth Key消息玩家逻辑进程挂掉").
-define(_LANG_ROLE_007,"等待 Map Enter消息玩家逻辑进程挂掉").
-define(_LANG_ROLE_008,"正常状态下玩家逻辑进程挂掉").


%%% 系统其它模块
-define(_LANG_LOCAL_000,"离线处理充值请求出错").
-define(_LANG_LOCAL_001,"GM发送信件成功，记录日志失败").
-define(_LANG_LOCAL_002,"处理后台充值请求出错").
-define(_LANG_LOCAL_003,"初始化帮派计数表失败").
-define(_LANG_LOCAL_004,"获取的开服日期为").
-define(_LANG_LOCAL_005,"发送消息出错").
-define(_LANG_LOCAL_006,"充值出错").
-define(_LANG_LOCAL_007,"检查充值请求出错").
-define(_LANG_LOCAL_008,"初始化任务信息出错").
-define(_LANG_LOCAL_009,"完成任务，之后自动添加可接任务列表返回").
-define(_LANG_LOCAL_010,"取消任务，之后自动添加可接任务列表返回").
-define(_LANG_LOCAL_011,"获取委托任务出错").
-define(_LANG_LOCAL_012,"委托任务完成奖励处理出错").
-define(_LANG_LOCAL_013,"初始化帮派进程信息出错").
-define(_LANG_LOCAL_014,"帮派进程销毁").
-define(_LANG_LOCAL_015,"初始化帮派成员信息出错").
-define(_LANG_LOCAL_016,"玩家上线同步信息到帮派进程出错").
-define(_LANG_LOCAL_017,"玩家下线同步信息到帮派进程出错").
-define(_LANG_LOCAL_018,"创建帮派出错").
-define(_LANG_LOCAL_019,"处理离线玩家加入帮派出错").
-define(_LANG_LOCAL_020,"处理在线玩家加入帮派出错").
-define(_LANG_LOCAL_021,"处理离线玩家离开帮派出错").
-define(_LANG_LOCAL_022,"处理在线玩家离开帮派出错").
-define(_LANG_LOCAL_023,"管理平台回复玩家消息出错").
-define(_LANG_LOCAL_024,"整理背包物品出错").
-define(_LANG_LOACL_025,"扩展背包格子出错").
-define(_LANG_LOCAL_026,"发送信件失败").
-define(_LANG_LOCAL_027,"提取物品错误").
-define(_LANG_LOCAL_028,"离线处理充值请求出错").
-define(_LANG_LOCAL_029,"处理后台充值请求出错").
-define(_LANG_LOCAL_030,"处理扣费请求出错").
-define(_LANG_LOCAL_031,"此游戏循环广播消息结构出错").
-define(_LANG_LOCAL_032,"游戏循环消息发送出错").
-define(_LANG_LOCAL_033,"初始化宠物ID计数表出错").
-define(_LANG_LOCAL_034,"创建宠物失败").
-define(_LANG_LOCAL_035,"创建怪物失败，查找不到怪物配置").
-define(_LANG_LOCAL_036,"玩家死亡，收到宠物出错").


%%%  合服模块
-define(_LANG_MERGE_000,"主节点：读取配置文件成功，准备启动mnesia").
-define(_LANG_MERGE_001,"主节点mnesia启动成功，准备启动合服子程序，本次参与合服的区包括").
-define(_LANG_MERGE_002,"区服数据处理完毕").
-define(_LANG_MERGE_003,"配置出错，合服程序结束").
-define(_LANG_MERGE_004,"合服完毕，恭喜！").
-define(_LANG_MERGE_005,"严重问题，服务器列表和合服类型配置数据不统计，请检查！").
-define(_LANG_MERGE_006,"宗族重名处理完毕，准备处理账号绑定问题").
-define(_LANG_MERGE_007,"账号处理完毕，准备 合并数据").
-define(_LANG_MERGE_008,"合并数据处理完毕，准备删除所有临时表").
-define(_LANG_MERGE_009,"合服完毕，恭喜！").
-define(_LANG_MERGE_010,"发生系统错误").
-define(_LANG_MERGE_011,"合区子程序").
-define(_LANG_MERGE_012,"正在启动中").
-define(_LANG_MERGE_013,"合区子程序正在准备处理数据").
-define(_LANG_MERGE_014,"读取配置文件成功").
-define(_LANG_MERGE_015,"严重问题，找不到区服的合服配置").
-define(_LANG_MERGE_016,"准备将区服").
-define(_LANG_MERGE_017,"的所有阵营置为").
-define(_LANG_MERGE_018,"准备工作好好，等待下一步指令").
-define(_LANG_MERGE_019,"建立临时数据库表成功").
-define(_LANG_MERGE_020,"拷贝数据成功").
-define(_LANG_MERGE_021,"删除原有数据").
-define(_LANG_MERGE_022,"打印所有服的玩家信息到日志文件中").
-define(_LANG_MERGE_023,"===============服务器[").
-define(_LANG_MERGE_024,"]玩家信息开始===============").
-define(_LANG_MERGE_025,"]玩家信息结束===============").
-define(_LANG_MERGE_026,"打印合服之后总的玩家的信息").
-define(_LANG_MERGE_027,"===============新服务器NEW玩家信息开始===============").
-define(_LANG_MERGE_028,"===============新服务器NEW玩家信息结束===============").
-define(_LANG_MERGE_029,"================数据合并开始================").
-define(_LANG_MERGE_030,"开始处理数据库Id表数据记录").
-define(_LANG_MERGE_031,"开始打印数据库Id表数据").
-define(_LANG_MERGE_032,"开始处理只保留主服数据记录").
-define(_LANG_MERGE_033,"开始合并帐号相关记录").
-define(_LANG_MERGE_034,"开始合并玩家记录").
-define(_LANG_MERGE_035,"开始合并背包记录").
-define(_LANG_MERGE_036,"开始合并玩家信件记录").
-define(_LANG_MERGE_038,"================数据合并结束================").
-define(_LANG_MERGE_039,"===============旧服务器玩家Id数据打印开始===============").
-define(_LANG_MERGE_040,"===============旧服务器玩家Id数据打印开始===============").
-define(_LANG_MERGE_041,"===============新服务器玩家Id数据打印开始===============").
-define(_LANG_MERGE_042,"===============新服务器玩家Id数据打印结束===============").
-define(_LANG_MERGE_043,"===============旧服务器帮派Id数据打印开始===============").
-define(_LANG_MERGE_044,"===============旧服务器帮派Id数据打印开始===============").
-define(_LANG_MERGE_045,"===============新服务器帮派Id数据打印开始===============").
-define(_LANG_MERGE_046,"===============新服务器帮派Id数据打印结束===============").
-define(_LANG_MERGE_047,"还原数据成功").
-define(_LANG_MERGE_048,"还原区服数据出错").
-define(_LANG_MERGE_049,"读取区服数据文件出错").
-define(_LANG_MERGE_050,"处理游戏玩家、帮派名称后缀").



