-module(medal).
-export([
		parse/1,
		get_attr_all/1,
		listener/3,
		listener/2,
		listener_special/2,
		listener_special/3,
		get_init_medal_cond/1,
		get_first/2,
		login/1,
		calc/1,
		medal_callback/2,
		make_cond/2,
		kill_super_boss/2,
		kill_npc_pirate/2,
		join_activity/2,
		check_next/1,
		% fix_when_necessery/2,
		gm_set/2,
		set_nth/2,
		get_init_cond/0,
		get_finish_cond/0,
		fix/1
		]).

-include("achievement.hrl").
-include("role.hrl").
-include("link.hrl").
-include("common.hrl").
-include("skill.hrl").
-include("sns.hrl").
-include("assets.hrl").
-include("pet.hrl").
-include("attr.hrl").
-include("item.hrl").
-include("channel.hrl").
-include("arena_career.hrl").
-include("tree.hrl").
-include("demon.hrl").
-include("manor.hrl").
-include("gain.hrl").

%%每次新增一种监听类型时都要考虑是否需要加到以下的define中

%%!!!!
%% eg: 下面这个例子，monster只是聚集了妖精类的条件，实际上在medal_data中的勋章的条件是不会出现的，
% 		这时候加到common_cond应该是monster_lv !!!!!
% listener(monster, Role) -> 
% 	Role1 = listener(monster_lv, Role),
% 	Role1;

%%%%

-define(common_cond, [suit, suit_armor, suit_armor2, suit_arms, suit_jewelry, suit_jewelry2, c_suit, s_suit, bs_suit, all_bs_suit, bs3_suit, bslv_suit,
					 all_3bs_suit, qh, qh_suit, all_qh_suit, jd_suit, jd_suit2, divine, divine_2, divine_3, skill, dragon_bone, coin, wing, 
					 legion_lv, fight_capacity, dragon_fight_capacity, dragon_level, level, drug, monster_lv]).

-define(pet_cond, [dragon_skill, dragon_skill_low, dragon_skill_mid, dragon_skill_high, dragon_skill_low2, dragon_skill_mid2, dragon_skill_high2]).


%% 版本转化 
parse({medal, Wearid, Cur_medal_id, Cur_rep, Need_rep, Gain, Condition, Pass}) ->
	{medal, Wearid, Cur_medal_id, Cur_rep, Need_rep, Gain, Condition, Pass, #medal_compete{}};
parse({medal, Wearid, Cur_medal_id, Cur_rep, Need_rep, Gain, Condition, Pass, Compete}) ->
	{medal, Wearid, Cur_medal_id, Cur_rep, Need_rep, Gain, Condition, Pass, Compete}.

%%登录
login(Role = #role{medal = undefined}) ->
	{ok, #medal_base{need_rep = Need_rep}} = medal_data:get_medal_base(?init_medal),
	Medal = #medal{cur_medal_id = ?init_medal, cur_rep = 0, need_rep = Need_rep, gain = [], condition = get_init_cond()},			
	NR 	  = Role#role{medal = Medal},
	NR;

login(Role = #role{medal = Medal}) when is_record(Medal, medal) ->
	% 同步最新配置
	sync_newest_cond(Role),
	%%　新配置重新check各个条件
	Role1 = check_next(Role),

	NRole1 = fix(Role1),

	#role{special = Special, medal = #medal{gain = Gain, condition = Cond, compete = #medal_compete{wearid = WearId}}} = NRole1,

	Loc = get_first(Cond, ?status_unclaimed),
	Num = [1 ||{St, _} <- Cond, St =:= ?status_unclaimed],
	case  Loc > ?condition_num of 
        true -> ok;
        false ->
        	push_notice(Role1, {Loc, erlang:length(Num)})
	end,

	NRole = #role{special = NSpecial} =
		case WearId of 
			0 -> NRole1;
			_ ->
				NRole1#role{special = [{?special_compete_medal, WearId, <<>>}] ++ Special}
		end,

	case lists:sort(Gain) of 
		[] ->
			NRole;
		List ->
			MedalId = lists:last(List),
			NRole#role{special = [{?special_medal, MedalId, <<>>}] ++ NSpecial}
	end.

%%%2014/9/10 测试完删除以下代码 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fix(Role = #role{id = {Rid, _}, career = Career, medal = Medal = #medal{cur_medal_id = Cur_medal_id, cur_rep = Cur_rep, gain = Gain}}) ->
    case Cur_medal_id =:= 10003 andalso Cur_rep =:= 1175 of 
        true ->
        	{ok, #medal_base{next_id = Next}} = medal_data:get_medal_base(Cur_medal_id),

            Role1 = role_listener:special_event(Role, {1062, Cur_medal_id}), %% 获得一块勋章
            Role2 = manor:fire(Cur_medal_id, Role1),

            log:log(log_medal, {<<"获得勋章">>, Cur_medal_id, Role2}),

            {ok, #medal_base{need_rep = Need2, condition = NCondition}} = medal_data:get_medal_base(Next), %%获得勋章
                
            NMedal = Medal#medal{wearid = Cur_medal_id, cur_medal_id = Next, cur_rep = 0, need_rep = Need2, gain = Gain ++ [Cur_medal_id], condition = medal:get_init_cond()},
            NCondition1 = medal:make_cond(Career, NCondition),
            medal_mgr:update_cur_medal_cond(Rid, NCondition1),
            NRole0 = Role2#role{medal = NMedal},
            NR = add_attr_role(NRole0, Cur_medal_id), %% 获取加成属性,更新Role
            % medal_mgr:update_top_n_medal(NR, Cur_medal_id),
            NR3 = medal:check_next(NR),
            NR3;
        false -> 
        	Role
    end.
add_attr_role(Role, Medal_id) ->
    case medal_data:get_medal_special(Medal_id) of 
        {false, _} ->
            Role;
        {ok, #medal_special{attr = Attr}} ->
            {ok, NRole} = role_attr:do_attr(Attr, Role),
            % role_api:push_attr(NRole),
            NRole
    end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% GM快速完成当前勋章的某一个条件
gm_set(Pid, N) when is_pid(Pid) andalso N > 0 andalso N =< 12 ->
	role:apply(async, Pid, {medal, set_nth, [N]});
gm_set({RoleId, SrvId}, N) when N > 0 andalso N =< 12 ->
	case role_api:lookup(by_id, {RoleId, SrvId}, #role.pid) of %%检查是否在线,在线则发送消息通知
        {ok, _, Pid} when is_pid(Pid)  ->
            role:apply(async, Pid, {medal, set_nth, [N]}),
            ok;
        _ ->
            ok
    end;
 gm_set(_, _) ->
 	ok.
set_nth(Role = #role{medal = _Medal = #medal{cur_medal_id = Cur_medal_id, condition = _Cond}}, N) ->
	CondProgress = medal_mgr:get_cur_medal_cond(Role), %%[{lable,target,target_value,rep}...]
	{ok, #medal_base{condition = Conditions}} = medal_data:get_medal_base(Cur_medal_id),
	CurCond = #medal_cond{need_value = Need} = lists:keyfind(N, #medal_cond.id, Conditions),

	% case lists:keyfind(N, #medal_cond.id, CondProgress) of 
	% 	CurCond = #medal_cond{id = N, need_value = Need} when is_record(CurCond, medal_cond) ->
			{ok, update_cond_unclaimed(Need, CondProgress, CurCond, Role)}.
	% 	_ -> {ok, Role}
	% end.
	% {L1, L2} = lists:split(N, Cond),
	% NL1 = lists:sublist(L1, N - 1),
	% NCond = NL1 ++ [{?status_unclaimed,}] ++ L2,
	% Num1 = [1 ||St <- NCond, St =:= ?status_unclaimed],
	% push_notice(Role, {N, erlang:length(Num1)}),
	% NRole = Role#role{medal = Medal#medal{condition = NCond}},
	% {ok, NRole}.


%%修复role回写失败，friend条件丢失的bug，2次封测结束可考虑去掉
% fix_when_necessery(Role = #role{medal = undefined}, friend) ->
% 	Role;
% fix_when_necessery(Role = #role{medal = Medal = #medal{cur_medal_id = Cur_medal_id, condition = Cond}}, friend) ->
% 	{ok, #medal_base{condition = CondBase}} = medal_data:get_medal_base(Cur_medal_id),
% 	case lists:keyfind(friend, #medal_cond.label, CondBase) of 
% 		M = #medal_cond{id = Id, target_value = Cond_Num} when is_record(M, medal_cond) ->
% 			Friends = friend:get_friend_list(),
% 			List_hy = [F || F = #friend{type = Type_hy} <- Friends, Type_hy == ?sns_friend_type_hy],
% 			Num 	= erlang:length(List_hy),
% 			case Num >= Cond_Num of 
% 				true ->
% 					case lists:nth(Id, Cond) of 
% 						?status_unfinish -> %%已经达到条件， 但是有标识为未完成的
% 							{L1, L2} = lists:split(Id, Cond),
% 							NL1 	 = lists:sublist(L1, Id - 1),
% 							NCond 	 = NL1 ++ [{?status_unclaimed, Cond_Num}] ++ L2,
% 							Num1 	 = [1 ||{St, _} <- NCond, St =:= ?status_unclaimed],
% 							push_notice(Role, {Id, erlang:length(Num1)}),
% 							Role#role{medal = Medal#medal{condition = NCond}};
% 						_ -> 
% 							Role
% 					end;
% 				_ -> 
% 					Role
% 			end;
% 		_ -> 
% 			Role
% 	end.							

get_init_cond() ->
    [{3, 0}, {3, 0}, {3, 0}, {3, 0}, {3, 0}, {3, 0}, {3, 0}, {3, 0}, {3, 0}, {3, 0}, {3, 0}, {3, 0}].

get_finish_cond() ->
    [{1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}, {1, 0}].

%%获得勋章时马上检查下一个勋章能完成的条件
%% check_next(#role{}) -> #role{}
check_next(Role = #role{medal = #medal{}}) ->
	MCond  = medal_mgr:get_cur_medal_cond(Role),
	Labels = [Label||#medal_cond{label = Label} <- MCond],
	do_check_next(Labels, Role).

do_check_next([], Role) -> Role;
do_check_next([Label|T], Role = #role{id = Rid, dungeon_map = DM}) -> 
	NRole = 
		case lists:member(Label, ?common_cond) of 
			true ->
				listener(Label, Role);
			false ->
				case lists:member(Label, ?pet_cond) of 
					true ->
						listener(pet_skill, Role);
					false ->
						case Label of 
							friend ->
								{ok, R}	= listener(Role, friend),
								R;
							tree_climb ->
								#tree_role{floor = Floor} = tree_api:get_tree_role(Rid),
								listener(tree_climb, Role, Floor);
							item -> 
								deal_item_cond(Role);
							dungeon_star ->
								Blue = [B||{_, B, _, _, _, _} <- DM],
								compare(dungeon_star, Role, lists:sum(Blue));
							dungeon_hardstar ->
								Purple = [P||{_, _, P, _, _, _} <- DM], 
								compare(dungeon_hardstar, Role, lists:sum(Purple));
							monsters_contract ->
								deal_monsters_contract(Role);
							_ ->
								Role
						end
				end
		end,
	do_check_next(T, NRole).

deal_monsters_contract(Role = #role{id = {Rid, _}}) ->
	?DEBUG("处理妖精图鉴！！！~n~n~n~n"),
	AllDemonBaseIds = demon_debris_mgr:get_role_demon(Rid),
	UUIDS = [check_uuid(BaseId, AllDemonBaseIds)||BaseId <- AllDemonBaseIds],
	accumulate(monsters_contract, Role, 0, lists:sum(UUIDS)).

check_uuid(BaseId, List) ->
	case BaseId > 99999 of 
		true -> 
			case lists:member(BaseId - 100000, List) of
				true -> 
					0;
				false ->
                   1
            end;
        false ->
        	case lists:member(BaseId + 100000, List) of
				true -> 
					0;
				false ->
                    1
            end
    end.

deal_item_cond(Role = #role{career = Career}) ->
	MCond 	  = medal_mgr:get_cur_medal_cond(Role),
	Condition = lists:keyfind(item, #medal_cond.label, MCond),
	Nth 	  = 
        if 
            Career =:= ?career_cike ->
                1;
            Career =:= ?career_xianzhe ->
                2;
            true ->
                3
        end,
	Target = lists:nth(Nth, Condition#medal_cond.target),
	Value  = storage:count(Role#role.bag, Target),
	listener(item, Role, {Target, Value}).

%%coin call back
medal_callback(Role, _Coin) ->
	listener(coin, Role).

%% 获取勋章总加成属性
get_attr_all(Gain) ->
	do_get_attr_all(Gain, []).

%% 获取第一个状态为status的条件
get_first([], _Status) -> 0;
get_first(Condition, Status) ->
    do_get_first(Condition, Status, 1).

do_get_first([], _Status, N) -> N;
do_get_first([{Status, _}|_Condition], Status, N) -> N;
do_get_first([{_St, _}|Condition], Status, N) ->
    do_get_first(Condition, Status, N + 1).


%%计算已有的勋章带来的属性加成
calc(Role = #role{medal = undefined}) -> Role;
calc(Role = #role{medal = #medal{gain = Gain}}) ->
	Add_Attr = get_attr_all(Gain),
	case role_attr:do_attr(Add_Attr, Role) of 
		{ok, NRole} ->
			NRole;
		{false, _} ->
			Role
	end.


% -define(career_cike, 2).     %% 刺客
% -define(career_xianzhe, 3).     %% 贤者
% -define(career_qishi, 5).     %% 骑士
%%根据职业构造勋章条件
make_cond(Career, Condition) ->
    ItemCond = [Cond||Cond = #medal_cond{label = item} <- Condition],
    case erlang:length(ItemCond) of 
        0 ->
            Condition;
        _ ->    
            Nth = 
                if 
                    Career =:= ?career_cike ->
                        1;
                    Career =:= ?career_xianzhe ->
                        2;
                    true ->
                        3
                end,
            NItemCond  = [Cond#medal_cond{target = lists:nth(Nth, ItemList)}||Cond = #medal_cond{target = ItemList} <- ItemCond],
            NCondition = Condition -- ItemCond,
            NItemCond ++ NCondition
    end. 

%%各种参加:世界boss,世界树，击杀海盗
join_activity(Role, Label) ->
	NR = listener({king, Label}, Role),
	{ok, NR}.

%%击杀世界boss call_back
kill_super_boss(Role, Boss_id) ->
	NRole = listener_special({hit_dragon_boss, Boss_id}, Role),
	{ok, NRole}.

%%击杀npc海盗 call_back
kill_npc_pirate(Role, Boss_id) ->
	NRole = listener_special({kill_pirate, Boss_id}, Role),
	{ok, NRole}.

%--------------------------------------------------------------------------------------------
% 条件监听接口
%--------------------------------------------------------------------------------------------

%%监听装备的变化,升级，颜色变化，穿戴
% {suit，40,1，100}：表示获得xx级以上的全套什么颜色以上套装，级数，123456表示绿蓝紫粉橙金，获得声望	 ok
% {suit_armor，40,1，100}：表示获得xx级以上的什么颜色以上全部6件防具，级数，123456表示绿蓝紫粉橙金，获得声望 ok
% {suit_arms，40,1，100}：表示获得xx级以上的什么颜色以上1件武器，级数，123456表示绿蓝紫粉橙金，获得声望	 ok
% {suit_jewelry，40,1，100}：表示获得xx级以上的什么颜色以上全部3件首饰，级数，123456表示绿蓝紫粉橙金，获得声望 ok
% {c_suit,2,1,100}:表示有几件xx颜色的装备，123456表示绿蓝紫粉橙金，几件，获得声望 ok
% {s_suit,40,1,100}:表示获得任意一件xx级数、xx颜色的装备，级数，123456表示绿蓝紫粉橙金，获得声望  ok
listener(eqm, Role) ->
	Role1 = listener(suit, Role),
	Role2 = listener(suit_armor, Role1),
	Role3 = listener(suit_arms, Role2),
	Role4 = listener(suit_jewelry, Role3),
	Role5 = listener(c_suit, Role4),
	Role6 = listener(s_suit, Role5),

	random_award:suit(Role6),
	random_award:suit_armor(Role6),
	random_award:suit_arms(Role6),
	random_award:suit_jewelry(Role6),
	random_award:c_suit(Role6),
	random_award:s_suit(Role6),

	Role7 = listener(suit_armor2, Role6),
	Role8 = listener(suit_jewelry2, Role7),
	Role8;

%%监听装备的变化，宝石镶嵌
% {bs_suit,1,1,100}:表示任意一件装备镶嵌一颗多少级的什么宝石，宝石属性（见右边），宝石等级，获得声望 1生命宝石	2防御宝石	3闪避宝石	4精准宝石	5韧性宝石	6敏捷宝石	7攻击宝石	8暴怒宝石	
%{all_bs_suit,0,1,100}:表示全装备镶嵌多少级以上的宝石，0没意义，宝石等级，获得声望
%{bs3_suit, 0,1,100}:表示任意一件装备镶嵌三颗多少级以上的宝石，0无意义，宝石等级，获得声望
% {all_3bs_suit,0,1,100}:表示全身装备都镶嵌三颗多少级以上的宝石，0没意义，宝石等级，获得声望	
%%{bslv_suit,2,5,100,20} 表示当前装备镶嵌了多少个多少级以上的宝石 ，等级， 数量
listener(bs_eqm, Role) ->
	Role1 = listener(bs_suit, Role),
	Role2 = listener(all_bs_suit, Role1),
	Role3 = listener(bs3_suit, Role2),
	Role4 = listener(all_3bs_suit, Role3),
	Role5 = listener(bslv_suit, Role4),

	random_award:bs_suit(Role5),

	Role5;

%%监听装备强化的变化
% {qh_suit,1,1,100}:表示多少件装备强化到多少，装备数量，强化到多少，获得声望
% {all_qh_suit,0,1,100}:表示所有装备强化到多少以上，0无意义，强化到多少以上，获得声望
listener(enchant, Role) ->
	Role1 = listener(qh_suit, Role),
	Role2 = listener(all_qh_suit, Role1),
	random_award:qh_suit(Role1),
	Role2;

% {jd_suit,0,5,100}:表示当前装备总鉴定了几次，阶数，星数，获得声望
listener(jd_suit, Role = #role{eqm = Eqm}) ->
	NList = [N||#item{wash_cnt = N} <- Eqm],
	All   = lists:sum(NList),
	random_award:jd_suit(Role),
	compare(jd_suit, Role, All);

% {jd_suit,0,5,100}:表示有X件装备鉴定分数在Y以上，Y，X，获得声望
listener(jd_suit2, Role = #role{eqm = Eqm}) ->
	case check_current_condition(Role, jd_suit2) of 
		{Target, _Value} ->
			{ok, Cur_Value} = check_jdsuit_score(Eqm, Target),
			compare(jd_suit2, Role, Cur_Value);
		_ -> 
			Role
	end;

%% 监听人物神觉
% {divine_2, 2, 5, 100}，表示人物多少个属性的神觉达到多少等级，神觉等级，多少个属性，获得声望	
% {divine, 1, 2, 100}，表示人物神觉等级，12345678代表神觉属性（见右边），神觉等级，获得声望	1抗性、2精准、3防御、4攻击、5生命、6格挡、7坚韧、8暴怒
% {divine_2, 2, 5, 100}，表示人物多少个属性的神觉强化加了多少，神觉数量，强化加了多少，获得声望	
listener(divine2, Role) ->
	Role1 = listener(divine, Role),
	Role2 = listener(divine_2, Role1),
	Role2;

% {suit, 40, 1, 100}:表示获得xx级以上的全套什么颜色以上套装，级数，123456表示绿蓝紫粉橙金，获得声望	 
listener(suit, Role = #role{eqm = Eqm}) ->
	case check_current_condition(Role, suit) of 
		{Target, Value} ->
			{ok, Cur_Value} = check_lev_quanlity(Eqm, ?enchant_type, Target, Value),
			compare(suit, Role, Cur_Value);
		_ -> 
			Role
	end;

% {suit_armor, 40, 1, 100}:表示获得xx级以上的什么颜色以上全部6件防具，级数，123456表示绿蓝紫粉橙金，获得声望
listener(suit_armor, Role = #role{eqm = Eqm}) ->
	case check_current_condition(Role, suit_armor) of 
		{Target, Value} ->
			{ok, Cur_Value} = check_lev_quanlity(Eqm, ?armor, Target, Value),
			compare(suit_armor, Role, Cur_Value);
		_ -> 
			Role
	end;

% {suit_armor2,X,Y,100,20}：表示获得Y件X级以上防具
listener(suit_armor2, Role = #role{eqm = Eqm}) ->
	case check_current_condition(Role, suit_armor2) of 
		{Target, _} ->
			{ok, Cur_Value} = check_suit_lev_num(Eqm, ?armor, Target),
			compare(suit_armor2, Role, Cur_Value);
		_ -> 
			Role
	end;


% {suit_arms, 40, 1, 100}:表示获得xx级以上的什么颜色以上1件武器，级数，123456表示绿蓝紫粉橙金，获得声望	
listener(suit_arms, Role = #role{eqm = Eqm}) ->
	case check_current_condition(Role, suit_arms) of 
		{Target, Value} ->
			{ok, Cur_Value} = check_lev_quanlity(Eqm, ?eqm, Target, Value),
			compare(suit_arms, Role, Cur_Value);
		_ -> 
			Role
	end;

% {suit_jewelry, 40, 1, 100}:表示获得xx级以上的什么颜色以上全部3件首饰，级数，123456表示绿蓝紫粉橙金，获得声望
listener(suit_jewelry, Role = #role{eqm = Eqm}) ->
	case check_current_condition(Role, suit_jewelry) of 
		{Target, Value} ->
			{ok, Cur_Value} = check_lev_quanlity(Eqm, ?jewelry, Target, Value),
			compare(suit_jewelry, Role, Cur_Value);
		_ -> 
			Role
	end;

% {suit_jewelry2,X,Y,100,20}：表示获得Y件X级以上饰品
listener(suit_jewelry2, Role = #role{eqm = Eqm}) ->
	case check_current_condition(Role, suit_jewelry2) of 
		{Target, _} ->
			{ok, Cur_Value} = check_suit_lev_num(Eqm, ?jewelry, Target),
			compare(suit_jewelry2, Role, Cur_Value);
		_ -> 
			Role
	end;

% {c_suit, 2, 1, 100}:表示有几件xx颜色的装备，123456表示绿蓝紫粉橙金，几件，获得声望
listener(c_suit, Role = #role{eqm = Eqm}) ->
	case check_current_condition(Role, c_suit) of 
		{Target, _Value} ->
			{ok, Cur_Value} = check_num_quanlity(Eqm, Target), %%Value件Target颜色(品质) 
			compare(c_suit, Role, Cur_Value);
		_ -> 
			Role
	end;


% {s_suit, 40, 1, 100}:表示获得任意一件xx级数、xx颜色的装备，级数，123456表示绿蓝紫粉橙金，获得声望 
listener(s_suit, Role = #role{eqm = Eqm}) ->	
	case check_current_condition(Role, s_suit) of 
		{Target, Value} ->
			{ok, Cur_Value} = check_lev_quanlity(Eqm, ?enchant_type, Target, Value), 
			compare(s_suit, Role, Cur_Value);
		_ -> 
			Role
	end;

% {qh_suit, 1, 1, 100}:表示多少件装备强化到多少，装备数量，强化到多少，获得声望
listener(qh_suit, Role = #role{eqm = Eqm}) ->	
	case check_current_condition(Role, qh_suit) of 
		{_Target, Value} ->
			{ok, Cur_Value} = check_num_enchant(Eqm, Value), %%Target表示装备数量，Value表示强化等级
			compare(qh_suit, Role, Cur_Value);
		_ -> 
			Role
	end;

% {all_qh_suit, 0, 1, 100}:表示所有装备强化到多少以上，0无意义，强化到多少以上，获得声望
listener(all_qh_suit, Role = #role{eqm = Eqm}) ->	
	case check_current_condition(Role, all_qh_suit) of 
		{_Target, Value} ->
			{ok, Cur_Value} = check_num_enchant(Eqm, Value), %% Value表示强化的等级
			compare(all_qh_suit, Role, Cur_Value);
		_ -> 
			Role
	end;

% {bs_suit, 1, 1, 100}:表示任意一件装备镶嵌一颗多少级的什么宝石，宝石属性（见右边），宝石等级，获得声望 1生命宝石	2防御宝石	3闪避宝石	4精准宝石	5韧性宝石	6敏捷宝石	7攻击宝石	8暴怒宝石
listener(bs_suit, Role = #role{eqm = Eqm}) ->	
	case check_current_condition(Role, bs_suit) of 
		{Target, Value} ->
			{ok, Cur_Value} = check_lev_bs(Eqm, Target, Value), %%Target表示等级，Value表示属性
			compare(bs_suit, Role, Cur_Value);
		_ -> 
			Role
	end;

%{all_bs_suit, 0, 1, 100}:表示全装备镶嵌多少级以上的宝石，0没意义，宝石等级，获得声望
listener(all_bs_suit, Role = #role{eqm = Eqm}) ->
	case check_current_condition(Role, all_bs_suit) of 
		{_Target, Value} ->
			{ok, Cur_Value} = check_lev_bs_all(Eqm, Value, 10),
			compare(all_bs_suit, Role, Cur_Value);
		_ -> 
			Role
	end;

%%{bslv_suit,2,5,100,20} 表示当前装备镶嵌了多少个多少级以上的宝石 ，等级， 数量
listener(bslv_suit, Role = #role{eqm = Eqm}) ->
	case check_current_condition(Role, bslv_suit) of 
		{Target, _Value} ->
			{ok, Cur_Value} = check_lev_num(Eqm, Target), %%Target 表示等级， Value 表示数量 
			compare(bslv_suit, Role, Cur_Value);
		_ -> 
			Role
	end;
		
%{bs3_suit, 0, 1, 100}:表示任意一件装备镶嵌三颗多少级以上的宝石，0无意义，宝石等级，获得声望
listener(bs3_suit, Role = #role{eqm = Eqm}) ->
	case check_current_condition(Role, bs3_suit) of 
		{_Target, Value} ->
			{ok, Cur_Value} = check_lev_bs_num(Eqm, Value, 3),
			compare(bs3_suit, Role, Cur_Value);
		_ -> 
			Role
	end;

% {all_3bs_suit, 0, 1, 100}:表示全身装备都镶嵌三颗多少级以上的宝石，0没意义，宝石等级，获得声望
listener(all_3bs_suit, Role = #role{eqm = Eqm}) ->	
	case check_current_condition(Role, all_3bs_suit) of 
		{_Target, Value} ->
			{ok, Cur_Value} = check_lev_bs_num_all(Eqm, Value, 3), %% Value表示等级,0表示属性不做要求
			compare(all_3bs_suit, Role, Cur_Value);
		_ -> 
			Role
	end;

% {skill, 1, 1, 100}：表示人物有多少个技能升到几级，技能等级，技能数，获得声望 ok
listener(skill, Role = #role{skill = #skill_all{skill_list = Skill}}) ->
	case check_current_condition(Role, skill) of 
		{Target, _} ->
			{ok, Cur_value} = check_lev_skill(Skill, Target), %% Target表示等级， Value表示数量
			compare(skill, Role, Cur_value);
		_ -> 
			Role
	end;

% {divine, 1, 2, 100}，表示人物神觉等级，12345678代表神觉属性（见右边），神觉等级，获得声望	1抗性、2精准、3防御、4攻击、5生命、6格挡、7坚韧、8暴怒
listener(divine, Role = #role{channels = Channels}) ->
	case check_current_condition(Role, divine) of 
		{Target, Value} ->
			{ok, Cur_Value} = check_lev_channel(Channels, Target, Value), %% Target表示属性， Value表示等级
			compare(divine, Role, Cur_Value);
		_ -> 
			Role
	end;

% {divine_2, 2, 5, 100}，表示人物多少个属性的神觉达到多少等级，神觉等级，多少个属性，获得声望	
listener(divine_2, Role = #role{channels = Channels}) ->
	case check_current_condition(Role, divine_2) of 
		{Target, _Value} ->
			{ok, Cur_Value} = check_lev_channels(Channels, Target), %% Target表示等级， Value表示数量
			compare(divine_2, Role, Cur_Value);
		_ -> 
			Role
	end;

% #medal_cond{id = 9, label = divine_3, target = 10, target_value = 8, rep = 400, stone = 20},
% {divine_2, 2, 5, 100}，表示人物多少个属性的神觉强化加了多少，神觉数量，强化加了多少，获得声望	
listener(divine_3, Role = #role{channels = Channels}) ->
	case check_current_condition(Role, divine_3) of 
		{Target, _Value} ->
			{ok, Cur_Value} = check_attr_channels(Channels, Target), %% Target表示强化多少， Value表示数量
			compare(divine_3, Role, Cur_Value);
		_ -> 
			Role
	end;

%-------------------------------------------------------------------------------------
%	非累计类型监听，值的大小的比较
%	只需比较值是否达到条件
%-------------------------------------------------------------------------------------
%%宠物技能的统计 ok
% {dragon_skill, 1, 1, 100}：表示宠物有多少个技能升到几级，技能等级，技能数，获得声望
% {dragon_skill_low, 0, 1, 100}：表示宠物有多少个低阶技能，0无意义，技能数，获得声望	
% {dragon_skill_mid, 0, 1, 100}：表示宠物有多少个中阶技能，0无意义，技能数，获得声望
% {dragon_skill_high, 0, 1, 100}：表示宠物有多少个高阶技能，0无意义，技能数，获得声望
listener(pet_skill, Role = #role{pet = #pet_bag{active = undefined}}) ->
	Role;
listener(pet_skill, Role = #role{pet = #pet_bag{active = #pet{skill = Skill}}}) ->
	List = [ID div 100 ||{ID, _, _, _} <- Skill],
	Low  = [L||L<-List, L rem 10 == 1], 
	Mid  = [L||L<-List, L rem 10 == 2], 
	High = [L||L<-List, L rem 10 == 3],

	case erlang:length(High) > 0 of  %%具有高阶技能时尝试名人榜
		true ->
			Highest = lists:max([ID1 rem 10 ||{ID1, _, _, _}<-Skill, ID1 div 100 rem 10 == 3]),
			rank_celebrity:listener(dragon_skill_high, Role, Highest);
		_ -> skip
	end,

	LLow  = erlang:length(Low),
	LMid  = erlang:length(Mid),
	LHigh = erlang:length(High),

	Role1 = compare(dragon_skill_low, Role, LLow),	%%低阶个数
	Role2 = compare(dragon_skill_mid, Role1, LMid),	%%中阶个数
	Role3 = compare(dragon_skill_high, Role2, LHigh),	%%高阶个数
	Role4 = listener(dragon_skill, Role3),	%%有多少个技能升到几级

	Role5 = listener(dragon_skill_low2, Role4),	 %%有多少个低阶技能达到多少级	
	Role6 = listener(dragon_skill_mid2, Role5),	 %%有多少个低阶技能达到多少级
	Role7 = listener(dragon_skill_high2, Role6), %%有多少个低阶技能达到多少级

	random_award:dragon_skill_low(Role7, LLow),
	random_award:dragon_skill_mid(Role7, LMid),
	random_award:dragon_skill_high(Role7, LHigh),

	Role7;

listener(dragon_skill, Role = #role{pet = #pet_bag{active = undefined}}) ->
	Role;
listener(dragon_skill, Role = #role{pet = #pet_bag{active = #pet{skill = Skill}}}) ->
	case check_current_condition(Role, dragon_skill) of 
		{Target, _} ->
			{ok, Cur_Value} = check_lev_skill_num(Skill, Target),
			compare(dragon_skill, Role, Cur_Value);
		_ -> Role
	end;

listener(dragon_skill_low2, Role = #role{pet = #pet_bag{active = undefined}}) ->
	Role;
listener(dragon_skill_low2, Role = #role{pet = #pet_bag{active = #pet{skill = Skill}}}) ->	 %%有多少个低阶技能达到多少级	
	case check_current_condition(Role, dragon_skill_low2) of 
		{Target, _} ->
			{ok, Cur_Value} = check_step_skill_num(low, Skill, Target),
			compare(dragon_skill_low2, Role, Cur_Value);
		_ -> Role
	end;

listener(dragon_skill_mid2, Role = #role{pet = #pet_bag{active = undefined}}) ->
	Role;
listener(dragon_skill_mid2, Role = #role{pet = #pet_bag{active = #pet{skill = Skill}}}) ->	 %%有多少个低阶技能达到多少级
	case check_current_condition(Role, dragon_skill_mid2) of 
		{Target, _} ->
			{ok, Cur_Value} = check_step_skill_num(mid, Skill, Target),
			compare(dragon_skill_mid2, Role, Cur_Value);
		_ -> Role
	end;

listener(dragon_skill_high2, Role = #role{pet = #pet_bag{active = undefined}}) ->
	Role;
listener(dragon_skill_high2, Role = #role{pet = #pet_bag{active = #pet{skill = Skill}}}) -> %%有多少个低阶技能达到多少级
	case check_current_condition(Role, dragon_skill_high2) of 
		{Target, _} ->
			{ok, Cur_Value} = check_step_skill_num(high, Skill, Target),
			compare(dragon_skill_high2, Role, Cur_Value);
		_ -> Role
	end;


% {dragon_bone, 0, 480, 100}:表示宠物根骨，0无意义，根骨平均数值，获得声望 ok
listener(dragon_bone, Role = #role{pet = #pet_bag{active = undefined}}) ->
	Role;
listener(dragon_bone, Role = #role{pet = #pet_bag{active = Pet}}) ->
	
	Avg = pet_attr:calc_avg_potential(Pet),
	random_award:dragon_bone(Role, Avg),
	rank_celebrity:listener(dragon_bone, Role, Avg), %% 宠物潜力名人榜尝试上榜
	compare(dragon_bone, Role, Avg);

% {coin, 0, 12323, 100}:身上有多少金币，0无意义，金币数，获得声望
listener(coin, Role = #role{assets = #assets{coin = Coin}}) ->
	
	compare(coin, Role, Coin);						

% {wing, 0, 12323, 100}:身上有多少晶钻，0无意义，晶钻数，获得声望
listener(wing, Role = #role{assets = #assets{gold = Gold}}) ->
	
	compare(wing, Role, Gold);						

% {friend, 0, 12, 100}:拥有多少位好友，0无意义，数量，获得声望 ok
listener(Role, friend) ->
	Friends = friend:get_friend_list(),
    List_hy = [F || F = #friend{type = Type_hy} <- Friends, Type_hy == ?sns_friend_type_hy],
    random_award:friend(Role, erlang:length(List_hy)),
    {ok, compare(friend, Role, erlang:length(List_hy))};

% {legion_lv, 0, 1, 100}:表示军团等级达到多少， 0无意义，军团等级，获得声望 ok
% listener(Role, legion_lv) ->
% 	Lev = guild_api:get_guild_lvl(Role),
% 	% random_award:legion_lv(Role, Lev),
% 	{ok, compare(legion_lv, Role, Lev)};

% {fight_capacity, 0, 10000, 100}:表示战斗力达到多少，0无意义，战斗力，获得声望 ok
listener(fight_capacity, Role = #role{attr = #attr{fight_capacity = FC}}) ->
	demon_debris_mgr:update_role_debris(Role), %% 更新妖精掠夺功能的数据
	random_award:fight_capacity(Role, FC),
	compare(fight_capacity, Role, FC);											

% {dragon_fight_capacity, 0, 10000, 100}:表示宠物战力，0无意义，宠物战斗力，获得声望  ok
listener(dragon_fight_capacity, Role = #role{pet = #pet_bag{active = undefined}}) ->
	Role; 
listener(dragon_fight_capacity, Role = #role{pet = #pet_bag{active = #pet{fight_capacity = FC}}}) -> 
	random_award:dragon_fight_capacity(Role, FC),
	compare(dragon_fight_capacity, Role, FC);

% {dragon_level, 0, 13, 100}:表示伙伴达到几级，0无意义，伙伴等级，获得声望 ok
listener(dragon_level, Role = #role{pet = #pet_bag{active = undefined}}) ->
	Role;
listener(dragon_level, Role = #role{pet = #pet_bag{active = #pet{lev = Lev}}}) ->
	random_award:dragon_level(Role, Lev),
	compare(dragon_level, Role, Lev);

% {level, 0, 13, 100}:表示人物达到几级，0无意义，人物等级，获得声望	 ok
listener(level, Role = #role{lev = Lev}) ->
	demon_debris_mgr:update_role_debris(Role), %% 更新妖精掠夺功能的数据
	random_award:level(Role, Lev),
	compare(level, Role, Lev);
%-----------------------------------------------------------------------------------
% 监听条件关于累积次数的，需要更新累积的次数
% eg.,被杀了多少次需要累积记录，每次减1
%-----------------------------------------------------------------------------------

% {kingdom_command, 0,2, 200}:参加王国圣令多少次，0无意义，次数，获得声望	ok
% {kingdomfight, 0, 2, 200}:参加王国远征多少次，0无意义，次数，获得声望 ok
% {tree_climb_times, 0, 2, 200}:参加世界树爬塔多少次，0无意义，次数，获得声望 ok
% {pirate, 0, 2, 200}:参加缉猎海盗多少次，0无意义，次数，获得声望 ok
% {dragon_boss, 0, 2, 200}:参加守城伐龙多少次，0无意义，次数，获得声望} 未添加
listener({king, Label}, Role) ->

	R  = accumulate(kingdom_command, Role, 0, 1),
	R1 = accumulate(Label, R, 0, 1),
	R1;

% {competitive_win, 0,1,200}:竞技场胜利多少次，0无意义，次数，获得声望	未测试 ok
% {competitive_loss, 0, 1,200}:竞技场失败多少次，0无意义，次数，获得声望 未测试 ok
listener({competitive, Label}, Role) ->
	case Label of
		?arena_career_win ->
			accumulate(competitive_win, Role, 0, 1);
		?arena_career_lose ->
			accumulate(competitive_loss, Role, 0, 1);
		_ -> Role
	end;												

% {monster_lv,X,Y,100,20}：表示有Y只妖精等级达到X（只计算当前，历史的不算）
% {monster_growth,X,Y,100,20}：表示有Y只妖精成长达到X（只计算当前，历史的不算）
listener(monster, Role) ->
	Role1 = listener(monster_lv, Role),
	% Role2 = listener(monster_growth, Role1),
	Role1;
listener(monster_lv, Role = #role{demon = #role_demon{active = Active, bag = Bag}}) ->
	?DEBUG("monster_lv:~p, ~p~n", [Active, Bag]),
	case check_current_condition(Role, monster_lv) of 
		{Target, _} ->
			{ok, Cur_Value} = check_monster_lev(Target, {Active, Bag}),
			compare(monster_lv, Role, Cur_Value);
		_ -> Role
	end;

listener(monster_growth, Role = #role{demon = #role_demon{active = Active, bag = Bag}}) ->
	case check_current_condition(Role, monster_growth) of 
		{Target, _} ->
			{ok, Cur_Value} = check_monster_growth(Target, {Active, Bag}),
			compare(monster_growth, Role, Cur_Value);
		_ -> Role
	end;

% {drug, 1, 1, 200}:服用多少瓶多少级的药水，级数，瓶数，获得声望	
listener(drug, Role) ->
	case check_current_condition(Role, drug) of 
		{Target, _} ->
			{ok, Cur_Value} = check_drug_eat(Target, Role),
			compare(drug, Role, Cur_Value);
		_ -> Role
	end;
%% monsters_contract
listener(Label, Role) ->
	accumulate(Label, Role, 0, 1).

% {tree_climb, 0, 10, 200}:表示世界树爬塔达到多少千庭米，0无意义，庭米数，获得声望 ok
listener(tree_climb, Role, Meters) ->
	rank_celebrity:listener(tree_climb, Role, Meters),
	random_award:tree_climb(Role, Meters),
	compare(tree_climb, Role, Meters);


% {dungeon, 11011, 1, 100}:通关某个副本，副本id，通关次数，获得声望 ok
% {dungeon_hard, 11011, 1, 100}:通关某个困难副本多少次，副本id，通关次数，获得声望 ok
% {dungeon_star, 0, 1, 100}:副本评价拿到总共多少颗蓝色星星，0无意义，星星数，获得声望 ok
% {dungeon_hardstar, 0, 1, 100}:副本评价拿到总共多少颗紫色星星，0无意义，星星数，获得声望 ok	
listener(dungeon, Role = #role{dungeon_map = DM}, {TargetId, Count}) ->
	Blue   = [B||{_, B, _, _, _, _} <- DM],
	Purple = [P||{_, _, P, _, _, _} <- DM], 
	case dungeon_api:is_hard(TargetId) of
	    false ->
	        R = accumulate(dungeon, Role, TargetId, Count),
	        random_award:dungeon(Role, TargetId),
	        random_award:dungeon_star(Role, lists:sum(Blue)),
	        compare(dungeon_star, R, lists:sum(Blue));
	    true ->
	        R = accumulate(dungeon_hard, Role, TargetId, Count),
	        random_award:dungeon_hard(Role, TargetId),
	        random_award:dungeon_hardstar(Role, lists:sum(Blue)),
	        compare(dungeon_hardstar, R, lists:sum(Purple))
    end;
	

% {kill_npc, 10204, 1, 200}:杀死npc，npcid，数量，获得声望 ok
% {item, 102574, 1, 100}:获得物品，物品id，数量，获得声望 ok	
% {monster_contract, 10204 ,1, 100}:表示收服妖怪，妖怪id，数量，获得声望 ok

listener(Label, Role, {TargetId, Num}) ->
	accumulate(Label, Role, TargetId, Num).

%----------------------------------------------------------------------------------
%% 特殊事件
%----------------------------------------------------------------------------------

%%悬赏boss 未测试
% {pirate_kill2, 0, 0, 200}:击杀任意一个悬赏boss海盗，0无意义，0无意义，获得声望
% {pirate_kill, 10021, 0, 200}:击杀某个悬赏boss海盗，海盗id，0无意义，获得声望		
listener_special({kill_pirate, Boss_id}, Role) ->
	R1 = event(pirate_kill2, Role, 0),
	R2 = event(pirate_kill, R1, Boss_id),
	rank_celebrity:listener(pirate_kill, R2, Boss_id),
	R2;

%%世界boss 未测试
% {dragon_boss_hit, 10402, 0, 200}:完成对某个世界boss的最后一击，bossid，0无意义，获得声望}
% {dragon_boss_hit2, 0, 0, 200}:完成对任意一个世界boss的最后一击，0无意义，0无意义，获得声望}	
listener_special({hit_dragon_boss, Boss_id}, Role) ->
	R1 = event(dragon_boss_hit2, Role, 0),
	R2 = event(dragon_boss_hit, R1, Boss_id),
	R2;

% {legion, 0, 0, 100}:表示加入军团， 0无意义，0无意义，获得声望	未测试
listener_special(Label, Role) ->
	event(Label, Role, 0).

% {trial，10001,0,100}:通关试炼场，试炼场id，0没意义，获得声望	ok
listener_special(Label, Role, Boss_id) ->
	event(Label, Role, Boss_id).		

%------------------------------------------------------------------------------
% Internal Used 
%------------------------------------------------------------------------------

%% @spec compare(Label, Role, Cur_Value) -> NRole | Role 
%% Label :: atom()  
%% Cur_Value :: number 表示当前数值的大小  
%% @doc 大小值的比较
compare(Label, Role = #role{medal = #medal{condition = Cond}}, Cur_Value) ->
	?DEBUG("--compare--Label--:~p~n",[Label]),
	CondProgress = medal_mgr:get_cur_medal_cond(Role), %%[{lable,target,target_value,rep}...]
	case find_cond2(Label, CondProgress) of 
		CurCond = #medal_cond{id = N, label = Label, need_value = Need_Value}->
			
			%%注意区别 NC与 Nth
			?DEBUG("--Condition--Label--~p~n", [Label]),
			case Need_Value > 0 of 
				true -> 
					case Need_Value > Cur_Value of 
						true ->
							update_cond_progress(Cur_Value, CondProgress, CurCond, Role);
						false ->
							case lists:nth(N, Cond) of 
								{?status_unfinish, _} ->
									update_cond_unclaimed(Need_Value, CondProgress, CurCond, Role);
								_ -> 
									Role
							end
					end;
				false -> 
					Role
			end;
		_ ->
			Role
	end.


%% @spec target_accu(Label, Role, Target, N) -> NRole | Role 
%% Label :: atom()  
%% Target :: number 
%% N :: number 表示累积的数值  
%% @doc 累积次数的更新 			
accumulate(Label, Role = #role{medal = #medal{condition = Cond}}, Target, Num) ->
	?DEBUG("--accumulate-Label--:~w~n",[Label]),
	CondProgress = medal_mgr:get_cur_medal_cond(Role), %%[{lable,target,target_value,rep}...]
	% case find_cond2(Label, Target, CondProgress) of 
	case find_cond2(Label, CondProgress) of 
		CurCond = #medal_cond{id = Nth, label = Label, target = Target, cur_value = Cur_Value, need_value = Need_Value} ->
			case Need_Value > 0 of 
				true -> 
					case Need_Value > Cur_Value + Num of 
						true ->
							update_cond_progress(Cur_Value + Num, CondProgress, CurCond, Role);
						false ->
							case lists:nth(Nth, Cond) of 
								{?status_unfinish, _} ->
									update_cond_unclaimed(Need_Value, CondProgress, CurCond, Role);
								_ -> 
									Role
							end
					end;
				false -> 
					Role
			end;
		_ -> 
			Role
	end.


%% @spec event(Label, Role) -> NRole | Role 
%% Label :: atom()  
%% @doc 纯粹的事件触发
event(Label, Role = #role{medal = #medal{condition = Cond}}, Target) ->
	?DEBUG("--event--Label--:~w~n",[Label]),
	CondProgress = medal_mgr:get_cur_medal_cond(Role), %%[{lable,target,target_value,rep}...]
	case lists:keyfind(Label, #medal_cond.label, CondProgress) of 
		CurCond = #medal_cond{id = N, label = Label, target = Target, need_value = Need_Value} when is_record(CurCond, medal_cond) ->
			case lists:nth(N, Cond) of 
				{?status_unfinish, _} ->
					update_cond_unclaimed(Need_Value, CondProgress, CurCond, Role);
				_ -> 
					Role
			end;
		_ ->
			Role
	end.

%%更新第Nth 个条件为可领取
update_cond_unclaimed(Progress, CondProgress, CurCond = #medal_cond{id = Nth}, Role = #role{id = {Rid, _}, medal = Medal = #medal{condition = Cond}}) ->
	{L1, L2} = lists:split(Nth, Cond),
	NL1      = lists:sublist(L1, Nth - 1),
	NCond  	 = NL1 ++ [{?status_unclaimed, Progress}] ++ L2,
	Num 	 = [St||{St, _} <- NCond, St =:= ?status_unclaimed],
	push_notice(Role, {Nth, erlang:length(Num)}), %% 收到push_notice则优先处理，不管是否已达到条件
	NMCond 	 = CondProgress -- [CurCond],
	medal_mgr:update_cur_medal_cond(Rid, NMCond),
	Role#role{medal = Medal#medal{condition = NCond}}.

%%更新第Nth个条件的进度
update_cond_progress(NewProgress, CondProgress, CurCond = #medal_cond{id = Nth, cur_value = Cur_value}, Role = #role{id = {Rid, _}, medal = Medal = #medal{condition = Cond}}) ->
	case NewProgress > Cur_value of 
		true ->
			NMCond1 = lists:keydelete(Nth, #medal_cond.id, CondProgress),
			NMCond2 = [CurCond#medal_cond{cur_value = NewProgress}] ++ NMCond1,
			medal_mgr:update_cur_medal_cond(Rid, NMCond2),
			push_progress(Role#role.link#link.conn_pid, {Nth, NewProgress}),

			% {Status, _} = lists:nth(Nth, Cond),
			% {CL1, CL2}  = lists:split(Nth, Cond),
			% NCL1 		= lists:sublist(CL1, Nth - 1),
			% NCond 		= NCL1 ++ [{Status, NewProgress}] ++ CL2,
			NCond = update_nth_cond(Nth, Cond, NewProgress),
			Role#role{medal = Medal#medal{condition = NCond}};
		_ ->
			{_, CurValue} = lists:nth(Nth, Cond),
			case NewProgress < CurValue of
				true ->
					NCond = update_nth_cond(Nth, Cond, NewProgress),
					Role#role{medal = Medal#medal{condition = NCond}};
				false -> 
					Role
			end
	end.

update_nth_cond(Nth, Cond, NewProgress) ->
	{Status, _} = lists:nth(Nth, Cond),
	{CL1, CL2}  = lists:split(Nth, Cond),
	NCL1 		= lists:sublist(CL1, Nth - 1),
	NCond 		= NCL1 ++ [{Status, NewProgress}] ++ CL2,
	NCond.

%%发送可领取通知
push_notice(#role{link = #link{conn_pid = ConnPid}}, {N, Num})->
	?DEBUG("-----******************-push_notice---:~p,~p~n~n~n",[N, Num]),
	% notice:alert(succ, ConnPid, ?L(<<"完成一个条件">>)),
	% ?DEBUG("------push_notice-num--:~w~n",[Num]),
	sys_conn:pack_send(ConnPid, 13065, {N, Num}).	

%%推送条件进度
push_progress(ConnPid, {N, Cur})->
	?DEBUG("-!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!-----push_progress---:~p, ~p~n~n~n",[N, Cur]),
	% ?DEBUG("------push_notice-num--:~w~n",[Num]),
	sys_conn:pack_send(ConnPid, 13069, {N, Cur}).	

%%获取属性
do_get_attr_all([], L) -> L;
do_get_attr_all([Id|Gain], L) ->
	{ok, #medal_special{attr = Attr}} = medal_data:get_medal_special(Id),
	NL = get_attr(Attr, L),
	do_get_attr_all(Gain, NL).

get_attr([], L) ->L ;
get_attr([{Key, Value}|Attr], L) ->
	case lists:keyfind(Key, 1, L) of 
		false ->
			get_attr(Attr, [{Key, Value}|L]);
		{Key, NValue} ->
			NL = lists:keyreplace(Key, 1, L, {Key, Value + NValue}),
			get_attr(Attr, NL)
	end.

%% 获取初始化的勋章条件
get_init_medal_cond(Career) ->
	{ok, Medal_Base} = medal_data:get_medal_base(?init_medal),
	make_cond(Career, Medal_Base#medal_base.condition).


%%检查人物达到某一个等级的神觉的个数
check_lev_channels(#channels{list = ChannelList}, Lev) ->
	?DEBUG("--ChannelList--~p~n~n~n", [ChannelList]),
	MatchChan = [1||#role_channel{lev = L} <- ChannelList, L >= Lev],
	{ok, erlang:length(MatchChan)}.

%%检查人物某一个属性的神觉是否达到某一个等级
check_lev_channel(#channels{list = ChannelList}, Attr, _Lev) ->
	case lists:keyfind(Attr, #role_channel.id, ChannelList) of 
		#role_channel{lev = L} -> {ok, L};
		_ -> {ok, 0}
	end.

%%检查人物某多少个属性的神觉每一个至少强化加了多少属性
check_attr_channels(#channels{list = ChannelList}, AttrValue) ->
	Num_List = [1||#role_channel{state = State} <- ChannelList, State >= AttrValue],
	{ok, erlang:length(Num_List)}.


%%检查有多少装备是达到Target等级以及Value的品质
check_lev_quanlity(Eqm, TypeList, Target, Value) ->
	F = fun(Item = #item{base_id = BaseId}, L) ->  
		Type = eqm:eqm_type(BaseId),
		case lists:member(Type, TypeList) of
			true -> [Item|L];
			false -> L
		end
	end,
	Eqm2 = lists:foldl(F, [], Eqm),
	List = [E||E <- Eqm2, E#item.require_lev >= Target andalso E#item.quality >= Value],
	{ok, erlang:length(List)}.   


%%检查有多少装备是达到Target等级
check_suit_lev_num(Eqm, TypeList, Target) ->
	F = fun(Item = #item{base_id = BaseId}, L) ->  
		Type = eqm:eqm_type(BaseId),
		case lists:member(Type, TypeList) of
			true -> [Item|L];
			false -> L
		end
	end,
	Eqm2 = lists:foldl(F, [], Eqm),
	List = [E||E <- Eqm2, E#item.require_lev >= Target],
	{ok, erlang:length(List)}.   

%%检查是否具有一整套件防具
% check_armor_all(Eqm, TypeList, Num) ->
% 	F = fun(Item = #item{base_id = BaseId}, L) ->  
% 		Type = eqm:eqm_type(BaseId),
% 		case lists:member(Type, TypeList) of
% 			true -> [Item|L];
% 			false -> L
% 		end
% 	end,
% 	Eqm2 = lists:foldl(F, [], Eqm),
% 	case erlang:length(Eqm2) >= Num of
% 		true -> Eqm2;
% 		false -> false
% 	end.

%%检查是否具有Value件Target颜色以上的装备
check_num_quanlity(Eqm, Target) ->
	List = [E||E<-Eqm, E#item.quality >= Target],
	{ok, erlang:length(List)}.

%%Num件装备强化到Lev级
check_num_enchant(Eqm, Lev) -> 
	List = [E||E<-Eqm, E#item.enchant >= Lev],
	{ok, erlang:length(List)}.

%%检查任意什么宝石达到什么属性
check_lev_bs(Eqm, Lev, Attr) ->
	AttrList = [Attr1||#item{attr = Attr1} <- Eqm, lists:keyfind(101, 2, Attr1) =/= false],
	NAttr 	 = lists:flatten(AttrList),
	F 		 = fun({_, _, Value}, Sum) ->
				case (Value rem 10) >= Lev andalso (Value div 100 rem 10) >= Attr of 
					true -> [1|Sum];
					false -> Sum
				end
		end,
	{ok, erlang:length(lists:foldl(F, [], NAttr))}.

%%检查全装备镶嵌多少级宝石
%%Num表示装备的数量，lev表示装备镶嵌宝石的等级
check_lev_bs_all(Eqm, Lev, Num) -> 
	AttrList = [Attr1||#item{attr = Attr1} <- Eqm, lists:keyfind(101, 2, Attr1) =/= false],
	case erlang:length(AttrList) >= Num of 
		true ->
			F = fun(List) ->
				L = [Flag||{_, Flag, Value2} <-List, Flag == 101 andalso Value2 rem 10 >= Lev],
				case erlang:length(L) > 0 of 
					true -> 1;
					false -> 0
				end
			end,  
			{ok, lists:sum(lists:map(F, AttrList))};
		false ->
			{ok, 0}
	end.

%%检查镶嵌多少个多少级宝石
%% Num表示有多少个宝石，
%% Lev 表示装备镶嵌宝石的等级
check_lev_num(Eqm, Lev) ->
	AttrList = [Attr1||#item{attr = Attr1} <- Eqm],
	F 		 = fun(List, Re) ->
				L = [1||{_, Flag, Value2} <-List, Flag =:= 101 andalso Value2 rem 10 >= Lev],
				case erlang:length(L) > 0 of 
					true -> L ++ Re;
					false -> Re
				end
	end,  
	{ok, lists:sum(lists:foldl(F, [], AttrList))}. 

%%表示任意一件装备镶嵌三颗多少级以上的宝石
check_lev_bs_num(Eqm, Lev, Num) ->
	AttrList = [Attr1||#item{attr = Attr1} <- Eqm, lists:keyfind(101, 2, Attr1) =/= false],
	F 		 = fun(List) ->
				L = [Flag||{_, Flag, Value2} <-List, Value2 rem 10 >= Lev],
				case erlang:length(L) >= Num of 
					true -> 1;
					false -> 0
				end
		end,  
	% case lists:sum(lists:map(F, AttrList)) >= 1 of 
	% 	true -> ok;
	% 	false -> false
	% end.
	{ok, lists:sum(lists:map(F, AttrList))}.

%%表示全装备都镶嵌三颗多少级以上的宝石
check_lev_bs_num_all(Eqm, Lev, Num) ->
	AttrList = [Attr1||#item{attr = Attr1} <- Eqm, lists:keyfind(101, 2, Attr1) =/= false],
	F 		 = fun(List) ->
				L = [Flag||{_, Flag, Value2} <-List, Value2 rem 10 >= Lev],
				case erlang:length(L) >= Num of 
					true -> 1;
					false -> 0
				end
		end,  
	{ok, lists:sum(lists:map(F, AttrList))}.

%%表示人物技能有达到lev等级的有多少个
check_lev_skill(Skill, Lev) ->
	List = [S||S<- Skill, is_record(S, skill) andalso S#skill.lev >= Lev],
	{ok, erlang:length(List)}.

%%检查宠物有多少个技能达到多少级
check_lev_skill_num(Skill, Lev) ->
	List = [ID||{ID, _, _, _}<-Skill, ID rem 10 >= Lev],
	{ok, erlang:length(List)}.

%% target means lev 检查伙伴有atom阶target级的技能
check_step_skill_num(low, Skill, Lev) ->
	List = [ID||{ID, _, _, _} <- Skill, (erlang:round(ID / 100) rem 10) =:= 1, ID rem 10 >= Lev],
	{ok, erlang:length(List)};
check_step_skill_num(mid, Skill, Lev) ->
	List = [ID||{ID, _, _, _} <- Skill, (erlang:round(ID / 100) rem 10) =:= 2, ID rem 10 >= Lev],
	{ok, erlang:length(List)};
check_step_skill_num(high, Skill, Lev) ->
	List = [ID||{ID, _, _, _} <- Skill, (erlang:round(ID / 100) rem 10) =:= 3, ID rem 10 >= Lev],
	{ok, erlang:length(List)}.
%%
% find_cond(Label, Target, MCond) ->
% 	do_find_cond(Label, Target, MCond).

% do_find_cond(_Label, _Target, []) ->
% 	false;
% do_find_cond(Label, Target, [MCond = #medal_cond{label = Label, target = Target}|_T]) ->
% 	MCond;
% do_find_cond(Label, Target, [#medal_cond{label = Label, target = _Target}|T]) ->
% 	do_find_cond(Label, Target, T);
% do_find_cond(Label,Target, [#medal_cond{label = _Label, target = _Target}|T]) ->
% 	do_find_cond(Label, Target, T).

find_cond2(Label, MCond) ->
	case lists:keyfind(Label, #medal_cond.label, MCond) of 
		Cond = #medal_cond{} when is_record(Cond, medal_cond) -> 
			Cond;
		_ -> false
	end.

%%检查当前是否含有该Label的条件
check_current_condition(Role, Label) ->
	MCond = medal_mgr:get_cur_medal_cond(Role), %%[{lable,target,target_value,rep}...]
	case lists:keyfind(Label, #medal_cond.label, MCond) of 
		M = #medal_cond{target = Target, target_value = Value} when is_record(M, medal_cond) ->
			{Target, Value};
		_ ->
			false
	end.

check_jdsuit_score(Eqm, Score) ->
	SpecialList = [Special||#item{special = Special} <- Eqm],
	F = fun(Special, Re) ->
		case lists:keyfind(?special_eqm_point, 1, Special) of
			Point when Point >= Score ->
				Re + 1;
			_ -> Re
		end
	end,  
	{ok, lists:foldl(F, 0, SpecialList)}. 


check_monster_lev(Lev, {Active, Bag}) ->
	All = 
		case Active =/= 0 of
			true -> [Active|Bag];
			false -> Bag
		end,
	List = [1||#demon2{lev = L}<-All, L >= Lev],
	{ok, erlang:length(List)}.

check_monster_growth(Grow, {Active, Bag}) ->
	All = 
		case Active =/= 0 of
			true -> [Active|Bag];
			false -> Bag
		end,
	List = [1||#demon2{grow = G}<- All, G >= Grow],
	{ok, erlang:length(List)}.

check_drug_eat(Lev, #role{manor_moyao = #manor_moyao{has_eat_yao = HasEat}}) ->
	List = [Num||#has_eat_yao{id = MoyaoId, num = Num} <- HasEat, (MoyaoId rem 10) >= Lev],
	{ok, lists:sum(List)}.


% @doc 登录时同步到最新配置数据
sync_newest_cond(Role = #role{id = {Rid, _}, career = Career, medal = #medal{cur_medal_id = CurId, condition = Condition}}) ->
	case medal_data:get_medal_base(CurId) of %%获得勋章
        {ok, #medal_base{condition = NCondition}}-> 
			NCondition1 = medal:make_cond(Career, NCondition),
			MCond 		= medal_mgr:get_cur_medal_cond(Role),  
			NMCond 		= merge(MCond, NCondition1),
			NMCond1 	= auto_fix(Condition, CurId, NMCond),
			medal_mgr:update_cur_medal_cond(Rid, NMCond1);
		_ -> 
			ignore
	end.

merge(CurCond, ConfigCond) ->
	do_merge(CurCond, ConfigCond, []).

do_merge([], _ConfigCond, Return) -> 
	Return;
do_merge([M0 = #medal_cond{id = Id, label = Label0, target = Target0, target_value = Value0}|T], ConfigCond, Return) ->
	case lists:keyfind(Id, #medal_cond.id, ConfigCond) of
		M = #medal_cond{label = Label1, target = Target1, target_value = Value1} when is_record(M, medal_cond) ->
			case Label0 == Label1 of
				true ->
					case (Target0 =/= Target1) orelse (Value0 =/= Value1) of
						true ->	%% target 或 target_value 变化, 只能更新累积性功能条件，进度会重新计算
							M1 = M#medal_cond{cur_value = 0}, 	
							do_merge(T, ConfigCond, [M1] ++ Return);
						false -> %% 没有变化
							do_merge(T, ConfigCond, [M0] ++ Return)
					end;
				false ->	%% label不同，已有进度会丢失
					do_merge(T, ConfigCond, [M] ++ Return)
			end;
		_ ->
			do_merge(T, ConfigCond, [M0] ++ Return)
	end.

auto_fix(Condition, CurId, CurCond) ->
	Unfinished = get_unfinish_nth(Condition, 1, []),
	NMCond1  = get_auto_fix_cond(Unfinished, CurId, CurCond),
	NMCond1.

get_auto_fix_cond(Unfinished, CurId, CurCond) ->
	{ok, #medal_base{condition = BaseConds}} = medal_data:get_medal_base(CurId),
	update_cond(Unfinished, BaseConds, CurCond).

update_cond([], _, CurCond) -> CurCond;
update_cond([H|T], BaseConds, CurCond) ->
	case lists:keyfind(H, #medal_cond.id, CurCond) of
		false ->
			Cond = #medal_cond{} = lists:keyfind(H, #medal_cond.id, BaseConds),
			update_cond(T, BaseConds, [Cond] ++ CurCond);
		_ -> 
			update_cond(T, BaseConds, CurCond)
	end.

get_unfinish_nth([], _Nth, Res) -> Res;
get_unfinish_nth([{?status_unfinish, _}|Conditions], Nth, Res) ->
	get_unfinish_nth(Conditions, Nth + 1, [Nth] ++ Res);
get_unfinish_nth([{_, _}|Conditions], Nth, Res) ->
	get_unfinish_nth(Conditions, Nth + 1, Res).
