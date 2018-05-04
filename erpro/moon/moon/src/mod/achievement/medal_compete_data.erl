%% -----------------------
%% 竞技勋章配置表
%% @autor wangweibiao
%% ------------------------
-module(medal_compete_data).
-export([
		get_all_condition/0,
		get_honor_badge/1,
		get_honor_effect/1,
		get_honor_puton_attr/1,
		get_medal/1
		]).

-include("condition.hrl").
-include("achievement.hrl").
-include("common.hrl").
-include("item.hrl").


get_all_condition() ->
	[
	#condition{code = 20000, label = honor, target = 0, target_value = 1500},
	#condition{code = 20001, label = honor, target = 0, target_value = 3000},
	#condition{code = 20002, label = honor, target = 0, target_value = 6000},
	#condition{code = 20003, label = honor, target = 0, target_value = 10000},
	#condition{code = 20004, label = honor, target = 0, target_value = 15000},
	#condition{code = 20005, label = honor, target = 0, target_value = 20000},
	#condition{code = 20006, label = honor, target = 0, target_value = 30000},
	#condition{code = 20007, label = honor, target = 0, target_value = 50000},
	#condition{code = 20008, label = honor, target = 0, target_value = 75000},
	#condition{code = 20009, label = honor, target = 0, target_value = 100000},
	#condition{code = 21000, label = compete_2v2, target = win, target_value = 150},
	#condition{code = 21001, label = compete_2v2, target = win, target_value = 500},
	#condition{code = 21002, label = compete_2v2, target = win, target_value = 1000},
	#condition{code = 21003, label = compete_2v2, target = win, target_value = 2000},
	#condition{code = 22000, label = compete_2v2, target = die, target_value = 200},
	#condition{code = 22001, label = compete_2v2, target = die, target_value = 500},
	#condition{code = 22002, label = compete_2v2, target = die, target_value = 1000},
	#condition{code = 22003, label = compete_2v2, target = die, target_value = 2000}	
	].

get_medal(20000) ->
	{ok,
		#compete_medal{
			id = 20000,
			attr = [{?attr_hp_max, 200},{?attr_rst_all,55}]}};
get_medal(20001) ->
	{ok,
		#compete_medal{
			id = 20001,
			attr = [{?attr_hp_max, 350},{?attr_rst_all,75},{?attr_dmg_magic,25}]}};
get_medal(20002) ->
	{ok,
		#compete_medal{
			id = 20002,
			attr = [{?attr_hp_max, 600},{?attr_rst_all,100},{?attr_dmg_magic,50}]}};
get_medal(20003) ->
	{ok,
		#compete_medal{
			id = 20003,
			attr = [{?attr_hp_max, 750},{?attr_rst_all,125},{?attr_dmg_magic,75},{?attr_evasion,10},{?attr_tenacity,10}]}};
get_medal(20004) ->
	{ok,
		#compete_medal{
			id = 20004,
			attr = [{?attr_hp_max, 900},{?attr_rst_all,145},{?attr_dmg_magic,95},{?attr_evasion,12},{?attr_tenacity,12}]}};
get_medal(20005) ->
	{ok,
		#compete_medal{
			id = 20005,
			attr = [{?attr_hp_max, 1200},{?attr_rst_all,180},{?attr_dmg_magic,125},{?attr_evasion,15},{?attr_tenacity,15}]}};
get_medal(20006) ->
	{ok,
		#compete_medal{
			id = 20006,
			attr = [{?attr_hp_max, 1500},{?attr_rst_all,200},{?attr_dmg_magic,135},{?attr_evasion,18},{?attr_tenacity,18}]}};
get_medal(20007) ->
	{ok,
		#compete_medal{
			id = 20007,
			attr = [{?attr_hp_max, 1550},{?attr_rst_all,225},{?attr_dmg_magic,150},{?attr_evasion,20},{?attr_tenacity,20}]}};
get_medal(20008) ->
	{ok,
		#compete_medal{
			id = 20008,
			attr = [{?attr_hp_max, 1650},{?attr_rst_all,250},{?attr_dmg_magic,165},{?attr_evasion,22},{?attr_tenacity,22}]}};
get_medal(20009) ->
	{ok,
		#compete_medal{
			id = 20009,
			attr = [{?attr_hp_max, 1800},{?attr_rst_all,265},{?attr_dmg_magic,180},{?attr_evasion,25},{?attr_tenacity,25}]}};
get_medal(21000) ->
	{ok,
		#compete_medal{
			id = 21000,
			attr = [{?attr_hp_max, 350},{?attr_rst_all,75},{?attr_dmg_magic,25}]}};
get_medal(21001) ->
	{ok,
		#compete_medal{
			id = 21001,
			attr = [{?attr_hp_max, 750},{?attr_rst_all,125},{?attr_dmg_magic,75},{?attr_evasion,10},{?attr_tenacity,10}]}};
get_medal(21002) ->
	{ok,
		#compete_medal{
			id = 21002,
			attr = [{?attr_hp_max, 1200},{?attr_rst_all,180},{?attr_dmg_magic,125},{?attr_evasion,15},{?attr_tenacity,15}]}};
get_medal(21003) ->
	{ok,
		#compete_medal{
			id = 21003,
			attr = [{?attr_hp_max, 1550},{?attr_rst_all,225},{?attr_dmg_magic,150},{?attr_evasion,20},{?attr_tenacity,20}]}};
get_medal(22000) ->
	{ok,
		#compete_medal{
			id = 22000,
			attr = [{?attr_hp_max, 350},{?attr_rst_all,75},{?attr_dmg_magic,25}]}};
get_medal(22001) ->
	{ok,
		#compete_medal{
			id = 22001,
			attr = [{?attr_hp_max, 750},{?attr_rst_all,125},{?attr_dmg_magic,75},{?attr_evasion,10},{?attr_tenacity,10}]}};
get_medal(22002) ->
	{ok,
		#compete_medal{
			id = 22002,
			attr = [{?attr_hp_max, 1200},{?attr_rst_all,180},{?attr_dmg_magic,125},{?attr_evasion,15},{?attr_tenacity,15}]}};
get_medal(22003) ->
	{ok,
		#compete_medal{
			id = 22003,
			attr = [{?attr_hp_max, 1550},{?attr_rst_all,225},{?attr_dmg_magic,150},{?attr_evasion,20},{?attr_tenacity,20}]}};
get_medal(_Tmp) ->
	?ERR("找不到勋章信息，勋章id:~w", [_Tmp]),
	{false, ?MSGID(<<"找不到勋章信息">>)}.

get_honor_puton_attr(20000) ->
	[{?attr_hp_max, 2000},{?attr_rst_all,500}];
get_honor_puton_attr(20001) ->
	[{?attr_hp_max, 3000},{?attr_rst_all,800},{?attr_mp_max, 200}];
get_honor_puton_attr(20002) ->
	[{?attr_hp_max, 4000},{?attr_rst_all,1500},{?attr_mp_max, 600}];
get_honor_puton_attr(20003) ->
	[{?attr_hp_max, 5500},{?attr_rst_all,2000},{?attr_mp_max, 800},{?attr_evasion,80},{?attr_tenacity,120}];
get_honor_puton_attr(20004) ->
	[{?attr_hp_max, 7000},{?attr_rst_all,3500},{?attr_mp_max, 1000},{?attr_evasion,120},{?attr_tenacity,150}];
get_honor_puton_attr(20005) ->
	[{?attr_hp_max, 8500},{?attr_rst_all,4200},{?attr_mp_max, 1250},{?attr_evasion,160},{?attr_tenacity,250}];
get_honor_puton_attr(20006) ->
	[{?attr_hp_max, 8500},{?attr_rst_all,6000},{?attr_mp_max, 1600},{?attr_evasion,160},{?attr_tenacity,250},{?attr_dmg_magic,120}];
get_honor_puton_attr(20007) ->
	[{?attr_hp_max, 10000},{?attr_rst_all,7000},{?attr_mp_max, 2600},{?attr_evasion,200},{?attr_tenacity,280},{?attr_dmg_magic,160}];
get_honor_puton_attr(20008) ->
	[{?attr_hp_max, 12000},{?attr_rst_all,8000},{?attr_mp_max, 2300},{?attr_evasion,220},{?attr_tenacity,300},{?attr_dmg_magic,200}];
get_honor_puton_attr(20009) ->
	[{?attr_hp_max, 13500},{?attr_rst_all,9000},{?attr_mp_max, 2800},{?attr_evasion,250},{?attr_tenacity,320},{?attr_dmg_magic,280}];
get_honor_puton_attr(21000) ->
	[{?attr_hp_max, 4000},{?attr_rst_all,1500},{?attr_mp_max, 600}];
get_honor_puton_attr(21001) ->
	[{?attr_hp_max, 4000},{?attr_rst_all,1500},{?attr_mp_max, 600}];
get_honor_puton_attr(21002) ->
	[{?attr_hp_max, 4000},{?attr_rst_all,1500},{?attr_mp_max, 600}];
get_honor_puton_attr(21003) ->
	[{?attr_hp_max, 4000},{?attr_rst_all,1500},{?attr_mp_max, 600}];
get_honor_puton_attr(22000) ->
	[{?attr_hp_max, 1000},{?attr_rst_all,300}];
get_honor_puton_attr(22001) ->
	[{?attr_hp_max, 1000},{?attr_rst_all,300}];
get_honor_puton_attr(22002) ->
	[{?attr_hp_max, 1000},{?attr_rst_all,300}];
get_honor_puton_attr(22003) ->
	[{?attr_hp_max, 1000},{?attr_rst_all,300}];
get_honor_puton_attr(_Tmp) ->
	?ERR("找不到称号佩戴属性，称号id:~w", [_Tmp]),
	[].
		
	
get_honor_badge(20000) ->
	100;
get_honor_badge(20001) ->
	130;
get_honor_badge(20002) ->
	150;
get_honor_badge(20003) ->
	150;
get_honor_badge(20004) ->
	150;
get_honor_badge(20005) ->
	150;
get_honor_badge(20006) ->
	150;
get_honor_badge(20007) ->
	150;
get_honor_badge(20008) ->
	150;
get_honor_badge(20009) ->
	288;
get_honor_badge(21000) ->
	150;
get_honor_badge(21001) ->
	150;
get_honor_badge(21002) ->
	150;
get_honor_badge(21003) ->
	150;
get_honor_badge(22000) ->
	50;
get_honor_badge(22001) ->
	50;
get_honor_badge(22002) ->
	50;
get_honor_badge(22003) ->
	50;
get_honor_badge(_Tmp) ->
	?ERR("找不到称号兑换需要纹章的数值，称号id:~w", [_Tmp]),
	0.
	
get_honor_effect(20000) ->
	7;
get_honor_effect(20001) ->
	7;
get_honor_effect(20002) ->
	7;
get_honor_effect(20003) ->
	7;
get_honor_effect(20004) ->
	7;
get_honor_effect(20005) ->
	7;
get_honor_effect(20006) ->
	7;
get_honor_effect(20007) ->
	7;
get_honor_effect(20008) ->
	7;
get_honor_effect(20009) ->
	7;
get_honor_effect(21000) ->
	7;
get_honor_effect(21001) ->
	7;
get_honor_effect(21002) ->
	7;
get_honor_effect(21003) ->
	7;
get_honor_effect(22000) ->
	30;
get_honor_effect(22001) ->
	30;
get_honor_effect(22002) ->
	30;
get_honor_effect(22003) ->
	30;
get_honor_effect(_Tmp) ->
	?ERR("找不到称号有效时间值，称号id:~w", [_Tmp]),
	0.	

