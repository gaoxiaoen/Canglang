
-module(manor_open_data).
-export([get/1, get_enchant_open/0]).

get(10003) -> [{baoshi,1002},{train,1019}];
get(10005) -> [{baoshi,1003}];
get(10007) -> [{baoshi,1004},{moyao,1009},{train,1020}];
get(10009) -> [{baoshi,1005}];
get(10011) -> [{baoshi,1006}];
get(10004) -> [{moyao,1008},{trade,1014}];
get(10010) -> [{moyao,1010},{trade,1017}];
get(10013) -> [{moyao,1011}];
get(10002) -> [{trade,1013},{make,1021}];
get(10006) -> [{trade,1015},{make,1022}];
get(10008) -> [{trade,1016}];
get(10012) -> [{make,1023}];
get(_Id) -> [].


get_enchant_open() -> {22,10670}.



