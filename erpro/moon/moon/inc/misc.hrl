%%----------------------------------------------------
%% @doc 杂七杂八
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------

%% 反外挂
-define(ANTICRACK_VER, 2).      %% 至尊消费特权模块
-record(anticrack, {
        ver = ?ANTICRACK_VER    %% 版本号
        ,escort = 0             %% 运镖时间
        ,dungeon = 0            %% 副本时间
        ,boss_counter = 0       %% 杀boss计数
    }
).
