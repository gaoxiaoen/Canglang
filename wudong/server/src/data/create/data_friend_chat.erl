%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_friend_chat
	%%% @Created : 2017-09-12 12:02:50
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_friend_chat).
-export([get/1]).
-export([get_less_fifty/0]).
-export([get_than_fifty/0]).
-include("common.hrl").
  get(1) -> ?T("45级要一起玩消消乐吗");
  get(2) -> ?T("45级要一起玩水果大作战吗");
  get(3) -> ?T("你的萌宠选的是什么呀，有时间一起玩吧/e16/");
  get(4) -> ?T("能不能送我朵花花呀/e17/");
  get(5) -> ?T("hi，以后一起玩好吗");
  get(6) -> ?T("你好，很高兴认识你呢！/e16/");
  get(7) -> ?T("我们已经是好友了，一起来聊天吧！");
  get(8) -> ?T("50级要一起打跨服副本吗");
  get(9) -> ?T("你打算进什么仙盟呀，要一起吗");
  get(10) -> ?T("hi，你知道单身狗头像框怎么获得吗");
  get(11) -> ?T("有时间一起打跨服副本吗/e16/");
  get(12) -> ?T("有时间来一把消消乐吧/e16/");
  get(13) -> ?T("有时间来一把水果作战吧/e16/");
  get(14) -> ?T("能不能送我朵花花呀/e17/");
  get(15) -> ?T("你的坐骑几阶啦？怎么升级快呢/e9/");
  get(16) -> ?T("你的翅膀几阶啦？怎么升级快呢/e9/");
  get(17) -> ?T("hi，以后一起玩好吗");
  get(18) -> ?T("你好，很高兴认识你呢！/e16/");
  get(19) -> ?T("我们已经是好友了，一起来聊天吧！");
  get(20) -> ?T("hi，你知道单身狗头像框怎么获得吗");
get(_) -> [].
get_less_fifty() -> [1,2,3,4,5,6,7,8,9,10].
get_than_fifty() -> [11,12,13,14,15,16,17,18,19,20]
.