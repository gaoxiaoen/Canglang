
%%----------------------------------------------------
%% 酒桶节管理进程
%% @author bwang
%%----------------------------------------------------
-module(beer_mgr).
-behaviour(gen_server).
-export([
		start_link/0,
		login/1,
		get_beer_info/1,
		update_beer_info/1,
		update_role_reward/2,
		get_role_reward_info/1,
		clear_role_reward/0,

		add_role_join/1,
		update_role_beer_times/0,

		ets_info/1
		]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
    }).

-include("common.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("link.hrl").
-include("beer.hrl").

-define(save_time, 600000).

%% 角色登录时同步ets中碎片的信息s
login(Role = #role{login_info = #login_info{last_logout = _LastLogout}}) ->
	% Now = util:unixtime(),
	% case util:is_same_day2(LastLogout, Now) of 
	% 	true -> ok;
	% 	false -> reset(Role)
	% end,
	% role_timer:set_timer(reset2, util:unixtime({nexttime, 86407}) * 1000, {?MODULE, fun reset/1, []}, 1, Role).
	Role.

% reset(Role = #role{id = {Rid, _}}) -> 
% 	Info = #beer_role_info{rid = Rid},
% 	update_beer_info(Info),
% 	{ok, Role}.


ets_info(TableName) ->
	ets:tab2list(TableName).

%% 获取角色酒桶节信息
get_beer_info({Rid, _}) -> 
	case ets:lookup(beer_role, Rid) of 
		[Info = #beer_role_info{}|_] ->
			Info;
		_ -> 
			#beer_role_info{}
	end.

%% 更新角色酒桶节信息
update_beer_info(Info = #beer_role_info{}) ->
	beer_mgr ! {update, Info}.

%% @spec update_role_reward(Id, {Answer, Coin, Exp}) -> ok
%% @spec Answer ::integer() 1答对 0 答错 2丢动作的奖励或者砸到的奖励
%% @doc更新角色奖励信息，主要是在
update_role_reward(Id, {Answer, Coin, Exp}) ->
	beer_mgr ! {update_reward, Id, Answer, Coin, Exp}.

%% 获取角色奖励信息
get_role_reward_info(Id) ->
	lookup_reward(Id).

%%删除ets表信息，考虑不使用api的方式，直接通过进程消息，比较隐秘
clear_role_reward() -> 
	beer_mgr ! clear.

%% 添加一个参加者
add_role_join({_Rid, _Srvid}) -> 
	beer_mgr ! {add_role, {_Rid, _Srvid}}.

%% 活动结束时， 遍历所有参加的更新参加的次数之后清空已有的记录
update_role_beer_times() -> 
	beer_mgr ! update_role_times.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

% ---------------------------------------------------------------------------------------
% system api
% ---------------------------------------------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    ets:new(beer_role, [public, set, named_table, {keypos, #beer_role_info.rid}]),
    ets:new(beer_reward, [public, set, named_table, {keypos, 1}]),

    put(beer_role_join, []), %% 记录参加的玩家，每次活动结束之后就清空

    process_flag(trap_exit, true), 
   	case load_role_beer_info() of 
   		ok -> 
		    erlang:send_after(?save_time, self(), save_info),
		    erlang:send_after(util:unixtime({nexttime, 86405}) * 1000, self(), clear_role_beer_info),

		    ?INFO("[~w] 酒桶节角色信息管理进程启动完成 !", [?MODULE]),
		    {ok, #state{}};
		_ -> 
			?INFO("[~w] 酒桶节角色信息管理进程启动失败 !", [?MODULE]),
			{stop, load_failure}
	end.

handle_info(save_info, State) ->
	save_role_beer_info(),
	erlang:send_after(?save_time, self(), save_info),
    {noreply, State};

handle_info({update, Info = #beer_role_info{rid = Rid}}, State) ->
	ets:delete(beer_role, Rid),
	ets:insert(beer_role, Info),
    {noreply, State};

handle_info({update_reward, Id, Answer, Coin, Exp}, State) ->
	{Right, Wrong, Coin0, Exp0} = lookup_reward(Id),
	{NewRight, NewWrong, NewCoin, NewExp} = 
		case Answer of 
			0 -> {Right, Wrong + 1, Coin0 + Coin, Exp0 + Exp};
			1 -> {Right + 1, Wrong, Coin0 + Coin, Exp0 + Exp};
			_ -> {Right, Wrong, Coin0 + Coin, Exp0 + Exp} %% 丢活动获得的奖励
		end,
	ets:delete(beer_reward, Id),
	ets:insert(beer_reward, {Id, NewRight, NewWrong, NewCoin, NewExp}),
    {noreply, State};

handle_info(clear_role_beer_info, State) ->
	ets:delete_all_objects(beer_role),
	delete_beer_role_db(),
	erlang:send_after(util:unixtime({nexttime, 86405}) * 1000, self(), clear_role_beer_info),
    {noreply, State};

handle_info(clear, State) ->
	ets:delete_all_objects(beer_reward),
    {noreply, State};

handle_info({add_role, {_Rid, _Srvid}}, State) ->
	JoinRoles = get(beer_role_join),
	case lists:member({_Rid, _Srvid}, JoinRoles) of 
		true -> ignore;
		false -> 
			NJoinRoles = [{_Rid, _Srvid}] ++ JoinRoles,
			put(beer_role_join, NJoinRoles)
	end,
    {noreply, State};

 handle_info(update_role_times, State) ->
	JoinRoles = get(beer_role_join),
	update_role_beer_times(JoinRoles),
    {noreply, State};


handle_info(_Request, State) ->
    {noreply, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
	save_role_beer_info(),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%-----------------------------------------------------------------------------
%% internal api
%%-----------------------------------------------------------------------------
update_role_beer_times([]) -> put(beer_role_join, []);
update_role_beer_times([H = {Rid, _Srvid}|T]) -> 
	BeerInfo = #beer_role_info{beer_times = BTimes} = get_beer_info(H),
	update_beer_info(BeerInfo#beer_role_info{rid = Rid, beer_times = BTimes - 1}),
	update_role_beer_times(T).


lookup_reward(Rid) -> 
	case ets:lookup(beer_reward, Rid) of 
		[{Rid, Right, Wrong, Coin, Exp}|_] -> 
			{Right, Wrong, Coin, Exp};
		_ -> {0, 0, 0, 0}
	end.

save_role_beer_info() -> 
	All = ets:tab2list(beer_role),
	do_save(All),
	ok.

do_save([]) -> ok;
% do_save([{beer_role_info, Rid, Beer, Egg, Flower, Fire}|T]) ->
do_save([{beer_role_info, Rid, Beer, _Egg, _Flower, _Fire}|T]) ->
	% Sql = "replace into sys_beer_mgr (rid, beer) values(~s, ~s, ~s, ~s, ~s)",
	Sql = "replace into sys_beer_mgr (rid, beer) values(~s, ~s)",
    % db:execute(Sql, [Rid, Beer, Egg, Flower, Fire]),
    db:execute(Sql, [Rid, Beer]),
    do_save(T).

load_role_beer_info() -> 
	 Sql = "select * from sys_beer_mgr",
    case db:get_all(Sql, []) of
        {ok, Data} ->
            do_load(load, Data);
        {error, undefined} -> 
            false;
        _ ->
            false
    end.

%% 执行数据转换
do_load(load, []) -> ok;
% do_load(load, [[Rid, Beer, Egg, Flower, Fire] | T]) ->
do_load(load, [[Rid, Beer] | T]) ->
    % ets:insert(beer_role, {beer_role_info, Rid, Beer, Egg, Flower, Fire}),
    ets:insert(beer_role, {beer_role_info, Rid, Beer, 0, 0, 0}),
    do_load(load, T).

delete_beer_role_db() -> 
	Sql = "delete from sys_beer_mgr",
	db:execute(Sql, []).