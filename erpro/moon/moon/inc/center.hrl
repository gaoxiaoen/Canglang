%%----------------------------------------------------
%% 跨服相关数据结构定义
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------

%% 服务器镜像数据
-record(mirror_data, {
        srv_id          %% 服务器ID bitstring()
        ,srv_ids = []   %% 合服的服务器ID列表 [bitstring()]
        ,platform       %% 平台标识 bitstring()
        ,name           %% 名称 bitstring()
        ,node           %% 节点名称 string()
        ,host           %% 域名 string()
        ,ver            %% 当前版本 string()
        ,cookie         %% 连接远端服务器时的erl cookie   string()
    }
).

%% 服务器镜像，即远程服务器在中央服上的镜像
-record(mirror, {
        srv_id         %% 服务器ID bitstring()
        ,platform       %% 平台标识 bitstring()
        ,name           %% 名称 bitstring()
        ,node           %% 节点名称 atom()
        ,host           %% 域名 string()
        ,ver            %% 当前版本 string()
        ,cookie         %% 连接远端服务器时的erl cookie   atom()

        ,pid            %% 进程ID
        ,mpid           %% 镜像进程pid
        ,mref           %% 镜像进程监视器
        ,timer_ref      %% 重连定时器
    }
).

%% 服务器信息
-record(srv, {
        id              %% 服务器ID
        ,platform       %% 平台标识
        ,group = []     %% 合服后的服务器ID组
        ,realm_a = []   %% 属于阵营a的服务器ID
        ,realm_b = []   %% 属于阵营b的服务器ID
        ,node           %% 节点名称
        ,host           %% 域名
        ,ver            %% 当前版本
    }
).


-define(cross_trip_flag, 0). %% 跨服旅行功能是否开发 0：不开放，1：开放
