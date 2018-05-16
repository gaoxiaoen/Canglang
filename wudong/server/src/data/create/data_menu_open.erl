%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_menu_open
	%%% @Created : 2018-05-09 21:28:58
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_menu_open).
-export([get/1]).
-export([get_task/1]).
-export([get_lim_sn_list/1]).
-include("error_code.hrl").
-include("wing.hrl").
-include("common.hrl").
%%"坐骑" 
get(1) -> 13;
%%"仙羽" 
get(2) -> 60;
%%"法宝" 
get(3) -> 29;
%%"神兵" 
get(4) -> 17;
%%"妖灵" 
get(5) -> 62;
%%"每日签到" 
get(6) -> 18;
%%"宠物" 
get(7) -> 8;
%%"宠物进阶" 
get(8) -> 9;
%%"宠物升星" 
get(9) -> 9;
%%"宠物助战" 
get(10) -> 25;
%%"宠物图鉴" 
get(11) -> 9;
%%"装备强化" 
get(12) -> 30;
%%"装备洗练" 
get(13) -> 66;
%%"装备进阶" 
get(14) -> 40;
%%"装备宝石" 
get(15) -> 55;
%%"装备精炼" 
get(16) -> 61;
%%"好友" 
get(17) -> 27;
%%"仙盟" 
get(18) -> 36;
%%"竞技场" 
get(19) -> 26;
%%"跨服竞技场" 
get(20) -> 48;
%%"剑池" 
get(21) -> 39;
%%"仙盟商店" 
get(22) -> 1;
%%"废弃" 
get(23) -> 50;
%%"进阶" 
get(24) -> 13;
%%"经验" 
get(25) -> 34;
%%"剧情" 
get(26) -> 13;
%%"神器" 
get(27) -> 62;
%%"经脉" 
get(28) -> 999;
%%"灵脉" 
get(29) -> 75;
%%"vip副本" 
get(30) -> 37;
%%"每日活动" 
get(31) -> 20;
%%"熔炼" 
get(32) -> 50;
%%"经脉" 
get(33) -> 65;
%%"图鉴野外" 
get(34) -> 41;
%%"十荒神器" 
get(35) -> 6;
%%"六龙" 
get(36) -> 48;
%%"巅峰" 
get(37) -> 48;
%%"跨服1v1" 
get(38) -> 48;
%%"王城守卫" 
get(39) -> 48;
%%"足迹" 
get(40) -> 66;
%%"组队" 
get(41) -> 55;
%%"符文塔" 
get(42) -> 46;
%%"符文" 
get(43) -> 46;
%%"休闲玩法" 
get(44) -> 45;
%%"守护副本" 
get(45) -> 65;
%%"灵猫" 
get(46) -> 70;
%%"乱斗战场" 
get(47) -> 65;
%%"法身" 
get(48) -> 72;
%%"结婚" 
get(49) -> 59;
%%"神炼" 
get(50) -> 90;
%%"附魔" 
get(51) -> 90;
%%"魔宫" 
get(52) -> 75;
%%"装备灵石" 
get(53) -> 80;
%%"时装" 
get(54) -> 41;
%%"宠物仙魂" 
get(55) -> 90;
%%"跨服攻城" 
get(56) -> 80;
%%"转生" 
get(57) -> 63;
%%"转生" 
get(58) -> 75;
%%"集市" 
get(59) -> 40;
%%"图鉴boss" 
get(60) -> 60;
%%"宝宝" 
get(61) -> 59;
%%"灵羽" 
get(62) -> 59;
%%"灵骑" 
get(63) -> 90;
%%"灵弓" 
get(64) -> 95;
%%"宝宝升星" 
get(65) -> 59;
%%"时装" 
get(66) -> 30;
%%"头饰" 
get(67) -> 30;
%%"气泡" 
get(68) -> 30;
%%"称号" 
get(69) -> 30;
%%"挂饰" 
get(70) -> 30;
%%"外观图鉴" 
get(71) -> 60;
%%"飞仙" 
get(72) -> 90;
%%"试炼" 
get(73) -> 90;
%%"仙宝" 
get(74) -> 110;
%%"灵佩" 
get(75) -> 120;
%%"仙装" 
get(76) -> 90;
%%"进阶" 
get(77) -> 90;
%%"仙炼" 
get(78) -> 90;
%%"觉醒" 
get(79) -> 90;
%%"聚宝" 
get(80) -> 90;
%%"兑换" 
get(81) -> 90;
%%"宠物对战" 
get(82) -> 50;
%%"宠物对战" 
get(83) -> 50;
%%"跨服1VN" 
get(84) -> 80;
%%"符文合成" 
get(85) -> 100;
%%"降神台" 
get(86) -> 90;
%%"降神" 
get(87) -> 90;
%%"模具兑换" 
get(88) -> 60;
%%"升级" 
get(89) -> 60;
%%"剑道" 
get(90) -> 120;
%%"元素" 
get(91) -> 120;
%%"神器锻造" 
get(92) -> 125;
get(_Data) -> 999.
%%"坐骑" 
get_task(1) -> {10160,3};
%%"仙羽" 
get_task(2) -> {10790,3};
%%"法宝" 
get_task(3) -> {10290,3};
%%"神兵" 
get_task(4) -> {10210,3};
%%"妖灵" 
get_task(5) -> {0,0};
%%"每日签到" 
get_task(6) -> {0,0};
%%"宠物" 
get_task(7) -> {10110,3};
%%"宠物进阶" 
get_task(8) -> {0,0};
%%"宠物升星" 
get_task(9) -> {0,0};
%%"宠物助战" 
get_task(10) -> {0,0};
%%"宠物图鉴" 
get_task(11) -> {0,0};
%%"装备强化" 
get_task(12) -> {0,0};
%%"装备洗练" 
get_task(13) -> {0,0};
%%"装备进阶" 
get_task(14) -> {0,0};
%%"装备宝石" 
get_task(15) -> {0,0};
%%"装备精炼" 
get_task(16) -> {0,0};
%%"好友" 
get_task(17) -> {0,0};
%%"仙盟" 
get_task(18) -> {0,0};
%%"竞技场" 
get_task(19) -> {0,0};
%%"跨服竞技场" 
get_task(20) -> {0,0};
%%"剑池" 
get_task(21) -> {10530,2};
%%"仙盟商店" 
get_task(22) -> {0,0};
%%"废弃" 
get_task(23) -> {0,0};
%%"进阶" 
get_task(24) -> {0,0};
%%"经验" 
get_task(25) -> {0,0};
%%"剧情" 
get_task(26) -> {0,0};
%%"神器" 
get_task(27) -> {0,0};
%%"经脉" 
get_task(28) -> {0,0};
%%"灵脉" 
get_task(29) -> {0,0};
%%"vip副本" 
get_task(30) -> {0,0};
%%"每日活动" 
get_task(31) -> {0,0};
%%"熔炼" 
get_task(32) -> {0,0};
%%"经脉" 
get_task(33) -> {0,0};
%%"图鉴野外" 
get_task(34) -> {0,0};
%%"十荒神器" 
get_task(35) -> {0,0};
%%"六龙" 
get_task(36) -> {0,0};
%%"巅峰" 
get_task(37) -> {0,0};
%%"跨服1v1" 
get_task(38) -> {0,0};
%%"王城守卫" 
get_task(39) -> {0,0};
%%"足迹" 
get_task(40) -> {0,0};
%%"组队" 
get_task(41) -> {0,0};
%%"符文塔" 
get_task(42) -> {0,0};
%%"符文" 
get_task(43) -> {0,0};
%%"休闲玩法" 
get_task(44) -> {0,0};
%%"守护副本" 
get_task(45) -> {0,0};
%%"灵猫" 
get_task(46) -> {0,0};
%%"乱斗战场" 
get_task(47) -> {0,0};
%%"法身" 
get_task(48) -> {0,0};
%%"结婚" 
get_task(49) -> {0,0};
%%"神炼" 
get_task(50) -> {0,0};
%%"附魔" 
get_task(51) -> {0,0};
%%"魔宫" 
get_task(52) -> {0,0};
%%"装备灵石" 
get_task(53) -> {0,0};
%%"时装" 
get_task(54) -> {10550,2};
%%"宠物仙魂" 
get_task(55) -> {0,0};
%%"跨服攻城" 
get_task(56) -> {0,0};
%%"转生" 
get_task(57) -> {0,0};
%%"转生" 
get_task(58) -> {0,0};
%%"集市" 
get_task(59) -> {0,0};
%%"图鉴boss" 
get_task(60) -> {0,0};
%%"宝宝" 
get_task(61) -> {0,0};
%%"灵羽" 
get_task(62) -> {0,0};
%%"灵骑" 
get_task(63) -> {0,0};
%%"灵弓" 
get_task(64) -> {0,0};
%%"宝宝升星" 
get_task(65) -> {0,0};
%%"时装" 
get_task(66) -> {0,0};
%%"头饰" 
get_task(67) -> {0,0};
%%"气泡" 
get_task(68) -> {0,0};
%%"称号" 
get_task(69) -> {0,0};
%%"挂饰" 
get_task(70) -> {0,0};
%%"外观图鉴" 
get_task(71) -> {0,0};
%%"飞仙" 
get_task(72) -> {0,0};
%%"试炼" 
get_task(73) -> {0,0};
%%"仙宝" 
get_task(74) -> {0,0};
%%"灵佩" 
get_task(75) -> {0,0};
%%"仙装" 
get_task(76) -> {0,0};
%%"进阶" 
get_task(77) -> {0,0};
%%"仙炼" 
get_task(78) -> {0,0};
%%"觉醒" 
get_task(79) -> {0,0};
%%"聚宝" 
get_task(80) -> {0,0};
%%"兑换" 
get_task(81) -> {0,0};
%%"宠物对战" 
get_task(82) -> {0,0};
%%"宠物对战" 
get_task(83) -> {0,0};
%%"跨服1VN" 
get_task(84) -> {0,0};
%%"符文合成" 
get_task(85) -> {0,0};
%%"降神台" 
get_task(86) -> {0,0};
%%"降神" 
get_task(87) -> {0,0};
%%"模具兑换" 
get_task(88) -> {0,0};
%%"升级" 
get_task(89) -> {0,0};
%%"剑道" 
get_task(90) -> {0,0};
%%"元素" 
get_task(91) -> {0,0};
%%"神器锻造" 
get_task(92) -> {0,0};
get_task(_Data) -> [].
%%"坐骑" 
get_lim_sn_list(1) -> [];
%%"仙羽" 
get_lim_sn_list(2) -> [];
%%"法宝" 
get_lim_sn_list(3) -> [];
%%"神兵" 
get_lim_sn_list(4) -> [];
%%"妖灵" 
get_lim_sn_list(5) -> [];
%%"每日签到" 
get_lim_sn_list(6) -> [];
%%"宠物" 
get_lim_sn_list(7) -> [];
%%"宠物进阶" 
get_lim_sn_list(8) -> [];
%%"宠物升星" 
get_lim_sn_list(9) -> [];
%%"宠物助战" 
get_lim_sn_list(10) -> [];
%%"宠物图鉴" 
get_lim_sn_list(11) -> [];
%%"装备强化" 
get_lim_sn_list(12) -> [];
%%"装备洗练" 
get_lim_sn_list(13) -> [];
%%"装备进阶" 
get_lim_sn_list(14) -> [];
%%"装备宝石" 
get_lim_sn_list(15) -> [];
%%"装备精炼" 
get_lim_sn_list(16) -> [];
%%"好友" 
get_lim_sn_list(17) -> [];
%%"仙盟" 
get_lim_sn_list(18) -> [];
%%"竞技场" 
get_lim_sn_list(19) -> [];
%%"跨服竞技场" 
get_lim_sn_list(20) -> [];
%%"剑池" 
get_lim_sn_list(21) -> [];
%%"仙盟商店" 
get_lim_sn_list(22) -> [];
%%"废弃" 
get_lim_sn_list(23) -> [];
%%"进阶" 
get_lim_sn_list(24) -> [];
%%"经验" 
get_lim_sn_list(25) -> [];
%%"剧情" 
get_lim_sn_list(26) -> [];
%%"神器" 
get_lim_sn_list(27) -> [];
%%"经脉" 
get_lim_sn_list(28) -> [];
%%"灵脉" 
get_lim_sn_list(29) -> [];
%%"vip副本" 
get_lim_sn_list(30) -> [];
%%"每日活动" 
get_lim_sn_list(31) -> [];
%%"熔炼" 
get_lim_sn_list(32) -> [];
%%"经脉" 
get_lim_sn_list(33) -> [];
%%"图鉴野外" 
get_lim_sn_list(34) -> [];
%%"十荒神器" 
get_lim_sn_list(35) -> [];
%%"六龙" 
get_lim_sn_list(36) -> [];
%%"巅峰" 
get_lim_sn_list(37) -> [];
%%"跨服1v1" 
get_lim_sn_list(38) -> [];
%%"王城守卫" 
get_lim_sn_list(39) -> [];
%%"足迹" 
get_lim_sn_list(40) -> [];
%%"组队" 
get_lim_sn_list(41) -> [];
%%"符文塔" 
get_lim_sn_list(42) -> [];
%%"符文" 
get_lim_sn_list(43) -> [];
%%"休闲玩法" 
get_lim_sn_list(44) -> [];
%%"守护副本" 
get_lim_sn_list(45) -> [];
%%"灵猫" 
get_lim_sn_list(46) -> [];
%%"乱斗战场" 
get_lim_sn_list(47) -> [];
%%"法身" 
get_lim_sn_list(48) -> [];
%%"结婚" 
get_lim_sn_list(49) -> [];
%%"神炼" 
get_lim_sn_list(50) -> [];
%%"附魔" 
get_lim_sn_list(51) -> [];
%%"魔宫" 
get_lim_sn_list(52) -> [];
%%"装备灵石" 
get_lim_sn_list(53) -> [];
%%"时装" 
get_lim_sn_list(54) -> [];
%%"宠物仙魂" 
get_lim_sn_list(55) -> [];
%%"跨服攻城" 
get_lim_sn_list(56) -> [];
%%"转生" 
get_lim_sn_list(57) -> [];
%%"转生" 
get_lim_sn_list(58) -> [];
%%"集市" 
get_lim_sn_list(59) -> [];
%%"图鉴boss" 
get_lim_sn_list(60) -> [];
%%"宝宝" 
get_lim_sn_list(61) -> [];
%%"灵羽" 
get_lim_sn_list(62) -> [];
%%"灵骑" 
get_lim_sn_list(63) -> [];
%%"灵弓" 
get_lim_sn_list(64) -> [];
%%"宝宝升星" 
get_lim_sn_list(65) -> [];
%%"时装" 
get_lim_sn_list(66) -> [];
%%"头饰" 
get_lim_sn_list(67) -> [];
%%"气泡" 
get_lim_sn_list(68) -> [];
%%"称号" 
get_lim_sn_list(69) -> [];
%%"挂饰" 
get_lim_sn_list(70) -> [];
%%"外观图鉴" 
get_lim_sn_list(71) -> [];
%%"飞仙" 
get_lim_sn_list(72) -> [];
%%"试炼" 
get_lim_sn_list(73) -> [];
%%"仙宝" 
get_lim_sn_list(74) -> [];
%%"灵佩" 
get_lim_sn_list(75) -> [];
%%"仙装" 
get_lim_sn_list(76) -> [];
%%"进阶" 
get_lim_sn_list(77) -> [];
%%"仙炼" 
get_lim_sn_list(78) -> [];
%%"觉醒" 
get_lim_sn_list(79) -> [];
%%"聚宝" 
get_lim_sn_list(80) -> [];
%%"兑换" 
get_lim_sn_list(81) -> [];
%%"宠物对战" 
get_lim_sn_list(82) -> [];
%%"宠物对战" 
get_lim_sn_list(83) -> [];
%%"跨服1VN" 
get_lim_sn_list(84) -> [];
%%"符文合成" 
get_lim_sn_list(85) -> [];
%%"降神台" 
get_lim_sn_list(86) -> [];
%%"降神" 
get_lim_sn_list(87) -> [];
%%"模具兑换" 
get_lim_sn_list(88) -> [];
%%"升级" 
get_lim_sn_list(89) -> [];
%%"剑道" 
get_lim_sn_list(90) -> [];
%%"元素" 
get_lim_sn_list(91) -> [];
%%"神器锻造" 
get_lim_sn_list(92) -> [];
get_lim_sn_list(_Data) -> [].
