-module(leisure).
-export([
		to_leisure_object/1,
		calc_dmg/2,
		send_score_and_rewards/3,
		calc_leisure_award/3
		]).

-include("role.hrl").
-include("pos.hrl").
-include("combat.hrl").
-include("attr.hrl").
-include("common.hrl").
-include("dungeon.hrl").
-include("gain.hrl").
-include("leisure.hrl").


%% 推送通关评分奖励
send_score_and_rewards(DungeonRole = #dungeon_role{pid = Pid}, DungeonId, Result) ->
    NData = 
    	case get(combat2_goal_result) of 
    		undefined -> {0, 0, 0};
    		Data -> Data
    	end,
    % role:apply(async, Pid, {fun async_send_score_and_rewards/5, [DungeonRole, DungeonId, Result, {Npc_hp_left, Role_hp_left, Kill_npc}]}).
    role:apply(async, Pid, {fun async_send_score_and_rewards/5, [DungeonRole, DungeonId, Result, NData]}).

async_send_score_and_rewards(Role = #role{id = Rid, pid = Pid, dungeon = RoleDungeons}, #dungeon_role{
        star = Stars, goals = Goals}, DungeonId, Result, {Npc_hp_left, Role_hp_left, Kill_npc}) ->

    Npc_hl_goal = calc_cond_goal(npc_hp_left, Npc_hp_left, DungeonId),
    Role_hl_goal = calc_cond_goal(role_hp_left, Role_hp_left, DungeonId),
    Kill_npc_goal = calc_cond_goal(kill_npc, Kill_npc, DungeonId),

    {Coin, Exp, Stone, Attainment, Items} = 
    	case leisure_goals_data:get_reward(DungeonId, Goals) of 
    		[] ->
    			?DEBUG("查询休闲玩法奖励出错:~p~n~n~n~n", [Goals]),
    			?ERR("查询休闲玩法奖励出错"),
    			{0, 0, 0, 0, []};
    		{Coin1, Exp1, Stone1, Attainment1, Items1} ->
    			{Coin1, Exp1, Stone1, Attainment1, Items1}
    	end,

    Assets2 = calc_leisure_award(Role, DungeonId, Goals),

    %%获得奖励
    Role4 = case role_gain:do(Assets2, Role) of
        {ok, Role1} ->
        	log:log(log_coin, {<<"副本结算">>, <<"副本结算">>, Role, Role1}),
        	log:log(log_stone, {<<"副本结算">>, <<"副本结算">>, Role, Role1}),
            Role1;
        _ ->
            award:send(Rid, 104000, Assets2),
            Role
    end,

    Msg = {Result, Goals, Stars, Npc_hp_left, Npc_hl_goal, Role_hp_left, Role_hl_goal, Kill_npc, Kill_npc_goal, Coin, Exp, Stone, Attainment, to_proto(Items)},
    role:pack_send(Pid, 19893, Msg), %% 推送副本结算  Goal表示等级， Star表示星星数

    case dungeon_api:is_hard(DungeonId) of
        true ->
            %%通关后扣进入次数
            RoleDungeons2 = dungeon_type:add_enter_count(RoleDungeons, DungeonId, 1),
            {ok, Role4#role{dungeon = RoleDungeons2}};
        false ->
            {ok, Role4}
    end.


calc_leisure_award(Role, DungeonId, Goals) ->
	{Coin, Exp, Stone, Attainment, Items} = 
    	case leisure_goals_data:get_reward(DungeonId, Goals) of 
    		[] ->
    			?DEBUG("查询休闲玩法奖励出错:~p~n~n~n~n", [Goals]),
    			?ERR("查询休闲玩法奖励出错"),
    			{0, 0, 0, 0, []};
    		{Coin1, Exp1, Stone1, Attainment1, Items1} ->
    			{Coin1, Exp1, Stone1, Attainment1, Items1}
    	end,

    Assets = make_item_access(Items, []) ++ [
            #gain{label = exp, val = Exp},
            #gain{label = coin, val = Coin},
            #gain{label = stone, val = Stone},
            #gain{label = attainment, val = Attainment}
           ],

    Assets2 = dungeon_api:get_vip_rewards(Assets, Role),
    Assets2.



% 暴击的判断：								
								
% 			暴击-坚韧的3种情况					
								
% 		如果	Crit - Ten > 700					
% 		X=	700 + 100 * (Crit-Ten-700)/(Crit-Ten-700+1000)					
								
% 		如果	Crit - Ten < 100 					
% 		X=	100 - 100*(100-(Crit-Ten))/(100-(Crit-Ten)+1000)					
								
% 		其他情况						
% 		X=	Crit - Ten					
								
% 		暴击概率=X/1000						
								
% 		暴击效果：	暴击为1.5倍伤害					
								
% 格挡的判断：								
								
% 			 H1 = Evasion - (HitRate - SkHitRateReduce),
		    % H2 = case H1 >= 300 of
		    %     true ->
		    %         500 + 100 * 300 / H1;
		    %     false ->
		    %         900 - H1
		    % end,
% 		格挡效果：	格挡为0.5倍伤害					

%%计算怪蓄力的伤害值
% 基础伤害=（攻击)(1-防御/（防御+受击者等级*60+2000）)+绝对伤害						
calc_dmg(#fighter{type = ?fighter_type_npc, attr = #attr{hitrate = Hitrate, critrate = Crit, dmg_min = Dmg_min, dmg_max = Dmg_max, 
	dmg_magic = Dmg_magic}}, 
	[#fighter{type = ?fighter_type_role, lev = Lev, attr = #attr{tenacity = Ten, evasion = Evasion, defence = Defence}}]
	) ->

	BaseDmg = erlang:round((Dmg_min + Dmg_max)/2 * (1 - Defence/(Defence + Lev * 60 + 2000)) + Dmg_magic),
	{CritRatio, HitRatio, IsCrit} = get_crit_hit_ratio({Crit, Ten}, {Hitrate, Evasion}),
	Final = erlang:round(BaseDmg * CritRatio * HitRatio),
	?DEBUG("--怪蓄力的大小--~p~n~n~n", [Final]),
	{Final, IsCrit};

%%计算角色蓄力的伤害值
% 基础伤害=（攻击)(1-抗性/（抗性+受击者等级*60+2000）)+绝对伤害						

calc_dmg(#fighter{type = ?fighter_type_role, attr = #attr{hitrate = Hitrate, critrate = Crit, dmg_min = Dmg_min, dmg_max = Dmg_max, dmg_magic = Dmg_magic}},
	[#fighter{lev = Lev, attr = #attr{resist_metal = Resist, tenacity = Ten, evasion = Evasion}}]) ->

	BaseDmg = erlang:round((Dmg_min + Dmg_max)/2 * (1 - Resist/(Resist + Lev * 60 + 2000)) + Dmg_magic),
	?DEBUG("--人物蓄力的大小--BaseDmg--~p~n~n~n", [BaseDmg]),
	{CritRatio, HitRatio, IsCrit} = get_crit_hit_ratio({Crit, Ten}, {Hitrate, Evasion}),
	Final = erlang:round(BaseDmg * CritRatio * HitRatio),
	?DEBUG("--人物蓄力的大小--~p~n~n~n", [Final]),
	{Final, IsCrit};

calc_dmg(_, _) ->
	?DEBUG("--蓄力伤害值计算参数有误-"),
	{0, 0}.

%%获得暴击参数以及精准参数
get_crit_hit_ratio({Crit, Ten}, {Hitrate, Evasion}) ->
	XCrit = calc_critrate_ratio(Crit, Ten),
	{CritRatio, IsCrit} = 
		case util:rand(1, 1000) =< XCrit of
			true -> {1.5, 1};
			_ -> {1, 0}
		end,

	XHit = calc_hitrate_evasion(Hitrate, Evasion),
	{HitRatio, IsHit} = 	
		case util:rand(1, 1000) =< XHit of 
			true -> {1, 2};
			_ -> {0.5, 4}
		end,
	% 0:普通 1:暴击 2:格挡
	CheckNum = IsCrit + IsHit,
	IfCrit = 
		if 
			CheckNum =:= 2 ->
				0;
			CheckNum =:= 3 ->
				1;
			CheckNum =:= 4 ->
				2;
			CheckNum =:= 5 ->
				2;
			true ->
				0
		end,

	{CritRatio, HitRatio, IfCrit}.


%%参战者新属性的分配
to_leisure_object(Role) when is_record(Role, role) ->
    #role{lev = Lev, event_pid= DungeonPid} = Role,
    case dungeon:get_info(DungeonPid) of
        {ok, #dungeon{id = Id}} ->
		    case leisure_role_data:get_cond(Id) of 
		    	Cond when is_list(Cond) ->
		    		Sorted = lists:keysort(1, Cond),
		    		AttrId = check_cond(lists:reverse(Sorted), Lev),
		    		case leisure_role_data:get_attr(AttrId) of 
		    			{false, _} -> 
		    				false;
		    			{Hp, Attr} ->
		    				Role#role{hp = Hp, hp_max = Hp, attr = Attr}
		    		end;
		    	{false, Reason} ->
		    		notice:alert(error, Role, Reason),
		    		false
		    end;
		_ ->
			false
	end;
to_leisure_object(_) -> false.


%%-----------------------------------------------------------------------------
%% Internal fun
%%-----------------------------------------------------------------------------
%% 构造 #gain{label = item...}
make_item_access([], Ret) -> Ret;
make_item_access([[BaseId, Bind, Num]|T], Ret) ->
	Gain = #gain{label = item, val = [BaseId, Bind, Num]},
	make_item_access(T, [Gain|Ret]);
make_item_access([_|T], Ret) -> 
	make_item_access(T, Ret).


%%计算暴击概率
calc_critrate_ratio(Crit, Ten) ->
	case Crit - Ten > 700 of 
		true ->
			erlang:round(700 + 100 * (Crit - Ten - 700)/(Crit - Ten - 700 + 1000));
		false ->
			case Crit - Ten < 100 of 
				true ->
					erlang:round(100 - 100 * (100 - (Crit - Ten))/(100 - (Crit - Ten) + 1000));
				_ ->
					Crit - Ten
			end
	end.

%%计算精准概率
calc_hitrate_evasion(Hitrate, Evasion)->
	H1 = Evasion - Hitrate, 
    case  H1 >= 300 of
        true ->
            erlang:round(500 + 100 * 300 / H1);
        false ->
            900 - H1
    end.


%%计算副本结算中3个条件达到的评级
calc_cond_goal(Label, Cond, DungeonId) ->
	case get_leisure_goals(DungeonId) of 
		[] -> 0;
		LeisureGoals ->
			do_calc_cond_goal(Label, Cond, LeisureGoals)
	end.

%%计算副本结算中3个条件达到的评级
do_calc_cond_goal(_Label, _Cond, []) -> 0;

do_calc_cond_goal(npc_hp_left, Npc_hp_left, [H|T]) ->
	case Npc_hp_left =< H#leisure_goal.npc_hp_left of 
		true ->
			H#leisure_goal.id;
		false ->
			do_calc_cond_goal(npc_hp_left, Npc_hp_left, T)
	end;

do_calc_cond_goal(role_hp_left, Role_hp_left, [H|T]) ->	
	case Role_hp_left >= H#leisure_goal.role_hp_left of 
		true ->
			H#leisure_goal.id;
		false ->
			do_calc_cond_goal(role_hp_left, Role_hp_left, T)
	end;

% do_calc_cond_goal(round, Round, [H|T]) ->	
% 	case Round =< H#leisure_goal.round of 
% 		true ->
% 			H#leisure_goal.id;
% 		false ->
% 			do_calc_cond_goal(round, Round, T)
% 	end;

do_calc_cond_goal(kill_npc, Kill_npc, [H|T]) ->	
	case Kill_npc >= H#leisure_goal.kill_npc of 
		true ->
			H#leisure_goal.id;
		false ->
			do_calc_cond_goal(kill_npc, Kill_npc, T)
	end;

do_calc_cond_goal(_, _, _) -> 
	0.


%%根军副本id获取结算的条件
get_leisure_goals(DungeonId) ->
 	case leisure_goals_data:get(DungeonId) of
        undefined ->
            [];
        LeisureGoals ->
        	lists:reverse(lists:keysort(#leisure_goal.id, LeisureGoals)) %% 从高到低
    end.


check_cond([], _Lev) -> 0;
check_cond([{Min, Max, AttrId}|T], Lev) ->
	case Max =/= 0 of 
		false ->
			if 
				Lev >= Min ->
					AttrId;
				true ->
					check_cond(T, Lev)
			end;
		true ->
			case Min =< Lev andalso Lev =< Max of 
				true ->
					AttrId;
				false ->
					check_cond(T, Lev)
			end
	end.

%%将[[BaseId, Bind, Num]...]转化成[{BaseId, Bind, Num}...]
to_proto([]) -> [];
to_proto(Items) ->
	do_to_proto(Items, []).
do_to_proto([], Ret) -> Ret;
do_to_proto([H|T], Ret) ->
	H1 = list_to_tuple(H),
	do_to_proto(T, [H1|Ret]).

