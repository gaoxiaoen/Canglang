%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_designation
	%%% @Created : 2018-05-03 15:53:48
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_designation).
-export([get/1,id_list/0]).
-include("error_code.hrl").
-include("designation.hrl").
-include("common.hrl").

    id_list() ->
    [10001,10002,10003,10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,10014,10015,10016,10017,10018,10019,10020,10021,10022,10023,10024,10025,10026,10027,10028,10029,10030,10031,10032,10033,10034,10035,10036,10037,10038,10039,10040,10041,10042,10043,10044,10045,10046,10047,10048,10049,10050,10051,10052,10053,10054,10055,10056,10057,10058,10059,10060,10061,10062,10063,10064,10065,10066,10067,10068,10069,10070,10071,10072,10073,10074,10075,10076,10077,10078,10079,10080,10081,10082,10083,10084,10085,10086,10087,10088,10089,10090,10091,10092,10093,10094,10095,10096,10097,10098,10099,10100,10101,10102,10103,10104,10105,10106,10107,10108,10109,10110,10111,10112,10113,10114,10115,10116,10117,10118,10119,10120,10121,10122,10123,10124,10125,10126,10127,10128,10129,10130,10131,10132,10133,10134,10135,10136,10137,10138,10139,10140,10141,11100,11101,11102,11103,12000,12001,12100,12101,12102,12103,15100,16000,16001].
get(10001) -> 
   #base_designation{designation_id = 10001 ,name = ?T("有缘人") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10001 ,goods_id = 6604001 ,goods_num = 10 ,is_global = 0 }
;get(10002) -> 
   #base_designation{designation_id = 10002 ,name = ?T("一骑当千") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{ten,108}],time_bar = 0 ,image = 10002 ,goods_id = 6604002 ,goods_num = 10 ,is_global = 0 }
;get(10003) -> 
   #base_designation{designation_id = 10003 ,name = ?T("凤舞九天") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{hit,108},{dodge,108}],time_bar = 0 ,image = 10003 ,goods_id = 6604003 ,goods_num = 10 ,is_global = 0 }
;get(10004) -> 
   #base_designation{designation_id = 10004 ,name = ?T("唯法独尊") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{ten,108}],time_bar = 0 ,image = 10004 ,goods_id = 6604004 ,goods_num = 10 ,is_global = 0 }
;get(10005) -> 
   #base_designation{designation_id = 10005 ,name = ?T("兵临天下") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{hit,108},{dodge,108}],time_bar = 0 ,image = 10005 ,goods_id = 6604005 ,goods_num = 10 ,is_global = 0 }
;get(10006) -> 
   #base_designation{designation_id = 10006 ,name = ?T("王者归来") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{ten,108}],time_bar = 86400 ,image = 10006 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10007) -> 
   #base_designation{designation_id = 10007 ,name = ?T("状元") ,type = 4 ,attrs = [{att,500},{def,250},{hp_lim,5000},{crit,90},{ten,80}],time_bar = 86400 ,image = 10007 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10008) -> 
   #base_designation{designation_id = 10008 ,name = ?T("榜眼") ,type = 4 ,attrs = [{att,300},{def,150},{hp_lim,3000},{hit,65},{dodge,55}],time_bar = 86400 ,image = 10008 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10009) -> 
   #base_designation{designation_id = 10009 ,name = ?T("探花") ,type = 4 ,attrs = [{att,200},{def,100},{hp_lim,2000},{crit,40},{ten,30}],time_bar = 86400 ,image = 10009 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10010) -> 
   #base_designation{designation_id = 10010 ,name = ?T("武动神州") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{ten,108}],time_bar = 86400 ,image = 10010 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10011) -> 
   #base_designation{designation_id = 10011 ,name = ?T("天下无敌") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{hit,108},{dodge,108}],time_bar = 86400 ,image = 10011 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10012) -> 
   #base_designation{designation_id = 10012 ,name = ?T("唯我独尊") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{ten,108}],time_bar = 86400 ,image = 10012 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10013) -> 
   #base_designation{designation_id = 10013 ,name = ?T("灵气逼人") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{ten,108}],time_bar = 0 ,image = 10013 ,goods_id = 6604015 ,goods_num = 10 ,is_global = 0 }
;get(10014) -> 
   #base_designation{designation_id = 10014 ,name = ?T("武林争霸") ,type = 4 ,attrs = [{att,840},{def,420},{hp_lim,8400},{crit,168},{ten,168}],time_bar = 0 ,image = 10014 ,goods_id = 6604016 ,goods_num = 10 ,is_global = 0 }
;get(10015) -> 
   #base_designation{designation_id = 10015 ,name = ?T("朱门绣户") ,type = 4 ,attrs = [{att,1500},{def,750},{hp_lim,15000}],time_bar = 0 ,image = 10015 ,goods_id = 6604007 ,goods_num = 10 ,is_global = 0 }
;get(10016) -> 
   #base_designation{designation_id = 10016 ,name = ?T("一掷千金") ,type = 4 ,attrs = [{att,1750},{def,875},{hp_lim,17500},{crit,350},{ten,350}],time_bar = 0 ,image = 10016 ,goods_id = 6604008 ,goods_num = 10 ,is_global = 0 }
;get(10017) -> 
   #base_designation{designation_id = 10017 ,name = ?T("崭露头角") ,type = 1 ,attrs = [{att,120},{def,60},{hp_lim,1200},{crit,24},{ten,24}],time_bar = 0 ,image = 10017 ,goods_id = 6604017 ,goods_num = 10 ,is_global = 0 }
;get(10018) -> 
   #base_designation{designation_id = 10018 ,name = ?T("剑破苍穹") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{ten,108}],time_bar = 172800 ,image = 10018 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10019) -> 
   #base_designation{designation_id = 10019 ,name = ?T("君临四海") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{hit,108},{dodge,108}],time_bar = 172800 ,image = 10019 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10020) -> 
   #base_designation{designation_id = 10020 ,name = ?T("威震八方") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{ten,108}],time_bar = 172800 ,image = 10020 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10021) -> 
   #base_designation{designation_id = 10021 ,name = ?T("初入江湖") ,type = 2 ,attrs = [{att,220},{def,130},{hp_lim,1840}],time_bar = 0 ,image = 10021 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10022) -> 
   #base_designation{designation_id = 10022 ,name = ?T("牛刀小试") ,type = 2 ,attrs = [{att,240},{def,140},{hp_lim,2020}],time_bar = 0 ,image = 10022 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10023) -> 
   #base_designation{designation_id = 10023 ,name = ?T("初露峥嵘") ,type = 2 ,attrs = [{att,260},{def,150},{hp_lim,2220}],time_bar = 0 ,image = 10023 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10024) -> 
   #base_designation{designation_id = 10024 ,name = ?T("锋芒毕露") ,type = 2 ,attrs = [{att,280},{def,160},{hp_lim,2440}],time_bar = 0 ,image = 10024 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10025) -> 
   #base_designation{designation_id = 10025 ,name = ?T("豪气干云") ,type = 2 ,attrs = [{att,300},{def,170},{hp_lim,2680}],time_bar = 0 ,image = 10025 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10026) -> 
   #base_designation{designation_id = 10026 ,name = ?T("勇者无惧") ,type = 2 ,attrs = [{att,330},{def,180},{hp_lim,2940}],time_bar = 0 ,image = 10026 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10027) -> 
   #base_designation{designation_id = 10027 ,name = ?T("谁与争锋") ,type = 2 ,attrs = [{att,360},{def,190},{hp_lim,3230}],time_bar = 0 ,image = 10027 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10028) -> 
   #base_designation{designation_id = 10028 ,name = ?T("一流高手") ,type = 2 ,attrs = [{att,390},{def,200},{hp_lim,3550}],time_bar = 0 ,image = 10028 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10029) -> 
   #base_designation{designation_id = 10029 ,name = ?T("独霸一方") ,type = 2 ,attrs = [{att,420},{def,220},{hp_lim,3900}],time_bar = 0 ,image = 10029 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10030) -> 
   #base_designation{designation_id = 10030 ,name = ?T("声名显赫") ,type = 2 ,attrs = [{att,460},{def,240},{hp_lim,4280}],time_bar = 0 ,image = 10030 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10031) -> 
   #base_designation{designation_id = 10031 ,name = ?T("江湖闻名") ,type = 2 ,attrs = [{att,500},{def,260},{hp_lim,4700}],time_bar = 0 ,image = 10031 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10032) -> 
   #base_designation{designation_id = 10032 ,name = ?T("名震八方") ,type = 2 ,attrs = [{att,540},{def,280},{hp_lim,5160}],time_bar = 0 ,image = 10032 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10033) -> 
   #base_designation{designation_id = 10033 ,name = ?T("问鼎江湖") ,type = 2 ,attrs = [{att,590},{def,300},{hp_lim,5670}],time_bar = 0 ,image = 10033 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10034) -> 
   #base_designation{designation_id = 10034 ,name = ?T("独孤求败") ,type = 2 ,attrs = [{att,640},{def,330},{hp_lim,6230}],time_bar = 0 ,image = 10034 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10035) -> 
   #base_designation{designation_id = 10035 ,name = ?T("傲视群雄") ,type = 2 ,attrs = [{att,700},{def,360},{hp_lim,6850}],time_bar = 0 ,image = 10035 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10036) -> 
   #base_designation{designation_id = 10036 ,name = ?T("武林至尊") ,type = 2 ,attrs = [{att,760},{def,390},{hp_lim,7530}],time_bar = 0 ,image = 10036 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10037) -> 
   #base_designation{designation_id = 10037 ,name = ?T("只手遮天") ,type = 2 ,attrs = [{att,830},{def,420},{hp_lim,8280}],time_bar = 0 ,image = 10037 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10038) -> 
   #base_designation{designation_id = 10038 ,name = ?T("独掌乾坤") ,type = 2 ,attrs = [{att,910},{def,460},{hp_lim,9100}],time_bar = 0 ,image = 10038 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10039) -> 
   #base_designation{designation_id = 10039 ,name = ?T("绝世武尊") ,type = 2 ,attrs = [{att,1000},{def,500},{hp_lim,10000}],time_bar = 0 ,image = 10039 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10040) -> 
   #base_designation{designation_id = 10040 ,name = ?T("气宇轩昂") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10040 ,goods_id = 6604040 ,goods_num = 10 ,is_global = 0 }
;get(10041) -> 
   #base_designation{designation_id = 10041 ,name = ?T("倾世花颜") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10041 ,goods_id = 6604041 ,goods_num = 10 ,is_global = 0 }
;get(10042) -> 
   #base_designation{designation_id = 10042 ,name = ?T("御剑江湖") ,type = 1 ,attrs = [{att,200},{def,100},{hp_lim,2000},{crit,40},{ten,30}],time_bar = 0 ,image = 10042 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10043) -> 
   #base_designation{designation_id = 10043 ,name = ?T("冰凉一夏") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10043 ,goods_id = 6604043 ,goods_num = 10 ,is_global = 0 }
;get(10044) -> 
   #base_designation{designation_id = 10044 ,name = ?T("恋香惜玉") ,type = 1 ,attrs = [{att,480},{def,240},{hp_lim,4800},{crit,96},{ten,96}],time_bar = 0 ,image = 10044 ,goods_id = 6604044 ,goods_num = 10 ,is_global = 0 }
;get(10045) -> 
   #base_designation{designation_id = 10045 ,name = ?T("无恶不作") ,type = 3 ,attrs = [{att,540},{def,270},{hp_lim,5400}],time_bar = 0 ,image = 10045 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10046) -> 
   #base_designation{designation_id = 10046 ,name = ?T("富甲一方") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10046 ,goods_id = 6604046 ,goods_num = 10 ,is_global = 0 }
;get(10047) -> 
   #base_designation{designation_id = 10047 ,name = ?T("腾云驾雾") ,type = 1 ,attrs = [{att,541},{def,271},{hp_lim,5400},{hit,108},{dodge,108}],time_bar = 0 ,image = 10047 ,goods_id = 6604047 ,goods_num = 10 ,is_global = 0 }
;get(10048) -> 
   #base_designation{designation_id = 10048 ,name = ?T("除魔卫道") ,type = 3 ,attrs = [{att,540},{def,270},{hp_lim,5400}],time_bar = 0 ,image = 10048 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10049) -> 
   #base_designation{designation_id = 10049 ,name = ?T("喵星人") ,type = 1 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{hit,108}],time_bar = 0 ,image = 10049 ,goods_id = 6604049 ,goods_num = 10 ,is_global = 0 }
;get(10050) -> 
   #base_designation{designation_id = 10050 ,name = ?T("缘定三生") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10050 ,goods_id = 6604050 ,goods_num = 10 ,is_global = 0 }
;get(10051) -> 
   #base_designation{designation_id = 10051 ,name = ?T("天作之合") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10051 ,goods_id = 6604051 ,goods_num = 10 ,is_global = 0 }
;get(10052) -> 
   #base_designation{designation_id = 10052 ,name = ?T("山无棱天地合") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10052 ,goods_id = 6604052 ,goods_num = 10 ,is_global = 0 }
;get(10053) -> 
   #base_designation{designation_id = 10053 ,name = ?T("神仙眷侣") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10053 ,goods_id = 6604053 ,goods_num = 10 ,is_global = 0 }
;get(10054) -> 
   #base_designation{designation_id = 10054 ,name = ?T("心心相印") ,type = 3 ,attrs = [{att,161},{def,81},{hp_lim,1600},{crit,33},{ten,33}],time_bar = 0 ,image = 10054 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10055) -> 
   #base_designation{designation_id = 10055 ,name = ?T("姻缘·心有灵犀") ,type = 3 ,attrs = [{att,322},{def,162},{hp_lim,3200},{hit,66},{dodge,66}],time_bar = 0 ,image = 10055 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10056) -> 
   #base_designation{designation_id = 10056 ,name = ?T("相濡以沫") ,type = 3 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{ten,108}],time_bar = 0 ,image = 10056 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10057) -> 
   #base_designation{designation_id = 10057 ,name = ?T("姻缘·至死不渝") ,type = 3 ,attrs = [{att,810},{def,405},{hp_lim,8100},{hit,163},{dodge,162}],time_bar = 0 ,image = 10057 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10058) -> 
   #base_designation{designation_id = 10058 ,name = ?T("情深意种") ,type = 3 ,attrs = [{att,1082},{def,542},{hp_lim,10800},{crit,216},{ten,216}],time_bar = 0 ,image = 10058 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10059) -> 
   #base_designation{designation_id = 10059 ,name = ?T("姻缘·情满花开") ,type = 3 ,attrs = [{att,1620},{def,810},{hp_lim,16200},{hit,325},{dodge,325}],time_bar = 0 ,image = 10059 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10060) -> 
   #base_designation{designation_id = 10060 ,name = ?T("比翼双飞") ,type = 3 ,attrs = [{att,2432},{def,1216},{hp_lim,24300},{crit,487},{ten,487}],time_bar = 0 ,image = 10060 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10061) -> 
   #base_designation{designation_id = 10061 ,name = ?T("海枯石烂") ,type = 3 ,attrs = [{att,3240},{def,1620},{hp_lim,32400},{hit,650},{dodge,650}],time_bar = 0 ,image = 10061 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10062) -> 
   #base_designation{designation_id = 10062 ,name = ?T("姻缘·天长地久") ,type = 3 ,attrs = [{att,4328},{def,2157},{hp_lim,43280},{crit,865},{ten,864}],time_bar = 0 ,image = 10062 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10063) -> 
   #base_designation{designation_id = 10063 ,name = ?T("法天象地") ,type = 1 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{hit,108}],time_bar = 0 ,image = 10063 ,goods_id = 6604063 ,goods_num = 10 ,is_global = 0 }
;get(10064) -> 
   #base_designation{designation_id = 10064 ,name = ?T("一城之主") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{hit,108},{dodge,108}],time_bar = 604800 ,image = 10064 ,goods_id = 0 ,goods_num = 0 ,is_global = 1 }
;get(10065) -> 
   #base_designation{designation_id = 10065 ,name = ?T("莫忘初心") ,type = 3 ,attrs = [{att,220},{def,130},{hp_lim,1840}],time_bar = 0 ,image = 10065 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10066) -> 
   #base_designation{designation_id = 10066 ,name = ?T("新手指导员") ,type = 3 ,attrs = [{att,220},{def,130},{hp_lim,1840}],time_bar = 604800 ,image = 10066 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10067) -> 
   #base_designation{designation_id = 10067 ,name = ?T("雏鹰展翅") ,type = 1 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{hit,108}],time_bar = 0 ,image = 10067 ,goods_id = 6604067 ,goods_num = 10 ,is_global = 0 }
;get(10068) -> 
   #base_designation{designation_id = 10068 ,name = ?T("砸蛋狂人") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10068 ,goods_id = 6604068 ,goods_num = 10 ,is_global = 0 }
;get(10069) -> 
   #base_designation{designation_id = 10069 ,name = ?T("我爱月饼") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10071 ,goods_id = 6604069 ,goods_num = 10 ,is_global = 0 }
;get(10070) -> 
   #base_designation{designation_id = 10070 ,name = ?T("长假嗨翻天") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10072 ,goods_id = 6604070 ,goods_num = 10 ,is_global = 0 }
;get(10071) -> 
   #base_designation{designation_id = 10071 ,name = ?T("国泰民安") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10069 ,goods_id = 6604071 ,goods_num = 10 ,is_global = 0 }
;get(10072) -> 
   #base_designation{designation_id = 10072 ,name = ?T("明月寄相思") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10070 ,goods_id = 6604072 ,goods_num = 10 ,is_global = 0 }
;get(10073) -> 
   #base_designation{designation_id = 10073 ,name = ?T("盘古开天") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10073 ,goods_id = 6604073 ,goods_num = 10 ,is_global = 0 }
;get(10074) -> 
   #base_designation{designation_id = 10074 ,name = ?T("夺魄勾魂") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10074 ,goods_id = 6604074 ,goods_num = 10 ,is_global = 0 }
;get(10075) -> 
   #base_designation{designation_id = 10075 ,name = ?T("铁笔银钩") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10075 ,goods_id = 6604075 ,goods_num = 10 ,is_global = 0 }
;get(10076) -> 
   #base_designation{designation_id = 10076 ,name = ?T("天下无狗") ,type = 3 ,attrs = [],time_bar = 0 ,image = 10076 ,goods_id = 6604076 ,goods_num = 10 ,is_global = 0 }
;get(10077) -> 
   #base_designation{designation_id = 10077 ,name = ?T("傲寒六诀") ,type = 2 ,attrs = [],time_bar = 0 ,image = 10077 ,goods_id = 6604077 ,goods_num = 10 ,is_global = 0 }
;get(10078) -> 
   #base_designation{designation_id = 10078 ,name = ?T("南瓜骑士") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10078 ,goods_id = 6604078 ,goods_num = 10 ,is_global = 0 }
;get(10079) -> 
   #base_designation{designation_id = 10079 ,name = ?T("至死不渝的爱") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10079 ,goods_id = 6604079 ,goods_num = 10 ,is_global = 0 }
;get(10080) -> 
   #base_designation{designation_id = 10080 ,name = ?T("万圣夜惊魂") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10080 ,goods_id = 6604080 ,goods_num = 10 ,is_global = 0 }
;get(10081) -> 
   #base_designation{designation_id = 10081 ,name = ?T("不给糖就导弹") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10081 ,goods_id = 6604081 ,goods_num = 10 ,is_global = 0 }
;get(10082) -> 
   #base_designation{designation_id = 10082 ,name = ?T("乱斗王者") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{ten,108}],time_bar = 604800 ,image = 10082 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10083) -> 
   #base_designation{designation_id = 10083 ,name = ?T("草莓先生") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10083 ,goods_id = 6604083 ,goods_num = 10 ,is_global = 0 }
;get(10084) -> 
   #base_designation{designation_id = 10084 ,name = ?T("璀璨王者") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10084 ,goods_id = 6604084 ,goods_num = 10 ,is_global = 0 }
;get(10085) -> 
   #base_designation{designation_id = 10085 ,name = ?T("电音小子") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10085 ,goods_id = 6604085 ,goods_num = 10 ,is_global = 0 }
;get(10086) -> 
   #base_designation{designation_id = 10086 ,name = ?T("哥是高富帅") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10086 ,goods_id = 6604086 ,goods_num = 10 ,is_global = 0 }
;get(10087) -> 
   #base_designation{designation_id = 10087 ,name = ?T("雷迪嘎嘎") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10087 ,goods_id = 6604087 ,goods_num = 10 ,is_global = 0 }
;get(10088) -> 
   #base_designation{designation_id = 10088 ,name = ?T("皮皮虾我们上") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10088 ,goods_id = 6604088 ,goods_num = 10 ,is_global = 0 }
;get(10089) -> 
   #base_designation{designation_id = 10089 ,name = ?T("骰子摇摇乐") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10089 ,goods_id = 6604089 ,goods_num = 10 ,is_global = 0 }
;get(10090) -> 
   #base_designation{designation_id = 10090 ,name = ?T("无双情圣") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10090 ,goods_id = 6604090 ,goods_num = 10 ,is_global = 0 }
;get(10091) -> 
   #base_designation{designation_id = 10091 ,name = ?T("牛X金钻贵族") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10091 ,goods_id = 6604091 ,goods_num = 10 ,is_global = 0 }
;get(10092) -> 
   #base_designation{designation_id = 10092 ,name = ?T("大吉大利") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10092 ,goods_id = 6604092 ,goods_num = 10 ,is_global = 0 }
;get(10093) -> 
   #base_designation{designation_id = 10093 ,name = ?T("今晚吃鸡") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10093 ,goods_id = 6604093 ,goods_num = 10 ,is_global = 0 }
;get(10094) -> 
   #base_designation{designation_id = 10094 ,name = ?T("感恩的心") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10094 ,goods_id = 6604094 ,goods_num = 10 ,is_global = 0 }
;get(10095) -> 
   #base_designation{designation_id = 10095 ,name = ?T("千手观音") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10095 ,goods_id = 6604095 ,goods_num = 10 ,is_global = 0 }
;get(10096) -> 
   #base_designation{designation_id = 10096 ,name = ?T("家财万贯") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10096 ,goods_id = 6604096 ,goods_num = 10 ,is_global = 0 }
;get(10097) -> 
   #base_designation{designation_id = 10097 ,name = ?T("狂欢圣典") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10097 ,goods_id = 6604097 ,goods_num = 10 ,is_global = 0 }
;get(10098) -> 
   #base_designation{designation_id = 10098 ,name = ?T("宝石达人") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10098 ,goods_id = 6604098 ,goods_num = 10 ,is_global = 0 }
;get(10099) -> 
   #base_designation{designation_id = 10099 ,name = ?T("圣诞快乐") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10099 ,goods_id = 6604099 ,goods_num = 10 ,is_global = 0 }
;get(10100) -> 
   #base_designation{designation_id = 10100 ,name = ?T("古德奈特") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10100 ,goods_id = 6604100 ,goods_num = 10 ,is_global = 0 }
;get(10101) -> 
   #base_designation{designation_id = 10101 ,name = ?T("小鹿乱撞") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10101 ,goods_id = 6604101 ,goods_num = 10 ,is_global = 0 }
;get(10102) -> 
   #base_designation{designation_id = 10102 ,name = ?T("重返荣耀") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10102 ,goods_id = 6604102 ,goods_num = 10 ,is_global = 0 }
;get(10103) -> 
   #base_designation{designation_id = 10103 ,name = ?T("武林盟主") ,type = 4 ,attrs = [{att,840},{def,420},{hp_lim,8400},{crit,168},{ten,168}],time_bar = 0 ,image = 10103 ,goods_id = 6604103 ,goods_num = 10 ,is_global = 0 }
;get(10104) -> 
   #base_designation{designation_id = 10104 ,name = ?T("雪冬小大寒") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10104 ,goods_id = 6604104 ,goods_num = 10 ,is_global = 0 }
;get(10105) -> 
   #base_designation{designation_id = 10105 ,name = ?T("天狐降世") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10105 ,goods_id = 6604105 ,goods_num = 10 ,is_global = 0 }
;get(10106) -> 
   #base_designation{designation_id = 10106 ,name = ?T("月转星回") ,type = 1 ,attrs = [],time_bar = 0 ,image = 10106 ,goods_id = 6604106 ,goods_num = 10 ,is_global = 0 }
;get(10107) -> 
   #base_designation{designation_id = 10107 ,name = ?T("2018纪念称号") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10107 ,goods_id = 6604107 ,goods_num = 10 ,is_global = 0 }
;get(10108) -> 
   #base_designation{designation_id = 10108 ,name = ?T("笑傲江湖") ,type = 4 ,attrs = [{att,541},{def,271},{hp_lim,5400},{crit,108},{ten,108}],time_bar = 604800 ,image = 10108 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(10109) -> 
   #base_designation{designation_id = 10109 ,name = ?T("新春大吉") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10109 ,goods_id = 6604108 ,goods_num = 10 ,is_global = 0 }
;get(10110) -> 
   #base_designation{designation_id = 10110 ,name = ?T("大顺大财大吉利") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10110 ,goods_id = 6604109 ,goods_num = 10 ,is_global = 0 }
;get(10111) -> 
   #base_designation{designation_id = 10111 ,name = ?T("2018贺新春") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10111 ,goods_id = 6604110 ,goods_num = 10 ,is_global = 0 }
;get(10112) -> 
   #base_designation{designation_id = 10112 ,name = ?T("魅力无双") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10112 ,goods_id = 6604111 ,goods_num = 10 ,is_global = 0 }
;get(10113) -> 
   #base_designation{designation_id = 10113 ,name = ?T("国色天香") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10113 ,goods_id = 6604112 ,goods_num = 10 ,is_global = 0 }
;get(10114) -> 
   #base_designation{designation_id = 10114 ,name = ?T("花容月貌") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10114 ,goods_id = 6604113 ,goods_num = 10 ,is_global = 0 }
;get(10115) -> 
   #base_designation{designation_id = 10115 ,name = ?T("盖世无双") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10115 ,goods_id = 6604114 ,goods_num = 10 ,is_global = 0 }
;get(10116) -> 
   #base_designation{designation_id = 10116 ,name = ?T("气宇轩昂") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10116 ,goods_id = 6604115 ,goods_num = 10 ,is_global = 0 }
;get(10117) -> 
   #base_designation{designation_id = 10117 ,name = ?T("玉树临风") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10117 ,goods_id = 6604116 ,goods_num = 10 ,is_global = 0 }
;get(10118) -> 
   #base_designation{designation_id = 10118 ,name = ?T("灵机百变") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10118 ,goods_id = 6604117 ,goods_num = 10 ,is_global = 0 }
;get(10119) -> 
   #base_designation{designation_id = 10119 ,name = ?T("喵喵咪呀") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10119 ,goods_id = 6604118 ,goods_num = 10 ,is_global = 0 }
;get(10120) -> 
   #base_designation{designation_id = 10120 ,name = ?T("融爱于心") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10120 ,goods_id = 6604119 ,goods_num = 10 ,is_global = 0 }
;get(10121) -> 
   #base_designation{designation_id = 10121 ,name = ?T("热恋之吻") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10121 ,goods_id = 6604120 ,goods_num = 10 ,is_global = 0 }
;get(10122) -> 
   #base_designation{designation_id = 10122 ,name = ?T("吃瓜群众") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10122 ,goods_id = 6604122 ,goods_num = 10 ,is_global = 0 }
;get(10123) -> 
   #base_designation{designation_id = 10123 ,name = ?T("星心相印") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10123 ,goods_id = 6604123 ,goods_num = 10 ,is_global = 0 }
;get(10124) -> 
   #base_designation{designation_id = 10124 ,name = ?T("团团圆圆") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10124 ,goods_id = 6604124 ,goods_num = 10 ,is_global = 0 }
;get(10125) -> 
   #base_designation{designation_id = 10125 ,name = ?T("醋意盎然") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10125 ,goods_id = 6604125 ,goods_num = 10 ,is_global = 0 }
;get(10126) -> 
   #base_designation{designation_id = 10126 ,name = ?T("春暖花开") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10126 ,goods_id = 6604126 ,goods_num = 10 ,is_global = 0 }
;get(10127) -> 
   #base_designation{designation_id = 10127 ,name = ?T("鸭飞蛋打") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10127 ,goods_id = 6604127 ,goods_num = 10 ,is_global = 0 }
;get(10128) -> 
   #base_designation{designation_id = 10128 ,name = ?T("不明觉厉") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10128 ,goods_id = 6604128 ,goods_num = 10 ,is_global = 0 }
;get(10129) -> 
   #base_designation{designation_id = 10129 ,name = ?T("不想说话") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10129 ,goods_id = 6604129 ,goods_num = 10 ,is_global = 0 }
;get(10130) -> 
   #base_designation{designation_id = 10130 ,name = ?T("眼冒金星") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10130 ,goods_id = 6604130 ,goods_num = 10 ,is_global = 0 }
;get(10131) -> 
   #base_designation{designation_id = 10131 ,name = ?T("滴滴老司机") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10131 ,goods_id = 6604131 ,goods_num = 10 ,is_global = 0 }
;get(10132) -> 
   #base_designation{designation_id = 10132 ,name = ?T("呱行天下") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10132 ,goods_id = 6604132 ,goods_num = 10 ,is_global = 0 }
;get(10133) -> 
   #base_designation{designation_id = 10133 ,name = ?T("缺钱请报卡号") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10133 ,goods_id = 6604133 ,goods_num = 10 ,is_global = 0 }
;get(10134) -> 
   #base_designation{designation_id = 10134 ,name = ?T("啦啦啦啦") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10134 ,goods_id = 6604134 ,goods_num = 10 ,is_global = 0 }
;get(10135) -> 
   #base_designation{designation_id = 10135 ,name = ?T("奖励小红花") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10135 ,goods_id = 6604135 ,goods_num = 10 ,is_global = 0 }
;get(10136) -> 
   #base_designation{designation_id = 10136 ,name = ?T("民间高手") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10136 ,goods_id = 6604136 ,goods_num = 10 ,is_global = 0 }
;get(10137) -> 
   #base_designation{designation_id = 10137 ,name = ?T("甜蜜之恋") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10137 ,goods_id = 6604137 ,goods_num = 10 ,is_global = 0 }
;get(10138) -> 
   #base_designation{designation_id = 10138 ,name = ?T("最美公主") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10138 ,goods_id = 6604138 ,goods_num = 10 ,is_global = 0 }
;get(10139) -> 
   #base_designation{designation_id = 10139 ,name = ?T("最帅王子") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10139 ,goods_id = 6604139 ,goods_num = 10 ,is_global = 0 }
;get(10140) -> 
   #base_designation{designation_id = 10140 ,name = ?T("劳动真快乐") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10140 ,goods_id = 6604140 ,goods_num = 10 ,is_global = 0 }
;get(10141) -> 
   #base_designation{designation_id = 10141 ,name = ?T("恋恋花雨") ,type = 5 ,attrs = [],time_bar = 0 ,image = 10141 ,goods_id = 6604141 ,goods_num = 10 ,is_global = 0 }
;get(11100) -> 
   #base_designation{designation_id = 11100 ,name = ?T("严永远爱雨荷") ,type = 6 ,attrs = [],time_bar = 0 ,image = 11100 ,goods_id = 6622100 ,goods_num = 10 ,is_global = 0 }
;get(11101) -> 
   #base_designation{designation_id = 11101 ,name = ?T("龙心相悦") ,type = 6 ,attrs = [],time_bar = 0 ,image = 11101 ,goods_id = 6622101 ,goods_num = 10 ,is_global = 0 }
;get(11102) -> 
   #base_designation{designation_id = 11102 ,name = ?T("雨荷一生一世") ,type = 6 ,attrs = [],time_bar = 0 ,image = 11102 ,goods_id = 6622102 ,goods_num = 10 ,is_global = 0 }
;get(11103) -> 
   #base_designation{designation_id = 11103 ,name = ?T("琳山比翼双飞") ,type = 6 ,attrs = [],time_bar = 0 ,image = 11103 ,goods_id = 6622103 ,goods_num = 10 ,is_global = 0 }
;get(12000) -> 
   #base_designation{designation_id = 12000 ,name = ?T("万人迷") ,type = 6 ,attrs = [],time_bar = 0 ,image = 12000 ,goods_id = 6622300 ,goods_num = 10 ,is_global = 0 }
;get(12001) -> 
   #base_designation{designation_id = 12001 ,name = ?T("瞇之音") ,type = 6 ,attrs = [],time_bar = 0 ,image = 12001 ,goods_id = 6622301 ,goods_num = 10 ,is_global = 0 }
;get(12100) -> 
   #base_designation{designation_id = 12100 ,name = ?T("逆天境界") ,type = 6 ,attrs = [],time_bar = 0 ,image = 12100 ,goods_id = 6622400 ,goods_num = 10 ,is_global = 0 }
;get(12101) -> 
   #base_designation{designation_id = 12101 ,name = ?T("《目童》") ,type = 6 ,attrs = [],time_bar = 0 ,image = 12101 ,goods_id = 6622401 ,goods_num = 10 ,is_global = 0 }
;get(12102) -> 
   #base_designation{designation_id = 12102 ,name = ?T("充值1元得高vip") ,type = 3 ,attrs = [{att,540},{def,270},{hp_lim,5400}],time_bar = 0 ,image = 12102 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(12103) -> 
   #base_designation{designation_id = 12103 ,name = ?T("59级就结婚") ,type = 3 ,attrs = [{att,540},{def,270},{hp_lim,5400}],time_bar = 0 ,image = 12103 ,goods_id = 0 ,goods_num = 0 ,is_global = 0 }
;get(15100) -> 
   #base_designation{designation_id = 15100 ,name = ?T("狂拽酷炫吊") ,type = 6 ,attrs = [],time_bar = 0 ,image = 15100 ,goods_id = 6623300 ,goods_num = 10 ,is_global = 0 }
;get(16000) -> 
   #base_designation{designation_id = 16000 ,name = ?T("我想静静") ,type = 6 ,attrs = [],time_bar = 0 ,image = 16000 ,goods_id = 6623500 ,goods_num = 10 ,is_global = 0 }
;get(16001) -> 
   #base_designation{designation_id = 16001 ,name = ?T("点点在心头") ,type = 6 ,attrs = [],time_bar = 0 ,image = 16001 ,goods_id = 6623501 ,goods_num = 10 ,is_global = 0 }
;get(_) -> [].