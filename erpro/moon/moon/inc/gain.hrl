%%----------------------------------------------------
%% 损益处理相关数据结构定义
%% @author yeahoo2000@gmail.com, yqhuang*
%%----------------------------------------------------

%% @see doc/global_label.xls/(sheet)损益数据结构标签说明
%% 所有业务模块都统一使用如下格式及说明,如有增加新标签,请在表中增加說明

%% 增加/获得
-record(gain, {
        label       %% 标签
        ,val        %% 值
        ,log        %% 日志类型，如果是需要记录日志则在此填上日志类型，否则留空
        ,msg = <<>> %% 增加操作失败时的提示信息
        ,misc = []  %% 附加信息[{key, Val} | #record{}] 如掉落公告{drop_notice, XXXX}
        ,err_code = 0  %% 错误代码编号
    }
).

%% 减少/扣除
-record(loss, {
        label       %% 标签
        ,val        %% 值
        ,log        %% 日志类型，如果是需要记录日志则在此填上日志类型，否则留空
        ,msg = <<>> %% 减少操作失败时的提示信息
        ,misc = []  %% 附加信息[{key, Val} | #record{}] 
        ,err_code =0  %% 错误代码编号
    }
).

%% -------------
%% 错误代码编号
%% -------------

%% ---增加/获得 错误
-define(gain_no_error, 0).
-define(gain_item_error, 1).
-define(gain_bag_full, 2).

%% ---减少/扣除 错误
