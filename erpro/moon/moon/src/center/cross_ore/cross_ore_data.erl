%%---------------------------------------------
%% 跨服仙府系统数据表
%% @author wpf(wprehard@qq.com)
%% @end
%%---------------------------------------------

-module(cross_ore_data).
-export([
        get_elems/0
        ,get_award/1
        ,get_buff/1
        ,get_sanxian/1
        ,get_shenshou/2
    ]).

%% 获取元素(仙府)列表
%% [{BaseId, Name, Lev, X, Y} | ...]
get_elems() ->
    [
        {60444, language:get(<<"高级仙府501（lv29）">>), 29, 2344, 619}
        ,{60439, language:get(<<"高级仙府502（lv27）">>), 27, 1251, 732}
        ,{60440, language:get(<<"高级仙府503（lv27）">>), 27, 2963, 862}
        ,{60441, language:get(<<"高级仙府504（lv25）">>), 25, 407, 934}
        ,{60442, language:get(<<"高级仙府505（lv25）">>), 25, 3497, 600}
        ,{60440, language:get(<<"高级仙府506（lv22）">>), 22, 3616, 1376}
        ,{60443, language:get(<<"高级仙府507（lv22）">>), 22, 781, 1379}
        ,{60429, language:get(<<"中级仙府508（lv19）">>), 19, 1953, 956}
        ,{60432, language:get(<<"中级仙府509（lv19）">>), 19, 2770, 1244}
        ,{60433, language:get(<<"中级仙府510（lv17）">>), 17, 1978, 1502}
        ,{60429, language:get(<<"中级仙府511（lv17）">>), 17, 3141, 1843}
        ,{60431, language:get(<<"中级仙府512（lv15）">>), 15, 1990, 1978}
        ,{60427, language:get(<<"中级仙府513（lv15）">>), 15, 436, 2068}
        ,{60429, language:get(<<"中级仙府514（lv15）">>), 15, 1227, 2360}
        ,{60429, language:get(<<"中级仙府515（lv13）">>), 13, 3256, 2237}
        ,{60428, language:get(<<"中级仙府516（lv13）">>), 13, 3666, 2660}
        ,{60438, language:get(<<"中级仙府517（lv13）">>), 13, 2516, 2806}
        ,{60430, language:get(<<"低级仙府518（lv9）">>), 9, 234, 2815}
        ,{60445, language:get(<<"低级仙府519（lv9）">>), 9, 1032, 2771}
        ,{60438, language:get(<<"低级仙府520（lv8）">>), 8, 2516, 2306}
        ,{60435, language:get(<<"低级仙府521（lv8）">>), 8, 850, 3272}
        ,{60438, language:get(<<"低级仙府522（lv8）">>), 8, 1848, 3240}
        ,{60434, language:get(<<"低级仙府523（lv6）">>), 6, 3116, 3299}
        ,{60436, language:get(<<"低级仙府524（lv6）">>), 6, 2607, 3492}
        ,{60445, language:get(<<"低级仙府525（lv6）">>), 6, 360, 3465}
        ,{60438, language:get(<<"低级仙府526（lv4）">>), 4, 1071, 3673}
        ,{60445, language:get(<<"低级仙府527（lv4）">>), 4, 1831, 3743}
        ,{60436, language:get(<<"低级仙府528（lv4）">>), 4, 3600, 3240}
        ,{60437, language:get(<<"低级仙府529（lv4）">>), 4, 3313, 3777}
        ,{60438, language:get(<<"低级仙府530（lv4）">>), 4, 3886, 3622}
    ].


%% 根据仙府等级获取资源奖励列表
get_award(4) -> [{1, 1, 15000},{9, 1, 75},{27000, 1, 2},{23015, 1, 1},{23000, 1, 3}];
get_award(6) -> [{1, 1, 16000},{9, 1, 80},{27000, 1, 2},{23015, 1, 1},{23000, 1, 3}];
get_award(8) -> [{1, 1, 17000},{9, 1, 85},{27000, 1, 2},{23015, 1, 1},{23000, 1, 3}];
get_award(9) -> [{1, 1, 18000},{9, 1, 90},{27000, 1, 2},{23015, 1, 1},{23000, 1, 3}];
get_award(13) -> [{1, 1, 19000},{9, 1, 105},{27000, 1, 3},{23015, 1, 1},{30210, 1, 1}];
get_award(15) -> [{1, 1, 20000},{9, 1, 110},{27000, 1, 3},{23015, 1, 1},{30210, 1, 1}];
get_award(17) -> [{1, 1, 21000},{9, 1, 115},{27000, 1, 3},{23015, 1, 1},{30210, 1, 1}];
get_award(19) -> [{1, 1, 22000},{9, 1, 120},{27000, 1, 3},{23015, 1, 1},{30210, 1, 1}];
get_award(22) -> [{1, 1, 24000},{9, 1, 135},{27000, 1, 4},{23015, 1, 1},{30210, 1, 1}];
get_award(25) -> [{1, 1, 26000},{9, 1, 140},{27000, 1, 4},{23015, 1, 1},{30210, 1, 1}];
get_award(27) -> [{1, 1, 28000},{9, 1, 145},{27000, 1, 4},{23015, 1, 1},{30210, 1, 1}];
get_award(29) -> [{1, 1, 30000},{9, 1, 150},{27000, 1, 4},{23015, 1, 1},{30210, 1, 1}];
get_award(_) -> [].

%% 根据仙府等级获取散仙ID
get_sanxian(4) -> [22600,22601,22602];
get_sanxian(6) -> [22600,22601,22602];
get_sanxian(8) -> [22603,22604,22605];
get_sanxian(9) -> [22603,22604,22605];
get_sanxian(13) -> [22606,22607,22608];
get_sanxian(15) -> [22606,22607,22608];
get_sanxian(17) -> [22609,22610,22611];
get_sanxian(19) -> [22609,22610,22611];
get_sanxian(22) -> [22612,22613,22614];
get_sanxian(25) -> [22612,22613,22614];
get_sanxian(27) -> [22615,22616,22617];
get_sanxian(29) -> [22615,22616,22617];
get_sanxian(_) -> [].

%% 根据仙府等级获取战斗加成BUFF的信息
get_buff(4) -> {101230,[100,20,0,100]};
get_buff(6) -> {101230,[100,20,0,100]};
get_buff(8) -> {101230,[100,20,0,100]};
get_buff(9) -> {101230,[100,20,0,100]};
get_buff(13) -> {101230,[100,20,0,150]};
get_buff(15) -> {101230,[100,20,0,150]};
get_buff(17) -> {101230,[100,20,0,150]};
get_buff(19) -> {101230,[100,20,0,150]};
get_buff(22) -> {101230,[100,20,0,200]};
get_buff(25) -> {101230,[100,20,0,200]};
get_buff(27) -> {101230,[100,20,0,200]};
get_buff(29) -> {101230,[100,20,0,200]};
get_buff(_) -> error.

%% 根据仙府等级获取神兽对应的战斗npcID
get_shenshou(1, 1) -> 22700;
get_shenshou(1, 2) -> 22701;
get_shenshou(1, 3) -> 22702;
get_shenshou(1, 4) -> 22703;
get_shenshou(1, 5) -> 22704;
get_shenshou(1, 6) -> 22705;
get_shenshou(1, 7) -> 22706;
get_shenshou(1, 8) -> 22707;
get_shenshou(1, 9) -> 22708;
get_shenshou(1, 10) -> 22709;
get_shenshou(2, 1) -> 22750;
get_shenshou(2, 2) -> 22751;
get_shenshou(2, 3) -> 22752;
get_shenshou(2, 4) -> 22753;
get_shenshou(2, 5) -> 22754;
get_shenshou(2, 6) -> 22755;
get_shenshou(2, 7) -> 22756;
get_shenshou(2, 8) -> 22757;
get_shenshou(2, 9) -> 22758;
get_shenshou(2, 10) -> 22759;
get_shenshou(_, _) -> 0.
