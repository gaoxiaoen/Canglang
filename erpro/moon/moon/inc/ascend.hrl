%% *********************************************
%% 职业进阶相关结构
%% @author wpf(wprehard@qq.com)
%% *********************************************

-define(ROLE_ASCEND_VER, 1).

%% 角色信息结构
-record(ascend, {
        ver = ?ROLE_ASCEND_VER
        ,direct = [] %% 进阶方向[{Career::integer(), AscendType::integer(), LastTime::integer()} | ...]
                     %% Career：职业
                     %% AscendType：进阶类型[1, 2]
                     %% LastTime：上次进阶时间
    }).

