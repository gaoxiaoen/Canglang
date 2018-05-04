%%% -------------------------------------------------------------------
%%% Author  :xiaocenfeng
%%% Description :
%%%
%%% Created : 2013-9-25
%%% -------------------------------------------------------------------
-module(mgeew_ranking_server).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("mgeew.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([start/0,start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([cmp/1,
		 rank/2]).

-define(RERESH_FIXED_TIME,1).   %%定时刷新
-define(RERESH_INTERVAL_TIME,2).    %%间隔刷新

%% ====================================================================
%% External functions
%% ====================================================================

start()->
    {ok,_} = supervisor:start_child(mgeew_sup,{?MODULE,
                                               {?MODULE,start_link,[]},
                                               permanent, 30000, worker,
                                               [?MODULE]}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).


%% ====================================================================
%% Server functions
%% ====================================================================

init([]) ->
	init_all_rank(),
	{_,{_H,M,S}} = erlang:localtime(),
	%%每十分钟检测一次，并且根据当前时间计算下次检测时间
	erlang:send_after((9 - (M rem 10))*60*1000 + (60-S)*1000, self(), loop),
    {ok,[]}.


handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_cast(_Request, State) ->
    {noreply,  State}.

handle_info(Info, State) ->
    ?DO_HANDLE_INFO(Info,State),
    {noreply, State}.

terminate(Reason, State) ->
    {stop,Reason, State}.

code_change(_Request,_Code,_State)->
    ok.


%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

do_handle_info(loop)->
    loop();

do_handle_info({?RANKING,?RANKING_GET,DataIn,RoleId,PId,_Line})->
    do_ranking(DataIn,RoleId,PId);

do_handle_info({rank,MethodName,ModuleName,Record})->
	ModuleName:MethodName(Record);

do_handle_info({reload_rank,ModuleName})->
    ModuleName:rank();

do_handle_info(init_rank)->
	init([]);

%% 执行函数处理
do_handle_info({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok.

loop()->
    RankIDList = cfg_ranking:find(rank_id_list),
    CurDate = erlang:localtime(),
    {_,{H,M,S}}=CurDate,
    erlang:send_after((9 - (M rem 10))*60*1000 + (60-S)*1000, self(), loop),
	lists:foreach(
	  fun(RankID)->
			  RankInfo=cfg_ranking:find({rank_info,RankID}),
			  case RankInfo#p_ranking.refresh_type of
				  ?RERESH_FIXED_TIME ->
					  ignore;
				  ?RERESH_INTERVAL_TIME ->
					  case (H*60+M) rem RankInfo#p_ranking.refresh_interval of
						  0 ->
							  ModuleName=RankInfo#p_ranking.rank_module,
							  ?TRY_CATCH(ModuleName:rank(),Err);
						  _->
							  ignore
					  end
			  end
	  end, RankIDList).

%% 初始化所有排行榜
init_all_rank()->
	%% 初始化攻城战排行
	mod_role_rank:init().


%% ===============排序  堆排序 begin=======================

-define(SORT_HEAP,sort_heap).

%% 排名
rank(RankName,HeapName)->
    %% 清除排行榜
    clean_rank(RankName),
    %% 1.清除排序堆
    common_minheap:delete_heap(?SORT_HEAP),
    %% 2.拷贝排序堆
    common_minheap:copy_heap(HeapName, ?SORT_HEAP),
    %% 3.取出有序列表 从大到小
    rank2(RankName).

%% 获取有序列表
rank2(RankName)->
    rank2(RankName,[]).

rank2(RankName,List)->
    case common_minheap:pop(?SORT_HEAP) of
        {error,not_found}->
            List;
        HeapVal->
            rank2(RankName,[HeapVal|List])
    end.

clean_rank(RankName)->
	erlang:erase(RankName).

%% ===============排序  堆排序 end=======================

do_ranking(DataIn,RoleId,PId)->
	#m_ranking_get_tos{rank_id=RankId}=DataIn,
	case cfg_ranking:find({rank_info,RankId}) of
		#p_ranking{rank_module=ModuleName}->
			ModuleName:send_ranking_info({DataIn,RoleId, PId});
		_->
			ignore
	end.

%% 从小到大
cmp([]) ->
    true;
cmp([{Element1,Element2}|List]) ->
    case Element1 =:= Element2 of
        true ->
            cmp(List);
        false ->
            Element1 < Element2
    end.