%% 帮派宏定义

%% 创建帮派进程类型
-define(FAMILY_PROCESS_OP_TYPE_INIT,1).               %% 系统初始化创建
-define(FAMILY_PROCESS_OP_TYPE_CREATE,2).             %% 玩家创建帮派创建

%% 成员在线状态
-define(FAMILY_MEMBER_OFFLINE,0).                     %% 不在线
-define(FAMILY_MEMBER_NOLINE,1).                      %% 在线

%% 成员职位状态
-define(FAMILY_MEMBER_OFFICE_TUAN_ZHANG,10000).       %% 团长
-define(FAMILY_MEMBER_OFFICE_DU_JUN,10001).           %% 督军
-define(FAMILY_MEMBER_OFFICE_YING_ZHANG,10002).       %% 营长
-define(FAMILY_MEMBER_OFFICE_QIANFU_ZHANG,10003).     %% 千夫长
-define(FAMILY_MEMBER_OFFICE_BAIFU_ZHANG,10004).      %% 百夫长
-define(FAMILY_MEMBER_OFFICE_WU_ZHANG,10005).         %% 伍长
-define(FAMILY_MEMBER_OFFICE_TUAN_YUAN,10006).        %% 团员
       
%% 退出帮派类型
-define(FAMILY_OUT_TYPE_DISBAND,1).                   %% 解散退出帮派
-define(FAMILY_OUT_TYPE_FIRE,2).                      %% 开除退出帮派
-define(FAMILY_OUT_TYPE_LEAVE,3).                     %% 离开退出帮派

%% 帮派属性变化通知接口类型
-define(FAMILY_ATTR_CHANGE_OP_TYPE_NORMAL,0).         %% 一般通知
-define(FAMILY_ATTR_CHANGE_OP_TYPE_IMPEACH,1).        %% 弹劾帮派团长通知
-define(FAMILY_ATTR_CHANGE_OP_TYPE_DONATE,2).         %% 捐献通知

%% 帮派设置信息接口操作类型
-define(FAMILY_SET_OP_TYPE_PUBLIC_NOTICE,1).          %% 1设置帮派公告





