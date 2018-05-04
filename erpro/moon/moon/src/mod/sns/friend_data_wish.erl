%%----------------------------------------------------
%% @doc 好友祝福经验
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(friend_data_wish).
-export([
        wish/1
        ,wished/1
    ]
).
%% 祝福人经验
wish(1) -> 10;
wish(2) -> 30;
wish(3) -> 50;
wish(4) -> 70;
wish(5) -> 90;
wish(6) -> 100;
wish(7) -> 200;
wish(8) -> 300;
wish(9) -> 400;
wish(10) -> 500;
wish(11) -> 600;
wish(12) -> 700;
wish(13) -> 800;
wish(14) -> 900;
wish(15) -> 1000;
wish(16) -> 1010;
wish(17) -> 1020;
wish(18) -> 1030;
wish(19) -> 1040;
wish(20) -> 1050;
wish(21) -> 1060;
wish(22) -> 1070;
wish(23) -> 1080;
wish(24) -> 1090;
wish(25) -> 1100;
wish(26) -> 1110;
wish(27) -> 1120;
wish(28) -> 1130;
wish(29) -> 1140;
wish(30) -> 1150;
wish(31) -> 1160;
wish(32) -> 1170;
wish(33) -> 1180;
wish(34) -> 1190;
wish(35) -> 1200;
wish(36) -> 1210;
wish(37) -> 1220;
wish(38) -> 1230;
wish(39) -> 1240;
wish(40) -> 1250;
wish(41) -> 1300;
wish(42) -> 1350;
wish(43) -> 1400;
wish(44) -> 1450;
wish(45) -> 1500;
wish(46) -> 1550;
wish(47) -> 1600;
wish(48) -> 1650;
wish(49) -> 1700;
wish(50) -> 1750;
wish(51) -> 1800;
wish(52) -> 1850;
wish(53) -> 1900;
wish(54) -> 1950;
wish(55) -> 2000;
wish(56) -> 2050;
wish(57) -> 2100;
wish(58) -> 2150;
wish(59) -> 2200;
wish(60) -> 2250;
wish(61) -> 2300;
wish(62) -> 2350;
wish(63) -> 2400;
wish(64) -> 2450;
wish(65) -> 2500;
wish(66) -> 2550;
wish(67) -> 2600;
wish(68) -> 2650;
wish(69) -> 2700;
wish(70) -> 2750;
wish(71) -> 2800;
wish(72) -> 2850;
wish(73) -> 2900;
wish(74) -> 2950;
wish(75) -> 3000;
wish(76) -> 3050;
wish(77) -> 3100;
wish(78) -> 3150;
wish(79) -> 3200;
wish(80) -> 3250;
wish(Lev) when Lev > 80 -> 3250;
wish(_) -> false.

%% 被祝福人经验
wished(15) -> 1500;
wished(20) -> 1575;
wished(25) -> 1650;
wished(30) -> 1725;
wished(35) -> 1800;
wished(40) -> 1875;
wished(41) -> 1950;
wished(42) -> 2025;
wished(43) -> 2100;
wished(44) -> 2175;
wished(45) -> 2250;
wished(46) -> 2325;
wished(47) -> 2400;
wished(48) -> 2475;
wished(49) -> 2550;
wished(50) -> 2625;
wished(51) -> 2700;
wished(52) -> 2775;
wished(53) -> 2850;
wished(54) -> 2925;
wished(55) -> 3000;
wished(56) -> 3075;
wished(57) -> 3150;
wished(58) -> 3225;
wished(59) -> 3300;
wished(60) -> 3375;
wished(61) -> 3450;
wished(62) -> 3525;
wished(63) -> 3600;
wished(64) -> 3675;
wished(65) -> 3750;
wished(66) -> 3825;
wished(67) -> 3900;
wished(68) -> 3975;
wished(69) -> 4050;
wished(70) -> 4125;
wished(71) -> 4200;
wished(72) -> 4275;
wished(73) -> 4350;
wished(74) -> 4425;
wished(75) -> 4500;
wished(76) -> 4575;
wished(77) -> 4650;
wished(78) -> 4725;
wished(79) -> 4800;
wished(80) -> 4875;
wished(Lev) when Lev > 80 -> 5000;
wished(_) -> false.
