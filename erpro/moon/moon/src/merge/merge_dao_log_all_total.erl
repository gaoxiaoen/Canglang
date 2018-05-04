%%----------------------------------------------------
%% @doc 横向统计日志
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_log_all_total).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table) ->
    merge_util:batch_insert_offset(Table, <<"srv_id, reg_num, online_max_num, online_avg_num, rmb_num, rmb, rmb_count, rmb_newnum, rmb_new, rmb_old, reg_num_total, rmb_num_total, money, per_total, arpu, arpu_first, login_num, login_num_old, consume_gold, stack_gold, ctime">>).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.
