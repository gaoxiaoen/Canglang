%%----------------------------------------------------
%% 勋章管理
%% @author bwang
%%----------------------------------------------------

-module(medal_mgr).
-behaviour(gen_server).
-export([
		start_link/0,
		get_cur_medal_cond/1,
		update_cur_medal_cond/2,
		get_all/0,
        update_top_n_medal/2,
        get_top_n_medal/0,
        load_top_n_medal/1
		]).



-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
    }).

-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("gain.hrl").
-include("link.hrl").
-include ("achievement.hrl").


%%更新角色当前修炼勋章的条件    
update_cur_medal_cond(Rid, Condition) ->
     ets:delete(medal_condition, Rid),
     ets:insert(medal_condition, {Rid, lists:reverse(Condition)}).

%%获取当前修炼勋章条件的数据 
get_cur_medal_cond(#role{id = {Rid, _}, career = Career}) ->
    case ets:lookup(medal_condition, Rid) of 
        [] ->
            Cond2 = init_medal_cond(Career),
            update_cur_medal_cond(Rid, Cond2),
            Cond2;
        [{_, NCond2}|_]->
            format_to_record_list(NCond2)
    end.

get_all() ->
	ets:tab2list(medal_condition).

%%获取前5个勋章
%% 勋章排行只保存最新的数据到数据库，服务器重启时不论是否过12时，都显示最新的数据，服务器正常运行时每天中午12时更新
get_top_n_medal() ->
    case ets:lookup(medal_rank, new) of 
        [] -> [];
        [{new, Data}] -> Data
    end.

%%更新最高级的5个勋章，提供荣耀学院首页用
update_top_n_medal(#role{id = {Rid, Srvid}, name = Name, career = Career, sex = Sex, looks = Looks, attr = #attr{fight_capacity = FC}}, MedalId) -> 

    [{new, Data}] = ets:lookup(medal_rank, new),

    NData = case lists:keyfind(Rid, 1, Data) of 
                false ->
                    Data ++ [{Rid, Srvid, Name, MedalId, FC, Career, Sex, Looks}];
                _ ->
                    lists:keydelete(Rid, 1, Data) ++ [{Rid, Srvid, Name, MedalId, FC, Career, Sex, Looks}]
            end,
    update_medal_rank(NData).

update_medal_rank(NData) ->
    NData2 = [{M, F, Name2}||{_, _, Name2, M, F,_, _, _}<-NData],
    NewData = lists:sort(NData2),
    NewData2 = lists:sublist(lists:reverse(NewData), 5),
    
    Fun = fun({_, _, N3}, Sum) ->
            case lists:keyfind(N3, 3, NData) of 
                false -> Sum;
                D -> 
                    [D|Sum]
            end
        end,
    ND = lists:foldl(Fun, [], NewData2),
    ets:delete(medal_rank, new),
    ets:insert(medal_rank, {new, ND}).


load_top_n_medal(Data) ->
    ets:delete(medal_rank, new),
    ets:insert(medal_rank, {new, Data}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    ets:new(medal_condition, [public, set, named_table, {keypos, 1}]),
    ets:new(medal_rank, [public, set, named_table, {keypos, 1}]),
    ets:insert(medal_rank, {new, []}),
    process_flag(trap_exit, true), 
    case medal_dao:load_cond() of 
    	ok ->
            case medal_dao:load_rank() of 
                ok ->
                    erlang:send_after(600000, self(), save_cond),
                    erlang:send_after(610000, self(), save_rank),
            		
        		    ?INFO("[~w] 勋章系统启动完成 !!", [?MODULE]),
        		    {ok, #state{}};
                _ ->
                    ?ERR("勋章系统启动失败"),
                    {stop, load_failure}
            end;    
		_ ->
			?ERR("勋章系统启动失败"),
			{stop, load_failure}
	end.
    
handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

%%----------------------------------------------------
%% handle_info
%%----------------------------------------------------

%%由rank.erl发过来的更新信息
handle_info({update_role, Rid, Srvid, FC}, State) ->
    ?DEBUG("--Rid-:~p Srvid:~p FC:~p~n~n~n", [Rid, Srvid, FC]),
    [{new, Data}] = ets:lookup(medal_rank, new),
    case lists:keyfind(Rid, 1, Data) of 
        {Rid, Srvid, A, MedalId, FC1, B, C, D, E} when FC =/= FC1 ->
            NData1 = lists:keydelete(Rid, 1, Data),
            NData2 = [{Rid, Srvid, A, MedalId, FC, B, C, D, E}] ++ NData1,
            update_medal_rank(NData2);
        _ ->
            ok
    end,
    {noreply, State};

%%定时保存前5个勋章的排行
handle_info(save_rank, State) ->
    
    erlang:send_after(610000, self(), save_rank),
    spawn(
        fun() ->
                medal_dao:save_rank()
        end
    ),
    {noreply, State};

%% 定时保存数据
handle_info(save_cond, State) ->
	
    erlang:send_after(600000, self(), save_cond),
    spawn(
        fun() ->
                medal_dao:save_cond()
        end
    ),
    {noreply, State};

handle_info(_Request, State) ->
    {noreply, State}.


%%----------------------------------------------------
%% 系统关闭
%%----------------------------------------------------
terminate(_Reason, _State) ->
    medal_dao:save_cond(),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%---------------------------------------------------------
%% 内部函数
%%---------------------------------------------------------
format_to_record_list(Data) ->
	do_format(Data, []).

do_format([],L) ->L;
do_format([{medal_cond, Id, Label, Target, Value, Rep, Stone, Need, Cur}|Data], L) ->
	Medal_Cond = #medal_cond{id = Id, label = Label,target = Target, target_value = Value, rep = Rep, stone = Stone, need_value = Need, cur_value = Cur},
	do_format(Data, [Medal_Cond|L]).

%% 初始化玩家正在修炼的勋章的条件
init_medal_cond(Career) ->
	medal:get_init_medal_cond(Career).
