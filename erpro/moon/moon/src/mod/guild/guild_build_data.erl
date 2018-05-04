
-module(guild_build_data).
-export([get_wish/1, get_stove/1, get_shop/1]).


%% 许愿池配置
get_wish(1) -> {1,2000,1};
get_wish(2) -> {2,6000,2};
get_wish(3) -> {3,18000,4};
get_wish(4) -> {4,45000,6};
get_wish(5) -> {5,112500,8};
get_wish(6) -> {6,281250,10};
get_wish(7) -> {7,562500,12};
get_wish(8) -> {8,1125000,14};
get_wish(9) -> {9,2250000,16};
get_wish(10) -> {10,4500000,18};
get_wish(_Lvl) -> false.

%% 神炉配置
get_stove(1) -> {5,8000,2};
get_stove(2) -> {10,24000,4};
get_stove(3) -> {15,72000,6};
get_stove(4) -> {20,180000,8};
get_stove(5) -> {25,450000,10};
get_stove(6) -> {30,1125000,12};
get_stove(7) -> {35,2250000,14};
get_stove(8) -> {40,4500000,16};
get_stove(9) -> {45,9000000,18};
get_stove(10) -> {50,18000000,20};
get_stove(_Lvl) -> false.

%% 军团商城配置
get_shop(1) -> {2,7000,1};
get_shop(2) -> {4,21000,2};
get_shop(3) -> {6,63000,4};
get_shop(4) -> {8,157500,6};
get_shop(5) -> {10,393750,8};
get_shop(6) -> {10,984375,10};
get_shop(7) -> {10,1968750,12};
get_shop(8) -> {10,3937500,14};
get_shop(9) -> {10,7875000,16};
get_shop(10) -> {10,15750000,18};
get_shop(_Lvl) -> false.

