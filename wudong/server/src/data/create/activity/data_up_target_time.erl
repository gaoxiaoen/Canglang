%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_up_target_time
	%%% @Created : 2017-12-07 15:37:01
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_up_target_time).
-export([get/1]).
-include("activity.hrl").
get(Days) when Days >= 1 andalso Days =< 7 -> #base_up_target_time{open_day=1,end_day=7, act_type_list1=[1,2,3,4,5,6,7], act_type_list2=[0,0,0,0,8,0,0],act_type_list3=[]};
get(Days) when Days >= 8 andalso Days =< 14 -> #base_up_target_time{open_day=8,end_day=14, act_type_list1=[31,32,33,34,35,36,37], act_type_list2=[38,39,40,41,31,43,42],act_type_list3=[]};
get(Days) when Days >= 15 andalso Days =< 21 -> #base_up_target_time{open_day=15,end_day=21, act_type_list1=[61,62,63,64,65,66,67], act_type_list2=[68,69,70,71,68,73,72],act_type_list3=[]};
get(Days) when Days >= 22 andalso Days =< 999 -> #base_up_target_time{open_day=22,end_day=999, act_type_list1=[101,102,103,104,105,106,107], act_type_list2=[108,109,110,111,101,113,112],act_type_list3=[]};
get(_Days) -> [].

