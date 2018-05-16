%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_god_weapon
	%%% @Created : 2018-05-14 16:35:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_god_weapon).
-export([id_list/0]).
-export([skill2ratio/1]).
-export([get/1]).
-include("god_weapon.hrl").
-include("common.hrl").

    id_list() ->
    [10001,10002,10003,10004,10005,10006,10007,10008,10009,10010].
skill2ratio(1301001)->100;
skill2ratio(1301002)->90;
skill2ratio(1301003)->80;
skill2ratio(1301004)->70;
skill2ratio(1301005)->60;
skill2ratio(1301006)->50;
skill2ratio(1301007)->40;
skill2ratio(1301008)->30;
skill2ratio(1301009)->20;
skill2ratio(1301010)->10;
skill2ratio(_) -> 0.
get(10001) ->
	#base_god_weapon{weapon_id = 10001 ,name = ?T("不归砚"), figure = 10003 ,desc = ?T("真厉害"), attrs = [{att,30},{def,15},{hp_lim,300},{crit,20},{ten,20}],skill_id = 1301001 ,ratio = 100 ,condition = [{days,1},{vip,0},{lv,1}]};
get(10002) ->
	#base_god_weapon{weapon_id = 10002 ,name = ?T("天神臂"), figure = 10008 ,desc = ?T("没得说"), attrs = [{hp_lim,3000},{crit,100},{ten,100},{hit,100},{dodge,100}],skill_id = 1301002 ,ratio = 90 ,condition = [{days,0},{vip,0},{lv,1},{charge_gold,1}]};
get(10003) ->
	#base_god_weapon{weapon_id = 10003 ,name = ?T("浮沉珠"), figure = 10001 ,desc = ?T("棒棒的"), attrs = [{att,70},{def,35},{hp_lim,700},{ten,30},{hit,30}],skill_id = 1301003 ,ratio = 80 ,condition = [{days,3},{vip,0},{lv,1}]};
get(10004) ->
	#base_god_weapon{weapon_id = 10004 ,name = ?T("玄镇尺"), figure = 10002 ,desc = ?T("真厉害"), attrs = [{att,100},{def,50},{hp_lim,100},{dodge,40},{hit,40}],skill_id = 1301004 ,ratio = 70 ,condition = [{days,5},{vip,0},{lv,1}]};
get(10005) ->
	#base_god_weapon{weapon_id = 10005 ,name = ?T("流光琴"), figure = 10004 ,desc = ?T("没得说"), attrs = [{att,200},{def,100},{hp_lim,2000},{crit,100},{dodge,100}],skill_id = 1301005 ,ratio = 60 ,condition = [{days,0},{vip,5},{lv,1}]};
get(10006) ->
	#base_god_weapon{weapon_id = 10006 ,name = ?T("仁王盾"), figure = 10005 ,desc = ?T("棒棒的"), attrs = [{att,180},{def,90},{hp_lim,1800},{crit,100},{ten,100}],skill_id = 1301006 ,ratio = 50 ,condition = [{days,7},{vip,0},{lv,1}]};
get(10007) ->
	#base_god_weapon{weapon_id = 10007 ,name = ?T("谪仙伞"), figure = 10006 ,desc = ?T("真厉害"), attrs = [{att,1000},{hp_lim,10000},{ten,200},{hit,200},{dodge,200}],skill_id = 1301007 ,ratio = 40 ,condition = [{days,0},{vip,0},{lv,80}]};
get(10008) ->
	#base_god_weapon{weapon_id = 10008 ,name = ?T("炎鬼轮"), figure = 10007 ,desc = ?T("没得说"), attrs = [{def,500},{crit,150},{ten,150},{hit,150},{dodge,150}],skill_id = 1301008 ,ratio = 30 ,condition = [{days,15},{vip,0},{lv,1}]};
get(10009) ->
	#base_god_weapon{weapon_id = 10009 ,name = ?T("东皇钟"), figure = 10009 ,desc = ?T("棒棒的"), attrs = [{att,1500},{def,750},{hp_lim,15000},{crit,250},{dodge,250}],skill_id = 1301009 ,ratio = 20 ,condition = [{days,0},{vip,0},{lv,100}]};
get(10010) ->
	#base_god_weapon{weapon_id = 10010 ,name = ?T("伏羲像"), figure = 10010 ,desc = ?T("棒棒的"), attrs = [{att,1800},{def,900},{hp_lim,18000},{crit,280},{dodge,280}],skill_id = 1301010 ,ratio = 10 ,condition = [{days,30},{vip,0},{lv,1}]};
get(_Data) -> [].