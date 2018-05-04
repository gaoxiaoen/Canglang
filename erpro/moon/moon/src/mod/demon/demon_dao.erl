-module(demon_dao).
-export([
        save_debris/0,
        load_debris/0,
        save_demon/0,
        load_demon/0
		]).
-include("common.hrl").
-include("demon.hrl").
-include("role.hrl").

save_debris() ->
	List = demon_debris_mgr:get_all(),
	save(List).

load_debris() ->
    Sql = "select rid, srv_id, name, lev, career, sex, fc, debris from sys_debris_mgr",
    case db:get_all(Sql, []) of
        {ok, Data} ->
            % ?DEBUG("--Data---:~w~n",[Data]),
            do_format(to_role_debris, Data),            
            ok;
        {error, undefined} -> 
            false;
        _ ->
            false
    end.

load_demon() ->
    Sql = "select rid, srv_id, demon from sys_demon_mgr",
    case db:get_all(Sql, []) of
        {ok, Data} ->
            % ?DEBUG("--Data---:~w~n",[Data]),
            do_format(to_role_demon, Data),            
            ok;
        {error, undefined} -> 
            false;
        _ ->
            false
    end.

save_demon() ->
    List = demon_debris_mgr:get_all_demon(),
    save2(List).

%%------------------------------------------------------------------
%% 内部方法
%%------------------------------------------------------------------

%% 执行数据转换
do_format(to_role_debris, []) -> ok;
do_format(to_role_debris, [[Rid, SrvId, Name, Lev, Career, Sex, Fc, Debris] | T]) ->
	{ok, Data} = util:bitstring_to_term(Debris),
    demon_debris_mgr:update_role_debris({Rid, SrvId, Name, Lev, Career, Sex, Fc, Data}),
    do_format(to_role_debris, T);

do_format(to_role_demon, []) -> ok;
do_format(to_role_demon, [[Rid, SrvId, Demon] | T]) ->
    {ok, Data} = util:bitstring_to_term(Demon),
    demon_debris_mgr:update_role_demon({Rid, SrvId, Data}),
    do_format(to_role_demon, T).


%% 保存勋章条件
save([]) ->ok;
save([{Rid, SrvId, Name, Lev, Sex, Career, Fc, Data}|T]) ->
	Sql = "replace into sys_debris_mgr (rid, srv_id, name, lev, career, sex, fc, debris) values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    Data1 = lists:filter(fun({_BaseIs, Val})-> case Val > 0 of true -> true; false -> false end end, Data),
    db:execute(Sql, [Rid, SrvId, Name, Lev, Career, Sex, Fc, util:term_to_string(Data1)]),
	save(T).

save2([]) ->ok;
save2([{Rid, SrvId, Data}|T]) ->
    Sql = "replace into sys_demon_mgr (rid, srv_id, demon) values(~s, ~s, ~s)",
    db:execute(Sql, [Rid, SrvId, util:term_to_string(Data)]),
    save2(T).
