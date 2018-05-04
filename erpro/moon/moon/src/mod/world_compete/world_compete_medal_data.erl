
%%----------------------------------------------------
%% 仙道会勋章数据
%% @author wpf0208@jieyou.cn
%% @end
%%----------------------------------------------------

-module(world_compete_medal_data).
-export([
        get_win_cnt/1
        ,get_attr/1
    ]).

%% 根据勋章等级，获取所需的胜利次数
get_win_cnt(1) ->
    1;
get_win_cnt(2) ->
    3;
get_win_cnt(3) ->
    5;
get_win_cnt(4) ->
    8;
get_win_cnt(5) ->
    11;
get_win_cnt(6) ->
    15;
get_win_cnt(7) ->
    19;
get_win_cnt(8) ->
    23;
get_win_cnt(9) ->
    27;
get_win_cnt(10) ->
    32;
get_win_cnt(11) ->
    36;
get_win_cnt(12) ->
    42;
get_win_cnt(13) ->
    47;
get_win_cnt(14) ->
    52;
get_win_cnt(15) ->
    58;
get_win_cnt(16) ->
    64;
get_win_cnt(17) ->
    70;
get_win_cnt(18) ->
    76;
get_win_cnt(19) ->
    83;
get_win_cnt(20) ->
    89;
get_win_cnt(21) ->
    96;
get_win_cnt(22) ->
    103;
get_win_cnt(23) ->
    110;
get_win_cnt(24) ->
    118;
get_win_cnt(25) ->
    125;
get_win_cnt(26) ->
    133;
get_win_cnt(27) ->
    140;
get_win_cnt(28) ->
    148;
get_win_cnt(29) ->
    156;
get_win_cnt(30) ->
    164;
get_win_cnt(31) ->
    173;
get_win_cnt(32) ->
    181;
get_win_cnt(33) ->
    190;
get_win_cnt(34) ->
    198;
get_win_cnt(35) ->
    207;
get_win_cnt(36) ->
    216;
get_win_cnt(37) ->
    225;
get_win_cnt(38) ->
    234;
get_win_cnt(39) ->
    244;
get_win_cnt(40) ->
    253;
get_win_cnt(41) ->
    263;
get_win_cnt(42) ->
    272;
get_win_cnt(43) ->
    282;
get_win_cnt(44) ->
    292;
get_win_cnt(45) ->
    302;
get_win_cnt(46) ->
    312;
get_win_cnt(47) ->
    322;
get_win_cnt(48) ->
    333;
get_win_cnt(49) ->
    343;
get_win_cnt(50) ->
    354;
get_win_cnt(51) ->
    364;
get_win_cnt(52) ->
    375;
get_win_cnt(53) ->
    386;
get_win_cnt(54) ->
    397;
get_win_cnt(55) ->
    408;
get_win_cnt(56) ->
    419;
get_win_cnt(57) ->
    430;
get_win_cnt(58) ->
    442;
get_win_cnt(59) ->
    453;
get_win_cnt(60) ->
    465;
get_win_cnt(61) ->
    476;
get_win_cnt(62) ->
    488;
get_win_cnt(63) ->
    500;
get_win_cnt(64) ->
    512;
get_win_cnt(65) ->
    524;
get_win_cnt(66) ->
    536;
get_win_cnt(67) ->
    548;
get_win_cnt(68) ->
    561;
get_win_cnt(69) ->
    573;
get_win_cnt(70) ->
    586;
get_win_cnt(71) ->
    598;
get_win_cnt(72) ->
    611;
get_win_cnt(73) ->
    624;
get_win_cnt(74) ->
    637;
get_win_cnt(75) ->
    650;
get_win_cnt(76) ->
    663;
get_win_cnt(77) ->
    676;
get_win_cnt(78) ->
    689;
get_win_cnt(79) ->
    702;
get_win_cnt(80) ->
    716;
get_win_cnt(81) ->
    729;
get_win_cnt(82) ->
    743;
get_win_cnt(83) ->
    756;
get_win_cnt(84) ->
    770;
get_win_cnt(85) ->
    784;
get_win_cnt(86) ->
    798;
get_win_cnt(87) ->
    811;
get_win_cnt(88) ->
    826;
get_win_cnt(89) ->
    840;
get_win_cnt(90) ->
    854;
get_win_cnt(91) ->
    868;
get_win_cnt(92) ->
    882;
get_win_cnt(93) ->
    897;
get_win_cnt(94) ->
    911;
get_win_cnt(95) ->
    926;
get_win_cnt(96) ->
    941;
get_win_cnt(97) ->
    955;
get_win_cnt(98) ->
    970;
get_win_cnt(99) ->
    985;
get_win_cnt(100) ->
    1003;
get_win_cnt(101) ->
    1022;
get_win_cnt(102) ->
    1042;
get_win_cnt(103) ->
    1063;
get_win_cnt(104) ->
    1085;
get_win_cnt(105) ->
    1108;
get_win_cnt(106) ->
    1132;
get_win_cnt(107) ->
    1157;
get_win_cnt(108) ->
    1183;
get_win_cnt(109) ->
    1210;
get_win_cnt(110) ->
    1238;
get_win_cnt(111) ->
    1267;
get_win_cnt(112) ->
    1297;
get_win_cnt(113) ->
    1327;
get_win_cnt(114) ->
    1358;
get_win_cnt(115) ->
    1390;
get_win_cnt(116) ->
    1423;
get_win_cnt(117) ->
    1457;
get_win_cnt(118) ->
    1492;
get_win_cnt(119) ->
    1528;
get_win_cnt(120) ->
    1565;
get_win_cnt(121) ->
    1603;
get_win_cnt(122) ->
    1642;
get_win_cnt(123) ->
    1682;
get_win_cnt(124) ->
    1723;
get_win_cnt(125) ->
    1765;
get_win_cnt(126) ->
    1808;
get_win_cnt(127) ->
    1852;
get_win_cnt(128) ->
    1897;
get_win_cnt(129) ->
    1943;
get_win_cnt(130) ->
    1990;
get_win_cnt(131) ->
    2038;
get_win_cnt(132) ->
    2087;
get_win_cnt(133) ->
    2137;
get_win_cnt(134) ->
    2188;
get_win_cnt(135) ->
    2240;
get_win_cnt(136) ->
    2293;
get_win_cnt(137) ->
    2347;
get_win_cnt(138) ->
    2401;
get_win_cnt(139) ->
    2456;
get_win_cnt(140) ->
    2512;
get_win_cnt(141) ->
    2569;
get_win_cnt(142) ->
    2627;
get_win_cnt(143) ->
    2686;
get_win_cnt(144) ->
    2746;
get_win_cnt(145) ->
    2807;
get_win_cnt(146) ->
    2869;
get_win_cnt(147) ->
    2932;
get_win_cnt(148) ->
    2996;
get_win_cnt(149) ->
    3061;
get_win_cnt(150) ->
    3127;
get_win_cnt(_) -> 9999999999.

% 根据勋章等级，获取对应属性
get_attr(1) ->
    [{hp_max,10},{resist_all,40}];
get_attr(2) ->
    [{hp_max,30},{resist_all,70}];
get_attr(3) ->
    [{hp_max,50},{resist_all,90}];
get_attr(4) ->
    [{hp_max,70},{resist_all,120}];
get_attr(5) ->
    [{hp_max,90},{resist_all,150}];
get_attr(6) ->
    [{hp_max,110},{resist_all,180}];
get_attr(7) ->
    [{hp_max,130},{resist_all,200}];
get_attr(8) ->
    [{hp_max,150},{resist_all,230}];
get_attr(9) ->
    [{hp_max,170},{resist_all,260}];
get_attr(10) ->
    [{hp_max,190},{resist_all,280}];
get_attr(11) ->
    [{hp_max,210},{resist_all,310}];
get_attr(12) ->
    [{hp_max,230},{resist_all,340}];
get_attr(13) ->
    [{hp_max,250},{resist_all,370}];
get_attr(14) ->
    [{hp_max,270},{resist_all,400}];
get_attr(15) ->
    [{hp_max,290},{resist_all,420}];
get_attr(16) ->
    [{hp_max,320},{resist_all,450}];
get_attr(17) ->
    [{hp_max,350},{resist_all,480}];
get_attr(18) ->
    [{hp_max,380},{resist_all,510}];
get_attr(19) ->
    [{hp_max,410},{resist_all,540}];
get_attr(20) ->
    [{hp_max,440},{resist_all,560}];
get_attr(21) ->
    [{hp_max,470},{resist_all,590}];
get_attr(22) ->
    [{hp_max,500},{resist_all,620}];
get_attr(23) ->
    [{hp_max,530},{resist_all,650}];
get_attr(24) ->
    [{hp_max,560},{resist_all,680}];
get_attr(25) ->
    [{hp_max,590},{resist_all,710}];
get_attr(26) ->
    [{hp_max,620},{resist_all,740}];
get_attr(27) ->
    [{hp_max,650},{resist_all,770}];
get_attr(28) ->
    [{hp_max,680},{resist_all,790}];
get_attr(29) ->
    [{hp_max,710},{resist_all,820}];
get_attr(30) ->
    [{hp_max,750},{resist_all,850}];
get_attr(31) ->
    [{hp_max,790},{resist_all,880}];
get_attr(32) ->
    [{hp_max,830},{resist_all,910}];
get_attr(33) ->
    [{hp_max,870},{resist_all,940}];
get_attr(34) ->
    [{hp_max,910},{resist_all,970}];
get_attr(35) ->
    [{hp_max,950},{resist_all,1000}];
get_attr(36) ->
    [{hp_max,990},{resist_all,1030}];
get_attr(37) ->
    [{hp_max,1030},{resist_all,1060}];
get_attr(38) ->
    [{hp_max,1070},{resist_all,1090}];
get_attr(39) ->
    [{hp_max,1110},{resist_all,1120}];
get_attr(40) ->
    [{hp_max,1150},{resist_all,1150}];
get_attr(41) ->
    [{hp_max,1190},{resist_all,1180}];
get_attr(42) ->
    [{hp_max,1230},{resist_all,1210}];
get_attr(43) ->
    [{hp_max,1270},{resist_all,1240}];
get_attr(44) ->
    [{hp_max,1320},{resist_all,1270}];
get_attr(45) ->
    [{hp_max,1370},{resist_all,1300}];
get_attr(46) ->
    [{hp_max,1420},{resist_all,1330}];
get_attr(47) ->
    [{hp_max,1470},{resist_all,1360}];
get_attr(48) ->
    [{hp_max,1530},{resist_all,1390}];
get_attr(49) ->
    [{hp_max,1590},{resist_all,1430}];
get_attr(50) ->
    [{hp_max,1650},{resist_all,1460}];
get_attr(51) ->
    [{hp_max,1710},{resist_all,1490}];
get_attr(52) ->
    [{hp_max,1780},{resist_all,1520}];
get_attr(53) ->
    [{hp_max,1850},{resist_all,1550}];
get_attr(54) ->
    [{hp_max,1920},{resist_all,1580}];
get_attr(55) ->
    [{hp_max,1990},{resist_all,1610}];
get_attr(56) ->
    [{hp_max,2070},{resist_all,1640}];
get_attr(57) ->
    [{hp_max,2150},{resist_all,1680}];
get_attr(58) ->
    [{hp_max,2230},{resist_all,1710}];
get_attr(59) ->
    [{hp_max,2310},{resist_all,1740}];
get_attr(60) ->
    [{hp_max,2400},{resist_all,1770}];
get_attr(61) ->
    [{hp_max,2490},{resist_all,1800}];
get_attr(62) ->
    [{hp_max,2580},{resist_all,1840}];
get_attr(63) ->
    [{hp_max,2670},{resist_all,1870}];
get_attr(64) ->
    [{hp_max,2770},{resist_all,1900}];
get_attr(65) ->
    [{hp_max,2870},{resist_all,1930}];
get_attr(66) ->
    [{hp_max,2970},{resist_all,1970}];
get_attr(67) ->
    [{hp_max,3070},{resist_all,2000}];
get_attr(68) ->
    [{hp_max,3180},{resist_all,2030}];
get_attr(69) ->
    [{hp_max,3290},{resist_all,2070}];
get_attr(70) ->
    [{hp_max,3400},{resist_all,2100}];
get_attr(71) ->
    [{hp_max,3510},{resist_all,2130}];
get_attr(72) ->
    [{hp_max,3630},{resist_all,2170}];
get_attr(73) ->
    [{hp_max,3750},{resist_all,2200}];
get_attr(74) ->
    [{hp_max,3870},{resist_all,2230}];
get_attr(75) ->
    [{hp_max,3990},{resist_all,2270}];
get_attr(76) ->
    [{hp_max,4120},{resist_all,2300}];
get_attr(77) ->
    [{hp_max,4250},{resist_all,2330}];
get_attr(78) ->
    [{hp_max,4380},{resist_all,2370}];
get_attr(79) ->
    [{hp_max,4510},{resist_all,2400}];
get_attr(80) ->
    [{hp_max,4650},{resist_all,2440}];
get_attr(81) ->
    [{hp_max,4790},{resist_all,2470}];
get_attr(82) ->
    [{hp_max,4930},{resist_all,2510}];
get_attr(83) ->
    [{hp_max,5070},{resist_all,2540}];
get_attr(84) ->
    [{hp_max,5220},{resist_all,2580}];
get_attr(85) ->
    [{hp_max,5370},{resist_all,2610}];
get_attr(86) ->
    [{hp_max,5520},{resist_all,2650}];
get_attr(87) ->
    [{hp_max,5670},{resist_all,2680}];
get_attr(88) ->
    [{hp_max,5830},{resist_all,2720}];
get_attr(89) ->
    [{hp_max,5990},{resist_all,2750}];
get_attr(90) ->
    [{hp_max,6150},{resist_all,2790}];
get_attr(91) ->
    [{hp_max,6310},{resist_all,2820}];
get_attr(92) ->
    [{hp_max,6480},{resist_all,2860}];
get_attr(93) ->
    [{hp_max,6650},{resist_all,2890}];
get_attr(94) ->
    [{hp_max,6820},{resist_all,2930}];
get_attr(95) ->
    [{hp_max,6990},{resist_all,2970}];
get_attr(96) ->
    [{hp_max,7170},{resist_all,3000}];
get_attr(97) ->
    [{hp_max,7350},{resist_all,3040}];
get_attr(98) ->
    [{hp_max,7530},{resist_all,3070}];
get_attr(99) ->
    [{hp_max,7710},{resist_all,3110}];
get_attr(100) ->
    [{hp_max,7840},{resist_all,3180}];
get_attr(101) ->
    [{hp_max,7970},{resist_all,3250}];
get_attr(102) ->
    [{hp_max,8100},{resist_all,3320}];
get_attr(103) ->
    [{hp_max,8230},{resist_all,3390}];
get_attr(104) ->
    [{hp_max,8360},{resist_all,3460}];
get_attr(105) ->
    [{hp_max,8490},{resist_all,3530}];
get_attr(106) ->
    [{hp_max,8620},{resist_all,3600}];
get_attr(107) ->
    [{hp_max,8750},{resist_all,3670}];
get_attr(108) ->
    [{hp_max,8880},{resist_all,3740}];
get_attr(109) ->
    [{hp_max,9010},{resist_all,3810}];
get_attr(110) ->
    [{hp_max,9140},{resist_all,3880}];
get_attr(111) ->
    [{hp_max,9270},{resist_all,3950}];
get_attr(112) ->
    [{hp_max,9400},{resist_all,4020}];
get_attr(113) ->
    [{hp_max,9530},{resist_all,4090}];
get_attr(114) ->
    [{hp_max,9660},{resist_all,4160}];
get_attr(115) ->
    [{hp_max,9790},{resist_all,4230}];
get_attr(116) ->
    [{hp_max,9920},{resist_all,4300}];
get_attr(117) ->
    [{hp_max,10050},{resist_all,4370}];
get_attr(118) ->
    [{hp_max,10180},{resist_all,4440}];
get_attr(119) ->
    [{hp_max,10310},{resist_all,4510}];
get_attr(120) ->
    [{hp_max,10440},{resist_all,4580}];
get_attr(121) ->
    [{hp_max,10570},{resist_all,4650}];
get_attr(122) ->
    [{hp_max,10700},{resist_all,4720}];
get_attr(123) ->
    [{hp_max,10830},{resist_all,4790}];
get_attr(124) ->
    [{hp_max,10960},{resist_all,4860}];
get_attr(125) ->
    [{hp_max,11090},{resist_all,4930}];
get_attr(126) ->
    [{hp_max,11220},{resist_all,5000}];
get_attr(127) ->
    [{hp_max,11350},{resist_all,5070}];
get_attr(128) ->
    [{hp_max,11480},{resist_all,5140}];
get_attr(129) ->
    [{hp_max,11610},{resist_all,5210}];
get_attr(130) ->
    [{hp_max,11740},{resist_all,5280}];
get_attr(131) ->
    [{hp_max,11870},{resist_all,5350}];
get_attr(132) ->
    [{hp_max,12000},{resist_all,5420}];
get_attr(133) ->
    [{hp_max,12130},{resist_all,5490}];
get_attr(134) ->
    [{hp_max,12260},{resist_all,5560}];
get_attr(135) ->
    [{hp_max,12390},{resist_all,5630}];
get_attr(136) ->
    [{hp_max,12520},{resist_all,5700}];
get_attr(137) ->
    [{hp_max,12650},{resist_all,5770}];
get_attr(138) ->
    [{hp_max,12780},{resist_all,5840}];
get_attr(139) ->
    [{hp_max,12910},{resist_all,5910}];
get_attr(140) ->
    [{hp_max,13040},{resist_all,5980}];
get_attr(141) ->
    [{hp_max,13170},{resist_all,6050}];
get_attr(142) ->
    [{hp_max,13300},{resist_all,6120}];
get_attr(143) ->
    [{hp_max,13430},{resist_all,6190}];
get_attr(144) ->
    [{hp_max,13560},{resist_all,6260}];
get_attr(145) ->
    [{hp_max,13690},{resist_all,6330}];
get_attr(146) ->
    [{hp_max,13820},{resist_all,6400}];
get_attr(147) ->
    [{hp_max,13950},{resist_all,6470}];
get_attr(148) ->
    [{hp_max,14080},{resist_all,6540}];
get_attr(149) ->
    [{hp_max,14210},{resist_all,6610}];
get_attr(150) ->
    [{hp_max,14340},{resist_all,6680}];
get_attr(_) -> [{error, 0}].
