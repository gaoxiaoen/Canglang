%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_scuffle_elite_career
	%%% @Created : 2017-11-15 16:07:51
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_scuffle_elite_career).
-export([career_list/0]).
-export([figure2career/1]).
-export([get/1]).
-include("common.hrl").
-include("cross_scuffle_elite.hrl").

    career_list() ->
    [1,2,3,4,5,6].
figure2career(10014) -> 1; 
figure2career(10012) -> 2; 
figure2career(10034) -> 3; 
figure2career(10025) -> 4; 
figure2career(10010) -> 5; 
figure2career(10007) -> 6; 
figure2career(_) -> []. 
get(1) -> 
   #base_scuffle_elite_career{career = 1 ,name = ?T("熊战士") ,figure = 10014 ,skill = {7601001,7601002,7601003,7601004} ,attrs = [{hp_lim,6000},{att,300},{crit,10},{ten,10},{hit,10},{dodge,10}],move_speed = 200 ,att_speed = 0.3 ,att_area = 3 }; 
get(2) -> 
   #base_scuffle_elite_career{career = 2 ,name = ?T("鸣雷鼓") ,figure = 10012 ,skill = {7601005,7601006,7601007,7601008} ,attrs = [{hp_lim,8000},{att,150},{crit,10},{ten,10},{hit,10},{dodge,10}],move_speed = 200 ,att_speed = 0.5 ,att_area = 3 }; 
get(3) -> 
   #base_scuffle_elite_career{career = 3 ,name = ?T("鹰射手") ,figure = 10034 ,skill = {7601009,7601010,7601011,7601012,7601013} ,attrs = [{hp_lim,4000},{att,375},{crit,10},{ten,10},{hit,10},{dodge,10}],move_speed = 200 ,att_speed = 0.5 ,att_area = 5 }; 
get(4) -> 
   #base_scuffle_elite_career{career = 4 ,name = ?T("咒术师") ,figure = 10025 ,skill = {7601014,7601015,7601016,7601017} ,attrs = [{hp_lim,4500},{att,600},{crit,10},{ten,10},{hit,10},{dodge,10},{crit_inc,2000}],move_speed = 200 ,att_speed = 1 ,att_area = 4 }; 
get(5) -> 
   #base_scuffle_elite_career{career = 5 ,name = ?T("鬼仙") ,figure = 10010 ,skill = {7601018,7601019,7601020,7601021} ,attrs = [{hp_lim,3750},{att,650},{crit,10},{ten,10},{hit,10},{dodge,10}],move_speed = 200 ,att_speed = 1 ,att_area = 6 }; 
get(6) -> 
   #base_scuffle_elite_career{career = 6 ,name = ?T("飞翼妖女") ,figure = 10007 ,skill = {7601022,7601023,7601024,7601025} ,attrs = [{hp_lim,6000},{att,350},{crit,10},{ten,10},{hit,10},{dodge,10}],move_speed = 200 ,att_speed = 1 ,att_area = 4 }; 
get(_) -> []. 
