%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pray_bag
	%%% @Created : 2016-02-01 21:00:48
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pray_bag).
-export([get/1]).
-include("common.hrl").
get(31) ->{50,250};
get(32) ->{50,500};
get(33) ->{50,750};
get(34) ->{50,1000};
get(35) ->{50,1250};
get(36) ->{50,1500};
get(37) ->{50,1750};
get(38) ->{50,2000};
get(39) ->{50,2250};
get(40) ->{50,2500};
get(41) ->{100,3000};
get(42) ->{100,3500};
get(43) ->{100,4000};
get(44) ->{100,4500};
get(45) ->{100,5000};
get(46) ->{100,5500};
get(47) ->{100,6000};
get(48) ->{100,6500};
get(49) ->{100,7000};
get(50) ->{100,7500};
get(51) ->{200,8500};
get(52) ->{200,9500};
get(53) ->{200,10500};
get(54) ->{200,11500};
get(55) ->{200,12500};
get(56) ->{200,13500};
get(57) ->{200,14500};
get(58) ->{200,15500};
get(59) ->{200,16500};
get(60) ->{200,17500};
get(_) -> throw({false,15}).