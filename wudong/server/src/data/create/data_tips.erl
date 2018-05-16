%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_tips
	%%% @Created : 2017-11-27 17:46:29
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_tips).
-export([ids/0]).
-export([login_tips/0]).
-export([uplv_tips/0]).
-export([timer_tips/0]).
-export([get/1]).
-include("common.hrl").
-include("tips.hrl").

ids() ->
    [100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215].

login_tips() ->
    [100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,134,136,144,145,146,147,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215].

uplv_tips() ->
    [109,111,135,137,148,167,168,169,170,171,172].

timer_tips() ->
    [106,107,108,110,135,136,138,139,141,143,168,179].
get(100) ->
	#base_tips{index = 1,id = 100,type = 1,type_desc = ?T("福利大厅") ,priority = 1,name = ?T("签到") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(101) ->
	#base_tips{index = 2,id = 101,type = 1,type_desc = ?T("福利大厅") ,priority = 2,name = ?T("在线时长奖励") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(102) ->
	#base_tips{index = 3,id = 102,type = 1,type_desc = ?T("福利大厅") ,priority = 3,name = ?T("离线经验") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(103) ->
	#base_tips{index = 4,id = 103,type = 1,type_desc = ?T("福利大厅") ,priority = 4,name = ?T("资源找回") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(104) ->
	#base_tips{index = 5,id = 104,type = 1,type_desc = ?T("福利大厅") ,priority = 5,name = ?T("签到再领一次") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(105) ->
	#base_tips{index = 6,id = 105,type = 1,type_desc = ?T("福利大厅") ,priority = 6,name = ?T("累计签到") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(106) ->
	#base_tips{index = 7,id = 106,type = 2,type_desc = ?T("在线时长奖励") ,priority = 1,name = ?T("在线时长奖励") ,lv_lim = 46,login = 1,uplv = 0,timer = 1};
get(107) ->
	#base_tips{index = 8,id = 107,type = 2,type_desc = ?T("签到再领一次") ,priority = 2,name = ?T("签到再领一次") ,lv_lim = 46,login = 1,uplv = 0,timer = 1};
get(108) ->
	#base_tips{index = 9,id = 108,type = 4,type_desc = ?T("副本扫荡") ,priority = 1,name = ?T("副本扫荡") ,lv_lim = 50,login = 1,uplv = 0,timer = 1};
get(109) ->
	#base_tips{index = 10,id = 109,type = 5,type_desc = ?T("单人副本") ,priority = 1,name = ?T("等级副本") ,lv_lim = 52,login = 1,uplv = 1,timer = 0};
get(110) ->
	#base_tips{index = 11,id = 110,type = 5,type_desc = ?T("单人副本") ,priority = 2,name = ?T("经验副本") ,lv_lim = 55,login = 1,uplv = 0,timer = 1};
get(111) ->
	#base_tips{index = 12,id = 111,type = 5,type_desc = ?T("单人副本") ,priority = 3,name = ?T("符文塔") ,lv_lim = 58,login = 1,uplv = 1,timer = 0};
get(112) ->
	#base_tips{index = 13,id = 112,type = 6,type_desc = ?T("获取新装备") ,priority = 1,name = ?T("人物装备") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(113) ->
	#base_tips{index = 14,id = 113,type = 7,type_desc = ?T("获取新道具") ,priority = 1,name = ?T("道具") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(114) ->
	#base_tips{index = 15,id = 114,type = 8,type_desc = ?T("替换外观装备") ,priority = 1,name = ?T("外观装备") ,lv_lim = 50,login = 1,uplv = 0,timer = 0};
get(115) ->
	#base_tips{index = 16,id = 115,type = 9,type_desc = ?T("坐骑") ,priority = 1,name = ?T("坐骑升阶") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(116) ->
	#base_tips{index = 17,id = 116,type = 9,type_desc = ?T("坐骑") ,priority = 2,name = ?T("技能升级") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(117) ->
	#base_tips{index = 18,id = 117,type = 9,type_desc = ?T("坐骑") ,priority = 3,name = ?T("精魄升级") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(118) ->
	#base_tips{index = 19,id = 118,type = 9,type_desc = ?T("坐骑") ,priority = 4,name = ?T("成长升级") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(119) ->
	#base_tips{index = 20,id = 119,type = 10,type_desc = ?T("仙羽") ,priority = 1,name = ?T("仙羽升阶") ,lv_lim = 61,login = 1,uplv = 0,timer = 0};
get(120) ->
	#base_tips{index = 21,id = 120,type = 10,type_desc = ?T("仙羽") ,priority = 2,name = ?T("技能升级") ,lv_lim = 61,login = 1,uplv = 0,timer = 0};
get(121) ->
	#base_tips{index = 22,id = 121,type = 10,type_desc = ?T("仙羽") ,priority = 3,name = ?T("精魄升级") ,lv_lim = 61,login = 1,uplv = 0,timer = 0};
get(122) ->
	#base_tips{index = 23,id = 122,type = 10,type_desc = ?T("仙羽") ,priority = 4,name = ?T("成长升级") ,lv_lim = 61,login = 1,uplv = 0,timer = 0};
get(123) ->
	#base_tips{index = 24,id = 123,type = 11,type_desc = ?T("法器") ,priority = 1,name = ?T("法器升阶") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(124) ->
	#base_tips{index = 25,id = 124,type = 11,type_desc = ?T("法器") ,priority = 2,name = ?T("技能升级") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(125) ->
	#base_tips{index = 26,id = 125,type = 11,type_desc = ?T("法器") ,priority = 3,name = ?T("精魄升级") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(126) ->
	#base_tips{index = 27,id = 126,type = 11,type_desc = ?T("法器") ,priority = 4,name = ?T("成长升级") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(127) ->
	#base_tips{index = 28,id = 127,type = 12,type_desc = ?T("神兵") ,priority = 1,name = ?T("神兵升阶") ,lv_lim = 60,login = 1,uplv = 0,timer = 0};
get(128) ->
	#base_tips{index = 29,id = 128,type = 12,type_desc = ?T("神兵") ,priority = 2,name = ?T("技能升级") ,lv_lim = 60,login = 1,uplv = 0,timer = 0};
get(129) ->
	#base_tips{index = 30,id = 129,type = 12,type_desc = ?T("神兵") ,priority = 3,name = ?T("精魄升级") ,lv_lim = 60,login = 1,uplv = 0,timer = 0};
get(130) ->
	#base_tips{index = 31,id = 130,type = 12,type_desc = ?T("神兵") ,priority = 4,name = ?T("成长升级") ,lv_lim = 60,login = 1,uplv = 0,timer = 0};
get(131) ->
	#base_tips{index = 32,id = 131,type = 13,type_desc = ?T("经脉") ,priority = 1,name = ?T("经脉激活") ,lv_lim = 63,login = 0,uplv = 0,timer = 0};
get(132) ->
	#base_tips{index = 33,id = 132,type = 13,type_desc = ?T("经脉") ,priority = 2,name = ?T("经脉升级") ,lv_lim = 63,login = 0,uplv = 0,timer = 0};
get(133) ->
	#base_tips{index = 34,id = 133,type = 13,type_desc = ?T("经脉") ,priority = 3,name = ?T("经脉突破") ,lv_lim = 63,login = 0,uplv = 0,timer = 0};
get(134) ->
	#base_tips{index = 35,id = 134,type = 14,type_desc = ?T("图鉴") ,priority = 1,name = ?T("图鉴激活") ,lv_lim = 50,login = 1,uplv = 0,timer = 0};
get(135) ->
	#base_tips{index = 36,id = 135,type = 14,type_desc = ?T("图鉴") ,priority = 1,name = ?T("图鉴升级") ,lv_lim = 43,login = 0,uplv = 1,timer = 1};
get(136) ->
	#base_tips{index = 37,id = 136,type = 15,type_desc = ?T("每日必做") ,priority = 1,name = ?T("每日必做升级") ,lv_lim = 50,login = 1,uplv = 0,timer = 1};
get(137) ->
	#base_tips{index = 38,id = 137,type = 16,type_desc = ?T("十荒神器") ,priority = 2,name = ?T("神器升级") ,lv_lim = 63,login = 0,uplv = 1,timer = 0};
get(138) ->
	#base_tips{index = 39,id = 138,type = 17,type_desc = ?T("竞技场") ,priority = 1,name = ?T("每日挑战奖励") ,lv_lim = 43,login = 0,uplv = 0,timer = 1};
get(139) ->
	#base_tips{index = 40,id = 139,type = 18,type_desc = ?T("锻造") ,priority = 1,name = ?T("强化") ,lv_lim = 47,login = 0,uplv = 0,timer = 1};
get(140) ->
	#base_tips{index = 41,id = 140,type = 18,type_desc = ?T("锻造") ,priority = 2,name = ?T("锻造进阶") ,lv_lim = 43,login = 0,uplv = 0,timer = 0};
get(141) ->
	#base_tips{index = 42,id = 141,type = 18,type_desc = ?T("锻造") ,priority = 3,name = ?T("镶嵌") ,lv_lim = 56,login = 0,uplv = 0,timer = 1};
get(142) ->
	#base_tips{index = 43,id = 142,type = 18,type_desc = ?T("锻造") ,priority = 4,name = ?T("洗练") ,lv_lim = 67,login = 0,uplv = 0,timer = 0};
get(143) ->
	#base_tips{index = 44,id = 143,type = 18,type_desc = ?T("锻造") ,priority = 5,name = ?T("精炼") ,lv_lim = 62,login = 0,uplv = 0,timer = 1};
get(144) ->
	#base_tips{index = 45,id = 144,type = 9,type_desc = ?T("坐骑") ,priority = 5,name = ?T("技能激活") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(145) ->
	#base_tips{index = 46,id = 145,type = 10,type_desc = ?T("仙羽") ,priority = 5,name = ?T("技能激活") ,lv_lim = 61,login = 1,uplv = 0,timer = 0};
get(146) ->
	#base_tips{index = 47,id = 146,type = 11,type_desc = ?T("法器") ,priority = 5,name = ?T("技能激活") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(147) ->
	#base_tips{index = 48,id = 147,type = 12,type_desc = ?T("神兵") ,priority = 5,name = ?T("技能激活") ,lv_lim = 60,login = 1,uplv = 0,timer = 0};
get(148) ->
	#base_tips{index = 49,id = 148,type = 16,type_desc = ?T("十荒神器") ,priority = 1,name = ?T("神器激活") ,lv_lim = 63,login = 0,uplv = 1,timer = 0};
get(149) ->
	#base_tips{index = 50,id = 149,type = 19,type_desc = ?T("技能") ,priority = 1,name = ?T("技能升级") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(150) ->
	#base_tips{index = 51,id = 150,type = 20,type_desc = ?T("妖灵") ,priority = 1,name = ?T("妖灵升阶") ,lv_lim = 63,login = 1,uplv = 0,timer = 0};
get(151) ->
	#base_tips{index = 52,id = 151,type = 20,type_desc = ?T("妖灵") ,priority = 2,name = ?T("技能升级") ,lv_lim = 63,login = 1,uplv = 0,timer = 0};
get(152) ->
	#base_tips{index = 53,id = 152,type = 20,type_desc = ?T("妖灵") ,priority = 3,name = ?T("精魄升级") ,lv_lim = 63,login = 1,uplv = 0,timer = 0};
get(153) ->
	#base_tips{index = 54,id = 153,type = 20,type_desc = ?T("妖灵") ,priority = 4,name = ?T("成长升级") ,lv_lim = 63,login = 1,uplv = 0,timer = 0};
get(154) ->
	#base_tips{index = 55,id = 154,type = 20,type_desc = ?T("妖灵") ,priority = 5,name = ?T("技能激活") ,lv_lim = 63,login = 1,uplv = 0,timer = 0};
get(155) ->
	#base_tips{index = 56,id = 155,type = 21,type_desc = ?T("足迹") ,priority = 1,name = ?T("足迹升阶") ,lv_lim = 68,login = 1,uplv = 0,timer = 0};
get(156) ->
	#base_tips{index = 57,id = 156,type = 21,type_desc = ?T("足迹") ,priority = 2,name = ?T("技能升级") ,lv_lim = 68,login = 1,uplv = 0,timer = 0};
get(157) ->
	#base_tips{index = 58,id = 157,type = 21,type_desc = ?T("足迹") ,priority = 3,name = ?T("精魄升级") ,lv_lim = 68,login = 1,uplv = 0,timer = 0};
get(158) ->
	#base_tips{index = 59,id = 158,type = 21,type_desc = ?T("足迹") ,priority = 4,name = ?T("成长升级") ,lv_lim = 68,login = 1,uplv = 0,timer = 0};
get(159) ->
	#base_tips{index = 60,id = 159,type = 21,type_desc = ?T("足迹") ,priority = 5,name = ?T("技能激活") ,lv_lim = 68,login = 1,uplv = 0,timer = 0};
get(160) ->
	#base_tips{index = 61,id = 160,type = 22,type_desc = ?T("道具过期") ,priority = 1,name = ?T("道具过期") ,lv_lim = 50,login = 1,uplv = 0,timer = 0};
get(161) ->
	#base_tips{index = 62,id = 161,type = 23,type_desc = ?T("坐骑") ,priority = 1,name = ?T("祝福值不足") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(162) ->
	#base_tips{index = 63,id = 162,type = 24,type_desc = ?T("仙羽") ,priority = 1,name = ?T("祝福值不足") ,lv_lim = 61,login = 1,uplv = 0,timer = 0};
get(163) ->
	#base_tips{index = 64,id = 163,type = 25,type_desc = ?T("法器") ,priority = 1,name = ?T("祝福值不足") ,lv_lim = 43,login = 1,uplv = 0,timer = 0};
get(164) ->
	#base_tips{index = 65,id = 164,type = 26,type_desc = ?T("神兵") ,priority = 1,name = ?T("祝福值不足") ,lv_lim = 60,login = 1,uplv = 0,timer = 0};
get(165) ->
	#base_tips{index = 66,id = 165,type = 27,type_desc = ?T("妖灵") ,priority = 1,name = ?T("祝福值不足") ,lv_lim = 63,login = 1,uplv = 0,timer = 0};
get(166) ->
	#base_tips{index = 67,id = 166,type = 28,type_desc = ?T("足迹") ,priority = 1,name = ?T("祝福值不足") ,lv_lim = 68,login = 1,uplv = 0,timer = 0};
get(167) ->
	#base_tips{index = 68,id = 167,type = 29,type_desc = ?T("神器副本") ,priority = 1,name = ?T("神器副本") ,lv_lim = 62,login = 0,uplv = 1,timer = 0};
get(168) ->
	#base_tips{index = 69,id = 168,type = 30,type_desc = ?T("符文") ,priority = 1,name = ?T("符文") ,lv_lim = 47,login = 0,uplv = 1,timer = 1};
get(169) ->
	#base_tips{index = 70,id = 169,type = 31,type_desc = ?T("宠物") ,priority = 1,name = ?T("技能升级") ,lv_lim = 53,login = 1,uplv = 1,timer = 0};
get(170) ->
	#base_tips{index = 71,id = 170,type = 31,type_desc = ?T("宠物") ,priority = 2,name = ?T("宠物进阶") ,lv_lim = 53,login = 1,uplv = 1,timer = 0};
get(171) ->
	#base_tips{index = 72,id = 171,type = 31,type_desc = ?T("宠物") ,priority = 3,name = ?T("宠物升星") ,lv_lim = 53,login = 1,uplv = 1,timer = 0};
get(172) ->
	#base_tips{index = 73,id = 172,type = 31,type_desc = ?T("宠物") ,priority = 4,name = ?T("宠物助战") ,lv_lim = 53,login = 1,uplv = 1,timer = 0};
get(173) ->
	#base_tips{index = 74,id = 173,type = 32,type_desc = ?T("灵猫") ,priority = 1,name = ?T("灵猫升阶") ,lv_lim = 71,login = 1,uplv = 0,timer = 0};
get(174) ->
	#base_tips{index = 75,id = 174,type = 32,type_desc = ?T("灵猫") ,priority = 2,name = ?T("技能升级") ,lv_lim = 71,login = 1,uplv = 0,timer = 0};
get(175) ->
	#base_tips{index = 76,id = 175,type = 32,type_desc = ?T("灵猫") ,priority = 3,name = ?T("精魄升级") ,lv_lim = 71,login = 1,uplv = 0,timer = 0};
get(176) ->
	#base_tips{index = 77,id = 176,type = 32,type_desc = ?T("灵猫") ,priority = 4,name = ?T("成长升级") ,lv_lim = 71,login = 1,uplv = 0,timer = 0};
get(177) ->
	#base_tips{index = 78,id = 177,type = 32,type_desc = ?T("灵猫") ,priority = 5,name = ?T("技能激活") ,lv_lim = 71,login = 1,uplv = 0,timer = 0};
get(178) ->
	#base_tips{index = 79,id = 178,type = 33,type_desc = ?T("灵猫") ,priority = 1,name = ?T("祝福值不足") ,lv_lim = 71,login = 1,uplv = 0,timer = 0};
get(179) ->
	#base_tips{index = 80,id = 179,type = 18,type_desc = ?T("熔炼") ,priority = 6,name = ?T("有装备可熔炼") ,lv_lim = 60,login = 1,uplv = 0,timer = 1};
get(180) ->
	#base_tips{index = 81,id = 180,type = 34,type_desc = ?T("法身") ,priority = 1,name = ?T("法身升阶") ,lv_lim = 75,login = 1,uplv = 0,timer = 0};
get(181) ->
	#base_tips{index = 82,id = 181,type = 34,type_desc = ?T("法身") ,priority = 2,name = ?T("技能升级") ,lv_lim = 75,login = 1,uplv = 0,timer = 0};
get(182) ->
	#base_tips{index = 83,id = 182,type = 34,type_desc = ?T("法身") ,priority = 3,name = ?T("精魄升级") ,lv_lim = 75,login = 1,uplv = 0,timer = 0};
get(183) ->
	#base_tips{index = 84,id = 183,type = 34,type_desc = ?T("法身") ,priority = 4,name = ?T("成长升级") ,lv_lim = 75,login = 1,uplv = 0,timer = 0};
get(184) ->
	#base_tips{index = 85,id = 184,type = 34,type_desc = ?T("法身") ,priority = 5,name = ?T("技能激活") ,lv_lim = 75,login = 1,uplv = 0,timer = 0};
get(185) ->
	#base_tips{index = 86,id = 185,type = 35,type_desc = ?T("法身") ,priority = 1,name = ?T("祝福值不足") ,lv_lim = 75,login = 1,uplv = 0,timer = 0};
get(186) ->
	#base_tips{index = 87,id = 186,type = 36,type_desc = ?T("灵羽") ,priority = 1,name = ?T("灵羽升阶") ,lv_lim = 59,login = 1,uplv = 0,timer = 0};
get(187) ->
	#base_tips{index = 88,id = 187,type = 36,type_desc = ?T("灵羽") ,priority = 2,name = ?T("技能升级") ,lv_lim = 59,login = 1,uplv = 0,timer = 0};
get(188) ->
	#base_tips{index = 89,id = 188,type = 36,type_desc = ?T("灵羽") ,priority = 3,name = ?T("精魄升级") ,lv_lim = 59,login = 1,uplv = 0,timer = 0};
get(189) ->
	#base_tips{index = 90,id = 189,type = 36,type_desc = ?T("灵羽") ,priority = 4,name = ?T("成长升级") ,lv_lim = 59,login = 1,uplv = 0,timer = 0};
get(190) ->
	#base_tips{index = 91,id = 190,type = 36,type_desc = ?T("灵羽") ,priority = 5,name = ?T("技能激活") ,lv_lim = 59,login = 1,uplv = 0,timer = 0};
get(191) ->
	#base_tips{index = 92,id = 191,type = 37,type_desc = ?T("灵羽") ,priority = 1,name = ?T("祝福值不足") ,lv_lim = 59,login = 1,uplv = 0,timer = 0};
get(192) ->
	#base_tips{index = 93,id = 192,type = 38,type_desc = ?T("灵骑") ,priority = 1,name = ?T("灵骑升阶") ,lv_lim = 85,login = 1,uplv = 0,timer = 0};
get(193) ->
	#base_tips{index = 94,id = 193,type = 38,type_desc = ?T("灵骑") ,priority = 2,name = ?T("技能升级") ,lv_lim = 85,login = 1,uplv = 0,timer = 0};
get(194) ->
	#base_tips{index = 95,id = 194,type = 38,type_desc = ?T("灵骑") ,priority = 3,name = ?T("精魄升级") ,lv_lim = 85,login = 1,uplv = 0,timer = 0};
get(195) ->
	#base_tips{index = 96,id = 195,type = 38,type_desc = ?T("灵骑") ,priority = 4,name = ?T("成长升级") ,lv_lim = 85,login = 1,uplv = 0,timer = 0};
get(196) ->
	#base_tips{index = 97,id = 196,type = 38,type_desc = ?T("灵骑") ,priority = 5,name = ?T("技能激活") ,lv_lim = 85,login = 1,uplv = 0,timer = 0};
get(197) ->
	#base_tips{index = 98,id = 197,type = 39,type_desc = ?T("灵骑") ,priority = 1,name = ?T("祝福值不足") ,lv_lim = 85,login = 1,uplv = 0,timer = 0};
get(198) ->
	#base_tips{index = 99,id = 198,type = 40,type_desc = ?T("灵弓") ,priority = 1,name = ?T("灵弓升阶") ,lv_lim = 90,login = 1,uplv = 0,timer = 0};
get(199) ->
	#base_tips{index = 100,id = 199,type = 40,type_desc = ?T("灵弓") ,priority = 2,name = ?T("技能升级") ,lv_lim = 90,login = 1,uplv = 0,timer = 0};
get(200) ->
	#base_tips{index = 101,id = 200,type = 40,type_desc = ?T("灵弓") ,priority = 3,name = ?T("精魄升级") ,lv_lim = 90,login = 1,uplv = 0,timer = 0};
get(201) ->
	#base_tips{index = 102,id = 201,type = 40,type_desc = ?T("灵弓") ,priority = 4,name = ?T("成长升级") ,lv_lim = 90,login = 1,uplv = 0,timer = 0};
get(202) ->
	#base_tips{index = 103,id = 202,type = 40,type_desc = ?T("灵弓") ,priority = 5,name = ?T("技能激活") ,lv_lim = 90,login = 1,uplv = 0,timer = 0};
get(203) ->
	#base_tips{index = 104,id = 203,type = 41,type_desc = ?T("灵弓") ,priority = 1,name = ?T("祝福值不足") ,lv_lim = 90,login = 1,uplv = 0,timer = 0};
get(204) ->
	#base_tips{index = 105,id = 204,type = 42,type_desc = ?T("仙宝") ,priority = 1,name = ?T("仙宝升阶") ,lv_lim = 110,login = 1,uplv = 0,timer = 0};
get(205) ->
	#base_tips{index = 106,id = 205,type = 42,type_desc = ?T("仙宝") ,priority = 2,name = ?T("技能升级") ,lv_lim = 110,login = 1,uplv = 0,timer = 0};
get(206) ->
	#base_tips{index = 107,id = 206,type = 42,type_desc = ?T("仙宝") ,priority = 3,name = ?T("精魄升级") ,lv_lim = 110,login = 1,uplv = 0,timer = 0};
get(207) ->
	#base_tips{index = 108,id = 207,type = 42,type_desc = ?T("仙宝") ,priority = 4,name = ?T("成长升级") ,lv_lim = 110,login = 1,uplv = 0,timer = 0};
get(208) ->
	#base_tips{index = 109,id = 208,type = 42,type_desc = ?T("仙宝") ,priority = 5,name = ?T("技能激活") ,lv_lim = 110,login = 1,uplv = 0,timer = 0};
get(209) ->
	#base_tips{index = 110,id = 209,type = 43,type_desc = ?T("仙宝") ,priority = 1,name = ?T("祝福值不足") ,lv_lim = 110,login = 1,uplv = 0,timer = 0};
get(210) ->
	#base_tips{index = 111,id = 210,type = 44,type_desc = ?T("灵佩") ,priority = 1,name = ?T("灵佩升阶") ,lv_lim = 120,login = 1,uplv = 0,timer = 0};
get(211) ->
	#base_tips{index = 112,id = 211,type = 44,type_desc = ?T("灵佩") ,priority = 2,name = ?T("技能升级") ,lv_lim = 120,login = 1,uplv = 0,timer = 0};
get(212) ->
	#base_tips{index = 113,id = 212,type = 44,type_desc = ?T("灵佩") ,priority = 3,name = ?T("精魄升级") ,lv_lim = 120,login = 1,uplv = 0,timer = 0};
get(213) ->
	#base_tips{index = 114,id = 213,type = 44,type_desc = ?T("灵佩") ,priority = 4,name = ?T("成长升级") ,lv_lim = 120,login = 1,uplv = 0,timer = 0};
get(214) ->
	#base_tips{index = 115,id = 214,type = 44,type_desc = ?T("灵佩") ,priority = 5,name = ?T("技能激活") ,lv_lim = 120,login = 1,uplv = 0,timer = 0};
get(215) ->
	#base_tips{index = 116,id = 215,type = 45,type_desc = ?T("灵佩") ,priority = 1,name = ?T("祝福值不足") ,lv_lim = 120,login = 1,uplv = 0,timer = 0};
get(_) -> [].
