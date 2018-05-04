-module(medal_dao).
-export([
        save_cond/0,
		save_rank/0,
        load_cond/0,
		load_rank/0
		]).
-include("achievement.hrl").
-include("common.hrl").
-include("role.hrl").

save_cond() ->
	List = medal_mgr:get_all(),
	% ?DEBUG("----:~w~n",[List]),
	save(List).

save_rank() ->
   [{new, Data}] = ets:lookup(medal_rank, new),
    % ?DEBUG("----:~w~n",[Data]),
    save2(Data).


load_rank() ->
	Sql = "select value from sys_medal_rank",
    case db:get_all(Sql, []) of
        {ok, Data} ->
        	% ?DEBUG("--Data---:~w~n",[Data]),
            do_format(to_medal_rank, Data),            
            ok;
        {error, undefined} -> 
           	false;
        _ ->
            false
    end.

load_cond() ->
    Sql = "select rid, value from sys_medal_mgr",
    case db:get_all(Sql, []) of
        {ok, Data} ->
            % ?DEBUG("--Data---:~w~n",[Data]),
            do_format(to_medal_cond, Data),            
            ok;
        {error, undefined} -> 
            false;
        _ ->
            false
    end.



%%------------------------------------------------------------------
%% 内部方法
%%------------------------------------------------------------------

%% 执行数据转换
do_format(to_medal_cond, []) -> ok;
do_format(to_medal_cond, [[Rid, Condition] | T]) ->
	{ok,Cond} = util:bitstring_to_term(Condition),
    medal_mgr:update_cur_medal_cond(Rid,Cond),
    do_format(to_medal_cond,T);


do_format(to_medal_rank, []) -> ok;
do_format(to_medal_rank, [[Value] | T]) ->
    {ok,Val} = util:bitstring_to_term(Value),
    % ?DEBUG("-----:~w~n",[Val]),
    medal_mgr:load_top_n_medal(Val),
    do_format(to_medal_rank,T).



% do_format(to_rank, []) -> ok;
% do_format(to_rank, [[Type, Val, D1, D2] | T]) ->
%     case util:bitstring_to_term(D2) of
%         {ok, List} ->
%             {ok, HonorL} = util:bitstring_to_term(D1),
%             Rank = #rank{type = Type, honor_roles = HonorL, roles = List, last_val = Val},
%             rank_mgr:update_ets(Rank),
%             do_format(to_rank, T);
%         _Why -> 
%             ?ERR("排行榜数据转换失败:[Type:~p]", [Type]),
%             case lists:member(Type, ?rank_allow_load_fail) of
%                 true ->
%                     do_format(to_rank, T);
%                 false ->
%                     false
%             end
%     end.

%% 保存勋章条件
save([]) ->ok;
save([{Rid,Data}|T]) ->
	Sql = "replace into sys_medal_mgr (rid,value) values(~s, ~s)",
    db:execute(Sql, [Rid, util:term_to_string(Data)]),
	save(T).

%% 保存勋章排行
save2([]) ->ok;
save2(List) ->
    Sql1 = "delete from sys_medal_rank",
    db:execute(Sql1,[]),
    Sql = "insert into sys_medal_rank (time,value) values(~s, ~s)",
    db:execute(Sql, [util:unixtime(), util:term_to_string(List)]).