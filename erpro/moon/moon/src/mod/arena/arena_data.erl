%%----------------------------------------------------
%% @doc 竞技场模块数据
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(arena_data).

-export([
        supply/2
        ,robot_score/1
        ,robot_base/2
    ]
).

-include("common.hrl").
-include("arena.hrl").

%% 算计补给人数
supply(?arena_lev_low, Num) -> calc_suppply(Num, 0.7, 4);
supply(?arena_lev_middle, Num) -> calc_suppply(Num, 0.7, 4);
supply(?arena_lev_hight, Num) -> calc_suppply(Num, 0.8, 2.5);
supply(?arena_lev_super, Num) -> calc_suppply(Num, 0.8, 2.5);
supply(?arena_lev_angle, Num) -> calc_suppply(Num, 0.8, 2.5);
supply(_ArenaLev, _Num) -> 0.

calc_suppply(Num, Pow, Rate) ->
    case math:pow(Num, Pow) * Rate of
        Total when Total > 100 -> 
            case Num < 100 of
                true -> 100 - Num;
                _ -> 0
            end;
        Total when Total > Num -> round(Total) - Num;
        _ -> 0
    end.

%% 机器人积分
robot_score(?arena_lev_low) -> 5;
robot_score(?arena_lev_middle) -> 6;
robot_score(?arena_lev_hight) -> 7;
robot_score(?arena_lev_super) -> 8;
robot_score(?arena_lev_angle) -> 9;
robot_score(_ArenaLev) -> 0.

%% 机器人基本ID
robot_base(?arena_lev_low, ?arena_group_dragon) -> [20220, 20221];
%% robot_base(?arena_lev_middle, ?arena_group_dragon) -> [30001];
robot_base(?arena_lev_middle, ?arena_group_dragon) -> [20222, 20223];
robot_base(?arena_lev_hight, ?arena_group_dragon) -> [20224, 20225];
robot_base(?arena_lev_super, ?arena_group_dragon) -> [20226, 20227];
robot_base(?arena_lev_angle, ?arena_group_dragon) -> [20228, 20229];
robot_base(?arena_lev_low, ?arena_group_tiger) -> [20180, 20181];
%% robot_base(?arena_lev_middle, ?arena_group_tiger) -> [30000];
robot_base(?arena_lev_middle, ?arena_group_tiger) -> [20182, 20183];
robot_base(?arena_lev_hight, ?arena_group_tiger) -> [20184, 20185];
robot_base(?arena_lev_super, ?arena_group_tiger) -> [20186, 20187];
robot_base(?arena_lev_angle, ?arena_group_tiger) -> [20188, 20189].
