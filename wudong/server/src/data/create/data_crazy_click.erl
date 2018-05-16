%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_crazy_click
	%%% @Created : 2016-06-17 00:54:33
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_crazy_click).
-export([get/1]).
-include("crazy_click.hrl").
  get(PlayerLv) when PlayerLv =< 40 -> #base_click{ lv=40,coin=2027,exp=675,drop_id=50001 };
  get(PlayerLv) when PlayerLv =< 50 -> #base_click{ lv=50,coin=2027,exp=675,drop_id=50001 };
  get(PlayerLv) when PlayerLv =< 60 -> #base_click{ lv=60,coin=2635,exp=675,drop_id=50001 };
  get(PlayerLv) when PlayerLv =< 70 -> #base_click{ lv=70,coin=3425,exp=675,drop_id=50001 };
  get(PlayerLv) when PlayerLv =< 80 -> #base_click{ lv=80,coin=4453,exp=675,drop_id=50001 };
  get(PlayerLv) when PlayerLv =< 90 -> #base_click{ lv=90,coin=5789,exp=675,drop_id=50001 };
  get(PlayerLv) when PlayerLv =< 100 -> #base_click{ lv=100,coin=7526,exp=675,drop_id=50001 };
  get(PlayerLv) when PlayerLv =< 110 -> #base_click{ lv=110,coin=9784,exp=675,drop_id=50001 };
  get(PlayerLv) when PlayerLv =< 120 -> #base_click{ lv=120,coin=9784,exp=675,drop_id=50001 };
  get(PlayerLv) when PlayerLv =< 130 -> #base_click{ lv=130,coin=9784,exp=675,drop_id=50001 };
  get(PlayerLv) when PlayerLv =< 999 -> #base_click{ lv=999,coin=9784,exp=675,drop_id=50001 };
get(_) -> [].
