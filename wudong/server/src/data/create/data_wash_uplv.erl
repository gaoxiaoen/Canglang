%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wash_uplv
	%%% @Created : 2017-06-21 16:44:14
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wash_uplv).
-export([get/1]).
-include("error_code.hrl").
get(Lv) when Lv >= 1 andalso Lv =< 80   ->1;
get(Lv) when Lv >= 81 andalso Lv =< 85   ->2;
get(Lv) when Lv >= 86 andalso Lv =< 88   ->3;
get(Lv) when Lv >= 89 andalso Lv =< 91   ->4;
get(Lv) when Lv >= 92 andalso Lv =< 93   ->5;
get(Lv) when Lv >= 94 andalso Lv =< 95   ->6;
get(Lv) when Lv >= 96 andalso Lv =< 96   ->7;
get(Lv) when Lv >= 97 andalso Lv =< 105   ->8;
get(Lv) when Lv >= 106 andalso Lv =< 120   ->9;
get(Lv) when Lv >= 121 andalso Lv =< 132   ->10;
get(Lv) when Lv >= 133 andalso Lv =< 147   ->11;
get(Lv) when Lv >= 148 andalso Lv =< 162   ->12;
get(Lv) when Lv >= 163 andalso Lv =< 177   ->13;
get(Lv) when Lv >= 178 andalso Lv =< 197   ->14;
get(Lv) when Lv >= 198 andalso Lv =< 217   ->15;
get(Lv) when Lv >= 218 andalso Lv =< 247   ->16;
get(Lv) when Lv >= 248 andalso Lv =< 277   ->17;
get(Lv) when Lv >= 278 andalso Lv =< 307   ->18;
get(Lv) when Lv >= 308 andalso Lv =< 337   ->19;
get(Lv) when Lv >= 338 andalso Lv =< 367   ->20;
get(Lv) when Lv >= 368 andalso Lv =< 999   ->21;
get(_Data) -> 0.
