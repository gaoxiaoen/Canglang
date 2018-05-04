-module(trial_dao).
-export([
        save_info/0,
        load_info/0
		]).
-include("achievement.hrl").
-include("common.hrl").
-include("role.hrl").

save_info() ->
	List = trial_mgr:get_all(),
	% ?DEBUG("----:~w~n",[List]),
	save(List).

load_info() ->
    Sql = "select value from sys_trial_info",
    case db:get_all(Sql, []) of
        {ok, Data} ->
            % ?DEBUG("--Data---:~w~n",[Data]),
            case Data of 
                [] ->
                    
                    ok;
                _ ->
                    do_format(to_trial_info, Data),            
                    ok
            end;
        {error, undefined} -> 
            false;
        _ ->
            false
    end.


%%------------------------------------------------------------------
%% 内部方法
%%------------------------------------------------------------------

%% 执行数据转换
do_format(to_trial_info, []) -> ok;
do_format(to_trial_info, [[Value] | T]) ->
    {ok,Val} = util:bitstring_to_term(Value),
    % ?DEBUG("-----:~w~n",[Val]),
    ets:insert(sys_trial_info, Val),
    do_format(to_trial_info,T).

%% 保存试炼场信息
save([]) ->ok;
save(List) ->
    Sql1 = "delete from sys_trial_info",
    db:execute(Sql1,[]),
    Sql = "insert into sys_trial_info (time,value) values(~s, ~s)",
    db:execute(Sql, [util:unixtime(), util:term_to_string(List)]).