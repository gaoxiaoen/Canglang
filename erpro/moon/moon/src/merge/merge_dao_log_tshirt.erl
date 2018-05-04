%%----------------------------------------------------
%% @doc 周年庆tshirt日志 
%% 
%% @author jackguan@jieyou.cn 
%% @end
%%----------------------------------------------------
-module(merge_dao_log_tshirt).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table) ->
    merge_util:batch_insert_offset(Table, <<"rid, srv_id, name, account, lev, career, sex, sizes, picture, info, ctime">>).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.

