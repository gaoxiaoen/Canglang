%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_equip_star
	%%% @Created : 2016-09-13 15:11:02
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_equip_star).
-export([get/2]).
-include("equip.hrl").
get(1,0) -> 
	#base_equip_star{subtype = 1 ,star = 0 ,need_player_lv = 0 ,need_goods = [{28202,2}],need_coin = 200000 ,addition_percent = []};
get(1,1) -> 
	#base_equip_star{subtype = 1 ,star = 1 ,need_player_lv = 10 ,need_goods = [{28201,8}],need_coin = 400000 ,addition_percent = [{hp_lim,1607},{def,300}]};
get(1,2) -> 
	#base_equip_star{subtype = 1 ,star = 2 ,need_player_lv = 20 ,need_goods = [{28201,16}],need_coin = 800000 ,addition_percent = [{hp_lim,3214},{def,600}]};
get(1,3) -> 
	#base_equip_star{subtype = 1 ,star = 3 ,need_player_lv = 30 ,need_goods = [{28201,32}],need_coin = 1400000 ,addition_percent = [{hp_lim,4821},{def,900}]};
get(1,4) -> 
	#base_equip_star{subtype = 1 ,star = 4 ,need_player_lv = 40 ,need_goods = [{28201,64}],need_coin = 2800000 ,addition_percent = [{hp_lim,7232},{def,1200}]};
get(1,5) -> 
	#base_equip_star{subtype = 1 ,star = 5 ,need_player_lv = 50 ,need_goods = [],need_coin = 0 ,addition_percent = [{hp_lim,10848},{def,1800}]};
get(2,0) -> 
	#base_equip_star{subtype = 2 ,star = 0 ,need_player_lv = 0 ,need_goods = [{28200,3}],need_coin = 200000 ,addition_percent = []};
get(2,1) -> 
	#base_equip_star{subtype = 2 ,star = 1 ,need_player_lv = 10 ,need_goods = [{28200,6}],need_coin = 400000 ,addition_percent = [{att,150}]};
get(2,2) -> 
	#base_equip_star{subtype = 2 ,star = 2 ,need_player_lv = 20 ,need_goods = [{28200,12}],need_coin = 800000 ,addition_percent = [{att,300}]};
get(2,3) -> 
	#base_equip_star{subtype = 2 ,star = 3 ,need_player_lv = 30 ,need_goods = [{28200,24}],need_coin = 1400000 ,addition_percent = [{att,450}]};
get(2,4) -> 
	#base_equip_star{subtype = 2 ,star = 4 ,need_player_lv = 40 ,need_goods = [{28200,48}],need_coin = 2800000 ,addition_percent = [{att,600}]};
get(2,5) -> 
	#base_equip_star{subtype = 2 ,star = 5 ,need_player_lv = 50 ,need_goods = [],need_coin = 0 ,addition_percent = [{att,900}]};
get(3,0) -> 
	#base_equip_star{subtype = 3 ,star = 0 ,need_player_lv = 0 ,need_goods = [{28201,4}],need_coin = 200000 ,addition_percent = []};
get(3,1) -> 
	#base_equip_star{subtype = 3 ,star = 1 ,need_player_lv = 10 ,need_goods = [{28201,8}],need_coin = 400000 ,addition_percent = [{hp_lim,1607},{def,300}]};
get(3,2) -> 
	#base_equip_star{subtype = 3 ,star = 2 ,need_player_lv = 20 ,need_goods = [{28201,16}],need_coin = 800000 ,addition_percent = [{hp_lim,3214},{def,600}]};
get(3,3) -> 
	#base_equip_star{subtype = 3 ,star = 3 ,need_player_lv = 30 ,need_goods = [{28201,32}],need_coin = 1400000 ,addition_percent = [{hp_lim,4821},{def,900}]};
get(3,4) -> 
	#base_equip_star{subtype = 3 ,star = 4 ,need_player_lv = 40 ,need_goods = [{28201,64}],need_coin = 2800000 ,addition_percent = [{hp_lim,7232},{def,1200}]};
get(3,5) -> 
	#base_equip_star{subtype = 3 ,star = 5 ,need_player_lv = 50 ,need_goods = [],need_coin = 0 ,addition_percent = [{hp_lim,10848},{def,1800}]};
get(4,0) -> 
	#base_equip_star{subtype = 4 ,star = 0 ,need_player_lv = 0 ,need_goods = [{28201,4}],need_coin = 200000 ,addition_percent = []};
get(4,1) -> 
	#base_equip_star{subtype = 4 ,star = 1 ,need_player_lv = 10 ,need_goods = [{28201,8}],need_coin = 400000 ,addition_percent = [{hp_lim,1607},{def,300}]};
get(4,2) -> 
	#base_equip_star{subtype = 4 ,star = 2 ,need_player_lv = 20 ,need_goods = [{28201,16}],need_coin = 800000 ,addition_percent = [{hp_lim,3214},{def,600}]};
get(4,3) -> 
	#base_equip_star{subtype = 4 ,star = 3 ,need_player_lv = 30 ,need_goods = [{28201,32}],need_coin = 1400000 ,addition_percent = [{hp_lim,4821},{def,900}]};
get(4,4) -> 
	#base_equip_star{subtype = 4 ,star = 4 ,need_player_lv = 40 ,need_goods = [{28201,64}],need_coin = 2800000 ,addition_percent = [{hp_lim,7232},{def,1200}]};
get(4,5) -> 
	#base_equip_star{subtype = 4 ,star = 5 ,need_player_lv = 50 ,need_goods = [],need_coin = 0 ,addition_percent = [{hp_lim,10848},{def,1800}]};
get(5,0) -> 
	#base_equip_star{subtype = 5 ,star = 0 ,need_player_lv = 0 ,need_goods = [{28201,4}],need_coin = 200000 ,addition_percent = []};
get(5,1) -> 
	#base_equip_star{subtype = 5 ,star = 1 ,need_player_lv = 10 ,need_goods = [{28201,8}],need_coin = 400000 ,addition_percent = [{hp_lim,1607},{def,300}]};
get(5,2) -> 
	#base_equip_star{subtype = 5 ,star = 2 ,need_player_lv = 20 ,need_goods = [{28201,16}],need_coin = 800000 ,addition_percent = [{hp_lim,3214},{def,600}]};
get(5,3) -> 
	#base_equip_star{subtype = 5 ,star = 3 ,need_player_lv = 30 ,need_goods = [{28201,32}],need_coin = 1400000 ,addition_percent = [{hp_lim,4821},{def,900}]};
get(5,4) -> 
	#base_equip_star{subtype = 5 ,star = 4 ,need_player_lv = 40 ,need_goods = [{28201,64}],need_coin = 2800000 ,addition_percent = [{hp_lim,7232},{def,1200}]};
get(5,5) -> 
	#base_equip_star{subtype = 5 ,star = 5 ,need_player_lv = 50 ,need_goods = [],need_coin = 0 ,addition_percent = [{hp_lim,10848},{def,1800}]};
get(6,0) -> 
	#base_equip_star{subtype = 6 ,star = 0 ,need_player_lv = 0 ,need_goods = [{28201,4}],need_coin = 200000 ,addition_percent = []};
get(6,1) -> 
	#base_equip_star{subtype = 6 ,star = 1 ,need_player_lv = 10 ,need_goods = [{28201,8}],need_coin = 400000 ,addition_percent = [{hp_lim,1607},{def,300}]};
get(6,2) -> 
	#base_equip_star{subtype = 6 ,star = 2 ,need_player_lv = 20 ,need_goods = [{28201,16}],need_coin = 800000 ,addition_percent = [{hp_lim,3214},{def,600}]};
get(6,3) -> 
	#base_equip_star{subtype = 6 ,star = 3 ,need_player_lv = 30 ,need_goods = [{28201,32}],need_coin = 1400000 ,addition_percent = [{hp_lim,4821},{def,900}]};
get(6,4) -> 
	#base_equip_star{subtype = 6 ,star = 4 ,need_player_lv = 40 ,need_goods = [{28201,64}],need_coin = 2800000 ,addition_percent = [{hp_lim,7232},{def,1200}]};
get(6,5) -> 
	#base_equip_star{subtype = 6 ,star = 5 ,need_player_lv = 50 ,need_goods = [],need_coin = 0 ,addition_percent = [{hp_lim,10848},{def,1800}]};
get(7,0) -> 
	#base_equip_star{subtype = 7 ,star = 0 ,need_player_lv = 0 ,need_goods = [{28200,5}],need_coin = 200000 ,addition_percent = []};
get(7,1) -> 
	#base_equip_star{subtype = 7 ,star = 1 ,need_player_lv = 10 ,need_goods = [{28200,10}],need_coin = 400000 ,addition_percent = [{att,300}]};
get(7,2) -> 
	#base_equip_star{subtype = 7 ,star = 2 ,need_player_lv = 20 ,need_goods = [{28200,20}],need_coin = 800000 ,addition_percent = [{att,600}]};
get(7,3) -> 
	#base_equip_star{subtype = 7 ,star = 3 ,need_player_lv = 30 ,need_goods = [{28200,40}],need_coin = 1400000 ,addition_percent = [{att,900}]};
get(7,4) -> 
	#base_equip_star{subtype = 7 ,star = 4 ,need_player_lv = 40 ,need_goods = [{28200,80}],need_coin = 2800000 ,addition_percent = [{att,1200}]};
get(7,5) -> 
	#base_equip_star{subtype = 7 ,star = 5 ,need_player_lv = 50 ,need_goods = [],need_coin = 0 ,addition_percent = [{att,1800}]};
get(8,0) -> 
	#base_equip_star{subtype = 8 ,star = 0 ,need_player_lv = 0 ,need_goods = [{28200,2}],need_coin = 200000 ,addition_percent = []};
get(8,1) -> 
	#base_equip_star{subtype = 8 ,star = 1 ,need_player_lv = 10 ,need_goods = [{28200,4}],need_coin = 400000 ,addition_percent = [{att,150},{hp_lim,1607}]};
get(8,2) -> 
	#base_equip_star{subtype = 8 ,star = 2 ,need_player_lv = 20 ,need_goods = [{28200,8}],need_coin = 800000 ,addition_percent = [{att,300},{hp_lim,3214}]};
get(8,3) -> 
	#base_equip_star{subtype = 8 ,star = 3 ,need_player_lv = 30 ,need_goods = [{28200,16}],need_coin = 1400000 ,addition_percent = [{att,450},{hp_lim,4821}]};
get(8,4) -> 
	#base_equip_star{subtype = 8 ,star = 4 ,need_player_lv = 40 ,need_goods = [{28200,32}],need_coin = 2800000 ,addition_percent = [{att,600},{hp_lim,7232}]};
get(8,5) -> 
	#base_equip_star{subtype = 8 ,star = 5 ,need_player_lv = 50 ,need_goods = [],need_coin = 0 ,addition_percent = [{att,900},{hp_lim,10848}]};
get(130,0) -> 
	#base_equip_star{subtype = 130 ,star = 0 ,need_player_lv = 0 ,need_goods = [{28200,3}],need_coin = 200000 ,addition_percent = []};
get(130,1) -> 
	#base_equip_star{subtype = 130 ,star = 1 ,need_player_lv = 10 ,need_goods = [{28200,6}],need_coin = 400000 ,addition_percent = [{att,150}]};
get(130,2) -> 
	#base_equip_star{subtype = 130 ,star = 2 ,need_player_lv = 20 ,need_goods = [{28200,12}],need_coin = 800000 ,addition_percent = [{att,300}]};
get(130,3) -> 
	#base_equip_star{subtype = 130 ,star = 3 ,need_player_lv = 30 ,need_goods = [{28200,24}],need_coin = 1400000 ,addition_percent = [{att,450}]};
get(130,4) -> 
	#base_equip_star{subtype = 130 ,star = 4 ,need_player_lv = 40 ,need_goods = [{28200,48}],need_coin = 2800000 ,addition_percent = [{att,600}]};
get(130,5) -> 
	#base_equip_star{subtype = 130 ,star = 5 ,need_player_lv = 50 ,need_goods = [],need_coin = 0 ,addition_percent = [{att,900}]};
get(131,0) -> 
	#base_equip_star{subtype = 131 ,star = 0 ,need_player_lv = 0 ,need_goods = [{28201,4}],need_coin = 200000 ,addition_percent = []};
get(131,1) -> 
	#base_equip_star{subtype = 131 ,star = 1 ,need_player_lv = 10 ,need_goods = [{28201,8}],need_coin = 400000 ,addition_percent = [{hp_lim,1607},{def,300}]};
get(131,2) -> 
	#base_equip_star{subtype = 131 ,star = 2 ,need_player_lv = 20 ,need_goods = [{28201,16}],need_coin = 800000 ,addition_percent = [{hp_lim,3214},{def,600}]};
get(131,3) -> 
	#base_equip_star{subtype = 131 ,star = 3 ,need_player_lv = 30 ,need_goods = [{28201,32}],need_coin = 1400000 ,addition_percent = [{hp_lim,4821},{def,900}]};
get(131,4) -> 
	#base_equip_star{subtype = 131 ,star = 4 ,need_player_lv = 40 ,need_goods = [{28201,64}],need_coin = 2800000 ,addition_percent = [{hp_lim,7232},{def,1200}]};
get(131,5) -> 
	#base_equip_star{subtype = 131 ,star = 5 ,need_player_lv = 50 ,need_goods = [],need_coin = 0 ,addition_percent = [{hp_lim,10848},{def,1800}]};
get(_,_) -> [].
