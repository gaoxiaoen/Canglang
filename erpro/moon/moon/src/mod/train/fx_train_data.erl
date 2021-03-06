%% --------------------------------------------------------------------
%% @doc 飞仙历练数据
%% @author weihua@jieyou.cn
%% --------------------------------------------------------------------
-module(fx_train_data).
-export([
        field/0
        ,lid_to_name/1
        ,path/1
        ,soul/2
    ]
).

%% 战斗力段划分
%% {最低战斗力，最高战斗力，战力段编号，战力段名称} 战斗力 0 表示不限制
field() ->
    [
        {0, 9999, 1, <<"筑基境">>},
        {10000, 19999, 2, <<"分神境">>},
        {20000, 29999, 3, <<"渡劫境">>},
        {30000, 34999, 4, <<"玄仙境">>},
        {35000, 39999, 5, <<"金仙境">>},
        {40000, 50000, 6, <<"化虚境">>},
        {50000, 0, 7, <<"归元境">>}
    ].

lid_to_name(Lid) ->
    case Lid of 
        1 -> <<"筑基境">>;
        2 -> <<"分神境">>;
        3 -> <<"渡劫境">>;
        4 -> <<"玄仙境">>;
        5 -> <<"金仙境">>;
        6 -> <<"化虚境">>;
        7 -> <<"归元境">>;
        _ -> <<>>
    end.

%% 人贩子位置
%% {desxy, viaxy}
path(1) -> {{196,127}, {437,313}};
path(2) -> {{1314,158}, {1077,324}};
path(3) -> {{1314,831}, {1046,694}};
path(_) -> {{184,831}, {443,694}}.

%% 获取魂气
soul(Lev, Type) ->
    {One, Two, Third} = lev_soul(Lev),
    case Type of
        3 -> Third;
        2 -> Two;
        _ -> One
    end.

%% 魂气数据
lev_soul(47) -> {15000, 30000, 90000};
lev_soul(48) -> {15000, 30000, 90000};
lev_soul(49) -> {15000, 30000, 90000};
lev_soul(50) -> {15000, 30000, 90000};
lev_soul(51) -> {15000, 30000, 90000};
lev_soul(52) -> {15000, 30000, 90000};
lev_soul(53) -> {15000, 30000, 90000};
lev_soul(54) -> {15000, 30000, 90000};
lev_soul(55) -> {15000, 30000, 90000};
lev_soul(56) -> {15000, 30000, 90000};
lev_soul(57) -> {15000, 30000, 90000};
lev_soul(58) -> {15000, 30000, 90000};
lev_soul(59) -> {15000, 30000, 90000};
lev_soul(60) -> {15000, 30000, 90000};
lev_soul(61) -> {15000, 30000, 90000};
lev_soul(62) -> {15000, 30000, 90000};
lev_soul(63) -> {15000, 30000, 90000};
lev_soul(64) -> {15000, 30000, 90000};
lev_soul(65) -> {15000, 30000, 90000};
lev_soul(66) -> {15000, 30000, 90000};
lev_soul(67) -> {15000, 30000, 90000};
lev_soul(68) -> {15000, 30000, 90000};
lev_soul(69) -> {15000, 30000, 90000};
lev_soul(70) -> {15000, 30000, 90000};
lev_soul(71) -> {15000, 30000, 90000};
lev_soul(72) -> {15000, 30000, 90000};
lev_soul(73) -> {15000, 30000, 90000};
lev_soul(74) -> {15000, 30000, 90000};
lev_soul(75) -> {15000, 30000, 90000};
lev_soul(76) -> {15000, 30000, 90000};
lev_soul(77) -> {15000, 30000, 90000};
lev_soul(78) -> {15000, 30000, 90000};
lev_soul(79) -> {15000, 30000, 90000};
lev_soul(80) -> {15000, 30000, 90000};
lev_soul(81) -> {15000, 30000, 90000};
lev_soul(82) -> {15000, 30000, 90000};
lev_soul(83) -> {15000, 30000, 90000};
lev_soul(84) -> {15000, 30000, 90000};
lev_soul(85) -> {15000, 30000, 90000};
lev_soul(86) -> {15000, 30000, 90000};
lev_soul(87) -> {15000, 30000, 90000};
lev_soul(88) -> {15000, 30000, 90000};
lev_soul(89) -> {15000, 30000, 90000};
lev_soul(90) -> {15000, 30000, 90000};
lev_soul(91) -> {15000, 30000, 90000};
lev_soul(92) -> {15000, 30000, 90000};
lev_soul(93) -> {15000, 30000, 90000};
lev_soul(94) -> {15000, 30000, 90000};
lev_soul(95) -> {15000, 30000, 90000};
lev_soul(96) -> {15000, 30000, 90000};
lev_soul(97) -> {15000, 30000, 90000};
lev_soul(98) -> {15000, 30000, 90000};
lev_soul(99) -> {15000, 30000, 90000};
lev_soul(100) ->{15000, 30000, 90000};

lev_soul(_) -> {0, 0, 0, 0}.
