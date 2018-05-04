%%----------------------------------------------------
%% @doc 社交模块
%%
%% @author yqhuang(QQ:19123767)
%% @end 
%%----------------------------------------------------

-define(sns_friend_type_hy,           0). %% 好友 
-define(sns_friend_type_cr,           1). %% 仇人 
-define(sns_friend_type_hmd,          2). %% 黑名单 
-define(sns_friend_type_msr,          3). %% 陌生人 
-define(sns_friend_type_kuafu,        4).%% 跨服好友

-define(sns_friend_offline,           0). %% 离线
-define(sns_friend_online,            1). %% 在线

-define(sns_op_fail,                  0). %% 操作失败
-define(sns_op_succ,                  1). %% 操作成功

%%

%% 默认分组Id
-define(sns_fr_group_id_hy,           0). %% 我的好友
-define(sns_fr_group_id_cr,           1). %% 仇人
-define(sns_fr_group_id_hmd,          2). %% 黑名单
-define(sns_fr_group_id_msr,          3). %% 陌生人
-define(sns_fr_group_id_kuafu,        4). %% 跨服好友

%% 默认好友数
-define(def_fr_max,     50).
-define(def_msr_max,     10).

-define(sns_buff_list, [sns_buff_lv1, sns_buff_lv2, sns_buff_lv3, sns_buff_lv4, sns_buff_lv5]). %% 亲密度列表 

-define(sns_chat_content, [
        language:get(<<"这游戏还蛮好玩的，以后要多多关照。">>)
        ,language:get(<<"原来这游戏加好友还有好友祝福得经验啊。">>)
        ,language:get(<<"这游戏画面真不错。">>)
        ,language:get(<<"过一会我升级了，你记得祝福我。">>)
        ,language:get(<<"好想快一点升级，刚才听人说副本里面掉很多好东西。">>)
        ,language:get(<<"你在干嘛啊？">>)
        ,language:get(<<"猜猜你是我第几个好友？">>)
    ]
).

%% 好友赠送体力相关宏
-define(invalid_flag, 0).       %% 无效标志
-define(no_give, 1).            %% 还没赠送
-define(has_give, 2).           %% 已赠送
-define(no_recv, 1).            %% 还没收到领取
-define(can_recv, 2).           %% 收到赠送
-define(has_recv, 3).           %% 已经领取
-define(max_recv_cnt, 5).      %% 最大可领取次数
-define(max_give_cnt, 5).       %% 最大赠送次数


%% 好友列表数据 record
-define(sns_ver,       5).  %% #sns{}记录版本号
-record(sns, {
        ver = ?sns_ver          			%% 版本号
        ,role_id   = 0          			%% 角色id 
        ,srv_id    = <<>>       			%% 角色所在服务器
        ,fr_max = ?def_fr_max   			%% 好友最大人数限制
        ,online_late = 0        			%% 最近上线时间
        ,fr_group = []          			%% 好友分组信息
        ,signature = <<>>       			%% 个人签名
        ,wish_times = {0, 0}    			%% 祝福次数{Date::integer(), Times::integer()}
        ,wished_times = 0       			%% 被祝福次数升级清零
        ,receive_gift = 0       			%% 祝福后接收回赠次数
        ,chat_face = []         			%% 动态表情ID列表[integer()]
        ,face_group = []        			%% 表情包id列表[{Id::integer(), Expire::integer()}]
        ,recv_time  =   0       			%% 收取好友赠送体力时间
        ,recv_cnt   =   ?max_recv_cnt      	%% 每天可收取次数 凌晨重置
        ,give_cnt   =   ?max_give_cnt       %% 每天可赠送次数 凌晨重置
    }
).

-record(friend, {
        type       = 255    			%% 类型[0:好友，1:仇人，2:黑名单, 255:陌生人]
        ,role_id   = 0      			%% 角色id 
        ,srv_id    = <<>>   			%% 角色所在服务
        ,pid                			%% 角色进程id
        ,group_id  = 0      			%% 分组Id
        ,name      = <<>>   			%% 角色名称
        ,sex       = 0      			%% 性别[0:女,1:男]
        ,career    = 0      			%% 职业 1:真武 2:魅影 3:天师 4:飞羽 5:天尊 6:新手 9:不限
        ,lev       = 0      			%% 好友等级
        ,intimacy  = 0      			%% 亲密度 
        ,online_late = 0    			%% 最近上线时间
        ,map_id    = 0      			%% 当前所在地图
        ,face_id   = 0      			%% 玩家头像
        ,vip_type  = 0      			%% 好友VIP类型
        ,signature = <<>>   			%% 好友自定义签名
        ,prestige  = 0      			%% 人气值
        ,guild     = <<>>   			%% 帮会
        ,online    = 0      			%% 好友是否在线[1:在线,0:离线]
        ,modified  = 0      			%% 是否修改过-针对是否需要同步到数据库[0:未修改 1:已修改]
        ,fight     = 0          		%% 好友战斗力
        ,last_chat = 0      			%% 最近聊天时间
        ,give_time = 0      			%% 赠送体力时间
        ,give_flag = ?no_give      		%% 赠送标志 0：无效，1:没赠送 2:已赠送
        ,recv_time = 0      			%% 收到体力时间
        ,recv_flag = ?no_recv      		%% 收取体力标志 0：无效，1:还没收到 2:可以领取 3:已经领取
    }
).

%% 好友在线信息
%% 作为临时参数
-record(friend_online, {
        pid                 %% 好友在线信息
        ,name = <<>>         %% 角色名称
        ,sex = 0            %% 性别
        ,career = 0         %% 职业
        ,lev = 1            %% 级别
        ,map_id = 0         %% 当前所有地图
        ,face_id = 0        %% 头像ID
        ,vip_type = 0       %% VIP类型
        ,signature = <<>>   %% 自定义签名
        ,prestige = 0       %% 人气值
        ,guild = <<>>       %% 帮会
        ,online_late =0     %% 最近上线时间
        ,fight = 0          %% 战斗力
    }
).

%% 12175参数
-record(friend_param_rlist, {
        conn_pid                %% 请求源conn_pid
        ,pid                    %% 请求源pid
        ,target_pids = []       %% 目标PID列表
        ,match = []         %% 角色列表{RoleId, SrvId, Name, Career, Sex, Lev}
        ,unmatch = []           %% 没有匹配的
        ,sex = {0, 0}           %% 性别数量
    }
).
