
%%----------------------------------------------------
%% 碎片管理
%% @author bwang
%%----------------------------------------------------
-module(demon_debris_mgr).
-behaviour(gen_server).
-export([
		start_link/0,
		get_role_demon/1,
		get_role_debris/1,
		update_role_demon/2,
		update_role_debris/1,
		get_all/0,
		get_all_demon/0,
		search_role_debris/2,
		update_role_demon/1,
		login/1,

		update_role_grab_info/1,
		get_role_grab_info/1
]).



-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
    }).

-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("gain.hrl").
-include("link.hrl").
-include ("demon.hrl").

-define(save_time, 600000).

%% 角色登录时同步ets中碎片的信息s
login(Role = #role{id = {Rid, _}, demon = RoleDemon}) ->
	case get_role_debris(Rid) of 
		[] -> Role;
		Data ->
			Role#role{demon = RoleDemon#role_demon{shape_skills = Data}}
	end.

%%更新角色碎片信息
update_role_debris(_Role = #role{attr = undefined}) ->
    ok;

update_role_debris(_Role = #role{id = {Rid, Srvid}, name = Name, sex = Sex, career = Career, lev = Lev, attr = #attr{fight_capacity = FC}
	, demon = #role_demon{shape_skills = Debris}}) ->
    ets:delete(role_debris, Rid),
    ets:insert(role_debris, {Rid, Srvid, Name, Lev, Sex, Career, FC, Debris});

update_role_debris({Rid, Debris}) ->
    ets:update_element(role_debris, Rid, {8, Debris});

update_role_debris({Rid, Srvid, Name, Sex, Career, Lev, FC, Debris}) ->
    ets:delete(role_debris, Rid),
    ets:insert(role_debris, {Rid, Srvid, Name, Lev, Sex, Career, FC, Debris}).


get_role_debris(Rid) ->
	% case ets:lookup(role_debris, Rid) of 
	% 	[{_, _, _, _, _, _, _, DD}]->
	% 		DD;
	% 	_ -> []
 %    end.
 	gen_server:call(?MODULE, {get_role_debris, Rid}).

get_role_demon(Rid) ->
	case ets:lookup(role_demon, Rid) of 
		[{_, _, DD}]->
			DD;
		_ -> []
    end.

get_role_grab_info(Rid) ->
	case ets:lookup(role_grab, Rid) of 
		[{_, _, DD}]->
			DD;
		_ -> []
    end.

update_role_demon(Role = #role{id = {Rid, Srvid}, demon = RoleDemon = #role_demon{attr = Attr}}, DemonBaseId) ->
 	case check_contain(Rid, Srvid, DemonBaseId) of 
 		true ->
 			Role;
 		{false, DD, DemonEffect} ->
		    ets:delete(role_demon, Rid),
		    All = [DemonBaseId] ++ DD,
		    ets:insert(role_demon, {Rid, Srvid, All}),
    		NAttr = DemonEffect ++ Attr,
    		Role1 = Role#role{demon = RoleDemon#role_demon{attr = NAttr}},
    		Role2 = deal_medal_listen(Role1, DD, DemonBaseId),
    		role_api:push_attr(Role2)
	end.

deal_medal_listen(Role, DemonList, DemonBaseId) -> 
	case DemonBaseId > 99999 of 
		true -> 
			case lists:member(DemonBaseId - 100000, DemonList) of
				true -> 
					Role;
				false ->
                    NRole1 = medal:listener(monsters_contract, Role), %% 这几个Medal要考虑整成一个
                	medal:listener(monster_contract, NRole1, {DemonBaseId, 1})
            end;
        false ->
        	case lists:member(DemonBaseId + 100000, DemonList) of
				true -> 
					Role;
				false ->
                    NRole1 = medal:listener(monsters_contract, Role), %% 这几个Medal要考虑整成一个
                	medal:listener(monster_contract, NRole1, {DemonBaseId, 1})
            end
    end.

%% 只能启动加载数据时使用
update_role_demon({Rid, Srvid, Demon}) ->
    ets:delete(role_demon, Rid),
    ets:insert(role_demon, {Rid, Srvid, Demon}).

%%
update_role_grab_info({Rid, Srvid, GrabInfo}) ->
    ets:delete(role_grab, Rid),
    ets:insert(role_grab, {Rid, Srvid, GrabInfo}).

%%
check_contain(Rid, _Srvid, DemonBaseId) ->
	DM = case ets:lookup(role_demon, Rid) of
                [] ->
                    [];
                Demons ->                	
                    Demons
            end,
    case DM of 
        [] -> {false, [], get_demon_attr(DemonBaseId, true)};
        [{_, _, DD}]->
        	case lists:member(DemonBaseId, DD) of 
        		true -> true ;
        		false -> 
        			case DemonBaseId > 99999 of 
        				true ->
        					case lists:member(DemonBaseId - 100000, DD) of
        						true ->
									{false, DD, get_demon_attr(DemonBaseId, false)};
								false ->
									{false, DD, get_demon_attr(DemonBaseId, true)}
							end;
						false ->
							case lists:member(DemonBaseId + 100000, DD) of
								true ->
									true;
								false ->
									{false, DD, get_demon_attr(DemonBaseId, false)}
							end
					end
        	end
    end.

get_demon_attr(DemonBaseId, Advance) ->
	case {DemonBaseId > 99999, Advance} of 
    	{true, true} ->
    		NBaseId = DemonBaseId - 100000,
    		get_demon_effect(DemonBaseId) ++ get_demon_effect(NBaseId);
    	{true, false} ->
    		get_demon_effect(DemonBaseId);
    	{false, _} ->
    		get_demon_effect(DemonBaseId)
    end.
get_demon_effect(DemonBaseId) ->
	case demon_data2:get_demon_effect(DemonBaseId) of 
		DemonEffect when is_list(DemonEffect) andalso erlang:length(DemonEffect) > 0 ->
			DemonEffect;
		_ -> []
	end.


search_role_debris(Id, DebriId) ->
	gen_server:call(?MODULE, {search, Id, DebriId}).

get_all() ->
	ets:tab2list(role_debris).

get_all_demon() ->
	ets:tab2list(role_demon).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    ets:new(role_debris, [public, set, named_table, {keypos, 1}]),
    ets:new(role_demon, [public, set, named_table, {keypos, 1}]), %% 记录图鉴信息
    ets:new(role_grab, [public, set, named_table, {keypos, 1}]),

    process_flag(trap_exit, true), 
    case demon_dao:load_debris() of 
    	ok ->
    		case demon_dao:load_demon() of 
    			ok ->
			        erlang:send_after(?save_time, self(), save_debris),
			        erlang:send_after(?save_time + 50, self(), save_demon),
			        
			        erlang:send_after(util:unixtime({nexttime, 86405}) * 1000, self(), clear_role_grab_info),

				    ?INFO("[~w] 妖精碎片系统启动完成 !!", [?MODULE]),
				    {ok, #state{}};
				_ ->	
					?ERR("妖精碎片系统启动失败"),
					{stop, load_failure}
			end;
		_ ->
			?ERR("妖精碎片系统启动失败"),
			{stop, load_failure}
	end.

handle_call({get_role_debris, Rid}, _From, State) ->
	Reply = 
		case ets:lookup(role_debris, Rid) of 
			[{_, _, _, _, _, _, _, DD}]->
				DD;
			_ -> []
	    end,
    {reply, Reply, State};

 
handle_call({search, Id, DebriId}, _From, State) ->
	List = search(Id, DebriId),
	Length = erlang:length(List),
	Add = add_arena_career(Id, Length),
    {reply, Add ++ List, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%%----------------------------------------------------
%% handle_info
%%----------------------------------------------------
%% 定时保存数据
handle_info(save_debris, State) ->
    erlang:send_after(?save_time, self(), save_debris),
    spawn(
        fun() ->
            demon_dao:save_debris()
        end
    ),
    {noreply, State};

handle_info(save_demon, State) ->
    erlang:send_after(?save_time, self(), save_demon),
    spawn(
        fun() ->
            demon_dao:save_demon()
        end
    ),
    {noreply, State};

handle_info(clear_role_grab_info, State) ->
	ets:delete_all_objects(role_debris),
	erlang:send_after(util:unixtime({nexttime, 86405}) * 1000, self(), clear_role_grab_info),
    {noreply, State};

handle_info(_Request, State) ->
    {noreply, State}.


%%----------------------------------------------------
%% 系统关闭
%%----------------------------------------------------
terminate(_Reason, _State) ->
    demon_dao:save_debris(),
    demon_dao:save_demon(),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%---------------------------------------------------------
%% 内部函数
%%---------------------------------------------------------  
search(Id, DebriId) ->
	List = get_all(),
	get_contain(Id, DebriId, List, []).

get_contain(_Id, _DebriId, [], Return) -> Return;
get_contain(Id = {Rid, Srvid}, DebriId, [{Rid, Srvid, _, _, _, _, _, _}|T], Return) ->
	get_contain(Id, DebriId, T, Return);
get_contain(Id = {_Rid, Srvid}, DebriId, [{Rid, Srvid, Name, Lev, Sex, Career, FC, Debris}|T], Return) ->
	case lists:keyfind(DebriId, 1, Debris) of 
		{_, Val} when Val > 1 ->
			get_contain(Id, DebriId, T, [{?demon_challenge_type_real, Rid, Srvid, Name, Lev, Career, Sex, FC}|Return]); %% 1 表示普通玩家数据
		_ ->
			get_contain(Id, DebriId, T, Return)
	end;
get_contain(Id, DebriId, [_|T], Return) ->
	get_contain(Id, DebriId, T, Return).	

add_arena_career(Id, Length) ->
	AddData = 
		case Length > 30 of 
			true ->
				get_n_record_from_arena_career(Id, 20);
			false ->
				get_n_record_from_arena_career(Id, 50)
		end,
	deal_data_from_arena_career(AddData, []).

deal_data_from_arena_career([], Return) -> Return;
deal_data_from_arena_career([H|T], Return) ->
	{Rid, Srvid, Lev, Sex, Career, FC} = list_to_tuple(H),
	deal_data_from_arena_career(T, [{?demon_challenge_type_virtual, Rid, Srvid, get_rand_name(Sex), Lev, Career, Sex, FC}|Return]). %% 0表示从中庭战神来的数据

get_n_record_from_arena_career({Rid, SrvId}, N) ->
	Sql = <<"select rid, srv_id, lev, sex, career, fight_capacity from sys_arena_career where rank > (select rank from sys_arena_career where rid = ~s and srv_id = ~s )limit ~s">>,
	case db:get_all(Sql, [Rid, SrvId, N]) of
        {ok, Rows2} when is_list(Rows2) ->
            lists:reverse(Rows2);
        _Err ->
            ?ERR("查询出错,Reason:~w",[_Err]),
            null
    end.

get_rand_name(Sex) ->	
	{{Weight12, Texts12}, {Weight3, Texts3}, {Weight4, Texts4}} = 
	case Sex of 
		?female ->
			{demon_grab_name:get_boy1_2(), demon_grab_name:get_boy3(), demon_grab_name:get_boy4()};
		_ ->
			{demon_grab_name:get_girl1_2(), demon_grab_name:get_girl3(), demon_grab_name:get_girl4()}
	end,

	Length1 = erlang:length(Texts12),
	Rand12 = util:rand(1, 100),
	Name12 = 
		case Rand12 =< Weight12 of 
			true ->
				Nth12 = util:rand(1, Length1), 
				lists:nth(Nth12, Texts12);
			false -> ""
		end,

	Length3 = erlang:length(Texts3),
	Rand3 = util:rand(1, 100),
	Name3 = 
		case Rand3 =< Weight3 of 
			true ->
				Nth3 = util:rand(1, Length3),
				lists:nth(Nth3, Texts3);
			false -> ""
		end,

	Length4 = erlang:length(Texts4),
	Rand4 = util:rand(1, 100),
	Name4 = 
		case Rand4 =< Weight4 of 
			true ->
				Nth4 = util:rand(1, Length4),
				lists:nth(Nth4, Texts4);
			false -> ""
		end,

	list_to_binary(Name12 ++ Name3 ++ Name4).
