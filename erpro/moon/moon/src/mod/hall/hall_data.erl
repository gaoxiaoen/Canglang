%% --------------------------------------------------------------------
%% 大厅数据
%% --------------------------------------------------------------------
-module(hall_data).

-export([get_hall/1]).

-include("hall.hrl").

get_hall(1) -> %% 试练大厅
    #hall{
        type = ?hall_type_practice
        ,map_base_id = 36001
    };

get_hall(2) -> %% 天位战
    #hall{
        type = ?hall_type_cross_boss
        ,map_base_id = 30101
    };

get_hall(?hall_type_dungeon_loong) -> %% 龙宫大厅
    #hall{
        type = ?hall_type_dungeon_loong
    };

get_hall(?hall_type_dungeon_loong_hard) -> %% 里龙宫大厅
    #hall{
        type = ?hall_type_dungeon_loong_hard
    };

get_hall(?hall_type_dungeon_tower_cross) -> %% 跨服镇妖塔大厅
    #hall{
        type = ?hall_type_dungeon_tower_cross
    };

get_hall(?hall_type_dungeon_tower_hard_cross) -> %% 跨服里镇妖塔大厅
    #hall{
        type = ?hall_type_dungeon_tower_hard_cross
    };

get_hall(?hall_type_dungeon_loong_cross) -> %% 跨服龙宫大厅
    #hall{
        type = ?hall_type_dungeon_loong_cross
    };

get_hall(?hall_type_dungeon_loong_hard_cross) -> %% 跨服里龙宫大厅
    #hall{
        type = ?hall_type_dungeon_loong_hard_cross
    };

get_hall(?hall_type_dungeon_5xing) -> %% 五行结界大厅
    #hall{
        type = ?hall_type_dungeon_5xing
    };

get_hall(?hall_type_dungeon_5xing_cross) -> %% 五行结界跨服大厅
    #hall{
        type = ?hall_type_dungeon_5xing_cross
    };

get_hall(?hall_type_practice_cross) -> %% 无尽试炼跨服大厅
    #hall{
        type = ?hall_type_practice_cross
    };

get_hall(?hall_type_dungeon_poetry4) -> %% 古诗大乱斗本服大厅
    #hall{
        type = ?hall_type_dungeon_poetry4
    };
get_hall(?hall_type_dungeon_poetry5) -> %% 古诗大乱斗本服大厅
    #hall{
        type = ?hall_type_dungeon_poetry5
    };
get_hall(?hall_type_dungeon_poetry6) -> %% 古诗大乱斗本服大厅
    #hall{
        type = ?hall_type_dungeon_poetry6
    };
get_hall(?hall_type_dungeon_poetry7) -> %% 古诗大乱斗本服大厅
    #hall{
        type = ?hall_type_dungeon_poetry7
    };
get_hall(?hall_type_dungeon_poetry8) -> %% 古诗大乱斗本服大厅
    #hall{
        type = ?hall_type_dungeon_poetry8
    };
get_hall(?hall_type_dungeon_poetry9) -> %% 古诗大乱斗本服大厅
    #hall{
        type = ?hall_type_dungeon_poetry9
    };

get_hall(?hall_type_dungeon_poetry_cross4) -> %% 古诗大乱斗跨服大厅
    #hall{
        type = ?hall_type_dungeon_poetry_cross4
    };
get_hall(?hall_type_dungeon_poetry_cross5) -> %% 古诗大乱斗跨服大厅
    #hall{
        type = ?hall_type_dungeon_poetry_cross5
    };
get_hall(?hall_type_dungeon_poetry_cross6) -> %% 古诗大乱斗跨服大厅
    #hall{
        type = ?hall_type_dungeon_poetry_cross6
    };
get_hall(?hall_type_dungeon_poetry_cross7) -> %% 古诗大乱斗跨服大厅
    #hall{
        type = ?hall_type_dungeon_poetry_cross7
    };
get_hall(?hall_type_dungeon_poetry_cross8) -> %% 古诗大乱斗跨服大厅
    #hall{
        type = ?hall_type_dungeon_poetry_cross8
    };
get_hall(?hall_type_dungeon_poetry_cross9) -> %% 古诗大乱斗跨服大厅
    #hall{
        type = ?hall_type_dungeon_poetry_cross9
    };
get_hall(?hall_type_dungeon_liang_corss) -> %% 古诗大乱斗跨服大厅
    #hall{
        type = ?hall_type_dungeon_liang_corss
    };

get_hall(255) -> %% 用于测试
    #hall{
        type = 255
    }.


