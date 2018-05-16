%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_manor_retinue
	%%% @Created : 2017-06-12 19:44:23
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_manor_retinue).
-export([get_type/0]).
-export([type_list/1]).
-export([get/1]).
-include("common.hrl").
-include("guild_manor.hrl").
get_type() -> [1,2,3].
type_list(1) -> [6501101,6501102,6501103,6501110,6501111,6501112,6501119,6501120,6501121,6501128,6501129,6501130];
type_list(2) -> [6501104,6501105,6501106,6501113,6501114,6501115,6501122,6501123,6501124];
type_list(3) -> [6501107,6501108,6501109,6501116,6501117,6501118,6501125,6501126,6501127];
type_list(_) -> [].
get(6501101) ->
	#base_manor_retinue{type = 1 ,id = 6501101 ,name = ?T("刁欣德"), color = 1 ,quality = 1 ,talent = {1001} ,exp_lim = 100 ,exp = 10 };
get(6501102) ->
	#base_manor_retinue{type = 1 ,id = 6501102 ,name = ?T("公孙飞翔"), color = 2 ,quality = 2 ,talent = {1002} ,exp_lim = 100 ,exp = 10 };
get(6501103) ->
	#base_manor_retinue{type = 1 ,id = 6501103 ,name = ?T("缪奇玮"), color = 3 ,quality = 3 ,talent = {1003} ,exp_lim = 100 ,exp = 10 };
get(6501104) ->
	#base_manor_retinue{type = 2 ,id = 6501104 ,name = ?T("祝雪风"), color = 1 ,quality = 1 ,talent = {1004} ,exp_lim = 100 ,exp = 10 };
get(6501105) ->
	#base_manor_retinue{type = 2 ,id = 6501105 ,name = ?T("季刚捷"), color = 2 ,quality = 2 ,talent = {1005} ,exp_lim = 100 ,exp = 10 };
get(6501106) ->
	#base_manor_retinue{type = 2 ,id = 6501106 ,name = ?T("冯向明"), color = 3 ,quality = 3 ,talent = {1006} ,exp_lim = 100 ,exp = 10 };
get(6501107) ->
	#base_manor_retinue{type = 3 ,id = 6501107 ,name = ?T("浦建白"), color = 1 ,quality = 1 ,talent = {1007} ,exp_lim = 100 ,exp = 10 };
get(6501108) ->
	#base_manor_retinue{type = 3 ,id = 6501108 ,name = ?T("喻学海"), color = 2 ,quality = 2 ,talent = {1008} ,exp_lim = 100 ,exp = 10 };
get(6501109) ->
	#base_manor_retinue{type = 3 ,id = 6501109 ,name = ?T("廉高峻"), color = 3 ,quality = 3 ,talent = {1009} ,exp_lim = 100 ,exp = 10 };
get(6501110) ->
	#base_manor_retinue{type = 1 ,id = 6501110 ,name = ?T("宋良骏"), color = 1 ,quality = 1 ,talent = {1010} ,exp_lim = 100 ,exp = 10 };
get(6501111) ->
	#base_manor_retinue{type = 1 ,id = 6501111 ,name = ?T("寇蕴藉"), color = 2 ,quality = 2 ,talent = {1051} ,exp_lim = 100 ,exp = 10 };
get(6501112) ->
	#base_manor_retinue{type = 1 ,id = 6501112 ,name = ?T("索光亮"), color = 3 ,quality = 3 ,talent = {1052} ,exp_lim = 100 ,exp = 10 };
get(6501113) ->
	#base_manor_retinue{type = 2 ,id = 6501113 ,name = ?T("应德惠"), color = 1 ,quality = 1 ,talent = {1053} ,exp_lim = 100 ,exp = 10 };
get(6501114) ->
	#base_manor_retinue{type = 2 ,id = 6501114 ,name = ?T("陶锐立"), color = 2 ,quality = 2 ,talent = {1054} ,exp_lim = 100 ,exp = 10 };
get(6501115) ->
	#base_manor_retinue{type = 2 ,id = 6501115 ,name = ?T("昌和雅"), color = 3 ,quality = 3 ,talent = {1055} ,exp_lim = 100 ,exp = 10 };
get(6501116) ->
	#base_manor_retinue{type = 3 ,id = 6501116 ,name = ?T("印乐志"), color = 1 ,quality = 1 ,talent = {1056} ,exp_lim = 100 ,exp = 10 };
get(6501117) ->
	#base_manor_retinue{type = 3 ,id = 6501117 ,name = ?T("苗祺祥"), color = 2 ,quality = 2 ,talent = {1057} ,exp_lim = 100 ,exp = 10 };
get(6501118) ->
	#base_manor_retinue{type = 3 ,id = 6501118 ,name = ?T("柳正卿"), color = 3 ,quality = 3 ,talent = {1058} ,exp_lim = 100 ,exp = 10 };
get(6501119) ->
	#base_manor_retinue{type = 1 ,id = 6501119 ,name = ?T("宣华翰"), color = 1 ,quality = 1 ,talent = {1059} ,exp_lim = 100 ,exp = 10 };
get(6501120) ->
	#base_manor_retinue{type = 1 ,id = 6501120 ,name = ?T("游飞尘"), color = 2 ,quality = 2 ,talent = {1060} ,exp_lim = 100 ,exp = 10 };
get(6501121) ->
	#base_manor_retinue{type = 1 ,id = 6501121 ,name = ?T("韶翰海"), color = 3 ,quality = 3 ,talent = {1101} ,exp_lim = 100 ,exp = 10 };
get(6501122) ->
	#base_manor_retinue{type = 2 ,id = 6501122 ,name = ?T("姬和同"), color = 1 ,quality = 1 ,talent = {1102} ,exp_lim = 100 ,exp = 10 };
get(6501123) ->
	#base_manor_retinue{type = 2 ,id = 6501123 ,name = ?T("乐正英彦"), color = 2 ,quality = 2 ,talent = {1103} ,exp_lim = 100 ,exp = 10 };
get(6501124) ->
	#base_manor_retinue{type = 2 ,id = 6501124 ,name = ?T("都浩南"), color = 3 ,quality = 3 ,talent = {1104} ,exp_lim = 100 ,exp = 10 };
get(6501125) ->
	#base_manor_retinue{type = 3 ,id = 6501125 ,name = ?T("仉督景同"), color = 1 ,quality = 1 ,talent = {1105} ,exp_lim = 100 ,exp = 10 };
get(6501126) ->
	#base_manor_retinue{type = 3 ,id = 6501126 ,name = ?T("连翔飞"), color = 2 ,quality = 2 ,talent = {1106} ,exp_lim = 100 ,exp = 10 };
get(6501127) ->
	#base_manor_retinue{type = 3 ,id = 6501127 ,name = ?T("糜英喆"), color = 3 ,quality = 3 ,talent = {1107} ,exp_lim = 100 ,exp = 10 };
get(6501128) ->
	#base_manor_retinue{type = 1 ,id = 6501128 ,name = ?T("巫翰翮"), color = 1 ,quality = 1 ,talent = {1108} ,exp_lim = 100 ,exp = 10 };
get(6501129) ->
	#base_manor_retinue{type = 1 ,id = 6501129 ,name = ?T("班文德"), color = 2 ,quality = 2 ,talent = {1109} ,exp_lim = 100 ,exp = 10 };
get(6501130) ->
	#base_manor_retinue{type = 1 ,id = 6501130 ,name = ?T("山文彬"), color = 3 ,quality = 3 ,talent = {1110} ,exp_lim = 100 ,exp = 10 };
get(_) -> [].