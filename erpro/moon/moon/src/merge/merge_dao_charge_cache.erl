%%----------------------------------------------------
%% @doc 充值缓存内容，用于解决类似新浪微博这样的平台需要先缓存用户充值数据的情况
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_charge_cache).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table) ->
    merge_util:batch_insert_offset(Table, <<"account, sn, ts, json">>).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.
