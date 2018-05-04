%% Author: xiaocenfeng
%% Created: 2013-11-12
%% Description: TODO: Add description to mod_role_rank
-module(mod_role_rank).

%%
%% Include files
%%
-include("mgeew.hrl").
%%
%% Exported Functions
%%
-export([init/0,
		 update_rank/1,
		 update/1,
		 send_ranking_info/1,
		 clean/1,
		 clean_rank/1,
		 rank/0]).
%%
%% API Functions
%%
-define(ranking_role,1001). %% 角色排行榜ID
%% 初始化角色排行
init()->
	#p_ranking{capacity=RankSize}=cfg_ranking:find({rank_info,?ranking_role}),
	RankList = db_api:dirty_match_object(?DB_ROLE_RANK,#r_role_rank{_='_'}),
	common_minheap:new_heap(?MODULE, RankSize, fun cmp/2),
	lists:foreach(fun(#r_role_rank{role_id=RoleID}=Element)->
						  common_minheap:insert(?MODULE,Element,RoleID)
						 end,RankList),
	rank().
	
%% 排名
rank()->
	List=mgeew_ranking_server:rank(?MODULE,?MODULE),
	%% 转换一下排个名放入进程字典
	{_,List2}=
		lists:foldl(
		  fun(RoleRank,{Rank,Acc})->
				  {Rank-1,[transform_row(RoleRank,Rank) | Acc]}		
		  end, {length(List),[]}, List),
	set_rank(?MODULE,List2).

transform_row(RoleRank,Rank)->
	#r_role_rank{role_id=RoleID,role_name=RoleName,role_level=RoleLevel}=RoleRank,
	#p_rank_row{row_id=Rank,role_id=RoleID,role_name=RoleName,int_list=[RoleLevel]}.

set_rank(RankName,List2)->
	erlang:put(RankName, List2).
get_rank(RankName)->
	erlang:get(RankName).

%% 外部调用
update(RoleBase)->
	#p_role_base{role_id=RoleId,role_name=RoleName,level=RoleLevel}=RoleBase,
	RoleRank=#r_role_rank{role_id=RoleId,role_name=RoleName,role_level=RoleLevel},
	?TRY_CATCH(erlang:send(mgeew_ranking_server,{rank,update_rank,?MODULE,RoleRank}),Errs).

%% 更新将领排名,只插堆不排序
update_rank(RoleRank) when is_record(RoleRank,r_role_rank)->
	RoleID = RoleRank#r_role_rank.role_id,
	common_minheap:update_db(?MODULE,RoleRank,RoleID,?DB_ROLE_RANK,RoleRank);
update_rank(Info)->
	?ERROR_MSG("mod_role_rank---unknow_info:~w",[Info]).

clean(RoleId)->
	?TRY_CATCH(erlang:send(mgeew_ranking_server,{rank,clean_rank,?MODULE,RoleId}),Err).

clean_rank(RoleId)->
	common_minheap:delete_db(?MODULE,RoleId,?DB_ROLE_RANK).

%% 获取排行榜发送前端
send_ranking_info({DataIn,RoleId,_PId})->
	RankInfoList=get_rank(?MODULE),
	R=#m_ranking_get_toc{rank_id=DataIn#m_ranking_get_tos.rank_id,
						 rows = RankInfoList},
	common_misc:unicast({role,RoleId}, ?RANKING, ?RANKING_GET,R).

cmp(RoleRank1, RoleRank2) ->
    #r_role_rank{role_level=RoleLevel1} = RoleRank1,
    #r_role_rank{role_level=RoleLevel2} = RoleRank2,
    mgeew_ranking_server:cmp([{RoleLevel1,RoleLevel2}]).