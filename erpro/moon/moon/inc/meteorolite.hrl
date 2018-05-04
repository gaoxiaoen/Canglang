%%   概述：在规定的时间、地点、随机场景位置，会在对应场景出现天外陨石

-define(meteorolite_elemid, 60240). %% 地图元素

%% 基础数据 出现基础配置数据
-record(meteorolite_base, {
        map_id = 0          %% 地图ID
        ,map_name = <<>>    %% 地图名称
        ,limit = 0          %% 单地图限制数量
        ,pos_list = []      %% 随机出现地点
    }
).
