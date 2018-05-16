%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_send_flower
	%%% @Created : 2017-07-17 13:55:28
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_send_flower).
-export([get/1]).
-include("relation.hrl").
  get(1025001) -> #base_flower{  goods_id=1025001,sweet_get =1 ,sweet_give =2 , charm=2,qinmidu=2, is_show=0,desc= "红色爱恋" };
  get(1025002) -> #base_flower{  goods_id=1025002,sweet_get =50 ,sweet_give =100 , charm=100,qinmidu=100, is_show=1,desc= "蓝色妖姬" };
  get(1025003) -> #base_flower{  goods_id=1025003,sweet_get =300 ,sweet_give =600 , charm=600,qinmidu=600, is_show=1,desc= "金粉佳人" };
get(_) -> [].
