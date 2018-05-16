%%%----------------------------------------------------------------------
%%% @author : kongqingquan <kqqsysu@gmail.com>
%%% @date   : 2013.06.15.
%%% @desc   : Key Value 处理模块，数据只保存在内存中
%%%----------------------------------------------------------------------

-module(global_data_ram).
-author('kongqingquan <kqqsysu@gmail.com>').
-define(TABLE,global_data_ram).

-export([init/0]).
-export([list/0,get/1,get/2,set/2,del/1]).

-define(SYNC_INTERVAL,3000000).

init() ->
	ets:new(?TABLE,[{keypos,1},named_table,public,set,{read_concurrency,true}]),
	ok.

list() ->
	ets:tab2list(?TABLE).

get(K) ->
	get(K,undefined).

get(K,Def) ->
	case ets:lookup(?TABLE,K) of
		[{K,V}] ->
			V;
		[] ->
			Def
	end.

del(K) ->
    ets:delete(?TABLE, K).

set(K,V) ->
	ets:insert(?TABLE,{K,V}).

