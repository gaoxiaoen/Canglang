%% -----------------------------------
%% 灵魂水晶配置表
%% @author lishen@jieyou.cn
%% -----------------------------------
-module(soul_mark_data).
-export([
        get_effect/1
        ,get_exp/1
    ]).

%% 获取灵魂刻印加成数值
get_effect(0) -> 0;
get_effect(1) -> 0.4;
get_effect(2) -> 0.8;
get_effect(3) -> 1.2000000000000002;
get_effect(4) -> 1.6;
get_effect(5) -> 2;
get_effect(6) -> 2.4;
get_effect(7) -> 2.8;
get_effect(8) -> 3.1999999999999997;
get_effect(9) -> 3.5999999999999996;
get_effect(10) -> 3.9999999999999996;
get_effect(11) -> 4.3999999999999995;
get_effect(12) -> 4.8;
get_effect(13) -> 5.2;
get_effect(14) -> 5.6000000000000005;
get_effect(15) -> 6.0000000000000009;
get_effect(16) -> 6.4000000000000012;
get_effect(17) -> 6.8000000000000016;
get_effect(18) -> 7.200000000000002;
get_effect(19) -> 7.6000000000000023;
get_effect(20) -> 8.0000000000000018;
get_effect(21) -> 8.4000000000000021;
get_effect(22) -> 8.8000000000000025;
get_effect(23) -> 9.2000000000000028;
get_effect(24) -> 9.6000000000000032;
get_effect(25) -> 10.000000000000004;
get_effect(26) -> 10.400000000000004;
get_effect(27) -> 10.800000000000004;
get_effect(28) -> 11.200000000000005;
get_effect(29) -> 11.600000000000005;
get_effect(30) -> 12.000000000000005;
get_effect(31) -> 12.400000000000006;
get_effect(32) -> 12.800000000000006;
get_effect(33) -> 13.200000000000006;
get_effect(34) -> 13.600000000000007;
get_effect(35) -> 14.000000000000007;
get_effect(36) -> 14.400000000000007;
get_effect(37) -> 14.800000000000008;
get_effect(38) -> 15.200000000000008;
get_effect(39) -> 15.600000000000009;
get_effect(40) -> 16.000000000000007;
get_effect(41) -> 16.400000000000006;
get_effect(42) -> 16.800000000000004;
get_effect(43) -> 17.200000000000003;
get_effect(44) -> 17.600000000000001;
get_effect(45) -> 18;
get_effect(46) -> 18.399999999999999;
get_effect(47) -> 18.799999999999997;
get_effect(48) -> 19.199999999999996;
get_effect(49) -> 19.599999999999994;
get_effect(50) -> 19.999999999999993;
get_effect(_) -> 0.

%% 获取灵魂刻印升级经验
get_exp(0) -> 10;
get_exp(1) -> 15;
get_exp(2) -> 20;
get_exp(3) -> 25;
get_exp(4) -> 30;
get_exp(5) -> 35;
get_exp(6) -> 40;
get_exp(7) -> 45;
get_exp(8) -> 50;
get_exp(9) -> 55;
get_exp(10) -> 60;
get_exp(11) -> 65;
get_exp(12) -> 70;
get_exp(13) -> 75;
get_exp(14) -> 80;
get_exp(15) -> 85;
get_exp(16) -> 90;
get_exp(17) -> 95;
get_exp(18) -> 100;
get_exp(19) -> 105;
get_exp(20) -> 110;
get_exp(21) -> 115;
get_exp(22) -> 120;
get_exp(23) -> 125;
get_exp(24) -> 130;
get_exp(25) -> 135;
get_exp(26) -> 140;
get_exp(27) -> 145;
get_exp(28) -> 150;
get_exp(29) -> 155;
get_exp(30) -> 160;
get_exp(31) -> 165;
get_exp(32) -> 170;
get_exp(33) -> 175;
get_exp(34) -> 180;
get_exp(35) -> 185;
get_exp(36) -> 190;
get_exp(37) -> 195;
get_exp(38) -> 200;
get_exp(39) -> 205;
get_exp(40) -> 210;
get_exp(41) -> 215;
get_exp(42) -> 220;
get_exp(43) -> 225;
get_exp(44) -> 230;
get_exp(45) -> 235;
get_exp(46) -> 240;
get_exp(47) -> 245;
get_exp(48) -> 250;
get_exp(49) -> 255;
get_exp(_) -> 999999.
