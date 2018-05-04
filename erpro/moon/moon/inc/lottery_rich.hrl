%%----------------------------------------------------
%% 秘境大富翁
%% @author whjing2011@gmail.com
%%----------------------------------------------------

%% 抽奖玩家信息记录
-record(lottery_rich, {
        last_award = []       %% 上次奖品
        ,count = 0            %% 抽奖的次数， 抽到极品时清零
        ,pos = 0              %% 位置[0~23]
    }
).


%% 抽奖日志
-record(lottery_rich_log, {
        rid = 0             %% 角色ID
        ,srv_id = <<>>      %% 角色服务器标识
        ,name = <<>>        %% 角色名
        ,award_id = 0       %% 奖品ID
        ,num = 1            %% 奖励数量
        ,bind = 1           %% 是否绑定
        ,is_notice = 1      %% 是否极品
        ,ctime = 0          %% 时间
    }
).

%% 彩票奖品的基础信息设定
-record(lottery_rich_item, {
        id = 0
        ,base_id = 0            %% 奖品ID
        ,name = <<>>            %% 物品名称
        ,num = 1                %% 奖励数量
        ,bind = 1               %% 是否绑定
        ,is_notice = 0          %% 0：不公告 1：公告
        ,is_stop = 0            %% 是否停留点
    }
).



