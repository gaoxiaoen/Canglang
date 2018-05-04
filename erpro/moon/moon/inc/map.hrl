%%----------------------------------------------------
%% 地图相关数据结构定义
%% @author yeahoo2000@gmail.com
%% 
%% * 地图与地图之间通过连接点相连，由地图编辑器中设置
%% * 连接点信息:{目标地图ID, X坐标, Y坐标, [条件列表]}
%% * 连接点可以被副本管理器等控制
%% * 角色进入地图有两种方式:1:访问连接点, 2:使用传送道具
%%----------------------------------------------------
-define(SLICE_WIDTH, 600). %% 60pixel

-define(SLICE(X), util:floor(X / ?SLICE_WIDTH)).  %% 将X坐标转换成slice

-define(gate_open, 1).  %% 大门打开状态
-define(gate_close, 0). %% 大门关闭状态

-define(box_open, 1).   %% 宝箱打开状态
-define(box_close, 0).  %% 宝箱关闭状态

-define(elem_obj,   10). %% 显示对象
-define(elem_tele,  1). %% 传送点
-define(elem_box,   2). %% 宝箱
-define(elem_gate,  3). %% 门
-define(elem_mine,  4). %% 独占采集元素
-define(elem_dun,   5). %% 副本入口
-define(elem_task_mine, 6). %% 非独占采集元素
-define(elem_cast, 7).  %% 广播效果的元素
-define(elem_sit, 8).   %% 宝座
-define(elem_no_cast, 9). %% 非广播效果的元素
-define(elem_onetime, 11).   %% 一次性采集
-define(elem_guild_war, 13).    %% 帮战元素
-define(elem_wanted, 14).   %% 通缉榜
-define(elem_wedding, 16). %% 婚庆元素
-define(elem_multi_status, 18).     %% 多状态采集元素
-define(elem_guild_arena, 19).    %% 帮战元素
-define(elem_qixi_box, 22).     %% 七夕宝盒
-define(elem_cross_ore, 23).    %% 跨服仙府矿资源
-define(elem_guard_counter, 24).    %% 洛水反击
-define(elem_dun_liang, 27).    %% 阆风阁副本元素

%%已废弃
-define(map_type_safe, 0).      %% 地图类型：安全区域（不能杀戮和劫镖等）
-define(map_type_unsafe, 1).    %% 地图类型：非安全区域

-define(map_type_dungeon, 0).    %% 地图类型：副本
-define(map_type_town, 1).       %% 地图类型：主城
-define(map_type_expedition, 5).   %% 地图类型：远征王军
-define(map_type_tree, 6).       %% 地图类型：世界树
-define(map_type_super_boss, 7).       %% 地图类型：世界Boss
-define(map_type_wanted, 8).       %% 地图类型：悬赏Boss
-define(map_type_arena_career, 9).  %% 地图类型：(中庭战神)
-define(map_type_hide_dungeon, 11).  %% 地图类型：隐藏副本
-define(map_type_leisure, 12).  %% 地图类型：隐藏副本
-define(map_type_guild_td, 18). %% 军团副本类型

-define(capital_map_id, 1400).      %% 主城地图id
-define(capital_map_id2, 1405).
-define(capital_map_id3, 1410).
-define(capital_map_id4, 1415).
-define(capital_map_id5, 1420).

%% 地图默认入口位置
-define(map_def_x, 535).    
-define(map_def_y, 504).   
-define(map_def_xy, {?map_def_x, ?map_def_y}). 

%% 默认线路
-define(map_def_line, 1).

%% 角色朝向
-define(map_role_dir_right, 6). %% 右

%% 地图在线信息
-record(map, {
        gid             %% 全局唯一标识{Line, MapId}, 副本中Line固定为1
        ,id             %% 地图ID
        ,base_id        %% 地图基础ID
        ,pid            %% 进程ID
        ,owner_pid = 0  %% 地图所有者ID，一般是副本进程ID，0表示是普通地图
        ,name = <<>>    %% 地图名称
        ,event = []     %% 地图事件监听
        ,elem = []      %% 地图元素
        ,condition = [] %% 进入条件
        ,width = 0      %% 宽度
        ,height = 0     %% 高度
        ,role_num = 0   %% 已进入地图的角色数量
        ,type = ?map_type_dungeon          %% 地图类型
    }
).

%% 地图原始数据
-record(map_data, {
        id              %% 地图ID
        ,name = <<>>    %% 地图名称
        ,done = []      %% 地图元素状态记录，比如杀死某个怪物时这里会有记录
        ,event = []     %% 地图事件监听
        ,elem = []      %% 地图元素
        ,npc = []       %% [NpcId | ...] 地图中的默认NPC
        ,condition = [] %% 进入地图的默认条件
        ,revive = []    %% [{X, Y} | ...] 复活点位置
        ,width = 0      %% 地图宽度
        ,height = 0     %% 地图长度
        ,type = ?map_type_dungeon          %% 地图类型
    }
).

%% 地图元素数据结构
-record(map_elem, {
        id = 0          %% 编号
        ,base_id = 0    %% BaseId
        ,type = 1       %% 元素类型
        ,name = <<>>    %% 元素名称
        ,status = 0     %% 当前状态
        ,trigger_status = 0 %% 触发后的状态
        ,disabled = <<>> %% 是否禁止操作(空表示无限制，非空为禁止原因)
        ,trigger_msg = <<>> %% 操作成功的提示
        ,rid = 0        %% 所属者角色ID(0表示无归属)
        ,srv_id = <<>>  %% 所属者服务器ID
        ,x = 0          %% 在地图中的X坐标
        ,y = 0          %% 在地图中的X坐标
        ,slice = 0      %% 所在区域
        ,condition = [] %% 地图元素的操作条件
        ,data = []      %% 地图元素附加属性
                        %% 以下是附加属性说明:
                        %% 显示对象:无意义
                        %% 门:所在地图Pid
                        %% 宝箱:{所在地图Pid, 拾取奖励}
                        %% 传送点:{目标地图Id, 目标X坐标, 目标Y坐标}
                        %% 矿石:跟宝箱相同
    }
).

%% 地图中的角色信息
-record(map_role, {
        pid = 0         %% 角色进程ID(在此用作主键)
        ,rid = 0        %% 角色ID
        ,srv_id = <<>>  %% 角色ID
        ,cross_srv_id = <<>> %% 跨服标识
        ,name = <<>>    %% 角色名称
        ,conn_pid = 0   %% 连接器PID
        ,map = 0        %% 当前所在地图ID
        ,speed = 0      %% 移动速度
        ,x = 0          %% 当前X坐标
        ,y = 0          %% 当前Y坐标
        ,dest_x = 0     %% 前进目标x坐标
        ,dest_y = 0     %% 前进目标y坐标
        ,dir = 0        %% 角色朝向
        ,slice = 0      %% 所在区域

        ,status = 0     %% 角色状态
        ,action = 0     %% 动作状态
        ,ride = 0       %% 骑乘状态
        ,event = 0      %% 活动状态
        ,exchange = 0   %% 交易状态
        ,mod = 0        %% 和平模式
        ,label = 0      %% 特殊标识
        ,hidden = 0     %% 是否隐藏
        ,lev = 1        %% 等级
        ,sex = 0        %% 性别
        ,career = 0     %% 职业
        ,realm = 0      %% 阵营 
        ,hp = 1         %% 当前血量
        ,mp = 1         %% 当前魔量
        ,hp_max = 1     %% 当前血量上限
        ,mp_max = 1     %% 当前魔量上限
        ,team_id = 0    %% 队伍ID
        ,guild = <<>>   %% 帮会名称
        ,fight_capacity = 1 %% 战斗力
        ,vip_type = 0        %% VIP 等级
        ,looks = []     %% 外观效果
        ,special = []   %% 特殊信息[{Type, Val1, Val2},...]
    }
).

%% 地图中的NPC信息
-record(map_npc, {
        id = 0          %% NPCID
        ,name = <<>>    %% NPC名称
        ,map = 0        %% 当前所在地图ID
        ,type = 0       %% 类型
        ,status = 0     %% 状态(0:正常状态, 1:战斗中)
        ,base_id = 0    %% 基础ID
        ,nature = 0     %% 性质(0:中立 1:敌对 2:友善)
        ,disabled = <<>> %% 是否禁止击杀(空表示无限制，非空为禁止原因)
        ,lev = 1        %% 等级
        ,speed = 0      %% 移动速度
        ,x = 0          %% 当前X坐标
        ,y = 0          %% 当前Y坐标
        ,slice = 0      %% 所在区域
    }
).

%% 地图事件
-record(map_listener, {
        events = []         %% 事件 [{Label, Param, flag} | ... ]
        ,actions = []       %% 动作
        ,repeat = 0         %% 可以重复执行的次数 0表示不可执行， N表示可重复执行的次数
        ,prob = 100         %% 概率
        ,trigger_count = 0  %% 已触发次数
        ,msg = <<>>         %% 触发事件的提示信息
    }).

%% 地图元素操作引起的事件
-record(map_elem_event, {
        label               %% 事件标识
        ,value              %% 事件值
        }).

%% 地图线路
-record(map_line, {
        base_id
        ,count
        ,lines = [] %% [{Index, pid()}]
        }).
