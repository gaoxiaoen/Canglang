%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_marry_designation
	%%% @Created : 2017-07-20 17:43:19
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_marry_designation).
-export([get_id/1]).
-export([get_designation_id/1]).
-export([id_list/0]).
-include("marry.hrl").
get_id(1) -> #base_marry_designation{id = 1 ,designation_id = 10054 ,goods_id = 6603054 ,ring_lv = 10 ,heart_lv = 0 ,tree_lv = 0};
get_id(2) -> #base_marry_designation{id = 2 ,designation_id = 10055 ,goods_id = 6603055 ,ring_lv = 20 ,heart_lv = 0 ,tree_lv = 0};
get_id(3) -> #base_marry_designation{id = 3 ,designation_id = 10056 ,goods_id = 6603056 ,ring_lv = 30 ,heart_lv = 30 ,tree_lv = 0};
get_id(4) -> #base_marry_designation{id = 4 ,designation_id = 10057 ,goods_id = 6603057 ,ring_lv = 40 ,heart_lv = 40 ,tree_lv = 0};
get_id(5) -> #base_marry_designation{id = 5 ,designation_id = 10058 ,goods_id = 6603058 ,ring_lv = 50 ,heart_lv = 50 ,tree_lv = 75};
get_id(6) -> #base_marry_designation{id = 6 ,designation_id = 10059 ,goods_id = 6603059 ,ring_lv = 60 ,heart_lv = 60 ,tree_lv = 100};
get_id(7) -> #base_marry_designation{id = 7 ,designation_id = 10060 ,goods_id = 6603060 ,ring_lv = 80 ,heart_lv = 80 ,tree_lv = 150};
get_id(8) -> #base_marry_designation{id = 8 ,designation_id = 10061 ,goods_id = 6603061 ,ring_lv = 100 ,heart_lv = 90 ,tree_lv = 200};
get_id(9) -> #base_marry_designation{id = 9 ,designation_id = 10062 ,goods_id = 6603062 ,ring_lv = 130 ,heart_lv = 99 ,tree_lv = 250};
get_id(_) -> [].
get_designation_id(10054) -> #base_marry_designation{id = 1 ,designation_id = 10054 ,goods_id = 6603054 ,ring_lv = 10 ,heart_lv = 0 ,tree_lv = 0};
get_designation_id(10055) -> #base_marry_designation{id = 2 ,designation_id = 10055 ,goods_id = 6603055 ,ring_lv = 20 ,heart_lv = 0 ,tree_lv = 0};
get_designation_id(10056) -> #base_marry_designation{id = 3 ,designation_id = 10056 ,goods_id = 6603056 ,ring_lv = 30 ,heart_lv = 30 ,tree_lv = 0};
get_designation_id(10057) -> #base_marry_designation{id = 4 ,designation_id = 10057 ,goods_id = 6603057 ,ring_lv = 40 ,heart_lv = 40 ,tree_lv = 0};
get_designation_id(10058) -> #base_marry_designation{id = 5 ,designation_id = 10058 ,goods_id = 6603058 ,ring_lv = 50 ,heart_lv = 50 ,tree_lv = 75};
get_designation_id(10059) -> #base_marry_designation{id = 6 ,designation_id = 10059 ,goods_id = 6603059 ,ring_lv = 60 ,heart_lv = 60 ,tree_lv = 100};
get_designation_id(10060) -> #base_marry_designation{id = 7 ,designation_id = 10060 ,goods_id = 6603060 ,ring_lv = 80 ,heart_lv = 80 ,tree_lv = 150};
get_designation_id(10061) -> #base_marry_designation{id = 8 ,designation_id = 10061 ,goods_id = 6603061 ,ring_lv = 100 ,heart_lv = 90 ,tree_lv = 200};
get_designation_id(10062) -> #base_marry_designation{id = 9 ,designation_id = 10062 ,goods_id = 6603062 ,ring_lv = 130 ,heart_lv = 99 ,tree_lv = 250};
get_designation_id(_) -> [].

    id_list() ->
    [1,2,3,4,5,6,7,8,9].
