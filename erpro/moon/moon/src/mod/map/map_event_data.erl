%%----------------------------------------------------
%% 地图事件数据 
%% @author abu
%%----------------------------------------------------
-module(map_event_data).

-export([get/1]).

-include("gain.hrl").

get(400)->
	[ 		{[{kill_all_npc, 30066}],[{remove_elem, 3},{enable_npc, 30069}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{kill_npc, 30069}],[{remove_elem, 5},{enable_npc, 30070}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{clear_npc}],[{dungeon_event, {dun_clear, 20001, 20}}],100,1,<<"">>}
	];
	
get(20012)->
	[ 		{[{kill_all_npc, 30071}],[{remove_elem, 3},{enable_npc, 30074}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{kill_all_npc, 30072}],[{remove_elem, 5},{enable_npc, 30075}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{clear_npc}],[{dungeon_event, {dun_clear, 20012, 21}}],100,1,<<"">>}
	];
	
get(20022)->
	[ 		{[{kill_all_npc, 30076}],[{remove_elem, 3},{enable_npc, 30079}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{kill_all_npc, 30077}],[{remove_elem, 5},{enable_npc, 30080}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{clear_npc}],[{dungeon_event, {dun_clear, 20022, 22}}],100,1,<<"">>}
	];
	
get(20032)->
	[ 		{[{kill_all_npc, 30081}],[{remove_elem, 3},{enable_npc, 30084}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{kill_all_npc, 30082}],[{remove_elem, 5},{enable_npc, 30085}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{clear_npc}],[{dungeon_event, {dun_clear, 20032, 23}}],100,1,<<"">>}
	];
	
get(20042)->
	[ 		{[{kill_all_npc, 30086}],[{remove_elem, 3},{enable_npc, 30089}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{kill_all_npc, 30087}],[{remove_elem, 5},{enable_npc, 30090}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{clear_npc}],[{dungeon_event, {dun_clear, 20042, 24}}],100,1,<<"">>}
	];
	
get(20052)->
	[ 		{[{kill_all_npc, 30097}],[{remove_elem, 3},{enable_npc, 30100}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{kill_all_npc, 30098}],[{remove_elem, 5},{enable_npc, 30101}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{clear_npc}],[{dungeon_event, {dun_clear, 20052, 25}}],100,1,<<"">>}
	];
	
get(20062)->
	[ 		{[{kill_all_npc, 30107}],[{remove_elem, 3},{enable_npc, 30110}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{kill_all_npc, 30108}],[{remove_elem, 5},{enable_npc, 30111}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{clear_npc}],[{dungeon_event, {dun_clear, 20062, 26}}],100,1,<<"">>}
	];
	
get(20100)->
	[ 		{[{clear_npc}],[{create_npc, 30054, 1600, 900}],100,1,<<"随着小妖倒下玄冰妖出现在镇妖塔，塔内空气仿佛都要被他身上的寒气所冻结。">>},
	 		{[{kill_npc, 30054}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第二层">>, 2152, 600, <<>>, {20101, 1150, 1550}},{dun_reward, [{tower, 1}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20100, 30}},{dun_kill_npc}],100,1,<<"镇妖塔第二层已开启">>}
	];
	
get(20101)->
	[ 		{[{clear_npc}],[{create_npc, 30055, 1600, 900}],100,1,<<"突然感觉镇妖塔内温度骤升，原来是赤炎羽趁你不备出现在身后。">>},
	 		{[{kill_npc, 30055}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第三层">>, 2152, 600, <<>>, {20102, 1150, 1550}},{dun_reward, [{tower, 2}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20101, 31}},{dun_kill_npc}],100,1,<<"镇妖塔第三层已开启">>}
	];
	
get(20102)->
	[ 		{[{clear_npc}],[{create_npc, 30056, 1600, 900}],100,1,<<"顺着小怪不甘的眼神你发现在此层还躲藏着一个强大的妖物，正是传说中的流萤雪。">>},
	 		{[{kill_npc, 30056}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第四层">>, 2152, 600, <<>>, {20103, 1150, 1550}},{dun_reward, [{tower, 3}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20102, 32}},{dun_kill_npc}],100,1,<<"镇妖塔第四层已开启">>}
	];
	
get(20103)->
	[ 		{[{clear_npc}],[{create_npc, 30057, 1600, 900}],100,1,<<"看似你已消灭了此层妖物，镇妖塔深处却传来阴森的笑声，一个绿色的身影逐渐显现。">>},
	 		{[{kill_npc, 30057}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第五层">>, 2152, 600, <<>>, {20104, 1150, 1550}},{dun_reward, [{tower, 4}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20103, 33}} ,{dun_kill_npc}],100,1,<<"镇妖塔第五层已开启">>}
	];
	
get(20104)->
	[ 		{[{clear_npc}],[{create_npc, 30058, 1600, 900}],100,1,<<"眼看妖物要被消灭一空，镇妖塔内寒光乍起，原来是罡少白手持利刃向你冲来。">>},
	 		{[{kill_npc, 30058}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第六层">>, 2152, 600, <<>>, {20105, 1150, 1550}},{dun_reward, [{tower, 5}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20104, 34}} ,{dun_kill_npc}],100,1,<<"镇妖塔第六层已开启">>}
	];
	
get(20105)->
	[ 		{[{clear_npc}],[{create_npc, 30059, 1600, 900}],100,1,<<"不知何时镇妖塔内出现一道婀娜的身影，凝神细看却是只带刺的花妖。">>},
	 		{[{kill_npc, 30059}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第七层">>, 2152, 600, <<>>, {20106, 1150, 1550}},{dun_reward, [{tower, 6}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20105, 35}} ,{dun_kill_npc}],100,1,<<"镇妖塔第七层已开启">>}
	];
	
get(20106)->
	[ 		{[{clear_npc}],[{create_npc, 30060, 1600, 900}],100,1,<<"正享受着胜利的喜悦，突然镇妖塔内又出现一只手持巨斧的妖物，它竟然没有头。">>},
	 		{[{kill_npc, 30060}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第八层">>, 2152, 600, <<>>, {20107, 1150, 1550}},{dun_reward, [{tower, 7}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20106, 36}} ,{dun_kill_npc}],100,1,<<"镇妖塔第八层已开启">>}
	];
	
get(20107)->
	[ 		{[{clear_npc}],[{create_npc, 30061, 1600, 900}],100,1,<<"这场战斗你饱受雷鸣电闪的干扰，待清理完小妖后才看清有个鸟人在作乱。">>},
	 		{[{kill_npc, 30061}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第九层">>, 2152, 600, <<>>, {20108, 1150, 1550}},{dun_reward, [{tower, 8}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20107, 37}}  ,{dun_kill_npc}],100,1,<<"镇妖塔第九层已开启">>}
	];
	
get(20108)->
	[ 		{[{clear_npc}],[{create_npc, 30062, 1600, 900}],100,1,<<"整个镇妖塔在强烈震动，原来是巨灵天正锤击地面妄图突破此层的封印，快去阻止它。">>},
	 		{[{kill_npc, 30062}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第十层">>, 2152, 600, <<>>, {20109, 1150, 1550}},{dun_reward, [{tower, 9}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20108, 38}} ,{dun_kill_npc}],100,1,<<"镇妖塔第十层已开启">>}
	];
	
get(20109)->
	[ 		{[{clear_npc}],[{create_npc, 30063, 1600, 900}],100,1,<<"此层小妖已被你杀的溃不成军，突然剑气四起，塔内一片寂静，原来是绝地王现身。">>},
	 		{[{kill_npc, 30063}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第十一层">>, 2152, 600, <<>>, {20110, 1150, 1550}},{dun_reward, [{tower, 10}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20109, 39}} ,{dun_kill_npc}],100,1,<<"镇妖塔第十一层已开启">>}
	];
	
get(20110)->
	[ 		{[{clear_npc}],[{create_npc, 30064, 1600, 900}],100,1,<<"一声巨响，破天王将手中灵宝向你掷出，幸好你躲闪及时。">>},
	 		{[{kill_npc, 30064}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第十二层">>, 2152, 600, <<>>, {20111, 1150, 1550}},{dun_reward, [{tower, 11}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20110, 40}} ,{dun_kill_npc}],100,1,<<"镇妖塔第十二层已开启">>}
	];
	
get(20111)->
	[ 		{[{clear_npc}],[{create_npc, 30065, 1600, 900}],100,1,<<"你的辉煌战绩引起了镇妖塔灵的重视，它的化身即将降临镇妖塔，望小心应对。">>},
	 		{[{kill_npc, 30065}],[{dun_reward, [{tower, 12}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20111, 41}} ,{dun_kill_npc},{dungeon_event, {level_dun_unlock, 20101}}],100,1,<<"">>}
	];
	
get(20003)->
	[ 		{[{kill_npc, 30015}],[{enable_npc, 30016},{remove_elem, 15}],100,1,<<"魔岩已被收服">>},
	 		{[{kill_npc, 30016}],[{enable_npc, 30017},{remove_elem, 16}],100,1,<<"魔岩已被收服">>},
	 		{[{clear_npc}],[{dungeon_event, {dun_clear, 20003, 2}} ],100,1,<<"">>}
	];
	
get(20004)->
	[ 		{[{kill_npc, 30009}],[{enable_npc, 30010},{remove_elem, 10}],100,1,<<"幻之花已消散">>},
	 		{[{kill_npc, 30010}],[{enable_npc, 30011},{remove_elem, 12}],100,1,<<"幻之花已消散">>},
	 		{[{clear_npc}],[{dungeon_event, {dun_clear, 20004, 3}} ],100,1,<<"">>}
	];
	
get(20005)->
	[ 		{[{kill_npc, 30021}],[{enable_npc, 30022},{remove_elem, 2}],100,1,<<"神秘突泉已消失">>},
	 		{[{kill_npc, 30022}],[{enable_npc, 30023},{remove_elem, 4}],100,1,<<"神秘突泉已消失">>},
	 		{[{clear_npc}],[{dungeon_event, {dun_clear, 20005, 4}} ],100,1,<<"">>}
	];
	
get(20006)->
	[ 		{[{kill_npc, 30027}],[{enable_npc, 30028},{remove_elem, 1}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{kill_npc, 30028}],[{enable_npc, 30029},{remove_elem, 2}],100,1,<<"妖之迷雾已烟消云散">>},
	 		{[{clear_npc}],[{dungeon_event, {dun_clear, 20006, 5}} ],100,1,<<"">>}
	];
	
get(20007)->
	[ 		{[{kill_npc, 30094}],[{enable_npc, 30095},{remove_elem, 60283}],100,1,<<"">>},
	 		{[{kill_npc, 30095}],[{enable_npc, 30096},{remove_elem, 60284}],100,1,<<"">>},
	 		{[{clear_npc}],[{dungeon_event, {dun_clear, 20007, 20007}} ],100,1,<<"">>}
	];
	
get(20001)->
	[ 		{[{kill_npc, 30003}],[{enable_npc, 30004}],100,1,<<"蟹将军已被惊动">>},
	 		{[{kill_npc, 30004}],[{enable_npc, 30005}],100,1,<<"恶蛟本尊已从沉睡中醒来">>},
	 		{[{kill_npc, 30003}],[{create_elem, 602211, 60221, 0, 1680, 1680, <<"">>},{create_elem, 602212, 60221, 0, 1500, 1410, <<"">>},{create_elem, 602213, 60221, 0, 1260, 1290, <<"">>},{remove_elem, 602181},{remove_elem, 602182},{remove_elem, 602191},{remove_elem, 602183},{remove_elem, 602192}],100,1,<<"">>},
	 		{[{kill_npc, 30004}],[{create_elem, 602221, 60222, 0, 961, 1169, <<"">>},{create_elem, 602222, 60222, 0, 721, 1130, <<"">>},{create_elem, 602201, 60220, 0, 584, 905, <<"">>},{remove_elem, 602211},{remove_elem, 602212},{remove_elem, 602213}],100,1,<<"">>},
	 		{[{kill_npc, 30005}],[{create_elem, 602184, 60218, 0, 735, 650, <<"">>},{remove_elem, 602221},{remove_elem, 602222},{remove_elem, 602201}],100,1,<<"">>}
	];
	
get(20201)->
	[ 		{[{kill_npc, 20155}],[{dungeon_event, {level_dun_unlock, 20202}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20201, 20201}},{dungeon_event, {clear_level}}],100,1,<<"">>}
	];
	
get(20202)->
	[ 		{[{kill_npc, 20157}],[{dungeon_event, {level_dun_unlock, 20203}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20202, 20202}},{dungeon_event, {clear_level}}],100,1,<<"">>}
	];
	
get(20203)->
	[ 		{[{kill_npc, 20156}],[{dungeon_event, {level_dun_unlock, 20204}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20203, 20203}},{dungeon_event, {clear_level}}],100,1,<<"">>}
	];
	
get(20204)->
	[ 		{[{kill_npc, 20159}],[{dungeon_event, {level_dun_unlock, 20205}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20204, 20204}},{dungeon_event, {clear_level}}],100,1,<<"">>}
	];
	
get(20205)->
	[ 		{[{kill_npc, 20160}],[{dungeon_event, {level_dun_unlock, 20206}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20205, 20205}},{dungeon_event, {clear_level}}],100,1,<<"">>}
	];
	
get(20206)->
	[ 		{[{kill_npc, 20167}],[{dungeon_event, {level_dun_unlock, 20207}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20206, 20206}},{dungeon_event, {clear_level}}],100,1,<<"">>}
	];
	
get(20207)->
	[ 		{[{kill_npc, 20169}],[{dungeon_event, {level_dun_unlock, 20208}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20207, 20207}},{dungeon_event, {clear_level}}],100,1,<<"">>}
	];
	
get(20208)->
	[ 		{[{kill_npc, 20165}],[{dungeon_event, {level_dun_unlock, 20209}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20208, 20208}},{dungeon_event, {clear_level}}],100,1,<<"">>}
	];
	
get(20209)->
	[ 		{[{kill_npc, 20164}],[{dungeon_event, {level_dun_unlock, 20210}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20209, 20209}},{dungeon_event, {clear_level}}],100,1,<<"">>}
	];
	
get(20210)->
	[ 		{[{kill_npc, 20171}],[{dungeon_event, {level_dun_unlock, 20211}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20210, 20210}},{dungeon_event, {clear_level}}],100,1,<<"">>}
	];
	
get(20211)->
	[ 		{[{kill_npc, 20174}],[{dungeon_event, {level_dun_unlock, 20212}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20211, 20211}},{dungeon_event, {clear_level}}],100,1,<<"">>}
	];
	
get(20212)->
	[ 		{[{kill_npc, 20175}],[{dungeon_event, {level_dun_unlock, 20213}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20212, 20212}},{dungeon_event, {clear_level}}],100,1,<<"">>}
	];
	
get(20213)->
	[ 		{[{kill_npc, 20270}],[{dungeon_event, {level_dun_unlock, 20214}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20213, 20213}},{dungeon_event, {clear_level}},{remove_elem, 2}],100,1,<<"">>}
	];
	
get(20214)->
	[ 		{[{kill_npc, 20276}],[{remove_elem, 1},{remove_elem, 8},{enable_elem, 60549}],100,1,<<"凭着坚强的意志，你成功地战胜了仇恨心魔，更强大的贪念心魔出现了">>},
	 		{[{kill_npc, 20277}],[{remove_elem, 2},{remove_elem, 9},{enable_elem, 60550}],100,1,<<"凭着无坚不摧的意志，你成功地战胜了贪念心魔，更强大的怨念心魔出现了">>},
	 		{[{kill_npc, 20278}],[{dungeon_event, {level_dun_unlock, 20215}},{dungeon_event, {clear_rewards}},{dungeon_event, {dun_clear, 20214, 20214}},{dungeon_event, {clear_level}},{remove_elem, 3},{remove_elem, 4},{remove_elem, 10},{enable_elem, 60545}],100,1,<<"你成功地战胜了怨念心魔，只见宝箱发出耀眼的光芒">>},
	 		{[{kill_npc, 20282}],[{remove_elem, 5}],100,1,<<"">>}
	];
	
get(20300)->
	[ 		{[{clear_npc}],[{create_npc, 25038, 840, 960}],100,1,<<"随着最后一只妖兽倒下，龙宫中出现了重明鸟的身影">>},
	 		{[{kill_npc, 25038}],[{create_dun_tele, 2, 60001, <<"通往第二层">>, 1601, 653, <<>>, {20301, 540, 1080}},{dun_reward, [{tower, 1}]},{dungeon_event, {dun_clear, 20300, 2}} ,{dun_kill_npc}],100,1,<<"洛水龙宫二层已开启">>}
	];
	
get(20301)->
	[ 		{[{clear_npc}],[{create_npc, 25039, 1440, 660}],100,1,<<"看到手下被屠戮一尽地狱战神发出阵阵怒吼">>},
	 		{[{kill_npc, 25039}],[{create_dun_tele, 2, 60001, <<"通往第三层">>, 1668, 556, <<>>, {20302, 420, 1260}},{dun_reward, [{tower, 2}]},{dungeon_event, {dun_clear, 20301, 2}} ,{dun_kill_npc}],100,1,<<"洛水龙宫三层已开启">>}
	];
	
get(20302)->
	[ 		{[{clear_npc}],[{create_npc, 25040, 840, 960}],100,1,<<"你们的战斗已打破了龙宫三层的安宁，神兽毕方已经被惊动">>},
	 		{[{kill_npc, 25040}],[{create_dun_tele, 2, 60001, <<"通往第四层">>, 1601, 653, <<>>, {20303, 540, 1080}},{dun_reward, [{tower, 3}]},{dungeon_event, {dun_clear, 20302, 2}} ,{dun_kill_npc}],100,1,<<"洛水龙宫四层已开启">>}
	];
	
get(20303)->
	[ 		{[{clear_npc}],[{create_npc, 25041, 1440, 660}],100,1,<<"对于你们的闯入开明兽貌似无动于衷，用不屑的眼神看着你们">>},
	 		{[{kill_npc, 25041}],[{create_dun_tele, 2, 60001, <<"通往第五层">>, 1668, 556, <<>>, {20304, 420, 1260}},{dun_reward, [{tower, 4}]},{dungeon_event, {dun_clear, 20303, 2}} ,{dun_kill_npc}],100,1,<<"洛水龙宫五层已开启">>}
	];
	
get(20304)->
	[ 		{[{clear_npc}],[{create_npc, 25042, 840, 960}],100,1,<<"后土看到自己的手下纷纷倒下终于忍不住出手了">>},
	 		{[{kill_npc, 25042}],[{create_dun_tele, 2, 60001, <<"通往第六层">>, 1601, 653, <<>>, {20305, 540, 1080}},{dun_reward, [{tower, 5}]},{dungeon_event, {dun_clear, 20304, 2}} ,{dun_kill_npc}],100,1,<<"洛水龙宫六层已开启">>}
	];
	
get(20305)->
	[ 		{[{clear_npc}],[{create_npc, 25043, 1440, 660}],100,1,<<"离朱对于你们的闯入出奇地愤怒，准备承受他的怒火吧">>},
	 		{[{kill_npc, 25043}],[{create_dun_tele, 2, 60001, <<"通往第七层">>, 1668, 556, <<>>, {20306, 420, 1260}},{dun_reward, [{tower, 6}]},{dungeon_event, {dun_clear, 20305, 2}} ,{dun_kill_npc}],100,1,<<"洛水龙宫七层已开启">>}
	];
	
get(20306)->
	[ 		{[{clear_npc}],[{create_npc, 25044, 840, 960}],100,1,<<"墨云裂齿龙睡眼朦胧地看着你们，貌似对你们丝毫不敢兴趣">>},
	 		{[{kill_npc, 25044}],[{create_dun_tele, 2, 60001, <<"通往第八层">>, 1601, 653, <<>>, {20307, 540, 1080}},{dun_reward, [{tower, 7}]},{dungeon_event, {dun_clear, 20306, 2}} ,{dun_kill_npc}],100,1,<<"洛水龙宫八层已开启">>}
	];
	
get(20307)->
	[ 		{[{clear_npc}],[{create_npc, 25045, 1440, 660}],100,1,<<"地狱魔将正擦拭着自己心爱的宝刀，估计接下来要有一场恶战">>},
	 		{[{kill_npc, 25045}],[{create_dun_tele, 2, 60001, <<"通往第九层">>, 1668, 556, <<>>, {20308, 420, 1260}},{dun_reward, [{tower, 8}]},{dungeon_event, {dun_clear, 20307, 2}} ,{dun_kill_npc}],100,1,<<"洛水龙宫九层已开启">>}
	];
	
get(20308)->
	[ 		{[{clear_npc}],[{create_npc, 25046, 840, 960}],100,1,<<"青猿妖圣正摩拳擦掌严阵以待，貌似已经习惯了强者的挑战">>},
	 		{[{kill_npc, 25046}],[{create_dun_tele, 2, 60001, <<"通往第十层">>, 1601, 653, <<>>, {20309, 540, 1080}},{dun_reward, [{tower, 9}]},{dungeon_event, {dun_clear, 20308, 2}} ,{dun_kill_npc}],100,1,<<"洛水龙宫十层已开启">>}
	];
	
get(20309)->
	[ 		{[{clear_npc}],[{create_npc, 25047, 1440, 660}],100,1,<<"龙族的威严是不能被挑战的，裂齿狂龙觉得你们已经超越了他的底线。">>},
	 		{[{kill_npc, 25047}],[{create_dun_tele, 2, 60001, <<"通往第十一层">>, 1668, 556, <<>>, {20310, 420, 1260}},{dun_reward, [{tower, 10}]},{dungeon_event, {dun_clear, 20309, 2}} ,{dun_kill_npc}],100,1,<<"洛水龙宫十一层已开启">>}
	];
	
get(20310)->
	[ 		{[{clear_npc}],[{create_npc, 25048, 840, 960}],100,1,<<"既然已经到了这一步就要有死的觉悟，接受来自金角大王的怒火吧">>},
	 		{[{kill_npc, 25048}],[{create_dun_tele, 2, 60001, <<"通往第十二层">>, 1620, 600, <<>>, {20311, 540, 1080}},{dun_reward, [{tower, 11}]},{dungeon_event, {dun_clear, 20310, 2}} ,{dun_kill_npc}],100,1,<<"洛水龙宫十二层已开启">>}
	];
	
get(20311)->
	[ 		{[{clear_npc}],[{create_npc, 25049, 1440, 660}],100,1,<<"强者并非毫无弱点，烈焰战魂正慎重地打量着你们，好像看出了什么破绽">>},
	 		{[{kill_npc, 25049}],[{dun_reward, [{tower, 12}]},{dungeon_event, {dun_clear, 20311, 61}} ,{dun_kill_npc},{dungeon_event, {level_dun_unlock, 20301}}],100,1,<<"">>}
	];
	
get(20401)->
	[ 		{[{clear_npc}],[{create_npc, 24050, 1600, 900}],100,1,<<"随着小妖倒下玄冰妖出现在镇妖塔，塔内空气仿佛都要被他身上的寒气所冻结。">>},
	 		{[{kill_npc, 24050}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第二层">>, 2152, 600, <<>>, {20402, 1150, 1550}},{dun_reward, [{tower, 1}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20401, 50}},{dun_kill_npc}],100,1,<<"里·镇妖塔第二层已开启">>}
	];
	
get(20402)->
	[ 		{[{clear_npc}],[{create_npc, 24051, 1600, 900}],100,1,<<"突然感觉镇妖塔内温度骤升，原来是赤炎羽趁你不备出现在身后。">>},
	 		{[{kill_npc, 24051}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第三层">>, 2152, 600, <<>>, {20403, 1150, 1550}},{dun_reward, [{tower, 2}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20402, 51}},{dun_kill_npc}],100,1,<<"里·镇妖塔第三层已开启">>}
	];
	
get(20403)->
	[ 		{[{clear_npc}],[{create_npc, 24052, 1600, 900}],100,1,<<"顺着小怪不甘的眼神你发现在此层还躲藏着一个强大的妖物，正是传说中的流萤雪。">>},
	 		{[{kill_npc, 24052}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第四层">>, 2152, 600, <<>>, {20404, 1150, 1550}},{dun_reward, [{tower, 3}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20403, 52}},{dun_kill_npc}],100,1,<<"里·镇妖塔第四层已开启">>}
	];
	
get(20404)->
	[ 		{[{clear_npc}],[{create_npc, 24053, 1600, 900}],100,1,<<"看似你已消灭了此层妖物，镇妖塔深处却传来阴森的笑声，一个绿色的身影逐渐显现。">>},
	 		{[{kill_npc, 24053}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第五层">>, 2152, 600, <<>>, {20405, 1150, 1550}},{dun_reward, [{tower, 4}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20404, 53}},{dun_kill_npc}],100,1,<<"里·镇妖塔第五层已开启">>}
	];
	
get(20405)->
	[ 		{[{clear_npc}],[{create_npc, 24054, 1600, 900}],100,1,<<"眼看妖物要被消灭一空，镇妖塔内寒光乍起，原来是罡少白手持利刃向你冲来。">>},
	 		{[{kill_npc, 24054}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第六层">>, 2152, 600, <<>>, {20406, 1150, 1550}},{dun_reward, [{tower, 5}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20405, 54}},{dun_kill_npc}],100,1,<<"里·镇妖塔第六层已开启">>}
	];
	
get(20406)->
	[ 		{[{clear_npc}],[{create_npc, 24055, 1600, 900}],100,1,<<"不知何时镇妖塔内出现一道婀娜的身影，凝神细看却是只带刺的花妖。">>},
	 		{[{kill_npc, 24055}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第七层">>, 2152, 600, <<>>, {20407, 1150, 1550}},{dun_reward, [{tower, 6}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20406, 55}},{dun_kill_npc}],100,1,<<"里·镇妖塔第七层已开启">>},
	 		{[{kill_npc, 24055}],[{create_npc, 11203, 1560, 960}],50,1,<<"阴森诡异的里·镇妖塔中原来囚禁着秘宝商人，为答谢勇士决定低价出手一批商品">>}
	];
	
get(20407)->
	[ 		{[{clear_npc}],[{create_npc, 24056, 1600, 900}],100,1,<<"正享受着胜利的喜悦，突然镇妖塔内又出现一只手持巨斧的妖物，它竟然没有头。">>},
	 		{[{kill_npc, 24056}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第八层">>, 2152, 600, <<>>, {20408, 1150, 1550}},{dun_reward, [{tower, 7}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20407, 56}},{dun_kill_npc}],100,1,<<"里·镇妖塔第八层已开启">>}
	];
	
get(20408)->
	[ 		{[{clear_npc}],[{create_npc, 24057, 1600, 900}],100,1,<<"这场战斗你饱受雷鸣电闪的干扰，待清理完小妖后才看清有个鸟人在作乱。">>},
	 		{[{kill_npc, 24057}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第九层">>, 2152, 600, <<>>, {20409, 1150, 1550}},{dun_reward, [{tower, 8}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20408, 57}},{dun_kill_npc}],100,1,<<"里·镇妖塔第九层已开启">>}
	];
	
get(20409)->
	[ 		{[{clear_npc}],[{create_npc, 24058, 1600, 900}],100,1,<<"整个镇妖塔在强烈震动，原来是巨灵天正锤击地面妄图突破此层的封印，快去阻止它。">>},
	 		{[{kill_npc, 24058}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第十层">>, 2152, 600, <<>>, {20410, 1150, 1550}},{dun_reward, [{tower, 9}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20409, 58}},{dun_kill_npc}],100,1,<<"里·镇妖塔第十层已开启">>},
	 		{[{kill_npc, 24058}],[{create_npc, 11203, 1560, 960}],100,1,<<"阴森诡异的里·镇妖塔中原来囚禁着秘宝商人，为答谢勇士决定低价出手一批商品">>}
	];
	
get(20410)->
	[ 		{[{clear_npc}],[{create_npc, 24059, 1600, 900}],100,1,<<"此层小妖已被你杀的溃不成军，突然剑气四起，塔内一片寂静，原来是绝地王现身。">>},
	 		{[{kill_npc, 24059}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第十一层">>, 2152, 600, <<>>, {20411, 1150, 1550}},{dun_reward, [{tower, 10}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20410, 59}},{dun_kill_npc}],100,1,<<"里·镇妖塔第十一层已开启">>}
	];
	
get(20411)->
	[ 		{[{clear_npc}],[{create_npc, 24060, 1600, 900}],100,1,<<"一声巨响，破天王将手中灵宝向你掷出，幸好你躲闪及时。">>},
	 		{[{kill_npc, 24060}],[{remove_elem, 3},{create_dun_tele, 2, 60001, <<"通往第十二层">>, 2152, 600, <<>>, {20412, 1150, 1550}},{dun_reward, [{tower, 11}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20411, 60}},{dun_kill_npc}],100,1,<<"里·镇妖塔第十二层已开启">>}
	];
	
get(20412)->
	[ 		{[{clear_npc}],[{create_npc, 24061, 1600, 900}],100,1,<<"你的辉煌战绩引起了镇妖塔灵的重视，它的化身即将降临镇妖塔，望小心应对。">>},
	 		{[{kill_npc, 24061}],[{dun_reward, [{tower, 12}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20412, 61}} ,{dun_kill_npc}],100,1,<<"">>},
	 		{[{kill_npc, 24061}],[{create_npc, 11203, 1560, 960}],100,1,<<"阴森诡异的里·镇妖塔中原来囚禁着秘宝商人，为答谢勇士决定低价出手一批商品">>}
	];
	
get(20501)->
	[ 		{[{clear_npc}],[{create_npc, 24150, 840, 960}],100,1,<<"随着最后一只妖兽倒下，龙宫中出现了重明鸟的身影">>},
	 		{[{kill_npc, 24150}],[{create_dun_tele, 2, 60001, <<"通往第二层">>, 1601, 653, <<>>, {20502, 540, 1080}},{dun_reward, [{tower, 1}]},{dungeon_event, {dun_clear, 20501, 2}} ,{dun_kill_npc}],100,1,<<"里·洛水龙宫二层已开启">>}
	];
	
get(20502)->
	[ 		{[{clear_npc}],[{create_npc, 24151, 1440, 660}],100,1,<<"看到手下被屠戮一尽地狱战神发出阵阵怒吼">>},
	 		{[{kill_npc, 24151}],[{create_dun_tele, 2, 60001, <<"通往第三层">>, 1668, 556, <<>>, {20503, 420, 1260}},{dun_reward, [{tower, 2}]},{dungeon_event, {dun_clear, 20502, 2}} ,{dun_kill_npc}],100,1,<<"里·洛水龙宫三层已开启">>}
	];
	
get(20503)->
	[ 		{[{clear_npc}],[{create_npc, 24152, 840, 960}],100,1,<<"你们的战斗已打破了龙宫三层的安宁，神兽毕方已经被惊动">>},
	 		{[{kill_npc, 24152}],[{create_dun_tele, 2, 60001, <<"通往第四层">>, 1601, 653, <<>>, {20504, 540, 1080}},{dun_reward, [{tower, 3}]},{dungeon_event, {dun_clear, 20503, 2}} ,{dun_kill_npc}],100,1,<<"里·洛水龙宫四层已开启">>}
	];
	
get(20504)->
	[ 		{[{clear_npc}],[{create_npc, 24153, 1440, 660}],100,1,<<"对于你们的闯入开明兽貌似无动于衷，用不屑的眼神看着你们">>},
	 		{[{kill_npc, 24153}],[{create_dun_tele, 2, 60001, <<"通往第五层">>, 1668, 556, <<>>, {20505, 420, 1260}},{dun_reward, [{tower, 4}]},{dungeon_event, {dun_clear, 20504, 2}} ,{dun_kill_npc}],100,1,<<"里·洛水龙宫五层已开启">>}
	];
	
get(20505)->
	[ 		{[{clear_npc}],[{create_npc, 24154, 840, 960}],100,1,<<"后土看到自己的手下纷纷倒下终于忍不住出手了">>},
	 		{[{kill_npc, 24154}],[{create_dun_tele, 2, 60001, <<"通往第六层">>, 1601, 653, <<>>, {20506, 540, 1080}},{dun_reward, [{tower, 5}]},{dungeon_event, {dun_clear, 20505, 2}} ,{dun_kill_npc}],100,1,<<"里·洛水龙宫六层已开启">>}
	];
	
get(20506)->
	[ 		{[{clear_npc}],[{create_npc, 24155, 1440, 660}],100,1,<<"离朱对于你们的闯入出奇地愤怒，准备承受他的怒火吧">>},
	 		{[{kill_npc, 24155}],[{create_dun_tele, 2, 60001, <<"通往第七层">>, 1668, 556, <<>>, {20507, 420, 1260}},{dun_reward, [{tower, 6}]},{dungeon_event, {dun_clear, 20506, 2}} ,{dun_kill_npc}],100,1,<<"里·洛水龙宫七层已开启">>},
	 		{[{kill_npc, 24155}],[{create_npc, 11203, 1080, 750}],100,1,<<"阴森诡异的里·洛水龙宫中原来囚禁着秘宝商人，为答谢勇士决定低价出手一批商品">>}
	];
	
get(20507)->
	[ 		{[{clear_npc}],[{create_npc, 24156, 840, 960}],100,1,<<"墨云裂齿龙睡眼朦胧地看着你们，貌似对你们丝毫不敢兴趣">>},
	 		{[{kill_npc, 24156}],[{create_dun_tele, 2, 60001, <<"通往第八层">>, 1601, 653, <<>>, {20508, 540, 1080}},{dun_reward, [{tower, 7}]},{dungeon_event, {dun_clear, 20507, 2}} ,{dun_kill_npc}],100,1,<<"里·洛水龙宫八层已开启">>}
	];
	
get(20508)->
	[ 		{[{clear_npc}],[{create_npc, 24157, 1440, 660}],100,1,<<"地狱魔将正擦拭着自己心爱的宝刀，估计接下来要有一场恶战">>},
	 		{[{kill_npc, 24157}],[{create_dun_tele, 2, 60001, <<"通往第九层">>, 1668, 556, <<>>, {20509, 420, 1260}},{dun_reward, [{tower, 8}]},{dungeon_event, {dun_clear, 20508, 2}} ,{dun_kill_npc}],100,1,<<"里·洛水龙宫九层已开启">>}
	];
	
get(20509)->
	[ 		{[{clear_npc}],[{create_npc, 24158, 840, 960}],100,1,<<"青猿妖圣正摩拳擦掌严阵以待，貌似已经习惯了强者的挑战">>},
	 		{[{kill_npc, 24158}],[{create_dun_tele, 2, 60001, <<"通往第十层">>, 1601, 653, <<>>, {20510, 540, 1080}},{dun_reward, [{tower, 9}]},{dungeon_event, {dun_clear, 20509, 2}} ,{dun_kill_npc}],100,1,<<"里·洛水龙宫十层已开启">>},
	 		{[{kill_npc, 24158}],[{create_npc, 11203, 900, 840}],100,1,<<"阴森诡异的里·洛水龙宫中原来囚禁着秘宝商人，为答谢勇士决定低价出手一批商品">>}
	];
	
get(20510)->
	[ 		{[{clear_npc}],[{create_npc, 24159, 1440, 660}],100,1,<<"龙族的威严是不能被挑战的，裂齿狂龙觉得你们已经超越了他的底线。">>},
	 		{[{kill_npc, 24159}],[{create_dun_tele, 2, 60001, <<"通往第十一层">>, 1668, 556, <<>>, {20511, 420, 1260}},{dun_reward, [{tower, 10}]},{dungeon_event, {dun_clear, 20510, 2}} ,{dun_kill_npc}],100,1,<<"里·洛水龙宫十一层已开启">>}
	];
	
get(20511)->
	[ 		{[{clear_npc}],[{create_npc, 24160, 840, 960}],100,1,<<"既然已经到了这一步就要有死的觉悟，接受来自金角大王的怒火吧">>},
	 		{[{kill_npc, 24160}],[{create_dun_tele, 2, 60001, <<"通往第十二层">>, 1620, 600, <<>>, {20512, 540, 1080}},{dun_reward, [{tower, 11}]},{dungeon_event, {dun_clear, 20511, 2}} ,{dun_kill_npc}],100,1,<<"里·洛水龙宫十二层已开启">>}
	];
	
get(20512)->
	[ 		{[{clear_npc}],[{create_npc, 24161, 1440, 660}],100,1,<<"强者并非毫无弱点，烈焰战魂正慎重地打量着你们，好像看出了什么破绽">>},
	 		{[{kill_npc, 24161}],[{dun_reward, [{tower, 12}]},{dungeon_event, {dun_clear, 20512, 62}} ,{dun_kill_npc}],100,1,<<"">>},
	 		{[{kill_npc, 24161}],[{create_npc, 11203, 1080, 750}],100,1,<<"阴森诡异的里·洛水龙宫中原来囚禁着秘宝商人，为答谢勇士决定低价出手一批商品">>}
	];
	
get(20601)->
	[ 		{[{clear_npc}],[{create_npc, 24201, 1206, 634},{remove_elem, 60409}],100,1,<<"铜力士在你们犀利的攻击下土崩瓦解，此时从中央剑阵传来一阵娇喝！一道飒爽的英姿出现在阵法中央。">>},
	 		{[{kill_npc, 24201}],[{create_dun_tele, 2, 60002, <<"通往幻.木之幻境">>, 1891, 236, <<>>, {20602, 540, 1140}},{dun_reward, [{tower, 1}]},{dun_kill_npc},{remove_elem, 60410},{remove_elem, 604101}],100,1,<<"随着幻.剑舞倾城的消失，结界的尽头出现一个传送阵。">>}
	];
	
get(20602)->
	[ 		{[{clear_npc}],[{create_npc, 24202, 1205, 688},{remove_elem, 60413}],100,1,<<"草木精果然不堪一击，不过随着一道清丽的身影出现他们顿时生龙活虎。">>},
	 		{[{kill_npc, 24202}],[{create_dun_tele, 2, 60002, <<"通往幻.水之幻境">>, 1793, 334, <<>>, {20603, 420, 1110}},{dun_reward, [{tower, 2}]},{dun_kill_npc},{remove_elem, 60412}],100,1,<<"随着幻.弓腰姬的消失，结界的尽头出现一个传送阵。">>}
	];
	
get(20603)->
	[ 		{[{clear_npc}],[{create_npc, 24203, 1102, 692},{remove_elem, 60417}],100,1,<<"在看似平静的湖面终于出现一个少女的身影，她对你们投来好奇的目光。">>},
	 		{[{kill_npc, 24203}],[{create_dun_tele, 2, 60002, <<"通往幻.火之幻境">>, 1772, 240, <<>>, {20604, 540, 1140}},{dun_reward, [{tower, 3}]},{dun_kill_npc}],100,1,<<"随着幻.玲珑仙子的消失，结界的尽头出现一个传送阵。">>}
	];
	
get(20604)->
	[ 		{[{clear_npc}],[{create_npc, 24204, 1102, 692},{remove_elem, 60414}],100,1,<<"愤怒的火灵龙发出了最后的怒吼终于招来了此处的主宰-俏飞凰">>},
	 		{[{kill_npc, 24204}],[{create_dun_tele, 2, 60002, <<"通往幻.土之幻境">>, 1787, 271, <<>>, {20605, 540, 1170}},{dun_reward, [{tower, 4}]},{dun_kill_npc},{remove_elem, 60415}],100,1,<<"随着幻.俏飞凰的消失，结界的尽头出现一个传送阵。">>}
	];
	
get(20605)->
	[ 		{[{clear_npc}],[{create_npc, 24205, 1102, 692},{remove_elem, 60419}],100,1,<<"伴随着曼妙琴声一位绝色的少女出现在幻境中央，好似她并未感到你们的到来。">>},
	 		{[{kill_npc, 24205}],[{create_dun_tele, 2, 60002, <<"通往真.金之幻境">>, 1873, 278, <<>>, {20606, 600, 1140}},{dun_reward, [{tower, 5}]},{dun_kill_npc},{remove_elem, 60418}],100,1,<<"你终于将所有幻.精灵守护清除，真.精灵幻境的入口重临飞仙世界。">>}
	];
	
get(20606)->
	[ 		{[{clear_npc}],[{create_npc, 24206, 1206, 634},{remove_elem, 60409}],100,1,<<"精英.铜力士也不过如此！剑舞倾城的真身终于现身。">>},
	 		{[{kill_npc, 24206}],[{create_dun_tele, 2, 60002, <<"通往真.木之幻境">>, 1891, 236, <<>>, {20607, 540, 1140}},{dun_reward, [{tower, 6}]},{dun_kill_npc},{remove_elem, 60410},{remove_elem, 604101}],100,1,<<"随着真.剑舞倾城的消失，结界的尽头出现一个传送阵。">>}
	];
	
get(20607)->
	[ 		{[{clear_npc}],[{create_npc, 24207, 1205, 688},{remove_elem, 60413}],100,1,<<"精英.草木精也是不堪一击！弓腰姬真身终于现身。">>},
	 		{[{kill_npc, 24207}],[{create_dun_tele, 2, 60002, <<"通往真.水之幻境">>, 1793, 334, <<>>, {20608, 420, 1110}},{dun_reward, [{tower, 7}]},{dun_kill_npc},{remove_elem, 60412}],100,1,<<"随着真.弓腰姬的消失，结界的尽头出现一个传送阵。">>}
	];
	
get(20608)->
	[ 		{[{clear_npc}],[{create_npc, 24208, 1102, 692},{remove_elem, 60417}],100,1,<<"精英.水鳞兽也是不堪一击！玲珑仙子真身终于现身。">>},
	 		{[{kill_npc, 24208}],[{create_dun_tele, 2, 60002, <<"通往真.火之幻境">>, 1772, 240, <<>>, {20609, 540, 1140}},{dun_reward, [{tower, 8}]},{dun_kill_npc}],100,1,<<"随着真.玲珑仙子守护的消失，结界的尽头出现一个传送阵。">>}
	];
	
get(20609)->
	[ 		{[{clear_npc}],[{create_npc, 24209, 1102, 692},{remove_elem, 60414}],100,1,<<"精英.火灵龙也是不堪一击！俏飞凰真身终于现身。">>},
	 		{[{kill_npc, 24209}],[{create_dun_tele, 2, 60002, <<"通往真.土之幻境">>, 1787, 271, <<>>, {20610, 540, 1170}},{dun_reward, [{tower, 9}]},{dun_kill_npc},{remove_elem, 60415}],100,1,<<"随着真.俏飞凰的消失，结界的尽头出现一个传送阵。">>}
	];
	
get(20610)->
	[ 		{[{clear_npc}],[{create_npc, 24210, 1102, 692},{remove_elem, 60419}],100,1,<<"精英.岩力士也是不堪一击！梦语琴心真身终于现身。">>},
	 		{[{kill_npc, 24210}],[{dun_reward, [{tower, 10}]},{dun_kill_npc},{remove_elem, 60418}],100,1,<<"">>}
	];
	
get(20700)->
	[ 		{[{clear_npc}],[{create_npc, 30194, 1600, 900}],100,1,<<"随着小妖倒下玄冰妖出现在镇妖塔，塔内空气仿佛都要被他身上的寒气所冻结。">>},
	 		{[{kill_npc, 30194}],[{dun_reward, [{tower, 1}, #gain{label = activity, val = 8}]},{dungeon_event, {dun_clear, 20700, 30}},{dun_kill_npc}],100,1,<<"">>}
	];
	
get(20801)->
	[ 		{[{kill_npc, 20424}],[{enable_npc, 20421},{remove_elem, 6}],100,1,<<"气泡已消失">>},
	 		{[{kill_npc, 20421}],[{enable_npc, 20418},{remove_elem, 7}],100,1,<<"气泡已消失">>}
	];
	
get(20802)->
	[ 		{[{kill_npc, 20415}],[{enable_npc, 20412},{remove_elem, 6}],100,1,<<"气泡已消失">>},
	 		{[{kill_npc, 20412}],[{enable_npc, 20409},{remove_elem, 7}],100,1,<<"气泡已消失">>}
	];
	
get(20803)->
	[ 		{[{kill_npc,20406}],[{enable_npc, 20403},{remove_elem, 6}],100,1,<<"气泡已消失">>},
	 		{[{kill_npc, 20403}],[{enable_npc, 20400},{remove_elem, 7}],100,1,<<"气泡已消失">>}
	];
	
get(21001)->
	[ 		{[{kill_npc, 30914}],[{create_hide_npc, [{0, 50, 30904, 6000, 9000},{51, 100, 30905, 6000, 9000}]},{remove_elem, 602861}],100,1,<<"虽然轻松击败了一个守卫，但是暗处潜伏着更多敌人。">>},
	 		{[{kill_npc, 30904}],[{create_hide_npc, [{0,10, 0, 0, 0},{11, 30, 30904, 5000, 9000},{31, 100, 30905, 5000, 9000}]}],100,5,<<"">>},
	 		{[{kill_npc, 30905}],[{create_hide_npc, [{0,10, 0, 0, 0},{11, 80, 30904, 5000, 9000},{81, 100, 30905, 5000, 9000}]}],100,5,<<"">>},
	 		{[{kill_npc, 30906}],[{create_dun_tele, 3, 60002, <<"玄武阵">>, 2509, 464, <<>>, {2,{21001, 420, 2310, <<"这似乎是一个错误的传送阵，你回到了第一层的起点">>},{21002, 420, 2310, <<"成功传送至第二层">>}}},{create_hide_npc, [{0,10, 0, 0, 0},{11, 50, 30904, 5000, 9000},{51, 100, 30905, 5000, 9000}]},{remove_elem, 60286}],100,1,<<"成功击败冥龟打通玄武阵">>},
	 		{[{kill_npc, 30907}],[{create_dun_tele, 2, 60002, <<"白虎阵">>, 314, 596, <<>>, {1,{21001, 420, 2310,<<"这似乎是一个错误的传送阵，你回到了第一层的起点">>},{21002, 420, 2310, <<"成功传送至第二层">>}}},{create_hide_npc, [{0,10, 0, 0, 0},{11, 50, 30904, 5000, 9000},{51, 100, 30905, 5000, 9000}]},{remove_elem, 602851}],100,1,<<"成功击败碧落护法打通白虎阵">>},
	 		{[{kill_npc, 30908}],[{create_dun_tele, 4, 60002, <<"青龙阵">>, 2701, 2160, <<>>, {3,{21001, 420, 2310, <<"这似乎是一个错误的传送阵，你回到了第一层的起点">>},{21002, 420, 2310, <<"成功传送至第二层">>}}},{create_hide_npc, [{0,10, 0, 0, 0},{11, 50, 30904, 5000, 9000},{51, 100, 30905, 5000, 9000}]},{remove_elem, 602852}],100,1,<<"成功击败黄泉护法打通青龙阵">>}
	];
	
get(21002)->
	[ 		{[{kill_npc, 30914}],[{create_hide_npc, [{0, 50, 30904, 6000, 9000},{51, 100, 30905, 6000, 9000}]},{remove_elem, 602861}],100,1,<<"虽然轻松击败了一个守卫，但是暗处潜伏着更多敌人。">>},
	 		{[{kill_npc, 30904}],[{create_hide_npc, [{0,10, 0, 0, 0},{11, 30, 30904, 5000, 9000},{31, 100, 30905, 5000, 9000}]}],100,5,<<"">>},
	 		{[{kill_npc, 30905}],[{create_hide_npc, [{0,10, 0, 0, 0},{11, 80, 30904, 5000, 9000},{81, 100, 30905, 5000, 9000}]}],100,5,<<"">>},
	 		{[{kill_npc, 30906}],[{create_dun_tele, 3, 60002, <<"玄武阵">>, 2509, 464, <<>>, {2,{21002, 420, 2310, <<"这似乎是一个错误的传送阵，你回到了第二层的起点">>},{21003, 420, 2310, <<"成功传送至第三层">>}}},{create_hide_npc, [{0,10, 0, 0, 0},{11, 50, 30904, 5000, 9000},{51, 100, 30905, 5000, 9000}]},{remove_elem, 60286}],100,1,<<"成功击败冥龟打通玄武阵">>},
	 		{[{kill_npc, 30907}],[{create_dun_tele, 2, 60002, <<"白虎阵">>, 314, 596, <<>>, {1,{21002, 420, 2310, <<"这似乎是一个错误的传送阵，你回到了第二层的起点">>},{21003, 420, 2310, <<"成功传送至第三层">>}}},{create_hide_npc, [{0,10, 0, 0, 0},{11, 50, 30904, 5000, 9000},{51, 100, 30905, 5000, 9000}]},{remove_elem, 602851}],100,1,<<"成功击败碧落护法打通白虎阵">>},
	 		{[{kill_npc, 30908}],[{create_dun_tele, 4, 60002, <<"青龙阵">>, 2701, 2160, <<>>, {3,{21002, 420, 2310, <<"这似乎是一个错误的传送阵，你回到了第二层的起点">>},{21003, 420, 2310, <<"成功传送至第三层">>}}},{create_hide_npc, [{0,10, 0, 0, 0},{11, 50, 30904, 5000, 9000},{51, 100, 30905, 5000, 9000}]},{remove_elem, 602852}],100,1,<<"成功击败黄泉护法打通青龙阵">>}
	];
	
get(21003)->
	[ 		{[{kill_npc, 30914}],[{create_hide_npc, [{0, 50, 30904, 6000, 9000},{51, 100, 30905, 6000, 9000}]},{remove_elem, 602861}],100,1,<<"虽然轻松击败了一个守卫，但是暗处潜伏着更多敌人。">>},
	 		{[{kill_npc, 30904}],[{create_hide_npc, [{0,10, 0, 0, 0},{11, 30, 30904, 5000, 9000},{31, 100, 30905, 5000, 9000}]}],100,5,<<"">>},
	 		{[{kill_npc, 30905}],[{create_hide_npc, [{0,10, 0, 0, 0},{11, 80, 30904, 5000, 9000},{81, 100, 30905, 5000, 9000}]}],100,5,<<"">>},
	 		{[{kill_npc, 30906}],[{create_dun_tele, 3, 60002, <<"玄武阵">>, 2509, 464, <<>>, {2,{21003, 420, 2310, <<"这似乎是一个错误的传送阵，你回到了第三层的起点">>},{21004, 360, 1140, <<"成功传送至第四层，前方貌似有只大BOSS">>}}} ,{create_hide_npc, [{0,10, 0, 0, 0},{11, 50, 30904, 5000, 9000},{51, 100, 30905, 5000, 9000}]},{remove_elem, 60286}],100,1,<<"成功击败冥龟打通玄武阵">>},
	 		{[{kill_npc, 30907}],[{create_dun_tele, 2, 60002, <<"白虎阵">>, 314, 596, <<>>, {1,{21003, 420, 2310, <<"这似乎是一个错误的传送阵，你回到了第三层的起点">>},{21004, 360, 1140, <<"成功传送至第四层，前方貌似有只大BOSS">>}}},{create_hide_npc, [{0,10, 0, 0, 0},{11, 50, 30904, 5000, 9000},{51, 100, 30905, 5000, 9000}]},{remove_elem, 602851}],100,1,<<"成功击败碧落护法打通白虎阵">>},
	 		{[{kill_npc, 30908}],[{create_dun_tele, 4, 60002, <<"青龙阵">>, 2701, 2160, <<>>, {3,{21003, 420, 2310, <<"这似乎是一个错误的传送阵，你回到了第三层的起点">>},{21004, 360, 1140, <<"成功传送至第四层，前方貌似有只大BOSS">>}}},{create_hide_npc, [{0,10, 0, 0, 0},{11, 50, 30904, 5000, 9000},{51, 100, 30905, 5000, 9000}]},{remove_elem, 602852}],100,1,<<"成功击败黄泉护法打通青龙阵">>}
	];
	
get(21004)->
	[ 		{[{kill_npc, 30909}],[{dungeon_event, {dun_clear, 21004, 6}} ],100,1,<<"">>}
	];
	
get(20701)->
	[ 		{[{kill_npc, 30915}],[{remove_elem, 6051501},{remove_elem, 6051502},{remove_elem, 6051503}],100,1,<<"云开雾散，你们成功闯过第一关">>},
	 		{[{kill_npc, 30921}],[{remove_elem, 6051504},{remove_elem, 6051505}],100,1,<<"云开雾散，你们成功闯过第二关">>},
	 		{[{kill_npc, 30927}],[{remove_elem, 6051508},{remove_elem, 6051509},{remove_elem, 6051510}],100,1,<<"拨开云雾见青天">>},
	 		{[{kill_all_npc, 30944}],[{create_npc, 30915, 3000, 3750}],100,1,<<"当你们庆幸怪物如此弱小之时，突然传来一声怒吼！">>},
	 		{[{kill_all_npc, 30945}],[{create_npc, 30921, 1260, 3000}],100,1,<<"似乎远方飞来一只青色的鸟儿">>},
	 		{[{kill_all_npc, 30948}],[{create_npc, 30927, 3360, 780}],100,1,<<"传说中的西王母居然出现在众人眼前">>},
	 		{[{kill_all_npc, 30950}],[{create_npc, 30933, 1140, 750}],100,1,<<"天帝终于露出了真身，似乎很开心见到你们">>},
	 		{[{kill_npc, 30933}],[{dungeon_event, {dun_clear, 20701, 150}} ],100,1,<<"">>}
	];
	
get(20702)->
	[ 		{[{kill_npc, 30015}],[{enable_npc, 30016},{remove_elem, 15}],100,1,<<"魔岩已被收服">>},
	 		{[{kill_npc, 30016}],[{enable_npc, 30017},{remove_elem, 16}],100,1,<<"魔岩已被收服">>},
	 		{[{clear_npc}],[{dungeon_event, {dun_clear, 20702, 2}} ],100,1,<<"">>}
	];
	
 
get(_) ->
    [].
