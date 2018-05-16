%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wash_random
	%%% @Created : 2016-09-13 15:58:36
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wash_random).
-export([get_wash_attr/1]).
-export([get_all_probability/1]).
-export([get_probability/2]).
-include("server.hrl").
get_wash_attr(1) -> {def,1,5};
get_wash_attr(5) -> {hp_lim,15,75};
get_wash_attr(6) -> {att,1,5};
get_wash_attr(7) -> {def,6,15};
get_wash_attr(11) -> {hp_lim,76,225};
get_wash_attr(12) -> {att,6,15};
get_wash_attr(13) -> {def,16,25};
get_wash_attr(17) -> {hp_lim,226,375};
get_wash_attr(18) -> {att,16,25};
get_wash_attr(19) -> {hp_lim,750,750};
get_wash_attr(20) -> {att,50,50};
get_wash_attr(21) -> {def,1,5};
get_wash_attr(25) -> {hp_lim,15,75};
get_wash_attr(26) -> {att,1,5};
get_wash_attr(27) -> {def,6,15};
get_wash_attr(31) -> {hp_lim,76,225};
get_wash_attr(32) -> {att,6,15};
get_wash_attr(33) -> {def,16,25};
get_wash_attr(37) -> {hp_lim,226,375};
get_wash_attr(38) -> {att,16,25};
get_wash_attr(39) -> {hp_lim,750,750};
get_wash_attr(40) -> {att,50,50};
get_wash_attr(41) -> {def,1,5};
get_wash_attr(45) -> {hp_lim,15,75};
get_wash_attr(46) -> {att,1,5};
get_wash_attr(47) -> {def,6,15};
get_wash_attr(51) -> {hp_lim,76,225};
get_wash_attr(52) -> {att,6,15};
get_wash_attr(53) -> {def,16,25};
get_wash_attr(57) -> {hp_lim,226,375};
get_wash_attr(58) -> {att,16,25};
get_wash_attr(59) -> {hp_lim,750,750};
get_wash_attr(60) -> {att,50,50};
get_wash_attr(61) -> {def,2,10};
get_wash_attr(65) -> {hp_lim,30,150};
get_wash_attr(66) -> {att,2,10};
get_wash_attr(67) -> {def,11,30};
get_wash_attr(71) -> {hp_lim,151,450};
get_wash_attr(72) -> {att,11,30};
get_wash_attr(73) -> {def,31,50};
get_wash_attr(77) -> {hp_lim,451,750};
get_wash_attr(78) -> {att,31,50};
get_wash_attr(79) -> {hp_lim,1500,1500};
get_wash_attr(80) -> {att,100,100};
get_wash_attr(81) -> {def,4,20};
get_wash_attr(85) -> {hp_lim,60,300};
get_wash_attr(86) -> {att,4,20};
get_wash_attr(87) -> {def,21,60};
get_wash_attr(91) -> {hp_lim,301,900};
get_wash_attr(92) -> {att,21,60};
get_wash_attr(93) -> {def,61,100};
get_wash_attr(97) -> {hp_lim,901,1500};
get_wash_attr(98) -> {att,61,100};
get_wash_attr(99) -> {hp_lim,3000,3000};
get_wash_attr(100) -> {att,200,200};
get_wash_attr(101) -> {def,8,40};
get_wash_attr(105) -> {hp_lim,120,600};
get_wash_attr(106) -> {att,8,40};
get_wash_attr(107) -> {def,41,120};
get_wash_attr(111) -> {hp_lim,601,1800};
get_wash_attr(112) -> {att,41,120};
get_wash_attr(113) -> {def,121,200};
get_wash_attr(117) -> {hp_lim,1801,3000};
get_wash_attr(118) -> {att,121,200};
get_wash_attr(119) -> {hp_lim,6000,6000};
get_wash_attr(120) -> {att,400,400};
get_wash_attr(121) -> {def,12,60};
get_wash_attr(125) -> {hp_lim,120,600};
get_wash_attr(126) -> {att,12,60};
get_wash_attr(127) -> {def,61,180};
get_wash_attr(128) -> {def,61,180};
get_wash_attr(132) -> {att,61,180};
get_wash_attr(133) -> {def,181,300};
get_wash_attr(137) -> {hp_lim,1801,3000};
get_wash_attr(138) -> {att,181,300};
get_wash_attr(139) -> {hp_lim,6000,6000};
get_wash_attr(140) -> {att,600,600};
get_wash_attr(141) -> {def,16,80};
get_wash_attr(145) -> {hp_lim,160,800};
get_wash_attr(146) -> {att,16,80};
get_wash_attr(147) -> {def,81,240};
get_wash_attr(151) -> {hp_lim,801,2400};
get_wash_attr(152) -> {att,81,240};
get_wash_attr(153) -> {def,241,400};
get_wash_attr(157) -> {hp_lim,2401,4000};
get_wash_attr(158) -> {att,241,400};
get_wash_attr(159) -> {hp_lim,8000,8000};
get_wash_attr(160) -> {att,800,800};
get_wash_attr(161) -> {def,20,100};
get_wash_attr(165) -> {hp_lim,200,1000};
get_wash_attr(166) -> {att,20,100};
get_wash_attr(167) -> {def,101,300};
get_wash_attr(171) -> {hp_lim,1001,3000};
get_wash_attr(172) -> {att,101,300};
get_wash_attr(173) -> {def,301,500};
get_wash_attr(177) -> {hp_lim,3001,5000};
get_wash_attr(178) -> {att,301,500};
get_wash_attr(179) -> {hp_lim,10000,10000};
get_wash_attr(180) -> {att,1000,1000};
get_wash_attr(_) -> throw({false,23333}). 

get_all_probability(1)->[{1,750},{5,1000},{6,1000},{7,375},{11,500},{12,500},{13,375},{17,250},{18,250},{19,250},{20,250}];
get_all_probability(11)->[{21,750},{25,1000},{26,1000},{27,375},{31,500},{32,500},{33,375},{37,250},{38,250},{39,250},{40,250}];
get_all_probability(41)->[{41,750},{45,1000},{46,1000},{47,375},{51,500},{52,500},{53,375},{57,250},{58,250},{59,250},{60,250}];
get_all_probability(51)->[{61,1200},{65,1600},{66,1600},{67,150},{71,200},{72,200},{73,150},{77,100},{78,100},{79,100},{80,100}];
get_all_probability(61)->[{81,1350},{85,1800},{86,1800},{87,75},{91,100},{92,100},{93,75},{97,50},{98,50},{99,50},{100,50}];
get_all_probability(71)->[{101,1350},{105,1800},{106,1800},{107,75},{111,100},{112,100},{113,75},{117,50},{118,50},{119,50},{120,50}];
get_all_probability(81)->[{121,1350},{125,1800},{126,1800},{127,75},{128,75},{132,100},{133,75},{137,50},{138,50},{139,50},{140,50}];
get_all_probability(91)->[{141,1350},{145,1800},{146,1800},{147,75},{151,100},{152,100},{153,75},{157,50},{158,50},{159,50},{160,50}];
get_all_probability(101)->[{161,1350},{165,1800},{166,1800},{167,75},{171,100},{172,100},{173,75},{177,50},{178,50},{179,50},{180,50}];
get_all_probability(_)-> throw({false,114444}). 

get_probability(1,1)->[{1,750},{5,1000},{6,1000}];
get_probability(1,2)->[{7,375},{11,500},{12,500}];
get_probability(1,3)->[{13,375},{17,250},{18,250}];
get_probability(1,4)->[{19,250},{20,250}];
get_probability(11,1)->[{21,750},{25,1000},{26,1000}];
get_probability(11,2)->[{27,375},{31,500},{32,500}];
get_probability(11,3)->[{33,375},{37,250},{38,250}];
get_probability(11,4)->[{39,250},{40,250}];
get_probability(41,1)->[{41,750},{45,1000},{46,1000}];
get_probability(41,2)->[{47,375},{51,500},{52,500}];
get_probability(41,3)->[{53,375},{57,250},{58,250}];
get_probability(41,4)->[{59,250},{60,250}];
get_probability(51,1)->[{61,1200},{65,1600},{66,1600}];
get_probability(51,2)->[{67,150},{71,200},{72,200}];
get_probability(51,3)->[{73,150},{77,100},{78,100}];
get_probability(51,4)->[{79,100},{80,100}];
get_probability(61,1)->[{81,1350},{85,1800},{86,1800}];
get_probability(61,2)->[{87,75},{91,100},{92,100}];
get_probability(61,3)->[{93,75},{97,50},{98,50}];
get_probability(61,4)->[{99,50},{100,50}];
get_probability(71,1)->[{101,1350},{105,1800},{106,1800}];
get_probability(71,2)->[{107,75},{111,100},{112,100}];
get_probability(71,3)->[{113,75},{117,50},{118,50}];
get_probability(71,4)->[{119,50},{120,50}];
get_probability(81,1)->[{121,1350},{125,1800},{126,1800}];
get_probability(81,2)->[{127,75},{128,75},{132,100}];
get_probability(81,3)->[{133,75},{137,50},{138,50}];
get_probability(81,4)->[{139,50},{140,50}];
get_probability(91,1)->[{141,1350},{145,1800},{146,1800}];
get_probability(91,2)->[{147,75},{151,100},{152,100}];
get_probability(91,3)->[{153,75},{157,50},{158,50}];
get_probability(91,4)->[{159,50},{160,50}];
get_probability(101,1)->[{161,1350},{165,1800},{166,1800}];
get_probability(101,2)->[{167,75},{171,100},{172,100}];
get_probability(101,3)->[{173,75},{177,50},{178,50}];
get_probability(101,4)->[{179,50},{180,50}];
get_probability(_,_)-> throw({false,4444}). 

