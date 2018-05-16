%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_all
	%%% @Created : 2018-05-14 12:03:28
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_all).
-export([group_list/0]).
-export([get_by_sn/2]).
-export([get_by_group/1]).
-export([get_group/1]).
-include("common.hrl").

    group_list() ->
    [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38].
%%本地服 
get_by_sn(Sn,Lan) when Sn >= 0 andalso Sn =< 0 andalso Lan == chn  ->'center0@127.0.0.1';
%%开发服 
get_by_sn(Sn,Lan) when Sn >= 30001 andalso Sn =< 30001 andalso Lan == chn  ->'center_hqg0@120.92.142.38';
%%稳定服 
get_by_sn(Sn,Lan) when Sn >= 30010 andalso Sn =< 30010 andalso Lan == chn  ->'center_stable0@120.92.142.38';
%%大蓝1 
get_by_sn(Sn,Lan) when Sn >= 1001 andalso Sn =< 1500 andalso Lan == chn  ->'center0@123.207.118.228';
%%仙豆专服 
get_by_sn(Sn,Lan) when Sn >= 8001 andalso Sn =< 8002 andalso Lan == chn  ->'center0@120.92.144.246';
%%测试服 
get_by_sn(Sn,Lan) when Sn >= 30009 andalso Sn =< 30009 andalso Lan == chn  ->'center_beta0@120.92.142.38';
%%繁体服 
get_by_sn(Sn,Lan) when Sn >= 30015 andalso Sn =< 30015 andalso Lan == fanti  ->'center_fanti0@120.92.142.38';
%%繁体正式跨服 
get_by_sn(Sn,Lan) when Sn >= 1001 andalso Sn =< 2000 andalso Lan == fanti  ->'center0@47.91.197.239';
%%大蓝2 
get_by_sn(Sn,Lan) when Sn >= 1501 andalso Sn =< 2000 andalso Lan == chn  ->'center0@123.207.227.114';
%%大蓝正版ios 
get_by_sn(Sn,Lan) when Sn >= 2001 andalso Sn =< 2500 andalso Lan == chn  ->'center_dl_ios0@123.207.227.114';
%%硬核专服 
get_by_sn(Sn,Lan) when Sn >= 2501 andalso Sn =< 3000 andalso Lan == chn  ->'center_yh0@139.199.2.78';
%%安卓大混服 
get_by_sn(Sn,Lan) when Sn >= 3001 andalso Sn =< 3500 andalso Lan == chn  ->'center_ad0@123.207.227.114';
%%应用宝联运 
get_by_sn(Sn,Lan) when Sn >= 3501 andalso Sn =< 4000 andalso Lan == chn  ->'center_yyb0@123.207.227.114';
%%仙豆新 
get_by_sn(Sn,Lan) when Sn >= 8003 andalso Sn =< 8500 andalso Lan == chn  ->'center_yh0@139.199.2.78';
%%经典专服 
get_by_sn(Sn,Lan) when Sn >= 5001 andalso Sn =< 5500 andalso Lan == chn  ->'center_jd0@123.207.227.114';
%%思璞专服  
get_by_sn(Sn,Lan) when Sn >= 6001 andalso Sn =< 6500 andalso Lan == chn  ->'center_sp0@123.207.227.114';
%%冰鸟专服  
get_by_sn(Sn,Lan) when Sn >= 4001 andalso Sn =< 4500 andalso Lan == chn  ->'center_bn0@139.199.2.78';
%%亿牛专服 
get_by_sn(Sn,Lan) when Sn >= 8501 andalso Sn =< 9000 andalso Lan == chn  ->'center_yn0@139.199.2.78';
%%韩服测试 
get_by_sn(Sn,Lan) when Sn >= 30024 andalso Sn =< 30024 andalso Lan == korea  ->'center_korea0@120.92.142.38';
%%bt测试 
get_by_sn(Sn,Lan) when Sn >= 30031 andalso Sn =< 30031 andalso Lan == bt  ->'center_bt0@120.92.142.38';
%%越南测试 
get_by_sn(Sn,Lan) when Sn >= 30030 andalso Sn =< 30030 andalso Lan == vietnam  ->'center_vietnam0@120.92.142.38';
%%韩服测试1 
get_by_sn(Sn,Lan) when Sn >= 30025 andalso Sn =< 30025 andalso Lan == korea  ->'center_k0@211.215.19.168';
%%妙聚专服 
get_by_sn(Sn,Lan) when Sn >= 9001 andalso Sn =< 9500 andalso Lan == chn  ->'center_mj0@123.207.227.114';
%%游龙专服 
get_by_sn(Sn,Lan) when Sn >= 9501 andalso Sn =< 10000 andalso Lan == chn  ->'center_yl0@139.199.2.78';
%%越南测试 
get_by_sn(Sn,Lan) when Sn >= 10001 andalso Sn =< 10010 andalso Lan == vietnam  ->'center_v0@103.53.171.29';
%%韩文服 
get_by_sn(Sn,Lan) when Sn >= 1001 andalso Sn =< 2000 andalso Lan == korea  ->'center0@110.10.40.205';
%%bt正式服 
get_by_sn(Sn,Lan) when Sn >= 1001 andalso Sn =< 2000 andalso Lan == bt  ->'center0@123.207.45.213';
%%韩服测试1 
get_by_sn(Sn,Lan) when Sn >= 30033 andalso Sn =< 30033 andalso Lan == korea  ->'center_k0@120.92.142.38';
%%韩服测试1 
get_by_sn(Sn,Lan) when Sn >= 31000 andalso Sn =< 31000 andalso Lan == korea  ->'center_dev_k0@211.215.19.168';
%%bt测试 
get_by_sn(Sn,Lan) when Sn >= 30034 andalso Sn =< 30034 andalso Lan == bt  ->'center_bt_dev0@120.92.142.38';
%%哈游专服 
get_by_sn(Sn,Lan) when Sn >= 10001 andalso Sn =< 10500 andalso Lan == chn  ->'center_hy0@139.199.2.78';
%%简体运营 
get_by_sn(Sn,Lan) when Sn >= 30050 andalso Sn =< 30050 andalso Lan == chn  ->'center_chn_yy0@120.92.159.155';
%%bt运营 
get_by_sn(Sn,Lan) when Sn >= 30051 andalso Sn =< 30051 andalso Lan == bt  ->'center_bt_yy0@120.92.159.155';
%%bt满V 
get_by_sn(Sn,Lan) when Sn >= 30040 andalso Sn =< 30040 andalso Lan == bt  ->'center_bt_vip0@120.92.142.38';
%%bt满V正式服 
get_by_sn(Sn,Lan) when Sn >= 2001 andalso Sn =< 3000 andalso Lan == bt  ->'center0@119.29.53.239';
%%越南正式服 
get_by_sn(Sn,Lan) when Sn >= 1001 andalso Sn =< 2000 andalso Lan == vietnam  ->'center0@103.53.171.195';
%%bt满V 
get_by_sn(Sn,Lan) when Sn >= 30041 andalso Sn =< 30041 andalso Lan == bt  ->'center_bt_vip_dev0@120.92.142.38';
%%bt运营 
get_by_sn(Sn,Lan) when Sn >= 30052 andalso Sn =< 30052 andalso Lan == bt  ->'center_bt_dev_yy0@120.92.159.155';
%%凤起专服 
get_by_sn(Sn,Lan) when Sn >= 10501 andalso Sn =< 11000 andalso Lan == chn  ->'center_fq0@123.207.227.114';
get_by_sn(_,_) -> none.
%%本地服 
get_by_group(1) ->'center0@127.0.0.1';
%%开发服 
get_by_group(2) ->'center_hqg0@120.92.142.38';
%%稳定服 
get_by_group(3) ->'center_stable0@120.92.142.38';
%%大蓝1 
get_by_group(4) ->'center0@123.207.118.228';
%%仙豆专服 
get_by_group(5) ->'center0@120.92.144.246';
%%测试服 
get_by_group(6) ->'center_beta0@120.92.142.38';
%%繁体服 
get_by_group(7) ->'center_fanti0@120.92.142.38';
%%繁体正式跨服 
get_by_group(8) ->'center0@47.91.197.239';
%%大蓝2 
get_by_group(9) ->'center0@123.207.227.114';
%%大蓝正版ios 
get_by_group(10) ->'center_dl_ios0@123.207.227.114';
%%硬核专服 
get_by_group(11) ->'center_yh0@139.199.2.78';
%%安卓大混服 
get_by_group(12) ->'center_ad0@123.207.227.114';
%%应用宝联运 
get_by_group(13) ->'center_yyb0@123.207.227.114';
%%仙豆新 
get_by_group(11) ->'center_yh0@139.199.2.78';
%%经典专服 
get_by_group(14) ->'center_jd0@123.207.227.114';
%%思璞专服  
get_by_group(15) ->'center_sp0@123.207.227.114';
%%冰鸟专服  
get_by_group(16) ->'center_bn0@139.199.2.78';
%%亿牛专服 
get_by_group(17) ->'center_yn0@139.199.2.78';
%%韩服测试 
get_by_group(18) ->'center_korea0@120.92.142.38';
%%bt测试 
get_by_group(19) ->'center_bt0@120.92.142.38';
%%越南测试 
get_by_group(20) ->'center_vietnam0@120.92.142.38';
%%韩服测试1 
get_by_group(21) ->'center_k0@211.215.19.168';
%%妙聚专服 
get_by_group(22) ->'center_mj0@123.207.227.114';
%%游龙专服 
get_by_group(23) ->'center_yl0@139.199.2.78';
%%越南测试 
get_by_group(24) ->'center_v0@103.53.171.29';
%%韩文服 
get_by_group(25) ->'center0@110.10.40.205';
%%bt正式服 
get_by_group(26) ->'center0@123.207.45.213';
%%韩服测试1 
get_by_group(27) ->'center_k0@120.92.142.38';
%%韩服测试1 
get_by_group(28) ->'center_dev_k0@211.215.19.168';
%%bt测试 
get_by_group(29) ->'center_bt_dev0@120.92.142.38';
%%哈游专服 
get_by_group(30) ->'center_hy0@139.199.2.78';
%%简体运营 
get_by_group(31) ->'center_chn_yy0@120.92.159.155';
%%bt运营 
get_by_group(32) ->'center_bt_yy0@120.92.159.155';
%%bt满V 
get_by_group(33) ->'center_bt_vip0@120.92.142.38';
%%bt满V正式服 
get_by_group(34) ->'center0@119.29.53.239';
%%越南正式服 
get_by_group(35) ->'center0@103.53.171.195';
%%bt满V 
get_by_group(36) ->'center_bt_vip_dev0@120.92.142.38';
%%bt运营 
get_by_group(37) ->'center_bt_dev_yy0@120.92.159.155';
%%凤起专服 
get_by_group(38) ->'center_fq0@123.207.227.114';
get_by_group(_) -> none.
%%本地服 
get_group('center0@127.0.0.1') ->1;
%%开发服 
get_group('center_hqg0@120.92.142.38') ->2;
%%稳定服 
get_group('center_stable0@120.92.142.38') ->3;
%%大蓝1 
get_group('center0@123.207.118.228') ->4;
%%仙豆专服 
get_group('center0@120.92.144.246') ->5;
%%测试服 
get_group('center_beta0@120.92.142.38') ->6;
%%繁体服 
get_group('center_fanti0@120.92.142.38') ->7;
%%繁体正式跨服 
get_group('center0@47.91.197.239') ->8;
%%大蓝2 
get_group('center0@123.207.227.114') ->9;
%%大蓝正版ios 
get_group('center_dl_ios0@123.207.227.114') ->10;
%%硬核专服 
get_group('center_yh0@139.199.2.78') ->11;
%%安卓大混服 
get_group('center_ad0@123.207.227.114') ->12;
%%应用宝联运 
get_group('center_yyb0@123.207.227.114') ->13;
%%仙豆新 
get_group('center_yh0@139.199.2.78') ->11;
%%经典专服 
get_group('center_jd0@123.207.227.114') ->14;
%%思璞专服  
get_group('center_sp0@123.207.227.114') ->15;
%%冰鸟专服  
get_group('center_bn0@139.199.2.78') ->16;
%%亿牛专服 
get_group('center_yn0@139.199.2.78') ->17;
%%韩服测试 
get_group('center_korea0@120.92.142.38') ->18;
%%bt测试 
get_group('center_bt0@120.92.142.38') ->19;
%%越南测试 
get_group('center_vietnam0@120.92.142.38') ->20;
%%韩服测试1 
get_group('center_k0@211.215.19.168') ->21;
%%妙聚专服 
get_group('center_mj0@123.207.227.114') ->22;
%%游龙专服 
get_group('center_yl0@139.199.2.78') ->23;
%%越南测试 
get_group('center_v0@103.53.171.29') ->24;
%%韩文服 
get_group('center0@110.10.40.205') ->25;
%%bt正式服 
get_group('center0@123.207.45.213') ->26;
%%韩服测试1 
get_group('center_k0@120.92.142.38') ->27;
%%韩服测试1 
get_group('center_dev_k0@211.215.19.168') ->28;
%%bt测试 
get_group('center_bt_dev0@120.92.142.38') ->29;
%%哈游专服 
get_group('center_hy0@139.199.2.78') ->30;
%%简体运营 
get_group('center_chn_yy0@120.92.159.155') ->31;
%%bt运营 
get_group('center_bt_yy0@120.92.159.155') ->32;
%%bt满V 
get_group('center_bt_vip0@120.92.142.38') ->33;
%%bt满V正式服 
get_group('center0@119.29.53.239') ->34;
%%越南正式服 
get_group('center0@103.53.171.195') ->35;
%%bt满V 
get_group('center_bt_vip_dev0@120.92.142.38') ->36;
%%bt运营 
get_group('center_bt_dev_yy0@120.92.159.155') ->37;
%%凤起专服 
get_group('center_fq0@123.207.227.114') ->38;
get_group(_) -> [].
