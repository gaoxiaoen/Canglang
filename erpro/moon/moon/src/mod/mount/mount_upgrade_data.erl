%% **************************
%% 坐骑进阶相关数据
%% @author lishen(105326073@qq.com)
%% **************************
-module(mount_upgrade_data).
-export([
        upgrade_lev/1
        ,get_growth/1
        ,get_cost/1
        ,get_new_mount/1
        ,get_luck_rate/2
        ,get_luck_max/1
        ,get_refresh_addition/1
        ,get_refresh_cost/1
        ,quantity_name/1
        ,get_refresh_quality/2
    ]).
 
%% @doc 计算进阶等级
upgrade_lev(Grade) -> Grade * 3 + 12.

%% @spec get_growth(Grade) -> Growth.
%% @doc 获取该阶数的成长值
get_growth(0) -> 50 * 6;
get_growth(1) -> 70 * 6;
get_growth(2) -> 90 * 6;
get_growth(3) -> 125 * 6;
get_growth(4) -> 170 * 6;
get_growth(5) -> 220 * 6;
get_growth(6) -> 280 * 6;
get_growth(7) -> 350 * 6;
get_growth(8) -> 420 * 6;
get_growth(_) -> 0.

%% @doc 获取进阶消耗
get_cost(0) -> {32300, 2, 1000};
get_cost(1) -> {32300, 3, 2000};
get_cost(2) -> {32301, 3, 3000};
get_cost(3) -> {32301, 4, 5000};
get_cost(4) -> {32301, 6, 5000};
get_cost(5) -> {32301, 8, 5000};
get_cost(6) -> {32301, 10, 5000};
get_cost(7) -> {32301, 10, 5000};
get_cost(_) -> {32301, 10, 5000}.

%% @doc 进阶后获得的新外观
get_new_mount(1) -> 19010;
get_new_mount(2) -> 19011;
get_new_mount(3) -> 19012;
get_new_mount(4) -> 19013;
get_new_mount(5) -> 19014;
get_new_mount(6) -> 19060;
get_new_mount(7) -> 19061;
get_new_mount(8) -> 19062;
get_new_mount(_) -> none.

%% @doc 洗髓品质
get_refresh_quality(Grade, Per) when (Grade >= 0 andalso Grade =< 1) andalso (Per >= 1 andalso Per =< 60) -> 0;
get_refresh_quality(Grade, Per) when (Grade >= 0 andalso Grade =< 1) andalso (Per >= 61 andalso Per =< 95) -> 1;
get_refresh_quality(Grade, Per) when (Grade >= 0 andalso Grade =< 1) andalso (Per >= 96 andalso Per =< 100) -> 2;
get_refresh_quality(Grade, Per) when (Grade >= 2 andalso Grade =< 4) andalso (Per >= 1 andalso Per =< 46) -> 0;
get_refresh_quality(Grade, Per) when (Grade >= 2 andalso Grade =< 4) andalso (Per >= 47 andalso Per =< 83) -> 1;
get_refresh_quality(Grade, Per) when (Grade >= 2 andalso Grade =< 4) andalso (Per >= 84 andalso Per =< 98) -> 2;
get_refresh_quality(Grade, Per) when (Grade >= 2 andalso Grade =< 4) andalso (Per >= 99 andalso Per =< 100) -> 3;
get_refresh_quality(Grade, Per) when (Grade >= 5 andalso Grade =< 6) andalso (Per >= 1 andalso Per =< 38) -> 0;
get_refresh_quality(Grade, Per) when (Grade >= 5 andalso Grade =< 6) andalso (Per >= 39 andalso Per =< 76) -> 1;
get_refresh_quality(Grade, Per) when (Grade >= 5 andalso Grade =< 6) andalso (Per >= 77 andalso Per =< 94) -> 2;
get_refresh_quality(Grade, Per) when (Grade >= 5 andalso Grade =< 6) andalso (Per >= 95 andalso Per =< 99) -> 3;
get_refresh_quality(Grade, Per) when (Grade >= 5 andalso Grade =< 6) andalso Per =:= 100 -> 4;
get_refresh_quality(Grade, Per) when Grade =:= 7 andalso Per >= 1 andalso Per =< 28 -> 0;
get_refresh_quality(Grade, Per) when Grade =:= 7 andalso Per >= 29 andalso Per =< 64 -> 1;
get_refresh_quality(Grade, Per) when Grade =:= 7 andalso Per >= 65 andalso Per =< 92 -> 2;
get_refresh_quality(Grade, Per) when Grade =:= 7 andalso Per >= 93 andalso Per =< 99 -> 3;
get_refresh_quality(Grade, Per) when Grade =:= 7 andalso Per =:= 100 -> 4;
get_refresh_quality(Grade, Per) when Grade =:= 8 andalso Per >= 1 andalso Per =< 16 -> 0;
get_refresh_quality(Grade, Per) when Grade =:= 8 andalso Per >= 17 andalso Per =< 46 -> 1;
get_refresh_quality(Grade, Per) when Grade =:= 8 andalso Per >= 47 andalso Per =< 81 -> 2;
get_refresh_quality(Grade, Per) when Grade =:= 8 andalso Per >= 82 andalso Per =< 95 -> 3;
get_refresh_quality(Grade, Per) when Grade =:= 8 andalso Per >= 96 andalso Per =< 99 -> 4;
get_refresh_quality(Grade, Per) when Grade =:= 8 andalso Per =:= 100 -> util:rand(4, 5).

%% @doc 品质附加值
get_refresh_addition(0) -> 0;
get_refresh_addition(1) -> 3;
get_refresh_addition(2) -> 5;
get_refresh_addition(3) -> 8;
get_refresh_addition(4) -> 13;
get_refresh_addition(5) -> 20;
get_refresh_addition(_) -> 0.

%% @doc 品质名称
quantity_name(0) -> "普通";
quantity_name(1) -> "优秀";
quantity_name(2) -> "精良";
quantity_name(3) -> "完美";
quantity_name(4) -> "至尊";
quantity_name(5) -> "神级";
quantity_name(_) -> "".

%% @doc 洗髓消耗
get_refresh_cost(0) -> {32302, 1, 2000};
get_refresh_cost(1) -> {32302, 1, 2000};
get_refresh_cost(2) -> {32302, 1, 2000};
get_refresh_cost(3) -> {32303, 1, 2000};
get_refresh_cost(4) -> {32303, 1, 2000};
get_refresh_cost(5) -> {32303, 1, 2000};
get_refresh_cost(6) -> {32303, 1, 2000};
get_refresh_cost(7) -> {32303, 1, 2000};
get_refresh_cost(8) -> {32303, 1, 2000};
get_refresh_cost(_) -> {32303, 1, 2000}.

%% @doc 幸运值最大值
get_luck_max(0) -> 96;
get_luck_max(1) -> 144;
get_luck_max(2) -> 216;
get_luck_max(3) -> 360;
get_luck_max(4) -> 540;
get_luck_max(5) -> 960;
get_luck_max(6) -> 1320;
get_luck_max(7) -> 1920;
get_luck_max(_) -> 1920.

%% @doc 进阶幸运值区间
get_luck_rate(0, Luck) when Luck >= 0 andalso Luck =< 40 -> 0;
get_luck_rate(0, Luck) when Luck >= 41 andalso Luck =< 56 -> 1;
get_luck_rate(0, Luck) when Luck >= 57 andalso Luck =< 64 -> 10;
get_luck_rate(0, Luck) when Luck >= 65 -> 1000;
get_luck_rate(1, Luck) when Luck >= 0 andalso Luck =< 60 -> 0;
get_luck_rate(1, Luck) when Luck >= 61 andalso Luck =< 84 -> 1;
get_luck_rate(1, Luck) when Luck >= 85 andalso Luck =< 96 -> 10;
get_luck_rate(1, Luck) when Luck >= 97 -> 1000;
get_luck_rate(2, Luck) when Luck >= 0 andalso Luck =< 90 -> 0;
get_luck_rate(2, Luck) when Luck >= 91 andalso Luck =< 126 -> 1;
get_luck_rate(2, Luck) when Luck >= 127 andalso Luck =< 144 -> 10;
get_luck_rate(2, Luck) when Luck >= 145 andalso Luck =< 162 -> 50;
get_luck_rate(2, Luck) when Luck >= 163 -> 1000;
get_luck_rate(3, Luck) when Luck >= 0 andalso Luck =< 150 -> 0;
get_luck_rate(3, Luck) when Luck >= 151 andalso Luck =< 210 -> 1;
get_luck_rate(3, Luck) when Luck >= 211 andalso Luck =< 240 -> 10;
get_luck_rate(3, Luck) when Luck >= 241 andalso Luck =< 270 -> 50;
get_luck_rate(3, Luck) when Luck >= 271 andalso Luck =< 299 -> 80;
get_luck_rate(3, Luck) when Luck >= 300 -> 1000;
get_luck_rate(4, Luck) when Luck >= 0 andalso Luck =< 225 -> 0;
get_luck_rate(4, Luck) when Luck >= 226 andalso Luck =< 315 -> 1;
get_luck_rate(4, Luck) when Luck >= 316 andalso Luck =< 360 -> 10;
get_luck_rate(4, Luck) when Luck >= 361 andalso Luck =< 405 -> 10;
get_luck_rate(4, Luck) when Luck >= 406 andalso Luck =< 449 -> 80;
get_luck_rate(4, Luck) when Luck >= 450 -> 1000;
get_luck_rate(5, Luck) when Luck >= 0 andalso Luck =< 400 -> 0;
get_luck_rate(5, Luck) when Luck >= 401 andalso Luck =< 560 -> 0;
get_luck_rate(5, Luck) when Luck >= 561 andalso Luck =< 640 -> 1;
get_luck_rate(5, Luck) when Luck >= 641 andalso Luck =< 720 -> 10;
get_luck_rate(5, Luck) when Luck >= 721 andalso Luck =< 799 -> 50;
get_luck_rate(5, Luck) when Luck >= 800 -> 1000;
get_luck_rate(6, Luck) when Luck >= 0 andalso Luck =< 660 -> 0;
get_luck_rate(6, Luck) when Luck >= 661 andalso Luck =< 770 -> 0;
get_luck_rate(6, Luck) when Luck >= 771 andalso Luck =< 825 -> 0;
get_luck_rate(6, Luck) when Luck >= 826 andalso Luck =< 880 -> 1;
get_luck_rate(6, Luck) when Luck >= 881 andalso Luck =< 935 -> 10;
get_luck_rate(6, Luck) when Luck >= 936 andalso Luck =< 990 -> 10;
get_luck_rate(6, Luck) when Luck >= 991 andalso Luck =< 1045 -> 10;
get_luck_rate(6, Luck) when Luck >= 1046 andalso Luck =< 1099 -> 10;
get_luck_rate(6, Luck) when Luck >= 1100 -> 1000;
get_luck_rate(7, Luck) when Luck >= 0 andalso Luck =< 960 -> 0;
get_luck_rate(7, Luck) when Luck >= 961 andalso Luck =< 1120 -> 0;
get_luck_rate(7, Luck) when Luck >= 1121 andalso Luck =< 1200 -> 0;
get_luck_rate(7, Luck) when Luck >= 1201 andalso Luck =< 1280 -> 1;
get_luck_rate(7, Luck) when Luck >= 1281 andalso Luck =< 1360 -> 10;
get_luck_rate(7, Luck) when Luck >= 1361 andalso Luck =< 1440 -> 10;
get_luck_rate(7, Luck) when Luck >= 1441 andalso Luck =< 1520 -> 10;
get_luck_rate(7, Luck) when Luck >= 1521 andalso Luck =< 1599 -> 10;
get_luck_rate(7, Luck) when Luck >= 1600 -> 1000;
get_luck_rate(_, _) -> 0.
