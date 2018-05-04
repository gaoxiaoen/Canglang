
%%----------------------------------------------------
%% 物品数据
%% @author mobin
%%----------------------------------------------------

-module(item_data).
-export([
        get/1
    ]
).
-include("item.hrl").
-include("condition.hrl").

get(5201314) ->
    {ok, #item_base{
            id = 5201314
            ,name = <<"补偿充值卡">>
            ,type = 52
            ,quality = 6
            ,overlap = 999
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
			,effect = [{love, 10}]
            ,attr = []
        }
    };

get(101081) ->
    {ok, #item_base{
            id = 101081
            ,name = <<"地牢测试用装42">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 42}]
            ,attr = [{?attr_dmg, 100, 7419}, {?attr_hp_max, 100, 32641}, {?attr_defence, 100, 8563}, {?attr_critrate, 100, 1048}, {?attr_hitrate, 100, 677}, {?attr_aspd, 100, 55}, {?attr_dmg_magic, 100, 1017}, {?attr_mp_max, 100, 2036}, {?attr_evasion, 100, 208}, {?attr_tenacity, 100, 471}, {?attr_rst_all, 100, 1455}, {?attr_js, 100, 331}]
        }
    };

get(101082) ->
    {ok, #item_base{
            id = 101082
            ,name = <<"地牢测试用装47">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 48}]
            ,attr = [{?attr_dmg, 100, 9922}, {?attr_hp_max, 100, 43013}, {?attr_defence, 100, 11274}, {?attr_critrate, 100, 1388}, {?attr_hitrate, 100, 883}, {?attr_aspd, 100, 66}, {?attr_dmg_magic, 100, 1450}, {?attr_mp_max, 100, 2526}, {?attr_evasion, 100, 306}, {?attr_tenacity, 100, 669}, {?attr_rst_all, 100, 2122}, {?attr_js, 100, 456}]
        }
    };

get(101083) ->
    {ok, #item_base{
            id = 101083
            ,name = <<"地牢测试用装52">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 54}]
            ,attr = [{?attr_dmg, 100, 11869}, {?attr_hp_max, 100, 53374}, {?attr_defence, 100, 14626}, {?attr_critrate, 100, 1815}, {?attr_hitrate, 100, 1107}, {?attr_aspd, 100, 69}, {?attr_dmg_magic, 100, 1723}, {?attr_mp_max, 100, 3041}, {?attr_evasion, 100, 422}, {?attr_tenacity, 100, 946}, {?attr_rst_all, 100, 2716}, {?attr_js, 100, 593}]
        }
    };

get(101084) ->
    {ok, #item_base{
            id = 101084
            ,name = <<"地牢测试用装56">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 57}]
            ,attr = [{?attr_dmg, 100, 13492}, {?attr_hp_max, 100, 61940}, {?attr_defence, 100, 17274}, {?attr_critrate, 100, 2142}, {?attr_hitrate, 100, 1284}, {?attr_aspd, 100, 80}, {?attr_dmg_magic, 100, 1990}, {?attr_mp_max, 100, 3528}, {?attr_evasion, 100, 509}, {?attr_tenacity, 100, 1141}, {?attr_rst_all, 100, 3313}, {?attr_js, 100, 741}]
        }
    };

get(101085) ->
    {ok, #item_base{
            id = 101085
            ,name = <<"地牢测试用装60">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,attr = [{?attr_dmg, 100, 16248}, {?attr_hp_max, 100, 74698}, {?attr_defence, 100, 20637}, {?attr_critrate, 100, 2586}, {?attr_hitrate, 100, 1536}, {?attr_aspd, 100, 80}, {?attr_dmg_magic, 100, 2503}, {?attr_mp_max, 100, 4096}, {?attr_evasion, 100, 648}, {?attr_tenacity, 100, 1414}, {?attr_rst_all, 100, 4222}, {?attr_js, 100, 929}]
        }
    };

get(101099) ->
    {ok, #item_base{
            id = 101099
            ,name = <<"20">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 1993}, {?attr_hp_max, 100, 8827}, {?attr_defence, 100, 703}, {?attr_critrate, 100, 79}, {?attr_hitrate, 100, 70}, {?attr_aspd, 100, 40}, {?attr_dmg_magic, 100, 159}]
        }
    };

get(101098) ->
    {ok, #item_base{
            id = 101098
            ,name = <<"25">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 4955}, {?attr_hp_max, 100, 21444}, {?attr_defence, 100, 1758}, {?attr_critrate, 100, 216}, {?attr_hitrate, 100, 172}, {?attr_aspd, 100, 45}, {?attr_dmg_magic, 100, 406}]
        }
    };

get(101097) ->
    {ok, #item_base{
            id = 101097
            ,name = <<"35">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 7093}, {?attr_hp_max, 100, 33572}, {?attr_defence, 100, 2863}, {?attr_critrate, 100, 358}, {?attr_hitrate, 100, 255}, {?attr_aspd, 100, 50}, {?attr_dmg_magic, 100, 672}]
        }
    };

get(101096) ->
    {ok, #item_base{
            id = 101096
            ,name = <<"40">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 14923}, {?attr_hp_max, 100, 65557}, {?attr_defence, 100, 5166}, {?attr_critrate, 100, 636}, {?attr_hitrate, 100, 447}, {?attr_aspd, 100, 55}, {?attr_dmg_magic, 100, 2070}]
        }
    };

get(101095) ->
    {ok, #item_base{
            id = 101095
            ,name = <<"45">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 20413}, {?attr_hp_max, 100, 93768}, {?attr_defence, 100, 7806}, {?attr_critrate, 100, 947}, {?attr_hitrate, 100, 623}, {?attr_aspd, 100, 60}, {?attr_dmg_magic, 100, 3106}]
        }
    };

get(101094) ->
    {ok, #item_base{
            id = 101094
            ,name = <<"50">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 26468}, {?attr_hp_max, 100, 124670}, {?attr_defence, 100, 10595}, {?attr_critrate, 100, 1300}, {?attr_hitrate, 100, 824}, {?attr_aspd, 100, 60}, {?attr_dmg_magic, 100, 4319}]
        }
    };

get(101093) ->
    {ok, #item_base{
            id = 101093
            ,name = <<"55">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 32610}, {?attr_hp_max, 100, 153557}, {?attr_defence, 100, 12817}, {?attr_critrate, 100, 1589}, {?attr_hitrate, 100, 993}, {?attr_aspd, 100, 65}, {?attr_dmg_magic, 100, 5759}]
        }
    };

get(101092) ->
    {ok, #item_base{
            id = 101092
            ,name = <<"60">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 38688}, {?attr_hp_max, 100, 190982}, {?attr_defence, 100, 16903}, {?attr_critrate, 100, 2114}, {?attr_hitrate, 100, 1253}, {?attr_aspd, 100, 73}, {?attr_dmg_magic, 100, 7065}]
        }
    };

get(102099) ->
    {ok, #item_base{
            id = 102099
            ,name = <<"30级绿色">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 1732}, {?attr_hp_max, 100, 7825}, {?attr_defence, 100, 1948}, {?attr_critrate, 100, 240}, {?attr_hitrate, 100, 184}, {?attr_aspd, 100, 45}, {?attr_dmg_magic, 100, 139}, {?attr_mp_max, 100, 703}, {?attr_evasion, 100, 27}, {?attr_tenacity, 100, 64}, {?attr_rst_all, 100, 280}, {?attr_js, 100, 77}]
        }
    };

get(102098) ->
    {ok, #item_base{
            id = 102098
            ,name = <<"31级绿色">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 1842}, {?attr_hp_max, 100, 8277}, {?attr_defence, 100, 2092}, {?attr_critrate, 100, 258}, {?attr_hitrate, 100, 196}, {?attr_aspd, 100, 45}, {?attr_dmg_magic, 100, 149}, {?attr_mp_max, 100, 743}, {?attr_evasion, 100, 30}, {?attr_tenacity, 100, 73}, {?attr_rst_all, 100, 303}, {?attr_js, 100, 83}]
        }
    };

get(102097) ->
    {ok, #item_base{
            id = 102097
            ,name = <<"32级绿色">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 1964}, {?attr_hp_max, 100, 8729}, {?attr_defence, 100, 2194}, {?attr_critrate, 100, 271}, {?attr_hitrate, 100, 207}, {?attr_aspd, 100, 45}, {?attr_dmg_magic, 100, 160}, {?attr_mp_max, 100, 775}, {?attr_evasion, 100, 31}, {?attr_tenacity, 100, 75}, {?attr_rst_all, 100, 312}, {?attr_js, 100, 85}]
        }
    };

get(102096) ->
    {ok, #item_base{
            id = 102096
            ,name = <<"33级绿色">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 2107}, {?attr_hp_max, 100, 9618}, {?attr_defence, 100, 2459}, {?attr_critrate, 100, 304}, {?attr_hitrate, 100, 225}, {?attr_aspd, 100, 45}, {?attr_dmg_magic, 100, 175}, {?attr_mp_max, 100, 822}, {?attr_evasion, 100, 36}, {?attr_tenacity, 100, 88}, {?attr_rst_all, 100, 340}, {?attr_js, 100, 95}]
        }
    };

get(102095) ->
    {ok, #item_base{
            id = 102095
            ,name = <<"34级绿色">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 2225}, {?attr_hp_max, 100, 10123}, {?attr_defence, 100, 2608}, {?attr_critrate, 100, 327}, {?attr_hitrate, 100, 239}, {?attr_aspd, 100, 45}, {?attr_dmg_magic, 100, 188}, {?attr_mp_max, 100, 865}, {?attr_evasion, 100, 42}, {?attr_tenacity, 100, 100}, {?attr_rst_all, 100, 369}, {?attr_js, 100, 102}]
        }
    };

get(102094) ->
    {ok, #item_base{
            id = 102094
            ,name = <<"35级绿色">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 2364}, {?attr_hp_max, 100, 11190}, {?attr_defence, 100, 2863}, {?attr_critrate, 100, 358}, {?attr_hitrate, 100, 255}, {?attr_aspd, 100, 50}, {?attr_dmg_magic, 100, 224}, {?attr_mp_max, 100, 915}, {?attr_evasion, 100, 49}, {?attr_tenacity, 100, 113}, {?attr_rst_all, 100, 423}, {?attr_js, 100, 113}]
        }
    };

get(102093) ->
    {ok, #item_base{
            id = 102093
            ,name = <<"36级绿色">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 2649}, {?attr_hp_max, 100, 13358}, {?attr_defence, 100, 3219}, {?attr_critrate, 100, 396}, {?attr_hitrate, 100, 282}, {?attr_aspd, 100, 50}, {?attr_dmg_magic, 100, 273}, {?attr_mp_max, 100, 976}, {?attr_evasion, 100, 63}, {?attr_tenacity, 100, 137}, {?attr_rst_all, 100, 612}, {?attr_js, 100, 130}]
        }
    };

get(102092) ->
    {ok, #item_base{
            id = 102092
            ,name = <<"37级绿色">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 3020}, {?attr_hp_max, 100, 14946}, {?attr_defence, 100, 3617}, {?attr_critrate, 100, 438}, {?attr_hitrate, 100, 310}, {?attr_aspd, 100, 50}, {?attr_dmg_magic, 100, 287}, {?attr_mp_max, 100, 1026}, {?attr_evasion, 100, 67}, {?attr_tenacity, 100, 147}, {?attr_rst_all, 100, 635}, {?attr_js, 100, 141}]
        }
    };

get(102091) ->
    {ok, #item_base{
            id = 102091
            ,name = <<"38级绿色">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 3386}, {?attr_hp_max, 100, 16264}, {?attr_defence, 100, 3965}, {?attr_critrate, 100, 480}, {?attr_hitrate, 100, 338}, {?attr_aspd, 100, 50}, {?attr_dmg_magic, 100, 302}, {?attr_mp_max, 100, 1076}, {?attr_evasion, 100, 75}, {?attr_tenacity, 100, 165}, {?attr_rst_all, 100, 674}, {?attr_js, 100, 152}]
        }
    };

get(102090) ->
    {ok, #item_base{
            id = 102090
            ,name = <<"39级绿色">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 3749}, {?attr_hp_max, 100, 17528}, {?attr_defence, 100, 4281}, {?attr_critrate, 100, 514}, {?attr_hitrate, 100, 364}, {?attr_aspd, 100, 50}, {?attr_dmg_magic, 100, 317}, {?attr_mp_max, 100, 1126}, {?attr_evasion, 100, 79}, {?attr_tenacity, 100, 175}, {?attr_rst_all, 100, 698}, {?attr_js, 100, 163}]
        }
    };

get(102089) ->
    {ok, #item_base{
            id = 102089
            ,name = <<"40级绿色">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 4044}, {?attr_hp_max, 100, 18614}, {?attr_defence, 100, 4584}, {?attr_critrate, 100, 550}, {?attr_hitrate, 100, 387}, {?attr_aspd, 100, 50}, {?attr_dmg_magic, 100, 323}, {?attr_mp_max, 100, 1177}, {?attr_evasion, 100, 87}, {?attr_tenacity, 100, 194}, {?attr_rst_all, 100, 737}, {?attr_js, 100, 174}]
        }
    };

get(101010) ->
    {ok, #item_base{
            id = 101010
            ,name = <<"毛睿睿棒棒糖">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = [{?attr_dmg, 100, 100000}, {?attr_hp_max, 100, 100000}, {?attr_defence, 100, 100000}, {?attr_critrate, 100, 100000}, {?attr_hitrate, 100, 100000}, {?attr_aspd, 100, 100000}, {?attr_dmg_magic, 100, 100000}]
        }
    };

get(101011) ->
    {ok, #item_base{
            id = 101011
            ,name = <<"忠诚之剑">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 276}, {?attr_critrate, 100, 27}, {?attr_hitrate, 100, 110}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 138}]
        }
    };

get(101021) ->
    {ok, #item_base{
            id = 101021
            ,name = <<"战痕之剑">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 414}, {?attr_critrate, 100, 41}, {?attr_hitrate, 100, 160}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 207}]
        }
    };

get(101022) ->
    {ok, #item_base{
            id = 101022
            ,name = <<"战痕之剑">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hitrate, 100, 0}]
        }
    };

get(101031) ->
    {ok, #item_base{
            id = 101031
            ,name = <<"誓约之剑">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 552}, {?attr_critrate, 100, 55}, {?attr_hitrate, 100, 220}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 276}]
        }
    };

get(101032) ->
    {ok, #item_base{
            id = 101032
            ,name = <<"誓约之剑">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 752}, {?attr_critrate, 100, 75}, {?attr_hitrate, 100, 300}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 376}]
        }
    };

get(101041) ->
    {ok, #item_base{
            id = 101041
            ,name = <<"审判之剑">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 690}, {?attr_critrate, 100, 69}, {?attr_hitrate, 100, 270}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 345}]
        }
    };

get(101042) ->
    {ok, #item_base{
            id = 101042
            ,name = <<"审判之剑">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 890}, {?attr_critrate, 100, 89}, {?attr_hitrate, 100, 350}, {?attr_aspd, 100, 14}, {?attr_dmg_magic, 100, 445}]
        }
    };

get(101043) ->
    {ok, #item_base{
            id = 101043
            ,name = <<"审判之剑">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1090}, {?attr_critrate, 100, 109}, {?attr_hitrate, 100, 430}, {?attr_aspd, 100, 17}, {?attr_dmg_magic, 100, 545}]
        }
    };

get(101051) ->
    {ok, #item_base{
            id = 101051
            ,name = <<"极昼之剑">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 828}, {?attr_critrate, 100, 82}, {?attr_hitrate, 100, 330}, {?attr_aspd, 100, 15}, {?attr_dmg_magic, 100, 414}]
        }
    };

get(101052) ->
    {ok, #item_base{
            id = 101052
            ,name = <<"极昼之剑">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1028}, {?attr_critrate, 100, 102}, {?attr_hitrate, 100, 410}, {?attr_aspd, 100, 17}, {?attr_dmg_magic, 100, 514}]
        }
    };

get(101053) ->
    {ok, #item_base{
            id = 101053
            ,name = <<"极昼之剑">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1228}, {?attr_critrate, 100, 122}, {?attr_hitrate, 100, 490}, {?attr_aspd, 100, 20}, {?attr_dmg_magic, 100, 614}]
        }
    };

get(101054) ->
    {ok, #item_base{
            id = 101054
            ,name = <<"极昼之剑">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1428}, {?attr_critrate, 100, 142}, {?attr_hitrate, 100, 570}, {?attr_aspd, 100, 22}, {?attr_dmg_magic, 100, 714}]
        }
    };

get(101061) ->
    {ok, #item_base{
            id = 101061
            ,name = <<"光明之剑">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 966}, {?attr_critrate, 100, 96}, {?attr_hitrate, 100, 380}, {?attr_aspd, 100, 17}, {?attr_dmg_magic, 100, 483}]
        }
    };

get(101062) ->
    {ok, #item_base{
            id = 101062
            ,name = <<"光明之剑">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1166}, {?attr_critrate, 100, 116}, {?attr_hitrate, 100, 460}, {?attr_aspd, 100, 19}, {?attr_dmg_magic, 100, 583}]
        }
    };

get(101063) ->
    {ok, #item_base{
            id = 101063
            ,name = <<"光明之剑">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1366}, {?attr_critrate, 100, 136}, {?attr_hitrate, 100, 540}, {?attr_aspd, 100, 22}, {?attr_dmg_magic, 100, 683}]
        }
    };

get(101064) ->
    {ok, #item_base{
            id = 101064
            ,name = <<"光明之剑">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1566}, {?attr_critrate, 100, 156}, {?attr_hitrate, 100, 620}, {?attr_aspd, 100, 24}, {?attr_dmg_magic, 100, 783}]
        }
    };

get(101065) ->
    {ok, #item_base{
            id = 101065
            ,name = <<"光明之剑">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1766}, {?attr_critrate, 100, 176}, {?attr_hitrate, 100, 700}, {?attr_aspd, 100, 27}, {?attr_dmg_magic, 100, 883}]
        }
    };

get(101071) ->
    {ok, #item_base{
            id = 101071
            ,name = <<"使命之剑">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1104}, {?attr_critrate, 100, 110}, {?attr_hitrate, 100, 440}, {?attr_aspd, 100, 20}, {?attr_dmg_magic, 100, 552}]
        }
    };

get(101072) ->
    {ok, #item_base{
            id = 101072
            ,name = <<"使命之剑">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1304}, {?attr_critrate, 100, 130}, {?attr_hitrate, 100, 520}, {?attr_aspd, 100, 22}, {?attr_dmg_magic, 100, 652}]
        }
    };

get(101073) ->
    {ok, #item_base{
            id = 101073
            ,name = <<"使命之剑">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1504}, {?attr_critrate, 100, 150}, {?attr_hitrate, 100, 600}, {?attr_aspd, 100, 25}, {?attr_dmg_magic, 100, 752}]
        }
    };

get(101074) ->
    {ok, #item_base{
            id = 101074
            ,name = <<"使命之剑">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1704}, {?attr_critrate, 100, 170}, {?attr_hitrate, 100, 680}, {?attr_aspd, 100, 27}, {?attr_dmg_magic, 100, 852}]
        }
    };

get(101075) ->
    {ok, #item_base{
            id = 101075
            ,name = <<"使命之剑">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1904}, {?attr_critrate, 100, 190}, {?attr_hitrate, 100, 760}, {?attr_aspd, 100, 30}, {?attr_dmg_magic, 100, 952}]
        }
    };

get(101076) ->
    {ok, #item_base{
            id = 101076
            ,name = <<"使命之剑">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 2104}, {?attr_critrate, 100, 210}, {?attr_hitrate, 100, 840}, {?attr_aspd, 100, 32}, {?attr_dmg_magic, 100, 1052}]
        }
    };

get(101111) ->
    {ok, #item_base{
            id = 101111
            ,name = <<"忠诚护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 414}, {?attr_defence, 100, 207}, {?attr_hitrate, 100, 110}, {?attr_evasion, 100, 33}, {?attr_rst_all, 100, 110}, {?attr_js, 100, 184}]
        }
    };

get(101121) ->
    {ok, #item_base{
            id = 101121
            ,name = <<"战痕护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 621}, {?attr_defence, 100, 310}, {?attr_hitrate, 100, 160}, {?attr_evasion, 100, 49}, {?attr_rst_all, 100, 165}, {?attr_js, 100, 276}]
        }
    };

get(101122) ->
    {ok, #item_base{
            id = 101122
            ,name = <<"战痕护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hitrate, 100, 0}]
        }
    };

get(101131) ->
    {ok, #item_base{
            id = 101131
            ,name = <<"誓约护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_hitrate, 100, 220}, {?attr_evasion, 100, 66}, {?attr_rst_all, 100, 220}, {?attr_js, 100, 368}]
        }
    };

get(101132) ->
    {ok, #item_base{
            id = 101132
            ,name = <<"誓约护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1128}, {?attr_defence, 100, 564}, {?attr_hitrate, 100, 300}, {?attr_evasion, 100, 90}, {?attr_rst_all, 100, 300}, {?attr_js, 100, 501}]
        }
    };

get(101141) ->
    {ok, #item_base{
            id = 101141
            ,name = <<"审判护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1035}, {?attr_defence, 100, 517}, {?attr_hitrate, 100, 270}, {?attr_evasion, 100, 82}, {?attr_rst_all, 100, 276}, {?attr_js, 100, 460}]
        }
    };

get(101142) ->
    {ok, #item_base{
            id = 101142
            ,name = <<"审判护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1335}, {?attr_defence, 100, 667}, {?attr_hitrate, 100, 350}, {?attr_evasion, 100, 106}, {?attr_rst_all, 100, 356}, {?attr_js, 100, 593}]
        }
    };

get(101143) ->
    {ok, #item_base{
            id = 101143
            ,name = <<"审判护腕">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1635}, {?attr_defence, 100, 817}, {?attr_hitrate, 100, 430}, {?attr_evasion, 100, 130}, {?attr_rst_all, 100, 436}, {?attr_js, 100, 726}]
        }
    };

get(101151) ->
    {ok, #item_base{
            id = 101151
            ,name = <<"极昼护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1242}, {?attr_defence, 100, 621}, {?attr_hitrate, 100, 330}, {?attr_evasion, 100, 99}, {?attr_rst_all, 100, 331}, {?attr_js, 100, 552}]
        }
    };

get(101152) ->
    {ok, #item_base{
            id = 101152
            ,name = <<"极昼护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1542}, {?attr_defence, 100, 771}, {?attr_hitrate, 100, 410}, {?attr_evasion, 100, 123}, {?attr_rst_all, 100, 411}, {?attr_js, 100, 685}]
        }
    };

get(101153) ->
    {ok, #item_base{
            id = 101153
            ,name = <<"极昼护腕">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1842}, {?attr_defence, 100, 921}, {?attr_hitrate, 100, 490}, {?attr_evasion, 100, 147}, {?attr_rst_all, 100, 491}, {?attr_js, 100, 818}]
        }
    };

get(101154) ->
    {ok, #item_base{
            id = 101154
            ,name = <<"极昼护腕">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2142}, {?attr_defence, 100, 1071}, {?attr_hitrate, 100, 570}, {?attr_evasion, 100, 171}, {?attr_rst_all, 100, 571}, {?attr_js, 100, 952}]
        }
    };

get(101161) ->
    {ok, #item_base{
            id = 101161
            ,name = <<"光明护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1449}, {?attr_defence, 100, 724}, {?attr_hitrate, 100, 380}, {?attr_evasion, 100, 115}, {?attr_rst_all, 100, 386}, {?attr_js, 100, 644}]
        }
    };

get(101162) ->
    {ok, #item_base{
            id = 101162
            ,name = <<"光明护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1749}, {?attr_defence, 100, 874}, {?attr_hitrate, 100, 460}, {?attr_evasion, 100, 139}, {?attr_rst_all, 100, 466}, {?attr_js, 100, 777}]
        }
    };

get(101163) ->
    {ok, #item_base{
            id = 101163
            ,name = <<"光明护腕">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2049}, {?attr_defence, 100, 1024}, {?attr_hitrate, 100, 540}, {?attr_evasion, 100, 163}, {?attr_rst_all, 100, 546}, {?attr_js, 100, 910}]
        }
    };

get(101164) ->
    {ok, #item_base{
            id = 101164
            ,name = <<"光明护腕">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2349}, {?attr_defence, 100, 1174}, {?attr_hitrate, 100, 620}, {?attr_evasion, 100, 187}, {?attr_rst_all, 100, 626}, {?attr_js, 100, 1044}]
        }
    };

get(101165) ->
    {ok, #item_base{
            id = 101165
            ,name = <<"光明护腕">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2649}, {?attr_defence, 100, 1324}, {?attr_hitrate, 100, 700}, {?attr_evasion, 100, 211}, {?attr_rst_all, 100, 706}, {?attr_js, 100, 1177}]
        }
    };

get(101171) ->
    {ok, #item_base{
            id = 101171
            ,name = <<"使命护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_hitrate, 100, 440}, {?attr_evasion, 100, 132}, {?attr_rst_all, 100, 441}, {?attr_js, 100, 736}]
        }
    };

get(101172) ->
    {ok, #item_base{
            id = 101172
            ,name = <<"使命护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1956}, {?attr_defence, 100, 978}, {?attr_hitrate, 100, 520}, {?attr_evasion, 100, 156}, {?attr_rst_all, 100, 521}, {?attr_js, 100, 869}]
        }
    };

get(101173) ->
    {ok, #item_base{
            id = 101173
            ,name = <<"使命护腕">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2256}, {?attr_defence, 100, 1128}, {?attr_hitrate, 100, 600}, {?attr_evasion, 100, 180}, {?attr_rst_all, 100, 601}, {?attr_js, 100, 1002}]
        }
    };

get(101174) ->
    {ok, #item_base{
            id = 101174
            ,name = <<"使命护腕">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2556}, {?attr_defence, 100, 1278}, {?attr_hitrate, 100, 680}, {?attr_evasion, 100, 204}, {?attr_rst_all, 100, 681}, {?attr_js, 100, 1136}]
        }
    };

get(101175) ->
    {ok, #item_base{
            id = 101175
            ,name = <<"使命护腕">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_hitrate, 100, 760}, {?attr_evasion, 100, 228}, {?attr_rst_all, 100, 761}, {?attr_js, 100, 1269}]
        }
    };

get(101176) ->
    {ok, #item_base{
            id = 101176
            ,name = <<"使命护腕">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3156}, {?attr_defence, 100, 1578}, {?attr_hitrate, 100, 840}, {?attr_evasion, 100, 252}, {?attr_rst_all, 100, 841}, {?attr_js, 100, 1402}]
        }
    };

get(101211) ->
    {ok, #item_base{
            id = 101211
            ,name = <<"忠诚铠甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 552}, {?attr_defence, 100, 276}, {?attr_hitrate, 100, 110}, {?attr_tenacity, 100, 110}, {?attr_rst_all, 100, 82}]
        }
    };

get(101221) ->
    {ok, #item_base{
            id = 101221
            ,name = <<"战痕铠甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_hitrate, 100, 160}, {?attr_tenacity, 100, 165}, {?attr_rst_all, 100, 124}]
        }
    };

get(101222) ->
    {ok, #item_base{
            id = 101222
            ,name = <<"战痕铠甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hitrate, 100, 0}]
        }
    };

get(101231) ->
    {ok, #item_base{
            id = 101231
            ,name = <<"誓约铠甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1104}, {?attr_defence, 100, 552}, {?attr_hitrate, 100, 220}, {?attr_tenacity, 100, 220}, {?attr_rst_all, 100, 165}]
        }
    };

get(101232) ->
    {ok, #item_base{
            id = 101232
            ,name = <<"誓约铠甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1504}, {?attr_defence, 100, 752}, {?attr_hitrate, 100, 300}, {?attr_tenacity, 100, 300}, {?attr_rst_all, 100, 225}]
        }
    };

get(101241) ->
    {ok, #item_base{
            id = 101241
            ,name = <<"审判铠甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1380}, {?attr_defence, 100, 690}, {?attr_hitrate, 100, 270}, {?attr_tenacity, 100, 276}, {?attr_rst_all, 100, 207}]
        }
    };

get(101242) ->
    {ok, #item_base{
            id = 101242
            ,name = <<"审判铠甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1780}, {?attr_defence, 100, 890}, {?attr_hitrate, 100, 350}, {?attr_tenacity, 100, 356}, {?attr_rst_all, 100, 267}]
        }
    };

get(101243) ->
    {ok, #item_base{
            id = 101243
            ,name = <<"审判铠甲">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2180}, {?attr_defence, 100, 1090}, {?attr_hitrate, 100, 430}, {?attr_tenacity, 100, 436}, {?attr_rst_all, 100, 327}]
        }
    };

get(101251) ->
    {ok, #item_base{
            id = 101251
            ,name = <<"极昼铠甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_hitrate, 100, 330}, {?attr_tenacity, 100, 331}, {?attr_rst_all, 100, 248}]
        }
    };

get(101252) ->
    {ok, #item_base{
            id = 101252
            ,name = <<"极昼铠甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2056}, {?attr_defence, 100, 1028}, {?attr_hitrate, 100, 410}, {?attr_tenacity, 100, 411}, {?attr_rst_all, 100, 308}]
        }
    };

get(101253) ->
    {ok, #item_base{
            id = 101253
            ,name = <<"极昼铠甲">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2456}, {?attr_defence, 100, 1228}, {?attr_hitrate, 100, 490}, {?attr_tenacity, 100, 491}, {?attr_rst_all, 100, 368}]
        }
    };

get(101254) ->
    {ok, #item_base{
            id = 101254
            ,name = <<"极昼铠甲">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_hitrate, 100, 570}, {?attr_tenacity, 100, 571}, {?attr_rst_all, 100, 428}]
        }
    };

get(101261) ->
    {ok, #item_base{
            id = 101261
            ,name = <<"光明铠甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1932}, {?attr_defence, 100, 966}, {?attr_hitrate, 100, 380}, {?attr_tenacity, 100, 386}, {?attr_rst_all, 100, 289}]
        }
    };

get(101262) ->
    {ok, #item_base{
            id = 101262
            ,name = <<"光明铠甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2332}, {?attr_defence, 100, 1166}, {?attr_hitrate, 100, 460}, {?attr_tenacity, 100, 466}, {?attr_rst_all, 100, 349}]
        }
    };

get(101263) ->
    {ok, #item_base{
            id = 101263
            ,name = <<"光明铠甲">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2732}, {?attr_defence, 100, 1366}, {?attr_hitrate, 100, 540}, {?attr_tenacity, 100, 546}, {?attr_rst_all, 100, 409}]
        }
    };

get(101264) ->
    {ok, #item_base{
            id = 101264
            ,name = <<"光明铠甲">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3132}, {?attr_defence, 100, 1566}, {?attr_hitrate, 100, 620}, {?attr_tenacity, 100, 626}, {?attr_rst_all, 100, 469}]
        }
    };

get(101265) ->
    {ok, #item_base{
            id = 101265
            ,name = <<"光明铠甲">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3532}, {?attr_defence, 100, 1766}, {?attr_hitrate, 100, 700}, {?attr_tenacity, 100, 706}, {?attr_rst_all, 100, 529}]
        }
    };

get(101271) ->
    {ok, #item_base{
            id = 101271
            ,name = <<"使命铠甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2208}, {?attr_defence, 100, 1104}, {?attr_hitrate, 100, 440}, {?attr_tenacity, 100, 441}, {?attr_rst_all, 100, 331}]
        }
    };

get(101272) ->
    {ok, #item_base{
            id = 101272
            ,name = <<"使命铠甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2608}, {?attr_defence, 100, 1304}, {?attr_hitrate, 100, 520}, {?attr_tenacity, 100, 521}, {?attr_rst_all, 100, 391}]
        }
    };

get(101273) ->
    {ok, #item_base{
            id = 101273
            ,name = <<"使命铠甲">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3008}, {?attr_defence, 100, 1504}, {?attr_hitrate, 100, 600}, {?attr_tenacity, 100, 601}, {?attr_rst_all, 100, 451}]
        }
    };

get(101274) ->
    {ok, #item_base{
            id = 101274
            ,name = <<"使命铠甲">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3408}, {?attr_defence, 100, 1704}, {?attr_hitrate, 100, 680}, {?attr_tenacity, 100, 681}, {?attr_rst_all, 100, 511}]
        }
    };

get(101275) ->
    {ok, #item_base{
            id = 101275
            ,name = <<"使命铠甲">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3808}, {?attr_defence, 100, 1904}, {?attr_hitrate, 100, 760}, {?attr_tenacity, 100, 761}, {?attr_rst_all, 100, 571}]
        }
    };

get(101276) ->
    {ok, #item_base{
            id = 101276
            ,name = <<"使命铠甲">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 4208}, {?attr_defence, 100, 2104}, {?attr_hitrate, 100, 840}, {?attr_tenacity, 100, 841}, {?attr_rst_all, 100, 631}]
        }
    };

get(101311) ->
    {ok, #item_base{
            id = 101311
            ,name = <<"忠诚腿甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 552}, {?attr_defence, 100, 276}, {?attr_hitrate, 100, 50}, {?attr_tenacity, 100, 82}, {?attr_rst_all, 100, 82}]
        }
    };

get(101321) ->
    {ok, #item_base{
            id = 101321
            ,name = <<"战痕腿甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_hitrate, 100, 50}, {?attr_tenacity, 100, 124}, {?attr_rst_all, 100, 124}]
        }
    };

get(101322) ->
    {ok, #item_base{
            id = 101322
            ,name = <<"战痕腿甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hitrate, 100, 50}]
        }
    };

get(101331) ->
    {ok, #item_base{
            id = 101331
            ,name = <<"誓约腿甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1104}, {?attr_defence, 100, 552}, {?attr_tenacity, 100, 165}, {?attr_rst_all, 100, 165}]
        }
    };

get(101332) ->
    {ok, #item_base{
            id = 101332
            ,name = <<"誓约腿甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1504}, {?attr_defence, 100, 752}, {?attr_tenacity, 100, 225}, {?attr_rst_all, 100, 225}]
        }
    };

get(101341) ->
    {ok, #item_base{
            id = 101341
            ,name = <<"审判腿甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1380}, {?attr_defence, 100, 690}, {?attr_tenacity, 100, 207}, {?attr_rst_all, 100, 207}]
        }
    };

get(101342) ->
    {ok, #item_base{
            id = 101342
            ,name = <<"审判腿甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1780}, {?attr_defence, 100, 890}, {?attr_tenacity, 100, 267}, {?attr_rst_all, 100, 267}]
        }
    };

get(101343) ->
    {ok, #item_base{
            id = 101343
            ,name = <<"审判腿甲">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2180}, {?attr_defence, 100, 1090}, {?attr_tenacity, 100, 327}, {?attr_rst_all, 100, 327}]
        }
    };

get(101351) ->
    {ok, #item_base{
            id = 101351
            ,name = <<"极昼腿甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_tenacity, 100, 248}, {?attr_rst_all, 100, 248}]
        }
    };

get(101352) ->
    {ok, #item_base{
            id = 101352
            ,name = <<"极昼腿甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2056}, {?attr_defence, 100, 1028}, {?attr_tenacity, 100, 308}, {?attr_rst_all, 100, 308}]
        }
    };

get(101353) ->
    {ok, #item_base{
            id = 101353
            ,name = <<"极昼腿甲">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2456}, {?attr_defence, 100, 1228}, {?attr_tenacity, 100, 368}, {?attr_rst_all, 100, 368}]
        }
    };

get(101354) ->
    {ok, #item_base{
            id = 101354
            ,name = <<"极昼腿甲">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_tenacity, 100, 428}, {?attr_rst_all, 100, 428}]
        }
    };

get(101361) ->
    {ok, #item_base{
            id = 101361
            ,name = <<"光明腿甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1932}, {?attr_defence, 100, 966}, {?attr_tenacity, 100, 289}, {?attr_rst_all, 100, 289}]
        }
    };

get(101362) ->
    {ok, #item_base{
            id = 101362
            ,name = <<"光明腿甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2332}, {?attr_defence, 100, 1166}, {?attr_tenacity, 100, 349}, {?attr_rst_all, 100, 349}]
        }
    };

get(101363) ->
    {ok, #item_base{
            id = 101363
            ,name = <<"光明腿甲">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2732}, {?attr_defence, 100, 1366}, {?attr_tenacity, 100, 409}, {?attr_rst_all, 100, 409}]
        }
    };

get(101364) ->
    {ok, #item_base{
            id = 101364
            ,name = <<"光明腿甲">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3132}, {?attr_defence, 100, 1566}, {?attr_tenacity, 100, 469}, {?attr_rst_all, 100, 469}]
        }
    };

get(101365) ->
    {ok, #item_base{
            id = 101365
            ,name = <<"光明腿甲">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3532}, {?attr_defence, 100, 1766}, {?attr_tenacity, 100, 529}, {?attr_rst_all, 100, 529}]
        }
    };

get(101371) ->
    {ok, #item_base{
            id = 101371
            ,name = <<"使命腿甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2208}, {?attr_defence, 100, 1104}, {?attr_tenacity, 100, 331}, {?attr_rst_all, 100, 331}]
        }
    };

get(101372) ->
    {ok, #item_base{
            id = 101372
            ,name = <<"使命腿甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2608}, {?attr_defence, 100, 1304}, {?attr_tenacity, 100, 391}, {?attr_rst_all, 100, 391}]
        }
    };

get(101373) ->
    {ok, #item_base{
            id = 101373
            ,name = <<"使命腿甲">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3008}, {?attr_defence, 100, 1504}, {?attr_tenacity, 100, 451}, {?attr_rst_all, 100, 451}]
        }
    };

get(101374) ->
    {ok, #item_base{
            id = 101374
            ,name = <<"使命腿甲">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3408}, {?attr_defence, 100, 1704}, {?attr_tenacity, 100, 511}, {?attr_rst_all, 100, 511}]
        }
    };

get(101375) ->
    {ok, #item_base{
            id = 101375
            ,name = <<"使命腿甲">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3808}, {?attr_defence, 100, 1904}, {?attr_tenacity, 100, 571}, {?attr_rst_all, 100, 571}]
        }
    };

get(101376) ->
    {ok, #item_base{
            id = 101376
            ,name = <<"使命腿甲">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 4208}, {?attr_defence, 100, 2104}, {?attr_tenacity, 100, 631}, {?attr_rst_all, 100, 631}]
        }
    };

get(101411) ->
    {ok, #item_base{
            id = 101411
            ,name = <<"忠诚战靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 414}, {?attr_defence, 100, 207}, {?attr_tenacity, 100, 82}, {?attr_rst_all, 100, 82}]
        }
    };

get(101421) ->
    {ok, #item_base{
            id = 101421
            ,name = <<"战痕战靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 621}, {?attr_defence, 100, 310}, {?attr_tenacity, 100, 124}, {?attr_rst_all, 100, 124}]
        }
    };

get(101422) ->
    {ok, #item_base{
            id = 101422
            ,name = <<"战痕战靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = []
        }
    };

get(101431) ->
    {ok, #item_base{
            id = 101431
            ,name = <<"誓约战靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_tenacity, 100, 165}, {?attr_rst_all, 100, 165}]
        }
    };

get(101432) ->
    {ok, #item_base{
            id = 101432
            ,name = <<"誓约战靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1128}, {?attr_defence, 100, 564}, {?attr_tenacity, 100, 225}, {?attr_rst_all, 100, 225}]
        }
    };

get(101441) ->
    {ok, #item_base{
            id = 101441
            ,name = <<"审判战靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1035}, {?attr_defence, 100, 517}, {?attr_tenacity, 100, 207}, {?attr_rst_all, 100, 207}]
        }
    };

get(101442) ->
    {ok, #item_base{
            id = 101442
            ,name = <<"审判战靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1335}, {?attr_defence, 100, 667}, {?attr_tenacity, 100, 267}, {?attr_rst_all, 100, 267}]
        }
    };

get(101443) ->
    {ok, #item_base{
            id = 101443
            ,name = <<"审判战靴">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1635}, {?attr_defence, 100, 817}, {?attr_tenacity, 100, 327}, {?attr_rst_all, 100, 327}]
        }
    };

get(101451) ->
    {ok, #item_base{
            id = 101451
            ,name = <<"极昼战靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1242}, {?attr_defence, 100, 621}, {?attr_tenacity, 100, 248}, {?attr_rst_all, 100, 248}]
        }
    };

get(101452) ->
    {ok, #item_base{
            id = 101452
            ,name = <<"极昼战靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1542}, {?attr_defence, 100, 771}, {?attr_tenacity, 100, 308}, {?attr_rst_all, 100, 308}]
        }
    };

get(101453) ->
    {ok, #item_base{
            id = 101453
            ,name = <<"极昼战靴">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1842}, {?attr_defence, 100, 921}, {?attr_tenacity, 100, 368}, {?attr_rst_all, 100, 368}]
        }
    };

get(101454) ->
    {ok, #item_base{
            id = 101454
            ,name = <<"极昼战靴">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2142}, {?attr_defence, 100, 1071}, {?attr_tenacity, 100, 428}, {?attr_rst_all, 100, 428}]
        }
    };

get(101461) ->
    {ok, #item_base{
            id = 101461
            ,name = <<"光明战靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1449}, {?attr_defence, 100, 724}, {?attr_tenacity, 100, 289}, {?attr_rst_all, 100, 289}]
        }
    };

get(101462) ->
    {ok, #item_base{
            id = 101462
            ,name = <<"光明战靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1749}, {?attr_defence, 100, 874}, {?attr_tenacity, 100, 349}, {?attr_rst_all, 100, 349}]
        }
    };

get(101463) ->
    {ok, #item_base{
            id = 101463
            ,name = <<"光明战靴">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2049}, {?attr_defence, 100, 1024}, {?attr_tenacity, 100, 409}, {?attr_rst_all, 100, 409}]
        }
    };

get(101464) ->
    {ok, #item_base{
            id = 101464
            ,name = <<"光明战靴">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2349}, {?attr_defence, 100, 1174}, {?attr_tenacity, 100, 469}, {?attr_rst_all, 100, 469}]
        }
    };

get(101465) ->
    {ok, #item_base{
            id = 101465
            ,name = <<"光明战靴">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2649}, {?attr_defence, 100, 1324}, {?attr_tenacity, 100, 529}, {?attr_rst_all, 100, 529}]
        }
    };

get(101471) ->
    {ok, #item_base{
            id = 101471
            ,name = <<"使命战靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_tenacity, 100, 331}, {?attr_rst_all, 100, 331}]
        }
    };

get(101472) ->
    {ok, #item_base{
            id = 101472
            ,name = <<"使命战靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1956}, {?attr_defence, 100, 978}, {?attr_tenacity, 100, 391}, {?attr_rst_all, 100, 391}]
        }
    };

get(101473) ->
    {ok, #item_base{
            id = 101473
            ,name = <<"使命战靴">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2256}, {?attr_defence, 100, 1128}, {?attr_tenacity, 100, 451}, {?attr_rst_all, 100, 451}]
        }
    };

get(101474) ->
    {ok, #item_base{
            id = 101474
            ,name = <<"使命战靴">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2556}, {?attr_defence, 100, 1278}, {?attr_tenacity, 100, 511}, {?attr_rst_all, 100, 511}]
        }
    };

get(101475) ->
    {ok, #item_base{
            id = 101475
            ,name = <<"使命战靴">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_tenacity, 100, 571}, {?attr_rst_all, 100, 571}]
        }
    };

get(101476) ->
    {ok, #item_base{
            id = 101476
            ,name = <<"使命战靴">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3156}, {?attr_defence, 100, 1578}, {?attr_tenacity, 100, 631}, {?attr_rst_all, 100, 631}]
        }
    };

get(101511) ->
    {ok, #item_base{
            id = 101511
            ,name = <<"忠诚腰甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 414}, {?attr_defence, 100, 207}, {?attr_evasion, 100, 44}, {?attr_rst_all, 100, 82}]
        }
    };

get(101521) ->
    {ok, #item_base{
            id = 101521
            ,name = <<"战痕腰甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 621}, {?attr_defence, 100, 310}, {?attr_evasion, 100, 66}, {?attr_rst_all, 100, 124}]
        }
    };

get(101522) ->
    {ok, #item_base{
            id = 101522
            ,name = <<"战痕腰甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = []
        }
    };

get(101531) ->
    {ok, #item_base{
            id = 101531
            ,name = <<"誓约腰甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_evasion, 100, 88}, {?attr_rst_all, 100, 165}]
        }
    };

get(101532) ->
    {ok, #item_base{
            id = 101532
            ,name = <<"誓约腰甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1128}, {?attr_defence, 100, 564}, {?attr_evasion, 100, 120}, {?attr_rst_all, 100, 225}]
        }
    };

get(101541) ->
    {ok, #item_base{
            id = 101541
            ,name = <<"审判腰甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1035}, {?attr_defence, 100, 517}, {?attr_evasion, 100, 110}, {?attr_rst_all, 100, 207}]
        }
    };

get(101542) ->
    {ok, #item_base{
            id = 101542
            ,name = <<"审判腰甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1335}, {?attr_defence, 100, 667}, {?attr_evasion, 100, 142}, {?attr_rst_all, 100, 267}]
        }
    };

get(101543) ->
    {ok, #item_base{
            id = 101543
            ,name = <<"审判腰甲">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1635}, {?attr_defence, 100, 817}, {?attr_evasion, 100, 174}, {?attr_rst_all, 100, 327}]
        }
    };

get(101551) ->
    {ok, #item_base{
            id = 101551
            ,name = <<"极昼腰甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1242}, {?attr_defence, 100, 621}, {?attr_evasion, 100, 132}, {?attr_rst_all, 100, 248}]
        }
    };

get(101552) ->
    {ok, #item_base{
            id = 101552
            ,name = <<"极昼腰甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1542}, {?attr_defence, 100, 771}, {?attr_evasion, 100, 164}, {?attr_rst_all, 100, 308}]
        }
    };

get(101553) ->
    {ok, #item_base{
            id = 101553
            ,name = <<"极昼腰甲">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1842}, {?attr_defence, 100, 921}, {?attr_evasion, 100, 196}, {?attr_rst_all, 100, 368}]
        }
    };

get(101554) ->
    {ok, #item_base{
            id = 101554
            ,name = <<"极昼腰甲">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2142}, {?attr_defence, 100, 1071}, {?attr_evasion, 100, 228}, {?attr_rst_all, 100, 428}]
        }
    };

get(101561) ->
    {ok, #item_base{
            id = 101561
            ,name = <<"光明腰甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1449}, {?attr_defence, 100, 724}, {?attr_evasion, 100, 154}, {?attr_rst_all, 100, 289}]
        }
    };

get(101562) ->
    {ok, #item_base{
            id = 101562
            ,name = <<"光明腰甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1749}, {?attr_defence, 100, 874}, {?attr_evasion, 100, 186}, {?attr_rst_all, 100, 349}]
        }
    };

get(101563) ->
    {ok, #item_base{
            id = 101563
            ,name = <<"光明腰甲">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2049}, {?attr_defence, 100, 1024}, {?attr_evasion, 100, 218}, {?attr_rst_all, 100, 409}]
        }
    };

get(101564) ->
    {ok, #item_base{
            id = 101564
            ,name = <<"光明腰甲">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2349}, {?attr_defence, 100, 1174}, {?attr_evasion, 100, 250}, {?attr_rst_all, 100, 469}]
        }
    };

get(101565) ->
    {ok, #item_base{
            id = 101565
            ,name = <<"光明腰甲">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2649}, {?attr_defence, 100, 1324}, {?attr_evasion, 100, 282}, {?attr_rst_all, 100, 529}]
        }
    };

get(101571) ->
    {ok, #item_base{
            id = 101571
            ,name = <<"使命腰甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_evasion, 100, 176}, {?attr_rst_all, 100, 331}]
        }
    };

get(101572) ->
    {ok, #item_base{
            id = 101572
            ,name = <<"使命腰甲">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1956}, {?attr_defence, 100, 978}, {?attr_evasion, 100, 208}, {?attr_rst_all, 100, 391}]
        }
    };

get(101573) ->
    {ok, #item_base{
            id = 101573
            ,name = <<"使命腰甲">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2256}, {?attr_defence, 100, 1128}, {?attr_evasion, 100, 240}, {?attr_rst_all, 100, 451}]
        }
    };

get(101574) ->
    {ok, #item_base{
            id = 101574
            ,name = <<"使命腰甲">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2556}, {?attr_defence, 100, 1278}, {?attr_evasion, 100, 272}, {?attr_rst_all, 100, 511}]
        }
    };

get(101575) ->
    {ok, #item_base{
            id = 101575
            ,name = <<"使命腰甲">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_evasion, 100, 304}, {?attr_rst_all, 100, 571}]
        }
    };

get(101576) ->
    {ok, #item_base{
            id = 101576
            ,name = <<"使命腰甲">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3156}, {?attr_defence, 100, 1578}, {?attr_evasion, 100, 336}, {?attr_rst_all, 100, 631}]
        }
    };

get(101611) ->
    {ok, #item_base{
            id = 101611
            ,name = <<"忠诚护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 414}, {?attr_defence, 100, 207}, {?attr_evasion, 100, 33}, {?attr_rst_all, 100, 110}, {?attr_js, 100, 184}]
        }
    };

get(101621) ->
    {ok, #item_base{
            id = 101621
            ,name = <<"战痕护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 621}, {?attr_defence, 100, 310}, {?attr_evasion, 100, 49}, {?attr_rst_all, 100, 165}, {?attr_js, 100, 276}]
        }
    };

get(101622) ->
    {ok, #item_base{
            id = 101622
            ,name = <<"战痕护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = []
        }
    };

get(101631) ->
    {ok, #item_base{
            id = 101631
            ,name = <<"誓约护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_evasion, 100, 66}, {?attr_rst_all, 100, 220}, {?attr_js, 100, 368}]
        }
    };

get(101632) ->
    {ok, #item_base{
            id = 101632
            ,name = <<"誓约护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1128}, {?attr_defence, 100, 564}, {?attr_evasion, 100, 90}, {?attr_rst_all, 100, 300}, {?attr_js, 100, 501}]
        }
    };

get(101641) ->
    {ok, #item_base{
            id = 101641
            ,name = <<"审判护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1035}, {?attr_defence, 100, 517}, {?attr_evasion, 100, 82}, {?attr_rst_all, 100, 276}, {?attr_js, 100, 460}]
        }
    };

get(101642) ->
    {ok, #item_base{
            id = 101642
            ,name = <<"审判护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1335}, {?attr_defence, 100, 667}, {?attr_evasion, 100, 106}, {?attr_rst_all, 100, 356}, {?attr_js, 100, 593}]
        }
    };

get(101643) ->
    {ok, #item_base{
            id = 101643
            ,name = <<"审判护手">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1635}, {?attr_defence, 100, 817}, {?attr_evasion, 100, 130}, {?attr_rst_all, 100, 436}, {?attr_js, 100, 726}]
        }
    };

get(101651) ->
    {ok, #item_base{
            id = 101651
            ,name = <<"极昼护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1242}, {?attr_defence, 100, 621}, {?attr_evasion, 100, 99}, {?attr_rst_all, 100, 331}, {?attr_js, 100, 552}]
        }
    };

get(101652) ->
    {ok, #item_base{
            id = 101652
            ,name = <<"极昼护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1542}, {?attr_defence, 100, 771}, {?attr_evasion, 100, 123}, {?attr_rst_all, 100, 411}, {?attr_js, 100, 685}]
        }
    };

get(101653) ->
    {ok, #item_base{
            id = 101653
            ,name = <<"极昼护手">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1842}, {?attr_defence, 100, 921}, {?attr_evasion, 100, 147}, {?attr_rst_all, 100, 491}, {?attr_js, 100, 818}]
        }
    };

get(101654) ->
    {ok, #item_base{
            id = 101654
            ,name = <<"极昼护手">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2142}, {?attr_defence, 100, 1071}, {?attr_evasion, 100, 171}, {?attr_rst_all, 100, 571}, {?attr_js, 100, 952}]
        }
    };

get(101661) ->
    {ok, #item_base{
            id = 101661
            ,name = <<"光明护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1449}, {?attr_defence, 100, 724}, {?attr_evasion, 100, 115}, {?attr_rst_all, 100, 386}, {?attr_js, 100, 644}]
        }
    };

get(101662) ->
    {ok, #item_base{
            id = 101662
            ,name = <<"光明护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1749}, {?attr_defence, 100, 874}, {?attr_evasion, 100, 139}, {?attr_rst_all, 100, 466}, {?attr_js, 100, 777}]
        }
    };

get(101663) ->
    {ok, #item_base{
            id = 101663
            ,name = <<"光明护手">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2049}, {?attr_defence, 100, 1024}, {?attr_evasion, 100, 163}, {?attr_rst_all, 100, 546}, {?attr_js, 100, 910}]
        }
    };

get(101664) ->
    {ok, #item_base{
            id = 101664
            ,name = <<"光明护手">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2349}, {?attr_defence, 100, 1174}, {?attr_evasion, 100, 187}, {?attr_rst_all, 100, 626}, {?attr_js, 100, 1044}]
        }
    };

get(101665) ->
    {ok, #item_base{
            id = 101665
            ,name = <<"光明护手">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2649}, {?attr_defence, 100, 1324}, {?attr_evasion, 100, 211}, {?attr_rst_all, 100, 706}, {?attr_js, 100, 1177}]
        }
    };

get(101671) ->
    {ok, #item_base{
            id = 101671
            ,name = <<"使命护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_evasion, 100, 132}, {?attr_rst_all, 100, 441}, {?attr_js, 100, 736}]
        }
    };

get(101672) ->
    {ok, #item_base{
            id = 101672
            ,name = <<"使命护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 1956}, {?attr_defence, 100, 978}, {?attr_evasion, 100, 156}, {?attr_rst_all, 100, 521}, {?attr_js, 100, 869}]
        }
    };

get(101673) ->
    {ok, #item_base{
            id = 101673
            ,name = <<"使命护手">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2256}, {?attr_defence, 100, 1128}, {?attr_evasion, 100, 180}, {?attr_rst_all, 100, 601}, {?attr_js, 100, 1002}]
        }
    };

get(101674) ->
    {ok, #item_base{
            id = 101674
            ,name = <<"使命护手">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2556}, {?attr_defence, 100, 1278}, {?attr_evasion, 100, 204}, {?attr_rst_all, 100, 681}, {?attr_js, 100, 1136}]
        }
    };

get(101675) ->
    {ok, #item_base{
            id = 101675
            ,name = <<"使命护手">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_evasion, 100, 228}, {?attr_rst_all, 100, 761}, {?attr_js, 100, 1269}]
        }
    };

get(101676) ->
    {ok, #item_base{
            id = 101676
            ,name = <<"使命护手">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 3156}, {?attr_defence, 100, 1578}, {?attr_evasion, 100, 252}, {?attr_rst_all, 100, 841}, {?attr_js, 100, 1402}]
        }
    };

get(101711) ->
    {ok, #item_base{
            id = 101711
            ,name = <<"忠诚护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 138}, {?attr_critrate, 100, 82}, {?attr_dmg_magic, 100, 69}]
        }
    };

get(101721) ->
    {ok, #item_base{
            id = 101721
            ,name = <<"战痕护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 207}, {?attr_critrate, 100, 124}, {?attr_aspd, 100, 3}, {?attr_dmg_magic, 100, 103}, {?attr_js, 100, 276}]
        }
    };

get(101722) ->
    {ok, #item_base{
            id = 101722
            ,name = <<"战痕护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = []
        }
    };

get(101731) ->
    {ok, #item_base{
            id = 101731
            ,name = <<"誓约护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 276}, {?attr_critrate, 100, 165}, {?attr_aspd, 100, 4}, {?attr_dmg_magic, 100, 138}, {?attr_js, 100, 368}]
        }
    };

get(101732) ->
    {ok, #item_base{
            id = 101732
            ,name = <<"誓约护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 376}, {?attr_critrate, 100, 225}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 188}, {?attr_js, 100, 501}]
        }
    };

get(101741) ->
    {ok, #item_base{
            id = 101741
            ,name = <<"审判护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 345}, {?attr_critrate, 100, 207}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 172}, {?attr_js, 100, 460}]
        }
    };

get(101742) ->
    {ok, #item_base{
            id = 101742
            ,name = <<"审判护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 445}, {?attr_critrate, 100, 267}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 222}, {?attr_js, 100, 593}]
        }
    };

get(101743) ->
    {ok, #item_base{
            id = 101743
            ,name = <<"审判护符">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 545}, {?attr_critrate, 100, 327}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 272}, {?attr_js, 100, 726}]
        }
    };

get(101751) ->
    {ok, #item_base{
            id = 101751
            ,name = <<"极昼护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 414}, {?attr_critrate, 100, 248}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 207}, {?attr_js, 100, 552}]
        }
    };

get(101752) ->
    {ok, #item_base{
            id = 101752
            ,name = <<"极昼护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 514}, {?attr_critrate, 100, 308}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 257}, {?attr_js, 100, 685}]
        }
    };

get(101753) ->
    {ok, #item_base{
            id = 101753
            ,name = <<"极昼护符">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 614}, {?attr_critrate, 100, 368}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 307}, {?attr_js, 100, 818}]
        }
    };

get(101754) ->
    {ok, #item_base{
            id = 101754
            ,name = <<"极昼护符">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 714}, {?attr_critrate, 100, 428}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 357}, {?attr_js, 100, 952}]
        }
    };

get(101761) ->
    {ok, #item_base{
            id = 101761
            ,name = <<"光明护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 483}, {?attr_critrate, 100, 289}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 241}, {?attr_js, 100, 644}]
        }
    };

get(101762) ->
    {ok, #item_base{
            id = 101762
            ,name = <<"光明护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 583}, {?attr_critrate, 100, 349}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 291}, {?attr_js, 100, 777}]
        }
    };

get(101763) ->
    {ok, #item_base{
            id = 101763
            ,name = <<"光明护符">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 683}, {?attr_critrate, 100, 409}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 341}, {?attr_js, 100, 910}]
        }
    };

get(101764) ->
    {ok, #item_base{
            id = 101764
            ,name = <<"光明护符">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 783}, {?attr_critrate, 100, 469}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 391}, {?attr_js, 100, 1044}]
        }
    };

get(101765) ->
    {ok, #item_base{
            id = 101765
            ,name = <<"光明护符">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 883}, {?attr_critrate, 100, 529}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 441}, {?attr_js, 100, 1177}]
        }
    };

get(101771) ->
    {ok, #item_base{
            id = 101771
            ,name = <<"使命护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 552}, {?attr_critrate, 100, 331}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 276}, {?attr_js, 100, 736}]
        }
    };

get(101772) ->
    {ok, #item_base{
            id = 101772
            ,name = <<"使命护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 652}, {?attr_critrate, 100, 391}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 326}, {?attr_js, 100, 869}]
        }
    };

get(101773) ->
    {ok, #item_base{
            id = 101773
            ,name = <<"使命护符">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 752}, {?attr_critrate, 100, 451}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 376}, {?attr_js, 100, 1002}]
        }
    };

get(101774) ->
    {ok, #item_base{
            id = 101774
            ,name = <<"使命护符">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 852}, {?attr_critrate, 100, 511}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 426}, {?attr_js, 100, 1136}]
        }
    };

get(101775) ->
    {ok, #item_base{
            id = 101775
            ,name = <<"使命护符">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 952}, {?attr_critrate, 100, 571}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 476}, {?attr_js, 100, 1269}]
        }
    };

get(101776) ->
    {ok, #item_base{
            id = 101776
            ,name = <<"使命护符">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 210
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1052}, {?attr_critrate, 100, 631}, {?attr_aspd, 100, 13}, {?attr_dmg_magic, 100, 526}, {?attr_js, 100, 1402}]
        }
    };

get(101811) ->
    {ok, #item_base{
            id = 101811
            ,name = <<"忠诚戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 138}, {?attr_critrate, 100, 82}, {?attr_dmg_magic, 100, 69}]
        }
    };

get(101821) ->
    {ok, #item_base{
            id = 101821
            ,name = <<"战痕戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 207}, {?attr_critrate, 100, 124}, {?attr_aspd, 100, 3}, {?attr_dmg_magic, 100, 103}, {?attr_js, 100, 276}]
        }
    };

get(101822) ->
    {ok, #item_base{
            id = 101822
            ,name = <<"战痕戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = []
        }
    };

get(101831) ->
    {ok, #item_base{
            id = 101831
            ,name = <<"誓约戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 276}, {?attr_critrate, 100, 165}, {?attr_aspd, 100, 4}, {?attr_dmg_magic, 100, 138}, {?attr_js, 100, 368}]
        }
    };

get(101832) ->
    {ok, #item_base{
            id = 101832
            ,name = <<"誓约戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 376}, {?attr_critrate, 100, 225}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 188}, {?attr_js, 100, 501}]
        }
    };

get(101841) ->
    {ok, #item_base{
            id = 101841
            ,name = <<"审判戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 345}, {?attr_critrate, 100, 207}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 172}, {?attr_js, 100, 460}]
        }
    };

get(101842) ->
    {ok, #item_base{
            id = 101842
            ,name = <<"审判戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 445}, {?attr_critrate, 100, 267}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 222}, {?attr_js, 100, 593}]
        }
    };

get(101843) ->
    {ok, #item_base{
            id = 101843
            ,name = <<"审判戒指">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 545}, {?attr_critrate, 100, 327}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 272}, {?attr_js, 100, 726}]
        }
    };

get(101851) ->
    {ok, #item_base{
            id = 101851
            ,name = <<"极昼戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 414}, {?attr_critrate, 100, 248}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 207}, {?attr_js, 100, 552}]
        }
    };

get(101852) ->
    {ok, #item_base{
            id = 101852
            ,name = <<"极昼戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 514}, {?attr_critrate, 100, 308}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 257}, {?attr_js, 100, 685}]
        }
    };

get(101853) ->
    {ok, #item_base{
            id = 101853
            ,name = <<"极昼戒指">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 614}, {?attr_critrate, 100, 368}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 307}, {?attr_js, 100, 818}]
        }
    };

get(101854) ->
    {ok, #item_base{
            id = 101854
            ,name = <<"极昼戒指">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 714}, {?attr_critrate, 100, 428}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 357}, {?attr_js, 100, 952}]
        }
    };

get(101861) ->
    {ok, #item_base{
            id = 101861
            ,name = <<"光明戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 483}, {?attr_critrate, 100, 289}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 241}, {?attr_js, 100, 644}]
        }
    };

get(101862) ->
    {ok, #item_base{
            id = 101862
            ,name = <<"光明戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 583}, {?attr_critrate, 100, 349}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 291}, {?attr_js, 100, 777}]
        }
    };

get(101863) ->
    {ok, #item_base{
            id = 101863
            ,name = <<"光明戒指">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 683}, {?attr_critrate, 100, 409}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 341}, {?attr_js, 100, 910}]
        }
    };

get(101864) ->
    {ok, #item_base{
            id = 101864
            ,name = <<"光明戒指">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 783}, {?attr_critrate, 100, 469}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 391}, {?attr_js, 100, 1044}]
        }
    };

get(101865) ->
    {ok, #item_base{
            id = 101865
            ,name = <<"光明戒指">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 883}, {?attr_critrate, 100, 529}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 441}, {?attr_js, 100, 1177}]
        }
    };

get(101871) ->
    {ok, #item_base{
            id = 101871
            ,name = <<"使命戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 552}, {?attr_critrate, 100, 331}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 276}, {?attr_js, 100, 736}]
        }
    };

get(101872) ->
    {ok, #item_base{
            id = 101872
            ,name = <<"使命戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 652}, {?attr_critrate, 100, 391}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 326}, {?attr_js, 100, 869}]
        }
    };

get(101873) ->
    {ok, #item_base{
            id = 101873
            ,name = <<"使命戒指">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 752}, {?attr_critrate, 100, 451}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 376}, {?attr_js, 100, 1002}]
        }
    };

get(101874) ->
    {ok, #item_base{
            id = 101874
            ,name = <<"使命戒指">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 852}, {?attr_critrate, 100, 511}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 426}, {?attr_js, 100, 1136}]
        }
    };

get(101875) ->
    {ok, #item_base{
            id = 101875
            ,name = <<"使命戒指">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 952}, {?attr_critrate, 100, 571}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 476}, {?attr_js, 100, 1269}]
        }
    };

get(101876) ->
    {ok, #item_base{
            id = 101876
            ,name = <<"使命戒指">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 210
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1052}, {?attr_critrate, 100, 631}, {?attr_aspd, 100, 13}, {?attr_dmg_magic, 100, 526}, {?attr_js, 100, 1402}]
        }
    };

get(101911) ->
    {ok, #item_base{
            id = 101911
            ,name = <<"忠诚项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 138}, {?attr_critrate, 100, 82}, {?attr_dmg_magic, 100, 69}]
        }
    };

get(101921) ->
    {ok, #item_base{
            id = 101921
            ,name = <<"战痕项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 207}, {?attr_critrate, 100, 124}, {?attr_aspd, 100, 3}, {?attr_dmg_magic, 100, 103}, {?attr_js, 100, 276}]
        }
    };

get(101922) ->
    {ok, #item_base{
            id = 101922
            ,name = <<"战痕项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 5}]
            ,attr = []
        }
    };

get(101931) ->
    {ok, #item_base{
            id = 101931
            ,name = <<"誓约项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 276}, {?attr_critrate, 100, 165}, {?attr_aspd, 100, 4}, {?attr_dmg_magic, 100, 138}, {?attr_js, 100, 368}]
        }
    };

get(101932) ->
    {ok, #item_base{
            id = 101932
            ,name = <<"誓约项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 376}, {?attr_critrate, 100, 225}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 188}, {?attr_js, 100, 501}]
        }
    };

get(101941) ->
    {ok, #item_base{
            id = 101941
            ,name = <<"审判项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 345}, {?attr_critrate, 100, 207}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 172}, {?attr_js, 100, 460}]
        }
    };

get(101942) ->
    {ok, #item_base{
            id = 101942
            ,name = <<"审判项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 445}, {?attr_critrate, 100, 267}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 222}, {?attr_js, 100, 593}]
        }
    };

get(101943) ->
    {ok, #item_base{
            id = 101943
            ,name = <<"审判项链">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 545}, {?attr_critrate, 100, 327}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 272}, {?attr_js, 100, 726}]
        }
    };

get(101951) ->
    {ok, #item_base{
            id = 101951
            ,name = <<"极昼项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 414}, {?attr_critrate, 100, 248}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 207}, {?attr_js, 100, 552}]
        }
    };

get(101952) ->
    {ok, #item_base{
            id = 101952
            ,name = <<"极昼项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 514}, {?attr_critrate, 100, 308}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 257}, {?attr_js, 100, 685}]
        }
    };

get(101953) ->
    {ok, #item_base{
            id = 101953
            ,name = <<"极昼项链">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 614}, {?attr_critrate, 100, 368}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 307}, {?attr_js, 100, 818}]
        }
    };

get(101954) ->
    {ok, #item_base{
            id = 101954
            ,name = <<"极昼项链">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 714}, {?attr_critrate, 100, 428}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 357}, {?attr_js, 100, 952}]
        }
    };

get(101961) ->
    {ok, #item_base{
            id = 101961
            ,name = <<"光明项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 483}, {?attr_critrate, 100, 289}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 241}, {?attr_js, 100, 644}]
        }
    };

get(101962) ->
    {ok, #item_base{
            id = 101962
            ,name = <<"光明项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 583}, {?attr_critrate, 100, 349}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 291}, {?attr_js, 100, 777}]
        }
    };

get(101963) ->
    {ok, #item_base{
            id = 101963
            ,name = <<"光明项链">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 683}, {?attr_critrate, 100, 409}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 341}, {?attr_js, 100, 910}]
        }
    };

get(101964) ->
    {ok, #item_base{
            id = 101964
            ,name = <<"光明项链">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 783}, {?attr_critrate, 100, 469}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 391}, {?attr_js, 100, 1044}]
        }
    };

get(101965) ->
    {ok, #item_base{
            id = 101965
            ,name = <<"光明项链">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 883}, {?attr_critrate, 100, 529}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 441}, {?attr_js, 100, 1177}]
        }
    };

get(101971) ->
    {ok, #item_base{
            id = 101971
            ,name = <<"使命项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 552}, {?attr_critrate, 100, 331}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 276}, {?attr_js, 100, 736}]
        }
    };

get(101972) ->
    {ok, #item_base{
            id = 101972
            ,name = <<"使命项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 652}, {?attr_critrate, 100, 391}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 326}, {?attr_js, 100, 869}]
        }
    };

get(101973) ->
    {ok, #item_base{
            id = 101973
            ,name = <<"使命项链">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 752}, {?attr_critrate, 100, 451}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 376}, {?attr_js, 100, 1002}]
        }
    };

get(101974) ->
    {ok, #item_base{
            id = 101974
            ,name = <<"使命项链">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 852}, {?attr_critrate, 100, 511}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 426}, {?attr_js, 100, 1136}]
        }
    };

get(101975) ->
    {ok, #item_base{
            id = 101975
            ,name = <<"使命项链">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 952}, {?attr_critrate, 100, 571}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 476}, {?attr_js, 100, 1269}]
        }
    };

get(101976) ->
    {ok, #item_base{
            id = 101976
            ,name = <<"使命项链">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 210
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 1052}, {?attr_critrate, 100, 631}, {?attr_aspd, 100, 13}, {?attr_dmg_magic, 100, 526}, {?attr_js, 100, 1402}]
        }
    };

get(102011) ->
    {ok, #item_base{
            id = 102011
            ,name = <<"咏诵之杖">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 276}, {?attr_critrate, 100, 27}, {?attr_hitrate, 100, 110}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 138}]
        }
    };

get(102021) ->
    {ok, #item_base{
            id = 102021
            ,name = <<"法印之杖">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 414}, {?attr_critrate, 100, 41}, {?attr_hitrate, 100, 160}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 207}]
        }
    };

get(102022) ->
    {ok, #item_base{
            id = 102022
            ,name = <<"法印之杖">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hitrate, 100, 0}]
        }
    };

get(102031) ->
    {ok, #item_base{
            id = 102031
            ,name = <<"启示之杖">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 552}, {?attr_critrate, 100, 55}, {?attr_hitrate, 100, 220}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 276}]
        }
    };

get(102032) ->
    {ok, #item_base{
            id = 102032
            ,name = <<"启示之杖">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 752}, {?attr_critrate, 100, 75}, {?attr_hitrate, 100, 300}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 376}]
        }
    };

get(102041) ->
    {ok, #item_base{
            id = 102041
            ,name = <<"符文之杖">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 690}, {?attr_critrate, 100, 69}, {?attr_hitrate, 100, 270}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 345}]
        }
    };

get(102042) ->
    {ok, #item_base{
            id = 102042
            ,name = <<"符文之杖">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 890}, {?attr_critrate, 100, 89}, {?attr_hitrate, 100, 350}, {?attr_aspd, 100, 14}, {?attr_dmg_magic, 100, 445}]
        }
    };

get(102043) ->
    {ok, #item_base{
            id = 102043
            ,name = <<"符文之杖">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1090}, {?attr_critrate, 100, 109}, {?attr_hitrate, 100, 430}, {?attr_aspd, 100, 17}, {?attr_dmg_magic, 100, 545}]
        }
    };

get(102051) ->
    {ok, #item_base{
            id = 102051
            ,name = <<"星辉之杖">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 828}, {?attr_critrate, 100, 82}, {?attr_hitrate, 100, 330}, {?attr_aspd, 100, 15}, {?attr_dmg_magic, 100, 414}]
        }
    };

get(102052) ->
    {ok, #item_base{
            id = 102052
            ,name = <<"星辉之杖">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1028}, {?attr_critrate, 100, 102}, {?attr_hitrate, 100, 410}, {?attr_aspd, 100, 17}, {?attr_dmg_magic, 100, 514}]
        }
    };

get(102053) ->
    {ok, #item_base{
            id = 102053
            ,name = <<"星辉之杖">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1228}, {?attr_critrate, 100, 122}, {?attr_hitrate, 100, 490}, {?attr_aspd, 100, 20}, {?attr_dmg_magic, 100, 614}]
        }
    };

get(102054) ->
    {ok, #item_base{
            id = 102054
            ,name = <<"星辉之杖">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1428}, {?attr_critrate, 100, 142}, {?attr_hitrate, 100, 570}, {?attr_aspd, 100, 22}, {?attr_dmg_magic, 100, 714}]
        }
    };

get(102061) ->
    {ok, #item_base{
            id = 102061
            ,name = <<"救赎之杖">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 966}, {?attr_critrate, 100, 96}, {?attr_hitrate, 100, 380}, {?attr_aspd, 100, 17}, {?attr_dmg_magic, 100, 483}]
        }
    };

get(102062) ->
    {ok, #item_base{
            id = 102062
            ,name = <<"救赎之杖">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1166}, {?attr_critrate, 100, 116}, {?attr_hitrate, 100, 460}, {?attr_aspd, 100, 19}, {?attr_dmg_magic, 100, 583}]
        }
    };

get(102063) ->
    {ok, #item_base{
            id = 102063
            ,name = <<"救赎之杖">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1366}, {?attr_critrate, 100, 136}, {?attr_hitrate, 100, 540}, {?attr_aspd, 100, 22}, {?attr_dmg_magic, 100, 683}]
        }
    };

get(102064) ->
    {ok, #item_base{
            id = 102064
            ,name = <<"救赎之杖">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1566}, {?attr_critrate, 100, 156}, {?attr_hitrate, 100, 620}, {?attr_aspd, 100, 24}, {?attr_dmg_magic, 100, 783}]
        }
    };

get(102065) ->
    {ok, #item_base{
            id = 102065
            ,name = <<"救赎之杖">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1766}, {?attr_critrate, 100, 176}, {?attr_hitrate, 100, 700}, {?attr_aspd, 100, 27}, {?attr_dmg_magic, 100, 883}]
        }
    };

get(102071) ->
    {ok, #item_base{
            id = 102071
            ,name = <<"圣光之杖">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1104}, {?attr_critrate, 100, 110}, {?attr_hitrate, 100, 440}, {?attr_aspd, 100, 20}, {?attr_dmg_magic, 100, 552}]
        }
    };

get(102072) ->
    {ok, #item_base{
            id = 102072
            ,name = <<"圣光之杖">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1304}, {?attr_critrate, 100, 130}, {?attr_hitrate, 100, 520}, {?attr_aspd, 100, 22}, {?attr_dmg_magic, 100, 652}]
        }
    };

get(102073) ->
    {ok, #item_base{
            id = 102073
            ,name = <<"圣光之杖">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1504}, {?attr_critrate, 100, 150}, {?attr_hitrate, 100, 600}, {?attr_aspd, 100, 25}, {?attr_dmg_magic, 100, 752}]
        }
    };

get(102074) ->
    {ok, #item_base{
            id = 102074
            ,name = <<"圣光之杖">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1704}, {?attr_critrate, 100, 170}, {?attr_hitrate, 100, 680}, {?attr_aspd, 100, 27}, {?attr_dmg_magic, 100, 852}]
        }
    };

get(102075) ->
    {ok, #item_base{
            id = 102075
            ,name = <<"圣光之杖">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1904}, {?attr_critrate, 100, 190}, {?attr_hitrate, 100, 760}, {?attr_aspd, 100, 30}, {?attr_dmg_magic, 100, 952}]
        }
    };

get(102076) ->
    {ok, #item_base{
            id = 102076
            ,name = <<"圣光之杖">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 2104}, {?attr_critrate, 100, 210}, {?attr_hitrate, 100, 840}, {?attr_aspd, 100, 32}, {?attr_dmg_magic, 100, 1052}]
        }
    };

get(102111) ->
    {ok, #item_base{
            id = 102111
            ,name = <<"咏诵护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 414}, {?attr_defence, 100, 207}, {?attr_hitrate, 100, 110}, {?attr_evasion, 100, 33}, {?attr_rst_all, 100, 110}, {?attr_js, 100, 184}]
        }
    };

get(102121) ->
    {ok, #item_base{
            id = 102121
            ,name = <<"法印护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 621}, {?attr_defence, 100, 310}, {?attr_hitrate, 100, 160}, {?attr_evasion, 100, 49}, {?attr_rst_all, 100, 165}, {?attr_js, 100, 276}]
        }
    };

get(102122) ->
    {ok, #item_base{
            id = 102122
            ,name = <<"法印护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hitrate, 100, 0}]
        }
    };

get(102131) ->
    {ok, #item_base{
            id = 102131
            ,name = <<"启示护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_hitrate, 100, 220}, {?attr_evasion, 100, 66}, {?attr_rst_all, 100, 220}, {?attr_js, 100, 368}]
        }
    };

get(102132) ->
    {ok, #item_base{
            id = 102132
            ,name = <<"启示护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1128}, {?attr_defence, 100, 564}, {?attr_hitrate, 100, 300}, {?attr_evasion, 100, 90}, {?attr_rst_all, 100, 300}, {?attr_js, 100, 501}]
        }
    };

get(102141) ->
    {ok, #item_base{
            id = 102141
            ,name = <<"符文护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1035}, {?attr_defence, 100, 517}, {?attr_hitrate, 100, 270}, {?attr_evasion, 100, 82}, {?attr_rst_all, 100, 276}, {?attr_js, 100, 460}]
        }
    };

get(102142) ->
    {ok, #item_base{
            id = 102142
            ,name = <<"符文护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1335}, {?attr_defence, 100, 667}, {?attr_hitrate, 100, 350}, {?attr_evasion, 100, 106}, {?attr_rst_all, 100, 356}, {?attr_js, 100, 593}]
        }
    };

get(102143) ->
    {ok, #item_base{
            id = 102143
            ,name = <<"符文护腕">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1635}, {?attr_defence, 100, 817}, {?attr_hitrate, 100, 430}, {?attr_evasion, 100, 130}, {?attr_rst_all, 100, 436}, {?attr_js, 100, 726}]
        }
    };

get(102151) ->
    {ok, #item_base{
            id = 102151
            ,name = <<"星辉护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1242}, {?attr_defence, 100, 621}, {?attr_hitrate, 100, 330}, {?attr_evasion, 100, 99}, {?attr_rst_all, 100, 331}, {?attr_js, 100, 552}]
        }
    };

get(102152) ->
    {ok, #item_base{
            id = 102152
            ,name = <<"星辉护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1542}, {?attr_defence, 100, 771}, {?attr_hitrate, 100, 410}, {?attr_evasion, 100, 123}, {?attr_rst_all, 100, 411}, {?attr_js, 100, 685}]
        }
    };

get(102153) ->
    {ok, #item_base{
            id = 102153
            ,name = <<"星辉护腕">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1842}, {?attr_defence, 100, 921}, {?attr_hitrate, 100, 490}, {?attr_evasion, 100, 147}, {?attr_rst_all, 100, 491}, {?attr_js, 100, 818}]
        }
    };

get(102154) ->
    {ok, #item_base{
            id = 102154
            ,name = <<"星辉护腕">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2142}, {?attr_defence, 100, 1071}, {?attr_hitrate, 100, 570}, {?attr_evasion, 100, 171}, {?attr_rst_all, 100, 571}, {?attr_js, 100, 952}]
        }
    };

get(102161) ->
    {ok, #item_base{
            id = 102161
            ,name = <<"救赎护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1449}, {?attr_defence, 100, 724}, {?attr_hitrate, 100, 380}, {?attr_evasion, 100, 115}, {?attr_rst_all, 100, 386}, {?attr_js, 100, 644}]
        }
    };

get(102162) ->
    {ok, #item_base{
            id = 102162
            ,name = <<"救赎护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1749}, {?attr_defence, 100, 874}, {?attr_hitrate, 100, 460}, {?attr_evasion, 100, 139}, {?attr_rst_all, 100, 466}, {?attr_js, 100, 777}]
        }
    };

get(102163) ->
    {ok, #item_base{
            id = 102163
            ,name = <<"救赎护腕">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2049}, {?attr_defence, 100, 1024}, {?attr_hitrate, 100, 540}, {?attr_evasion, 100, 163}, {?attr_rst_all, 100, 546}, {?attr_js, 100, 910}]
        }
    };

get(102164) ->
    {ok, #item_base{
            id = 102164
            ,name = <<"救赎护腕">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2349}, {?attr_defence, 100, 1174}, {?attr_hitrate, 100, 620}, {?attr_evasion, 100, 187}, {?attr_rst_all, 100, 626}, {?attr_js, 100, 1044}]
        }
    };

get(102165) ->
    {ok, #item_base{
            id = 102165
            ,name = <<"救赎护腕">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2649}, {?attr_defence, 100, 1324}, {?attr_hitrate, 100, 700}, {?attr_evasion, 100, 211}, {?attr_rst_all, 100, 706}, {?attr_js, 100, 1177}]
        }
    };

get(102171) ->
    {ok, #item_base{
            id = 102171
            ,name = <<"圣光护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_hitrate, 100, 440}, {?attr_evasion, 100, 132}, {?attr_rst_all, 100, 441}, {?attr_js, 100, 736}]
        }
    };

get(102172) ->
    {ok, #item_base{
            id = 102172
            ,name = <<"圣光护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1956}, {?attr_defence, 100, 978}, {?attr_hitrate, 100, 520}, {?attr_evasion, 100, 156}, {?attr_rst_all, 100, 521}, {?attr_js, 100, 869}]
        }
    };

get(102173) ->
    {ok, #item_base{
            id = 102173
            ,name = <<"圣光护腕">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2256}, {?attr_defence, 100, 1128}, {?attr_hitrate, 100, 600}, {?attr_evasion, 100, 180}, {?attr_rst_all, 100, 601}, {?attr_js, 100, 1002}]
        }
    };

get(102174) ->
    {ok, #item_base{
            id = 102174
            ,name = <<"圣光护腕">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2556}, {?attr_defence, 100, 1278}, {?attr_hitrate, 100, 680}, {?attr_evasion, 100, 204}, {?attr_rst_all, 100, 681}, {?attr_js, 100, 1136}]
        }
    };

get(102175) ->
    {ok, #item_base{
            id = 102175
            ,name = <<"圣光护腕">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_hitrate, 100, 760}, {?attr_evasion, 100, 228}, {?attr_rst_all, 100, 761}, {?attr_js, 100, 1269}]
        }
    };

get(102176) ->
    {ok, #item_base{
            id = 102176
            ,name = <<"圣光护腕">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3156}, {?attr_defence, 100, 1578}, {?attr_hitrate, 100, 840}, {?attr_evasion, 100, 252}, {?attr_rst_all, 100, 841}, {?attr_js, 100, 1402}]
        }
    };

get(102211) ->
    {ok, #item_base{
            id = 102211
            ,name = <<"咏诵法袍">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 552}, {?attr_defence, 100, 276}, {?attr_hitrate, 100, 110}, {?attr_tenacity, 100, 110}, {?attr_rst_all, 100, 82}]
        }
    };

get(102221) ->
    {ok, #item_base{
            id = 102221
            ,name = <<"法印法袍">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_hitrate, 100, 160}, {?attr_tenacity, 100, 165}, {?attr_rst_all, 100, 124}]
        }
    };

get(102222) ->
    {ok, #item_base{
            id = 102222
            ,name = <<"法印法袍">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hitrate, 100, 0}]
        }
    };

get(102231) ->
    {ok, #item_base{
            id = 102231
            ,name = <<"启示法袍">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1104}, {?attr_defence, 100, 552}, {?attr_hitrate, 100, 220}, {?attr_tenacity, 100, 220}, {?attr_rst_all, 100, 165}]
        }
    };

get(102232) ->
    {ok, #item_base{
            id = 102232
            ,name = <<"启示法袍">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1504}, {?attr_defence, 100, 752}, {?attr_hitrate, 100, 300}, {?attr_tenacity, 100, 300}, {?attr_rst_all, 100, 225}]
        }
    };

get(102241) ->
    {ok, #item_base{
            id = 102241
            ,name = <<"符文法袍">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1380}, {?attr_defence, 100, 690}, {?attr_hitrate, 100, 270}, {?attr_tenacity, 100, 276}, {?attr_rst_all, 100, 207}]
        }
    };

get(102242) ->
    {ok, #item_base{
            id = 102242
            ,name = <<"符文法袍">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1780}, {?attr_defence, 100, 890}, {?attr_hitrate, 100, 350}, {?attr_tenacity, 100, 356}, {?attr_rst_all, 100, 267}]
        }
    };

get(102243) ->
    {ok, #item_base{
            id = 102243
            ,name = <<"符文法袍">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2180}, {?attr_defence, 100, 1090}, {?attr_hitrate, 100, 430}, {?attr_tenacity, 100, 436}, {?attr_rst_all, 100, 327}]
        }
    };

get(102251) ->
    {ok, #item_base{
            id = 102251
            ,name = <<"星辉法袍">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_hitrate, 100, 330}, {?attr_tenacity, 100, 331}, {?attr_rst_all, 100, 248}]
        }
    };

get(102252) ->
    {ok, #item_base{
            id = 102252
            ,name = <<"星辉法袍">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2056}, {?attr_defence, 100, 1028}, {?attr_hitrate, 100, 410}, {?attr_tenacity, 100, 411}, {?attr_rst_all, 100, 308}]
        }
    };

get(102253) ->
    {ok, #item_base{
            id = 102253
            ,name = <<"星辉法袍">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2456}, {?attr_defence, 100, 1228}, {?attr_hitrate, 100, 490}, {?attr_tenacity, 100, 491}, {?attr_rst_all, 100, 368}]
        }
    };

get(102254) ->
    {ok, #item_base{
            id = 102254
            ,name = <<"星辉法袍">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_hitrate, 100, 570}, {?attr_tenacity, 100, 571}, {?attr_rst_all, 100, 428}]
        }
    };

get(102261) ->
    {ok, #item_base{
            id = 102261
            ,name = <<"救赎法袍">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1932}, {?attr_defence, 100, 966}, {?attr_hitrate, 100, 380}, {?attr_tenacity, 100, 386}, {?attr_rst_all, 100, 289}]
        }
    };

get(102262) ->
    {ok, #item_base{
            id = 102262
            ,name = <<"救赎法袍">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2332}, {?attr_defence, 100, 1166}, {?attr_hitrate, 100, 460}, {?attr_tenacity, 100, 466}, {?attr_rst_all, 100, 349}]
        }
    };

get(102263) ->
    {ok, #item_base{
            id = 102263
            ,name = <<"救赎法袍">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2732}, {?attr_defence, 100, 1366}, {?attr_hitrate, 100, 540}, {?attr_tenacity, 100, 546}, {?attr_rst_all, 100, 409}]
        }
    };

get(102264) ->
    {ok, #item_base{
            id = 102264
            ,name = <<"救赎法袍">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3132}, {?attr_defence, 100, 1566}, {?attr_hitrate, 100, 620}, {?attr_tenacity, 100, 626}, {?attr_rst_all, 100, 469}]
        }
    };

get(102265) ->
    {ok, #item_base{
            id = 102265
            ,name = <<"救赎法袍">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3532}, {?attr_defence, 100, 1766}, {?attr_hitrate, 100, 700}, {?attr_tenacity, 100, 706}, {?attr_rst_all, 100, 529}]
        }
    };

get(102271) ->
    {ok, #item_base{
            id = 102271
            ,name = <<"圣光法袍">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2208}, {?attr_defence, 100, 1104}, {?attr_hitrate, 100, 440}, {?attr_tenacity, 100, 441}, {?attr_rst_all, 100, 331}]
        }
    };

get(102272) ->
    {ok, #item_base{
            id = 102272
            ,name = <<"圣光法袍">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2608}, {?attr_defence, 100, 1304}, {?attr_hitrate, 100, 520}, {?attr_tenacity, 100, 521}, {?attr_rst_all, 100, 391}]
        }
    };

get(102273) ->
    {ok, #item_base{
            id = 102273
            ,name = <<"圣光法袍">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3008}, {?attr_defence, 100, 1504}, {?attr_hitrate, 100, 600}, {?attr_tenacity, 100, 601}, {?attr_rst_all, 100, 451}]
        }
    };

get(102274) ->
    {ok, #item_base{
            id = 102274
            ,name = <<"圣光法袍">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3408}, {?attr_defence, 100, 1704}, {?attr_hitrate, 100, 680}, {?attr_tenacity, 100, 681}, {?attr_rst_all, 100, 511}]
        }
    };

get(102275) ->
    {ok, #item_base{
            id = 102275
            ,name = <<"圣光法袍">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3808}, {?attr_defence, 100, 1904}, {?attr_hitrate, 100, 760}, {?attr_tenacity, 100, 761}, {?attr_rst_all, 100, 571}]
        }
    };

get(102276) ->
    {ok, #item_base{
            id = 102276
            ,name = <<"圣光法袍">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 4208}, {?attr_defence, 100, 2104}, {?attr_hitrate, 100, 840}, {?attr_tenacity, 100, 841}, {?attr_rst_all, 100, 631}]
        }
    };

get(102311) ->
    {ok, #item_base{
            id = 102311
            ,name = <<"咏诵长裤">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 552}, {?attr_defence, 100, 276}, {?attr_hitrate, 100, 50}, {?attr_tenacity, 100, 82}, {?attr_rst_all, 100, 82}]
        }
    };

get(102321) ->
    {ok, #item_base{
            id = 102321
            ,name = <<"法印长裤">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_hitrate, 100, 50}, {?attr_tenacity, 100, 124}, {?attr_rst_all, 100, 124}]
        }
    };

get(102322) ->
    {ok, #item_base{
            id = 102322
            ,name = <<"法印长裤">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hitrate, 100, 50}]
        }
    };

get(102331) ->
    {ok, #item_base{
            id = 102331
            ,name = <<"启示长裤">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1104}, {?attr_defence, 100, 552}, {?attr_tenacity, 100, 165}, {?attr_rst_all, 100, 165}]
        }
    };

get(102332) ->
    {ok, #item_base{
            id = 102332
            ,name = <<"启示长裤">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1504}, {?attr_defence, 100, 752}, {?attr_tenacity, 100, 225}, {?attr_rst_all, 100, 225}]
        }
    };

get(102341) ->
    {ok, #item_base{
            id = 102341
            ,name = <<"符文长裤">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1380}, {?attr_defence, 100, 690}, {?attr_tenacity, 100, 207}, {?attr_rst_all, 100, 207}]
        }
    };

get(102342) ->
    {ok, #item_base{
            id = 102342
            ,name = <<"符文长裤">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1780}, {?attr_defence, 100, 890}, {?attr_tenacity, 100, 267}, {?attr_rst_all, 100, 267}]
        }
    };

get(102343) ->
    {ok, #item_base{
            id = 102343
            ,name = <<"符文长裤">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2180}, {?attr_defence, 100, 1090}, {?attr_tenacity, 100, 327}, {?attr_rst_all, 100, 327}]
        }
    };

get(102351) ->
    {ok, #item_base{
            id = 102351
            ,name = <<"星辉长裤">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_tenacity, 100, 248}, {?attr_rst_all, 100, 248}]
        }
    };

get(102352) ->
    {ok, #item_base{
            id = 102352
            ,name = <<"星辉长裤">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2056}, {?attr_defence, 100, 1028}, {?attr_tenacity, 100, 308}, {?attr_rst_all, 100, 308}]
        }
    };

get(102353) ->
    {ok, #item_base{
            id = 102353
            ,name = <<"星辉长裤">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2456}, {?attr_defence, 100, 1228}, {?attr_tenacity, 100, 368}, {?attr_rst_all, 100, 368}]
        }
    };

get(102354) ->
    {ok, #item_base{
            id = 102354
            ,name = <<"星辉长裤">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_tenacity, 100, 428}, {?attr_rst_all, 100, 428}]
        }
    };

get(102361) ->
    {ok, #item_base{
            id = 102361
            ,name = <<"救赎长裤">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1932}, {?attr_defence, 100, 966}, {?attr_tenacity, 100, 289}, {?attr_rst_all, 100, 289}]
        }
    };

get(102362) ->
    {ok, #item_base{
            id = 102362
            ,name = <<"救赎长裤">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2332}, {?attr_defence, 100, 1166}, {?attr_tenacity, 100, 349}, {?attr_rst_all, 100, 349}]
        }
    };

get(102363) ->
    {ok, #item_base{
            id = 102363
            ,name = <<"救赎长裤">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2732}, {?attr_defence, 100, 1366}, {?attr_tenacity, 100, 409}, {?attr_rst_all, 100, 409}]
        }
    };

get(102364) ->
    {ok, #item_base{
            id = 102364
            ,name = <<"救赎长裤">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3132}, {?attr_defence, 100, 1566}, {?attr_tenacity, 100, 469}, {?attr_rst_all, 100, 469}]
        }
    };

get(102365) ->
    {ok, #item_base{
            id = 102365
            ,name = <<"救赎长裤">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3532}, {?attr_defence, 100, 1766}, {?attr_tenacity, 100, 529}, {?attr_rst_all, 100, 529}]
        }
    };

get(102371) ->
    {ok, #item_base{
            id = 102371
            ,name = <<"圣光长裤">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2208}, {?attr_defence, 100, 1104}, {?attr_tenacity, 100, 331}, {?attr_rst_all, 100, 331}]
        }
    };

get(102372) ->
    {ok, #item_base{
            id = 102372
            ,name = <<"圣光长裤">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2608}, {?attr_defence, 100, 1304}, {?attr_tenacity, 100, 391}, {?attr_rst_all, 100, 391}]
        }
    };

get(102373) ->
    {ok, #item_base{
            id = 102373
            ,name = <<"圣光长裤">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3008}, {?attr_defence, 100, 1504}, {?attr_tenacity, 100, 451}, {?attr_rst_all, 100, 451}]
        }
    };

get(102374) ->
    {ok, #item_base{
            id = 102374
            ,name = <<"圣光长裤">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3408}, {?attr_defence, 100, 1704}, {?attr_tenacity, 100, 511}, {?attr_rst_all, 100, 511}]
        }
    };

get(102375) ->
    {ok, #item_base{
            id = 102375
            ,name = <<"圣光长裤">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3808}, {?attr_defence, 100, 1904}, {?attr_tenacity, 100, 571}, {?attr_rst_all, 100, 571}]
        }
    };

get(102376) ->
    {ok, #item_base{
            id = 102376
            ,name = <<"圣光长裤">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 4208}, {?attr_defence, 100, 2104}, {?attr_tenacity, 100, 631}, {?attr_rst_all, 100, 631}]
        }
    };

get(102411) ->
    {ok, #item_base{
            id = 102411
            ,name = <<"咏诵法靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 414}, {?attr_defence, 100, 207}, {?attr_tenacity, 100, 82}, {?attr_rst_all, 100, 82}]
        }
    };

get(102421) ->
    {ok, #item_base{
            id = 102421
            ,name = <<"法印法靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 621}, {?attr_defence, 100, 310}, {?attr_tenacity, 100, 124}, {?attr_rst_all, 100, 124}]
        }
    };

get(102422) ->
    {ok, #item_base{
            id = 102422
            ,name = <<"法印法靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = []
        }
    };

get(102431) ->
    {ok, #item_base{
            id = 102431
            ,name = <<"启示法靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_tenacity, 100, 165}, {?attr_rst_all, 100, 165}]
        }
    };

get(102432) ->
    {ok, #item_base{
            id = 102432
            ,name = <<"启示法靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1128}, {?attr_defence, 100, 564}, {?attr_tenacity, 100, 225}, {?attr_rst_all, 100, 225}]
        }
    };

get(102441) ->
    {ok, #item_base{
            id = 102441
            ,name = <<"符文法靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1035}, {?attr_defence, 100, 517}, {?attr_tenacity, 100, 207}, {?attr_rst_all, 100, 207}]
        }
    };

get(102442) ->
    {ok, #item_base{
            id = 102442
            ,name = <<"符文法靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1335}, {?attr_defence, 100, 667}, {?attr_tenacity, 100, 267}, {?attr_rst_all, 100, 267}]
        }
    };

get(102443) ->
    {ok, #item_base{
            id = 102443
            ,name = <<"符文法靴">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1635}, {?attr_defence, 100, 817}, {?attr_tenacity, 100, 327}, {?attr_rst_all, 100, 327}]
        }
    };

get(102451) ->
    {ok, #item_base{
            id = 102451
            ,name = <<"星辉法靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1242}, {?attr_defence, 100, 621}, {?attr_tenacity, 100, 248}, {?attr_rst_all, 100, 248}]
        }
    };

get(102452) ->
    {ok, #item_base{
            id = 102452
            ,name = <<"星辉法靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1542}, {?attr_defence, 100, 771}, {?attr_tenacity, 100, 308}, {?attr_rst_all, 100, 308}]
        }
    };

get(102453) ->
    {ok, #item_base{
            id = 102453
            ,name = <<"星辉法靴">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1842}, {?attr_defence, 100, 921}, {?attr_tenacity, 100, 368}, {?attr_rst_all, 100, 368}]
        }
    };

get(102454) ->
    {ok, #item_base{
            id = 102454
            ,name = <<"星辉法靴">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2142}, {?attr_defence, 100, 1071}, {?attr_tenacity, 100, 428}, {?attr_rst_all, 100, 428}]
        }
    };

get(102461) ->
    {ok, #item_base{
            id = 102461
            ,name = <<"救赎法靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1449}, {?attr_defence, 100, 724}, {?attr_tenacity, 100, 289}, {?attr_rst_all, 100, 289}]
        }
    };

get(102462) ->
    {ok, #item_base{
            id = 102462
            ,name = <<"救赎法靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1749}, {?attr_defence, 100, 874}, {?attr_tenacity, 100, 349}, {?attr_rst_all, 100, 349}]
        }
    };

get(102463) ->
    {ok, #item_base{
            id = 102463
            ,name = <<"救赎法靴">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2049}, {?attr_defence, 100, 1024}, {?attr_tenacity, 100, 409}, {?attr_rst_all, 100, 409}]
        }
    };

get(102464) ->
    {ok, #item_base{
            id = 102464
            ,name = <<"救赎法靴">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2349}, {?attr_defence, 100, 1174}, {?attr_tenacity, 100, 469}, {?attr_rst_all, 100, 469}]
        }
    };

get(102465) ->
    {ok, #item_base{
            id = 102465
            ,name = <<"救赎法靴">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2649}, {?attr_defence, 100, 1324}, {?attr_tenacity, 100, 529}, {?attr_rst_all, 100, 529}]
        }
    };

get(102471) ->
    {ok, #item_base{
            id = 102471
            ,name = <<"圣光法靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_tenacity, 100, 331}, {?attr_rst_all, 100, 331}]
        }
    };

get(102472) ->
    {ok, #item_base{
            id = 102472
            ,name = <<"圣光法靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1956}, {?attr_defence, 100, 978}, {?attr_tenacity, 100, 391}, {?attr_rst_all, 100, 391}]
        }
    };

get(102473) ->
    {ok, #item_base{
            id = 102473
            ,name = <<"圣光法靴">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2256}, {?attr_defence, 100, 1128}, {?attr_tenacity, 100, 451}, {?attr_rst_all, 100, 451}]
        }
    };

get(102474) ->
    {ok, #item_base{
            id = 102474
            ,name = <<"圣光法靴">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2556}, {?attr_defence, 100, 1278}, {?attr_tenacity, 100, 511}, {?attr_rst_all, 100, 511}]
        }
    };

get(102475) ->
    {ok, #item_base{
            id = 102475
            ,name = <<"圣光法靴">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_tenacity, 100, 571}, {?attr_rst_all, 100, 571}]
        }
    };

get(102476) ->
    {ok, #item_base{
            id = 102476
            ,name = <<"圣光法靴">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3156}, {?attr_defence, 100, 1578}, {?attr_tenacity, 100, 631}, {?attr_rst_all, 100, 631}]
        }
    };

get(102511) ->
    {ok, #item_base{
            id = 102511
            ,name = <<"咏诵腰带">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 414}, {?attr_defence, 100, 207}, {?attr_evasion, 100, 44}, {?attr_rst_all, 100, 82}]
        }
    };

get(102521) ->
    {ok, #item_base{
            id = 102521
            ,name = <<"法印腰带">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 621}, {?attr_defence, 100, 310}, {?attr_evasion, 100, 66}, {?attr_rst_all, 100, 124}]
        }
    };

get(102522) ->
    {ok, #item_base{
            id = 102522
            ,name = <<"法印腰带">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = []
        }
    };

get(102531) ->
    {ok, #item_base{
            id = 102531
            ,name = <<"启示腰带">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_evasion, 100, 88}, {?attr_rst_all, 100, 165}]
        }
    };

get(102532) ->
    {ok, #item_base{
            id = 102532
            ,name = <<"启示腰带">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1128}, {?attr_defence, 100, 564}, {?attr_evasion, 100, 120}, {?attr_rst_all, 100, 225}]
        }
    };

get(102541) ->
    {ok, #item_base{
            id = 102541
            ,name = <<"符文腰带">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1035}, {?attr_defence, 100, 517}, {?attr_evasion, 100, 110}, {?attr_rst_all, 100, 207}]
        }
    };

get(102542) ->
    {ok, #item_base{
            id = 102542
            ,name = <<"符文腰带">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1335}, {?attr_defence, 100, 667}, {?attr_evasion, 100, 142}, {?attr_rst_all, 100, 267}]
        }
    };

get(102543) ->
    {ok, #item_base{
            id = 102543
            ,name = <<"符文腰带">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1635}, {?attr_defence, 100, 817}, {?attr_evasion, 100, 174}, {?attr_rst_all, 100, 327}]
        }
    };

get(102551) ->
    {ok, #item_base{
            id = 102551
            ,name = <<"星辉腰带">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1242}, {?attr_defence, 100, 621}, {?attr_evasion, 100, 132}, {?attr_rst_all, 100, 248}]
        }
    };

get(102552) ->
    {ok, #item_base{
            id = 102552
            ,name = <<"星辉腰带">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1542}, {?attr_defence, 100, 771}, {?attr_evasion, 100, 164}, {?attr_rst_all, 100, 308}]
        }
    };

get(102553) ->
    {ok, #item_base{
            id = 102553
            ,name = <<"星辉腰带">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1842}, {?attr_defence, 100, 921}, {?attr_evasion, 100, 196}, {?attr_rst_all, 100, 368}]
        }
    };

get(102554) ->
    {ok, #item_base{
            id = 102554
            ,name = <<"星辉腰带">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2142}, {?attr_defence, 100, 1071}, {?attr_evasion, 100, 228}, {?attr_rst_all, 100, 428}]
        }
    };

get(102561) ->
    {ok, #item_base{
            id = 102561
            ,name = <<"救赎腰带">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1449}, {?attr_defence, 100, 724}, {?attr_evasion, 100, 154}, {?attr_rst_all, 100, 289}]
        }
    };

get(102562) ->
    {ok, #item_base{
            id = 102562
            ,name = <<"救赎腰带">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1749}, {?attr_defence, 100, 874}, {?attr_evasion, 100, 186}, {?attr_rst_all, 100, 349}]
        }
    };

get(102563) ->
    {ok, #item_base{
            id = 102563
            ,name = <<"救赎腰带">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2049}, {?attr_defence, 100, 1024}, {?attr_evasion, 100, 218}, {?attr_rst_all, 100, 409}]
        }
    };

get(102564) ->
    {ok, #item_base{
            id = 102564
            ,name = <<"救赎腰带">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2349}, {?attr_defence, 100, 1174}, {?attr_evasion, 100, 250}, {?attr_rst_all, 100, 469}]
        }
    };

get(102565) ->
    {ok, #item_base{
            id = 102565
            ,name = <<"救赎腰带">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2649}, {?attr_defence, 100, 1324}, {?attr_evasion, 100, 282}, {?attr_rst_all, 100, 529}]
        }
    };

get(102571) ->
    {ok, #item_base{
            id = 102571
            ,name = <<"圣光腰带">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_evasion, 100, 176}, {?attr_rst_all, 100, 331}]
        }
    };

get(102572) ->
    {ok, #item_base{
            id = 102572
            ,name = <<"圣光腰带">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1956}, {?attr_defence, 100, 978}, {?attr_evasion, 100, 208}, {?attr_rst_all, 100, 391}]
        }
    };

get(102573) ->
    {ok, #item_base{
            id = 102573
            ,name = <<"圣光腰带">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2256}, {?attr_defence, 100, 1128}, {?attr_evasion, 100, 240}, {?attr_rst_all, 100, 451}]
        }
    };

get(102574) ->
    {ok, #item_base{
            id = 102574
            ,name = <<"圣光腰带">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2556}, {?attr_defence, 100, 1278}, {?attr_evasion, 100, 272}, {?attr_rst_all, 100, 511}]
        }
    };

get(102575) ->
    {ok, #item_base{
            id = 102575
            ,name = <<"圣光腰带">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_evasion, 100, 304}, {?attr_rst_all, 100, 571}]
        }
    };

get(102576) ->
    {ok, #item_base{
            id = 102576
            ,name = <<"圣光腰带">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3156}, {?attr_defence, 100, 1578}, {?attr_evasion, 100, 336}, {?attr_rst_all, 100, 631}]
        }
    };

get(102611) ->
    {ok, #item_base{
            id = 102611
            ,name = <<"咏诵护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 414}, {?attr_defence, 100, 207}, {?attr_evasion, 100, 33}, {?attr_rst_all, 100, 110}, {?attr_js, 100, 184}]
        }
    };

get(102621) ->
    {ok, #item_base{
            id = 102621
            ,name = <<"法印护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 621}, {?attr_defence, 100, 310}, {?attr_evasion, 100, 49}, {?attr_rst_all, 100, 165}, {?attr_js, 100, 276}]
        }
    };

get(102622) ->
    {ok, #item_base{
            id = 102622
            ,name = <<"法印护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = []
        }
    };

get(102631) ->
    {ok, #item_base{
            id = 102631
            ,name = <<"启示护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_evasion, 100, 66}, {?attr_rst_all, 100, 220}, {?attr_js, 100, 368}]
        }
    };

get(102632) ->
    {ok, #item_base{
            id = 102632
            ,name = <<"启示护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1128}, {?attr_defence, 100, 564}, {?attr_evasion, 100, 90}, {?attr_rst_all, 100, 300}, {?attr_js, 100, 501}]
        }
    };

get(102641) ->
    {ok, #item_base{
            id = 102641
            ,name = <<"符文护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1035}, {?attr_defence, 100, 517}, {?attr_evasion, 100, 82}, {?attr_rst_all, 100, 276}, {?attr_js, 100, 460}]
        }
    };

get(102642) ->
    {ok, #item_base{
            id = 102642
            ,name = <<"符文护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1335}, {?attr_defence, 100, 667}, {?attr_evasion, 100, 106}, {?attr_rst_all, 100, 356}, {?attr_js, 100, 593}]
        }
    };

get(102643) ->
    {ok, #item_base{
            id = 102643
            ,name = <<"符文护手">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1635}, {?attr_defence, 100, 817}, {?attr_evasion, 100, 130}, {?attr_rst_all, 100, 436}, {?attr_js, 100, 726}]
        }
    };

get(102651) ->
    {ok, #item_base{
            id = 102651
            ,name = <<"星辉护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1242}, {?attr_defence, 100, 621}, {?attr_evasion, 100, 99}, {?attr_rst_all, 100, 331}, {?attr_js, 100, 552}]
        }
    };

get(102652) ->
    {ok, #item_base{
            id = 102652
            ,name = <<"星辉护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1542}, {?attr_defence, 100, 771}, {?attr_evasion, 100, 123}, {?attr_rst_all, 100, 411}, {?attr_js, 100, 685}]
        }
    };

get(102653) ->
    {ok, #item_base{
            id = 102653
            ,name = <<"星辉护手">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1842}, {?attr_defence, 100, 921}, {?attr_evasion, 100, 147}, {?attr_rst_all, 100, 491}, {?attr_js, 100, 818}]
        }
    };

get(102654) ->
    {ok, #item_base{
            id = 102654
            ,name = <<"星辉护手">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2142}, {?attr_defence, 100, 1071}, {?attr_evasion, 100, 171}, {?attr_rst_all, 100, 571}, {?attr_js, 100, 952}]
        }
    };

get(102661) ->
    {ok, #item_base{
            id = 102661
            ,name = <<"救赎护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1449}, {?attr_defence, 100, 724}, {?attr_evasion, 100, 115}, {?attr_rst_all, 100, 386}, {?attr_js, 100, 644}]
        }
    };

get(102662) ->
    {ok, #item_base{
            id = 102662
            ,name = <<"救赎护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1749}, {?attr_defence, 100, 874}, {?attr_evasion, 100, 139}, {?attr_rst_all, 100, 466}, {?attr_js, 100, 777}]
        }
    };

get(102663) ->
    {ok, #item_base{
            id = 102663
            ,name = <<"救赎护手">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2049}, {?attr_defence, 100, 1024}, {?attr_evasion, 100, 163}, {?attr_rst_all, 100, 546}, {?attr_js, 100, 910}]
        }
    };

get(102664) ->
    {ok, #item_base{
            id = 102664
            ,name = <<"救赎护手">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2349}, {?attr_defence, 100, 1174}, {?attr_evasion, 100, 187}, {?attr_rst_all, 100, 626}, {?attr_js, 100, 1044}]
        }
    };

get(102665) ->
    {ok, #item_base{
            id = 102665
            ,name = <<"救赎护手">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2649}, {?attr_defence, 100, 1324}, {?attr_evasion, 100, 211}, {?attr_rst_all, 100, 706}, {?attr_js, 100, 1177}]
        }
    };

get(102671) ->
    {ok, #item_base{
            id = 102671
            ,name = <<"圣光护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_evasion, 100, 132}, {?attr_rst_all, 100, 441}, {?attr_js, 100, 736}]
        }
    };

get(102672) ->
    {ok, #item_base{
            id = 102672
            ,name = <<"圣光护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 1956}, {?attr_defence, 100, 978}, {?attr_evasion, 100, 156}, {?attr_rst_all, 100, 521}, {?attr_js, 100, 869}]
        }
    };

get(102673) ->
    {ok, #item_base{
            id = 102673
            ,name = <<"圣光护手">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2256}, {?attr_defence, 100, 1128}, {?attr_evasion, 100, 180}, {?attr_rst_all, 100, 601}, {?attr_js, 100, 1002}]
        }
    };

get(102674) ->
    {ok, #item_base{
            id = 102674
            ,name = <<"圣光护手">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2556}, {?attr_defence, 100, 1278}, {?attr_evasion, 100, 204}, {?attr_rst_all, 100, 681}, {?attr_js, 100, 1136}]
        }
    };

get(102675) ->
    {ok, #item_base{
            id = 102675
            ,name = <<"圣光护手">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_evasion, 100, 228}, {?attr_rst_all, 100, 761}, {?attr_js, 100, 1269}]
        }
    };

get(102676) ->
    {ok, #item_base{
            id = 102676
            ,name = <<"圣光护手">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 3156}, {?attr_defence, 100, 1578}, {?attr_evasion, 100, 252}, {?attr_rst_all, 100, 841}, {?attr_js, 100, 1402}]
        }
    };

get(102711) ->
    {ok, #item_base{
            id = 102711
            ,name = <<"咏诵护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 138}, {?attr_critrate, 100, 82}, {?attr_dmg_magic, 100, 69}]
        }
    };

get(102721) ->
    {ok, #item_base{
            id = 102721
            ,name = <<"法印护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 207}, {?attr_critrate, 100, 124}, {?attr_aspd, 100, 3}, {?attr_dmg_magic, 100, 103}, {?attr_js, 100, 276}]
        }
    };

get(102722) ->
    {ok, #item_base{
            id = 102722
            ,name = <<"法印护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = []
        }
    };

get(102731) ->
    {ok, #item_base{
            id = 102731
            ,name = <<"启示护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 276}, {?attr_critrate, 100, 165}, {?attr_aspd, 100, 4}, {?attr_dmg_magic, 100, 138}, {?attr_js, 100, 368}]
        }
    };

get(102732) ->
    {ok, #item_base{
            id = 102732
            ,name = <<"启示护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 376}, {?attr_critrate, 100, 225}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 188}, {?attr_js, 100, 501}]
        }
    };

get(102741) ->
    {ok, #item_base{
            id = 102741
            ,name = <<"符文护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 345}, {?attr_critrate, 100, 207}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 172}, {?attr_js, 100, 460}]
        }
    };

get(102742) ->
    {ok, #item_base{
            id = 102742
            ,name = <<"符文护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 445}, {?attr_critrate, 100, 267}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 222}, {?attr_js, 100, 593}]
        }
    };

get(102743) ->
    {ok, #item_base{
            id = 102743
            ,name = <<"符文护符">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 545}, {?attr_critrate, 100, 327}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 272}, {?attr_js, 100, 726}]
        }
    };

get(102751) ->
    {ok, #item_base{
            id = 102751
            ,name = <<"星辉护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 414}, {?attr_critrate, 100, 248}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 207}, {?attr_js, 100, 552}]
        }
    };

get(102752) ->
    {ok, #item_base{
            id = 102752
            ,name = <<"星辉护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 514}, {?attr_critrate, 100, 308}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 257}, {?attr_js, 100, 685}]
        }
    };

get(102753) ->
    {ok, #item_base{
            id = 102753
            ,name = <<"星辉护符">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 614}, {?attr_critrate, 100, 368}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 307}, {?attr_js, 100, 818}]
        }
    };

get(102754) ->
    {ok, #item_base{
            id = 102754
            ,name = <<"星辉护符">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 714}, {?attr_critrate, 100, 428}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 357}, {?attr_js, 100, 952}]
        }
    };

get(102761) ->
    {ok, #item_base{
            id = 102761
            ,name = <<"救赎护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 483}, {?attr_critrate, 100, 289}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 241}, {?attr_js, 100, 644}]
        }
    };

get(102762) ->
    {ok, #item_base{
            id = 102762
            ,name = <<"救赎护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 583}, {?attr_critrate, 100, 349}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 291}, {?attr_js, 100, 777}]
        }
    };

get(102763) ->
    {ok, #item_base{
            id = 102763
            ,name = <<"救赎护符">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 683}, {?attr_critrate, 100, 409}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 341}, {?attr_js, 100, 910}]
        }
    };

get(102764) ->
    {ok, #item_base{
            id = 102764
            ,name = <<"救赎护符">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 783}, {?attr_critrate, 100, 469}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 391}, {?attr_js, 100, 1044}]
        }
    };

get(102765) ->
    {ok, #item_base{
            id = 102765
            ,name = <<"救赎护符">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 883}, {?attr_critrate, 100, 529}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 441}, {?attr_js, 100, 1177}]
        }
    };

get(102771) ->
    {ok, #item_base{
            id = 102771
            ,name = <<"圣光护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 552}, {?attr_critrate, 100, 331}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 276}, {?attr_js, 100, 736}]
        }
    };

get(102772) ->
    {ok, #item_base{
            id = 102772
            ,name = <<"圣光护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 652}, {?attr_critrate, 100, 391}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 326}, {?attr_js, 100, 869}]
        }
    };

get(102773) ->
    {ok, #item_base{
            id = 102773
            ,name = <<"圣光护符">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 752}, {?attr_critrate, 100, 451}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 376}, {?attr_js, 100, 1002}]
        }
    };

get(102774) ->
    {ok, #item_base{
            id = 102774
            ,name = <<"圣光护符">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 852}, {?attr_critrate, 100, 511}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 426}, {?attr_js, 100, 1136}]
        }
    };

get(102775) ->
    {ok, #item_base{
            id = 102775
            ,name = <<"圣光护符">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 952}, {?attr_critrate, 100, 571}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 476}, {?attr_js, 100, 1269}]
        }
    };

get(102776) ->
    {ok, #item_base{
            id = 102776
            ,name = <<"圣光护符">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 210
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1052}, {?attr_critrate, 100, 631}, {?attr_aspd, 100, 13}, {?attr_dmg_magic, 100, 526}, {?attr_js, 100, 1402}]
        }
    };

get(102811) ->
    {ok, #item_base{
            id = 102811
            ,name = <<"咏诵戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 138}, {?attr_critrate, 100, 82}, {?attr_dmg_magic, 100, 69}]
        }
    };

get(102821) ->
    {ok, #item_base{
            id = 102821
            ,name = <<"法印戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 207}, {?attr_critrate, 100, 124}, {?attr_aspd, 100, 3}, {?attr_dmg_magic, 100, 103}, {?attr_js, 100, 276}]
        }
    };

get(102822) ->
    {ok, #item_base{
            id = 102822
            ,name = <<"法印戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = []
        }
    };

get(102831) ->
    {ok, #item_base{
            id = 102831
            ,name = <<"启示戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 276}, {?attr_critrate, 100, 165}, {?attr_aspd, 100, 4}, {?attr_dmg_magic, 100, 138}, {?attr_js, 100, 368}]
        }
    };

get(102832) ->
    {ok, #item_base{
            id = 102832
            ,name = <<"启示戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 376}, {?attr_critrate, 100, 225}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 188}, {?attr_js, 100, 501}]
        }
    };

get(102841) ->
    {ok, #item_base{
            id = 102841
            ,name = <<"符文戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 345}, {?attr_critrate, 100, 207}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 172}, {?attr_js, 100, 460}]
        }
    };

get(102842) ->
    {ok, #item_base{
            id = 102842
            ,name = <<"符文戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 445}, {?attr_critrate, 100, 267}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 222}, {?attr_js, 100, 593}]
        }
    };

get(102843) ->
    {ok, #item_base{
            id = 102843
            ,name = <<"符文戒指">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 545}, {?attr_critrate, 100, 327}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 272}, {?attr_js, 100, 726}]
        }
    };

get(102851) ->
    {ok, #item_base{
            id = 102851
            ,name = <<"星辉戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 414}, {?attr_critrate, 100, 248}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 207}, {?attr_js, 100, 552}]
        }
    };

get(102852) ->
    {ok, #item_base{
            id = 102852
            ,name = <<"星辉戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 514}, {?attr_critrate, 100, 308}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 257}, {?attr_js, 100, 685}]
        }
    };

get(102853) ->
    {ok, #item_base{
            id = 102853
            ,name = <<"星辉戒指">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 614}, {?attr_critrate, 100, 368}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 307}, {?attr_js, 100, 818}]
        }
    };

get(102854) ->
    {ok, #item_base{
            id = 102854
            ,name = <<"星辉戒指">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 714}, {?attr_critrate, 100, 428}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 357}, {?attr_js, 100, 952}]
        }
    };

get(102861) ->
    {ok, #item_base{
            id = 102861
            ,name = <<"救赎戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 483}, {?attr_critrate, 100, 289}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 241}, {?attr_js, 100, 644}]
        }
    };

get(102862) ->
    {ok, #item_base{
            id = 102862
            ,name = <<"救赎戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 583}, {?attr_critrate, 100, 349}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 291}, {?attr_js, 100, 777}]
        }
    };

get(102863) ->
    {ok, #item_base{
            id = 102863
            ,name = <<"救赎戒指">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 683}, {?attr_critrate, 100, 409}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 341}, {?attr_js, 100, 910}]
        }
    };

get(102864) ->
    {ok, #item_base{
            id = 102864
            ,name = <<"救赎戒指">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 783}, {?attr_critrate, 100, 469}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 391}, {?attr_js, 100, 1044}]
        }
    };

get(102865) ->
    {ok, #item_base{
            id = 102865
            ,name = <<"救赎戒指">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 883}, {?attr_critrate, 100, 529}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 441}, {?attr_js, 100, 1177}]
        }
    };

get(102871) ->
    {ok, #item_base{
            id = 102871
            ,name = <<"圣光戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 552}, {?attr_critrate, 100, 331}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 276}, {?attr_js, 100, 736}]
        }
    };

get(102872) ->
    {ok, #item_base{
            id = 102872
            ,name = <<"圣光戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 652}, {?attr_critrate, 100, 391}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 326}, {?attr_js, 100, 869}]
        }
    };

get(102873) ->
    {ok, #item_base{
            id = 102873
            ,name = <<"圣光戒指">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 752}, {?attr_critrate, 100, 451}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 376}, {?attr_js, 100, 1002}]
        }
    };

get(102874) ->
    {ok, #item_base{
            id = 102874
            ,name = <<"圣光戒指">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 852}, {?attr_critrate, 100, 511}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 426}, {?attr_js, 100, 1136}]
        }
    };

get(102875) ->
    {ok, #item_base{
            id = 102875
            ,name = <<"圣光戒指">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 952}, {?attr_critrate, 100, 571}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 476}, {?attr_js, 100, 1269}]
        }
    };

get(102876) ->
    {ok, #item_base{
            id = 102876
            ,name = <<"圣光戒指">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 210
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1052}, {?attr_critrate, 100, 631}, {?attr_aspd, 100, 13}, {?attr_dmg_magic, 100, 526}, {?attr_js, 100, 1402}]
        }
    };

get(102911) ->
    {ok, #item_base{
            id = 102911
            ,name = <<"咏诵项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 138}, {?attr_critrate, 100, 82}, {?attr_dmg_magic, 100, 69}]
        }
    };

get(102921) ->
    {ok, #item_base{
            id = 102921
            ,name = <<"法印项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 207}, {?attr_critrate, 100, 124}, {?attr_aspd, 100, 3}, {?attr_dmg_magic, 100, 103}, {?attr_js, 100, 276}]
        }
    };

get(102922) ->
    {ok, #item_base{
            id = 102922
            ,name = <<"法印项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 3}]
            ,attr = []
        }
    };

get(102931) ->
    {ok, #item_base{
            id = 102931
            ,name = <<"启示项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 276}, {?attr_critrate, 100, 165}, {?attr_aspd, 100, 4}, {?attr_dmg_magic, 100, 138}, {?attr_js, 100, 368}]
        }
    };

get(102932) ->
    {ok, #item_base{
            id = 102932
            ,name = <<"启示项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 376}, {?attr_critrate, 100, 225}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 188}, {?attr_js, 100, 501}]
        }
    };

get(102941) ->
    {ok, #item_base{
            id = 102941
            ,name = <<"符文项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 345}, {?attr_critrate, 100, 207}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 172}, {?attr_js, 100, 460}]
        }
    };

get(102942) ->
    {ok, #item_base{
            id = 102942
            ,name = <<"符文项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 445}, {?attr_critrate, 100, 267}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 222}, {?attr_js, 100, 593}]
        }
    };

get(102943) ->
    {ok, #item_base{
            id = 102943
            ,name = <<"符文项链">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 545}, {?attr_critrate, 100, 327}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 272}, {?attr_js, 100, 726}]
        }
    };

get(102951) ->
    {ok, #item_base{
            id = 102951
            ,name = <<"星辉项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 414}, {?attr_critrate, 100, 248}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 207}, {?attr_js, 100, 552}]
        }
    };

get(102952) ->
    {ok, #item_base{
            id = 102952
            ,name = <<"星辉项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 514}, {?attr_critrate, 100, 308}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 257}, {?attr_js, 100, 685}]
        }
    };

get(102953) ->
    {ok, #item_base{
            id = 102953
            ,name = <<"星辉项链">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 614}, {?attr_critrate, 100, 368}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 307}, {?attr_js, 100, 818}]
        }
    };

get(102954) ->
    {ok, #item_base{
            id = 102954
            ,name = <<"星辉项链">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 714}, {?attr_critrate, 100, 428}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 357}, {?attr_js, 100, 952}]
        }
    };

get(102961) ->
    {ok, #item_base{
            id = 102961
            ,name = <<"救赎项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 483}, {?attr_critrate, 100, 289}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 241}, {?attr_js, 100, 644}]
        }
    };

get(102962) ->
    {ok, #item_base{
            id = 102962
            ,name = <<"救赎项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 583}, {?attr_critrate, 100, 349}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 291}, {?attr_js, 100, 777}]
        }
    };

get(102963) ->
    {ok, #item_base{
            id = 102963
            ,name = <<"救赎项链">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 683}, {?attr_critrate, 100, 409}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 341}, {?attr_js, 100, 910}]
        }
    };

get(102964) ->
    {ok, #item_base{
            id = 102964
            ,name = <<"救赎项链">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 783}, {?attr_critrate, 100, 469}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 391}, {?attr_js, 100, 1044}]
        }
    };

get(102965) ->
    {ok, #item_base{
            id = 102965
            ,name = <<"救赎项链">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 883}, {?attr_critrate, 100, 529}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 441}, {?attr_js, 100, 1177}]
        }
    };

get(102971) ->
    {ok, #item_base{
            id = 102971
            ,name = <<"圣光项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 552}, {?attr_critrate, 100, 331}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 276}, {?attr_js, 100, 736}]
        }
    };

get(102972) ->
    {ok, #item_base{
            id = 102972
            ,name = <<"圣光项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 652}, {?attr_critrate, 100, 391}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 326}, {?attr_js, 100, 869}]
        }
    };

get(102973) ->
    {ok, #item_base{
            id = 102973
            ,name = <<"圣光项链">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 752}, {?attr_critrate, 100, 451}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 376}, {?attr_js, 100, 1002}]
        }
    };

get(102974) ->
    {ok, #item_base{
            id = 102974
            ,name = <<"圣光项链">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 852}, {?attr_critrate, 100, 511}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 426}, {?attr_js, 100, 1136}]
        }
    };

get(102975) ->
    {ok, #item_base{
            id = 102975
            ,name = <<"圣光项链">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 952}, {?attr_critrate, 100, 571}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 476}, {?attr_js, 100, 1269}]
        }
    };

get(102976) ->
    {ok, #item_base{
            id = 102976
            ,name = <<"圣光项链">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 210
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 1052}, {?attr_critrate, 100, 631}, {?attr_aspd, 100, 13}, {?attr_dmg_magic, 100, 526}, {?attr_js, 100, 1402}]
        }
    };

get(103011) ->
    {ok, #item_base{
            id = 103011
            ,name = <<"寂静之刃">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 276}, {?attr_critrate, 100, 27}, {?attr_hitrate, 100, 110}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 138}]
        }
    };

get(103021) ->
    {ok, #item_base{
            id = 103021
            ,name = <<"魅影之刃">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 414}, {?attr_critrate, 100, 41}, {?attr_hitrate, 100, 160}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 207}]
        }
    };

get(103022) ->
    {ok, #item_base{
            id = 103022
            ,name = <<"魅影之刃">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hitrate, 100, 0}]
        }
    };

get(103031) ->
    {ok, #item_base{
            id = 103031
            ,name = <<"血色之刃">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 552}, {?attr_critrate, 100, 55}, {?attr_hitrate, 100, 220}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 276}]
        }
    };

get(103032) ->
    {ok, #item_base{
            id = 103032
            ,name = <<"血色之刃">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 752}, {?attr_critrate, 100, 75}, {?attr_hitrate, 100, 300}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 376}]
        }
    };

get(103041) ->
    {ok, #item_base{
            id = 103041
            ,name = <<"幻灭之刃">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 690}, {?attr_critrate, 100, 69}, {?attr_hitrate, 100, 270}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 345}]
        }
    };

get(103042) ->
    {ok, #item_base{
            id = 103042
            ,name = <<"幻灭之刃">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 890}, {?attr_critrate, 100, 89}, {?attr_hitrate, 100, 350}, {?attr_aspd, 100, 14}, {?attr_dmg_magic, 100, 445}]
        }
    };

get(103043) ->
    {ok, #item_base{
            id = 103043
            ,name = <<"幻灭之刃">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1090}, {?attr_critrate, 100, 109}, {?attr_hitrate, 100, 430}, {?attr_aspd, 100, 17}, {?attr_dmg_magic, 100, 545}]
        }
    };

get(103051) ->
    {ok, #item_base{
            id = 103051
            ,name = <<"暗夜之刃">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 828}, {?attr_critrate, 100, 82}, {?attr_hitrate, 100, 330}, {?attr_aspd, 100, 15}, {?attr_dmg_magic, 100, 414}]
        }
    };

get(103052) ->
    {ok, #item_base{
            id = 103052
            ,name = <<"暗夜之刃">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1028}, {?attr_critrate, 100, 102}, {?attr_hitrate, 100, 410}, {?attr_aspd, 100, 17}, {?attr_dmg_magic, 100, 514}]
        }
    };

get(103053) ->
    {ok, #item_base{
            id = 103053
            ,name = <<"暗夜之刃">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1228}, {?attr_critrate, 100, 122}, {?attr_hitrate, 100, 490}, {?attr_aspd, 100, 20}, {?attr_dmg_magic, 100, 614}]
        }
    };

get(103054) ->
    {ok, #item_base{
            id = 103054
            ,name = <<"暗夜之刃">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1428}, {?attr_critrate, 100, 142}, {?attr_hitrate, 100, 570}, {?attr_aspd, 100, 22}, {?attr_dmg_magic, 100, 714}]
        }
    };

get(103061) ->
    {ok, #item_base{
            id = 103061
            ,name = <<"遗忘之刃">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 966}, {?attr_critrate, 100, 96}, {?attr_hitrate, 100, 380}, {?attr_aspd, 100, 17}, {?attr_dmg_magic, 100, 483}]
        }
    };

get(103062) ->
    {ok, #item_base{
            id = 103062
            ,name = <<"遗忘之刃">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1166}, {?attr_critrate, 100, 116}, {?attr_hitrate, 100, 460}, {?attr_aspd, 100, 19}, {?attr_dmg_magic, 100, 583}]
        }
    };

get(103063) ->
    {ok, #item_base{
            id = 103063
            ,name = <<"遗忘之刃">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1366}, {?attr_critrate, 100, 136}, {?attr_hitrate, 100, 540}, {?attr_aspd, 100, 22}, {?attr_dmg_magic, 100, 683}]
        }
    };

get(103064) ->
    {ok, #item_base{
            id = 103064
            ,name = <<"遗忘之刃">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1566}, {?attr_critrate, 100, 156}, {?attr_hitrate, 100, 620}, {?attr_aspd, 100, 24}, {?attr_dmg_magic, 100, 783}]
        }
    };

get(103065) ->
    {ok, #item_base{
            id = 103065
            ,name = <<"遗忘之刃">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1766}, {?attr_critrate, 100, 176}, {?attr_hitrate, 100, 700}, {?attr_aspd, 100, 27}, {?attr_dmg_magic, 100, 883}]
        }
    };

get(103071) ->
    {ok, #item_base{
            id = 103071
            ,name = <<"幽灵之刃">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1104}, {?attr_critrate, 100, 110}, {?attr_hitrate, 100, 440}, {?attr_aspd, 100, 20}, {?attr_dmg_magic, 100, 552}]
        }
    };

get(103072) ->
    {ok, #item_base{
            id = 103072
            ,name = <<"幽灵之刃">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1304}, {?attr_critrate, 100, 130}, {?attr_hitrate, 100, 520}, {?attr_aspd, 100, 22}, {?attr_dmg_magic, 100, 652}]
        }
    };

get(103073) ->
    {ok, #item_base{
            id = 103073
            ,name = <<"幽灵之刃">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1504}, {?attr_critrate, 100, 150}, {?attr_hitrate, 100, 600}, {?attr_aspd, 100, 25}, {?attr_dmg_magic, 100, 752}]
        }
    };

get(103074) ->
    {ok, #item_base{
            id = 103074
            ,name = <<"幽灵之刃">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1704}, {?attr_critrate, 100, 170}, {?attr_hitrate, 100, 680}, {?attr_aspd, 100, 27}, {?attr_dmg_magic, 100, 852}]
        }
    };

get(103075) ->
    {ok, #item_base{
            id = 103075
            ,name = <<"幽灵之刃">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1904}, {?attr_critrate, 100, 190}, {?attr_hitrate, 100, 760}, {?attr_aspd, 100, 30}, {?attr_dmg_magic, 100, 952}]
        }
    };

get(103076) ->
    {ok, #item_base{
            id = 103076
            ,name = <<"幽灵之刃">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 2104}, {?attr_critrate, 100, 210}, {?attr_hitrate, 100, 840}, {?attr_aspd, 100, 32}, {?attr_dmg_magic, 100, 1052}]
        }
    };

get(103111) ->
    {ok, #item_base{
            id = 103111
            ,name = <<"寂静护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 414}, {?attr_defence, 100, 207}, {?attr_hitrate, 100, 110}, {?attr_evasion, 100, 33}, {?attr_rst_all, 100, 110}, {?attr_js, 100, 184}]
        }
    };

get(103121) ->
    {ok, #item_base{
            id = 103121
            ,name = <<"魅影护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 621}, {?attr_defence, 100, 310}, {?attr_hitrate, 100, 160}, {?attr_evasion, 100, 49}, {?attr_rst_all, 100, 165}, {?attr_js, 100, 276}]
        }
    };

get(103122) ->
    {ok, #item_base{
            id = 103122
            ,name = <<"魅影护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hitrate, 100, 0}]
        }
    };

get(103131) ->
    {ok, #item_base{
            id = 103131
            ,name = <<"血色护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_hitrate, 100, 220}, {?attr_evasion, 100, 66}, {?attr_rst_all, 100, 220}, {?attr_js, 100, 368}]
        }
    };

get(103132) ->
    {ok, #item_base{
            id = 103132
            ,name = <<"血色护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1128}, {?attr_defence, 100, 564}, {?attr_hitrate, 100, 300}, {?attr_evasion, 100, 90}, {?attr_rst_all, 100, 300}, {?attr_js, 100, 501}]
        }
    };

get(103141) ->
    {ok, #item_base{
            id = 103141
            ,name = <<"幻灭护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1035}, {?attr_defence, 100, 517}, {?attr_hitrate, 100, 270}, {?attr_evasion, 100, 82}, {?attr_rst_all, 100, 276}, {?attr_js, 100, 460}]
        }
    };

get(103142) ->
    {ok, #item_base{
            id = 103142
            ,name = <<"幻灭护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1335}, {?attr_defence, 100, 667}, {?attr_hitrate, 100, 350}, {?attr_evasion, 100, 106}, {?attr_rst_all, 100, 356}, {?attr_js, 100, 593}]
        }
    };

get(103143) ->
    {ok, #item_base{
            id = 103143
            ,name = <<"幻灭护腕">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1635}, {?attr_defence, 100, 817}, {?attr_hitrate, 100, 430}, {?attr_evasion, 100, 130}, {?attr_rst_all, 100, 436}, {?attr_js, 100, 726}]
        }
    };

get(103151) ->
    {ok, #item_base{
            id = 103151
            ,name = <<"暗夜护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1242}, {?attr_defence, 100, 621}, {?attr_hitrate, 100, 330}, {?attr_evasion, 100, 99}, {?attr_rst_all, 100, 331}, {?attr_js, 100, 552}]
        }
    };

get(103152) ->
    {ok, #item_base{
            id = 103152
            ,name = <<"暗夜护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1542}, {?attr_defence, 100, 771}, {?attr_hitrate, 100, 410}, {?attr_evasion, 100, 123}, {?attr_rst_all, 100, 411}, {?attr_js, 100, 685}]
        }
    };

get(103153) ->
    {ok, #item_base{
            id = 103153
            ,name = <<"暗夜护腕">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1842}, {?attr_defence, 100, 921}, {?attr_hitrate, 100, 490}, {?attr_evasion, 100, 147}, {?attr_rst_all, 100, 491}, {?attr_js, 100, 818}]
        }
    };

get(103154) ->
    {ok, #item_base{
            id = 103154
            ,name = <<"暗夜护腕">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2142}, {?attr_defence, 100, 1071}, {?attr_hitrate, 100, 570}, {?attr_evasion, 100, 171}, {?attr_rst_all, 100, 571}, {?attr_js, 100, 952}]
        }
    };

get(103161) ->
    {ok, #item_base{
            id = 103161
            ,name = <<"遗忘护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1449}, {?attr_defence, 100, 724}, {?attr_hitrate, 100, 380}, {?attr_evasion, 100, 115}, {?attr_rst_all, 100, 386}, {?attr_js, 100, 644}]
        }
    };

get(103162) ->
    {ok, #item_base{
            id = 103162
            ,name = <<"遗忘护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1749}, {?attr_defence, 100, 874}, {?attr_hitrate, 100, 460}, {?attr_evasion, 100, 139}, {?attr_rst_all, 100, 466}, {?attr_js, 100, 777}]
        }
    };

get(103163) ->
    {ok, #item_base{
            id = 103163
            ,name = <<"遗忘护腕">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2049}, {?attr_defence, 100, 1024}, {?attr_hitrate, 100, 540}, {?attr_evasion, 100, 163}, {?attr_rst_all, 100, 546}, {?attr_js, 100, 910}]
        }
    };

get(103164) ->
    {ok, #item_base{
            id = 103164
            ,name = <<"遗忘护腕">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2349}, {?attr_defence, 100, 1174}, {?attr_hitrate, 100, 620}, {?attr_evasion, 100, 187}, {?attr_rst_all, 100, 626}, {?attr_js, 100, 1044}]
        }
    };

get(103165) ->
    {ok, #item_base{
            id = 103165
            ,name = <<"遗忘护腕">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2649}, {?attr_defence, 100, 1324}, {?attr_hitrate, 100, 700}, {?attr_evasion, 100, 211}, {?attr_rst_all, 100, 706}, {?attr_js, 100, 1177}]
        }
    };

get(103171) ->
    {ok, #item_base{
            id = 103171
            ,name = <<"幽灵护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_hitrate, 100, 440}, {?attr_evasion, 100, 132}, {?attr_rst_all, 100, 441}, {?attr_js, 100, 736}]
        }
    };

get(103172) ->
    {ok, #item_base{
            id = 103172
            ,name = <<"幽灵护腕">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1956}, {?attr_defence, 100, 978}, {?attr_hitrate, 100, 520}, {?attr_evasion, 100, 156}, {?attr_rst_all, 100, 521}, {?attr_js, 100, 869}]
        }
    };

get(103173) ->
    {ok, #item_base{
            id = 103173
            ,name = <<"幽灵护腕">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2256}, {?attr_defence, 100, 1128}, {?attr_hitrate, 100, 600}, {?attr_evasion, 100, 180}, {?attr_rst_all, 100, 601}, {?attr_js, 100, 1002}]
        }
    };

get(103174) ->
    {ok, #item_base{
            id = 103174
            ,name = <<"幽灵护腕">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2556}, {?attr_defence, 100, 1278}, {?attr_hitrate, 100, 680}, {?attr_evasion, 100, 204}, {?attr_rst_all, 100, 681}, {?attr_js, 100, 1136}]
        }
    };

get(103175) ->
    {ok, #item_base{
            id = 103175
            ,name = <<"幽灵护腕">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_hitrate, 100, 760}, {?attr_evasion, 100, 228}, {?attr_rst_all, 100, 761}, {?attr_js, 100, 1269}]
        }
    };

get(103176) ->
    {ok, #item_base{
            id = 103176
            ,name = <<"幽灵护腕">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3156}, {?attr_defence, 100, 1578}, {?attr_hitrate, 100, 840}, {?attr_evasion, 100, 252}, {?attr_rst_all, 100, 841}, {?attr_js, 100, 1402}]
        }
    };

get(103211) ->
    {ok, #item_base{
            id = 103211
            ,name = <<"寂静披风">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 552}, {?attr_defence, 100, 276}, {?attr_hitrate, 100, 110}, {?attr_tenacity, 100, 110}, {?attr_rst_all, 100, 82}]
        }
    };

get(103221) ->
    {ok, #item_base{
            id = 103221
            ,name = <<"魅影披风">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_hitrate, 100, 160}, {?attr_tenacity, 100, 165}, {?attr_rst_all, 100, 124}]
        }
    };

get(103222) ->
    {ok, #item_base{
            id = 103222
            ,name = <<"魅影披风">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hitrate, 100, 0}]
        }
    };

get(103231) ->
    {ok, #item_base{
            id = 103231
            ,name = <<"血色披风">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1104}, {?attr_defence, 100, 552}, {?attr_hitrate, 100, 220}, {?attr_tenacity, 100, 220}, {?attr_rst_all, 100, 165}]
        }
    };

get(103232) ->
    {ok, #item_base{
            id = 103232
            ,name = <<"血色披风">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1504}, {?attr_defence, 100, 752}, {?attr_hitrate, 100, 300}, {?attr_tenacity, 100, 300}, {?attr_rst_all, 100, 225}]
        }
    };

get(103241) ->
    {ok, #item_base{
            id = 103241
            ,name = <<"幻灭披风">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1380}, {?attr_defence, 100, 690}, {?attr_hitrate, 100, 270}, {?attr_tenacity, 100, 276}, {?attr_rst_all, 100, 207}]
        }
    };

get(103242) ->
    {ok, #item_base{
            id = 103242
            ,name = <<"幻灭披风">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1780}, {?attr_defence, 100, 890}, {?attr_hitrate, 100, 350}, {?attr_tenacity, 100, 356}, {?attr_rst_all, 100, 267}]
        }
    };

get(103243) ->
    {ok, #item_base{
            id = 103243
            ,name = <<"幻灭披风">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2180}, {?attr_defence, 100, 1090}, {?attr_hitrate, 100, 430}, {?attr_tenacity, 100, 436}, {?attr_rst_all, 100, 327}]
        }
    };

get(103251) ->
    {ok, #item_base{
            id = 103251
            ,name = <<"暗夜披风">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_hitrate, 100, 330}, {?attr_tenacity, 100, 331}, {?attr_rst_all, 100, 248}]
        }
    };

get(103252) ->
    {ok, #item_base{
            id = 103252
            ,name = <<"暗夜披风">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2056}, {?attr_defence, 100, 1028}, {?attr_hitrate, 100, 410}, {?attr_tenacity, 100, 411}, {?attr_rst_all, 100, 308}]
        }
    };

get(103253) ->
    {ok, #item_base{
            id = 103253
            ,name = <<"暗夜披风">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2456}, {?attr_defence, 100, 1228}, {?attr_hitrate, 100, 490}, {?attr_tenacity, 100, 491}, {?attr_rst_all, 100, 368}]
        }
    };

get(103254) ->
    {ok, #item_base{
            id = 103254
            ,name = <<"暗夜披风">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_hitrate, 100, 570}, {?attr_tenacity, 100, 571}, {?attr_rst_all, 100, 428}]
        }
    };

get(103261) ->
    {ok, #item_base{
            id = 103261
            ,name = <<"遗忘披风">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1932}, {?attr_defence, 100, 966}, {?attr_hitrate, 100, 380}, {?attr_tenacity, 100, 386}, {?attr_rst_all, 100, 289}]
        }
    };

get(103262) ->
    {ok, #item_base{
            id = 103262
            ,name = <<"遗忘披风">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2332}, {?attr_defence, 100, 1166}, {?attr_hitrate, 100, 460}, {?attr_tenacity, 100, 466}, {?attr_rst_all, 100, 349}]
        }
    };

get(103263) ->
    {ok, #item_base{
            id = 103263
            ,name = <<"遗忘披风">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2732}, {?attr_defence, 100, 1366}, {?attr_hitrate, 100, 540}, {?attr_tenacity, 100, 546}, {?attr_rst_all, 100, 409}]
        }
    };

get(103264) ->
    {ok, #item_base{
            id = 103264
            ,name = <<"遗忘披风">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3132}, {?attr_defence, 100, 1566}, {?attr_hitrate, 100, 620}, {?attr_tenacity, 100, 626}, {?attr_rst_all, 100, 469}]
        }
    };

get(103265) ->
    {ok, #item_base{
            id = 103265
            ,name = <<"遗忘披风">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3532}, {?attr_defence, 100, 1766}, {?attr_hitrate, 100, 700}, {?attr_tenacity, 100, 706}, {?attr_rst_all, 100, 529}]
        }
    };

get(103271) ->
    {ok, #item_base{
            id = 103271
            ,name = <<"幽灵披风">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2208}, {?attr_defence, 100, 1104}, {?attr_hitrate, 100, 440}, {?attr_tenacity, 100, 441}, {?attr_rst_all, 100, 331}]
        }
    };

get(103272) ->
    {ok, #item_base{
            id = 103272
            ,name = <<"幽灵披风">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2608}, {?attr_defence, 100, 1304}, {?attr_hitrate, 100, 520}, {?attr_tenacity, 100, 521}, {?attr_rst_all, 100, 391}]
        }
    };

get(103273) ->
    {ok, #item_base{
            id = 103273
            ,name = <<"幽灵披风">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3008}, {?attr_defence, 100, 1504}, {?attr_hitrate, 100, 600}, {?attr_tenacity, 100, 601}, {?attr_rst_all, 100, 451}]
        }
    };

get(103274) ->
    {ok, #item_base{
            id = 103274
            ,name = <<"幽灵披风">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3408}, {?attr_defence, 100, 1704}, {?attr_hitrate, 100, 680}, {?attr_tenacity, 100, 681}, {?attr_rst_all, 100, 511}]
        }
    };

get(103275) ->
    {ok, #item_base{
            id = 103275
            ,name = <<"幽灵披风">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3808}, {?attr_defence, 100, 1904}, {?attr_hitrate, 100, 760}, {?attr_tenacity, 100, 761}, {?attr_rst_all, 100, 571}]
        }
    };

get(103276) ->
    {ok, #item_base{
            id = 103276
            ,name = <<"幽灵披风">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 4208}, {?attr_defence, 100, 2104}, {?attr_hitrate, 100, 840}, {?attr_tenacity, 100, 841}, {?attr_rst_all, 100, 631}]
        }
    };

get(103311) ->
    {ok, #item_base{
            id = 103311
            ,name = <<"寂静衣摆">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 552}, {?attr_defence, 100, 276}, {?attr_hitrate, 100, 50}, {?attr_tenacity, 100, 82}, {?attr_rst_all, 100, 82}]
        }
    };

get(103321) ->
    {ok, #item_base{
            id = 103321
            ,name = <<"魅影衣摆">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_hitrate, 100, 50}, {?attr_tenacity, 100, 124}, {?attr_rst_all, 100, 124}]
        }
    };

get(103322) ->
    {ok, #item_base{
            id = 103322
            ,name = <<"魅影衣摆">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hitrate, 100, 50}]
        }
    };

get(103331) ->
    {ok, #item_base{
            id = 103331
            ,name = <<"血色衣摆">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1104}, {?attr_defence, 100, 552}, {?attr_tenacity, 100, 165}, {?attr_rst_all, 100, 165}]
        }
    };

get(103332) ->
    {ok, #item_base{
            id = 103332
            ,name = <<"血色衣摆">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1504}, {?attr_defence, 100, 752}, {?attr_tenacity, 100, 225}, {?attr_rst_all, 100, 225}]
        }
    };

get(103341) ->
    {ok, #item_base{
            id = 103341
            ,name = <<"幻灭衣摆">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1380}, {?attr_defence, 100, 690}, {?attr_tenacity, 100, 207}, {?attr_rst_all, 100, 207}]
        }
    };

get(103342) ->
    {ok, #item_base{
            id = 103342
            ,name = <<"幻灭衣摆">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1780}, {?attr_defence, 100, 890}, {?attr_tenacity, 100, 267}, {?attr_rst_all, 100, 267}]
        }
    };

get(103343) ->
    {ok, #item_base{
            id = 103343
            ,name = <<"幻灭衣摆">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2180}, {?attr_defence, 100, 1090}, {?attr_tenacity, 100, 327}, {?attr_rst_all, 100, 327}]
        }
    };

get(103351) ->
    {ok, #item_base{
            id = 103351
            ,name = <<"暗夜衣摆">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_tenacity, 100, 248}, {?attr_rst_all, 100, 248}]
        }
    };

get(103352) ->
    {ok, #item_base{
            id = 103352
            ,name = <<"暗夜衣摆">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2056}, {?attr_defence, 100, 1028}, {?attr_tenacity, 100, 308}, {?attr_rst_all, 100, 308}]
        }
    };

get(103353) ->
    {ok, #item_base{
            id = 103353
            ,name = <<"暗夜衣摆">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2456}, {?attr_defence, 100, 1228}, {?attr_tenacity, 100, 368}, {?attr_rst_all, 100, 368}]
        }
    };

get(103354) ->
    {ok, #item_base{
            id = 103354
            ,name = <<"暗夜衣摆">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_tenacity, 100, 428}, {?attr_rst_all, 100, 428}]
        }
    };

get(103361) ->
    {ok, #item_base{
            id = 103361
            ,name = <<"遗忘衣摆">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1932}, {?attr_defence, 100, 966}, {?attr_tenacity, 100, 289}, {?attr_rst_all, 100, 289}]
        }
    };

get(103362) ->
    {ok, #item_base{
            id = 103362
            ,name = <<"遗忘衣摆">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2332}, {?attr_defence, 100, 1166}, {?attr_tenacity, 100, 349}, {?attr_rst_all, 100, 349}]
        }
    };

get(103363) ->
    {ok, #item_base{
            id = 103363
            ,name = <<"遗忘衣摆">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2732}, {?attr_defence, 100, 1366}, {?attr_tenacity, 100, 409}, {?attr_rst_all, 100, 409}]
        }
    };

get(103364) ->
    {ok, #item_base{
            id = 103364
            ,name = <<"遗忘衣摆">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3132}, {?attr_defence, 100, 1566}, {?attr_tenacity, 100, 469}, {?attr_rst_all, 100, 469}]
        }
    };

get(103365) ->
    {ok, #item_base{
            id = 103365
            ,name = <<"遗忘衣摆">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3532}, {?attr_defence, 100, 1766}, {?attr_tenacity, 100, 529}, {?attr_rst_all, 100, 529}]
        }
    };

get(103371) ->
    {ok, #item_base{
            id = 103371
            ,name = <<"幽灵衣摆">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2208}, {?attr_defence, 100, 1104}, {?attr_tenacity, 100, 331}, {?attr_rst_all, 100, 331}]
        }
    };

get(103372) ->
    {ok, #item_base{
            id = 103372
            ,name = <<"幽灵衣摆">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2608}, {?attr_defence, 100, 1304}, {?attr_tenacity, 100, 391}, {?attr_rst_all, 100, 391}]
        }
    };

get(103373) ->
    {ok, #item_base{
            id = 103373
            ,name = <<"幽灵衣摆">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3008}, {?attr_defence, 100, 1504}, {?attr_tenacity, 100, 451}, {?attr_rst_all, 100, 451}]
        }
    };

get(103374) ->
    {ok, #item_base{
            id = 103374
            ,name = <<"幽灵衣摆">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3408}, {?attr_defence, 100, 1704}, {?attr_tenacity, 100, 511}, {?attr_rst_all, 100, 511}]
        }
    };

get(103375) ->
    {ok, #item_base{
            id = 103375
            ,name = <<"幽灵衣摆">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3808}, {?attr_defence, 100, 1904}, {?attr_tenacity, 100, 571}, {?attr_rst_all, 100, 571}]
        }
    };

get(103376) ->
    {ok, #item_base{
            id = 103376
            ,name = <<"幽灵衣摆">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 4208}, {?attr_defence, 100, 2104}, {?attr_tenacity, 100, 631}, {?attr_rst_all, 100, 631}]
        }
    };

get(103411) ->
    {ok, #item_base{
            id = 103411
            ,name = <<"寂静长靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 414}, {?attr_defence, 100, 207}, {?attr_tenacity, 100, 82}, {?attr_rst_all, 100, 82}]
        }
    };

get(103421) ->
    {ok, #item_base{
            id = 103421
            ,name = <<"魅影长靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 621}, {?attr_defence, 100, 310}, {?attr_tenacity, 100, 124}, {?attr_rst_all, 100, 124}]
        }
    };

get(103422) ->
    {ok, #item_base{
            id = 103422
            ,name = <<"魅影长靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = []
        }
    };

get(103431) ->
    {ok, #item_base{
            id = 103431
            ,name = <<"血色长靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_tenacity, 100, 165}, {?attr_rst_all, 100, 165}]
        }
    };

get(103432) ->
    {ok, #item_base{
            id = 103432
            ,name = <<"血色长靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1128}, {?attr_defence, 100, 564}, {?attr_tenacity, 100, 225}, {?attr_rst_all, 100, 225}]
        }
    };

get(103441) ->
    {ok, #item_base{
            id = 103441
            ,name = <<"幻灭长靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1035}, {?attr_defence, 100, 517}, {?attr_tenacity, 100, 207}, {?attr_rst_all, 100, 207}]
        }
    };

get(103442) ->
    {ok, #item_base{
            id = 103442
            ,name = <<"幻灭长靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1335}, {?attr_defence, 100, 667}, {?attr_tenacity, 100, 267}, {?attr_rst_all, 100, 267}]
        }
    };

get(103443) ->
    {ok, #item_base{
            id = 103443
            ,name = <<"幻灭长靴">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1635}, {?attr_defence, 100, 817}, {?attr_tenacity, 100, 327}, {?attr_rst_all, 100, 327}]
        }
    };

get(103451) ->
    {ok, #item_base{
            id = 103451
            ,name = <<"暗夜长靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1242}, {?attr_defence, 100, 621}, {?attr_tenacity, 100, 248}, {?attr_rst_all, 100, 248}]
        }
    };

get(103452) ->
    {ok, #item_base{
            id = 103452
            ,name = <<"暗夜长靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1542}, {?attr_defence, 100, 771}, {?attr_tenacity, 100, 308}, {?attr_rst_all, 100, 308}]
        }
    };

get(103453) ->
    {ok, #item_base{
            id = 103453
            ,name = <<"暗夜长靴">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1842}, {?attr_defence, 100, 921}, {?attr_tenacity, 100, 368}, {?attr_rst_all, 100, 368}]
        }
    };

get(103454) ->
    {ok, #item_base{
            id = 103454
            ,name = <<"暗夜长靴">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2142}, {?attr_defence, 100, 1071}, {?attr_tenacity, 100, 428}, {?attr_rst_all, 100, 428}]
        }
    };

get(103461) ->
    {ok, #item_base{
            id = 103461
            ,name = <<"遗忘长靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1449}, {?attr_defence, 100, 724}, {?attr_tenacity, 100, 289}, {?attr_rst_all, 100, 289}]
        }
    };

get(103462) ->
    {ok, #item_base{
            id = 103462
            ,name = <<"遗忘长靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1749}, {?attr_defence, 100, 874}, {?attr_tenacity, 100, 349}, {?attr_rst_all, 100, 349}]
        }
    };

get(103463) ->
    {ok, #item_base{
            id = 103463
            ,name = <<"遗忘长靴">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2049}, {?attr_defence, 100, 1024}, {?attr_tenacity, 100, 409}, {?attr_rst_all, 100, 409}]
        }
    };

get(103464) ->
    {ok, #item_base{
            id = 103464
            ,name = <<"遗忘长靴">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2349}, {?attr_defence, 100, 1174}, {?attr_tenacity, 100, 469}, {?attr_rst_all, 100, 469}]
        }
    };

get(103465) ->
    {ok, #item_base{
            id = 103465
            ,name = <<"遗忘长靴">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2649}, {?attr_defence, 100, 1324}, {?attr_tenacity, 100, 529}, {?attr_rst_all, 100, 529}]
        }
    };

get(103471) ->
    {ok, #item_base{
            id = 103471
            ,name = <<"幽灵长靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_tenacity, 100, 331}, {?attr_rst_all, 100, 331}]
        }
    };

get(103472) ->
    {ok, #item_base{
            id = 103472
            ,name = <<"幽灵长靴">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1956}, {?attr_defence, 100, 978}, {?attr_tenacity, 100, 391}, {?attr_rst_all, 100, 391}]
        }
    };

get(103473) ->
    {ok, #item_base{
            id = 103473
            ,name = <<"幽灵长靴">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2256}, {?attr_defence, 100, 1128}, {?attr_tenacity, 100, 451}, {?attr_rst_all, 100, 451}]
        }
    };

get(103474) ->
    {ok, #item_base{
            id = 103474
            ,name = <<"幽灵长靴">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2556}, {?attr_defence, 100, 1278}, {?attr_tenacity, 100, 511}, {?attr_rst_all, 100, 511}]
        }
    };

get(103475) ->
    {ok, #item_base{
            id = 103475
            ,name = <<"幽灵长靴">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_tenacity, 100, 571}, {?attr_rst_all, 100, 571}]
        }
    };

get(103476) ->
    {ok, #item_base{
            id = 103476
            ,name = <<"幽灵长靴">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3156}, {?attr_defence, 100, 1578}, {?attr_tenacity, 100, 631}, {?attr_rst_all, 100, 631}]
        }
    };

get(103511) ->
    {ok, #item_base{
            id = 103511
            ,name = <<"寂静腰环">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 414}, {?attr_defence, 100, 207}, {?attr_evasion, 100, 44}, {?attr_rst_all, 100, 82}]
        }
    };

get(103521) ->
    {ok, #item_base{
            id = 103521
            ,name = <<"魅影腰环">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 621}, {?attr_defence, 100, 310}, {?attr_evasion, 100, 66}, {?attr_rst_all, 100, 124}]
        }
    };

get(103522) ->
    {ok, #item_base{
            id = 103522
            ,name = <<"魅影腰环">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = []
        }
    };

get(103531) ->
    {ok, #item_base{
            id = 103531
            ,name = <<"血色腰环">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_evasion, 100, 88}, {?attr_rst_all, 100, 165}]
        }
    };

get(103532) ->
    {ok, #item_base{
            id = 103532
            ,name = <<"血色腰环">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1128}, {?attr_defence, 100, 564}, {?attr_evasion, 100, 120}, {?attr_rst_all, 100, 225}]
        }
    };

get(103541) ->
    {ok, #item_base{
            id = 103541
            ,name = <<"幻灭腰环">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1035}, {?attr_defence, 100, 517}, {?attr_evasion, 100, 110}, {?attr_rst_all, 100, 207}]
        }
    };

get(103542) ->
    {ok, #item_base{
            id = 103542
            ,name = <<"幻灭腰环">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1335}, {?attr_defence, 100, 667}, {?attr_evasion, 100, 142}, {?attr_rst_all, 100, 267}]
        }
    };

get(103543) ->
    {ok, #item_base{
            id = 103543
            ,name = <<"幻灭腰环">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1635}, {?attr_defence, 100, 817}, {?attr_evasion, 100, 174}, {?attr_rst_all, 100, 327}]
        }
    };

get(103551) ->
    {ok, #item_base{
            id = 103551
            ,name = <<"暗夜腰环">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1242}, {?attr_defence, 100, 621}, {?attr_evasion, 100, 132}, {?attr_rst_all, 100, 248}]
        }
    };

get(103552) ->
    {ok, #item_base{
            id = 103552
            ,name = <<"暗夜腰环">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1542}, {?attr_defence, 100, 771}, {?attr_evasion, 100, 164}, {?attr_rst_all, 100, 308}]
        }
    };

get(103553) ->
    {ok, #item_base{
            id = 103553
            ,name = <<"暗夜腰环">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1842}, {?attr_defence, 100, 921}, {?attr_evasion, 100, 196}, {?attr_rst_all, 100, 368}]
        }
    };

get(103554) ->
    {ok, #item_base{
            id = 103554
            ,name = <<"暗夜腰环">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2142}, {?attr_defence, 100, 1071}, {?attr_evasion, 100, 228}, {?attr_rst_all, 100, 428}]
        }
    };

get(103561) ->
    {ok, #item_base{
            id = 103561
            ,name = <<"遗忘腰环">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1449}, {?attr_defence, 100, 724}, {?attr_evasion, 100, 154}, {?attr_rst_all, 100, 289}]
        }
    };

get(103562) ->
    {ok, #item_base{
            id = 103562
            ,name = <<"遗忘腰环">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1749}, {?attr_defence, 100, 874}, {?attr_evasion, 100, 186}, {?attr_rst_all, 100, 349}]
        }
    };

get(103563) ->
    {ok, #item_base{
            id = 103563
            ,name = <<"遗忘腰环">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2049}, {?attr_defence, 100, 1024}, {?attr_evasion, 100, 218}, {?attr_rst_all, 100, 409}]
        }
    };

get(103564) ->
    {ok, #item_base{
            id = 103564
            ,name = <<"遗忘腰环">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2349}, {?attr_defence, 100, 1174}, {?attr_evasion, 100, 250}, {?attr_rst_all, 100, 469}]
        }
    };

get(103565) ->
    {ok, #item_base{
            id = 103565
            ,name = <<"遗忘腰环">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2649}, {?attr_defence, 100, 1324}, {?attr_evasion, 100, 282}, {?attr_rst_all, 100, 529}]
        }
    };

get(103571) ->
    {ok, #item_base{
            id = 103571
            ,name = <<"幽灵腰环">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_evasion, 100, 176}, {?attr_rst_all, 100, 331}]
        }
    };

get(103572) ->
    {ok, #item_base{
            id = 103572
            ,name = <<"幽灵腰环">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1956}, {?attr_defence, 100, 978}, {?attr_evasion, 100, 208}, {?attr_rst_all, 100, 391}]
        }
    };

get(103573) ->
    {ok, #item_base{
            id = 103573
            ,name = <<"幽灵腰环">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2256}, {?attr_defence, 100, 1128}, {?attr_evasion, 100, 240}, {?attr_rst_all, 100, 451}]
        }
    };

get(103574) ->
    {ok, #item_base{
            id = 103574
            ,name = <<"幽灵腰环">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2556}, {?attr_defence, 100, 1278}, {?attr_evasion, 100, 272}, {?attr_rst_all, 100, 511}]
        }
    };

get(103575) ->
    {ok, #item_base{
            id = 103575
            ,name = <<"幽灵腰环">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_evasion, 100, 304}, {?attr_rst_all, 100, 571}]
        }
    };

get(103576) ->
    {ok, #item_base{
            id = 103576
            ,name = <<"幽灵腰环">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3156}, {?attr_defence, 100, 1578}, {?attr_evasion, 100, 336}, {?attr_rst_all, 100, 631}]
        }
    };

get(103611) ->
    {ok, #item_base{
            id = 103611
            ,name = <<"寂静护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 414}, {?attr_defence, 100, 207}, {?attr_evasion, 100, 33}, {?attr_rst_all, 100, 110}, {?attr_js, 100, 184}]
        }
    };

get(103621) ->
    {ok, #item_base{
            id = 103621
            ,name = <<"魅影护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 621}, {?attr_defence, 100, 310}, {?attr_evasion, 100, 49}, {?attr_rst_all, 100, 165}, {?attr_js, 100, 276}]
        }
    };

get(103622) ->
    {ok, #item_base{
            id = 103622
            ,name = <<"魅影护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = []
        }
    };

get(103631) ->
    {ok, #item_base{
            id = 103631
            ,name = <<"血色护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 828}, {?attr_defence, 100, 414}, {?attr_evasion, 100, 66}, {?attr_rst_all, 100, 220}, {?attr_js, 100, 368}]
        }
    };

get(103632) ->
    {ok, #item_base{
            id = 103632
            ,name = <<"血色护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1128}, {?attr_defence, 100, 564}, {?attr_evasion, 100, 90}, {?attr_rst_all, 100, 300}, {?attr_js, 100, 501}]
        }
    };

get(103641) ->
    {ok, #item_base{
            id = 103641
            ,name = <<"幻灭护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1035}, {?attr_defence, 100, 517}, {?attr_evasion, 100, 82}, {?attr_rst_all, 100, 276}, {?attr_js, 100, 460}]
        }
    };

get(103642) ->
    {ok, #item_base{
            id = 103642
            ,name = <<"幻灭护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1335}, {?attr_defence, 100, 667}, {?attr_evasion, 100, 106}, {?attr_rst_all, 100, 356}, {?attr_js, 100, 593}]
        }
    };

get(103643) ->
    {ok, #item_base{
            id = 103643
            ,name = <<"幻灭护手">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1635}, {?attr_defence, 100, 817}, {?attr_evasion, 100, 130}, {?attr_rst_all, 100, 436}, {?attr_js, 100, 726}]
        }
    };

get(103651) ->
    {ok, #item_base{
            id = 103651
            ,name = <<"暗夜护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1242}, {?attr_defence, 100, 621}, {?attr_evasion, 100, 99}, {?attr_rst_all, 100, 331}, {?attr_js, 100, 552}]
        }
    };

get(103652) ->
    {ok, #item_base{
            id = 103652
            ,name = <<"暗夜护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1542}, {?attr_defence, 100, 771}, {?attr_evasion, 100, 123}, {?attr_rst_all, 100, 411}, {?attr_js, 100, 685}]
        }
    };

get(103653) ->
    {ok, #item_base{
            id = 103653
            ,name = <<"暗夜护手">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1842}, {?attr_defence, 100, 921}, {?attr_evasion, 100, 147}, {?attr_rst_all, 100, 491}, {?attr_js, 100, 818}]
        }
    };

get(103654) ->
    {ok, #item_base{
            id = 103654
            ,name = <<"暗夜护手">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2142}, {?attr_defence, 100, 1071}, {?attr_evasion, 100, 171}, {?attr_rst_all, 100, 571}, {?attr_js, 100, 952}]
        }
    };

get(103661) ->
    {ok, #item_base{
            id = 103661
            ,name = <<"遗忘护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1449}, {?attr_defence, 100, 724}, {?attr_evasion, 100, 115}, {?attr_rst_all, 100, 386}, {?attr_js, 100, 644}]
        }
    };

get(103662) ->
    {ok, #item_base{
            id = 103662
            ,name = <<"遗忘护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1749}, {?attr_defence, 100, 874}, {?attr_evasion, 100, 139}, {?attr_rst_all, 100, 466}, {?attr_js, 100, 777}]
        }
    };

get(103663) ->
    {ok, #item_base{
            id = 103663
            ,name = <<"遗忘护手">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2049}, {?attr_defence, 100, 1024}, {?attr_evasion, 100, 163}, {?attr_rst_all, 100, 546}, {?attr_js, 100, 910}]
        }
    };

get(103664) ->
    {ok, #item_base{
            id = 103664
            ,name = <<"遗忘护手">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2349}, {?attr_defence, 100, 1174}, {?attr_evasion, 100, 187}, {?attr_rst_all, 100, 626}, {?attr_js, 100, 1044}]
        }
    };

get(103665) ->
    {ok, #item_base{
            id = 103665
            ,name = <<"遗忘护手">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2649}, {?attr_defence, 100, 1324}, {?attr_evasion, 100, 211}, {?attr_rst_all, 100, 706}, {?attr_js, 100, 1177}]
        }
    };

get(103671) ->
    {ok, #item_base{
            id = 103671
            ,name = <<"幽灵护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1656}, {?attr_defence, 100, 828}, {?attr_evasion, 100, 132}, {?attr_rst_all, 100, 441}, {?attr_js, 100, 736}]
        }
    };

get(103672) ->
    {ok, #item_base{
            id = 103672
            ,name = <<"幽灵护手">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 120
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 1956}, {?attr_defence, 100, 978}, {?attr_evasion, 100, 156}, {?attr_rst_all, 100, 521}, {?attr_js, 100, 869}]
        }
    };

get(103673) ->
    {ok, #item_base{
            id = 103673
            ,name = <<"幽灵护手">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 130
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2256}, {?attr_defence, 100, 1128}, {?attr_evasion, 100, 180}, {?attr_rst_all, 100, 601}, {?attr_js, 100, 1002}]
        }
    };

get(103674) ->
    {ok, #item_base{
            id = 103674
            ,name = <<"幽灵护手">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 140
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2556}, {?attr_defence, 100, 1278}, {?attr_evasion, 100, 204}, {?attr_rst_all, 100, 681}, {?attr_js, 100, 1136}]
        }
    };

get(103675) ->
    {ok, #item_base{
            id = 103675
            ,name = <<"幽灵护手">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 150
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 2856}, {?attr_defence, 100, 1428}, {?attr_evasion, 100, 228}, {?attr_rst_all, 100, 761}, {?attr_js, 100, 1269}]
        }
    };

get(103676) ->
    {ok, #item_base{
            id = 103676
            ,name = <<"幽灵护手">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 160
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 3156}, {?attr_defence, 100, 1578}, {?attr_evasion, 100, 252}, {?attr_rst_all, 100, 841}, {?attr_js, 100, 1402}]
        }
    };

get(103711) ->
    {ok, #item_base{
            id = 103711
            ,name = <<"寂静护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 138}, {?attr_critrate, 100, 82}, {?attr_dmg_magic, 100, 69}]
        }
    };

get(103721) ->
    {ok, #item_base{
            id = 103721
            ,name = <<"魅影护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 207}, {?attr_critrate, 100, 124}, {?attr_aspd, 100, 3}, {?attr_dmg_magic, 100, 103}, {?attr_js, 100, 276}]
        }
    };

get(103722) ->
    {ok, #item_base{
            id = 103722
            ,name = <<"魅影护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = []
        }
    };

get(103731) ->
    {ok, #item_base{
            id = 103731
            ,name = <<"血色护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 276}, {?attr_critrate, 100, 165}, {?attr_aspd, 100, 4}, {?attr_dmg_magic, 100, 138}, {?attr_js, 100, 368}]
        }
    };

get(103732) ->
    {ok, #item_base{
            id = 103732
            ,name = <<"血色护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 376}, {?attr_critrate, 100, 225}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 188}, {?attr_js, 100, 501}]
        }
    };

get(103741) ->
    {ok, #item_base{
            id = 103741
            ,name = <<"幻灭护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 345}, {?attr_critrate, 100, 207}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 172}, {?attr_js, 100, 460}]
        }
    };

get(103742) ->
    {ok, #item_base{
            id = 103742
            ,name = <<"幻灭护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 445}, {?attr_critrate, 100, 267}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 222}, {?attr_js, 100, 593}]
        }
    };

get(103743) ->
    {ok, #item_base{
            id = 103743
            ,name = <<"幻灭护符">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 545}, {?attr_critrate, 100, 327}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 272}, {?attr_js, 100, 726}]
        }
    };

get(103751) ->
    {ok, #item_base{
            id = 103751
            ,name = <<"暗夜护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 414}, {?attr_critrate, 100, 248}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 207}, {?attr_js, 100, 552}]
        }
    };

get(103752) ->
    {ok, #item_base{
            id = 103752
            ,name = <<"暗夜护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 514}, {?attr_critrate, 100, 308}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 257}, {?attr_js, 100, 685}]
        }
    };

get(103753) ->
    {ok, #item_base{
            id = 103753
            ,name = <<"暗夜护符">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 614}, {?attr_critrate, 100, 368}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 307}, {?attr_js, 100, 818}]
        }
    };

get(103754) ->
    {ok, #item_base{
            id = 103754
            ,name = <<"暗夜护符">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 714}, {?attr_critrate, 100, 428}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 357}, {?attr_js, 100, 952}]
        }
    };

get(103761) ->
    {ok, #item_base{
            id = 103761
            ,name = <<"遗忘护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 483}, {?attr_critrate, 100, 289}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 241}, {?attr_js, 100, 644}]
        }
    };

get(103762) ->
    {ok, #item_base{
            id = 103762
            ,name = <<"遗忘护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 583}, {?attr_critrate, 100, 349}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 291}, {?attr_js, 100, 777}]
        }
    };

get(103763) ->
    {ok, #item_base{
            id = 103763
            ,name = <<"遗忘护符">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 683}, {?attr_critrate, 100, 409}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 341}, {?attr_js, 100, 910}]
        }
    };

get(103764) ->
    {ok, #item_base{
            id = 103764
            ,name = <<"遗忘护符">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 783}, {?attr_critrate, 100, 469}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 391}, {?attr_js, 100, 1044}]
        }
    };

get(103765) ->
    {ok, #item_base{
            id = 103765
            ,name = <<"遗忘护符">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 883}, {?attr_critrate, 100, 529}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 441}, {?attr_js, 100, 1177}]
        }
    };

get(103771) ->
    {ok, #item_base{
            id = 103771
            ,name = <<"幽灵护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 552}, {?attr_critrate, 100, 331}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 276}, {?attr_js, 100, 736}]
        }
    };

get(103772) ->
    {ok, #item_base{
            id = 103772
            ,name = <<"幽灵护符">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 652}, {?attr_critrate, 100, 391}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 326}, {?attr_js, 100, 869}]
        }
    };

get(103773) ->
    {ok, #item_base{
            id = 103773
            ,name = <<"幽灵护符">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 752}, {?attr_critrate, 100, 451}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 376}, {?attr_js, 100, 1002}]
        }
    };

get(103774) ->
    {ok, #item_base{
            id = 103774
            ,name = <<"幽灵护符">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 852}, {?attr_critrate, 100, 511}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 426}, {?attr_js, 100, 1136}]
        }
    };

get(103775) ->
    {ok, #item_base{
            id = 103775
            ,name = <<"幽灵护符">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 952}, {?attr_critrate, 100, 571}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 476}, {?attr_js, 100, 1269}]
        }
    };

get(103776) ->
    {ok, #item_base{
            id = 103776
            ,name = <<"幽灵护符">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 210
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1052}, {?attr_critrate, 100, 631}, {?attr_aspd, 100, 13}, {?attr_dmg_magic, 100, 526}, {?attr_js, 100, 1402}]
        }
    };

get(103811) ->
    {ok, #item_base{
            id = 103811
            ,name = <<"寂静戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 138}, {?attr_critrate, 100, 82}, {?attr_dmg_magic, 100, 69}]
        }
    };

get(103821) ->
    {ok, #item_base{
            id = 103821
            ,name = <<"魅影戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 207}, {?attr_critrate, 100, 124}, {?attr_aspd, 100, 3}, {?attr_dmg_magic, 100, 103}, {?attr_js, 100, 276}]
        }
    };

get(103822) ->
    {ok, #item_base{
            id = 103822
            ,name = <<"魅影戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = []
        }
    };

get(103831) ->
    {ok, #item_base{
            id = 103831
            ,name = <<"血色戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 276}, {?attr_critrate, 100, 165}, {?attr_aspd, 100, 4}, {?attr_dmg_magic, 100, 138}, {?attr_js, 100, 368}]
        }
    };

get(103832) ->
    {ok, #item_base{
            id = 103832
            ,name = <<"血色戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 376}, {?attr_critrate, 100, 225}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 188}, {?attr_js, 100, 501}]
        }
    };

get(103841) ->
    {ok, #item_base{
            id = 103841
            ,name = <<"幻灭戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 345}, {?attr_critrate, 100, 207}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 172}, {?attr_js, 100, 460}]
        }
    };

get(103842) ->
    {ok, #item_base{
            id = 103842
            ,name = <<"幻灭戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 445}, {?attr_critrate, 100, 267}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 222}, {?attr_js, 100, 593}]
        }
    };

get(103843) ->
    {ok, #item_base{
            id = 103843
            ,name = <<"幻灭戒指">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 545}, {?attr_critrate, 100, 327}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 272}, {?attr_js, 100, 726}]
        }
    };

get(103851) ->
    {ok, #item_base{
            id = 103851
            ,name = <<"暗夜戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 414}, {?attr_critrate, 100, 248}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 207}, {?attr_js, 100, 552}]
        }
    };

get(103852) ->
    {ok, #item_base{
            id = 103852
            ,name = <<"暗夜戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 514}, {?attr_critrate, 100, 308}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 257}, {?attr_js, 100, 685}]
        }
    };

get(103853) ->
    {ok, #item_base{
            id = 103853
            ,name = <<"暗夜戒指">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 614}, {?attr_critrate, 100, 368}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 307}, {?attr_js, 100, 818}]
        }
    };

get(103854) ->
    {ok, #item_base{
            id = 103854
            ,name = <<"暗夜戒指">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 714}, {?attr_critrate, 100, 428}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 357}, {?attr_js, 100, 952}]
        }
    };

get(103861) ->
    {ok, #item_base{
            id = 103861
            ,name = <<"遗忘戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 483}, {?attr_critrate, 100, 289}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 241}, {?attr_js, 100, 644}]
        }
    };

get(103862) ->
    {ok, #item_base{
            id = 103862
            ,name = <<"遗忘戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 583}, {?attr_critrate, 100, 349}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 291}, {?attr_js, 100, 777}]
        }
    };

get(103863) ->
    {ok, #item_base{
            id = 103863
            ,name = <<"遗忘戒指">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 683}, {?attr_critrate, 100, 409}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 341}, {?attr_js, 100, 910}]
        }
    };

get(103864) ->
    {ok, #item_base{
            id = 103864
            ,name = <<"遗忘戒指">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 783}, {?attr_critrate, 100, 469}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 391}, {?attr_js, 100, 1044}]
        }
    };

get(103865) ->
    {ok, #item_base{
            id = 103865
            ,name = <<"遗忘戒指">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 883}, {?attr_critrate, 100, 529}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 441}, {?attr_js, 100, 1177}]
        }
    };

get(103871) ->
    {ok, #item_base{
            id = 103871
            ,name = <<"幽灵戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 552}, {?attr_critrate, 100, 331}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 276}, {?attr_js, 100, 736}]
        }
    };

get(103872) ->
    {ok, #item_base{
            id = 103872
            ,name = <<"幽灵戒指">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 652}, {?attr_critrate, 100, 391}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 326}, {?attr_js, 100, 869}]
        }
    };

get(103873) ->
    {ok, #item_base{
            id = 103873
            ,name = <<"幽灵戒指">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 752}, {?attr_critrate, 100, 451}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 376}, {?attr_js, 100, 1002}]
        }
    };

get(103874) ->
    {ok, #item_base{
            id = 103874
            ,name = <<"幽灵戒指">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 852}, {?attr_critrate, 100, 511}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 426}, {?attr_js, 100, 1136}]
        }
    };

get(103875) ->
    {ok, #item_base{
            id = 103875
            ,name = <<"幽灵戒指">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 952}, {?attr_critrate, 100, 571}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 476}, {?attr_js, 100, 1269}]
        }
    };

get(103876) ->
    {ok, #item_base{
            id = 103876
            ,name = <<"幽灵戒指">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 210
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1052}, {?attr_critrate, 100, 631}, {?attr_aspd, 100, 13}, {?attr_dmg_magic, 100, 526}, {?attr_js, 100, 1402}]
        }
    };

get(103911) ->
    {ok, #item_base{
            id = 103911
            ,name = <<"寂静项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 10}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 138}, {?attr_critrate, 100, 82}, {?attr_dmg_magic, 100, 69}]
        }
    };

get(103921) ->
    {ok, #item_base{
            id = 103921
            ,name = <<"魅影项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 207}, {?attr_critrate, 100, 124}, {?attr_aspd, 100, 3}, {?attr_dmg_magic, 100, 103}, {?attr_js, 100, 276}]
        }
    };

get(103922) ->
    {ok, #item_base{
            id = 103922
            ,name = <<"魅影项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}, #condition{label = career, target_value = 2}]
            ,attr = []
        }
    };

get(103931) ->
    {ok, #item_base{
            id = 103931
            ,name = <<"血色项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 276}, {?attr_critrate, 100, 165}, {?attr_aspd, 100, 4}, {?attr_dmg_magic, 100, 138}, {?attr_js, 100, 368}]
        }
    };

get(103932) ->
    {ok, #item_base{
            id = 103932
            ,name = <<"血色项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 30}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 376}, {?attr_critrate, 100, 225}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 188}, {?attr_js, 100, 501}]
        }
    };

get(103941) ->
    {ok, #item_base{
            id = 103941
            ,name = <<"幻灭项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 345}, {?attr_critrate, 100, 207}, {?attr_aspd, 100, 5}, {?attr_dmg_magic, 100, 172}, {?attr_js, 100, 460}]
        }
    };

get(103942) ->
    {ok, #item_base{
            id = 103942
            ,name = <<"幻灭项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 445}, {?attr_critrate, 100, 267}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 222}, {?attr_js, 100, 593}]
        }
    };

get(103943) ->
    {ok, #item_base{
            id = 103943
            ,name = <<"幻灭项链">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 545}, {?attr_critrate, 100, 327}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 272}, {?attr_js, 100, 726}]
        }
    };

get(103951) ->
    {ok, #item_base{
            id = 103951
            ,name = <<"暗夜项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 414}, {?attr_critrate, 100, 248}, {?attr_aspd, 100, 6}, {?attr_dmg_magic, 100, 207}, {?attr_js, 100, 552}]
        }
    };

get(103952) ->
    {ok, #item_base{
            id = 103952
            ,name = <<"暗夜项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 514}, {?attr_critrate, 100, 308}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 257}, {?attr_js, 100, 685}]
        }
    };

get(103953) ->
    {ok, #item_base{
            id = 103953
            ,name = <<"暗夜项链">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 614}, {?attr_critrate, 100, 368}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 307}, {?attr_js, 100, 818}]
        }
    };

get(103954) ->
    {ok, #item_base{
            id = 103954
            ,name = <<"暗夜项链">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 714}, {?attr_critrate, 100, 428}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 357}, {?attr_js, 100, 952}]
        }
    };

get(103961) ->
    {ok, #item_base{
            id = 103961
            ,name = <<"遗忘项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 483}, {?attr_critrate, 100, 289}, {?attr_aspd, 100, 7}, {?attr_dmg_magic, 100, 241}, {?attr_js, 100, 644}]
        }
    };

get(103962) ->
    {ok, #item_base{
            id = 103962
            ,name = <<"遗忘项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 583}, {?attr_critrate, 100, 349}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 291}, {?attr_js, 100, 777}]
        }
    };

get(103963) ->
    {ok, #item_base{
            id = 103963
            ,name = <<"遗忘项链">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 683}, {?attr_critrate, 100, 409}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 341}, {?attr_js, 100, 910}]
        }
    };

get(103964) ->
    {ok, #item_base{
            id = 103964
            ,name = <<"遗忘项链">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 783}, {?attr_critrate, 100, 469}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 391}, {?attr_js, 100, 1044}]
        }
    };

get(103965) ->
    {ok, #item_base{
            id = 103965
            ,name = <<"遗忘项链">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 883}, {?attr_critrate, 100, 529}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 441}, {?attr_js, 100, 1177}]
        }
    };

get(103971) ->
    {ok, #item_base{
            id = 103971
            ,name = <<"幽灵项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 552}, {?attr_critrate, 100, 331}, {?attr_aspd, 100, 8}, {?attr_dmg_magic, 100, 276}, {?attr_js, 100, 736}]
        }
    };

get(103972) ->
    {ok, #item_base{
            id = 103972
            ,name = <<"幽灵项链">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,set_id = 170
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 652}, {?attr_critrate, 100, 391}, {?attr_aspd, 100, 9}, {?attr_dmg_magic, 100, 326}, {?attr_js, 100, 869}]
        }
    };

get(103973) ->
    {ok, #item_base{
            id = 103973
            ,name = <<"幽灵项链">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 180
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 752}, {?attr_critrate, 100, 451}, {?attr_aspd, 100, 10}, {?attr_dmg_magic, 100, 376}, {?attr_js, 100, 1002}]
        }
    };

get(103974) ->
    {ok, #item_base{
            id = 103974
            ,name = <<"幽灵项链">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,set_id = 190
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 852}, {?attr_critrate, 100, 511}, {?attr_aspd, 100, 11}, {?attr_dmg_magic, 100, 426}, {?attr_js, 100, 1136}]
        }
    };

get(103975) ->
    {ok, #item_base{
            id = 103975
            ,name = <<"幽灵项链">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 200
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 952}, {?attr_critrate, 100, 571}, {?attr_aspd, 100, 12}, {?attr_dmg_magic, 100, 476}, {?attr_js, 100, 1269}]
        }
    };

get(103976) ->
    {ok, #item_base{
            id = 103976
            ,name = <<"幽灵项链">>
            ,type = 10
            ,quality = 6
            ,overlap = 1
            ,set_id = 210
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 70}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 1052}, {?attr_critrate, 100, 631}, {?attr_aspd, 100, 13}, {?attr_dmg_magic, 100, 526}, {?attr_js, 100, 1402}]
        }
    };

get(106001) ->
    {ok, #item_base{
            id = 106001
            ,name = <<"玫瑰隐蝶之衣">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  480}, {?attr_hp_max,  100,  1172}, {?attr_rst_all,  100,  248}, {?attr_tenacity,  100,  93},{?attr_looks_id, 100, 105}]
            ,attr = []
        }
    };

get(106002) ->
    {ok, #item_base{
            id = 106002
            ,name = <<"夜莺追风之衣">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  480}, {?attr_hp_max,  100,  1172}, {?attr_rst_all,  100,  248}, {?attr_tenacity,  100,  93},{?attr_looks_id, 100, 105}]
            ,attr = []
        }
    };

get(106203) ->
    {ok, #item_base{
            id = 106203
            ,name = <<"玫瑰隐蝶头饰">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  332}, {?attr_rst_all,  100,  194}, {?attr_evasion,  100,  43}, {?attr_critrate,  100,  90},{?attr_looks_id, 100, 105}]
            ,attr = []
        }
    };

get(106204) ->
    {ok, #item_base{
            id = 106204
            ,name = <<"夜莺追风头饰">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  332}, {?attr_rst_all,  100,  194}, {?attr_evasion,  100,  43}, {?attr_critrate,  100,  90},{?attr_looks_id, 100, 105}]
            ,attr = []
        }
    };

get(106105) ->
    {ok, #item_base{
            id = 106105
            ,name = <<"玫瑰隐蝶武饰">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_dmg,  100, 217}, {?attr_critrate,  100,  73}, {?attr_hitrate,  100, 35}, {?attr_dmg_magic,  100, 93},{?attr_looks_id, 100, 105}]
            ,attr = []
        }
    };

get(106106) ->
    {ok, #item_base{
            id = 106106
            ,name = <<"夜莺追风武饰">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_dmg,  100, 217}, {?attr_critrate,  100,  73}, {?attr_hitrate,  100, 35}, {?attr_dmg_magic,  100, 93},{?attr_looks_id, 100, 105}]
            ,attr = []
        }
    };

get(106007) ->
    {ok, #item_base{
            id = 106007
            ,name = <<"夜影神恩之衣">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  959}, {?attr_hp_max,  100,  2344}, {?attr_rst_all,  100,  495}, {?attr_tenacity,  100,  186},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106008) ->
    {ok, #item_base{
            id = 106008
            ,name = <<"夜影神佑之衣">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  959}, {?attr_hp_max,  100,  2344}, {?attr_rst_all,  100,  495}, {?attr_tenacity,  100,  186},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106209) ->
    {ok, #item_base{
            id = 106209
            ,name = <<"夜影神恩头饰">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  663}, {?attr_rst_all,  100,  388}, {?attr_evasion,  100,  86}, {?attr_critrate,  100,  180},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106210) ->
    {ok, #item_base{
            id = 106210
            ,name = <<"夜影神佑头饰">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  663}, {?attr_rst_all,  100,  388}, {?attr_evasion,  100,  86}, {?attr_critrate,  100,  180},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106111) ->
    {ok, #item_base{
            id = 106111
            ,name = <<"夜影神恩武饰">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_dmg,  100, 434}, {?attr_critrate,  100,  145}, {?attr_hitrate,  100, 69}, {?attr_dmg_magic,  100, 186},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106112) ->
    {ok, #item_base{
            id = 106112
            ,name = <<"夜影神佑武饰">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_dmg,  100, 434}, {?attr_critrate,  100,  145}, {?attr_hitrate,  100, 69}, {?attr_dmg_magic,  100, 186},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106013) ->
    {ok, #item_base{
            id = 106013
            ,name = <<"黑桃公主之衣">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  480}, {?attr_hp_max,  100,  1172}, {?attr_rst_all,  100,  248}, {?attr_tenacity,  100,  93},{?attr_looks_id, 100, 103}]
            ,attr = []
        }
    };

get(106014) ->
    {ok, #item_base{
            id = 106014
            ,name = <<"宫廷法师之衣">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  480}, {?attr_hp_max,  100,  1172}, {?attr_rst_all,  100,  248}, {?attr_tenacity,  100,  93},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106215) ->
    {ok, #item_base{
            id = 106215
            ,name = <<"黑桃公主头饰">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  332}, {?attr_rst_all,  100,  194}, {?attr_evasion,  100,  43}, {?attr_critrate,  100,  90},{?attr_looks_id, 100, 103}]
            ,attr = []
        }
    };

get(106216) ->
    {ok, #item_base{
            id = 106216
            ,name = <<"宫廷法师头饰">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  332}, {?attr_rst_all,  100,  194}, {?attr_evasion,  100,  43}, {?attr_critrate,  100,  90},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106117) ->
    {ok, #item_base{
            id = 106117
            ,name = <<"黑桃公主武饰">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_dmg,  100, 217}, {?attr_critrate,  100,  73}, {?attr_hitrate,  100, 35}, {?attr_dmg_magic,  100, 93},{?attr_looks_id, 100, 103}]
            ,attr = []
        }
    };

get(106118) ->
    {ok, #item_base{
            id = 106118
            ,name = <<"宫廷法师武饰">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_dmg,  100, 217}, {?attr_critrate,  100,  73}, {?attr_hitrate,  100, 35}, {?attr_dmg_magic,  100, 93},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106019) ->
    {ok, #item_base{
            id = 106019
            ,name = <<"水晶圣约之衣">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  959}, {?attr_hp_max,  100,  2344}, {?attr_rst_all,  100,  495}, {?attr_tenacity,  100,  186},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106020) ->
    {ok, #item_base{
            id = 106020
            ,name = <<"永夜血族之衣">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  959}, {?attr_hp_max,  100,  2344}, {?attr_rst_all,  100,  495}, {?attr_tenacity,  100,  186},{?attr_looks_id, 100, 103}]
            ,attr = []
        }
    };

get(106221) ->
    {ok, #item_base{
            id = 106221
            ,name = <<"水晶圣约头饰">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  663}, {?attr_rst_all,  100,  388}, {?attr_evasion,  100,  86}, {?attr_critrate,  100,  180},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106222) ->
    {ok, #item_base{
            id = 106222
            ,name = <<"永夜血族头饰">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  663}, {?attr_rst_all,  100,  388}, {?attr_evasion,  100,  86}, {?attr_critrate,  100,  180},{?attr_looks_id, 100, 103}]
            ,attr = []
        }
    };

get(106123) ->
    {ok, #item_base{
            id = 106123
            ,name = <<"水晶圣约武饰">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_dmg,  100, 434}, {?attr_critrate,  100,  145}, {?attr_hitrate,  100, 69}, {?attr_dmg_magic,  100, 186},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106124) ->
    {ok, #item_base{
            id = 106124
            ,name = <<"永夜血族武饰">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_dmg,  100, 434}, {?attr_critrate,  100,  145}, {?attr_hitrate,  100, 69}, {?attr_dmg_magic,  100, 186},{?attr_looks_id, 100, 103}]
            ,attr = []
        }
    };

get(106025) ->
    {ok, #item_base{
            id = 106025
            ,name = <<"蔚蓝叹息之衣">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  480}, {?attr_hp_max,  100,  1172}, {?attr_rst_all,  100,  248}, {?attr_tenacity,  100,  93},{?attr_looks_id, 100, 104}]
            ,attr = []
        }
    };

get(106026) ->
    {ok, #item_base{
            id = 106026
            ,name = <<"苍蓝勇气之衣">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  480}, {?attr_hp_max,  100,  1172}, {?attr_rst_all,  100,  248}, {?attr_tenacity,  100,  93},{?attr_looks_id, 100, 104}]
            ,attr = []
        }
    };

get(106227) ->
    {ok, #item_base{
            id = 106227
            ,name = <<"蔚蓝叹息头饰">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  332}, {?attr_rst_all,  100,  194}, {?attr_evasion,  100,  43}, {?attr_critrate,  100,  90},{?attr_looks_id, 100, 104}]
            ,attr = []
        }
    };

get(106228) ->
    {ok, #item_base{
            id = 106228
            ,name = <<"苍蓝勇气头饰">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  332}, {?attr_rst_all,  100,  194}, {?attr_evasion,  100,  43}, {?attr_critrate,  100,  90},{?attr_looks_id, 100, 104}]
            ,attr = []
        }
    };

get(106129) ->
    {ok, #item_base{
            id = 106129
            ,name = <<"蔚蓝叹息武饰">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_dmg,  100, 217}, {?attr_critrate,  100,  73}, {?attr_hitrate,  100, 35}, {?attr_dmg_magic,  100, 93},{?attr_looks_id, 100, 104}]
            ,attr = []
        }
    };

get(106130) ->
    {ok, #item_base{
            id = 106130
            ,name = <<"苍蓝勇气武饰">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_dmg,  100, 217}, {?attr_critrate,  100,  73}, {?attr_hitrate,  100, 35}, {?attr_dmg_magic,  100, 93},{?attr_looks_id, 100, 104}]
            ,attr = []
        }
    };

get(106031) ->
    {ok, #item_base{
            id = 106031
            ,name = <<"黑曜幻想之衣">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  959}, {?attr_hp_max,  100,  2344}, {?attr_rst_all,  100,  495}, {?attr_tenacity,  100,  186},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106032) ->
    {ok, #item_base{
            id = 106032
            ,name = <<"黑曜残阳之衣">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  959}, {?attr_hp_max,  100,  2344}, {?attr_rst_all,  100,  495}, {?attr_tenacity,  100,  186},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106233) ->
    {ok, #item_base{
            id = 106233
            ,name = <<"黑曜幻想头饰">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  663}, {?attr_rst_all,  100,  388}, {?attr_evasion,  100,  86}, {?attr_critrate,  100,  180},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106234) ->
    {ok, #item_base{
            id = 106234
            ,name = <<"黑曜残阳头饰">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_defence,  100,  663}, {?attr_rst_all,  100,  388}, {?attr_evasion,  100,  86}, {?attr_critrate,  100,  180},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106135) ->
    {ok, #item_base{
            id = 106135
            ,name = <<"黑曜幻想武饰">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_dmg,  100, 434}, {?attr_critrate,  100,  145}, {?attr_hitrate,  100, 69}, {?attr_dmg_magic,  100, 186},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106136) ->
    {ok, #item_base{
            id = 106136
            ,name = <<"黑曜残阳武饰">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,188},{1,560},{2,1060}]}]
			,effect = [{?attr_dmg,  100, 434}, {?attr_critrate,  100,  145}, {?attr_hitrate,  100, 69}, {?attr_dmg_magic,  100, 186},{?attr_looks_id, 100, 101}]
            ,attr = []
        }
    };

get(106301) ->
    {ok, #item_base{
            id = 106301
            ,name = <<"启航之翼">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,set_id = 500
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}]
            ,value = [{buy_npc, [{0,168},{1,480},{2,880}]}]
			,effect = [{?attr_hp_max,  100,  1540}, {?attr_rst_all,  100,  385}, {?attr_hitrate,  100,  56}, {?attr_js,  100,  137},{?attr_looks_id, 100, 100}]
            ,attr = []
        }
    };

get(106302) ->
    {ok, #item_base{
            id = 106302
            ,name = <<"米迦勒之翼">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = sex, target_value = 0}]
            ,value = [{buy_npc, [{0,168},{1,480},{2,880}]}]
			,effect = [{?attr_hp_max,  100,  3080}, {?attr_rst_all,  100,  769}, {?attr_hitrate,  100,  111}, {?attr_js,  100,  274},{?attr_looks_id, 100, 103}]
            ,attr = []
        }
    };

get(106303) ->
    {ok, #item_base{
            id = 106303
            ,name = <<"路西法之翼">>
            ,type = 10
            ,quality = 5
            ,overlap = 1
            ,set_id = 520
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = sex, target_value = 1}]
            ,value = [{buy_npc, [{0,168},{1,480},{2,880}]}]
			,effect = [{?attr_hp_max,  100,  3080}, {?attr_rst_all,  100,  769}, {?attr_hitrate,  100,  111}, {?attr_js,  100,  274},{?attr_looks_id, 100, 102}]
            ,attr = []
        }
    };

get(107123) ->
    {ok, #item_base{
            id = 107123
            ,name = <<"日影鳞甲（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_hitrate,   8,  12}, {?attr_evasion,   8,  12}]
            ,attr = []
        }
    };

get(107124) ->
    {ok, #item_base{
            id = 107124
            ,name = <<"日影鳞甲（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_defence,  280,  343}, {?attr_tenacity,  10,  15}]
            ,attr = []
        }
    };

get(107221) ->
    {ok, #item_base{
            id = 107221
            ,name = <<"日影胫甲（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_hp_max,  850,  981}, {?attr_mp_max,   58,  78}]
            ,attr = []
        }
    };

get(107222) ->
    {ok, #item_base{
            id = 107222
            ,name = <<"日影胫甲（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_dmg,   45,  57}, {?attr_critrate,   10,  15}]
            ,attr = []
        }
    };

get(107223) ->
    {ok, #item_base{
            id = 107223
            ,name = <<"日影胫甲（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_hitrate,   8,  12}, {?attr_evasion,   8,  12}]
            ,attr = []
        }
    };

get(107224) ->
    {ok, #item_base{
            id = 107224
            ,name = <<"日影胫甲（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_defence,  280,  343}, {?attr_tenacity,  10,  15}]
            ,attr = []
        }
    };

get(107321) ->
    {ok, #item_base{
            id = 107321
            ,name = <<"日影兽戒（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_hp_max,   580,  654}, {?attr_mp_max,   40,  52}]
            ,attr = []
        }
    };

get(107322) ->
    {ok, #item_base{
            id = 107322
            ,name = <<"日影兽戒（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_dmg,   28,  38}, {?attr_critrate,   6,  10}]
            ,attr = []
        }
    };

get(107323) ->
    {ok, #item_base{
            id = 107323
            ,name = <<"日影兽戒（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_hitrate,  4,  8}, {?attr_evasion,   4,  8}]
            ,attr = []
        }
    };

get(107324) ->
    {ok, #item_base{
            id = 107324
            ,name = <<"日影兽戒（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_defence,  180,  229}, {?attr_tenacity,  6,  10}]
            ,attr = []
        }
    };

get(107421) ->
    {ok, #item_base{
            id = 107421
            ,name = <<"日影利爪（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_hp_max,   580,  654}, {?attr_mp_max,   40,  52}]
            ,attr = []
        }
    };

get(107422) ->
    {ok, #item_base{
            id = 107422
            ,name = <<"日影利爪（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_dmg,   28,  38}, {?attr_critrate,   6,  10}]
            ,attr = []
        }
    };

get(107423) ->
    {ok, #item_base{
            id = 107423
            ,name = <<"日影利爪（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_hitrate,  4,  8}, {?attr_evasion,   4,  8}]
            ,attr = []
        }
    };

get(107424) ->
    {ok, #item_base{
            id = 107424
            ,name = <<"日影利爪（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_defence,  180,  229}, {?attr_tenacity,  6,  10}]
            ,attr = []
        }
    };

get(107521) ->
    {ok, #item_base{
            id = 107521
            ,name = <<"日影龙石（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_hp_max,   720,  818}, {?attr_mp_max,   45,  65}]
            ,attr = []
        }
    };

get(107522) ->
    {ok, #item_base{
            id = 107522
            ,name = <<"日影龙石（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_dmg,   36,  48}, {?attr_critrate,   8,  12}]
            ,attr = []
        }
    };

get(107523) ->
    {ok, #item_base{
            id = 107523
            ,name = <<"日影龙石（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_hitrate,   6,  10}, {?attr_evasion,   6,  10}]
            ,attr = []
        }
    };

get(107524) ->
    {ok, #item_base{
            id = 107524
            ,name = <<"日影龙石（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_defence,  230,  286}, {?attr_tenacity,  8,  12}]
            ,attr = []
        }
    };

get(107621) ->
    {ok, #item_base{
            id = 107621
            ,name = <<"日影火焰（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_hp_max,   1000,  1362}, {?attr_mp_max,   80,  109}]
            ,attr = []
        }
    };

get(107622) ->
    {ok, #item_base{
            id = 107622
            ,name = <<"日影火焰（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_dmg,   60,  79}, {?attr_critrate,  15,  20}]
            ,attr = []
        }
    };

get(107623) ->
    {ok, #item_base{
            id = 107623
            ,name = <<"日影火焰（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_hitrate,   12,  17}, {?attr_evasion,   12,  17}]
            ,attr = []
        }
    };

get(107624) ->
    {ok, #item_base{
            id = 107624
            ,name = <<"日影火焰（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1600}]
			,effect = [{?attr_defence,  390,  477}, {?attr_tenacity,  15,  20}]
            ,attr = []
        }
    };

get(107125) ->
    {ok, #item_base{
            id = 107125
            ,name = <<"日影鳞甲（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_hp_max,  1118,  1332}, {?attr_mp_max,   86,  107}]
            ,attr = []
        }
    };

get(107126) ->
    {ok, #item_base{
            id = 107126
            ,name = <<"日影鳞甲（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_dmg,   60,  78}, {?attr_critrate,   15,  20}]
            ,attr = []
        }
    };

get(107127) ->
    {ok, #item_base{
            id = 107127
            ,name = <<"日影鳞甲（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_hitrate,   12,  17}, {?attr_evasion,   12,  17}]
            ,attr = []
        }
    };

get(107128) ->
    {ok, #item_base{
            id = 107128
            ,name = <<"日影鳞甲（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_defence,  350,  466}, {?attr_tenacity,  15,  20}]
            ,attr = []
        }
    };

get(107225) ->
    {ok, #item_base{
            id = 107225
            ,name = <<"日影胫甲（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_hp_max,  1118,  1332}, {?attr_mp_max,   86,  107}]
            ,attr = []
        }
    };

get(107226) ->
    {ok, #item_base{
            id = 107226
            ,name = <<"日影胫甲（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_dmg,   60,  78}, {?attr_critrate,   15,  20}]
            ,attr = []
        }
    };

get(107227) ->
    {ok, #item_base{
            id = 107227
            ,name = <<"日影胫甲（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_hitrate,   12,  17}, {?attr_evasion,   12,  17}]
            ,attr = []
        }
    };

get(107228) ->
    {ok, #item_base{
            id = 107228
            ,name = <<"日影胫甲（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_defence,  350,  466}, {?attr_tenacity,  15,  20}]
            ,attr = []
        }
    };

get(107325) ->
    {ok, #item_base{
            id = 107325
            ,name = <<"日影兽戒（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_hp_max,   688,  888}, {?attr_mp_max,   50,  71}]
            ,attr = []
        }
    };

get(107326) ->
    {ok, #item_base{
            id = 107326
            ,name = <<"日影兽戒（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_dmg,   40,  52}, {?attr_critrate,   8,  13}]
            ,attr = []
        }
    };

get(107327) ->
    {ok, #item_base{
            id = 107327
            ,name = <<"日影兽戒（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_hitrate,   7,  11}, {?attr_evasion,   7,  11}]
            ,attr = []
        }
    };

get(107328) ->
    {ok, #item_base{
            id = 107328
            ,name = <<"日影兽戒（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_defence,  260,  311}, {?attr_tenacity,  8,  13}]
            ,attr = []
        }
    };

get(107425) ->
    {ok, #item_base{
            id = 107425
            ,name = <<"日影利爪（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_hp_max,   688,  888}, {?attr_mp_max,   50,  71}]
            ,attr = []
        }
    };

get(107426) ->
    {ok, #item_base{
            id = 107426
            ,name = <<"日影利爪（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_dmg,   40,  52}, {?attr_critrate,   8,  13}]
            ,attr = []
        }
    };

get(107427) ->
    {ok, #item_base{
            id = 107427
            ,name = <<"日影利爪（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_hitrate,   7,  11}, {?attr_evasion,   7,  11}]
            ,attr = []
        }
    };

get(107428) ->
    {ok, #item_base{
            id = 107428
            ,name = <<"日影利爪（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_defence,  260,  311}, {?attr_tenacity,  8,  13}]
            ,attr = []
        }
    };

get(107525) ->
    {ok, #item_base{
            id = 107525
            ,name = <<"日影龙石（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_hp_max,   888,  1110}, {?attr_mp_max,   50,  71}]
            ,attr = []
        }
    };

get(107526) ->
    {ok, #item_base{
            id = 107526
            ,name = <<"日影龙石（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_dmg,   49,  65}, {?attr_critrate,  11,  17}]
            ,attr = []
        }
    };

get(107527) ->
    {ok, #item_base{
            id = 107527
            ,name = <<"日影龙石（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_hitrate,   8,  14}, {?attr_evasion,   8,  14}]
            ,attr = []
        }
    };

get(107528) ->
    {ok, #item_base{
            id = 107528
            ,name = <<"日影龙石（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_defence,  300,  389}, {?attr_tenacity,  11,  17}]
            ,attr = []
        }
    };

get(107625) ->
    {ok, #item_base{
            id = 107625
            ,name = <<"日影火焰（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_hp_max,  1500,  1850}, {?attr_mp_max,   88,  148}]
            ,attr = []
        }
    };

get(107626) ->
    {ok, #item_base{
            id = 107626
            ,name = <<"日影火焰（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_dmg,   88,  108}, {?attr_critrate,   20,  28}]
            ,attr = []
        }
    };

get(107627) ->
    {ok, #item_base{
            id = 107627
            ,name = <<"日影火焰（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_hitrate,   16,  23}, {?attr_evasion,   16,  23}]
            ,attr = []
        }
    };

get(107628) ->
    {ok, #item_base{
            id = 107628
            ,name = <<"日影火焰（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 3200}]
			,effect = [{?attr_defence,  550,  648}, {?attr_tenacity,  20,  28}]
            ,attr = []
        }
    };

get(107131) ->
    {ok, #item_base{
            id = 107131
            ,name = <<"烈日鳞甲（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_hp_max,  1200,  1575}, {?attr_mp_max,   90,  126}]
            ,attr = []
        }
    };

get(107132) ->
    {ok, #item_base{
            id = 107132
            ,name = <<"烈日鳞甲（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_dmg,   72,  92}, {?attr_critrate,   18,  24}]
            ,attr = []
        }
    };

get(107133) ->
    {ok, #item_base{
            id = 107133
            ,name = <<"烈日鳞甲（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_hitrate,   15,  20}, {?attr_evasion,   15,  20}]
            ,attr = []
        }
    };

get(107134) ->
    {ok, #item_base{
            id = 107134
            ,name = <<"烈日鳞甲（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_defence,  444,  551}, {?attr_tenacity,  18,  24}]
            ,attr = []
        }
    };

get(107231) ->
    {ok, #item_base{
            id = 107231
            ,name = <<"烈日胫甲（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_hp_max,  1200,  1575}, {?attr_mp_max,   90,  126}]
            ,attr = []
        }
    };

get(107232) ->
    {ok, #item_base{
            id = 107232
            ,name = <<"烈日胫甲（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_dmg,   72,  92}, {?attr_critrate,   18,  24}]
            ,attr = []
        }
    };

get(107233) ->
    {ok, #item_base{
            id = 107233
            ,name = <<"烈日胫甲（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_hitrate,   15,  20}, {?attr_evasion,   15,  20}]
            ,attr = []
        }
    };

get(107234) ->
    {ok, #item_base{
            id = 107234
            ,name = <<"烈日胫甲（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_defence,  444,  551}, {?attr_tenacity,  18,  24}]
            ,attr = []
        }
    };

get(107331) ->
    {ok, #item_base{
            id = 107331
            ,name = <<"烈日兽戒（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_hp_max,   850,  1050}, {?attr_mp_max,   64,  84}]
            ,attr = []
        }
    };

get(107332) ->
    {ok, #item_base{
            id = 107332
            ,name = <<"烈日兽戒（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_dmg,   45,  61}, {?attr_critrate,   9,  16}]
            ,attr = []
        }
    };

get(107333) ->
    {ok, #item_base{
            id = 107333
            ,name = <<"烈日兽戒（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_hitrate,   8,  13}, {?attr_evasion,   8,  13}]
            ,attr = []
        }
    };

get(107334) ->
    {ok, #item_base{
            id = 107334
            ,name = <<"烈日兽戒（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_defence,  288,  368}, {?attr_tenacity,  9,  16}]
            ,attr = []
        }
    };

get(107431) ->
    {ok, #item_base{
            id = 107431
            ,name = <<"烈日利爪（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_hp_max,   850,  1050}, {?attr_mp_max,   64,  84}]
            ,attr = []
        }
    };

get(107432) ->
    {ok, #item_base{
            id = 107432
            ,name = <<"烈日利爪（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_dmg,   45,  61}, {?attr_critrate,   9,  16}]
            ,attr = []
        }
    };

get(107433) ->
    {ok, #item_base{
            id = 107433
            ,name = <<"烈日利爪（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_hitrate,   8,  13}, {?attr_evasion,   8,  13}]
            ,attr = []
        }
    };

get(107434) ->
    {ok, #item_base{
            id = 107434
            ,name = <<"烈日利爪（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_defence,  288,  368}, {?attr_tenacity,  9,  16}]
            ,attr = []
        }
    };

get(107531) ->
    {ok, #item_base{
            id = 107531
            ,name = <<"烈日龙石（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_hp_max,   1111,  1312}, {?attr_mp_max,   85,  105}]
            ,attr = []
        }
    };

get(107532) ->
    {ok, #item_base{
            id = 107532
            ,name = <<"烈日龙石（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_dmg,   64,  77}, {?attr_critrate,   15,  20}]
            ,attr = []
        }
    };

get(107533) ->
    {ok, #item_base{
            id = 107533
            ,name = <<"烈日龙石（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_hitrate,   11,  16}, {?attr_evasion,   11,  16}]
            ,attr = []
        }
    };

get(107534) ->
    {ok, #item_base{
            id = 107534
            ,name = <<"烈日龙石（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_defence,  380,  459}, {?attr_tenacity,  15,  20}]
            ,attr = []
        }
    };

get(107631) ->
    {ok, #item_base{
            id = 107631
            ,name = <<"烈日火焰（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_hp_max,   1900,  2188}, {?attr_mp_max,   145,  175}]
            ,attr = []
        }
    };

get(107632) ->
    {ok, #item_base{
            id = 107632
            ,name = <<"烈日火焰（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_dmg,   100,  128}, {?attr_critrate, 25,  33}]
            ,attr = []
        }
    };

get(107633) ->
    {ok, #item_base{
            id = 107633
            ,name = <<"烈日火焰（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_hitrate,   21,  27}, {?attr_evasion,   21,  27}]
            ,attr = []
        }
    };

get(107634) ->
    {ok, #item_base{
            id = 107634
            ,name = <<"烈日火焰（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3300}]
			,effect = [{?attr_defence,  611,  766}, {?attr_tenacity,  25,  33}]
            ,attr = []
        }
    };

get(107135) ->
    {ok, #item_base{
            id = 107135
            ,name = <<"烈日鳞甲（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_hp_max,  1480,  1926}, {?attr_mp_max,   120,  154}]
            ,attr = []
        }
    };

get(107136) ->
    {ok, #item_base{
            id = 107136
            ,name = <<"烈日鳞甲（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_dmg,   89,  112}, {?attr_critrate,   24,  29}]
            ,attr = []
        }
    };

get(107137) ->
    {ok, #item_base{
            id = 107137
            ,name = <<"烈日鳞甲（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_hitrate,   18,  24}, {?attr_evasion,   18,  24}]
            ,attr = []
        }
    };

get(107138) ->
    {ok, #item_base{
            id = 107138
            ,name = <<"烈日鳞甲（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_defence,  510,  674}, {?attr_tenacity,  22,  29}]
            ,attr = []
        }
    };

get(107235) ->
    {ok, #item_base{
            id = 107235
            ,name = <<"烈日胫甲（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_hp_max,  1480,  1926}, {?attr_mp_max,   120,  154}]
            ,attr = []
        }
    };

get(107236) ->
    {ok, #item_base{
            id = 107236
            ,name = <<"烈日胫甲（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_dmg,   89,  112}, {?attr_critrate,   24,  29}]
            ,attr = []
        }
    };

get(107237) ->
    {ok, #item_base{
            id = 107237
            ,name = <<"烈日胫甲（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_hitrate,   18,  24}, {?attr_evasion,   18,  24}]
            ,attr = []
        }
    };

get(107238) ->
    {ok, #item_base{
            id = 107238
            ,name = <<"烈日胫甲（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_defence,  510,  674}, {?attr_tenacity,  22,  29}]
            ,attr = []
        }
    };

get(107335) ->
    {ok, #item_base{
            id = 107335
            ,name = <<"烈日兽戒（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_hp_max,   999,  1284}, {?attr_mp_max,   83  ,  103}]
            ,attr = []
        }
    };

get(107336) ->
    {ok, #item_base{
            id = 107336
            ,name = <<"烈日兽戒（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_dmg,   60,  75}, {?attr_critrate,   14,  19}]
            ,attr = []
        }
    };

get(107337) ->
    {ok, #item_base{
            id = 107337
            ,name = <<"烈日兽戒（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_hitrate,   12,  16}, {?attr_evasion,   12,  16}]
            ,attr = []
        }
    };

get(107338) ->
    {ok, #item_base{
            id = 107338
            ,name = <<"烈日兽戒（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_defence,  360,  449}, {?attr_tenacity,  14,  19}]
            ,attr = []
        }
    };

get(107435) ->
    {ok, #item_base{
            id = 107435
            ,name = <<"烈日利爪（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_hp_max,   999,  1284}, {?attr_mp_max,   83  ,  103}]
            ,attr = []
        }
    };

get(107436) ->
    {ok, #item_base{
            id = 107436
            ,name = <<"烈日利爪（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_dmg,   60,  75}, {?attr_critrate,   14,  19}]
            ,attr = []
        }
    };

get(107437) ->
    {ok, #item_base{
            id = 107437
            ,name = <<"烈日利爪（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_hitrate,   12,  16}, {?attr_evasion,   12,  16}]
            ,attr = []
        }
    };

get(107438) ->
    {ok, #item_base{
            id = 107438
            ,name = <<"烈日利爪（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_defence,  360,  449}, {?attr_tenacity,  14,  19}]
            ,attr = []
        }
    };

get(107535) ->
    {ok, #item_base{
            id = 107535
            ,name = <<"烈日龙石（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_hp_max,   1300,  1605}, {?attr_mp_max,   100,  128}]
            ,attr = []
        }
    };

get(107536) ->
    {ok, #item_base{
            id = 107536
            ,name = <<"烈日龙石（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_dmg,   72,  94}, {?attr_critrate,   19,  24}]
            ,attr = []
        }
    };

get(107537) ->
    {ok, #item_base{
            id = 107537
            ,name = <<"烈日龙石（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_hitrate,   15,  20}, {?attr_evasion,   15,  20}]
            ,attr = []
        }
    };

get(107538) ->
    {ok, #item_base{
            id = 107538
            ,name = <<"烈日龙石（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_defence,  444,  562}, {?attr_tenacity,  19,  24}]
            ,attr = []
        }
    };

get(107635) ->
    {ok, #item_base{
            id = 107635
            ,name = <<"烈日火焰（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_hp_max,   2000,  2675}, {?attr_mp_max,   170,  214}]
            ,attr = []
        }
    };

get(107636) ->
    {ok, #item_base{
            id = 107636
            ,name = <<"烈日火焰（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_dmg,   120,  156}, {?attr_critrate,  30,  40}]
            ,attr = []
        }
    };

get(107637) ->
    {ok, #item_base{
            id = 107637
            ,name = <<"烈日火焰（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_hitrate,   25,  33}, {?attr_evasion,   25,  33}]
            ,attr = []
        }
    };

get(107638) ->
    {ok, #item_base{
            id = 107638
            ,name = <<"烈日火焰（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 4800}]
			,effect = [{?attr_defence,  750,  936}, {?attr_tenacity,  30,  40}]
            ,attr = []
        }
    };

get(107141) ->
    {ok, #item_base{
            id = 107141
            ,name = <<"暮色鳞甲（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_hp_max,  1488,  1872}, {?attr_mp_max,   118,  150}]
            ,attr = []
        }
    };

get(107142) ->
    {ok, #item_base{
            id = 107142
            ,name = <<"暮色鳞甲（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_dmg,   88,  109}, {?attr_critrate,   22,  28}]
            ,attr = []
        }
    };

get(107143) ->
    {ok, #item_base{
            id = 107143
            ,name = <<"暮色鳞甲（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_hitrate,   18,  23}, {?attr_evasion,   18,  23}]
            ,attr = []
        }
    };

get(107144) ->
    {ok, #item_base{
            id = 107144
            ,name = <<"暮色鳞甲（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_defence,  500,  655}, {?attr_tenacity,  22,  28}]
            ,attr = []
        }
    };

get(107241) ->
    {ok, #item_base{
            id = 107241
            ,name = <<"暮色胫甲（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_hp_max,  1488,  1872}, {?attr_mp_max,   118,  150}]
            ,attr = []
        }
    };

get(107242) ->
    {ok, #item_base{
            id = 107242
            ,name = <<"暮色胫甲（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_dmg,   88,  109}, {?attr_critrate,   22,  28}]
            ,attr = []
        }
    };

get(107243) ->
    {ok, #item_base{
            id = 107243
            ,name = <<"暮色胫甲（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_hitrate,   18,  23}, {?attr_evasion,   18,  23}]
            ,attr = []
        }
    };

get(107244) ->
    {ok, #item_base{
            id = 107244
            ,name = <<"暮色胫甲（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_defence,  500,  655}, {?attr_tenacity,  22,  28}]
            ,attr = []
        }
    };

get(107341) ->
    {ok, #item_base{
            id = 107341
            ,name = <<"暮色兽戒（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_hp_max,   980,  1248}, {?attr_mp_max,   75,  100}]
            ,attr = []
        }
    };

get(107342) ->
    {ok, #item_base{
            id = 107342
            ,name = <<"暮色兽戒（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_dmg,   56,  73}, {?attr_critrate,   15,  19}]
            ,attr = []
        }
    };

get(107343) ->
    {ok, #item_base{
            id = 107343
            ,name = <<"暮色兽戒（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_hitrate,   12,  16}, {?attr_evasion,   12,  16}]
            ,attr = []
        }
    };

get(107344) ->
    {ok, #item_base{
            id = 107344
            ,name = <<"暮色兽戒（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_defence,  334,  434}, {?attr_tenacity,  15,  19}]
            ,attr = []
        }
    };

get(107441) ->
    {ok, #item_base{
            id = 107441
            ,name = <<"暮色利爪（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_hp_max,   980,  1248}, {?attr_mp_max,   75,  100}]
            ,attr = []
        }
    };

get(107442) ->
    {ok, #item_base{
            id = 107442
            ,name = <<"暮色利爪（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_dmg,   56,  73}, {?attr_critrate,   15,  19}]
            ,attr = []
        }
    };

get(107443) ->
    {ok, #item_base{
            id = 107443
            ,name = <<"暮色利爪（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_hitrate,   12,  16}, {?attr_evasion,   12,  16}]
            ,attr = []
        }
    };

get(107444) ->
    {ok, #item_base{
            id = 107444
            ,name = <<"暮色利爪（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_defence,  334,  434}, {?attr_tenacity,  15,  19}]
            ,attr = []
        }
    };

get(107541) ->
    {ok, #item_base{
            id = 107541
            ,name = <<"暮色龙石（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_hp_max,   1288,  1560}, {?attr_mp_max,   105,  125}]
            ,attr = []
        }
    };

get(107542) ->
    {ok, #item_base{
            id = 107542
            ,name = <<"暮色龙石（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_dmg,   78,  91}, {?attr_critrate,   18,  23}]
            ,attr = []
        }
    };

get(107543) ->
    {ok, #item_base{
            id = 107543
            ,name = <<"暮色龙石（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_hitrate,   15,  20}, {?attr_evasion,   15,  20}]
            ,attr = []
        }
    };

get(107544) ->
    {ok, #item_base{
            id = 107544
            ,name = <<"暮色龙石（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_defence,  400,  546}, {?attr_tenacity,  18,  23}]
            ,attr = []
        }
    };

get(107641) ->
    {ok, #item_base{
            id = 107641
            ,name = <<"暮色火焰（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_hp_max,   2300,  2600}, {?attr_mp_max,   178,  208}]
            ,attr = []
        }
    };

get(107642) ->
    {ok, #item_base{
            id = 107642
            ,name = <<"暮色火焰（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_dmg,   120,  152}, {?attr_critrate, 30,  39}]
            ,attr = []
        }
    };

get(107643) ->
    {ok, #item_base{
            id = 107643
            ,name = <<"暮色火焰（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_hitrate,   25,  33}, {?attr_evasion,   25,  33}]
            ,attr = []
        }
    };

get(107644) ->
    {ok, #item_base{
            id = 107644
            ,name = <<"暮色火焰（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4900}]
			,effect = [{?attr_defence,  750,  910}, {?attr_tenacity,  30,  39}]
            ,attr = []
        }
    };

get(107145) ->
    {ok, #item_base{
            id = 107145
            ,name = <<"暮色鳞甲（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hp_max,  1888,  2223}, {?attr_mp_max,   138,  178}]
            ,attr = []
        }
    };

get(107146) ->
    {ok, #item_base{
            id = 107146
            ,name = <<"暮色鳞甲（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_dmg,   89,  130}, {?attr_critrate,   28,  33}]
            ,attr = []
        }
    };

get(107147) ->
    {ok, #item_base{
            id = 107147
            ,name = <<"暮色鳞甲（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hitrate,   22,  28}, {?attr_evasion,   22,  28}]
            ,attr = []
        }
    };

get(107148) ->
    {ok, #item_base{
            id = 107148
            ,name = <<"暮色鳞甲（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_defence,  550,  778}, {?attr_tenacity,  28,  33}]
            ,attr = []
        }
    };

get(107245) ->
    {ok, #item_base{
            id = 107245
            ,name = <<"暮色胫甲（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hp_max,  1888,  2223}, {?attr_mp_max,   138,  178}]
            ,attr = []
        }
    };

get(107246) ->
    {ok, #item_base{
            id = 107246
            ,name = <<"暮色胫甲（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_dmg,   89,  130}, {?attr_critrate,   28,  33}]
            ,attr = []
        }
    };

get(107247) ->
    {ok, #item_base{
            id = 107247
            ,name = <<"暮色胫甲（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hitrate,   22,  28}, {?attr_evasion,   22,  28}]
            ,attr = []
        }
    };

get(107248) ->
    {ok, #item_base{
            id = 107248
            ,name = <<"暮色胫甲（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_defence,  550,  778}, {?attr_tenacity,  28,  33}]
            ,attr = []
        }
    };

get(107345) ->
    {ok, #item_base{
            id = 107345
            ,name = <<"暮色兽戒（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hp_max,   1188,  1482}, {?attr_mp_max,   90  ,  119}]
            ,attr = []
        }
    };

get(107346) ->
    {ok, #item_base{
            id = 107346
            ,name = <<"暮色兽戒（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_dmg,   68,  86}, {?attr_critrate,   16,  22}]
            ,attr = []
        }
    };

get(107347) ->
    {ok, #item_base{
            id = 107347
            ,name = <<"暮色兽戒（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hitrate,   12,  18}, {?attr_evasion,   12,  18}]
            ,attr = []
        }
    };

get(107348) ->
    {ok, #item_base{
            id = 107348
            ,name = <<"暮色兽戒（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_defence,  400,  519}, {?attr_tenacity,  15,  22}]
            ,attr = []
        }
    };

get(107445) ->
    {ok, #item_base{
            id = 107445
            ,name = <<"暮色利爪（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hp_max,   1188,  1482}, {?attr_mp_max,   90  ,  119}]
            ,attr = []
        }
    };

get(107446) ->
    {ok, #item_base{
            id = 107446
            ,name = <<"暮色利爪（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_dmg,   68,  86}, {?attr_critrate,   16,  22}]
            ,attr = []
        }
    };

get(107447) ->
    {ok, #item_base{
            id = 107447
            ,name = <<"暮色利爪（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hitrate,   12,  18}, {?attr_evasion,   12,  18}]
            ,attr = []
        }
    };

get(107448) ->
    {ok, #item_base{
            id = 107448
            ,name = <<"暮色利爪（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_defence,  400,  519}, {?attr_tenacity,  16,  22}]
            ,attr = []
        }
    };

get(107545) ->
    {ok, #item_base{
            id = 107545
            ,name = <<"暮色龙石（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hp_max,   1400,  1853}, {?attr_mp_max,   121,  148}]
            ,attr = []
        }
    };

get(107546) ->
    {ok, #item_base{
            id = 107546
            ,name = <<"暮色龙石（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_dmg,   80,  108}, {?attr_critrate,   23,  28}]
            ,attr = []
        }
    };

get(107547) ->
    {ok, #item_base{
            id = 107547
            ,name = <<"暮色龙石（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hitrate,   17,  23}, {?attr_evasion,   17,  23}]
            ,attr = []
        }
    };

get(107548) ->
    {ok, #item_base{
            id = 107548
            ,name = <<"暮色龙石（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_defence,  500,  648}, {?attr_tenacity,  23 ,  28}]
            ,attr = []
        }
    };

get(107645) ->
    {ok, #item_base{
            id = 107645
            ,name = <<"暮色火焰（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hp_max,   2500,  3088}, {?attr_mp_max,   190,  247}]
            ,attr = []
        }
    };

get(107646) ->
    {ok, #item_base{
            id = 107646
            ,name = <<"暮色火焰（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_dmg,   140,  180}, {?attr_critrate,  36,  46}]
            ,attr = []
        }
    };

get(107647) ->
    {ok, #item_base{
            id = 107647
            ,name = <<"暮色火焰（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hitrate,   29,  39}, {?attr_evasion,   29,  39}]
            ,attr = []
        }
    };

get(107648) ->
    {ok, #item_base{
            id = 107648
            ,name = <<"暮色火焰（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_defence,  850,  1081}, {?attr_tenacity,  36,  46}]
            ,attr = []
        }
    };

get(108141) ->
    {ok, #item_base{
            id = 108141
            ,name = <<"暮色鳞甲（体力）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_hp_max,  2100,  2574}, {?attr_mp_max,   160,  206}]
            ,attr = []
        }
    };

get(108142) ->
    {ok, #item_base{
            id = 108142
            ,name = <<"暮色鳞甲（力量）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_dmg,   89,  150}, {?attr_critrate,   29,  39}]
            ,attr = []
        }
    };

get(108143) ->
    {ok, #item_base{
            id = 108143
            ,name = <<"暮色鳞甲（灵巧）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_hitrate,   24,  32}, {?attr_evasion,   24,  32}]
            ,attr = []
        }
    };

get(108144) ->
    {ok, #item_base{
            id = 108144
            ,name = <<"暮色鳞甲（坚毅）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_defence,  700,  901}, {?attr_tenacity,  29,  39}]
            ,attr = []
        }
    };

get(108241) ->
    {ok, #item_base{
            id = 108241
            ,name = <<"暮色胫甲（体力）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_hp_max,  2100,  2574}, {?attr_mp_max,   160,  206}]
            ,attr = []
        }
    };

get(108242) ->
    {ok, #item_base{
            id = 108242
            ,name = <<"暮色胫甲（力量）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_dmg,   89,  150}, {?attr_critrate,   29,  39}]
            ,attr = []
        }
    };

get(108243) ->
    {ok, #item_base{
            id = 108243
            ,name = <<"暮色胫甲（灵巧）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_hitrate,   24,  32}, {?attr_evasion,   24,  32}]
            ,attr = []
        }
    };

get(108244) ->
    {ok, #item_base{
            id = 108244
            ,name = <<"暮色胫甲（坚毅）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_defence,  700,  901}, {?attr_tenacity,  29,  39}]
            ,attr = []
        }
    };

get(108341) ->
    {ok, #item_base{
            id = 108341
            ,name = <<"暮色兽戒（体力）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_hp_max,   1400,  1716}, {?attr_mp_max,   100  ,  137}]
            ,attr = []
        }
    };

get(108342) ->
    {ok, #item_base{
            id = 108342
            ,name = <<"暮色兽戒（力量）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_dmg,  75,  100}, {?attr_critrate,   18,  26}]
            ,attr = []
        }
    };

get(108343) ->
    {ok, #item_base{
            id = 108343
            ,name = <<"暮色兽戒（灵巧）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_hitrate,   15,  21}, {?attr_evasion,   15,  21}]
            ,attr = []
        }
    };

get(108344) ->
    {ok, #item_base{
            id = 108344
            ,name = <<"暮色兽戒（坚毅）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_defence,  450,  601}, {?attr_tenacity,  18,  26}]
            ,attr = []
        }
    };

get(108441) ->
    {ok, #item_base{
            id = 108441
            ,name = <<"暮色利爪（体力）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_hp_max,   1400,  1716}, {?attr_mp_max,   100  ,  137}]
            ,attr = []
        }
    };

get(108442) ->
    {ok, #item_base{
            id = 108442
            ,name = <<"暮色利爪（力量）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_dmg,  75,  100}, {?attr_critrate,   18,  26}]
            ,attr = []
        }
    };

get(108443) ->
    {ok, #item_base{
            id = 108443
            ,name = <<"暮色利爪（灵巧）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_hitrate,   15,  21}, {?attr_evasion,   15,  21}]
            ,attr = []
        }
    };

get(108444) ->
    {ok, #item_base{
            id = 108444
            ,name = <<"暮色利爪（坚毅）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_defence,  450,  601}, {?attr_tenacity,  18,  26}]
            ,attr = []
        }
    };

get(108541) ->
    {ok, #item_base{
            id = 108541
            ,name = <<"暮色龙石（体力）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_hp_max,   1300,  2145}, {?attr_mp_max,   140,  172}]
            ,attr = []
        }
    };

get(108542) ->
    {ok, #item_base{
            id = 108542
            ,name = <<"暮色龙石（力量）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_dmg,   95,  125}, {?attr_critrate,   26,  32}]
            ,attr = []
        }
    };

get(108543) ->
    {ok, #item_base{
            id = 108543
            ,name = <<"暮色龙石（灵巧）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_hitrate,   21,  27}, {?attr_evasion,   21,  27}]
            ,attr = []
        }
    };

get(108544) ->
    {ok, #item_base{
            id = 108544
            ,name = <<"暮色龙石（坚毅）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_defence,  588,  750}, {?attr_tenacity,  26,  32}]
            ,attr = []
        }
    };

get(108641) ->
    {ok, #item_base{
            id = 108641
            ,name = <<"暮色火焰（体力）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_hp_max,   2900, 3575}, {?attr_mp_max,   170,  286}]
            ,attr = []
        }
    };

get(108642) ->
    {ok, #item_base{
            id = 108642
            ,name = <<"暮色火焰（力量）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_dmg,   168,  209}, {?attr_critrate,  42,  54}]
            ,attr = []
        }
    };

get(108643) ->
    {ok, #item_base{
            id = 108643
            ,name = <<"暮色火焰（灵巧）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_hitrate,   35,  45}, {?attr_evasion,   35,  45}]
            ,attr = []
        }
    };

get(108644) ->
    {ok, #item_base{
            id = 108644
            ,name = <<"暮色火焰（坚毅）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 8000}]
			,effect = [{?attr_defence,  988,  1251}, {?attr_tenacity,  42,  54}]
            ,attr = []
        }
    };

get(107151) ->
    {ok, #item_base{
            id = 107151
            ,name = <<"暗夜鳞甲（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hp_max,  1700,  2169}, {?attr_mp_max,   140,  174}]
            ,attr = []
        }
    };

get(107152) ->
    {ok, #item_base{
            id = 107152
            ,name = <<"暗夜鳞甲（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_dmg,   98,  127}, {?attr_critrate,   26,  33}]
            ,attr = []
        }
    };

get(107153) ->
    {ok, #item_base{
            id = 107153
            ,name = <<"暗夜鳞甲（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hitrate,   21,  27}, {?attr_evasion,   21,  27}]
            ,attr = []
        }
    };

get(107154) ->
    {ok, #item_base{
            id = 107154
            ,name = <<"暗夜鳞甲（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_defence,  666,  882}, {?attr_tenacity,  26,  33}]
            ,attr = []
        }
    };

get(107251) ->
    {ok, #item_base{
            id = 107251
            ,name = <<"暗夜胫甲（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hp_max,  1700,  2169}, {?attr_mp_max,   140,  174}]
            ,attr = []
        }
    };

get(107252) ->
    {ok, #item_base{
            id = 107252
            ,name = <<"暗夜胫甲（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_dmg,   98,  127}, {?attr_critrate,   26,  33}]
            ,attr = []
        }
    };

get(107253) ->
    {ok, #item_base{
            id = 107253
            ,name = <<"暗夜胫甲（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hitrate,   21,  27}, {?attr_evasion,   21,  27}]
            ,attr = []
        }
    };

get(107254) ->
    {ok, #item_base{
            id = 107254
            ,name = <<"暗夜胫甲（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_defence,  666,  882}, {?attr_tenacity,  26,  33}]
            ,attr = []
        }
    };

get(107351) ->
    {ok, #item_base{
            id = 107351
            ,name = <<"暗夜兽戒（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hp_max,   1200,  1446}, {?attr_mp_max,   90,  116}]
            ,attr = []
        }
    };

get(107352) ->
    {ok, #item_base{
            id = 107352
            ,name = <<"暗夜兽戒（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_dmg,   68,  84}, {?attr_critrate,   17,  22}]
            ,attr = []
        }
    };

get(107353) ->
    {ok, #item_base{
            id = 107353
            ,name = <<"暗夜兽戒（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hitrate,   14,  18}, {?attr_evasion,   14,  18}]
            ,attr = []
        }
    };

get(107354) ->
    {ok, #item_base{
            id = 107354
            ,name = <<"暗夜兽戒（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_defence,  388,  506}, {?attr_tenacity,  17,  22}]
            ,attr = []
        }
    };

get(107451) ->
    {ok, #item_base{
            id = 107451
            ,name = <<"暗夜利爪（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hp_max,   1200,  1446}, {?attr_mp_max,   90,  116}]
            ,attr = []
        }
    };

get(107452) ->
    {ok, #item_base{
            id = 107452
            ,name = <<"暗夜利爪（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_dmg,   68,  84}, {?attr_critrate,   17,  22}]
            ,attr = []
        }
    };

get(107453) ->
    {ok, #item_base{
            id = 107453
            ,name = <<"暗夜利爪（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hitrate,   14,  18}, {?attr_evasion,   14,  18}]
            ,attr = []
        }
    };

get(107454) ->
    {ok, #item_base{
            id = 107454
            ,name = <<"暗夜利爪（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_defence,  388,  506}, {?attr_tenacity,  17,  22}]
            ,attr = []
        }
    };

get(107551) ->
    {ok, #item_base{
            id = 107551
            ,name = <<"暗夜龙石（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hp_max,   1588,  1808}, {?attr_mp_max,   115,  145}]
            ,attr = []
        }
    };

get(107552) ->
    {ok, #item_base{
            id = 107552
            ,name = <<"暗夜龙石（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_dmg,   88,  105}, {?attr_critrate,   21,  27}]
            ,attr = []
        }
    };

get(107553) ->
    {ok, #item_base{
            id = 107553
            ,name = <<"暗夜龙石（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hitrate,   18,  23}, {?attr_evasion,   18,  23}]
            ,attr = []
        }
    };

get(107554) ->
    {ok, #item_base{
            id = 107554
            ,name = <<"暗夜龙石（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_defence,  500,  633}, {?attr_tenacity,  21,  27}]
            ,attr = []
        }
    };

get(107651) ->
    {ok, #item_base{
            id = 107651
            ,name = <<"暗夜火焰（体力）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hp_max,   2600,  3013}, {?attr_mp_max,   190,  241}]
            ,attr = []
        }
    };

get(107652) ->
    {ok, #item_base{
            id = 107652
            ,name = <<"暗夜火焰（力量）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_dmg,   140,  176}, {?attr_critrate, 35,  45}]
            ,attr = []
        }
    };

get(107653) ->
    {ok, #item_base{
            id = 107653
            ,name = <<"暗夜火焰（灵巧）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_hitrate,   30,  38}, {?attr_evasion,   30,  38}]
            ,attr = []
        }
    };

get(107654) ->
    {ok, #item_base{
            id = 107654
            ,name = <<"暗夜火焰（坚毅）">>
            ,type = 10
            ,quality = 2
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 6000}]
			,effect = [{?attr_defence,  799,  1054}, {?attr_tenacity,  35,  45}]
            ,attr = []
        }
    };

get(107155) ->
    {ok, #item_base{
            id = 107155
            ,name = <<"暗夜鳞甲（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_hp_max,  2000,  2520}, {?attr_mp_max,   168,  202}]
            ,attr = []
        }
    };

get(107156) ->
    {ok, #item_base{
            id = 107156
            ,name = <<"暗夜鳞甲（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_dmg,   118,  147}, {?attr_critrate,   32,  38}]
            ,attr = []
        }
    };

get(107157) ->
    {ok, #item_base{
            id = 107157
            ,name = <<"暗夜鳞甲（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_hitrate,   26,  32}, {?attr_evasion,   26,  32}]
            ,attr = []
        }
    };

get(107158) ->
    {ok, #item_base{
            id = 107158
            ,name = <<"暗夜鳞甲（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_defence,  688,  882}, {?attr_tenacity,  32,  38}]
            ,attr = []
        }
    };

get(107255) ->
    {ok, #item_base{
            id = 107255
            ,name = <<"暗夜胫甲（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_hp_max,  2000,  2520}, {?attr_mp_max,   168,  202}]
            ,attr = []
        }
    };

get(107256) ->
    {ok, #item_base{
            id = 107256
            ,name = <<"暗夜胫甲（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_dmg,   118,  147}, {?attr_critrate,   32,  38}]
            ,attr = []
        }
    };

get(107257) ->
    {ok, #item_base{
            id = 107257
            ,name = <<"暗夜胫甲（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_hitrate,   26,  32}, {?attr_evasion,   26,  32}]
            ,attr = []
        }
    };

get(107258) ->
    {ok, #item_base{
            id = 107258
            ,name = <<"暗夜胫甲（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_defence,  688,  882}, {?attr_tenacity,  32,  38}]
            ,attr = []
        }
    };

get(107355) ->
    {ok, #item_base{
            id = 107355
            ,name = <<"暗夜兽戒（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_hp_max,   1300,  1680}, {?attr_mp_max,   108  ,  134}]
            ,attr = []
        }
    };

get(107356) ->
    {ok, #item_base{
            id = 107356
            ,name = <<"暗夜兽戒（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_dmg,   75,  98}, {?attr_critrate,   19,  25}]
            ,attr = []
        }
    };

get(107357) ->
    {ok, #item_base{
            id = 107357
            ,name = <<"暗夜兽戒（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_hitrate,   16,  21}, {?attr_evasion,   16,  21}]
            ,attr = []
        }
    };

get(107358) ->
    {ok, #item_base{
            id = 107358
            ,name = <<"暗夜兽戒（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_defence,  444,  588}, {?attr_tenacity,  19,  25}]
            ,attr = []
        }
    };

get(107455) ->
    {ok, #item_base{
            id = 107455
            ,name = <<"暗夜利爪（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_hp_max,   1300,  1680}, {?attr_mp_max,   108  ,  134}]
            ,attr = []
        }
    };

get(107456) ->
    {ok, #item_base{
            id = 107456
            ,name = <<"暗夜利爪（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_dmg,   75,  98}, {?attr_critrate,   19,  25}]
            ,attr = []
        }
    };

get(107457) ->
    {ok, #item_base{
            id = 107457
            ,name = <<"暗夜利爪（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_hitrate,   16,  21}, {?attr_evasion,   16,  21}]
            ,attr = []
        }
    };

get(107458) ->
    {ok, #item_base{
            id = 107458
            ,name = <<"暗夜利爪（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_defence,  444,  588}, {?attr_tenacity,  19,  25}]
            ,attr = []
        }
    };

get(107555) ->
    {ok, #item_base{
            id = 107555
            ,name = <<"暗夜龙石（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_hp_max,   1688,  2100}, {?attr_mp_max,   100,  128}]
            ,attr = []
        }
    };

get(107556) ->
    {ok, #item_base{
            id = 107556
            ,name = <<"暗夜龙石（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_dmg,   98,  123}, {?attr_critrate,   26,  32}]
            ,attr = []
        }
    };

get(107557) ->
    {ok, #item_base{
            id = 107557
            ,name = <<"暗夜龙石（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_hitrate,   20,  26}, {?attr_evasion,   20,  26}]
            ,attr = []
        }
    };

get(107558) ->
    {ok, #item_base{
            id = 107558
            ,name = <<"暗夜龙石（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_defence,  566,  735}, {?attr_tenacity,  26,  32}]
            ,attr = []
        }
    };

get(107655) ->
    {ok, #item_base{
            id = 107655
            ,name = <<"暗夜火焰（体力）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_hp_max,   3000,  3500}, {?attr_mp_max,   238,  280}]
            ,attr = []
        }
    };

get(107656) ->
    {ok, #item_base{
            id = 107656
            ,name = <<"暗夜火焰（力量）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_dmg,   168,  204}, {?attr_critrate,  40,  53}]
            ,attr = []
        }
    };

get(107657) ->
    {ok, #item_base{
            id = 107657
            ,name = <<"暗夜火焰（灵巧）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_hitrate,   33,  44}, {?attr_evasion,   33,  44}]
            ,attr = []
        }
    };

get(107658) ->
    {ok, #item_base{
            id = 107658
            ,name = <<"暗夜火焰（坚毅）">>
            ,type = 10
            ,quality = 3
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 7200}]
			,effect = [{?attr_defence,  988,  1225}, {?attr_tenacity,  40,  53}]
            ,attr = []
        }
    };

get(108151) ->
    {ok, #item_base{
            id = 108151
            ,name = <<"暗夜鳞甲（体力）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_hp_max,  2400,  2871}, {?attr_mp_max,   180,  230}]
            ,attr = []
        }
    };

get(108152) ->
    {ok, #item_base{
            id = 108152
            ,name = <<"暗夜鳞甲（力量）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_dmg,   128,  167}, {?attr_critrate,   33,  43}]
            ,attr = []
        }
    };

get(108153) ->
    {ok, #item_base{
            id = 108153
            ,name = <<"暗夜鳞甲（灵巧）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_hitrate,   28,  36}, {?attr_evasion,   28,  36}]
            ,attr = []
        }
    };

get(108154) ->
    {ok, #item_base{
            id = 108154
            ,name = <<"暗夜鳞甲（坚毅）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_defence,  800,  1005}, {?attr_tenacity,  33,  43}]
            ,attr = []
        }
    };

get(108251) ->
    {ok, #item_base{
            id = 108251
            ,name = <<"暗夜胫甲（体力）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_hp_max,  2400,  2871}, {?attr_mp_max,   180,  230}]
            ,attr = []
        }
    };

get(108252) ->
    {ok, #item_base{
            id = 108252
            ,name = <<"暗夜胫甲（力量）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_dmg,   128,  167}, {?attr_critrate,   33,  43}]
            ,attr = []
        }
    };

get(108253) ->
    {ok, #item_base{
            id = 108253
            ,name = <<"暗夜胫甲（灵巧）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_hitrate,   28,  36}, {?attr_evasion,   28,  36}]
            ,attr = []
        }
    };

get(108254) ->
    {ok, #item_base{
            id = 108254
            ,name = <<"暗夜胫甲（坚毅）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_defence,  800,  1005}, {?attr_tenacity,  33,  43}]
            ,attr = []
        }
    };

get(108351) ->
    {ok, #item_base{
            id = 108351
            ,name = <<"暗夜兽戒（体力）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_hp_max,   1588,  1914}, {?attr_mp_max,   120  ,  153}]
            ,attr = []
        }
    };

get(108352) ->
    {ok, #item_base{
            id = 108352
            ,name = <<"暗夜兽戒（力量）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_dmg,  87,  112}, {?attr_critrate,   24, 29}]
            ,attr = []
        }
    };

get(108353) ->
    {ok, #item_base{
            id = 108353
            ,name = <<"暗夜兽戒（灵巧）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_hitrate,   19,  24}, {?attr_evasion,   19,  24}]
            ,attr = []
        }
    };

get(108354) ->
    {ok, #item_base{
            id = 108354
            ,name = <<"暗夜兽戒（坚毅）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_defence,  522,  670}, {?attr_tenacity,  24,  29}]
            ,attr = []
        }
    };

get(108451) ->
    {ok, #item_base{
            id = 108451
            ,name = <<"暗夜利爪（体力）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_hp_max,   1588,  1914}, {?attr_mp_max,   120  ,  153}]
            ,attr = []
        }
    };

get(108452) ->
    {ok, #item_base{
            id = 108452
            ,name = <<"暗夜利爪（力量）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_dmg,  87,  112}, {?attr_critrate,   24, 29}]
            ,attr = []
        }
    };

get(108453) ->
    {ok, #item_base{
            id = 108453
            ,name = <<"暗夜利爪（灵巧）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_hitrate,   19,  24}, {?attr_evasion,   19,  24}]
            ,attr = []
        }
    };

get(108454) ->
    {ok, #item_base{
            id = 108454
            ,name = <<"暗夜利爪（坚毅）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_defence,  522,  670}, {?attr_tenacity,  24,  29}]
            ,attr = []
        }
    };

get(108551) ->
    {ok, #item_base{
            id = 108551
            ,name = <<"暗夜龙石（体力）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_hp_max,   1888,  2393}, {?attr_mp_max,   150,  191}]
            ,attr = []
        }
    };

get(108552) ->
    {ok, #item_base{
            id = 108552
            ,name = <<"暗夜龙石（力量）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_dmg,   111,  139}, {?attr_critrate,   28,  36}]
            ,attr = []
        }
    };

get(108553) ->
    {ok, #item_base{
            id = 108553
            ,name = <<"暗夜龙石（灵巧）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_hitrate,   25,  30}, {?attr_evasion,   25,  30}]
            ,attr = []
        }
    };

get(108554) ->
    {ok, #item_base{
            id = 108554
            ,name = <<"暗夜龙石（坚毅）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_defence,  688,  837}, {?attr_tenacity,  28,  36}]
            ,attr = []
        }
    };

get(108651) ->
    {ok, #item_base{
            id = 108651
            ,name = <<"暗夜火焰（体力）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_hp_max,   3200,  3988}, {?attr_mp_max,   280,  320}]
            ,attr = []
        }
    };

get(108652) ->
    {ok, #item_base{
            id = 108652
            ,name = <<"暗夜火焰（力量）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_dmg,   198,  233}, {?attr_critrate,  48,  60}]
            ,attr = []
        }
    };

get(108653) ->
    {ok, #item_base{
            id = 108653
            ,name = <<"暗夜火焰（灵巧）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_hitrate,   40,  50}, {?attr_evasion,   40,  50}]
            ,attr = []
        }
    };

get(108654) ->
    {ok, #item_base{
            id = 108654
            ,name = <<"暗夜火焰（坚毅）">>
            ,type = 10
            ,quality = 4
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 9000}]
			,effect = [{?attr_defence,  1088,  1396}, {?attr_tenacity,  48,  60}]
            ,attr = []
        }
    };

get(111001) ->
    {ok, #item_base{
            id = 111001
            ,name = <<"强化石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 3000}]
            ,attr = []
        }
    };

get(111101) ->
    {ok, #item_base{
            id = 111101
            ,name = <<"蓝色棱晶">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 3000}]
            ,attr = []
        }
    };

get(111102) ->
    {ok, #item_base{
            id = 111102
            ,name = <<"紫色棱晶">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 8000}]
            ,attr = []
        }
    };

get(111103) ->
    {ok, #item_base{
            id = 111103
            ,name = <<"粉色棱晶">>
            ,type = 11
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 12000}]
            ,attr = []
        }
    };

get(111104) ->
    {ok, #item_base{
            id = 111104
            ,name = <<"橙色棱晶">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 20000}]
            ,attr = []
        }
    };

get(111105) ->
    {ok, #item_base{
            id = 111105
            ,name = <<"金色棱晶">>
            ,type = 11
            ,quality = 6
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 30000}]
            ,attr = []
        }
    };

get(111106) ->
    {ok, #item_base{
            id = 111106
            ,name = <<"黑纱兽牙">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 6000}]
            ,attr = []
        }
    };

get(111107) ->
    {ok, #item_base{
            id = 111107
            ,name = <<"漩涡火焰">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 7500}]
            ,attr = []
        }
    };

get(111108) ->
    {ok, #item_base{
            id = 111108
            ,name = <<"火鳞石">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111109) ->
    {ok, #item_base{
            id = 111109
            ,name = <<"龙骸石晶">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111201) ->
    {ok, #item_base{
            id = 111201
            ,name = <<"一级生命宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 450}]
            ,attr = [{?attr_hp_max, 100, 100}]
        }
    };

get(111211) ->
    {ok, #item_base{
            id = 111211
            ,name = <<"一级攻击宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 450}]
            ,attr = [{?attr_dmg_max, 100, 14}]
        }
    };

get(111221) ->
    {ok, #item_base{
            id = 111221
            ,name = <<"一级防御宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 450}]
            ,attr = [{?attr_defence, 100, 50}]
        }
    };

get(111231) ->
    {ok, #item_base{
            id = 111231
            ,name = <<"一级暴怒宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 450}]
            ,attr = [{?attr_critrate, 100, 10}]
        }
    };

get(111241) ->
    {ok, #item_base{
            id = 111241
            ,name = <<"一级精准宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 450}]
            ,attr = [{?attr_hitrate, 100, 4}]
        }
    };

get(111251) ->
    {ok, #item_base{
            id = 111251
            ,name = <<"一级格挡宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 450}]
            ,attr = [{?attr_evasion, 100, 4}]
        }
    };

get(111261) ->
    {ok, #item_base{
            id = 111261
            ,name = <<"一级坚韧宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 450}]
            ,attr = [{?attr_tenacity, 100, 10}]
        }
    };

get(111271) ->
    {ok, #item_base{
            id = 111271
            ,name = <<"一级敏捷宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 450}]
            ,attr = [{?attr_aspd, 100, 1}]
        }
    };

get(111202) ->
    {ok, #item_base{
            id = 111202
            ,name = <<"二级生命宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1800}]
            ,attr = [{?attr_hp_max, 100, 200}]
        }
    };

get(111212) ->
    {ok, #item_base{
            id = 111212
            ,name = <<"二级攻击宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1800}]
            ,attr = [{?attr_dmg_max, 100, 30}]
        }
    };

get(111222) ->
    {ok, #item_base{
            id = 111222
            ,name = <<"二级防御宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1800}]
            ,attr = [{?attr_defence, 100, 100}]
        }
    };

get(111232) ->
    {ok, #item_base{
            id = 111232
            ,name = <<"二级暴怒宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1800}]
            ,attr = [{?attr_critrate, 100, 20}]
        }
    };

get(111242) ->
    {ok, #item_base{
            id = 111242
            ,name = <<"二级精准宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1800}]
            ,attr = [{?attr_hitrate, 100, 8}]
        }
    };

get(111252) ->
    {ok, #item_base{
            id = 111252
            ,name = <<"二级格挡宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1800}]
            ,attr = [{?attr_evasion, 100, 8}]
        }
    };

get(111262) ->
    {ok, #item_base{
            id = 111262
            ,name = <<"二级坚韧宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1800}]
            ,attr = [{?attr_tenacity, 100, 20}]
        }
    };

get(111272) ->
    {ok, #item_base{
            id = 111272
            ,name = <<"二级敏捷宝石">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1800}]
            ,attr = [{?attr_aspd, 100, 2}]
        }
    };

get(111203) ->
    {ok, #item_base{
            id = 111203
            ,name = <<"三级生命宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 7200}]
            ,attr = [{?attr_hp_max, 100, 400}]
        }
    };

get(111213) ->
    {ok, #item_base{
            id = 111213
            ,name = <<"三级攻击宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 7200}]
            ,attr = [{?attr_dmg_max, 100, 50}]
        }
    };

get(111223) ->
    {ok, #item_base{
            id = 111223
            ,name = <<"三级防御宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 7200}]
            ,attr = [{?attr_defence, 100, 200}]
        }
    };

get(111233) ->
    {ok, #item_base{
            id = 111233
            ,name = <<"三级暴怒宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 7200}]
            ,attr = [{?attr_critrate, 100, 40}]
        }
    };

get(111243) ->
    {ok, #item_base{
            id = 111243
            ,name = <<"三级精准宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 7200}]
            ,attr = [{?attr_hitrate, 100, 16}]
        }
    };

get(111253) ->
    {ok, #item_base{
            id = 111253
            ,name = <<"三级格挡宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 7200}]
            ,attr = [{?attr_evasion, 100, 16}]
        }
    };

get(111263) ->
    {ok, #item_base{
            id = 111263
            ,name = <<"三级坚韧宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 7200}]
            ,attr = [{?attr_tenacity, 100, 40}]
        }
    };

get(111273) ->
    {ok, #item_base{
            id = 111273
            ,name = <<"三级敏捷宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 7200}]
            ,attr = [{?attr_aspd, 100, 3}]
        }
    };

get(111204) ->
    {ok, #item_base{
            id = 111204
            ,name = <<"四级生命宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_hp_max, 100, 720}]
        }
    };

get(111214) ->
    {ok, #item_base{
            id = 111214
            ,name = <<"四级攻击宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_dmg_max, 100, 90}]
        }
    };

get(111224) ->
    {ok, #item_base{
            id = 111224
            ,name = <<"四级防御宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_defence, 100, 360}]
        }
    };

get(111234) ->
    {ok, #item_base{
            id = 111234
            ,name = <<"四级暴怒宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_critrate, 100, 72}]
        }
    };

get(111244) ->
    {ok, #item_base{
            id = 111244
            ,name = <<"四级精准宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_hitrate, 100, 30}]
        }
    };

get(111254) ->
    {ok, #item_base{
            id = 111254
            ,name = <<"四级格挡宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_evasion, 100, 30}]
        }
    };

get(111264) ->
    {ok, #item_base{
            id = 111264
            ,name = <<"四级坚韧宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_tenacity, 100, 72}]
        }
    };

get(111274) ->
    {ok, #item_base{
            id = 111274
            ,name = <<"四级敏捷宝石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_aspd, 100, 4}]
        }
    };

get(111205) ->
    {ok, #item_base{
            id = 111205
            ,name = <<"五级生命宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_hp_max, 100, 1200}]
        }
    };

get(111215) ->
    {ok, #item_base{
            id = 111215
            ,name = <<"五级攻击宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_dmg_max, 100, 150}]
        }
    };

get(111225) ->
    {ok, #item_base{
            id = 111225
            ,name = <<"五级防御宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_defence, 100, 600}]
        }
    };

get(111235) ->
    {ok, #item_base{
            id = 111235
            ,name = <<"五级暴怒宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_critrate, 100, 120}]
        }
    };

get(111245) ->
    {ok, #item_base{
            id = 111245
            ,name = <<"五级精准宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_hitrate, 100, 48}]
        }
    };

get(111255) ->
    {ok, #item_base{
            id = 111255
            ,name = <<"五级格挡宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_evasion, 100, 48}]
        }
    };

get(111265) ->
    {ok, #item_base{
            id = 111265
            ,name = <<"五级坚韧宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_tenacity, 100, 120}]
        }
    };

get(111275) ->
    {ok, #item_base{
            id = 111275
            ,name = <<"五级敏捷宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_aspd, 100, 5}]
        }
    };

get(111206) ->
    {ok, #item_base{
            id = 111206
            ,name = <<"六级生命宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_hp_max, 100, 2000}]
        }
    };

get(111216) ->
    {ok, #item_base{
            id = 111216
            ,name = <<"六级攻击宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_dmg_max, 100, 250}]
        }
    };

get(111226) ->
    {ok, #item_base{
            id = 111226
            ,name = <<"六级防御宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_defence, 100, 1000}]
        }
    };

get(111236) ->
    {ok, #item_base{
            id = 111236
            ,name = <<"六级暴怒宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_critrate, 100, 200}]
        }
    };

get(111246) ->
    {ok, #item_base{
            id = 111246
            ,name = <<"六级精准宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_hitrate, 100, 80}]
        }
    };

get(111256) ->
    {ok, #item_base{
            id = 111256
            ,name = <<"六级格挡宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_evasion, 100, 80}]
        }
    };

get(111266) ->
    {ok, #item_base{
            id = 111266
            ,name = <<"六级坚韧宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_tenacity, 100, 200}]
        }
    };

get(111276) ->
    {ok, #item_base{
            id = 111276
            ,name = <<"六级敏捷宝石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_aspd, 100, 6}]
        }
    };

get(111207) ->
    {ok, #item_base{
            id = 111207
            ,name = <<"七级生命宝石">>
            ,type = 11
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_hp_max, 100, 3300}]
        }
    };

get(111217) ->
    {ok, #item_base{
            id = 111217
            ,name = <<"七级攻击宝石">>
            ,type = 11
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_dmg_max, 100, 410}]
        }
    };

get(111227) ->
    {ok, #item_base{
            id = 111227
            ,name = <<"七级防御宝石">>
            ,type = 11
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_defence, 100, 1650}]
        }
    };

get(111237) ->
    {ok, #item_base{
            id = 111237
            ,name = <<"七级暴怒宝石">>
            ,type = 11
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_critrate, 100, 330}]
        }
    };

get(111247) ->
    {ok, #item_base{
            id = 111247
            ,name = <<"七级精准宝石">>
            ,type = 11
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_hitrate, 100, 132}]
        }
    };

get(111257) ->
    {ok, #item_base{
            id = 111257
            ,name = <<"七级格挡宝石">>
            ,type = 11
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_evasion, 100, 132}]
        }
    };

get(111267) ->
    {ok, #item_base{
            id = 111267
            ,name = <<"七级坚韧宝石">>
            ,type = 11
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_tenacity, 100, 330}]
        }
    };

get(111277) ->
    {ok, #item_base{
            id = 111277
            ,name = <<"七级敏捷宝石">>
            ,type = 11
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_aspd, 100, 7}]
        }
    };

get(111208) ->
    {ok, #item_base{
            id = 111208
            ,name = <<"八级生命宝石">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_hp_max, 100, 5500}]
        }
    };

get(111218) ->
    {ok, #item_base{
            id = 111218
            ,name = <<"八级攻击宝石">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_dmg_max, 100, 690}]
        }
    };

get(111228) ->
    {ok, #item_base{
            id = 111228
            ,name = <<"八级防御宝石">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_defence, 100, 2750}]
        }
    };

get(111238) ->
    {ok, #item_base{
            id = 111238
            ,name = <<"八级暴怒宝石">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_critrate, 100, 550}]
        }
    };

get(111248) ->
    {ok, #item_base{
            id = 111248
            ,name = <<"八级精准宝石">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_hitrate, 100, 220}]
        }
    };

get(111258) ->
    {ok, #item_base{
            id = 111258
            ,name = <<"八级格挡宝石">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_evasion, 100, 220}]
        }
    };

get(111268) ->
    {ok, #item_base{
            id = 111268
            ,name = <<"八级坚韧宝石">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_tenacity, 100, 550}]
        }
    };

get(111278) ->
    {ok, #item_base{
            id = 111278
            ,name = <<"八级敏捷宝石">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_aspd, 100, 8}]
        }
    };

get(111209) ->
    {ok, #item_base{
            id = 111209
            ,name = <<"九级生命宝石">>
            ,type = 11
            ,quality = 6
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_hp_max, 100, 9000}]
        }
    };

get(111219) ->
    {ok, #item_base{
            id = 111219
            ,name = <<"九级攻击宝石">>
            ,type = 11
            ,quality = 6
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_dmg_max, 100, 1130}]
        }
    };

get(111229) ->
    {ok, #item_base{
            id = 111229
            ,name = <<"九级防御宝石">>
            ,type = 11
            ,quality = 6
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_defence, 100, 4500}]
        }
    };

get(111239) ->
    {ok, #item_base{
            id = 111239
            ,name = <<"九级暴怒宝石">>
            ,type = 11
            ,quality = 6
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_critrate, 100, 900}]
        }
    };

get(111249) ->
    {ok, #item_base{
            id = 111249
            ,name = <<"九级精准宝石">>
            ,type = 11
            ,quality = 6
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_hitrate, 100, 360}]
        }
    };

get(111259) ->
    {ok, #item_base{
            id = 111259
            ,name = <<"九级格挡宝石">>
            ,type = 11
            ,quality = 6
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_evasion, 100, 360}]
        }
    };

get(111269) ->
    {ok, #item_base{
            id = 111269
            ,name = <<"九级坚韧宝石">>
            ,type = 11
            ,quality = 6
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_tenacity, 100, 900}]
        }
    };

get(111279) ->
    {ok, #item_base{
            id = 111279
            ,name = <<"九级敏捷宝石">>
            ,type = 11
            ,quality = 6
            ,overlap = 99
            ,use_type = 1
            ,attr = [{?attr_aspd, 100, 9}]
        }
    };

get(111301) ->
    {ok, #item_base{
            id = 111301
            ,name = <<"鉴定石">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 3000}]
            ,attr = []
        }
    };

get(111401) ->
    {ok, #item_base{
            id = 111401
            ,name = <<"黑亚麻布">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 150}]
            ,attr = []
        }
    };

get(111402) ->
    {ok, #item_base{
            id = 111402
            ,name = <<"月光石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 150}]
            ,attr = []
        }
    };

get(111403) ->
    {ok, #item_base{
            id = 111403
            ,name = <<"沙地剑麻">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 150}]
            ,attr = []
        }
    };

get(111404) ->
    {ok, #item_base{
            id = 111404
            ,name = <<"银马鬃">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 150}]
            ,attr = []
        }
    };

get(111405) ->
    {ok, #item_base{
            id = 111405
            ,name = <<"碎花麻布">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 225}]
            ,attr = []
        }
    };

get(111406) ->
    {ok, #item_base{
            id = 111406
            ,name = <<"裂纹钢">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 225}]
            ,attr = []
        }
    };

get(111407) ->
    {ok, #item_base{
            id = 111407
            ,name = <<"毒蝎甲">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 225}]
            ,attr = []
        }
    };

get(111408) ->
    {ok, #item_base{
            id = 111408
            ,name = <<"炙火刚石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 225}]
            ,attr = []
        }
    };

get(111409) ->
    {ok, #item_base{
            id = 111409
            ,name = <<"棕叶鳞">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 275}]
            ,attr = []
        }
    };

get(111410) ->
    {ok, #item_base{
            id = 111410
            ,name = <<"荧光树叶">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 275}]
            ,attr = []
        }
    };

get(111411) ->
    {ok, #item_base{
            id = 111411
            ,name = <<"绿棘皮革">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 275}]
            ,attr = []
        }
    };

get(111412) ->
    {ok, #item_base{
            id = 111412
            ,name = <<"影子树皮">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 275}]
            ,attr = []
        }
    };

get(111413) ->
    {ok, #item_base{
            id = 111413
            ,name = <<"紫绒棉">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 360}]
            ,attr = []
        }
    };

get(111414) ->
    {ok, #item_base{
            id = 111414
            ,name = <<"火花鹿角">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 360}]
            ,attr = []
        }
    };

get(111415) ->
    {ok, #item_base{
            id = 111415
            ,name = <<"山地羊裘">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 360}]
            ,attr = []
        }
    };

get(111416) ->
    {ok, #item_base{
            id = 111416
            ,name = <<"雪晶冰石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 360}]
            ,attr = []
        }
    };

get(111417) ->
    {ok, #item_base{
            id = 111417
            ,name = <<"碎裂纹石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111418) ->
    {ok, #item_base{
            id = 111418
            ,name = <<"恶魔骨骸">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111419) ->
    {ok, #item_base{
            id = 111419
            ,name = <<"浪声螺壳">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111420) ->
    {ok, #item_base{
            id = 111420
            ,name = <<"狱火裘皮">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111421) ->
    {ok, #item_base{
            id = 111421
            ,name = <<"寒鸦黑羽">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111422) ->
    {ok, #item_base{
            id = 111422
            ,name = <<"梦魇皮革">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(111423) ->
    {ok, #item_base{
            id = 111423
            ,name = <<"精致雀翎">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111424) ->
    {ok, #item_base{
            id = 111424
            ,name = <<"金焰颅骨">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111425) ->
    {ok, #item_base{
            id = 111425
            ,name = <<"火纹树叶">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 1}]
            ,attr = []
        }
    };

get(111426) ->
    {ok, #item_base{
            id = 111426
            ,name = <<"银鸦羽">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 1}]
            ,attr = []
        }
    };

get(111451) ->
    {ok, #item_base{
            id = 111451
            ,name = <<"魔曜石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 150}]
            ,attr = []
        }
    };

get(111452) ->
    {ok, #item_base{
            id = 111452
            ,name = <<"魔法铭文 ">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 150}]
            ,attr = []
        }
    };

get(111453) ->
    {ok, #item_base{
            id = 111453
            ,name = <<"混沌火龙草">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 225}]
            ,attr = []
        }
    };

get(111454) ->
    {ok, #item_base{
            id = 111454
            ,name = <<"源河心石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 225}]
            ,attr = []
        }
    };

get(111455) ->
    {ok, #item_base{
            id = 111455
            ,name = <<"赤狱沙">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 275}]
            ,attr = []
        }
    };

get(111456) ->
    {ok, #item_base{
            id = 111456
            ,name = <<"帝晶石 ">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 275}]
            ,attr = []
        }
    };

get(111457) ->
    {ok, #item_base{
            id = 111457
            ,name = <<"霜钢锭">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 325}]
            ,attr = []
        }
    };

get(111458) ->
    {ok, #item_base{
            id = 111458
            ,name = <<"恒金矿石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 325}]
            ,attr = []
        }
    };

get(111476) ->
    {ok, #item_base{
            id = 111476
            ,name = <<"毒龙绿晶">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 150}]
            ,attr = []
        }
    };

get(111477) ->
    {ok, #item_base{
            id = 111477
            ,name = <<"冰龙秘晶">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 225}]
            ,attr = []
        }
    };

get(111478) ->
    {ok, #item_base{
            id = 111478
            ,name = <<"银龙血晶">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 275}]
            ,attr = []
        }
    };

get(111479) ->
    {ok, #item_base{
            id = 111479
            ,name = <<"虎眼石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111480) ->
    {ok, #item_base{
            id = 111480
            ,name = <<"水纹砂">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 150}]
            ,attr = []
        }
    };

get(111481) ->
    {ok, #item_base{
            id = 111481
            ,name = <<"银色龙牙">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 225}]
            ,attr = []
        }
    };

get(111482) ->
    {ok, #item_base{
            id = 111482
            ,name = <<"荒古钢石">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 275}]
            ,attr = []
        }
    };

get(111483) ->
    {ok, #item_base{
            id = 111483
            ,name = <<"太阳之尘">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 325}]
            ,attr = []
        }
    };

get(111484) ->
    {ok, #item_base{
            id = 111484
            ,name = <<"冥龙炎晶">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 275}]
            ,attr = []
        }
    };

get(111501) ->
    {ok, #item_base{
            id = 111501
            ,name = <<"低级幸运水晶">>
            ,type = 11
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(111502) ->
    {ok, #item_base{
            id = 111502
            ,name = <<"中级幸运水晶">>
            ,type = 11
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(111503) ->
    {ok, #item_base{
            id = 111503
            ,name = <<"高级幸运水晶">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(111504) ->
    {ok, #item_base{
            id = 111504
            ,name = <<"特级幸运水晶">>
            ,type = 11
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(111505) ->
    {ok, #item_base{
            id = 111505
            ,name = <<"璀璨幸运水晶">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(111600) ->
    {ok, #item_base{
            id = 111600
            ,name = <<"20级武器卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,attr = []
        }
    };

get(111601) ->
    {ok, #item_base{
            id = 111601
            ,name = <<"20级项链卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(111602) ->
    {ok, #item_base{
            id = 111602
            ,name = <<"20级护符卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(111603) ->
    {ok, #item_base{
            id = 111603
            ,name = <<"20级戒指卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(111604) ->
    {ok, #item_base{
            id = 111604
            ,name = <<"20级衣服卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(111605) ->
    {ok, #item_base{
            id = 111605
            ,name = <<"20级裤子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(111606) ->
    {ok, #item_base{
            id = 111606
            ,name = <<"20级护手卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(111607) ->
    {ok, #item_base{
            id = 111607
            ,name = <<"20级护腕卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(111608) ->
    {ok, #item_base{
            id = 111608
            ,name = <<"20级腰带卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(111609) ->
    {ok, #item_base{
            id = 111609
            ,name = <<"20级鞋子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(111610) ->
    {ok, #item_base{
            id = 111610
            ,name = <<"30级武器卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 30}]
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(111611) ->
    {ok, #item_base{
            id = 111611
            ,name = <<"30级项链卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 30}]
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(111612) ->
    {ok, #item_base{
            id = 111612
            ,name = <<"30级护符卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 30}]
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(111613) ->
    {ok, #item_base{
            id = 111613
            ,name = <<"30级戒指卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 30}]
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(111614) ->
    {ok, #item_base{
            id = 111614
            ,name = <<"30级衣服卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 30}]
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(111615) ->
    {ok, #item_base{
            id = 111615
            ,name = <<"30级裤子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 30}]
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(111616) ->
    {ok, #item_base{
            id = 111616
            ,name = <<"30级护手卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 30}]
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(111617) ->
    {ok, #item_base{
            id = 111617
            ,name = <<"30级护腕卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 30}]
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(111618) ->
    {ok, #item_base{
            id = 111618
            ,name = <<"30级腰带卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 30}]
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(111619) ->
    {ok, #item_base{
            id = 111619
            ,name = <<"30级鞋子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 30}]
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(111620) ->
    {ok, #item_base{
            id = 111620
            ,name = <<"40级武器卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3500}]
            ,attr = []
        }
    };

get(111621) ->
    {ok, #item_base{
            id = 111621
            ,name = <<"40级项链卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3500}]
            ,attr = []
        }
    };

get(111622) ->
    {ok, #item_base{
            id = 111622
            ,name = <<"40级护符卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3500}]
            ,attr = []
        }
    };

get(111623) ->
    {ok, #item_base{
            id = 111623
            ,name = <<"40级戒指卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3500}]
            ,attr = []
        }
    };

get(111624) ->
    {ok, #item_base{
            id = 111624
            ,name = <<"40级衣服卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3500}]
            ,attr = []
        }
    };

get(111625) ->
    {ok, #item_base{
            id = 111625
            ,name = <<"40级裤子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3500}]
            ,attr = []
        }
    };

get(111626) ->
    {ok, #item_base{
            id = 111626
            ,name = <<"40级护手卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3500}]
            ,attr = []
        }
    };

get(111627) ->
    {ok, #item_base{
            id = 111627
            ,name = <<"40级护腕卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3500}]
            ,attr = []
        }
    };

get(111628) ->
    {ok, #item_base{
            id = 111628
            ,name = <<"40级腰带卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3500}]
            ,attr = []
        }
    };

get(111629) ->
    {ok, #item_base{
            id = 111629
            ,name = <<"40级鞋子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,value = [{sell_npc, 3500}]
            ,attr = []
        }
    };

get(111630) ->
    {ok, #item_base{
            id = 111630
            ,name = <<"50级武器卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4500}]
            ,attr = []
        }
    };

get(111631) ->
    {ok, #item_base{
            id = 111631
            ,name = <<"50级项链卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4500}]
            ,attr = []
        }
    };

get(111632) ->
    {ok, #item_base{
            id = 111632
            ,name = <<"50级护符卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4500}]
            ,attr = []
        }
    };

get(111633) ->
    {ok, #item_base{
            id = 111633
            ,name = <<"50级戒指卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4500}]
            ,attr = []
        }
    };

get(111634) ->
    {ok, #item_base{
            id = 111634
            ,name = <<"50级衣服卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4500}]
            ,attr = []
        }
    };

get(111635) ->
    {ok, #item_base{
            id = 111635
            ,name = <<"50级裤子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4500}]
            ,attr = []
        }
    };

get(111636) ->
    {ok, #item_base{
            id = 111636
            ,name = <<"50级护手卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4500}]
            ,attr = []
        }
    };

get(111637) ->
    {ok, #item_base{
            id = 111637
            ,name = <<"50级护腕卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4500}]
            ,attr = []
        }
    };

get(111638) ->
    {ok, #item_base{
            id = 111638
            ,name = <<"50级腰带卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4500}]
            ,attr = []
        }
    };

get(111639) ->
    {ok, #item_base{
            id = 111639
            ,name = <<"50级鞋子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 50}]
            ,value = [{sell_npc, 4500}]
            ,attr = []
        }
    };

get(111640) ->
    {ok, #item_base{
            id = 111640
            ,name = <<"60级武器卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 5500}]
            ,attr = []
        }
    };

get(111641) ->
    {ok, #item_base{
            id = 111641
            ,name = <<"60级项链卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 5500}]
            ,attr = []
        }
    };

get(111642) ->
    {ok, #item_base{
            id = 111642
            ,name = <<"60级护符卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 5500}]
            ,attr = []
        }
    };

get(111643) ->
    {ok, #item_base{
            id = 111643
            ,name = <<"60级戒指卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 5500}]
            ,attr = []
        }
    };

get(111644) ->
    {ok, #item_base{
            id = 111644
            ,name = <<"60级衣服卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 5500}]
            ,attr = []
        }
    };

get(111645) ->
    {ok, #item_base{
            id = 111645
            ,name = <<"60级裤子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 5500}]
            ,attr = []
        }
    };

get(111646) ->
    {ok, #item_base{
            id = 111646
            ,name = <<"60级护手卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 5500}]
            ,attr = []
        }
    };

get(111647) ->
    {ok, #item_base{
            id = 111647
            ,name = <<"60级护腕卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 5500}]
            ,attr = []
        }
    };

get(111648) ->
    {ok, #item_base{
            id = 111648
            ,name = <<"60级腰带卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 5500}]
            ,attr = []
        }
    };

get(111649) ->
    {ok, #item_base{
            id = 111649
            ,name = <<"60级鞋子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 60}]
            ,value = [{sell_npc, 5500}]
            ,attr = []
        }
    };

get(111650) ->
    {ok, #item_base{
            id = 111650
            ,name = <<"70级武器卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 70}]
            ,value = [{sell_npc, 6500}]
            ,attr = []
        }
    };

get(111651) ->
    {ok, #item_base{
            id = 111651
            ,name = <<"70级项链卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 70}]
            ,value = [{sell_npc, 6500}]
            ,attr = []
        }
    };

get(111652) ->
    {ok, #item_base{
            id = 111652
            ,name = <<"70级护符卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 70}]
            ,value = [{sell_npc, 6500}]
            ,attr = []
        }
    };

get(111653) ->
    {ok, #item_base{
            id = 111653
            ,name = <<"70级戒指卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 70}]
            ,value = [{sell_npc, 6500}]
            ,attr = []
        }
    };

get(111654) ->
    {ok, #item_base{
            id = 111654
            ,name = <<"70级衣服卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 70}]
            ,value = [{sell_npc, 6500}]
            ,attr = []
        }
    };

get(111655) ->
    {ok, #item_base{
            id = 111655
            ,name = <<"70级裤子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 70}]
            ,value = [{sell_npc, 6500}]
            ,attr = []
        }
    };

get(111656) ->
    {ok, #item_base{
            id = 111656
            ,name = <<"70级护手卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 70}]
            ,value = [{sell_npc, 6500}]
            ,attr = []
        }
    };

get(111657) ->
    {ok, #item_base{
            id = 111657
            ,name = <<"70级护腕卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 70}]
            ,value = [{sell_npc, 6500}]
            ,attr = []
        }
    };

get(111658) ->
    {ok, #item_base{
            id = 111658
            ,name = <<"70级腰带卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 70}]
            ,value = [{sell_npc, 6500}]
            ,attr = []
        }
    };

get(111659) ->
    {ok, #item_base{
            id = 111659
            ,name = <<"70级鞋子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 70}]
            ,value = [{sell_npc, 6500}]
            ,attr = []
        }
    };

get(111660) ->
    {ok, #item_base{
            id = 111660
            ,name = <<"10级武器卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 1}]
            ,value = [{sell_npc, 200}]
            ,attr = []
        }
    };

get(111664) ->
    {ok, #item_base{
            id = 111664
            ,name = <<"10级衣服卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 1}]
            ,value = [{sell_npc, 200}]
            ,attr = []
        }
    };

get(111665) ->
    {ok, #item_base{
            id = 111665
            ,name = <<"10级裤子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 1}]
            ,value = [{sell_npc, 200}]
            ,attr = []
        }
    };

get(111666) ->
    {ok, #item_base{
            id = 111666
            ,name = <<"10级护手卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 1}]
            ,value = [{sell_npc, 200}]
            ,attr = []
        }
    };

get(111667) ->
    {ok, #item_base{
            id = 111667
            ,name = <<"10级护腕卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 1}]
            ,value = [{sell_npc, 200}]
            ,attr = []
        }
    };

get(111668) ->
    {ok, #item_base{
            id = 111668
            ,name = <<"10级腰带卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 1}]
            ,value = [{sell_npc, 200}]
            ,attr = []
        }
    };

get(111669) ->
    {ok, #item_base{
            id = 111669
            ,name = <<"10级鞋子卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 1}]
            ,value = [{sell_npc, 200}]
            ,attr = []
        }
    };

get(121101) ->
    {ok, #item_base{
            id = 121101
            ,name = <<"40级制作护纹">>
            ,type = 12
            ,quality = 5
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 40000}]
            ,attr = []
        }
    };

get(121102) ->
    {ok, #item_base{
            id = 121102
            ,name = <<"50级制作护纹">>
            ,type = 12
            ,quality = 5
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 75000}]
            ,attr = []
        }
    };

get(121103) ->
    {ok, #item_base{
            id = 121103
            ,name = <<"60级制作护纹">>
            ,type = 12
            ,quality = 5
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 150000}]
            ,attr = []
        }
    };

get(121104) ->
    {ok, #item_base{
            id = 121104
            ,name = <<"70级制作护纹">>
            ,type = 12
            ,quality = 5
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 300000}]
            ,attr = []
        }
    };

get(121201) ->
    {ok, #item_base{
            id = 121201
            ,name = <<"打孔钻">>
            ,type = 12
            ,quality = 4
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(131001) ->
    {ok, #item_base{
            id = 131001
            ,name = <<"技能残卷">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 5000}]
            ,attr = []
        }
    };

get(132001) ->
    {ok, #item_base{
            id = 132001
            ,name = <<"低阶连击符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 40000}]
			,effect = [{pet_skill,  100101}]
            ,attr = []
        }
    };

get(132002) ->
    {ok, #item_base{
            id = 132002
            ,name = <<"中阶连击符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 170000}]
			,effect = [{pet_skill,  100201}]
            ,attr = []
        }
    };

get(132003) ->
    {ok, #item_base{
            id = 132003
            ,name = <<"高阶连击符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 430000}]
			,effect = [{pet_skill,  100301}]
            ,attr = []
        }
    };

get(132004) ->
    {ok, #item_base{
            id = 132004
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132005) ->
    {ok, #item_base{
            id = 132005
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132006) ->
    {ok, #item_base{
            id = 132006
            ,name = <<"低阶暴怒符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 10000}]
			,effect = [{pet_skill,  110101}]
            ,attr = []
        }
    };

get(132007) ->
    {ok, #item_base{
            id = 132007
            ,name = <<"中阶暴怒符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 110000}]
			,effect = [{pet_skill,  110201}]
            ,attr = []
        }
    };

get(132008) ->
    {ok, #item_base{
            id = 132008
            ,name = <<"高阶暴怒符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 260000}]
			,effect = [{pet_skill,  110301}]
            ,attr = []
        }
    };

get(132009) ->
    {ok, #item_base{
            id = 132009
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132010) ->
    {ok, #item_base{
            id = 132010
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132011) ->
    {ok, #item_base{
            id = 132011
            ,name = <<"低阶精准符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 10000}]
			,effect = [{pet_skill,  120101}]
            ,attr = []
        }
    };

get(132012) ->
    {ok, #item_base{
            id = 132012
            ,name = <<"中阶精准符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 110000}]
			,effect = [{pet_skill,  120201}]
            ,attr = []
        }
    };

get(132013) ->
    {ok, #item_base{
            id = 132013
            ,name = <<"高阶精准符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 260000}]
			,effect = [{pet_skill,  120301}]
            ,attr = []
        }
    };

get(132014) ->
    {ok, #item_base{
            id = 132014
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132015) ->
    {ok, #item_base{
            id = 132015
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132016) ->
    {ok, #item_base{
            id = 132016
            ,name = <<"低阶格挡符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 10000}]
			,effect = [{pet_skill,  130101}]
            ,attr = []
        }
    };

get(132017) ->
    {ok, #item_base{
            id = 132017
            ,name = <<"中阶格挡符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 110000}]
			,effect = [{pet_skill,  130201}]
            ,attr = []
        }
    };

get(132018) ->
    {ok, #item_base{
            id = 132018
            ,name = <<"高阶格挡符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 260000}]
			,effect = [{pet_skill,  130301}]
            ,attr = []
        }
    };

get(132019) ->
    {ok, #item_base{
            id = 132019
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132020) ->
    {ok, #item_base{
            id = 132020
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132021) ->
    {ok, #item_base{
            id = 132021
            ,name = <<"低阶坚韧符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 6000}]
			,effect = [{pet_skill,  140101}]
            ,attr = []
        }
    };

get(132022) ->
    {ok, #item_base{
            id = 132022
            ,name = <<"中阶坚韧符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 60000}]
			,effect = [{pet_skill,  140201}]
            ,attr = []
        }
    };

get(132023) ->
    {ok, #item_base{
            id = 132023
            ,name = <<"高阶坚韧符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 190000}]
			,effect = [{pet_skill,  140301}]
            ,attr = []
        }
    };

get(132024) ->
    {ok, #item_base{
            id = 132024
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132025) ->
    {ok, #item_base{
            id = 132025
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132026) ->
    {ok, #item_base{
            id = 132026
            ,name = <<"低阶重生符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 40000}]
			,effect = [{pet_skill,  150101}]
            ,attr = []
        }
    };

get(132027) ->
    {ok, #item_base{
            id = 132027
            ,name = <<"中阶重生符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 170000}]
			,effect = [{pet_skill,  150201}]
            ,attr = []
        }
    };

get(132028) ->
    {ok, #item_base{
            id = 132028
            ,name = <<"高阶重生符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 430000}]
			,effect = [{pet_skill,  150301}]
            ,attr = []
        }
    };

get(132029) ->
    {ok, #item_base{
            id = 132029
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132030) ->
    {ok, #item_base{
            id = 132030
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132031) ->
    {ok, #item_base{
            id = 132031
            ,name = <<"低阶抗性符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 10000}]
			,effect = [{pet_skill,  160101}]
            ,attr = []
        }
    };

get(132032) ->
    {ok, #item_base{
            id = 132032
            ,name = <<"中阶抗性符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 120000}]
			,effect = [{pet_skill,  160201}]
            ,attr = []
        }
    };

get(132033) ->
    {ok, #item_base{
            id = 132033
            ,name = <<"高阶抗性符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 260000}]
			,effect = [{pet_skill,  160301}]
            ,attr = []
        }
    };

get(132034) ->
    {ok, #item_base{
            id = 132034
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132035) ->
    {ok, #item_base{
            id = 132035
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132036) ->
    {ok, #item_base{
            id = 132036
            ,name = <<"低阶防御符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 6000}]
			,effect = [{pet_skill,  170101}]
            ,attr = []
        }
    };

get(132037) ->
    {ok, #item_base{
            id = 132037
            ,name = <<"中阶防御符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 60000}]
			,effect = [{pet_skill,  170201}]
            ,attr = []
        }
    };

get(132038) ->
    {ok, #item_base{
            id = 132038
            ,name = <<"高阶防御符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 190000}]
			,effect = [{pet_skill,  170301}]
            ,attr = []
        }
    };

get(132039) ->
    {ok, #item_base{
            id = 132039
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132040) ->
    {ok, #item_base{
            id = 132040
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132041) ->
    {ok, #item_base{
            id = 132041
            ,name = <<"低阶毒焰符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 10000}]
			,effect = [{pet_skill,  180101}]
            ,attr = []
        }
    };

get(132042) ->
    {ok, #item_base{
            id = 132042
            ,name = <<"中阶毒焰符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 110000}]
			,effect = [{pet_skill,  180201}]
            ,attr = []
        }
    };

get(132043) ->
    {ok, #item_base{
            id = 132043
            ,name = <<"高阶毒焰符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 260000}]
			,effect = [{pet_skill,  180301}]
            ,attr = []
        }
    };

get(132044) ->
    {ok, #item_base{
            id = 132044
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132045) ->
    {ok, #item_base{
            id = 132045
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132046) ->
    {ok, #item_base{
            id = 132046
            ,name = <<"低阶攻击符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 10000}]
			,effect = [{pet_skill,  190101}]
            ,attr = []
        }
    };

get(132047) ->
    {ok, #item_base{
            id = 132047
            ,name = <<"中阶攻击符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 120000}]
			,effect = [{pet_skill,  190201}]
            ,attr = []
        }
    };

get(132048) ->
    {ok, #item_base{
            id = 132048
            ,name = <<"高阶攻击符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 260000}]
			,effect = [{pet_skill,  190301}]
            ,attr = []
        }
    };

get(132049) ->
    {ok, #item_base{
            id = 132049
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132050) ->
    {ok, #item_base{
            id = 132050
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132051) ->
    {ok, #item_base{
            id = 132051
            ,name = <<"低阶破甲符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 40000}]
			,effect = [{pet_skill,  200101}]
            ,attr = []
        }
    };

get(132052) ->
    {ok, #item_base{
            id = 132052
            ,name = <<"中阶破甲符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 170000}]
			,effect = [{pet_skill,  200201}]
            ,attr = []
        }
    };

get(132053) ->
    {ok, #item_base{
            id = 132053
            ,name = <<"高阶破甲符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 430000}]
			,effect = [{pet_skill,  200301}]
            ,attr = []
        }
    };

get(132054) ->
    {ok, #item_base{
            id = 132054
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132055) ->
    {ok, #item_base{
            id = 132055
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132056) ->
    {ok, #item_base{
            id = 132056
            ,name = <<"低阶破魔符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 10000}]
			,effect = [{pet_skill,  210101}]
            ,attr = []
        }
    };

get(132057) ->
    {ok, #item_base{
            id = 132057
            ,name = <<"中阶破魔符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 110000}]
			,effect = [{pet_skill,  210201}]
            ,attr = []
        }
    };

get(132058) ->
    {ok, #item_base{
            id = 132058
            ,name = <<"高阶破魔符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 260000}]
			,effect = [{pet_skill,  210301}]
            ,attr = []
        }
    };

get(132059) ->
    {ok, #item_base{
            id = 132059
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132060) ->
    {ok, #item_base{
            id = 132060
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132061) ->
    {ok, #item_base{
            id = 132061
            ,name = <<"低阶守护符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 15000}]
			,effect = [{pet_skill,  220101}]
            ,attr = []
        }
    };

get(132062) ->
    {ok, #item_base{
            id = 132062
            ,name = <<"中阶守护符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 120000}]
			,effect = [{pet_skill,  220201}]
            ,attr = []
        }
    };

get(132063) ->
    {ok, #item_base{
            id = 132063
            ,name = <<"高阶守护符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 260000}]
			,effect = [{pet_skill,  220301}]
            ,attr = []
        }
    };

get(132064) ->
    {ok, #item_base{
            id = 132064
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132065) ->
    {ok, #item_base{
            id = 132065
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132066) ->
    {ok, #item_base{
            id = 132066
            ,name = <<"低阶治愈符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 6000}]
			,effect = [{pet_skill,  230101}]
            ,attr = []
        }
    };

get(132067) ->
    {ok, #item_base{
            id = 132067
            ,name = <<"中阶治愈符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 60000}]
			,effect = [{pet_skill,  230201}]
            ,attr = []
        }
    };

get(132068) ->
    {ok, #item_base{
            id = 132068
            ,name = <<"高阶治愈符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 190000}]
			,effect = [{pet_skill,  230301}]
            ,attr = []
        }
    };

get(132069) ->
    {ok, #item_base{
            id = 132069
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132070) ->
    {ok, #item_base{
            id = 132070
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132071) ->
    {ok, #item_base{
            id = 132071
            ,name = <<"低阶回魔符文">>
            ,type = 13
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 6000}]
			,effect = [{pet_skill,  240101}]
            ,attr = []
        }
    };

get(132072) ->
    {ok, #item_base{
            id = 132072
            ,name = <<"中阶回魔符文">>
            ,type = 13
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 60000}]
			,effect = [{pet_skill,  240201}]
            ,attr = []
        }
    };

get(132073) ->
    {ok, #item_base{
            id = 132073
            ,name = <<"高阶回魔符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 190000}]
			,effect = [{pet_skill,  240301}]
            ,attr = []
        }
    };

get(132074) ->
    {ok, #item_base{
            id = 132074
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132075) ->
    {ok, #item_base{
            id = 132075
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132081) ->
    {ok, #item_base{
            id = 132081
            ,name = <<"招架符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
			,effect = [{pet_skill,  250101}]
            ,attr = []
        }
    };

get(132082) ->
    {ok, #item_base{
            id = 132082
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132083) ->
    {ok, #item_base{
            id = 132083
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132084) ->
    {ok, #item_base{
            id = 132084
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132085) ->
    {ok, #item_base{
            id = 132085
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132091) ->
    {ok, #item_base{
            id = 132091
            ,name = <<"反击符文">>
            ,type = 13
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
			,effect = [{pet_skill,  260101}]
            ,attr = []
        }
    };

get(132092) ->
    {ok, #item_base{
            id = 132092
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132093) ->
    {ok, #item_base{
            id = 132093
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132094) ->
    {ok, #item_base{
            id = 132094
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(132095) ->
    {ok, #item_base{
            id = 132095
            ,name = <<"预留">>
            ,type = 13
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(221301) ->
    {ok, #item_base{
            id = 221301
            ,name = <<"一级攻击药剂">>
            ,type = 22
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 500}]
            ,attr = []
        }
    };

get(221311) ->
    {ok, #item_base{
            id = 221311
            ,name = <<"一级防御药剂">>
            ,type = 22
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 500}]
            ,attr = []
        }
    };

get(221321) ->
    {ok, #item_base{
            id = 221321
            ,name = <<"一级生命药剂">>
            ,type = 22
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 500}]
            ,attr = []
        }
    };

get(221331) ->
    {ok, #item_base{
            id = 221331
            ,name = <<"一级暴怒药剂">>
            ,type = 22
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 500}]
            ,attr = []
        }
    };

get(221302) ->
    {ok, #item_base{
            id = 221302
            ,name = <<"二级攻击药剂">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1200}]
            ,attr = []
        }
    };

get(221312) ->
    {ok, #item_base{
            id = 221312
            ,name = <<"二级防御药剂">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1200}]
            ,attr = []
        }
    };

get(221322) ->
    {ok, #item_base{
            id = 221322
            ,name = <<"二级生命药剂">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1200}]
            ,attr = []
        }
    };

get(221332) ->
    {ok, #item_base{
            id = 221332
            ,name = <<"二级暴怒药剂">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1200}]
            ,attr = []
        }
    };

get(221342) ->
    {ok, #item_base{
            id = 221342
            ,name = <<"二级精准药剂">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1200}]
            ,attr = []
        }
    };

get(221303) ->
    {ok, #item_base{
            id = 221303
            ,name = <<"三级攻击药剂">>
            ,type = 22
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(221313) ->
    {ok, #item_base{
            id = 221313
            ,name = <<"三级防御药剂">>
            ,type = 22
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(221323) ->
    {ok, #item_base{
            id = 221323
            ,name = <<"三级生命药剂">>
            ,type = 22
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(221333) ->
    {ok, #item_base{
            id = 221333
            ,name = <<"三级暴怒药剂">>
            ,type = 22
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(221343) ->
    {ok, #item_base{
            id = 221343
            ,name = <<"三级精准药剂">>
            ,type = 22
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(221353) ->
    {ok, #item_base{
            id = 221353
            ,name = <<"三级格挡药剂">>
            ,type = 22
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 1500}]
            ,attr = []
        }
    };

get(221304) ->
    {ok, #item_base{
            id = 221304
            ,name = <<"四级攻击药剂">>
            ,type = 22
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2200}]
            ,attr = []
        }
    };

get(221314) ->
    {ok, #item_base{
            id = 221314
            ,name = <<"四级防御药剂">>
            ,type = 22
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2200}]
            ,attr = []
        }
    };

get(221324) ->
    {ok, #item_base{
            id = 221324
            ,name = <<"四级生命药剂">>
            ,type = 22
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2200}]
            ,attr = []
        }
    };

get(221334) ->
    {ok, #item_base{
            id = 221334
            ,name = <<"四级暴怒药剂">>
            ,type = 22
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2200}]
            ,attr = []
        }
    };

get(221344) ->
    {ok, #item_base{
            id = 221344
            ,name = <<"四级精准药剂">>
            ,type = 22
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2200}]
            ,attr = []
        }
    };

get(221354) ->
    {ok, #item_base{
            id = 221354
            ,name = <<"四级格挡药剂">>
            ,type = 22
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2200}]
            ,attr = []
        }
    };

get(221364) ->
    {ok, #item_base{
            id = 221364
            ,name = <<"四级坚韧药剂">>
            ,type = 22
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2200}]
            ,attr = []
        }
    };

get(221374) ->
    {ok, #item_base{
            id = 221374
            ,name = <<"四级智力药剂">>
            ,type = 22
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2200}]
            ,attr = []
        }
    };

get(221384) ->
    {ok, #item_base{
            id = 221384
            ,name = <<"四级抗性药剂">>
            ,type = 22
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2200}]
            ,attr = []
        }
    };

get(221394) ->
    {ok, #item_base{
            id = 221394
            ,name = <<"四级伤害药剂">>
            ,type = 22
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2200}]
            ,attr = []
        }
    };

get(221305) ->
    {ok, #item_base{
            id = 221305
            ,name = <<"五级攻击药剂">>
            ,type = 22
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(221315) ->
    {ok, #item_base{
            id = 221315
            ,name = <<"五级防御药剂">>
            ,type = 22
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(221325) ->
    {ok, #item_base{
            id = 221325
            ,name = <<"五级生命药剂">>
            ,type = 22
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(221335) ->
    {ok, #item_base{
            id = 221335
            ,name = <<"五级暴怒药剂">>
            ,type = 22
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(221345) ->
    {ok, #item_base{
            id = 221345
            ,name = <<"五级精准药剂">>
            ,type = 22
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(221355) ->
    {ok, #item_base{
            id = 221355
            ,name = <<"五级格挡药剂">>
            ,type = 22
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(221365) ->
    {ok, #item_base{
            id = 221365
            ,name = <<"五级坚韧药剂">>
            ,type = 22
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(221375) ->
    {ok, #item_base{
            id = 221375
            ,name = <<"五级智力药剂">>
            ,type = 22
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(221385) ->
    {ok, #item_base{
            id = 221385
            ,name = <<"五级抗性药剂">>
            ,type = 22
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(221395) ->
    {ok, #item_base{
            id = 221395
            ,name = <<"五级伤害药剂">>
            ,type = 22
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 2500}]
            ,attr = []
        }
    };

get(222401) ->
    {ok, #item_base{
            id = 222401
            ,name = <<"野浆果">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222402) ->
    {ok, #item_base{
            id = 222402
            ,name = <<"薄荷液">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222403) ->
    {ok, #item_base{
            id = 222403
            ,name = <<"山葡萄">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222404) ->
    {ok, #item_base{
            id = 222404
            ,name = <<"水仙根">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222405) ->
    {ok, #item_base{
            id = 222405
            ,name = <<"雏菊花瓣">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222406) ->
    {ok, #item_base{
            id = 222406
            ,name = <<"龙舌兰">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222407) ->
    {ok, #item_base{
            id = 222407
            ,name = <<"月桂树枝">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222408) ->
    {ok, #item_base{
            id = 222408
            ,name = <<"枫糖浸液">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222409) ->
    {ok, #item_base{
            id = 222409
            ,name = <<"月长石粉末">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222410) ->
    {ok, #item_base{
            id = 222410
            ,name = <<"蜂鸟羽毛">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222411) ->
    {ok, #item_base{
            id = 222411
            ,name = <<"月光兽角">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222412) ->
    {ok, #item_base{
            id = 222412
            ,name = <<"仙人掌汁">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222413) ->
    {ok, #item_base{
            id = 222413
            ,name = <<"曼德拉草">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222414) ->
    {ok, #item_base{
            id = 222414
            ,name = <<"满月草">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222415) ->
    {ok, #item_base{
            id = 222415
            ,name = <<"独角兽血">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222416) ->
    {ok, #item_base{
            id = 222416
            ,name = <<"黑珍珠粉">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222417) ->
    {ok, #item_base{
            id = 222417
            ,name = <<"不老泉水">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222418) ->
    {ok, #item_base{
            id = 222418
            ,name = <<"墨角藻">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(222419) ->
    {ok, #item_base{
            id = 222419
            ,name = <<"鹿舌草">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(231001) ->
    {ok, #item_base{
            id = 231001
            ,name = <<"强化神源">>
            ,type = 23
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 3000}]
            ,attr = []
        }
    };

get(231002) ->
    {ok, #item_base{
            id = 231002
            ,name = <<"神觉强化护纹">>
            ,type = 23
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 60000}]
            ,attr = []
        }
    };

get(501001) ->
    {ok, #item_base{
            id = 501001
            ,name = <<"人偶">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501002) ->
    {ok, #item_base{
            id = 501002
            ,name = <<"绑丝带的小人偶">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501003) ->
    {ok, #item_base{
            id = 501003
            ,name = <<"破旧的帽子">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501004) ->
    {ok, #item_base{
            id = 501004
            ,name = <<"龟壳">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501005) ->
    {ok, #item_base{
            id = 501005
            ,name = <<"瓶子">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501006) ->
    {ok, #item_base{
            id = 501006
            ,name = <<"装神源的瓶子">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501007) ->
    {ok, #item_base{
            id = 501007
            ,name = <<"一截树根">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501008) ->
    {ok, #item_base{
            id = 501008
            ,name = <<"黑面包">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501009) ->
    {ok, #item_base{
            id = 501009
            ,name = <<"封魔书">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501010) ->
    {ok, #item_base{
            id = 501010
            ,name = <<"兔吉恩的优惠券">>
            ,type = 50
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(501201) ->
    {ok, #item_base{
            id = 501201
            ,name = <<"卡萝大妈的袜子">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501202) ->
    {ok, #item_base{
            id = 501202
            ,name = <<"女巫艾娃的发卡">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501203) ->
    {ok, #item_base{
            id = 501203
            ,name = <<"王国将领的勋章">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501204) ->
    {ok, #item_base{
            id = 501204
            ,name = <<"沐晨村村长的帽子">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501205) ->
    {ok, #item_base{
            id = 501205
            ,name = <<"老巫师的魔法书">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501206) ->
    {ok, #item_base{
            id = 501206
            ,name = <<"威利的小刀">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501207) ->
    {ok, #item_base{
            id = 501207
            ,name = <<"凯文的手套">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501208) ->
    {ok, #item_base{
            id = 501208
            ,name = <<"路易斯的戒指">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501209) ->
    {ok, #item_base{
            id = 501209
            ,name = <<"马卡斯的围巾">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(501210) ->
    {ok, #item_base{
            id = 501210
            ,name = <<"神秘商人的丝巾">>
            ,type = 50
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(522000) ->
    {ok, #item_base{
            id = 522000
            ,name = <<"艾娃的梦境">>
            ,type = 52
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,attr = []
        }
    };

get(532301) ->
    {ok, #item_base{
            id = 532301
            ,name = <<"VIP专属翅膀">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532302) ->
    {ok, #item_base{
            id = 532302
            ,name = <<"VIP专属时装礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532303) ->
    {ok, #item_base{
            id = 532303
            ,name = <<"VIP专属高级时装礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532501) ->
    {ok, #item_base{
            id = 532501
            ,name = <<"VIP1礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532502) ->
    {ok, #item_base{
            id = 532502
            ,name = <<"VIP2礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532503) ->
    {ok, #item_base{
            id = 532503
            ,name = <<"VIP3礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532504) ->
    {ok, #item_base{
            id = 532504
            ,name = <<"VIP4礼包">>
            ,type = 53
            ,quality = 4
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532505) ->
    {ok, #item_base{
            id = 532505
            ,name = <<"VIP5礼包">>
            ,type = 53
            ,quality = 4
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532506) ->
    {ok, #item_base{
            id = 532506
            ,name = <<"VIP6礼包">>
            ,type = 53
            ,quality = 4
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532507) ->
    {ok, #item_base{
            id = 532507
            ,name = <<"VIP7礼包">>
            ,type = 53
            ,quality = 4
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532508) ->
    {ok, #item_base{
            id = 532508
            ,name = <<"VIP8礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532509) ->
    {ok, #item_base{
            id = 532509
            ,name = <<"VIP9礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532510) ->
    {ok, #item_base{
            id = 532510
            ,name = <<"VIP10礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532511) ->
    {ok, #item_base{
            id = 532511
            ,name = <<"初级契约礼包">>
            ,type = 53
            ,quality = 2
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532512) ->
    {ok, #item_base{
            id = 532512
            ,name = <<"中级契约礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532513) ->
    {ok, #item_base{
            id = 532513
            ,name = <<"高级契约礼包">>
            ,type = 53
            ,quality = 4
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532514) ->
    {ok, #item_base{
            id = 532514
            ,name = <<"首充翅膀">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(532515) ->
    {ok, #item_base{
            id = 532515
            ,name = <<"反震技能礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532516) ->
    {ok, #item_base{
            id = 532516
            ,name = <<"首充大礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532517) ->
    {ok, #item_base{
            id = 532517
            ,name = <<"协同作战礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532518) ->
    {ok, #item_base{
            id = 532518
            ,name = <<"首次招募礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532519) ->
    {ok, #item_base{
            id = 532519
            ,name = <<"二次招募礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532520) ->
    {ok, #item_base{
            id = 532520
            ,name = <<"三次招募礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532521) ->
    {ok, #item_base{
            id = 532521
            ,name = <<"四次招募礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532522) ->
    {ok, #item_base{
            id = 532522
            ,name = <<"招募大使礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532523) ->
    {ok, #item_base{
            id = 532523
            ,name = <<"刮刮乐卡片">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(532524) ->
    {ok, #item_base{
            id = 532524
            ,name = <<"封测新手大礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(532525) ->
    {ok, #item_base{
            id = 532525
            ,name = <<"小型刮刮乐卡片">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(531001) ->
    {ok, #item_base{
            id = 531001
            ,name = <<"沐晨村赠别礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(531002) ->
    {ok, #item_base{
            id = 531002
            ,name = <<"伙伴技能礼盒">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(531003) ->
    {ok, #item_base{
            id = 531003
            ,name = <<"中级伙伴技能礼盒">>
            ,type = 53
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(531004) ->
    {ok, #item_base{
            id = 531004
            ,name = <<"高级伙伴技能礼盒">>
            ,type = 53
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(531005) ->
    {ok, #item_base{
            id = 531005
            ,name = <<"20级升级礼包">>
            ,type = 53
            ,quality = 4
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 20}]
            ,attr = []
        }
    };

get(531006) ->
    {ok, #item_base{
            id = 531006
            ,name = <<"30级升级礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 30}]
            ,attr = []
        }
    };

get(531007) ->
    {ok, #item_base{
            id = 531007
            ,name = <<"40级升级礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 40}]
            ,attr = []
        }
    };

get(531008) ->
    {ok, #item_base{
            id = 531008
            ,name = <<"伙伴装备礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 10}]
            ,attr = []
        }
    };

get(531009) ->
    {ok, #item_base{
            id = 531009
            ,name = <<"伙伴粉装礼盒">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 10}]
            ,attr = []
        }
    };

get(531010) ->
    {ok, #item_base{
            id = 531010
            ,name = <<"30武器材料包">>
            ,type = 53
            ,quality = 3
            ,overlap = 9
            ,use_type = 1
            ,attr = []
        }
    };

get(531011) ->
    {ok, #item_base{
            id = 531011
            ,name = <<"40武器材料包">>
            ,type = 53
            ,quality = 3
            ,overlap = 9
            ,use_type = 1
            ,attr = []
        }
    };

get(531012) ->
    {ok, #item_base{
            id = 531012
            ,name = <<"50武器材料包">>
            ,type = 53
            ,quality = 3
            ,overlap = 9
            ,use_type = 1
            ,attr = []
        }
    };

get(531013) ->
    {ok, #item_base{
            id = 531013
            ,name = <<"60武器材料包">>
            ,type = 53
            ,quality = 3
            ,overlap = 9
            ,use_type = 1
            ,attr = []
        }
    };

get(531014) ->
    {ok, #item_base{
            id = 531014
            ,name = <<"小型强化材料包">>
            ,type = 53
            ,quality = 3
            ,overlap = 9
            ,use_type = 1
            ,attr = []
        }
    };

get(531015) ->
    {ok, #item_base{
            id = 531015
            ,name = <<"中型强化材料包">>
            ,type = 53
            ,quality = 3
            ,overlap = 9
            ,use_type = 1
            ,attr = []
        }
    };

get(531016) ->
    {ok, #item_base{
            id = 531016
            ,name = <<"大型强化材料包">>
            ,type = 53
            ,quality = 3
            ,overlap = 9
            ,use_type = 1
            ,attr = []
        }
    };

get(534000) ->
    {ok, #item_base{
            id = 534000
            ,name = <<"艾娃的装备礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 9
            ,use_type = 1
            ,attr = []
        }
    };

get(534001) ->
    {ok, #item_base{
            id = 534001
            ,name = <<"艾娃的伙伴礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 9
            ,use_type = 1
            ,attr = []
        }
    };

get(534002) ->
    {ok, #item_base{
            id = 534002
            ,name = <<"艾娃的妖精礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 9
            ,use_type = 1
            ,attr = []
        }
    };

get(535601) ->
    {ok, #item_base{
            id = 535601
            ,name = <<"绿色妖精碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535602) ->
    {ok, #item_base{
            id = 535602
            ,name = <<"蓝色妖精碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535603) ->
    {ok, #item_base{
            id = 535603
            ,name = <<"紫色妖精碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535604) ->
    {ok, #item_base{
            id = 535604
            ,name = <<"拳王妖精匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535605) ->
    {ok, #item_base{
            id = 535605
            ,name = <<"灰烬恶魔碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535606) ->
    {ok, #item_base{
            id = 535606
            ,name = <<"牛头恶魔碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535607) ->
    {ok, #item_base{
            id = 535607
            ,name = <<"虚空树妖碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535608) ->
    {ok, #item_base{
            id = 535608
            ,name = <<"狂暴野猪碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535609) ->
    {ok, #item_base{
            id = 535609
            ,name = <<"咆哮棕熊碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535610) ->
    {ok, #item_base{
            id = 535610
            ,name = <<"南瓜怪碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535611) ->
    {ok, #item_base{
            id = 535611
            ,name = <<"蓝晶巨石怪碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535612) ->
    {ok, #item_base{
            id = 535612
            ,name = <<"洞穴蜥蜴碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535613) ->
    {ok, #item_base{
            id = 535613
            ,name = <<"树根蜥蜴碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535614) ->
    {ok, #item_base{
            id = 535614
            ,name = <<"沙漠蜥蜴碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535615) ->
    {ok, #item_base{
            id = 535615
            ,name = <<"骷髅法师碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535616) ->
    {ok, #item_base{
            id = 535616
            ,name = <<"黑暗树根怪碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535617) ->
    {ok, #item_base{
            id = 535617
            ,name = <<"诅咒树根怪碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535618) ->
    {ok, #item_base{
            id = 535618
            ,name = <<"混沌沙虫碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535619) ->
    {ok, #item_base{
            id = 535619
            ,name = <<"骷髅骑士碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535620) ->
    {ok, #item_base{
            id = 535620
            ,name = <<"救赎叶子精碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535621) ->
    {ok, #item_base{
            id = 535621
            ,name = <<"部落地精碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535622) ->
    {ok, #item_base{
            id = 535622
            ,name = <<"枷锁巨兔碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535623) ->
    {ok, #item_base{
            id = 535623
            ,name = <<"怒焰恶魔碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535624) ->
    {ok, #item_base{
            id = 535624
            ,name = <<"深渊沙虫碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535625) ->
    {ok, #item_base{
            id = 535625
            ,name = <<"鹿角巨兔碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535626) ->
    {ok, #item_base{
            id = 535626
            ,name = <<"狱火巨蝎碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535627) ->
    {ok, #item_base{
            id = 535627
            ,name = <<"远古骷髅碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535628) ->
    {ok, #item_base{
            id = 535628
            ,name = <<"幽暗树蛙碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535629) ->
    {ok, #item_base{
            id = 535629
            ,name = <<"野蛮小草碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535630) ->
    {ok, #item_base{
            id = 535630
            ,name = <<"剑士兔碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535631) ->
    {ok, #item_base{
            id = 535631
            ,name = <<"铠甲骑士马碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535632) ->
    {ok, #item_base{
            id = 535632
            ,name = <<"拳王碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535633) ->
    {ok, #item_base{
            id = 535633
            ,name = <<"荒野猎人碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535634) ->
    {ok, #item_base{
            id = 535634
            ,name = <<"巨翼灵兵碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535635) ->
    {ok, #item_base{
            id = 535635
            ,name = <<"史诗骑士碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535636) ->
    {ok, #item_base{
            id = 535636
            ,name = <<"花之精灵碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535637) ->
    {ok, #item_base{
            id = 535637
            ,name = <<"火之精灵碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535638) ->
    {ok, #item_base{
            id = 535638
            ,name = <<"石之精灵碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535639) ->
    {ok, #item_base{
            id = 535639
            ,name = <<"棕熊法师碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535640) ->
    {ok, #item_base{
            id = 535640
            ,name = <<"黄铜守卫碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535641) ->
    {ok, #item_base{
            id = 535641
            ,name = <<"绿革守卫碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535642) ->
    {ok, #item_base{
            id = 535642
            ,name = <<"银甲守卫碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535643) ->
    {ok, #item_base{
            id = 535643
            ,name = <<"永罚怨灵碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535644) ->
    {ok, #item_base{
            id = 535644
            ,name = <<"种子怪碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535645) ->
    {ok, #item_base{
            id = 535645
            ,name = <<"破晓女神碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535646) ->
    {ok, #item_base{
            id = 535646
            ,name = <<"霜雪牦牛碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535647) ->
    {ok, #item_base{
            id = 535647
            ,name = <<"半人马法师碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535648) ->
    {ok, #item_base{
            id = 535648
            ,name = <<"吞噬巨蜥碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535649) ->
    {ok, #item_base{
            id = 535649
            ,name = <<"恐惧魔王碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535650) ->
    {ok, #item_base{
            id = 535650
            ,name = <<"噩梦女巫碎片匣">>
            ,type = 53
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535651) ->
    {ok, #item_base{
            id = 535651
            ,name = <<"遗落松鼠碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535652) ->
    {ok, #item_base{
            id = 535652
            ,name = <<"狂野水精碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535653) ->
    {ok, #item_base{
            id = 535653
            ,name = <<"燃草火精碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535654) ->
    {ok, #item_base{
            id = 535654
            ,name = <<"蒜头小兵碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535655) ->
    {ok, #item_base{
            id = 535655
            ,name = <<"森林兔子碎片匣">>
            ,type = 53
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(535656) ->
    {ok, #item_base{
            id = 535656
            ,name = <<"幽惑花妖碎片匣">>
            ,type = 53
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(611101) ->
    {ok, #item_base{
            id = 611101
            ,name = <<"普通炸弹">>
            ,type = 61
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(611102) ->
    {ok, #item_base{
            id = 611102
            ,name = <<"强力炸弹">>
            ,type = 61
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
            ,attr = []
        }
    };

get(611501) ->
    {ok, #item_base{
            id = 611501
            ,name = <<"扫荡券">>
            ,type = 61
            ,quality = 3
            ,overlap = 999
            ,use_type = 1
            ,attr = []
        }
    };

get(621100) ->
    {ok, #item_base{
            id = 621100
            ,name = <<"潜能石">>
            ,type = 62
            ,quality = 2
            ,overlap = 999
            ,use_type = 1
            ,value = [{sell_npc, 1000}]
            ,attr = []
        }
    };

get(621101) ->
    {ok, #item_base{
            id = 621101
            ,name = <<"潜能护纹">>
            ,type = 62
            ,quality = 5
            ,overlap = 99
            ,use_type = 0
            ,value = [{sell_npc, 30000}]
            ,attr = []
        }
    };

get(621201) ->
    {ok, #item_base{
            id = 621201
            ,name = <<"命运硬币">>
            ,type = 62
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 6000}]
            ,attr = []
        }
    };

get(621401) ->
    {ok, #item_base{
            id = 621401
            ,name = <<"龙蛋">>
            ,type = 62
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
			,effect = [{pet,  [{base_id,  124046}, {name,  <<"花楹精灵">>},  {potential, 120, 120, 120, 120},  {per,  25, 25, 25, 25}]}]
            ,attr = []
        }
    };

get(621501) ->
    {ok, #item_base{
            id = 621501
            ,name = <<"小瓶魔法气息">>
            ,type = 62
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 20000}]
			,effect = [{exp,  2}]
            ,attr = []
        }
    };

get(621502) ->
    {ok, #item_base{
            id = 621502
            ,name = <<"中瓶魔法气息">>
            ,type = 62
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 40000}]
			,effect = [{exp,  4}]
            ,attr = []
        }
    };

get(621503) ->
    {ok, #item_base{
            id = 621503
            ,name = <<"大瓶魔法气息">>
            ,type = 62
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 60000}]
			,effect = [{exp,  8}]
            ,attr = []
        }
    };

get(641101) ->
    {ok, #item_base{
            id = 641101
            ,name = <<"小红帽召唤卡">>
            ,type = 64
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
			,effect = [{demon, 118012}]
            ,attr = []
        }
    };

get(641102) ->
    {ok, #item_base{
            id = 641102
            ,name = <<"美人鱼召唤卡">>
            ,type = 64
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
			,effect = [{demon, 118011}]
            ,attr = []
        }
    };

get(641103) ->
    {ok, #item_base{
            id = 641103
            ,name = <<"精灵王子召唤卡">>
            ,type = 64
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
			,effect = [{demon, 118010}]
            ,attr = []
        }
    };

get(641104) ->
    {ok, #item_base{
            id = 641104
            ,name = <<"雷神召唤卡">>
            ,type = 64
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
			,effect = [{demon, 118009}]
            ,attr = []
        }
    };

get(641105) ->
    {ok, #item_base{
            id = 641105
            ,name = <<"噩梦女巫召唤卡">>
            ,type = 64
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
			,effect = [{demon, 120007}]
            ,attr = []
        }
    };

get(641106) ->
    {ok, #item_base{
            id = 641106
            ,name = <<"南瓜怪召唤卡">>
            ,type = 64
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
			,effect = [{demon, 10207}]
            ,attr = []
        }
    };

get(641201) ->
    {ok, #item_base{
            id = 641201
            ,name = <<"妖精饼干">>
            ,type = 64
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
            ,condition = [#condition{label = lev, target_value = 1}]
			,effect = [{exp_npc, 1000}]
            ,attr = []
        }
    };

get(221001) ->
    {ok, #item_base{
            id = 221001
            ,name = <<"经验瓶">>
            ,type = 22
            ,quality = 2
            ,overlap = 99
            ,use_type = 1
			,effect = [{exp,  50000}]
            ,attr = []
        }
    };

get(221101) ->
    {ok, #item_base{
            id = 221101
            ,name = <<"金币包裹">>
            ,type = 22
            ,quality = 2
            ,overlap = 999
            ,use_type = 1
			,effect = [{coin,  1000}]
            ,attr = []
        }
    };

get(221102) ->
    {ok, #item_base{
            id = 221102
            ,name = <<"大金币包裹">>
            ,type = 22
            ,quality = 3
            ,overlap = 999
            ,use_type = 1
			,effect = [{coin,  10000}]
            ,attr = []
        }
    };

get(221103) ->
    {ok, #item_base{
            id = 221103
            ,name = <<"符石砂罐">>
            ,type = 22
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
			,effect = [{stone,  1000}]
            ,attr = []
        }
    };

get(221104) ->
    {ok, #item_base{
            id = 221104
            ,name = <<"晶钻卡">>
            ,type = 22
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
			,effect = [{gold,  10}]
            ,attr = []
        }
    };

get(221105) ->
    {ok, #item_base{
            id = 221105
            ,name = <<"技能点卡">>
            ,type = 22
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
			,effect = [{attainment,  1000}]
            ,attr = []
        }
    };

get(221106) ->
    {ok, #item_base{
            id = 221106
            ,name = <<"晶钻">>
            ,type = 22
            ,quality = 5
            ,overlap = 999
            ,use_type = 1
			,effect = [{gold,  1}]
            ,attr = []
        }
    };

get(101001) ->
    {ok, #item_base{
            id = 101001
            ,name = <<"训练大剑">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 138}, {?attr_critrate, 100, 13}, {?attr_hitrate, 100, 50}, {?attr_aspd, 100, 2}, {?attr_dmg_magic, 100, 69}]
        }
    };

get(101101) ->
    {ok, #item_base{
            id = 101101
            ,name = <<"训练护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 207}, {?attr_defence, 100, 103}, {?attr_evasion, 100, 16}, {?attr_rst_all, 100, 55}]
        }
    };

get(101201) ->
    {ok, #item_base{
            id = 101201
            ,name = <<"训练铠甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 276}, {?attr_defence, 100, 138}, {?attr_tenacity, 100, 55}, {?attr_rst_all, 100, 41}]
        }
    };

get(101301) ->
    {ok, #item_base{
            id = 101301
            ,name = <<"训练腿甲">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 276}, {?attr_defence, 100, 138}, {?attr_tenacity, 100, 41}, {?attr_rst_all, 100, 41}]
        }
    };

get(101401) ->
    {ok, #item_base{
            id = 101401
            ,name = <<"训练战靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 207}, {?attr_defence, 100, 103}, {?attr_tenacity, 100, 41}, {?attr_rst_all, 100, 41}]
        }
    };

get(101501) ->
    {ok, #item_base{
            id = 101501
            ,name = <<"训练腰带">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 207}, {?attr_defence, 100, 103}, {?attr_evasion, 100, 22}, {?attr_rst_all, 100, 41}]
        }
    };

get(101601) ->
    {ok, #item_base{
            id = 101601
            ,name = <<"训练护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_hp_max, 100, 207}, {?attr_defence, 100, 103}, {?attr_evasion, 100, 16}, {?attr_rst_all, 100, 55}]
        }
    };

get(101701) ->
    {ok, #item_base{
            id = 101701
            ,name = <<"训练骑士护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 69}, {?attr_critrate, 100, 41}, {?attr_aspd, 100, 1}, {?attr_dmg_magic, 100, 34}, {?attr_js, 100, 92}]
        }
    };

get(101801) ->
    {ok, #item_base{
            id = 101801
            ,name = <<"训练骑士戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 69}, {?attr_critrate, 100, 41}, {?attr_aspd, 100, 1}, {?attr_dmg_magic, 100, 34}, {?attr_js, 100, 92}]
        }
    };

get(101901) ->
    {ok, #item_base{
            id = 101901
            ,name = <<"训练骑士项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 5}]
            ,attr = [{?attr_dmg, 100, 69}, {?attr_critrate, 100, 41}, {?attr_aspd, 100, 1}, {?attr_dmg_magic, 100, 34}, {?attr_js, 100, 92}]
        }
    };

get(102001) ->
    {ok, #item_base{
            id = 102001
            ,name = <<"训练法杖">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 138}, {?attr_critrate, 100, 13}, {?attr_hitrate, 100, 50}, {?attr_aspd, 100, 2}, {?attr_dmg_magic, 100, 69}]
        }
    };

get(102101) ->
    {ok, #item_base{
            id = 102101
            ,name = <<"训练护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 207}, {?attr_defence, 100, 103}, {?attr_evasion, 100, 16}, {?attr_rst_all, 100, 55}]
        }
    };

get(102201) ->
    {ok, #item_base{
            id = 102201
            ,name = <<"训练法袍">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 276}, {?attr_defence, 100, 138}, {?attr_tenacity, 100, 55}, {?attr_rst_all, 100, 41}]
        }
    };

get(102301) ->
    {ok, #item_base{
            id = 102301
            ,name = <<"训练长裤">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 276}, {?attr_defence, 100, 138}, {?attr_tenacity, 100, 41}, {?attr_rst_all, 100, 41}]
        }
    };

get(102401) ->
    {ok, #item_base{
            id = 102401
            ,name = <<"训练法靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 207}, {?attr_defence, 100, 103}, {?attr_tenacity, 100, 41}, {?attr_rst_all, 100, 41}]
        }
    };

get(102501) ->
    {ok, #item_base{
            id = 102501
            ,name = <<"训练腰带">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 207}, {?attr_defence, 100, 103}, {?attr_evasion, 100, 22}, {?attr_rst_all, 100, 41}]
        }
    };

get(102601) ->
    {ok, #item_base{
            id = 102601
            ,name = <<"训练护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_hp_max, 100, 207}, {?attr_defence, 100, 103}, {?attr_evasion, 100, 16}, {?attr_rst_all, 100, 55}]
        }
    };

get(102701) ->
    {ok, #item_base{
            id = 102701
            ,name = <<"训练贤者护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 69}, {?attr_critrate, 100, 41}, {?attr_aspd, 100, 1}, {?attr_dmg_magic, 100, 34}, {?attr_js, 100, 92}]
        }
    };

get(102801) ->
    {ok, #item_base{
            id = 102801
            ,name = <<"训练贤者戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 69}, {?attr_critrate, 100, 41}, {?attr_aspd, 100, 1}, {?attr_dmg_magic, 100, 34}, {?attr_js, 100, 92}]
        }
    };

get(102901) ->
    {ok, #item_base{
            id = 102901
            ,name = <<"训练贤者项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 3}]
            ,attr = [{?attr_dmg, 100, 69}, {?attr_critrate, 100, 41}, {?attr_aspd, 100, 1}, {?attr_dmg_magic, 100, 34}, {?attr_js, 100, 92}]
        }
    };

get(103001) ->
    {ok, #item_base{
            id = 103001
            ,name = <<"训练匕首">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 138}, {?attr_critrate, 100, 13}, {?attr_hitrate, 100, 50}, {?attr_aspd, 100, 2}, {?attr_dmg_magic, 100, 69}]
        }
    };

get(103101) ->
    {ok, #item_base{
            id = 103101
            ,name = <<"训练护腕">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 207}, {?attr_defence, 100, 103}, {?attr_evasion, 100, 16}, {?attr_rst_all, 100, 55}]
        }
    };

get(103201) ->
    {ok, #item_base{
            id = 103201
            ,name = <<"训练披风">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 276}, {?attr_defence, 100, 138}, {?attr_tenacity, 100, 55}, {?attr_rst_all, 100, 41}]
        }
    };

get(103301) ->
    {ok, #item_base{
            id = 103301
            ,name = <<"训练衣摆">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 276}, {?attr_defence, 100, 138}, {?attr_tenacity, 100, 41}, {?attr_rst_all, 100, 41}]
        }
    };

get(103401) ->
    {ok, #item_base{
            id = 103401
            ,name = <<"训练长靴">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 207}, {?attr_defence, 100, 103}, {?attr_tenacity, 100, 41}, {?attr_rst_all, 100, 41}]
        }
    };

get(103501) ->
    {ok, #item_base{
            id = 103501
            ,name = <<"训练腰环">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 207}, {?attr_defence, 100, 103}, {?attr_evasion, 100, 22}, {?attr_rst_all, 100, 41}]
        }
    };

get(103601) ->
    {ok, #item_base{
            id = 103601
            ,name = <<"训练护手">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_hp_max, 100, 207}, {?attr_defence, 100, 103}, {?attr_evasion, 100, 16}, {?attr_rst_all, 100, 55}]
        }
    };

get(103701) ->
    {ok, #item_base{
            id = 103701
            ,name = <<"训练刺客护符">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 69}, {?attr_critrate, 100, 41}, {?attr_aspd, 100, 1}, {?attr_dmg_magic, 100, 34}, {?attr_js, 100, 92}]
        }
    };

get(103801) ->
    {ok, #item_base{
            id = 103801
            ,name = <<"训练刺客戒指">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 69}, {?attr_critrate, 100, 41}, {?attr_aspd, 100, 1}, {?attr_dmg_magic, 100, 34}, {?attr_js, 100, 92}]
        }
    };

get(103901) ->
    {ok, #item_base{
            id = 103901
            ,name = <<"训练刺客项链">>
            ,type = 10
            ,quality = 1
            ,overlap = 1
            ,use_type = 3
            ,condition = [#condition{label = lev, target_value = 1}, #condition{label = career, target_value = 2}]
            ,attr = [{?attr_dmg, 100, 69}, {?attr_critrate, 100, 41}, {?attr_aspd, 100, 1}, {?attr_dmg_magic, 100, 34}, {?attr_js, 100, 92}]
        }
    };

get(121001) ->
    {ok, #item_base{
            id = 121001
            ,name = <<"17强化护纹">>
            ,type = 12
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(121002) ->
    {ok, #item_base{
            id = 121002
            ,name = <<"18强化护纹">>
            ,type = 12
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(121003) ->
    {ok, #item_base{
            id = 121003
            ,name = <<"19强化护纹">>
            ,type = 12
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(121004) ->
    {ok, #item_base{
            id = 121004
            ,name = <<"20强化护纹">>
            ,type = 12
            ,quality = 5
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(201001) ->
    {ok, #item_base{
            id = 201001
            ,name = <<"体力药水">>
            ,type = 20
            ,quality = 3
            ,overlap = 99
            ,use_type = 1
            ,attr = []
        }
    };

get(111701) ->
    {ok, #item_base{
            id = 111701
            ,name = <<"4级宝石合成卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111702) ->
    {ok, #item_base{
            id = 111702
            ,name = <<"5级宝石合成卷轴">>
            ,type = 11
            ,quality = 3
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111703) ->
    {ok, #item_base{
            id = 111703
            ,name = <<"6级宝石合成卷轴">>
            ,type = 11
            ,quality = 4
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111704) ->
    {ok, #item_base{
            id = 111704
            ,name = <<"7级宝石合成卷轴">>
            ,type = 11
            ,quality = 4
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111705) ->
    {ok, #item_base{
            id = 111705
            ,name = <<"8级宝石合成卷轴">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(111706) ->
    {ok, #item_base{
            id = 111706
            ,name = <<"9级宝石合成卷轴">>
            ,type = 11
            ,quality = 5
            ,overlap = 99
            ,use_type = 0
            ,attr = []
        }
    };

get(131003) ->
    {ok, #item_base{
            id = 131003
            ,name = <<"《灵风一闪》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131004) ->
    {ok, #item_base{
            id = 131004
            ,name = <<"《极限冲杀》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131005) ->
    {ok, #item_base{
            id = 131005
            ,name = <<"《终结收割》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131006) ->
    {ok, #item_base{
            id = 131006
            ,name = <<"《死亡之缚》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131007) ->
    {ok, #item_base{
            id = 131007
            ,name = <<"《致盲穿刺》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131008) ->
    {ok, #item_base{
            id = 131008
            ,name = <<"《嗜血之刃》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131009) ->
    {ok, #item_base{
            id = 131009
            ,name = <<"《暴怒强化》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131010) ->
    {ok, #item_base{
            id = 131010
            ,name = <<"《精准强化》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131011) ->
    {ok, #item_base{
            id = 131011
            ,name = <<"《暗影毒雾》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131012) ->
    {ok, #item_base{
            id = 131012
            ,name = <<"《绝地反击》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131013) ->
    {ok, #item_base{
            id = 131013
            ,name = <<"《末日浩劫》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131014) ->
    {ok, #item_base{
            id = 131014
            ,name = <<"《混沌火球》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131015) ->
    {ok, #item_base{
            id = 131015
            ,name = <<"《连锁闪电》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131016) ->
    {ok, #item_base{
            id = 131016
            ,name = <<"《荆棘缠绕》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131017) ->
    {ok, #item_base{
            id = 131017
            ,name = <<"《安魂吟唱》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131018) ->
    {ok, #item_base{
            id = 131018
            ,name = <<"《虚弱诅咒》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131019) ->
    {ok, #item_base{
            id = 131019
            ,name = <<"《女神之光》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131020) ->
    {ok, #item_base{
            id = 131020
            ,name = <<"《智力强化》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131021) ->
    {ok, #item_base{
            id = 131021
            ,name = <<"《生命强化》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131022) ->
    {ok, #item_base{
            id = 131022
            ,name = <<"《神圣恩赐》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131023) ->
    {ok, #item_base{
            id = 131023
            ,name = <<"《奥术溅射》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131024) ->
    {ok, #item_base{
            id = 131024
            ,name = <<"《圣光守护》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131025) ->
    {ok, #item_base{
            id = 131025
            ,name = <<"《凌空下劈》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131026) ->
    {ok, #item_base{
            id = 131026
            ,name = <<"《巨刃击溃》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131027) ->
    {ok, #item_base{
            id = 131027
            ,name = <<"《愤怒咆哮》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131028) ->
    {ok, #item_base{
            id = 131028
            ,name = <<"《正义审判》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131029) ->
    {ok, #item_base{
            id = 131029
            ,name = <<"《大地震裂》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131030) ->
    {ok, #item_base{
            id = 131030
            ,name = <<"《光之屏障》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131031) ->
    {ok, #item_base{
            id = 131031
            ,name = <<"《防御强化》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131032) ->
    {ok, #item_base{
            id = 131032
            ,name = <<"《格挡强化》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131033) ->
    {ok, #item_base{
            id = 131033
            ,name = <<"《圣盾闪现》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131034) ->
    {ok, #item_base{
            id = 131034
            ,name = <<"《执念回击》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(131035) ->
    {ok, #item_base{
            id = 131035
            ,name = <<"《不灭意志》">>
            ,type = 13
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(601001) ->
    {ok, #item_base{
            id = 601001
            ,name = <<"背包拓展器">>
            ,type = 60
            ,quality = 1
            ,overlap = 99
            ,use_type = 1
            ,value = [{sell_npc, 500}]
            ,attr = []
        }
    };

get(631001) ->
    {ok, #item_base{
            id = 631001
            ,name = <<"VIP1体验卡">>
            ,type = 63
            ,quality = 2
            ,overlap = 1
            ,use_type = 1
			,effect = [{vip,  1}]
            ,attr = []
        }
    };

get(631002) ->
    {ok, #item_base{
            id = 631002
            ,name = <<"VIP2体验卡">>
            ,type = 63
            ,quality = 2
            ,overlap = 1
            ,use_type = 1
			,effect = [{vip,  2}]
            ,attr = []
        }
    };

get(631003) ->
    {ok, #item_base{
            id = 631003
            ,name = <<"VIP3体验卡">>
            ,type = 63
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
			,effect = [{vip,  3}]
            ,attr = []
        }
    };

get(631004) ->
    {ok, #item_base{
            id = 631004
            ,name = <<"VIP4体验卡">>
            ,type = 63
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
			,effect = [{vip,  4}]
            ,attr = []
        }
    };

get(631005) ->
    {ok, #item_base{
            id = 631005
            ,name = <<"VIP5体验卡">>
            ,type = 63
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
			,effect = [{vip,  5}]
            ,attr = []
        }
    };

get(631006) ->
    {ok, #item_base{
            id = 631006
            ,name = <<"VIP6体验卡">>
            ,type = 63
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
			,effect = [{vip,  6}]
            ,attr = []
        }
    };

get(631007) ->
    {ok, #item_base{
            id = 631007
            ,name = <<"VIP7体验卡">>
            ,type = 63
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
			,effect = [{vip,  7}]
            ,attr = []
        }
    };

get(631008) ->
    {ok, #item_base{
            id = 631008
            ,name = <<"VIP8体验卡">>
            ,type = 63
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
			,effect = [{vip,  8}]
            ,attr = []
        }
    };

get(631009) ->
    {ok, #item_base{
            id = 631009
            ,name = <<"VIP9体验卡">>
            ,type = 63
            ,quality = 6
            ,overlap = 1
            ,use_type = 1
			,effect = [{vip,  9}]
            ,attr = []
        }
    };

get(631011) ->
    {ok, #item_base{
            id = 631011
            ,name = <<"VIP10体验卡">>
            ,type = 63
            ,quality = 6
            ,overlap = 1
            ,use_type = 1
			,effect = [{vip,  10}]
            ,attr = []
        }
    };

get(631010) ->
    {ok, #item_base{
            id = 631010
            ,name = <<"充值月卡">>
            ,type = 63
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
			,effect = [{month_card, 1}]
            ,attr = []
        }
    };

get(641001) ->
    {ok, #item_base{
            id = 641001
            ,name = <<"灰烬恶魔碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641002) ->
    {ok, #item_base{
            id = 641002
            ,name = <<"牛头恶魔碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641003) ->
    {ok, #item_base{
            id = 641003
            ,name = <<"虚空树妖碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641004) ->
    {ok, #item_base{
            id = 641004
            ,name = <<"狂暴野猪碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641005) ->
    {ok, #item_base{
            id = 641005
            ,name = <<"咆哮棕熊碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641006) ->
    {ok, #item_base{
            id = 641006
            ,name = <<"南瓜怪碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641007) ->
    {ok, #item_base{
            id = 641007
            ,name = <<"蓝晶巨石怪碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641008) ->
    {ok, #item_base{
            id = 641008
            ,name = <<"洞穴蜥蜴碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641009) ->
    {ok, #item_base{
            id = 641009
            ,name = <<"树根蜥蜴碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641010) ->
    {ok, #item_base{
            id = 641010
            ,name = <<"沙漠蜥蜴碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641011) ->
    {ok, #item_base{
            id = 641011
            ,name = <<"骷髅法师碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641012) ->
    {ok, #item_base{
            id = 641012
            ,name = <<"黑暗树根怪碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641013) ->
    {ok, #item_base{
            id = 641013
            ,name = <<"诅咒树根怪碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641014) ->
    {ok, #item_base{
            id = 641014
            ,name = <<"混沌沙虫碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641015) ->
    {ok, #item_base{
            id = 641015
            ,name = <<"骷髅骑士碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641016) ->
    {ok, #item_base{
            id = 641016
            ,name = <<"救赎叶子精碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641017) ->
    {ok, #item_base{
            id = 641017
            ,name = <<"部落地精碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641018) ->
    {ok, #item_base{
            id = 641018
            ,name = <<"枷锁巨兔碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641019) ->
    {ok, #item_base{
            id = 641019
            ,name = <<"怒焰恶魔碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641020) ->
    {ok, #item_base{
            id = 641020
            ,name = <<"深渊沙虫碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641021) ->
    {ok, #item_base{
            id = 641021
            ,name = <<"鹿角巨兔碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641022) ->
    {ok, #item_base{
            id = 641022
            ,name = <<"狱火巨蝎碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641023) ->
    {ok, #item_base{
            id = 641023
            ,name = <<"远古骷髅碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641024) ->
    {ok, #item_base{
            id = 641024
            ,name = <<"幽暗树蛙碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641025) ->
    {ok, #item_base{
            id = 641025
            ,name = <<"野蛮小草碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641026) ->
    {ok, #item_base{
            id = 641026
            ,name = <<"剑士兔碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641027) ->
    {ok, #item_base{
            id = 641027
            ,name = <<"铠甲骑士马碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641028) ->
    {ok, #item_base{
            id = 641028
            ,name = <<"拳王碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641029) ->
    {ok, #item_base{
            id = 641029
            ,name = <<"荒野猎人碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641030) ->
    {ok, #item_base{
            id = 641030
            ,name = <<"巨翼灵兵碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641031) ->
    {ok, #item_base{
            id = 641031
            ,name = <<"史诗骑士碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641032) ->
    {ok, #item_base{
            id = 641032
            ,name = <<"花之精灵碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641033) ->
    {ok, #item_base{
            id = 641033
            ,name = <<"火之精灵碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641034) ->
    {ok, #item_base{
            id = 641034
            ,name = <<"石之精灵碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641035) ->
    {ok, #item_base{
            id = 641035
            ,name = <<"棕熊法师碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641036) ->
    {ok, #item_base{
            id = 641036
            ,name = <<"黄铜守卫碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641037) ->
    {ok, #item_base{
            id = 641037
            ,name = <<"绿革守卫碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641038) ->
    {ok, #item_base{
            id = 641038
            ,name = <<"银甲守卫碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641039) ->
    {ok, #item_base{
            id = 641039
            ,name = <<"永罚怨灵碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641040) ->
    {ok, #item_base{
            id = 641040
            ,name = <<"种子怪碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641041) ->
    {ok, #item_base{
            id = 641041
            ,name = <<"破晓女神碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641042) ->
    {ok, #item_base{
            id = 641042
            ,name = <<"霜雪牦牛碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641043) ->
    {ok, #item_base{
            id = 641043
            ,name = <<"半人马法师碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641044) ->
    {ok, #item_base{
            id = 641044
            ,name = <<"吞噬巨蜥碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641045) ->
    {ok, #item_base{
            id = 641045
            ,name = <<"恐惧魔王碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641046) ->
    {ok, #item_base{
            id = 641046
            ,name = <<"噩梦女巫碎片">>
            ,type = 64
            ,quality = 3
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641047) ->
    {ok, #item_base{
            id = 641047
            ,name = <<"遗落松鼠碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641048) ->
    {ok, #item_base{
            id = 641048
            ,name = <<"狂野水精碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641049) ->
    {ok, #item_base{
            id = 641049
            ,name = <<"燃草火精碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641050) ->
    {ok, #item_base{
            id = 641050
            ,name = <<"蒜头小兵碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641051) ->
    {ok, #item_base{
            id = 641051
            ,name = <<"森林兔子碎片">>
            ,type = 64
            ,quality = 2
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(641052) ->
    {ok, #item_base{
            id = 641052
            ,name = <<"幽惑花妖碎片">>
            ,type = 64
            ,quality = 1
            ,overlap = 999
            ,use_type = 0
            ,value = [{sell_npc, 10000}]
            ,attr = []
        }
    };

get(651001) ->
    {ok, #item_base{
            id = 651001
            ,name = <<"紫色伙伴装备">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651002) ->
    {ok, #item_base{
            id = 651002
            ,name = <<"蓝色伙伴装备">>
            ,type = 65
            ,quality = 2
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651003) ->
    {ok, #item_base{
            id = 651003
            ,name = <<"首饰卷轴">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651004) ->
    {ok, #item_base{
            id = 651004
            ,name = <<"首饰制作材料">>
            ,type = 65
            ,quality = 2
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651005) ->
    {ok, #item_base{
            id = 651005
            ,name = <<"装备精练材料">>
            ,type = 65
            ,quality = 6
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651006) ->
    {ok, #item_base{
            id = 651006
            ,name = <<"大量金币">>
            ,type = 65
            ,quality = 2
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651007) ->
    {ok, #item_base{
            id = 651007
            ,name = <<"海量金币">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651008) ->
    {ok, #item_base{
            id = 651008
            ,name = <<"奇怪的物品">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651009) ->
    {ok, #item_base{
            id = 651009
            ,name = <<"武器制作卷轴">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651010) ->
    {ok, #item_base{
            id = 651010
            ,name = <<"武器制作材料">>
            ,type = 65
            ,quality = 2
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651011) ->
    {ok, #item_base{
            id = 651011
            ,name = <<"幸运水晶">>
            ,type = 65
            ,quality = 5
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651012) ->
    {ok, #item_base{
            id = 651012
            ,name = <<"强化材料">>
            ,type = 65
            ,quality = 5
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651013) ->
    {ok, #item_base{
            id = 651013
            ,name = <<"大量经验">>
            ,type = 65
            ,quality = 2
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651101) ->
    {ok, #item_base{
            id = 651101
            ,name = <<"20级伙伴装备（体力）">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,attr = []
        }
    };

get(651102) ->
    {ok, #item_base{
            id = 651102
            ,name = <<"20级伙伴装备（力量）">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,attr = []
        }
    };

get(651103) ->
    {ok, #item_base{
            id = 651103
            ,name = <<"20级伙伴装备（灵巧）">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,attr = []
        }
    };

get(651104) ->
    {ok, #item_base{
            id = 651104
            ,name = <<"20级伙伴装备（坚毅）">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,attr = []
        }
    };

get(651105) ->
    {ok, #item_base{
            id = 651105
            ,name = <<"20级伙伴装备">>
            ,type = 65
            ,quality = 2
            ,overlap = 1
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 20}]
            ,attr = []
        }
    };

get(651106) ->
    {ok, #item_base{
            id = 651106
            ,name = <<"40级伙伴装备（体力）">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,attr = []
        }
    };

get(651107) ->
    {ok, #item_base{
            id = 651107
            ,name = <<"40级伙伴装备（力量）">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,attr = []
        }
    };

get(651108) ->
    {ok, #item_base{
            id = 651108
            ,name = <<"40级伙伴装备（灵巧）">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,attr = []
        }
    };

get(651109) ->
    {ok, #item_base{
            id = 651109
            ,name = <<"40级伙伴装备（坚毅）">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,attr = []
        }
    };

get(651110) ->
    {ok, #item_base{
            id = 651110
            ,name = <<"40级伙伴装备">>
            ,type = 65
            ,quality = 2
            ,overlap = 1
            ,use_type = 0
            ,condition = [#condition{label = lev, target_value = 40}]
            ,attr = []
        }
    };

get(651201) ->
    {ok, #item_base{
            id = 651201
            ,name = <<"金币">>
            ,type = 65
            ,quality = 2
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651202) ->
    {ok, #item_base{
            id = 651202
            ,name = <<"符石">>
            ,type = 65
            ,quality = 2
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651203) ->
    {ok, #item_base{
            id = 651203
            ,name = <<"绑定晶钻">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(651204) ->
    {ok, #item_base{
            id = 651204
            ,name = <<"经验">>
            ,type = 65
            ,quality = 3
            ,overlap = 1
            ,use_type = 0
            ,attr = []
        }
    };

get(532304) ->
    {ok, #item_base{
            id = 532304
            ,name = <<"VIP专属高级翅膀">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536000) ->
    {ok, #item_base{
            id = 536000
            ,name = <<"新手大礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536001) ->
    {ok, #item_base{
            id = 536001
            ,name = <<"删档大礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536002) ->
    {ok, #item_base{
            id = 536002
            ,name = <<"删档特权礼包">>
            ,type = 53
            ,quality = 4
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536003) ->
    {ok, #item_base{
            id = 536003
            ,name = <<"删档豪华礼包">>
            ,type = 53
            ,quality = 5
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536101) ->
    {ok, #item_base{
            id = 536101
            ,name = <<"PP新手礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536102) ->
    {ok, #item_base{
            id = 536102
            ,name = <<"91新手礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536103) ->
    {ok, #item_base{
            id = 536103
            ,name = <<"百度新手礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536104) ->
    {ok, #item_base{
            id = 536104
            ,name = <<"PP特权礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536105) ->
    {ok, #item_base{
            id = 536105
            ,name = <<"91特权礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536106) ->
    {ok, #item_base{
            id = 536106
            ,name = <<"百度特权礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536107) ->
    {ok, #item_base{
            id = 536107
            ,name = <<"九游特权礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536108) ->
    {ok, #item_base{
            id = 536108
            ,name = <<"当乐特权礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536109) ->
    {ok, #item_base{
            id = 536109
            ,name = <<"九游活动礼包一">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536110) ->
    {ok, #item_base{
            id = 536110
            ,name = <<"当乐活动礼包一">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536111) ->
    {ok, #item_base{
            id = 536111
            ,name = <<"九游活动礼包二">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536112) ->
    {ok, #item_base{
            id = 536112
            ,name = <<"当乐活动礼包二">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536113) ->
    {ok, #item_base{
            id = 536113
            ,name = <<"九游活动礼包三">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536114) ->
    {ok, #item_base{
            id = 536114
            ,name = <<"当乐活动礼包三">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536115) ->
    {ok, #item_base{
            id = 536115
            ,name = <<"九游活动礼包四">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536116) ->
    {ok, #item_base{
            id = 536116
            ,name = <<"当乐活动礼包四">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536117) ->
    {ok, #item_base{
            id = 536117
            ,name = <<"九游老用户召回礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(536118) ->
    {ok, #item_base{
            id = 536118
            ,name = <<"当乐老用户召回礼包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(531021) ->
    {ok, #item_base{
            id = 531021
            ,name = <<"花之精灵卡包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(531022) ->
    {ok, #item_base{
            id = 531022
            ,name = <<"破晓女神卡包">>
            ,type = 53
            ,quality = 3
            ,overlap = 1
            ,use_type = 1
            ,attr = []
        }
    };

get(_Id) ->
    {false, <<"不存在该物品">>}.
