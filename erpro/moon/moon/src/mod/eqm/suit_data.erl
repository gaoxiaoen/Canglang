
-module(suit_data).
-export([
        get_attr/2
       ,get_all/1
	   ,get_fashion_suit_attr/2
    ]
).

-include("item.hrl").
get_attr(_Id, Num) when Num < 2 -> [];
get_attr(120, Num) when Num >= 1 andalso Num < 4 ->
    [{15,572}];
get_attr(120, Num) when Num >= 4 andalso Num < 6 ->
    [{15,572}, {23,11}];
get_attr(120, Num) when Num =:= 6 ->
    [{15,572}, {23,11}, {25,11},{30,57}];
get_attr(130, Num) when Num >= 1 andalso Num < 4 ->
    [{15,1220}];
get_attr(130, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1220}, {23,24}];
get_attr(130, Num) when Num =:= 6 ->
    [{15,1220}, {23,24}, {25,24},{30,122}];
get_attr(140, Num) when Num >= 1 andalso Num < 4 ->
    [{15,1940}];
get_attr(140, Num) when Num >= 4 andalso Num < 6 ->
    [{15,1940}, {23,39}];
get_attr(140, Num) when Num =:= 6 ->
    [{15,1940}, {23,39}, {25,39},{30,194}];
get_attr(170, Num) when Num =:= 1 ->
    [{20,229}];
get_attr(170, Num) when Num =:= 2 ->
    [{20,229}, {22,9}];
get_attr(170, Num) when Num =:= 3 ->
    [{20,229}, {22,9}];
get_attr(180, Num) when Num =:= 1 ->
    [{20,488}];
get_attr(180, Num) when Num =:= 2 ->
    [{20,488}, {22,18}];
get_attr(180, Num) when Num =:= 3 ->
    [{20,488}, {22,18}];
get_attr(190, Num) when Num =:= 1 ->
    [{20,776}];
get_attr(190, Num) when Num =:= 2 ->
    [{20,776}, {22,29}];
get_attr(190, Num) when Num =:= 3 ->
    [{20,776}, {22,29}];

get_attr(_Id, _Num) -> [].

get_fashion_suit_attr(500, Num) when Num =:= 2 ->
	[{21,260}];
get_fashion_suit_attr(500, Num) when Num =:= 3 ->
	[{21,260}, {25,60}];
get_fashion_suit_attr(500, Num) when Num =:= 4 ->
	[{21,260},{25,60},{15,650},{20,244}];
get_fashion_suit_attr(510, Num) when Num =:= 2 ->
	[{21,260}];
get_fashion_suit_attr(510, Num) when Num =:= 3 ->
	[{21,260}, {25,60}];
get_fashion_suit_attr(510, Num) when Num =:= 4 ->
	[{21,260},{25,60},{15,650},{20,244}];
get_fashion_suit_attr(520, Num) when Num =:= 2 ->
	[{21,520}];
get_fashion_suit_attr(520, Num) when Num =:= 3 ->
	[{21,520}, {25,120}];
get_fashion_suit_attr(520, Num) when Num =:= 4 ->
	[{21,520},{25,120},{15,1300},{20,488}];
get_fashion_suit_attr(_Id, _Num) -> [].

get_all(Enchant) when Enchant >= 8 andalso Enchant < 13 ->
	[
		{?attr_rst_all,80},
		{?attr_dmg_magic,20},
		{?attr_tenacity,80}
	];
get_all(Enchant) when Enchant >= 13 andalso Enchant < 17 ->
	[
		{?attr_rst_all,200},
		{?attr_dmg_magic,50},
		{?attr_tenacity,200}
	];
get_all(Enchant) when Enchant >= 17 andalso Enchant < 18 ->
	[
		{?attr_rst_all,430},
		{?attr_dmg_magic,110},
		{?attr_tenacity,520}
	];
get_all(Enchant) when Enchant >= 18 andalso Enchant < 19 ->
	[
		{?attr_rst_all,910},
		{?attr_dmg_magic,230},
		{?attr_tenacity,1200},
		{?attr_rst_all_per,2},
		{?attr_dmg_magic_per,2},
		{?attr_critrate_per,2}
	];
get_all(Enchant) when Enchant >= 19 andalso Enchant < 20 ->
	[
		{?attr_rst_all,2120},
		{?attr_dmg_magic,510},
		{?attr_tenacity,2600},
		{?attr_rst_all_per,7},
		{?attr_dmg_magic_per,7},
		{?attr_critrate_per,7}
	];
get_all(Enchant)  when Enchant =:= 20 ->
	[
		{?attr_rst_all,800},
		{?attr_dmg_magic,150},
		{?attr_tenacity,1000},
		{?attr_rst_all_per,8},
		{?attr_dmg_magic_per,8},
		{?attr_critrate_per,8}
	];
get_all(_) -> [].


