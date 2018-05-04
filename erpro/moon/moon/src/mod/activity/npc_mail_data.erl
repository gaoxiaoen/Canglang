%% NPC_MAIL_DATA
-module(npc_mail_data).
-export([enevt_id/0, get/0, get_gain/1]).

-include("npc_mail.hrl").

enevt_id() -> [1061,1070,1062,1074,1075].

get() ->
[
	
#npc_mail{
		id = 1
		,label = special_event
		,type = 510400
		, target = 1
},
#npc_mail{
		id = 2
		,label = special_event
		,type = 310200
		, target = 1
},
#npc_mail{
		id = 3
		,label = special_event
		,type = 210400
		, target = 1
},
#npc_mail{
		id = 4
		,label = special_event
		,type = 101711
		, target = 1
},
#npc_mail{
		id = 5
		,label = special_event
		,type = 102711
		, target = 1
},
#npc_mail{
		id = 6
		,label = special_event
		,type = 103711
		, target = 1
},
#npc_mail{
		id = 7
		,label = sweep_dungeon
		,type = 11011
		, target = 1
},
#npc_mail{
		id = 8
		,label = sweep_dungeon
		,type = 10071
		, target = 1
},
#npc_mail{
		id = 9
		,label = special_event
		,type = 10001
		, target = 1
},
#npc_mail{
		id = 10
		,label = special_event
		, target = 1
},
#npc_mail{
		id = 11
		,label = special_event
		,type = 10236
		, target = 1
},
#npc_mail{
		id = 13
		,label = special_event
		,type = 10002
		, target = 1
},
#npc_mail{
		id = 14
		,label = special_event
		,type = 10003
		, target = 1
},
#npc_mail{
		id = 15
		,label = finish_task
		,type = 10930
		, target = 1
},
#npc_mail{
		id = 18
		,label = special_event
		,type = 200600
		, target = 1
},
#npc_mail{
		id = 19
		,label = special_event
		,type = 300600
		, target = 1
},
#npc_mail{
		id = 20
		,label = special_event
		,type = 500600
		, target = 1
},
#npc_mail{
		id = 21
		,label = special_event
		,type = 10207
		, target = 1
},
#npc_mail{
		id = 23
		,label = special_event
		,type = 118012
		, target = 1
},
#npc_mail{
		id = 24
		,label = special_event
		,type = 118011
		, target = 1
},
#npc_mail{
		id = 25
		,label = special_event
		,type = 118010
		, target = 1
},
#npc_mail{
		id = 26
		,label = special_event
		,type = 118009
		, target = 1
},
#npc_mail{
		id = 27
		,label = special_event
		,type = 10220
		, target = 1
},
#npc_mail{
		id = 28
		,label = special_event
		,type = 110220
		, target = 1
},
#npc_mail{
		id = 29
		,label = special_event
		,type = 10248
		, target = 1
},
#npc_mail{
		id = 30
		,label = special_event
		,type = 110248
		, target = 1
},
#npc_mail{
		id = 31
		,label = special_event
		,type = 20007
		, target = 1
},
#npc_mail{
		id = 32
		,label = special_event
		,type = 120007
		, target = 1
},
#npc_mail{
		id = 33
		,label = special_event
		,type = 10226
		, target = 1
},
#npc_mail{
		id = 34
		,label = special_event
		,type = 110226
		, target = 1
},
#npc_mail{
		id = 35
		,label = special_event
		,type = 10235
		, target = 1
},
#npc_mail{
		id = 36
		,label = special_event
		,type = 110235
		, target = 1
},
#npc_mail{
		id = 37
		,label = special_event
		,type = 10234
		, target = 1
},
#npc_mail{
		id = 38
		,label = special_event
		,type = 110234
		, target = 1
},
#npc_mail{
		id = 39
		,label = special_event
		,type = 10245
		, target = 1
},
#npc_mail{
		id = 40
		,label = special_event
		,type = 110245
		, target = 1
},
#npc_mail{
		id = 41
		,label = special_event
		,type = 10215
		, target = 1
},
#npc_mail{
		id = 42
		,label = special_event
		,type = 110215
		, target = 1
},
#npc_mail{
		id = 43
		,label = special_event
		,type = 10256
		, target = 1
},
#npc_mail{
		id = 44
		,label = special_event
		,type = 110256
		, target = 1
},
#npc_mail{
		id = 45
		,label = special_event
		,type = 10239
		, target = 1
},
#npc_mail{
		id = 46
		,label = special_event
		,type = 110239
		, target = 1
},
#npc_mail{
		id = 47
		,label = special_event
		,type = 10254
		, target = 1
},
#npc_mail{
		id = 48
		,label = special_event
		,type = 110254
		, target = 1
},
#npc_mail{
		id = 49
		,label = special_event
		,type = 10240
		, target = 1
},
#npc_mail{
		id = 50
		,label = special_event
		,type = 110240
		, target = 1
},
#npc_mail{
		id = 51
		,label = special_event
		,type = 10241
		, target = 1
},
#npc_mail{
		id = 52
		,label = special_event
		,type = 110241
		, target = 1
},
#npc_mail{
		id = 53
		,label = special_event
		,type = 10242
		, target = 1
},
#npc_mail{
		id = 54
		,label = special_event
		,type = 110242
		, target = 1
},
#npc_mail{
		id = 55
		,label = special_event
		,type = 10244
		, target = 1
},
#npc_mail{
		id = 56
		,label = special_event
		,type = 110244
		, target = 1
},
#npc_mail{
		id = 57
		,label = special_event
		,type = 10207
		, target = 1
},
#npc_mail{
		id = 58
		,label = special_event
		,type = 110207
		, target = 1
},
#npc_mail{
		id = 59
		,label = special_event
		,type = 10201
		, target = 1
},
#npc_mail{
		id = 60
		,label = special_event
		,type = 110201
		, target = 1
},
#npc_mail{
		id = 61
		,label = special_event
		,type = 10202
		, target = 1
},
#npc_mail{
		id = 62
		,label = special_event
		,type = 110202
		, target = 1
},
#npc_mail{
		id = 63
		,label = special_event
		,type = 10227
		, target = 1
},
#npc_mail{
		id = 64
		,label = special_event
		,type = 110227
		, target = 1
},
#npc_mail{
		id = 65
		,label = special_event
		,type = 10218
		, target = 1
},
#npc_mail{
		id = 66
		,label = special_event
		,type = 110218
		, target = 1
},
#npc_mail{
		id = 67
		,label = special_event
		,type = 10216
		, target = 1
},
#npc_mail{
		id = 68
		,label = special_event
		,type = 110216
		, target = 1
},
#npc_mail{
		id = 69
		,label = special_event
		,type = 10217
		, target = 1
},
#npc_mail{
		id = 70
		,label = special_event
		,type = 110217
		, target = 1
},
#npc_mail{
		id = 71
		,label = special_event
		,type = 10274
		, target = 1
},
#npc_mail{
		id = 72
		,label = special_event
		,type = 110274
		, target = 1
},
#npc_mail{
		id = 73
		,label = special_event
		,type = 10210
		, target = 1
},
#npc_mail{
		id = 74
		,label = special_event
		,type = 110210
		, target = 1
},
#npc_mail{
		id = 75
		,label = special_event
		,type = 10200
		, target = 1
},
#npc_mail{
		id = 76
		,label = special_event
		,type = 110200
		, target = 1
},
#npc_mail{
		id = 77
		,label = special_event
		,type = 10276
		, target = 1
},
#npc_mail{
		id = 78
		,label = special_event
		,type = 110276
		, target = 1
},
#npc_mail{
		id = 79
		,label = special_event
		,type = 10230
		, target = 1
},
#npc_mail{
		id = 80
		,label = special_event
		,type = 110230
		, target = 1
},
#npc_mail{
		id = 81
		,label = special_event
		,type = 10219
		, target = 1
},
#npc_mail{
		id = 82
		,label = special_event
		,type = 110219
		, target = 1
},
#npc_mail{
		id = 83
		,label = special_event
		,type = 10221
		, target = 1
},
#npc_mail{
		id = 84
		,label = special_event
		,type = 110221
		, target = 1
},
#npc_mail{
		id = 85
		,label = special_event
		,type = 10237
		, target = 1
},
#npc_mail{
		id = 86
		,label = special_event
		,type = 110237
		, target = 1
},
#npc_mail{
		id = 87
		,label = special_event
		,type = 10246
		, target = 1
},
#npc_mail{
		id = 88
		,label = special_event
		,type = 110246
		, target = 1
},
#npc_mail{
		id = 89
		,label = special_event
		,type = 10247
		, target = 1
},
#npc_mail{
		id = 90
		,label = special_event
		,type = 110247
		, target = 1
},
#npc_mail{
		id = 91
		,label = special_event
		,type = 10275
		, target = 1
},
#npc_mail{
		id = 92
		,label = special_event
		,type = 110275
		, target = 1
},
#npc_mail{
		id = 93
		,label = special_event
		,type = 10231
		, target = 1
},
#npc_mail{
		id = 94
		,label = special_event
		,type = 110231
		, target = 1
},
#npc_mail{
		id = 95
		,label = special_event
		,type = 10232
		, target = 1
},
#npc_mail{
		id = 96
		,label = special_event
		,type = 110232
		, target = 1
},
#npc_mail{
		id = 97
		,label = special_event
		,type = 10252
		, target = 1
},
#npc_mail{
		id = 98
		,label = special_event
		,type = 110252
		, target = 1
},
#npc_mail{
		id = 99
		,label = special_event
		,type = 10204
		, target = 1
},
#npc_mail{
		id = 100
		,label = special_event
		,type = 110204
		, target = 1
},
#npc_mail{
		id = 101
		,label = special_event
		,type = 10205
		, target = 1
},
#npc_mail{
		id = 102
		,label = special_event
		,type = 110205
		, target = 1
},
#npc_mail{
		id = 103
		,label = special_event
		,type = 10273
		, target = 1
},
#npc_mail{
		id = 104
		,label = special_event
		,type = 110273
		, target = 1
},
#npc_mail{
		id = 105
		,label = special_event
		,type = 10212
		, target = 1
},
#npc_mail{
		id = 106
		,label = special_event
		,type = 110212
		, target = 1
},
#npc_mail{
		id = 107
		,label = special_event
		,type = 10213
		, target = 1
},
#npc_mail{
		id = 108
		,label = special_event
		,type = 110213
		, target = 1
},
#npc_mail{
		id = 109
		,label = special_event
		,type = 10206
		, target = 1
},
#npc_mail{
		id = 110
		,label = special_event
		,type = 110206
		, target = 1
},
#npc_mail{
		id = 111
		,label = special_event
		,type = 10277
		, target = 1
},
#npc_mail{
		id = 112
		,label = special_event
		,type = 110277
		, target = 1
},
#npc_mail{
		id = 113
		,label = special_event
		,type = 10253
		, target = 1
},
#npc_mail{
		id = 114
		,label = special_event
		,type = 110253
		, target = 1
},
#npc_mail{
		id = 115
		,label = kill_npc
		,type = 15011
		, target = 1
},
#npc_mail{
		id = 116
		,label = kill_npc
		,type = 15012
		, target = 1
},
#npc_mail{
		id = 117
		,label = kill_npc
		,type = 15013
		, target = 1
},
#npc_mail{
		id = 118
		,label = kill_npc
		,type = 15014
		, target = 1
},
#npc_mail{
		id = 119
		,label = kill_npc
		,type = 15015
		, target = 1
},
#npc_mail{
		id = 120
		,label = finish_task
		,type = 10126
		, target = 1
}].

get_gain(1) -> [{coin,10000}];
get_gain(2) -> [{coin,10000}];
get_gain(3) -> [{coin,10000}];
get_gain(4) -> [{coin,20000}];
get_gain(5) -> [{coin,20000}];
get_gain(6) -> [{coin,20000}];
get_gain(7) -> [{coin,15000}];
get_gain(8) -> [{coin,15000}];
get_gain(9) -> [{stone,6000}];
get_gain(10) -> [{coin,10000}];
get_gain(11) -> [{coin,10000}];
get_gain(13) -> [{stone,5000}];
get_gain(14) -> [{stone,5000}];
get_gain(15) -> [{coin,13000}];
get_gain(18) -> [{coin,10000}];
get_gain(19) -> [{coin,10000}];
get_gain(20) -> [{coin,10000}];
get_gain(21) -> [{coin,10000}];
get_gain(23) -> [{coin,12000}];
get_gain(24) -> [{coin,14000}];
get_gain(25) -> [{coin,16000}];
get_gain(26) -> [{coin,20000}];
get_gain(27) -> [{coin,10000}];
get_gain(28) -> [{coin,10000}];
get_gain(29) -> [{coin,10000}];
get_gain(30) -> [{coin,10000}];
get_gain(31) -> [{coin,10000}];
get_gain(32) -> [{coin,10000}];
get_gain(33) -> [{coin,10000}];
get_gain(34) -> [{coin,10000}];
get_gain(35) -> [{coin,10000}];
get_gain(36) -> [{coin,10000}];
get_gain(37) -> [{coin,10000}];
get_gain(38) -> [{coin,10000}];
get_gain(39) -> [{coin,10000}];
get_gain(40) -> [{coin,10000}];
get_gain(41) -> [{coin,10000}];
get_gain(42) -> [{coin,10000}];
get_gain(43) -> [{coin,10000}];
get_gain(44) -> [{coin,10000}];
get_gain(45) -> [{coin,10000}];
get_gain(46) -> [{coin,10000}];
get_gain(47) -> [{coin,10000}];
get_gain(48) -> [{coin,10000}];
get_gain(49) -> [{coin,10000}];
get_gain(50) -> [{coin,10000}];
get_gain(51) -> [{coin,10000}];
get_gain(52) -> [{coin,10000}];
get_gain(53) -> [{coin,10000}];
get_gain(54) -> [{coin,10000}];
get_gain(55) -> [{coin,10000}];
get_gain(56) -> [{coin,10000}];
get_gain(57) -> [{coin,10000}];
get_gain(58) -> [{coin,10000}];
get_gain(59) -> [{coin,10000}];
get_gain(60) -> [{coin,10000}];
get_gain(61) -> [{coin,10000}];
get_gain(62) -> [{coin,10000}];
get_gain(63) -> [{coin,10000}];
get_gain(64) -> [{coin,10000}];
get_gain(65) -> [{coin,10000}];
get_gain(66) -> [{coin,10000}];
get_gain(67) -> [{coin,10000}];
get_gain(68) -> [{coin,10000}];
get_gain(69) -> [{coin,10000}];
get_gain(70) -> [{coin,10000}];
get_gain(71) -> [{coin,10000}];
get_gain(72) -> [{coin,10000}];
get_gain(73) -> [{coin,10000}];
get_gain(74) -> [{coin,10000}];
get_gain(75) -> [{coin,10000}];
get_gain(76) -> [{coin,10000}];
get_gain(77) -> [{coin,10000}];
get_gain(78) -> [{coin,10000}];
get_gain(79) -> [{coin,10000}];
get_gain(80) -> [{coin,10000}];
get_gain(81) -> [{coin,10000}];
get_gain(82) -> [{coin,10000}];
get_gain(83) -> [{coin,10000}];
get_gain(84) -> [{coin,10000}];
get_gain(85) -> [{coin,10000}];
get_gain(86) -> [{coin,10000}];
get_gain(87) -> [{coin,10000}];
get_gain(88) -> [{coin,10000}];
get_gain(89) -> [{coin,10000}];
get_gain(90) -> [{coin,10000}];
get_gain(91) -> [{coin,10000}];
get_gain(92) -> [{coin,10000}];
get_gain(93) -> [{coin,10000}];
get_gain(94) -> [{coin,10000}];
get_gain(95) -> [{coin,10000}];
get_gain(96) -> [{coin,10000}];
get_gain(97) -> [{coin,10000}];
get_gain(98) -> [{coin,10000}];
get_gain(99) -> [{coin,10000}];
get_gain(100) -> [{coin,10000}];
get_gain(101) -> [{coin,10000}];
get_gain(102) -> [{coin,10000}];
get_gain(103) -> [{coin,10000}];
get_gain(104) -> [{coin,10000}];
get_gain(105) -> [{coin,10000}];
get_gain(106) -> [{coin,10000}];
get_gain(107) -> [{coin,10000}];
get_gain(108) -> [{coin,10000}];
get_gain(109) -> [{coin,10000}];
get_gain(110) -> [{coin,10000}];
get_gain(111) -> [{coin,10000}];
get_gain(112) -> [{coin,10000}];
get_gain(113) -> [{coin,10000}];
get_gain(114) -> [{coin,10000}];
get_gain(115) -> [{coin,10000}];
get_gain(116) -> [{coin,10000}];
get_gain(117) -> [{coin,10000}];
get_gain(118) -> [{coin,10000}];
get_gain(119) -> [{coin,10000}];
get_gain(120) -> [{coin,10000}];
get_gain(_Id) -> [].



