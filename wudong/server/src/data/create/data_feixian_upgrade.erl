%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_feixian_upgrade
	%%% @Created : 2018-05-03 16:44:06
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_feixian_upgrade).
-export([get/1]).
-include("xian.hrl").
get(1) -> #base_xian_upgrade{
			stage = 1,
			desc = "地仙",
			attr = [{att,410},{def,200},{hp_lim,4080},{crit,90},{ten,80},{hit,80},{dodge,70}],
			condition = [{1, get_goods, 7405002, 10, "收集地仙令，凝聚地仙的力量，厚积薄发，冲击天仙。"}, {2, kill_mon, 26003, 100, "天仙有怒，四海皆危。用你的势力，震慑诸荒妖族吧！",10007}, {3, pass_dungeon, 12008, 1, "转眼三五甲子，颇有小成，去接收试练吧"}],
			drop_goods=[{7405003, 1, 5000}], 
			pass_goods=[{7405003,3},{7405001,20}]
		};
get(2) -> #base_xian_upgrade{
			stage = 2,
			desc = "天仙",
			attr = [{att,820},{def,410},{hp_lim,8160},{crit,180},{ten,160},{hit,160},{dodge,150}],
			condition = [{1, get_goods, 7405003, 40, "收集天仙令，凝聚天仙的力量，厚积薄发，冲击金仙。"}, {2, kill_mon, 26012, 100, "金仙有怒，四海皆危。用你的势力，震慑诸荒妖族吧！",10007}, {3, pass_dungeon, 12009, 1, "转眼三五甲子，颇有小成，去接收试练吧"}],
			drop_goods=[{7405004, 1, 5000}], 
			pass_goods=[{7405004,3},{7405001,30}]
		};
get(3) -> #base_xian_upgrade{
			stage = 3,
			desc = "金仙",
			attr = [{att,1430},{def,710},{hp_lim,14290},{crit,310},{ten,290},{hit,290},{dodge,260}],
			condition = [{1, get_goods, 7405004, 50, "收集金仙令，凝聚金仙的力量，厚积薄发，冲击星君。"}, {2, kill_mon, 26117, 100, "星君有怒，四海皆危。用你的势力，震慑诸荒妖族吧！",10007}, {3, pass_dungeon, 12010, 1, "转眼三五甲子，颇有小成，去接收试练吧"}],
			drop_goods=[{7405005, 1, 5000}], 
			pass_goods=[{7405005,3},{7405001,40}]
		};
get(4) -> #base_xian_upgrade{
			stage = 4,
			desc = "星君",
			attr = [{att,2450},{def,1220},{hp_lim,24490},{crit,540},{ten,490},{hit,490},{dodge,440}],
			condition = [{1, get_goods, 7405005, 50, "收集星君令，凝聚星君的力量，厚积薄发，冲击仙帝。"}, {2, kill_mon, 26122, 100, "仙帝有怒，四海皆危。用你的势力，震慑诸荒妖族吧！",10007}, {3, pass_dungeon, 12011, 1, "转眼三五甲子，颇有小成，去接收试练吧"}],
			drop_goods=[{7405006, 1, 5000}], 
			pass_goods=[{7405006,3},{7405001,50}]
		};
get(5) -> #base_xian_upgrade{
			stage = 5,
			desc = "仙帝",
			attr = [{att,4080},{def,2040},{hp_lim,40820},{crit,900},{ten,820},{hit,820},{dodge,730}],
			condition = [{1, get_goods, 7405006, 80, "收集仙帝令，凝聚仙帝的力量，厚积薄发，冲击神子。"}, {2, kill_mon, 28006, 100, "神子有怒，四海皆危。用你的势力，震慑诸荒妖族吧！",10008}, {3, pass_dungeon, 12012, 1, "转眼三五甲子，颇有小成，去接收试练吧"}],
			drop_goods=[{7405007, 1, 5000}], 
			pass_goods=[{7405007,5},{7405001,60}]
		};
get(6) -> #base_xian_upgrade{
			stage = 6,
			desc = "神子",
			attr = [{att,8160},{def,4080},{hp_lim,81630},{crit,1800},{ten,1630},{hit,1630},{dodge,1470}],
			condition = [{1, get_goods, 7405007, 100, "收集神子令，凝聚神子的力量，厚积薄发，冲击天神。"}, {2, kill_mon, 28009, 100, "天神有怒，四海皆危。用你的势力，震慑诸荒妖族吧！",10008}, {3, pass_dungeon, 12013, 1, "转眼三五甲子，颇有小成，去接收试练吧"}],
			drop_goods=[{7405001, 100, 5000}], 
			pass_goods=[{7405001,500}]
		};
get(7) -> #base_xian_upgrade{
			stage = 7,
			desc = "天神",
			attr = [{att,12240},{def,6120},{hp_lim,122450},{crit,2690},{ten,2450},{hit,2450},{dodge,2200}],
			condition = [],
			drop_goods=[], 
			pass_goods=[]
		};
get(_stage) -> [].

