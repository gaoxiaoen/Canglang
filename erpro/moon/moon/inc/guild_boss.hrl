%%----------------------------------------------------
%% @doc 帮会boss相关数据结构定义
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
%% 帮派记录领养记录
-record(guild_boss_guild, {
        id = {0, <<>>}
        ,name = <<>>
        ,bosses = []
        ,kill_log = []
    }).

%% 个人击杀记录
-record(guild_boss_role, {
        id = {0, <<>>} %% 角色id
        ,name = <<>> %% 角色名称
        ,sex = 0 %% 角色性别
        ,career = 0 %% 职业
        ,lev = 0 %% 等级
        ,today_feed = 0 %% 今天喂养次数
        ,today_play = 0 %% 今天调戏次数
        ,last_feed = 0 %% 最后一次喂养时间
        ,last_played = 0 %% 最后一次调戏时间
        ,total_dmg = 0 %% 总伤害
        ,max_dmg = 0 %% 最高伤害
        ,is_fighting = 0 %% 是否正在打boss
        ,last_fighted = 0 %% 最后战斗时间
        ,today_fighted = 0 %% 今天击杀了多少次
    }).

%% boss数据结构
-record(guild_boss_npc, {
        id = 0      %% boss的npc唯一标识0为未召唤出来
        ,gid = {0, <<>>} %% 所属帮派
        ,type       %% boss类型
        ,mood = 0 %% 心情值
        ,exp = 0  %% 经验值
        ,lev = 0 %% 等级
        ,hp = 0  %% boss的剩余血量
        ,today_feed = 0 %% 今天喂养次数
        ,today_play = 0 %% 今天调戏次数
        ,last_feed = 0 %% 最后一次喂养时间
        ,last_played = 0 %% 最后一次调戏时间
        ,role_log = [] %% 玩家操作记录
        ,can_fight = 0 %% 是否可以击杀
    }).
