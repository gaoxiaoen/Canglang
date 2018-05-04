%%---------------------------------------------
%% 竞技勋章
%% @author wangweibiao
%% @end
%%---------------------------------------------
-module(medal_compete).
-export([
		gm_set_win_die/3,
		gm_set_honor/2,
		calc/1,
		check_medal/3,
		puton/2,
		takeoff/2,
		exchange/2,
		push_compete_medal_info/2,
		login/1,
		add_compete_result/2,
		add_medal_attr/1,
		filter_expire_honor/1
		]).

-include("role.hrl").
-include("common.hrl").
-include("achievement.hrl").
-include("assets.hrl").
-include("link.hrl").
-include("condition.hrl").
-include("combat.hrl").
-include("gain.hrl").

% -define(effect_days, 30).
%% 查找称号的有效期
-define(effect_days(HonorId), medal_compete_data:get_honor_effect(HonorId)).

gm_set_honor(Role = #role{assets = Assets, medal = Medal = #medal{compete = Compete}}, Honor) ->
	NRole = Role#role{assets = Assets#assets{honor = Honor}, medal = Medal#medal{compete = Compete#medal_compete{wearid = 0, honors = [], medals = []}}},
	check_medal(NRole, compete_2v2, {1, 1}).

gm_set_win_die(Role = #role{medal = Medal = #medal{compete = Compete = #medal_compete{special = Special}}}, Win, Die) ->
	NSpecial_1 = 
		case get_statistic_info(compete_2v2, win, Special) of 
			0 ->
				[{compete_2v2, win, Win - 1}] ++ Special;
			N -> 
				Special1 = Special -- [{compete_2v2, win, N}],
				[{compete_2v2, win, Win - 1}] ++ Special1
				
		end,
	NSpecial_2 = 
		case get_statistic_info(compete_2v2, die, NSpecial_1) of 
			0 ->
				[{compete_2v2, die, Die - 1}] ++ NSpecial_1;
			N1 -> 
				Special_1 = NSpecial_1 -- [{compete_2v2, die, N1}],
				[{compete_2v2, die, Die - 1}] ++ Special_1
		end,

	NRole = Role#role{medal = Medal#medal{compete = Compete#medal_compete{special = NSpecial_2, wearid = 0, honors = [], medals = []}}},
	check_medal(NRole, compete_2v2, {1, 1}).


% @spec login(Role) -> Role|NRole
% @doc 登录时，检查已有的称号的有效期，去掉过期的，同时设置一个定时器，0时继续检查一遍
login(Role) ->
	Role1 = deal_offline_result(Role),
	NRole = do_filter_expire_honor(Role1, false),
	role_timer:set_timer(check_compete_honor, util:unixtime({nexttime, 86410}) * 1000, {?MODULE, filter_expire_honor, []}, 1, NRole).


add_medal_attr(Role = #role{medal = #medal{compete = #medal_compete{wearid = WearId}}}) -> 
	Attr2 = 
		case WearId =:= 0 of
			false ->
				medal_compete_data:get_honor_puton_attr(WearId);
			true -> []
		end,
	TAttr = role_attr:trans_atrrs(Attr2),
	case role_attr:do_attr(TAttr, Role) of
    	{ok, NRole} -> 
    		NRole;
    	_ ->
    		Role
    end;
add_medal_attr(Role) ->
	Role. 

% @spec calc(Role) -> Role|NRole
% @doc 计算竞技勋章带来的属性加成
calc(Role = #role{medal = #medal{compete = #medal_compete{wearid = _WearId, medals = Medals}}}) ->
	Attr = get_all_attr(Medals, []),
	% Attr2 = 
	% 			% medal_compete_data:get_honor_puton_attr(WearId),
	% 	case WearId =:= 0 of
	% 		false ->
	% 			medal_compete_data:get_honor_puton_attr(WearId);
	% 		true -> []
	% 	end,

	% TAttr = role_attr:trans_atrrs(Attr2 ++ Attr),
	TAttr = role_attr:trans_atrrs(Attr),
    case role_attr:do_attr(TAttr, Role) of
    	{ok, NRole} -> 
    		NRole;
    	_ ->
    		Role
    end.

% @sepc puton(Role, HonorId) -> {ok, NewRole}|{false, Reason}
% @spec MedalId :: integer()
% @doc 佩戴竞技勋章称号
puton(Role = #role{special = Special, medal = Medal = #medal{compete = Compete = #medal_compete{wearid = WearId, honors = Honors}}}, HonorId) ->
	case WearId =:= HonorId of
		true -> {false, ?MSGID(<<"已经佩戴该称号">>)};
		false ->
			case lists:keyfind(HonorId, 1, Honors) of 
				{_, StartTime} ->
					Now = util:unixtime(),
					case (?effect_days(HonorId) - util:day_diff(Now, StartTime)) > 0 of 
						true ->
							Special1 = lists:keydelete(?special_compete_medal, 1, Special), 
							NSpecial = [{?special_compete_medal, HonorId, <<>>}] ++ Special1,

							NRole = Role#role{medal = Medal#medal{compete = Compete#medal_compete{wearid = HonorId}}, special = NSpecial},
							NRole1 = role_api:push_attr(NRole),
							% demon_api:refresh_role_special(NRole),
							map:role_update(NRole1),
							{ok, NRole1};
						false ->
							{false, ?MSGID(<<"称号已过期">>)}
					end;		
				false ->
					{false, ?MSGID(<<"尚未获得该称号">>)}
			end
	end.

% @sepc takeoff(Role, HonorId) -> {ok, NewRole}|{false, Reason}
% @spec MedalId :: integer()
% @doc 取消佩戴竞技勋章称号
takeoff(Role = #role{special = Special, medal = Medal = #medal{compete = Compete = #medal_compete{wearid = WearId}}}, HonorId) ->
	case WearId =:= HonorId of
		false -> {false, ?MSGID(<<"尚未佩戴该称号">>)};
		true ->			
			NSpecial = Special -- [{?special_compete_medal, HonorId, <<>>}],
			NRole = Role#role{medal = Medal#medal{compete = Compete#medal_compete{wearid = 0}}, special = NSpecial},
			NRole1 = role_api:push_attr(NRole),
			% demon_api:refresh_role_special(NRole),
			map:role_update(NRole1),
			{ok, NRole1}
	end.

% @spec exchange(HonorId, Role) ->{ok, NRole} | {false, Res}
% @spec HonorId :: integer()
% @spec Role :: #role{}
% @doc 使用纹章兑换	称号
exchange(HonorId, Role = #role{medal = Medal = #medal{compete = Compete = #medal_compete{medals = Medals, honors = Honors}}}) ->
	case lists:keyfind(HonorId, 1, Honors) of
		{_, _} ->
			{false, ?MSGID(<<"已获得该称号">>)};
		false ->
			NeedBadge = medal_compete_data:get_honor_badge(HonorId),
			case lists:member(HonorId, Medals) of 
				false ->
					{false, ?MSGID(<<"未激活相应的勋章, 无法兑换">>)};
				true ->
					case role_gain:do([#loss{label = badge, val = NeedBadge, msg = ?MSGID(<<"纹章不足, 无法兑换">>)}], Role) of
						{false, #loss{msg = Msg}} ->
							{false, Msg};
						{ok, NRole} ->
							NHonors = [{HonorId, util:unixtime()}] ++ Honors,
							NRole1 = NRole#role{medal = Medal#medal{compete = Compete#medal_compete{honors = NHonors}}},
							% deal_gain_honor_attr(NRole1, HonorId),
							% push_compete_medal_info(NRole1, true),
							{ok, NRole1}
					end
			end
	end.

% @spec check_medal(Role, Type, {Result, IsDie}) -> NewRole
% @spec Type :: atom, 战斗类型 compete_2v2
% @spec Result ::atom, win | loss | die 战斗结果 
% @doc 竞技勋章刷新
check_medal(Role = #role{medal = Medal = #medal{compete = Compete = #medal_compete{medals = Medals, special = Special}}, assets = #assets{honor = 
	Honor}}, Type, {Result, IsDie}) ->

	{Value1, NSpecial} = calc_combat_result(Role, Type, Result, Special), %%统计战斗结果

	{Value2, NSpecial_1} = calc_combat_IsDie(Type, IsDie, NSpecial), %% 统计死亡次数

	AllCondition = medal_compete_data:get_all_condition(),

	NMedals_1 = check_new_medals(Value1, Type, win, Medals, AllCondition),

	NMedals_2 = check_new_medals(Value2, Type, die, NMedals_1 ++ Medals, AllCondition),

	MayNMedals3 = check_condition(honor, 0, Honor, AllCondition), %% 检查荣誉值
	NMedals_30 = MayNMedals3 -- Medals,  %% 获得新的勋章 竞技荣誉值 

	NMedals_3 = NMedals_30 -- NMedals_2,

	NMedals = NMedals_1 ++ NMedals_2 ++ NMedals_3,
	
	% Role1 = deal_gain_medal_attr(Role, NMedals),
	Role1 = 
	case erlang:length(NMedals) > 0 of
		true ->
			NRole = Role#role{medal = Medal#medal{compete = Compete#medal_compete{medals = NMedals ++ Medals, special = NSpecial_1}}},
			push_compete_medal_info(NRole, true),
			NRole;
		false ->
			NRole = Role#role{medal = Medal#medal{compete = Compete#medal_compete{special = NSpecial_1}}},
			push_compete_medal_info(NRole, false),
			NRole
	end,
	role_api:push_attr(Role1).

%% 推送竞技勋章的信息
push_compete_medal_info(_Role = #role{link = #link{conn_pid = ConnPid}, assets = #assets{honor = Honor},
		medal = #medal{compete = #medal_compete{wearid = WearId, medals = Medals, honors = Honors, special = Special}}}, true) ->
	
	Now = util:unixtime(),
	
	AllHonors = [{HonorId, ?effect_days(HonorId) - util:day_diff(Now, StartTime)}||{HonorId, StartTime} <- Honors, 
					(?effect_days(HonorId) - util:day_diff(Now, StartTime)) > 0],
	
	AllWin = get_from_special(compete_2v2, win, Special),
	AllDie = get_from_special(compete_2v2, die, Special),

	sys_conn:pack_send(ConnPid, 13080, {WearId, Honor, Medals, AllHonors, AllWin, AllDie});
									%% 荣誉值， 纹章值， 勋章列表， 称号列表， 总的胜利次数，总的死亡次数 

push_compete_medal_info(_Role = #role{link = #link{conn_pid = ConnPid}, assets = #assets{honor = Honor},
		medal = #medal{compete = #medal_compete{special = Special}}}, false) ->
	
	AllWin = get_from_special(compete_2v2, win, Special),
	AllDie = get_from_special(compete_2v2, die, Special),

	sys_conn:pack_send(ConnPid, 13083, {Honor, AllWin, AllDie});

push_compete_medal_info(_, _) -> ok.

%% @spec add_compete_result(Rid, {Result, IsDie}) -> ok | ignore
%% @doc 添加离线竞技结算结果
add_compete_result({Rid, _Srvid}, Data) ->
	Sql = "replace into sys_compete_result (rid, val) values(~s, ~s)",
    db:execute(Sql, [Rid, util:term_to_string(Data)]);

add_compete_result(_Rid, {_CombatResult, _IsDie}) ->
	?ERR(<<"角色ID有问题，ID:~w~n">>, _Rid),
	ignore.

%%----------------------------------------------------------------------------------------------------
%% internal api
%%----------------------------------------------------------------------------------------------------
%% 处理离线的结果
deal_offline_result(Role = #role{id = {Rid, _}}) ->
	case get_data_from_database(Rid) of 
		false -> 
			?DEBUG("没有离线结果~n~n"),
			Role;
		{CombatResult, IsDie} ->
			?DEBUG("离线结果~p,~p~n~n", [CombatResult, IsDie]),
			del_offline_result(Rid),
			check_medal(Role, compete_2v2, {CombatResult, IsDie});
		Data ->
			?ERR("匹配竞技离线结果格式有误, ~w", Data),
			Role
	end.

get_data_from_database(Rid) ->
 	Sql = "select val from sys_compete_result where rid = ~s",
    case db:get_all(Sql, [Rid]) of
        {ok, Data} ->
            do_format(to_compete_result, Data);
        {error, undefined} -> 
            false;
        _ ->
            false
    end.

%% 执行数据转换
do_format(to_compete_result, []) -> false;
do_format(to_compete_result, [[Data] | _]) ->
	{ok, Data1} = util:bitstring_to_term(Data),
	Data1.
	% Data.

del_offline_result(Rid)->
	Sql = "delete from sys_compete_result where rid = ~s",
    db:execute(Sql, [Rid]).

%% 定时器回调
filter_expire_honor(Role) ->
	NRole = do_filter_expire_honor(Role, true),
	{ok, role_timer:set_timer(check_compete_honor1, util:unixtime({nexttime, 86410}) * 1000, {?MODULE, filter_expire_honor, []}, day_check, NRole)}.


get_from_special(Type, Label, Special) ->
	Search = [Value||{Type1, Label1, Value} <- Special, Type1 == Type, Label1 == Label],
	case erlang:length(Search) > 0 of 
		true ->
			[Return|_] = Search,
			Return;
		false ->
			0
	end.

check_new_medals(NValue, Type, Label, OLdMedals, Conditions) ->
	case NValue =:= 0 of 
		false ->
			MayNMedals = check_condition(Type, Label, NValue, Conditions),
			MayNMedals -- OLdMedals; %% 获得新的勋章
		true -> []
	end.

%% 检查统计战斗输赢	
calc_combat_result(_Role, Type, Result, Special) ->
	case Result of 
		?combat_result_win ->
			% random_award:competitive_win(Role),
			case get_statistic_info(Type, win, Special) of 
				0 ->
					Special1 = [{Type, win, 1}] ++ Special,
					{1, Special1};
				N -> 
					Special1 = Special -- [{Type, win, N}],
					Special2 = [{Type, win, N + 1}] ++ Special1, 
					{N + 1, Special2}
			end;
		_ -> %% 战斗失败不需要统计条件
			% random_award:competitive_loss(Role),
			{0, Special}
	end.

%% 检查统计死亡次数
calc_combat_IsDie(Type, IsDie, Special) ->
	case IsDie of
		?true ->
			case get_statistic_info(Type, die, Special) of 
				0 ->
					Special1 = [{Type, die, 1}] ++ Special,
					{1, Special1};
				N -> 
					Special1 = Special -- [{Type, die, N}],
					Special2 = [{Type, die, N + 1}] ++ Special1, 
					{N + 1, Special2}
			end;
		_ -> %% 战斗失败不需要统计条件
			{0, Special}
	end.

get_statistic_info(_Type, _Result, []) -> 0;
get_statistic_info(_Type, _Result, [{_Type, _Result, Times}|_]) -> Times;
get_statistic_info(Type, Result, [{_Type, _Result, _}|T]) ->
	get_statistic_info(Type, Result, T).


check_condition(Label, Target, Target_Val, Conditions) ->
	do_check_condition(Label, Target, Target_Val, Conditions, []).

do_check_condition(_Label, _Target, _Target_Val, [], Return) -> Return;

do_check_condition(Label, Target, Target_Val, [#condition{code = Code, label = Label, target = Target, target_value = TargetVal}|T], Return)
	when Target_Val >= TargetVal ->
	case medal_compete_data:get_medal(Code) of 
		{ok, #compete_medal{id = Id}}->
			do_check_condition(Label, Target, Target_Val, T, [Id|Return]);
		_ ->
			?ERR("找不到竞技勋章信息~n~n"),
			do_check_condition(Label, Target, Target_Val, T, Return)
	end;

do_check_condition(Label, Target, Target_Val, [#condition{label = _Label, target = _Target}|T], Return)->
	do_check_condition(Label, Target, Target_Val, T, Return).

get_all_attr([], Return) -> Return;
get_all_attr([Medal_id|T], Return) ->
    {ok, #compete_medal{attr = Attr}} = medal_compete_data:get_medal(Medal_id),
    get_all_attr(T, Attr ++ Return).

%% 过滤过期的称号
do_filter_expire_honor(Role = #role{medal = Medal = #medal{compete = Compete = #medal_compete{honors = Honors}}}, If_Refresh) ->
	Now = util:unixtime(),
	NHonors = [{HonorId, StartTime}||{HonorId, StartTime} <- Honors, (?effect_days(HonorId) - util:day_diff(Now, StartTime)) > 0],
	NRole = Role#role{medal = Medal#medal{compete = Compete#medal_compete{honors = NHonors}}},
	case If_Refresh andalso erlang:length(Honors -- NHonors) > 0 of
		true ->
			role_api:push_attr(NRole);
		false -> NRole
	end.
