%%%-------------------------------------------------------------------
%%% File        :merge.hrl
%%%-------------------------------------------------------------------


-define(MERGE_LOG(Format, Args), erlang:send(merge_log_server, {log, {?MODULE, ?LINE, erlang:localtime(), Format, Args}})).

%% 合服操作错误码定义
-define(MERGE_OP_CODE_000,0).                    %% 合服操作成功
-define(MERGE_OP_CODE_900,900).                  %% merge配置代理名称出错
-define(MERGE_OP_CODE_901,901).                  %% 合服的数据库文件无法找到，请检查
-define(MERGE_OP_CODE_902,902).                  %% merge合服列表配置出错
-define(MERGE_OP_CODE_903,903).                  %% 执行合服操作出错
-define(MERGE_OP_CODE_904,904).                  %% 加载数据库表数据出错
-define(MERGE_OP_CODE_905,905).                  %% 合并数据操作完成，删除主数据库表出错
-define(MERGE_OP_CODE_906,906).                  %% 修改数据库表类型出错
