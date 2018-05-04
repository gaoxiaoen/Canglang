-module(random_award).
-export([
			item/3,
			coin/2,
			gold/2,
			friend/2,
			legion/1,
			% legion_lv/2,
			kill_npc/3,
			task/2,
			monsters_contract/1,
			monster_contract/2,
			gemstone/1,
			drug_make/1,
			trade/1,
			dragon_train/1,
			drug/2,
			fight_capacity/2,
			dragon_fight_capacity/2,
			skill/2,
			skill_learn/3,
			level/2,
			dragon_level/2,
			dragon_skill/2,
			dragon_skill_low/2,
			dragon_skill_mid/2,
			dragon_skill_high/2,
			suit/1,
			suit_armor/1,
			suit_arms/1,
			suit_jewelry/1,
			c_suit/1,
			s_suit/1,
			jd_suit/1,
			qh_suit/1,
			bs_suit/1,
			divine/3,
			divine_str/3,
			divine_2/2,
			dragon_bone/2,
			dungeon_hard/2,
			dungeon/2,
			dungeon_star/2,
			dungeon_hardstar/2,
			tree_climb/2,
			trial/2,
			competitive_win/1,
			competitive_loss/1,
			kingdomfight/1,
			tree_climb_times/1,
			pirate/1,
			dragon_boss/1
		]).

-include("common.hrl").
-include("role.hrl").
-include("award.hrl").
-include("skill.hrl").
-include("channel.hrl").
-include("item.hrl").
-include("random_award.hrl").

% 获得X个物品	{item,物品ID,物品数量}
item(Role, Target, Value) ->
	do_check_target_accumulate(Role, item, {Target, Value}).


% 身上有X金币	{coin,0,金币数}
coin(Role, Value) ->
	do_check(Role, coin, {0, Value}).


% 身上有X晶钻	{wing,0,晶钻数}
gold(Role, Value) ->
	do_check(Role, wing, {0, Value}).


% 拥有X位好友	{friend,0,好友数}
friend(Role, Value) ->
	do_check(Role, friend, {0, Value}).


% 加入军团	{legion，0, 0}
legion(Role) ->
	do_check(Role, legion, {0, 0}).


% 军团等级到达X	{legion_lv，0,军团等级}
% legion_lv(Role, Value) ->
% 	do_check(Role, legion_lv, {0, Value}).


% 杀死某个怪物X次	{kill_npc,NPC的ID,次数}
kill_npc(Role, Target, Num) ->
	do_check_target_accumulate(Role, kill_npc, {Target, Num}).


% 完成某个任务	{task,任务ID,0}
task(Role, Target) ->
	do_check(Role, task, {Target, 0}).


% 收服妖精X只	{monsters_contract,0,妖精数量}
monsters_contract(Role) ->
	do_check_target_accumulate(Role, monsters_contract, {0, 1}).


% 收服某个妖精	{monster_contract,妖精ID,0}
monster_contract(Role, Target) ->
	do_check(Role, monster_contract, {Target, 0}).


% 庄园宝石打造X次	{gemstone，0,次数}
gemstone(Role) ->
		do_check_target_accumulate(Role, gemstone, {0, 1}).	


% 庄园魔药炼制X次	{drug_make，0,次数}
drug_make(Role) ->
	do_check_target_accumulate(Role, drug_make, {0, 1}).


% 庄园贸易行商X次	{trade，0,次数}
trade(Role) ->
	do_check_target_accumulate(Role, trade, {0, 1}).


% 庄园伙伴培养X次	{dragon_train，0,次数}
dragon_train(Role) ->
	do_check_target_accumulate(Role, dragon_train, {0, 1}).


% 服用X瓶某等级的药水	{drug，级数,瓶数}
drug(Role, Target) ->
	do_check_target_accumulate(Role, drug, {Target, 1}).


% 战斗力达到X	{fight_capacity,0,战斗力}
fight_capacity(Role, Value) ->
	do_check(Role, fight_capacity, {0,  Value}).


% 伙伴战斗力达到X	{dragon_fight_capacity,0,伙伴战斗力}
dragon_fight_capacity(Role, Value) ->
	do_check(Role, dragon_fight_capacity, {0,  Value}).


% X个技能升级到某个等级	{skill，技能等级，技能数}
skill(_, _) ->
	ok.
% skill(Role, Lev) ->
% 	do_check_skill(Role, skill, Lev).
% do_check_skill(Role = #role{id = Id = {Rid, _}, name = Name}, skill, Target)->
% 	Data = get_role_award_data(Role),
% 	Filter = [D||D = #random_award{label = skill, target = Target1} <- Data, Target1 == Target],
% 	case erlang:length(Filter) > 0 of 
% 		true -> 
% 			N = calc_lev_skill(Role, Target),
% 			Finish = [D||D = #random_award{value = Val} <- Filter, N >= Val],
% 			case erlang:length(Finish) > 0 of 
% 				true -> 
% 					NData = Data -- Finish,
% 					put(random_award_cond, NData),
% 					random_award_mgr:update_cur_cond(Rid, NData),
% 					[send_award_and_said(Id, RandomId, AwardId, Name)||#random_award{id = RandomId, award_id = AwardId} <- Finish];
% 				false -> 
% 					ok
% 			end;
% 		false -> 
% 			ok
% 	end.
% calc_lev_skill(#role{skill = #skill_all{skill_list = Skill}}, Lev) ->
% 	List = [S||S<- Skill, is_record(S, skill), S#skill.lev >= Lev],
% 	erlang:length(List).



% 升级某个技能到某个等级	{skill_learn，技能ID，技能等级（填1指从没有这个技能到学会这个技能）}
skill_learn(Role, Target, Value) ->
	do_check(Role, skill_learn, {Target, Value}).


% 升级到某个等级	{level，0,等级}
level(Role, Value) ->
	do_check(Role, level, {0, Value}).


% 伙伴升级到某个等级	{dragon_level，0,等级}
dragon_level(Role, Value) ->
	do_check(Role, dragon_level, {0, Value}).
	

% 伙伴学会某个技能	{dragon_skill，技能ID前4位, 0}
dragon_skill(Role, Target) -> 
	do_check(Role, dragon_skill, {Target, 0}).


% 伙伴有多少个低阶技能	{dragon_skill_low，0,数量}
dragon_skill_low(Role, Value) ->
	do_check(Role, dragon_skill_low, {0, Value}).


% 伙伴有多少个中阶技能	{dragon_skill_mid，0,数量}
dragon_skill_mid(Role, Value) ->
	do_check(Role, dragon_skill_mid, {0, Value}).


% 伙伴有多少个高阶技能	{dragon_skill_high，0,数量}
dragon_skill_high(Role, Value) ->
	do_check(Role, dragon_skill_high, {0, Value}).


% 获得某个等级以上的全套某个颜色以上套装	{suit，等级,颜色}123456表示绿蓝紫粉橙金
suit(_) ->
	ok.
% suit(Role) ->
% 	Data = get_role_award_data(Role),
% 	Filter = [D||D = #random_award{label = suit}<-Data],
% 	case erlang:length(Filter) > 0 of 
% 		true -> 
% 			[do_check_suit(Role, Data, ?enchant_type, 10, D1)||D1 = #random_award{}<-Filter];
% 		false -> 
% 			ok
% 	end.

% 获得xx级以上的什么颜色以上全部6件防具	{suit_armor，等级,颜色}
suit_armor(_) ->
	ok.
% suit_armor(Role) ->
% 	Data = get_role_award_data(Role),
% 	Filter = [D||D = #random_award{label = suit_armor}<-Data],
% 	case erlang:length(Filter) > 0 of 
% 		true -> 
% 			[do_check_suit(Role, Data, ?armor, 6, D)||D = #random_award{}<-Filter];
% 		false -> 
% 			ok
% 	end.


% 获得xx级以上的什么颜色以上1件武器	{suit_arms，等级,颜色}
suit_arms(_) ->
	ok.
% suit_arms(Role) ->
	% Data = get_role_award_data(Role),
	% Filter = [D||D = #random_award{label = suit_arms}<-Data],
	% case erlang:length(Filter) > 0 of 
	% 	true -> 
	% 		[do_check_suit(Role, Data, ?eqm, 1, D)||D = #random_award{}<-Filter];
	% 	false -> 
	% 		ok
	% end.

% 获得xx级以上的什么颜色以上全部3件首饰	{suit_jewelry，等级,颜色}
suit_jewelry(_) ->
	ok.
% suit_jewelry(Role) ->
	% Data = get_role_award_data(Role),
	% Filter = [D||D = #random_award{label = suit_jewelry}<-Data],
	% case erlang:length(Filter) > 0 of 
	% 	true -> 
	% 		[do_check_suit(Role, Data, ?jewelry, 3, D)||D = #random_award{}<-Filter];
	% 	false -> 
	% 		ok
	% end.

% do_check_suit(Role = #role{id = Id, eqm = Eqm, name = Name}, AllCond, TypeList, Num, #random_award{id = RandomId, award_id = AwardId, target = Target, 
% 		value = Value})->
% 	Cur_Value = check_lev_quanlity(Eqm, TypeList, Target, Value),
% 	case Cur_Value >= Num of 
% 		true -> 
% 			del_cond(Role, RandomId, AllCond),
% 			send_award_and_said(Id, RandomId, AwardId, Name);
% 		false -> 
% 			ok
% 	end.
% check_lev_quanlity(Eqm, TypeList, Target, Value) ->
% 	F = fun(Item = #item{base_id = BaseId}, L) ->  
% 		Type = eqm:eqm_type(BaseId),
% 		case lists:member(Type, TypeList) of
% 			true -> [Item|L];
% 			false -> L
% 		end
% 	end,
% 	Eqm2 = lists:foldl(F, [], Eqm),
% 	List = [E||E <- Eqm2, E#item.require_lev >= Target andalso E#item.quality >= Value],
% 	erlang:length(List).   

% 有几件xx颜色的衣服	{c_suit,颜色,数量}
c_suit(_) ->
	ok.
% c_suit(Role) ->
% 	Data = get_role_award_data(Role),
% 	Filter = [D||D = #random_award{label = c_suit}<-Data],
% 	case erlang:length(Filter) > 0 of 
% 		true -> 
% 			[do_check_suit2(Role, Data, D)||D = #random_award{}<-Filter];
% 		false -> 
% 			ok
% 	end.
% do_check_suit2(Role = #role{id = Id, eqm = Eqm, name = Name}, AllCond, #random_award{id = RandomId, 
% 				award_id = AwardId, target = Target, value = Val})->
% 	Cur_Value = check_num_quanlity(Eqm, Target),
% 	case Cur_Value >= Val of 
% 		true -> 
% 			del_cond(Role, RandomId, AllCond),
% 			send_award_and_said(Id, RandomId, AwardId, Name);
% 		false -> 
% 			ok
% 	end.
% check_num_quanlity(Eqm, Target) ->
% 	List = [E||E<-Eqm, E#item.quality >= Target],
% 	erlang:length(List).


% 获得任意一件xx级数、xx颜色的衣服	{s_suit,等级,颜色}
s_suit(_) ->
	ok.
% s_suit(Role) ->
% 	Data = get_role_award_data(Role),
% 	Filter = [D||D = #random_award{label = s_suit} <- Data],
% 	case erlang:length(Filter) > 0 of 
% 		true -> 
% 			[do_check_suit(Role, Data, ?enchant_type, 1, D)||D = #random_award{}<-Filter];
% 		false -> 
% 			ok
% 	end.


% 全部装备鉴定几次	{jd_suit,0,次数}
jd_suit(Role) -> %% Value为总的次数
	do_check_target_accumulate(Role, jd_suit, {0, 1}).


% 多少件装备强化到多少	{qh_suit,强化等级,装备数量}
qh_suit(_) ->
	ok.
% qh_suit(Role) ->
% 	Data = get_role_award_data(Role),
% 	Filter = [D||D = #random_award{label = qh_suit}<-Data],
% 	case erlang:length(Filter) > 0 of 
% 		true -> 
% 			[do_check_suit3(Role, Data, D)||D = #random_award{}<-Filter];
% 		false -> 
% 			ok
% 	end.
% do_check_suit3(Role = #role{id = Id, eqm = Eqm, name = Name}, AllCond, #random_award{id = RandomId, 
% 				award_id = AwardId, target = Target, value = Val})->
% 	Cur_Value = check_num_enchant(Eqm, Val),
% 	case Cur_Value >= Target of 
% 		true -> 
% 			del_cond(Role, RandomId, AllCond),
% 			send_award_and_said(Id, RandomId, AwardId, Name);
% 		false -> 
% 			ok
% 	end.

% check_num_enchant(Eqm, Lev) -> 
% 	List = [E||E<-Eqm, E#item.enchant >= Lev],
% 	erlang:length(List).


% 任意一件装备镶嵌一颗多少级的什么宝石	{bs_suit,宝石属性,宝石等级}0不限、1抗性、2精准、3防御、4攻击、5生命、6格挡、7坚韧、8暴怒
bs_suit(_) ->
	ok.
% bs_suit(Role) ->
% 	Data = get_role_award_data(Role),
% 	Filter = [D||D = #random_award{label = bs_suit}<-Data],
% 	case erlang:length(Filter) > 0 of 
% 		true -> 
% 			[do_check_suit4(Role, Data, D)||D = #random_award{}<-Filter];
% 		false -> 
% 			ok
% 	end.
% do_check_suit4(Role = #role{id = Id, eqm = Eqm, name = Name}, AllCond, #random_award{id = RandomId, 
% 				award_id = AwardId, target = Target, value = Val})->
% 	Cur_Value = check_lev_bs(Eqm, Val, Target),
% 	case Cur_Value >= 1 of 
% 		true -> 
% 			del_cond(Role, RandomId, AllCond),
% 			send_award_and_said(Id, RandomId, AwardId, Name);
% 		false -> 
% 			ok
% 	end.
% %%检查任意什么宝石达到什么属性
% check_lev_bs(Eqm, Lev, Attr) ->
% 	AttrList = [Attr1||#item{attr = Attr1} <- Eqm, lists:keyfind(101, 2, Attr1) =/= false],
% 	NAttr = lists:flatten(AttrList),
% 	F = fun({_, _, Value}, Sum) ->
% 			case (Value rem 10) >= Lev andalso (Value div 100 rem 10) >= Attr of 
% 				true -> [1|Sum];
% 				false -> Sum
% 			end
% 		end,
% 	erlang:length(lists:foldl(F, [], NAttr)).

% 人物神觉觉醒等级	{divine,神觉属性,神觉等级}0不限、1抗性、2精准、3防御、4攻击、5生命、6格挡、7坚韧、8暴怒
divine(Role, _Target, Value) ->
	do_check(Role, divine, {0, Value}).


% 人物神觉强化等级	{divine_str,神觉属性,神觉等级}0不限、1抗性、2精准、3防御、4攻击、5生命、6格挡、7坚韧、8暴怒
divine_str(Role, _Target, Value) ->
	do_check(Role, divine_str, {0, Value}).


% 人物多少个属性的神觉达到多少等级	{divine_2,神觉等级,属性数量}
divine_2(_, _) ->
	ok.
% divine_2(Role, Value) ->
% 	do_check_divine(Role, divine_2, Value).
% do_check_divine(Role = #role{id = Id = {Rid, _}, name = Name}, divine_2, Target)->
% 	Data = get_role_award_data(Role),
% 	Filter = [D||D = #random_award{label = divine_2, target = Target1} <- Data, Target1 == Target],
% 	case erlang:length(Filter) > 0 of 
% 		true -> 
% 			N = calc_divine(Role, Target),
% 			Finish = [D1||D1 = #random_award{value = Val} <- Filter, N >= Val],
% 			case erlang:length(Finish) > 0 of 
% 				true -> 
% 					NData = Data -- Finish,
% 					put(random_award_cond, NData),
% 					random_award_mgr:update_cur_cond(Rid, NData),
% 					[send_award_and_said(Id, RandomId, AwardId, Name)||#random_award{id = RandomId, award_id = AwardId} <- Finish];
% 				false -> 
% 					ok
% 			end;
% 		false -> 
% 			ok
% 	end.
% calc_divine(#role{channels = #channels{list = ChannelList}}, Lev) ->
% 	?DEBUG("--ChannelList--~p~n~n~n", [ChannelList]),
% 	MatchChan = [1||#role_channel{lev = L} <- ChannelList, L >= Lev],
% 	erlang:length(MatchChan).


% 伙伴潜能平均达到X	{dragon_bone,0,潜能平均值}
dragon_bone(Role, Value) ->
	do_check(Role, dragon_bone, {0, Value}).


% 通关某个困难副本多少次	{dungeon_hard，副本ID,通关次数}
dungeon_hard(Role, Target) ->
	do_check_target_accumulate(Role, dungeon_hard, {Target, 1}).


% 通关某个副本多少次	{dungeon，副本ID,通关次数}
dungeon(Role, Target) ->
	do_check_target_accumulate(Role, dungeon, {Target, 1}).


% 副本评价拿到总共多少颗蓝色星星	{dungeon_star，0,数量}
dungeon_star(Role, Value) ->
	do_check(Role, dungeon_star, {0, Value}).


% 副本评价拿到总共多少颗紫色星星	{dungeon_hardstar，0,数量}
dungeon_hardstar(Role, Value) ->
	do_check(Role, dungeon_hardstar, {0, Value}).


% 世界树爬塔达到多少层	{tree_climb,0,层数}
tree_climb(Role, Value) ->
	do_check(Role, tree_climb, {0, Value}).


% 通关某个试炼场	{trial，试炼场ID, 0}
trial(Role, Target) ->
	do_check(Role, trial, {Target, 1}).


% 竞技场胜利多少次	{competitive_win，0,次数}
competitive_win(Role) ->
	do_check_target_accumulate(Role, competitive_win, {0, 1}),
	{ok}.


% 竞技场失败多少次	{competitive_loss，0,次数}
competitive_loss(Role) ->
	do_check_target_accumulate(Role, competitive_loss, {0, 1}),
	{ok}.


% 参加王国远征多少次	{kingdomfight，0，次数}
kingdomfight(Role) ->
	do_check_target_accumulate(Role, kingdomfight, {0, 1}).

% 参加世界树爬塔多少次	{tree_climb_times，0，次数}
tree_climb_times(Role) ->
	do_check_target_accumulate(Role, tree_climb_times, {0, 1}).

% 参加缉猎海盗多少次	{pirate，0，次数}
pirate(Role) ->
	do_check_target_accumulate(Role, pirate, {0, 1}).


% 参加守城伐龙多少次
% {dragon_boss，0，次数}
dragon_boss(Role) ->
	do_check_target_accumulate(Role, dragon_boss, {0, 1}).


%% 全部都是比较类型的检查
do_check(_, _, _) -> 
	ok.
% do_check(Role = #role{id = Id, name = Name}, Label, {Target, Value}) -> 
% 	case check_current_condition(Role, Label, {Target, Value}) of 
% 		{RandomId, AwardId, AllCond} ->
% 			del_cond(Role, RandomId, AllCond),
% 			send_award_and_said(Id, RandomId, AwardId, Name);
% 		_ -> ok
% 	end.


% check_current_condition(Role, Label, {Target, Value}) ->
% 	MCond = get_role_award_data(Role), 
% 	Data = [D0||D0 = #random_award{label = Label1, target = Target1} <- MCond, Label1 == Label, Target1 == Target],
% 	Filter = [D||D = #random_award{label = Label1, target = Target1, value = Val} <- Data, Label1 == Label, Value >= Val, Target1 == Target],
% 	case Filter of 
% 		[] -> false;
% 		[#random_award{id = ID, award_id = AwardId}|_] -> 	
% 			{ID, AwardId, MCond}
% 	end.

% del_cond(_Role = #role{id = {Rid, _}}, ID, AllCond) -> 
% 	NAllCond = lists:keydelete(ID, #random_award.id, AllCond),
% 	put(random_award_cond, NAllCond),
% 	random_award_mgr:update_cur_cond(Rid, NAllCond),
% 	ok.

do_check_target_accumulate(_, _, _) ->
	ok.
% do_check_target_accumulate(Role = #role{id = Id = {Rid, _}, name = Name}, Label, {Target, Value}) ->
	% Data = get_role_award_data(Role),
	% Data1 = [D||D = #random_award{label = Label1, target = Target1} <- Data, Label1 == Label, Target1 == Target],
	% Finish = [D1||D1 = #random_award{value = V1} <- Data1, Value >= V1],

	% Update1 = Data1 -- Finish,
	% Update2 = [D2#random_award{value = V1 - Value}||D2 = #random_award{value = V1} <- Update1],

	% NData = Data -- Data1,
	% NData1 = Update2 ++ NData,
	% put(random_award_cond, NData1),
	% random_award_mgr:update_cur_cond(Rid, NData1),
	% [send_award_and_said(Id, RandomId, AwardId, Name)||#random_award{id = RandomId, award_id = AwardId} <- Finish].

% get_role_award_data(Role) ->
% 	MCond = 
% 		case get(random_award_cond) of 
% 			Data when is_list(Data) -> 
% 				Data;
% 			_ -> 
% 				random_award_mgr:get_cur_cond(Role) %%[{lable,target,target_value, award_id}...]
% 		end,
% 	MCond.

% send_award_and_said(Rid, RandomId, AwardId, Name) ->
% 	case random_award_data:get_said_info(RandomId) of 
% 		<<>> -> ignore;
% 		Msg -> 
% 			RoleMsg = notice:role_to_msg(Name),
% 			role_group:pack_cast(world, 10932, {7, 1, util:fbin(?L(Msg), [RoleMsg])})
% 	end,
% 	if
% 		AwardId =/= 0 ->
% 			award:send(Rid, AwardId);
% 		true -> 
% 			ignore
% 	end.	