%%%----------------------------------------------------------------------
%%% File    : mod_subscriber_dumper.erl
%%%----------------------------------------------------------------------
-module(mod_subscriber_dumper).



%%
%% Include files
%%
-include("common.hrl").
-include("common_server.hrl").

%%
%% Exported Functions
%%
-export([do_mnesia_queues/1,do_mysql_queues/3]).
-export([do_clear_table_mnesia/1,do_clear_table_mysql/1]).

-define(db_persistent, db_persistent).

%%
%% API Functions
%%

do_clear_table_mnesia(DiskTab) when is_atom(DiskTab)->
    erlang:send(?db_persistent, {clear_table, DiskTab}).

do_clear_table_mysql(DiskTab) when is_atom(DiskTab)->
    try
        SQL = mod_mysql:get_esql_delete(DiskTab, [] ),
        {ok,_} = mod_mysql:delete(SQL)
    catch
        _:Reason->
            ?ERROR_MSG("do_clear_table_mysql error,Reason=~w,stacktrace=~w",[Reason,erlang:get_stacktrace()])
    end.

%% @spec do_mnesia_queues/1
%% @doc 将队列消息发送给db_persistent 进行持久化
do_mnesia_queues( QueueList )->
	erlang:send(?db_persistent, {cache_subscriber_queue, QueueList}),
	ok.

%% @spec do_mysql_queues(TabType::atom(),QueueList::list(), IsDeleteTag::bool())
do_mysql_queues( _TabType,QueueList, false)->
    try_do_mysql_queue_batch(QueueList);
do_mysql_queues( _TabType,[], true)->
    ok;
do_mysql_queues( TabType,[H|T],true )->
	try_do_mysql_queue_once( TabType,H),
	do_mysql_queues( TabType,T,true).

%%@doc mysql批量处理队列
try_do_mysql_queue_batch([H|_T]=QueueList)->
    {CrudType,DiskTab, _Record} = H,
    try
        RecordList = [ R||{_,_, R}<-QueueList],
        mysql_persistent_handler:dirty_write_batch(DiskTab, RecordList)
    catch
        _:Reason->
            ?ERROR_MSG("do_mysql_queue error,CrudType=~w,DiskTab=~w,Reason=~w,stacktrace=~w",[CrudType,DiskTab,Reason,erlang:get_stacktrace()])
    end.

try_do_mysql_queue_once(TabType,Request)->
    try
        do_mysql_queue(TabType,Request)
    catch
        _:Reason->
            %%根据不同的原因，选择是否throw
            {CrudType,DiskTab, _Record} = Request,
            ?ERROR_MSG("do_mysql_queue error,CrudType=~w,DiskTab=~w,Reason=~w,stacktrace=~w",[CrudType,DiskTab,Reason,erlang:get_stacktrace()])
    end.
	

%% @spec do_mysql_queue/1
%% @doc 通过MySQL方式处理 每一条队列
do_mysql_queue(_TabType,{insert,DiskTab, Record})->
	 mysql_persistent_handler:dirty_insert(DiskTab, Record);
do_mysql_queue(_TabType,{write,DiskTab, Record})->
	 mysql_persistent_handler:dirty_write(DiskTab, Record);
do_mysql_queue(TabType,{update,DiskTab, Record})->
	mysql_persistent_handler:dirty_update(TabType,DiskTab, Record);
do_mysql_queue(_TabType,{delete,DiskTab, Key})->
	 mysql_persistent_handler:dirty_delete(DiskTab, Key);
do_mysql_queue(TabType,{delete_object,DiskTab, Object})->
	mysql_persistent_handler:dirty_delete_object(TabType,DiskTab, Object).



