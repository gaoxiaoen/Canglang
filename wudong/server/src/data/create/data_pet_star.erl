%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pet_star
	%%% @Created : 2018-05-09 14:50:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pet_star).
-export([get/1]).
-include("common.hrl").
-include("pet.hrl").
get(1) ->
	#base_pet_star{star = 1 ,exp = 40 ,attrs = [{att,100},{def,50},{hp_lim,1000},{crit,20},{ten,20},{dodge,20},{hit,20}],merge_exp = 5 };
get(2) ->
	#base_pet_star{star = 2 ,exp = 80 ,attrs = [{att,180},{def,90},{hp_lim,1800},{crit,36},{ten,36},{dodge,36},{hit,36}],merge_exp = 45 };
get(3) ->
	#base_pet_star{star = 3 ,exp = 160 ,attrs = [{att,320},{def,160},{hp_lim,3200},{crit,64},{ten,64},{dodge,64},{hit,64}],merge_exp = 125 };
get(4) ->
	#base_pet_star{star = 4 ,exp = 320 ,attrs = [{att,560},{def,280},{hp_lim,5600},{crit,112},{ten,112},{dodge,112},{hit,112}],merge_exp = 285 };
get(5) ->
	#base_pet_star{star = 5 ,exp = 640 ,attrs = [{att,980},{def,490},{hp_lim,9800},{crit,196},{ten,196},{dodge,196},{hit,196}],merge_exp = 605 };
get(6) ->
	#base_pet_star{star = 6 ,exp = 1280 ,attrs = [{att,1720},{def,860},{hp_lim,17200},{crit,344},{ten,344},{dodge,344},{hit,344}],merge_exp = 1245 };
get(7) ->
	#base_pet_star{star = 7 ,exp = 2560 ,attrs = [{att,3010},{def,1505},{hp_lim,30100},{crit,602},{ten,602},{dodge,602},{hit,602}],merge_exp = 2525 };
get(8) ->
	#base_pet_star{star = 8 ,exp = 5120 ,attrs = [{att,5270},{def,2635},{hp_lim,52700},{crit,1054},{ten,1054},{dodge,1054},{hit,1054}],merge_exp = 5085 };
get(9) ->
	#base_pet_star{star = 9 ,exp = 10240 ,attrs = [{att,9220},{def,4610},{hp_lim,92200},{crit,1844},{ten,1844},{dodge,1844},{hit,1844}],merge_exp = 10205 };
get(10) ->
	#base_pet_star{star = 10 ,exp = 94100 ,attrs = [{att,16140},{def,8070},{hp_lim,161400},{crit,3228},{ten,3228},{dodge,3228},{hit,3228}],merge_exp = 20445 };
get(11) ->
	#base_pet_star{star = 11 ,exp = 188205 ,attrs = [{att,27440},{def,13720},{hp_lim,274400},{crit,5488},{ten,5488},{dodge,5488},{hit,5488}],merge_exp = 114545 };
get(12) ->
	#base_pet_star{star = 12 ,exp = 376405 ,attrs = [{att,43900},{def,21950},{hp_lim,439000},{crit,8780},{ten,8780},{dodge,8780},{hit,8780}],merge_exp = 302750 };
get(13) ->
	#base_pet_star{star = 13 ,exp = 752810 ,attrs = [{att,65850},{def,32925},{hp_lim,658500},{crit,13170},{ten,13170},{dodge,13170},{hit,13170}],merge_exp = 679155 };
get(14) ->
	#base_pet_star{star = 14 ,exp = 1505620 ,attrs = [{att,92190},{def,46095},{hp_lim,921900},{crit,18438},{ten,18438},{dodge,18438},{hit,18438}],merge_exp = 1431965 };
get(15) ->
	#base_pet_star{star = 15 ,exp = 0 ,attrs = [{att,110630},{def,55315},{hp_lim,1106300},{crit,22126},{ten,22126},{dodge,22126},{hit,22126}],merge_exp = 2937585 };
get(_) -> [].

