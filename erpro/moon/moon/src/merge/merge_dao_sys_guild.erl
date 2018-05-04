%%----------------------------------------------------
%% @doc 帮会
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(merge_dao_sys_guild).

-export([
        do_init/1
        ,do_convert/2
        ,do_end/1
        ,update_srv_id/1
    ]
).

-include("common.hrl").
-include("merge.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("link.hrl").

do_init(Table = #merge_table{server = #merge_server{index = Size, size = Size}}) ->
    %% guild_merge:merge(),
    SrvList = merge_util:all_server(),
    List = [Platform || #merge_server{platform = Platform} <- SrvList],
    guild_merge:merge(List),
    {ok, [], Table};
do_init(Table) -> {ok, [], Table}.

%% 处理数据
do_convert(_Data, Table) -> {ok, Table}.

%% 最后执行一下,释放资源
do_end(_Table) -> ignore.

%% 纠正SrvId
update_srv_id(Table = #merge_table{old_srv_id = OldSrvId, new_srv_id = NewSrvId}) ->
    merge_util:update_srv_id(Table, "srv_id"),
    ?INFO("==========更新帮会信息begin=========="),
    <<"success">> = guild_merge:alter_srvid(OldSrvId, NewSrvId),
    ?INFO("==========更新帮会信息begin=========="),
    ok.
