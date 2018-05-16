%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_marry
	%%% @Created : 2017-11-16 16:43:45
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_marry).
-export([max_round/0]).
-export([get_mon/1]).
-export([get_revive/1]).
-export([get_k/1]).
-include("common.hrl").
-include("dungeon.hrl").
max_round() -> 10.
get_mon(1)->[{45108,30,84},{45108,30,82},{45108,30,83},{45108,30,85},{45108,30,86},{45108,30,87},{45108,31,80},{45108,31,81},{45108,31,82},{45108,31,83}];
get_mon(2)->[{45109,21,83},{45109,21,84},{45109,21,85},{45109,21,86},{45109,21,87},{45109,21,88},{45109,21,89},{45109,21,90},{45109,21,91},{45109,21,92}];
get_mon(3)->[{45110,14,88}];
get_mon(4)->[{45111,13,83},{45111,13,81},{45111,13,79},{45111,13,77},{45111,13,75},{45111,15,80},{45111,15,78},{45111,15,76},{45111,15,74},{45111,16,76}];
get_mon(5)->[{45112,14,62},{45112,14,64},{45112,13,57},{45112,14,57},{45112,15,57},{45112,16,57},{45112,13,59},{45112,14,59},{45112,15,59},{45112,16,59}];
get_mon(6)->[{45113,18,48}];
get_mon(7)->[{45114,20,54},{43020,21,56},{43020,22,57},{43020,23,58},{43020,15,53},{43020,16,54},{43020,17,55},{43020,18,57},{43020,19,58},{43020,20,50}];
get_mon(8)->[{45115,11,42},{45115,12,42},{45115,13,42},{45115,15,42},{45115,16,42},{45115,12,45},{45115,14,46},{45115,15,47},{45115,16,48},{45115,17,49}];
get_mon(9)->[{45116,15,30},{45116,16,31},{45116,17,32},{45116,18,33},{45116,19,34},{45116,20,35},{45116,14,31},{45116,15,32},{45116,16,33},{45116,17,34}];
get_mon(10)->[{45117,25,23}];
get_mon(_) -> [].
get_revive(1)->[38,79];
get_revive(2)->[38,79];
get_revive(3)->[38,79];
get_revive(4)->[38,79];
get_revive(5)->[38,79];
get_revive(6)->[38,79];
get_revive(7)->[38,79];
get_revive(8)->[38,79];
get_revive(9)->[38,79];
get_revive(10)->[38,79];
get_revive(_) -> [].
get_k(1)->{20, 2.85, 0.3};
get_k(2)->{20, 2.85, 0.3};
get_k(3)->{40, 2.85, 0.8};
get_k(4)->{20, 2.85, 0.3};
get_k(5)->{20, 2.85, 0.3};
get_k(6)->{50, 2.85, 0.9};
get_k(7)->{20, 2.85, 0.3};
get_k(8)->{20, 2.85, 0.3};
get_k(9)->{20, 2.85, 0.3};
get_k(10)->{70, 2.85, 1};
get_k(_) -> [].
