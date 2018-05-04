%%----------------------------------------------------
%% 翅膀数据
%% @author whjing2012@gmail.com
%%----------------------------------------------------
-module(wing_data).
-export([
        get_suc/2
        ,get_max_luck/1
        ,get_skill_luck/2
        ,get_skill_list/0
    ]
).

-include("wing.hrl").

%% 获取进阶成功率
get_suc(1, LuckVal) when LuckVal >= 0 andalso LuckVal =< 60 -> 0;
get_suc(1, LuckVal) when LuckVal >= 61 andalso LuckVal =< 75 -> 0;
get_suc(1, LuckVal) when LuckVal >= 76 andalso LuckVal =< 90 -> 1;
get_suc(1, LuckVal) when LuckVal >= 91 andalso LuckVal =< 105 -> 1;
get_suc(1, LuckVal) when LuckVal >= 106 andalso LuckVal =< 120 -> 1;
get_suc(1, LuckVal) when LuckVal >= 121 andalso LuckVal =< 135 -> 100;
get_suc(1, LuckVal) when LuckVal >= 136 andalso LuckVal =< 150 -> 100;
get_suc(2, LuckVal) when LuckVal >= 0 andalso LuckVal =< 80 -> 0;
get_suc(2, LuckVal) when LuckVal >= 81 andalso LuckVal =< 100 -> 0;
get_suc(2, LuckVal) when LuckVal >= 101 andalso LuckVal =< 120 -> 0;
get_suc(2, LuckVal) when LuckVal >= 121 andalso LuckVal =< 140 -> 0;
get_suc(2, LuckVal) when LuckVal >= 141 andalso LuckVal =< 160 -> 1;
get_suc(2, LuckVal) when LuckVal >= 161 andalso LuckVal =< 180 -> 100;
get_suc(2, LuckVal) when LuckVal >= 181 andalso LuckVal =< 200 -> 100;
get_suc(3, LuckVal) when LuckVal >= 0 andalso LuckVal =< 100 -> 0;
get_suc(3, LuckVal) when LuckVal >= 101 andalso LuckVal =< 125 -> 0;
get_suc(3, LuckVal) when LuckVal >= 126 andalso LuckVal =< 150 -> 1;
get_suc(3, LuckVal) when LuckVal >= 151 andalso LuckVal =< 175 -> 5;
get_suc(3, LuckVal) when LuckVal >= 176 andalso LuckVal =< 200 -> 5;
get_suc(3, LuckVal) when LuckVal >= 201 andalso LuckVal =< 225 -> 100;
get_suc(3, LuckVal) when LuckVal >= 226 andalso LuckVal =< 250 -> 100;
get_suc(4, LuckVal) when LuckVal >= 0 andalso LuckVal =< 128 -> 0;
get_suc(4, LuckVal) when LuckVal >= 129 andalso LuckVal =< 160 -> 0;
get_suc(4, LuckVal) when LuckVal >= 161 andalso LuckVal =< 192 -> 0;
get_suc(4, LuckVal) when LuckVal >= 193 andalso LuckVal =< 224 -> 1;
get_suc(4, LuckVal) when LuckVal >= 225 andalso LuckVal =< 256 -> 5;
get_suc(4, LuckVal) when LuckVal >= 257 andalso LuckVal =< 288 -> 100;
get_suc(4, LuckVal) when LuckVal >= 289 andalso LuckVal =< 320 -> 100;
get_suc(5, LuckVal) when LuckVal >= 0 andalso LuckVal =< 140 -> 0;
get_suc(5, LuckVal) when LuckVal >= 141 andalso LuckVal =< 175 -> 0;
get_suc(5, LuckVal) when LuckVal >= 176 andalso LuckVal =< 210 -> 0;
get_suc(5, LuckVal) when LuckVal >= 211 andalso LuckVal =< 245 -> 5;
get_suc(5, LuckVal) when LuckVal >= 246 andalso LuckVal =< 280 -> 5;
get_suc(5, LuckVal) when LuckVal >= 281 andalso LuckVal =< 315 -> 100;
get_suc(5, LuckVal) when LuckVal >= 316 andalso LuckVal =< 350 -> 100;
get_suc(6, LuckVal) when LuckVal >= 351 andalso LuckVal =< 160 -> 0;
get_suc(6, LuckVal) when LuckVal >= 161 andalso LuckVal =< 200 -> 0;
get_suc(6, LuckVal) when LuckVal >= 201 andalso LuckVal =< 240 -> 0;
get_suc(6, LuckVal) when LuckVal >= 241 andalso LuckVal =< 280 -> 3;
get_suc(6, LuckVal) when LuckVal >= 281 andalso LuckVal =< 320 -> 5;
get_suc(6, LuckVal) when LuckVal >= 321 andalso LuckVal =< 360 -> 100;
get_suc(6, LuckVal) when LuckVal >= 361 andalso LuckVal =< 400 -> 100;
get_suc(7, LuckVal) when LuckVal >= 0 andalso LuckVal =< 200 -> 0;
get_suc(7, LuckVal) when LuckVal >= 201 andalso LuckVal =< 250 -> 0;
get_suc(7, LuckVal) when LuckVal >= 251 andalso LuckVal =< 300 -> 0;
get_suc(7, LuckVal) when LuckVal >= 301 andalso LuckVal =< 350 -> 2;
get_suc(7, LuckVal) when LuckVal >= 351 andalso LuckVal =< 400 -> 5;
get_suc(7, LuckVal) when LuckVal >= 401 andalso LuckVal =< 450 -> 100;
get_suc(7, LuckVal) when LuckVal >= 451 andalso LuckVal =< 500 -> 100;
get_suc(8, LuckVal) when LuckVal >= 0 andalso LuckVal =< 252 -> 0;
get_suc(8, LuckVal) when LuckVal >= 253 andalso LuckVal =< 315 -> 0;
get_suc(8, LuckVal) when LuckVal >= 316 andalso LuckVal =< 378 -> 0;
get_suc(8, LuckVal) when LuckVal >= 379 andalso LuckVal =< 441 -> 2;
get_suc(8, LuckVal) when LuckVal >= 442 andalso LuckVal =< 504 -> 5;
get_suc(8, LuckVal) when LuckVal >= 505 andalso LuckVal =< 567 -> 100;
get_suc(8, LuckVal) when LuckVal >= 568 andalso LuckVal =< 630 -> 100;
get_suc(9, LuckVal) when LuckVal >= 0 andalso LuckVal =< 320 -> 0;
get_suc(9, LuckVal) when LuckVal >= 321 andalso LuckVal =< 400 -> 0;
get_suc(9, LuckVal) when LuckVal >= 401 andalso LuckVal =< 480 -> 0;
get_suc(9, LuckVal) when LuckVal >= 481 andalso LuckVal =< 560 -> 1;
get_suc(9, LuckVal) when LuckVal >= 561 andalso LuckVal =< 640 -> 3;
get_suc(9, LuckVal) when LuckVal >= 641 andalso LuckVal =< 720 -> 100;
get_suc(9, LuckVal) when LuckVal >= 721 andalso LuckVal =< 800 -> 100;
get_suc(10, LuckVal) when LuckVal >= 0 andalso LuckVal =< 400 -> 0;
get_suc(10, LuckVal) when LuckVal >= 401 andalso LuckVal =< 500 -> 0;
get_suc(10, LuckVal) when LuckVal >= 501 andalso LuckVal =< 600 -> 0;
get_suc(10, LuckVal) when LuckVal >= 601 andalso LuckVal =< 700 -> 1;
get_suc(10, LuckVal) when LuckVal >= 701 andalso LuckVal =< 800 -> 3;
get_suc(10, LuckVal) when LuckVal >= 801 andalso LuckVal =< 900 -> 100;
get_suc(10, LuckVal) when LuckVal >= 901 andalso LuckVal =< 1000 -> 100;
get_suc(_Step, _LuckVal) -> 0. %% 非法 必不成功

%% 获取进阶最大幸运值
get_max_luck(1) -> 150;
get_max_luck(2) -> 200;
get_max_luck(3) -> 250;
get_max_luck(4) -> 320;
get_max_luck(5) -> 350;
get_max_luck(6) -> 400;
get_max_luck(7) -> 500;
get_max_luck(8) -> 630;
get_max_luck(9) -> 800;
get_max_luck(10) -> 1000;
get_max_luck(11) -> 1200;
get_max_luck(_Step) -> false.

%% 获取技能幸运刷新值
get_skill_luck(1, LuckVal) when LuckVal >= 0 andalso LuckVal =< 100 -> [100,0,0,0,0];
get_skill_luck(1, LuckVal) when LuckVal >= 101 andalso LuckVal =< 200 -> [97,3,0,0,0];
get_skill_luck(1, LuckVal) when LuckVal >= 201 andalso LuckVal =< 300 -> [95,5,0,0,0];
get_skill_luck(1, LuckVal) when LuckVal >= 301 andalso LuckVal =< 400 -> [89,10,1,0,0];
get_skill_luck(1, LuckVal) when LuckVal >= 401 andalso LuckVal =< 500 -> [75,20,5,0,0];
get_skill_luck(1, LuckVal) when LuckVal >= 501 andalso LuckVal =< 600 -> [40,50,10,0,0];
get_skill_luck(1, LuckVal) when LuckVal >= 601 andalso LuckVal =< 700 -> [25,60,15,0,0];
get_skill_luck(1, LuckVal) when LuckVal >= 701 andalso LuckVal =< 800 -> [20,60,20,0,0];
get_skill_luck(1, LuckVal) when LuckVal >= 801 andalso LuckVal =< 900 -> [20,55,25,0,0];
get_skill_luck(1, LuckVal) when LuckVal >= 901 andalso LuckVal =< 1000 -> [20,50,30,0,0];
get_skill_luck(2, LuckVal) when LuckVal >= 0 andalso LuckVal =< 100 -> [95,5,0,0,0];
get_skill_luck(2, LuckVal) when LuckVal >= 101 andalso LuckVal =< 200 -> [85,10,5,0,0];
get_skill_luck(2, LuckVal) when LuckVal >= 201 andalso LuckVal =< 300 -> [75,17,8,0,0];
get_skill_luck(2, LuckVal) when LuckVal >= 301 andalso LuckVal =< 400 -> [60,24,15,1,0];
get_skill_luck(2, LuckVal) when LuckVal >= 401 andalso LuckVal =< 500 -> [40,25,30,5,0];
get_skill_luck(2, LuckVal) when LuckVal >= 501 andalso LuckVal =< 600 -> [0,25,60,15,0];
get_skill_luck(2, LuckVal) when LuckVal >= 601 andalso LuckVal =< 700 -> [0,20,49,30,1];
get_skill_luck(2, LuckVal) when LuckVal >= 701 andalso LuckVal =< 800 -> [0,0,56,40,4];
get_skill_luck(2, LuckVal) when LuckVal >= 801 andalso LuckVal =< 900 -> [0,0,60,30,10];
get_skill_luck(2, LuckVal) when LuckVal >= 901 andalso LuckVal =< 1000 -> [0,0,50,35,15];
get_skill_luck(_Type, _LuckVal) -> [100]. %% 必出一阶技能

%% 获取技能刷新列表
get_skill_list() -> [
	{800,5},{801,10},{802,10},{803,10},{804,10},{805,10},{806,10},{807,10},{808,10},{809,5},{810,8},{811,10},{812,10},{813,10},{814,10},{815,10}
].
