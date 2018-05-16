%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_fairy_soul_draw
	%%% @Created : 2017-11-14 14:18:52
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_fairy_soul_draw).
-export([get/1]).
-include("fairy_soul.hrl").
get(1) -> #base_fairy_soul_draw{id = 1 ,cost = 1000 ,floor_ratio = [{-1,70},{1,30}] ,type_ratio = [{1,100},{2,20},{3,0}] ,color_ratio = [{1,60},{2,40},{3,0},{4,0},{5,0}] ,goods_list = {30001,30002,30003,30004,30005,30006,30007}};
get(2) -> #base_fairy_soul_draw{id = 2 ,cost = 2000 ,floor_ratio = [{-1,70},{1,30}] ,type_ratio = [{1,100},{2,20},{3,0}] ,color_ratio = [{1,50},{2,40},{3,10},{4,0},{5,0}] ,goods_list = {30013,30014,30015,30016,30017,30018,30019}};
get(3) -> #base_fairy_soul_draw{id = 3 ,cost = 4000 ,floor_ratio = [{-1,80},{1,20}] ,type_ratio = [{1,100},{2,20},{3,0}] ,color_ratio = [{1,40},{2,40},{3,15},{4,5},{5,0}] ,goods_list = {30025,30026,30027,30028,30029,30030,30031}};
get(4) -> #base_fairy_soul_draw{id = 4 ,cost = 6000 ,floor_ratio = [{-1,60},{1,40}] ,type_ratio = [{1,100},{2,0},{3,0}] ,color_ratio = [{1,0},{2,60},{3,30},{4,10},{5,0}] ,goods_list = {30037,30038,30039,30040,30041,30042,30043,30044,30045,30046,30047}};
get(5) -> #base_fairy_soul_draw{id = 5 ,cost = 8000 ,floor_ratio = [{-1,100},{1,0}] ,type_ratio = [{1,100},{2,0},{3,10}] ,color_ratio = [{1,0},{2,5},{3,25},{4,15},{5,10}] ,goods_list = {30073,30049,30050,30051,30052,30053,30054,30055,30056,30057,30058,30059}};
get(_) -> [].
