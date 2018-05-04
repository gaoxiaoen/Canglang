%% ************************************
%%  幻灵秘境配置表
%%  @author lishen@jieyou.cn
%% ************************************
-module(secret_data).
-export([
        get_exp/2
        ,cost_gold/2
        ,get_foe/4
        ]).

-include("looks.hrl").

%% 消耗晶钻
cost_gold(Lev, Num) when Lev >= 40 andalso Lev =< 49 andalso Num >= 1 andalso Num =< 1 -> 0;
cost_gold(Lev, Num) when Lev >= 40 andalso Lev =< 49 andalso Num >= 2 andalso Num =< 5 -> 2;
cost_gold(Lev, Num) when Lev >= 40 andalso Lev =< 49 andalso Num >= 6 andalso Num =< 10 -> 4;
cost_gold(Lev, Num) when Lev >= 40 andalso Lev =< 49 andalso Num >= 11 andalso Num =< 20 -> 6;
cost_gold(Lev, Num) when Lev >= 40 andalso Lev =< 49 andalso Num >= 21 andalso Num =< 30 -> 8;
cost_gold(Lev, Num) when Lev >= 40 andalso Lev =< 49 andalso Num >= 31 andalso Num =< 999999 -> 10;
cost_gold(Lev, Num) when Lev >= 50 andalso Lev =< 59 andalso Num >= 1 andalso Num =< 1 -> 0;
cost_gold(Lev, Num) when Lev >= 50 andalso Lev =< 59 andalso Num >= 2 andalso Num =< 5 -> 2;
cost_gold(Lev, Num) when Lev >= 50 andalso Lev =< 59 andalso Num >= 6 andalso Num =< 10 -> 4;
cost_gold(Lev, Num) when Lev >= 50 andalso Lev =< 59 andalso Num >= 11 andalso Num =< 20 -> 6;
cost_gold(Lev, Num) when Lev >= 50 andalso Lev =< 59 andalso Num >= 21 andalso Num =< 30 -> 8;
cost_gold(Lev, Num) when Lev >= 50 andalso Lev =< 59 andalso Num >= 31 andalso Num =< 999999 -> 10;
cost_gold(Lev, Num) when Lev >= 60 andalso Lev =< 69 andalso Num >= 1 andalso Num =< 1 -> 0;
cost_gold(Lev, Num) when Lev >= 60 andalso Lev =< 69 andalso Num >= 2 andalso Num =< 5 -> 2;
cost_gold(Lev, Num) when Lev >= 60 andalso Lev =< 69 andalso Num >= 6 andalso Num =< 10 -> 4;
cost_gold(Lev, Num) when Lev >= 60 andalso Lev =< 69 andalso Num >= 11 andalso Num =< 20 -> 6;
cost_gold(Lev, Num) when Lev >= 60 andalso Lev =< 69 andalso Num >= 21 andalso Num =< 30 -> 8;
cost_gold(Lev, Num) when Lev >= 60 andalso Lev =< 69 andalso Num >= 31 andalso Num =< 999999 -> 10;
cost_gold(Lev, Num) when Lev >= 70 andalso Lev =< 99 andalso Num >= 1 andalso Num =< 1 -> 0;
cost_gold(Lev, Num) when Lev >= 70 andalso Lev =< 99 andalso Num >= 2 andalso Num =< 5 -> 2;
cost_gold(Lev, Num) when Lev >= 70 andalso Lev =< 99 andalso Num >= 6 andalso Num =< 10 -> 4;
cost_gold(Lev, Num) when Lev >= 70 andalso Lev =< 99 andalso Num >= 11 andalso Num =< 20 -> 6;
cost_gold(Lev, Num) when Lev >= 70 andalso Lev =< 99 andalso Num >= 21 andalso Num =< 30 -> 8;
cost_gold(Lev, Num) when Lev >= 70 andalso Lev =< 99 andalso Num >= 31 andalso Num =< 999999 -> 10;
cost_gold(Lev, _Num) when Lev >= 90 -> false.

%% 获取经验值
get_exp(_Lev, Num) when Num =:= 0 -> 0;
get_exp(Lev, Num) when Lev >= 40 andalso Lev =< 49 andalso Num >= 1 andalso Num =< 1 -> 20000;
get_exp(Lev, Num) when Lev >= 40 andalso Lev =< 49 andalso Num >= 2 andalso Num =< 5 -> 20000;
get_exp(Lev, Num) when Lev >= 40 andalso Lev =< 49 andalso Num >= 6 andalso Num =< 10 -> 25000;
get_exp(Lev, Num) when Lev >= 40 andalso Lev =< 49 andalso Num >= 11 andalso Num =< 20 -> 30000;
get_exp(Lev, Num) when Lev >= 40 andalso Lev =< 49 andalso Num >= 21 andalso Num =< 30 -> 35000;
get_exp(Lev, Num) when Lev >= 40 andalso Lev =< 49 andalso Num >= 31 andalso Num =< 999999 -> 40000;
get_exp(Lev, Num) when Lev >= 50 andalso Lev =< 59 andalso Num >= 1 andalso Num =< 1 -> 25000;
get_exp(Lev, Num) when Lev >= 50 andalso Lev =< 59 andalso Num >= 2 andalso Num =< 5 -> 25000;
get_exp(Lev, Num) when Lev >= 50 andalso Lev =< 59 andalso Num >= 6 andalso Num =< 10 -> 31250;
get_exp(Lev, Num) when Lev >= 50 andalso Lev =< 59 andalso Num >= 11 andalso Num =< 20 -> 37500;
get_exp(Lev, Num) when Lev >= 50 andalso Lev =< 59 andalso Num >= 21 andalso Num =< 30 -> 43750;
get_exp(Lev, Num) when Lev >= 50 andalso Lev =< 59 andalso Num >= 31 andalso Num =< 999999 -> 50000;
get_exp(Lev, Num) when Lev >= 60 andalso Lev =< 69 andalso Num >= 1 andalso Num =< 1 -> 30000;
get_exp(Lev, Num) when Lev >= 60 andalso Lev =< 69 andalso Num >= 2 andalso Num =< 5 -> 30000;
get_exp(Lev, Num) when Lev >= 60 andalso Lev =< 69 andalso Num >= 6 andalso Num =< 10 -> 37500;
get_exp(Lev, Num) when Lev >= 60 andalso Lev =< 69 andalso Num >= 11 andalso Num =< 20 -> 45000;
get_exp(Lev, Num) when Lev >= 60 andalso Lev =< 69 andalso Num >= 21 andalso Num =< 30 -> 52500;
get_exp(Lev, Num) when Lev >= 60 andalso Lev =< 69 andalso Num >= 31 andalso Num =< 999999 -> 60000;
get_exp(Lev, Num) when Lev >= 70 andalso Lev =< 99 andalso Num >= 1 andalso Num =< 1 -> 40000;
get_exp(Lev, Num) when Lev >= 70 andalso Lev =< 99 andalso Num >= 2 andalso Num =< 5 -> 40000;
get_exp(Lev, Num) when Lev >= 70 andalso Lev =< 99 andalso Num >= 6 andalso Num =< 10 -> 50000;
get_exp(Lev, Num) when Lev >= 70 andalso Lev =< 99 andalso Num >= 11 andalso Num =< 20 -> 60000;
get_exp(Lev, Num) when Lev >= 70 andalso Lev =< 99 andalso Num >= 21 andalso Num =< 30 -> 70000;
get_exp(Lev, Num) when Lev >= 70 andalso Lev =< 99 andalso Num >= 31 andalso Num =< 999999 -> 80000;
get_exp(Lev, _Num) when Lev >= 90 -> 0.

%% 获取敌人数据
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,80        
,11        
,[        
{?LOOKS_TYPE_WEAPON,10575,10}        
,{?LOOKS_TYPE_SETS,151,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,2000        
,3187        
,[{aspd,40},{defence,776},{dmg_min,513},{dmg_max,641},{dmg_magic,100},{hitrate,135},{evasion,0},{critrate,50},{tenacity,0}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,80        
,12        
,[        
{?LOOKS_TYPE_WEAPON,10576,10}        
,{?LOOKS_TYPE_SETS,150,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,2480        
,5325        
,[{aspd,45},{defence,893},{dmg_min,739},{dmg_max,923},{dmg_magic,112},{hitrate,145},{evasion,17},{critrate,74},{tenacity,12}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,90        
,13        
,[        
{?LOOKS_TYPE_WEAPON,10576,11}        
,{?LOOKS_TYPE_SETS,150,0}        
,{?LOOKS_TYPE_DRESS,16000,10}        
,{?LOOKS_TYPE_WING,18803,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16904,10}                ]        
,2960        
,7463        
,[{aspd,50},{defence,1018},{dmg_min,965},{dmg_max,1206},{dmg_magic,124},{hitrate,155},{evasion,34},{critrate,98},{tenacity,24}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,100        
,14        
,[        
{?LOOKS_TYPE_WEAPON,10576,11}        
,{?LOOKS_TYPE_SETS,150,0}        
,{?LOOKS_TYPE_DRESS,16000,11}        
,{?LOOKS_TYPE_WING,18803,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16904,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,3440        
,9601        
,[{aspd,55},{defence,1153},{dmg_min,1191},{dmg_max,1488},{dmg_magic,136},{hitrate,165},{evasion,51},{critrate,122},{tenacity,36}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,110        
,15        
,[        
{?LOOKS_TYPE_WEAPON,10576,11}        
,{?LOOKS_TYPE_SETS,150,0}        
,{?LOOKS_TYPE_DRESS,16024,11}        
,{?LOOKS_TYPE_WING,18854,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16700,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,3920        
,11739        
,[{aspd,60},{defence,1297},{dmg_min,1416},{dmg_max,1770},{dmg_magic,148},{hitrate,175},{evasion,68},{critrate,146},{tenacity,48}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,120        
,16        
,[        
{?LOOKS_TYPE_WEAPON,10576,12}        
,{?LOOKS_TYPE_SETS,150,0}        
,{?LOOKS_TYPE_DRESS,16024,12}        
,{?LOOKS_TYPE_WING,18854,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16700,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,4400        
,13876        
,[{aspd,55},{defence,1503},{dmg_min,1644},{dmg_max,2055},{dmg_magic,160},{hitrate,186},{evasion,84},{critrate,170},{tenacity,60}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,80        
,11        
,[        
{?LOOKS_TYPE_WEAPON,10760,10}        
,{?LOOKS_TYPE_SETS,161,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,4000        
,8892        
,[{aspd,100},{defence,1410},{dmg_min,1096},{dmg_max,1370},{dmg_magic,175},{hitrate,190},{evasion,110},{critrate,140},{tenacity,30}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,80        
,12        
,[        
{?LOOKS_TYPE_WEAPON,10761,10}        
,{?LOOKS_TYPE_SETS,160,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,5320        
,14598        
,[{aspd,105},{defence,1836},{dmg_min,1915},{dmg_max,2393},{dmg_magic,246},{hitrate,227},{evasion,135},{critrate,196},{tenacity,81}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,90        
,13        
,[        
{?LOOKS_TYPE_WEAPON,10761,11}        
,{?LOOKS_TYPE_SETS,160,0}        
,{?LOOKS_TYPE_DRESS,16012,10}        
,{?LOOKS_TYPE_WING,18809,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,10}                ]        
,6640        
,20304        
,[{aspd,110},{defence,2332},{dmg_min,2735},{dmg_max,3418},{dmg_magic,317},{hitrate,264},{evasion,160},{critrate,252},{tenacity,132}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,100        
,14        
,[        
{?LOOKS_TYPE_WEAPON,10761,11}        
,{?LOOKS_TYPE_SETS,160,0}        
,{?LOOKS_TYPE_DRESS,16012,11}        
,{?LOOKS_TYPE_WING,18809,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,7960        
,26010        
,[{aspd,115},{defence,2911},{dmg_min,3554},{dmg_max,4442},{dmg_magic,388},{hitrate,301},{evasion,185},{critrate,308},{tenacity,183}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,110        
,15        
,[        
{?LOOKS_TYPE_WEAPON,10761,11}        
,{?LOOKS_TYPE_SETS,160,0}        
,{?LOOKS_TYPE_DRESS,16026,11}        
,{?LOOKS_TYPE_WING,18859,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16715,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,9280        
,31716        
,[{aspd,120},{defence,3592},{dmg_min,4374},{dmg_max,5467},{dmg_magic,459},{hitrate,338},{evasion,210},{critrate,364},{tenacity,234}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,120        
,16        
,[        
{?LOOKS_TYPE_WEAPON,10761,12}        
,{?LOOKS_TYPE_SETS,160,0}        
,{?LOOKS_TYPE_DRESS,16026,12}        
,{?LOOKS_TYPE_WING,18859,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16715,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,10600        
,37422        
,[{aspd,115},{defence,5027},{dmg_min,5194},{dmg_max,6492},{dmg_magic,532},{hitrate,376},{evasion,233},{critrate,422},{tenacity,285}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,80        
,11        
,[        
{?LOOKS_TYPE_WEAPON,10945,10}        
,{?LOOKS_TYPE_SETS,171,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,8000        
,29680        
,[{aspd,135},{defence,2400},{dmg_min,3378},{dmg_max,4222},{dmg_magic,500},{hitrate,350},{evasion,150},{critrate,300},{tenacity,90}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,80        
,12        
,[        
{?LOOKS_TYPE_WEAPON,10946,10}        
,{?LOOKS_TYPE_SETS,170,0}        
,{?LOOKS_TYPE_DRESS,16022,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,11000        
,43398        
,[{aspd,145},{defence,3217},{dmg_min,5232},{dmg_max,6540},{dmg_magic,620},{hitrate,417},{evasion,198},{critrate,444},{tenacity,283}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,90        
,13        
,[        
{?LOOKS_TYPE_WEAPON,10946,11}        
,{?LOOKS_TYPE_SETS,170,0}        
,{?LOOKS_TYPE_DRESS,16022,10}        
,{?LOOKS_TYPE_WING,18860,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,10}                ]        
,14000        
,57116        
,[{aspd,155},{defence,4228},{dmg_min,7087},{dmg_max,8858},{dmg_magic,740},{hitrate,484},{evasion,246},{critrate,588},{tenacity,476}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,100        
,14        
,[        
{?LOOKS_TYPE_WEAPON,10946,11}        
,{?LOOKS_TYPE_SETS,170,0}        
,{?LOOKS_TYPE_DRESS,16030,11}        
,{?LOOKS_TYPE_WING,18806,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16710,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,17000        
,70834        
,[{aspd,165},{defence,5501},{dmg_min,8941},{dmg_max,11176},{dmg_magic,860},{hitrate,551},{evasion,294},{critrate,732},{tenacity,669}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,110        
,15        
,[        
{?LOOKS_TYPE_WEAPON,10946,11}        
,{?LOOKS_TYPE_SETS,170,0}        
,{?LOOKS_TYPE_DRESS,16030,11}        
,{?LOOKS_TYPE_WING,18806,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16710,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,20000        
,84552        
,[{aspd,175},{defence,7137},{dmg_min,10795},{dmg_max,13493},{dmg_magic,980},{hitrate,618},{evasion,342},{critrate,876},{tenacity,862}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,120        
,16        
,[        
{?LOOKS_TYPE_WEAPON,10946,12}        
,{?LOOKS_TYPE_SETS,170,0}        
,{?LOOKS_TYPE_DRESS,16032,12}        
,{?LOOKS_TYPE_WING,18805,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16715,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,23000        
,98272        
,[{aspd,165},{defence,7900},{dmg_min,12650},{dmg_max,15812},{dmg_magic,1100},{hitrate,686},{evasion,390},{critrate,1020},{tenacity,1056}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,80        
,11        
,[        
{?LOOKS_TYPE_WEAPON,11130,10}        
,{?LOOKS_TYPE_SETS,181,0}        
,{?LOOKS_TYPE_DRESS,16010,10}        
,{?LOOKS_TYPE_WING,18853,10}                                ]        
,15000        
,80925        
,[{aspd,175},{defence,3338},{dmg_min,5284},{dmg_max,6605},{dmg_magic,772},{hitrate,500},{evasion,317},{critrate,609},{tenacity,457}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,80        
,12        
,[        
{?LOOKS_TYPE_WEAPON,11131,10}        
,{?LOOKS_TYPE_SETS,180,0}        
,{?LOOKS_TYPE_DRESS,16010,10}        
,{?LOOKS_TYPE_WING,18853,10}                                ]        
,18240        
,93816        
,[{aspd,180},{defence,4576},{dmg_min,7568},{dmg_max,9460},{dmg_magic,980},{hitrate,585},{evasion,363},{critrate,770},{tenacity,714}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,90        
,13        
,[        
{?LOOKS_TYPE_WEAPON,11131,11}        
,{?LOOKS_TYPE_SETS,180,0}        
,{?LOOKS_TYPE_DRESS,16032,10}        
,{?LOOKS_TYPE_WING,18805,10}        
,{?LOOKS_TYPE_WEAPON_DRESS,16715,10}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,10}                ]        
,21480        
,106707        
,[{aspd,185},{defence,6187},{dmg_min,9851},{dmg_max,12313},{dmg_magic,1188},{hitrate,670},{evasion,409},{critrate,931},{tenacity,971}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,100        
,14        
,[        
{?LOOKS_TYPE_WEAPON,11131,11}        
,{?LOOKS_TYPE_SETS,180,0}        
,{?LOOKS_TYPE_DRESS,16032,11}        
,{?LOOKS_TYPE_WING,18805,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16715,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,24720        
,119598        
,[{aspd,190},{defence,8349},{dmg_min,12135},{dmg_max,15168},{dmg_magic,1396},{hitrate,755},{evasion,455},{critrate,1092},{tenacity,1228}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,110        
,15        
,[        
{?LOOKS_TYPE_WEAPON,11131,11}        
,{?LOOKS_TYPE_SETS,180,0}        
,{?LOOKS_TYPE_DRESS,16028,11}        
,{?LOOKS_TYPE_WING,18857,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16705,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,27960        
,132489        
,[{aspd,195},{defence,11374},{dmg_min,14418},{dmg_max,18022},{dmg_magic,1604},{hitrate,840},{evasion,501},{critrate,1253},{tenacity,1485}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 1 andalso Sex =:= 1 ->
    {
        <<"幻灵.真武">>        
,120        
,16        
,[        
{?LOOKS_TYPE_WEAPON,11131,12}        
,{?LOOKS_TYPE_SETS,180,0}        
,{?LOOKS_TYPE_DRESS,16028,12}        
,{?LOOKS_TYPE_WING,18857,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16705,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,31200        
,145380        
,[{aspd,190},{defence,12734},{dmg_min,16703},{dmg_max,20878},{dmg_magic,1810},{hitrate,926},{evasion,548},{critrate,1413},{tenacity,1744}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,80        
,11        
,[        
{?LOOKS_TYPE_WEAPON,10575,10}        
,{?LOOKS_TYPE_SETS,151,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,2000        
,3187        
,[{aspd,40},{defence,776},{dmg_min,513},{dmg_max,641},{dmg_magic,100},{hitrate,135},{evasion,0},{critrate,50},{tenacity,0}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,80        
,12        
,[        
{?LOOKS_TYPE_WEAPON,10576,10}        
,{?LOOKS_TYPE_SETS,150,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,2480        
,5325        
,[{aspd,45},{defence,893},{dmg_min,739},{dmg_max,923},{dmg_magic,112},{hitrate,145},{evasion,17},{critrate,74},{tenacity,12}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,90        
,13        
,[        
{?LOOKS_TYPE_WEAPON,10576,11}        
,{?LOOKS_TYPE_SETS,150,0}        
,{?LOOKS_TYPE_DRESS,16001,10}        
,{?LOOKS_TYPE_WING,18853,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,10}                ]        
,2960        
,7463        
,[{aspd,50},{defence,1018},{dmg_min,965},{dmg_max,1206},{dmg_magic,124},{hitrate,155},{evasion,34},{critrate,98},{tenacity,24}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,100        
,14        
,[        
{?LOOKS_TYPE_WEAPON,10576,11}        
,{?LOOKS_TYPE_SETS,150,0}        
,{?LOOKS_TYPE_DRESS,16001,11}        
,{?LOOKS_TYPE_WING,18853,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,3440        
,9601        
,[{aspd,55},{defence,1153},{dmg_min,1191},{dmg_max,1488},{dmg_magic,136},{hitrate,165},{evasion,51},{critrate,122},{tenacity,36}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,110        
,15        
,[        
{?LOOKS_TYPE_WEAPON,10576,11}        
,{?LOOKS_TYPE_SETS,150,0}        
,{?LOOKS_TYPE_DRESS,16027,11}        
,{?LOOKS_TYPE_WING,18807,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16700,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,3920        
,11739        
,[{aspd,60},{defence,1297},{dmg_min,1416},{dmg_max,1770},{dmg_magic,148},{hitrate,175},{evasion,68},{critrate,146},{tenacity,48}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,120        
,16        
,[        
{?LOOKS_TYPE_WEAPON,10576,12}        
,{?LOOKS_TYPE_SETS,150,0}        
,{?LOOKS_TYPE_DRESS,16027,12}        
,{?LOOKS_TYPE_WING,18807,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16700,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,4400        
,13876        
,[{aspd,55},{defence,1503},{dmg_min,1644},{dmg_max,2055},{dmg_magic,160},{hitrate,186},{evasion,84},{critrate,170},{tenacity,60}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,80        
,11        
,[        
{?LOOKS_TYPE_WEAPON,10760,10}        
,{?LOOKS_TYPE_SETS,161,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,4000        
,8892        
,[{aspd,100},{defence,1410},{dmg_min,1096},{dmg_max,1370},{dmg_magic,175},{hitrate,190},{evasion,110},{critrate,140},{tenacity,30}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,80        
,12        
,[        
{?LOOKS_TYPE_WEAPON,10761,10}        
,{?LOOKS_TYPE_SETS,160,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,5320        
,14598        
,[{aspd,105},{defence,1836},{dmg_min,1915},{dmg_max,2393},{dmg_magic,246},{hitrate,227},{evasion,135},{critrate,196},{tenacity,81}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,90        
,13        
,[        
{?LOOKS_TYPE_WEAPON,10761,11}        
,{?LOOKS_TYPE_SETS,160,0}        
,{?LOOKS_TYPE_DRESS,16013,10}        
,{?LOOKS_TYPE_WING,18809,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,10}                ]        
,6640        
,20304        
,[{aspd,110},{defence,2332},{dmg_min,2735},{dmg_max,3418},{dmg_magic,317},{hitrate,264},{evasion,160},{critrate,252},{tenacity,132}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,100        
,14        
,[        
{?LOOKS_TYPE_WEAPON,10761,11}        
,{?LOOKS_TYPE_SETS,160,0}        
,{?LOOKS_TYPE_DRESS,16013,11}        
,{?LOOKS_TYPE_WING,18809,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,7960        
,26010        
,[{aspd,115},{defence,2911},{dmg_min,3554},{dmg_max,4442},{dmg_magic,388},{hitrate,301},{evasion,185},{critrate,308},{tenacity,183}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,110        
,15        
,[        
{?LOOKS_TYPE_WEAPON,10761,11}        
,{?LOOKS_TYPE_SETS,160,0}        
,{?LOOKS_TYPE_DRESS,16025,11}        
,{?LOOKS_TYPE_WING,18858,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16715,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,9280        
,31716        
,[{aspd,120},{defence,3592},{dmg_min,4374},{dmg_max,5467},{dmg_magic,459},{hitrate,338},{evasion,210},{critrate,364},{tenacity,234}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,120        
,16        
,[        
{?LOOKS_TYPE_WEAPON,10761,12}        
,{?LOOKS_TYPE_SETS,160,0}        
,{?LOOKS_TYPE_DRESS,16025,12}        
,{?LOOKS_TYPE_WING,18858,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16715,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,10600        
,37422        
,[{aspd,115},{defence,5027},{dmg_min,5194},{dmg_max,6492},{dmg_magic,532},{hitrate,376},{evasion,233},{critrate,422},{tenacity,285}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,80        
,11        
,[        
{?LOOKS_TYPE_WEAPON,10945,10}        
,{?LOOKS_TYPE_SETS,171,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,8000        
,29680        
,[{aspd,135},{defence,2400},{dmg_min,3378},{dmg_max,4222},{dmg_magic,500},{hitrate,350},{evasion,150},{critrate,300},{tenacity,90}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,80        
,12        
,[        
{?LOOKS_TYPE_WEAPON,10946,10}        
,{?LOOKS_TYPE_SETS,170,0}        
,{?LOOKS_TYPE_DRESS,16011,10}        
,{?LOOKS_TYPE_WING,18854,10}                                ]        
,11000        
,43398        
,[{aspd,145},{defence,3217},{dmg_min,5232},{dmg_max,6540},{dmg_magic,620},{hitrate,417},{evasion,198},{critrate,444},{tenacity,283}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,90        
,13        
,[        
{?LOOKS_TYPE_WEAPON,10946,11}        
,{?LOOKS_TYPE_SETS,170,0}        
,{?LOOKS_TYPE_DRESS,16011,10}        
,{?LOOKS_TYPE_WING,18854,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,10}                ]        
,14000        
,57116        
,[{aspd,155},{defence,4228},{dmg_min,7087},{dmg_max,8858},{dmg_magic,740},{hitrate,484},{evasion,246},{critrate,588},{tenacity,476}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,100        
,14        
,[        
{?LOOKS_TYPE_WEAPON,10946,11}        
,{?LOOKS_TYPE_SETS,170,0}        
,{?LOOKS_TYPE_DRESS,16031,11}        
,{?LOOKS_TYPE_WING,18855,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16710,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,17000        
,70834        
,[{aspd,165},{defence,5501},{dmg_min,8941},{dmg_max,11176},{dmg_magic,860},{hitrate,551},{evasion,294},{critrate,732},{tenacity,669}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,110        
,15        
,[        
{?LOOKS_TYPE_WEAPON,10946,11}        
,{?LOOKS_TYPE_SETS,170,0}        
,{?LOOKS_TYPE_DRESS,16031,11}        
,{?LOOKS_TYPE_WING,18855,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16710,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,20000        
,84552        
,[{aspd,175},{defence,7137},{dmg_min,10795},{dmg_max,13493},{dmg_magic,980},{hitrate,618},{evasion,342},{critrate,876},{tenacity,862}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,120        
,16        
,[        
{?LOOKS_TYPE_WEAPON,10946,12}        
,{?LOOKS_TYPE_SETS,170,0}        
,{?LOOKS_TYPE_DRESS,16033,12}        
,{?LOOKS_TYPE_WING,18856,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16715,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,23000        
,98272        
,[{aspd,165},{defence,7900},{dmg_min,12650},{dmg_max,15812},{dmg_magic,1100},{hitrate,686},{evasion,390},{critrate,1020},{tenacity,1056}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,80        
,11        
,[        
{?LOOKS_TYPE_WEAPON,11130,10}        
,{?LOOKS_TYPE_SETS,181,0}        
,{?LOOKS_TYPE_DRESS,16023,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,15000        
,80925        
,[{aspd,175},{defence,3338},{dmg_min,5284},{dmg_max,6605},{dmg_magic,772},{hitrate,500},{evasion,317},{critrate,609},{tenacity,457}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,80        
,12        
,[        
{?LOOKS_TYPE_WEAPON,11131,10}        
,{?LOOKS_TYPE_SETS,180,0}        
,{?LOOKS_TYPE_DRESS,16023,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,18240        
,93816        
,[{aspd,180},{defence,4576},{dmg_min,7568},{dmg_max,9460},{dmg_magic,980},{hitrate,585},{evasion,363},{critrate,770},{tenacity,714}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,90        
,13        
,[        
{?LOOKS_TYPE_WEAPON,11131,11}        
,{?LOOKS_TYPE_SETS,180,0}        
,{?LOOKS_TYPE_DRESS,16033,10}        
,{?LOOKS_TYPE_WING,18856,10}        
,{?LOOKS_TYPE_WEAPON_DRESS,16715,10}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,10}                ]        
,21480        
,106707        
,[{aspd,185},{defence,6187},{dmg_min,9851},{dmg_max,12313},{dmg_magic,1188},{hitrate,670},{evasion,409},{critrate,931},{tenacity,971}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,100        
,14        
,[        
{?LOOKS_TYPE_WEAPON,11131,11}        
,{?LOOKS_TYPE_SETS,180,0}        
,{?LOOKS_TYPE_DRESS,16033,11}        
,{?LOOKS_TYPE_WING,18856,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16715,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,24720        
,119598        
,[{aspd,190},{defence,8349},{dmg_min,12135},{dmg_max,15168},{dmg_magic,1396},{hitrate,755},{evasion,455},{critrate,1092},{tenacity,1228}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,110        
,15        
,[        
{?LOOKS_TYPE_WEAPON,11131,11}        
,{?LOOKS_TYPE_SETS,180,0}        
,{?LOOKS_TYPE_DRESS,16029,11}        
,{?LOOKS_TYPE_WING,18857,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16705,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,27960        
,132489        
,[{aspd,195},{defence,11374},{dmg_min,14418},{dmg_max,18022},{dmg_magic,1604},{hitrate,840},{evasion,501},{critrate,1253},{tenacity,1485}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 1 andalso Sex =:= 0 ->
    {
        <<"幻灵.真武">>        
,120        
,16        
,[        
{?LOOKS_TYPE_WEAPON,11131,12}        
,{?LOOKS_TYPE_SETS,180,0}        
,{?LOOKS_TYPE_DRESS,16029,12}        
,{?LOOKS_TYPE_WING,18857,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16705,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,31200        
,145380        
,[{aspd,190},{defence,12734},{dmg_min,16703},{dmg_max,20878},{dmg_magic,1810},{hitrate,926},{evasion,548},{critrate,1413},{tenacity,1744}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,80        
,21        
,[        
{?LOOKS_TYPE_WEAPON,10585,10}        
,{?LOOKS_TYPE_SETS,251,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,2000        
,3187        
,[{aspd,40},{defence,776},{dmg_min,513},{dmg_max,641},{dmg_magic,100},{hitrate,135},{evasion,0},{critrate,50},{tenacity,0}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,80        
,22        
,[        
{?LOOKS_TYPE_WEAPON,10586,10}        
,{?LOOKS_TYPE_SETS,250,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,2480        
,5325        
,[{aspd,45},{defence,893},{dmg_min,739},{dmg_max,923},{dmg_magic,112},{hitrate,145},{evasion,17},{critrate,74},{tenacity,12}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,90        
,23        
,[        
{?LOOKS_TYPE_WEAPON,10586,11}        
,{?LOOKS_TYPE_SETS,250,0}        
,{?LOOKS_TYPE_DRESS,16018,10}        
,{?LOOKS_TYPE_WING,18859,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16904,10}                ]        
,2960        
,7463        
,[{aspd,50},{defence,1018},{dmg_min,965},{dmg_max,1206},{dmg_magic,124},{hitrate,155},{evasion,34},{critrate,98},{tenacity,24}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,100        
,24        
,[        
{?LOOKS_TYPE_WEAPON,10586,11}        
,{?LOOKS_TYPE_SETS,250,0}        
,{?LOOKS_TYPE_DRESS,16018,11}        
,{?LOOKS_TYPE_WING,18859,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16904,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,3440        
,9601        
,[{aspd,55},{defence,1153},{dmg_min,1191},{dmg_max,1488},{dmg_magic,136},{hitrate,165},{evasion,51},{critrate,122},{tenacity,36}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,110        
,25        
,[        
{?LOOKS_TYPE_WEAPON,10586,11}        
,{?LOOKS_TYPE_SETS,250,0}        
,{?LOOKS_TYPE_DRESS,16024,11}        
,{?LOOKS_TYPE_WING,18854,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16701,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,3920        
,11739        
,[{aspd,60},{defence,1297},{dmg_min,1416},{dmg_max,1770},{dmg_magic,148},{hitrate,175},{evasion,68},{critrate,146},{tenacity,48}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,120        
,26        
,[        
{?LOOKS_TYPE_WEAPON,10586,12}        
,{?LOOKS_TYPE_SETS,250,0}        
,{?LOOKS_TYPE_DRESS,16024,12}        
,{?LOOKS_TYPE_WING,18854,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16701,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,4400        
,13876        
,[{aspd,55},{defence,1503},{dmg_min,1644},{dmg_max,2055},{dmg_magic,160},{hitrate,186},{evasion,84},{critrate,170},{tenacity,60}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,80        
,21        
,[        
{?LOOKS_TYPE_WEAPON,10770,10}        
,{?LOOKS_TYPE_SETS,261,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,4000        
,8892        
,[{aspd,100},{defence,1410},{dmg_min,1096},{dmg_max,1370},{dmg_magic,175},{hitrate,190},{evasion,110},{critrate,140},{tenacity,30}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,80        
,22        
,[        
{?LOOKS_TYPE_WEAPON,10771,10}        
,{?LOOKS_TYPE_SETS,260,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,5320        
,14598        
,[{aspd,105},{defence,1836},{dmg_min,1915},{dmg_max,2393},{dmg_magic,246},{hitrate,227},{evasion,135},{critrate,196},{tenacity,81}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,90        
,23        
,[        
{?LOOKS_TYPE_WEAPON,10771,11}        
,{?LOOKS_TYPE_SETS,260,0}        
,{?LOOKS_TYPE_DRESS,16006,10}        
,{?LOOKS_TYPE_WING,18807,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,10}                ]        
,6640        
,20304        
,[{aspd,110},{defence,2332},{dmg_min,2735},{dmg_max,3418},{dmg_magic,317},{hitrate,264},{evasion,160},{critrate,252},{tenacity,132}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,100        
,24        
,[        
{?LOOKS_TYPE_WEAPON,10771,11}        
,{?LOOKS_TYPE_SETS,260,0}        
,{?LOOKS_TYPE_DRESS,16006,11}        
,{?LOOKS_TYPE_WING,18807,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,7960        
,26010        
,[{aspd,115},{defence,2911},{dmg_min,3554},{dmg_max,4442},{dmg_magic,388},{hitrate,301},{evasion,185},{critrate,308},{tenacity,183}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,110        
,25        
,[        
{?LOOKS_TYPE_WEAPON,10771,11}        
,{?LOOKS_TYPE_SETS,260,0}        
,{?LOOKS_TYPE_DRESS,16026,11}        
,{?LOOKS_TYPE_WING,18859,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16716,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,9280        
,31716        
,[{aspd,120},{defence,3592},{dmg_min,4374},{dmg_max,5467},{dmg_magic,459},{hitrate,338},{evasion,210},{critrate,364},{tenacity,234}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,120        
,26        
,[        
{?LOOKS_TYPE_WEAPON,10771,12}        
,{?LOOKS_TYPE_SETS,260,0}        
,{?LOOKS_TYPE_DRESS,16026,12}        
,{?LOOKS_TYPE_WING,18859,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16716,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,10600        
,37422        
,[{aspd,115},{defence,5027},{dmg_min,5194},{dmg_max,6492},{dmg_magic,532},{hitrate,376},{evasion,233},{critrate,422},{tenacity,285}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,80        
,21        
,[        
{?LOOKS_TYPE_WEAPON,10955,10}        
,{?LOOKS_TYPE_SETS,271,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,8000        
,29680        
,[{aspd,135},{defence,2400},{dmg_min,3378},{dmg_max,4222},{dmg_magic,500},{hitrate,350},{evasion,150},{critrate,300},{tenacity,90}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,80        
,22        
,[        
{?LOOKS_TYPE_WEAPON,10956,10}        
,{?LOOKS_TYPE_SETS,270,0}        
,{?LOOKS_TYPE_DRESS,16022,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,11000        
,43398        
,[{aspd,145},{defence,3217},{dmg_min,5232},{dmg_max,6540},{dmg_magic,620},{hitrate,417},{evasion,198},{critrate,444},{tenacity,283}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,90        
,23        
,[        
{?LOOKS_TYPE_WEAPON,10956,11}        
,{?LOOKS_TYPE_SETS,270,0}        
,{?LOOKS_TYPE_DRESS,16022,10}        
,{?LOOKS_TYPE_WING,18860,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,10}                ]        
,14000        
,57116        
,[{aspd,155},{defence,4228},{dmg_min,7087},{dmg_max,8858},{dmg_magic,740},{hitrate,484},{evasion,246},{critrate,588},{tenacity,476}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,100        
,24        
,[        
{?LOOKS_TYPE_WEAPON,10956,11}        
,{?LOOKS_TYPE_SETS,270,0}        
,{?LOOKS_TYPE_DRESS,16030,11}        
,{?LOOKS_TYPE_WING,18806,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16711,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,17000        
,70834        
,[{aspd,165},{defence,5501},{dmg_min,8941},{dmg_max,11176},{dmg_magic,860},{hitrate,551},{evasion,294},{critrate,732},{tenacity,669}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,110        
,25        
,[        
{?LOOKS_TYPE_WEAPON,10956,11}        
,{?LOOKS_TYPE_SETS,270,0}        
,{?LOOKS_TYPE_DRESS,16030,11}        
,{?LOOKS_TYPE_WING,18806,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16711,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,20000        
,84552        
,[{aspd,175},{defence,7137},{dmg_min,10795},{dmg_max,13493},{dmg_magic,980},{hitrate,618},{evasion,342},{critrate,876},{tenacity,862}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,120        
,26        
,[        
{?LOOKS_TYPE_WEAPON,10956,12}        
,{?LOOKS_TYPE_SETS,270,0}        
,{?LOOKS_TYPE_DRESS,16032,12}        
,{?LOOKS_TYPE_WING,18805,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16716,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,23000        
,98272        
,[{aspd,165},{defence,7900},{dmg_min,12650},{dmg_max,15812},{dmg_magic,1100},{hitrate,686},{evasion,390},{critrate,1020},{tenacity,1056}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,80        
,21        
,[        
{?LOOKS_TYPE_WEAPON,11140,10}        
,{?LOOKS_TYPE_SETS,281,0}        
,{?LOOKS_TYPE_DRESS,16010,10}        
,{?LOOKS_TYPE_WING,18853,10}                                ]        
,15000        
,80925        
,[{aspd,175},{defence,3338},{dmg_min,5284},{dmg_max,6605},{dmg_magic,772},{hitrate,500},{evasion,317},{critrate,609},{tenacity,457}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,80        
,22        
,[        
{?LOOKS_TYPE_WEAPON,11141,10}        
,{?LOOKS_TYPE_SETS,280,0}        
,{?LOOKS_TYPE_DRESS,16010,10}        
,{?LOOKS_TYPE_WING,18853,10}                                ]        
,18240        
,93816        
,[{aspd,180},{defence,4576},{dmg_min,7568},{dmg_max,9460},{dmg_magic,980},{hitrate,585},{evasion,363},{critrate,770},{tenacity,714}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,90        
,23        
,[        
{?LOOKS_TYPE_WEAPON,11141,11}        
,{?LOOKS_TYPE_SETS,280,0}        
,{?LOOKS_TYPE_DRESS,16032,10}        
,{?LOOKS_TYPE_WING,18805,10}        
,{?LOOKS_TYPE_WEAPON_DRESS,16716,10}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,10}                ]        
,21480        
,106707        
,[{aspd,185},{defence,6187},{dmg_min,9851},{dmg_max,12313},{dmg_magic,1188},{hitrate,670},{evasion,409},{critrate,931},{tenacity,971}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,100        
,24        
,[        
{?LOOKS_TYPE_WEAPON,11141,11}        
,{?LOOKS_TYPE_SETS,280,0}        
,{?LOOKS_TYPE_DRESS,16032,11}        
,{?LOOKS_TYPE_WING,18805,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16716,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,24720        
,119598        
,[{aspd,190},{defence,8349},{dmg_min,12135},{dmg_max,15168},{dmg_magic,1396},{hitrate,755},{evasion,455},{critrate,1092},{tenacity,1228}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,110        
,25        
,[        
{?LOOKS_TYPE_WEAPON,11141,11}        
,{?LOOKS_TYPE_SETS,280,0}        
,{?LOOKS_TYPE_DRESS,16028,11}        
,{?LOOKS_TYPE_WING,18857,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16706,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,27960        
,132489        
,[{aspd,195},{defence,11374},{dmg_min,14418},{dmg_max,18022},{dmg_magic,1604},{hitrate,840},{evasion,501},{critrate,1253},{tenacity,1485}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 2 andalso Sex =:= 1 ->
    {
        <<"幻灵.刺客">>        
,120        
,26        
,[        
{?LOOKS_TYPE_WEAPON,11141,12}        
,{?LOOKS_TYPE_SETS,280,0}        
,{?LOOKS_TYPE_DRESS,16028,12}        
,{?LOOKS_TYPE_WING,18857,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16706,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,31200        
,145380        
,[{aspd,190},{defence,12734},{dmg_min,16703},{dmg_max,20878},{dmg_magic,1810},{hitrate,926},{evasion,548},{critrate,1413},{tenacity,1744}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,80        
,21        
,[        
{?LOOKS_TYPE_WEAPON,10585,10}        
,{?LOOKS_TYPE_SETS,251,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,2000        
,3187        
,[{aspd,40},{defence,776},{dmg_min,513},{dmg_max,641},{dmg_magic,100},{hitrate,135},{evasion,0},{critrate,50},{tenacity,0}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,80        
,22        
,[        
{?LOOKS_TYPE_WEAPON,10586,10}        
,{?LOOKS_TYPE_SETS,250,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,2480        
,5325        
,[{aspd,45},{defence,893},{dmg_min,739},{dmg_max,923},{dmg_magic,112},{hitrate,145},{evasion,17},{critrate,74},{tenacity,12}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,90        
,23        
,[        
{?LOOKS_TYPE_WEAPON,10586,11}        
,{?LOOKS_TYPE_SETS,250,0}        
,{?LOOKS_TYPE_DRESS,16019,10}        
,{?LOOKS_TYPE_WING,18801,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,10}                ]        
,2960        
,7463        
,[{aspd,50},{defence,1018},{dmg_min,965},{dmg_max,1206},{dmg_magic,124},{hitrate,155},{evasion,34},{critrate,98},{tenacity,24}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,100        
,24        
,[        
{?LOOKS_TYPE_WEAPON,10586,11}        
,{?LOOKS_TYPE_SETS,250,0}        
,{?LOOKS_TYPE_DRESS,16019,11}        
,{?LOOKS_TYPE_WING,18801,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,3440        
,9601        
,[{aspd,55},{defence,1153},{dmg_min,1191},{dmg_max,1488},{dmg_magic,136},{hitrate,165},{evasion,51},{critrate,122},{tenacity,36}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,110        
,25        
,[        
{?LOOKS_TYPE_WEAPON,10586,11}        
,{?LOOKS_TYPE_SETS,250,0}        
,{?LOOKS_TYPE_DRESS,16027,11}        
,{?LOOKS_TYPE_WING,18807,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16701,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,3920        
,11739        
,[{aspd,60},{defence,1297},{dmg_min,1416},{dmg_max,1770},{dmg_magic,148},{hitrate,175},{evasion,68},{critrate,146},{tenacity,48}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,120        
,26        
,[        
{?LOOKS_TYPE_WEAPON,10586,12}        
,{?LOOKS_TYPE_SETS,250,0}        
,{?LOOKS_TYPE_DRESS,16027,12}        
,{?LOOKS_TYPE_WING,18807,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16701,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,4400        
,13876        
,[{aspd,55},{defence,1503},{dmg_min,1644},{dmg_max,2055},{dmg_magic,160},{hitrate,186},{evasion,84},{critrate,170},{tenacity,60}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,80        
,21        
,[        
{?LOOKS_TYPE_WEAPON,10770,10}        
,{?LOOKS_TYPE_SETS,261,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,4000        
,8892        
,[{aspd,100},{defence,1410},{dmg_min,1096},{dmg_max,1370},{dmg_magic,175},{hitrate,190},{evasion,110},{critrate,140},{tenacity,30}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,80        
,22        
,[        
{?LOOKS_TYPE_WEAPON,10771,10}        
,{?LOOKS_TYPE_SETS,260,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,5320        
,14598        
,[{aspd,105},{defence,1836},{dmg_min,1915},{dmg_max,2393},{dmg_magic,246},{hitrate,227},{evasion,135},{critrate,196},{tenacity,81}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,90        
,23        
,[        
{?LOOKS_TYPE_WEAPON,10771,11}        
,{?LOOKS_TYPE_SETS,260,0}        
,{?LOOKS_TYPE_DRESS,16007,10}        
,{?LOOKS_TYPE_WING,18807,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,10}                ]        
,6640        
,20304        
,[{aspd,110},{defence,2332},{dmg_min,2735},{dmg_max,3418},{dmg_magic,317},{hitrate,264},{evasion,160},{critrate,252},{tenacity,132}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,100        
,24        
,[        
{?LOOKS_TYPE_WEAPON,10771,11}        
,{?LOOKS_TYPE_SETS,260,0}        
,{?LOOKS_TYPE_DRESS,16007,11}        
,{?LOOKS_TYPE_WING,18807,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,7960        
,26010        
,[{aspd,115},{defence,2911},{dmg_min,3554},{dmg_max,4442},{dmg_magic,388},{hitrate,301},{evasion,185},{critrate,308},{tenacity,183}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,110        
,25        
,[        
{?LOOKS_TYPE_WEAPON,10771,11}        
,{?LOOKS_TYPE_SETS,260,0}        
,{?LOOKS_TYPE_DRESS,16025,11}        
,{?LOOKS_TYPE_WING,18858,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16716,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,9280        
,31716        
,[{aspd,120},{defence,3592},{dmg_min,4374},{dmg_max,5467},{dmg_magic,459},{hitrate,338},{evasion,210},{critrate,364},{tenacity,234}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,120        
,26        
,[        
{?LOOKS_TYPE_WEAPON,10771,12}        
,{?LOOKS_TYPE_SETS,260,0}        
,{?LOOKS_TYPE_DRESS,16025,12}        
,{?LOOKS_TYPE_WING,18858,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16716,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,10600        
,37422        
,[{aspd,115},{defence,5027},{dmg_min,5194},{dmg_max,6492},{dmg_magic,532},{hitrate,376},{evasion,233},{critrate,422},{tenacity,285}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,80        
,21        
,[        
{?LOOKS_TYPE_WEAPON,10955,10}        
,{?LOOKS_TYPE_SETS,271,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,8000        
,29680        
,[{aspd,135},{defence,2400},{dmg_min,3378},{dmg_max,4222},{dmg_magic,500},{hitrate,350},{evasion,150},{critrate,300},{tenacity,90}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,80        
,22        
,[        
{?LOOKS_TYPE_WEAPON,10956,10}        
,{?LOOKS_TYPE_SETS,270,0}        
,{?LOOKS_TYPE_DRESS,16011,10}        
,{?LOOKS_TYPE_WING,18854,10}                                ]        
,11000        
,43398        
,[{aspd,145},{defence,3217},{dmg_min,5232},{dmg_max,6540},{dmg_magic,620},{hitrate,417},{evasion,198},{critrate,444},{tenacity,283}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,90        
,23        
,[        
{?LOOKS_TYPE_WEAPON,10956,11}        
,{?LOOKS_TYPE_SETS,270,0}        
,{?LOOKS_TYPE_DRESS,16011,10}        
,{?LOOKS_TYPE_WING,18854,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,10}                ]        
,14000        
,57116        
,[{aspd,155},{defence,4228},{dmg_min,7087},{dmg_max,8858},{dmg_magic,740},{hitrate,484},{evasion,246},{critrate,588},{tenacity,476}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,100        
,24        
,[        
{?LOOKS_TYPE_WEAPON,10956,11}        
,{?LOOKS_TYPE_SETS,270,0}        
,{?LOOKS_TYPE_DRESS,16031,11}        
,{?LOOKS_TYPE_WING,18855,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16711,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,17000        
,70834        
,[{aspd,165},{defence,5501},{dmg_min,8941},{dmg_max,11176},{dmg_magic,860},{hitrate,551},{evasion,294},{critrate,732},{tenacity,669}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,110        
,25        
,[        
{?LOOKS_TYPE_WEAPON,10956,11}        
,{?LOOKS_TYPE_SETS,270,0}        
,{?LOOKS_TYPE_DRESS,16031,11}        
,{?LOOKS_TYPE_WING,18855,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16711,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,20000        
,84552        
,[{aspd,175},{defence,7137},{dmg_min,10795},{dmg_max,13493},{dmg_magic,980},{hitrate,618},{evasion,342},{critrate,876},{tenacity,862}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,120        
,26        
,[        
{?LOOKS_TYPE_WEAPON,10956,12}        
,{?LOOKS_TYPE_SETS,270,0}        
,{?LOOKS_TYPE_DRESS,16033,12}        
,{?LOOKS_TYPE_WING,18856,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16716,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,23000        
,98272        
,[{aspd,165},{defence,7900},{dmg_min,12650},{dmg_max,15812},{dmg_magic,1100},{hitrate,686},{evasion,390},{critrate,1020},{tenacity,1056}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,80        
,21        
,[        
{?LOOKS_TYPE_WEAPON,11140,10}        
,{?LOOKS_TYPE_SETS,281,0}        
,{?LOOKS_TYPE_DRESS,16023,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,15000        
,80925        
,[{aspd,175},{defence,3338},{dmg_min,5284},{dmg_max,6605},{dmg_magic,772},{hitrate,500},{evasion,317},{critrate,609},{tenacity,457}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,80        
,22        
,[        
{?LOOKS_TYPE_WEAPON,11141,10}        
,{?LOOKS_TYPE_SETS,280,0}        
,{?LOOKS_TYPE_DRESS,16023,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,18240        
,93816        
,[{aspd,180},{defence,4576},{dmg_min,7568},{dmg_max,9460},{dmg_magic,980},{hitrate,585},{evasion,363},{critrate,770},{tenacity,714}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,90        
,23        
,[        
{?LOOKS_TYPE_WEAPON,11141,11}        
,{?LOOKS_TYPE_SETS,280,0}        
,{?LOOKS_TYPE_DRESS,16033,10}        
,{?LOOKS_TYPE_WING,18856,10}        
,{?LOOKS_TYPE_WEAPON_DRESS,16716,10}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,10}                ]        
,21480        
,106707        
,[{aspd,185},{defence,6187},{dmg_min,9851},{dmg_max,12313},{dmg_magic,1188},{hitrate,670},{evasion,409},{critrate,931},{tenacity,971}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,100        
,24        
,[        
{?LOOKS_TYPE_WEAPON,11141,11}        
,{?LOOKS_TYPE_SETS,280,0}        
,{?LOOKS_TYPE_DRESS,16033,11}        
,{?LOOKS_TYPE_WING,18856,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16716,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,24720        
,119598        
,[{aspd,190},{defence,8349},{dmg_min,12135},{dmg_max,15168},{dmg_magic,1396},{hitrate,755},{evasion,455},{critrate,1092},{tenacity,1228}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,110        
,25        
,[        
{?LOOKS_TYPE_WEAPON,11141,11}        
,{?LOOKS_TYPE_SETS,280,0}        
,{?LOOKS_TYPE_DRESS,16029,11}        
,{?LOOKS_TYPE_WING,18857,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16706,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,27960        
,132489        
,[{aspd,195},{defence,11374},{dmg_min,14418},{dmg_max,18022},{dmg_magic,1604},{hitrate,840},{evasion,501},{critrate,1253},{tenacity,1485}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 2 andalso Sex =:= 0 ->
    {
        <<"幻灵.刺客">>        
,120        
,26        
,[        
{?LOOKS_TYPE_WEAPON,11141,12}        
,{?LOOKS_TYPE_SETS,280,0}        
,{?LOOKS_TYPE_DRESS,16029,12}        
,{?LOOKS_TYPE_WING,18857,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16706,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,31200        
,145380        
,[{aspd,190},{defence,12734},{dmg_min,16703},{dmg_max,20878},{dmg_magic,1810},{hitrate,926},{evasion,548},{critrate,1413},{tenacity,1744}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,80        
,41        
,[        
{?LOOKS_TYPE_WEAPON,10595,10}        
,{?LOOKS_TYPE_SETS,451,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,2000        
,3187        
,[{aspd,40},{defence,776},{dmg_min,513},{dmg_max,641},{dmg_magic,100},{hitrate,135},{evasion,0},{critrate,50},{tenacity,0}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,80        
,42        
,[        
{?LOOKS_TYPE_WEAPON,10596,10}        
,{?LOOKS_TYPE_SETS,450,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,2480        
,5325        
,[{aspd,45},{defence,893},{dmg_min,739},{dmg_max,923},{dmg_magic,112},{hitrate,145},{evasion,17},{critrate,74},{tenacity,12}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,90        
,43        
,[        
{?LOOKS_TYPE_WEAPON,10596,11}        
,{?LOOKS_TYPE_SETS,450,0}        
,{?LOOKS_TYPE_DRESS,16004,10}        
,{?LOOKS_TYPE_WING,18806,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16904,10}                ]        
,2960        
,7463        
,[{aspd,50},{defence,1018},{dmg_min,965},{dmg_max,1206},{dmg_magic,124},{hitrate,155},{evasion,34},{critrate,98},{tenacity,24}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,100        
,44        
,[        
{?LOOKS_TYPE_WEAPON,10596,11}        
,{?LOOKS_TYPE_SETS,450,0}        
,{?LOOKS_TYPE_DRESS,16004,11}        
,{?LOOKS_TYPE_WING,18806,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16904,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,3440        
,9601        
,[{aspd,55},{defence,1153},{dmg_min,1191},{dmg_max,1488},{dmg_magic,136},{hitrate,165},{evasion,51},{critrate,122},{tenacity,36}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,110        
,45        
,[        
{?LOOKS_TYPE_WEAPON,10596,11}        
,{?LOOKS_TYPE_SETS,450,0}        
,{?LOOKS_TYPE_DRESS,16024,11}        
,{?LOOKS_TYPE_WING,18854,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16703,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,3920        
,11739        
,[{aspd,60},{defence,1297},{dmg_min,1416},{dmg_max,1770},{dmg_magic,148},{hitrate,175},{evasion,68},{critrate,146},{tenacity,48}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,120        
,46        
,[        
{?LOOKS_TYPE_WEAPON,10596,12}        
,{?LOOKS_TYPE_SETS,450,0}        
,{?LOOKS_TYPE_DRESS,16024,12}        
,{?LOOKS_TYPE_WING,18854,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16703,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,4400        
,13876        
,[{aspd,55},{defence,1503},{dmg_min,1644},{dmg_max,2055},{dmg_magic,160},{hitrate,186},{evasion,84},{critrate,170},{tenacity,60}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,80        
,41        
,[        
{?LOOKS_TYPE_WEAPON,10780,10}        
,{?LOOKS_TYPE_SETS,461,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,4000        
,8892        
,[{aspd,100},{defence,1410},{dmg_min,1096},{dmg_max,1370},{dmg_magic,175},{hitrate,190},{evasion,110},{critrate,140},{tenacity,30}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,80        
,42        
,[        
{?LOOKS_TYPE_WEAPON,10781,10}        
,{?LOOKS_TYPE_SETS,460,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,5320        
,14598        
,[{aspd,105},{defence,1836},{dmg_min,1915},{dmg_max,2393},{dmg_magic,246},{hitrate,227},{evasion,135},{critrate,196},{tenacity,81}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,90        
,43        
,[        
{?LOOKS_TYPE_WEAPON,10781,11}        
,{?LOOKS_TYPE_SETS,460,0}        
,{?LOOKS_TYPE_DRESS,16016,10}        
,{?LOOKS_TYPE_WING,18853,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,10}                ]        
,6640        
,20304        
,[{aspd,110},{defence,2332},{dmg_min,2735},{dmg_max,3418},{dmg_magic,317},{hitrate,264},{evasion,160},{critrate,252},{tenacity,132}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,100        
,44        
,[        
{?LOOKS_TYPE_WEAPON,10781,11}        
,{?LOOKS_TYPE_SETS,460,0}        
,{?LOOKS_TYPE_DRESS,16016,11}        
,{?LOOKS_TYPE_WING,18853,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,7960        
,26010        
,[{aspd,115},{defence,2911},{dmg_min,3554},{dmg_max,4442},{dmg_magic,388},{hitrate,301},{evasion,185},{critrate,308},{tenacity,183}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,110        
,45        
,[        
{?LOOKS_TYPE_WEAPON,10781,11}        
,{?LOOKS_TYPE_SETS,460,0}        
,{?LOOKS_TYPE_DRESS,16026,11}        
,{?LOOKS_TYPE_WING,18859,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16718,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,9280        
,31716        
,[{aspd,120},{defence,3592},{dmg_min,4374},{dmg_max,5467},{dmg_magic,459},{hitrate,338},{evasion,210},{critrate,364},{tenacity,234}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,120        
,46        
,[        
{?LOOKS_TYPE_WEAPON,10781,12}        
,{?LOOKS_TYPE_SETS,460,0}        
,{?LOOKS_TYPE_DRESS,16026,12}        
,{?LOOKS_TYPE_WING,18859,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16718,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,10600        
,37422        
,[{aspd,115},{defence,5027},{dmg_min,5194},{dmg_max,6492},{dmg_magic,532},{hitrate,376},{evasion,233},{critrate,422},{tenacity,285}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,80        
,41        
,[        
{?LOOKS_TYPE_WEAPON,10965,10}        
,{?LOOKS_TYPE_SETS,471,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,8000        
,29680        
,[{aspd,135},{defence,2400},{dmg_min,3378},{dmg_max,4222},{dmg_magic,500},{hitrate,350},{evasion,150},{critrate,300},{tenacity,90}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,80        
,42        
,[        
{?LOOKS_TYPE_WEAPON,10966,10}        
,{?LOOKS_TYPE_SETS,470,0}        
,{?LOOKS_TYPE_DRESS,16022,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,11000        
,43398        
,[{aspd,145},{defence,3217},{dmg_min,5232},{dmg_max,6540},{dmg_magic,620},{hitrate,417},{evasion,198},{critrate,444},{tenacity,283}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,90        
,43        
,[        
{?LOOKS_TYPE_WEAPON,10966,11}        
,{?LOOKS_TYPE_SETS,470,0}        
,{?LOOKS_TYPE_DRESS,16022,10}        
,{?LOOKS_TYPE_WING,18860,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,10}                ]        
,14000        
,57116        
,[{aspd,155},{defence,4228},{dmg_min,7087},{dmg_max,8858},{dmg_magic,740},{hitrate,484},{evasion,246},{critrate,588},{tenacity,476}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,100        
,44        
,[        
{?LOOKS_TYPE_WEAPON,10966,11}        
,{?LOOKS_TYPE_SETS,470,0}        
,{?LOOKS_TYPE_DRESS,16030,11}        
,{?LOOKS_TYPE_WING,18806,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16713,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,17000        
,70834        
,[{aspd,165},{defence,5501},{dmg_min,8941},{dmg_max,11176},{dmg_magic,860},{hitrate,551},{evasion,294},{critrate,732},{tenacity,669}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,110        
,45        
,[        
{?LOOKS_TYPE_WEAPON,10966,11}        
,{?LOOKS_TYPE_SETS,470,0}        
,{?LOOKS_TYPE_DRESS,16030,11}        
,{?LOOKS_TYPE_WING,18806,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16713,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,20000        
,84552        
,[{aspd,175},{defence,7137},{dmg_min,10795},{dmg_max,13493},{dmg_magic,980},{hitrate,618},{evasion,342},{critrate,876},{tenacity,862}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,120        
,46        
,[        
{?LOOKS_TYPE_WEAPON,10966,12}        
,{?LOOKS_TYPE_SETS,470,0}        
,{?LOOKS_TYPE_DRESS,16032,12}        
,{?LOOKS_TYPE_WING,18805,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16718,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,23000        
,98272        
,[{aspd,165},{defence,7900},{dmg_min,12650},{dmg_max,15812},{dmg_magic,1100},{hitrate,686},{evasion,390},{critrate,1020},{tenacity,1056}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,80        
,41        
,[        
{?LOOKS_TYPE_WEAPON,11150,10}        
,{?LOOKS_TYPE_SETS,481,0}        
,{?LOOKS_TYPE_DRESS,16010,10}        
,{?LOOKS_TYPE_WING,18853,10}                                ]        
,15000        
,80925        
,[{aspd,175},{defence,3338},{dmg_min,5284},{dmg_max,6605},{dmg_magic,772},{hitrate,500},{evasion,317},{critrate,609},{tenacity,457}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,80        
,42        
,[        
{?LOOKS_TYPE_WEAPON,11151,10}        
,{?LOOKS_TYPE_SETS,480,0}        
,{?LOOKS_TYPE_DRESS,16010,10}        
,{?LOOKS_TYPE_WING,18853,10}                                ]        
,18240        
,93816        
,[{aspd,180},{defence,4576},{dmg_min,7568},{dmg_max,9460},{dmg_magic,980},{hitrate,585},{evasion,363},{critrate,770},{tenacity,714}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,90        
,43        
,[        
{?LOOKS_TYPE_WEAPON,11151,11}        
,{?LOOKS_TYPE_SETS,480,0}        
,{?LOOKS_TYPE_DRESS,16032,10}        
,{?LOOKS_TYPE_WING,18805,10}        
,{?LOOKS_TYPE_WEAPON_DRESS,16718,10}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,10}                ]        
,21480        
,106707        
,[{aspd,185},{defence,6187},{dmg_min,9851},{dmg_max,12313},{dmg_magic,1188},{hitrate,670},{evasion,409},{critrate,931},{tenacity,971}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,100        
,44        
,[        
{?LOOKS_TYPE_WEAPON,11151,11}        
,{?LOOKS_TYPE_SETS,480,0}        
,{?LOOKS_TYPE_DRESS,16032,11}        
,{?LOOKS_TYPE_WING,18805,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16718,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,24720        
,119598        
,[{aspd,190},{defence,8349},{dmg_min,12135},{dmg_max,15168},{dmg_magic,1396},{hitrate,755},{evasion,455},{critrate,1092},{tenacity,1228}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,110        
,45        
,[        
{?LOOKS_TYPE_WEAPON,11151,11}        
,{?LOOKS_TYPE_SETS,480,0}        
,{?LOOKS_TYPE_DRESS,16028,11}        
,{?LOOKS_TYPE_WING,18857,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16708,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,27960        
,132489        
,[{aspd,195},{defence,11374},{dmg_min,14418},{dmg_max,18022},{dmg_magic,1604},{hitrate,840},{evasion,501},{critrate,1253},{tenacity,1485}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 4 andalso Sex =:= 1 ->
    {
        <<"幻灵.飞羽">>        
,120        
,46        
,[        
{?LOOKS_TYPE_WEAPON,11151,12}        
,{?LOOKS_TYPE_SETS,480,0}        
,{?LOOKS_TYPE_DRESS,16028,12}        
,{?LOOKS_TYPE_WING,18857,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16708,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,31200        
,145380        
,[{aspd,190},{defence,12734},{dmg_min,16703},{dmg_max,20878},{dmg_magic,1810},{hitrate,926},{evasion,548},{critrate,1413},{tenacity,1744}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,80        
,41        
,[        
{?LOOKS_TYPE_WEAPON,10595,10}        
,{?LOOKS_TYPE_SETS,451,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,2000        
,3187        
,[{aspd,40},{defence,776},{dmg_min,513},{dmg_max,641},{dmg_magic,100},{hitrate,135},{evasion,0},{critrate,50},{tenacity,0}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,80        
,42        
,[        
{?LOOKS_TYPE_WEAPON,10596,10}        
,{?LOOKS_TYPE_SETS,450,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,2480        
,5325        
,[{aspd,45},{defence,893},{dmg_min,739},{dmg_max,923},{dmg_magic,112},{hitrate,145},{evasion,17},{critrate,74},{tenacity,12}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,90        
,43        
,[        
{?LOOKS_TYPE_WEAPON,10596,11}        
,{?LOOKS_TYPE_SETS,450,0}        
,{?LOOKS_TYPE_DRESS,16005,10}        
,{?LOOKS_TYPE_WING,18854,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,10}                ]        
,2960        
,7463        
,[{aspd,50},{defence,1018},{dmg_min,965},{dmg_max,1206},{dmg_magic,124},{hitrate,155},{evasion,34},{critrate,98},{tenacity,24}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,100        
,44        
,[        
{?LOOKS_TYPE_WEAPON,10596,11}        
,{?LOOKS_TYPE_SETS,450,0}        
,{?LOOKS_TYPE_DRESS,16005,11}        
,{?LOOKS_TYPE_WING,18854,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,3440        
,9601        
,[{aspd,55},{defence,1153},{dmg_min,1191},{dmg_max,1488},{dmg_magic,136},{hitrate,165},{evasion,51},{critrate,122},{tenacity,36}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,110        
,45        
,[        
{?LOOKS_TYPE_WEAPON,10596,11}        
,{?LOOKS_TYPE_SETS,450,0}        
,{?LOOKS_TYPE_DRESS,16027,11}        
,{?LOOKS_TYPE_WING,18807,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16703,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,3920        
,11739        
,[{aspd,60},{defence,1297},{dmg_min,1416},{dmg_max,1770},{dmg_magic,148},{hitrate,175},{evasion,68},{critrate,146},{tenacity,48}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,120        
,46        
,[        
{?LOOKS_TYPE_WEAPON,10596,12}        
,{?LOOKS_TYPE_SETS,450,0}        
,{?LOOKS_TYPE_DRESS,16027,12}        
,{?LOOKS_TYPE_WING,18807,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16703,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,4400        
,13876        
,[{aspd,55},{defence,1503},{dmg_min,1644},{dmg_max,2055},{dmg_magic,160},{hitrate,186},{evasion,84},{critrate,170},{tenacity,60}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,80        
,41        
,[        
{?LOOKS_TYPE_WEAPON,10780,10}        
,{?LOOKS_TYPE_SETS,461,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,4000        
,8892        
,[{aspd,100},{defence,1410},{dmg_min,1096},{dmg_max,1370},{dmg_magic,175},{hitrate,190},{evasion,110},{critrate,140},{tenacity,30}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,80        
,42        
,[        
{?LOOKS_TYPE_WEAPON,10781,10}        
,{?LOOKS_TYPE_SETS,460,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,5320        
,14598        
,[{aspd,105},{defence,1836},{dmg_min,1915},{dmg_max,2393},{dmg_magic,246},{hitrate,227},{evasion,135},{critrate,196},{tenacity,81}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,90        
,43        
,[        
{?LOOKS_TYPE_WEAPON,10781,11}        
,{?LOOKS_TYPE_SETS,460,0}        
,{?LOOKS_TYPE_DRESS,16017,10}        
,{?LOOKS_TYPE_WING,18853,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,10}                ]        
,6640        
,20304        
,[{aspd,110},{defence,2332},{dmg_min,2735},{dmg_max,3418},{dmg_magic,317},{hitrate,264},{evasion,160},{critrate,252},{tenacity,132}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,100        
,44        
,[        
{?LOOKS_TYPE_WEAPON,10781,11}        
,{?LOOKS_TYPE_SETS,460,0}        
,{?LOOKS_TYPE_DRESS,16017,11}        
,{?LOOKS_TYPE_WING,18853,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,7960        
,26010        
,[{aspd,115},{defence,2911},{dmg_min,3554},{dmg_max,4442},{dmg_magic,388},{hitrate,301},{evasion,185},{critrate,308},{tenacity,183}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,110        
,45        
,[        
{?LOOKS_TYPE_WEAPON,10781,11}        
,{?LOOKS_TYPE_SETS,460,0}        
,{?LOOKS_TYPE_DRESS,16025,11}        
,{?LOOKS_TYPE_WING,18858,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16718,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,9280        
,31716        
,[{aspd,120},{defence,3592},{dmg_min,4374},{dmg_max,5467},{dmg_magic,459},{hitrate,338},{evasion,210},{critrate,364},{tenacity,234}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,120        
,46        
,[        
{?LOOKS_TYPE_WEAPON,10781,12}        
,{?LOOKS_TYPE_SETS,460,0}        
,{?LOOKS_TYPE_DRESS,16025,12}        
,{?LOOKS_TYPE_WING,18858,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16718,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,10600        
,37422        
,[{aspd,115},{defence,5027},{dmg_min,5194},{dmg_max,6492},{dmg_magic,532},{hitrate,376},{evasion,233},{critrate,422},{tenacity,285}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,80        
,41        
,[        
{?LOOKS_TYPE_WEAPON,10965,10}        
,{?LOOKS_TYPE_SETS,471,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,8000        
,29680        
,[{aspd,135},{defence,2400},{dmg_min,3378},{dmg_max,4222},{dmg_magic,500},{hitrate,350},{evasion,150},{critrate,300},{tenacity,90}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,80        
,42        
,[        
{?LOOKS_TYPE_WEAPON,10966,10}        
,{?LOOKS_TYPE_SETS,470,0}        
,{?LOOKS_TYPE_DRESS,16011,10}        
,{?LOOKS_TYPE_WING,18854,10}                                ]        
,11000        
,43398        
,[{aspd,145},{defence,3217},{dmg_min,5232},{dmg_max,6540},{dmg_magic,620},{hitrate,417},{evasion,198},{critrate,444},{tenacity,283}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,90        
,43        
,[        
{?LOOKS_TYPE_WEAPON,10966,11}        
,{?LOOKS_TYPE_SETS,470,0}        
,{?LOOKS_TYPE_DRESS,16011,10}        
,{?LOOKS_TYPE_WING,18854,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,10}                ]        
,14000        
,57116        
,[{aspd,155},{defence,4228},{dmg_min,7087},{dmg_max,8858},{dmg_magic,740},{hitrate,484},{evasion,246},{critrate,588},{tenacity,476}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,100        
,44        
,[        
{?LOOKS_TYPE_WEAPON,10966,11}        
,{?LOOKS_TYPE_SETS,470,0}        
,{?LOOKS_TYPE_DRESS,16031,11}        
,{?LOOKS_TYPE_WING,18855,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16713,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,17000        
,70834        
,[{aspd,165},{defence,5501},{dmg_min,8941},{dmg_max,11176},{dmg_magic,860},{hitrate,551},{evasion,294},{critrate,732},{tenacity,669}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,110        
,45        
,[        
{?LOOKS_TYPE_WEAPON,10966,11}        
,{?LOOKS_TYPE_SETS,470,0}        
,{?LOOKS_TYPE_DRESS,16031,11}        
,{?LOOKS_TYPE_WING,18855,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16713,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,20000        
,84552        
,[{aspd,175},{defence,7137},{dmg_min,10795},{dmg_max,13493},{dmg_magic,980},{hitrate,618},{evasion,342},{critrate,876},{tenacity,862}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,120        
,46        
,[        
{?LOOKS_TYPE_WEAPON,10966,12}        
,{?LOOKS_TYPE_SETS,470,0}        
,{?LOOKS_TYPE_DRESS,16033,12}        
,{?LOOKS_TYPE_WING,18856,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16718,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,23000        
,98272        
,[{aspd,165},{defence,7900},{dmg_min,12650},{dmg_max,15812},{dmg_magic,1100},{hitrate,686},{evasion,390},{critrate,1020},{tenacity,1056}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,80        
,41        
,[        
{?LOOKS_TYPE_WEAPON,11150,10}        
,{?LOOKS_TYPE_SETS,481,0}        
,{?LOOKS_TYPE_DRESS,16023,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,15000        
,80925        
,[{aspd,175},{defence,3338},{dmg_min,5284},{dmg_max,6605},{dmg_magic,772},{hitrate,500},{evasion,317},{critrate,609},{tenacity,457}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,80        
,42        
,[        
{?LOOKS_TYPE_WEAPON,11151,10}        
,{?LOOKS_TYPE_SETS,480,0}        
,{?LOOKS_TYPE_DRESS,16023,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,18240        
,93816        
,[{aspd,180},{defence,4576},{dmg_min,7568},{dmg_max,9460},{dmg_magic,980},{hitrate,585},{evasion,363},{critrate,770},{tenacity,714}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,90        
,43        
,[        
{?LOOKS_TYPE_WEAPON,11151,11}        
,{?LOOKS_TYPE_SETS,480,0}        
,{?LOOKS_TYPE_DRESS,16033,10}        
,{?LOOKS_TYPE_WING,18856,10}        
,{?LOOKS_TYPE_WEAPON_DRESS,16718,10}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,10}                ]        
,21480        
,106707        
,[{aspd,185},{defence,6187},{dmg_min,9851},{dmg_max,12313},{dmg_magic,1188},{hitrate,670},{evasion,409},{critrate,931},{tenacity,971}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,100        
,44        
,[        
{?LOOKS_TYPE_WEAPON,11151,11}        
,{?LOOKS_TYPE_SETS,480,0}        
,{?LOOKS_TYPE_DRESS,16033,11}        
,{?LOOKS_TYPE_WING,18856,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16718,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,24720        
,119598        
,[{aspd,190},{defence,8349},{dmg_min,12135},{dmg_max,15168},{dmg_magic,1396},{hitrate,755},{evasion,455},{critrate,1092},{tenacity,1228}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,110        
,45        
,[        
{?LOOKS_TYPE_WEAPON,11151,11}        
,{?LOOKS_TYPE_SETS,480,0}        
,{?LOOKS_TYPE_DRESS,16029,11}        
,{?LOOKS_TYPE_WING,18857,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16708,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,27960        
,132489        
,[{aspd,195},{defence,11374},{dmg_min,14418},{dmg_max,18022},{dmg_magic,1604},{hitrate,840},{evasion,501},{critrate,1253},{tenacity,1485}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 4 andalso Sex =:= 0 ->
    {
        <<"幻灵.飞羽">>        
,120        
,46        
,[        
{?LOOKS_TYPE_WEAPON,11151,12}        
,{?LOOKS_TYPE_SETS,480,0}        
,{?LOOKS_TYPE_DRESS,16029,12}        
,{?LOOKS_TYPE_WING,18857,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16708,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,31200        
,145380        
,[{aspd,190},{defence,12734},{dmg_min,16703},{dmg_max,20878},{dmg_magic,1810},{hitrate,926},{evasion,548},{critrate,1413},{tenacity,1744}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,80        
,31        
,[        
{?LOOKS_TYPE_WEAPON,10590,10}        
,{?LOOKS_TYPE_SETS,351,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,2000        
,3187        
,[{aspd,40},{defence,776},{dmg_min,513},{dmg_max,641},{dmg_magic,100},{hitrate,135},{evasion,0},{critrate,50},{tenacity,0}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,80        
,32        
,[        
{?LOOKS_TYPE_WEAPON,10591,10}        
,{?LOOKS_TYPE_SETS,350,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,2480        
,5325        
,[{aspd,45},{defence,893},{dmg_min,739},{dmg_max,923},{dmg_magic,112},{hitrate,145},{evasion,17},{critrate,74},{tenacity,12}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,90        
,33        
,[        
{?LOOKS_TYPE_WEAPON,10591,11}        
,{?LOOKS_TYPE_SETS,350,0}        
,{?LOOKS_TYPE_DRESS,16002,10}        
,{?LOOKS_TYPE_WING,18805,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16904,10}                ]        
,2960        
,7463        
,[{aspd,50},{defence,1018},{dmg_min,965},{dmg_max,1206},{dmg_magic,124},{hitrate,155},{evasion,34},{critrate,98},{tenacity,24}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,100        
,34        
,[        
{?LOOKS_TYPE_WEAPON,10591,11}        
,{?LOOKS_TYPE_SETS,350,0}        
,{?LOOKS_TYPE_DRESS,16002,11}        
,{?LOOKS_TYPE_WING,18805,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16904,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,3440        
,9601        
,[{aspd,55},{defence,1153},{dmg_min,1191},{dmg_max,1488},{dmg_magic,136},{hitrate,165},{evasion,51},{critrate,122},{tenacity,36}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,110        
,35        
,[        
{?LOOKS_TYPE_WEAPON,10591,11}        
,{?LOOKS_TYPE_SETS,350,0}        
,{?LOOKS_TYPE_DRESS,16024,11}        
,{?LOOKS_TYPE_WING,18854,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16702,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,3920        
,11739        
,[{aspd,60},{defence,1297},{dmg_min,1416},{dmg_max,1770},{dmg_magic,148},{hitrate,175},{evasion,68},{critrate,146},{tenacity,48}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,120        
,36        
,[        
{?LOOKS_TYPE_WEAPON,10591,12}        
,{?LOOKS_TYPE_SETS,350,0}        
,{?LOOKS_TYPE_DRESS,16024,12}        
,{?LOOKS_TYPE_WING,18854,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16702,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,4400        
,13876        
,[{aspd,55},{defence,1503},{dmg_min,1644},{dmg_max,2055},{dmg_magic,160},{hitrate,186},{evasion,84},{critrate,170},{tenacity,60}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,80        
,31        
,[        
{?LOOKS_TYPE_WEAPON,10775,10}        
,{?LOOKS_TYPE_SETS,361,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,4000        
,8892        
,[{aspd,100},{defence,1410},{dmg_min,1096},{dmg_max,1370},{dmg_magic,175},{hitrate,190},{evasion,110},{critrate,140},{tenacity,30}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,80        
,32        
,[        
{?LOOKS_TYPE_WEAPON,10776,10}        
,{?LOOKS_TYPE_SETS,360,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,5320        
,14598        
,[{aspd,105},{defence,1836},{dmg_min,1915},{dmg_max,2393},{dmg_magic,246},{hitrate,227},{evasion,135},{critrate,196},{tenacity,81}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,90        
,33        
,[        
{?LOOKS_TYPE_WEAPON,10776,11}        
,{?LOOKS_TYPE_SETS,360,0}        
,{?LOOKS_TYPE_DRESS,16014,10}        
,{?LOOKS_TYPE_WING,18853,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,10}                ]        
,6640        
,20304        
,[{aspd,110},{defence,2332},{dmg_min,2735},{dmg_max,3418},{dmg_magic,317},{hitrate,264},{evasion,160},{critrate,252},{tenacity,132}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,100        
,34        
,[        
{?LOOKS_TYPE_WEAPON,10776,11}        
,{?LOOKS_TYPE_SETS,360,0}        
,{?LOOKS_TYPE_DRESS,16014,11}        
,{?LOOKS_TYPE_WING,18853,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,7960        
,26010        
,[{aspd,115},{defence,2911},{dmg_min,3554},{dmg_max,4442},{dmg_magic,388},{hitrate,301},{evasion,185},{critrate,308},{tenacity,183}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,110        
,35        
,[        
{?LOOKS_TYPE_WEAPON,10776,11}        
,{?LOOKS_TYPE_SETS,360,0}        
,{?LOOKS_TYPE_DRESS,16026,11}        
,{?LOOKS_TYPE_WING,18859,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16717,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,9280        
,31716        
,[{aspd,120},{defence,3592},{dmg_min,4374},{dmg_max,5467},{dmg_magic,459},{hitrate,338},{evasion,210},{critrate,364},{tenacity,234}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,120        
,36        
,[        
{?LOOKS_TYPE_WEAPON,10776,12}        
,{?LOOKS_TYPE_SETS,360,0}        
,{?LOOKS_TYPE_DRESS,16026,12}        
,{?LOOKS_TYPE_WING,18859,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16717,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,10600        
,37422        
,[{aspd,115},{defence,5027},{dmg_min,5194},{dmg_max,6492},{dmg_magic,532},{hitrate,376},{evasion,233},{critrate,422},{tenacity,285}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,80        
,31        
,[        
{?LOOKS_TYPE_WEAPON,10960,10}        
,{?LOOKS_TYPE_SETS,371,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,8000        
,29680        
,[{aspd,135},{defence,2400},{dmg_min,3378},{dmg_max,4222},{dmg_magic,500},{hitrate,350},{evasion,150},{critrate,300},{tenacity,90}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,80        
,32        
,[        
{?LOOKS_TYPE_WEAPON,10961,10}        
,{?LOOKS_TYPE_SETS,370,0}        
,{?LOOKS_TYPE_DRESS,16022,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,11000        
,43398        
,[{aspd,145},{defence,3217},{dmg_min,5232},{dmg_max,6540},{dmg_magic,620},{hitrate,417},{evasion,198},{critrate,444},{tenacity,283}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,90        
,33        
,[        
{?LOOKS_TYPE_WEAPON,10961,11}        
,{?LOOKS_TYPE_SETS,370,0}        
,{?LOOKS_TYPE_DRESS,16022,10}        
,{?LOOKS_TYPE_WING,18860,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,10}                ]        
,14000        
,57116        
,[{aspd,155},{defence,4228},{dmg_min,7087},{dmg_max,8858},{dmg_magic,740},{hitrate,484},{evasion,246},{critrate,588},{tenacity,476}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,100        
,34        
,[        
{?LOOKS_TYPE_WEAPON,10961,11}        
,{?LOOKS_TYPE_SETS,370,0}        
,{?LOOKS_TYPE_DRESS,16030,11}        
,{?LOOKS_TYPE_WING,18806,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16712,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,17000        
,70834        
,[{aspd,165},{defence,5501},{dmg_min,8941},{dmg_max,11176},{dmg_magic,860},{hitrate,551},{evasion,294},{critrate,732},{tenacity,669}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,110        
,35        
,[        
{?LOOKS_TYPE_WEAPON,10961,11}        
,{?LOOKS_TYPE_SETS,370,0}        
,{?LOOKS_TYPE_DRESS,16030,11}        
,{?LOOKS_TYPE_WING,18806,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16712,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,20000        
,84552        
,[{aspd,175},{defence,7137},{dmg_min,10795},{dmg_max,13493},{dmg_magic,980},{hitrate,618},{evasion,342},{critrate,876},{tenacity,862}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,120        
,36        
,[        
{?LOOKS_TYPE_WEAPON,10961,12}        
,{?LOOKS_TYPE_SETS,370,0}        
,{?LOOKS_TYPE_DRESS,16032,12}        
,{?LOOKS_TYPE_WING,18805,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16717,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,23000        
,98272        
,[{aspd,165},{defence,7900},{dmg_min,12650},{dmg_max,15812},{dmg_magic,1100},{hitrate,686},{evasion,390},{critrate,1020},{tenacity,1056}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,80        
,31        
,[        
{?LOOKS_TYPE_WEAPON,11145,10}        
,{?LOOKS_TYPE_SETS,381,0}        
,{?LOOKS_TYPE_DRESS,16010,10}        
,{?LOOKS_TYPE_WING,18853,10}                                ]        
,15000        
,80925        
,[{aspd,175},{defence,3338},{dmg_min,5284},{dmg_max,6605},{dmg_magic,772},{hitrate,500},{evasion,317},{critrate,609},{tenacity,457}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,80        
,32        
,[        
{?LOOKS_TYPE_WEAPON,11146,10}        
,{?LOOKS_TYPE_SETS,380,0}        
,{?LOOKS_TYPE_DRESS,16010,10}        
,{?LOOKS_TYPE_WING,18853,10}                                ]        
,18240        
,93816        
,[{aspd,180},{defence,4576},{dmg_min,7568},{dmg_max,9460},{dmg_magic,980},{hitrate,585},{evasion,363},{critrate,770},{tenacity,714}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,90        
,33        
,[        
{?LOOKS_TYPE_WEAPON,11146,11}        
,{?LOOKS_TYPE_SETS,380,0}        
,{?LOOKS_TYPE_DRESS,16032,10}        
,{?LOOKS_TYPE_WING,18805,10}        
,{?LOOKS_TYPE_WEAPON_DRESS,16717,10}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,10}                ]        
,21480        
,106707        
,[{aspd,185},{defence,6187},{dmg_min,9851},{dmg_max,12313},{dmg_magic,1188},{hitrate,670},{evasion,409},{critrate,931},{tenacity,971}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,100        
,34        
,[        
{?LOOKS_TYPE_WEAPON,11146,11}        
,{?LOOKS_TYPE_SETS,380,0}        
,{?LOOKS_TYPE_DRESS,16032,11}        
,{?LOOKS_TYPE_WING,18805,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16717,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,24720        
,119598        
,[{aspd,190},{defence,8349},{dmg_min,12135},{dmg_max,15168},{dmg_magic,1396},{hitrate,755},{evasion,455},{critrate,1092},{tenacity,1228}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,110        
,35        
,[        
{?LOOKS_TYPE_WEAPON,11146,11}        
,{?LOOKS_TYPE_SETS,380,0}        
,{?LOOKS_TYPE_DRESS,16028,11}        
,{?LOOKS_TYPE_WING,18857,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16707,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,27960        
,132489        
,[{aspd,195},{defence,11374},{dmg_min,14418},{dmg_max,18022},{dmg_magic,1604},{hitrate,840},{evasion,501},{critrate,1253},{tenacity,1485}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 3 andalso Sex =:= 1 ->
    {
        <<"幻灵.贤者">>        
,120        
,36        
,[        
{?LOOKS_TYPE_WEAPON,11146,12}        
,{?LOOKS_TYPE_SETS,380,0}        
,{?LOOKS_TYPE_DRESS,16028,12}        
,{?LOOKS_TYPE_WING,18857,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16707,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,31200        
,145380        
,[{aspd,190},{defence,12734},{dmg_min,16703},{dmg_max,20878},{dmg_magic,1810},{hitrate,926},{evasion,548},{critrate,1413},{tenacity,1744}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,80        
,31        
,[        
{?LOOKS_TYPE_WEAPON,10590,10}        
,{?LOOKS_TYPE_SETS,351,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,2000        
,3187        
,[{aspd,40},{defence,776},{dmg_min,513},{dmg_max,641},{dmg_magic,100},{hitrate,135},{evasion,0},{critrate,50},{tenacity,0}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,80        
,32        
,[        
{?LOOKS_TYPE_WEAPON,10591,10}        
,{?LOOKS_TYPE_SETS,350,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,2480        
,5325        
,[{aspd,45},{defence,893},{dmg_min,739},{dmg_max,923},{dmg_magic,112},{hitrate,145},{evasion,17},{critrate,74},{tenacity,12}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,90        
,33        
,[        
{?LOOKS_TYPE_WEAPON,10591,11}        
,{?LOOKS_TYPE_SETS,350,0}        
,{?LOOKS_TYPE_DRESS,16003,10}        
,{?LOOKS_TYPE_WING,18809,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,10}                ]        
,2960        
,7463        
,[{aspd,50},{defence,1018},{dmg_min,965},{dmg_max,1206},{dmg_magic,124},{hitrate,155},{evasion,34},{critrate,98},{tenacity,24}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,100        
,34        
,[        
{?LOOKS_TYPE_WEAPON,10591,11}        
,{?LOOKS_TYPE_SETS,350,0}        
,{?LOOKS_TYPE_DRESS,16003,11}        
,{?LOOKS_TYPE_WING,18809,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,3440        
,9601        
,[{aspd,55},{defence,1153},{dmg_min,1191},{dmg_max,1488},{dmg_magic,136},{hitrate,165},{evasion,51},{critrate,122},{tenacity,36}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,110        
,35        
,[        
{?LOOKS_TYPE_WEAPON,10591,11}        
,{?LOOKS_TYPE_SETS,350,0}        
,{?LOOKS_TYPE_DRESS,16027,11}        
,{?LOOKS_TYPE_WING,18807,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16702,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,3920        
,11739        
,[{aspd,60},{defence,1297},{dmg_min,1416},{dmg_max,1770},{dmg_magic,148},{hitrate,175},{evasion,68},{critrate,146},{tenacity,48}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,120        
,36        
,[        
{?LOOKS_TYPE_WEAPON,10591,12}        
,{?LOOKS_TYPE_SETS,350,0}        
,{?LOOKS_TYPE_DRESS,16027,12}        
,{?LOOKS_TYPE_WING,18807,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16702,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,4400        
,13876        
,[{aspd,55},{defence,1503},{dmg_min,1644},{dmg_max,2055},{dmg_magic,160},{hitrate,186},{evasion,84},{critrate,170},{tenacity,60}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,80        
,31        
,[        
{?LOOKS_TYPE_WEAPON,10775,10}        
,{?LOOKS_TYPE_SETS,361,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,4000        
,8892        
,[{aspd,100},{defence,1410},{dmg_min,1096},{dmg_max,1370},{dmg_magic,175},{hitrate,190},{evasion,110},{critrate,140},{tenacity,30}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,80        
,32        
,[        
{?LOOKS_TYPE_WEAPON,10776,10}        
,{?LOOKS_TYPE_SETS,360,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,5320        
,14598        
,[{aspd,105},{defence,1836},{dmg_min,1915},{dmg_max,2393},{dmg_magic,246},{hitrate,227},{evasion,135},{critrate,196},{tenacity,81}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,90        
,33        
,[        
{?LOOKS_TYPE_WEAPON,10776,11}        
,{?LOOKS_TYPE_SETS,360,0}        
,{?LOOKS_TYPE_DRESS,16015,10}        
,{?LOOKS_TYPE_WING,18806,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,10}                ]        
,6640        
,20304        
,[{aspd,110},{defence,2332},{dmg_min,2735},{dmg_max,3418},{dmg_magic,317},{hitrate,264},{evasion,160},{critrate,252},{tenacity,132}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,100        
,34        
,[        
{?LOOKS_TYPE_WEAPON,10776,11}        
,{?LOOKS_TYPE_SETS,360,0}        
,{?LOOKS_TYPE_DRESS,16015,11}        
,{?LOOKS_TYPE_WING,18806,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,7960        
,26010        
,[{aspd,115},{defence,2911},{dmg_min,3554},{dmg_max,4442},{dmg_magic,388},{hitrate,301},{evasion,185},{critrate,308},{tenacity,183}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,110        
,35        
,[        
{?LOOKS_TYPE_WEAPON,10776,11}        
,{?LOOKS_TYPE_SETS,360,0}        
,{?LOOKS_TYPE_DRESS,16025,11}        
,{?LOOKS_TYPE_WING,18858,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16717,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,9280        
,31716        
,[{aspd,120},{defence,3592},{dmg_min,4374},{dmg_max,5467},{dmg_magic,459},{hitrate,338},{evasion,210},{critrate,364},{tenacity,234}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,120        
,36        
,[        
{?LOOKS_TYPE_WEAPON,10776,12}        
,{?LOOKS_TYPE_SETS,360,0}        
,{?LOOKS_TYPE_DRESS,16025,12}        
,{?LOOKS_TYPE_WING,18858,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16717,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,10600        
,37422        
,[{aspd,115},{defence,5027},{dmg_min,5194},{dmg_max,6492},{dmg_magic,532},{hitrate,376},{evasion,233},{critrate,422},{tenacity,285}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,80        
,31        
,[        
{?LOOKS_TYPE_WEAPON,10960,10}        
,{?LOOKS_TYPE_SETS,371,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,8000        
,29680        
,[{aspd,135},{defence,2400},{dmg_min,3378},{dmg_max,4222},{dmg_magic,500},{hitrate,350},{evasion,150},{critrate,300},{tenacity,90}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,80        
,32        
,[        
{?LOOKS_TYPE_WEAPON,10961,10}        
,{?LOOKS_TYPE_SETS,370,0}        
,{?LOOKS_TYPE_DRESS,16011,10}        
,{?LOOKS_TYPE_WING,18854,10}                                ]        
,11000        
,43398        
,[{aspd,145},{defence,3217},{dmg_min,5232},{dmg_max,6540},{dmg_magic,620},{hitrate,417},{evasion,198},{critrate,444},{tenacity,283}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,90        
,33        
,[        
{?LOOKS_TYPE_WEAPON,10961,11}        
,{?LOOKS_TYPE_SETS,370,0}        
,{?LOOKS_TYPE_DRESS,16011,10}        
,{?LOOKS_TYPE_WING,18854,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,10}                ]        
,14000        
,57116        
,[{aspd,155},{defence,4228},{dmg_min,7087},{dmg_max,8858},{dmg_magic,740},{hitrate,484},{evasion,246},{critrate,588},{tenacity,476}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,100        
,34        
,[        
{?LOOKS_TYPE_WEAPON,10961,11}        
,{?LOOKS_TYPE_SETS,370,0}        
,{?LOOKS_TYPE_DRESS,16031,11}        
,{?LOOKS_TYPE_WING,18855,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16712,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,17000        
,70834        
,[{aspd,165},{defence,5501},{dmg_min,8941},{dmg_max,11176},{dmg_magic,860},{hitrate,551},{evasion,294},{critrate,732},{tenacity,669}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,110        
,35        
,[        
{?LOOKS_TYPE_WEAPON,10961,11}        
,{?LOOKS_TYPE_SETS,370,0}        
,{?LOOKS_TYPE_DRESS,16031,11}        
,{?LOOKS_TYPE_WING,18855,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16712,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,20000        
,84552        
,[{aspd,175},{defence,7137},{dmg_min,10795},{dmg_max,13493},{dmg_magic,980},{hitrate,618},{evasion,342},{critrate,876},{tenacity,862}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,120        
,36        
,[        
{?LOOKS_TYPE_WEAPON,10961,12}        
,{?LOOKS_TYPE_SETS,370,0}        
,{?LOOKS_TYPE_DRESS,16033,12}        
,{?LOOKS_TYPE_WING,18856,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16717,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,23000        
,98272        
,[{aspd,165},{defence,7900},{dmg_min,12650},{dmg_max,15812},{dmg_magic,1100},{hitrate,686},{evasion,390},{critrate,1020},{tenacity,1056}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,80        
,31        
,[        
{?LOOKS_TYPE_WEAPON,11145,10}        
,{?LOOKS_TYPE_SETS,381,0}        
,{?LOOKS_TYPE_DRESS,16023,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,15000        
,80925        
,[{aspd,175},{defence,3338},{dmg_min,5284},{dmg_max,6605},{dmg_magic,772},{hitrate,500},{evasion,317},{critrate,609},{tenacity,457}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,80        
,32        
,[        
{?LOOKS_TYPE_WEAPON,11146,10}        
,{?LOOKS_TYPE_SETS,380,0}        
,{?LOOKS_TYPE_DRESS,16023,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,18240        
,93816        
,[{aspd,180},{defence,4576},{dmg_min,7568},{dmg_max,9460},{dmg_magic,980},{hitrate,585},{evasion,363},{critrate,770},{tenacity,714}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,90        
,33        
,[        
{?LOOKS_TYPE_WEAPON,11146,11}        
,{?LOOKS_TYPE_SETS,380,0}        
,{?LOOKS_TYPE_DRESS,16033,10}        
,{?LOOKS_TYPE_WING,18856,10}        
,{?LOOKS_TYPE_WEAPON_DRESS,16717,10}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,10}                ]        
,21480        
,106707        
,[{aspd,185},{defence,6187},{dmg_min,9851},{dmg_max,12313},{dmg_magic,1188},{hitrate,670},{evasion,409},{critrate,931},{tenacity,971}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,100        
,34        
,[        
{?LOOKS_TYPE_WEAPON,11146,11}        
,{?LOOKS_TYPE_SETS,380,0}        
,{?LOOKS_TYPE_DRESS,16033,11}        
,{?LOOKS_TYPE_WING,18856,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16717,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,24720        
,119598        
,[{aspd,190},{defence,8349},{dmg_min,12135},{dmg_max,15168},{dmg_magic,1396},{hitrate,755},{evasion,455},{critrate,1092},{tenacity,1228}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,110        
,35        
,[        
{?LOOKS_TYPE_WEAPON,11146,11}        
,{?LOOKS_TYPE_SETS,380,0}        
,{?LOOKS_TYPE_DRESS,16029,11}        
,{?LOOKS_TYPE_WING,18857,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16707,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,27960        
,132489        
,[{aspd,195},{defence,11374},{dmg_min,14418},{dmg_max,18022},{dmg_magic,1604},{hitrate,840},{evasion,501},{critrate,1253},{tenacity,1485}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 3 andalso Sex =:= 0 ->
    {
        <<"幻灵.贤者">>        
,120        
,36        
,[        
{?LOOKS_TYPE_WEAPON,11146,12}        
,{?LOOKS_TYPE_SETS,380,0}        
,{?LOOKS_TYPE_DRESS,16029,12}        
,{?LOOKS_TYPE_WING,18857,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16707,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,31200        
,145380        
,[{aspd,190},{defence,12734},{dmg_min,16703},{dmg_max,20878},{dmg_magic,1810},{hitrate,926},{evasion,548},{critrate,1413},{tenacity,1744}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,80        
,51        
,[        
{?LOOKS_TYPE_WEAPON,10580,10}        
,{?LOOKS_TYPE_SETS,551,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,2000        
,3187        
,[{aspd,40},{defence,776},{dmg_min,513},{dmg_max,641},{dmg_magic,100},{hitrate,135},{evasion,0},{critrate,50},{tenacity,0}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,80        
,52        
,[        
{?LOOKS_TYPE_WEAPON,10581,10}        
,{?LOOKS_TYPE_SETS,550,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,2480        
,5325        
,[{aspd,45},{defence,893},{dmg_min,739},{dmg_max,923},{dmg_magic,112},{hitrate,145},{evasion,17},{critrate,74},{tenacity,12}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,90        
,53        
,[        
{?LOOKS_TYPE_WEAPON,10581,11}        
,{?LOOKS_TYPE_SETS,550,0}        
,{?LOOKS_TYPE_DRESS,16008,10}        
,{?LOOKS_TYPE_WING,18805,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16904,10}                ]        
,2960        
,7463        
,[{aspd,50},{defence,1018},{dmg_min,965},{dmg_max,1206},{dmg_magic,124},{hitrate,155},{evasion,34},{critrate,98},{tenacity,24}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,100        
,54        
,[        
{?LOOKS_TYPE_WEAPON,10581,11}        
,{?LOOKS_TYPE_SETS,550,0}        
,{?LOOKS_TYPE_DRESS,16008,11}        
,{?LOOKS_TYPE_WING,18805,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16904,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,3440        
,9601        
,[{aspd,55},{defence,1153},{dmg_min,1191},{dmg_max,1488},{dmg_magic,136},{hitrate,165},{evasion,51},{critrate,122},{tenacity,36}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,110        
,55        
,[        
{?LOOKS_TYPE_WEAPON,10581,11}        
,{?LOOKS_TYPE_SETS,550,0}        
,{?LOOKS_TYPE_DRESS,16024,11}        
,{?LOOKS_TYPE_WING,18854,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16704,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,3920        
,11739        
,[{aspd,60},{defence,1297},{dmg_min,1416},{dmg_max,1770},{dmg_magic,148},{hitrate,175},{evasion,68},{critrate,146},{tenacity,48}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,120        
,56        
,[        
{?LOOKS_TYPE_WEAPON,10581,12}        
,{?LOOKS_TYPE_SETS,550,0}        
,{?LOOKS_TYPE_DRESS,16024,12}        
,{?LOOKS_TYPE_WING,18854,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16704,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,4400        
,13876        
,[{aspd,55},{defence,1503},{dmg_min,1644},{dmg_max,2055},{dmg_magic,160},{hitrate,186},{evasion,84},{critrate,170},{tenacity,60}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,80        
,51        
,[        
{?LOOKS_TYPE_WEAPON,10765,10}        
,{?LOOKS_TYPE_SETS,561,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,4000        
,8892        
,[{aspd,100},{defence,1410},{dmg_min,1096},{dmg_max,1370},{dmg_magic,175},{hitrate,190},{evasion,110},{critrate,140},{tenacity,30}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,80        
,52        
,[        
{?LOOKS_TYPE_WEAPON,10766,10}        
,{?LOOKS_TYPE_SETS,560,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,5320        
,14598        
,[{aspd,105},{defence,1836},{dmg_min,1915},{dmg_max,2393},{dmg_magic,246},{hitrate,227},{evasion,135},{critrate,196},{tenacity,81}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,90        
,53        
,[        
{?LOOKS_TYPE_WEAPON,10766,11}        
,{?LOOKS_TYPE_SETS,560,0}        
,{?LOOKS_TYPE_DRESS,16020,10}        
,{?LOOKS_TYPE_WING,18809,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,10}                ]        
,6640        
,20304        
,[{aspd,110},{defence,2332},{dmg_min,2735},{dmg_max,3418},{dmg_magic,317},{hitrate,264},{evasion,160},{critrate,252},{tenacity,132}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,100        
,54        
,[        
{?LOOKS_TYPE_WEAPON,10766,11}        
,{?LOOKS_TYPE_SETS,560,0}        
,{?LOOKS_TYPE_DRESS,16020,11}        
,{?LOOKS_TYPE_WING,18809,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,7960        
,26010        
,[{aspd,115},{defence,2911},{dmg_min,3554},{dmg_max,4442},{dmg_magic,388},{hitrate,301},{evasion,185},{critrate,308},{tenacity,183}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,110        
,55        
,[        
{?LOOKS_TYPE_WEAPON,10766,11}        
,{?LOOKS_TYPE_SETS,560,0}        
,{?LOOKS_TYPE_DRESS,16026,11}        
,{?LOOKS_TYPE_WING,18859,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16719,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,9280        
,31716        
,[{aspd,120},{defence,3592},{dmg_min,4374},{dmg_max,5467},{dmg_magic,459},{hitrate,338},{evasion,210},{critrate,364},{tenacity,234}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,120        
,56        
,[        
{?LOOKS_TYPE_WEAPON,10766,12}        
,{?LOOKS_TYPE_SETS,560,0}        
,{?LOOKS_TYPE_DRESS,16026,12}        
,{?LOOKS_TYPE_WING,18859,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16719,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,10600        
,37422        
,[{aspd,115},{defence,5027},{dmg_min,5194},{dmg_max,6492},{dmg_magic,532},{hitrate,376},{evasion,233},{critrate,422},{tenacity,285}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,80        
,51        
,[        
{?LOOKS_TYPE_WEAPON,10950,10}        
,{?LOOKS_TYPE_SETS,571,0}                
,{?LOOKS_TYPE_WING,18852,10}                                ]        
,8000        
,29680        
,[{aspd,135},{defence,2400},{dmg_min,3378},{dmg_max,4222},{dmg_magic,500},{hitrate,350},{evasion,150},{critrate,300},{tenacity,90}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,80        
,52        
,[        
{?LOOKS_TYPE_WEAPON,10951,10}        
,{?LOOKS_TYPE_SETS,570,0}        
,{?LOOKS_TYPE_DRESS,16022,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,11000        
,43398        
,[{aspd,145},{defence,3217},{dmg_min,5232},{dmg_max,6540},{dmg_magic,620},{hitrate,417},{evasion,198},{critrate,444},{tenacity,283}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,90        
,53        
,[        
{?LOOKS_TYPE_WEAPON,10951,11}        
,{?LOOKS_TYPE_SETS,570,0}        
,{?LOOKS_TYPE_DRESS,16022,10}        
,{?LOOKS_TYPE_WING,18860,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,10}                ]        
,14000        
,57116        
,[{aspd,155},{defence,4228},{dmg_min,7087},{dmg_max,8858},{dmg_magic,740},{hitrate,484},{evasion,246},{critrate,588},{tenacity,476}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,100        
,54        
,[        
{?LOOKS_TYPE_WEAPON,10951,11}        
,{?LOOKS_TYPE_SETS,570,0}        
,{?LOOKS_TYPE_DRESS,16030,11}        
,{?LOOKS_TYPE_WING,18806,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16714,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,17000        
,70834        
,[{aspd,165},{defence,5501},{dmg_min,8941},{dmg_max,11176},{dmg_magic,860},{hitrate,551},{evasion,294},{critrate,732},{tenacity,669}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,110        
,55        
,[        
{?LOOKS_TYPE_WEAPON,10951,11}        
,{?LOOKS_TYPE_SETS,570,0}        
,{?LOOKS_TYPE_DRESS,16030,11}        
,{?LOOKS_TYPE_WING,18806,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16714,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,20000        
,84552        
,[{aspd,175},{defence,7137},{dmg_min,10795},{dmg_max,13493},{dmg_magic,980},{hitrate,618},{evasion,342},{critrate,876},{tenacity,862}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,120        
,56        
,[        
{?LOOKS_TYPE_WEAPON,10951,12}        
,{?LOOKS_TYPE_SETS,570,0}        
,{?LOOKS_TYPE_DRESS,16032,12}        
,{?LOOKS_TYPE_WING,18805,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16719,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,23000        
,98272        
,[{aspd,165},{defence,7900},{dmg_min,12650},{dmg_max,15812},{dmg_magic,1100},{hitrate,686},{evasion,390},{critrate,1020},{tenacity,1056}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,80        
,51        
,[        
{?LOOKS_TYPE_WEAPON,11135,10}        
,{?LOOKS_TYPE_SETS,581,0}        
,{?LOOKS_TYPE_DRESS,16010,10}        
,{?LOOKS_TYPE_WING,18853,10}                                ]        
,15000        
,80925        
,[{aspd,175},{defence,3338},{dmg_min,5284},{dmg_max,6605},{dmg_magic,772},{hitrate,500},{evasion,317},{critrate,609},{tenacity,457}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,80        
,52        
,[        
{?LOOKS_TYPE_WEAPON,11136,10}        
,{?LOOKS_TYPE_SETS,580,0}        
,{?LOOKS_TYPE_DRESS,16010,10}        
,{?LOOKS_TYPE_WING,18853,10}                                ]        
,18240        
,93816        
,[{aspd,180},{defence,4576},{dmg_min,7568},{dmg_max,9460},{dmg_magic,980},{hitrate,585},{evasion,363},{critrate,770},{tenacity,714}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,90        
,53        
,[        
{?LOOKS_TYPE_WEAPON,11136,11}        
,{?LOOKS_TYPE_SETS,580,0}        
,{?LOOKS_TYPE_DRESS,16032,10}        
,{?LOOKS_TYPE_WING,18805,10}        
,{?LOOKS_TYPE_WEAPON_DRESS,16719,10}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,10}                ]        
,21480        
,106707        
,[{aspd,185},{defence,6187},{dmg_min,9851},{dmg_max,12313},{dmg_magic,1188},{hitrate,670},{evasion,409},{critrate,931},{tenacity,971}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,100        
,54        
,[        
{?LOOKS_TYPE_WEAPON,11136,11}        
,{?LOOKS_TYPE_SETS,580,0}        
,{?LOOKS_TYPE_DRESS,16032,11}        
,{?LOOKS_TYPE_WING,18805,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16719,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,24720        
,119598        
,[{aspd,190},{defence,8349},{dmg_min,12135},{dmg_max,15168},{dmg_magic,1396},{hitrate,755},{evasion,455},{critrate,1092},{tenacity,1228}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,110        
,55        
,[        
{?LOOKS_TYPE_WEAPON,11136,11}        
,{?LOOKS_TYPE_SETS,580,0}        
,{?LOOKS_TYPE_DRESS,16028,11}        
,{?LOOKS_TYPE_WING,18857,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16709,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,27960        
,132489        
,[{aspd,195},{defence,11374},{dmg_min,14418},{dmg_max,18022},{dmg_magic,1604},{hitrate,840},{evasion,501},{critrate,1253},{tenacity,1485}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 5 andalso Sex =:= 1 ->
    {
        <<"幻灵.骑士">>        
,120        
,56        
,[        
{?LOOKS_TYPE_WEAPON,11136,12}        
,{?LOOKS_TYPE_SETS,580,0}        
,{?LOOKS_TYPE_DRESS,16028,12}        
,{?LOOKS_TYPE_WING,18857,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16709,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,31200        
,145380        
,[{aspd,190},{defence,12734},{dmg_min,16703},{dmg_max,20878},{dmg_magic,1810},{hitrate,926},{evasion,548},{critrate,1413},{tenacity,1744}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,80        
,51        
,[        
{?LOOKS_TYPE_WEAPON,10580,10}        
,{?LOOKS_TYPE_SETS,551,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,2000        
,3187        
,[{aspd,40},{defence,776},{dmg_min,513},{dmg_max,641},{dmg_magic,100},{hitrate,135},{evasion,0},{critrate,50},{tenacity,0}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,80        
,52        
,[        
{?LOOKS_TYPE_WEAPON,10581,10}        
,{?LOOKS_TYPE_SETS,550,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,2480        
,5325        
,[{aspd,45},{defence,893},{dmg_min,739},{dmg_max,923},{dmg_magic,112},{hitrate,145},{evasion,17},{critrate,74},{tenacity,12}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,90        
,53        
,[        
{?LOOKS_TYPE_WEAPON,10581,11}        
,{?LOOKS_TYPE_SETS,550,0}        
,{?LOOKS_TYPE_DRESS,16009,10}        
,{?LOOKS_TYPE_WING,18854,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,10}                ]        
,2960        
,7463        
,[{aspd,50},{defence,1018},{dmg_min,965},{dmg_max,1206},{dmg_magic,124},{hitrate,155},{evasion,34},{critrate,98},{tenacity,24}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,100        
,54        
,[        
{?LOOKS_TYPE_WEAPON,10581,11}        
,{?LOOKS_TYPE_SETS,550,0}        
,{?LOOKS_TYPE_DRESS,16009,11}        
,{?LOOKS_TYPE_WING,18854,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16903,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,3440        
,9601        
,[{aspd,55},{defence,1153},{dmg_min,1191},{dmg_max,1488},{dmg_magic,136},{hitrate,165},{evasion,51},{critrate,122},{tenacity,36}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,110        
,55        
,[        
{?LOOKS_TYPE_WEAPON,10581,11}        
,{?LOOKS_TYPE_SETS,550,0}        
,{?LOOKS_TYPE_DRESS,16027,11}        
,{?LOOKS_TYPE_WING,18807,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16704,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,3920        
,11739        
,[{aspd,60},{defence,1297},{dmg_min,1416},{dmg_max,1770},{dmg_magic,148},{hitrate,175},{evasion,68},{critrate,146},{tenacity,48}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 40 andalso Lev =< 49 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,120        
,56        
,[        
{?LOOKS_TYPE_WEAPON,10581,12}        
,{?LOOKS_TYPE_SETS,550,0}        
,{?LOOKS_TYPE_DRESS,16027,12}        
,{?LOOKS_TYPE_WING,18807,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16704,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,4400        
,13876        
,[{aspd,55},{defence,1503},{dmg_min,1644},{dmg_max,2055},{dmg_magic,160},{hitrate,186},{evasion,84},{critrate,170},{tenacity,60}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,80        
,51        
,[        
{?LOOKS_TYPE_WEAPON,10765,10}        
,{?LOOKS_TYPE_SETS,561,0}                
,{?LOOKS_TYPE_WING,18851,10}                                ]        
,4000        
,8892        
,[{aspd,100},{defence,1410},{dmg_min,1096},{dmg_max,1370},{dmg_magic,175},{hitrate,190},{evasion,110},{critrate,140},{tenacity,30}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,80        
,52        
,[        
{?LOOKS_TYPE_WEAPON,10766,10}        
,{?LOOKS_TYPE_SETS,560,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,5320        
,14598        
,[{aspd,105},{defence,1836},{dmg_min,1915},{dmg_max,2393},{dmg_magic,246},{hitrate,227},{evasion,135},{critrate,196},{tenacity,81}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,90        
,53        
,[        
{?LOOKS_TYPE_WEAPON,10766,11}        
,{?LOOKS_TYPE_SETS,560,0}        
,{?LOOKS_TYPE_DRESS,16021,10}        
,{?LOOKS_TYPE_WING,18853,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,10}                ]        
,6640        
,20304        
,[{aspd,110},{defence,2332},{dmg_min,2735},{dmg_max,3418},{dmg_magic,317},{hitrate,264},{evasion,160},{critrate,252},{tenacity,132}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,100        
,54        
,[        
{?LOOKS_TYPE_WEAPON,10766,11}        
,{?LOOKS_TYPE_SETS,560,0}        
,{?LOOKS_TYPE_DRESS,16021,11}        
,{?LOOKS_TYPE_WING,18853,11}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16902,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,7960        
,26010        
,[{aspd,115},{defence,2911},{dmg_min,3554},{dmg_max,4442},{dmg_magic,388},{hitrate,301},{evasion,185},{critrate,308},{tenacity,183}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,110        
,55        
,[        
{?LOOKS_TYPE_WEAPON,10766,11}        
,{?LOOKS_TYPE_SETS,560,0}        
,{?LOOKS_TYPE_DRESS,16025,11}        
,{?LOOKS_TYPE_WING,18858,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16719,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,9280        
,31716        
,[{aspd,120},{defence,3592},{dmg_min,4374},{dmg_max,5467},{dmg_magic,459},{hitrate,338},{evasion,210},{critrate,364},{tenacity,234}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 50 andalso Lev =< 59 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,120        
,56        
,[        
{?LOOKS_TYPE_WEAPON,10766,12}        
,{?LOOKS_TYPE_SETS,560,0}        
,{?LOOKS_TYPE_DRESS,16025,12}        
,{?LOOKS_TYPE_WING,18858,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16719,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,10600        
,37422        
,[{aspd,115},{defence,5027},{dmg_min,5194},{dmg_max,6492},{dmg_magic,532},{hitrate,376},{evasion,233},{critrate,422},{tenacity,285}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,80        
,51        
,[        
{?LOOKS_TYPE_WEAPON,10950,10}        
,{?LOOKS_TYPE_SETS,571,0}                
,{?LOOKS_TYPE_WING,18804,10}                                ]        
,8000        
,29680        
,[{aspd,135},{defence,2400},{dmg_min,3378},{dmg_max,4222},{dmg_magic,500},{hitrate,350},{evasion,150},{critrate,300},{tenacity,90}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,80        
,52        
,[        
{?LOOKS_TYPE_WEAPON,10951,10}        
,{?LOOKS_TYPE_SETS,570,0}        
,{?LOOKS_TYPE_DRESS,16011,10}        
,{?LOOKS_TYPE_WING,18854,10}                                ]        
,11000        
,43398        
,[{aspd,145},{defence,3217},{dmg_min,5232},{dmg_max,6540},{dmg_magic,620},{hitrate,417},{evasion,198},{critrate,444},{tenacity,283}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,90        
,53        
,[        
{?LOOKS_TYPE_WEAPON,10951,11}        
,{?LOOKS_TYPE_SETS,570,0}        
,{?LOOKS_TYPE_DRESS,16011,10}        
,{?LOOKS_TYPE_WING,18854,10}                
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,10}                ]        
,14000        
,57116        
,[{aspd,155},{defence,4228},{dmg_min,7087},{dmg_max,8858},{dmg_magic,740},{hitrate,484},{evasion,246},{critrate,588},{tenacity,476}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,100        
,54        
,[        
{?LOOKS_TYPE_WEAPON,10951,11}        
,{?LOOKS_TYPE_SETS,570,0}        
,{?LOOKS_TYPE_DRESS,16031,11}        
,{?LOOKS_TYPE_WING,18855,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16714,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16901,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,17000        
,70834        
,[{aspd,165},{defence,5501},{dmg_min,8941},{dmg_max,11176},{dmg_magic,860},{hitrate,551},{evasion,294},{critrate,732},{tenacity,669}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,110        
,55        
,[        
{?LOOKS_TYPE_WEAPON,10951,11}        
,{?LOOKS_TYPE_SETS,570,0}        
,{?LOOKS_TYPE_DRESS,16031,11}        
,{?LOOKS_TYPE_WING,18855,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16714,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,20000        
,84552        
,[{aspd,175},{defence,7137},{dmg_min,10795},{dmg_max,13493},{dmg_magic,980},{hitrate,618},{evasion,342},{critrate,876},{tenacity,862}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 60 andalso Lev =< 69 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,120        
,56        
,[        
{?LOOKS_TYPE_WEAPON,10951,12}        
,{?LOOKS_TYPE_SETS,570,0}        
,{?LOOKS_TYPE_DRESS,16033,12}        
,{?LOOKS_TYPE_WING,18856,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16719,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,23000        
,98272        
,[{aspd,165},{defence,7900},{dmg_min,12650},{dmg_max,15812},{dmg_magic,1100},{hitrate,686},{evasion,390},{critrate,1020},{tenacity,1056}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 1 andalso Num =< 1 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,80        
,51        
,[        
{?LOOKS_TYPE_WEAPON,11135,10}        
,{?LOOKS_TYPE_SETS,581,0}        
,{?LOOKS_TYPE_DRESS,16023,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,15000        
,80925        
,[{aspd,175},{defence,3338},{dmg_min,5284},{dmg_max,6605},{dmg_magic,772},{hitrate,500},{evasion,317},{critrate,609},{tenacity,457}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 2 andalso Num =< 5 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,80        
,52        
,[        
{?LOOKS_TYPE_WEAPON,11136,10}        
,{?LOOKS_TYPE_SETS,580,0}        
,{?LOOKS_TYPE_DRESS,16023,10}        
,{?LOOKS_TYPE_WING,18860,10}                                ]        
,18240        
,93816        
,[{aspd,180},{defence,4576},{dmg_min,7568},{dmg_max,9460},{dmg_magic,980},{hitrate,585},{evasion,363},{critrate,770},{tenacity,714}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 6 andalso Num =< 10 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,90        
,53        
,[        
{?LOOKS_TYPE_WEAPON,11136,11}        
,{?LOOKS_TYPE_SETS,580,0}        
,{?LOOKS_TYPE_DRESS,16033,10}        
,{?LOOKS_TYPE_WING,18856,10}        
,{?LOOKS_TYPE_WEAPON_DRESS,16719,10}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,10}                ]        
,21480        
,106707        
,[{aspd,185},{defence,6187},{dmg_min,9851},{dmg_max,12313},{dmg_magic,1188},{hitrate,670},{evasion,409},{critrate,931},{tenacity,971}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 11 andalso Num =< 20 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,100        
,54        
,[        
{?LOOKS_TYPE_WEAPON,11136,11}        
,{?LOOKS_TYPE_SETS,580,0}        
,{?LOOKS_TYPE_DRESS,16033,11}        
,{?LOOKS_TYPE_WING,18856,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16719,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16905,11}        
,{?LOOKS_TYPE_ALL,0,21}        ]        
,24720        
,119598        
,[{aspd,190},{defence,8349},{dmg_min,12135},{dmg_max,15168},{dmg_magic,1396},{hitrate,755},{evasion,455},{critrate,1092},{tenacity,1228}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 21 andalso Num =< 30 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,110        
,55        
,[        
{?LOOKS_TYPE_WEAPON,11136,11}        
,{?LOOKS_TYPE_SETS,580,0}        
,{?LOOKS_TYPE_DRESS,16029,11}        
,{?LOOKS_TYPE_WING,18857,11}        
,{?LOOKS_TYPE_WEAPON_DRESS,16709,11}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,11}        
,{?LOOKS_TYPE_ALL,0,22}        ]        
,27960        
,132489        
,[{aspd,195},{defence,11374},{dmg_min,14418},{dmg_max,18022},{dmg_magic,1604},{hitrate,840},{evasion,501},{critrate,1253},{tenacity,1485}]    };
get_foe(Lev, Num, Career, Sex) when Lev >= 70 andalso Lev =< 99 andalso Num >= 31 andalso Num =< 999999 andalso Career =:= 5 andalso Sex =:= 0 ->
    {
        <<"幻灵.骑士">>        
,120        
,56        
,[        
{?LOOKS_TYPE_WEAPON,11136,12}        
,{?LOOKS_TYPE_SETS,580,0}        
,{?LOOKS_TYPE_DRESS,16029,12}        
,{?LOOKS_TYPE_WING,18857,12}        
,{?LOOKS_TYPE_WEAPON_DRESS,16709,12}        
,{?LOOKS_TYPE_JEWELRY_DRESS,16900,12}        
,{?LOOKS_TYPE_ALL,0,23}        ]        
,31200        
,145380        
,[{aspd,190},{defence,12734},{dmg_min,16703},{dmg_max,20878},{dmg_magic,1810},{hitrate,926},{evasion,548},{critrate,1413},{tenacity,1744}]    };
get_foe(_Lev, _Num, _Career, _Sex) -> false.
