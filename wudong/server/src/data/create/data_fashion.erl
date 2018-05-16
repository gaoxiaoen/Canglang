%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_fashion
	%%% @Created : 2018-05-08 16:20:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_fashion).
-export([id_list/0]).
-export([get/1]).
-export([get_icon/1]).
-include("error_code.hrl").
-include("fashion.hrl").
-include("common.hrl").

    id_list() ->
    [10001,10002,10003,10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,10014,10015,10016,10017,10018,10019,10020,10021,10022,10023,10024,10025,10026,10027,10028,10029,10030,10031,10032,10033,10034,10035].
get(10001) -> 
   #base_fashion{fashion_id = 10001 ,name = ?T("沙漠风情") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10001 ,goods_id = 6602001 ,goods_num = 10 ,icon = 6601001 ,head_id = 10001 }
;get(10002) -> 
   #base_fashion{fashion_id = 10002 ,name = ?T("水晶之恋") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10002 ,goods_id = 6602002 ,goods_num = 10 ,icon = 6601002 ,head_id = 10002 }
;get(10003) -> 
   #base_fashion{fashion_id = 10003 ,name = ?T("月落孤痕") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10003 ,goods_id = 6602003 ,goods_num = 10 ,icon = 6601003 ,head_id = 10003 }
;get(10004) -> 
   #base_fashion{fashion_id = 10004 ,name = ?T("热情沙滩") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10004 ,goods_id = 6602004 ,goods_num = 10 ,icon = 6601004 ,head_id = 10004 }
;get(10005) -> 
   #base_fashion{fashion_id = 10005 ,name = ?T("暗龙护铠") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10005 ,goods_id = 6602005 ,goods_num = 10 ,icon = 6601005 ,head_id = 10005 }
;get(10006) -> 
   #base_fashion{fashion_id = 10006 ,name = ?T("紫气东来") ,type = 2 ,attrs = [],time_bar = 0 ,image = 10006 ,goods_id = 6602006 ,goods_num = 10 ,icon = 6601006 ,head_id = 10006 }
;get(10007) -> 
   #base_fashion{fashion_id = 10007 ,name = ?T("仙皇至尊") ,type = 2 ,attrs = [],time_bar = 0 ,image = 10007 ,goods_id = 6602007 ,goods_num = 10 ,icon = 6601007 ,head_id = 10007 }
;get(10008) -> 
   #base_fashion{fashion_id = 10008 ,name = ?T("无双斗神") ,type = 2 ,attrs = [],time_bar = 0 ,image = 10008 ,goods_id = 6602008 ,goods_num = 10 ,icon = 6601008 ,head_id = 10008 }
;get(10009) -> 
   #base_fashion{fashion_id = 10009 ,name = ?T("结婚礼服（1天）") ,type = 4 ,attrs = [{att,271},{def,135},{hp_lim,2700},{hit,54},{dodge,54}],time_bar = 86400 ,image = 10009 ,goods_id = 0 ,goods_num = 0 ,icon = 6601009 ,head_id = 10009 }
;get(10010) -> 
   #base_fashion{fashion_id = 10010 ,name = ?T("结婚礼服（7天）") ,type = 4 ,attrs = [{att,271},{def,135},{hp_lim,2700},{hit,54},{dodge,54}],time_bar = 604800 ,image = 10009 ,goods_id = 0 ,goods_num = 0 ,icon = 6601009 ,head_id = 10010 }
;get(10011) -> 
   #base_fashion{fashion_id = 10011 ,name = ?T("结婚礼服") ,type = 4 ,attrs = [],time_bar = 0 ,image = 10009 ,goods_id = 6602011 ,goods_num = 10 ,icon = 6601009 ,head_id = 10011 }
;get(10012) -> 
   #base_fashion{fashion_id = 10012 ,name = ?T("萌宝奇缘") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10010 ,goods_id = 6602012 ,goods_num = 10 ,icon = 6601012 ,head_id = 10012 }
;get(10013) -> 
   #base_fashion{fashion_id = 10013 ,name = ?T("凌云赤霄") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10011 ,goods_id = 6602013 ,goods_num = 10 ,icon = 6601013 ,head_id = 10013 }
;get(10014) -> 
   #base_fashion{fashion_id = 10014 ,name = ?T("星际战警") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10012 ,goods_id = 6602014 ,goods_num = 10 ,icon = 6601014 ,head_id = 10014 }
;get(10015) -> 
   #base_fashion{fashion_id = 10015 ,name = ?T("杀破狼") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10013 ,goods_id = 6602015 ,goods_num = 10 ,icon = 6601015 ,head_id = 10015 }
;get(10016) -> 
   #base_fashion{fashion_id = 10016 ,name = ?T("万圣迷情") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10014 ,goods_id = 6602016 ,goods_num = 10 ,icon = 6601016 ,head_id = 10016 }
;get(10017) -> 
   #base_fashion{fashion_id = 10017 ,name = ?T("沧海月明") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10015 ,goods_id = 6602017 ,goods_num = 10 ,icon = 6601017 ,head_id = 10017 }
;get(10018) -> 
   #base_fashion{fashion_id = 10018 ,name = ?T("踏莎而行") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10015 ,goods_id = 6602018 ,goods_num = 10 ,icon = 6601018 ,head_id = 10018 }
;get(10019) -> 
   #base_fashion{fashion_id = 10019 ,name = ?T("霸王别姬") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10016 ,goods_id = 6602019 ,goods_num = 10 ,icon = 6601019 ,head_id = 10019 }
;get(10020) -> 
   #base_fashion{fashion_id = 10020 ,name = ?T("红梅煮酒") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10017 ,goods_id = 6602020 ,goods_num = 10 ,icon = 6601020 ,head_id = 10020 }
;get(10021) -> 
   #base_fashion{fashion_id = 10021 ,name = ?T("蔚蓝幻想") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10018 ,goods_id = 6602021 ,goods_num = 10 ,icon = 6601021 ,head_id = 10021 }
;get(10022) -> 
   #base_fashion{fashion_id = 10022 ,name = ?T("圣诞套装") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10019 ,goods_id = 6602022 ,goods_num = 10 ,icon = 6601022 ,head_id = 10022 }
;get(10023) -> 
   #base_fashion{fashion_id = 10023 ,name = ?T("仙狐彩袂") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10020 ,goods_id = 6602023 ,goods_num = 10 ,icon = 6601023 ,head_id = 10023 }
;get(10024) -> 
   #base_fashion{fashion_id = 10024 ,name = ?T("吉祥如意") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10021 ,goods_id = 6602024 ,goods_num = 10 ,icon = 6601024 ,head_id = 10024 }
;get(10025) -> 
   #base_fashion{fashion_id = 10025 ,name = ?T("天河翠羽") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10022 ,goods_id = 6602025 ,goods_num = 10 ,icon = 6601025 ,head_id = 10025 }
;get(10026) -> 
   #base_fashion{fashion_id = 10026 ,name = ?T("韩风恋歌") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10023 ,goods_id = 6602026 ,goods_num = 10 ,icon = 6601026 ,head_id = 10026 }
;get(10027) -> 
   #base_fashion{fashion_id = 10027 ,name = ?T("春华秋实") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10024 ,goods_id = 6602027 ,goods_num = 10 ,icon = 6601027 ,head_id = 10027 }
;get(10028) -> 
   #base_fashion{fashion_id = 10028 ,name = ?T("金风玉露") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10025 ,goods_id = 6602028 ,goods_num = 10 ,icon = 6601028 ,head_id = 10028 }
;get(10029) -> 
   #base_fashion{fashion_id = 10029 ,name = ?T("元气虎") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10026 ,goods_id = 6602029 ,goods_num = 10 ,icon = 6601029 ,head_id = 10029 }
;get(10030) -> 
   #base_fashion{fashion_id = 10030 ,name = ?T("柴郡猫") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10027 ,goods_id = 6602030 ,goods_num = 10 ,icon = 6601030 ,head_id = 10030 }
;get(10031) -> 
   #base_fashion{fashion_id = 10031 ,name = ?T("哈士奇") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10028 ,goods_id = 6602031 ,goods_num = 10 ,icon = 6601031 ,head_id = 10031 }
;get(10032) -> 
   #base_fashion{fashion_id = 10032 ,name = ?T("花鸟风月") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10029 ,goods_id = 6602032 ,goods_num = 10 ,icon = 6601032 ,head_id = 10032 }
;get(10033) -> 
   #base_fashion{fashion_id = 10033 ,name = ?T("潮流先锋") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10030 ,goods_id = 6602033 ,goods_num = 10 ,icon = 6601033 ,head_id = 10033 }
;get(10034) -> 
   #base_fashion{fashion_id = 10034 ,name = ?T("街头嘻哈") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10031 ,goods_id = 6602034 ,goods_num = 10 ,icon = 6601034 ,head_id = 10034 }
;get(10035) -> 
   #base_fashion{fashion_id = 10035 ,name = ?T("格斗天王") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10032 ,goods_id = 6602035 ,goods_num = 10 ,icon = 6601035 ,head_id = 10035 }
;get(_) -> [].
get_icon(6601001) -> 
   #base_fashion{fashion_id = 10001 ,name = ?T("沙漠风情") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10001 ,goods_id = 6602001 ,goods_num = 10 ,icon = 6601001 ,head_id = 10001 }
;get_icon(6601002) -> 
   #base_fashion{fashion_id = 10002 ,name = ?T("水晶之恋") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10002 ,goods_id = 6602002 ,goods_num = 10 ,icon = 6601002 ,head_id = 10002 }
;get_icon(6601003) -> 
   #base_fashion{fashion_id = 10003 ,name = ?T("月落孤痕") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10003 ,goods_id = 6602003 ,goods_num = 10 ,icon = 6601003 ,head_id = 10003 }
;get_icon(6601004) -> 
   #base_fashion{fashion_id = 10004 ,name = ?T("热情沙滩") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10004 ,goods_id = 6602004 ,goods_num = 10 ,icon = 6601004 ,head_id = 10004 }
;get_icon(6601005) -> 
   #base_fashion{fashion_id = 10005 ,name = ?T("暗龙护铠") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10005 ,goods_id = 6602005 ,goods_num = 10 ,icon = 6601005 ,head_id = 10005 }
;get_icon(6601006) -> 
   #base_fashion{fashion_id = 10006 ,name = ?T("紫气东来") ,type = 2 ,attrs = [],time_bar = 0 ,image = 10006 ,goods_id = 6602006 ,goods_num = 10 ,icon = 6601006 ,head_id = 10006 }
;get_icon(6601007) -> 
   #base_fashion{fashion_id = 10007 ,name = ?T("仙皇至尊") ,type = 2 ,attrs = [],time_bar = 0 ,image = 10007 ,goods_id = 6602007 ,goods_num = 10 ,icon = 6601007 ,head_id = 10007 }
;get_icon(6601008) -> 
   #base_fashion{fashion_id = 10008 ,name = ?T("无双斗神") ,type = 2 ,attrs = [],time_bar = 0 ,image = 10008 ,goods_id = 6602008 ,goods_num = 10 ,icon = 6601008 ,head_id = 10008 }
;get_icon(6601009) -> 
   #base_fashion{fashion_id = 10009 ,name = ?T("结婚礼服（1天）") ,type = 4 ,attrs = [{att,271},{def,135},{hp_lim,2700},{hit,54},{dodge,54}],time_bar = 86400 ,image = 10009 ,goods_id = 0 ,goods_num = 0 ,icon = 6601009 ,head_id = 10009 }
;get_icon(6601009) -> 
   #base_fashion{fashion_id = 10010 ,name = ?T("结婚礼服（7天）") ,type = 4 ,attrs = [{att,271},{def,135},{hp_lim,2700},{hit,54},{dodge,54}],time_bar = 604800 ,image = 10009 ,goods_id = 0 ,goods_num = 0 ,icon = 6601009 ,head_id = 10010 }
;get_icon(6601009) -> 
   #base_fashion{fashion_id = 10011 ,name = ?T("结婚礼服") ,type = 4 ,attrs = [],time_bar = 0 ,image = 10009 ,goods_id = 6602011 ,goods_num = 10 ,icon = 6601009 ,head_id = 10011 }
;get_icon(6601012) -> 
   #base_fashion{fashion_id = 10012 ,name = ?T("萌宝奇缘") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10010 ,goods_id = 6602012 ,goods_num = 10 ,icon = 6601012 ,head_id = 10012 }
;get_icon(6601013) -> 
   #base_fashion{fashion_id = 10013 ,name = ?T("凌云赤霄") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10011 ,goods_id = 6602013 ,goods_num = 10 ,icon = 6601013 ,head_id = 10013 }
;get_icon(6601014) -> 
   #base_fashion{fashion_id = 10014 ,name = ?T("星际战警") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10012 ,goods_id = 6602014 ,goods_num = 10 ,icon = 6601014 ,head_id = 10014 }
;get_icon(6601015) -> 
   #base_fashion{fashion_id = 10015 ,name = ?T("杀破狼") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10013 ,goods_id = 6602015 ,goods_num = 10 ,icon = 6601015 ,head_id = 10015 }
;get_icon(6601016) -> 
   #base_fashion{fashion_id = 10016 ,name = ?T("万圣迷情") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10014 ,goods_id = 6602016 ,goods_num = 10 ,icon = 6601016 ,head_id = 10016 }
;get_icon(6601017) -> 
   #base_fashion{fashion_id = 10017 ,name = ?T("沧海月明") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10015 ,goods_id = 6602017 ,goods_num = 10 ,icon = 6601017 ,head_id = 10017 }
;get_icon(6601018) -> 
   #base_fashion{fashion_id = 10018 ,name = ?T("踏莎而行") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10015 ,goods_id = 6602018 ,goods_num = 10 ,icon = 6601018 ,head_id = 10018 }
;get_icon(6601019) -> 
   #base_fashion{fashion_id = 10019 ,name = ?T("霸王别姬") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10016 ,goods_id = 6602019 ,goods_num = 10 ,icon = 6601019 ,head_id = 10019 }
;get_icon(6601020) -> 
   #base_fashion{fashion_id = 10020 ,name = ?T("红梅煮酒") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10017 ,goods_id = 6602020 ,goods_num = 10 ,icon = 6601020 ,head_id = 10020 }
;get_icon(6601021) -> 
   #base_fashion{fashion_id = 10021 ,name = ?T("蔚蓝幻想") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10018 ,goods_id = 6602021 ,goods_num = 10 ,icon = 6601021 ,head_id = 10021 }
;get_icon(6601022) -> 
   #base_fashion{fashion_id = 10022 ,name = ?T("圣诞套装") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10019 ,goods_id = 6602022 ,goods_num = 10 ,icon = 6601022 ,head_id = 10022 }
;get_icon(6601023) -> 
   #base_fashion{fashion_id = 10023 ,name = ?T("仙狐彩袂") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10020 ,goods_id = 6602023 ,goods_num = 10 ,icon = 6601023 ,head_id = 10023 }
;get_icon(6601024) -> 
   #base_fashion{fashion_id = 10024 ,name = ?T("吉祥如意") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10021 ,goods_id = 6602024 ,goods_num = 10 ,icon = 6601024 ,head_id = 10024 }
;get_icon(6601025) -> 
   #base_fashion{fashion_id = 10025 ,name = ?T("天河翠羽") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10022 ,goods_id = 6602025 ,goods_num = 10 ,icon = 6601025 ,head_id = 10025 }
;get_icon(6601026) -> 
   #base_fashion{fashion_id = 10026 ,name = ?T("韩风恋歌") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10023 ,goods_id = 6602026 ,goods_num = 10 ,icon = 6601026 ,head_id = 10026 }
;get_icon(6601027) -> 
   #base_fashion{fashion_id = 10027 ,name = ?T("春华秋实") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10024 ,goods_id = 6602027 ,goods_num = 10 ,icon = 6601027 ,head_id = 10027 }
;get_icon(6601028) -> 
   #base_fashion{fashion_id = 10028 ,name = ?T("金风玉露") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10025 ,goods_id = 6602028 ,goods_num = 10 ,icon = 6601028 ,head_id = 10028 }
;get_icon(6601029) -> 
   #base_fashion{fashion_id = 10029 ,name = ?T("元气虎") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10026 ,goods_id = 6602029 ,goods_num = 10 ,icon = 6601029 ,head_id = 10029 }
;get_icon(6601030) -> 
   #base_fashion{fashion_id = 10030 ,name = ?T("柴郡猫") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10027 ,goods_id = 6602030 ,goods_num = 10 ,icon = 6601030 ,head_id = 10030 }
;get_icon(6601031) -> 
   #base_fashion{fashion_id = 10031 ,name = ?T("哈士奇") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10028 ,goods_id = 6602031 ,goods_num = 10 ,icon = 6601031 ,head_id = 10031 }
;get_icon(6601032) -> 
   #base_fashion{fashion_id = 10032 ,name = ?T("花鸟风月") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10029 ,goods_id = 6602032 ,goods_num = 10 ,icon = 6601032 ,head_id = 10032 }
;get_icon(6601033) -> 
   #base_fashion{fashion_id = 10033 ,name = ?T("潮流先锋") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10030 ,goods_id = 6602033 ,goods_num = 10 ,icon = 6601033 ,head_id = 10033 }
;get_icon(6601034) -> 
   #base_fashion{fashion_id = 10034 ,name = ?T("街头嘻哈") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10031 ,goods_id = 6602034 ,goods_num = 10 ,icon = 6601034 ,head_id = 10034 }
;get_icon(6601035) -> 
   #base_fashion{fashion_id = 10035 ,name = ?T("格斗天王") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10032 ,goods_id = 6602035 ,goods_num = 10 ,icon = 6601035 ,head_id = 10035 }
;get_icon(_) -> [].
