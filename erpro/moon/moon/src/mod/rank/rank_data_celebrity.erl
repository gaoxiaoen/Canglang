%% -----------------------
%% 名人榜配置表
%% @autor wangweibiao
%% ------------------------
-module(rank_data_celebrity).
-export([
        list/0
        ,get/1
    ]
).

-include("condition.hrl").
-include("rank.hrl").
-include("gain.hrl").


list() -> [11101,11102,11103,11104,11105,11106,11107,11108,11201,11202,11203,11204,11205,11206,11207,11208,12101,12102,12103,12104,12201,12202,12203,12204,13101,13102,13103,13104,13201,13202,13203,13204].

get(11101) ->
	{ok,	
		#rank_data_celebrity{
			id = 11101, 
			name = <<"中庭之国里第一个战斗力达到4500的战士，成长卓绝！">>,
			honor = <<"厉风之雄鹰">>,
			condition = #condition{label = fight_capacity,target = 0,target_value = 4500},
			rewards = 201001			
			}
	};
get(11102) ->
	{ok,	
		#rank_data_celebrity{
			id = 11102, 
			name = <<"中庭之国里第一个战斗力达到9000的战士，战力显赫！">>,
			honor = <<"王国之铁拳">>,
			condition = #condition{label = fight_capacity,target = 0,target_value = 9000},
			rewards = 201002			
			}
	};
get(11103) ->
	{ok,	
		#rank_data_celebrity{
			id = 11103, 
			name = <<"中庭之国里第一个战斗力达到15000的战士，威震四方！">>,
			honor = <<"咆哮之雄狮">>,
			condition = #condition{label = fight_capacity,target = 0,target_value = 15000},
			rewards = 201003			
			}
	};
get(11104) ->
	{ok,	
		#rank_data_celebrity{
			id = 11104, 
			name = <<"中庭之国里第一个战斗力达到30000的战士，谁与争锋！">>,
			honor = <<"中庭之极巅">>,
			condition = #condition{label = fight_capacity,target = 0,target_value = 30000},
			rewards = 201004			
			}
	};
get(11105) ->
	{ok,	
		#rank_data_celebrity{
			id = 11105, 
			name = <<"中庭之国里第一个全部神觉等级达到20的战士！">>,
			honor = <<"神性研修者">>,
			condition = #condition{label = divine_lev,target = 20,target_value = 8},
			rewards = 201005			
			}
	};
get(11106) ->
	{ok,	
		#rank_data_celebrity{
			id = 11106, 
			name = <<"中庭之国里第一个全部神觉等级达到40的战士！">>,
			honor = <<"神性觉醒者">>,
			condition = #condition{label = divine_lev,target = 40,target_value = 8},
			rewards = 201006			
			}
	};
get(11107) ->
	{ok,	
		#rank_data_celebrity{
			id = 11107, 
			name = <<"中庭之国里第一个全部神觉强化达到30的战士！">>,
			honor = <<"神性炼悟者">>,
			condition = #condition{label = divine_jd,target = 30,target_value = 8},
			rewards = 201007			
			}
	};
get(11108) ->
	{ok,	
		#rank_data_celebrity{
			id = 11108, 
			name = <<"中庭之国里第一个全部神觉强化达到50的战士！">>,
			honor = <<"神性不朽者">>,
			condition = #condition{label = divine_jd,target = 50,target_value = 8},
			rewards = 201008			
			}
	};
get(11201) ->
	{ok,	
		#rank_data_celebrity{
			id = 11201, 
			name = <<"中庭之国第一个获得全身蓝色套装的战士！">>,
			honor = <<"霜雪冰甲">>,
			condition = #condition{label = c_suit,target = 2,target_value = 10},
			rewards = 201009			
			}
	};
get(11202) ->
	{ok,	
		#rank_data_celebrity{
			id = 11202, 
			name = <<"中庭之国第一个获得全身紫色套装的战士！">>,
			honor = <<"极夜星甲">>,
			condition = #condition{label = c_suit,target = 3,target_value = 10},
			rewards = 201010			
			}
	};
get(11203) ->
	{ok,	
		#rank_data_celebrity{
			id = 11203, 
			name = <<"中庭之国第一个获得全身粉色套装的战士！">>,
			honor = <<"晨曦霞装">>,
			condition = #condition{label = c_suit,target = 4,target_value = 10},
			rewards = 201011			
			}
	};
get(11204) ->
	{ok,	
		#rank_data_celebrity{
			id = 11204, 
			name = <<"中庭之国第一个获得全身橙色套装的战士！">>,
			honor = <<"极昼烈甲">>,
			condition = #condition{label = c_suit,target = 5,target_value = 10},
			rewards = 201012			
			}
	};
get(11205) ->
	{ok,	
		#rank_data_celebrity{
			id = 11205, 
			name = <<"中庭之国第一个全身装备强化+30的战士！">>,
			honor = <<"精湛之甲">>,
			condition = #condition{label = all_qh_suit,target = 0,target_value = 30},
			rewards = 201013			
			}
	};
get(11206) ->
	{ok,	
		#rank_data_celebrity{
			id = 11206, 
			name = <<"中庭之国第一个全身装备强化+60的战士！">>,
			honor = <<"卓越之甲">>,
			condition = #condition{label = all_qh_suit,target = 0,target_value = 60},
			rewards = 201014			
			}
	};
get(11207) ->
	{ok,	
		#rank_data_celebrity{
			id = 11207, 
			name = <<"中庭之国第一个全身镶嵌3级宝石的战士！">>,
			honor = <<"星辰之甲">>,
			condition = #condition{label = all_bs_suit,target = 0,target_value = 3},
			rewards = 201015			
			}
	};
get(11208) ->
	{ok,	
		#rank_data_celebrity{
			id = 11208, 
			name = <<"中庭之国第一个全身镶嵌6级宝石的战士！">>,
			honor = <<"光辉之甲">>,
			condition = #condition{label = all_bs_suit,target = 0,target_value = 6},
			rewards = 201016			
			}
	};
get(12101) ->
	{ok,	
		#rank_data_celebrity{
			id = 12101, 
			name = <<"中庭之国第一个伙伴战斗力达到2000的战士！">>,
			honor = <<"苏醒之龙">>,
			condition = #condition{label = dragon_fight_capacity,target = 0,target_value = 2000},
			rewards = 201017			
			}
	};
get(12102) ->
	{ok,	
		#rank_data_celebrity{
			id = 12102, 
			name = <<"中庭之国第一个伙伴战斗力达到5000的战士！">>,
			honor = <<"破空之龙">>,
			condition = #condition{label = dragon_fight_capacity,target = 0,target_value = 5000},
			rewards = 201018			
			}
	};
get(12103) ->
	{ok,	
		#rank_data_celebrity{
			id = 12103, 
			name = <<"中庭之国第一个伙伴拥有高阶4级技能的战士！">>,
			honor = <<"奇迹之龙">>,
			condition = #condition{label = dragon_skill_high,target = 0,target_value = 4},
			rewards = 201019			
			}
	};
get(12104) ->
	{ok,	
		#rank_data_celebrity{
			id = 12104, 
			name = <<"中庭之国第一个伙伴拥有高阶8级技能的战士！">>,
			honor = <<"传说之龙">>,
			condition = #condition{label = dragon_skill_high,target = 0,target_value = 8},
			rewards = 201020			
			}
	};
get(12201) ->
	{ok,	
		#rank_data_celebrity{
			id = 12201, 
			name = <<"中庭之国第一个伙伴平均潜力达到100的战士！">>,
			honor = <<"追风之龙">>,
			condition = #condition{label = dragon_bone,target = 0,target_value = 100},
			rewards = 201021			
			}
	};
get(12202) ->
	{ok,	
		#rank_data_celebrity{
			id = 12202, 
			name = <<"中庭之国第一个伙伴平均潜力达到200的战士！">>,
			honor = <<"浴火之龙">>,
			condition = #condition{label = dragon_bone,target = 0,target_value = 200},
			rewards = 201022			
			}
	};
get(12203) ->
	{ok,	
		#rank_data_celebrity{
			id = 12203, 
			name = <<"中庭之国第一个伙伴平均潜力达到300的战士！">>,
			honor = <<"驱雷之龙">>,
			condition = #condition{label = dragon_bone,target = 0,target_value = 300},
			rewards = 201023			
			}
	};
get(12204) ->
	{ok,	
		#rank_data_celebrity{
			id = 12204, 
			name = <<"中庭之国第一个伙伴平均潜力达到500的战士！">>,
			honor = <<"应天之龙">>,
			condition = #condition{label = dragon_bone,target = 0,target_value = 500},
			rewards = 201024			
			}
	};
get(13101) ->
	{ok,	
		#rank_data_celebrity{
			id = 13101, 
			name = <<"中庭之国第一个守城伐龙对恶龙造成总70万伤害的战士！">>,
			honor = <<"伐龙勇者">>,
			condition = #condition{label = dragon_boss_hit,target = 0,target_value = 700000},
			rewards = 201025			
			}
	};
get(13102) ->
	{ok,	
		#rank_data_celebrity{
			id = 13102, 
			name = <<"中庭之国第一个守城伐龙对恶龙造成总100万伤害的战士！">>,
			honor = <<"弑龙勇将">>,
			condition = #condition{label = dragon_boss_hit,target = 0,target_value = 1000000},
			rewards = 201026			
			}
	};
get(13103) ->
	{ok,	
		#rank_data_celebrity{
			id = 13103, 
			name = <<"中庭之国第一个击杀鼠海盗的战士！">>,
			honor = <<"赏金猎手">>,
			condition = #condition{label = pirate_kill,target = 0,target_value = 15011},
			rewards = 201027			
			}
	};
get(13104) ->
	{ok,	
		#rank_data_celebrity{
			id = 13104, 
			name = <<"中庭之国第一个击杀维京海盗的战士！">>,
			honor = <<"维京克星">>,
			condition = #condition{label = pirate_kill,target = 0,target_value = 15012},
			rewards = 201028			
			}
	};
get(13201) ->
	{ok,	
		#rank_data_celebrity{
			id = 13201, 
			name = <<"中庭之国第一个世界树达到30层的战士！">>,
			honor = <<"世界树窥望者">>,
			condition = #condition{label = tree_climb,target = 0,target_value = 30},
			rewards = 201029			
			}
	};
get(13202) ->
	{ok,	
		#rank_data_celebrity{
			id = 13202, 
			name = <<"中庭之国第一个世界树达到50层的战士！">>,
			honor = <<"世界树漫步者">>,
			condition = #condition{label = tree_climb,target = 0,target_value = 50},
			rewards = 201030			
			}
	};
get(13203) ->
	{ok,	
		#rank_data_celebrity{
			id = 13203, 
			name = <<"中庭之国第一个世界树达到80层的战士！">>,
			honor = <<"世界树修行者">>,
			condition = #condition{label = tree_climb,target = 0,target_value = 80},
			rewards = 201031			
			}
	};
get(13204) ->
	{ok,	
		#rank_data_celebrity{
			id = 13204, 
			name = <<"中庭之国第一个世界树达到100层的战士！">>,
			honor = <<"世界树登峰者">>,
			condition = #condition{label = tree_climb,target = 0,target_value = 100},
			rewards = 201032			
			}
	};
get(_Id) ->
    {false, <<"不存在此数据">>}.


