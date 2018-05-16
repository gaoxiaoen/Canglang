%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_fashion_suit
	%%% @Created : 2018-03-19 16:38:18
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_fashion_suit).
-export([get/1,ids/0]).
-include("common.hrl").
-include("fashion_suit.hrl").
get(1001) -> 
   #base_fashion_suit{suit_id = 1001 ,suit_name = ?T("泳装派对") ,active_num = 3 ,tar_list = [{1,10004,6601004},{6,110023,3307003},{9,50001,6607004}] ,attrs = []};
get(1002) -> 
   #base_fashion_suit{suit_id = 1002 ,suit_name = ?T("梦游仙境") ,active_num = 4 ,tar_list = [{1,10012,6601012},{6,110025,3307006},{5,100027,3107007},{3,11001,6609016}] ,attrs = []};
get(1003) -> 
   #base_fashion_suit{suit_id = 1003 ,suit_name = ?T("挥斥方遒") ,active_num = 4 ,tar_list = [{1,10006,6601006},{6,110024,3307005},{5,100026,3107006},{4,10075,6604075}] ,attrs = []};
get(1004) -> 
   #base_fashion_suit{suit_id = 1004 ,suit_name = ?T("万圣节套装") ,active_num = 4 ,tar_list = [{1,10016,6601016},{5,100028,3107008},{6,110028,3307009},{4,10080,6603080}] ,attrs = []};
get(1005) -> 
   #base_fashion_suit{suit_id = 1005 ,suit_name = ?T("吃鸡套装") ,active_num = 4 ,tar_list = [{6,110029,3307010},{5,100029,3107009},{9,50007,6608024},{3,10018,6610023}] ,attrs = []};
get(1006) -> 
   #base_fashion_suit{suit_id = 1006 ,suit_name = ?T("钢铁雄心") ,active_num = 4 ,tar_list = [{1,10021,6601021},{7,1020014,3207004},{3,11006,6609026},{2,10022,6605022}] ,attrs = []};
get(1007) -> 
   #base_fashion_suit{suit_id = 1007 ,suit_name = ?T("欢度圣诞") ,active_num = 4 ,tar_list = [{1,10022,6601022},{5,100030,3107010},{6,110032,3307013},{2,10025,6605025}] ,attrs = []};
get(1008) -> 
   #base_fashion_suit{suit_id = 1008 ,suit_name = ?T("天狐降世") ,active_num = 4 ,tar_list = [{1,10023,6601023},{7,1020015,3207005},{4,10105,6603105},{3,10023,6609029}] ,attrs = []};
get(1009) -> 
   #base_fashion_suit{suit_id = 1009 ,suit_name = ?T("新春套装") ,active_num = 4 ,tar_list = [{1,10024,6601024},{5,100031,3107011},{4,10109,6603108},{2,10029,6605029}] ,attrs = []};
get(1010) -> 
   #base_fashion_suit{suit_id = 1010 ,suit_name = ?T("恋恋风歌") ,active_num = 4 ,tar_list = [{1,10026,6601026},{5,100032,3107012},{4,10116,6603116},{2,10033,6605033}] ,attrs = []};
get(_) -> #base_fashion_suit{}.


ids() -> [1001,1002,1003,1004,1005,1006,1007,1008,1009,1010].