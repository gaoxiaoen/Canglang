%%----------------------------------------------------
%% 数据
%% @author whing2012@gmail.com
%%----------------------------------------------------
-module(achievement_data_everyday).
-export([list/0, list_types/0, list_types/1, get/1]).
-include("achievement.hrl").
-include("condition.hrl").


%% 所有日常目标数据
list() ->
   [1000,1001,1100,1200,1201,1300,1400,1500,1501,1502,1600,1601,1602,1700,
1800,1801,1900,1901,1902,1903,1904,1905,1906,1907,1908,1909,1910,1911,1912,
1913,1914,1915,1916].

%% 所有日常类型
list_types() -> [10,11,12,13,14,15,16,17,18,19].

%% 指定类型目标
list_types(10) -> [1000,1001];
list_types(11) -> [1100];
list_types(12) -> [1200,1201];
list_types(13) -> [1300];
list_types(14) -> [1400];
list_types(15) -> [1500,1501,1502];
list_types(16) -> [1600,1601,1602];
list_types(17) -> [1700];
list_types(18) -> [1800,1801];
list_types(19) -> [1900,1901,1902,1903,1904,1905,1906,1907,1908,1909
   ,1910,1911,1912,1913,1914,1915,1916];
list_types(_) -> [].


%% 日常目标数据
get(1000) ->
    {ok, #achievement_base{
            id = 1000
            ,name = <<"装备强化">>
            ,type = 10
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 40}
]
            ,finish_cond = [#condition{label = acc_event, target = 125, target_value = 1}
]
        }
    };

get(1001) ->
    {ok, #achievement_base{
            id = 1001
            ,name = <<"品质提升">>
            ,type = 10
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 50}
]
            ,finish_cond = [#condition{label = acc_event, target = 126, target_value = 1}
]
        }
    };

get(1100) ->
    {ok, #achievement_base{
            id = 1100
            ,name = <<"坐骑增强">>
            ,type = 11
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 43}
]
            ,finish_cond = [#condition{label = acc_event, target = 127, target_value = 100}
]
        }
    };

get(1200) ->
    {ok, #achievement_base{
            id = 1200
            ,name = <<"翅膀进阶">>
            ,type = 12
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 44}
]
            ,finish_cond = [#condition{label = acc_event, target = 128, target_value = 1}
]
        }
    };

get(1201) ->
    {ok, #achievement_base{
            id = 1201
            ,name = <<"翅膀技能提升">>
            ,type = 12
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 44}
]
            ,finish_cond = [#condition{label = acc_event, target = 129, target_value = 1}
]
        }
    };

get(1300) ->
    {ok, #achievement_base{
            id = 1300
            ,name = <<"元神境界提升">>
            ,type = 13
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 40}
]
            ,finish_cond = [#condition{label = acc_event, target = 130, target_value = 2}
]
        }
    };

get(1400) ->
    {ok, #achievement_base{
            id = 1400
            ,name = <<"技能提升">>
            ,type = 14
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 40}
]
            ,finish_cond = [#condition{label = acc_event, target = 131, target_value = 1}
]
        }
    };

get(1500) ->
    {ok, #achievement_base{
            id = 1500
            ,name = <<"宠物潜力提升">>
            ,type = 15
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 40}
]
            ,finish_cond = [#condition{label = acc_event, target = 132, target_value = 3}
]
        }
    };

get(1501) ->
    {ok, #achievement_base{
            id = 1501
            ,name = <<"宠物成长提升">>
            ,type = 15
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 40}
]
            ,finish_cond = [#condition{label = acc_event, target = 133, target_value = 3}
]
        }
    };

get(1502) ->
    {ok, #achievement_base{
            id = 1502
            ,name = <<"宠物魔晶提升">>
            ,type = 15
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 40}
]
            ,finish_cond = [#condition{label = acc_event, target = 134, target_ext = 3, target_value = 1}
]
        }
    };

get(1600) ->
    {ok, #achievement_base{
            id = 1600
            ,name = <<"帮会贡献">>
            ,type = 16
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 40}
]
            ,finish_cond = [#condition{label = acc_event, target = 138, target_value = 1000}
]
        }
    };

get(1601) ->
    {ok, #achievement_base{
            id = 1601
            ,name = <<"帮会贡献">>
            ,type = 16
            ,extends = 1600
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 50}
]
            ,finish_cond = [#condition{label = acc_event, target = 138, target_value = 1200}
]
        }
    };

get(1602) ->
    {ok, #achievement_base{
            id = 1602
            ,name = <<"帮会贡献">>
            ,type = 16
            ,extends = 1601
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 60}
]
            ,finish_cond = [#condition{label = acc_event, target = 138, target_value = 1500}
]
        }
    };

get(1700) ->
    {ok, #achievement_base{
            id = 1700
            ,name = <<"八门遁甲">>
            ,type = 17
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 52}
]
            ,finish_cond = [#condition{label = acc_event, target = 136, target_value = 1}
]
        }
    };

get(1800) ->
    {ok, #achievement_base{
            id = 1800
            ,name = <<"合成宝石">>
            ,type = 18
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 42}
]
            ,finish_cond = [#condition{label = acc_event, target = 118, target_ext = 4, target_value = 1}
]
        }
    };

get(1801) ->
    {ok, #achievement_base{
            id = 1801
            ,name = <<"淬炼宝石">>
            ,type = 18
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 42}
]
            ,finish_cond = [#condition{label = acc_event, target = 137, target_value = 1}
]
        }
    };

get(1900) ->
    {ok, #achievement_base{
            id = 1900
            ,name = <<"【镇妖塔】闯关">>
            ,type = 19
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 40}
]
            ,finish_cond = [#condition{label = kill_npc, target = 0, target_ext = [30056, 24052], target_value = 1}
]
        }
    };

get(1901) ->
    {ok, #achievement_base{
            id = 1901
            ,name = <<"【镇妖塔】闯关">>
            ,type = 19
            ,extends = 1900
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 50}
]
            ,finish_cond = [#condition{label = kill_npc, target = 0, target_ext = [30059, 24055], target_value = 1}
]
        }
    };

get(1902) ->
    {ok, #achievement_base{
            id = 1902
            ,name = <<"【镇妖塔】闯关">>
            ,type = 19
            ,extends = 1901
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 60}
]
            ,finish_cond = [#condition{label = kill_npc, target = 0, target_ext = [30063, 24059], target_value = 1}
]
        }
    };

get(1903) ->
    {ok, #achievement_base{
            id = 1903
            ,name = <<"【镇妖塔】闯关">>
            ,type = 19
            ,extends = 1902
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 70}
]
            ,finish_cond = [#condition{label = kill_npc, target = 0, target_ext = [30065, 24061], target_value = 1}
]
        }
    };

get(1904) ->
    {ok, #achievement_base{
            id = 1904
            ,name = <<"【梦溪古谈】挑战">>
            ,type = 19
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 43}
]
            ,finish_cond = [#condition{label = special_event, target = 20030, target_value = 1}
]
        }
    };

get(1905) ->
    {ok, #achievement_base{
            id = 1905
            ,name = <<"【无尽试炼】挑战">>
            ,type = 19
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 40}
]
            ,finish_cond = [#condition{label = special_event, target = 20029, target_value = 5}
]
        }
    };

get(1906) ->
    {ok, #achievement_base{
            id = 1906
            ,name = <<"【无尽试炼】挑战">>
            ,type = 19
            ,extends = 1905
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 50}
]
            ,finish_cond = [#condition{label = special_event, target = 20029, target_value = 8}
]
        }
    };

get(1907) ->
    {ok, #achievement_base{
            id = 1907
            ,name = <<"【无尽试炼】挑战">>
            ,type = 19
            ,extends = 1906
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 60}
]
            ,finish_cond = [#condition{label = special_event, target = 20029, target_value = 10}
]
        }
    };

get(1908) ->
    {ok, #achievement_base{
            id = 1908
            ,name = <<"【无尽试炼】挑战">>
            ,type = 19
            ,extends = 1907
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 70}
]
            ,finish_cond = [#condition{label = special_event, target = 20029, target_value = 16}
]
        }
    };

get(1909) ->
    {ok, #achievement_base{
            id = 1909
            ,name = <<"【仙道会】历练">>
            ,type = 19
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 52}
]
            ,finish_cond = [#condition{label = acc_event, target = 135, target_value = 500}
]
        }
    };

get(1910) ->
    {ok, #achievement_base{
            id = 1910
            ,name = <<"【仙道会】历练">>
            ,type = 19
            ,extends = 1909
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 60}
]
            ,finish_cond = [#condition{label = acc_event, target = 135, target_value = 600}
]
        }
    };

get(1911) ->
    {ok, #achievement_base{
            id = 1911
            ,name = <<"【仙道会】历练">>
            ,type = 19
            ,extends = 1910
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 70}
]
            ,finish_cond = [#condition{label = acc_event, target = 135, target_value = 800}
]
        }
    };

get(1912) ->
    {ok, #achievement_base{
            id = 1912
            ,name = <<"【帮战】积分">>
            ,type = 19
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 40}
]
            ,finish_cond = [#condition{label = special_event, target = 20028, target_value = 200}
]
        }
    };

get(1913) ->
    {ok, #achievement_base{
            id = 1913
            ,name = <<"【帮战】积分">>
            ,type = 19
            ,extends = 1912
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 50}
]
            ,finish_cond = [#condition{label = special_event, target = 20028, target_value = 350}
]
        }
    };

get(1914) ->
    {ok, #achievement_base{
            id = 1914
            ,name = <<"【帮战】积分">>
            ,type = 19
            ,extends = 1913
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 60}
]
            ,finish_cond = [#condition{label = special_event, target = 20028, target_value = 500}
]
        }
    };

get(1915) ->
    {ok, #achievement_base{
            id = 1915
            ,name = <<"【帮战】积分">>
            ,type = 19
            ,extends = 1914
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 70}
]
            ,finish_cond = [#condition{label = special_event, target = 20028, target_value = 700}
]
        }
    };

get(1916) ->
    {ok, #achievement_base{
            id = 1916
            ,name = <<"【竞技场】挑战">>
            ,type = 19
            ,extends = false
            ,accept_cond = [#condition{label = lev, target = 0, target_value = 40}
]
            ,finish_cond = [#condition{label = acc_event, target = 106, target_value = 4}
]
        }
    };

get(_) ->
    {false, <<"无相关日常目标">>}.
