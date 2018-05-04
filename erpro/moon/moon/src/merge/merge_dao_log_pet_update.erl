%%----------------------------------------------------
%% @doc 宠物变化日志记录
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_log_pet_update).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

do_init(Table) ->
    Time = util:unixtime() - 86400 * 15,
    merge_util:batch_insert_offset(Table, <<"rid, srv_id, rname, pet_id, p_name, status, p_lev, p_exp, msg, pet, ct, recovered, old_pet_msg, new_pet_msg, old_pet">>, util:fbin(<<"where ct > ~w">>, [Time])).

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.
