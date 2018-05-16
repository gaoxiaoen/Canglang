%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pet_stage
	%%% @Created : 2018-05-09 14:50:42
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pet_stage).
-export([get/2]).
-export([get_max_lv/1]).
-include("server.hrl").
-include("pet.hrl").
get(1,0) ->
	#base_pet_stage{stage = 1 ,lv = 0 ,exp = 100 ,add_exp = 10 ,goods = {20340,1} ,attrs = [{att,100},{def,50},{hp_lim,1000},{crit,20},{ten,20},{hit,20},{dodge,20}]};
get(1,1) ->
	#base_pet_stage{stage = 1 ,lv = 1 ,exp = 100 ,add_exp = 10 ,goods = {20340,1} ,attrs = [{att,130},{def,65},{hp_lim,1300},{crit,26},{ten,26},{hit,26},{dodge,26}]};
get(1,2) ->
	#base_pet_stage{stage = 1 ,lv = 2 ,exp = 100 ,add_exp = 10 ,goods = {20340,1} ,attrs = [{att,160},{def,80},{hp_lim,1600},{crit,32},{ten,32},{hit,32},{dodge,32}]};
get(1,3) ->
	#base_pet_stage{stage = 1 ,lv = 3 ,exp = 100 ,add_exp = 10 ,goods = {20340,1} ,attrs = [{att,190},{def,95},{hp_lim,1900},{crit,38},{ten,38},{hit,38},{dodge,38}]};
get(1,4) ->
	#base_pet_stage{stage = 1 ,lv = 4 ,exp = 100 ,add_exp = 10 ,goods = {20340,1} ,attrs = [{att,220},{def,110},{hp_lim,2200},{crit,44},{ten,44},{hit,44},{dodge,44}]};
get(1,5) ->
	#base_pet_stage{stage = 1 ,lv = 5 ,exp = 100 ,add_exp = 10 ,goods = {20340,1} ,attrs = [{att,250},{def,125},{hp_lim,2500},{crit,50},{ten,50},{hit,50},{dodge,50}]};
get(1,6) ->
	#base_pet_stage{stage = 1 ,lv = 6 ,exp = 100 ,add_exp = 10 ,goods = {20340,1} ,attrs = [{att,280},{def,140},{hp_lim,2800},{crit,56},{ten,56},{hit,56},{dodge,56}]};
get(1,7) ->
	#base_pet_stage{stage = 1 ,lv = 7 ,exp = 100 ,add_exp = 10 ,goods = {20340,1} ,attrs = [{att,310},{def,155},{hp_lim,3100},{crit,62},{ten,62},{hit,62},{dodge,62}]};
get(1,8) ->
	#base_pet_stage{stage = 1 ,lv = 8 ,exp = 100 ,add_exp = 10 ,goods = {20340,1} ,attrs = [{att,340},{def,170},{hp_lim,3400},{crit,68},{ten,68},{hit,68},{dodge,68}]};
get(1,9) ->
	#base_pet_stage{stage = 1 ,lv = 9 ,exp = 150 ,add_exp = 10 ,goods = {20340,2} ,attrs = [{att,370},{def,185},{hp_lim,3700},{crit,74},{ten,74},{hit,74},{dodge,74}]};
get(2,0) ->
	#base_pet_stage{stage = 2 ,lv = 0 ,exp = 150 ,add_exp = 10 ,goods = {20340,2} ,attrs = [{att,430},{def,215},{hp_lim,4300},{crit,86},{ten,86},{hit,86},{dodge,86}]};
get(2,1) ->
	#base_pet_stage{stage = 2 ,lv = 1 ,exp = 150 ,add_exp = 10 ,goods = {20340,2} ,attrs = [{att,490},{def,245},{hp_lim,4900},{crit,98},{ten,98},{hit,98},{dodge,98}]};
get(2,2) ->
	#base_pet_stage{stage = 2 ,lv = 2 ,exp = 150 ,add_exp = 10 ,goods = {20340,2} ,attrs = [{att,550},{def,275},{hp_lim,5500},{crit,110},{ten,110},{hit,110},{dodge,110}]};
get(2,3) ->
	#base_pet_stage{stage = 2 ,lv = 3 ,exp = 150 ,add_exp = 10 ,goods = {20340,2} ,attrs = [{att,610},{def,305},{hp_lim,6100},{crit,122},{ten,122},{hit,122},{dodge,122}]};
get(2,4) ->
	#base_pet_stage{stage = 2 ,lv = 4 ,exp = 150 ,add_exp = 10 ,goods = {20340,2} ,attrs = [{att,670},{def,335},{hp_lim,6700},{crit,134},{ten,134},{hit,134},{dodge,134}]};
get(2,5) ->
	#base_pet_stage{stage = 2 ,lv = 5 ,exp = 150 ,add_exp = 10 ,goods = {20340,2} ,attrs = [{att,730},{def,365},{hp_lim,7300},{crit,146},{ten,146},{hit,146},{dodge,146}]};
get(2,6) ->
	#base_pet_stage{stage = 2 ,lv = 6 ,exp = 150 ,add_exp = 10 ,goods = {20340,2} ,attrs = [{att,790},{def,395},{hp_lim,7900},{crit,158},{ten,158},{hit,158},{dodge,158}]};
get(2,7) ->
	#base_pet_stage{stage = 2 ,lv = 7 ,exp = 150 ,add_exp = 10 ,goods = {20340,2} ,attrs = [{att,850},{def,425},{hp_lim,8500},{crit,170},{ten,170},{hit,170},{dodge,170}]};
get(2,8) ->
	#base_pet_stage{stage = 2 ,lv = 8 ,exp = 150 ,add_exp = 10 ,goods = {20340,2} ,attrs = [{att,910},{def,455},{hp_lim,9100},{crit,182},{ten,182},{hit,182},{dodge,182}]};
get(2,9) ->
	#base_pet_stage{stage = 2 ,lv = 9 ,exp = 200 ,add_exp = 10 ,goods = {20340,3} ,attrs = [{att,970},{def,485},{hp_lim,9700},{crit,194},{ten,194},{hit,194},{dodge,194}]};
get(3,0) ->
	#base_pet_stage{stage = 3 ,lv = 0 ,exp = 200 ,add_exp = 10 ,goods = {20340,3} ,attrs = [{att,1060},{def,530},{hp_lim,10600},{crit,212},{ten,212},{hit,212},{dodge,212}]};
get(3,1) ->
	#base_pet_stage{stage = 3 ,lv = 1 ,exp = 200 ,add_exp = 10 ,goods = {20340,3} ,attrs = [{att,1150},{def,575},{hp_lim,11500},{crit,230},{ten,230},{hit,230},{dodge,230}]};
get(3,2) ->
	#base_pet_stage{stage = 3 ,lv = 2 ,exp = 200 ,add_exp = 10 ,goods = {20340,3} ,attrs = [{att,1240},{def,620},{hp_lim,12400},{crit,248},{ten,248},{hit,248},{dodge,248}]};
get(3,3) ->
	#base_pet_stage{stage = 3 ,lv = 3 ,exp = 200 ,add_exp = 10 ,goods = {20340,3} ,attrs = [{att,1330},{def,665},{hp_lim,13300},{crit,266},{ten,266},{hit,266},{dodge,266}]};
get(3,4) ->
	#base_pet_stage{stage = 3 ,lv = 4 ,exp = 200 ,add_exp = 10 ,goods = {20340,3} ,attrs = [{att,1420},{def,710},{hp_lim,14200},{crit,284},{ten,284},{hit,284},{dodge,284}]};
get(3,5) ->
	#base_pet_stage{stage = 3 ,lv = 5 ,exp = 200 ,add_exp = 10 ,goods = {20340,3} ,attrs = [{att,1510},{def,755},{hp_lim,15100},{crit,302},{ten,302},{hit,302},{dodge,302}]};
get(3,6) ->
	#base_pet_stage{stage = 3 ,lv = 6 ,exp = 200 ,add_exp = 10 ,goods = {20340,3} ,attrs = [{att,1600},{def,800},{hp_lim,16000},{crit,320},{ten,320},{hit,320},{dodge,320}]};
get(3,7) ->
	#base_pet_stage{stage = 3 ,lv = 7 ,exp = 200 ,add_exp = 10 ,goods = {20340,3} ,attrs = [{att,1690},{def,845},{hp_lim,16900},{crit,338},{ten,338},{hit,338},{dodge,338}]};
get(3,8) ->
	#base_pet_stage{stage = 3 ,lv = 8 ,exp = 200 ,add_exp = 10 ,goods = {20340,3} ,attrs = [{att,1780},{def,890},{hp_lim,17800},{crit,356},{ten,356},{hit,356},{dodge,356}]};
get(3,9) ->
	#base_pet_stage{stage = 3 ,lv = 9 ,exp = 200 ,add_exp = 10 ,goods = {20340,4} ,attrs = [{att,1870},{def,935},{hp_lim,18700},{crit,374},{ten,374},{hit,374},{dodge,374}]};
get(4,0) ->
	#base_pet_stage{stage = 4 ,lv = 0 ,exp = 200 ,add_exp = 10 ,goods = {20340,4} ,attrs = [{att,1990},{def,995},{hp_lim,19900},{crit,398},{ten,398},{hit,398},{dodge,398}]};
get(4,1) ->
	#base_pet_stage{stage = 4 ,lv = 1 ,exp = 200 ,add_exp = 10 ,goods = {20340,4} ,attrs = [{att,2110},{def,1055},{hp_lim,21100},{crit,422},{ten,422},{hit,422},{dodge,422}]};
get(4,2) ->
	#base_pet_stage{stage = 4 ,lv = 2 ,exp = 200 ,add_exp = 10 ,goods = {20340,4} ,attrs = [{att,2230},{def,1115},{hp_lim,22300},{crit,446},{ten,446},{hit,446},{dodge,446}]};
get(4,3) ->
	#base_pet_stage{stage = 4 ,lv = 3 ,exp = 200 ,add_exp = 10 ,goods = {20340,4} ,attrs = [{att,2350},{def,1175},{hp_lim,23500},{crit,470},{ten,470},{hit,470},{dodge,470}]};
get(4,4) ->
	#base_pet_stage{stage = 4 ,lv = 4 ,exp = 200 ,add_exp = 10 ,goods = {20340,4} ,attrs = [{att,2470},{def,1235},{hp_lim,24700},{crit,494},{ten,494},{hit,494},{dodge,494}]};
get(4,5) ->
	#base_pet_stage{stage = 4 ,lv = 5 ,exp = 200 ,add_exp = 10 ,goods = {20340,4} ,attrs = [{att,2590},{def,1295},{hp_lim,25900},{crit,518},{ten,518},{hit,518},{dodge,518}]};
get(4,6) ->
	#base_pet_stage{stage = 4 ,lv = 6 ,exp = 200 ,add_exp = 10 ,goods = {20340,4} ,attrs = [{att,2710},{def,1355},{hp_lim,27100},{crit,542},{ten,542},{hit,542},{dodge,542}]};
get(4,7) ->
	#base_pet_stage{stage = 4 ,lv = 7 ,exp = 200 ,add_exp = 10 ,goods = {20340,4} ,attrs = [{att,2830},{def,1415},{hp_lim,28300},{crit,566},{ten,566},{hit,566},{dodge,566}]};
get(4,8) ->
	#base_pet_stage{stage = 4 ,lv = 8 ,exp = 200 ,add_exp = 10 ,goods = {20340,4} ,attrs = [{att,2950},{def,1475},{hp_lim,29500},{crit,590},{ten,590},{hit,590},{dodge,590}]};
get(4,9) ->
	#base_pet_stage{stage = 4 ,lv = 9 ,exp = 200 ,add_exp = 10 ,goods = {20340,5} ,attrs = [{att,3070},{def,1535},{hp_lim,30700},{crit,614},{ten,614},{hit,614},{dodge,614}]};
get(5,0) ->
	#base_pet_stage{stage = 5 ,lv = 0 ,exp = 200 ,add_exp = 10 ,goods = {20340,5} ,attrs = [{att,3220},{def,1610},{hp_lim,32200},{crit,644},{ten,644},{hit,644},{dodge,644}]};
get(5,1) ->
	#base_pet_stage{stage = 5 ,lv = 1 ,exp = 200 ,add_exp = 10 ,goods = {20340,5} ,attrs = [{att,3370},{def,1685},{hp_lim,33700},{crit,674},{ten,674},{hit,674},{dodge,674}]};
get(5,2) ->
	#base_pet_stage{stage = 5 ,lv = 2 ,exp = 200 ,add_exp = 10 ,goods = {20340,5} ,attrs = [{att,3520},{def,1760},{hp_lim,35200},{crit,704},{ten,704},{hit,704},{dodge,704}]};
get(5,3) ->
	#base_pet_stage{stage = 5 ,lv = 3 ,exp = 200 ,add_exp = 10 ,goods = {20340,5} ,attrs = [{att,3670},{def,1835},{hp_lim,36700},{crit,734},{ten,734},{hit,734},{dodge,734}]};
get(5,4) ->
	#base_pet_stage{stage = 5 ,lv = 4 ,exp = 200 ,add_exp = 10 ,goods = {20340,5} ,attrs = [{att,3820},{def,1910},{hp_lim,38200},{crit,764},{ten,764},{hit,764},{dodge,764}]};
get(5,5) ->
	#base_pet_stage{stage = 5 ,lv = 5 ,exp = 200 ,add_exp = 10 ,goods = {20340,5} ,attrs = [{att,3970},{def,1985},{hp_lim,39700},{crit,794},{ten,794},{hit,794},{dodge,794}]};
get(5,6) ->
	#base_pet_stage{stage = 5 ,lv = 6 ,exp = 200 ,add_exp = 10 ,goods = {20340,5} ,attrs = [{att,4120},{def,2060},{hp_lim,41200},{crit,824},{ten,824},{hit,824},{dodge,824}]};
get(5,7) ->
	#base_pet_stage{stage = 5 ,lv = 7 ,exp = 200 ,add_exp = 10 ,goods = {20340,5} ,attrs = [{att,4270},{def,2135},{hp_lim,42700},{crit,854},{ten,854},{hit,854},{dodge,854}]};
get(5,8) ->
	#base_pet_stage{stage = 5 ,lv = 8 ,exp = 200 ,add_exp = 10 ,goods = {20340,5} ,attrs = [{att,4420},{def,2210},{hp_lim,44200},{crit,884},{ten,884},{hit,884},{dodge,884}]};
get(5,9) ->
	#base_pet_stage{stage = 5 ,lv = 9 ,exp = 200 ,add_exp = 10 ,goods = {20340,6} ,attrs = [{att,4570},{def,2285},{hp_lim,45700},{crit,914},{ten,914},{hit,914},{dodge,914}]};
get(6,0) ->
	#base_pet_stage{stage = 6 ,lv = 0 ,exp = 200 ,add_exp = 10 ,goods = {20340,6} ,attrs = [{att,4750},{def,2375},{hp_lim,47500},{crit,950},{ten,950},{hit,950},{dodge,950}]};
get(6,1) ->
	#base_pet_stage{stage = 6 ,lv = 1 ,exp = 200 ,add_exp = 10 ,goods = {20340,6} ,attrs = [{att,4930},{def,2465},{hp_lim,49300},{crit,986},{ten,986},{hit,986},{dodge,986}]};
get(6,2) ->
	#base_pet_stage{stage = 6 ,lv = 2 ,exp = 200 ,add_exp = 10 ,goods = {20340,6} ,attrs = [{att,5110},{def,2555},{hp_lim,51100},{crit,1022},{ten,1022},{hit,1022},{dodge,1022}]};
get(6,3) ->
	#base_pet_stage{stage = 6 ,lv = 3 ,exp = 200 ,add_exp = 10 ,goods = {20340,6} ,attrs = [{att,5290},{def,2645},{hp_lim,52900},{crit,1058},{ten,1058},{hit,1058},{dodge,1058}]};
get(6,4) ->
	#base_pet_stage{stage = 6 ,lv = 4 ,exp = 200 ,add_exp = 10 ,goods = {20340,6} ,attrs = [{att,5470},{def,2735},{hp_lim,54700},{crit,1094},{ten,1094},{hit,1094},{dodge,1094}]};
get(6,5) ->
	#base_pet_stage{stage = 6 ,lv = 5 ,exp = 200 ,add_exp = 10 ,goods = {20340,6} ,attrs = [{att,5650},{def,2825},{hp_lim,56500},{crit,1130},{ten,1130},{hit,1130},{dodge,1130}]};
get(6,6) ->
	#base_pet_stage{stage = 6 ,lv = 6 ,exp = 200 ,add_exp = 10 ,goods = {20340,6} ,attrs = [{att,5830},{def,2915},{hp_lim,58300},{crit,1166},{ten,1166},{hit,1166},{dodge,1166}]};
get(6,7) ->
	#base_pet_stage{stage = 6 ,lv = 7 ,exp = 200 ,add_exp = 10 ,goods = {20340,6} ,attrs = [{att,6010},{def,3005},{hp_lim,60100},{crit,1202},{ten,1202},{hit,1202},{dodge,1202}]};
get(6,8) ->
	#base_pet_stage{stage = 6 ,lv = 8 ,exp = 200 ,add_exp = 10 ,goods = {20340,6} ,attrs = [{att,6190},{def,3095},{hp_lim,61900},{crit,1238},{ten,1238},{hit,1238},{dodge,1238}]};
get(6,9) ->
	#base_pet_stage{stage = 6 ,lv = 9 ,exp = 200 ,add_exp = 10 ,goods = {20340,7} ,attrs = [{att,6370},{def,3185},{hp_lim,63700},{crit,1274},{ten,1274},{hit,1274},{dodge,1274}]};
get(7,0) ->
	#base_pet_stage{stage = 7 ,lv = 0 ,exp = 200 ,add_exp = 10 ,goods = {20340,7} ,attrs = [{att,6580},{def,3290},{hp_lim,65800},{crit,1316},{ten,1316},{hit,1316},{dodge,1316}]};
get(7,1) ->
	#base_pet_stage{stage = 7 ,lv = 1 ,exp = 200 ,add_exp = 10 ,goods = {20340,7} ,attrs = [{att,6790},{def,3395},{hp_lim,67900},{crit,1358},{ten,1358},{hit,1358},{dodge,1358}]};
get(7,2) ->
	#base_pet_stage{stage = 7 ,lv = 2 ,exp = 200 ,add_exp = 10 ,goods = {20340,7} ,attrs = [{att,7000},{def,3500},{hp_lim,70000},{crit,1400},{ten,1400},{hit,1400},{dodge,1400}]};
get(7,3) ->
	#base_pet_stage{stage = 7 ,lv = 3 ,exp = 200 ,add_exp = 10 ,goods = {20340,7} ,attrs = [{att,7210},{def,3605},{hp_lim,72100},{crit,1442},{ten,1442},{hit,1442},{dodge,1442}]};
get(7,4) ->
	#base_pet_stage{stage = 7 ,lv = 4 ,exp = 200 ,add_exp = 10 ,goods = {20340,7} ,attrs = [{att,7420},{def,3710},{hp_lim,74200},{crit,1484},{ten,1484},{hit,1484},{dodge,1484}]};
get(7,5) ->
	#base_pet_stage{stage = 7 ,lv = 5 ,exp = 200 ,add_exp = 10 ,goods = {20340,7} ,attrs = [{att,7630},{def,3815},{hp_lim,76300},{crit,1526},{ten,1526},{hit,1526},{dodge,1526}]};
get(7,6) ->
	#base_pet_stage{stage = 7 ,lv = 6 ,exp = 200 ,add_exp = 10 ,goods = {20340,7} ,attrs = [{att,7840},{def,3920},{hp_lim,78400},{crit,1568},{ten,1568},{hit,1568},{dodge,1568}]};
get(7,7) ->
	#base_pet_stage{stage = 7 ,lv = 7 ,exp = 200 ,add_exp = 10 ,goods = {20340,7} ,attrs = [{att,8050},{def,4025},{hp_lim,80500},{crit,1610},{ten,1610},{hit,1610},{dodge,1610}]};
get(7,8) ->
	#base_pet_stage{stage = 7 ,lv = 8 ,exp = 200 ,add_exp = 10 ,goods = {20340,7} ,attrs = [{att,8260},{def,4130},{hp_lim,82600},{crit,1652},{ten,1652},{hit,1652},{dodge,1652}]};
get(7,9) ->
	#base_pet_stage{stage = 7 ,lv = 9 ,exp = 200 ,add_exp = 10 ,goods = {20340,8} ,attrs = [{att,8470},{def,4235},{hp_lim,84700},{crit,1694},{ten,1694},{hit,1694},{dodge,1694}]};
get(8,0) ->
	#base_pet_stage{stage = 8 ,lv = 0 ,exp = 200 ,add_exp = 10 ,goods = {20340,8} ,attrs = [{att,8710},{def,4355},{hp_lim,87100},{crit,1742},{ten,1742},{hit,1742},{dodge,1742}]};
get(8,1) ->
	#base_pet_stage{stage = 8 ,lv = 1 ,exp = 200 ,add_exp = 10 ,goods = {20340,8} ,attrs = [{att,8950},{def,4475},{hp_lim,89500},{crit,1790},{ten,1790},{hit,1790},{dodge,1790}]};
get(8,2) ->
	#base_pet_stage{stage = 8 ,lv = 2 ,exp = 200 ,add_exp = 10 ,goods = {20340,8} ,attrs = [{att,9190},{def,4595},{hp_lim,91900},{crit,1838},{ten,1838},{hit,1838},{dodge,1838}]};
get(8,3) ->
	#base_pet_stage{stage = 8 ,lv = 3 ,exp = 200 ,add_exp = 10 ,goods = {20340,8} ,attrs = [{att,9430},{def,4715},{hp_lim,94300},{crit,1886},{ten,1886},{hit,1886},{dodge,1886}]};
get(8,4) ->
	#base_pet_stage{stage = 8 ,lv = 4 ,exp = 200 ,add_exp = 10 ,goods = {20340,8} ,attrs = [{att,9670},{def,4835},{hp_lim,96700},{crit,1934},{ten,1934},{hit,1934},{dodge,1934}]};
get(8,5) ->
	#base_pet_stage{stage = 8 ,lv = 5 ,exp = 200 ,add_exp = 10 ,goods = {20340,8} ,attrs = [{att,9910},{def,4955},{hp_lim,99100},{crit,1982},{ten,1982},{hit,1982},{dodge,1982}]};
get(8,6) ->
	#base_pet_stage{stage = 8 ,lv = 6 ,exp = 200 ,add_exp = 10 ,goods = {20340,8} ,attrs = [{att,10150},{def,5075},{hp_lim,101500},{crit,2030},{ten,2030},{hit,2030},{dodge,2030}]};
get(8,7) ->
	#base_pet_stage{stage = 8 ,lv = 7 ,exp = 200 ,add_exp = 10 ,goods = {20340,8} ,attrs = [{att,10390},{def,5195},{hp_lim,103900},{crit,2078},{ten,2078},{hit,2078},{dodge,2078}]};
get(8,8) ->
	#base_pet_stage{stage = 8 ,lv = 8 ,exp = 200 ,add_exp = 10 ,goods = {20340,8} ,attrs = [{att,10630},{def,5315},{hp_lim,106300},{crit,2126},{ten,2126},{hit,2126},{dodge,2126}]};
get(8,9) ->
	#base_pet_stage{stage = 8 ,lv = 9 ,exp = 200 ,add_exp = 10 ,goods = {20340,9} ,attrs = [{att,10870},{def,5435},{hp_lim,108700},{crit,2174},{ten,2174},{hit,2174},{dodge,2174}]};
get(9,0) ->
	#base_pet_stage{stage = 9 ,lv = 0 ,exp = 200 ,add_exp = 10 ,goods = {20340,9} ,attrs = [{att,11140},{def,5570},{hp_lim,111400},{crit,2228},{ten,2228},{hit,2228},{dodge,2228}]};
get(9,1) ->
	#base_pet_stage{stage = 9 ,lv = 1 ,exp = 200 ,add_exp = 10 ,goods = {20340,9} ,attrs = [{att,11410},{def,5705},{hp_lim,114100},{crit,2282},{ten,2282},{hit,2282},{dodge,2282}]};
get(9,2) ->
	#base_pet_stage{stage = 9 ,lv = 2 ,exp = 200 ,add_exp = 10 ,goods = {20340,9} ,attrs = [{att,11680},{def,5840},{hp_lim,116800},{crit,2336},{ten,2336},{hit,2336},{dodge,2336}]};
get(9,3) ->
	#base_pet_stage{stage = 9 ,lv = 3 ,exp = 200 ,add_exp = 10 ,goods = {20340,9} ,attrs = [{att,11950},{def,5975},{hp_lim,119500},{crit,2390},{ten,2390},{hit,2390},{dodge,2390}]};
get(9,4) ->
	#base_pet_stage{stage = 9 ,lv = 4 ,exp = 200 ,add_exp = 10 ,goods = {20340,9} ,attrs = [{att,12220},{def,6110},{hp_lim,122200},{crit,2444},{ten,2444},{hit,2444},{dodge,2444}]};
get(9,5) ->
	#base_pet_stage{stage = 9 ,lv = 5 ,exp = 200 ,add_exp = 10 ,goods = {20340,9} ,attrs = [{att,12490},{def,6245},{hp_lim,124900},{crit,2498},{ten,2498},{hit,2498},{dodge,2498}]};
get(9,6) ->
	#base_pet_stage{stage = 9 ,lv = 6 ,exp = 200 ,add_exp = 10 ,goods = {20340,9} ,attrs = [{att,12760},{def,6380},{hp_lim,127600},{crit,2552},{ten,2552},{hit,2552},{dodge,2552}]};
get(9,7) ->
	#base_pet_stage{stage = 9 ,lv = 7 ,exp = 200 ,add_exp = 10 ,goods = {20340,9} ,attrs = [{att,13030},{def,6515},{hp_lim,130300},{crit,2606},{ten,2606},{hit,2606},{dodge,2606}]};
get(9,8) ->
	#base_pet_stage{stage = 9 ,lv = 8 ,exp = 200 ,add_exp = 10 ,goods = {20340,9} ,attrs = [{att,13300},{def,6650},{hp_lim,133000},{crit,2660},{ten,2660},{hit,2660},{dodge,2660}]};
get(9,9) ->
	#base_pet_stage{stage = 9 ,lv = 9 ,exp = 200 ,add_exp = 10 ,goods = {20340,10} ,attrs = [{att,13570},{def,6785},{hp_lim,135700},{crit,2714},{ten,2714},{hit,2714},{dodge,2714}]};
get(10,0) ->
	#base_pet_stage{stage = 10 ,lv = 0 ,exp = 200 ,add_exp = 10 ,goods = {20340,10} ,attrs = [{att,13870},{def,6935},{hp_lim,138700},{crit,2774},{ten,2774},{hit,2774},{dodge,2774}]};
get(10,1) ->
	#base_pet_stage{stage = 10 ,lv = 1 ,exp = 200 ,add_exp = 10 ,goods = {20340,10} ,attrs = [{att,14170},{def,7085},{hp_lim,141700},{crit,2834},{ten,2834},{hit,2834},{dodge,2834}]};
get(10,2) ->
	#base_pet_stage{stage = 10 ,lv = 2 ,exp = 200 ,add_exp = 10 ,goods = {20340,10} ,attrs = [{att,14470},{def,7235},{hp_lim,144700},{crit,2894},{ten,2894},{hit,2894},{dodge,2894}]};
get(10,3) ->
	#base_pet_stage{stage = 10 ,lv = 3 ,exp = 200 ,add_exp = 10 ,goods = {20340,10} ,attrs = [{att,14770},{def,7385},{hp_lim,147700},{crit,2954},{ten,2954},{hit,2954},{dodge,2954}]};
get(10,4) ->
	#base_pet_stage{stage = 10 ,lv = 4 ,exp = 200 ,add_exp = 10 ,goods = {20340,10} ,attrs = [{att,15070},{def,7535},{hp_lim,150700},{crit,3014},{ten,3014},{hit,3014},{dodge,3014}]};
get(10,5) ->
	#base_pet_stage{stage = 10 ,lv = 5 ,exp = 200 ,add_exp = 10 ,goods = {20340,10} ,attrs = [{att,15370},{def,7685},{hp_lim,153700},{crit,3074},{ten,3074},{hit,3074},{dodge,3074}]};
get(10,6) ->
	#base_pet_stage{stage = 10 ,lv = 6 ,exp = 200 ,add_exp = 10 ,goods = {20340,10} ,attrs = [{att,15670},{def,7835},{hp_lim,156700},{crit,3134},{ten,3134},{hit,3134},{dodge,3134}]};
get(10,7) ->
	#base_pet_stage{stage = 10 ,lv = 7 ,exp = 200 ,add_exp = 10 ,goods = {20340,10} ,attrs = [{att,15970},{def,7985},{hp_lim,159700},{crit,3194},{ten,3194},{hit,3194},{dodge,3194}]};
get(10,8) ->
	#base_pet_stage{stage = 10 ,lv = 8 ,exp = 200 ,add_exp = 10 ,goods = {20340,10} ,attrs = [{att,16270},{def,8135},{hp_lim,162700},{crit,3254},{ten,3254},{hit,3254},{dodge,3254}]};
get(10,9) ->
	#base_pet_stage{stage = 10 ,lv = 9 ,exp = 200 ,add_exp = 10 ,goods = {20340,10} ,attrs = [{att,16570},{def,8285},{hp_lim,165700},{crit,3314},{ten,3314},{hit,3314},{dodge,3314}]};
get(11,0) ->
	#base_pet_stage{stage = 11 ,lv = 0 ,exp = 220 ,add_exp = 10 ,goods = {20340,11} ,attrs = [{att,16900},{def,8450},{hp_lim,169000},{crit,3380},{ten,3380},{hit,3380},{dodge,3380}]};
get(11,1) ->
	#base_pet_stage{stage = 11 ,lv = 1 ,exp = 220 ,add_exp = 10 ,goods = {20340,11} ,attrs = [{att,17230},{def,8615},{hp_lim,172300},{crit,3446},{ten,3446},{hit,3446},{dodge,3446}]};
get(11,2) ->
	#base_pet_stage{stage = 11 ,lv = 2 ,exp = 220 ,add_exp = 10 ,goods = {20340,11} ,attrs = [{att,17560},{def,8780},{hp_lim,175600},{crit,3512},{ten,3512},{hit,3512},{dodge,3512}]};
get(11,3) ->
	#base_pet_stage{stage = 11 ,lv = 3 ,exp = 220 ,add_exp = 10 ,goods = {20340,11} ,attrs = [{att,17890},{def,8945},{hp_lim,178900},{crit,3578},{ten,3578},{hit,3578},{dodge,3578}]};
get(11,4) ->
	#base_pet_stage{stage = 11 ,lv = 4 ,exp = 220 ,add_exp = 10 ,goods = {20340,11} ,attrs = [{att,18220},{def,9110},{hp_lim,182200},{crit,3644},{ten,3644},{hit,3644},{dodge,3644}]};
get(11,5) ->
	#base_pet_stage{stage = 11 ,lv = 5 ,exp = 220 ,add_exp = 10 ,goods = {20340,11} ,attrs = [{att,18550},{def,9275},{hp_lim,185500},{crit,3710},{ten,3710},{hit,3710},{dodge,3710}]};
get(11,6) ->
	#base_pet_stage{stage = 11 ,lv = 6 ,exp = 220 ,add_exp = 10 ,goods = {20340,11} ,attrs = [{att,18880},{def,9440},{hp_lim,188800},{crit,3776},{ten,3776},{hit,3776},{dodge,3776}]};
get(11,7) ->
	#base_pet_stage{stage = 11 ,lv = 7 ,exp = 220 ,add_exp = 10 ,goods = {20340,11} ,attrs = [{att,19210},{def,9605},{hp_lim,192100},{crit,3842},{ten,3842},{hit,3842},{dodge,3842}]};
get(11,8) ->
	#base_pet_stage{stage = 11 ,lv = 8 ,exp = 220 ,add_exp = 10 ,goods = {20340,11} ,attrs = [{att,19540},{def,9770},{hp_lim,195400},{crit,3908},{ten,3908},{hit,3908},{dodge,3908}]};
get(11,9) ->
	#base_pet_stage{stage = 11 ,lv = 9 ,exp = 220 ,add_exp = 10 ,goods = {20340,11} ,attrs = [{att,19870},{def,9935},{hp_lim,198700},{crit,3974},{ten,3974},{hit,3974},{dodge,3974}]};
get(12,0) ->
	#base_pet_stage{stage = 12 ,lv = 0 ,exp = 240 ,add_exp = 10 ,goods = {20340,12} ,attrs = [{att,20230},{def,10115},{hp_lim,202300},{crit,4046},{ten,4046},{hit,4046},{dodge,4046}]};
get(12,1) ->
	#base_pet_stage{stage = 12 ,lv = 1 ,exp = 240 ,add_exp = 10 ,goods = {20340,12} ,attrs = [{att,20590},{def,10295},{hp_lim,205900},{crit,4118},{ten,4118},{hit,4118},{dodge,4118}]};
get(12,2) ->
	#base_pet_stage{stage = 12 ,lv = 2 ,exp = 240 ,add_exp = 10 ,goods = {20340,12} ,attrs = [{att,20950},{def,10475},{hp_lim,209500},{crit,4190},{ten,4190},{hit,4190},{dodge,4190}]};
get(12,3) ->
	#base_pet_stage{stage = 12 ,lv = 3 ,exp = 240 ,add_exp = 10 ,goods = {20340,12} ,attrs = [{att,21310},{def,10655},{hp_lim,213100},{crit,4262},{ten,4262},{hit,4262},{dodge,4262}]};
get(12,4) ->
	#base_pet_stage{stage = 12 ,lv = 4 ,exp = 240 ,add_exp = 10 ,goods = {20340,12} ,attrs = [{att,21670},{def,10835},{hp_lim,216700},{crit,4334},{ten,4334},{hit,4334},{dodge,4334}]};
get(12,5) ->
	#base_pet_stage{stage = 12 ,lv = 5 ,exp = 240 ,add_exp = 10 ,goods = {20340,12} ,attrs = [{att,22030},{def,11015},{hp_lim,220300},{crit,4406},{ten,4406},{hit,4406},{dodge,4406}]};
get(12,6) ->
	#base_pet_stage{stage = 12 ,lv = 6 ,exp = 240 ,add_exp = 10 ,goods = {20340,12} ,attrs = [{att,22390},{def,11195},{hp_lim,223900},{crit,4478},{ten,4478},{hit,4478},{dodge,4478}]};
get(12,7) ->
	#base_pet_stage{stage = 12 ,lv = 7 ,exp = 240 ,add_exp = 10 ,goods = {20340,12} ,attrs = [{att,22750},{def,11375},{hp_lim,227500},{crit,4550},{ten,4550},{hit,4550},{dodge,4550}]};
get(12,8) ->
	#base_pet_stage{stage = 12 ,lv = 8 ,exp = 240 ,add_exp = 10 ,goods = {20340,12} ,attrs = [{att,23110},{def,11555},{hp_lim,231100},{crit,4622},{ten,4622},{hit,4622},{dodge,4622}]};
get(12,9) ->
	#base_pet_stage{stage = 12 ,lv = 9 ,exp = 240 ,add_exp = 10 ,goods = {20340,12} ,attrs = [{att,23470},{def,11735},{hp_lim,234700},{crit,4694},{ten,4694},{hit,4694},{dodge,4694}]};
get(13,0) ->
	#base_pet_stage{stage = 13 ,lv = 0 ,exp = 260 ,add_exp = 10 ,goods = {20340,13} ,attrs = [{att,23860},{def,11930},{hp_lim,238600},{crit,4772},{ten,4772},{hit,4772},{dodge,4772}]};
get(13,1) ->
	#base_pet_stage{stage = 13 ,lv = 1 ,exp = 260 ,add_exp = 10 ,goods = {20340,13} ,attrs = [{att,24250},{def,12125},{hp_lim,242500},{crit,4850},{ten,4850},{hit,4850},{dodge,4850}]};
get(13,2) ->
	#base_pet_stage{stage = 13 ,lv = 2 ,exp = 260 ,add_exp = 10 ,goods = {20340,13} ,attrs = [{att,24640},{def,12320},{hp_lim,246400},{crit,4928},{ten,4928},{hit,4928},{dodge,4928}]};
get(13,3) ->
	#base_pet_stage{stage = 13 ,lv = 3 ,exp = 260 ,add_exp = 10 ,goods = {20340,13} ,attrs = [{att,25030},{def,12515},{hp_lim,250300},{crit,5006},{ten,5006},{hit,5006},{dodge,5006}]};
get(13,4) ->
	#base_pet_stage{stage = 13 ,lv = 4 ,exp = 260 ,add_exp = 10 ,goods = {20340,13} ,attrs = [{att,25420},{def,12710},{hp_lim,254200},{crit,5084},{ten,5084},{hit,5084},{dodge,5084}]};
get(13,5) ->
	#base_pet_stage{stage = 13 ,lv = 5 ,exp = 260 ,add_exp = 10 ,goods = {20340,13} ,attrs = [{att,25810},{def,12905},{hp_lim,258100},{crit,5162},{ten,5162},{hit,5162},{dodge,5162}]};
get(13,6) ->
	#base_pet_stage{stage = 13 ,lv = 6 ,exp = 260 ,add_exp = 10 ,goods = {20340,13} ,attrs = [{att,26200},{def,13100},{hp_lim,262000},{crit,5240},{ten,5240},{hit,5240},{dodge,5240}]};
get(13,7) ->
	#base_pet_stage{stage = 13 ,lv = 7 ,exp = 260 ,add_exp = 10 ,goods = {20340,13} ,attrs = [{att,26590},{def,13295},{hp_lim,265900},{crit,5318},{ten,5318},{hit,5318},{dodge,5318}]};
get(13,8) ->
	#base_pet_stage{stage = 13 ,lv = 8 ,exp = 260 ,add_exp = 10 ,goods = {20340,13} ,attrs = [{att,26980},{def,13490},{hp_lim,269800},{crit,5396},{ten,5396},{hit,5396},{dodge,5396}]};
get(13,9) ->
	#base_pet_stage{stage = 13 ,lv = 9 ,exp = 260 ,add_exp = 10 ,goods = {20340,13} ,attrs = [{att,27370},{def,13685},{hp_lim,273700},{crit,5474},{ten,5474},{hit,5474},{dodge,5474}]};
get(14,0) ->
	#base_pet_stage{stage = 14 ,lv = 0 ,exp = 280 ,add_exp = 10 ,goods = {20340,14} ,attrs = [{att,27790},{def,13895},{hp_lim,277900},{crit,5558},{ten,5558},{hit,5558},{dodge,5558}]};
get(14,1) ->
	#base_pet_stage{stage = 14 ,lv = 1 ,exp = 280 ,add_exp = 10 ,goods = {20340,14} ,attrs = [{att,28210},{def,14105},{hp_lim,282100},{crit,5642},{ten,5642},{hit,5642},{dodge,5642}]};
get(14,2) ->
	#base_pet_stage{stage = 14 ,lv = 2 ,exp = 280 ,add_exp = 10 ,goods = {20340,14} ,attrs = [{att,28630},{def,14315},{hp_lim,286300},{crit,5726},{ten,5726},{hit,5726},{dodge,5726}]};
get(14,3) ->
	#base_pet_stage{stage = 14 ,lv = 3 ,exp = 280 ,add_exp = 10 ,goods = {20340,14} ,attrs = [{att,29050},{def,14525},{hp_lim,290500},{crit,5810},{ten,5810},{hit,5810},{dodge,5810}]};
get(14,4) ->
	#base_pet_stage{stage = 14 ,lv = 4 ,exp = 280 ,add_exp = 10 ,goods = {20340,14} ,attrs = [{att,29470},{def,14735},{hp_lim,294700},{crit,5894},{ten,5894},{hit,5894},{dodge,5894}]};
get(14,5) ->
	#base_pet_stage{stage = 14 ,lv = 5 ,exp = 280 ,add_exp = 10 ,goods = {20340,14} ,attrs = [{att,29890},{def,14945},{hp_lim,298900},{crit,5978},{ten,5978},{hit,5978},{dodge,5978}]};
get(14,6) ->
	#base_pet_stage{stage = 14 ,lv = 6 ,exp = 280 ,add_exp = 10 ,goods = {20340,14} ,attrs = [{att,30310},{def,15155},{hp_lim,303100},{crit,6062},{ten,6062},{hit,6062},{dodge,6062}]};
get(14,7) ->
	#base_pet_stage{stage = 14 ,lv = 7 ,exp = 280 ,add_exp = 10 ,goods = {20340,14} ,attrs = [{att,30730},{def,15365},{hp_lim,307300},{crit,6146},{ten,6146},{hit,6146},{dodge,6146}]};
get(14,8) ->
	#base_pet_stage{stage = 14 ,lv = 8 ,exp = 280 ,add_exp = 10 ,goods = {20340,14} ,attrs = [{att,31150},{def,15575},{hp_lim,311500},{crit,6230},{ten,6230},{hit,6230},{dodge,6230}]};
get(14,9) ->
	#base_pet_stage{stage = 14 ,lv = 9 ,exp = 280 ,add_exp = 10 ,goods = {20340,14} ,attrs = [{att,31570},{def,15785},{hp_lim,315700},{crit,6314},{ten,6314},{hit,6314},{dodge,6314}]};
get(15,0) ->
	#base_pet_stage{stage = 15 ,lv = 0 ,exp = 300 ,add_exp = 10 ,goods = {20340,15} ,attrs = [{att,32020},{def,16010},{hp_lim,320200},{crit,6404},{ten,6404},{hit,6404},{dodge,6404}]};
get(15,1) ->
	#base_pet_stage{stage = 15 ,lv = 1 ,exp = 300 ,add_exp = 10 ,goods = {20340,15} ,attrs = [{att,32470},{def,16235},{hp_lim,324700},{crit,6494},{ten,6494},{hit,6494},{dodge,6494}]};
get(15,2) ->
	#base_pet_stage{stage = 15 ,lv = 2 ,exp = 300 ,add_exp = 10 ,goods = {20340,15} ,attrs = [{att,32920},{def,16460},{hp_lim,329200},{crit,6584},{ten,6584},{hit,6584},{dodge,6584}]};
get(15,3) ->
	#base_pet_stage{stage = 15 ,lv = 3 ,exp = 300 ,add_exp = 10 ,goods = {20340,15} ,attrs = [{att,33370},{def,16685},{hp_lim,333700},{crit,6674},{ten,6674},{hit,6674},{dodge,6674}]};
get(15,4) ->
	#base_pet_stage{stage = 15 ,lv = 4 ,exp = 300 ,add_exp = 10 ,goods = {20340,15} ,attrs = [{att,33820},{def,16910},{hp_lim,338200},{crit,6764},{ten,6764},{hit,6764},{dodge,6764}]};
get(15,5) ->
	#base_pet_stage{stage = 15 ,lv = 5 ,exp = 300 ,add_exp = 10 ,goods = {20340,15} ,attrs = [{att,34270},{def,17135},{hp_lim,342700},{crit,6854},{ten,6854},{hit,6854},{dodge,6854}]};
get(15,6) ->
	#base_pet_stage{stage = 15 ,lv = 6 ,exp = 300 ,add_exp = 10 ,goods = {20340,15} ,attrs = [{att,34720},{def,17360},{hp_lim,347200},{crit,6944},{ten,6944},{hit,6944},{dodge,6944}]};
get(15,7) ->
	#base_pet_stage{stage = 15 ,lv = 7 ,exp = 300 ,add_exp = 10 ,goods = {20340,15} ,attrs = [{att,35170},{def,17585},{hp_lim,351700},{crit,7034},{ten,7034},{hit,7034},{dodge,7034}]};
get(15,8) ->
	#base_pet_stage{stage = 15 ,lv = 8 ,exp = 300 ,add_exp = 10 ,goods = {20340,15} ,attrs = [{att,35620},{def,17810},{hp_lim,356200},{crit,7124},{ten,7124},{hit,7124},{dodge,7124}]};
get(15,9) ->
	#base_pet_stage{stage = 15 ,lv = 9 ,exp = 300 ,add_exp = 10 ,goods = {20340,15} ,attrs = [{att,36070},{def,18035},{hp_lim,360700},{crit,7214},{ten,7214},{hit,7214},{dodge,7214}]};
get(16,0) ->
	#base_pet_stage{stage = 16 ,lv = 0 ,exp = 320 ,add_exp = 10 ,goods = {20340,16} ,attrs = [{att,36550},{def,18275},{hp_lim,365500},{crit,7310},{ten,7310},{hit,7310},{dodge,7310}]};
get(16,1) ->
	#base_pet_stage{stage = 16 ,lv = 1 ,exp = 320 ,add_exp = 10 ,goods = {20340,16} ,attrs = [{att,37030},{def,18515},{hp_lim,370300},{crit,7406},{ten,7406},{hit,7406},{dodge,7406}]};
get(16,2) ->
	#base_pet_stage{stage = 16 ,lv = 2 ,exp = 320 ,add_exp = 10 ,goods = {20340,16} ,attrs = [{att,37510},{def,18755},{hp_lim,375100},{crit,7502},{ten,7502},{hit,7502},{dodge,7502}]};
get(16,3) ->
	#base_pet_stage{stage = 16 ,lv = 3 ,exp = 320 ,add_exp = 10 ,goods = {20340,16} ,attrs = [{att,37990},{def,18995},{hp_lim,379900},{crit,7598},{ten,7598},{hit,7598},{dodge,7598}]};
get(16,4) ->
	#base_pet_stage{stage = 16 ,lv = 4 ,exp = 320 ,add_exp = 10 ,goods = {20340,16} ,attrs = [{att,38470},{def,19235},{hp_lim,384700},{crit,7694},{ten,7694},{hit,7694},{dodge,7694}]};
get(16,5) ->
	#base_pet_stage{stage = 16 ,lv = 5 ,exp = 320 ,add_exp = 10 ,goods = {20340,16} ,attrs = [{att,38950},{def,19475},{hp_lim,389500},{crit,7790},{ten,7790},{hit,7790},{dodge,7790}]};
get(16,6) ->
	#base_pet_stage{stage = 16 ,lv = 6 ,exp = 320 ,add_exp = 10 ,goods = {20340,16} ,attrs = [{att,39430},{def,19715},{hp_lim,394300},{crit,7886},{ten,7886},{hit,7886},{dodge,7886}]};
get(16,7) ->
	#base_pet_stage{stage = 16 ,lv = 7 ,exp = 320 ,add_exp = 10 ,goods = {20340,16} ,attrs = [{att,39910},{def,19955},{hp_lim,399100},{crit,7982},{ten,7982},{hit,7982},{dodge,7982}]};
get(16,8) ->
	#base_pet_stage{stage = 16 ,lv = 8 ,exp = 320 ,add_exp = 10 ,goods = {20340,16} ,attrs = [{att,40390},{def,20195},{hp_lim,403900},{crit,8078},{ten,8078},{hit,8078},{dodge,8078}]};
get(16,9) ->
	#base_pet_stage{stage = 16 ,lv = 9 ,exp = 320 ,add_exp = 10 ,goods = {20340,16} ,attrs = [{att,40870},{def,20435},{hp_lim,408700},{crit,8174},{ten,8174},{hit,8174},{dodge,8174}]};
get(17,0) ->
	#base_pet_stage{stage = 17 ,lv = 0 ,exp = 340 ,add_exp = 10 ,goods = {20340,17} ,attrs = [{att,41380},{def,20690},{hp_lim,413800},{crit,8276},{ten,8276},{hit,8276},{dodge,8276}]};
get(17,1) ->
	#base_pet_stage{stage = 17 ,lv = 1 ,exp = 340 ,add_exp = 10 ,goods = {20340,17} ,attrs = [{att,41890},{def,20945},{hp_lim,418900},{crit,8378},{ten,8378},{hit,8378},{dodge,8378}]};
get(17,2) ->
	#base_pet_stage{stage = 17 ,lv = 2 ,exp = 340 ,add_exp = 10 ,goods = {20340,17} ,attrs = [{att,42400},{def,21200},{hp_lim,424000},{crit,8480},{ten,8480},{hit,8480},{dodge,8480}]};
get(17,3) ->
	#base_pet_stage{stage = 17 ,lv = 3 ,exp = 340 ,add_exp = 10 ,goods = {20340,17} ,attrs = [{att,42910},{def,21455},{hp_lim,429100},{crit,8582},{ten,8582},{hit,8582},{dodge,8582}]};
get(17,4) ->
	#base_pet_stage{stage = 17 ,lv = 4 ,exp = 340 ,add_exp = 10 ,goods = {20340,17} ,attrs = [{att,43420},{def,21710},{hp_lim,434200},{crit,8684},{ten,8684},{hit,8684},{dodge,8684}]};
get(17,5) ->
	#base_pet_stage{stage = 17 ,lv = 5 ,exp = 340 ,add_exp = 10 ,goods = {20340,17} ,attrs = [{att,43930},{def,21965},{hp_lim,439300},{crit,8786},{ten,8786},{hit,8786},{dodge,8786}]};
get(17,6) ->
	#base_pet_stage{stage = 17 ,lv = 6 ,exp = 340 ,add_exp = 10 ,goods = {20340,17} ,attrs = [{att,44440},{def,22220},{hp_lim,444400},{crit,8888},{ten,8888},{hit,8888},{dodge,8888}]};
get(17,7) ->
	#base_pet_stage{stage = 17 ,lv = 7 ,exp = 340 ,add_exp = 10 ,goods = {20340,17} ,attrs = [{att,44950},{def,22475},{hp_lim,449500},{crit,8990},{ten,8990},{hit,8990},{dodge,8990}]};
get(17,8) ->
	#base_pet_stage{stage = 17 ,lv = 8 ,exp = 340 ,add_exp = 10 ,goods = {20340,17} ,attrs = [{att,45460},{def,22730},{hp_lim,454600},{crit,9092},{ten,9092},{hit,9092},{dodge,9092}]};
get(17,9) ->
	#base_pet_stage{stage = 17 ,lv = 9 ,exp = 340 ,add_exp = 10 ,goods = {20340,17} ,attrs = [{att,45970},{def,22985},{hp_lim,459700},{crit,9194},{ten,9194},{hit,9194},{dodge,9194}]};
get(18,0) ->
	#base_pet_stage{stage = 18 ,lv = 0 ,exp = 360 ,add_exp = 10 ,goods = {20340,18} ,attrs = [{att,46510},{def,23255},{hp_lim,465100},{crit,9302},{ten,9302},{hit,9302},{dodge,9302}]};
get(18,1) ->
	#base_pet_stage{stage = 18 ,lv = 1 ,exp = 360 ,add_exp = 10 ,goods = {20340,18} ,attrs = [{att,47050},{def,23525},{hp_lim,470500},{crit,9410},{ten,9410},{hit,9410},{dodge,9410}]};
get(18,2) ->
	#base_pet_stage{stage = 18 ,lv = 2 ,exp = 360 ,add_exp = 10 ,goods = {20340,18} ,attrs = [{att,47590},{def,23795},{hp_lim,475900},{crit,9518},{ten,9518},{hit,9518},{dodge,9518}]};
get(18,3) ->
	#base_pet_stage{stage = 18 ,lv = 3 ,exp = 360 ,add_exp = 10 ,goods = {20340,18} ,attrs = [{att,48130},{def,24065},{hp_lim,481300},{crit,9626},{ten,9626},{hit,9626},{dodge,9626}]};
get(18,4) ->
	#base_pet_stage{stage = 18 ,lv = 4 ,exp = 360 ,add_exp = 10 ,goods = {20340,18} ,attrs = [{att,48670},{def,24335},{hp_lim,486700},{crit,9734},{ten,9734},{hit,9734},{dodge,9734}]};
get(18,5) ->
	#base_pet_stage{stage = 18 ,lv = 5 ,exp = 360 ,add_exp = 10 ,goods = {20340,18} ,attrs = [{att,49210},{def,24605},{hp_lim,492100},{crit,9842},{ten,9842},{hit,9842},{dodge,9842}]};
get(18,6) ->
	#base_pet_stage{stage = 18 ,lv = 6 ,exp = 360 ,add_exp = 10 ,goods = {20340,18} ,attrs = [{att,49750},{def,24875},{hp_lim,497500},{crit,9950},{ten,9950},{hit,9950},{dodge,9950}]};
get(18,7) ->
	#base_pet_stage{stage = 18 ,lv = 7 ,exp = 360 ,add_exp = 10 ,goods = {20340,18} ,attrs = [{att,50290},{def,25145},{hp_lim,502900},{crit,10058},{ten,10058},{hit,10058},{dodge,10058}]};
get(18,8) ->
	#base_pet_stage{stage = 18 ,lv = 8 ,exp = 360 ,add_exp = 10 ,goods = {20340,18} ,attrs = [{att,50830},{def,25415},{hp_lim,508300},{crit,10166},{ten,10166},{hit,10166},{dodge,10166}]};
get(18,9) ->
	#base_pet_stage{stage = 18 ,lv = 9 ,exp = 360 ,add_exp = 10 ,goods = {20340,18} ,attrs = [{att,51370},{def,25685},{hp_lim,513700},{crit,10274},{ten,10274},{hit,10274},{dodge,10274}]};
get(19,0) ->
	#base_pet_stage{stage = 19 ,lv = 0 ,exp = 380 ,add_exp = 10 ,goods = {20340,19} ,attrs = [{att,51940},{def,25970},{hp_lim,519400},{crit,10388},{ten,10388},{hit,10388},{dodge,10388}]};
get(19,1) ->
	#base_pet_stage{stage = 19 ,lv = 1 ,exp = 380 ,add_exp = 10 ,goods = {20340,19} ,attrs = [{att,52510},{def,26255},{hp_lim,525100},{crit,10502},{ten,10502},{hit,10502},{dodge,10502}]};
get(19,2) ->
	#base_pet_stage{stage = 19 ,lv = 2 ,exp = 380 ,add_exp = 10 ,goods = {20340,19} ,attrs = [{att,53080},{def,26540},{hp_lim,530800},{crit,10616},{ten,10616},{hit,10616},{dodge,10616}]};
get(19,3) ->
	#base_pet_stage{stage = 19 ,lv = 3 ,exp = 380 ,add_exp = 10 ,goods = {20340,19} ,attrs = [{att,53650},{def,26825},{hp_lim,536500},{crit,10730},{ten,10730},{hit,10730},{dodge,10730}]};
get(19,4) ->
	#base_pet_stage{stage = 19 ,lv = 4 ,exp = 380 ,add_exp = 10 ,goods = {20340,19} ,attrs = [{att,54220},{def,27110},{hp_lim,542200},{crit,10844},{ten,10844},{hit,10844},{dodge,10844}]};
get(19,5) ->
	#base_pet_stage{stage = 19 ,lv = 5 ,exp = 380 ,add_exp = 10 ,goods = {20340,19} ,attrs = [{att,54790},{def,27395},{hp_lim,547900},{crit,10958},{ten,10958},{hit,10958},{dodge,10958}]};
get(19,6) ->
	#base_pet_stage{stage = 19 ,lv = 6 ,exp = 380 ,add_exp = 10 ,goods = {20340,19} ,attrs = [{att,55360},{def,27680},{hp_lim,553600},{crit,11072},{ten,11072},{hit,11072},{dodge,11072}]};
get(19,7) ->
	#base_pet_stage{stage = 19 ,lv = 7 ,exp = 380 ,add_exp = 10 ,goods = {20340,19} ,attrs = [{att,55930},{def,27965},{hp_lim,559300},{crit,11186},{ten,11186},{hit,11186},{dodge,11186}]};
get(19,8) ->
	#base_pet_stage{stage = 19 ,lv = 8 ,exp = 380 ,add_exp = 10 ,goods = {20340,19} ,attrs = [{att,56500},{def,28250},{hp_lim,565000},{crit,11300},{ten,11300},{hit,11300},{dodge,11300}]};
get(19,9) ->
	#base_pet_stage{stage = 19 ,lv = 9 ,exp = 380 ,add_exp = 10 ,goods = {20340,19} ,attrs = [{att,57070},{def,28535},{hp_lim,570700},{crit,11414},{ten,11414},{hit,11414},{dodge,11414}]};
get(20,0) ->
	#base_pet_stage{stage = 20 ,lv = 0 ,exp = 400 ,add_exp = 10 ,goods = {20340,20} ,attrs = [{att,57670},{def,28835},{hp_lim,576700},{crit,11534},{ten,11534},{hit,11534},{dodge,11534}]};
get(20,1) ->
	#base_pet_stage{stage = 20 ,lv = 1 ,exp = 400 ,add_exp = 10 ,goods = {20340,20} ,attrs = [{att,58270},{def,29135},{hp_lim,582700},{crit,11654},{ten,11654},{hit,11654},{dodge,11654}]};
get(20,2) ->
	#base_pet_stage{stage = 20 ,lv = 2 ,exp = 400 ,add_exp = 10 ,goods = {20340,20} ,attrs = [{att,58870},{def,29435},{hp_lim,588700},{crit,11774},{ten,11774},{hit,11774},{dodge,11774}]};
get(20,3) ->
	#base_pet_stage{stage = 20 ,lv = 3 ,exp = 400 ,add_exp = 10 ,goods = {20340,20} ,attrs = [{att,59470},{def,29735},{hp_lim,594700},{crit,11894},{ten,11894},{hit,11894},{dodge,11894}]};
get(20,4) ->
	#base_pet_stage{stage = 20 ,lv = 4 ,exp = 400 ,add_exp = 10 ,goods = {20340,20} ,attrs = [{att,60070},{def,30035},{hp_lim,600700},{crit,12014},{ten,12014},{hit,12014},{dodge,12014}]};
get(20,5) ->
	#base_pet_stage{stage = 20 ,lv = 5 ,exp = 400 ,add_exp = 10 ,goods = {20340,20} ,attrs = [{att,60670},{def,30335},{hp_lim,606700},{crit,12134},{ten,12134},{hit,12134},{dodge,12134}]};
get(20,6) ->
	#base_pet_stage{stage = 20 ,lv = 6 ,exp = 400 ,add_exp = 10 ,goods = {20340,20} ,attrs = [{att,61270},{def,30635},{hp_lim,612700},{crit,12254},{ten,12254},{hit,12254},{dodge,12254}]};
get(20,7) ->
	#base_pet_stage{stage = 20 ,lv = 7 ,exp = 400 ,add_exp = 10 ,goods = {20340,20} ,attrs = [{att,61870},{def,30935},{hp_lim,618700},{crit,12374},{ten,12374},{hit,12374},{dodge,12374}]};
get(20,8) ->
	#base_pet_stage{stage = 20 ,lv = 8 ,exp = 400 ,add_exp = 10 ,goods = {20340,20} ,attrs = [{att,62470},{def,31235},{hp_lim,624700},{crit,12494},{ten,12494},{hit,12494},{dodge,12494}]};
get(20,9) ->
	#base_pet_stage{stage = 20 ,lv = 9 ,exp = 400 ,add_exp = 10 ,goods = {20340,20} ,attrs = [{att,63070},{def,31535},{hp_lim,630700},{crit,12614},{ten,12614},{hit,12614},{dodge,12614}]};
get(21,0) ->
	#base_pet_stage{stage = 21 ,lv = 0 ,exp = 420 ,add_exp = 10 ,goods = {20340,21} ,attrs = [{att,63700},{def,31850},{hp_lim,637000},{crit,12740},{ten,12740},{hit,12740},{dodge,12740}]};
get(21,1) ->
	#base_pet_stage{stage = 21 ,lv = 1 ,exp = 420 ,add_exp = 10 ,goods = {20340,21} ,attrs = [{att,64330},{def,32165},{hp_lim,643300},{crit,12866},{ten,12866},{hit,12866},{dodge,12866}]};
get(21,2) ->
	#base_pet_stage{stage = 21 ,lv = 2 ,exp = 420 ,add_exp = 10 ,goods = {20340,21} ,attrs = [{att,64960},{def,32480},{hp_lim,649600},{crit,12992},{ten,12992},{hit,12992},{dodge,12992}]};
get(21,3) ->
	#base_pet_stage{stage = 21 ,lv = 3 ,exp = 420 ,add_exp = 10 ,goods = {20340,21} ,attrs = [{att,65590},{def,32795},{hp_lim,655900},{crit,13118},{ten,13118},{hit,13118},{dodge,13118}]};
get(21,4) ->
	#base_pet_stage{stage = 21 ,lv = 4 ,exp = 420 ,add_exp = 10 ,goods = {20340,21} ,attrs = [{att,66220},{def,33110},{hp_lim,662200},{crit,13244},{ten,13244},{hit,13244},{dodge,13244}]};
get(21,5) ->
	#base_pet_stage{stage = 21 ,lv = 5 ,exp = 420 ,add_exp = 10 ,goods = {20340,21} ,attrs = [{att,66850},{def,33425},{hp_lim,668500},{crit,13370},{ten,13370},{hit,13370},{dodge,13370}]};
get(21,6) ->
	#base_pet_stage{stage = 21 ,lv = 6 ,exp = 420 ,add_exp = 10 ,goods = {20340,21} ,attrs = [{att,67480},{def,33740},{hp_lim,674800},{crit,13496},{ten,13496},{hit,13496},{dodge,13496}]};
get(21,7) ->
	#base_pet_stage{stage = 21 ,lv = 7 ,exp = 420 ,add_exp = 10 ,goods = {20340,21} ,attrs = [{att,68110},{def,34055},{hp_lim,681100},{crit,13622},{ten,13622},{hit,13622},{dodge,13622}]};
get(21,8) ->
	#base_pet_stage{stage = 21 ,lv = 8 ,exp = 420 ,add_exp = 10 ,goods = {20340,21} ,attrs = [{att,68740},{def,34370},{hp_lim,687400},{crit,13748},{ten,13748},{hit,13748},{dodge,13748}]};
get(21,9) ->
	#base_pet_stage{stage = 21 ,lv = 9 ,exp = 420 ,add_exp = 10 ,goods = {20340,21} ,attrs = [{att,69370},{def,34685},{hp_lim,693700},{crit,13874},{ten,13874},{hit,13874},{dodge,13874}]};
get(22,0) ->
	#base_pet_stage{stage = 22 ,lv = 0 ,exp = 440 ,add_exp = 10 ,goods = {20340,22} ,attrs = [{att,70030},{def,35015},{hp_lim,700300},{crit,14006},{ten,14006},{hit,14006},{dodge,14006}]};
get(22,1) ->
	#base_pet_stage{stage = 22 ,lv = 1 ,exp = 440 ,add_exp = 10 ,goods = {20340,22} ,attrs = [{att,70690},{def,35345},{hp_lim,706900},{crit,14138},{ten,14138},{hit,14138},{dodge,14138}]};
get(22,2) ->
	#base_pet_stage{stage = 22 ,lv = 2 ,exp = 440 ,add_exp = 10 ,goods = {20340,22} ,attrs = [{att,71350},{def,35675},{hp_lim,713500},{crit,14270},{ten,14270},{hit,14270},{dodge,14270}]};
get(22,3) ->
	#base_pet_stage{stage = 22 ,lv = 3 ,exp = 440 ,add_exp = 10 ,goods = {20340,22} ,attrs = [{att,72010},{def,36005},{hp_lim,720100},{crit,14402},{ten,14402},{hit,14402},{dodge,14402}]};
get(22,4) ->
	#base_pet_stage{stage = 22 ,lv = 4 ,exp = 440 ,add_exp = 10 ,goods = {20340,22} ,attrs = [{att,72670},{def,36335},{hp_lim,726700},{crit,14534},{ten,14534},{hit,14534},{dodge,14534}]};
get(22,5) ->
	#base_pet_stage{stage = 22 ,lv = 5 ,exp = 440 ,add_exp = 10 ,goods = {20340,22} ,attrs = [{att,73330},{def,36665},{hp_lim,733300},{crit,14666},{ten,14666},{hit,14666},{dodge,14666}]};
get(22,6) ->
	#base_pet_stage{stage = 22 ,lv = 6 ,exp = 440 ,add_exp = 10 ,goods = {20340,22} ,attrs = [{att,73990},{def,36995},{hp_lim,739900},{crit,14798},{ten,14798},{hit,14798},{dodge,14798}]};
get(22,7) ->
	#base_pet_stage{stage = 22 ,lv = 7 ,exp = 440 ,add_exp = 10 ,goods = {20340,22} ,attrs = [{att,74650},{def,37325},{hp_lim,746500},{crit,14930},{ten,14930},{hit,14930},{dodge,14930}]};
get(22,8) ->
	#base_pet_stage{stage = 22 ,lv = 8 ,exp = 440 ,add_exp = 10 ,goods = {20340,22} ,attrs = [{att,75310},{def,37655},{hp_lim,753100},{crit,15062},{ten,15062},{hit,15062},{dodge,15062}]};
get(22,9) ->
	#base_pet_stage{stage = 22 ,lv = 9 ,exp = 440 ,add_exp = 10 ,goods = {20340,22} ,attrs = [{att,75970},{def,37985},{hp_lim,759700},{crit,15194},{ten,15194},{hit,15194},{dodge,15194}]};
get(23,0) ->
	#base_pet_stage{stage = 23 ,lv = 0 ,exp = 460 ,add_exp = 10 ,goods = {20340,23} ,attrs = [{att,76660},{def,38330},{hp_lim,766600},{crit,15332},{ten,15332},{hit,15332},{dodge,15332}]};
get(23,1) ->
	#base_pet_stage{stage = 23 ,lv = 1 ,exp = 460 ,add_exp = 10 ,goods = {20340,23} ,attrs = [{att,77350},{def,38675},{hp_lim,773500},{crit,15470},{ten,15470},{hit,15470},{dodge,15470}]};
get(23,2) ->
	#base_pet_stage{stage = 23 ,lv = 2 ,exp = 460 ,add_exp = 10 ,goods = {20340,23} ,attrs = [{att,78040},{def,39020},{hp_lim,780400},{crit,15608},{ten,15608},{hit,15608},{dodge,15608}]};
get(23,3) ->
	#base_pet_stage{stage = 23 ,lv = 3 ,exp = 460 ,add_exp = 10 ,goods = {20340,23} ,attrs = [{att,78730},{def,39365},{hp_lim,787300},{crit,15746},{ten,15746},{hit,15746},{dodge,15746}]};
get(23,4) ->
	#base_pet_stage{stage = 23 ,lv = 4 ,exp = 460 ,add_exp = 10 ,goods = {20340,23} ,attrs = [{att,79420},{def,39710},{hp_lim,794200},{crit,15884},{ten,15884},{hit,15884},{dodge,15884}]};
get(23,5) ->
	#base_pet_stage{stage = 23 ,lv = 5 ,exp = 460 ,add_exp = 10 ,goods = {20340,23} ,attrs = [{att,80110},{def,40055},{hp_lim,801100},{crit,16022},{ten,16022},{hit,16022},{dodge,16022}]};
get(23,6) ->
	#base_pet_stage{stage = 23 ,lv = 6 ,exp = 460 ,add_exp = 10 ,goods = {20340,23} ,attrs = [{att,80800},{def,40400},{hp_lim,808000},{crit,16160},{ten,16160},{hit,16160},{dodge,16160}]};
get(23,7) ->
	#base_pet_stage{stage = 23 ,lv = 7 ,exp = 460 ,add_exp = 10 ,goods = {20340,23} ,attrs = [{att,81490},{def,40745},{hp_lim,814900},{crit,16298},{ten,16298},{hit,16298},{dodge,16298}]};
get(23,8) ->
	#base_pet_stage{stage = 23 ,lv = 8 ,exp = 460 ,add_exp = 10 ,goods = {20340,23} ,attrs = [{att,82180},{def,41090},{hp_lim,821800},{crit,16436},{ten,16436},{hit,16436},{dodge,16436}]};
get(23,9) ->
	#base_pet_stage{stage = 23 ,lv = 9 ,exp = 460 ,add_exp = 10 ,goods = {20340,23} ,attrs = [{att,82870},{def,41435},{hp_lim,828700},{crit,16574},{ten,16574},{hit,16574},{dodge,16574}]};
get(24,0) ->
	#base_pet_stage{stage = 24 ,lv = 0 ,exp = 480 ,add_exp = 10 ,goods = {20340,24} ,attrs = [{att,83590},{def,41795},{hp_lim,835900},{crit,16718},{ten,16718},{hit,16718},{dodge,16718}]};
get(24,1) ->
	#base_pet_stage{stage = 24 ,lv = 1 ,exp = 480 ,add_exp = 10 ,goods = {20340,24} ,attrs = [{att,84310},{def,42155},{hp_lim,843100},{crit,16862},{ten,16862},{hit,16862},{dodge,16862}]};
get(24,2) ->
	#base_pet_stage{stage = 24 ,lv = 2 ,exp = 480 ,add_exp = 10 ,goods = {20340,24} ,attrs = [{att,85030},{def,42515},{hp_lim,850300},{crit,17006},{ten,17006},{hit,17006},{dodge,17006}]};
get(24,3) ->
	#base_pet_stage{stage = 24 ,lv = 3 ,exp = 480 ,add_exp = 10 ,goods = {20340,24} ,attrs = [{att,85750},{def,42875},{hp_lim,857500},{crit,17150},{ten,17150},{hit,17150},{dodge,17150}]};
get(24,4) ->
	#base_pet_stage{stage = 24 ,lv = 4 ,exp = 480 ,add_exp = 10 ,goods = {20340,24} ,attrs = [{att,86470},{def,43235},{hp_lim,864700},{crit,17294},{ten,17294},{hit,17294},{dodge,17294}]};
get(24,5) ->
	#base_pet_stage{stage = 24 ,lv = 5 ,exp = 480 ,add_exp = 10 ,goods = {20340,24} ,attrs = [{att,87190},{def,43595},{hp_lim,871900},{crit,17438},{ten,17438},{hit,17438},{dodge,17438}]};
get(24,6) ->
	#base_pet_stage{stage = 24 ,lv = 6 ,exp = 480 ,add_exp = 10 ,goods = {20340,24} ,attrs = [{att,87910},{def,43955},{hp_lim,879100},{crit,17582},{ten,17582},{hit,17582},{dodge,17582}]};
get(24,7) ->
	#base_pet_stage{stage = 24 ,lv = 7 ,exp = 480 ,add_exp = 10 ,goods = {20340,24} ,attrs = [{att,88630},{def,44315},{hp_lim,886300},{crit,17726},{ten,17726},{hit,17726},{dodge,17726}]};
get(24,8) ->
	#base_pet_stage{stage = 24 ,lv = 8 ,exp = 480 ,add_exp = 10 ,goods = {20340,24} ,attrs = [{att,89350},{def,44675},{hp_lim,893500},{crit,17870},{ten,17870},{hit,17870},{dodge,17870}]};
get(24,9) ->
	#base_pet_stage{stage = 24 ,lv = 9 ,exp = 480 ,add_exp = 10 ,goods = {20340,24} ,attrs = [{att,90070},{def,45035},{hp_lim,900700},{crit,18014},{ten,18014},{hit,18014},{dodge,18014}]};
get(25,0) ->
	#base_pet_stage{stage = 25 ,lv = 0 ,exp = 500 ,add_exp = 10 ,goods = {20340,25} ,attrs = [{att,90820},{def,45410},{hp_lim,908200},{crit,18164},{ten,18164},{hit,18164},{dodge,18164}]};
get(25,1) ->
	#base_pet_stage{stage = 25 ,lv = 1 ,exp = 500 ,add_exp = 10 ,goods = {20340,25} ,attrs = [{att,91570},{def,45785},{hp_lim,915700},{crit,18314},{ten,18314},{hit,18314},{dodge,18314}]};
get(25,2) ->
	#base_pet_stage{stage = 25 ,lv = 2 ,exp = 500 ,add_exp = 10 ,goods = {20340,25} ,attrs = [{att,92320},{def,46160},{hp_lim,923200},{crit,18464},{ten,18464},{hit,18464},{dodge,18464}]};
get(25,3) ->
	#base_pet_stage{stage = 25 ,lv = 3 ,exp = 500 ,add_exp = 10 ,goods = {20340,25} ,attrs = [{att,93070},{def,46535},{hp_lim,930700},{crit,18614},{ten,18614},{hit,18614},{dodge,18614}]};
get(25,4) ->
	#base_pet_stage{stage = 25 ,lv = 4 ,exp = 500 ,add_exp = 10 ,goods = {20340,25} ,attrs = [{att,93820},{def,46910},{hp_lim,938200},{crit,18764},{ten,18764},{hit,18764},{dodge,18764}]};
get(25,5) ->
	#base_pet_stage{stage = 25 ,lv = 5 ,exp = 500 ,add_exp = 10 ,goods = {20340,25} ,attrs = [{att,94570},{def,47285},{hp_lim,945700},{crit,18914},{ten,18914},{hit,18914},{dodge,18914}]};
get(25,6) ->
	#base_pet_stage{stage = 25 ,lv = 6 ,exp = 500 ,add_exp = 10 ,goods = {20340,25} ,attrs = [{att,95320},{def,47660},{hp_lim,953200},{crit,19064},{ten,19064},{hit,19064},{dodge,19064}]};
get(25,7) ->
	#base_pet_stage{stage = 25 ,lv = 7 ,exp = 500 ,add_exp = 10 ,goods = {20340,25} ,attrs = [{att,96070},{def,48035},{hp_lim,960700},{crit,19214},{ten,19214},{hit,19214},{dodge,19214}]};
get(25,8) ->
	#base_pet_stage{stage = 25 ,lv = 8 ,exp = 500 ,add_exp = 10 ,goods = {20340,25} ,attrs = [{att,96820},{def,48410},{hp_lim,968200},{crit,19364},{ten,19364},{hit,19364},{dodge,19364}]};
get(25,9) ->
	#base_pet_stage{stage = 25 ,lv = 9 ,exp = 500 ,add_exp = 10 ,goods = {20340,25} ,attrs = [{att,97570},{def,48785},{hp_lim,975700},{crit,19514},{ten,19514},{hit,19514},{dodge,19514}]};
get(26,0) ->
	#base_pet_stage{stage = 26 ,lv = 0 ,exp = 520 ,add_exp = 10 ,goods = {20340,26} ,attrs = [{att,98350},{def,49175},{hp_lim,983500},{crit,19670},{ten,19670},{hit,19670},{dodge,19670}]};
get(26,1) ->
	#base_pet_stage{stage = 26 ,lv = 1 ,exp = 520 ,add_exp = 10 ,goods = {20340,26} ,attrs = [{att,99130},{def,49565},{hp_lim,991300},{crit,19826},{ten,19826},{hit,19826},{dodge,19826}]};
get(26,2) ->
	#base_pet_stage{stage = 26 ,lv = 2 ,exp = 520 ,add_exp = 10 ,goods = {20340,26} ,attrs = [{att,99910},{def,49955},{hp_lim,999100},{crit,19982},{ten,19982},{hit,19982},{dodge,19982}]};
get(26,3) ->
	#base_pet_stage{stage = 26 ,lv = 3 ,exp = 520 ,add_exp = 10 ,goods = {20340,26} ,attrs = [{att,100690},{def,50345},{hp_lim,1006900},{crit,20138},{ten,20138},{hit,20138},{dodge,20138}]};
get(26,4) ->
	#base_pet_stage{stage = 26 ,lv = 4 ,exp = 520 ,add_exp = 10 ,goods = {20340,26} ,attrs = [{att,101470},{def,50735},{hp_lim,1014700},{crit,20294},{ten,20294},{hit,20294},{dodge,20294}]};
get(26,5) ->
	#base_pet_stage{stage = 26 ,lv = 5 ,exp = 520 ,add_exp = 10 ,goods = {20340,26} ,attrs = [{att,102250},{def,51125},{hp_lim,1022500},{crit,20450},{ten,20450},{hit,20450},{dodge,20450}]};
get(26,6) ->
	#base_pet_stage{stage = 26 ,lv = 6 ,exp = 520 ,add_exp = 10 ,goods = {20340,26} ,attrs = [{att,103030},{def,51515},{hp_lim,1030300},{crit,20606},{ten,20606},{hit,20606},{dodge,20606}]};
get(26,7) ->
	#base_pet_stage{stage = 26 ,lv = 7 ,exp = 520 ,add_exp = 10 ,goods = {20340,26} ,attrs = [{att,103810},{def,51905},{hp_lim,1038100},{crit,20762},{ten,20762},{hit,20762},{dodge,20762}]};
get(26,8) ->
	#base_pet_stage{stage = 26 ,lv = 8 ,exp = 520 ,add_exp = 10 ,goods = {20340,26} ,attrs = [{att,104590},{def,52295},{hp_lim,1045900},{crit,20918},{ten,20918},{hit,20918},{dodge,20918}]};
get(26,9) ->
	#base_pet_stage{stage = 26 ,lv = 9 ,exp = 520 ,add_exp = 10 ,goods = {20340,26} ,attrs = [{att,105370},{def,52685},{hp_lim,1053700},{crit,21074},{ten,21074},{hit,21074},{dodge,21074}]};
get(27,0) ->
	#base_pet_stage{stage = 27 ,lv = 0 ,exp = 540 ,add_exp = 10 ,goods = {20340,27} ,attrs = [{att,106180},{def,53090},{hp_lim,1061800},{crit,21236},{ten,21236},{hit,21236},{dodge,21236}]};
get(27,1) ->
	#base_pet_stage{stage = 27 ,lv = 1 ,exp = 540 ,add_exp = 10 ,goods = {20340,27} ,attrs = [{att,106990},{def,53495},{hp_lim,1069900},{crit,21398},{ten,21398},{hit,21398},{dodge,21398}]};
get(27,2) ->
	#base_pet_stage{stage = 27 ,lv = 2 ,exp = 540 ,add_exp = 10 ,goods = {20340,27} ,attrs = [{att,107800},{def,53900},{hp_lim,1078000},{crit,21560},{ten,21560},{hit,21560},{dodge,21560}]};
get(27,3) ->
	#base_pet_stage{stage = 27 ,lv = 3 ,exp = 540 ,add_exp = 10 ,goods = {20340,27} ,attrs = [{att,108610},{def,54305},{hp_lim,1086100},{crit,21722},{ten,21722},{hit,21722},{dodge,21722}]};
get(27,4) ->
	#base_pet_stage{stage = 27 ,lv = 4 ,exp = 540 ,add_exp = 10 ,goods = {20340,27} ,attrs = [{att,109420},{def,54710},{hp_lim,1094200},{crit,21884},{ten,21884},{hit,21884},{dodge,21884}]};
get(27,5) ->
	#base_pet_stage{stage = 27 ,lv = 5 ,exp = 540 ,add_exp = 10 ,goods = {20340,27} ,attrs = [{att,110230},{def,55115},{hp_lim,1102300},{crit,22046},{ten,22046},{hit,22046},{dodge,22046}]};
get(27,6) ->
	#base_pet_stage{stage = 27 ,lv = 6 ,exp = 540 ,add_exp = 10 ,goods = {20340,27} ,attrs = [{att,111040},{def,55520},{hp_lim,1110400},{crit,22208},{ten,22208},{hit,22208},{dodge,22208}]};
get(27,7) ->
	#base_pet_stage{stage = 27 ,lv = 7 ,exp = 540 ,add_exp = 10 ,goods = {20340,27} ,attrs = [{att,111850},{def,55925},{hp_lim,1118500},{crit,22370},{ten,22370},{hit,22370},{dodge,22370}]};
get(27,8) ->
	#base_pet_stage{stage = 27 ,lv = 8 ,exp = 540 ,add_exp = 10 ,goods = {20340,27} ,attrs = [{att,112660},{def,56330},{hp_lim,1126600},{crit,22532},{ten,22532},{hit,22532},{dodge,22532}]};
get(27,9) ->
	#base_pet_stage{stage = 27 ,lv = 9 ,exp = 540 ,add_exp = 10 ,goods = {20340,27} ,attrs = [{att,113470},{def,56735},{hp_lim,1134700},{crit,22694},{ten,22694},{hit,22694},{dodge,22694}]};
get(28,0) ->
	#base_pet_stage{stage = 28 ,lv = 0 ,exp = 560 ,add_exp = 10 ,goods = {20340,28} ,attrs = [{att,114310},{def,57155},{hp_lim,1143100},{crit,22862},{ten,22862},{hit,22862},{dodge,22862}]};
get(28,1) ->
	#base_pet_stage{stage = 28 ,lv = 1 ,exp = 560 ,add_exp = 10 ,goods = {20340,28} ,attrs = [{att,115150},{def,57575},{hp_lim,1151500},{crit,23030},{ten,23030},{hit,23030},{dodge,23030}]};
get(28,2) ->
	#base_pet_stage{stage = 28 ,lv = 2 ,exp = 560 ,add_exp = 10 ,goods = {20340,28} ,attrs = [{att,115990},{def,57995},{hp_lim,1159900},{crit,23198},{ten,23198},{hit,23198},{dodge,23198}]};
get(28,3) ->
	#base_pet_stage{stage = 28 ,lv = 3 ,exp = 560 ,add_exp = 10 ,goods = {20340,28} ,attrs = [{att,116830},{def,58415},{hp_lim,1168300},{crit,23366},{ten,23366},{hit,23366},{dodge,23366}]};
get(28,4) ->
	#base_pet_stage{stage = 28 ,lv = 4 ,exp = 560 ,add_exp = 10 ,goods = {20340,28} ,attrs = [{att,117670},{def,58835},{hp_lim,1176700},{crit,23534},{ten,23534},{hit,23534},{dodge,23534}]};
get(28,5) ->
	#base_pet_stage{stage = 28 ,lv = 5 ,exp = 560 ,add_exp = 10 ,goods = {20340,28} ,attrs = [{att,118510},{def,59255},{hp_lim,1185100},{crit,23702},{ten,23702},{hit,23702},{dodge,23702}]};
get(28,6) ->
	#base_pet_stage{stage = 28 ,lv = 6 ,exp = 560 ,add_exp = 10 ,goods = {20340,28} ,attrs = [{att,119350},{def,59675},{hp_lim,1193500},{crit,23870},{ten,23870},{hit,23870},{dodge,23870}]};
get(28,7) ->
	#base_pet_stage{stage = 28 ,lv = 7 ,exp = 560 ,add_exp = 10 ,goods = {20340,28} ,attrs = [{att,120190},{def,60095},{hp_lim,1201900},{crit,24038},{ten,24038},{hit,24038},{dodge,24038}]};
get(28,8) ->
	#base_pet_stage{stage = 28 ,lv = 8 ,exp = 560 ,add_exp = 10 ,goods = {20340,28} ,attrs = [{att,121030},{def,60515},{hp_lim,1210300},{crit,24206},{ten,24206},{hit,24206},{dodge,24206}]};
get(28,9) ->
	#base_pet_stage{stage = 28 ,lv = 9 ,exp = 560 ,add_exp = 10 ,goods = {20340,28} ,attrs = [{att,121870},{def,60935},{hp_lim,1218700},{crit,24374},{ten,24374},{hit,24374},{dodge,24374}]};
get(29,0) ->
	#base_pet_stage{stage = 29 ,lv = 0 ,exp = 580 ,add_exp = 10 ,goods = {20340,29} ,attrs = [{att,122740},{def,61370},{hp_lim,1227400},{crit,24548},{ten,24548},{hit,24548},{dodge,24548}]};
get(29,1) ->
	#base_pet_stage{stage = 29 ,lv = 1 ,exp = 580 ,add_exp = 10 ,goods = {20340,29} ,attrs = [{att,123610},{def,61805},{hp_lim,1236100},{crit,24722},{ten,24722},{hit,24722},{dodge,24722}]};
get(29,2) ->
	#base_pet_stage{stage = 29 ,lv = 2 ,exp = 580 ,add_exp = 10 ,goods = {20340,29} ,attrs = [{att,124480},{def,62240},{hp_lim,1244800},{crit,24896},{ten,24896},{hit,24896},{dodge,24896}]};
get(29,3) ->
	#base_pet_stage{stage = 29 ,lv = 3 ,exp = 580 ,add_exp = 10 ,goods = {20340,29} ,attrs = [{att,125350},{def,62675},{hp_lim,1253500},{crit,25070},{ten,25070},{hit,25070},{dodge,25070}]};
get(29,4) ->
	#base_pet_stage{stage = 29 ,lv = 4 ,exp = 580 ,add_exp = 10 ,goods = {20340,29} ,attrs = [{att,126220},{def,63110},{hp_lim,1262200},{crit,25244},{ten,25244},{hit,25244},{dodge,25244}]};
get(29,5) ->
	#base_pet_stage{stage = 29 ,lv = 5 ,exp = 580 ,add_exp = 10 ,goods = {20340,29} ,attrs = [{att,127090},{def,63545},{hp_lim,1270900},{crit,25418},{ten,25418},{hit,25418},{dodge,25418}]};
get(29,6) ->
	#base_pet_stage{stage = 29 ,lv = 6 ,exp = 580 ,add_exp = 10 ,goods = {20340,29} ,attrs = [{att,127960},{def,63980},{hp_lim,1279600},{crit,25592},{ten,25592},{hit,25592},{dodge,25592}]};
get(29,7) ->
	#base_pet_stage{stage = 29 ,lv = 7 ,exp = 580 ,add_exp = 10 ,goods = {20340,29} ,attrs = [{att,128830},{def,64415},{hp_lim,1288300},{crit,25766},{ten,25766},{hit,25766},{dodge,25766}]};
get(29,8) ->
	#base_pet_stage{stage = 29 ,lv = 8 ,exp = 580 ,add_exp = 10 ,goods = {20340,29} ,attrs = [{att,129700},{def,64850},{hp_lim,1297000},{crit,25940},{ten,25940},{hit,25940},{dodge,25940}]};
get(29,9) ->
	#base_pet_stage{stage = 29 ,lv = 9 ,exp = 580 ,add_exp = 10 ,goods = {20340,29} ,attrs = [{att,130570},{def,65285},{hp_lim,1305700},{crit,26114},{ten,26114},{hit,26114},{dodge,26114}]};
get(30,0) ->
	#base_pet_stage{stage = 30 ,lv = 0 ,exp = 600 ,add_exp = 10 ,goods = {20340,30} ,attrs = [{att,131470},{def,65735},{hp_lim,1314700},{crit,26294},{ten,26294},{hit,26294},{dodge,26294}]};
get(30,1) ->
	#base_pet_stage{stage = 30 ,lv = 1 ,exp = 600 ,add_exp = 10 ,goods = {20340,30} ,attrs = [{att,132370},{def,66185},{hp_lim,1323700},{crit,26474},{ten,26474},{hit,26474},{dodge,26474}]};
get(30,2) ->
	#base_pet_stage{stage = 30 ,lv = 2 ,exp = 600 ,add_exp = 10 ,goods = {20340,30} ,attrs = [{att,133270},{def,66635},{hp_lim,1332700},{crit,26654},{ten,26654},{hit,26654},{dodge,26654}]};
get(30,3) ->
	#base_pet_stage{stage = 30 ,lv = 3 ,exp = 600 ,add_exp = 10 ,goods = {20340,30} ,attrs = [{att,134170},{def,67085},{hp_lim,1341700},{crit,26834},{ten,26834},{hit,26834},{dodge,26834}]};
get(30,4) ->
	#base_pet_stage{stage = 30 ,lv = 4 ,exp = 600 ,add_exp = 10 ,goods = {20340,30} ,attrs = [{att,135070},{def,67535},{hp_lim,1350700},{crit,27014},{ten,27014},{hit,27014},{dodge,27014}]};
get(30,5) ->
	#base_pet_stage{stage = 30 ,lv = 5 ,exp = 600 ,add_exp = 10 ,goods = {20340,30} ,attrs = [{att,135970},{def,67985},{hp_lim,1359700},{crit,27194},{ten,27194},{hit,27194},{dodge,27194}]};
get(30,6) ->
	#base_pet_stage{stage = 30 ,lv = 6 ,exp = 600 ,add_exp = 10 ,goods = {20340,30} ,attrs = [{att,136870},{def,68435},{hp_lim,1368700},{crit,27374},{ten,27374},{hit,27374},{dodge,27374}]};
get(30,7) ->
	#base_pet_stage{stage = 30 ,lv = 7 ,exp = 600 ,add_exp = 10 ,goods = {20340,30} ,attrs = [{att,137770},{def,68885},{hp_lim,1377700},{crit,27554},{ten,27554},{hit,27554},{dodge,27554}]};
get(30,8) ->
	#base_pet_stage{stage = 30 ,lv = 8 ,exp = 600 ,add_exp = 10 ,goods = {20340,30} ,attrs = [{att,138670},{def,69335},{hp_lim,1386700},{crit,27734},{ten,27734},{hit,27734},{dodge,27734}]};
get(30,9) ->
	#base_pet_stage{stage = 30 ,lv = 9 ,exp = 0 ,add_exp = 0 ,goods = {20340,30} ,attrs = [{att,139570},{def,69785},{hp_lim,1395700},{crit,27914},{ten,27914},{hit,27914},{dodge,27914}]};
get(_,_) -> [].
  get_max_lv(1) -> 9;
  get_max_lv(2) -> 9;
  get_max_lv(3) -> 9;
  get_max_lv(4) -> 9;
  get_max_lv(5) -> 9;
  get_max_lv(6) -> 9;
  get_max_lv(7) -> 9;
  get_max_lv(8) -> 9;
  get_max_lv(9) -> 9;
  get_max_lv(10) -> 9;
  get_max_lv(11) -> 9;
  get_max_lv(12) -> 9;
  get_max_lv(13) -> 9;
  get_max_lv(14) -> 9;
  get_max_lv(15) -> 9;
  get_max_lv(16) -> 9;
  get_max_lv(17) -> 9;
  get_max_lv(18) -> 9;
  get_max_lv(19) -> 9;
  get_max_lv(20) -> 9;
  get_max_lv(21) -> 9;
  get_max_lv(22) -> 9;
  get_max_lv(23) -> 9;
  get_max_lv(24) -> 9;
  get_max_lv(25) -> 9;
  get_max_lv(26) -> 9;
  get_max_lv(27) -> 9;
  get_max_lv(28) -> 9;
  get_max_lv(29) -> 9;
  get_max_lv(30) -> 9;
get_max_lv(_) -> [].
