%%----------------------------------------------------
%% @doc 角色数据
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_card_ext).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
        ,update_srv_id/1
    ]
).

-include("common.hrl").
-include("merge.hrl").

%% -record(merge_card_ext, {
%%         card_num = <<>>     %% 卡号
%%         ,role_id = 0        %% 角色ID
%%         ,srv_id = <<>>      %% 服务器标志符
%%         ,use_time = 0       %% 使用时间
%%     }
%% ).

%%----------------------------------------------------
%% API
%%----------------------------------------------------
do_init(Table = #merge_table{server = #merge_server{schema = Schema, target_schema = TargetSchema,  index = 1}}) ->
    Sql = util:fbin(<<"insert into ~s.sys_card_ext (select * from ~s.sys_card_ext where role_id != 0)">>, [TargetSchema, Schema]),
    case merge_db:execute(?merge_target, Sql, []) of
        {ok, _Affected} -> {ok, [], Table};
        {error, Reason} -> {error, Reason}
    end;
do_init(Table = #merge_table{server = #merge_server{schema = Schema, target_schema = TargetSchema, index = Index, size = Size}}) when Index =/= Size -> 
    Sql = util:fbin(<<"insert into ~s.sys_card_ext (select * from ~s.sys_card_ext where role_id != 0 and card_num not in (select card_num from ~s.sys_card_ext))">>, [TargetSchema, Schema, TargetSchema]),
    case merge_db:execute(?merge_target, Sql, []) of
        {ok, _Affected} -> {ok, [], Table};
        {error, Reason} -> {error, Reason}
    end;
do_init(Table = #merge_table{server = #merge_server{schema = Schema, target_schema = TargetSchema, index = Index, size = Size}}) when Index =:= Size -> 
    Sql = util:fbin(<<"insert into ~s.sys_card_ext (select * from ~s.sys_card_ext where role_id != 0 and card_num not in (select card_num from ~s.sys_card_ext))">>, [TargetSchema, Schema, TargetSchema]),
    case merge_db:execute(?merge_target, Sql, []) of
        {ok, _Affected} -> 
            Sql2 = util:fbin(<<"insert into ~s.sys_card_ext (select * from ~s.sys_card_ext where role_id = 0 and card_num not in (select card_num from ~s.sys_card_ext))">>, [TargetSchema, Schema, TargetSchema]),
            case merge_db:execute(?merge_target, Sql2, []) of
                {ok, _Affected2} -> {ok, [], Table};
                {error, Reason} -> {error, Reason}
            end;
        {error, Reason} -> {error, Reason}
    end.

%% 处理数据
do_convert([], Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.

%% 纠正SrvId
update_srv_id(Table) ->
    merge_util:update_srv_id(Table, "srv_id").
%%----------------------------------------------------
%%----------------------------------------------------
