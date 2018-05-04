%%----------------------------------------------------
%% @doc 摇钱树相关数据定义
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
%% 玩家摇钱个人信息
-record(money_tree, {
        ver = 0,    %% 版本号
        times = 0,  %% 摇树次数
        pool = 0, %% 个人奖池
        last_shaked = 0 %% 最后一次摇的时间
    }).

%% 玩家摇钱日志
-record(money_tree_shaked, {
        ver = 0,    %% 版本号
        rid = 0,    %% 玩家id
        srv_id = <<>>, %% 玩家srv_id
        name = <<>>, %% 玩家名称
        times = 0,  %% 摇树次数
        is_double = 0, %% 是否双倍掉落
        money = 0, %% 铜币数
        last_shaked = 0 %% 最后一次摇的时间
    }).
