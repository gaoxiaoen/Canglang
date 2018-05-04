-module(vip_lev).
-export([get/1]).



% vip等级	累计充值额度（晶钻）
% 0	100
% 1	500
% 2	1000
% 3	3000
% 4	8000
% 5	15000
% 6	25000
% 7	40000
% 8	80000
% 9	150000
% 10	200000

get_all_lev() ->
	[100,500,1000,3000,8000,15000,25000,40000,80000,150000,200000].

get(Value) ->
	F = fun(E,Nth)->
			case  Value >= E of 
				true -> Nth + 1;
				false -> Nth
			end
		end,
	Lev = lists:foldl(F,0,get_all_lev()),
	case Lev > 10 of 
		true -> 10;
		false -> Lev 
	end. 