%%----------------------------------------------------
%% @doc 合服相关
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------

%% 数据库
-define(merge_target, merge_target).  %% 目标库
-define(merge_src_list, merge_src_list).  %% 源库

%% 合并表信息
-record(merge_table, {
        name = <<>>         %% 表名描述
        ,table = <<>>       %% 表名
        ,dao                %% dao模块
        ,server             %% 服务器信息
        ,next_key = 0       %% 需要修改key的下个值
        ,process = merge_main_proc %% 进程名称
        ,state              %% 状态值
        ,new_srv_id         %% 新SrvId，纠正一些服的SrvId时使用
        ,old_srv_id         %% 旧SrvId，纠正一些服的SrvId时使用
    }
).

%% 服务器信息
-record(merge_server, {
        platform = ""       %% 服务器标志
        ,data_source        %% 数据源
        ,schema             %% schema
        ,target_schema      %% 目标库schema
        ,update_realm = true%% 是否需要转阵营
        ,realm = 0          %% 阵营 [0:阵营不变 1:蓬莱 2:逍遥]
        ,index = 0          %% 索引
        ,size = 0           %% 服务器大小
    }
).


%% 角色名称
-record(merge_role_name, {
        key = {0, <<>>}     %% 键值
        ,name = <<>>        %% 角色名
        ,lev = 0            %% 等级
        ,exp = 0            %% 经验
        ,data_source
    }
).
