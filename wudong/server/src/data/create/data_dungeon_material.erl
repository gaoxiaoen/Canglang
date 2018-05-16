%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_material
	%%% @Created : 2017-11-28 18:13:49
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_material).
-export([ids/0]).
-export([get_subtype/1]).
-export([first_goods/2]).
-export([pass_goods/2]).
-export([drop_goods/2]).
-export([sweep_goods/2]).
-include("common.hrl").
-include("dungeon.hrl").

    ids() ->
    [50001,50002,50003,50004,50005,50006,50007,50008,50009,50010,50011,50012,50013,50014,50015].
get_subtype(50001) -> 1;
get_subtype(50002) -> 2;
get_subtype(50003) -> 3;
get_subtype(50004) -> 4;
get_subtype(50005) -> 5;
get_subtype(50006) -> 6;
get_subtype(50007) -> 7;
get_subtype(50008) -> 8;
get_subtype(50009) -> 9;
get_subtype(50010) -> 10;
get_subtype(50011) -> 11;
get_subtype(50012) -> 12;
get_subtype(50013) -> 13;
get_subtype(50014) -> 14;
get_subtype(50015) -> 15;
get_subtype(_) -> [].
first_goods(50001,Lv) when Lv>= 1 andalso Lv =< 999->{{3101000,3}};
first_goods(50002,Lv) when Lv>= 1 andalso Lv =< 999->{{3201000,3}};
first_goods(50003,Lv) when Lv>= 1 andalso Lv =< 999->{{3301000,3}};
first_goods(50004,Lv) when Lv>= 1 andalso Lv =< 999->{{3401000,3}};
first_goods(50005,Lv) when Lv>= 1 andalso Lv =< 60->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 61 andalso Lv =< 65->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 66 andalso Lv =< 68->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 69 andalso Lv =< 71->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 72 andalso Lv =< 74->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 75 andalso Lv =< 77->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 78 andalso Lv =< 79->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 80 andalso Lv =< 91->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 92 andalso Lv =< 112->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 113 andalso Lv =< 127->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 128 andalso Lv =< 142->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 143 andalso Lv =< 157->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 158 andalso Lv =< 172->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 173 andalso Lv =< 192->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 193 andalso Lv =< 212->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 213 andalso Lv =< 242->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 243 andalso Lv =< 272->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 273 andalso Lv =< 302->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 303 andalso Lv =< 332->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 333 andalso Lv =< 362->{{20340,6},{21001,1}};
first_goods(50005,Lv) when Lv>= 363 andalso Lv =< 382->{{20340,6},{21001,1}};
first_goods(50006,Lv) when Lv>= 1 andalso Lv =< 999->{{3501000,3}};
first_goods(50007,Lv) when Lv>= 1 andalso Lv =< 999->{{3601000,3}};
first_goods(50008,Lv) when Lv>= 1 andalso Lv =< 999->{{3701000,3}};
first_goods(50009,Lv) when Lv>= 1 andalso Lv =< 999->{{3801000,3}};
first_goods(50010,Lv) when Lv>= 1 andalso Lv =< 999->{{7302001,3}};
first_goods(50011,Lv) when Lv>= 1 andalso Lv =< 999->{{3901000,3}};
first_goods(50012,Lv) when Lv>= 1 andalso Lv =< 999->{{4001000,3}};
first_goods(50013,Lv) when Lv>= 1 andalso Lv =< 999->{{6001000,3}};
first_goods(50014,Lv) when Lv>= 1 andalso Lv =< 999->{{6201000,3}};
first_goods(50015,Lv) when Lv>= 1 andalso Lv =< 999->{{6301000,3}};
first_goods(_,_) -> [].
pass_goods(50001,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{3101000,1}};
pass_goods(50002,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{3201000,1}};
pass_goods(50003,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{3301000,1}};
pass_goods(50004,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{3401000,1}};
pass_goods(50005,Lv) when Lv>= 1 andalso Lv =< 60->{{10108,20000},{20340,3},{1010005,1}};
pass_goods(50005,Lv) when Lv>= 61 andalso Lv =< 65->{{10108,20000},{20340,3},{1010005,1}};
pass_goods(50005,Lv) when Lv>= 66 andalso Lv =< 68->{{10108,20000},{20340,3},{1010005,2}};
pass_goods(50005,Lv) when Lv>= 69 andalso Lv =< 71->{{10108,20000},{20340,3},{1010005,2}};
pass_goods(50005,Lv) when Lv>= 72 andalso Lv =< 74->{{10108,20000},{20340,3},{1010005,3}};
pass_goods(50005,Lv) when Lv>= 75 andalso Lv =< 77->{{10108,20000},{20340,3},{1010005,4}};
pass_goods(50005,Lv) when Lv>= 78 andalso Lv =< 79->{{10108,20000},{20340,3},{1010005,5}};
pass_goods(50005,Lv) when Lv>= 80 andalso Lv =< 91->{{10108,20000},{20340,3},{1010005,6}};
pass_goods(50005,Lv) when Lv>= 92 andalso Lv =< 112->{{10108,20000},{20340,3},{1010005,7}};
pass_goods(50005,Lv) when Lv>= 113 andalso Lv =< 127->{{10108,20000},{20340,3},{1010005,8}};
pass_goods(50005,Lv) when Lv>= 128 andalso Lv =< 142->{{10108,20000},{20340,3},{1010005,9}};
pass_goods(50005,Lv) when Lv>= 143 andalso Lv =< 157->{{10108,20000},{20340,3},{1010005,10}};
pass_goods(50005,Lv) when Lv>= 158 andalso Lv =< 172->{{10108,20000},{20340,3},{1010005,11}};
pass_goods(50005,Lv) when Lv>= 173 andalso Lv =< 192->{{10108,20000},{20340,3},{1010005,12}};
pass_goods(50005,Lv) when Lv>= 193 andalso Lv =< 212->{{10108,20000},{20340,3},{1010005,13}};
pass_goods(50005,Lv) when Lv>= 213 andalso Lv =< 242->{{10108,20000},{20340,3},{1010005,14}};
pass_goods(50005,Lv) when Lv>= 243 andalso Lv =< 272->{{10108,20000},{20340,3},{1010005,15}};
pass_goods(50005,Lv) when Lv>= 273 andalso Lv =< 302->{{10108,20000},{20340,3},{1010005,16}};
pass_goods(50005,Lv) when Lv>= 303 andalso Lv =< 332->{{10108,20000},{20340,3},{1010005,17}};
pass_goods(50005,Lv) when Lv>= 333 andalso Lv =< 362->{{10108,20000},{20340,3},{1010005,18}};
pass_goods(50005,Lv) when Lv>= 363 andalso Lv =< 382->{{10108,20000},{20340,3},{1010005,19}};
pass_goods(50006,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{3501000,1}};
pass_goods(50007,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{3601000,1}};
pass_goods(50008,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{3701000,1}};
pass_goods(50009,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{3801000,1}};
pass_goods(50010,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{7302001,1},{7301001,3}};
pass_goods(50011,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{3901000,1}};
pass_goods(50012,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{4001000,1}};
pass_goods(50013,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{6001000,1}};
pass_goods(50014,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{6201000,1}};
pass_goods(50015,Lv) when Lv>= 1 andalso Lv =< 999->{{10108,20000},{6301000,1}};
pass_goods(_,_) -> [].
drop_goods(50001,Lv) when Lv>= 1 andalso Lv =< 999->[{3104000,1,100},{3105000,1,100},{3106000,1,100},{0,1,300}];
drop_goods(50002,Lv) when Lv>= 1 andalso Lv =< 999->[{3204000,1,100},{3205000,1,100},{3206000,1,100},{0,1,300}];
drop_goods(50003,Lv) when Lv>= 1 andalso Lv =< 999->[{3304000,1,100},{3305000,1,100},{3306000,1,100},{0,1,300}];
drop_goods(50004,Lv) when Lv>= 1 andalso Lv =< 999->[{3404000,1,100},{3405000,1,100},{3406000,1,100},{0,1,300}];
drop_goods(50005,Lv) when Lv>= 1 andalso Lv =< 60->[{8001069,1,40},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 61 andalso Lv =< 65->[{8001069,1,40},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 66 andalso Lv =< 68->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 69 andalso Lv =< 71->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 72 andalso Lv =< 74->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 75 andalso Lv =< 77->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 78 andalso Lv =< 79->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 80 andalso Lv =< 91->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 92 andalso Lv =< 112->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 113 andalso Lv =< 127->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 128 andalso Lv =< 142->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 143 andalso Lv =< 157->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 158 andalso Lv =< 172->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 173 andalso Lv =< 192->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 193 andalso Lv =< 212->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 213 andalso Lv =< 242->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 243 andalso Lv =< 272->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 273 andalso Lv =< 302->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 303 andalso Lv =< 332->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 333 andalso Lv =< 362->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50005,Lv) when Lv>= 363 andalso Lv =< 382->[{8001069,1,39},{21001,1,1},{0,1,60}];
drop_goods(50006,Lv) when Lv>= 1 andalso Lv =< 999->[{3504000,1,100},{3505000,1,100},{3506000,1,100},{0,1,300}];
drop_goods(50007,Lv) when Lv>= 1 andalso Lv =< 999->[{3604000,1,100},{3605000,1,100},{3606000,1,100},{0,1,300}];
drop_goods(50008,Lv) when Lv>= 1 andalso Lv =< 999->[{3704000,1,100},{3705000,1,100},{3706000,1,100},{0,1,300}];
drop_goods(50009,Lv) when Lv>= 1 andalso Lv =< 999->[{3804000,1,100},{3805000,1,100},{3806000,1,100},{0,1,300}];
drop_goods(50010,Lv) when Lv>= 1 andalso Lv =< 999->[{7301001,3,280},{7321001,1,10},{7321002,1,10},{0,1,700}];
drop_goods(50011,Lv) when Lv>= 1 andalso Lv =< 999->[{3904000,1,100},{3905000,1,100},{3906000,1,100},{0,1,300}];
drop_goods(50012,Lv) when Lv>= 1 andalso Lv =< 999->[{4004000,1,100},{4005000,1,100},{4006000,1,100},{0,1,300}];
drop_goods(50013,Lv) when Lv>= 1 andalso Lv =< 999->[{6004000,1,100},{6005000,1,100},{6006000,1,100},{0,1,300}];
drop_goods(50014,Lv) when Lv>= 1 andalso Lv =< 999->[{6204000,1,100},{6205000,1,100},{6206000,1,100},{0,1,300}];
drop_goods(50015,Lv) when Lv>= 1 andalso Lv =< 999->[{6304000,1,100},{6305000,1,100},{6306000,1,100},{0,1,300}];
drop_goods(_,_) -> [].
sweep_goods(50001,Lv) when Lv>= 1 andalso Lv =< 999->[{3101000,2}];
sweep_goods(50002,Lv) when Lv>= 1 andalso Lv =< 999->[{3201000,2}];
sweep_goods(50003,Lv) when Lv>= 1 andalso Lv =< 999->[{3301000,2}];
sweep_goods(50004,Lv) when Lv>= 1 andalso Lv =< 999->[{3401000,2}];
sweep_goods(50005,Lv) when Lv>= 1 andalso Lv =< 60->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 61 andalso Lv =< 65->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 66 andalso Lv =< 68->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 69 andalso Lv =< 71->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 72 andalso Lv =< 74->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 75 andalso Lv =< 77->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 78 andalso Lv =< 79->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 80 andalso Lv =< 91->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 92 andalso Lv =< 112->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 113 andalso Lv =< 127->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 128 andalso Lv =< 142->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 143 andalso Lv =< 157->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 158 andalso Lv =< 172->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 173 andalso Lv =< 192->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 193 andalso Lv =< 212->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 213 andalso Lv =< 242->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 243 andalso Lv =< 272->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 273 andalso Lv =< 302->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 303 andalso Lv =< 332->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 333 andalso Lv =< 362->[{20340,2}];
sweep_goods(50005,Lv) when Lv>= 363 andalso Lv =< 382->[{20340,2}];
sweep_goods(50006,Lv) when Lv>= 1 andalso Lv =< 999->[{3501000,2}];
sweep_goods(50007,Lv) when Lv>= 1 andalso Lv =< 999->[{3601000,2}];
sweep_goods(50008,Lv) when Lv>= 1 andalso Lv =< 999->[{3701000,2}];
sweep_goods(50009,Lv) when Lv>= 1 andalso Lv =< 999->[{3801000,2}];
sweep_goods(50010,Lv) when Lv>= 1 andalso Lv =< 999->[{7302001,2}];
sweep_goods(50011,Lv) when Lv>= 1 andalso Lv =< 999->[{3901000,2}];
sweep_goods(50012,Lv) when Lv>= 1 andalso Lv =< 999->[{4001000,2}];
sweep_goods(50013,Lv) when Lv>= 1 andalso Lv =< 999->[{6001000,2}];
sweep_goods(50014,Lv) when Lv>= 1 andalso Lv =< 999->[{6201000,2}];
sweep_goods(50015,Lv) when Lv>= 1 andalso Lv =< 999->[{6301000,2}];
sweep_goods(_,_) -> [].
