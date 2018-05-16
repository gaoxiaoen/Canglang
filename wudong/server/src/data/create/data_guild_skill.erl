%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_skill
	%%% @Created : 2017-06-19 20:41:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_skill).
-export([ids/0,id_lvs/1,get/2]).
-include("common.hrl").
-include("guild.hrl").

    ids() ->
    [2,3,1,9,10,7,8].

    id_lvs(2) ->
    [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100];

    id_lvs(3) ->
    [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100];

    id_lvs(1) ->
    [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100];

    id_lvs(9) ->
    [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100];

    id_lvs(10) ->
    [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100];

    id_lvs(7) ->
    [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100];

    id_lvs(8) ->
    [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100];

    id_lvs(_) ->
    [].
get(2,1) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击50点") ,lv = 1 ,glv = 1 ,plv = 1 ,attribute = 50 ,contrib = 100 };
get(2,2) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击100点") ,lv = 2 ,glv = 1 ,plv = 1 ,attribute = 100 ,contrib = 100 };
get(2,3) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击150点") ,lv = 3 ,glv = 1 ,plv = 1 ,attribute = 150 ,contrib = 100 };
get(2,4) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击200点") ,lv = 4 ,glv = 1 ,plv = 1 ,attribute = 200 ,contrib = 100 };
get(2,5) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击250点") ,lv = 5 ,glv = 1 ,plv = 1 ,attribute = 250 ,contrib = 100 };
get(2,6) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击300点") ,lv = 6 ,glv = 1 ,plv = 1 ,attribute = 300 ,contrib = 200 };
get(2,7) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击350点") ,lv = 7 ,glv = 1 ,plv = 1 ,attribute = 350 ,contrib = 200 };
get(2,8) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击400点") ,lv = 8 ,glv = 1 ,plv = 1 ,attribute = 400 ,contrib = 200 };
get(2,9) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击450点") ,lv = 9 ,glv = 1 ,plv = 1 ,attribute = 450 ,contrib = 200 };
get(2,10) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击500点") ,lv = 10 ,glv = 1 ,plv = 1 ,attribute = 500 ,contrib = 200 };
get(2,11) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击550点") ,lv = 11 ,glv = 1 ,plv = 1 ,attribute = 550 ,contrib = 300 };
get(2,12) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击600点") ,lv = 12 ,glv = 1 ,plv = 1 ,attribute = 600 ,contrib = 300 };
get(2,13) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击650点") ,lv = 13 ,glv = 1 ,plv = 1 ,attribute = 650 ,contrib = 300 };
get(2,14) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击700点") ,lv = 14 ,glv = 1 ,plv = 1 ,attribute = 700 ,contrib = 300 };
get(2,15) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击750点") ,lv = 15 ,glv = 1 ,plv = 1 ,attribute = 750 ,contrib = 300 };
get(2,16) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击800点") ,lv = 16 ,glv = 1 ,plv = 1 ,attribute = 800 ,contrib = 400 };
get(2,17) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击850点") ,lv = 17 ,glv = 1 ,plv = 1 ,attribute = 850 ,contrib = 400 };
get(2,18) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击900点") ,lv = 18 ,glv = 1 ,plv = 1 ,attribute = 900 ,contrib = 400 };
get(2,19) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击950点") ,lv = 19 ,glv = 1 ,plv = 1 ,attribute = 950 ,contrib = 400 };
get(2,20) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1000点") ,lv = 20 ,glv = 1 ,plv = 1 ,attribute = 1000 ,contrib = 400 };
get(2,21) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1050点") ,lv = 21 ,glv = 1 ,plv = 1 ,attribute = 1050 ,contrib = 500 };
get(2,22) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1100点") ,lv = 22 ,glv = 1 ,plv = 1 ,attribute = 1100 ,contrib = 500 };
get(2,23) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1150点") ,lv = 23 ,glv = 1 ,plv = 1 ,attribute = 1150 ,contrib = 500 };
get(2,24) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1200点") ,lv = 24 ,glv = 1 ,plv = 1 ,attribute = 1200 ,contrib = 500 };
get(2,25) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1250点") ,lv = 25 ,glv = 1 ,plv = 1 ,attribute = 1250 ,contrib = 500 };
get(2,26) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1300点") ,lv = 26 ,glv = 1 ,plv = 1 ,attribute = 1300 ,contrib = 600 };
get(2,27) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1350点") ,lv = 27 ,glv = 1 ,plv = 1 ,attribute = 1350 ,contrib = 600 };
get(2,28) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1400点") ,lv = 28 ,glv = 1 ,plv = 1 ,attribute = 1400 ,contrib = 600 };
get(2,29) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1450点") ,lv = 29 ,glv = 1 ,plv = 1 ,attribute = 1450 ,contrib = 600 };
get(2,30) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1500点") ,lv = 30 ,glv = 1 ,plv = 1 ,attribute = 1500 ,contrib = 600 };
get(2,31) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1550点") ,lv = 31 ,glv = 1 ,plv = 1 ,attribute = 1550 ,contrib = 700 };
get(2,32) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1600点") ,lv = 32 ,glv = 1 ,plv = 1 ,attribute = 1600 ,contrib = 700 };
get(2,33) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1650点") ,lv = 33 ,glv = 1 ,plv = 1 ,attribute = 1650 ,contrib = 700 };
get(2,34) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1700点") ,lv = 34 ,glv = 1 ,plv = 1 ,attribute = 1700 ,contrib = 700 };
get(2,35) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1750点") ,lv = 35 ,glv = 1 ,plv = 1 ,attribute = 1750 ,contrib = 700 };
get(2,36) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1800点") ,lv = 36 ,glv = 1 ,plv = 1 ,attribute = 1800 ,contrib = 800 };
get(2,37) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1850点") ,lv = 37 ,glv = 1 ,plv = 1 ,attribute = 1850 ,contrib = 800 };
get(2,38) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1900点") ,lv = 38 ,glv = 1 ,plv = 1 ,attribute = 1900 ,contrib = 800 };
get(2,39) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击1950点") ,lv = 39 ,glv = 1 ,plv = 1 ,attribute = 1950 ,contrib = 800 };
get(2,40) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2000点") ,lv = 40 ,glv = 1 ,plv = 1 ,attribute = 2000 ,contrib = 800 };
get(2,41) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2050点") ,lv = 41 ,glv = 1 ,plv = 1 ,attribute = 2050 ,contrib = 900 };
get(2,42) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2100点") ,lv = 42 ,glv = 1 ,plv = 1 ,attribute = 2100 ,contrib = 900 };
get(2,43) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2150点") ,lv = 43 ,glv = 1 ,plv = 1 ,attribute = 2150 ,contrib = 900 };
get(2,44) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2200点") ,lv = 44 ,glv = 1 ,plv = 1 ,attribute = 2200 ,contrib = 900 };
get(2,45) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2250点") ,lv = 45 ,glv = 1 ,plv = 1 ,attribute = 2250 ,contrib = 900 };
get(2,46) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2300点") ,lv = 46 ,glv = 1 ,plv = 1 ,attribute = 2300 ,contrib = 1000 };
get(2,47) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2350点") ,lv = 47 ,glv = 1 ,plv = 1 ,attribute = 2350 ,contrib = 1000 };
get(2,48) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2400点") ,lv = 48 ,glv = 1 ,plv = 1 ,attribute = 2400 ,contrib = 1000 };
get(2,49) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2450点") ,lv = 49 ,glv = 1 ,plv = 1 ,attribute = 2450 ,contrib = 1000 };
get(2,50) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2500点") ,lv = 50 ,glv = 1 ,plv = 1 ,attribute = 2500 ,contrib = 1000 };
get(2,51) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2550点") ,lv = 51 ,glv = 1 ,plv = 1 ,attribute = 2550 ,contrib = 1100 };
get(2,52) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2600点") ,lv = 52 ,glv = 1 ,plv = 1 ,attribute = 2600 ,contrib = 1100 };
get(2,53) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2650点") ,lv = 53 ,glv = 1 ,plv = 1 ,attribute = 2650 ,contrib = 1100 };
get(2,54) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2700点") ,lv = 54 ,glv = 1 ,plv = 1 ,attribute = 2700 ,contrib = 1100 };
get(2,55) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2750点") ,lv = 55 ,glv = 1 ,plv = 1 ,attribute = 2750 ,contrib = 1100 };
get(2,56) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2800点") ,lv = 56 ,glv = 1 ,plv = 1 ,attribute = 2800 ,contrib = 1200 };
get(2,57) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2850点") ,lv = 57 ,glv = 1 ,plv = 1 ,attribute = 2850 ,contrib = 1200 };
get(2,58) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2900点") ,lv = 58 ,glv = 1 ,plv = 1 ,attribute = 2900 ,contrib = 1200 };
get(2,59) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击2950点") ,lv = 59 ,glv = 1 ,plv = 1 ,attribute = 2950 ,contrib = 1200 };
get(2,60) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3000点") ,lv = 60 ,glv = 1 ,plv = 1 ,attribute = 3000 ,contrib = 1200 };
get(2,61) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3050点") ,lv = 61 ,glv = 1 ,plv = 1 ,attribute = 3050 ,contrib = 1300 };
get(2,62) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3100点") ,lv = 62 ,glv = 1 ,plv = 1 ,attribute = 3100 ,contrib = 1300 };
get(2,63) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3150点") ,lv = 63 ,glv = 1 ,plv = 1 ,attribute = 3150 ,contrib = 1300 };
get(2,64) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3200点") ,lv = 64 ,glv = 1 ,plv = 1 ,attribute = 3200 ,contrib = 1300 };
get(2,65) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3250点") ,lv = 65 ,glv = 1 ,plv = 1 ,attribute = 3250 ,contrib = 1300 };
get(2,66) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3300点") ,lv = 66 ,glv = 1 ,plv = 1 ,attribute = 3300 ,contrib = 1400 };
get(2,67) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3350点") ,lv = 67 ,glv = 1 ,plv = 1 ,attribute = 3350 ,contrib = 1400 };
get(2,68) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3400点") ,lv = 68 ,glv = 1 ,plv = 1 ,attribute = 3400 ,contrib = 1400 };
get(2,69) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3450点") ,lv = 69 ,glv = 1 ,plv = 1 ,attribute = 3450 ,contrib = 1400 };
get(2,70) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3500点") ,lv = 70 ,glv = 1 ,plv = 1 ,attribute = 3500 ,contrib = 1400 };
get(2,71) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3550点") ,lv = 71 ,glv = 1 ,plv = 1 ,attribute = 3550 ,contrib = 1500 };
get(2,72) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3600点") ,lv = 72 ,glv = 1 ,plv = 1 ,attribute = 3600 ,contrib = 1500 };
get(2,73) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3650点") ,lv = 73 ,glv = 1 ,plv = 1 ,attribute = 3650 ,contrib = 1500 };
get(2,74) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3700点") ,lv = 74 ,glv = 1 ,plv = 1 ,attribute = 3700 ,contrib = 1500 };
get(2,75) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3750点") ,lv = 75 ,glv = 1 ,plv = 1 ,attribute = 3750 ,contrib = 1500 };
get(2,76) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3800点") ,lv = 76 ,glv = 1 ,plv = 1 ,attribute = 3800 ,contrib = 1600 };
get(2,77) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3850点") ,lv = 77 ,glv = 1 ,plv = 1 ,attribute = 3850 ,contrib = 1600 };
get(2,78) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3900点") ,lv = 78 ,glv = 1 ,plv = 1 ,attribute = 3900 ,contrib = 1600 };
get(2,79) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击3950点") ,lv = 79 ,glv = 1 ,plv = 1 ,attribute = 3950 ,contrib = 1600 };
get(2,80) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4000点") ,lv = 80 ,glv = 1 ,plv = 1 ,attribute = 4000 ,contrib = 1600 };
get(2,81) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4050点") ,lv = 81 ,glv = 1 ,plv = 1 ,attribute = 4050 ,contrib = 1700 };
get(2,82) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4100点") ,lv = 82 ,glv = 1 ,plv = 1 ,attribute = 4100 ,contrib = 1700 };
get(2,83) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4150点") ,lv = 83 ,glv = 1 ,plv = 1 ,attribute = 4150 ,contrib = 1700 };
get(2,84) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4200点") ,lv = 84 ,glv = 1 ,plv = 1 ,attribute = 4200 ,contrib = 1700 };
get(2,85) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4250点") ,lv = 85 ,glv = 1 ,plv = 1 ,attribute = 4250 ,contrib = 1700 };
get(2,86) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4300点") ,lv = 86 ,glv = 1 ,plv = 1 ,attribute = 4300 ,contrib = 1800 };
get(2,87) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4350点") ,lv = 87 ,glv = 1 ,plv = 1 ,attribute = 4350 ,contrib = 1800 };
get(2,88) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4400点") ,lv = 88 ,glv = 1 ,plv = 1 ,attribute = 4400 ,contrib = 1800 };
get(2,89) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4450点") ,lv = 89 ,glv = 1 ,plv = 1 ,attribute = 4450 ,contrib = 1800 };
get(2,90) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4500点") ,lv = 90 ,glv = 1 ,plv = 1 ,attribute = 4500 ,contrib = 1800 };
get(2,91) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4550点") ,lv = 91 ,glv = 1 ,plv = 1 ,attribute = 4550 ,contrib = 1900 };
get(2,92) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4600点") ,lv = 92 ,glv = 1 ,plv = 1 ,attribute = 4600 ,contrib = 1900 };
get(2,93) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4650点") ,lv = 93 ,glv = 1 ,plv = 1 ,attribute = 4650 ,contrib = 1900 };
get(2,94) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4700点") ,lv = 94 ,glv = 1 ,plv = 1 ,attribute = 4700 ,contrib = 1900 };
get(2,95) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4750点") ,lv = 95 ,glv = 1 ,plv = 1 ,attribute = 4750 ,contrib = 1900 };
get(2,96) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4800点") ,lv = 96 ,glv = 1 ,plv = 1 ,attribute = 4800 ,contrib = 2000 };
get(2,97) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4850点") ,lv = 97 ,glv = 1 ,plv = 1 ,attribute = 4850 ,contrib = 2000 };
get(2,98) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4900点") ,lv = 98 ,glv = 1 ,plv = 1 ,attribute = 4900 ,contrib = 2000 };
get(2,99) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击4950点") ,lv = 99 ,glv = 1 ,plv = 1 ,attribute = 4950 ,contrib = 2000 };
get(2,100) ->
	#base_guild_skill{id = 2 ,name = ?T("攻击") ,desc = ?T("永久提升主角攻击5000点") ,lv = 100 ,glv = 1 ,plv = 1 ,attribute = 5000 ,contrib = 2000 };
get(3,1) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御25点") ,lv = 1 ,glv = 1 ,plv = 1 ,attribute = 25 ,contrib = 100 };
get(3,2) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御50点") ,lv = 2 ,glv = 1 ,plv = 1 ,attribute = 50 ,contrib = 100 };
get(3,3) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御75点") ,lv = 3 ,glv = 1 ,plv = 1 ,attribute = 75 ,contrib = 100 };
get(3,4) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御100点") ,lv = 4 ,glv = 1 ,plv = 1 ,attribute = 100 ,contrib = 100 };
get(3,5) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御125点") ,lv = 5 ,glv = 1 ,plv = 1 ,attribute = 125 ,contrib = 100 };
get(3,6) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御150点") ,lv = 6 ,glv = 1 ,plv = 1 ,attribute = 150 ,contrib = 200 };
get(3,7) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御175点") ,lv = 7 ,glv = 1 ,plv = 1 ,attribute = 175 ,contrib = 200 };
get(3,8) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御200点") ,lv = 8 ,glv = 1 ,plv = 1 ,attribute = 200 ,contrib = 200 };
get(3,9) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御225点") ,lv = 9 ,glv = 1 ,plv = 1 ,attribute = 225 ,contrib = 200 };
get(3,10) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御250点") ,lv = 10 ,glv = 1 ,plv = 1 ,attribute = 250 ,contrib = 200 };
get(3,11) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御275点") ,lv = 11 ,glv = 1 ,plv = 1 ,attribute = 275 ,contrib = 300 };
get(3,12) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御300点") ,lv = 12 ,glv = 1 ,plv = 1 ,attribute = 300 ,contrib = 300 };
get(3,13) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御325点") ,lv = 13 ,glv = 1 ,plv = 1 ,attribute = 325 ,contrib = 300 };
get(3,14) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御350点") ,lv = 14 ,glv = 1 ,plv = 1 ,attribute = 350 ,contrib = 300 };
get(3,15) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御375点") ,lv = 15 ,glv = 1 ,plv = 1 ,attribute = 375 ,contrib = 300 };
get(3,16) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御400点") ,lv = 16 ,glv = 1 ,plv = 1 ,attribute = 400 ,contrib = 400 };
get(3,17) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御425点") ,lv = 17 ,glv = 1 ,plv = 1 ,attribute = 425 ,contrib = 400 };
get(3,18) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御450点") ,lv = 18 ,glv = 1 ,plv = 1 ,attribute = 450 ,contrib = 400 };
get(3,19) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御475点") ,lv = 19 ,glv = 1 ,plv = 1 ,attribute = 475 ,contrib = 400 };
get(3,20) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御500点") ,lv = 20 ,glv = 1 ,plv = 1 ,attribute = 500 ,contrib = 400 };
get(3,21) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御525点") ,lv = 21 ,glv = 1 ,plv = 1 ,attribute = 525 ,contrib = 500 };
get(3,22) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御550点") ,lv = 22 ,glv = 1 ,plv = 1 ,attribute = 550 ,contrib = 500 };
get(3,23) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御575点") ,lv = 23 ,glv = 1 ,plv = 1 ,attribute = 575 ,contrib = 500 };
get(3,24) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御600点") ,lv = 24 ,glv = 1 ,plv = 1 ,attribute = 600 ,contrib = 500 };
get(3,25) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御625点") ,lv = 25 ,glv = 1 ,plv = 1 ,attribute = 625 ,contrib = 500 };
get(3,26) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御650点") ,lv = 26 ,glv = 1 ,plv = 1 ,attribute = 650 ,contrib = 600 };
get(3,27) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御675点") ,lv = 27 ,glv = 1 ,plv = 1 ,attribute = 675 ,contrib = 600 };
get(3,28) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御700点") ,lv = 28 ,glv = 1 ,plv = 1 ,attribute = 700 ,contrib = 600 };
get(3,29) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御725点") ,lv = 29 ,glv = 1 ,plv = 1 ,attribute = 725 ,contrib = 600 };
get(3,30) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御750点") ,lv = 30 ,glv = 1 ,plv = 1 ,attribute = 750 ,contrib = 600 };
get(3,31) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御775点") ,lv = 31 ,glv = 1 ,plv = 1 ,attribute = 775 ,contrib = 700 };
get(3,32) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御800点") ,lv = 32 ,glv = 1 ,plv = 1 ,attribute = 800 ,contrib = 700 };
get(3,33) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御825点") ,lv = 33 ,glv = 1 ,plv = 1 ,attribute = 825 ,contrib = 700 };
get(3,34) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御850点") ,lv = 34 ,glv = 1 ,plv = 1 ,attribute = 850 ,contrib = 700 };
get(3,35) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御875点") ,lv = 35 ,glv = 1 ,plv = 1 ,attribute = 875 ,contrib = 700 };
get(3,36) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御900点") ,lv = 36 ,glv = 1 ,plv = 1 ,attribute = 900 ,contrib = 800 };
get(3,37) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御925点") ,lv = 37 ,glv = 1 ,plv = 1 ,attribute = 925 ,contrib = 800 };
get(3,38) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御950点") ,lv = 38 ,glv = 1 ,plv = 1 ,attribute = 950 ,contrib = 800 };
get(3,39) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御975点") ,lv = 39 ,glv = 1 ,plv = 1 ,attribute = 975 ,contrib = 800 };
get(3,40) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1000点") ,lv = 40 ,glv = 1 ,plv = 1 ,attribute = 1000 ,contrib = 800 };
get(3,41) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1025点") ,lv = 41 ,glv = 1 ,plv = 1 ,attribute = 1025 ,contrib = 900 };
get(3,42) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1050点") ,lv = 42 ,glv = 1 ,plv = 1 ,attribute = 1050 ,contrib = 900 };
get(3,43) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1075点") ,lv = 43 ,glv = 1 ,plv = 1 ,attribute = 1075 ,contrib = 900 };
get(3,44) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1100点") ,lv = 44 ,glv = 1 ,plv = 1 ,attribute = 1100 ,contrib = 900 };
get(3,45) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1125点") ,lv = 45 ,glv = 1 ,plv = 1 ,attribute = 1125 ,contrib = 900 };
get(3,46) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1150点") ,lv = 46 ,glv = 1 ,plv = 1 ,attribute = 1150 ,contrib = 1000 };
get(3,47) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1175点") ,lv = 47 ,glv = 1 ,plv = 1 ,attribute = 1175 ,contrib = 1000 };
get(3,48) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1200点") ,lv = 48 ,glv = 1 ,plv = 1 ,attribute = 1200 ,contrib = 1000 };
get(3,49) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1225点") ,lv = 49 ,glv = 1 ,plv = 1 ,attribute = 1225 ,contrib = 1000 };
get(3,50) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1250点") ,lv = 50 ,glv = 1 ,plv = 1 ,attribute = 1250 ,contrib = 1000 };
get(3,51) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1275点") ,lv = 51 ,glv = 1 ,plv = 1 ,attribute = 1275 ,contrib = 1100 };
get(3,52) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1300点") ,lv = 52 ,glv = 1 ,plv = 1 ,attribute = 1300 ,contrib = 1100 };
get(3,53) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1325点") ,lv = 53 ,glv = 1 ,plv = 1 ,attribute = 1325 ,contrib = 1100 };
get(3,54) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1350点") ,lv = 54 ,glv = 1 ,plv = 1 ,attribute = 1350 ,contrib = 1100 };
get(3,55) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1375点") ,lv = 55 ,glv = 1 ,plv = 1 ,attribute = 1375 ,contrib = 1100 };
get(3,56) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1400点") ,lv = 56 ,glv = 1 ,plv = 1 ,attribute = 1400 ,contrib = 1200 };
get(3,57) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1425点") ,lv = 57 ,glv = 1 ,plv = 1 ,attribute = 1425 ,contrib = 1200 };
get(3,58) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1450点") ,lv = 58 ,glv = 1 ,plv = 1 ,attribute = 1450 ,contrib = 1200 };
get(3,59) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1475点") ,lv = 59 ,glv = 1 ,plv = 1 ,attribute = 1475 ,contrib = 1200 };
get(3,60) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1500点") ,lv = 60 ,glv = 1 ,plv = 1 ,attribute = 1500 ,contrib = 1200 };
get(3,61) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1525点") ,lv = 61 ,glv = 1 ,plv = 1 ,attribute = 1525 ,contrib = 1300 };
get(3,62) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1550点") ,lv = 62 ,glv = 1 ,plv = 1 ,attribute = 1550 ,contrib = 1300 };
get(3,63) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1575点") ,lv = 63 ,glv = 1 ,plv = 1 ,attribute = 1575 ,contrib = 1300 };
get(3,64) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1600点") ,lv = 64 ,glv = 1 ,plv = 1 ,attribute = 1600 ,contrib = 1300 };
get(3,65) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1625点") ,lv = 65 ,glv = 1 ,plv = 1 ,attribute = 1625 ,contrib = 1300 };
get(3,66) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1650点") ,lv = 66 ,glv = 1 ,plv = 1 ,attribute = 1650 ,contrib = 1400 };
get(3,67) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1675点") ,lv = 67 ,glv = 1 ,plv = 1 ,attribute = 1675 ,contrib = 1400 };
get(3,68) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1700点") ,lv = 68 ,glv = 1 ,plv = 1 ,attribute = 1700 ,contrib = 1400 };
get(3,69) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1725点") ,lv = 69 ,glv = 1 ,plv = 1 ,attribute = 1725 ,contrib = 1400 };
get(3,70) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1750点") ,lv = 70 ,glv = 1 ,plv = 1 ,attribute = 1750 ,contrib = 1400 };
get(3,71) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1775点") ,lv = 71 ,glv = 1 ,plv = 1 ,attribute = 1775 ,contrib = 1500 };
get(3,72) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1800点") ,lv = 72 ,glv = 1 ,plv = 1 ,attribute = 1800 ,contrib = 1500 };
get(3,73) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1825点") ,lv = 73 ,glv = 1 ,plv = 1 ,attribute = 1825 ,contrib = 1500 };
get(3,74) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1850点") ,lv = 74 ,glv = 1 ,plv = 1 ,attribute = 1850 ,contrib = 1500 };
get(3,75) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1875点") ,lv = 75 ,glv = 1 ,plv = 1 ,attribute = 1875 ,contrib = 1500 };
get(3,76) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1900点") ,lv = 76 ,glv = 1 ,plv = 1 ,attribute = 1900 ,contrib = 1600 };
get(3,77) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1925点") ,lv = 77 ,glv = 1 ,plv = 1 ,attribute = 1925 ,contrib = 1600 };
get(3,78) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1950点") ,lv = 78 ,glv = 1 ,plv = 1 ,attribute = 1950 ,contrib = 1600 };
get(3,79) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御1975点") ,lv = 79 ,glv = 1 ,plv = 1 ,attribute = 1975 ,contrib = 1600 };
get(3,80) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2000点") ,lv = 80 ,glv = 1 ,plv = 1 ,attribute = 2000 ,contrib = 1600 };
get(3,81) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2025点") ,lv = 81 ,glv = 1 ,plv = 1 ,attribute = 2025 ,contrib = 1700 };
get(3,82) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2050点") ,lv = 82 ,glv = 1 ,plv = 1 ,attribute = 2050 ,contrib = 1700 };
get(3,83) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2075点") ,lv = 83 ,glv = 1 ,plv = 1 ,attribute = 2075 ,contrib = 1700 };
get(3,84) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2100点") ,lv = 84 ,glv = 1 ,plv = 1 ,attribute = 2100 ,contrib = 1700 };
get(3,85) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2125点") ,lv = 85 ,glv = 1 ,plv = 1 ,attribute = 2125 ,contrib = 1700 };
get(3,86) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2150点") ,lv = 86 ,glv = 1 ,plv = 1 ,attribute = 2150 ,contrib = 1800 };
get(3,87) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2175点") ,lv = 87 ,glv = 1 ,plv = 1 ,attribute = 2175 ,contrib = 1800 };
get(3,88) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2200点") ,lv = 88 ,glv = 1 ,plv = 1 ,attribute = 2200 ,contrib = 1800 };
get(3,89) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2225点") ,lv = 89 ,glv = 1 ,plv = 1 ,attribute = 2225 ,contrib = 1800 };
get(3,90) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2250点") ,lv = 90 ,glv = 1 ,plv = 1 ,attribute = 2250 ,contrib = 1800 };
get(3,91) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2275点") ,lv = 91 ,glv = 1 ,plv = 1 ,attribute = 2275 ,contrib = 1900 };
get(3,92) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2300点") ,lv = 92 ,glv = 1 ,plv = 1 ,attribute = 2300 ,contrib = 1900 };
get(3,93) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2325点") ,lv = 93 ,glv = 1 ,plv = 1 ,attribute = 2325 ,contrib = 1900 };
get(3,94) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2350点") ,lv = 94 ,glv = 1 ,plv = 1 ,attribute = 2350 ,contrib = 1900 };
get(3,95) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2375点") ,lv = 95 ,glv = 1 ,plv = 1 ,attribute = 2375 ,contrib = 1900 };
get(3,96) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2400点") ,lv = 96 ,glv = 1 ,plv = 1 ,attribute = 2400 ,contrib = 2000 };
get(3,97) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2425点") ,lv = 97 ,glv = 1 ,plv = 1 ,attribute = 2425 ,contrib = 2000 };
get(3,98) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2450点") ,lv = 98 ,glv = 1 ,plv = 1 ,attribute = 2450 ,contrib = 2000 };
get(3,99) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2475点") ,lv = 99 ,glv = 1 ,plv = 1 ,attribute = 2475 ,contrib = 2000 };
get(3,100) ->
	#base_guild_skill{id = 3 ,name = ?T("防御") ,desc = ?T("永久提升主角防御2500点") ,lv = 100 ,glv = 1 ,plv = 1 ,attribute = 2500 ,contrib = 2000 };
get(1,1) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血500点") ,lv = 1 ,glv = 1 ,plv = 1 ,attribute = 500 ,contrib = 100 };
get(1,2) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血1000点") ,lv = 2 ,glv = 1 ,plv = 1 ,attribute = 1000 ,contrib = 100 };
get(1,3) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血1500点") ,lv = 3 ,glv = 1 ,plv = 1 ,attribute = 1500 ,contrib = 100 };
get(1,4) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血2000点") ,lv = 4 ,glv = 1 ,plv = 1 ,attribute = 2000 ,contrib = 100 };
get(1,5) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血2500点") ,lv = 5 ,glv = 1 ,plv = 1 ,attribute = 2500 ,contrib = 100 };
get(1,6) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血3000点") ,lv = 6 ,glv = 1 ,plv = 1 ,attribute = 3000 ,contrib = 200 };
get(1,7) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血3500点") ,lv = 7 ,glv = 1 ,plv = 1 ,attribute = 3500 ,contrib = 200 };
get(1,8) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血4000点") ,lv = 8 ,glv = 1 ,plv = 1 ,attribute = 4000 ,contrib = 200 };
get(1,9) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血4500点") ,lv = 9 ,glv = 1 ,plv = 1 ,attribute = 4500 ,contrib = 200 };
get(1,10) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血5000点") ,lv = 10 ,glv = 1 ,plv = 1 ,attribute = 5000 ,contrib = 200 };
get(1,11) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血5500点") ,lv = 11 ,glv = 1 ,plv = 1 ,attribute = 5500 ,contrib = 300 };
get(1,12) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血6000点") ,lv = 12 ,glv = 1 ,plv = 1 ,attribute = 6000 ,contrib = 300 };
get(1,13) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血6500点") ,lv = 13 ,glv = 1 ,plv = 1 ,attribute = 6500 ,contrib = 300 };
get(1,14) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血7000点") ,lv = 14 ,glv = 1 ,plv = 1 ,attribute = 7000 ,contrib = 300 };
get(1,15) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血7500点") ,lv = 15 ,glv = 1 ,plv = 1 ,attribute = 7500 ,contrib = 300 };
get(1,16) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血8000点") ,lv = 16 ,glv = 1 ,plv = 1 ,attribute = 8000 ,contrib = 400 };
get(1,17) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血8500点") ,lv = 17 ,glv = 1 ,plv = 1 ,attribute = 8500 ,contrib = 400 };
get(1,18) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血9000点") ,lv = 18 ,glv = 1 ,plv = 1 ,attribute = 9000 ,contrib = 400 };
get(1,19) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血9500点") ,lv = 19 ,glv = 1 ,plv = 1 ,attribute = 9500 ,contrib = 400 };
get(1,20) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血10000点") ,lv = 20 ,glv = 1 ,plv = 1 ,attribute = 10000 ,contrib = 400 };
get(1,21) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血10500点") ,lv = 21 ,glv = 1 ,plv = 1 ,attribute = 10500 ,contrib = 500 };
get(1,22) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血11000点") ,lv = 22 ,glv = 1 ,plv = 1 ,attribute = 11000 ,contrib = 500 };
get(1,23) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血11500点") ,lv = 23 ,glv = 1 ,plv = 1 ,attribute = 11500 ,contrib = 500 };
get(1,24) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血12000点") ,lv = 24 ,glv = 1 ,plv = 1 ,attribute = 12000 ,contrib = 500 };
get(1,25) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血12500点") ,lv = 25 ,glv = 1 ,plv = 1 ,attribute = 12500 ,contrib = 500 };
get(1,26) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血13000点") ,lv = 26 ,glv = 1 ,plv = 1 ,attribute = 13000 ,contrib = 600 };
get(1,27) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血13500点") ,lv = 27 ,glv = 1 ,plv = 1 ,attribute = 13500 ,contrib = 600 };
get(1,28) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血14000点") ,lv = 28 ,glv = 1 ,plv = 1 ,attribute = 14000 ,contrib = 600 };
get(1,29) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血14500点") ,lv = 29 ,glv = 1 ,plv = 1 ,attribute = 14500 ,contrib = 600 };
get(1,30) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血15000点") ,lv = 30 ,glv = 1 ,plv = 1 ,attribute = 15000 ,contrib = 600 };
get(1,31) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血15500点") ,lv = 31 ,glv = 1 ,plv = 1 ,attribute = 15500 ,contrib = 700 };
get(1,32) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血16000点") ,lv = 32 ,glv = 1 ,plv = 1 ,attribute = 16000 ,contrib = 700 };
get(1,33) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血16500点") ,lv = 33 ,glv = 1 ,plv = 1 ,attribute = 16500 ,contrib = 700 };
get(1,34) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血17000点") ,lv = 34 ,glv = 1 ,plv = 1 ,attribute = 17000 ,contrib = 700 };
get(1,35) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血17500点") ,lv = 35 ,glv = 1 ,plv = 1 ,attribute = 17500 ,contrib = 700 };
get(1,36) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血18000点") ,lv = 36 ,glv = 1 ,plv = 1 ,attribute = 18000 ,contrib = 800 };
get(1,37) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血18500点") ,lv = 37 ,glv = 1 ,plv = 1 ,attribute = 18500 ,contrib = 800 };
get(1,38) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血19000点") ,lv = 38 ,glv = 1 ,plv = 1 ,attribute = 19000 ,contrib = 800 };
get(1,39) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血19500点") ,lv = 39 ,glv = 1 ,plv = 1 ,attribute = 19500 ,contrib = 800 };
get(1,40) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血20000点") ,lv = 40 ,glv = 1 ,plv = 1 ,attribute = 20000 ,contrib = 800 };
get(1,41) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血20500点") ,lv = 41 ,glv = 1 ,plv = 1 ,attribute = 20500 ,contrib = 900 };
get(1,42) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血21000点") ,lv = 42 ,glv = 1 ,plv = 1 ,attribute = 21000 ,contrib = 900 };
get(1,43) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血21500点") ,lv = 43 ,glv = 1 ,plv = 1 ,attribute = 21500 ,contrib = 900 };
get(1,44) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血22000点") ,lv = 44 ,glv = 1 ,plv = 1 ,attribute = 22000 ,contrib = 900 };
get(1,45) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血22500点") ,lv = 45 ,glv = 1 ,plv = 1 ,attribute = 22500 ,contrib = 900 };
get(1,46) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血23000点") ,lv = 46 ,glv = 1 ,plv = 1 ,attribute = 23000 ,contrib = 1000 };
get(1,47) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血23500点") ,lv = 47 ,glv = 1 ,plv = 1 ,attribute = 23500 ,contrib = 1000 };
get(1,48) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血24000点") ,lv = 48 ,glv = 1 ,plv = 1 ,attribute = 24000 ,contrib = 1000 };
get(1,49) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血24500点") ,lv = 49 ,glv = 1 ,plv = 1 ,attribute = 24500 ,contrib = 1000 };
get(1,50) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血25000点") ,lv = 50 ,glv = 1 ,plv = 1 ,attribute = 25000 ,contrib = 1000 };
get(1,51) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血25500点") ,lv = 51 ,glv = 1 ,plv = 1 ,attribute = 25500 ,contrib = 1100 };
get(1,52) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血26000点") ,lv = 52 ,glv = 1 ,plv = 1 ,attribute = 26000 ,contrib = 1100 };
get(1,53) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血26500点") ,lv = 53 ,glv = 1 ,plv = 1 ,attribute = 26500 ,contrib = 1100 };
get(1,54) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血27000点") ,lv = 54 ,glv = 1 ,plv = 1 ,attribute = 27000 ,contrib = 1100 };
get(1,55) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血27500点") ,lv = 55 ,glv = 1 ,plv = 1 ,attribute = 27500 ,contrib = 1100 };
get(1,56) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血28000点") ,lv = 56 ,glv = 1 ,plv = 1 ,attribute = 28000 ,contrib = 1200 };
get(1,57) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血28500点") ,lv = 57 ,glv = 1 ,plv = 1 ,attribute = 28500 ,contrib = 1200 };
get(1,58) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血29000点") ,lv = 58 ,glv = 1 ,plv = 1 ,attribute = 29000 ,contrib = 1200 };
get(1,59) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血29500点") ,lv = 59 ,glv = 1 ,plv = 1 ,attribute = 29500 ,contrib = 1200 };
get(1,60) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血30000点") ,lv = 60 ,glv = 1 ,plv = 1 ,attribute = 30000 ,contrib = 1200 };
get(1,61) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血30500点") ,lv = 61 ,glv = 1 ,plv = 1 ,attribute = 30500 ,contrib = 1300 };
get(1,62) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血31000点") ,lv = 62 ,glv = 1 ,plv = 1 ,attribute = 31000 ,contrib = 1300 };
get(1,63) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血31500点") ,lv = 63 ,glv = 1 ,plv = 1 ,attribute = 31500 ,contrib = 1300 };
get(1,64) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血32000点") ,lv = 64 ,glv = 1 ,plv = 1 ,attribute = 32000 ,contrib = 1300 };
get(1,65) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血32500点") ,lv = 65 ,glv = 1 ,plv = 1 ,attribute = 32500 ,contrib = 1300 };
get(1,66) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血33000点") ,lv = 66 ,glv = 1 ,plv = 1 ,attribute = 33000 ,contrib = 1400 };
get(1,67) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血33500点") ,lv = 67 ,glv = 1 ,plv = 1 ,attribute = 33500 ,contrib = 1400 };
get(1,68) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血34000点") ,lv = 68 ,glv = 1 ,plv = 1 ,attribute = 34000 ,contrib = 1400 };
get(1,69) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血34500点") ,lv = 69 ,glv = 1 ,plv = 1 ,attribute = 34500 ,contrib = 1400 };
get(1,70) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血35000点") ,lv = 70 ,glv = 1 ,plv = 1 ,attribute = 35000 ,contrib = 1400 };
get(1,71) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血35500点") ,lv = 71 ,glv = 1 ,plv = 1 ,attribute = 35500 ,contrib = 1500 };
get(1,72) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血36000点") ,lv = 72 ,glv = 1 ,plv = 1 ,attribute = 36000 ,contrib = 1500 };
get(1,73) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血36500点") ,lv = 73 ,glv = 1 ,plv = 1 ,attribute = 36500 ,contrib = 1500 };
get(1,74) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血37000点") ,lv = 74 ,glv = 1 ,plv = 1 ,attribute = 37000 ,contrib = 1500 };
get(1,75) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血37500点") ,lv = 75 ,glv = 1 ,plv = 1 ,attribute = 37500 ,contrib = 1500 };
get(1,76) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血38000点") ,lv = 76 ,glv = 1 ,plv = 1 ,attribute = 38000 ,contrib = 1600 };
get(1,77) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血38500点") ,lv = 77 ,glv = 1 ,plv = 1 ,attribute = 38500 ,contrib = 1600 };
get(1,78) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血39000点") ,lv = 78 ,glv = 1 ,plv = 1 ,attribute = 39000 ,contrib = 1600 };
get(1,79) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血39500点") ,lv = 79 ,glv = 1 ,plv = 1 ,attribute = 39500 ,contrib = 1600 };
get(1,80) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血40000点") ,lv = 80 ,glv = 1 ,plv = 1 ,attribute = 40000 ,contrib = 1600 };
get(1,81) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血40500点") ,lv = 81 ,glv = 1 ,plv = 1 ,attribute = 40500 ,contrib = 1700 };
get(1,82) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血41000点") ,lv = 82 ,glv = 1 ,plv = 1 ,attribute = 41000 ,contrib = 1700 };
get(1,83) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血41500点") ,lv = 83 ,glv = 1 ,plv = 1 ,attribute = 41500 ,contrib = 1700 };
get(1,84) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血42000点") ,lv = 84 ,glv = 1 ,plv = 1 ,attribute = 42000 ,contrib = 1700 };
get(1,85) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血42500点") ,lv = 85 ,glv = 1 ,plv = 1 ,attribute = 42500 ,contrib = 1700 };
get(1,86) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血43000点") ,lv = 86 ,glv = 1 ,plv = 1 ,attribute = 43000 ,contrib = 1800 };
get(1,87) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血43500点") ,lv = 87 ,glv = 1 ,plv = 1 ,attribute = 43500 ,contrib = 1800 };
get(1,88) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血44000点") ,lv = 88 ,glv = 1 ,plv = 1 ,attribute = 44000 ,contrib = 1800 };
get(1,89) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血44500点") ,lv = 89 ,glv = 1 ,plv = 1 ,attribute = 44500 ,contrib = 1800 };
get(1,90) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血45000点") ,lv = 90 ,glv = 1 ,plv = 1 ,attribute = 45000 ,contrib = 1800 };
get(1,91) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血45500点") ,lv = 91 ,glv = 1 ,plv = 1 ,attribute = 45500 ,contrib = 1900 };
get(1,92) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血46000点") ,lv = 92 ,glv = 1 ,plv = 1 ,attribute = 46000 ,contrib = 1900 };
get(1,93) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血46500点") ,lv = 93 ,glv = 1 ,plv = 1 ,attribute = 46500 ,contrib = 1900 };
get(1,94) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血47000点") ,lv = 94 ,glv = 1 ,plv = 1 ,attribute = 47000 ,contrib = 1900 };
get(1,95) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血47500点") ,lv = 95 ,glv = 1 ,plv = 1 ,attribute = 47500 ,contrib = 1900 };
get(1,96) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血48000点") ,lv = 96 ,glv = 1 ,plv = 1 ,attribute = 48000 ,contrib = 2000 };
get(1,97) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血48500点") ,lv = 97 ,glv = 1 ,plv = 1 ,attribute = 48500 ,contrib = 2000 };
get(1,98) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血49000点") ,lv = 98 ,glv = 1 ,plv = 1 ,attribute = 49000 ,contrib = 2000 };
get(1,99) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血49500点") ,lv = 99 ,glv = 1 ,plv = 1 ,attribute = 49500 ,contrib = 2000 };
get(1,100) ->
	#base_guild_skill{id = 1 ,name = ?T("气血") ,desc = ?T("永久提升主角气血50000点") ,lv = 100 ,glv = 1 ,plv = 1 ,attribute = 50000 ,contrib = 2000 };
get(9,1) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击10点") ,lv = 1 ,glv = 1 ,plv = 1 ,attribute = 10 ,contrib = 100 };
get(9,2) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击20点") ,lv = 2 ,glv = 1 ,plv = 1 ,attribute = 20 ,contrib = 100 };
get(9,3) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击30点") ,lv = 3 ,glv = 1 ,plv = 1 ,attribute = 30 ,contrib = 100 };
get(9,4) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击40点") ,lv = 4 ,glv = 1 ,plv = 1 ,attribute = 40 ,contrib = 100 };
get(9,5) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击50点") ,lv = 5 ,glv = 1 ,plv = 1 ,attribute = 50 ,contrib = 100 };
get(9,6) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击60点") ,lv = 6 ,glv = 1 ,plv = 1 ,attribute = 60 ,contrib = 200 };
get(9,7) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击70点") ,lv = 7 ,glv = 1 ,plv = 1 ,attribute = 70 ,contrib = 200 };
get(9,8) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击80点") ,lv = 8 ,glv = 1 ,plv = 1 ,attribute = 80 ,contrib = 200 };
get(9,9) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击90点") ,lv = 9 ,glv = 1 ,plv = 1 ,attribute = 90 ,contrib = 200 };
get(9,10) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击100点") ,lv = 10 ,glv = 1 ,plv = 1 ,attribute = 100 ,contrib = 200 };
get(9,11) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击110点") ,lv = 11 ,glv = 1 ,plv = 1 ,attribute = 110 ,contrib = 300 };
get(9,12) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击120点") ,lv = 12 ,glv = 1 ,plv = 1 ,attribute = 120 ,contrib = 300 };
get(9,13) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击130点") ,lv = 13 ,glv = 1 ,plv = 1 ,attribute = 130 ,contrib = 300 };
get(9,14) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击140点") ,lv = 14 ,glv = 1 ,plv = 1 ,attribute = 140 ,contrib = 300 };
get(9,15) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击150点") ,lv = 15 ,glv = 1 ,plv = 1 ,attribute = 150 ,contrib = 300 };
get(9,16) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击160点") ,lv = 16 ,glv = 1 ,plv = 1 ,attribute = 160 ,contrib = 400 };
get(9,17) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击170点") ,lv = 17 ,glv = 1 ,plv = 1 ,attribute = 170 ,contrib = 400 };
get(9,18) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击180点") ,lv = 18 ,glv = 1 ,plv = 1 ,attribute = 180 ,contrib = 400 };
get(9,19) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击190点") ,lv = 19 ,glv = 1 ,plv = 1 ,attribute = 190 ,contrib = 400 };
get(9,20) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击200点") ,lv = 20 ,glv = 1 ,plv = 1 ,attribute = 200 ,contrib = 400 };
get(9,21) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击210点") ,lv = 21 ,glv = 1 ,plv = 1 ,attribute = 210 ,contrib = 500 };
get(9,22) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击220点") ,lv = 22 ,glv = 1 ,plv = 1 ,attribute = 220 ,contrib = 500 };
get(9,23) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击230点") ,lv = 23 ,glv = 1 ,plv = 1 ,attribute = 230 ,contrib = 500 };
get(9,24) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击240点") ,lv = 24 ,glv = 1 ,plv = 1 ,attribute = 240 ,contrib = 500 };
get(9,25) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击250点") ,lv = 25 ,glv = 1 ,plv = 1 ,attribute = 250 ,contrib = 500 };
get(9,26) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击260点") ,lv = 26 ,glv = 1 ,plv = 1 ,attribute = 260 ,contrib = 600 };
get(9,27) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击270点") ,lv = 27 ,glv = 1 ,plv = 1 ,attribute = 270 ,contrib = 600 };
get(9,28) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击280点") ,lv = 28 ,glv = 1 ,plv = 1 ,attribute = 280 ,contrib = 600 };
get(9,29) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击290点") ,lv = 29 ,glv = 1 ,plv = 1 ,attribute = 290 ,contrib = 600 };
get(9,30) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击300点") ,lv = 30 ,glv = 1 ,plv = 1 ,attribute = 300 ,contrib = 600 };
get(9,31) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击310点") ,lv = 31 ,glv = 1 ,plv = 1 ,attribute = 310 ,contrib = 700 };
get(9,32) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击320点") ,lv = 32 ,glv = 1 ,plv = 1 ,attribute = 320 ,contrib = 700 };
get(9,33) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击330点") ,lv = 33 ,glv = 1 ,plv = 1 ,attribute = 330 ,contrib = 700 };
get(9,34) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击340点") ,lv = 34 ,glv = 1 ,plv = 1 ,attribute = 340 ,contrib = 700 };
get(9,35) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击350点") ,lv = 35 ,glv = 1 ,plv = 1 ,attribute = 350 ,contrib = 700 };
get(9,36) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击360点") ,lv = 36 ,glv = 1 ,plv = 1 ,attribute = 360 ,contrib = 800 };
get(9,37) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击370点") ,lv = 37 ,glv = 1 ,plv = 1 ,attribute = 370 ,contrib = 800 };
get(9,38) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击380点") ,lv = 38 ,glv = 1 ,plv = 1 ,attribute = 380 ,contrib = 800 };
get(9,39) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击390点") ,lv = 39 ,glv = 1 ,plv = 1 ,attribute = 390 ,contrib = 800 };
get(9,40) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击400点") ,lv = 40 ,glv = 1 ,plv = 1 ,attribute = 400 ,contrib = 800 };
get(9,41) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击410点") ,lv = 41 ,glv = 1 ,plv = 1 ,attribute = 410 ,contrib = 900 };
get(9,42) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击420点") ,lv = 42 ,glv = 1 ,plv = 1 ,attribute = 420 ,contrib = 900 };
get(9,43) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击430点") ,lv = 43 ,glv = 1 ,plv = 1 ,attribute = 430 ,contrib = 900 };
get(9,44) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击440点") ,lv = 44 ,glv = 1 ,plv = 1 ,attribute = 440 ,contrib = 900 };
get(9,45) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击450点") ,lv = 45 ,glv = 1 ,plv = 1 ,attribute = 450 ,contrib = 900 };
get(9,46) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击460点") ,lv = 46 ,glv = 1 ,plv = 1 ,attribute = 460 ,contrib = 1000 };
get(9,47) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击470点") ,lv = 47 ,glv = 1 ,plv = 1 ,attribute = 470 ,contrib = 1000 };
get(9,48) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击480点") ,lv = 48 ,glv = 1 ,plv = 1 ,attribute = 480 ,contrib = 1000 };
get(9,49) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击490点") ,lv = 49 ,glv = 1 ,plv = 1 ,attribute = 490 ,contrib = 1000 };
get(9,50) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击500点") ,lv = 50 ,glv = 1 ,plv = 1 ,attribute = 500 ,contrib = 1000 };
get(9,51) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击510点") ,lv = 51 ,glv = 1 ,plv = 1 ,attribute = 510 ,contrib = 1100 };
get(9,52) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击520点") ,lv = 52 ,glv = 1 ,plv = 1 ,attribute = 520 ,contrib = 1100 };
get(9,53) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击530点") ,lv = 53 ,glv = 1 ,plv = 1 ,attribute = 530 ,contrib = 1100 };
get(9,54) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击540点") ,lv = 54 ,glv = 1 ,plv = 1 ,attribute = 540 ,contrib = 1100 };
get(9,55) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击550点") ,lv = 55 ,glv = 1 ,plv = 1 ,attribute = 550 ,contrib = 1100 };
get(9,56) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击560点") ,lv = 56 ,glv = 1 ,plv = 1 ,attribute = 560 ,contrib = 1200 };
get(9,57) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击570点") ,lv = 57 ,glv = 1 ,plv = 1 ,attribute = 570 ,contrib = 1200 };
get(9,58) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击580点") ,lv = 58 ,glv = 1 ,plv = 1 ,attribute = 580 ,contrib = 1200 };
get(9,59) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击590点") ,lv = 59 ,glv = 1 ,plv = 1 ,attribute = 590 ,contrib = 1200 };
get(9,60) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击600点") ,lv = 60 ,glv = 1 ,plv = 1 ,attribute = 600 ,contrib = 1200 };
get(9,61) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击610点") ,lv = 61 ,glv = 1 ,plv = 1 ,attribute = 610 ,contrib = 1300 };
get(9,62) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击620点") ,lv = 62 ,glv = 1 ,plv = 1 ,attribute = 620 ,contrib = 1300 };
get(9,63) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击630点") ,lv = 63 ,glv = 1 ,plv = 1 ,attribute = 630 ,contrib = 1300 };
get(9,64) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击640点") ,lv = 64 ,glv = 1 ,plv = 1 ,attribute = 640 ,contrib = 1300 };
get(9,65) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击650点") ,lv = 65 ,glv = 1 ,plv = 1 ,attribute = 650 ,contrib = 1300 };
get(9,66) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击660点") ,lv = 66 ,glv = 1 ,plv = 1 ,attribute = 660 ,contrib = 1400 };
get(9,67) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击670点") ,lv = 67 ,glv = 1 ,plv = 1 ,attribute = 670 ,contrib = 1400 };
get(9,68) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击680点") ,lv = 68 ,glv = 1 ,plv = 1 ,attribute = 680 ,contrib = 1400 };
get(9,69) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击690点") ,lv = 69 ,glv = 1 ,plv = 1 ,attribute = 690 ,contrib = 1400 };
get(9,70) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击700点") ,lv = 70 ,glv = 1 ,plv = 1 ,attribute = 700 ,contrib = 1400 };
get(9,71) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击710点") ,lv = 71 ,glv = 1 ,plv = 1 ,attribute = 710 ,contrib = 1500 };
get(9,72) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击720点") ,lv = 72 ,glv = 1 ,plv = 1 ,attribute = 720 ,contrib = 1500 };
get(9,73) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击730点") ,lv = 73 ,glv = 1 ,plv = 1 ,attribute = 730 ,contrib = 1500 };
get(9,74) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击740点") ,lv = 74 ,glv = 1 ,plv = 1 ,attribute = 740 ,contrib = 1500 };
get(9,75) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击750点") ,lv = 75 ,glv = 1 ,plv = 1 ,attribute = 750 ,contrib = 1500 };
get(9,76) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击760点") ,lv = 76 ,glv = 1 ,plv = 1 ,attribute = 760 ,contrib = 1600 };
get(9,77) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击770点") ,lv = 77 ,glv = 1 ,plv = 1 ,attribute = 770 ,contrib = 1600 };
get(9,78) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击780点") ,lv = 78 ,glv = 1 ,plv = 1 ,attribute = 780 ,contrib = 1600 };
get(9,79) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击790点") ,lv = 79 ,glv = 1 ,plv = 1 ,attribute = 790 ,contrib = 1600 };
get(9,80) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击800点") ,lv = 80 ,glv = 1 ,plv = 1 ,attribute = 800 ,contrib = 1600 };
get(9,81) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击810点") ,lv = 81 ,glv = 1 ,plv = 1 ,attribute = 810 ,contrib = 1700 };
get(9,82) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击820点") ,lv = 82 ,glv = 1 ,plv = 1 ,attribute = 820 ,contrib = 1700 };
get(9,83) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击830点") ,lv = 83 ,glv = 1 ,plv = 1 ,attribute = 830 ,contrib = 1700 };
get(9,84) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击840点") ,lv = 84 ,glv = 1 ,plv = 1 ,attribute = 840 ,contrib = 1700 };
get(9,85) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击850点") ,lv = 85 ,glv = 1 ,plv = 1 ,attribute = 850 ,contrib = 1700 };
get(9,86) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击860点") ,lv = 86 ,glv = 1 ,plv = 1 ,attribute = 860 ,contrib = 1800 };
get(9,87) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击870点") ,lv = 87 ,glv = 1 ,plv = 1 ,attribute = 870 ,contrib = 1800 };
get(9,88) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击880点") ,lv = 88 ,glv = 1 ,plv = 1 ,attribute = 880 ,contrib = 1800 };
get(9,89) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击890点") ,lv = 89 ,glv = 1 ,plv = 1 ,attribute = 890 ,contrib = 1800 };
get(9,90) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击900点") ,lv = 90 ,glv = 1 ,plv = 1 ,attribute = 900 ,contrib = 1800 };
get(9,91) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击910点") ,lv = 91 ,glv = 1 ,plv = 1 ,attribute = 910 ,contrib = 1900 };
get(9,92) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击920点") ,lv = 92 ,glv = 1 ,plv = 1 ,attribute = 920 ,contrib = 1900 };
get(9,93) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击930点") ,lv = 93 ,glv = 1 ,plv = 1 ,attribute = 930 ,contrib = 1900 };
get(9,94) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击940点") ,lv = 94 ,glv = 1 ,plv = 1 ,attribute = 940 ,contrib = 1900 };
get(9,95) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击950点") ,lv = 95 ,glv = 1 ,plv = 1 ,attribute = 950 ,contrib = 1900 };
get(9,96) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击960点") ,lv = 96 ,glv = 1 ,plv = 1 ,attribute = 960 ,contrib = 2000 };
get(9,97) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击970点") ,lv = 97 ,glv = 1 ,plv = 1 ,attribute = 970 ,contrib = 2000 };
get(9,98) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击980点") ,lv = 98 ,glv = 1 ,plv = 1 ,attribute = 980 ,contrib = 2000 };
get(9,99) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击990点") ,lv = 99 ,glv = 1 ,plv = 1 ,attribute = 990 ,contrib = 2000 };
get(9,100) ->
	#base_guild_skill{id = 9 ,name = ?T("暴击") ,desc = ?T("永久提升主角暴击1000点") ,lv = 100 ,glv = 1 ,plv = 1 ,attribute = 1000 ,contrib = 2000 };
get(10,1) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性10点") ,lv = 1 ,glv = 1 ,plv = 1 ,attribute = 10 ,contrib = 100 };
get(10,2) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性20点") ,lv = 2 ,glv = 1 ,plv = 1 ,attribute = 20 ,contrib = 100 };
get(10,3) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性30点") ,lv = 3 ,glv = 1 ,plv = 1 ,attribute = 30 ,contrib = 100 };
get(10,4) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性40点") ,lv = 4 ,glv = 1 ,plv = 1 ,attribute = 40 ,contrib = 100 };
get(10,5) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性50点") ,lv = 5 ,glv = 1 ,plv = 1 ,attribute = 50 ,contrib = 100 };
get(10,6) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性60点") ,lv = 6 ,glv = 1 ,plv = 1 ,attribute = 60 ,contrib = 200 };
get(10,7) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性70点") ,lv = 7 ,glv = 1 ,plv = 1 ,attribute = 70 ,contrib = 200 };
get(10,8) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性80点") ,lv = 8 ,glv = 1 ,plv = 1 ,attribute = 80 ,contrib = 200 };
get(10,9) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性90点") ,lv = 9 ,glv = 1 ,plv = 1 ,attribute = 90 ,contrib = 200 };
get(10,10) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性100点") ,lv = 10 ,glv = 1 ,plv = 1 ,attribute = 100 ,contrib = 200 };
get(10,11) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性110点") ,lv = 11 ,glv = 1 ,plv = 1 ,attribute = 110 ,contrib = 300 };
get(10,12) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性120点") ,lv = 12 ,glv = 1 ,plv = 1 ,attribute = 120 ,contrib = 300 };
get(10,13) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性130点") ,lv = 13 ,glv = 1 ,plv = 1 ,attribute = 130 ,contrib = 300 };
get(10,14) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性140点") ,lv = 14 ,glv = 1 ,plv = 1 ,attribute = 140 ,contrib = 300 };
get(10,15) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性150点") ,lv = 15 ,glv = 1 ,plv = 1 ,attribute = 150 ,contrib = 300 };
get(10,16) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性160点") ,lv = 16 ,glv = 1 ,plv = 1 ,attribute = 160 ,contrib = 400 };
get(10,17) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性170点") ,lv = 17 ,glv = 1 ,plv = 1 ,attribute = 170 ,contrib = 400 };
get(10,18) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性180点") ,lv = 18 ,glv = 1 ,plv = 1 ,attribute = 180 ,contrib = 400 };
get(10,19) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性190点") ,lv = 19 ,glv = 1 ,plv = 1 ,attribute = 190 ,contrib = 400 };
get(10,20) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性200点") ,lv = 20 ,glv = 1 ,plv = 1 ,attribute = 200 ,contrib = 400 };
get(10,21) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性210点") ,lv = 21 ,glv = 1 ,plv = 1 ,attribute = 210 ,contrib = 500 };
get(10,22) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性220点") ,lv = 22 ,glv = 1 ,plv = 1 ,attribute = 220 ,contrib = 500 };
get(10,23) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性230点") ,lv = 23 ,glv = 1 ,plv = 1 ,attribute = 230 ,contrib = 500 };
get(10,24) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性240点") ,lv = 24 ,glv = 1 ,plv = 1 ,attribute = 240 ,contrib = 500 };
get(10,25) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性250点") ,lv = 25 ,glv = 1 ,plv = 1 ,attribute = 250 ,contrib = 500 };
get(10,26) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性260点") ,lv = 26 ,glv = 1 ,plv = 1 ,attribute = 260 ,contrib = 600 };
get(10,27) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性270点") ,lv = 27 ,glv = 1 ,plv = 1 ,attribute = 270 ,contrib = 600 };
get(10,28) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性280点") ,lv = 28 ,glv = 1 ,plv = 1 ,attribute = 280 ,contrib = 600 };
get(10,29) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性290点") ,lv = 29 ,glv = 1 ,plv = 1 ,attribute = 290 ,contrib = 600 };
get(10,30) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性300点") ,lv = 30 ,glv = 1 ,plv = 1 ,attribute = 300 ,contrib = 600 };
get(10,31) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性310点") ,lv = 31 ,glv = 1 ,plv = 1 ,attribute = 310 ,contrib = 700 };
get(10,32) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性320点") ,lv = 32 ,glv = 1 ,plv = 1 ,attribute = 320 ,contrib = 700 };
get(10,33) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性330点") ,lv = 33 ,glv = 1 ,plv = 1 ,attribute = 330 ,contrib = 700 };
get(10,34) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性340点") ,lv = 34 ,glv = 1 ,plv = 1 ,attribute = 340 ,contrib = 700 };
get(10,35) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性350点") ,lv = 35 ,glv = 1 ,plv = 1 ,attribute = 350 ,contrib = 700 };
get(10,36) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性360点") ,lv = 36 ,glv = 1 ,plv = 1 ,attribute = 360 ,contrib = 800 };
get(10,37) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性370点") ,lv = 37 ,glv = 1 ,plv = 1 ,attribute = 370 ,contrib = 800 };
get(10,38) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性380点") ,lv = 38 ,glv = 1 ,plv = 1 ,attribute = 380 ,contrib = 800 };
get(10,39) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性390点") ,lv = 39 ,glv = 1 ,plv = 1 ,attribute = 390 ,contrib = 800 };
get(10,40) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性400点") ,lv = 40 ,glv = 1 ,plv = 1 ,attribute = 400 ,contrib = 800 };
get(10,41) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性410点") ,lv = 41 ,glv = 1 ,plv = 1 ,attribute = 410 ,contrib = 900 };
get(10,42) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性420点") ,lv = 42 ,glv = 1 ,plv = 1 ,attribute = 420 ,contrib = 900 };
get(10,43) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性430点") ,lv = 43 ,glv = 1 ,plv = 1 ,attribute = 430 ,contrib = 900 };
get(10,44) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性440点") ,lv = 44 ,glv = 1 ,plv = 1 ,attribute = 440 ,contrib = 900 };
get(10,45) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性450点") ,lv = 45 ,glv = 1 ,plv = 1 ,attribute = 450 ,contrib = 900 };
get(10,46) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性460点") ,lv = 46 ,glv = 1 ,plv = 1 ,attribute = 460 ,contrib = 1000 };
get(10,47) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性470点") ,lv = 47 ,glv = 1 ,plv = 1 ,attribute = 470 ,contrib = 1000 };
get(10,48) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性480点") ,lv = 48 ,glv = 1 ,plv = 1 ,attribute = 480 ,contrib = 1000 };
get(10,49) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性490点") ,lv = 49 ,glv = 1 ,plv = 1 ,attribute = 490 ,contrib = 1000 };
get(10,50) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性500点") ,lv = 50 ,glv = 1 ,plv = 1 ,attribute = 500 ,contrib = 1000 };
get(10,51) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性510点") ,lv = 51 ,glv = 1 ,plv = 1 ,attribute = 510 ,contrib = 1100 };
get(10,52) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性520点") ,lv = 52 ,glv = 1 ,plv = 1 ,attribute = 520 ,contrib = 1100 };
get(10,53) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性530点") ,lv = 53 ,glv = 1 ,plv = 1 ,attribute = 530 ,contrib = 1100 };
get(10,54) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性540点") ,lv = 54 ,glv = 1 ,plv = 1 ,attribute = 540 ,contrib = 1100 };
get(10,55) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性550点") ,lv = 55 ,glv = 1 ,plv = 1 ,attribute = 550 ,contrib = 1100 };
get(10,56) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性560点") ,lv = 56 ,glv = 1 ,plv = 1 ,attribute = 560 ,contrib = 1200 };
get(10,57) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性570点") ,lv = 57 ,glv = 1 ,plv = 1 ,attribute = 570 ,contrib = 1200 };
get(10,58) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性580点") ,lv = 58 ,glv = 1 ,plv = 1 ,attribute = 580 ,contrib = 1200 };
get(10,59) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性590点") ,lv = 59 ,glv = 1 ,plv = 1 ,attribute = 590 ,contrib = 1200 };
get(10,60) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性600点") ,lv = 60 ,glv = 1 ,plv = 1 ,attribute = 600 ,contrib = 1200 };
get(10,61) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性610点") ,lv = 61 ,glv = 1 ,plv = 1 ,attribute = 610 ,contrib = 1300 };
get(10,62) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性620点") ,lv = 62 ,glv = 1 ,plv = 1 ,attribute = 620 ,contrib = 1300 };
get(10,63) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性630点") ,lv = 63 ,glv = 1 ,plv = 1 ,attribute = 630 ,contrib = 1300 };
get(10,64) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性640点") ,lv = 64 ,glv = 1 ,plv = 1 ,attribute = 640 ,contrib = 1300 };
get(10,65) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性650点") ,lv = 65 ,glv = 1 ,plv = 1 ,attribute = 650 ,contrib = 1300 };
get(10,66) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性660点") ,lv = 66 ,glv = 1 ,plv = 1 ,attribute = 660 ,contrib = 1400 };
get(10,67) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性670点") ,lv = 67 ,glv = 1 ,plv = 1 ,attribute = 670 ,contrib = 1400 };
get(10,68) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性680点") ,lv = 68 ,glv = 1 ,plv = 1 ,attribute = 680 ,contrib = 1400 };
get(10,69) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性690点") ,lv = 69 ,glv = 1 ,plv = 1 ,attribute = 690 ,contrib = 1400 };
get(10,70) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性700点") ,lv = 70 ,glv = 1 ,plv = 1 ,attribute = 700 ,contrib = 1400 };
get(10,71) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性710点") ,lv = 71 ,glv = 1 ,plv = 1 ,attribute = 710 ,contrib = 1500 };
get(10,72) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性720点") ,lv = 72 ,glv = 1 ,plv = 1 ,attribute = 720 ,contrib = 1500 };
get(10,73) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性730点") ,lv = 73 ,glv = 1 ,plv = 1 ,attribute = 730 ,contrib = 1500 };
get(10,74) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性740点") ,lv = 74 ,glv = 1 ,plv = 1 ,attribute = 740 ,contrib = 1500 };
get(10,75) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性750点") ,lv = 75 ,glv = 1 ,plv = 1 ,attribute = 750 ,contrib = 1500 };
get(10,76) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性760点") ,lv = 76 ,glv = 1 ,plv = 1 ,attribute = 760 ,contrib = 1600 };
get(10,77) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性770点") ,lv = 77 ,glv = 1 ,plv = 1 ,attribute = 770 ,contrib = 1600 };
get(10,78) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性780点") ,lv = 78 ,glv = 1 ,plv = 1 ,attribute = 780 ,contrib = 1600 };
get(10,79) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性790点") ,lv = 79 ,glv = 1 ,plv = 1 ,attribute = 790 ,contrib = 1600 };
get(10,80) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性800点") ,lv = 80 ,glv = 1 ,plv = 1 ,attribute = 800 ,contrib = 1600 };
get(10,81) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性810点") ,lv = 81 ,glv = 1 ,plv = 1 ,attribute = 810 ,contrib = 1700 };
get(10,82) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性820点") ,lv = 82 ,glv = 1 ,plv = 1 ,attribute = 820 ,contrib = 1700 };
get(10,83) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性830点") ,lv = 83 ,glv = 1 ,plv = 1 ,attribute = 830 ,contrib = 1700 };
get(10,84) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性840点") ,lv = 84 ,glv = 1 ,plv = 1 ,attribute = 840 ,contrib = 1700 };
get(10,85) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性850点") ,lv = 85 ,glv = 1 ,plv = 1 ,attribute = 850 ,contrib = 1700 };
get(10,86) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性860点") ,lv = 86 ,glv = 1 ,plv = 1 ,attribute = 860 ,contrib = 1800 };
get(10,87) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性870点") ,lv = 87 ,glv = 1 ,plv = 1 ,attribute = 870 ,contrib = 1800 };
get(10,88) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性880点") ,lv = 88 ,glv = 1 ,plv = 1 ,attribute = 880 ,contrib = 1800 };
get(10,89) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性890点") ,lv = 89 ,glv = 1 ,plv = 1 ,attribute = 890 ,contrib = 1800 };
get(10,90) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性900点") ,lv = 90 ,glv = 1 ,plv = 1 ,attribute = 900 ,contrib = 1800 };
get(10,91) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性910点") ,lv = 91 ,glv = 1 ,plv = 1 ,attribute = 910 ,contrib = 1900 };
get(10,92) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性920点") ,lv = 92 ,glv = 1 ,plv = 1 ,attribute = 920 ,contrib = 1900 };
get(10,93) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性930点") ,lv = 93 ,glv = 1 ,plv = 1 ,attribute = 930 ,contrib = 1900 };
get(10,94) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性940点") ,lv = 94 ,glv = 1 ,plv = 1 ,attribute = 940 ,contrib = 1900 };
get(10,95) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性950点") ,lv = 95 ,glv = 1 ,plv = 1 ,attribute = 950 ,contrib = 1900 };
get(10,96) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性960点") ,lv = 96 ,glv = 1 ,plv = 1 ,attribute = 960 ,contrib = 2000 };
get(10,97) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性970点") ,lv = 97 ,glv = 1 ,plv = 1 ,attribute = 970 ,contrib = 2000 };
get(10,98) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性980点") ,lv = 98 ,glv = 1 ,plv = 1 ,attribute = 980 ,contrib = 2000 };
get(10,99) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性990点") ,lv = 99 ,glv = 1 ,plv = 1 ,attribute = 990 ,contrib = 2000 };
get(10,100) ->
	#base_guild_skill{id = 10 ,name = ?T("韧性") ,desc = ?T("永久提升主角韧性1000点") ,lv = 100 ,glv = 1 ,plv = 1 ,attribute = 1000 ,contrib = 2000 };
get(7,1) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中10点") ,lv = 1 ,glv = 1 ,plv = 1 ,attribute = 10 ,contrib = 100 };
get(7,2) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中20点") ,lv = 2 ,glv = 1 ,plv = 1 ,attribute = 20 ,contrib = 100 };
get(7,3) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中30点") ,lv = 3 ,glv = 1 ,plv = 1 ,attribute = 30 ,contrib = 100 };
get(7,4) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中40点") ,lv = 4 ,glv = 1 ,plv = 1 ,attribute = 40 ,contrib = 100 };
get(7,5) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中50点") ,lv = 5 ,glv = 1 ,plv = 1 ,attribute = 50 ,contrib = 100 };
get(7,6) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中60点") ,lv = 6 ,glv = 1 ,plv = 1 ,attribute = 60 ,contrib = 200 };
get(7,7) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中70点") ,lv = 7 ,glv = 1 ,plv = 1 ,attribute = 70 ,contrib = 200 };
get(7,8) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中80点") ,lv = 8 ,glv = 1 ,plv = 1 ,attribute = 80 ,contrib = 200 };
get(7,9) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中90点") ,lv = 9 ,glv = 1 ,plv = 1 ,attribute = 90 ,contrib = 200 };
get(7,10) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中100点") ,lv = 10 ,glv = 1 ,plv = 1 ,attribute = 100 ,contrib = 200 };
get(7,11) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中110点") ,lv = 11 ,glv = 1 ,plv = 1 ,attribute = 110 ,contrib = 300 };
get(7,12) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中120点") ,lv = 12 ,glv = 1 ,plv = 1 ,attribute = 120 ,contrib = 300 };
get(7,13) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中130点") ,lv = 13 ,glv = 1 ,plv = 1 ,attribute = 130 ,contrib = 300 };
get(7,14) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中140点") ,lv = 14 ,glv = 1 ,plv = 1 ,attribute = 140 ,contrib = 300 };
get(7,15) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中150点") ,lv = 15 ,glv = 1 ,plv = 1 ,attribute = 150 ,contrib = 300 };
get(7,16) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中160点") ,lv = 16 ,glv = 1 ,plv = 1 ,attribute = 160 ,contrib = 400 };
get(7,17) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中170点") ,lv = 17 ,glv = 1 ,plv = 1 ,attribute = 170 ,contrib = 400 };
get(7,18) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中180点") ,lv = 18 ,glv = 1 ,plv = 1 ,attribute = 180 ,contrib = 400 };
get(7,19) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中190点") ,lv = 19 ,glv = 1 ,plv = 1 ,attribute = 190 ,contrib = 400 };
get(7,20) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中200点") ,lv = 20 ,glv = 1 ,plv = 1 ,attribute = 200 ,contrib = 400 };
get(7,21) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中210点") ,lv = 21 ,glv = 1 ,plv = 1 ,attribute = 210 ,contrib = 500 };
get(7,22) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中220点") ,lv = 22 ,glv = 1 ,plv = 1 ,attribute = 220 ,contrib = 500 };
get(7,23) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中230点") ,lv = 23 ,glv = 1 ,plv = 1 ,attribute = 230 ,contrib = 500 };
get(7,24) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中240点") ,lv = 24 ,glv = 1 ,plv = 1 ,attribute = 240 ,contrib = 500 };
get(7,25) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中250点") ,lv = 25 ,glv = 1 ,plv = 1 ,attribute = 250 ,contrib = 500 };
get(7,26) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中260点") ,lv = 26 ,glv = 1 ,plv = 1 ,attribute = 260 ,contrib = 600 };
get(7,27) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中270点") ,lv = 27 ,glv = 1 ,plv = 1 ,attribute = 270 ,contrib = 600 };
get(7,28) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中280点") ,lv = 28 ,glv = 1 ,plv = 1 ,attribute = 280 ,contrib = 600 };
get(7,29) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中290点") ,lv = 29 ,glv = 1 ,plv = 1 ,attribute = 290 ,contrib = 600 };
get(7,30) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中300点") ,lv = 30 ,glv = 1 ,plv = 1 ,attribute = 300 ,contrib = 600 };
get(7,31) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中310点") ,lv = 31 ,glv = 1 ,plv = 1 ,attribute = 310 ,contrib = 700 };
get(7,32) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中320点") ,lv = 32 ,glv = 1 ,plv = 1 ,attribute = 320 ,contrib = 700 };
get(7,33) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中330点") ,lv = 33 ,glv = 1 ,plv = 1 ,attribute = 330 ,contrib = 700 };
get(7,34) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中340点") ,lv = 34 ,glv = 1 ,plv = 1 ,attribute = 340 ,contrib = 700 };
get(7,35) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中350点") ,lv = 35 ,glv = 1 ,plv = 1 ,attribute = 350 ,contrib = 700 };
get(7,36) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中360点") ,lv = 36 ,glv = 1 ,plv = 1 ,attribute = 360 ,contrib = 800 };
get(7,37) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中370点") ,lv = 37 ,glv = 1 ,plv = 1 ,attribute = 370 ,contrib = 800 };
get(7,38) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中380点") ,lv = 38 ,glv = 1 ,plv = 1 ,attribute = 380 ,contrib = 800 };
get(7,39) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中390点") ,lv = 39 ,glv = 1 ,plv = 1 ,attribute = 390 ,contrib = 800 };
get(7,40) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中400点") ,lv = 40 ,glv = 1 ,plv = 1 ,attribute = 400 ,contrib = 800 };
get(7,41) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中410点") ,lv = 41 ,glv = 1 ,plv = 1 ,attribute = 410 ,contrib = 900 };
get(7,42) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中420点") ,lv = 42 ,glv = 1 ,plv = 1 ,attribute = 420 ,contrib = 900 };
get(7,43) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中430点") ,lv = 43 ,glv = 1 ,plv = 1 ,attribute = 430 ,contrib = 900 };
get(7,44) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中440点") ,lv = 44 ,glv = 1 ,plv = 1 ,attribute = 440 ,contrib = 900 };
get(7,45) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中450点") ,lv = 45 ,glv = 1 ,plv = 1 ,attribute = 450 ,contrib = 900 };
get(7,46) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中460点") ,lv = 46 ,glv = 1 ,plv = 1 ,attribute = 460 ,contrib = 1000 };
get(7,47) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中470点") ,lv = 47 ,glv = 1 ,plv = 1 ,attribute = 470 ,contrib = 1000 };
get(7,48) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中480点") ,lv = 48 ,glv = 1 ,plv = 1 ,attribute = 480 ,contrib = 1000 };
get(7,49) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中490点") ,lv = 49 ,glv = 1 ,plv = 1 ,attribute = 490 ,contrib = 1000 };
get(7,50) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中500点") ,lv = 50 ,glv = 1 ,plv = 1 ,attribute = 500 ,contrib = 1000 };
get(7,51) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中510点") ,lv = 51 ,glv = 1 ,plv = 1 ,attribute = 510 ,contrib = 1100 };
get(7,52) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中520点") ,lv = 52 ,glv = 1 ,plv = 1 ,attribute = 520 ,contrib = 1100 };
get(7,53) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中530点") ,lv = 53 ,glv = 1 ,plv = 1 ,attribute = 530 ,contrib = 1100 };
get(7,54) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中540点") ,lv = 54 ,glv = 1 ,plv = 1 ,attribute = 540 ,contrib = 1100 };
get(7,55) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中550点") ,lv = 55 ,glv = 1 ,plv = 1 ,attribute = 550 ,contrib = 1100 };
get(7,56) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中560点") ,lv = 56 ,glv = 1 ,plv = 1 ,attribute = 560 ,contrib = 1200 };
get(7,57) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中570点") ,lv = 57 ,glv = 1 ,plv = 1 ,attribute = 570 ,contrib = 1200 };
get(7,58) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中580点") ,lv = 58 ,glv = 1 ,plv = 1 ,attribute = 580 ,contrib = 1200 };
get(7,59) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中590点") ,lv = 59 ,glv = 1 ,plv = 1 ,attribute = 590 ,contrib = 1200 };
get(7,60) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中600点") ,lv = 60 ,glv = 1 ,plv = 1 ,attribute = 600 ,contrib = 1200 };
get(7,61) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中610点") ,lv = 61 ,glv = 1 ,plv = 1 ,attribute = 610 ,contrib = 1300 };
get(7,62) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中620点") ,lv = 62 ,glv = 1 ,plv = 1 ,attribute = 620 ,contrib = 1300 };
get(7,63) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中630点") ,lv = 63 ,glv = 1 ,plv = 1 ,attribute = 630 ,contrib = 1300 };
get(7,64) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中640点") ,lv = 64 ,glv = 1 ,plv = 1 ,attribute = 640 ,contrib = 1300 };
get(7,65) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中650点") ,lv = 65 ,glv = 1 ,plv = 1 ,attribute = 650 ,contrib = 1300 };
get(7,66) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中660点") ,lv = 66 ,glv = 1 ,plv = 1 ,attribute = 660 ,contrib = 1400 };
get(7,67) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中670点") ,lv = 67 ,glv = 1 ,plv = 1 ,attribute = 670 ,contrib = 1400 };
get(7,68) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中680点") ,lv = 68 ,glv = 1 ,plv = 1 ,attribute = 680 ,contrib = 1400 };
get(7,69) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中690点") ,lv = 69 ,glv = 1 ,plv = 1 ,attribute = 690 ,contrib = 1400 };
get(7,70) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中700点") ,lv = 70 ,glv = 1 ,plv = 1 ,attribute = 700 ,contrib = 1400 };
get(7,71) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中710点") ,lv = 71 ,glv = 1 ,plv = 1 ,attribute = 710 ,contrib = 1500 };
get(7,72) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中720点") ,lv = 72 ,glv = 1 ,plv = 1 ,attribute = 720 ,contrib = 1500 };
get(7,73) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中730点") ,lv = 73 ,glv = 1 ,plv = 1 ,attribute = 730 ,contrib = 1500 };
get(7,74) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中740点") ,lv = 74 ,glv = 1 ,plv = 1 ,attribute = 740 ,contrib = 1500 };
get(7,75) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中750点") ,lv = 75 ,glv = 1 ,plv = 1 ,attribute = 750 ,contrib = 1500 };
get(7,76) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中760点") ,lv = 76 ,glv = 1 ,plv = 1 ,attribute = 760 ,contrib = 1600 };
get(7,77) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中770点") ,lv = 77 ,glv = 1 ,plv = 1 ,attribute = 770 ,contrib = 1600 };
get(7,78) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中780点") ,lv = 78 ,glv = 1 ,plv = 1 ,attribute = 780 ,contrib = 1600 };
get(7,79) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中790点") ,lv = 79 ,glv = 1 ,plv = 1 ,attribute = 790 ,contrib = 1600 };
get(7,80) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中800点") ,lv = 80 ,glv = 1 ,plv = 1 ,attribute = 800 ,contrib = 1600 };
get(7,81) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中810点") ,lv = 81 ,glv = 1 ,plv = 1 ,attribute = 810 ,contrib = 1700 };
get(7,82) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中820点") ,lv = 82 ,glv = 1 ,plv = 1 ,attribute = 820 ,contrib = 1700 };
get(7,83) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中830点") ,lv = 83 ,glv = 1 ,plv = 1 ,attribute = 830 ,contrib = 1700 };
get(7,84) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中840点") ,lv = 84 ,glv = 1 ,plv = 1 ,attribute = 840 ,contrib = 1700 };
get(7,85) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中850点") ,lv = 85 ,glv = 1 ,plv = 1 ,attribute = 850 ,contrib = 1700 };
get(7,86) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中860点") ,lv = 86 ,glv = 1 ,plv = 1 ,attribute = 860 ,contrib = 1800 };
get(7,87) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中870点") ,lv = 87 ,glv = 1 ,plv = 1 ,attribute = 870 ,contrib = 1800 };
get(7,88) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中880点") ,lv = 88 ,glv = 1 ,plv = 1 ,attribute = 880 ,contrib = 1800 };
get(7,89) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中890点") ,lv = 89 ,glv = 1 ,plv = 1 ,attribute = 890 ,contrib = 1800 };
get(7,90) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中900点") ,lv = 90 ,glv = 1 ,plv = 1 ,attribute = 900 ,contrib = 1800 };
get(7,91) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中910点") ,lv = 91 ,glv = 1 ,plv = 1 ,attribute = 910 ,contrib = 1900 };
get(7,92) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中920点") ,lv = 92 ,glv = 1 ,plv = 1 ,attribute = 920 ,contrib = 1900 };
get(7,93) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中930点") ,lv = 93 ,glv = 1 ,plv = 1 ,attribute = 930 ,contrib = 1900 };
get(7,94) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中940点") ,lv = 94 ,glv = 1 ,plv = 1 ,attribute = 940 ,contrib = 1900 };
get(7,95) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中950点") ,lv = 95 ,glv = 1 ,plv = 1 ,attribute = 950 ,contrib = 1900 };
get(7,96) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中960点") ,lv = 96 ,glv = 1 ,plv = 1 ,attribute = 960 ,contrib = 2000 };
get(7,97) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中970点") ,lv = 97 ,glv = 1 ,plv = 1 ,attribute = 970 ,contrib = 2000 };
get(7,98) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中980点") ,lv = 98 ,glv = 1 ,plv = 1 ,attribute = 980 ,contrib = 2000 };
get(7,99) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中990点") ,lv = 99 ,glv = 1 ,plv = 1 ,attribute = 990 ,contrib = 2000 };
get(7,100) ->
	#base_guild_skill{id = 7 ,name = ?T("命中") ,desc = ?T("永久提升主角命中1000点") ,lv = 100 ,glv = 1 ,plv = 1 ,attribute = 1000 ,contrib = 2000 };
get(8,1) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避10点") ,lv = 1 ,glv = 1 ,plv = 1 ,attribute = 10 ,contrib = 100 };
get(8,2) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避20点") ,lv = 2 ,glv = 1 ,plv = 1 ,attribute = 20 ,contrib = 100 };
get(8,3) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避30点") ,lv = 3 ,glv = 1 ,plv = 1 ,attribute = 30 ,contrib = 100 };
get(8,4) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避40点") ,lv = 4 ,glv = 1 ,plv = 1 ,attribute = 40 ,contrib = 100 };
get(8,5) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避50点") ,lv = 5 ,glv = 1 ,plv = 1 ,attribute = 50 ,contrib = 100 };
get(8,6) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避60点") ,lv = 6 ,glv = 1 ,plv = 1 ,attribute = 60 ,contrib = 200 };
get(8,7) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避70点") ,lv = 7 ,glv = 1 ,plv = 1 ,attribute = 70 ,contrib = 200 };
get(8,8) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避80点") ,lv = 8 ,glv = 1 ,plv = 1 ,attribute = 80 ,contrib = 200 };
get(8,9) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避90点") ,lv = 9 ,glv = 1 ,plv = 1 ,attribute = 90 ,contrib = 200 };
get(8,10) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避100点") ,lv = 10 ,glv = 1 ,plv = 1 ,attribute = 100 ,contrib = 200 };
get(8,11) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避110点") ,lv = 11 ,glv = 1 ,plv = 1 ,attribute = 110 ,contrib = 300 };
get(8,12) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避120点") ,lv = 12 ,glv = 1 ,plv = 1 ,attribute = 120 ,contrib = 300 };
get(8,13) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避130点") ,lv = 13 ,glv = 1 ,plv = 1 ,attribute = 130 ,contrib = 300 };
get(8,14) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避140点") ,lv = 14 ,glv = 1 ,plv = 1 ,attribute = 140 ,contrib = 300 };
get(8,15) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避150点") ,lv = 15 ,glv = 1 ,plv = 1 ,attribute = 150 ,contrib = 300 };
get(8,16) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避160点") ,lv = 16 ,glv = 1 ,plv = 1 ,attribute = 160 ,contrib = 400 };
get(8,17) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避170点") ,lv = 17 ,glv = 1 ,plv = 1 ,attribute = 170 ,contrib = 400 };
get(8,18) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避180点") ,lv = 18 ,glv = 1 ,plv = 1 ,attribute = 180 ,contrib = 400 };
get(8,19) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避190点") ,lv = 19 ,glv = 1 ,plv = 1 ,attribute = 190 ,contrib = 400 };
get(8,20) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避200点") ,lv = 20 ,glv = 1 ,plv = 1 ,attribute = 200 ,contrib = 400 };
get(8,21) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避210点") ,lv = 21 ,glv = 1 ,plv = 1 ,attribute = 210 ,contrib = 500 };
get(8,22) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避220点") ,lv = 22 ,glv = 1 ,plv = 1 ,attribute = 220 ,contrib = 500 };
get(8,23) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避230点") ,lv = 23 ,glv = 1 ,plv = 1 ,attribute = 230 ,contrib = 500 };
get(8,24) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避240点") ,lv = 24 ,glv = 1 ,plv = 1 ,attribute = 240 ,contrib = 500 };
get(8,25) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避250点") ,lv = 25 ,glv = 1 ,plv = 1 ,attribute = 250 ,contrib = 500 };
get(8,26) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避260点") ,lv = 26 ,glv = 1 ,plv = 1 ,attribute = 260 ,contrib = 600 };
get(8,27) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避270点") ,lv = 27 ,glv = 1 ,plv = 1 ,attribute = 270 ,contrib = 600 };
get(8,28) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避280点") ,lv = 28 ,glv = 1 ,plv = 1 ,attribute = 280 ,contrib = 600 };
get(8,29) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避290点") ,lv = 29 ,glv = 1 ,plv = 1 ,attribute = 290 ,contrib = 600 };
get(8,30) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避300点") ,lv = 30 ,glv = 1 ,plv = 1 ,attribute = 300 ,contrib = 600 };
get(8,31) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避310点") ,lv = 31 ,glv = 1 ,plv = 1 ,attribute = 310 ,contrib = 700 };
get(8,32) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避320点") ,lv = 32 ,glv = 1 ,plv = 1 ,attribute = 320 ,contrib = 700 };
get(8,33) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避330点") ,lv = 33 ,glv = 1 ,plv = 1 ,attribute = 330 ,contrib = 700 };
get(8,34) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避340点") ,lv = 34 ,glv = 1 ,plv = 1 ,attribute = 340 ,contrib = 700 };
get(8,35) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避350点") ,lv = 35 ,glv = 1 ,plv = 1 ,attribute = 350 ,contrib = 700 };
get(8,36) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避360点") ,lv = 36 ,glv = 1 ,plv = 1 ,attribute = 360 ,contrib = 800 };
get(8,37) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避370点") ,lv = 37 ,glv = 1 ,plv = 1 ,attribute = 370 ,contrib = 800 };
get(8,38) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避380点") ,lv = 38 ,glv = 1 ,plv = 1 ,attribute = 380 ,contrib = 800 };
get(8,39) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避390点") ,lv = 39 ,glv = 1 ,plv = 1 ,attribute = 390 ,contrib = 800 };
get(8,40) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避400点") ,lv = 40 ,glv = 1 ,plv = 1 ,attribute = 400 ,contrib = 800 };
get(8,41) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避410点") ,lv = 41 ,glv = 1 ,plv = 1 ,attribute = 410 ,contrib = 900 };
get(8,42) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避420点") ,lv = 42 ,glv = 1 ,plv = 1 ,attribute = 420 ,contrib = 900 };
get(8,43) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避430点") ,lv = 43 ,glv = 1 ,plv = 1 ,attribute = 430 ,contrib = 900 };
get(8,44) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避440点") ,lv = 44 ,glv = 1 ,plv = 1 ,attribute = 440 ,contrib = 900 };
get(8,45) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避450点") ,lv = 45 ,glv = 1 ,plv = 1 ,attribute = 450 ,contrib = 900 };
get(8,46) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避460点") ,lv = 46 ,glv = 1 ,plv = 1 ,attribute = 460 ,contrib = 1000 };
get(8,47) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避470点") ,lv = 47 ,glv = 1 ,plv = 1 ,attribute = 470 ,contrib = 1000 };
get(8,48) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避480点") ,lv = 48 ,glv = 1 ,plv = 1 ,attribute = 480 ,contrib = 1000 };
get(8,49) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避490点") ,lv = 49 ,glv = 1 ,plv = 1 ,attribute = 490 ,contrib = 1000 };
get(8,50) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避500点") ,lv = 50 ,glv = 1 ,plv = 1 ,attribute = 500 ,contrib = 1000 };
get(8,51) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避510点") ,lv = 51 ,glv = 1 ,plv = 1 ,attribute = 510 ,contrib = 1100 };
get(8,52) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避520点") ,lv = 52 ,glv = 1 ,plv = 1 ,attribute = 520 ,contrib = 1100 };
get(8,53) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避530点") ,lv = 53 ,glv = 1 ,plv = 1 ,attribute = 530 ,contrib = 1100 };
get(8,54) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避540点") ,lv = 54 ,glv = 1 ,plv = 1 ,attribute = 540 ,contrib = 1100 };
get(8,55) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避550点") ,lv = 55 ,glv = 1 ,plv = 1 ,attribute = 550 ,contrib = 1100 };
get(8,56) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避560点") ,lv = 56 ,glv = 1 ,plv = 1 ,attribute = 560 ,contrib = 1200 };
get(8,57) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避570点") ,lv = 57 ,glv = 1 ,plv = 1 ,attribute = 570 ,contrib = 1200 };
get(8,58) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避580点") ,lv = 58 ,glv = 1 ,plv = 1 ,attribute = 580 ,contrib = 1200 };
get(8,59) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避590点") ,lv = 59 ,glv = 1 ,plv = 1 ,attribute = 590 ,contrib = 1200 };
get(8,60) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避600点") ,lv = 60 ,glv = 1 ,plv = 1 ,attribute = 600 ,contrib = 1200 };
get(8,61) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避610点") ,lv = 61 ,glv = 1 ,plv = 1 ,attribute = 610 ,contrib = 1300 };
get(8,62) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避620点") ,lv = 62 ,glv = 1 ,plv = 1 ,attribute = 620 ,contrib = 1300 };
get(8,63) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避630点") ,lv = 63 ,glv = 1 ,plv = 1 ,attribute = 630 ,contrib = 1300 };
get(8,64) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避640点") ,lv = 64 ,glv = 1 ,plv = 1 ,attribute = 640 ,contrib = 1300 };
get(8,65) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避650点") ,lv = 65 ,glv = 1 ,plv = 1 ,attribute = 650 ,contrib = 1300 };
get(8,66) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避660点") ,lv = 66 ,glv = 1 ,plv = 1 ,attribute = 660 ,contrib = 1400 };
get(8,67) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避670点") ,lv = 67 ,glv = 1 ,plv = 1 ,attribute = 670 ,contrib = 1400 };
get(8,68) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避680点") ,lv = 68 ,glv = 1 ,plv = 1 ,attribute = 680 ,contrib = 1400 };
get(8,69) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避690点") ,lv = 69 ,glv = 1 ,plv = 1 ,attribute = 690 ,contrib = 1400 };
get(8,70) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避700点") ,lv = 70 ,glv = 1 ,plv = 1 ,attribute = 700 ,contrib = 1400 };
get(8,71) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避710点") ,lv = 71 ,glv = 1 ,plv = 1 ,attribute = 710 ,contrib = 1500 };
get(8,72) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避720点") ,lv = 72 ,glv = 1 ,plv = 1 ,attribute = 720 ,contrib = 1500 };
get(8,73) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避730点") ,lv = 73 ,glv = 1 ,plv = 1 ,attribute = 730 ,contrib = 1500 };
get(8,74) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避740点") ,lv = 74 ,glv = 1 ,plv = 1 ,attribute = 740 ,contrib = 1500 };
get(8,75) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避750点") ,lv = 75 ,glv = 1 ,plv = 1 ,attribute = 750 ,contrib = 1500 };
get(8,76) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避760点") ,lv = 76 ,glv = 1 ,plv = 1 ,attribute = 760 ,contrib = 1600 };
get(8,77) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避770点") ,lv = 77 ,glv = 1 ,plv = 1 ,attribute = 770 ,contrib = 1600 };
get(8,78) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避780点") ,lv = 78 ,glv = 1 ,plv = 1 ,attribute = 780 ,contrib = 1600 };
get(8,79) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避790点") ,lv = 79 ,glv = 1 ,plv = 1 ,attribute = 790 ,contrib = 1600 };
get(8,80) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避800点") ,lv = 80 ,glv = 1 ,plv = 1 ,attribute = 800 ,contrib = 1600 };
get(8,81) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避810点") ,lv = 81 ,glv = 1 ,plv = 1 ,attribute = 810 ,contrib = 1700 };
get(8,82) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避820点") ,lv = 82 ,glv = 1 ,plv = 1 ,attribute = 820 ,contrib = 1700 };
get(8,83) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避830点") ,lv = 83 ,glv = 1 ,plv = 1 ,attribute = 830 ,contrib = 1700 };
get(8,84) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避840点") ,lv = 84 ,glv = 1 ,plv = 1 ,attribute = 840 ,contrib = 1700 };
get(8,85) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避850点") ,lv = 85 ,glv = 1 ,plv = 1 ,attribute = 850 ,contrib = 1700 };
get(8,86) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避860点") ,lv = 86 ,glv = 1 ,plv = 1 ,attribute = 860 ,contrib = 1800 };
get(8,87) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避870点") ,lv = 87 ,glv = 1 ,plv = 1 ,attribute = 870 ,contrib = 1800 };
get(8,88) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避880点") ,lv = 88 ,glv = 1 ,plv = 1 ,attribute = 880 ,contrib = 1800 };
get(8,89) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避890点") ,lv = 89 ,glv = 1 ,plv = 1 ,attribute = 890 ,contrib = 1800 };
get(8,90) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避900点") ,lv = 90 ,glv = 1 ,plv = 1 ,attribute = 900 ,contrib = 1800 };
get(8,91) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避910点") ,lv = 91 ,glv = 1 ,plv = 1 ,attribute = 910 ,contrib = 1900 };
get(8,92) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避920点") ,lv = 92 ,glv = 1 ,plv = 1 ,attribute = 920 ,contrib = 1900 };
get(8,93) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避930点") ,lv = 93 ,glv = 1 ,plv = 1 ,attribute = 930 ,contrib = 1900 };
get(8,94) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避940点") ,lv = 94 ,glv = 1 ,plv = 1 ,attribute = 940 ,contrib = 1900 };
get(8,95) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避950点") ,lv = 95 ,glv = 1 ,plv = 1 ,attribute = 950 ,contrib = 1900 };
get(8,96) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避960点") ,lv = 96 ,glv = 1 ,plv = 1 ,attribute = 960 ,contrib = 2000 };
get(8,97) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避970点") ,lv = 97 ,glv = 1 ,plv = 1 ,attribute = 970 ,contrib = 2000 };
get(8,98) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避980点") ,lv = 98 ,glv = 1 ,plv = 1 ,attribute = 980 ,contrib = 2000 };
get(8,99) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避990点") ,lv = 99 ,glv = 1 ,plv = 1 ,attribute = 990 ,contrib = 2000 };
get(8,100) ->
	#base_guild_skill{id = 8 ,name = ?T("闪避") ,desc = ?T("永久提升主角闪避1000点") ,lv = 100 ,glv = 1 ,plv = 1 ,attribute = 1000 ,contrib = 2000 };
get(_,_) -> [].