%%-------------------------------------------------
%% @author  liuweihua(yjbgwxf@gmail.com)
%%
%% 私聊，频道聊天，数据
%%-------------------------------------------------

%% 频道
-define(chat_world, 1).             %% 世界频道
-define(chat_map, 2).               %% 地图频道
-define(chat_guild, 3).             %% 帮会频道
-define(chat_team, 4).              %% 组队频道
-define(chat_friend, 5).            %% 好友频道
-define(chat_sys, 6).               %% 系统频道
-define(chat_hearsay, 7).           %% 传闻频道
-define(chat_right, 8).             %% 右下角事件频道                 
-define(chat_world_team, 9).        %% 队伍招募
-define(chat_kuafu_hy, 11).         %% 跨服好友
-define(chat_hall_room, 12).         %% 房间内聊天

-define(chat_online, 1).            %% 私聊对方在线
-define(chat_offline, 0).           %% 私聊对方不在线
-define(chat_circle, 1).            %% 私聊对方在自己交友圈子
-define(chat_nocircle, 0).          %% 私聊对方不在自己的交友圈子
-define(chat_nocircle_not_kuafu, 2).%% 私聊对方不是交友圈子，且不在跨服活动

%% 私聊限制
-record(chat_circle_limit, {
        id = 0              %% 角色ID
        ,last = 0           %% 上次聊天时间
        ,list = []          %% 列表
    }).
