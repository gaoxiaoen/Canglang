%%----------------------------------------------------
%% 缘分摇一摇 数据结构
%% @author whjing2012@gmail.com
%%----------------------------------------------------
-define(FATE_VER, 0).

-define(FATE_MIN_LEV, 52). %% 最小等级要求

-define(fate_type_finger_guess, 1).  %% 猜拳
-define(fate_type_dice, 2).          %% 摇骰子

%% 角色基础数据信息
-record(fate_role_base_info, {
        id = {rid, srv_id}    %% 角色标志
        ,name = <<>>          %% 角色名称
        ,sex = 0              %% 角色性别
        ,age = 0              %% 年龄
        ,star = 0             %% 星座
        ,msg = <<>>           %% 描述
        ,power = 0            %% 角色战力
        ,ip = 0               %% 角色IP地址
        ,province = language:get(<<"未选择">>)%% 省份
        ,city = language:get(<<"未选择">>)    %% 角色所有城市
        ,fate_list = []       %% 有缘人列表 [#fate_role{}...]
        ,other_info           %% 其它信息
    }
).

%% 角色有缘人信息
-record(fate_role, {
        id = {rid, srv_id}    %% 角色标志
        ,name = <<>>          %% 角色名称
        ,sex = 0              %% 角色性别
        ,career = 0           %% 角色职业
        ,lev = 0              %% 角色等级
        ,vip = 0              %% VIP类型
        ,age = 0              %% 年龄
        ,star = 0             %% 星座
        ,power = 0            %% 角色战力
        ,charm = 0            %% 魅力值
        ,hi = 0               %% hi次数
        ,province = language:get(<<"未选择">>)%% 省份
        ,city = language:get(<<"未选择">>)    %% 所在城市
        ,face = 0             %% 角色头像
        ,msg = <<>>           %% 交友宣言
        ,looks = []           %% 角色外观
        ,eqm = []             %% 角色装备列表
    }
).

%% 角色缘分数据
-record(fate, {
        ver = ?FATE_VER
        ,logs = []            %% 日志[{Type, N, LastTime}]
    }
).
