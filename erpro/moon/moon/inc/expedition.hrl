%%----------------------------------------------------
%% 远征王军
%%
%% @author qingxuan 
%%----------------------------------------------------

%%远征王军每天次数
-define(expedition_limit_count, 5). 
%% 远征王军可购买次数
% -define(expedition_limit_buy, 5).

-define(expedition_follower_pos1, [390, 470]).
-define(expedition_follower_pos2, [350, 400]).

-record(expedition, {
    times = 0           %% 进入次数
    ,last_time = 0      %% 最后进入的时间
    ,buy_times = 0      %% 购买次数
    ,last_buy_time = 0  %% 最后购买时间
    ,partners = []      %% 获取的伙伴
}).
