%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_version_different
	%%% @Created : 2018-04-10 15:19:31
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_version_different).
-export([get/1]).
-include("vip.hrl").
-include("common.hrl").
get(Id) -> get(version:get_lan_config(), Id).
%%类型说明
%% 1  首次登陆赠品;
%% 2  聊天限制;
%% 3  d_vip;
%% 4  仙境寻宝;
%% 5  符文寻宝;
%% 6  迷宫寻宝;
%% 7  仙盟宝箱;
%% 8  精英赛战队创建价格;
%% 9  经验副本投资;
%% 10  充值卡元宝比例;
%% 11  结婚副本重置;
%% 12  世界boss疲劳度;
%% 13  普通玩家等级上限;
%% 14  剑道寻宝;


%% get(Version,Type) -> Args.
get(chn,1) -> [];
get(fanti,1) -> [] ;
get(korea,1) -> [] ;
get(vietnam,1) -> [] ;
get(bt,1) -> [{10106, 13888}, {10101, 1000000}] ;

get(chn,2) -> {0,0};
get(fanti,2) -> {0,0} ;
get(korea,2) -> {0,0} ;
get(vietnam,2) -> {0,0} ;
get(bt,2) -> {50,4} ;

get(chn,3) -> {60, 0, 888, 1980, 10, 7};
get(fanti,3) -> {60, 0, 888, 1980, 10, 7};
get(korea,3) -> {30, 30, 888, 4000, 10, 0};
get(vietnam,3) -> {60, 0, 888, 1980, 10, 7};
get(bt,3) -> {60, 0, 8888, 19800, 100, 7};

get(chn,4) -> 15;
get(fanti,4) -> 15;
get(korea,4) -> 15;
get(vietnam,4) -> 15;
get(bt,4) -> 150;

get(chn,5) -> {100,800} ;
get(fanti,5) -> {100,800} ;
get(korea,5) -> {100,800} ;
get(vietnam,5) -> {100,800} ;
get(bt,5) -> {600,5400} ;

get(chn,6) -> 30;
get(fanti,6) -> 30;
get(korea,6) -> 30;
get(vietnam,6) -> 30;
get(bt,6) -> 300;

get(chn,7) -> {3,6,900,1500,20,600,1800,20,10};
get(fanti,7) -> {3,6,600,1800,20,600,1800,20,10};
get(korea,7) -> {3,6,600,1800,20,600,1800,20,10};
get(vietnam,7) -> {3,6,600,1800,20,600,1800,20,10};
get(bt,7) -> {3,6,600,1800,20,600,1800,20,10};

get(chn,8) -> 30;
get(fanti,8) -> 30;
get(korea,8) -> 30;
get(vietnam,8) -> 30;
get(bt,8) -> 600;

get(chn,9) -> {588,10};
get(fanti,9) -> {588,10};
get(korea,9) -> {588,10};
get(vietnam,9) -> {588,10};
get(bt,9) -> {588,10};

get(chn,10) -> 100;
get(fanti,10) -> 100;
get(korea,10) -> 100;
get(vietnam,10) -> 100;
get(bt,10) -> 2000;

get(chn,11) -> 30;
get(fanti,11) -> 30;
get(korea,11) -> 30;
get(vietnam,11) -> 30;
get(bt,11) -> 300;

get(chn,12) -> 15;
get(fanti,12) -> 15;
get(korea,12) -> 25;
get(vietnam,12) -> 15;
get(bt,12) -> 15;

get(chn,13) -> 350;
get(fanti,13) -> 350;
get(korea,13) -> 350;
get(vietnam,13) -> 350;
get(bt,13) -> 350;

get(chn,14) -> {100,800} ;
get(fanti,14) -> {100,800} ;
get(korea,14) -> {100,800} ;
get(vietnam,14) -> {100,800} ;
get(bt,14) -> {600,5400} ;

get(_,_) -> [].

