%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_month_card_gift
	%%% @Created : 2016-06-16 10:05:29
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_month_card_gift).
-export([get/1]).
-export([get_all/0]).
-include("month_card.hrl").
  get(5) -> #base_month_card_gift{ buy_num=5,gift_id=41001,need_vip=0 };
  get(15) -> #base_month_card_gift{ buy_num=15,gift_id=41002,need_vip=0 };
  get(25) -> #base_month_card_gift{ buy_num=25,gift_id=41003,need_vip=1 };
  get(40) -> #base_month_card_gift{ buy_num=40,gift_id=41004,need_vip=1 };
  get(60) -> #base_month_card_gift{ buy_num=60,gift_id=41005,need_vip=2 };
  get(90) -> #base_month_card_gift{ buy_num=90,gift_id=41006,need_vip=2 };
  get(135) -> #base_month_card_gift{ buy_num=135,gift_id=41007,need_vip=2 };
  get(200) -> #base_month_card_gift{ buy_num=200,gift_id=41008,need_vip=2 };
get(_) -> [].
get_all() -> [5,15,25,40,60,90,135,200].

