
%% -----------------------
%% @autor wangweibiao
%% ------------------------
-module(demon_data2).
-export([
		get_demon_base/1
		,get_demon_base_attr/1
		,get_demon_init_attr/1
		,get_quality_bless/1
		,get_buff_id/1
		,get_demon_effect/1
		,get_demon_weight/1
		,get_wake_weight/1
		,get_grab_info/1 %% 理论上是否可掠夺应该是一个属性
		]).

-include("demon.hrl").
-include("common.hrl").
-include("item.hrl").

%% dmg 攻击
%% critrate 暴怒
%% hp_max 生命
%% mp_max 魔法
%% defence 防御
%% tenacity 坚韧
%% evasion 格挡
%% hitrate 精准
%% dmg_max 绝对伤害


get_quality_bless(1) -> 1;
get_quality_bless(2) -> 3;
get_quality_bless(3) -> 10;
get_quality_bless(4) -> 15;
get_quality_bless(5) -> 20;
get_quality_bless(6) -> 25;
get_quality_bless(_) -> 0.


get_demon_base(10201) -> 
	{ok,
		#demon2{base_id = 10201,
		name = <<"灰烬恶魔">>,
		craft = 2,
		skills = [805101,809101],
		debris = 641001,
		debris_num = 40,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(10202) -> 
	{ok,
		#demon2{base_id = 10202,
		name = <<"牛头恶魔">>,
		craft = 1,
		skills = [802101,809101],
		debris = 641002,
		debris_num = 20,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(10204) -> 
	{ok,
		#demon2{base_id = 10204,
		name = <<"虚空树妖">>,
		craft = 1,
		skills = [823101],
		debris = 641003,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(10205) -> 
	{ok,
		#demon2{base_id = 10205,
		name = <<"狂暴野猪">>,
		craft = 1,
		skills = [804101],
		debris = 641004,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(10206) -> 
	{ok,
		#demon2{base_id = 10206,
		name = <<"咆哮棕熊">>,
		craft = 1,
		skills = [814101],
		debris = 641005,
		debris_num = 20,
		devour = 12,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(10207) -> 
	{ok,
		#demon2{base_id = 10207,
		name = <<"南瓜怪">>,
		craft = 2,
		skills = [801101,guild_defence_21],
		debris = 641006,
		debris_num = 40,
		devour = 50,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(10210) -> 
	{ok,
		#demon2{base_id = 10210,
		name = <<"蓝晶巨石怪">>,
		craft = 2,
		skills = [813101,guild_tenacity_21],
		debris = 641007,
		debris_num = 40,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(10212) -> 
	{ok,
		#demon2{base_id = 10212,
		name = <<"洞穴蜥蜴">>,
		craft = 1,
		skills = [807101],
		debris = 641008,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(10213) -> 
	{ok,
		#demon2{base_id = 10213,
		name = <<"树根蜥蜴">>,
		craft = 1,
		skills = [807101],
		debris = 641009,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(10214) -> 
	{ok,
		#demon2{base_id = 10214,
		name = <<"沙漠蜥蜴">>,
		craft = 2,
		skills = [807201,guild_evasion_21],
		debris = 641010,
		debris_num = 40,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(10215) -> 
	{ok,
		#demon2{base_id = 10215,
		name = <<"骷髅法师">>,
		craft = 3,
		skills = [805201,810201,guild_dmg_21],
		debris = 641011,
		debris_num = 60,
		devour = 360,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(10216) -> 
	{ok,
		#demon2{base_id = 10216,
		name = <<"黑暗树根怪">>,
		craft = 2,
		skills = [810101,guild_mp_21],
		debris = 641012,
		debris_num = 40,
		devour = 54,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(10217) -> 
	{ok,
		#demon2{base_id = 10217,
		name = <<"诅咒树根怪">>,
		craft = 2,
		skills = [803201,811101],
		debris = 641013,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(10218) -> 
	{ok,
		#demon2{base_id = 10218,
		name = <<"混沌沙虫">>,
		craft = 2,
		skills = [822101,guild_critrate_21],
		debris = 641014,
		debris_num = 40,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(10219) -> 
	{ok,
		#demon2{base_id = 10219,
		name = <<"骷髅骑士">>,
		craft = 2,
		skills = [811201,guild_defence_22],
		debris = 641015,
		debris_num = 40,
		devour = 54,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(10220) -> 
	{ok,
		#demon2{base_id = 10220,
		name = <<"救赎叶子精">>,
		craft = 3,
		skills = [823201,813101,guild_evasion_22],
		debris = 641016,
		debris_num = 60,
		devour = 300,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(10285) -> 
	{ok,
		#demon2{base_id = 10285,
		name = <<"部落地精">>,
		craft = 2,
		skills = [822201,guild_hp_21],
		debris = 641017,
		debris_num = 40,
		devour = 54,
		attack_type = 1,
		grow_max = 3		
		}
	};
get_demon_base(10226) -> 
	{ok,
		#demon2{base_id = 10226,
		name = <<"怒焰恶魔">>,
		craft = 3,
		skills = [814201,guild_critrate_22,802201],
		debris = 641019,
		debris_num = 60,
		devour = 300,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(10227) -> 
	{ok,
		#demon2{base_id = 10227,
		name = <<"深渊沙虫">>,
		craft = 2,
		skills = [807201,810101],
		debris = 641020,
		debris_num = 40,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(10230) -> 
	{ok,
		#demon2{base_id = 10230,
		name = <<"远古骷髅">>,
		craft = 2,
		skills = [805201,803201],
		debris = 641023,
		debris_num = 40,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(10231) -> 
	{ok,
		#demon2{base_id = 10231,
		name = <<"幽暗树蛙">>,
		craft = 1,
		skills = [824101],
		debris = 641024,
		debris_num = 20,
		devour = 12,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(10232) -> 
	{ok,
		#demon2{base_id = 10232,
		name = <<"野蛮小草">>,
		craft = 1,
		skills = [guild_hitrate_21],
		debris = 641025,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(10234) -> 
	{ok,
		#demon2{base_id = 10234,
		name = <<"剑士兔">>,
		craft = 3,
		skills = [807201,822201,guild_dmg_22],
		debris = 641026,
		debris_num = 60,
		devour = 300,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(10235) -> 
	{ok,
		#demon2{base_id = 10235,
		name = <<"铠甲骑士马">>,
		craft = 3,
		skills = [806301,825201,guild_defence_23],
		debris = 641027,
		debris_num = 60,
		devour = 360,
		attack_type = 0,
		grow_max = 5		
		}
	};
get_demon_base(10236) -> 
	{ok,
		#demon2{base_id = 10236,
		name = <<"拳王">>,
		craft = 1,
		skills = [814201],
		debris = 641028,
		debris_num = 20,
		devour = 5,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(10237) -> 
	{ok,
		#demon2{base_id = 10237,
		name = <<"荒野猎人">>,
		craft = 2,
		skills = [811201,813201],
		debris = 641029,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(10239) -> 
	{ok,
		#demon2{base_id = 10239,
		name = <<"巨翼灵兵">>,
		craft = 3,
		skills = [811301,802301,guild_dmg_22],
		debris = 641030,
		debris_num = 60,
		devour = 320,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(10240) -> 
	{ok,
		#demon2{base_id = 10240,
		name = <<"史诗骑士">>,
		craft = 3,
		skills = [806301,804301,813301],
		debris = 641031,
		debris_num = 60,
		devour = 320,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(10241) -> 
	{ok,
		#demon2{base_id = 10241,
		name = <<"花之精灵">>,
		craft = 3,
		skills = [824201,guild_tenacity_22,guild_hp_22],
		debris = 641032,
		debris_num = 60,
		devour = 320,
		attack_type = 1,
		grow_max = 4		
		}
	};
get_demon_base(10242) -> 
	{ok,
		#demon2{base_id = 10242,
		name = <<"火之精灵">>,
		craft = 3,
		skills = [825201,823201,guild_dmg_22],
		debris = 641033,
		debris_num = 60,
		devour = 300,
		attack_type = 1,
		grow_max = 4		
		}
	};
get_demon_base(10244) -> 
	{ok,
		#demon2{base_id = 10244,
		name = <<"石之精灵">>,
		craft = 3,
		skills = [813201,810301,guild_defence_23],
		debris = 641034,
		debris_num = 60,
		devour = 360,
		attack_type = 1,
		grow_max = 4		
		}
	};
get_demon_base(10245) -> 
	{ok,
		#demon2{base_id = 10245,
		name = <<"棕熊法师">>,
		craft = 3,
		skills = [810301,824201,guild_hp_22],
		debris = 641035,
		debris_num = 60,
		devour = 300,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(10246) -> 
	{ok,
		#demon2{base_id = 10246,
		name = <<"黄铜守卫">>,
		craft = 2,
		skills = [813201,811201],
		debris = 641036,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(10247) -> 
	{ok,
		#demon2{base_id = 10247,
		name = <<"绿革守卫">>,
		craft = 1,
		skills = [813201,806201],
		debris = 641037,
		debris_num = 20,
		devour = 60,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(10248) -> 
	{ok,
		#demon2{base_id = 10248,
		name = <<"银甲守卫">>,
		craft = 3,
		skills = [813301,807301,guild_tenacity_22],
		debris = 641038,
		debris_num = 60,
		devour = 360,
		attack_type = 0,
		grow_max = 5		
		}
	};
get_demon_base(10252) -> 
	{ok,
		#demon2{base_id = 10252,
		name = <<"永罚怨灵">>,
		craft = 1,
		skills = [803101],
		debris = 641039,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(10253) -> 
	{ok,
		#demon2{base_id = 10253,
		name = <<"种子怪">>,
		craft = 1,
		skills = [guild_critrate_21],
		debris = 641040,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(10254) -> 
	{ok,
		#demon2{base_id = 10254,
		name = <<"破晓女神">>,
		craft = 3,
		skills = [801301,824301,guild_hp_22],
		debris = 641041,
		debris_num = 60,
		devour = 400,
		attack_type = 0,
		grow_max = 5		
		}
	};
get_demon_base(10256) -> 
	{ok,
		#demon2{base_id = 10256,
		name = <<"半人马法师">>,
		craft = 3,
		skills = [802301,806301,guild_mp_22],
		debris = 641043,
		debris_num = 60,
		devour = 360,
		attack_type = 0,
		grow_max = 5		
		}
	};
get_demon_base(20007) -> 
	{ok,
		#demon2{base_id = 20007,
		name = <<"噩梦女巫">>,
		craft = 3,
		skills = [805301,811201,814201],
		debris = 641046,
		debris_num = 60,
		devour = 300,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(10200) -> 
	{ok,
		#demon2{base_id = 10200,
		name = <<"遗落松鼠">>,
		craft = 2,
		skills = [803201,guild_critrate_21],
		debris = 641047,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(10273) -> 
	{ok,
		#demon2{base_id = 10273,
		name = <<"狂野水精">>,
		craft = 1,
		skills = [guild_tenacity_21],
		debris = 641048,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(10274) -> 
	{ok,
		#demon2{base_id = 10274,
		name = <<"燃草火精">>,
		craft = 2,
		skills = [812101,814201],
		debris = 641049,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(10275) -> 
	{ok,
		#demon2{base_id = 10275,
		name = <<"蒜头小兵">>,
		craft = 2,
		skills = [807201,822101],
		debris = 641050,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(10276) -> 
	{ok,
		#demon2{base_id = 10276,
		name = <<"森林兔子">>,
		craft = 2,
		skills = [guild_critrate_21,807101],
		debris = 641051,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(10277) -> 
	{ok,
		#demon2{base_id = 10277,
		name = <<"幽惑花妖">>,
		craft = 1,
		skills = [guild_hp_21],
		debris = 641052,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(118009) -> 
	{ok,
		#demon2{base_id = 118009,
		name = <<"雷神">>,
		craft = 75,
		skills = [822301,guild_dmg_23,825301,guild_hitrate_23],
		debris = 0,
		debris_num = 0,
		devour = 500,
		attack_type = 0,
		grow_max = 5		
		}
	};
get_demon_base(118010) -> 
	{ok,
		#demon2{base_id = 118010,
		name = <<"精灵王子">>,
		craft = 75,
		skills = [814301,guild_evasion_23,812301,guild_hp_23],
		debris = 1,
		debris_num = 0,
		devour = 500,
		attack_type = 1,
		grow_max = 5		
		}
	};
get_demon_base(118011) -> 
	{ok,
		#demon2{base_id = 118011,
		name = <<"美人鱼">>,
		craft = 73,
		skills = [guild_tenacity_23,803301,823301],
		debris = 2,
		debris_num = 0,
		devour = 500,
		attack_type = 0,
		grow_max = 5		
		}
	};
get_demon_base(118012) -> 
	{ok,
		#demon2{base_id = 118012,
		name = <<"小红帽">>,
		craft = 73,
		skills = [815201,guild_hp_22,guild_dmg_22],
		debris = 3,
		debris_num = 0,
		devour = 500,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(110201) -> 
	{ok,
		#demon2{base_id = 110201,
		name = <<"灰烬恶魔">>,
		craft = 2,
		skills = [805101,809101],
		debris = 641001,
		debris_num = 40,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(110202) -> 
	{ok,
		#demon2{base_id = 110202,
		name = <<"牛头恶魔">>,
		craft = 1,
		skills = [802101,809101],
		debris = 641002,
		debris_num = 20,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(110204) -> 
	{ok,
		#demon2{base_id = 110204,
		name = <<"虚空树妖">>,
		craft = 1,
		skills = [823101],
		debris = 641003,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(110205) -> 
	{ok,
		#demon2{base_id = 110205,
		name = <<"狂暴野猪">>,
		craft = 1,
		skills = [804101],
		debris = 641004,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(110206) -> 
	{ok,
		#demon2{base_id = 110206,
		name = <<"咆哮棕熊">>,
		craft = 1,
		skills = [814101],
		debris = 641005,
		debris_num = 20,
		devour = 12,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(110207) -> 
	{ok,
		#demon2{base_id = 110207,
		name = <<"南瓜怪">>,
		craft = 2,
		skills = [801101,guild_defence_21],
		debris = 641006,
		debris_num = 40,
		devour = 50,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(110210) -> 
	{ok,
		#demon2{base_id = 110210,
		name = <<"蓝晶巨石怪">>,
		craft = 2,
		skills = [813101,guild_tenacity_21],
		debris = 641007,
		debris_num = 40,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(110212) -> 
	{ok,
		#demon2{base_id = 110212,
		name = <<"洞穴蜥蜴">>,
		craft = 1,
		skills = [807101],
		debris = 641008,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(110213) -> 
	{ok,
		#demon2{base_id = 110213,
		name = <<"树根蜥蜴">>,
		craft = 1,
		skills = [807101],
		debris = 641009,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(110214) -> 
	{ok,
		#demon2{base_id = 110214,
		name = <<"沙漠蜥蜴">>,
		craft = 2,
		skills = [807201,guild_evasion_21],
		debris = 641010,
		debris_num = 40,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(110215) -> 
	{ok,
		#demon2{base_id = 110215,
		name = <<"骷髅法师">>,
		craft = 3,
		skills = [805201,810201,guild_dmg_21],
		debris = 641011,
		debris_num = 60,
		devour = 360,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(110216) -> 
	{ok,
		#demon2{base_id = 110216,
		name = <<"黑暗树根怪">>,
		craft = 2,
		skills = [810101,guild_mp_21],
		debris = 641012,
		debris_num = 40,
		devour = 54,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(110217) -> 
	{ok,
		#demon2{base_id = 110217,
		name = <<"诅咒树根怪">>,
		craft = 2,
		skills = [803201,811101],
		debris = 641013,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(110218) -> 
	{ok,
		#demon2{base_id = 110218,
		name = <<"混沌沙虫">>,
		craft = 2,
		skills = [822101,guild_critrate_21],
		debris = 641014,
		debris_num = 40,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(110219) -> 
	{ok,
		#demon2{base_id = 110219,
		name = <<"骷髅骑士">>,
		craft = 2,
		skills = [811201,guild_defence_22],
		debris = 641015,
		debris_num = 40,
		devour = 54,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(110220) -> 
	{ok,
		#demon2{base_id = 110220,
		name = <<"救赎叶子精">>,
		craft = 3,
		skills = [823201,813101,guild_evasion_22],
		debris = 641016,
		debris_num = 60,
		devour = 300,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(110285) -> 
	{ok,
		#demon2{base_id = 110285,
		name = <<"部落地精">>,
		craft = 2,
		skills = [822201,guild_hp_21],
		debris = 641017,
		debris_num = 40,
		devour = 54,
		attack_type = 1,
		grow_max = 3		
		}
	};
get_demon_base(110226) -> 
	{ok,
		#demon2{base_id = 110226,
		name = <<"怒焰恶魔">>,
		craft = 3,
		skills = [814201,guild_critrate_22,802201],
		debris = 641019,
		debris_num = 60,
		devour = 300,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(110227) -> 
	{ok,
		#demon2{base_id = 110227,
		name = <<"深渊沙虫">>,
		craft = 2,
		skills = [807201,810101],
		debris = 641020,
		debris_num = 40,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(110230) -> 
	{ok,
		#demon2{base_id = 110230,
		name = <<"远古骷髅">>,
		craft = 2,
		skills = [805201,803201],
		debris = 641023,
		debris_num = 40,
		devour = 48,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(110231) -> 
	{ok,
		#demon2{base_id = 110231,
		name = <<"幽暗树蛙">>,
		craft = 1,
		skills = [824101],
		debris = 641024,
		debris_num = 20,
		devour = 12,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(110232) -> 
	{ok,
		#demon2{base_id = 110232,
		name = <<"野蛮小草">>,
		craft = 1,
		skills = [guild_hitrate_21],
		debris = 641025,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(110234) -> 
	{ok,
		#demon2{base_id = 110234,
		name = <<"剑士兔">>,
		craft = 3,
		skills = [807201,822201,guild_dmg_22],
		debris = 641026,
		debris_num = 60,
		devour = 300,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(110235) -> 
	{ok,
		#demon2{base_id = 110235,
		name = <<"铠甲骑士马">>,
		craft = 3,
		skills = [806301,825201,guild_defence_23],
		debris = 641027,
		debris_num = 60,
		devour = 360,
		attack_type = 0,
		grow_max = 5		
		}
	};
get_demon_base(110236) -> 
	{ok,
		#demon2{base_id = 110236,
		name = <<"拳王">>,
		craft = 1,
		skills = [814201],
		debris = 641028,
		debris_num = 20,
		devour = 5,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(110237) -> 
	{ok,
		#demon2{base_id = 110237,
		name = <<"荒野猎人">>,
		craft = 2,
		skills = [811201,813201],
		debris = 641029,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(110239) -> 
	{ok,
		#demon2{base_id = 110239,
		name = <<"巨翼灵兵">>,
		craft = 3,
		skills = [811301,802301,guild_dmg_22],
		debris = 641030,
		debris_num = 60,
		devour = 320,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(110240) -> 
	{ok,
		#demon2{base_id = 110240,
		name = <<"史诗骑士">>,
		craft = 3,
		skills = [806301,804301,813301],
		debris = 641031,
		debris_num = 60,
		devour = 320,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(110241) -> 
	{ok,
		#demon2{base_id = 110241,
		name = <<"花之精灵">>,
		craft = 3,
		skills = [824201,guild_tenacity_22,guild_hp_22],
		debris = 641032,
		debris_num = 60,
		devour = 320,
		attack_type = 1,
		grow_max = 4		
		}
	};
get_demon_base(110242) -> 
	{ok,
		#demon2{base_id = 110242,
		name = <<"火之精灵">>,
		craft = 3,
		skills = [825201,823201,guild_dmg_22],
		debris = 641033,
		debris_num = 60,
		devour = 300,
		attack_type = 1,
		grow_max = 4		
		}
	};
get_demon_base(110244) -> 
	{ok,
		#demon2{base_id = 110244,
		name = <<"石之精灵">>,
		craft = 3,
		skills = [813201,810301,guild_defence_23],
		debris = 641034,
		debris_num = 60,
		devour = 360,
		attack_type = 1,
		grow_max = 5		
		}
	};
get_demon_base(110245) -> 
	{ok,
		#demon2{base_id = 110245,
		name = <<"棕熊法师">>,
		craft = 3,
		skills = [810301,824201,guild_hp_22],
		debris = 641035,
		debris_num = 60,
		devour = 300,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(110246) -> 
	{ok,
		#demon2{base_id = 110246,
		name = <<"黄铜守卫">>,
		craft = 2,
		skills = [813201,811201],
		debris = 641036,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(110247) -> 
	{ok,
		#demon2{base_id = 110247,
		name = <<"绿革守卫">>,
		craft = 1,
		skills = [813201,806201],
		debris = 641037,
		debris_num = 20,
		devour = 60,
		attack_type = 0,
		grow_max = 2		
		}
	};
get_demon_base(110248) -> 
	{ok,
		#demon2{base_id = 110248,
		name = <<"银甲守卫">>,
		craft = 3,
		skills = [813301,807301,guild_tenacity_22],
		debris = 641038,
		debris_num = 60,
		devour = 360,
		attack_type = 0,
		grow_max = 5		
		}
	};
get_demon_base(110252) -> 
	{ok,
		#demon2{base_id = 110252,
		name = <<"永罚怨灵">>,
		craft = 1,
		skills = [803101],
		debris = 641039,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(110253) -> 
	{ok,
		#demon2{base_id = 110253,
		name = <<"种子怪">>,
		craft = 1,
		skills = [guild_critrate_21],
		debris = 641040,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(110254) -> 
	{ok,
		#demon2{base_id = 110254,
		name = <<"破晓女神">>,
		craft = 3,
		skills = [801301,824301,guild_hp_22],
		debris = 641041,
		debris_num = 60,
		devour = 400,
		attack_type = 0,
		grow_max = 5		
		}
	};
get_demon_base(110256) -> 
	{ok,
		#demon2{base_id = 110256,
		name = <<"半人马法师">>,
		craft = 3,
		skills = [802301,806301,guild_mp_22],
		debris = 641043,
		debris_num = 60,
		devour = 360,
		attack_type = 0,
		grow_max = 5		
		}
	};
get_demon_base(120007) -> 
	{ok,
		#demon2{base_id = 120007,
		name = <<"噩梦女巫">>,
		craft = 3,
		skills = [805301,811201,814201],
		debris = 641046,
		debris_num = 60,
		devour = 300,
		attack_type = 0,
		grow_max = 4		
		}
	};
get_demon_base(110200) -> 
	{ok,
		#demon2{base_id = 110200,
		name = <<"遗落松鼠">>,
		craft = 2,
		skills = [803201,guild_critrate_21],
		debris = 641047,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(110273) -> 
	{ok,
		#demon2{base_id = 110273,
		name = <<"狂野水精">>,
		craft = 1,
		skills = [guild_tenacity_21],
		debris = 641048,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(110274) -> 
	{ok,
		#demon2{base_id = 110274,
		name = <<"燃草火精">>,
		craft = 2,
		skills = [812101,814201],
		debris = 641049,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(110275) -> 
	{ok,
		#demon2{base_id = 110275,
		name = <<"蒜头小兵">>,
		craft = 2,
		skills = [807201,822101],
		debris = 641050,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(110276) -> 
	{ok,
		#demon2{base_id = 110276,
		name = <<"森林兔子">>,
		craft = 2,
		skills = [guild_critrate_21,807101],
		debris = 641051,
		debris_num = 40,
		devour = 60,
		attack_type = 0,
		grow_max = 3		
		}
	};
get_demon_base(110277) -> 
	{ok,
		#demon2{base_id = 110277,
		name = <<"幽惑花妖">>,
		craft = 1,
		skills = [guild_hp_21],
		debris = 641052,
		debris_num = 20,
		devour = 10,
		attack_type = 0,
		grow_max = 1		
		}
	};
get_demon_base(_) ->
	{false, ?L(<<"数据不存在">>)}.

	
get_demon_init_attr(10201) -> 
	[{?attr_dmg, 1260},{?attr_critrate, 504},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 630}];
get_demon_init_attr(10202) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4725},{?attr_mp_max, 3000},{?attr_defence, 2363},{?attr_tenacity , 450},{?attr_evasion , 189},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(10204) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3000},{?attr_defence, 2363},{?attr_tenacity , 473},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(10205) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 473},{?attr_hp_max, 4500},{?attr_mp_max, 3000},{?attr_defence, 2250},{?attr_tenacity , 473},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 591}];
get_demon_init_attr(10206) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3000},{?attr_defence, 2363},{?attr_tenacity , 450},{?attr_evasion , 189},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(10207) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4725},{?attr_mp_max, 3150},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 189},{?attr_dmg_magic , 563}];
get_demon_init_attr(10210) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2520},{?attr_tenacity , 480},{?attr_evasion , 202},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(10212) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4725},{?attr_mp_max, 3000},{?attr_defence, 2250},{?attr_tenacity , 473},{?attr_evasion , 180},{?attr_hitrate , 189},{?attr_dmg_magic , 563}];
get_demon_init_attr(10213) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 473},{?attr_hp_max, 4725},{?attr_mp_max, 3000},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(10214) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 504},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 630}];
get_demon_init_attr(10215) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3570},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 669}];
get_demon_init_attr(10216) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2520},{?attr_tenacity , 480},{?attr_evasion , 202},{?attr_hitrate , 202},{?attr_dmg_magic , 600}];
get_demon_init_attr(10217) -> 
	[{?attr_dmg, 1260},{?attr_critrate, 504},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 630}];
get_demon_init_attr(10218) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2520},{?attr_tenacity , 480},{?attr_evasion , 202},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(10219) -> 
	[{?attr_dmg, 1260},{?attr_critrate, 480},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2520},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(10220) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5355},{?attr_mp_max, 3400},{?attr_defence, 2678},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(10285) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3150},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 591}];
get_demon_init_attr(10226) -> 
	[{?attr_dmg, 1339},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3570},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 669}];
get_demon_init_attr(10227) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 504},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 504},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(10230) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 4800},{?attr_mp_max, 3360},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 630}];
get_demon_init_attr(10231) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4725},{?attr_mp_max, 3000},{?attr_defence, 2363},{?attr_tenacity , 473},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(10232) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 473},{?attr_hp_max, 4500},{?attr_mp_max, 3000},{?attr_defence, 2250},{?attr_tenacity , 473},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(10234) -> 
	[{?attr_dmg, 1339},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3400},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 214},{?attr_dmg_magic , 669}];
get_demon_init_attr(10235) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5355},{?attr_mp_max, 3400},{?attr_defence, 2678},{?attr_tenacity , 536},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(10236) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3000},{?attr_defence, 2363},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 189},{?attr_dmg_magic , 563}];
get_demon_init_attr(10237) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 504},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 202},{?attr_dmg_magic , 630}];
get_demon_init_attr(10239) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5355},{?attr_mp_max, 3570},{?attr_defence, 2678},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(10240) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3400},{?attr_defence, 2550},{?attr_tenacity , 536},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 669}];
get_demon_init_attr(10241) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5355},{?attr_mp_max, 3570},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(10242) -> 
	[{?attr_dmg, 1339},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3570},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(10244) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3570},{?attr_defence, 2678},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(10245) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5355},{?attr_mp_max, 3570},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(10246) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2520},{?attr_tenacity , 504},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(10247) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 472},{?attr_hp_max, 4500},{?attr_mp_max, 3000},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 591}];
get_demon_init_attr(10248) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3400},{?attr_defence, 2678},{?attr_tenacity , 536},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(10252) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3150},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 189},{?attr_hitrate , 180},{?attr_dmg_magic , 591}];
get_demon_init_attr(10253) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4725},{?attr_mp_max, 3000},{?attr_defence, 2363},{?attr_tenacity , 450},{?attr_evasion , 189},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(10254) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5355},{?attr_mp_max, 3570},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(10256) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3400},{?attr_defence, 2550},{?attr_tenacity , 536},{?attr_evasion , 214},{?attr_hitrate , 214},{?attr_dmg_magic , 638}];
get_demon_init_attr(20007) -> 
	[{?attr_dmg, 1339},{?attr_critrate, 536},{?attr_hp_max, 5100},{?attr_mp_max, 3400},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 669}];
get_demon_init_attr(10200) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 202},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(10273) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3150},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 189},{?attr_dmg_magic , 563}];
get_demon_init_attr(10274) -> 
	[{?attr_dmg, 1260},{?attr_critrate, 504},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 630}];
get_demon_init_attr(10275) -> 
	[{?attr_dmg, 1260},{?attr_critrate, 480},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2520},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(10276) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 504},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 202},{?attr_dmg_magic , 600}];
get_demon_init_attr(10277) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3150},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 591}];
get_demon_init_attr(118009) -> 
	[{?attr_dmg, 1588},{?attr_critrate, 635},{?attr_hp_max, 6050},{?attr_mp_max, 4033},{?attr_defence, 3025},{?attr_tenacity , 605},{?attr_evasion , 242},{?attr_hitrate , 242},{?attr_dmg_magic , 794}];
get_demon_init_attr(118010) -> 
	[{?attr_dmg, 1375},{?attr_critrate, 578},{?attr_hp_max, 5500},{?attr_mp_max, 3667},{?attr_defence, 2750},{?attr_tenacity , 550},{?attr_evasion , 220},{?attr_hitrate , 231},{?attr_dmg_magic , 722}];
get_demon_init_attr(118011) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5355},{?attr_mp_max, 3400},{?attr_defence, 2678},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(118012) -> 
	[{?attr_dmg, 1147},{?attr_critrate, 459},{?attr_hp_max, 4590},{?attr_mp_max, 3060},{?attr_defence, 2295},{?attr_tenacity , 482},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 574}];
get_demon_init_attr(110201) -> 
	[{?attr_dmg, 1260},{?attr_critrate, 504},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 630}];
get_demon_init_attr(110202) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4725},{?attr_mp_max, 3000},{?attr_defence, 2363},{?attr_tenacity , 450},{?attr_evasion , 189},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(110204) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3000},{?attr_defence, 2363},{?attr_tenacity , 473},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(110205) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 473},{?attr_hp_max, 4500},{?attr_mp_max, 3000},{?attr_defence, 2250},{?attr_tenacity , 473},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 591}];
get_demon_init_attr(110206) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3000},{?attr_defence, 2363},{?attr_tenacity , 450},{?attr_evasion , 189},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(110207) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4725},{?attr_mp_max, 3150},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 189},{?attr_dmg_magic , 563}];
get_demon_init_attr(110210) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2520},{?attr_tenacity , 480},{?attr_evasion , 202},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(110212) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4725},{?attr_mp_max, 3000},{?attr_defence, 2250},{?attr_tenacity , 473},{?attr_evasion , 180},{?attr_hitrate , 189},{?attr_dmg_magic , 563}];
get_demon_init_attr(110213) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 473},{?attr_hp_max, 4725},{?attr_mp_max, 3000},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(110214) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 504},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 630}];
get_demon_init_attr(110215) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3570},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 669}];
get_demon_init_attr(110216) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2520},{?attr_tenacity , 480},{?attr_evasion , 202},{?attr_hitrate , 202},{?attr_dmg_magic , 600}];
get_demon_init_attr(110217) -> 
	[{?attr_dmg, 1260},{?attr_critrate, 504},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 630}];
get_demon_init_attr(110218) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2520},{?attr_tenacity , 480},{?attr_evasion , 202},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(110219) -> 
	[{?attr_dmg, 1260},{?attr_critrate, 480},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2520},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(110220) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5355},{?attr_mp_max, 3400},{?attr_defence, 2678},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(110285) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3150},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 591}];
get_demon_init_attr(110226) -> 
	[{?attr_dmg, 1339},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3570},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 669}];
get_demon_init_attr(110227) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 504},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 504},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(110230) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 4800},{?attr_mp_max, 3360},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 630}];
get_demon_init_attr(110231) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4725},{?attr_mp_max, 3000},{?attr_defence, 2363},{?attr_tenacity , 473},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(110232) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 473},{?attr_hp_max, 4500},{?attr_mp_max, 3000},{?attr_defence, 2250},{?attr_tenacity , 473},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(110234) -> 
	[{?attr_dmg, 1339},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3400},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 214},{?attr_dmg_magic , 669}];
get_demon_init_attr(110235) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5355},{?attr_mp_max, 3400},{?attr_defence, 2678},{?attr_tenacity , 536},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(110236) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3000},{?attr_defence, 2363},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 189},{?attr_dmg_magic , 563}];
get_demon_init_attr(110237) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 504},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 202},{?attr_dmg_magic , 630}];
get_demon_init_attr(110239) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5355},{?attr_mp_max, 3570},{?attr_defence, 2678},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(110240) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3400},{?attr_defence, 2550},{?attr_tenacity , 536},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 669}];
get_demon_init_attr(110241) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5355},{?attr_mp_max, 3570},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(110242) -> 
	[{?attr_dmg, 1339},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3570},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(110244) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3570},{?attr_defence, 2678},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(110245) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5355},{?attr_mp_max, 3570},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(110246) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2520},{?attr_tenacity , 504},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(110247) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 472},{?attr_hp_max, 4500},{?attr_mp_max, 3000},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 591}];
get_demon_init_attr(110248) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3400},{?attr_defence, 2678},{?attr_tenacity , 536},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(110252) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3150},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 189},{?attr_hitrate , 180},{?attr_dmg_magic , 591}];
get_demon_init_attr(110253) -> 
	[{?attr_dmg, 1125},{?attr_critrate, 450},{?attr_hp_max, 4725},{?attr_mp_max, 3000},{?attr_defence, 2363},{?attr_tenacity , 450},{?attr_evasion , 189},{?attr_hitrate , 180},{?attr_dmg_magic , 563}];
get_demon_init_attr(110254) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5355},{?attr_mp_max, 3570},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 638}];
get_demon_init_attr(110256) -> 
	[{?attr_dmg, 1275},{?attr_critrate, 510},{?attr_hp_max, 5100},{?attr_mp_max, 3400},{?attr_defence, 2550},{?attr_tenacity , 536},{?attr_evasion , 214},{?attr_hitrate , 214},{?attr_dmg_magic , 638}];
get_demon_init_attr(120007) -> 
	[{?attr_dmg, 1339},{?attr_critrate, 536},{?attr_hp_max, 5100},{?attr_mp_max, 3400},{?attr_defence, 2550},{?attr_tenacity , 510},{?attr_evasion , 204},{?attr_hitrate , 204},{?attr_dmg_magic , 669}];
get_demon_init_attr(110200) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 480},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 202},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(110273) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3150},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 189},{?attr_dmg_magic , 563}];
get_demon_init_attr(110274) -> 
	[{?attr_dmg, 1260},{?attr_critrate, 504},{?attr_hp_max, 4800},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 630}];
get_demon_init_attr(110275) -> 
	[{?attr_dmg, 1260},{?attr_critrate, 480},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2520},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 192},{?attr_dmg_magic , 600}];
get_demon_init_attr(110276) -> 
	[{?attr_dmg, 1200},{?attr_critrate, 504},{?attr_hp_max, 5040},{?attr_mp_max, 3200},{?attr_defence, 2400},{?attr_tenacity , 480},{?attr_evasion , 192},{?attr_hitrate , 202},{?attr_dmg_magic , 600}];
get_demon_init_attr(110277) -> 
	[{?attr_dmg, 1181},{?attr_critrate, 450},{?attr_hp_max, 4500},{?attr_mp_max, 3150},{?attr_defence, 2250},{?attr_tenacity , 450},{?attr_evasion , 180},{?attr_hitrate , 180},{?attr_dmg_magic , 591}];
get_demon_init_attr(_) ->
	[].
	
get_demon_base_attr(10201) -> 
	[{?attr_dmg, 53.000},{?attr_critrate, 21.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 26.000}];
get_demon_base_attr(10202) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 184.000},{?attr_mp_max, 117.000},{?attr_defence, 92.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(10204) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 175.000},{?attr_mp_max, 117.000},{?attr_defence, 92.000},{?attr_tenacity , 19.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(10205) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 19.000},{?attr_hp_max, 175.000},{?attr_mp_max, 117.000},{?attr_defence, 88.000},{?attr_tenacity , 19.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 23.000}];
get_demon_base_attr(10206) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 18.000},{?attr_hp_max, 175.000},{?attr_mp_max, 117.000},{?attr_defence, 92.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(10207) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 184.000},{?attr_mp_max, 123.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(10210) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(10212) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 184.000},{?attr_mp_max, 117.000},{?attr_defence, 88.000},{?attr_tenacity , 19.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(10213) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 19.000},{?attr_hp_max, 184.000},{?attr_mp_max, 117.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(10214) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 21.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 26.000}];
get_demon_base_attr(10215) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 158.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 30.000}];
get_demon_base_attr(10216) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(10217) -> 
	[{?attr_dmg, 53.000},{?attr_critrate, 21.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 26.000}];
get_demon_base_attr(10218) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(10219) -> 
	[{?attr_dmg, 53.000},{?attr_critrate, 20.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(10220) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 236.000},{?attr_mp_max, 150.000},{?attr_defence, 119.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(10285) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 18.000},{?attr_hp_max, 175.000},{?attr_mp_max, 123.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 23.000}];
get_demon_base_attr(10226) -> 
	[{?attr_dmg, 60.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 158.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 30.000}];
get_demon_base_attr(10227) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 21.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 21.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(10230) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 200.000},{?attr_mp_max, 141.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 26.000}];
get_demon_base_attr(10231) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 184.000},{?attr_mp_max, 117.000},{?attr_defence, 92.000},{?attr_tenacity , 19.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(10232) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 19.000},{?attr_hp_max, 175.000},{?attr_mp_max, 117.000},{?attr_defence, 88.000},{?attr_tenacity , 19.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(10234) -> 
	[{?attr_dmg, 60.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 150.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 30.000}];
get_demon_base_attr(10235) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 236.000},{?attr_mp_max, 150.000},{?attr_defence, 119.000},{?attr_tenacity , 24.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(10236) -> 
	[{?attr_dmg, 53.000},{?attr_critrate, 20.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(10237) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 21.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 26.000}];
get_demon_base_attr(10239) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 236.000},{?attr_mp_max, 158.000},{?attr_defence, 119.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(10240) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 150.000},{?attr_defence, 113.000},{?attr_tenacity , 24.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 30.000}];
get_demon_base_attr(10241) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 236.000},{?attr_mp_max, 158.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(10242) -> 
	[{?attr_dmg, 60.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 158.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(10244) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 158.000},{?attr_defence, 119.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(10245) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 236.000},{?attr_mp_max, 158.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(10246) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 21.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(10247) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 19.000},{?attr_hp_max, 175.000},{?attr_mp_max, 117.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 23.000}];
get_demon_base_attr(10248) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 150.000},{?attr_defence, 119.000},{?attr_tenacity , 24.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(10252) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 175.000},{?attr_mp_max, 123.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 23.000}];
get_demon_base_attr(10253) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 184.000},{?attr_mp_max, 117.000},{?attr_defence, 92.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(10254) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 236.000},{?attr_mp_max, 158.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(10256) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 150.000},{?attr_defence, 113.000},{?attr_tenacity , 24.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(20007) -> 
	[{?attr_dmg, 60.000},{?attr_critrate, 24.000},{?attr_hp_max, 225.000},{?attr_mp_max, 150.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 30.000}];
get_demon_base_attr(10200) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(10273) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 18.000},{?attr_hp_max, 175.000},{?attr_mp_max, 123.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(10274) -> 
	[{?attr_dmg, 53.000},{?attr_critrate, 21.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 26.000}];
get_demon_base_attr(10275) -> 
	[{?attr_dmg, 53.000},{?attr_critrate, 20.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(10276) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 21.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(10277) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 18.000},{?attr_hp_max, 175.000},{?attr_mp_max, 123.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 23.000}];
get_demon_base_attr(118009) -> 
	[{?attr_dmg, 72.000},{?attr_critrate, 28.000},{?attr_hp_max, 275.000},{?attr_mp_max, 183.000},{?attr_defence, 137.000},{?attr_tenacity , 27.000},{?attr_evasion , 11.000},{?attr_hitrate , 11.000},{?attr_dmg_magic , 37.000}];
get_demon_base_attr(118010) -> 
	[{?attr_dmg, 63.000},{?attr_critrate, 26.000},{?attr_hp_max, 250.000},{?attr_mp_max, 167.000},{?attr_defence, 125.000},{?attr_tenacity , 25.000},{?attr_evasion , 10.000},{?attr_hitrate , 11.000},{?attr_dmg_magic , 34.000}];
get_demon_base_attr(118011) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 236.000},{?attr_mp_max, 150.000},{?attr_defence, 119.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(118012) -> 
	[{?attr_dmg, 51.000},{?attr_critrate, 20.000},{?attr_hp_max, 202.000},{?attr_mp_max, 135.000},{?attr_defence, 101.000},{?attr_tenacity , 21.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 26.000}];
get_demon_base_attr(110201) -> 
	[{?attr_dmg, 53.000},{?attr_critrate, 21.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 26.000}];
get_demon_base_attr(110202) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 184.000},{?attr_mp_max, 117.000},{?attr_defence, 92.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(110204) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 175.000},{?attr_mp_max, 117.000},{?attr_defence, 92.000},{?attr_tenacity , 19.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(110205) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 19.000},{?attr_hp_max, 175.000},{?attr_mp_max, 117.000},{?attr_defence, 88.000},{?attr_tenacity , 19.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 23.000}];
get_demon_base_attr(110206) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 18.000},{?attr_hp_max, 175.000},{?attr_mp_max, 117.000},{?attr_defence, 92.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(110207) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 184.000},{?attr_mp_max, 123.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(110210) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(110212) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 184.000},{?attr_mp_max, 117.000},{?attr_defence, 88.000},{?attr_tenacity , 19.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(110213) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 19.000},{?attr_hp_max, 184.000},{?attr_mp_max, 117.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(110214) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 21.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 26.000}];
get_demon_base_attr(110215) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 158.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 30.000}];
get_demon_base_attr(110216) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(110217) -> 
	[{?attr_dmg, 53.000},{?attr_critrate, 21.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 26.000}];
get_demon_base_attr(110218) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(110219) -> 
	[{?attr_dmg, 53.000},{?attr_critrate, 20.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(110220) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 236.000},{?attr_mp_max, 150.000},{?attr_defence, 119.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(110285) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 18.000},{?attr_hp_max, 175.000},{?attr_mp_max, 123.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 23.000}];
get_demon_base_attr(110226) -> 
	[{?attr_dmg, 60.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 158.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 30.000}];
get_demon_base_attr(110227) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 21.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 21.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(110230) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 200.000},{?attr_mp_max, 141.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 26.000}];
get_demon_base_attr(110231) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 184.000},{?attr_mp_max, 117.000},{?attr_defence, 92.000},{?attr_tenacity , 19.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(110232) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 19.000},{?attr_hp_max, 175.000},{?attr_mp_max, 117.000},{?attr_defence, 88.000},{?attr_tenacity , 19.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(110234) -> 
	[{?attr_dmg, 60.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 150.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 30.000}];
get_demon_base_attr(110235) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 236.000},{?attr_mp_max, 150.000},{?attr_defence, 119.000},{?attr_tenacity , 24.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(110236) -> 
	[{?attr_dmg, 53.000},{?attr_critrate, 20.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(110237) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 21.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 26.000}];
get_demon_base_attr(110239) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 236.000},{?attr_mp_max, 158.000},{?attr_defence, 119.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(110240) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 150.000},{?attr_defence, 113.000},{?attr_tenacity , 24.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 30.000}];
get_demon_base_attr(110241) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 236.000},{?attr_mp_max, 158.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(110242) -> 
	[{?attr_dmg, 60.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 158.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(110244) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 158.000},{?attr_defence, 119.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(110245) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 236.000},{?attr_mp_max, 158.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(110246) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 21.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(110247) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 19.000},{?attr_hp_max, 175.000},{?attr_mp_max, 117.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 23.000}];
get_demon_base_attr(110248) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 150.000},{?attr_defence, 119.000},{?attr_tenacity , 24.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(110252) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 175.000},{?attr_mp_max, 123.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 23.000}];
get_demon_base_attr(110253) -> 
	[{?attr_dmg, 44.000},{?attr_critrate, 18.000},{?attr_hp_max, 184.000},{?attr_mp_max, 117.000},{?attr_defence, 92.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(110254) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 236.000},{?attr_mp_max, 158.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(110256) -> 
	[{?attr_dmg, 57.000},{?attr_critrate, 23.000},{?attr_hp_max, 225.000},{?attr_mp_max, 150.000},{?attr_defence, 113.000},{?attr_tenacity , 24.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 29.000}];
get_demon_base_attr(120007) -> 
	[{?attr_dmg, 60.000},{?attr_critrate, 24.000},{?attr_hp_max, 225.000},{?attr_mp_max, 150.000},{?attr_defence, 113.000},{?attr_tenacity , 23.000},{?attr_evasion , 9.000},{?attr_hitrate , 9.000},{?attr_dmg_magic , 30.000}];
get_demon_base_attr(110200) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 20.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(110273) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 18.000},{?attr_hp_max, 175.000},{?attr_mp_max, 123.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 22.000}];
get_demon_base_attr(110274) -> 
	[{?attr_dmg, 53.000},{?attr_critrate, 21.000},{?attr_hp_max, 200.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 26.000}];
get_demon_base_attr(110275) -> 
	[{?attr_dmg, 53.000},{?attr_critrate, 20.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 105.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(110276) -> 
	[{?attr_dmg, 50.000},{?attr_critrate, 21.000},{?attr_hp_max, 210.000},{?attr_mp_max, 134.000},{?attr_defence, 100.000},{?attr_tenacity , 20.000},{?attr_evasion , 8.000},{?attr_hitrate , 8.000},{?attr_dmg_magic , 25.000}];
get_demon_base_attr(110277) -> 
	[{?attr_dmg, 46.000},{?attr_critrate, 18.000},{?attr_hp_max, 175.000},{?attr_mp_max, 123.000},{?attr_defence, 88.000},{?attr_tenacity , 18.000},{?attr_evasion , 7.000},{?attr_hitrate , 7.000},{?attr_dmg_magic , 23.000}];
get_demon_base_attr(_) ->
	[].

get_buff_id(guild_hp_21)->
	10000;
get_buff_id(guild_hp_22)->
	10001;
get_buff_id(guild_hp_23)->
	10002;
get_buff_id(guild_tenacity_21)->
	10003;
get_buff_id(guild_tenacity_22)->
	10004;
get_buff_id(guild_tenacity_23)->
	10005;
get_buff_id(guild_dmg_21)->
	10006;
get_buff_id(guild_dmg_22)->
	10007;
get_buff_id(guild_dmg_23)->
	10008;
get_buff_id(guild_critrate_21)->
	10009;
get_buff_id(guild_critrate_22)->
	10010;
get_buff_id(guild_critrate_23)->
	10011;
get_buff_id(guild_hitrate_21)->
	10012;
get_buff_id(guild_hitrate_22)->
	10013;
get_buff_id(guild_hitrate_23)->
	10014;
get_buff_id(guild_evasion_21)->
	10015;
get_buff_id(guild_evasion_22)->
	10016;
get_buff_id(guild_evasion_23)->
	10017;
get_buff_id(guild_defence_21)->
	10018;
get_buff_id(guild_defence_22)->
	10019;
get_buff_id(guild_defence_23)->
	10020;
get_buff_id(guild_mp_21)->
	10021;
get_buff_id(guild_mp_22)->
	10022;
get_buff_id(guild_mp_23)->
	10023;

get_buff_id(_) ->
	0.

	
get_demon_effect(10201) -> 
	[{?attr_hp_max, 60},{?attr_mp_max, 60}];
get_demon_effect(10202) -> 
	[{?attr_hp_max, 60},{?attr_mp_max, 60}];
get_demon_effect(10204) -> 
	[{?attr_hp_max, 40},{?attr_mp_max, 40}];
get_demon_effect(10205) -> 
	[{?attr_hp_max, 40},{?attr_mp_max, 40}];
get_demon_effect(10206) -> 
	[{?attr_hp_max, 40},{?attr_mp_max, 40}];
get_demon_effect(10207) -> 
	[{?attr_hp_max, 65},{?attr_mp_max, 65}];
get_demon_effect(10210) -> 
	[{?attr_hp_max, 60},{?attr_mp_max, 60}];
get_demon_effect(10212) -> 
	[{?attr_hp_max, 42},{?attr_mp_max, 42}];
get_demon_effect(10213) -> 
	[{?attr_defence,18},{?attr_rst_all,4}];
get_demon_effect(10214) -> 
	[{?attr_hp_max, 60},{?attr_mp_max, 60}];
get_demon_effect(10215) -> 
	[{?attr_hp_max, 100},{?attr_mp_max, 100}];
get_demon_effect(10216) -> 
	[{?attr_hp_max, 65},{?attr_mp_max, 65}];
get_demon_effect(10217) -> 
	[{?attr_hp_max, 65},{?attr_mp_max, 65}];
get_demon_effect(10218) -> 
	[{?attr_defence,25},{?attr_rst_all,6}];
get_demon_effect(10219) -> 
	[{?attr_defence,25},{?attr_rst_all,6}];
get_demon_effect(10220) -> 
	[{?attr_hp_max, 100},{?attr_mp_max, 100}];
get_demon_effect(10285) -> 
	[{?attr_defence,25},{?attr_rst_all,6}];
get_demon_effect(10226) -> 
	[{?attr_hp_max, 100},{?attr_mp_max, 100}];
get_demon_effect(10227) -> 
	[{?attr_defence,25},{?attr_rst_all,6}];
get_demon_effect(10230) -> 
	[{?attr_defence,25},{?attr_rst_all,6}];
get_demon_effect(10231) -> 
	[{?attr_defence,18},{?attr_rst_all,4}];
get_demon_effect(10232) -> 
	[{?attr_defence,19},{?attr_rst_all,5}];
get_demon_effect(10234) -> 
	[{?attr_hp_max, 100},{?attr_mp_max, 100}];
get_demon_effect(10235) -> 
	[{?attr_hp_max, 90},{?attr_mp_max, 90}];
get_demon_effect(10236) -> 
	[{?attr_js,2},{?attr_critrate,3}];
get_demon_effect(10237) -> 
	[{?attr_defence,25},{?attr_rst_all,6}];
get_demon_effect(10239) -> 
	[{?attr_js,6},{?attr_critrate,8}];
get_demon_effect(10240) -> 
	[{?attr_js,6},{?attr_critrate,8}];
get_demon_effect(10241) -> 
	[{?attr_js,6},{?attr_evasion,5}];
get_demon_effect(10242) -> 
	[{?attr_hitrate,5},{?attr_tenacity,6}];
get_demon_effect(10244) -> 
	[{?attr_hitrate,5},{?attr_tenacity,6}];
get_demon_effect(10245) -> 
	[{?attr_defence,30},{?attr_rst_all,8}];
get_demon_effect(10246) -> 
	[{?attr_js,4},{?attr_hitrate,4}];
get_demon_effect(10247) -> 
	[{?attr_js,4},{?attr_hitrate,4}];
get_demon_effect(10248) -> 
	[{?attr_defence,30},{?attr_rst_all,8}];
get_demon_effect(10252) -> 
	[{?attr_js,2},{?attr_critrate,3}];
get_demon_effect(10253) -> 
	[{?attr_hitrate,2},{?attr_evasion,2}];
get_demon_effect(10254) -> 
	[{?attr_defence,30},{?attr_rst_all,8}];
get_demon_effect(10256) -> 
	[{?attr_defence,30},{?attr_rst_all,8}];
get_demon_effect(20007) -> 
	[{?attr_defence,30},{?attr_rst_all,8}];
get_demon_effect(10200) -> 
	[{?attr_js,4},{?attr_tenacity,5}];
get_demon_effect(10273) -> 
	[{?attr_hitrate,2},{?attr_tenacity,5}];
get_demon_effect(10274) -> 
	[{?attr_js,4},{?attr_tenacity,5}];
get_demon_effect(10275) -> 
	[{?attr_evasion,3},{?attr_critrate,7}];
get_demon_effect(10276) -> 
	[{?attr_evasion,3},{?attr_critrate,8}];
get_demon_effect(10277) -> 
	[{?attr_js,2},{?attr_tenacity,2}];
get_demon_effect(118009) -> 
	[{?attr_hitrate,12},{?attr_rst_all,20}];
get_demon_effect(118010) -> 
	[{?attr_critrate,15},{?attr_tenacity,10}];
get_demon_effect(118011) -> 
	[{?attr_js,15},{?attr_evasion,8}];
get_demon_effect(118012) -> 
	[{?attr_hp_max, 300},{?attr_mp_max, 300}];
get_demon_effect(110201) -> 
	[{?attr_hp_max, 90},{?attr_mp_max, 90}];
get_demon_effect(110202) -> 
	[{?attr_hp_max, 90},{?attr_mp_max, 90}];
get_demon_effect(110204) -> 
	[{?attr_hp_max, 60},{?attr_mp_max, 60}];
get_demon_effect(110205) -> 
	[{?attr_hp_max, 60},{?attr_mp_max, 60}];
get_demon_effect(110206) -> 
	[{?attr_hp_max, 60},{?attr_mp_max, 60}];
get_demon_effect(110207) -> 
	[{?attr_hp_max, 98},{?attr_mp_max, 98}];
get_demon_effect(110210) -> 
	[{?attr_hp_max, 90},{?attr_mp_max, 90}];
get_demon_effect(110212) -> 
	[{?attr_hp_max, 63},{?attr_mp_max, 63}];
get_demon_effect(110213) -> 
	[{?attr_defence,27},{?attr_rst_all,6}];
get_demon_effect(110214) -> 
	[{?attr_hp_max, 90},{?attr_mp_max, 90}];
get_demon_effect(110215) -> 
	[{?attr_hp_max, 150},{?attr_mp_max, 150}];
get_demon_effect(110216) -> 
	[{?attr_hp_max, 98},{?attr_mp_max, 98}];
get_demon_effect(110217) -> 
	[{?attr_hp_max, 98},{?attr_mp_max, 98}];
get_demon_effect(110218) -> 
	[{?attr_defence,38},{?attr_rst_all,9}];
get_demon_effect(110219) -> 
	[{?attr_defence,38},{?attr_rst_all,9}];
get_demon_effect(110220) -> 
	[{?attr_hp_max, 100},{?attr_mp_max, 100}];
get_demon_effect(110285) -> 
	[{?attr_defence,38},{?attr_rst_all,9}];
get_demon_effect(110226) -> 
	[{?attr_hp_max, 150},{?attr_mp_max, 150}];
get_demon_effect(110227) -> 
	[{?attr_defence,38},{?attr_rst_all,9}];
get_demon_effect(110230) -> 
	[{?attr_defence,38},{?attr_rst_all,9}];
get_demon_effect(110231) -> 
	[{?attr_defence,27},{?attr_rst_all,6}];
get_demon_effect(110232) -> 
	[{?attr_defence,28},{?attr_rst_all,8}];
get_demon_effect(110234) -> 
	[{?attr_hp_max, 150},{?attr_mp_max, 150}];
get_demon_effect(110235) -> 
	[{?attr_hp_max, 135},{?attr_mp_max, 135}];
get_demon_effect(110236) -> 
	[{?attr_js,2},{?attr_critrate,3}];
get_demon_effect(110237) -> 
	[{?attr_defence,38},{?attr_rst_all,9}];
get_demon_effect(110239) -> 
	[{?attr_js,9},{?attr_critrate,12}];
get_demon_effect(110240) -> 
	[{?attr_js,9},{?attr_critrate,12}];
get_demon_effect(110241) -> 
	[{?attr_js,9},{?attr_evasion,8}];
get_demon_effect(110242) -> 
	[{?attr_hitrate,8},{?attr_tenacity,9}];
get_demon_effect(110244) -> 
	[{?attr_hitrate,8},{?attr_tenacity,9}];
get_demon_effect(110245) -> 
	[{?attr_defence,45},{?attr_rst_all,12}];
get_demon_effect(110246) -> 
	[{?attr_js,6},{?attr_hitrate,6}];
get_demon_effect(110247) -> 
	[{?attr_js,6},{?attr_hitrate,6}];
get_demon_effect(110248) -> 
	[{?attr_defence,45},{?attr_rst_all,12}];
get_demon_effect(110252) -> 
	[{?attr_js,3},{?attr_critrate,5}];
get_demon_effect(110253) -> 
	[{?attr_hitrate,3},{?attr_evasion,3}];
get_demon_effect(110254) -> 
	[{?attr_defence,45},{?attr_rst_all,12}];
get_demon_effect(110256) -> 
	[{?attr_defence,45},{?attr_rst_all,12}];
get_demon_effect(120007) -> 
	[{?attr_defence,45},{?attr_rst_all,12}];
get_demon_effect(110200) -> 
	[{?attr_js,6},{?attr_tenacity,8}];
get_demon_effect(110273) -> 
	[{?attr_hitrate,3},{?attr_tenacity,8}];
get_demon_effect(110274) -> 
	[{?attr_js,6},{?attr_tenacity,8}];
get_demon_effect(110275) -> 
	[{?attr_evasion,5},{?attr_critrate,11}];
get_demon_effect(110276) -> 
	[{?attr_evasion,5},{?attr_critrate,12}];
get_demon_effect(110277) -> 
	[{?attr_js,3},{?attr_tenacity,3}];
get_demon_effect(_) ->
	[].

get_demon_weight(641001) -> 
	{25, 20};
get_demon_weight(641002) -> 
	{25, 20};
get_demon_weight(641003) -> 
	{30, 25};
get_demon_weight(641004) -> 
	{30, 25};
get_demon_weight(641005) -> 
	{30, 25};
get_demon_weight(641006) -> 
	{25, 20};
get_demon_weight(641007) -> 
	{25, 20};
get_demon_weight(641008) -> 
	{30, 25};
get_demon_weight(641009) -> 
	{30, 25};
get_demon_weight(641010) -> 
	{25, 20};
get_demon_weight(641011) -> 
	{20, 15};
get_demon_weight(641012) -> 
	{25, 20};
get_demon_weight(641013) -> 
	{25, 20};
get_demon_weight(641014) -> 
	{25, 20};
get_demon_weight(641015) -> 
	{25, 20};
get_demon_weight(641016) -> 
	{20, 15};
get_demon_weight(641017) -> 
	{25, 20};
get_demon_weight(641019) -> 
	{20, 15};
get_demon_weight(641020) -> 
	{25, 20};
get_demon_weight(641023) -> 
	{25, 20};
get_demon_weight(641024) -> 
	{30, 25};
get_demon_weight(641025) -> 
	{30, 25};
get_demon_weight(641026) -> 
	{20, 15};
get_demon_weight(641027) -> 
	{20, 15};
get_demon_weight(641028) -> 
	{30, 25};
get_demon_weight(641029) -> 
	{25, 20};
get_demon_weight(641030) -> 
	{20, 15};
get_demon_weight(641031) -> 
	{20, 15};
get_demon_weight(641032) -> 
	{20, 15};
get_demon_weight(641033) -> 
	{20, 15};
get_demon_weight(641034) -> 
	{20, 15};
get_demon_weight(641035) -> 
	{20, 15};
get_demon_weight(641036) -> 
	{25, 20};
get_demon_weight(641037) -> 
	{25, 20};
get_demon_weight(641038) -> 
	{20, 15};
get_demon_weight(641039) -> 
	{30, 25};
get_demon_weight(641040) -> 
	{30, 25};
get_demon_weight(641041) -> 
	{20, 15};
get_demon_weight(641043) -> 
	{20, 15};
get_demon_weight(641046) -> 
	{20, 15};
get_demon_weight(641047) -> 
	{25, 20};
get_demon_weight(641048) -> 
	{30, 25};
get_demon_weight(641049) -> 
	{25, 20};
get_demon_weight(641050) -> 
	{25, 20};
get_demon_weight(641051) -> 
	{25, 20};
get_demon_weight(641052) -> 
	{30, 25};
get_demon_weight(_) ->
	{0, 0}.


get_wake_weight(641001) -> 90;
get_wake_weight(641002) -> 90;
get_wake_weight(641003) -> 85;
get_wake_weight(641004) -> 85;
get_wake_weight(641005) -> 85;
get_wake_weight(641006) -> 90;
get_wake_weight(641007) -> 90;
get_wake_weight(641008) -> 85;
get_wake_weight(641009) -> 85;
get_wake_weight(641010) -> 90;
get_wake_weight(641011) -> 95;
get_wake_weight(641012) -> 90;
get_wake_weight(641013) -> 90;
get_wake_weight(641014) -> 90;
get_wake_weight(641015) -> 90;
get_wake_weight(641016) -> 85;
get_wake_weight(641017) -> 90;
get_wake_weight(641019) -> 95;
get_wake_weight(641020) -> 90;
get_wake_weight(641023) -> 90;
get_wake_weight(641024) -> 85;
get_wake_weight(641025) -> 85;
get_wake_weight(641026) -> 95;
get_wake_weight(641027) -> 95;
get_wake_weight(641028) -> 85;
get_wake_weight(641029) -> 90;
get_wake_weight(641030) -> 95;
get_wake_weight(641031) -> 95;
get_wake_weight(641032) -> 95;
get_wake_weight(641033) -> 95;
get_wake_weight(641034) -> 95;
get_wake_weight(641035) -> 95;
get_wake_weight(641036) -> 90;
get_wake_weight(641037) -> 90;
get_wake_weight(641038) -> 95;
get_wake_weight(641039) -> 85;
get_wake_weight(641040) -> 85;
get_wake_weight(641041) -> 95;
get_wake_weight(641043) -> 95;
get_wake_weight(641046) -> 95;
get_wake_weight(641047) -> 90;
get_wake_weight(641048) -> 85;
get_wake_weight(641049) -> 90;
get_wake_weight(641050) -> 90;
get_wake_weight(641051) -> 90;
get_wake_weight(641052) -> 85;
get_wake_weight(_) -> 0.

get_grab_info(641001) -> 0;
get_grab_info(641002) -> 0;
get_grab_info(641003) -> 0;
get_grab_info(641004) -> 0;
get_grab_info(641005) -> 0;
get_grab_info(641006) -> 0;
get_grab_info(641007) -> 0;
get_grab_info(641008) -> 0;
get_grab_info(641009) -> 0;
get_grab_info(641010) -> 0;
get_grab_info(641011) -> 0;
get_grab_info(641012) -> 0;
get_grab_info(641013) -> 0;
get_grab_info(641014) -> 0;
get_grab_info(641015) -> 0;
get_grab_info(641016) -> 1;
get_grab_info(641017) -> 0;
get_grab_info(641019) -> 0;
get_grab_info(641020) -> 0;
get_grab_info(641023) -> 0;
get_grab_info(641024) -> 0;
get_grab_info(641025) -> 0;
get_grab_info(641026) -> 0;
get_grab_info(641027) -> 0;
get_grab_info(641028) -> 1;
get_grab_info(641029) -> 0;
get_grab_info(641030) -> 0;
get_grab_info(641031) -> 0;
get_grab_info(641032) -> 0;
get_grab_info(641033) -> 0;
get_grab_info(641034) -> 0;
get_grab_info(641035) -> 0;
get_grab_info(641036) -> 0;
get_grab_info(641037) -> 0;
get_grab_info(641038) -> 0;
get_grab_info(641039) -> 0;
get_grab_info(641040) -> 0;
get_grab_info(641041) -> 0;
get_grab_info(641043) -> 0;
get_grab_info(641046) -> 0;
get_grab_info(641047) -> 0;
get_grab_info(641048) -> 0;
get_grab_info(641049) -> 0;
get_grab_info(641050) -> 0;
get_grab_info(641051) -> 0;
get_grab_info(641052) -> 0;
get_grab_info(_) -> 1.

	

