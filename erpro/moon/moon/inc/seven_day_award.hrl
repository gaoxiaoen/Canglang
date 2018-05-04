%% 七天奖励


-define(init_awards_info, 
                    [
                    #award{day=1, flag=0}
                    ,#award{day=2, flag=0}
                    ,#award{day=3, flag=0}
                    ,#award{day=4, flag=0}
                    ,#award{day=5, flag=0}
                    ,#award{day=6, flag=0}
                    ,#award{day=7, flag=0}
                ]                        %% 奖励记录 [#award{}, #award{}]

).

%% 在线信息
-record(online_info, {
        online_time = 0        %% 当天在线时长
        ,last_login = 0         %% 上一次登陆时间
    }).

%% 奖励内容
-record(award, {
        day                %% 第几天的奖励
        ,flag              %% 1-没领取  2-已领取
    }).

-record(seven_day_award, {
        online_info = #online_info{}        %% 在线信息
        ,type = 1                           %% 奖励类型  1 - 第一类七天奖励， 2 - 第二类七天奖励
        ,awards = ?init_awards_info
    }).




