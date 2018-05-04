%% -----------------------
%% 战力天平配置表
%% @autor wangweibiao
%% ------------------------
-module(fight_data).
-export([
		get_pet_lev_weight/0,
		get_demon_lev_weight/0,
		get_demon_grow_weight/0,
		get_channel_lev_weight/2,
		get_eqm_lev_weight/2
		]).
		
get_demon_grow_weight() ->
	5.
get_demon_lev_weight() ->
	5.
get_pet_lev_weight() ->
	5.
		
get_channel_lev_weight(1, 1) ->
	1;
get_channel_lev_weight(1, 2) ->
	3;
get_channel_lev_weight(1, 3) ->
	4;
get_channel_lev_weight(1, 4) ->
	6;
get_channel_lev_weight(1, 5) ->
	7;
get_channel_lev_weight(1, 6) ->
	9;
get_channel_lev_weight(1, 7) ->
	10;
get_channel_lev_weight(1, 8) ->
	12;
get_channel_lev_weight(1, 9) ->
	13;
get_channel_lev_weight(1, 10) ->
	15;
get_channel_lev_weight(1, 11) ->
	16;
get_channel_lev_weight(1, 12) ->
	18;
get_channel_lev_weight(1, 13) ->
	19;
get_channel_lev_weight(1, 14) ->
	21;
get_channel_lev_weight(1, 15) ->
	22;
get_channel_lev_weight(1, 16) ->
	24;
get_channel_lev_weight(1, 17) ->
	25;
get_channel_lev_weight(1, 18) ->
	27;
get_channel_lev_weight(1, 19) ->
	28;
get_channel_lev_weight(1, 20) ->
	30;
get_channel_lev_weight(1, 21) ->
	31;
get_channel_lev_weight(1, 22) ->
	33;
get_channel_lev_weight(1, 23) ->
	34;
get_channel_lev_weight(1, 24) ->
	36;
get_channel_lev_weight(1, 25) ->
	37;
get_channel_lev_weight(1, 26) ->
	39;
get_channel_lev_weight(1, 27) ->
	40;
get_channel_lev_weight(1, 28) ->
	42;
get_channel_lev_weight(1, 29) ->
	43;
get_channel_lev_weight(1, 30) ->
	45;
get_channel_lev_weight(1, 31) ->
	46;
get_channel_lev_weight(1, 32) ->
	48;
get_channel_lev_weight(1, 33) ->
	49;
get_channel_lev_weight(1, 34) ->
	51;
get_channel_lev_weight(1, 35) ->
	52;
get_channel_lev_weight(1, 36) ->
	54;
get_channel_lev_weight(1, 37) ->
	55;
get_channel_lev_weight(1, 38) ->
	57;
get_channel_lev_weight(1, 39) ->
	58;
get_channel_lev_weight(1, 40) ->
	60;
get_channel_lev_weight(1, 41) ->
	61;
get_channel_lev_weight(1, 42) ->
	63;
get_channel_lev_weight(1, 43) ->
	64;
get_channel_lev_weight(1, 44) ->
	66;
get_channel_lev_weight(1, 45) ->
	67;
get_channel_lev_weight(1, 46) ->
	69;
get_channel_lev_weight(1, 47) ->
	70;
get_channel_lev_weight(1, 48) ->
	72;
get_channel_lev_weight(1, 49) ->
	73;
get_channel_lev_weight(1, 50) ->
	75;
get_channel_lev_weight(1, 51) ->
	76;
get_channel_lev_weight(1, 52) ->
	78;
get_channel_lev_weight(1, 53) ->
	79;
get_channel_lev_weight(1, 54) ->
	81;
get_channel_lev_weight(1, 55) ->
	82;
get_channel_lev_weight(1, 56) ->
	84;
get_channel_lev_weight(1, 57) ->
	85;
get_channel_lev_weight(1, 58) ->
	87;
get_channel_lev_weight(1, 59) ->
	88;
get_channel_lev_weight(1, 60) ->
	90;
get_channel_lev_weight(1, 61) ->
	91;
get_channel_lev_weight(1, 62) ->
	93;
get_channel_lev_weight(1, 63) ->
	94;
get_channel_lev_weight(1, 64) ->
	96;
get_channel_lev_weight(1, 65) ->
	97;
get_channel_lev_weight(1, 66) ->
	99;
get_channel_lev_weight(1, 67) ->
	100;
get_channel_lev_weight(1, 68) ->
	102;
get_channel_lev_weight(1, 69) ->
	103;
get_channel_lev_weight(1, 70) ->
	105;
get_channel_lev_weight(1, 71) ->
	106;
get_channel_lev_weight(1, 72) ->
	108;
get_channel_lev_weight(1, 73) ->
	109;
get_channel_lev_weight(1, 74) ->
	111;
get_channel_lev_weight(1, 75) ->
	112;
get_channel_lev_weight(1, 76) ->
	114;
get_channel_lev_weight(1, 77) ->
	115;
get_channel_lev_weight(1, 78) ->
	117;
get_channel_lev_weight(1, 79) ->
	118;
get_channel_lev_weight(1, 80) ->
	120;
get_channel_lev_weight(1, 81) ->
	121;
get_channel_lev_weight(1, 82) ->
	123;
get_channel_lev_weight(1, 83) ->
	124;
get_channel_lev_weight(1, 84) ->
	126;
get_channel_lev_weight(1, 85) ->
	127;
get_channel_lev_weight(1, 86) ->
	129;
get_channel_lev_weight(1, 87) ->
	130;
get_channel_lev_weight(1, 88) ->
	132;
get_channel_lev_weight(1, 89) ->
	133;
get_channel_lev_weight(1, 90) ->
	135;
get_channel_lev_weight(1, 91) ->
	136;
get_channel_lev_weight(1, 92) ->
	138;
get_channel_lev_weight(1, 93) ->
	139;
get_channel_lev_weight(1, 94) ->
	141;
get_channel_lev_weight(1, 95) ->
	142;
get_channel_lev_weight(1, 96) ->
	144;
get_channel_lev_weight(1, 97) ->
	145;
get_channel_lev_weight(1, 98) ->
	147;
get_channel_lev_weight(1, 99) ->
	148;
get_channel_lev_weight(1, 100) ->
	150;
get_channel_lev_weight(1, 101) ->
	151;
get_channel_lev_weight(1, 102) ->
	153;
get_channel_lev_weight(1, 103) ->
	154;
get_channel_lev_weight(1, 104) ->
	156;
get_channel_lev_weight(1, 105) ->
	157;
get_channel_lev_weight(1, 106) ->
	159;
get_channel_lev_weight(1, 107) ->
	160;
get_channel_lev_weight(1, 108) ->
	162;
get_channel_lev_weight(1, 109) ->
	163;
get_channel_lev_weight(1, 110) ->
	165;
get_channel_lev_weight(1, 111) ->
	166;
get_channel_lev_weight(1, 112) ->
	168;
get_channel_lev_weight(1, 113) ->
	169;
get_channel_lev_weight(1, 114) ->
	171;
get_channel_lev_weight(1, 115) ->
	172;
get_channel_lev_weight(1, 116) ->
	174;
get_channel_lev_weight(1, 117) ->
	175;
get_channel_lev_weight(1, 118) ->
	177;
get_channel_lev_weight(1, 119) ->
	178;
get_channel_lev_weight(1, 120) ->
	180;
get_channel_lev_weight(1, 121) ->
	181;
get_channel_lev_weight(1, 122) ->
	183;
get_channel_lev_weight(1, 123) ->
	184;
get_channel_lev_weight(1, 124) ->
	186;
get_channel_lev_weight(1, 125) ->
	187;
get_channel_lev_weight(1, 126) ->
	189;
get_channel_lev_weight(1, 127) ->
	190;
get_channel_lev_weight(1, 128) ->
	192;
get_channel_lev_weight(1, 129) ->
	193;
get_channel_lev_weight(1, 130) ->
	195;
get_channel_lev_weight(1, 131) ->
	196;
get_channel_lev_weight(1, 132) ->
	198;
get_channel_lev_weight(1, 133) ->
	199;
get_channel_lev_weight(1, 134) ->
	201;
get_channel_lev_weight(1, 135) ->
	202;
get_channel_lev_weight(1, 136) ->
	204;
get_channel_lev_weight(1, 137) ->
	205;
get_channel_lev_weight(1, 138) ->
	207;
get_channel_lev_weight(1, 139) ->
	208;
get_channel_lev_weight(1, 140) ->
	210;
get_channel_lev_weight(1, 141) ->
	211;
get_channel_lev_weight(1, 142) ->
	213;
get_channel_lev_weight(1, 143) ->
	214;
get_channel_lev_weight(1, 144) ->
	216;
get_channel_lev_weight(1, 145) ->
	217;
get_channel_lev_weight(1, 146) ->
	219;
get_channel_lev_weight(1, 147) ->
	220;
get_channel_lev_weight(1, 148) ->
	222;
get_channel_lev_weight(1, 149) ->
	223;
get_channel_lev_weight(1, 150) ->
	225;
get_channel_lev_weight(1, 151) ->
	226;
get_channel_lev_weight(1, 152) ->
	228;
get_channel_lev_weight(1, 153) ->
	229;
get_channel_lev_weight(1, 154) ->
	231;
get_channel_lev_weight(1, 155) ->
	232;
get_channel_lev_weight(1, 156) ->
	234;
get_channel_lev_weight(1, 157) ->
	235;
get_channel_lev_weight(1, 158) ->
	237;
get_channel_lev_weight(1, 159) ->
	238;
get_channel_lev_weight(1, 160) ->
	240;
get_channel_lev_weight(1, 161) ->
	241;
get_channel_lev_weight(1, 162) ->
	243;
get_channel_lev_weight(1, 163) ->
	244;
get_channel_lev_weight(1, 164) ->
	246;
get_channel_lev_weight(1, 165) ->
	247;
get_channel_lev_weight(1, 166) ->
	249;
get_channel_lev_weight(1, 167) ->
	250;
get_channel_lev_weight(1, 168) ->
	252;
get_channel_lev_weight(1, 169) ->
	253;
get_channel_lev_weight(1, 170) ->
	255;
get_channel_lev_weight(1, 171) ->
	256;
get_channel_lev_weight(1, 172) ->
	258;
get_channel_lev_weight(1, 173) ->
	259;
get_channel_lev_weight(1, 174) ->
	261;
get_channel_lev_weight(1, 175) ->
	262;
get_channel_lev_weight(1, 176) ->
	264;
get_channel_lev_weight(1, 177) ->
	265;
get_channel_lev_weight(1, 178) ->
	267;
get_channel_lev_weight(1, 179) ->
	268;
get_channel_lev_weight(1, 180) ->
	270;
get_channel_lev_weight(1, 181) ->
	271;
get_channel_lev_weight(1, 182) ->
	273;
get_channel_lev_weight(1, 183) ->
	274;
get_channel_lev_weight(1, 184) ->
	276;
get_channel_lev_weight(1, 185) ->
	277;
get_channel_lev_weight(1, 186) ->
	279;
get_channel_lev_weight(1, 187) ->
	280;
get_channel_lev_weight(1, 188) ->
	282;
get_channel_lev_weight(1, 189) ->
	283;
get_channel_lev_weight(1, 190) ->
	285;
get_channel_lev_weight(1, 191) ->
	286;
get_channel_lev_weight(1, 192) ->
	288;
get_channel_lev_weight(1, 193) ->
	289;
get_channel_lev_weight(1, 194) ->
	291;
get_channel_lev_weight(1, 195) ->
	292;
get_channel_lev_weight(1, 196) ->
	294;
get_channel_lev_weight(1, 197) ->
	295;
get_channel_lev_weight(1, 198) ->
	297;
get_channel_lev_weight(1, 199) ->
	298;
get_channel_lev_weight(1, 200) ->
	300;
get_channel_lev_weight(2, 1) ->
	1;
get_channel_lev_weight(2, 2) ->
	3;
get_channel_lev_weight(2, 3) ->
	4;
get_channel_lev_weight(2, 4) ->
	6;
get_channel_lev_weight(2, 5) ->
	7;
get_channel_lev_weight(2, 6) ->
	9;
get_channel_lev_weight(2, 7) ->
	10;
get_channel_lev_weight(2, 8) ->
	12;
get_channel_lev_weight(2, 9) ->
	13;
get_channel_lev_weight(2, 10) ->
	15;
get_channel_lev_weight(2, 11) ->
	16;
get_channel_lev_weight(2, 12) ->
	18;
get_channel_lev_weight(2, 13) ->
	19;
get_channel_lev_weight(2, 14) ->
	21;
get_channel_lev_weight(2, 15) ->
	22;
get_channel_lev_weight(2, 16) ->
	24;
get_channel_lev_weight(2, 17) ->
	25;
get_channel_lev_weight(2, 18) ->
	27;
get_channel_lev_weight(2, 19) ->
	28;
get_channel_lev_weight(2, 20) ->
	30;
get_channel_lev_weight(2, 21) ->
	31;
get_channel_lev_weight(2, 22) ->
	33;
get_channel_lev_weight(2, 23) ->
	34;
get_channel_lev_weight(2, 24) ->
	36;
get_channel_lev_weight(2, 25) ->
	37;
get_channel_lev_weight(2, 26) ->
	39;
get_channel_lev_weight(2, 27) ->
	40;
get_channel_lev_weight(2, 28) ->
	42;
get_channel_lev_weight(2, 29) ->
	43;
get_channel_lev_weight(2, 30) ->
	45;
get_channel_lev_weight(2, 31) ->
	46;
get_channel_lev_weight(2, 32) ->
	48;
get_channel_lev_weight(2, 33) ->
	49;
get_channel_lev_weight(2, 34) ->
	51;
get_channel_lev_weight(2, 35) ->
	52;
get_channel_lev_weight(2, 36) ->
	54;
get_channel_lev_weight(2, 37) ->
	55;
get_channel_lev_weight(2, 38) ->
	57;
get_channel_lev_weight(2, 39) ->
	58;
get_channel_lev_weight(2, 40) ->
	60;
get_channel_lev_weight(2, 41) ->
	61;
get_channel_lev_weight(2, 42) ->
	63;
get_channel_lev_weight(2, 43) ->
	64;
get_channel_lev_weight(2, 44) ->
	66;
get_channel_lev_weight(2, 45) ->
	67;
get_channel_lev_weight(2, 46) ->
	69;
get_channel_lev_weight(2, 47) ->
	70;
get_channel_lev_weight(2, 48) ->
	72;
get_channel_lev_weight(2, 49) ->
	73;
get_channel_lev_weight(2, 50) ->
	75;
get_channel_lev_weight(2, 51) ->
	76;
get_channel_lev_weight(2, 52) ->
	78;
get_channel_lev_weight(2, 53) ->
	79;
get_channel_lev_weight(2, 54) ->
	81;
get_channel_lev_weight(2, 55) ->
	82;
get_channel_lev_weight(2, 56) ->
	84;
get_channel_lev_weight(2, 57) ->
	85;
get_channel_lev_weight(2, 58) ->
	87;
get_channel_lev_weight(2, 59) ->
	88;
get_channel_lev_weight(2, 60) ->
	90;
get_channel_lev_weight(2, 61) ->
	91;
get_channel_lev_weight(2, 62) ->
	93;
get_channel_lev_weight(2, 63) ->
	94;
get_channel_lev_weight(2, 64) ->
	96;
get_channel_lev_weight(2, 65) ->
	97;
get_channel_lev_weight(2, 66) ->
	99;
get_channel_lev_weight(2, 67) ->
	100;
get_channel_lev_weight(2, 68) ->
	102;
get_channel_lev_weight(2, 69) ->
	103;
get_channel_lev_weight(2, 70) ->
	105;
get_channel_lev_weight(2, 71) ->
	106;
get_channel_lev_weight(2, 72) ->
	108;
get_channel_lev_weight(2, 73) ->
	109;
get_channel_lev_weight(2, 74) ->
	111;
get_channel_lev_weight(2, 75) ->
	112;
get_channel_lev_weight(2, 76) ->
	114;
get_channel_lev_weight(2, 77) ->
	115;
get_channel_lev_weight(2, 78) ->
	117;
get_channel_lev_weight(2, 79) ->
	118;
get_channel_lev_weight(2, 80) ->
	120;
get_channel_lev_weight(2, 81) ->
	121;
get_channel_lev_weight(2, 82) ->
	123;
get_channel_lev_weight(2, 83) ->
	124;
get_channel_lev_weight(2, 84) ->
	126;
get_channel_lev_weight(2, 85) ->
	127;
get_channel_lev_weight(2, 86) ->
	129;
get_channel_lev_weight(2, 87) ->
	130;
get_channel_lev_weight(2, 88) ->
	132;
get_channel_lev_weight(2, 89) ->
	133;
get_channel_lev_weight(2, 90) ->
	135;
get_channel_lev_weight(2, 91) ->
	136;
get_channel_lev_weight(2, 92) ->
	138;
get_channel_lev_weight(2, 93) ->
	139;
get_channel_lev_weight(2, 94) ->
	141;
get_channel_lev_weight(2, 95) ->
	142;
get_channel_lev_weight(2, 96) ->
	144;
get_channel_lev_weight(2, 97) ->
	145;
get_channel_lev_weight(2, 98) ->
	147;
get_channel_lev_weight(2, 99) ->
	148;
get_channel_lev_weight(2, 100) ->
	150;
get_channel_lev_weight(2, 101) ->
	151;
get_channel_lev_weight(2, 102) ->
	153;
get_channel_lev_weight(2, 103) ->
	154;
get_channel_lev_weight(2, 104) ->
	156;
get_channel_lev_weight(2, 105) ->
	157;
get_channel_lev_weight(2, 106) ->
	159;
get_channel_lev_weight(2, 107) ->
	160;
get_channel_lev_weight(2, 108) ->
	162;
get_channel_lev_weight(2, 109) ->
	163;
get_channel_lev_weight(2, 110) ->
	165;
get_channel_lev_weight(2, 111) ->
	166;
get_channel_lev_weight(2, 112) ->
	168;
get_channel_lev_weight(2, 113) ->
	169;
get_channel_lev_weight(2, 114) ->
	171;
get_channel_lev_weight(2, 115) ->
	172;
get_channel_lev_weight(2, 116) ->
	174;
get_channel_lev_weight(2, 117) ->
	175;
get_channel_lev_weight(2, 118) ->
	177;
get_channel_lev_weight(2, 119) ->
	178;
get_channel_lev_weight(2, 120) ->
	180;
get_channel_lev_weight(2, 121) ->
	181;
get_channel_lev_weight(2, 122) ->
	183;
get_channel_lev_weight(2, 123) ->
	184;
get_channel_lev_weight(2, 124) ->
	186;
get_channel_lev_weight(2, 125) ->
	187;
get_channel_lev_weight(2, 126) ->
	189;
get_channel_lev_weight(2, 127) ->
	190;
get_channel_lev_weight(2, 128) ->
	192;
get_channel_lev_weight(2, 129) ->
	193;
get_channel_lev_weight(2, 130) ->
	195;
get_channel_lev_weight(2, 131) ->
	196;
get_channel_lev_weight(2, 132) ->
	198;
get_channel_lev_weight(2, 133) ->
	199;
get_channel_lev_weight(2, 134) ->
	201;
get_channel_lev_weight(2, 135) ->
	202;
get_channel_lev_weight(2, 136) ->
	204;
get_channel_lev_weight(2, 137) ->
	205;
get_channel_lev_weight(2, 138) ->
	207;
get_channel_lev_weight(2, 139) ->
	208;
get_channel_lev_weight(2, 140) ->
	210;
get_channel_lev_weight(2, 141) ->
	211;
get_channel_lev_weight(2, 142) ->
	213;
get_channel_lev_weight(2, 143) ->
	214;
get_channel_lev_weight(2, 144) ->
	216;
get_channel_lev_weight(2, 145) ->
	217;
get_channel_lev_weight(2, 146) ->
	219;
get_channel_lev_weight(2, 147) ->
	220;
get_channel_lev_weight(2, 148) ->
	222;
get_channel_lev_weight(2, 149) ->
	223;
get_channel_lev_weight(2, 150) ->
	225;
get_channel_lev_weight(2, 151) ->
	226;
get_channel_lev_weight(2, 152) ->
	228;
get_channel_lev_weight(2, 153) ->
	229;
get_channel_lev_weight(2, 154) ->
	231;
get_channel_lev_weight(2, 155) ->
	232;
get_channel_lev_weight(2, 156) ->
	234;
get_channel_lev_weight(2, 157) ->
	235;
get_channel_lev_weight(2, 158) ->
	237;
get_channel_lev_weight(2, 159) ->
	238;
get_channel_lev_weight(2, 160) ->
	240;
get_channel_lev_weight(2, 161) ->
	241;
get_channel_lev_weight(2, 162) ->
	243;
get_channel_lev_weight(2, 163) ->
	244;
get_channel_lev_weight(2, 164) ->
	246;
get_channel_lev_weight(2, 165) ->
	247;
get_channel_lev_weight(2, 166) ->
	249;
get_channel_lev_weight(2, 167) ->
	250;
get_channel_lev_weight(2, 168) ->
	252;
get_channel_lev_weight(2, 169) ->
	253;
get_channel_lev_weight(2, 170) ->
	255;
get_channel_lev_weight(2, 171) ->
	256;
get_channel_lev_weight(2, 172) ->
	258;
get_channel_lev_weight(2, 173) ->
	259;
get_channel_lev_weight(2, 174) ->
	261;
get_channel_lev_weight(2, 175) ->
	262;
get_channel_lev_weight(2, 176) ->
	264;
get_channel_lev_weight(2, 177) ->
	265;
get_channel_lev_weight(2, 178) ->
	267;
get_channel_lev_weight(2, 179) ->
	268;
get_channel_lev_weight(2, 180) ->
	270;
get_channel_lev_weight(2, 181) ->
	271;
get_channel_lev_weight(2, 182) ->
	273;
get_channel_lev_weight(2, 183) ->
	274;
get_channel_lev_weight(2, 184) ->
	276;
get_channel_lev_weight(2, 185) ->
	277;
get_channel_lev_weight(2, 186) ->
	279;
get_channel_lev_weight(2, 187) ->
	280;
get_channel_lev_weight(2, 188) ->
	282;
get_channel_lev_weight(2, 189) ->
	283;
get_channel_lev_weight(2, 190) ->
	285;
get_channel_lev_weight(2, 191) ->
	286;
get_channel_lev_weight(2, 192) ->
	288;
get_channel_lev_weight(2, 193) ->
	289;
get_channel_lev_weight(2, 194) ->
	291;
get_channel_lev_weight(2, 195) ->
	292;
get_channel_lev_weight(2, 196) ->
	294;
get_channel_lev_weight(2, 197) ->
	295;
get_channel_lev_weight(2, 198) ->
	297;
get_channel_lev_weight(2, 199) ->
	298;
get_channel_lev_weight(2, 200) ->
	300;
get_channel_lev_weight(3, 1) ->
	1;
get_channel_lev_weight(3, 2) ->
	3;
get_channel_lev_weight(3, 3) ->
	4;
get_channel_lev_weight(3, 4) ->
	6;
get_channel_lev_weight(3, 5) ->
	7;
get_channel_lev_weight(3, 6) ->
	9;
get_channel_lev_weight(3, 7) ->
	10;
get_channel_lev_weight(3, 8) ->
	12;
get_channel_lev_weight(3, 9) ->
	13;
get_channel_lev_weight(3, 10) ->
	15;
get_channel_lev_weight(3, 11) ->
	16;
get_channel_lev_weight(3, 12) ->
	18;
get_channel_lev_weight(3, 13) ->
	19;
get_channel_lev_weight(3, 14) ->
	21;
get_channel_lev_weight(3, 15) ->
	22;
get_channel_lev_weight(3, 16) ->
	24;
get_channel_lev_weight(3, 17) ->
	25;
get_channel_lev_weight(3, 18) ->
	27;
get_channel_lev_weight(3, 19) ->
	28;
get_channel_lev_weight(3, 20) ->
	30;
get_channel_lev_weight(3, 21) ->
	31;
get_channel_lev_weight(3, 22) ->
	33;
get_channel_lev_weight(3, 23) ->
	34;
get_channel_lev_weight(3, 24) ->
	36;
get_channel_lev_weight(3, 25) ->
	37;
get_channel_lev_weight(3, 26) ->
	39;
get_channel_lev_weight(3, 27) ->
	40;
get_channel_lev_weight(3, 28) ->
	42;
get_channel_lev_weight(3, 29) ->
	43;
get_channel_lev_weight(3, 30) ->
	45;
get_channel_lev_weight(3, 31) ->
	46;
get_channel_lev_weight(3, 32) ->
	48;
get_channel_lev_weight(3, 33) ->
	49;
get_channel_lev_weight(3, 34) ->
	51;
get_channel_lev_weight(3, 35) ->
	52;
get_channel_lev_weight(3, 36) ->
	54;
get_channel_lev_weight(3, 37) ->
	55;
get_channel_lev_weight(3, 38) ->
	57;
get_channel_lev_weight(3, 39) ->
	58;
get_channel_lev_weight(3, 40) ->
	60;
get_channel_lev_weight(3, 41) ->
	61;
get_channel_lev_weight(3, 42) ->
	63;
get_channel_lev_weight(3, 43) ->
	64;
get_channel_lev_weight(3, 44) ->
	66;
get_channel_lev_weight(3, 45) ->
	67;
get_channel_lev_weight(3, 46) ->
	69;
get_channel_lev_weight(3, 47) ->
	70;
get_channel_lev_weight(3, 48) ->
	72;
get_channel_lev_weight(3, 49) ->
	73;
get_channel_lev_weight(3, 50) ->
	75;
get_channel_lev_weight(3, 51) ->
	76;
get_channel_lev_weight(3, 52) ->
	78;
get_channel_lev_weight(3, 53) ->
	79;
get_channel_lev_weight(3, 54) ->
	81;
get_channel_lev_weight(3, 55) ->
	82;
get_channel_lev_weight(3, 56) ->
	84;
get_channel_lev_weight(3, 57) ->
	85;
get_channel_lev_weight(3, 58) ->
	87;
get_channel_lev_weight(3, 59) ->
	88;
get_channel_lev_weight(3, 60) ->
	90;
get_channel_lev_weight(3, 61) ->
	91;
get_channel_lev_weight(3, 62) ->
	93;
get_channel_lev_weight(3, 63) ->
	94;
get_channel_lev_weight(3, 64) ->
	96;
get_channel_lev_weight(3, 65) ->
	97;
get_channel_lev_weight(3, 66) ->
	99;
get_channel_lev_weight(3, 67) ->
	100;
get_channel_lev_weight(3, 68) ->
	102;
get_channel_lev_weight(3, 69) ->
	103;
get_channel_lev_weight(3, 70) ->
	105;
get_channel_lev_weight(3, 71) ->
	106;
get_channel_lev_weight(3, 72) ->
	108;
get_channel_lev_weight(3, 73) ->
	109;
get_channel_lev_weight(3, 74) ->
	111;
get_channel_lev_weight(3, 75) ->
	112;
get_channel_lev_weight(3, 76) ->
	114;
get_channel_lev_weight(3, 77) ->
	115;
get_channel_lev_weight(3, 78) ->
	117;
get_channel_lev_weight(3, 79) ->
	118;
get_channel_lev_weight(3, 80) ->
	120;
get_channel_lev_weight(3, 81) ->
	121;
get_channel_lev_weight(3, 82) ->
	123;
get_channel_lev_weight(3, 83) ->
	124;
get_channel_lev_weight(3, 84) ->
	126;
get_channel_lev_weight(3, 85) ->
	127;
get_channel_lev_weight(3, 86) ->
	129;
get_channel_lev_weight(3, 87) ->
	130;
get_channel_lev_weight(3, 88) ->
	132;
get_channel_lev_weight(3, 89) ->
	133;
get_channel_lev_weight(3, 90) ->
	135;
get_channel_lev_weight(3, 91) ->
	136;
get_channel_lev_weight(3, 92) ->
	138;
get_channel_lev_weight(3, 93) ->
	139;
get_channel_lev_weight(3, 94) ->
	141;
get_channel_lev_weight(3, 95) ->
	142;
get_channel_lev_weight(3, 96) ->
	144;
get_channel_lev_weight(3, 97) ->
	145;
get_channel_lev_weight(3, 98) ->
	147;
get_channel_lev_weight(3, 99) ->
	148;
get_channel_lev_weight(3, 100) ->
	150;
get_channel_lev_weight(3, 101) ->
	151;
get_channel_lev_weight(3, 102) ->
	153;
get_channel_lev_weight(3, 103) ->
	154;
get_channel_lev_weight(3, 104) ->
	156;
get_channel_lev_weight(3, 105) ->
	157;
get_channel_lev_weight(3, 106) ->
	159;
get_channel_lev_weight(3, 107) ->
	160;
get_channel_lev_weight(3, 108) ->
	162;
get_channel_lev_weight(3, 109) ->
	163;
get_channel_lev_weight(3, 110) ->
	165;
get_channel_lev_weight(3, 111) ->
	166;
get_channel_lev_weight(3, 112) ->
	168;
get_channel_lev_weight(3, 113) ->
	169;
get_channel_lev_weight(3, 114) ->
	171;
get_channel_lev_weight(3, 115) ->
	172;
get_channel_lev_weight(3, 116) ->
	174;
get_channel_lev_weight(3, 117) ->
	175;
get_channel_lev_weight(3, 118) ->
	177;
get_channel_lev_weight(3, 119) ->
	178;
get_channel_lev_weight(3, 120) ->
	180;
get_channel_lev_weight(3, 121) ->
	181;
get_channel_lev_weight(3, 122) ->
	183;
get_channel_lev_weight(3, 123) ->
	184;
get_channel_lev_weight(3, 124) ->
	186;
get_channel_lev_weight(3, 125) ->
	187;
get_channel_lev_weight(3, 126) ->
	189;
get_channel_lev_weight(3, 127) ->
	190;
get_channel_lev_weight(3, 128) ->
	192;
get_channel_lev_weight(3, 129) ->
	193;
get_channel_lev_weight(3, 130) ->
	195;
get_channel_lev_weight(3, 131) ->
	196;
get_channel_lev_weight(3, 132) ->
	198;
get_channel_lev_weight(3, 133) ->
	199;
get_channel_lev_weight(3, 134) ->
	201;
get_channel_lev_weight(3, 135) ->
	202;
get_channel_lev_weight(3, 136) ->
	204;
get_channel_lev_weight(3, 137) ->
	205;
get_channel_lev_weight(3, 138) ->
	207;
get_channel_lev_weight(3, 139) ->
	208;
get_channel_lev_weight(3, 140) ->
	210;
get_channel_lev_weight(3, 141) ->
	211;
get_channel_lev_weight(3, 142) ->
	213;
get_channel_lev_weight(3, 143) ->
	214;
get_channel_lev_weight(3, 144) ->
	216;
get_channel_lev_weight(3, 145) ->
	217;
get_channel_lev_weight(3, 146) ->
	219;
get_channel_lev_weight(3, 147) ->
	220;
get_channel_lev_weight(3, 148) ->
	222;
get_channel_lev_weight(3, 149) ->
	223;
get_channel_lev_weight(3, 150) ->
	225;
get_channel_lev_weight(3, 151) ->
	226;
get_channel_lev_weight(3, 152) ->
	228;
get_channel_lev_weight(3, 153) ->
	229;
get_channel_lev_weight(3, 154) ->
	231;
get_channel_lev_weight(3, 155) ->
	232;
get_channel_lev_weight(3, 156) ->
	234;
get_channel_lev_weight(3, 157) ->
	235;
get_channel_lev_weight(3, 158) ->
	237;
get_channel_lev_weight(3, 159) ->
	238;
get_channel_lev_weight(3, 160) ->
	240;
get_channel_lev_weight(3, 161) ->
	241;
get_channel_lev_weight(3, 162) ->
	243;
get_channel_lev_weight(3, 163) ->
	244;
get_channel_lev_weight(3, 164) ->
	246;
get_channel_lev_weight(3, 165) ->
	247;
get_channel_lev_weight(3, 166) ->
	249;
get_channel_lev_weight(3, 167) ->
	250;
get_channel_lev_weight(3, 168) ->
	252;
get_channel_lev_weight(3, 169) ->
	253;
get_channel_lev_weight(3, 170) ->
	255;
get_channel_lev_weight(3, 171) ->
	256;
get_channel_lev_weight(3, 172) ->
	258;
get_channel_lev_weight(3, 173) ->
	259;
get_channel_lev_weight(3, 174) ->
	261;
get_channel_lev_weight(3, 175) ->
	262;
get_channel_lev_weight(3, 176) ->
	264;
get_channel_lev_weight(3, 177) ->
	265;
get_channel_lev_weight(3, 178) ->
	267;
get_channel_lev_weight(3, 179) ->
	268;
get_channel_lev_weight(3, 180) ->
	270;
get_channel_lev_weight(3, 181) ->
	271;
get_channel_lev_weight(3, 182) ->
	273;
get_channel_lev_weight(3, 183) ->
	274;
get_channel_lev_weight(3, 184) ->
	276;
get_channel_lev_weight(3, 185) ->
	277;
get_channel_lev_weight(3, 186) ->
	279;
get_channel_lev_weight(3, 187) ->
	280;
get_channel_lev_weight(3, 188) ->
	282;
get_channel_lev_weight(3, 189) ->
	283;
get_channel_lev_weight(3, 190) ->
	285;
get_channel_lev_weight(3, 191) ->
	286;
get_channel_lev_weight(3, 192) ->
	288;
get_channel_lev_weight(3, 193) ->
	289;
get_channel_lev_weight(3, 194) ->
	291;
get_channel_lev_weight(3, 195) ->
	292;
get_channel_lev_weight(3, 196) ->
	294;
get_channel_lev_weight(3, 197) ->
	295;
get_channel_lev_weight(3, 198) ->
	297;
get_channel_lev_weight(3, 199) ->
	298;
get_channel_lev_weight(3, 200) ->
	300;
get_channel_lev_weight(4, 1) ->
	1;
get_channel_lev_weight(4, 2) ->
	3;
get_channel_lev_weight(4, 3) ->
	4;
get_channel_lev_weight(4, 4) ->
	6;
get_channel_lev_weight(4, 5) ->
	7;
get_channel_lev_weight(4, 6) ->
	9;
get_channel_lev_weight(4, 7) ->
	10;
get_channel_lev_weight(4, 8) ->
	12;
get_channel_lev_weight(4, 9) ->
	13;
get_channel_lev_weight(4, 10) ->
	15;
get_channel_lev_weight(4, 11) ->
	16;
get_channel_lev_weight(4, 12) ->
	18;
get_channel_lev_weight(4, 13) ->
	19;
get_channel_lev_weight(4, 14) ->
	21;
get_channel_lev_weight(4, 15) ->
	22;
get_channel_lev_weight(4, 16) ->
	24;
get_channel_lev_weight(4, 17) ->
	25;
get_channel_lev_weight(4, 18) ->
	27;
get_channel_lev_weight(4, 19) ->
	28;
get_channel_lev_weight(4, 20) ->
	30;
get_channel_lev_weight(4, 21) ->
	31;
get_channel_lev_weight(4, 22) ->
	33;
get_channel_lev_weight(4, 23) ->
	34;
get_channel_lev_weight(4, 24) ->
	36;
get_channel_lev_weight(4, 25) ->
	37;
get_channel_lev_weight(4, 26) ->
	39;
get_channel_lev_weight(4, 27) ->
	40;
get_channel_lev_weight(4, 28) ->
	42;
get_channel_lev_weight(4, 29) ->
	43;
get_channel_lev_weight(4, 30) ->
	45;
get_channel_lev_weight(4, 31) ->
	46;
get_channel_lev_weight(4, 32) ->
	48;
get_channel_lev_weight(4, 33) ->
	49;
get_channel_lev_weight(4, 34) ->
	51;
get_channel_lev_weight(4, 35) ->
	52;
get_channel_lev_weight(4, 36) ->
	54;
get_channel_lev_weight(4, 37) ->
	55;
get_channel_lev_weight(4, 38) ->
	57;
get_channel_lev_weight(4, 39) ->
	58;
get_channel_lev_weight(4, 40) ->
	60;
get_channel_lev_weight(4, 41) ->
	61;
get_channel_lev_weight(4, 42) ->
	63;
get_channel_lev_weight(4, 43) ->
	64;
get_channel_lev_weight(4, 44) ->
	66;
get_channel_lev_weight(4, 45) ->
	67;
get_channel_lev_weight(4, 46) ->
	69;
get_channel_lev_weight(4, 47) ->
	70;
get_channel_lev_weight(4, 48) ->
	72;
get_channel_lev_weight(4, 49) ->
	73;
get_channel_lev_weight(4, 50) ->
	75;
get_channel_lev_weight(4, 51) ->
	76;
get_channel_lev_weight(4, 52) ->
	78;
get_channel_lev_weight(4, 53) ->
	79;
get_channel_lev_weight(4, 54) ->
	81;
get_channel_lev_weight(4, 55) ->
	82;
get_channel_lev_weight(4, 56) ->
	84;
get_channel_lev_weight(4, 57) ->
	85;
get_channel_lev_weight(4, 58) ->
	87;
get_channel_lev_weight(4, 59) ->
	88;
get_channel_lev_weight(4, 60) ->
	90;
get_channel_lev_weight(4, 61) ->
	91;
get_channel_lev_weight(4, 62) ->
	93;
get_channel_lev_weight(4, 63) ->
	94;
get_channel_lev_weight(4, 64) ->
	96;
get_channel_lev_weight(4, 65) ->
	97;
get_channel_lev_weight(4, 66) ->
	99;
get_channel_lev_weight(4, 67) ->
	100;
get_channel_lev_weight(4, 68) ->
	102;
get_channel_lev_weight(4, 69) ->
	103;
get_channel_lev_weight(4, 70) ->
	105;
get_channel_lev_weight(4, 71) ->
	106;
get_channel_lev_weight(4, 72) ->
	108;
get_channel_lev_weight(4, 73) ->
	109;
get_channel_lev_weight(4, 74) ->
	111;
get_channel_lev_weight(4, 75) ->
	112;
get_channel_lev_weight(4, 76) ->
	114;
get_channel_lev_weight(4, 77) ->
	115;
get_channel_lev_weight(4, 78) ->
	117;
get_channel_lev_weight(4, 79) ->
	118;
get_channel_lev_weight(4, 80) ->
	120;
get_channel_lev_weight(4, 81) ->
	121;
get_channel_lev_weight(4, 82) ->
	123;
get_channel_lev_weight(4, 83) ->
	124;
get_channel_lev_weight(4, 84) ->
	126;
get_channel_lev_weight(4, 85) ->
	127;
get_channel_lev_weight(4, 86) ->
	129;
get_channel_lev_weight(4, 87) ->
	130;
get_channel_lev_weight(4, 88) ->
	132;
get_channel_lev_weight(4, 89) ->
	133;
get_channel_lev_weight(4, 90) ->
	135;
get_channel_lev_weight(4, 91) ->
	136;
get_channel_lev_weight(4, 92) ->
	138;
get_channel_lev_weight(4, 93) ->
	139;
get_channel_lev_weight(4, 94) ->
	141;
get_channel_lev_weight(4, 95) ->
	142;
get_channel_lev_weight(4, 96) ->
	144;
get_channel_lev_weight(4, 97) ->
	145;
get_channel_lev_weight(4, 98) ->
	147;
get_channel_lev_weight(4, 99) ->
	148;
get_channel_lev_weight(4, 100) ->
	150;
get_channel_lev_weight(4, 101) ->
	151;
get_channel_lev_weight(4, 102) ->
	153;
get_channel_lev_weight(4, 103) ->
	154;
get_channel_lev_weight(4, 104) ->
	156;
get_channel_lev_weight(4, 105) ->
	157;
get_channel_lev_weight(4, 106) ->
	159;
get_channel_lev_weight(4, 107) ->
	160;
get_channel_lev_weight(4, 108) ->
	162;
get_channel_lev_weight(4, 109) ->
	163;
get_channel_lev_weight(4, 110) ->
	165;
get_channel_lev_weight(4, 111) ->
	166;
get_channel_lev_weight(4, 112) ->
	168;
get_channel_lev_weight(4, 113) ->
	169;
get_channel_lev_weight(4, 114) ->
	171;
get_channel_lev_weight(4, 115) ->
	172;
get_channel_lev_weight(4, 116) ->
	174;
get_channel_lev_weight(4, 117) ->
	175;
get_channel_lev_weight(4, 118) ->
	177;
get_channel_lev_weight(4, 119) ->
	178;
get_channel_lev_weight(4, 120) ->
	180;
get_channel_lev_weight(4, 121) ->
	181;
get_channel_lev_weight(4, 122) ->
	183;
get_channel_lev_weight(4, 123) ->
	184;
get_channel_lev_weight(4, 124) ->
	186;
get_channel_lev_weight(4, 125) ->
	187;
get_channel_lev_weight(4, 126) ->
	189;
get_channel_lev_weight(4, 127) ->
	190;
get_channel_lev_weight(4, 128) ->
	192;
get_channel_lev_weight(4, 129) ->
	193;
get_channel_lev_weight(4, 130) ->
	195;
get_channel_lev_weight(4, 131) ->
	196;
get_channel_lev_weight(4, 132) ->
	198;
get_channel_lev_weight(4, 133) ->
	199;
get_channel_lev_weight(4, 134) ->
	201;
get_channel_lev_weight(4, 135) ->
	202;
get_channel_lev_weight(4, 136) ->
	204;
get_channel_lev_weight(4, 137) ->
	205;
get_channel_lev_weight(4, 138) ->
	207;
get_channel_lev_weight(4, 139) ->
	208;
get_channel_lev_weight(4, 140) ->
	210;
get_channel_lev_weight(4, 141) ->
	211;
get_channel_lev_weight(4, 142) ->
	213;
get_channel_lev_weight(4, 143) ->
	214;
get_channel_lev_weight(4, 144) ->
	216;
get_channel_lev_weight(4, 145) ->
	217;
get_channel_lev_weight(4, 146) ->
	219;
get_channel_lev_weight(4, 147) ->
	220;
get_channel_lev_weight(4, 148) ->
	222;
get_channel_lev_weight(4, 149) ->
	223;
get_channel_lev_weight(4, 150) ->
	225;
get_channel_lev_weight(4, 151) ->
	226;
get_channel_lev_weight(4, 152) ->
	228;
get_channel_lev_weight(4, 153) ->
	229;
get_channel_lev_weight(4, 154) ->
	231;
get_channel_lev_weight(4, 155) ->
	232;
get_channel_lev_weight(4, 156) ->
	234;
get_channel_lev_weight(4, 157) ->
	235;
get_channel_lev_weight(4, 158) ->
	237;
get_channel_lev_weight(4, 159) ->
	238;
get_channel_lev_weight(4, 160) ->
	240;
get_channel_lev_weight(4, 161) ->
	241;
get_channel_lev_weight(4, 162) ->
	243;
get_channel_lev_weight(4, 163) ->
	244;
get_channel_lev_weight(4, 164) ->
	246;
get_channel_lev_weight(4, 165) ->
	247;
get_channel_lev_weight(4, 166) ->
	249;
get_channel_lev_weight(4, 167) ->
	250;
get_channel_lev_weight(4, 168) ->
	252;
get_channel_lev_weight(4, 169) ->
	253;
get_channel_lev_weight(4, 170) ->
	255;
get_channel_lev_weight(4, 171) ->
	256;
get_channel_lev_weight(4, 172) ->
	258;
get_channel_lev_weight(4, 173) ->
	259;
get_channel_lev_weight(4, 174) ->
	261;
get_channel_lev_weight(4, 175) ->
	262;
get_channel_lev_weight(4, 176) ->
	264;
get_channel_lev_weight(4, 177) ->
	265;
get_channel_lev_weight(4, 178) ->
	267;
get_channel_lev_weight(4, 179) ->
	268;
get_channel_lev_weight(4, 180) ->
	270;
get_channel_lev_weight(4, 181) ->
	271;
get_channel_lev_weight(4, 182) ->
	273;
get_channel_lev_weight(4, 183) ->
	274;
get_channel_lev_weight(4, 184) ->
	276;
get_channel_lev_weight(4, 185) ->
	277;
get_channel_lev_weight(4, 186) ->
	279;
get_channel_lev_weight(4, 187) ->
	280;
get_channel_lev_weight(4, 188) ->
	282;
get_channel_lev_weight(4, 189) ->
	283;
get_channel_lev_weight(4, 190) ->
	285;
get_channel_lev_weight(4, 191) ->
	286;
get_channel_lev_weight(4, 192) ->
	288;
get_channel_lev_weight(4, 193) ->
	289;
get_channel_lev_weight(4, 194) ->
	291;
get_channel_lev_weight(4, 195) ->
	292;
get_channel_lev_weight(4, 196) ->
	294;
get_channel_lev_weight(4, 197) ->
	295;
get_channel_lev_weight(4, 198) ->
	297;
get_channel_lev_weight(4, 199) ->
	298;
get_channel_lev_weight(4, 200) ->
	300;
get_channel_lev_weight(5, 1) ->
	1;
get_channel_lev_weight(5, 2) ->
	3;
get_channel_lev_weight(5, 3) ->
	4;
get_channel_lev_weight(5, 4) ->
	6;
get_channel_lev_weight(5, 5) ->
	7;
get_channel_lev_weight(5, 6) ->
	9;
get_channel_lev_weight(5, 7) ->
	10;
get_channel_lev_weight(5, 8) ->
	12;
get_channel_lev_weight(5, 9) ->
	13;
get_channel_lev_weight(5, 10) ->
	15;
get_channel_lev_weight(5, 11) ->
	16;
get_channel_lev_weight(5, 12) ->
	18;
get_channel_lev_weight(5, 13) ->
	19;
get_channel_lev_weight(5, 14) ->
	21;
get_channel_lev_weight(5, 15) ->
	22;
get_channel_lev_weight(5, 16) ->
	24;
get_channel_lev_weight(5, 17) ->
	25;
get_channel_lev_weight(5, 18) ->
	27;
get_channel_lev_weight(5, 19) ->
	28;
get_channel_lev_weight(5, 20) ->
	30;
get_channel_lev_weight(5, 21) ->
	31;
get_channel_lev_weight(5, 22) ->
	33;
get_channel_lev_weight(5, 23) ->
	34;
get_channel_lev_weight(5, 24) ->
	36;
get_channel_lev_weight(5, 25) ->
	37;
get_channel_lev_weight(5, 26) ->
	39;
get_channel_lev_weight(5, 27) ->
	40;
get_channel_lev_weight(5, 28) ->
	42;
get_channel_lev_weight(5, 29) ->
	43;
get_channel_lev_weight(5, 30) ->
	45;
get_channel_lev_weight(5, 31) ->
	46;
get_channel_lev_weight(5, 32) ->
	48;
get_channel_lev_weight(5, 33) ->
	49;
get_channel_lev_weight(5, 34) ->
	51;
get_channel_lev_weight(5, 35) ->
	52;
get_channel_lev_weight(5, 36) ->
	54;
get_channel_lev_weight(5, 37) ->
	55;
get_channel_lev_weight(5, 38) ->
	57;
get_channel_lev_weight(5, 39) ->
	58;
get_channel_lev_weight(5, 40) ->
	60;
get_channel_lev_weight(5, 41) ->
	61;
get_channel_lev_weight(5, 42) ->
	63;
get_channel_lev_weight(5, 43) ->
	64;
get_channel_lev_weight(5, 44) ->
	66;
get_channel_lev_weight(5, 45) ->
	67;
get_channel_lev_weight(5, 46) ->
	69;
get_channel_lev_weight(5, 47) ->
	70;
get_channel_lev_weight(5, 48) ->
	72;
get_channel_lev_weight(5, 49) ->
	73;
get_channel_lev_weight(5, 50) ->
	75;
get_channel_lev_weight(5, 51) ->
	76;
get_channel_lev_weight(5, 52) ->
	78;
get_channel_lev_weight(5, 53) ->
	79;
get_channel_lev_weight(5, 54) ->
	81;
get_channel_lev_weight(5, 55) ->
	82;
get_channel_lev_weight(5, 56) ->
	84;
get_channel_lev_weight(5, 57) ->
	85;
get_channel_lev_weight(5, 58) ->
	87;
get_channel_lev_weight(5, 59) ->
	88;
get_channel_lev_weight(5, 60) ->
	90;
get_channel_lev_weight(5, 61) ->
	91;
get_channel_lev_weight(5, 62) ->
	93;
get_channel_lev_weight(5, 63) ->
	94;
get_channel_lev_weight(5, 64) ->
	96;
get_channel_lev_weight(5, 65) ->
	97;
get_channel_lev_weight(5, 66) ->
	99;
get_channel_lev_weight(5, 67) ->
	100;
get_channel_lev_weight(5, 68) ->
	102;
get_channel_lev_weight(5, 69) ->
	103;
get_channel_lev_weight(5, 70) ->
	105;
get_channel_lev_weight(5, 71) ->
	106;
get_channel_lev_weight(5, 72) ->
	108;
get_channel_lev_weight(5, 73) ->
	109;
get_channel_lev_weight(5, 74) ->
	111;
get_channel_lev_weight(5, 75) ->
	112;
get_channel_lev_weight(5, 76) ->
	114;
get_channel_lev_weight(5, 77) ->
	115;
get_channel_lev_weight(5, 78) ->
	117;
get_channel_lev_weight(5, 79) ->
	118;
get_channel_lev_weight(5, 80) ->
	120;
get_channel_lev_weight(5, 81) ->
	121;
get_channel_lev_weight(5, 82) ->
	123;
get_channel_lev_weight(5, 83) ->
	124;
get_channel_lev_weight(5, 84) ->
	126;
get_channel_lev_weight(5, 85) ->
	127;
get_channel_lev_weight(5, 86) ->
	129;
get_channel_lev_weight(5, 87) ->
	130;
get_channel_lev_weight(5, 88) ->
	132;
get_channel_lev_weight(5, 89) ->
	133;
get_channel_lev_weight(5, 90) ->
	135;
get_channel_lev_weight(5, 91) ->
	136;
get_channel_lev_weight(5, 92) ->
	138;
get_channel_lev_weight(5, 93) ->
	139;
get_channel_lev_weight(5, 94) ->
	141;
get_channel_lev_weight(5, 95) ->
	142;
get_channel_lev_weight(5, 96) ->
	144;
get_channel_lev_weight(5, 97) ->
	145;
get_channel_lev_weight(5, 98) ->
	147;
get_channel_lev_weight(5, 99) ->
	148;
get_channel_lev_weight(5, 100) ->
	150;
get_channel_lev_weight(5, 101) ->
	151;
get_channel_lev_weight(5, 102) ->
	153;
get_channel_lev_weight(5, 103) ->
	154;
get_channel_lev_weight(5, 104) ->
	156;
get_channel_lev_weight(5, 105) ->
	157;
get_channel_lev_weight(5, 106) ->
	159;
get_channel_lev_weight(5, 107) ->
	160;
get_channel_lev_weight(5, 108) ->
	162;
get_channel_lev_weight(5, 109) ->
	163;
get_channel_lev_weight(5, 110) ->
	165;
get_channel_lev_weight(5, 111) ->
	166;
get_channel_lev_weight(5, 112) ->
	168;
get_channel_lev_weight(5, 113) ->
	169;
get_channel_lev_weight(5, 114) ->
	171;
get_channel_lev_weight(5, 115) ->
	172;
get_channel_lev_weight(5, 116) ->
	174;
get_channel_lev_weight(5, 117) ->
	175;
get_channel_lev_weight(5, 118) ->
	177;
get_channel_lev_weight(5, 119) ->
	178;
get_channel_lev_weight(5, 120) ->
	180;
get_channel_lev_weight(5, 121) ->
	181;
get_channel_lev_weight(5, 122) ->
	183;
get_channel_lev_weight(5, 123) ->
	184;
get_channel_lev_weight(5, 124) ->
	186;
get_channel_lev_weight(5, 125) ->
	187;
get_channel_lev_weight(5, 126) ->
	189;
get_channel_lev_weight(5, 127) ->
	190;
get_channel_lev_weight(5, 128) ->
	192;
get_channel_lev_weight(5, 129) ->
	193;
get_channel_lev_weight(5, 130) ->
	195;
get_channel_lev_weight(5, 131) ->
	196;
get_channel_lev_weight(5, 132) ->
	198;
get_channel_lev_weight(5, 133) ->
	199;
get_channel_lev_weight(5, 134) ->
	201;
get_channel_lev_weight(5, 135) ->
	202;
get_channel_lev_weight(5, 136) ->
	204;
get_channel_lev_weight(5, 137) ->
	205;
get_channel_lev_weight(5, 138) ->
	207;
get_channel_lev_weight(5, 139) ->
	208;
get_channel_lev_weight(5, 140) ->
	210;
get_channel_lev_weight(5, 141) ->
	211;
get_channel_lev_weight(5, 142) ->
	213;
get_channel_lev_weight(5, 143) ->
	214;
get_channel_lev_weight(5, 144) ->
	216;
get_channel_lev_weight(5, 145) ->
	217;
get_channel_lev_weight(5, 146) ->
	219;
get_channel_lev_weight(5, 147) ->
	220;
get_channel_lev_weight(5, 148) ->
	222;
get_channel_lev_weight(5, 149) ->
	223;
get_channel_lev_weight(5, 150) ->
	225;
get_channel_lev_weight(5, 151) ->
	226;
get_channel_lev_weight(5, 152) ->
	228;
get_channel_lev_weight(5, 153) ->
	229;
get_channel_lev_weight(5, 154) ->
	231;
get_channel_lev_weight(5, 155) ->
	232;
get_channel_lev_weight(5, 156) ->
	234;
get_channel_lev_weight(5, 157) ->
	235;
get_channel_lev_weight(5, 158) ->
	237;
get_channel_lev_weight(5, 159) ->
	238;
get_channel_lev_weight(5, 160) ->
	240;
get_channel_lev_weight(5, 161) ->
	241;
get_channel_lev_weight(5, 162) ->
	243;
get_channel_lev_weight(5, 163) ->
	244;
get_channel_lev_weight(5, 164) ->
	246;
get_channel_lev_weight(5, 165) ->
	247;
get_channel_lev_weight(5, 166) ->
	249;
get_channel_lev_weight(5, 167) ->
	250;
get_channel_lev_weight(5, 168) ->
	252;
get_channel_lev_weight(5, 169) ->
	253;
get_channel_lev_weight(5, 170) ->
	255;
get_channel_lev_weight(5, 171) ->
	256;
get_channel_lev_weight(5, 172) ->
	258;
get_channel_lev_weight(5, 173) ->
	259;
get_channel_lev_weight(5, 174) ->
	261;
get_channel_lev_weight(5, 175) ->
	262;
get_channel_lev_weight(5, 176) ->
	264;
get_channel_lev_weight(5, 177) ->
	265;
get_channel_lev_weight(5, 178) ->
	267;
get_channel_lev_weight(5, 179) ->
	268;
get_channel_lev_weight(5, 180) ->
	270;
get_channel_lev_weight(5, 181) ->
	271;
get_channel_lev_weight(5, 182) ->
	273;
get_channel_lev_weight(5, 183) ->
	274;
get_channel_lev_weight(5, 184) ->
	276;
get_channel_lev_weight(5, 185) ->
	277;
get_channel_lev_weight(5, 186) ->
	279;
get_channel_lev_weight(5, 187) ->
	280;
get_channel_lev_weight(5, 188) ->
	282;
get_channel_lev_weight(5, 189) ->
	283;
get_channel_lev_weight(5, 190) ->
	285;
get_channel_lev_weight(5, 191) ->
	286;
get_channel_lev_weight(5, 192) ->
	288;
get_channel_lev_weight(5, 193) ->
	289;
get_channel_lev_weight(5, 194) ->
	291;
get_channel_lev_weight(5, 195) ->
	292;
get_channel_lev_weight(5, 196) ->
	294;
get_channel_lev_weight(5, 197) ->
	295;
get_channel_lev_weight(5, 198) ->
	297;
get_channel_lev_weight(5, 199) ->
	298;
get_channel_lev_weight(5, 200) ->
	300;
get_channel_lev_weight(6, 1) ->
	1;
get_channel_lev_weight(6, 2) ->
	3;
get_channel_lev_weight(6, 3) ->
	4;
get_channel_lev_weight(6, 4) ->
	6;
get_channel_lev_weight(6, 5) ->
	7;
get_channel_lev_weight(6, 6) ->
	9;
get_channel_lev_weight(6, 7) ->
	10;
get_channel_lev_weight(6, 8) ->
	12;
get_channel_lev_weight(6, 9) ->
	13;
get_channel_lev_weight(6, 10) ->
	15;
get_channel_lev_weight(6, 11) ->
	16;
get_channel_lev_weight(6, 12) ->
	18;
get_channel_lev_weight(6, 13) ->
	19;
get_channel_lev_weight(6, 14) ->
	21;
get_channel_lev_weight(6, 15) ->
	22;
get_channel_lev_weight(6, 16) ->
	24;
get_channel_lev_weight(6, 17) ->
	25;
get_channel_lev_weight(6, 18) ->
	27;
get_channel_lev_weight(6, 19) ->
	28;
get_channel_lev_weight(6, 20) ->
	30;
get_channel_lev_weight(6, 21) ->
	31;
get_channel_lev_weight(6, 22) ->
	33;
get_channel_lev_weight(6, 23) ->
	34;
get_channel_lev_weight(6, 24) ->
	36;
get_channel_lev_weight(6, 25) ->
	37;
get_channel_lev_weight(6, 26) ->
	39;
get_channel_lev_weight(6, 27) ->
	40;
get_channel_lev_weight(6, 28) ->
	42;
get_channel_lev_weight(6, 29) ->
	43;
get_channel_lev_weight(6, 30) ->
	45;
get_channel_lev_weight(6, 31) ->
	46;
get_channel_lev_weight(6, 32) ->
	48;
get_channel_lev_weight(6, 33) ->
	49;
get_channel_lev_weight(6, 34) ->
	51;
get_channel_lev_weight(6, 35) ->
	52;
get_channel_lev_weight(6, 36) ->
	54;
get_channel_lev_weight(6, 37) ->
	55;
get_channel_lev_weight(6, 38) ->
	57;
get_channel_lev_weight(6, 39) ->
	58;
get_channel_lev_weight(6, 40) ->
	60;
get_channel_lev_weight(6, 41) ->
	61;
get_channel_lev_weight(6, 42) ->
	63;
get_channel_lev_weight(6, 43) ->
	64;
get_channel_lev_weight(6, 44) ->
	66;
get_channel_lev_weight(6, 45) ->
	67;
get_channel_lev_weight(6, 46) ->
	69;
get_channel_lev_weight(6, 47) ->
	70;
get_channel_lev_weight(6, 48) ->
	72;
get_channel_lev_weight(6, 49) ->
	73;
get_channel_lev_weight(6, 50) ->
	75;
get_channel_lev_weight(6, 51) ->
	76;
get_channel_lev_weight(6, 52) ->
	78;
get_channel_lev_weight(6, 53) ->
	79;
get_channel_lev_weight(6, 54) ->
	81;
get_channel_lev_weight(6, 55) ->
	82;
get_channel_lev_weight(6, 56) ->
	84;
get_channel_lev_weight(6, 57) ->
	85;
get_channel_lev_weight(6, 58) ->
	87;
get_channel_lev_weight(6, 59) ->
	88;
get_channel_lev_weight(6, 60) ->
	90;
get_channel_lev_weight(6, 61) ->
	91;
get_channel_lev_weight(6, 62) ->
	93;
get_channel_lev_weight(6, 63) ->
	94;
get_channel_lev_weight(6, 64) ->
	96;
get_channel_lev_weight(6, 65) ->
	97;
get_channel_lev_weight(6, 66) ->
	99;
get_channel_lev_weight(6, 67) ->
	100;
get_channel_lev_weight(6, 68) ->
	102;
get_channel_lev_weight(6, 69) ->
	103;
get_channel_lev_weight(6, 70) ->
	105;
get_channel_lev_weight(6, 71) ->
	106;
get_channel_lev_weight(6, 72) ->
	108;
get_channel_lev_weight(6, 73) ->
	109;
get_channel_lev_weight(6, 74) ->
	111;
get_channel_lev_weight(6, 75) ->
	112;
get_channel_lev_weight(6, 76) ->
	114;
get_channel_lev_weight(6, 77) ->
	115;
get_channel_lev_weight(6, 78) ->
	117;
get_channel_lev_weight(6, 79) ->
	118;
get_channel_lev_weight(6, 80) ->
	120;
get_channel_lev_weight(6, 81) ->
	121;
get_channel_lev_weight(6, 82) ->
	123;
get_channel_lev_weight(6, 83) ->
	124;
get_channel_lev_weight(6, 84) ->
	126;
get_channel_lev_weight(6, 85) ->
	127;
get_channel_lev_weight(6, 86) ->
	129;
get_channel_lev_weight(6, 87) ->
	130;
get_channel_lev_weight(6, 88) ->
	132;
get_channel_lev_weight(6, 89) ->
	133;
get_channel_lev_weight(6, 90) ->
	135;
get_channel_lev_weight(6, 91) ->
	136;
get_channel_lev_weight(6, 92) ->
	138;
get_channel_lev_weight(6, 93) ->
	139;
get_channel_lev_weight(6, 94) ->
	141;
get_channel_lev_weight(6, 95) ->
	142;
get_channel_lev_weight(6, 96) ->
	144;
get_channel_lev_weight(6, 97) ->
	145;
get_channel_lev_weight(6, 98) ->
	147;
get_channel_lev_weight(6, 99) ->
	148;
get_channel_lev_weight(6, 100) ->
	150;
get_channel_lev_weight(6, 101) ->
	151;
get_channel_lev_weight(6, 102) ->
	153;
get_channel_lev_weight(6, 103) ->
	154;
get_channel_lev_weight(6, 104) ->
	156;
get_channel_lev_weight(6, 105) ->
	157;
get_channel_lev_weight(6, 106) ->
	159;
get_channel_lev_weight(6, 107) ->
	160;
get_channel_lev_weight(6, 108) ->
	162;
get_channel_lev_weight(6, 109) ->
	163;
get_channel_lev_weight(6, 110) ->
	165;
get_channel_lev_weight(6, 111) ->
	166;
get_channel_lev_weight(6, 112) ->
	168;
get_channel_lev_weight(6, 113) ->
	169;
get_channel_lev_weight(6, 114) ->
	171;
get_channel_lev_weight(6, 115) ->
	172;
get_channel_lev_weight(6, 116) ->
	174;
get_channel_lev_weight(6, 117) ->
	175;
get_channel_lev_weight(6, 118) ->
	177;
get_channel_lev_weight(6, 119) ->
	178;
get_channel_lev_weight(6, 120) ->
	180;
get_channel_lev_weight(6, 121) ->
	181;
get_channel_lev_weight(6, 122) ->
	183;
get_channel_lev_weight(6, 123) ->
	184;
get_channel_lev_weight(6, 124) ->
	186;
get_channel_lev_weight(6, 125) ->
	187;
get_channel_lev_weight(6, 126) ->
	189;
get_channel_lev_weight(6, 127) ->
	190;
get_channel_lev_weight(6, 128) ->
	192;
get_channel_lev_weight(6, 129) ->
	193;
get_channel_lev_weight(6, 130) ->
	195;
get_channel_lev_weight(6, 131) ->
	196;
get_channel_lev_weight(6, 132) ->
	198;
get_channel_lev_weight(6, 133) ->
	199;
get_channel_lev_weight(6, 134) ->
	201;
get_channel_lev_weight(6, 135) ->
	202;
get_channel_lev_weight(6, 136) ->
	204;
get_channel_lev_weight(6, 137) ->
	205;
get_channel_lev_weight(6, 138) ->
	207;
get_channel_lev_weight(6, 139) ->
	208;
get_channel_lev_weight(6, 140) ->
	210;
get_channel_lev_weight(6, 141) ->
	211;
get_channel_lev_weight(6, 142) ->
	213;
get_channel_lev_weight(6, 143) ->
	214;
get_channel_lev_weight(6, 144) ->
	216;
get_channel_lev_weight(6, 145) ->
	217;
get_channel_lev_weight(6, 146) ->
	219;
get_channel_lev_weight(6, 147) ->
	220;
get_channel_lev_weight(6, 148) ->
	222;
get_channel_lev_weight(6, 149) ->
	223;
get_channel_lev_weight(6, 150) ->
	225;
get_channel_lev_weight(6, 151) ->
	226;
get_channel_lev_weight(6, 152) ->
	228;
get_channel_lev_weight(6, 153) ->
	229;
get_channel_lev_weight(6, 154) ->
	231;
get_channel_lev_weight(6, 155) ->
	232;
get_channel_lev_weight(6, 156) ->
	234;
get_channel_lev_weight(6, 157) ->
	235;
get_channel_lev_weight(6, 158) ->
	237;
get_channel_lev_weight(6, 159) ->
	238;
get_channel_lev_weight(6, 160) ->
	240;
get_channel_lev_weight(6, 161) ->
	241;
get_channel_lev_weight(6, 162) ->
	243;
get_channel_lev_weight(6, 163) ->
	244;
get_channel_lev_weight(6, 164) ->
	246;
get_channel_lev_weight(6, 165) ->
	247;
get_channel_lev_weight(6, 166) ->
	249;
get_channel_lev_weight(6, 167) ->
	250;
get_channel_lev_weight(6, 168) ->
	252;
get_channel_lev_weight(6, 169) ->
	253;
get_channel_lev_weight(6, 170) ->
	255;
get_channel_lev_weight(6, 171) ->
	256;
get_channel_lev_weight(6, 172) ->
	258;
get_channel_lev_weight(6, 173) ->
	259;
get_channel_lev_weight(6, 174) ->
	261;
get_channel_lev_weight(6, 175) ->
	262;
get_channel_lev_weight(6, 176) ->
	264;
get_channel_lev_weight(6, 177) ->
	265;
get_channel_lev_weight(6, 178) ->
	267;
get_channel_lev_weight(6, 179) ->
	268;
get_channel_lev_weight(6, 180) ->
	270;
get_channel_lev_weight(6, 181) ->
	271;
get_channel_lev_weight(6, 182) ->
	273;
get_channel_lev_weight(6, 183) ->
	274;
get_channel_lev_weight(6, 184) ->
	276;
get_channel_lev_weight(6, 185) ->
	277;
get_channel_lev_weight(6, 186) ->
	279;
get_channel_lev_weight(6, 187) ->
	280;
get_channel_lev_weight(6, 188) ->
	282;
get_channel_lev_weight(6, 189) ->
	283;
get_channel_lev_weight(6, 190) ->
	285;
get_channel_lev_weight(6, 191) ->
	286;
get_channel_lev_weight(6, 192) ->
	288;
get_channel_lev_weight(6, 193) ->
	289;
get_channel_lev_weight(6, 194) ->
	291;
get_channel_lev_weight(6, 195) ->
	292;
get_channel_lev_weight(6, 196) ->
	294;
get_channel_lev_weight(6, 197) ->
	295;
get_channel_lev_weight(6, 198) ->
	297;
get_channel_lev_weight(6, 199) ->
	298;
get_channel_lev_weight(6, 200) ->
	300;
get_channel_lev_weight(7, 1) ->
	1;
get_channel_lev_weight(7, 2) ->
	3;
get_channel_lev_weight(7, 3) ->
	4;
get_channel_lev_weight(7, 4) ->
	6;
get_channel_lev_weight(7, 5) ->
	7;
get_channel_lev_weight(7, 6) ->
	9;
get_channel_lev_weight(7, 7) ->
	10;
get_channel_lev_weight(7, 8) ->
	12;
get_channel_lev_weight(7, 9) ->
	13;
get_channel_lev_weight(7, 10) ->
	15;
get_channel_lev_weight(7, 11) ->
	16;
get_channel_lev_weight(7, 12) ->
	18;
get_channel_lev_weight(7, 13) ->
	19;
get_channel_lev_weight(7, 14) ->
	21;
get_channel_lev_weight(7, 15) ->
	22;
get_channel_lev_weight(7, 16) ->
	24;
get_channel_lev_weight(7, 17) ->
	25;
get_channel_lev_weight(7, 18) ->
	27;
get_channel_lev_weight(7, 19) ->
	28;
get_channel_lev_weight(7, 20) ->
	30;
get_channel_lev_weight(7, 21) ->
	31;
get_channel_lev_weight(7, 22) ->
	33;
get_channel_lev_weight(7, 23) ->
	34;
get_channel_lev_weight(7, 24) ->
	36;
get_channel_lev_weight(7, 25) ->
	37;
get_channel_lev_weight(7, 26) ->
	39;
get_channel_lev_weight(7, 27) ->
	40;
get_channel_lev_weight(7, 28) ->
	42;
get_channel_lev_weight(7, 29) ->
	43;
get_channel_lev_weight(7, 30) ->
	45;
get_channel_lev_weight(7, 31) ->
	46;
get_channel_lev_weight(7, 32) ->
	48;
get_channel_lev_weight(7, 33) ->
	49;
get_channel_lev_weight(7, 34) ->
	51;
get_channel_lev_weight(7, 35) ->
	52;
get_channel_lev_weight(7, 36) ->
	54;
get_channel_lev_weight(7, 37) ->
	55;
get_channel_lev_weight(7, 38) ->
	57;
get_channel_lev_weight(7, 39) ->
	58;
get_channel_lev_weight(7, 40) ->
	60;
get_channel_lev_weight(7, 41) ->
	61;
get_channel_lev_weight(7, 42) ->
	63;
get_channel_lev_weight(7, 43) ->
	64;
get_channel_lev_weight(7, 44) ->
	66;
get_channel_lev_weight(7, 45) ->
	67;
get_channel_lev_weight(7, 46) ->
	69;
get_channel_lev_weight(7, 47) ->
	70;
get_channel_lev_weight(7, 48) ->
	72;
get_channel_lev_weight(7, 49) ->
	73;
get_channel_lev_weight(7, 50) ->
	75;
get_channel_lev_weight(7, 51) ->
	76;
get_channel_lev_weight(7, 52) ->
	78;
get_channel_lev_weight(7, 53) ->
	79;
get_channel_lev_weight(7, 54) ->
	81;
get_channel_lev_weight(7, 55) ->
	82;
get_channel_lev_weight(7, 56) ->
	84;
get_channel_lev_weight(7, 57) ->
	85;
get_channel_lev_weight(7, 58) ->
	87;
get_channel_lev_weight(7, 59) ->
	88;
get_channel_lev_weight(7, 60) ->
	90;
get_channel_lev_weight(7, 61) ->
	91;
get_channel_lev_weight(7, 62) ->
	93;
get_channel_lev_weight(7, 63) ->
	94;
get_channel_lev_weight(7, 64) ->
	96;
get_channel_lev_weight(7, 65) ->
	97;
get_channel_lev_weight(7, 66) ->
	99;
get_channel_lev_weight(7, 67) ->
	100;
get_channel_lev_weight(7, 68) ->
	102;
get_channel_lev_weight(7, 69) ->
	103;
get_channel_lev_weight(7, 70) ->
	105;
get_channel_lev_weight(7, 71) ->
	106;
get_channel_lev_weight(7, 72) ->
	108;
get_channel_lev_weight(7, 73) ->
	109;
get_channel_lev_weight(7, 74) ->
	111;
get_channel_lev_weight(7, 75) ->
	112;
get_channel_lev_weight(7, 76) ->
	114;
get_channel_lev_weight(7, 77) ->
	115;
get_channel_lev_weight(7, 78) ->
	117;
get_channel_lev_weight(7, 79) ->
	118;
get_channel_lev_weight(7, 80) ->
	120;
get_channel_lev_weight(7, 81) ->
	121;
get_channel_lev_weight(7, 82) ->
	123;
get_channel_lev_weight(7, 83) ->
	124;
get_channel_lev_weight(7, 84) ->
	126;
get_channel_lev_weight(7, 85) ->
	127;
get_channel_lev_weight(7, 86) ->
	129;
get_channel_lev_weight(7, 87) ->
	130;
get_channel_lev_weight(7, 88) ->
	132;
get_channel_lev_weight(7, 89) ->
	133;
get_channel_lev_weight(7, 90) ->
	135;
get_channel_lev_weight(7, 91) ->
	136;
get_channel_lev_weight(7, 92) ->
	138;
get_channel_lev_weight(7, 93) ->
	139;
get_channel_lev_weight(7, 94) ->
	141;
get_channel_lev_weight(7, 95) ->
	142;
get_channel_lev_weight(7, 96) ->
	144;
get_channel_lev_weight(7, 97) ->
	145;
get_channel_lev_weight(7, 98) ->
	147;
get_channel_lev_weight(7, 99) ->
	148;
get_channel_lev_weight(7, 100) ->
	150;
get_channel_lev_weight(7, 101) ->
	151;
get_channel_lev_weight(7, 102) ->
	153;
get_channel_lev_weight(7, 103) ->
	154;
get_channel_lev_weight(7, 104) ->
	156;
get_channel_lev_weight(7, 105) ->
	157;
get_channel_lev_weight(7, 106) ->
	159;
get_channel_lev_weight(7, 107) ->
	160;
get_channel_lev_weight(7, 108) ->
	162;
get_channel_lev_weight(7, 109) ->
	163;
get_channel_lev_weight(7, 110) ->
	165;
get_channel_lev_weight(7, 111) ->
	166;
get_channel_lev_weight(7, 112) ->
	168;
get_channel_lev_weight(7, 113) ->
	169;
get_channel_lev_weight(7, 114) ->
	171;
get_channel_lev_weight(7, 115) ->
	172;
get_channel_lev_weight(7, 116) ->
	174;
get_channel_lev_weight(7, 117) ->
	175;
get_channel_lev_weight(7, 118) ->
	177;
get_channel_lev_weight(7, 119) ->
	178;
get_channel_lev_weight(7, 120) ->
	180;
get_channel_lev_weight(7, 121) ->
	181;
get_channel_lev_weight(7, 122) ->
	183;
get_channel_lev_weight(7, 123) ->
	184;
get_channel_lev_weight(7, 124) ->
	186;
get_channel_lev_weight(7, 125) ->
	187;
get_channel_lev_weight(7, 126) ->
	189;
get_channel_lev_weight(7, 127) ->
	190;
get_channel_lev_weight(7, 128) ->
	192;
get_channel_lev_weight(7, 129) ->
	193;
get_channel_lev_weight(7, 130) ->
	195;
get_channel_lev_weight(7, 131) ->
	196;
get_channel_lev_weight(7, 132) ->
	198;
get_channel_lev_weight(7, 133) ->
	199;
get_channel_lev_weight(7, 134) ->
	201;
get_channel_lev_weight(7, 135) ->
	202;
get_channel_lev_weight(7, 136) ->
	204;
get_channel_lev_weight(7, 137) ->
	205;
get_channel_lev_weight(7, 138) ->
	207;
get_channel_lev_weight(7, 139) ->
	208;
get_channel_lev_weight(7, 140) ->
	210;
get_channel_lev_weight(7, 141) ->
	211;
get_channel_lev_weight(7, 142) ->
	213;
get_channel_lev_weight(7, 143) ->
	214;
get_channel_lev_weight(7, 144) ->
	216;
get_channel_lev_weight(7, 145) ->
	217;
get_channel_lev_weight(7, 146) ->
	219;
get_channel_lev_weight(7, 147) ->
	220;
get_channel_lev_weight(7, 148) ->
	222;
get_channel_lev_weight(7, 149) ->
	223;
get_channel_lev_weight(7, 150) ->
	225;
get_channel_lev_weight(7, 151) ->
	226;
get_channel_lev_weight(7, 152) ->
	228;
get_channel_lev_weight(7, 153) ->
	229;
get_channel_lev_weight(7, 154) ->
	231;
get_channel_lev_weight(7, 155) ->
	232;
get_channel_lev_weight(7, 156) ->
	234;
get_channel_lev_weight(7, 157) ->
	235;
get_channel_lev_weight(7, 158) ->
	237;
get_channel_lev_weight(7, 159) ->
	238;
get_channel_lev_weight(7, 160) ->
	240;
get_channel_lev_weight(7, 161) ->
	241;
get_channel_lev_weight(7, 162) ->
	243;
get_channel_lev_weight(7, 163) ->
	244;
get_channel_lev_weight(7, 164) ->
	246;
get_channel_lev_weight(7, 165) ->
	247;
get_channel_lev_weight(7, 166) ->
	249;
get_channel_lev_weight(7, 167) ->
	250;
get_channel_lev_weight(7, 168) ->
	252;
get_channel_lev_weight(7, 169) ->
	253;
get_channel_lev_weight(7, 170) ->
	255;
get_channel_lev_weight(7, 171) ->
	256;
get_channel_lev_weight(7, 172) ->
	258;
get_channel_lev_weight(7, 173) ->
	259;
get_channel_lev_weight(7, 174) ->
	261;
get_channel_lev_weight(7, 175) ->
	262;
get_channel_lev_weight(7, 176) ->
	264;
get_channel_lev_weight(7, 177) ->
	265;
get_channel_lev_weight(7, 178) ->
	267;
get_channel_lev_weight(7, 179) ->
	268;
get_channel_lev_weight(7, 180) ->
	270;
get_channel_lev_weight(7, 181) ->
	271;
get_channel_lev_weight(7, 182) ->
	273;
get_channel_lev_weight(7, 183) ->
	274;
get_channel_lev_weight(7, 184) ->
	276;
get_channel_lev_weight(7, 185) ->
	277;
get_channel_lev_weight(7, 186) ->
	279;
get_channel_lev_weight(7, 187) ->
	280;
get_channel_lev_weight(7, 188) ->
	282;
get_channel_lev_weight(7, 189) ->
	283;
get_channel_lev_weight(7, 190) ->
	285;
get_channel_lev_weight(7, 191) ->
	286;
get_channel_lev_weight(7, 192) ->
	288;
get_channel_lev_weight(7, 193) ->
	289;
get_channel_lev_weight(7, 194) ->
	291;
get_channel_lev_weight(7, 195) ->
	292;
get_channel_lev_weight(7, 196) ->
	294;
get_channel_lev_weight(7, 197) ->
	295;
get_channel_lev_weight(7, 198) ->
	297;
get_channel_lev_weight(7, 199) ->
	298;
get_channel_lev_weight(7, 200) ->
	300;
get_channel_lev_weight(8, 1) ->
	1;
get_channel_lev_weight(8, 2) ->
	3;
get_channel_lev_weight(8, 3) ->
	4;
get_channel_lev_weight(8, 4) ->
	6;
get_channel_lev_weight(8, 5) ->
	7;
get_channel_lev_weight(8, 6) ->
	9;
get_channel_lev_weight(8, 7) ->
	10;
get_channel_lev_weight(8, 8) ->
	12;
get_channel_lev_weight(8, 9) ->
	13;
get_channel_lev_weight(8, 10) ->
	15;
get_channel_lev_weight(8, 11) ->
	16;
get_channel_lev_weight(8, 12) ->
	18;
get_channel_lev_weight(8, 13) ->
	19;
get_channel_lev_weight(8, 14) ->
	21;
get_channel_lev_weight(8, 15) ->
	22;
get_channel_lev_weight(8, 16) ->
	24;
get_channel_lev_weight(8, 17) ->
	25;
get_channel_lev_weight(8, 18) ->
	27;
get_channel_lev_weight(8, 19) ->
	28;
get_channel_lev_weight(8, 20) ->
	30;
get_channel_lev_weight(8, 21) ->
	31;
get_channel_lev_weight(8, 22) ->
	33;
get_channel_lev_weight(8, 23) ->
	34;
get_channel_lev_weight(8, 24) ->
	36;
get_channel_lev_weight(8, 25) ->
	37;
get_channel_lev_weight(8, 26) ->
	39;
get_channel_lev_weight(8, 27) ->
	40;
get_channel_lev_weight(8, 28) ->
	42;
get_channel_lev_weight(8, 29) ->
	43;
get_channel_lev_weight(8, 30) ->
	45;
get_channel_lev_weight(8, 31) ->
	46;
get_channel_lev_weight(8, 32) ->
	48;
get_channel_lev_weight(8, 33) ->
	49;
get_channel_lev_weight(8, 34) ->
	51;
get_channel_lev_weight(8, 35) ->
	52;
get_channel_lev_weight(8, 36) ->
	54;
get_channel_lev_weight(8, 37) ->
	55;
get_channel_lev_weight(8, 38) ->
	57;
get_channel_lev_weight(8, 39) ->
	58;
get_channel_lev_weight(8, 40) ->
	60;
get_channel_lev_weight(8, 41) ->
	61;
get_channel_lev_weight(8, 42) ->
	63;
get_channel_lev_weight(8, 43) ->
	64;
get_channel_lev_weight(8, 44) ->
	66;
get_channel_lev_weight(8, 45) ->
	67;
get_channel_lev_weight(8, 46) ->
	69;
get_channel_lev_weight(8, 47) ->
	70;
get_channel_lev_weight(8, 48) ->
	72;
get_channel_lev_weight(8, 49) ->
	73;
get_channel_lev_weight(8, 50) ->
	75;
get_channel_lev_weight(8, 51) ->
	76;
get_channel_lev_weight(8, 52) ->
	78;
get_channel_lev_weight(8, 53) ->
	79;
get_channel_lev_weight(8, 54) ->
	81;
get_channel_lev_weight(8, 55) ->
	82;
get_channel_lev_weight(8, 56) ->
	84;
get_channel_lev_weight(8, 57) ->
	85;
get_channel_lev_weight(8, 58) ->
	87;
get_channel_lev_weight(8, 59) ->
	88;
get_channel_lev_weight(8, 60) ->
	90;
get_channel_lev_weight(8, 61) ->
	91;
get_channel_lev_weight(8, 62) ->
	93;
get_channel_lev_weight(8, 63) ->
	94;
get_channel_lev_weight(8, 64) ->
	96;
get_channel_lev_weight(8, 65) ->
	97;
get_channel_lev_weight(8, 66) ->
	99;
get_channel_lev_weight(8, 67) ->
	100;
get_channel_lev_weight(8, 68) ->
	102;
get_channel_lev_weight(8, 69) ->
	103;
get_channel_lev_weight(8, 70) ->
	105;
get_channel_lev_weight(8, 71) ->
	106;
get_channel_lev_weight(8, 72) ->
	108;
get_channel_lev_weight(8, 73) ->
	109;
get_channel_lev_weight(8, 74) ->
	111;
get_channel_lev_weight(8, 75) ->
	112;
get_channel_lev_weight(8, 76) ->
	114;
get_channel_lev_weight(8, 77) ->
	115;
get_channel_lev_weight(8, 78) ->
	117;
get_channel_lev_weight(8, 79) ->
	118;
get_channel_lev_weight(8, 80) ->
	120;
get_channel_lev_weight(8, 81) ->
	121;
get_channel_lev_weight(8, 82) ->
	123;
get_channel_lev_weight(8, 83) ->
	124;
get_channel_lev_weight(8, 84) ->
	126;
get_channel_lev_weight(8, 85) ->
	127;
get_channel_lev_weight(8, 86) ->
	129;
get_channel_lev_weight(8, 87) ->
	130;
get_channel_lev_weight(8, 88) ->
	132;
get_channel_lev_weight(8, 89) ->
	133;
get_channel_lev_weight(8, 90) ->
	135;
get_channel_lev_weight(8, 91) ->
	136;
get_channel_lev_weight(8, 92) ->
	138;
get_channel_lev_weight(8, 93) ->
	139;
get_channel_lev_weight(8, 94) ->
	141;
get_channel_lev_weight(8, 95) ->
	142;
get_channel_lev_weight(8, 96) ->
	144;
get_channel_lev_weight(8, 97) ->
	145;
get_channel_lev_weight(8, 98) ->
	147;
get_channel_lev_weight(8, 99) ->
	148;
get_channel_lev_weight(8, 100) ->
	150;
get_channel_lev_weight(8, 101) ->
	151;
get_channel_lev_weight(8, 102) ->
	153;
get_channel_lev_weight(8, 103) ->
	154;
get_channel_lev_weight(8, 104) ->
	156;
get_channel_lev_weight(8, 105) ->
	157;
get_channel_lev_weight(8, 106) ->
	159;
get_channel_lev_weight(8, 107) ->
	160;
get_channel_lev_weight(8, 108) ->
	162;
get_channel_lev_weight(8, 109) ->
	163;
get_channel_lev_weight(8, 110) ->
	165;
get_channel_lev_weight(8, 111) ->
	166;
get_channel_lev_weight(8, 112) ->
	168;
get_channel_lev_weight(8, 113) ->
	169;
get_channel_lev_weight(8, 114) ->
	171;
get_channel_lev_weight(8, 115) ->
	172;
get_channel_lev_weight(8, 116) ->
	174;
get_channel_lev_weight(8, 117) ->
	175;
get_channel_lev_weight(8, 118) ->
	177;
get_channel_lev_weight(8, 119) ->
	178;
get_channel_lev_weight(8, 120) ->
	180;
get_channel_lev_weight(8, 121) ->
	181;
get_channel_lev_weight(8, 122) ->
	183;
get_channel_lev_weight(8, 123) ->
	184;
get_channel_lev_weight(8, 124) ->
	186;
get_channel_lev_weight(8, 125) ->
	187;
get_channel_lev_weight(8, 126) ->
	189;
get_channel_lev_weight(8, 127) ->
	190;
get_channel_lev_weight(8, 128) ->
	192;
get_channel_lev_weight(8, 129) ->
	193;
get_channel_lev_weight(8, 130) ->
	195;
get_channel_lev_weight(8, 131) ->
	196;
get_channel_lev_weight(8, 132) ->
	198;
get_channel_lev_weight(8, 133) ->
	199;
get_channel_lev_weight(8, 134) ->
	201;
get_channel_lev_weight(8, 135) ->
	202;
get_channel_lev_weight(8, 136) ->
	204;
get_channel_lev_weight(8, 137) ->
	205;
get_channel_lev_weight(8, 138) ->
	207;
get_channel_lev_weight(8, 139) ->
	208;
get_channel_lev_weight(8, 140) ->
	210;
get_channel_lev_weight(8, 141) ->
	211;
get_channel_lev_weight(8, 142) ->
	213;
get_channel_lev_weight(8, 143) ->
	214;
get_channel_lev_weight(8, 144) ->
	216;
get_channel_lev_weight(8, 145) ->
	217;
get_channel_lev_weight(8, 146) ->
	219;
get_channel_lev_weight(8, 147) ->
	220;
get_channel_lev_weight(8, 148) ->
	222;
get_channel_lev_weight(8, 149) ->
	223;
get_channel_lev_weight(8, 150) ->
	225;
get_channel_lev_weight(8, 151) ->
	226;
get_channel_lev_weight(8, 152) ->
	228;
get_channel_lev_weight(8, 153) ->
	229;
get_channel_lev_weight(8, 154) ->
	231;
get_channel_lev_weight(8, 155) ->
	232;
get_channel_lev_weight(8, 156) ->
	234;
get_channel_lev_weight(8, 157) ->
	235;
get_channel_lev_weight(8, 158) ->
	237;
get_channel_lev_weight(8, 159) ->
	238;
get_channel_lev_weight(8, 160) ->
	240;
get_channel_lev_weight(8, 161) ->
	241;
get_channel_lev_weight(8, 162) ->
	243;
get_channel_lev_weight(8, 163) ->
	244;
get_channel_lev_weight(8, 164) ->
	246;
get_channel_lev_weight(8, 165) ->
	247;
get_channel_lev_weight(8, 166) ->
	249;
get_channel_lev_weight(8, 167) ->
	250;
get_channel_lev_weight(8, 168) ->
	252;
get_channel_lev_weight(8, 169) ->
	253;
get_channel_lev_weight(8, 170) ->
	255;
get_channel_lev_weight(8, 171) ->
	256;
get_channel_lev_weight(8, 172) ->
	258;
get_channel_lev_weight(8, 173) ->
	259;
get_channel_lev_weight(8, 174) ->
	261;
get_channel_lev_weight(8, 175) ->
	262;
get_channel_lev_weight(8, 176) ->
	264;
get_channel_lev_weight(8, 177) ->
	265;
get_channel_lev_weight(8, 178) ->
	267;
get_channel_lev_weight(8, 179) ->
	268;
get_channel_lev_weight(8, 180) ->
	270;
get_channel_lev_weight(8, 181) ->
	271;
get_channel_lev_weight(8, 182) ->
	273;
get_channel_lev_weight(8, 183) ->
	274;
get_channel_lev_weight(8, 184) ->
	276;
get_channel_lev_weight(8, 185) ->
	277;
get_channel_lev_weight(8, 186) ->
	279;
get_channel_lev_weight(8, 187) ->
	280;
get_channel_lev_weight(8, 188) ->
	282;
get_channel_lev_weight(8, 189) ->
	283;
get_channel_lev_weight(8, 190) ->
	285;
get_channel_lev_weight(8, 191) ->
	286;
get_channel_lev_weight(8, 192) ->
	288;
get_channel_lev_weight(8, 193) ->
	289;
get_channel_lev_weight(8, 194) ->
	291;
get_channel_lev_weight(8, 195) ->
	292;
get_channel_lev_weight(8, 196) ->
	294;
get_channel_lev_weight(8, 197) ->
	295;
get_channel_lev_weight(8, 198) ->
	297;
get_channel_lev_weight(8, 199) ->
	298;
get_channel_lev_weight(8, 200) ->
	300;
get_channel_lev_weight(_Id, _) ->
		0.

get_eqm_lev_weight(10, 1) ->
	8;
get_eqm_lev_weight(10, 2) ->
	15;
get_eqm_lev_weight(10, 3) ->
	23;
get_eqm_lev_weight(10, 4) ->
	30;
get_eqm_lev_weight(10, 5) ->
	38;
get_eqm_lev_weight(10, 6) ->
	45;
get_eqm_lev_weight(10, 7) ->
	53;
get_eqm_lev_weight(10, 8) ->
	60;
get_eqm_lev_weight(10, 9) ->
	68;
get_eqm_lev_weight(10, 10) ->
	75;
get_eqm_lev_weight(10, 11) ->
	83;
get_eqm_lev_weight(10, 12) ->
	90;
get_eqm_lev_weight(10, 13) ->
	98;
get_eqm_lev_weight(10, 14) ->
	105;
get_eqm_lev_weight(10, 15) ->
	113;
get_eqm_lev_weight(10, 16) ->
	120;
get_eqm_lev_weight(10, 17) ->
	128;
get_eqm_lev_weight(10, 18) ->
	135;
get_eqm_lev_weight(10, 19) ->
	143;
get_eqm_lev_weight(10, 20) ->
	150;
get_eqm_lev_weight(10, 21) ->
	158;
get_eqm_lev_weight(10, 22) ->
	165;
get_eqm_lev_weight(10, 23) ->
	173;
get_eqm_lev_weight(10, 24) ->
	180;
get_eqm_lev_weight(10, 25) ->
	187;
get_eqm_lev_weight(10, 26) ->
	195;
get_eqm_lev_weight(10, 27) ->
	202;
get_eqm_lev_weight(10, 28) ->
	210;
get_eqm_lev_weight(10, 29) ->
	217;
get_eqm_lev_weight(10, 30) ->
	225;
get_eqm_lev_weight(10, 31) ->
	232;
get_eqm_lev_weight(10, 32) ->
	240;
get_eqm_lev_weight(10, 33) ->
	247;
get_eqm_lev_weight(10, 34) ->
	255;
get_eqm_lev_weight(10, 35) ->
	262;
get_eqm_lev_weight(10, 36) ->
	270;
get_eqm_lev_weight(10, 37) ->
	277;
get_eqm_lev_weight(10, 38) ->
	285;
get_eqm_lev_weight(10, 39) ->
	292;
get_eqm_lev_weight(10, 40) ->
	300;
get_eqm_lev_weight(10, 41) ->
	307;
get_eqm_lev_weight(10, 42) ->
	315;
get_eqm_lev_weight(10, 43) ->
	322;
get_eqm_lev_weight(10, 44) ->
	330;
get_eqm_lev_weight(10, 45) ->
	337;
get_eqm_lev_weight(10, 46) ->
	345;
get_eqm_lev_weight(10, 47) ->
	352;
get_eqm_lev_weight(10, 48) ->
	360;
get_eqm_lev_weight(10, 49) ->
	367;
get_eqm_lev_weight(10, 50) ->
	374;
get_eqm_lev_weight(10, 51) ->
	382;
get_eqm_lev_weight(10, 52) ->
	389;
get_eqm_lev_weight(10, 53) ->
	397;
get_eqm_lev_weight(10, 54) ->
	404;
get_eqm_lev_weight(10, 55) ->
	412;
get_eqm_lev_weight(10, 56) ->
	419;
get_eqm_lev_weight(10, 57) ->
	427;
get_eqm_lev_weight(10, 58) ->
	434;
get_eqm_lev_weight(10, 59) ->
	442;
get_eqm_lev_weight(10, 60) ->
	449;
get_eqm_lev_weight(10, 61) ->
	457;
get_eqm_lev_weight(10, 62) ->
	464;
get_eqm_lev_weight(10, 63) ->
	472;
get_eqm_lev_weight(10, 64) ->
	479;
get_eqm_lev_weight(10, 65) ->
	487;
get_eqm_lev_weight(10, 66) ->
	494;
get_eqm_lev_weight(10, 67) ->
	502;
get_eqm_lev_weight(10, 68) ->
	509;
get_eqm_lev_weight(10, 69) ->
	517;
get_eqm_lev_weight(10, 70) ->
	524;
get_eqm_lev_weight(10, 71) ->
	532;
get_eqm_lev_weight(10, 72) ->
	539;
get_eqm_lev_weight(10, 73) ->
	547;
get_eqm_lev_weight(10, 74) ->
	554;
get_eqm_lev_weight(10, 75) ->
	561;
get_eqm_lev_weight(10, 76) ->
	569;
get_eqm_lev_weight(10, 77) ->
	576;
get_eqm_lev_weight(10, 78) ->
	584;
get_eqm_lev_weight(10, 79) ->
	591;
get_eqm_lev_weight(10, 80) ->
	599;
get_eqm_lev_weight(10, 81) ->
	606;
get_eqm_lev_weight(10, 82) ->
	614;
get_eqm_lev_weight(10, 83) ->
	621;
get_eqm_lev_weight(10, 84) ->
	629;
get_eqm_lev_weight(10, 85) ->
	636;
get_eqm_lev_weight(10, 86) ->
	644;
get_eqm_lev_weight(10, 87) ->
	651;
get_eqm_lev_weight(10, 88) ->
	659;
get_eqm_lev_weight(10, 89) ->
	666;
get_eqm_lev_weight(10, 90) ->
	674;
get_eqm_lev_weight(10, 91) ->
	681;
get_eqm_lev_weight(10, 92) ->
	689;
get_eqm_lev_weight(10, 93) ->
	696;
get_eqm_lev_weight(10, 94) ->
	704;
get_eqm_lev_weight(10, 95) ->
	711;
get_eqm_lev_weight(10, 96) ->
	719;
get_eqm_lev_weight(10, 97) ->
	726;
get_eqm_lev_weight(10, 98) ->
	734;
get_eqm_lev_weight(10, 99) ->
	741;
get_eqm_lev_weight(10, 100) ->
	748;
get_eqm_lev_weight(11, 1) ->
	6;
get_eqm_lev_weight(11, 2) ->
	12;
get_eqm_lev_weight(11, 3) ->
	18;
get_eqm_lev_weight(11, 4) ->
	24;
get_eqm_lev_weight(11, 5) ->
	29;
get_eqm_lev_weight(11, 6) ->
	35;
get_eqm_lev_weight(11, 7) ->
	41;
get_eqm_lev_weight(11, 8) ->
	47;
get_eqm_lev_weight(11, 9) ->
	53;
get_eqm_lev_weight(11, 10) ->
	58;
get_eqm_lev_weight(11, 11) ->
	64;
get_eqm_lev_weight(11, 12) ->
	70;
get_eqm_lev_weight(11, 13) ->
	76;
get_eqm_lev_weight(11, 14) ->
	82;
get_eqm_lev_weight(11, 15) ->
	87;
get_eqm_lev_weight(11, 16) ->
	93;
get_eqm_lev_weight(11, 17) ->
	99;
get_eqm_lev_weight(11, 18) ->
	105;
get_eqm_lev_weight(11, 19) ->
	111;
get_eqm_lev_weight(11, 20) ->
	116;
get_eqm_lev_weight(11, 21) ->
	122;
get_eqm_lev_weight(11, 22) ->
	128;
get_eqm_lev_weight(11, 23) ->
	134;
get_eqm_lev_weight(11, 24) ->
	139;
get_eqm_lev_weight(11, 25) ->
	145;
get_eqm_lev_weight(11, 26) ->
	151;
get_eqm_lev_weight(11, 27) ->
	157;
get_eqm_lev_weight(11, 28) ->
	163;
get_eqm_lev_weight(11, 29) ->
	168;
get_eqm_lev_weight(11, 30) ->
	174;
get_eqm_lev_weight(11, 31) ->
	180;
get_eqm_lev_weight(11, 32) ->
	186;
get_eqm_lev_weight(11, 33) ->
	192;
get_eqm_lev_weight(11, 34) ->
	197;
get_eqm_lev_weight(11, 35) ->
	203;
get_eqm_lev_weight(11, 36) ->
	209;
get_eqm_lev_weight(11, 37) ->
	215;
get_eqm_lev_weight(11, 38) ->
	221;
get_eqm_lev_weight(11, 39) ->
	226;
get_eqm_lev_weight(11, 40) ->
	232;
get_eqm_lev_weight(11, 41) ->
	238;
get_eqm_lev_weight(11, 42) ->
	244;
get_eqm_lev_weight(11, 43) ->
	249;
get_eqm_lev_weight(11, 44) ->
	255;
get_eqm_lev_weight(11, 45) ->
	261;
get_eqm_lev_weight(11, 46) ->
	267;
get_eqm_lev_weight(11, 47) ->
	273;
get_eqm_lev_weight(11, 48) ->
	278;
get_eqm_lev_weight(11, 49) ->
	284;
get_eqm_lev_weight(11, 50) ->
	290;
get_eqm_lev_weight(11, 51) ->
	296;
get_eqm_lev_weight(11, 52) ->
	302;
get_eqm_lev_weight(11, 53) ->
	307;
get_eqm_lev_weight(11, 54) ->
	313;
get_eqm_lev_weight(11, 55) ->
	319;
get_eqm_lev_weight(11, 56) ->
	325;
get_eqm_lev_weight(11, 57) ->
	331;
get_eqm_lev_weight(11, 58) ->
	336;
get_eqm_lev_weight(11, 59) ->
	342;
get_eqm_lev_weight(11, 60) ->
	348;
get_eqm_lev_weight(11, 61) ->
	354;
get_eqm_lev_weight(11, 62) ->
	359;
get_eqm_lev_weight(11, 63) ->
	365;
get_eqm_lev_weight(11, 64) ->
	371;
get_eqm_lev_weight(11, 65) ->
	377;
get_eqm_lev_weight(11, 66) ->
	383;
get_eqm_lev_weight(11, 67) ->
	388;
get_eqm_lev_weight(11, 68) ->
	394;
get_eqm_lev_weight(11, 69) ->
	400;
get_eqm_lev_weight(11, 70) ->
	406;
get_eqm_lev_weight(11, 71) ->
	412;
get_eqm_lev_weight(11, 72) ->
	417;
get_eqm_lev_weight(11, 73) ->
	423;
get_eqm_lev_weight(11, 74) ->
	429;
get_eqm_lev_weight(11, 75) ->
	435;
get_eqm_lev_weight(11, 76) ->
	441;
get_eqm_lev_weight(11, 77) ->
	446;
get_eqm_lev_weight(11, 78) ->
	452;
get_eqm_lev_weight(11, 79) ->
	458;
get_eqm_lev_weight(11, 80) ->
	464;
get_eqm_lev_weight(11, 81) ->
	469;
get_eqm_lev_weight(11, 82) ->
	475;
get_eqm_lev_weight(11, 83) ->
	481;
get_eqm_lev_weight(11, 84) ->
	487;
get_eqm_lev_weight(11, 85) ->
	493;
get_eqm_lev_weight(11, 86) ->
	498;
get_eqm_lev_weight(11, 87) ->
	504;
get_eqm_lev_weight(11, 88) ->
	510;
get_eqm_lev_weight(11, 89) ->
	516;
get_eqm_lev_weight(11, 90) ->
	522;
get_eqm_lev_weight(11, 91) ->
	527;
get_eqm_lev_weight(11, 92) ->
	533;
get_eqm_lev_weight(11, 93) ->
	539;
get_eqm_lev_weight(11, 94) ->
	545;
get_eqm_lev_weight(11, 95) ->
	551;
get_eqm_lev_weight(11, 96) ->
	556;
get_eqm_lev_weight(11, 97) ->
	562;
get_eqm_lev_weight(11, 98) ->
	568;
get_eqm_lev_weight(11, 99) ->
	574;
get_eqm_lev_weight(11, 100) ->
	579;
get_eqm_lev_weight(12, 1) ->
	6;
get_eqm_lev_weight(12, 2) ->
	12;
get_eqm_lev_weight(12, 3) ->
	18;
get_eqm_lev_weight(12, 4) ->
	24;
get_eqm_lev_weight(12, 5) ->
	29;
get_eqm_lev_weight(12, 6) ->
	35;
get_eqm_lev_weight(12, 7) ->
	41;
get_eqm_lev_weight(12, 8) ->
	47;
get_eqm_lev_weight(12, 9) ->
	53;
get_eqm_lev_weight(12, 10) ->
	58;
get_eqm_lev_weight(12, 11) ->
	64;
get_eqm_lev_weight(12, 12) ->
	70;
get_eqm_lev_weight(12, 13) ->
	76;
get_eqm_lev_weight(12, 14) ->
	82;
get_eqm_lev_weight(12, 15) ->
	87;
get_eqm_lev_weight(12, 16) ->
	93;
get_eqm_lev_weight(12, 17) ->
	99;
get_eqm_lev_weight(12, 18) ->
	105;
get_eqm_lev_weight(12, 19) ->
	111;
get_eqm_lev_weight(12, 20) ->
	116;
get_eqm_lev_weight(12, 21) ->
	122;
get_eqm_lev_weight(12, 22) ->
	128;
get_eqm_lev_weight(12, 23) ->
	134;
get_eqm_lev_weight(12, 24) ->
	139;
get_eqm_lev_weight(12, 25) ->
	145;
get_eqm_lev_weight(12, 26) ->
	151;
get_eqm_lev_weight(12, 27) ->
	157;
get_eqm_lev_weight(12, 28) ->
	163;
get_eqm_lev_weight(12, 29) ->
	168;
get_eqm_lev_weight(12, 30) ->
	174;
get_eqm_lev_weight(12, 31) ->
	180;
get_eqm_lev_weight(12, 32) ->
	186;
get_eqm_lev_weight(12, 33) ->
	192;
get_eqm_lev_weight(12, 34) ->
	197;
get_eqm_lev_weight(12, 35) ->
	203;
get_eqm_lev_weight(12, 36) ->
	209;
get_eqm_lev_weight(12, 37) ->
	215;
get_eqm_lev_weight(12, 38) ->
	221;
get_eqm_lev_weight(12, 39) ->
	226;
get_eqm_lev_weight(12, 40) ->
	232;
get_eqm_lev_weight(12, 41) ->
	238;
get_eqm_lev_weight(12, 42) ->
	244;
get_eqm_lev_weight(12, 43) ->
	249;
get_eqm_lev_weight(12, 44) ->
	255;
get_eqm_lev_weight(12, 45) ->
	261;
get_eqm_lev_weight(12, 46) ->
	267;
get_eqm_lev_weight(12, 47) ->
	273;
get_eqm_lev_weight(12, 48) ->
	278;
get_eqm_lev_weight(12, 49) ->
	284;
get_eqm_lev_weight(12, 50) ->
	290;
get_eqm_lev_weight(12, 51) ->
	296;
get_eqm_lev_weight(12, 52) ->
	302;
get_eqm_lev_weight(12, 53) ->
	307;
get_eqm_lev_weight(12, 54) ->
	313;
get_eqm_lev_weight(12, 55) ->
	319;
get_eqm_lev_weight(12, 56) ->
	325;
get_eqm_lev_weight(12, 57) ->
	331;
get_eqm_lev_weight(12, 58) ->
	336;
get_eqm_lev_weight(12, 59) ->
	342;
get_eqm_lev_weight(12, 60) ->
	348;
get_eqm_lev_weight(12, 61) ->
	354;
get_eqm_lev_weight(12, 62) ->
	359;
get_eqm_lev_weight(12, 63) ->
	365;
get_eqm_lev_weight(12, 64) ->
	371;
get_eqm_lev_weight(12, 65) ->
	377;
get_eqm_lev_weight(12, 66) ->
	383;
get_eqm_lev_weight(12, 67) ->
	388;
get_eqm_lev_weight(12, 68) ->
	394;
get_eqm_lev_weight(12, 69) ->
	400;
get_eqm_lev_weight(12, 70) ->
	406;
get_eqm_lev_weight(12, 71) ->
	412;
get_eqm_lev_weight(12, 72) ->
	417;
get_eqm_lev_weight(12, 73) ->
	423;
get_eqm_lev_weight(12, 74) ->
	429;
get_eqm_lev_weight(12, 75) ->
	435;
get_eqm_lev_weight(12, 76) ->
	441;
get_eqm_lev_weight(12, 77) ->
	446;
get_eqm_lev_weight(12, 78) ->
	452;
get_eqm_lev_weight(12, 79) ->
	458;
get_eqm_lev_weight(12, 80) ->
	464;
get_eqm_lev_weight(12, 81) ->
	469;
get_eqm_lev_weight(12, 82) ->
	475;
get_eqm_lev_weight(12, 83) ->
	481;
get_eqm_lev_weight(12, 84) ->
	487;
get_eqm_lev_weight(12, 85) ->
	493;
get_eqm_lev_weight(12, 86) ->
	498;
get_eqm_lev_weight(12, 87) ->
	504;
get_eqm_lev_weight(12, 88) ->
	510;
get_eqm_lev_weight(12, 89) ->
	516;
get_eqm_lev_weight(12, 90) ->
	522;
get_eqm_lev_weight(12, 91) ->
	527;
get_eqm_lev_weight(12, 92) ->
	533;
get_eqm_lev_weight(12, 93) ->
	539;
get_eqm_lev_weight(12, 94) ->
	545;
get_eqm_lev_weight(12, 95) ->
	551;
get_eqm_lev_weight(12, 96) ->
	556;
get_eqm_lev_weight(12, 97) ->
	562;
get_eqm_lev_weight(12, 98) ->
	568;
get_eqm_lev_weight(12, 99) ->
	574;
get_eqm_lev_weight(12, 100) ->
	579;
get_eqm_lev_weight(13, 1) ->
	6;
get_eqm_lev_weight(13, 2) ->
	12;
get_eqm_lev_weight(13, 3) ->
	18;
get_eqm_lev_weight(13, 4) ->
	24;
get_eqm_lev_weight(13, 5) ->
	29;
get_eqm_lev_weight(13, 6) ->
	35;
get_eqm_lev_weight(13, 7) ->
	41;
get_eqm_lev_weight(13, 8) ->
	47;
get_eqm_lev_weight(13, 9) ->
	53;
get_eqm_lev_weight(13, 10) ->
	58;
get_eqm_lev_weight(13, 11) ->
	64;
get_eqm_lev_weight(13, 12) ->
	70;
get_eqm_lev_weight(13, 13) ->
	76;
get_eqm_lev_weight(13, 14) ->
	82;
get_eqm_lev_weight(13, 15) ->
	87;
get_eqm_lev_weight(13, 16) ->
	93;
get_eqm_lev_weight(13, 17) ->
	99;
get_eqm_lev_weight(13, 18) ->
	105;
get_eqm_lev_weight(13, 19) ->
	111;
get_eqm_lev_weight(13, 20) ->
	116;
get_eqm_lev_weight(13, 21) ->
	122;
get_eqm_lev_weight(13, 22) ->
	128;
get_eqm_lev_weight(13, 23) ->
	134;
get_eqm_lev_weight(13, 24) ->
	139;
get_eqm_lev_weight(13, 25) ->
	145;
get_eqm_lev_weight(13, 26) ->
	151;
get_eqm_lev_weight(13, 27) ->
	157;
get_eqm_lev_weight(13, 28) ->
	163;
get_eqm_lev_weight(13, 29) ->
	168;
get_eqm_lev_weight(13, 30) ->
	174;
get_eqm_lev_weight(13, 31) ->
	180;
get_eqm_lev_weight(13, 32) ->
	186;
get_eqm_lev_weight(13, 33) ->
	192;
get_eqm_lev_weight(13, 34) ->
	197;
get_eqm_lev_weight(13, 35) ->
	203;
get_eqm_lev_weight(13, 36) ->
	209;
get_eqm_lev_weight(13, 37) ->
	215;
get_eqm_lev_weight(13, 38) ->
	221;
get_eqm_lev_weight(13, 39) ->
	226;
get_eqm_lev_weight(13, 40) ->
	232;
get_eqm_lev_weight(13, 41) ->
	238;
get_eqm_lev_weight(13, 42) ->
	244;
get_eqm_lev_weight(13, 43) ->
	249;
get_eqm_lev_weight(13, 44) ->
	255;
get_eqm_lev_weight(13, 45) ->
	261;
get_eqm_lev_weight(13, 46) ->
	267;
get_eqm_lev_weight(13, 47) ->
	273;
get_eqm_lev_weight(13, 48) ->
	278;
get_eqm_lev_weight(13, 49) ->
	284;
get_eqm_lev_weight(13, 50) ->
	290;
get_eqm_lev_weight(13, 51) ->
	296;
get_eqm_lev_weight(13, 52) ->
	302;
get_eqm_lev_weight(13, 53) ->
	307;
get_eqm_lev_weight(13, 54) ->
	313;
get_eqm_lev_weight(13, 55) ->
	319;
get_eqm_lev_weight(13, 56) ->
	325;
get_eqm_lev_weight(13, 57) ->
	331;
get_eqm_lev_weight(13, 58) ->
	336;
get_eqm_lev_weight(13, 59) ->
	342;
get_eqm_lev_weight(13, 60) ->
	348;
get_eqm_lev_weight(13, 61) ->
	354;
get_eqm_lev_weight(13, 62) ->
	359;
get_eqm_lev_weight(13, 63) ->
	365;
get_eqm_lev_weight(13, 64) ->
	371;
get_eqm_lev_weight(13, 65) ->
	377;
get_eqm_lev_weight(13, 66) ->
	383;
get_eqm_lev_weight(13, 67) ->
	388;
get_eqm_lev_weight(13, 68) ->
	394;
get_eqm_lev_weight(13, 69) ->
	400;
get_eqm_lev_weight(13, 70) ->
	406;
get_eqm_lev_weight(13, 71) ->
	412;
get_eqm_lev_weight(13, 72) ->
	417;
get_eqm_lev_weight(13, 73) ->
	423;
get_eqm_lev_weight(13, 74) ->
	429;
get_eqm_lev_weight(13, 75) ->
	435;
get_eqm_lev_weight(13, 76) ->
	441;
get_eqm_lev_weight(13, 77) ->
	446;
get_eqm_lev_weight(13, 78) ->
	452;
get_eqm_lev_weight(13, 79) ->
	458;
get_eqm_lev_weight(13, 80) ->
	464;
get_eqm_lev_weight(13, 81) ->
	469;
get_eqm_lev_weight(13, 82) ->
	475;
get_eqm_lev_weight(13, 83) ->
	481;
get_eqm_lev_weight(13, 84) ->
	487;
get_eqm_lev_weight(13, 85) ->
	493;
get_eqm_lev_weight(13, 86) ->
	498;
get_eqm_lev_weight(13, 87) ->
	504;
get_eqm_lev_weight(13, 88) ->
	510;
get_eqm_lev_weight(13, 89) ->
	516;
get_eqm_lev_weight(13, 90) ->
	522;
get_eqm_lev_weight(13, 91) ->
	527;
get_eqm_lev_weight(13, 92) ->
	533;
get_eqm_lev_weight(13, 93) ->
	539;
get_eqm_lev_weight(13, 94) ->
	545;
get_eqm_lev_weight(13, 95) ->
	551;
get_eqm_lev_weight(13, 96) ->
	556;
get_eqm_lev_weight(13, 97) ->
	562;
get_eqm_lev_weight(13, 98) ->
	568;
get_eqm_lev_weight(13, 99) ->
	574;
get_eqm_lev_weight(13, 100) ->
	579;
get_eqm_lev_weight(14, 1) ->
	6;
get_eqm_lev_weight(14, 2) ->
	12;
get_eqm_lev_weight(14, 3) ->
	18;
get_eqm_lev_weight(14, 4) ->
	24;
get_eqm_lev_weight(14, 5) ->
	29;
get_eqm_lev_weight(14, 6) ->
	35;
get_eqm_lev_weight(14, 7) ->
	41;
get_eqm_lev_weight(14, 8) ->
	47;
get_eqm_lev_weight(14, 9) ->
	53;
get_eqm_lev_weight(14, 10) ->
	58;
get_eqm_lev_weight(14, 11) ->
	64;
get_eqm_lev_weight(14, 12) ->
	70;
get_eqm_lev_weight(14, 13) ->
	76;
get_eqm_lev_weight(14, 14) ->
	82;
get_eqm_lev_weight(14, 15) ->
	87;
get_eqm_lev_weight(14, 16) ->
	93;
get_eqm_lev_weight(14, 17) ->
	99;
get_eqm_lev_weight(14, 18) ->
	105;
get_eqm_lev_weight(14, 19) ->
	111;
get_eqm_lev_weight(14, 20) ->
	116;
get_eqm_lev_weight(14, 21) ->
	122;
get_eqm_lev_weight(14, 22) ->
	128;
get_eqm_lev_weight(14, 23) ->
	134;
get_eqm_lev_weight(14, 24) ->
	139;
get_eqm_lev_weight(14, 25) ->
	145;
get_eqm_lev_weight(14, 26) ->
	151;
get_eqm_lev_weight(14, 27) ->
	157;
get_eqm_lev_weight(14, 28) ->
	163;
get_eqm_lev_weight(14, 29) ->
	168;
get_eqm_lev_weight(14, 30) ->
	174;
get_eqm_lev_weight(14, 31) ->
	180;
get_eqm_lev_weight(14, 32) ->
	186;
get_eqm_lev_weight(14, 33) ->
	192;
get_eqm_lev_weight(14, 34) ->
	197;
get_eqm_lev_weight(14, 35) ->
	203;
get_eqm_lev_weight(14, 36) ->
	209;
get_eqm_lev_weight(14, 37) ->
	215;
get_eqm_lev_weight(14, 38) ->
	221;
get_eqm_lev_weight(14, 39) ->
	226;
get_eqm_lev_weight(14, 40) ->
	232;
get_eqm_lev_weight(14, 41) ->
	238;
get_eqm_lev_weight(14, 42) ->
	244;
get_eqm_lev_weight(14, 43) ->
	249;
get_eqm_lev_weight(14, 44) ->
	255;
get_eqm_lev_weight(14, 45) ->
	261;
get_eqm_lev_weight(14, 46) ->
	267;
get_eqm_lev_weight(14, 47) ->
	273;
get_eqm_lev_weight(14, 48) ->
	278;
get_eqm_lev_weight(14, 49) ->
	284;
get_eqm_lev_weight(14, 50) ->
	290;
get_eqm_lev_weight(14, 51) ->
	296;
get_eqm_lev_weight(14, 52) ->
	302;
get_eqm_lev_weight(14, 53) ->
	307;
get_eqm_lev_weight(14, 54) ->
	313;
get_eqm_lev_weight(14, 55) ->
	319;
get_eqm_lev_weight(14, 56) ->
	325;
get_eqm_lev_weight(14, 57) ->
	331;
get_eqm_lev_weight(14, 58) ->
	336;
get_eqm_lev_weight(14, 59) ->
	342;
get_eqm_lev_weight(14, 60) ->
	348;
get_eqm_lev_weight(14, 61) ->
	354;
get_eqm_lev_weight(14, 62) ->
	359;
get_eqm_lev_weight(14, 63) ->
	365;
get_eqm_lev_weight(14, 64) ->
	371;
get_eqm_lev_weight(14, 65) ->
	377;
get_eqm_lev_weight(14, 66) ->
	383;
get_eqm_lev_weight(14, 67) ->
	388;
get_eqm_lev_weight(14, 68) ->
	394;
get_eqm_lev_weight(14, 69) ->
	400;
get_eqm_lev_weight(14, 70) ->
	406;
get_eqm_lev_weight(14, 71) ->
	412;
get_eqm_lev_weight(14, 72) ->
	417;
get_eqm_lev_weight(14, 73) ->
	423;
get_eqm_lev_weight(14, 74) ->
	429;
get_eqm_lev_weight(14, 75) ->
	435;
get_eqm_lev_weight(14, 76) ->
	441;
get_eqm_lev_weight(14, 77) ->
	446;
get_eqm_lev_weight(14, 78) ->
	452;
get_eqm_lev_weight(14, 79) ->
	458;
get_eqm_lev_weight(14, 80) ->
	464;
get_eqm_lev_weight(14, 81) ->
	469;
get_eqm_lev_weight(14, 82) ->
	475;
get_eqm_lev_weight(14, 83) ->
	481;
get_eqm_lev_weight(14, 84) ->
	487;
get_eqm_lev_weight(14, 85) ->
	493;
get_eqm_lev_weight(14, 86) ->
	498;
get_eqm_lev_weight(14, 87) ->
	504;
get_eqm_lev_weight(14, 88) ->
	510;
get_eqm_lev_weight(14, 89) ->
	516;
get_eqm_lev_weight(14, 90) ->
	522;
get_eqm_lev_weight(14, 91) ->
	527;
get_eqm_lev_weight(14, 92) ->
	533;
get_eqm_lev_weight(14, 93) ->
	539;
get_eqm_lev_weight(14, 94) ->
	545;
get_eqm_lev_weight(14, 95) ->
	551;
get_eqm_lev_weight(14, 96) ->
	556;
get_eqm_lev_weight(14, 97) ->
	562;
get_eqm_lev_weight(14, 98) ->
	568;
get_eqm_lev_weight(14, 99) ->
	574;
get_eqm_lev_weight(14, 100) ->
	579;
get_eqm_lev_weight(15, 1) ->
	6;
get_eqm_lev_weight(15, 2) ->
	12;
get_eqm_lev_weight(15, 3) ->
	18;
get_eqm_lev_weight(15, 4) ->
	24;
get_eqm_lev_weight(15, 5) ->
	29;
get_eqm_lev_weight(15, 6) ->
	35;
get_eqm_lev_weight(15, 7) ->
	41;
get_eqm_lev_weight(15, 8) ->
	47;
get_eqm_lev_weight(15, 9) ->
	53;
get_eqm_lev_weight(15, 10) ->
	58;
get_eqm_lev_weight(15, 11) ->
	64;
get_eqm_lev_weight(15, 12) ->
	70;
get_eqm_lev_weight(15, 13) ->
	76;
get_eqm_lev_weight(15, 14) ->
	82;
get_eqm_lev_weight(15, 15) ->
	87;
get_eqm_lev_weight(15, 16) ->
	93;
get_eqm_lev_weight(15, 17) ->
	99;
get_eqm_lev_weight(15, 18) ->
	105;
get_eqm_lev_weight(15, 19) ->
	111;
get_eqm_lev_weight(15, 20) ->
	116;
get_eqm_lev_weight(15, 21) ->
	122;
get_eqm_lev_weight(15, 22) ->
	128;
get_eqm_lev_weight(15, 23) ->
	134;
get_eqm_lev_weight(15, 24) ->
	139;
get_eqm_lev_weight(15, 25) ->
	145;
get_eqm_lev_weight(15, 26) ->
	151;
get_eqm_lev_weight(15, 27) ->
	157;
get_eqm_lev_weight(15, 28) ->
	163;
get_eqm_lev_weight(15, 29) ->
	168;
get_eqm_lev_weight(15, 30) ->
	174;
get_eqm_lev_weight(15, 31) ->
	180;
get_eqm_lev_weight(15, 32) ->
	186;
get_eqm_lev_weight(15, 33) ->
	192;
get_eqm_lev_weight(15, 34) ->
	197;
get_eqm_lev_weight(15, 35) ->
	203;
get_eqm_lev_weight(15, 36) ->
	209;
get_eqm_lev_weight(15, 37) ->
	215;
get_eqm_lev_weight(15, 38) ->
	221;
get_eqm_lev_weight(15, 39) ->
	226;
get_eqm_lev_weight(15, 40) ->
	232;
get_eqm_lev_weight(15, 41) ->
	238;
get_eqm_lev_weight(15, 42) ->
	244;
get_eqm_lev_weight(15, 43) ->
	249;
get_eqm_lev_weight(15, 44) ->
	255;
get_eqm_lev_weight(15, 45) ->
	261;
get_eqm_lev_weight(15, 46) ->
	267;
get_eqm_lev_weight(15, 47) ->
	273;
get_eqm_lev_weight(15, 48) ->
	278;
get_eqm_lev_weight(15, 49) ->
	284;
get_eqm_lev_weight(15, 50) ->
	290;
get_eqm_lev_weight(15, 51) ->
	296;
get_eqm_lev_weight(15, 52) ->
	302;
get_eqm_lev_weight(15, 53) ->
	307;
get_eqm_lev_weight(15, 54) ->
	313;
get_eqm_lev_weight(15, 55) ->
	319;
get_eqm_lev_weight(15, 56) ->
	325;
get_eqm_lev_weight(15, 57) ->
	331;
get_eqm_lev_weight(15, 58) ->
	336;
get_eqm_lev_weight(15, 59) ->
	342;
get_eqm_lev_weight(15, 60) ->
	348;
get_eqm_lev_weight(15, 61) ->
	354;
get_eqm_lev_weight(15, 62) ->
	359;
get_eqm_lev_weight(15, 63) ->
	365;
get_eqm_lev_weight(15, 64) ->
	371;
get_eqm_lev_weight(15, 65) ->
	377;
get_eqm_lev_weight(15, 66) ->
	383;
get_eqm_lev_weight(15, 67) ->
	388;
get_eqm_lev_weight(15, 68) ->
	394;
get_eqm_lev_weight(15, 69) ->
	400;
get_eqm_lev_weight(15, 70) ->
	406;
get_eqm_lev_weight(15, 71) ->
	412;
get_eqm_lev_weight(15, 72) ->
	417;
get_eqm_lev_weight(15, 73) ->
	423;
get_eqm_lev_weight(15, 74) ->
	429;
get_eqm_lev_weight(15, 75) ->
	435;
get_eqm_lev_weight(15, 76) ->
	441;
get_eqm_lev_weight(15, 77) ->
	446;
get_eqm_lev_weight(15, 78) ->
	452;
get_eqm_lev_weight(15, 79) ->
	458;
get_eqm_lev_weight(15, 80) ->
	464;
get_eqm_lev_weight(15, 81) ->
	469;
get_eqm_lev_weight(15, 82) ->
	475;
get_eqm_lev_weight(15, 83) ->
	481;
get_eqm_lev_weight(15, 84) ->
	487;
get_eqm_lev_weight(15, 85) ->
	493;
get_eqm_lev_weight(15, 86) ->
	498;
get_eqm_lev_weight(15, 87) ->
	504;
get_eqm_lev_weight(15, 88) ->
	510;
get_eqm_lev_weight(15, 89) ->
	516;
get_eqm_lev_weight(15, 90) ->
	522;
get_eqm_lev_weight(15, 91) ->
	527;
get_eqm_lev_weight(15, 92) ->
	533;
get_eqm_lev_weight(15, 93) ->
	539;
get_eqm_lev_weight(15, 94) ->
	545;
get_eqm_lev_weight(15, 95) ->
	551;
get_eqm_lev_weight(15, 96) ->
	556;
get_eqm_lev_weight(15, 97) ->
	562;
get_eqm_lev_weight(15, 98) ->
	568;
get_eqm_lev_weight(15, 99) ->
	574;
get_eqm_lev_weight(15, 100) ->
	579;
get_eqm_lev_weight(16, 1) ->
	6;
get_eqm_lev_weight(16, 2) ->
	12;
get_eqm_lev_weight(16, 3) ->
	18;
get_eqm_lev_weight(16, 4) ->
	24;
get_eqm_lev_weight(16, 5) ->
	29;
get_eqm_lev_weight(16, 6) ->
	35;
get_eqm_lev_weight(16, 7) ->
	41;
get_eqm_lev_weight(16, 8) ->
	47;
get_eqm_lev_weight(16, 9) ->
	53;
get_eqm_lev_weight(16, 10) ->
	58;
get_eqm_lev_weight(16, 11) ->
	64;
get_eqm_lev_weight(16, 12) ->
	70;
get_eqm_lev_weight(16, 13) ->
	76;
get_eqm_lev_weight(16, 14) ->
	82;
get_eqm_lev_weight(16, 15) ->
	87;
get_eqm_lev_weight(16, 16) ->
	93;
get_eqm_lev_weight(16, 17) ->
	99;
get_eqm_lev_weight(16, 18) ->
	105;
get_eqm_lev_weight(16, 19) ->
	111;
get_eqm_lev_weight(16, 20) ->
	116;
get_eqm_lev_weight(16, 21) ->
	122;
get_eqm_lev_weight(16, 22) ->
	128;
get_eqm_lev_weight(16, 23) ->
	134;
get_eqm_lev_weight(16, 24) ->
	139;
get_eqm_lev_weight(16, 25) ->
	145;
get_eqm_lev_weight(16, 26) ->
	151;
get_eqm_lev_weight(16, 27) ->
	157;
get_eqm_lev_weight(16, 28) ->
	163;
get_eqm_lev_weight(16, 29) ->
	168;
get_eqm_lev_weight(16, 30) ->
	174;
get_eqm_lev_weight(16, 31) ->
	180;
get_eqm_lev_weight(16, 32) ->
	186;
get_eqm_lev_weight(16, 33) ->
	192;
get_eqm_lev_weight(16, 34) ->
	197;
get_eqm_lev_weight(16, 35) ->
	203;
get_eqm_lev_weight(16, 36) ->
	209;
get_eqm_lev_weight(16, 37) ->
	215;
get_eqm_lev_weight(16, 38) ->
	221;
get_eqm_lev_weight(16, 39) ->
	226;
get_eqm_lev_weight(16, 40) ->
	232;
get_eqm_lev_weight(16, 41) ->
	238;
get_eqm_lev_weight(16, 42) ->
	244;
get_eqm_lev_weight(16, 43) ->
	249;
get_eqm_lev_weight(16, 44) ->
	255;
get_eqm_lev_weight(16, 45) ->
	261;
get_eqm_lev_weight(16, 46) ->
	267;
get_eqm_lev_weight(16, 47) ->
	273;
get_eqm_lev_weight(16, 48) ->
	278;
get_eqm_lev_weight(16, 49) ->
	284;
get_eqm_lev_weight(16, 50) ->
	290;
get_eqm_lev_weight(16, 51) ->
	296;
get_eqm_lev_weight(16, 52) ->
	302;
get_eqm_lev_weight(16, 53) ->
	307;
get_eqm_lev_weight(16, 54) ->
	313;
get_eqm_lev_weight(16, 55) ->
	319;
get_eqm_lev_weight(16, 56) ->
	325;
get_eqm_lev_weight(16, 57) ->
	331;
get_eqm_lev_weight(16, 58) ->
	336;
get_eqm_lev_weight(16, 59) ->
	342;
get_eqm_lev_weight(16, 60) ->
	348;
get_eqm_lev_weight(16, 61) ->
	354;
get_eqm_lev_weight(16, 62) ->
	359;
get_eqm_lev_weight(16, 63) ->
	365;
get_eqm_lev_weight(16, 64) ->
	371;
get_eqm_lev_weight(16, 65) ->
	377;
get_eqm_lev_weight(16, 66) ->
	383;
get_eqm_lev_weight(16, 67) ->
	388;
get_eqm_lev_weight(16, 68) ->
	394;
get_eqm_lev_weight(16, 69) ->
	400;
get_eqm_lev_weight(16, 70) ->
	406;
get_eqm_lev_weight(16, 71) ->
	412;
get_eqm_lev_weight(16, 72) ->
	417;
get_eqm_lev_weight(16, 73) ->
	423;
get_eqm_lev_weight(16, 74) ->
	429;
get_eqm_lev_weight(16, 75) ->
	435;
get_eqm_lev_weight(16, 76) ->
	441;
get_eqm_lev_weight(16, 77) ->
	446;
get_eqm_lev_weight(16, 78) ->
	452;
get_eqm_lev_weight(16, 79) ->
	458;
get_eqm_lev_weight(16, 80) ->
	464;
get_eqm_lev_weight(16, 81) ->
	469;
get_eqm_lev_weight(16, 82) ->
	475;
get_eqm_lev_weight(16, 83) ->
	481;
get_eqm_lev_weight(16, 84) ->
	487;
get_eqm_lev_weight(16, 85) ->
	493;
get_eqm_lev_weight(16, 86) ->
	498;
get_eqm_lev_weight(16, 87) ->
	504;
get_eqm_lev_weight(16, 88) ->
	510;
get_eqm_lev_weight(16, 89) ->
	516;
get_eqm_lev_weight(16, 90) ->
	522;
get_eqm_lev_weight(16, 91) ->
	527;
get_eqm_lev_weight(16, 92) ->
	533;
get_eqm_lev_weight(16, 93) ->
	539;
get_eqm_lev_weight(16, 94) ->
	545;
get_eqm_lev_weight(16, 95) ->
	551;
get_eqm_lev_weight(16, 96) ->
	556;
get_eqm_lev_weight(16, 97) ->
	562;
get_eqm_lev_weight(16, 98) ->
	568;
get_eqm_lev_weight(16, 99) ->
	574;
get_eqm_lev_weight(16, 100) ->
	579;
get_eqm_lev_weight(17, 1) ->
	8;
get_eqm_lev_weight(17, 2) ->
	16;
get_eqm_lev_weight(17, 3) ->
	24;
get_eqm_lev_weight(17, 4) ->
	31;
get_eqm_lev_weight(17, 5) ->
	39;
get_eqm_lev_weight(17, 6) ->
	47;
get_eqm_lev_weight(17, 7) ->
	55;
get_eqm_lev_weight(17, 8) ->
	62;
get_eqm_lev_weight(17, 9) ->
	70;
get_eqm_lev_weight(17, 10) ->
	78;
get_eqm_lev_weight(17, 11) ->
	86;
get_eqm_lev_weight(17, 12) ->
	93;
get_eqm_lev_weight(17, 13) ->
	101;
get_eqm_lev_weight(17, 14) ->
	109;
get_eqm_lev_weight(17, 15) ->
	117;
get_eqm_lev_weight(17, 16) ->
	124;
get_eqm_lev_weight(17, 17) ->
	132;
get_eqm_lev_weight(17, 18) ->
	140;
get_eqm_lev_weight(17, 19) ->
	148;
get_eqm_lev_weight(17, 20) ->
	155;
get_eqm_lev_weight(17, 21) ->
	163;
get_eqm_lev_weight(17, 22) ->
	171;
get_eqm_lev_weight(17, 23) ->
	179;
get_eqm_lev_weight(17, 24) ->
	186;
get_eqm_lev_weight(17, 25) ->
	194;
get_eqm_lev_weight(17, 26) ->
	202;
get_eqm_lev_weight(17, 27) ->
	209;
get_eqm_lev_weight(17, 28) ->
	217;
get_eqm_lev_weight(17, 29) ->
	225;
get_eqm_lev_weight(17, 30) ->
	233;
get_eqm_lev_weight(17, 31) ->
	240;
get_eqm_lev_weight(17, 32) ->
	248;
get_eqm_lev_weight(17, 33) ->
	256;
get_eqm_lev_weight(17, 34) ->
	264;
get_eqm_lev_weight(17, 35) ->
	271;
get_eqm_lev_weight(17, 36) ->
	279;
get_eqm_lev_weight(17, 37) ->
	287;
get_eqm_lev_weight(17, 38) ->
	295;
get_eqm_lev_weight(17, 39) ->
	302;
get_eqm_lev_weight(17, 40) ->
	310;
get_eqm_lev_weight(17, 41) ->
	318;
get_eqm_lev_weight(17, 42) ->
	326;
get_eqm_lev_weight(17, 43) ->
	333;
get_eqm_lev_weight(17, 44) ->
	341;
get_eqm_lev_weight(17, 45) ->
	349;
get_eqm_lev_weight(17, 46) ->
	357;
get_eqm_lev_weight(17, 47) ->
	364;
get_eqm_lev_weight(17, 48) ->
	372;
get_eqm_lev_weight(17, 49) ->
	380;
get_eqm_lev_weight(17, 50) ->
	387;
get_eqm_lev_weight(17, 51) ->
	395;
get_eqm_lev_weight(17, 52) ->
	403;
get_eqm_lev_weight(17, 53) ->
	411;
get_eqm_lev_weight(17, 54) ->
	418;
get_eqm_lev_weight(17, 55) ->
	426;
get_eqm_lev_weight(17, 56) ->
	434;
get_eqm_lev_weight(17, 57) ->
	442;
get_eqm_lev_weight(17, 58) ->
	449;
get_eqm_lev_weight(17, 59) ->
	457;
get_eqm_lev_weight(17, 60) ->
	465;
get_eqm_lev_weight(17, 61) ->
	473;
get_eqm_lev_weight(17, 62) ->
	480;
get_eqm_lev_weight(17, 63) ->
	488;
get_eqm_lev_weight(17, 64) ->
	496;
get_eqm_lev_weight(17, 65) ->
	504;
get_eqm_lev_weight(17, 66) ->
	511;
get_eqm_lev_weight(17, 67) ->
	519;
get_eqm_lev_weight(17, 68) ->
	527;
get_eqm_lev_weight(17, 69) ->
	535;
get_eqm_lev_weight(17, 70) ->
	542;
get_eqm_lev_weight(17, 71) ->
	550;
get_eqm_lev_weight(17, 72) ->
	558;
get_eqm_lev_weight(17, 73) ->
	566;
get_eqm_lev_weight(17, 74) ->
	573;
get_eqm_lev_weight(17, 75) ->
	581;
get_eqm_lev_weight(17, 76) ->
	589;
get_eqm_lev_weight(17, 77) ->
	596;
get_eqm_lev_weight(17, 78) ->
	604;
get_eqm_lev_weight(17, 79) ->
	612;
get_eqm_lev_weight(17, 80) ->
	620;
get_eqm_lev_weight(17, 81) ->
	627;
get_eqm_lev_weight(17, 82) ->
	635;
get_eqm_lev_weight(17, 83) ->
	643;
get_eqm_lev_weight(17, 84) ->
	651;
get_eqm_lev_weight(17, 85) ->
	658;
get_eqm_lev_weight(17, 86) ->
	666;
get_eqm_lev_weight(17, 87) ->
	674;
get_eqm_lev_weight(17, 88) ->
	682;
get_eqm_lev_weight(17, 89) ->
	689;
get_eqm_lev_weight(17, 90) ->
	697;
get_eqm_lev_weight(17, 91) ->
	705;
get_eqm_lev_weight(17, 92) ->
	713;
get_eqm_lev_weight(17, 93) ->
	720;
get_eqm_lev_weight(17, 94) ->
	728;
get_eqm_lev_weight(17, 95) ->
	736;
get_eqm_lev_weight(17, 96) ->
	744;
get_eqm_lev_weight(17, 97) ->
	751;
get_eqm_lev_weight(17, 98) ->
	759;
get_eqm_lev_weight(17, 99) ->
	767;
get_eqm_lev_weight(17, 100) ->
	774;
get_eqm_lev_weight(18, 1) ->
	8;
get_eqm_lev_weight(18, 2) ->
	16;
get_eqm_lev_weight(18, 3) ->
	24;
get_eqm_lev_weight(18, 4) ->
	31;
get_eqm_lev_weight(18, 5) ->
	39;
get_eqm_lev_weight(18, 6) ->
	47;
get_eqm_lev_weight(18, 7) ->
	55;
get_eqm_lev_weight(18, 8) ->
	62;
get_eqm_lev_weight(18, 9) ->
	70;
get_eqm_lev_weight(18, 10) ->
	78;
get_eqm_lev_weight(18, 11) ->
	86;
get_eqm_lev_weight(18, 12) ->
	93;
get_eqm_lev_weight(18, 13) ->
	101;
get_eqm_lev_weight(18, 14) ->
	109;
get_eqm_lev_weight(18, 15) ->
	117;
get_eqm_lev_weight(18, 16) ->
	124;
get_eqm_lev_weight(18, 17) ->
	132;
get_eqm_lev_weight(18, 18) ->
	140;
get_eqm_lev_weight(18, 19) ->
	148;
get_eqm_lev_weight(18, 20) ->
	155;
get_eqm_lev_weight(18, 21) ->
	163;
get_eqm_lev_weight(18, 22) ->
	171;
get_eqm_lev_weight(18, 23) ->
	179;
get_eqm_lev_weight(18, 24) ->
	186;
get_eqm_lev_weight(18, 25) ->
	194;
get_eqm_lev_weight(18, 26) ->
	202;
get_eqm_lev_weight(18, 27) ->
	209;
get_eqm_lev_weight(18, 28) ->
	217;
get_eqm_lev_weight(18, 29) ->
	225;
get_eqm_lev_weight(18, 30) ->
	233;
get_eqm_lev_weight(18, 31) ->
	240;
get_eqm_lev_weight(18, 32) ->
	248;
get_eqm_lev_weight(18, 33) ->
	256;
get_eqm_lev_weight(18, 34) ->
	264;
get_eqm_lev_weight(18, 35) ->
	271;
get_eqm_lev_weight(18, 36) ->
	279;
get_eqm_lev_weight(18, 37) ->
	287;
get_eqm_lev_weight(18, 38) ->
	295;
get_eqm_lev_weight(18, 39) ->
	302;
get_eqm_lev_weight(18, 40) ->
	310;
get_eqm_lev_weight(18, 41) ->
	318;
get_eqm_lev_weight(18, 42) ->
	326;
get_eqm_lev_weight(18, 43) ->
	333;
get_eqm_lev_weight(18, 44) ->
	341;
get_eqm_lev_weight(18, 45) ->
	349;
get_eqm_lev_weight(18, 46) ->
	357;
get_eqm_lev_weight(18, 47) ->
	364;
get_eqm_lev_weight(18, 48) ->
	372;
get_eqm_lev_weight(18, 49) ->
	380;
get_eqm_lev_weight(18, 50) ->
	387;
get_eqm_lev_weight(18, 51) ->
	395;
get_eqm_lev_weight(18, 52) ->
	403;
get_eqm_lev_weight(18, 53) ->
	411;
get_eqm_lev_weight(18, 54) ->
	418;
get_eqm_lev_weight(18, 55) ->
	426;
get_eqm_lev_weight(18, 56) ->
	434;
get_eqm_lev_weight(18, 57) ->
	442;
get_eqm_lev_weight(18, 58) ->
	449;
get_eqm_lev_weight(18, 59) ->
	457;
get_eqm_lev_weight(18, 60) ->
	465;
get_eqm_lev_weight(18, 61) ->
	473;
get_eqm_lev_weight(18, 62) ->
	480;
get_eqm_lev_weight(18, 63) ->
	488;
get_eqm_lev_weight(18, 64) ->
	496;
get_eqm_lev_weight(18, 65) ->
	504;
get_eqm_lev_weight(18, 66) ->
	511;
get_eqm_lev_weight(18, 67) ->
	519;
get_eqm_lev_weight(18, 68) ->
	527;
get_eqm_lev_weight(18, 69) ->
	535;
get_eqm_lev_weight(18, 70) ->
	542;
get_eqm_lev_weight(18, 71) ->
	550;
get_eqm_lev_weight(18, 72) ->
	558;
get_eqm_lev_weight(18, 73) ->
	566;
get_eqm_lev_weight(18, 74) ->
	573;
get_eqm_lev_weight(18, 75) ->
	581;
get_eqm_lev_weight(18, 76) ->
	589;
get_eqm_lev_weight(18, 77) ->
	596;
get_eqm_lev_weight(18, 78) ->
	604;
get_eqm_lev_weight(18, 79) ->
	612;
get_eqm_lev_weight(18, 80) ->
	620;
get_eqm_lev_weight(18, 81) ->
	627;
get_eqm_lev_weight(18, 82) ->
	635;
get_eqm_lev_weight(18, 83) ->
	643;
get_eqm_lev_weight(18, 84) ->
	651;
get_eqm_lev_weight(18, 85) ->
	658;
get_eqm_lev_weight(18, 86) ->
	666;
get_eqm_lev_weight(18, 87) ->
	674;
get_eqm_lev_weight(18, 88) ->
	682;
get_eqm_lev_weight(18, 89) ->
	689;
get_eqm_lev_weight(18, 90) ->
	697;
get_eqm_lev_weight(18, 91) ->
	705;
get_eqm_lev_weight(18, 92) ->
	713;
get_eqm_lev_weight(18, 93) ->
	720;
get_eqm_lev_weight(18, 94) ->
	728;
get_eqm_lev_weight(18, 95) ->
	736;
get_eqm_lev_weight(18, 96) ->
	744;
get_eqm_lev_weight(18, 97) ->
	751;
get_eqm_lev_weight(18, 98) ->
	759;
get_eqm_lev_weight(18, 99) ->
	767;
get_eqm_lev_weight(18, 100) ->
	774;
get_eqm_lev_weight(19, 1) ->
	8;
get_eqm_lev_weight(19, 2) ->
	16;
get_eqm_lev_weight(19, 3) ->
	24;
get_eqm_lev_weight(19, 4) ->
	31;
get_eqm_lev_weight(19, 5) ->
	39;
get_eqm_lev_weight(19, 6) ->
	47;
get_eqm_lev_weight(19, 7) ->
	55;
get_eqm_lev_weight(19, 8) ->
	62;
get_eqm_lev_weight(19, 9) ->
	70;
get_eqm_lev_weight(19, 10) ->
	78;
get_eqm_lev_weight(19, 11) ->
	86;
get_eqm_lev_weight(19, 12) ->
	93;
get_eqm_lev_weight(19, 13) ->
	101;
get_eqm_lev_weight(19, 14) ->
	109;
get_eqm_lev_weight(19, 15) ->
	117;
get_eqm_lev_weight(19, 16) ->
	124;
get_eqm_lev_weight(19, 17) ->
	132;
get_eqm_lev_weight(19, 18) ->
	140;
get_eqm_lev_weight(19, 19) ->
	148;
get_eqm_lev_weight(19, 20) ->
	155;
get_eqm_lev_weight(19, 21) ->
	163;
get_eqm_lev_weight(19, 22) ->
	171;
get_eqm_lev_weight(19, 23) ->
	179;
get_eqm_lev_weight(19, 24) ->
	186;
get_eqm_lev_weight(19, 25) ->
	194;
get_eqm_lev_weight(19, 26) ->
	202;
get_eqm_lev_weight(19, 27) ->
	209;
get_eqm_lev_weight(19, 28) ->
	217;
get_eqm_lev_weight(19, 29) ->
	225;
get_eqm_lev_weight(19, 30) ->
	233;
get_eqm_lev_weight(19, 31) ->
	240;
get_eqm_lev_weight(19, 32) ->
	248;
get_eqm_lev_weight(19, 33) ->
	256;
get_eqm_lev_weight(19, 34) ->
	264;
get_eqm_lev_weight(19, 35) ->
	271;
get_eqm_lev_weight(19, 36) ->
	279;
get_eqm_lev_weight(19, 37) ->
	287;
get_eqm_lev_weight(19, 38) ->
	295;
get_eqm_lev_weight(19, 39) ->
	302;
get_eqm_lev_weight(19, 40) ->
	310;
get_eqm_lev_weight(19, 41) ->
	318;
get_eqm_lev_weight(19, 42) ->
	326;
get_eqm_lev_weight(19, 43) ->
	333;
get_eqm_lev_weight(19, 44) ->
	341;
get_eqm_lev_weight(19, 45) ->
	349;
get_eqm_lev_weight(19, 46) ->
	357;
get_eqm_lev_weight(19, 47) ->
	364;
get_eqm_lev_weight(19, 48) ->
	372;
get_eqm_lev_weight(19, 49) ->
	380;
get_eqm_lev_weight(19, 50) ->
	387;
get_eqm_lev_weight(19, 51) ->
	395;
get_eqm_lev_weight(19, 52) ->
	403;
get_eqm_lev_weight(19, 53) ->
	411;
get_eqm_lev_weight(19, 54) ->
	418;
get_eqm_lev_weight(19, 55) ->
	426;
get_eqm_lev_weight(19, 56) ->
	434;
get_eqm_lev_weight(19, 57) ->
	442;
get_eqm_lev_weight(19, 58) ->
	449;
get_eqm_lev_weight(19, 59) ->
	457;
get_eqm_lev_weight(19, 60) ->
	465;
get_eqm_lev_weight(19, 61) ->
	473;
get_eqm_lev_weight(19, 62) ->
	480;
get_eqm_lev_weight(19, 63) ->
	488;
get_eqm_lev_weight(19, 64) ->
	496;
get_eqm_lev_weight(19, 65) ->
	504;
get_eqm_lev_weight(19, 66) ->
	511;
get_eqm_lev_weight(19, 67) ->
	519;
get_eqm_lev_weight(19, 68) ->
	527;
get_eqm_lev_weight(19, 69) ->
	535;
get_eqm_lev_weight(19, 70) ->
	542;
get_eqm_lev_weight(19, 71) ->
	550;
get_eqm_lev_weight(19, 72) ->
	558;
get_eqm_lev_weight(19, 73) ->
	566;
get_eqm_lev_weight(19, 74) ->
	573;
get_eqm_lev_weight(19, 75) ->
	581;
get_eqm_lev_weight(19, 76) ->
	589;
get_eqm_lev_weight(19, 77) ->
	596;
get_eqm_lev_weight(19, 78) ->
	604;
get_eqm_lev_weight(19, 79) ->
	612;
get_eqm_lev_weight(19, 80) ->
	620;
get_eqm_lev_weight(19, 81) ->
	627;
get_eqm_lev_weight(19, 82) ->
	635;
get_eqm_lev_weight(19, 83) ->
	643;
get_eqm_lev_weight(19, 84) ->
	651;
get_eqm_lev_weight(19, 85) ->
	658;
get_eqm_lev_weight(19, 86) ->
	666;
get_eqm_lev_weight(19, 87) ->
	674;
get_eqm_lev_weight(19, 88) ->
	682;
get_eqm_lev_weight(19, 89) ->
	689;
get_eqm_lev_weight(19, 90) ->
	697;
get_eqm_lev_weight(19, 91) ->
	705;
get_eqm_lev_weight(19, 92) ->
	713;
get_eqm_lev_weight(19, 93) ->
	720;
get_eqm_lev_weight(19, 94) ->
	728;
get_eqm_lev_weight(19, 95) ->
	736;
get_eqm_lev_weight(19, 96) ->
	744;
get_eqm_lev_weight(19, 97) ->
	751;
get_eqm_lev_weight(19, 98) ->
	759;
get_eqm_lev_weight(19, 99) ->
	767;
get_eqm_lev_weight(19, 100) ->
	774;
get_eqm_lev_weight(_Id, _) ->
		0.


