%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_jiandao_upstage
	%%% @Created : 2018-03-28 15:41:09
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_jiandao_upstage).
-export([get/1]).
-export([get_all/0]).
-include("element.hrl").
get(1) -> #base_jiandao_stage{stage = 1, jiandao_id = 1100, consume = [], attrs = [], skill_list = [], wear_element_max = 1};
get(2) -> #base_jiandao_stage{stage = 2, jiandao_id = 1200, consume = [{40002,10}], attrs = [{att,1207},{def,603},{hp_lim,12074},{crit,269},{ten,250},{hit,241},{dodge,232}], skill_list = [], wear_element_max = 1};
get(3) -> #base_jiandao_stage{stage = 3, jiandao_id = 1300, consume = [{40002,20}], attrs = [{att,3219},{def,1609},{hp_lim,32198},{crit,718},{ten,668},{hit,643},{dodge,619}], skill_list = [1311001], wear_element_max = 1};
get(4) -> #base_jiandao_stage{stage = 4, jiandao_id = 1400, consume = [{40002,40}], attrs = [{att,6037},{def,3018},{hp_lim,60371},{crit,1346},{ten,1253},{hit,1207},{dodge,1160}], skill_list = [1311001], wear_element_max = 2};
get(5) -> #base_jiandao_stage{stage = 5, jiandao_id = 1500, consume = [{40002,80}], attrs = [{att,10061},{def,5030},{hp_lim,100619},{crit,2244},{ten,2089},{hit,2012},{dodge,1934}], skill_list = [1311001], wear_element_max = 2};
get(6) -> #base_jiandao_stage{stage = 6, jiandao_id = 1600, consume = [{40002,160}], attrs = [{att,15294},{def,7647},{hp_lim,152941},{crit,3411},{ten,3176},{hit,3058},{dodge,2941}], skill_list = [1311001], wear_element_max = 2};
get(7) -> #base_jiandao_stage{stage = 7, jiandao_id = 1700, consume = [{40002,300}], attrs = [{att,21331},{def,10665},{hp_lim,213312},{crit,4758},{ten,4430},{hit,4266},{dodge,4102}], skill_list = [1311001], wear_element_max = 2};
get(8) -> #base_jiandao_stage{stage = 8, jiandao_id = 1800, consume = [{40002,500}], attrs = [{att,27368},{def,13684},{hp_lim,273684},{crit,6105},{ten,5684},{hit,5473},{dodge,5263}], skill_list = [1311001], wear_element_max = 3};
get(9) -> #base_jiandao_stage{stage = 9, jiandao_id = 1900, consume = [{40002,800}], attrs = [{att,33405},{def,16702},{hp_lim,334055},{crit,7452},{ten,6938},{hit,6681},{dodge,6424}], skill_list = [1311001], wear_element_max = 3};
get(10) -> #base_jiandao_stage{stage = 10, jiandao_id = 2000, consume = [{40002,1000}], attrs = [{att,40247},{def,20123},{hp_lim,402476},{crit,8978},{ten,8359},{hit,8049},{dodge,7739}], skill_list = [1311001], wear_element_max = 3};
get(_Id) -> [].

get_all()->[1,2,3,4,5,6,7,8,9,10].

