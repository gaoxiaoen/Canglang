%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_convoy_help
	%%% @Created : 2017-09-07 16:53:45
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_convoy_help).
-export([get/1]).
-include("common.hrl").
-include("task.hrl").
get(Lv) when Lv>=1 andalso Lv =< 80 ->[{10108,16015},{10101,801}];
get(Lv) when Lv>=81 andalso Lv =< 85 ->[{10108,17224},{10101,861}];
get(Lv) when Lv>=86 andalso Lv =< 88 ->[{10108,17956},{10101,898}];
get(Lv) when Lv>=89 andalso Lv =< 91 ->[{10108,18693},{10101,935}];
get(Lv) when Lv>=92 andalso Lv =< 93 ->[{10108,19187},{10101,959}];
get(Lv) when Lv>=94 andalso Lv =< 95 ->[{10108,19683},{10101,984}];
get(Lv) when Lv>=96 andalso Lv =< 96 ->[{10108,19932},{10101,997}];
get(Lv) when Lv>=97 andalso Lv =< 105 ->[{10108,22195},{10101,1110}];
get(Lv) when Lv>=106 andalso Lv =< 120 ->[{10108,26052},{10101,1303}];
get(Lv) when Lv>=121 andalso Lv =< 132 ->[{10108,29208},{10101,1460}];
get(Lv) when Lv>=133 andalso Lv =< 147 ->[{10108,33235},{10101,1662}];
get(Lv) when Lv>=148 andalso Lv =< 162 ->[{10108,37345},{10101,1867}];
get(Lv) when Lv>=163 andalso Lv =< 177 ->[{10108,41532},{10101,2077}];
get(Lv) when Lv>=178 andalso Lv =< 197 ->[{10108,47226},{10101,2361}];
get(Lv) when Lv>=198 andalso Lv =< 217 ->[{10108,53036},{10101,2652}];
get(Lv) when Lv>=218 andalso Lv =< 247 ->[{10108,61952},{10101,3098}];
get(Lv) when Lv>=248 andalso Lv =< 277 ->[{10108,71088},{10101,3554}];
get(Lv) when Lv>=278 andalso Lv =< 307 ->[{10108,80424},{10101,4021}];
get(Lv) when Lv>=308 andalso Lv =< 337 ->[{10108,89945},{10101,4497}];
get(Lv) when Lv>=338 andalso Lv =< 367 ->[{10108,99636},{10101,4982}];
get(Lv) when Lv>=368 andalso Lv =< 387 ->[{10108,106187},{10101,5309}];
get(_) -> [].