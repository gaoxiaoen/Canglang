%%----------------------------------------------------
%% @doc 市场一级二级物品类型对应表
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(market_data_type).
-export([
        type_ref/1
        ,item_type_to_market/2
    ]
).

%% 类别对应关系
type_ref(1) -> {ok, 200};
type_ref(2) -> {ok, 200};
type_ref(3) -> {ok, 200};
type_ref(4) -> {ok, 200};
type_ref(5) -> {ok, 200};
type_ref(11) -> {ok, 201};
type_ref(6) -> {ok, 201};
type_ref(7) -> {ok, 201};
type_ref(8) -> {ok, 201};
type_ref(9) -> {ok, 201};
type_ref(10) -> {ok, 201};
type_ref(14) -> {ok, 201};
type_ref(12) -> {ok, 202};
type_ref(13) -> {ok, 202};
type_ref(17) -> {ok, 203};
type_ref(47) -> {ok, 203};
type_ref(62) -> {ok, 203};
type_ref(26) -> {ok, 204};
type_ref(22) -> {ok, 204};
type_ref(23) -> {ok, 204};
type_ref(24) -> {ok, 204};
type_ref(25) -> {ok, 204};
type_ref(33) -> {ok, 204};
type_ref(43) -> {ok, 204};
type_ref(58) -> {ok, 204};
type_ref(28) -> {ok, 214};
type_ref(48) -> {ok, 214};
type_ref(20) -> {ok, 205};
type_ref(21) -> {ok, 206};
type_ref(41) -> {ok, 206};
type_ref(64) -> {ok, 206};
type_ref(65) -> {ok, 206};
type_ref(19) -> {ok, 207};
type_ref(39) -> {ok, 207};
type_ref(18) -> {ok, 208};
type_ref(30) -> {ok, 209};
type_ref(34) -> {ok, 210};
type_ref(36) -> {ok, 210};
type_ref(0) -> {ok, 211};
type_ref(29) -> {ok, 211};
type_ref(31) -> {ok, 211};
type_ref(40) -> {ok, 211};
type_ref(46) -> {ok, 212};
type_ref(44) -> {ok, 213};
type_ref(45) -> {ok, 213};
type_ref(59) -> {ok, 215};
type_ref(60) -> {ok, 216};
type_ref(61) -> {ok, 217};
type_ref(63) -> {ok, 218};
type_ref(_Type) -> 
    {false, <<"没有找到类别对应关系">>}.

%% 物品类型转换成市场类型
item_type_to_market(_Type, BaseId) when BaseId >= 32300 andalso BaseId =< 32304 -> 62;
item_type_to_market(_Type, BaseId) when BaseId >= 32202 andalso BaseId =< 32204 -> 63;
item_type_to_market(_Type, BaseId) when BaseId >= 33033 andalso BaseId =< 33033 -> 20;
item_type_to_market(_Type, BaseId) when BaseId >= 33149 andalso BaseId =< 33149 -> 61;
item_type_to_market(_Type, BaseId) when BaseId >= 33151 andalso BaseId =< 33151 -> 61;
item_type_to_market(Type, _BaseId) -> Type.
