
%% -----------------------
%% @autor wangweibiao
%% ------------------------
-module(demon_devour_data).
-export([
		get_devour_target/1,
		get_devour_attr/1
		]).

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



get_devour_target(10201) -> 
	{2,
			[{1, [10252,110252]},{2, [10204,110204]}]
	};
get_devour_target(10202) -> 
	{2,
			[{1, [10252,110252]},{2, [10232,110232]}]
	};
get_devour_target(10204) -> 
	{1,
			[]
	};
get_devour_target(10205) -> 
	{1,
			[]
	};
get_devour_target(10206) -> 
	{2,
			[{1, [10205,110205]},{2, [10204,110204]}]
	};
get_devour_target(10207) -> 
	{3,
			[{1, [10253,110253]},{2, [10277,110277]},{4, [10204,110204]},{5, [10236,110236]}]
	};
get_devour_target(10210) -> 
	{2,
			[{1, [10253,110253]},{2, [10232,110232]}]
	};
get_devour_target(10212) -> 
	{1,
			[{1, [10205.110205]},{2, [10204,110204]}]
	};
get_devour_target(10213) -> 
	{1,
			[]
	};
get_devour_target(10214) -> 
	{2,
			[{1, [10205,110205]},{2, [10212,110212]}]
	};
get_devour_target(10215) -> 
	{4,
			[{1, [10252,110252]},{2, [10231,110231]},{4, [10277,110277]},{5, [10202,110202]},{7, [10218,110218]},{8, [10219,110219]}]
	};
get_devour_target(10216) -> 
	{3,
			[{1, [10253,110253]},{2, [10277,110277]},{4, [10232,110232]},{5, [10236,110236]}]
	};
get_devour_target(10217) -> 
	{3,
			[{1, [10253,110253]},{2, [10277,110277]},{4, [10273,110273]},{5, [10236,110236]}]
	};
get_devour_target(10218) -> 
	{2,
			[{1, [10205,110205]},{2, [10206,110206]}]
	};
get_devour_target(10219) -> 
	{3,
			[{1, [10252,110252]},{2, [10277,110277]},{4, [10273,110273]},{5, [10202,110202]}]
	};
get_devour_target(10220) -> 
	{4,
			[{1, [10236,110236]},{2, [10212,110212]},{4, [10200,110200]},{5, [10276,110276]},{7, [10200,110200]},{8, [10237,110237]}]
	};
get_devour_target(10285) -> 
	{3,
			[{1, [10252,110252]},{2, [10273,110273]},{4, [10204,110204]},{5, [10236,110236]}]
	};
get_devour_target(10226) -> 
	{4,
			[{1, [10252,110252]},{2, [10204,110204]},{4, [10212,110212]},{5, [10236,110236]},{7, [10201,110201]},{8, [10219,110219]}]
	};
get_devour_target(10227) -> 
	{2,
			[{1, [10205,110205]},{2, [10213,110213]}]
	};
get_devour_target(10230) -> 
	{2,
			[{1, [10252,110252]},{2, [10213,110213]}]
	};
get_devour_target(10231) -> 
	{2,
			[{1, [10253,110253]},{2, [10277,110277]}]
	};
get_devour_target(10232) -> 
	{1,
			[]
	};
get_devour_target(10234) -> 
	{4,
			[{1, [10206,110206]},{2, [10247,110247]},{4, [10276,110276]},{5, [10237,110237]},{7, [10276,110276]},{8, [10200,110200]}]
	};
get_devour_target(10235) -> 
	{5,
			[{1, [10205,110205]},{2, [10273,110273]},{4, [10232,110232]},{5, [10206,110206]},{7, [10236,110236]},{8, [10247,110247]},{10, [10246,110246]},{11, [10234,110234]}]
	};
get_devour_target(10236) -> 
	{2,
			[{1, [10253,110253]},{2, [10277,110277]}]
	};
get_devour_target(10237) -> 
	{3,
			[{1, [10252,110252]},{2, [10232,110232]},{4, [10202,110202]},{5, [10247,110247]}]
	};
get_devour_target(10239) -> 
	{4,
			[{1, [10252,110252]},{2, [10232,110232]},{4, [10204,110204]},{5, [10202,110202]},{7, [10230,110230]},{8, [10285,110285]}]
	};
get_devour_target(10240) -> 
	{4,
			[{1, [10252,110252]},{2, [10212,110212]},{4, [10232,110232]},{5, [10202,110202]},{7, [10210,110210]},{8, [10200,110200]}]
	};
get_devour_target(10241) -> 
	{4,
			[{1, [10202,110202]},{2, [10231,110231]},{4, [10200,110200]},{5, [10237,110237]},{7, [10276,110276]},{8, [10237,110237]}]
	};
get_devour_target(10242) -> 
	{4,
			[{1, [10253,110253]},{2, [10232,110232]},{4, [10277,110277]},{5, [10236,110236]},{7, [10231,110231]},{8, [10274,110274]}]
	};
get_devour_target(10244) -> 
	{4,
			[{1, [10253,110253]},{2, [10273,110273]},{4, [10232,110232]},{5, [10236,110236]},{7, [10210,110210]},{8, [10200,110200]}]
	};
get_devour_target(10245) -> 
	{4,
			[{1, [10205,110205]},{2, [10212,110212]},{4, [10213,110213]},{5, [10206,110206]},{7, [10201,110201]},{8, [10276,110276]}]
	};
get_devour_target(10246) -> 
	{3,
			[{1, [10252,110252]},{2, [10273,110273]},{4, [10212,110212]},{5, [10202,110202]}]
	};
get_devour_target(10247) -> 
	{2,
			[{1, [10252,110252]},{2, [10232,110232]}]
	};
get_devour_target(10248) -> 
	{5,
			[{1, [10252,110252]},{2, [10273,110273]},{4, [10232,110232]},{5, [10202,110202]},{7, [10210,110210]},{8, [10247,110247]},{10, [10246,110246]},{11, [10239,110239]}]
	};
get_devour_target(10252) -> 
	{1,
			[]
	};
get_devour_target(10253) -> 
	{1,
			[]
	};
get_devour_target(10254) -> 
	{5,
			[{1, [10202,110202]},{2, [10247,110247]},{4, [10200,110200]},{5, [10237,110237]},{7, [10237,110237]},{8, [10200,110200]},{10, [10220,110220]},{11, [10241,110241]}]
	};
get_devour_target(10256) -> 
	{5,
			[{1, [10205,110205]},{2, [10204,110204]},{4, [10277,110277]},{5, [10206,110206]},{7, [10201,110201]},{8, [10200,110200]},{10, [10237,110237]},{11, [10245,110245]}]
	};
get_devour_target(20007) -> 
	{4,
			[{1, [10252,110252]},{2, [10277,110277]},{4, [10273,110273]},{5, [10202,110202]},{7, [10214,110214]},{8, [10207,110207]}]
	};
get_devour_target(10200) -> 
	{3,
			[{1, [10205,110205]},{2, [10204,110204]},{4, [10206,110206]},{5, [10212,110212]}]
	};
get_devour_target(10273) -> 
	{1,
			[]
	};
get_devour_target(10274) -> 
	{3,
			[{1, [10253,110253]},{2, [10232,110232]},{4, [10204,110204]},{5, [10236,110236]}]
	};
get_devour_target(10275) -> 
	{3,
			[{1, [10253,110253]},{2, [10204,110204]},{4, [10273,110273]},{5, [10236,110236]}]
	};
get_devour_target(10276) -> 
	{3,
			[{1, [10253,110253]},{2, [10277,110277]},{4, [10236,110236]},{5, [10231,110231]}]
	};
get_devour_target(10277) -> 
	{1,
			[]
	};
get_devour_target(118009) -> 
	{5,
			[{1, [10202,110202]},{2, [10247,110247]},{4, [10200,110200]},{5, [10237,110237]},{7, [10234,110234]},{8, [10241,110241]},{10, [118012]},{11, [10254,110254]}]
	};
get_devour_target(118010) -> 
	{5,
			[{1, [10236,110236]},{2, [10212,110212]},{4, [10276,110276]},{5, [10200,110200]},{7, [10220,110220]},{8, [10241,110241]},{10, [118011]},{11, [10254,110254]}]
	};
get_devour_target(118011) -> 
	{5,
			[{1, [10206,110206]},{2, [10212,110212]},{4, [10276,110276]},{5, [10237,110237]},{7, [10276,110276]},{8, [10200,110200]},{10, [10234,110234]},{11, [10241,110241]}]
	};
get_devour_target(118012) -> 
	{4,
			[{1, [10236,110236]},{2, [10231,110231]},{4, [10276,110276]},{5, [10200,110200]},{7, [10276,110276]},{8, [10237,110237]}]
	};
get_devour_target(110201) -> 
	{2,
			[{1, [10252,110252]},{2, [10204,110204]}]
	};
get_devour_target(110202) -> 
	{2,
			[{1, [10252,110252]},{2, [10232,110232]}]
	};
get_devour_target(110204) -> 
	{1,
			[]
	};
get_devour_target(110205) -> 
	{1,
			[]
	};
get_devour_target(110206) -> 
	{2,
			[{1, [10205,110205]},{2, [10204,110204]}]
	};
get_devour_target(110207) -> 
	{3,
			[{1, [10253,110253]},{2, [10277,110277]},{4, [10204,110204]},{5, [10236,110236]}]
	};
get_devour_target(110210) -> 
	{2,
			[{1, [10253,110253]},{2, [10232,110232]}]
	};
get_devour_target(110212) -> 
	{1,
			[{1, [10205.110205]},{2, [10204,110204]}]
	};
get_devour_target(110213) -> 
	{1,
			[]
	};
get_devour_target(110214) -> 
	{2,
			[{1, [10205,110205]},{2, [10212,110212]}]
	};
get_devour_target(110215) -> 
	{4,
			[{1, [10252,110252]},{2, [10231,110231]},{4, [10277,110277]},{5, [10202,110202]},{7, [10218,110218]},{8, [10219,110219]}]
	};
get_devour_target(110216) -> 
	{3,
			[{1, [10253,110253]},{2, [10277,110277]},{4, [10232,110232]},{5, [10236,110236]}]
	};
get_devour_target(110217) -> 
	{3,
			[{1, [10253,110253]},{2, [10277,110277]},{4, [10273,110273]},{5, [10236,110236]}]
	};
get_devour_target(110218) -> 
	{2,
			[{1, [10205,110205]},{2, [10206,110206]}]
	};
get_devour_target(110219) -> 
	{3,
			[{1, [10252,110252]},{2, [10277,110277]},{4, [10273,110273]},{5, [10202,110202]}]
	};
get_devour_target(110220) -> 
	{4,
			[{1, [10236,110236]},{2, [10212,110212]},{4, [10200,110200]},{5, [10276,110276]},{7, [10200,110200]},{8, [10237,110237]}]
	};
get_devour_target(110285) -> 
	{3,
			[{1, [10252,110252]},{2, [10273,110273]},{4, [10204,110204]},{5, [10236,110236]}]
	};
get_devour_target(110226) -> 
	{4,
			[{1, [10252,110252]},{2, [10204,110204]},{4, [10212,110212]},{5, [10236,110236]},{7, [10201,110201]},{8, [10219,110219]}]
	};
get_devour_target(110227) -> 
	{2,
			[{1, [10205,110205]},{2, [10213,110213]}]
	};
get_devour_target(110230) -> 
	{2,
			[{1, [10252,110252]},{2, [10213,110213]}]
	};
get_devour_target(110231) -> 
	{2,
			[{1, [10253,110253]},{2, [10277,110277]}]
	};
get_devour_target(110232) -> 
	{1,
			[]
	};
get_devour_target(110234) -> 
	{4,
			[{1, [10206,110206]},{2, [10247,110247]},{4, [10276,110276]},{5, [10237,110237]},{7, [10276,110276]},{8, [10200,110200]}]
	};
get_devour_target(110235) -> 
	{5,
			[{1, [10205,110205]},{2, [10273,110273]},{4, [10232,110232]},{5, [10206,110206]},{7, [10236,110236]},{8, [10247,110247]},{10, [10246,110246]},{11, [10234,110234]}]
	};
get_devour_target(110236) -> 
	{2,
			[{1, [10253,110253]},{2, [10277,110277]}]
	};
get_devour_target(110237) -> 
	{3,
			[{1, [10252,110252]},{2, [10232,110232]},{4, [10202,110202]},{5, [10247,110247]}]
	};
get_devour_target(110239) -> 
	{4,
			[{1, [10252,110252]},{2, [10232,110232]},{4, [10204,110204]},{5, [10202,110202]},{7, [10230,110230]},{8, [10285,110285]}]
	};
get_devour_target(110240) -> 
	{4,
			[{1, [10252,110252]},{2, [10212,110212]},{4, [10232,110232]},{5, [10202,110202]},{7, [10210,110210]},{8, [10200,110200]}]
	};
get_devour_target(110241) -> 
	{4,
			[{1, [10202,110202]},{2, [10231,110231]},{4, [10200,110200]},{5, [10237,110237]},{7, [10276,110276]},{8, [10237,110237]}]
	};
get_devour_target(110242) -> 
	{4,
			[{1, [10253,110253]},{2, [10232,110232]},{4, [10277,110277]},{5, [10236,110236]},{7, [10231,110231]},{8, [10274,110274]}]
	};
get_devour_target(110244) -> 
	{5,
			[{1, [10253,110253]},{2, [10273,110273]},{4, [10232,110232]},{5, [10236,110236]},{7, [10210,110210]},{8, [10200,110200]}]
	};
get_devour_target(110245) -> 
	{4,
			[{1, [10205,110205]},{2, [10212,110212]},{4, [10213,110213]},{5, [10206,110206]},{7, [10201,110201]},{8, [10276,110276]}]
	};
get_devour_target(110246) -> 
	{3,
			[{1, [10252,110252]},{2, [10273,110273]},{4, [10212,110212]},{5, [10202,110202]}]
	};
get_devour_target(110247) -> 
	{2,
			[{1, [10252,110252]},{2, [10232,110232]}]
	};
get_devour_target(110248) -> 
	{5,
			[{1, [10252,110252]},{2, [10273,110273]},{4, [10232,110232]},{5, [10202,110202]},{7, [10210,110210]},{8, [10247,110247]},{10, [10246,110246]},{11, [10239,110239]}]
	};
get_devour_target(110252) -> 
	{1,
			[]
	};
get_devour_target(110253) -> 
	{1,
			[]
	};
get_devour_target(110254) -> 
	{5,
			[{1, [10202,110202]},{2, [10247,110247]},{4, [10200,110200]},{5, [10237,110237]},{7, [10237,110237]},{8, [10200,110200]},{10, [10220,110220]},{11, [10241,110241]}]
	};
get_devour_target(110256) -> 
	{5,
			[{1, [10205,110205]},{2, [10204,110204]},{4, [10277,110277]},{5, [10206,110206]},{7, [10201,110201]},{8, [10200,110200]},{10, [10237,110237]},{11, [10245,110245]}]
	};
get_devour_target(120007) -> 
	{4,
			[{1, [10252,110252]},{2, [10277,110277]},{4, [10273,110273]},{5, [10202,110202]},{7, [10214,110214]},{8, [10207,110207]}]
	};
get_devour_target(110200) -> 
	{3,
			[{1, [10205,110205]},{2, [10204,110204]},{4, [10206,110206]},{5, [10212,110212]}]
	};
get_devour_target(110273) -> 
	{1,
			[]
	};
get_devour_target(110274) -> 
	{3,
			[{1, [10253,110253]},{2, [10232,110232]},{4, [10204,110204]},{5, [10236,110236]}]
	};
get_devour_target(110275) -> 
	{3,
			[{1, [10253,110253]},{2, [10204,110204]},{4, [10273,110273]},{5, [10236,110236]}]
	};
get_devour_target(110276) -> 
	{3,
			[{1, [10253,110253]},{2, [10277,110277]},{4, [10236,110236]},{5, [10231,110231]}]
	};
get_devour_target(110277) -> 
	{1,
			[]
	};
get_devour_target(_) ->
	[].


get_devour_attr(10201) -> 
	{3,[
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}]			
	]
};
get_devour_attr(10202) -> 
	{2,[
					[{?attr_dmg, 263.000},{?attr_critrate, 105.000},{?attr_hp_max, 1103.000},{?attr_mp_max, 700.000},{?attr_defence, 551.000},{?attr_tenacity, 105.000},{?attr_evasion, 44.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 263.000},{?attr_critrate, 105.000},{?attr_hp_max, 1103.000},{?attr_mp_max, 700.000},{?attr_defence, 551.000},{?attr_tenacity, 105.000},{?attr_evasion, 44.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 131.000},{?attr_critrate, 53.000},{?attr_hp_max, 551.000},{?attr_mp_max, 350.000},{?attr_defence, 276.000},{?attr_tenacity, 53.000},{?attr_evasion, 22.000},{?attr_hitrate, 21.000},{?attr_dmg_magic, 66.000}]			
	]
};
get_devour_attr(10204) -> 
	{1,[
			
	]
};
get_devour_attr(10205) -> 
	{1,[
			
	]
};
get_devour_attr(10206) -> 
	{2,[
					[{?attr_dmg, 276.000},{?attr_critrate, 105.000},{?attr_hp_max, 1050.000},{?attr_mp_max, 700.000},{?attr_defence, 551.000},{?attr_tenacity, 105.000},{?attr_evasion, 44.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 276.000},{?attr_critrate, 105.000},{?attr_hp_max, 1050.000},{?attr_mp_max, 700.000},{?attr_defence, 551.000},{?attr_tenacity, 105.000},{?attr_evasion, 44.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 138.000},{?attr_critrate, 53.000},{?attr_hp_max, 525.000},{?attr_mp_max, 350.000},{?attr_defence, 276.000},{?attr_tenacity, 53.000},{?attr_evasion, 22.000},{?attr_hitrate, 21.000},{?attr_dmg_magic, 66.000}]			
	]
};
get_devour_attr(10207) -> 
	{2,[
					[{?attr_dmg, 263.000},{?attr_critrate, 105.000},{?attr_hp_max, 1103.000},{?attr_mp_max, 735.000},{?attr_defence, 525.000},{?attr_tenacity, 105.000},{?attr_evasion, 42.000},{?attr_hitrate, 44.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 263.000},{?attr_critrate, 105.000},{?attr_hp_max, 1103.000},{?attr_mp_max, 735.000},{?attr_defence, 525.000},{?attr_tenacity, 105.000},{?attr_evasion, 42.000},{?attr_hitrate, 44.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 131.000},{?attr_critrate, 53.000},{?attr_hp_max, 551.000},{?attr_mp_max, 368.000},{?attr_defence, 263.000},{?attr_tenacity, 53.000},{?attr_evasion, 21.000},{?attr_hitrate, 22.000},{?attr_dmg_magic, 66.000}]			
	]
};
get_devour_attr(10210) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(10212) -> 
	{1,[
			
	]
};
get_devour_attr(10213) -> 
	{1,[
			
	]
};
get_devour_attr(10214) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 63.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 63.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}]			
	]
};
get_devour_attr(10215) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}]			
	]
};
get_devour_attr(10216) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(10217) -> 
	{3,[
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}]			
	]
};
get_devour_attr(10218) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(10219) -> 
	{3,[
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(10220) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(10285) -> 
	{3,[
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(10226) -> 
	{4,[
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}]			
	]
};
get_devour_attr(10227) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 63.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 63.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 63.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 63.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(10230) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 840.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 840.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 420.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 840.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 840.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 420.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}]			
	]
};
get_devour_attr(10231) -> 
	{2,[
					[{?attr_dmg, 263.000},{?attr_critrate, 105.000},{?attr_hp_max, 1103.000},{?attr_mp_max, 700.000},{?attr_defence, 551.000},{?attr_tenacity, 110.000},{?attr_evasion, 42.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 263.000},{?attr_critrate, 105.000},{?attr_hp_max, 1103.000},{?attr_mp_max, 700.000},{?attr_defence, 551.000},{?attr_tenacity, 110.000},{?attr_evasion, 42.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 131.000},{?attr_critrate, 53.000},{?attr_hp_max, 551.000},{?attr_mp_max, 350.000},{?attr_defence, 276.000},{?attr_tenacity, 55.000},{?attr_evasion, 21.000},{?attr_hitrate, 21.000},{?attr_dmg_magic, 66.000}]			
	]
};
get_devour_attr(10232) -> 
	{1,[
			
	]
};
get_devour_attr(10234) -> 
	{4,[
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 89.000}]			
	]
};
get_devour_attr(10235) -> 
	{5,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(10236) -> 
	{2,[
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(10237) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 79.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 79.000}]			
	]
};
get_devour_attr(10239) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(10240) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}]			
	]
};
get_devour_attr(10241) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(10242) -> 
	{4,[
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(10244) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(10245) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(10246) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 63.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 63.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(10247) -> 
	{2,[
					[{?attr_dmg, 276.000},{?attr_critrate, 110.000},{?attr_hp_max, 1050.000},{?attr_mp_max, 700.000},{?attr_defence, 525.000},{?attr_tenacity, 105.000},{?attr_evasion, 42.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 138.000}], 
					[{?attr_dmg, 276.000},{?attr_critrate, 110.000},{?attr_hp_max, 1050.000},{?attr_mp_max, 700.000},{?attr_defence, 525.000},{?attr_tenacity, 105.000},{?attr_evasion, 42.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 138.000}], 
					[{?attr_dmg, 138.000},{?attr_critrate, 55.000},{?attr_hp_max, 525.000},{?attr_mp_max, 350.000},{?attr_defence, 263.000},{?attr_tenacity, 53.000},{?attr_evasion, 21.000},{?attr_hitrate, 21.000},{?attr_dmg_magic, 69.000}]			
	]
};
get_devour_attr(10248) -> 
	{5,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(10252) -> 
	{1,[
			
	]
};
get_devour_attr(10253) -> 
	{1,[
			
	]
};
get_devour_attr(10254) -> 
	{5,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(10256) -> 
	{5,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 28.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 28.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 28.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 28.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(20007) -> 
	{4,[
					[{?attr_dmg, 354.000},{?attr_critrate, 142.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 142.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 71.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 142.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 142.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 71.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 142.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 142.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 71.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}]			
	]
};
get_devour_attr(10200) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(10273) -> 
	{1,[
			
	]
};
get_devour_attr(10274) -> 
	{3,[
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}]			
	]
};
get_devour_attr(10275) -> 
	{3,[
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(10276) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 63.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 63.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(10277) -> 
	{1,[
			
	]
};
get_devour_attr(118009) -> 
	{5,[
					[{?attr_dmg, 394.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 60.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 394.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 60.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 197.000},{?attr_critrate, 79.000},{?attr_hp_max, 750.000},{?attr_mp_max, 500.000},{?attr_defence, 375.000},{?attr_tenacity, 75.000},{?attr_evasion, 30.000},{?attr_hitrate, 30.000},{?attr_dmg_magic, 98.000}], 
					[{?attr_dmg, 394.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 60.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 394.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 60.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 197.000},{?attr_critrate, 79.000},{?attr_hp_max, 750.000},{?attr_mp_max, 500.000},{?attr_defence, 375.000},{?attr_tenacity, 75.000},{?attr_evasion, 30.000},{?attr_hitrate, 30.000},{?attr_dmg_magic, 98.000}], 
					[{?attr_dmg, 394.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 60.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 394.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 60.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 197.000},{?attr_critrate, 79.000},{?attr_hp_max, 750.000},{?attr_mp_max, 500.000},{?attr_defence, 375.000},{?attr_tenacity, 75.000},{?attr_evasion, 30.000},{?attr_hitrate, 30.000},{?attr_dmg_magic, 98.000}], 
					[{?attr_dmg, 394.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 60.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 394.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 60.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 197.000},{?attr_critrate, 79.000},{?attr_hp_max, 750.000},{?attr_mp_max, 500.000},{?attr_defence, 375.000},{?attr_tenacity, 75.000},{?attr_evasion, 30.000},{?attr_hitrate, 30.000},{?attr_dmg_magic, 98.000}]			
	]
};
get_devour_attr(118010) -> 
	{5,[
					[{?attr_dmg, 375.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 63.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 375.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 63.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 188.000},{?attr_critrate, 79.000},{?attr_hp_max, 750.000},{?attr_mp_max, 500.000},{?attr_defence, 375.000},{?attr_tenacity, 75.000},{?attr_evasion, 30.000},{?attr_hitrate, 32.000},{?attr_dmg_magic, 98.000}], 
					[{?attr_dmg, 375.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 63.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 375.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 63.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 188.000},{?attr_critrate, 79.000},{?attr_hp_max, 750.000},{?attr_mp_max, 500.000},{?attr_defence, 375.000},{?attr_tenacity, 75.000},{?attr_evasion, 30.000},{?attr_hitrate, 32.000},{?attr_dmg_magic, 98.000}], 
					[{?attr_dmg, 375.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 63.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 375.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 63.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 188.000},{?attr_critrate, 79.000},{?attr_hp_max, 750.000},{?attr_mp_max, 500.000},{?attr_defence, 375.000},{?attr_tenacity, 75.000},{?attr_evasion, 30.000},{?attr_hitrate, 32.000},{?attr_dmg_magic, 98.000}], 
					[{?attr_dmg, 375.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 63.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 375.000},{?attr_critrate, 158.000},{?attr_hp_max, 1500.000},{?attr_mp_max, 1000.000},{?attr_defence, 750.000},{?attr_tenacity, 150.000},{?attr_evasion, 60.000},{?attr_hitrate, 63.000},{?attr_dmg_magic, 197.000}], 
					[{?attr_dmg, 188.000},{?attr_critrate, 79.000},{?attr_hp_max, 750.000},{?attr_mp_max, 500.000},{?attr_defence, 375.000},{?attr_tenacity, 75.000},{?attr_evasion, 30.000},{?attr_hitrate, 32.000},{?attr_dmg_magic, 98.000}]			
	]
};
get_devour_attr(118011) -> 
	{5,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(118012) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 28.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 28.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 28.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(110201) -> 
	{3,[
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}]			
	]
};
get_devour_attr(110202) -> 
	{2,[
					[{?attr_dmg, 263.000},{?attr_critrate, 105.000},{?attr_hp_max, 1103.000},{?attr_mp_max, 700.000},{?attr_defence, 551.000},{?attr_tenacity, 105.000},{?attr_evasion, 44.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 263.000},{?attr_critrate, 105.000},{?attr_hp_max, 1103.000},{?attr_mp_max, 700.000},{?attr_defence, 551.000},{?attr_tenacity, 105.000},{?attr_evasion, 44.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 131.000},{?attr_critrate, 53.000},{?attr_hp_max, 551.000},{?attr_mp_max, 350.000},{?attr_defence, 276.000},{?attr_tenacity, 53.000},{?attr_evasion, 22.000},{?attr_hitrate, 21.000},{?attr_dmg_magic, 66.000}]			
	]
};
get_devour_attr(110204) -> 
	{1,[
			
	]
};
get_devour_attr(110205) -> 
	{1,[
			
	]
};
get_devour_attr(110206) -> 
	{2,[
					[{?attr_dmg, 276.000},{?attr_critrate, 105.000},{?attr_hp_max, 1050.000},{?attr_mp_max, 700.000},{?attr_defence, 551.000},{?attr_tenacity, 105.000},{?attr_evasion, 44.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 276.000},{?attr_critrate, 105.000},{?attr_hp_max, 1050.000},{?attr_mp_max, 700.000},{?attr_defence, 551.000},{?attr_tenacity, 105.000},{?attr_evasion, 44.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 138.000},{?attr_critrate, 53.000},{?attr_hp_max, 525.000},{?attr_mp_max, 350.000},{?attr_defence, 276.000},{?attr_tenacity, 53.000},{?attr_evasion, 22.000},{?attr_hitrate, 21.000},{?attr_dmg_magic, 66.000}]			
	]
};
get_devour_attr(110207) -> 
	{2,[
					[{?attr_dmg, 263.000},{?attr_critrate, 105.000},{?attr_hp_max, 1103.000},{?attr_mp_max, 735.000},{?attr_defence, 525.000},{?attr_tenacity, 105.000},{?attr_evasion, 42.000},{?attr_hitrate, 44.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 263.000},{?attr_critrate, 105.000},{?attr_hp_max, 1103.000},{?attr_mp_max, 735.000},{?attr_defence, 525.000},{?attr_tenacity, 105.000},{?attr_evasion, 42.000},{?attr_hitrate, 44.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 131.000},{?attr_critrate, 53.000},{?attr_hp_max, 551.000},{?attr_mp_max, 368.000},{?attr_defence, 263.000},{?attr_tenacity, 53.000},{?attr_evasion, 21.000},{?attr_hitrate, 22.000},{?attr_dmg_magic, 66.000}]			
	]
};
get_devour_attr(110210) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(110212) -> 
	{1,[
			
	]
};
get_devour_attr(110213) -> 
	{1,[
			
	]
};
get_devour_attr(110214) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 63.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 63.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}]			
	]
};
get_devour_attr(110215) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}]			
	]
};
get_devour_attr(110216) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(110217) -> 
	{3,[
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}]			
	]
};
get_devour_attr(110218) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(110219) -> 
	{3,[
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(110220) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(110285) -> 
	{3,[
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(110226) -> 
	{4,[
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}]			
	]
};
get_devour_attr(110227) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 63.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 63.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 63.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 63.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(110230) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 840.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 840.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 420.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 840.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 840.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 420.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}]			
	]
};
get_devour_attr(110231) -> 
	{2,[
					[{?attr_dmg, 263.000},{?attr_critrate, 105.000},{?attr_hp_max, 1103.000},{?attr_mp_max, 700.000},{?attr_defence, 551.000},{?attr_tenacity, 110.000},{?attr_evasion, 42.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 263.000},{?attr_critrate, 105.000},{?attr_hp_max, 1103.000},{?attr_mp_max, 700.000},{?attr_defence, 551.000},{?attr_tenacity, 110.000},{?attr_evasion, 42.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 131.000}], 
					[{?attr_dmg, 131.000},{?attr_critrate, 53.000},{?attr_hp_max, 551.000},{?attr_mp_max, 350.000},{?attr_defence, 276.000},{?attr_tenacity, 55.000},{?attr_evasion, 21.000},{?attr_hitrate, 21.000},{?attr_dmg_magic, 66.000}]			
	]
};
get_devour_attr(110232) -> 
	{1,[
			
	]
};
get_devour_attr(110234) -> 
	{4,[
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 89.000}]			
	]
};
get_devour_attr(110235) -> 
	{5,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(110236) -> 
	{2,[
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(110237) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 79.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 79.000}]			
	]
};
get_devour_attr(110239) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(110240) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}]			
	]
};
get_devour_attr(110241) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(110242) -> 
	{4,[
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(110244) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 945.000},{?attr_defence, 709.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 473.000},{?attr_defence, 354.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(110245) -> 
	{4,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(110246) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 63.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 126.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 63.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(110247) -> 
	{2,[
					[{?attr_dmg, 276.000},{?attr_critrate, 110.000},{?attr_hp_max, 1050.000},{?attr_mp_max, 700.000},{?attr_defence, 525.000},{?attr_tenacity, 105.000},{?attr_evasion, 42.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 138.000}], 
					[{?attr_dmg, 276.000},{?attr_critrate, 110.000},{?attr_hp_max, 1050.000},{?attr_mp_max, 700.000},{?attr_defence, 525.000},{?attr_tenacity, 105.000},{?attr_evasion, 42.000},{?attr_hitrate, 42.000},{?attr_dmg_magic, 138.000}], 
					[{?attr_dmg, 138.000},{?attr_critrate, 55.000},{?attr_hp_max, 525.000},{?attr_mp_max, 350.000},{?attr_defence, 263.000},{?attr_tenacity, 53.000},{?attr_evasion, 21.000},{?attr_hitrate, 21.000},{?attr_dmg_magic, 69.000}]			
	]
};
get_devour_attr(110248) -> 
	{5,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 709.000},{?attr_tenacity, 142.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 354.000},{?attr_tenacity, 71.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(110252) -> 
	{1,[
			
	]
};
get_devour_attr(110253) -> 
	{1,[
			
	]
};
get_devour_attr(110254) -> 
	{5,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1418.000},{?attr_mp_max, 945.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 709.000},{?attr_mp_max, 473.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(110256) -> 
	{5,[
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 28.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 28.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 28.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 84.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 338.000},{?attr_critrate, 135.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 142.000},{?attr_evasion, 57.000},{?attr_hitrate, 57.000},{?attr_dmg_magic, 169.000}], 
					[{?attr_dmg, 169.000},{?attr_critrate, 68.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 71.000},{?attr_evasion, 28.000},{?attr_hitrate, 28.000},{?attr_dmg_magic, 84.000}]			
	]
};
get_devour_attr(120007) -> 
	{4,[
					[{?attr_dmg, 354.000},{?attr_critrate, 142.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 142.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 71.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 142.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 142.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 71.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 142.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 354.000},{?attr_critrate, 142.000},{?attr_hp_max, 1350.000},{?attr_mp_max, 900.000},{?attr_defence, 675.000},{?attr_tenacity, 135.000},{?attr_evasion, 54.000},{?attr_hitrate, 54.000},{?attr_dmg_magic, 177.000}], 
					[{?attr_dmg, 177.000},{?attr_critrate, 71.000},{?attr_hp_max, 675.000},{?attr_mp_max, 450.000},{?attr_defence, 338.000},{?attr_tenacity, 68.000},{?attr_evasion, 27.000},{?attr_hitrate, 27.000},{?attr_dmg_magic, 89.000}]			
	]
};
get_devour_attr(110200) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 50.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 25.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(110273) -> 
	{1,[
			
	]
};
get_devour_attr(110274) -> 
	{3,[
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 126.000},{?attr_hp_max, 1200.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 158.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 63.000},{?attr_hp_max, 600.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 79.000}]			
	]
};
get_devour_attr(110275) -> 
	{3,[
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 315.000},{?attr_critrate, 120.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 630.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 48.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 158.000},{?attr_critrate, 60.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 315.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 24.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(110276) -> 
	{3,[
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 63.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 75.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 300.000},{?attr_critrate, 126.000},{?attr_hp_max, 1260.000},{?attr_mp_max, 800.000},{?attr_defence, 600.000},{?attr_tenacity, 120.000},{?attr_evasion, 48.000},{?attr_hitrate, 50.000},{?attr_dmg_magic, 150.000}], 
					[{?attr_dmg, 150.000},{?attr_critrate, 63.000},{?attr_hp_max, 630.000},{?attr_mp_max, 400.000},{?attr_defence, 300.000},{?attr_tenacity, 60.000},{?attr_evasion, 24.000},{?attr_hitrate, 25.000},{?attr_dmg_magic, 75.000}]			
	]
};
get_devour_attr(110277) -> 
	{1,[
			
	]
};
get_devour_attr(_) ->
	[].

	

