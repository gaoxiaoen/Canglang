%%----------------------------------------------------
%% 奇遇事件 
%%
%% @author wangweibiao
%%----------------------------------------------------
-module(adventure).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([start_link/0]).

-export([

		trigger_adventure/4,
		get_role_holes/1,
		update_role_holes/2,
		adventure/2,
		gain_reward/2,
		pack/2,
		login/1
	]).

-include("common.hrl").
-include("gain.hrl").
-include("role.hrl").
-include("link.hrl").
-include("award.hrl").
-include("dungeon.hrl").
-include("pet.hrl").

-record(state, {}).

-define(Expire, 30 * 60). %% 10分钟

login(Role = #role{id = Id, pid = Pid}) ->
	Holes = get_role_holes(Id),
	Now = util:unixtime(),
	Holes1 = [Hole||Hole = #adventure_event{expire = Expire} <- Holes, Expire > Now],
	case erlang:length(Holes1) > 0 of 
		true -> 
			role:pack_send(Pid, 14010, {pack(14010, Holes1)});
		_ -> ignore
	end,
	update_role_holes(Id, Holes1),
	% case util:is_same_day2(LastLogout, Now) of 
 %        false -> %% 不是同一天，清空上次的事件
 %        	update_role_today_holes(Id, []);
 %        true -> %%是同一天则跳过
 %        	ignore
 %    end,
    Role.
   %%设置定时器 24点清空当天的事件
 	% role_timer:set_timer(delete_role_todayholes, util:unixtime({nexttime, 86408}) * 1000, {adventure, delete_role_today_holes, []}, 1, Role).

%% 触发一次奇遇事件
%% @spec IsFirst 是否首次通关
%% @spec IfClear 是否为扫荡
trigger_adventure(#role{pet = #pet_bag{active = undefined}}, _, _, _) ->
	ok;
trigger_adventure(Role, DungeonId, IsFirst, IfClear) ->
	?DEBUG("----trigger_adventure--~p, ~p~n", [DungeonId, IsFirst]),
	case IsFirst of 
		?true -> %% 是首次通关 
			case adventure_event_data:get(DungeonId) of 
				#adventure_dungeon{must = Must} -> 
					case Must of 
						?true -> %% 推送一次事件，并添加到角色事件列表ets and db
							add_hole(must, Role, DungeonId, IfClear);
						?false -> %% 不是必须的就根据概率来了
							ignore
					end;
				_ -> ignore
			end;
		?false -> %%不是首次通关则判断是否已经通关过
			case check_has_cleared(DungeonId, Role) of
				true -> %% 已经通关过了，则判断是否达到今日限制次数
					case check_if_limit(DungeonId, Role) of 
						false -> 
							add_hole(rand, Role, DungeonId, IfClear);
						true -> ignore
					end;
				false -> %% 没有通关过，直接跳过
					ignore
			end
	end,
	ok.

%% 获取角色已有的奇遇事件
%% @spec Id :: {Rid, Srvid} 下同
get_role_holes(Id) ->
	case ets:lookup(adventure_role_holes, Id) of 
        [] -> [];
        [{_, Data}|_] -> 
        	Data
    end.

%% 更新角色事件
update_role_holes(Id, NewHoles) ->
	ets:delete(adventure_role_holes, Id),
    ets:insert(adventure_role_holes, {Id, NewHoles}).

%% 前往
%% Id表示洞穴(事件)序号
adventure({Id, HoleId}, #role{id = RId}) ->
	Holes = get_role_holes(RId),
	Now = util:unixtime(),
	Filter = [AE||AE = #adventure_event{id = I, hole_id = Hole_Id, expire = Expire} <- Holes, Expire > Now, Id =:= I, HoleId =:= Hole_Id],
	case erlang:length(Filter) > 0 of 
		true ->
			case adventure_event_data:get_hole(HoleId) of 
				AH = #adventure_hole{} -> 
					AccountNum = get_account_num(AH#adventure_hole.account_num),
					RandAward = rand_adventure_award(AccountNum, AH),
					put(adventure_reward, RandAward),
					put(adventure_hole_sid, Id),
					delete_hole(Id, RId),
					{AccountNum, RandAward};
				_ -> 
					{0, []}
			end;
		false -> 
			{0, []}
	end.

%% 洞穴序号id, 遭遇第几件事
gain_reward({Id, EncountId}, Role = #role{id = RId}) ->
	Award = 
		case get(adventure_hole_sid) of 
			SId when is_integer(SId) -> 
				case SId =:= Id of 
					true -> 
						case get(adventure_reward) of 
							Data when is_list(Data) -> 
								case lists:keyfind(EncountId, 1, Data) of 
									{_, _, _, Label, BaseId, Num} -> 
										put(adventure_reward, lists:keydelete(EncountId, 1, Data)),
											
										{Label, BaseId, Num};
									_ -> ignore
								end;
							_ -> ignore
						end;
					false ->  ignore
				end;
			_ -> ignore
		end,
	case Award of 
		{Label1, BaseId1, Num1} ->
			Gain = 
				case Label1 of 
					item -> [#gain{label = item ,val = [BaseId1, 1, Num1]}]; 
					L when L == coin orelse L == gold_bind orelse L == stone -> [#gain{label = Label1, val = Num1}];
					_ -> []
				end,
			case role_gain:do(Gain, Role) of 
		        {ok, NewRole} ->
		        	{?true, NewRole};
		        {false, _} ->
		        	award:send(RId, 207000, Gain),
		        	{?true, Role}
    		end;
		_ -> {?false, Role}  
	end.

pack(14010, Data) ->
	Now = util:unixtime(),
	[{Id, Hold_Id, Expire - Now}||#adventure_event{id = Id, hole_id = Hold_Id, expire = Expire} <- Data, Expire > Now];

pack(14013, {EncountNum, Data}) ->
	Proto = [{Count, H, Mode, to_int(Label), BaseId, Num}||{Count, H, Mode, Label, BaseId, Num}<-Data],
	{EncountNum, Proto};

pack(_, _) -> 
	ok.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).	

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ets:new(adventure_today_holes, [public, set, named_table, {keypos, 1}]),
    ets:new(adventure_role_holes, [public, set, named_table, {keypos, 1}]),

    erlang:send_after(util:unixtime({nexttime, 86400}) * 1000, self(), clear_today_holes),

    ?INFO("[~w] 奇遇事件系统启动完成 !!", [?MODULE]),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Data, State) ->
	{noreply, State}.

handle_info(clear_today_holes, State) ->
	ets:delete_all_objects(adventure_today_holes),
    {noreply, State};
handle_info(_Data, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    {noreply, _State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 查询今日触发过的事件
get_role_today_holes({Rid, Srvid}) ->
    case ets:lookup(adventure_today_holes, {Rid, Srvid}) of 
        [] -> [];
        [{_, Data}|_] -> Data
    end.

add_hole(must, Role = #role{id = Id}, DungeonId, IfClear) -> %% 
	case adventure_event_data:get(DungeonId) of 
		#adventure_dungeon{hole_id = HoleId} ->
				add_hole_role(Id, HoleId, Role, IfClear),
				add_hole_today(Id, DungeonId);
		_ -> ignore
	end;

add_hole(Type, Role = #role{id = Id}, DungeonId, IfClear) -> %% 
	case adventure_event_data:get(DungeonId) of 
		AD = #adventure_dungeon{hole_id = HoleId} ->
			RandWeight = get_rand_weight(Type),
			ConfigWeigt = get_config_weight(IfClear, AD),
			case RandWeight =< ConfigWeigt of 
				true -> %% 添加一次事件，推送出去
					add_hole_role(Id, HoleId, Role, IfClear),
					add_hole_today(Id, DungeonId);
				false -> 
					ignore
			end;
		_ -> ignore
	end.

get_rand_weight(must) -> 100;
get_rand_weight(rand) -> util:rand(1, 100);
get_rand_weight(_) -> 0.

get_config_weight(?true, AD) -> AD#adventure_dungeon.clear_weight; %% 扫荡
get_config_weight(?false, AD) -> AD#adventure_dungeon.hole_weight; %% 非扫荡
get_config_weight(_, _) -> 0.

add_hole_role(Id, HoleId, #role{id = Id, pid = Pid}, IfClear) ->
	OldHoles = get_role_holes(Id),
	Now = util:unixtime(),
	OldHoles1 = [Hole||Hole = #adventure_event{expire = Expire}<-OldHoles, Expire > Now],
	{MaxId, IfHas} = 
		case erlang:length(OldHoles1) > 0 of
			true ->
				Ids = [I||#adventure_event{id = I} <- OldHoles1],
				{lists:max(Ids) + 1, true};
			false -> {1, false}
		end,
	NAHole = #adventure_event{id = MaxId, hole_id = HoleId, expire = Now + ?Expire},
	NewHoles = [NAHole] ++ OldHoles1,
	update_role_holes(Id, NewHoles),
	case IfClear of 
		?false -> 
			%% 推送新的事件
			role:pack_send(Pid, 14012, {MaxId, HoleId, ?Expire}),
			ok;
		_ ->  %% 如果当前一个事件都没有，还是需要推送
			case IfHas of
				true -> ignore;
				false -> role:pack_send(Pid, 14012, {MaxId, HoleId, ?Expire})
			end
	end,
	ok.

add_hole_today(Id, DungeonId) ->
	TodayHoles = get_role_today_holes(Id),
	NewTodayHs = 
		case lists:keyfind(DungeonId, 1, TodayHoles) of 
			{DungeonId, Num} ->
				NewTodayHs1 = lists:keydelete(DungeonId, 1, TodayHoles),
				[{DungeonId, Num + 1}] ++ NewTodayHs1;
			false -> 
				[{DungeonId, 1}] ++ TodayHoles
		end,
	update_role_today_holes(Id, NewTodayHs),
	ok.

update_role_today_holes(Id, NewTodayHs) -> 
	ets:delete(adventure_today_holes, Id),
    ets:insert(adventure_today_holes, {Id, NewTodayHs}).


check_has_cleared(DungeonId, #role{dungeon = RoleDungeons}) -> 
    case lists:keyfind(DungeonId, #role_dungeon.id, RoleDungeons) of
        #role_dungeon{clear_count = ClearCount} when ClearCount > 0 ->
            true;
        _ -> false
    end.

check_if_limit(DungeonId, #role{id = Id}) -> 
	TodayHoles = get_role_today_holes(Id),
	case adventure_event_data:get(DungeonId) of 
		#adventure_dungeon{max = Max} when Max > 0-> 
			case lists:keyfind(DungeonId, 1, TodayHoles) of 
				{DungeonId, Num} ->
					if Num >= Max -> true; true -> false end; 
				false -> false
			end;
		_ -> true
	end.

%% 根据序号删除角色洞穴
delete_hole(Id, RId) ->
	Holes = get_role_holes(RId),
	Nholes = lists:keydelete(Id, #adventure_event.id, Holes),
	update_role_holes(RId, Nholes).

get_account_num({Min, Max}) -> 
	case Max =:= 0 of
		true -> 0;
		false -> 
			case Max =< Min of 
				true -> 
					Max;
				false -> 
					util:rand(Min, Max)
			end
	end.

rand_adventure_award(AccountNum, _AH = #adventure_hole{barrier_wei = BW, barrier_awd = BA, npc_wei = NW, npc_awd = NA, 
		item_wei = IW, item_awd = IA, box_wei = BoW, box_awd = BoA, box_max = BMax}) ->
		
		WeightSum = BW + NW + IW + BoW,
		WL = [BW, NW, IW, BoW],
		RandHoles = rand_holes(AccountNum, WeightSum, WL, BMax),
		RandHoles1 = make_least_one_box(RandHoles),
		?DEBUG("--RandHoles--~p~n~n", [RandHoles1]),
		AL = [BA, NA, IA, BoA],
		rand_awards(RandHoles1, AL, 1, []).

make_least_one_box([]) -> [];
make_least_one_box(RandHoles) -> 
	case lists:member(4, RandHoles) of 
		true -> 
			RandHoles;
		false -> 
			Length = erlang:length(RandHoles),
			RandNth = util:rand(1, Length),
			{P1, P2} = lists:split(RandNth, RandHoles),
			NP1 = lists:sublist(P1, erlang:length(P1) - 1),
			NP1 ++ [4] ++ P2
	end.

rand_awards([], _AL, _Count, Return) -> lists:keysort(1, Return);
rand_awards([H|T], AL, Count, Return) ->
	HAward = lists:nth(H, AL),
	{_, Mode, Label, BaseId, Num} = rand_event_award(HAward),
	rand_awards(T, AL, Count + 1, [{Count, H, Mode, Label, BaseId, Num}] ++ Return).

rand_event_award(HAward) -> 
	WL = [Weight||{Weight, _, _, _, _} <- HAward],
	WeightSum = lists:sum(WL),
	Rand = util:rand(1, WeightSum),
	Nth = calc_nth(Rand, WL, 1),
	lists:nth(Nth, HAward).


rand_holes(AccountNum, WeightSum, WL, BMax) ->
	do_rand_holes(AccountNum, WeightSum, WL, BMax, 0, []).

do_rand_holes(0, _WeightSum, _WL, _BMax, _BoxT, Return) -> Return; 
do_rand_holes(Times, WeightSum, WL, BMax, BoxT, Return) -> 
	Rand = util:rand(1, WeightSum),
	N = calc_nth(Rand, WL, 1),
	?DEBUG("--rand_events---~p~n", [N]),
	case N =:= 4 andalso BMax =< BoxT of  %% 4 表示宝箱， 若有添加其他类型的遭遇事件，需要调整
		true ->
			do_rand_holes(Times, WeightSum, WL, BMax, BoxT, Return);
		false ->
			if
				N =:= 4 ->
					do_rand_holes(Times - 1, WeightSum, WL, BMax, BoxT + 1, [N] ++ Return);	
				true ->
					do_rand_holes(Times - 1, WeightSum, WL, BMax, BoxT, [N] ++ Return)
			end
	end.

calc_nth(_Rand, [], N) -> N;
calc_nth(Rand, [H|T], N) ->
	case  Rand - H =< 0 of
		true ->
			N;
		false ->
			calc_nth(Rand - H, T, N + 1)
	end.

to_int(gold_bind) 	-> 2;
to_int(coin) 		-> 3;
to_int(item) 		-> 11;
to_int(stone) 		-> 12;
to_int(_) 			-> 0.
