%----------------------------------------------------
%%  帮会数值数据
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_data).
-export([get/2 ]).

-include("guild.hrl").
-include("common.hrl").

%% 帮会升级数据
get(guild_lev, 1) ->
    {ok, #guild_lev{
            lev = 1
            ,cost_fund = 100
            ,day_fund = 0
            ,maxnum = 10
            ,desc = language:get(<<"帮会成员上限为10">>)
        }
    };
    
get(guild_lev, 2) ->
    {ok, #guild_lev{
            lev = 2
            ,cost_fund = 100
            ,day_fund = 50
            ,maxnum = 11
            ,desc = language:get(<<"帮会成员上限为11">>)
        }
    };
    
get(guild_lev, 3) ->
    {ok, #guild_lev{
            lev = 3
            ,cost_fund = 300
            ,day_fund = 50
            ,maxnum = 12
            ,desc = language:get(<<"帮会成员上限为12">>)
        }
    };
    
get(guild_lev, 4) ->
    {ok, #guild_lev{
            lev = 4
            ,cost_fund = 500
            ,day_fund = 100
            ,maxnum = 13
            ,desc = language:get(<<"帮会成员上限为13">>)
        }
    };
    
get(guild_lev, 5) ->
    {ok, #guild_lev{
            lev = 5
            ,cost_fund = 1000
            ,day_fund = 100
            ,maxnum = 14
            ,desc = language:get(<<"帮会成员上限为14">>)
        }
    };
    
get(guild_lev, 6) ->
    {ok, #guild_lev{
            lev = 6
            ,cost_fund = 2000
            ,day_fund = 120
            ,maxnum = 15
            ,desc = language:get(<<"帮会成员上限为15">>)
        }
    };
    
get(guild_lev, 7) ->
    {ok, #guild_lev{
            lev = 7
            ,cost_fund = 2500
            ,day_fund = 120
            ,maxnum = 16
            ,desc = language:get(<<"帮会成员上限为16">>)
        }
    };
    
get(guild_lev, 8) ->
    {ok, #guild_lev{
            lev = 8
            ,cost_fund = 3000
            ,day_fund = 125
            ,maxnum = 17
            ,desc = language:get(<<"帮会成员上限为17">>)
        }
    };
    
get(guild_lev, 9) ->
    {ok, #guild_lev{
            lev = 9
            ,cost_fund = 3500
            ,day_fund = 130
            ,maxnum = 18
            ,desc = language:get(<<"帮会成员上限为18">>)
        }
    };
    
get(guild_lev, 10) ->
    {ok, #guild_lev{
            lev = 10
            ,cost_fund = 5000
            ,day_fund = 135
            ,maxnum = 19
            ,desc = language:get(<<"帮会成员上限为19">>)
        }
    };
    
get(guild_lev, 11) ->
    {ok, #guild_lev{
            lev = 11
            ,cost_fund = 6000
            ,day_fund = 140
            ,maxnum = 20
            ,desc = language:get(<<"帮会成员上限为20">>)
        }
    };
    
get(guild_lev, 12) ->
    {ok, #guild_lev{
            lev = 12
            ,cost_fund = 7000
            ,day_fund = 140
            ,maxnum = 21
            ,desc = language:get(<<"帮会成员上限为21">>)
        }
    };
    
get(guild_lev, 13) ->
    {ok, #guild_lev{
            lev = 13
            ,cost_fund = 8000
            ,day_fund = 145
            ,maxnum = 22
            ,desc = language:get(<<"帮会成员上限为22">>)
        }
    };
    
get(guild_lev, 14) ->
    {ok, #guild_lev{
            lev = 14
            ,cost_fund = 9000
            ,day_fund = 180
            ,maxnum = 23
            ,desc = language:get(<<"帮会成员上限为23">>)
        }
    };
    
get(guild_lev, 15) ->
    {ok, #guild_lev{
            lev = 15
            ,cost_fund = 10000
            ,day_fund = 200
            ,maxnum = 24
            ,desc = language:get(<<"帮会成员上限为24">>)
        }
    };
    
get(guild_lev, 16) ->
    {ok, #guild_lev{
            lev = 16
            ,cost_fund = 11000
            ,day_fund = 225
            ,maxnum = 25
            ,desc = language:get(<<"帮会成员上限为25">>)
        }
    };
    
get(guild_lev, 17) ->
    {ok, #guild_lev{
            lev = 17
            ,cost_fund = 12000
            ,day_fund = 245
            ,maxnum = 26
            ,desc = language:get(<<"帮会成员上限为26">>)
        }
    };
    
get(guild_lev, 18) ->
    {ok, #guild_lev{
            lev = 18
            ,cost_fund = 13000
            ,day_fund = 270
            ,maxnum = 27
            ,desc = language:get(<<"帮会成员上限为27">>)
        }
    };
    
get(guild_lev, 19) ->
    {ok, #guild_lev{
            lev = 19
            ,cost_fund = 14000
            ,day_fund = 320
            ,maxnum = 28
            ,desc = language:get(<<"帮会成员上限为28">>)
        }
    };
    
get(guild_lev, 20) ->
    {ok, #guild_lev{
            lev = 20
            ,cost_fund = 15000
            ,day_fund = 345
            ,maxnum = 29
            ,desc = language:get(<<"帮会成员上限为29">>)
        }
    };
    
get(guild_lev, 21) ->
    {ok, #guild_lev{
            lev = 21
            ,cost_fund = 20000
            ,day_fund = 375
            ,maxnum = 30
            ,desc = language:get(<<"帮会成员上限为30">>)
        }
    };
    
get(guild_lev, 22) ->
    {ok, #guild_lev{
            lev = 22
            ,cost_fund = 21000
            ,day_fund = 405
            ,maxnum = 31
            ,desc = language:get(<<"帮会成员上限为31">>)
        }
    };
    
get(guild_lev, 23) ->
    {ok, #guild_lev{
            lev = 23
            ,cost_fund = 25000
            ,day_fund = 440
            ,maxnum = 32
            ,desc = language:get(<<"帮会成员上限为32">>)
        }
    };
    
get(guild_lev, 24) ->
    {ok, #guild_lev{
            lev = 24
            ,cost_fund = 25000
            ,day_fund = 475
            ,maxnum = 33
            ,desc = language:get(<<"帮会成员上限为33">>)
        }
    };
    
get(guild_lev, 25) ->
    {ok, #guild_lev{
            lev = 25
            ,cost_fund = 25000
            ,day_fund = 485
            ,maxnum = 34
            ,desc = language:get(<<"帮会成员上限为34">>)
        }
    };
    
get(guild_lev, 26) ->
    {ok, #guild_lev{
            lev = 26
            ,cost_fund = 30000
            ,day_fund = 495
            ,maxnum = 35
            ,desc = language:get(<<"帮会成员上限为35">>)
        }
    };
    
get(guild_lev, 27) ->
    {ok, #guild_lev{
            lev = 27
            ,cost_fund = 35000
            ,day_fund = 500
            ,maxnum = 36
            ,desc = language:get(<<"帮会成员上限为36">>)
        }
    };
    
get(guild_lev, 28) ->
    {ok, #guild_lev{
            lev = 28
            ,cost_fund = 40000
            ,day_fund = 500
            ,maxnum = 37
            ,desc = language:get(<<"帮会成员上限为37">>)
        }
    };
    
get(guild_lev, 29) ->
    {ok, #guild_lev{
            lev = 29
            ,cost_fund = 50000
            ,day_fund = 550
            ,maxnum = 38
            ,desc = language:get(<<"帮会成员上限为38">>)
        }
    };
    
get(guild_lev, 30) ->
    {ok, #guild_lev{
            lev = 30
            ,cost_fund = 70000
            ,day_fund = 550
            ,maxnum = 39
            ,desc = language:get(<<"帮会成员上限为39">>)
        }
    };
    
get(guild_lev, 31) ->
    {ok, #guild_lev{
            lev = 31
            ,cost_fund = 100000
            ,day_fund = 550
            ,maxnum = 40
            ,desc = language:get(<<"帮会成员上限为40">>)
        }
    };
    
get(guild_lev, 32) ->
    {ok, #guild_lev{
            lev = 32
            ,cost_fund = 150000
            ,day_fund = 550
            ,maxnum = 41
            ,desc = language:get(<<"帮会成员上限为41">>)
        }
    };
    
get(guild_lev, 33) ->
    {ok, #guild_lev{
            lev = 33
            ,cost_fund = 200000
            ,day_fund = 600
            ,maxnum = 42
            ,desc = language:get(<<"帮会成员上限为42">>)
        }
    };
    
get(guild_lev, 34) ->
    {ok, #guild_lev{
            lev = 34
            ,cost_fund = 300000
            ,day_fund = 650
            ,maxnum = 43
            ,desc = language:get(<<"帮会成员上限为43">>)
        }
    };
    
get(guild_lev, 35) ->
    {ok, #guild_lev{
            lev = 35
            ,cost_fund = 400000
            ,day_fund = 650
            ,maxnum = 44
            ,desc = language:get(<<"帮会成员上限为44">>)
        }
    };
    
get(guild_lev, 36) ->
    {ok, #guild_lev{
            lev = 36
            ,cost_fund = 400000
            ,day_fund = 650
            ,maxnum = 45
            ,desc = language:get(<<"帮会成员上限为45">>)
        }
    };
    
get(guild_lev, 37) ->
    {ok, #guild_lev{
            lev = 37
            ,cost_fund = 400000
            ,day_fund = 650
            ,maxnum = 46
            ,desc = language:get(<<"帮会成员上限为46">>)
        }
    };
    
get(guild_lev, 38) ->
    {ok, #guild_lev{
            lev = 38
            ,cost_fund = 450000
            ,day_fund = 700
            ,maxnum = 47
            ,desc = language:get(<<"帮会成员上限为47">>)
        }
    };
    
get(guild_lev, 39) ->
    {ok, #guild_lev{
            lev = 39
            ,cost_fund = 450000
            ,day_fund = 700
            ,maxnum = 48
            ,desc = language:get(<<"帮会成员上限为48">>)
        }
    };
    
get(guild_lev, 40) ->
    {ok, #guild_lev{
            lev = 40
            ,cost_fund = 500000
            ,day_fund = 700
            ,maxnum = 49
            ,desc = language:get(<<"帮会成员上限为49">>)
        }
    };
    
get(guild_lev, 41) ->
    {ok, #guild_lev{
            lev = 41
            ,cost_fund = 500000
            ,day_fund = 700
            ,maxnum = 50
            ,desc = language:get(<<"帮会成员上限为50">>)
        }
    };
    
get(guild_lev, 42) ->
    {ok, #guild_lev{
            lev = 42
            ,cost_fund = 500000
            ,day_fund = 700
            ,maxnum = 51
            ,desc = language:get(<<"帮会成员上限为51">>)
        }
    };
    
get(guild_lev, 43) ->
    {ok, #guild_lev{
            lev = 43
            ,cost_fund = 500000
            ,day_fund = 750
            ,maxnum = 52
            ,desc = language:get(<<"帮会成员上限为52">>)
        }
    };
    
get(guild_lev, 44) ->
    {ok, #guild_lev{
            lev = 44
            ,cost_fund = 500000
            ,day_fund = 750
            ,maxnum = 53
            ,desc = language:get(<<"帮会成员上限为53">>)
        }
    };
    
get(guild_lev, 45) ->
    {ok, #guild_lev{
            lev = 45
            ,cost_fund = 750000
            ,day_fund = 750
            ,maxnum = 54
            ,desc = language:get(<<"帮会成员上限为54">>)
        }
    };
    
get(guild_lev, 46) ->
    {ok, #guild_lev{
            lev = 46
            ,cost_fund = 750000
            ,day_fund = 750
            ,maxnum = 55
            ,desc = language:get(<<"帮会成员上限为55">>)
        }
    };
    
get(guild_lev, 47) ->
    {ok, #guild_lev{
            lev = 47
            ,cost_fund = 750000
            ,day_fund = 800
            ,maxnum = 56
            ,desc = language:get(<<"帮会成员上限为56">>)
        }
    };
    
get(guild_lev, 48) ->
    {ok, #guild_lev{
            lev = 48
            ,cost_fund = 750000
            ,day_fund = 900
            ,maxnum = 57
            ,desc = language:get(<<"帮会成员上限为57">>)
        }
    };
    
get(guild_lev, 49) ->
    {ok, #guild_lev{
            lev = 49
            ,cost_fund = 1000000
            ,day_fund = 1000
            ,maxnum = 58
            ,desc = language:get(<<"帮会成员上限为58">>)
        }
    };
    
get(guild_lev, 50) ->
    {ok, #guild_lev{
            lev = 50
            ,cost_fund = 0
            ,day_fund = 1000
            ,maxnum = 59
            ,desc = language:get(<<"帮会成员上限为59">>)
        }
    };
get(guild_lev, _Lev) ->
    ?ELOG("帮会等级数据异常，等级为~w",[_Lev]),
    {ok, #guild_lev{
            lev = 0
            ,cost_fund = 0
            ,day_fund = 0
            ,maxnum = 0
            ,desc = language:get(<<"数据异常">>)
        }
    };

%% 帮会福利数据
get(weal_lev, 0) ->
    {ok, #weal_lev{
            lev = 0
            ,glev = 0
            ,fund = 0
            ,desc = language:get(<<"未激活">>)
        }
    };
get(weal_lev, 1) ->
    {ok, #weal_lev{
            lev = 1
            ,glev = 1
            ,fund = 100
            ,desc = language:get(<<"增加打怪经验获得1%">>)
        }
    };
get(weal_lev, 2) ->
    {ok, #weal_lev{
            lev = 2
            ,glev = 2
            ,fund = 200
            ,desc = language:get(<<"增加打怪经验获得2%">>)
        }
    };
get(weal_lev, 3) ->
    {ok, #weal_lev{
            lev = 3
            ,glev = 3
            ,fund = 500
            ,desc = language:get(<<"增加打怪经验获得3%">>)
        }
    };
get(weal_lev, 4) ->
    {ok, #weal_lev{
            lev = 4
            ,glev = 4
            ,fund = 1000
            ,desc = language:get(<<"增加打怪经验获得4%">>)
        }
    };
get(weal_lev, 5) ->
    {ok, #weal_lev{
            lev = 5
            ,glev = 5
            ,fund = 1500
            ,desc = language:get(<<"增加打怪经验获得5%">>)
        }
    };
get(weal_lev, 6) ->
    {ok, #weal_lev{
            lev = 6
            ,glev = 6
            ,fund = 2000
            ,desc = language:get(<<"增加打怪经验获得6%">>)
        }
    };
get(weal_lev, 7) ->
    {ok, #weal_lev{
            lev = 7
            ,glev = 7
            ,fund = 3000
            ,desc = language:get(<<"增加打怪经验获得7%">>)
        }
    };
get(weal_lev, 8) ->
    {ok, #weal_lev{
            lev = 8
            ,glev = 8
            ,fund = 4000
            ,desc = language:get(<<"增加打怪经验获得8%">>)
        }
    };
get(weal_lev, 9) ->
    {ok, #weal_lev{
            lev = 9
            ,glev = 9
            ,fund = 5000
            ,desc = language:get(<<"增加打怪经验获得9%">>)
        }
    };
get(weal_lev, 10) ->
    {ok, #weal_lev{
            lev = 10
            ,glev = 10
            ,fund = 6000
            ,desc = language:get(<<"增加打怪经验获得10%">>)
        }
    };
get(weal_lev, 11) ->
    {ok, #weal_lev{
            lev = 11
            ,glev = 11
            ,fund = 8000
            ,desc = language:get(<<"增加打怪经验获得11%">>)
        }
    };
get(weal_lev, 12) ->
    {ok, #weal_lev{
            lev = 12
            ,glev = 12
            ,fund = 10000
            ,desc = language:get(<<"增加打怪经验获得12%">>)
        }
    };
get(weal_lev, 13) ->
    {ok, #weal_lev{
            lev = 13
            ,glev = 13
            ,fund = 12000
            ,desc = language:get(<<"增加打怪经验获得13%">>)
        }
    };
get(weal_lev, 14) ->
    {ok, #weal_lev{
            lev = 14
            ,glev = 14
            ,fund = 14000
            ,desc = language:get(<<"增加打怪经验获得14%">>)
        }
    };
get(weal_lev, 15) ->
    {ok, #weal_lev{
            lev = 15
            ,glev = 15
            ,fund = 16000
            ,desc = language:get(<<"增加打怪经验获得15%">>)
        }
    };
get(weal_lev, 16) ->
    {ok, #weal_lev{
            lev = 16
            ,glev = 16
            ,fund = 18000
            ,desc = language:get(<<"增加打怪经验获得16%">>)
        }
    };
get(weal_lev, 17) ->
    {ok, #weal_lev{
            lev = 17
            ,glev = 17
            ,fund = 20000
            ,desc = language:get(<<"增加打怪经验获得17%">>)
        }
    };
get(weal_lev, 18) ->
    {ok, #weal_lev{
            lev = 18
            ,glev = 18
            ,fund = 22000
            ,desc = language:get(<<"增加打怪经验获得18%">>)
        }
    };
get(weal_lev, 19) ->
    {ok, #weal_lev{
            lev = 19
            ,glev = 19
            ,fund = 24000
            ,desc = language:get(<<"增加打怪经验获得19%">>)
        }
    };
get(weal_lev, 20) ->
    {ok, #weal_lev{
            lev = 20
            ,glev = 20
            ,fund = 30000
            ,desc = language:get(<<"增加打怪经验获得20%">>)
        }
    };

get(weal_lev, _Wlev) ->
    ?ERR("福利等级数据异常，等级为~w",[_Wlev]),
    {ok, #weal_lev{
            lev = 0
            ,glev = 0
            ,fund = 0
            ,desc = language:get(<<"数据异常">>)
        }
    };

%% 神炉升级信息
get(stove_lev, 0) ->
    {ok, #stove_lev{
            lev = 0
            ,glev = 0
            ,fund = 0
            ,ratio = 0
            ,desc = language:get(<<"未激活">>)
        }
    };
get(stove_lev, 1) ->
    {ok, #stove_lev{
            lev = 1
            ,glev = 5
            ,fund = 2000
            ,ratio = 1
            ,desc = language:get(<<"增加强化成功率1%">>)
        }
    };
get(stove_lev, 2) ->
    {ok, #stove_lev{
            lev = 2
            ,glev = 10
            ,fund = 5000
            ,ratio = 2
            ,desc = language:get(<<"增加强化成功率2%">>)
        }
    };
get(stove_lev, 3) ->
    {ok, #stove_lev{
            lev = 3
            ,glev = 11
            ,fund = 8000
            ,ratio = 3
            ,desc = language:get(<<"增加强化成功率3%">>)
        }
    };
get(stove_lev, 4) ->
    {ok, #stove_lev{
            lev = 4
            ,glev = 12
            ,fund = 10000
            ,ratio = 4
            ,desc = language:get(<<"增加强化成功率4%">>)
        }
    };
get(stove_lev, 5) ->
    {ok, #stove_lev{
            lev = 5
            ,glev = 13
            ,fund = 20000
            ,ratio = 5
            ,desc = language:get(<<"增加强化成功率5%">>)
        }
    };
get(stove_lev, 6) ->
    {ok, #stove_lev{
            lev = 6
            ,glev = 14
            ,fund = 30000
            ,ratio = 6
            ,desc = language:get(<<"增加强化成功率6%">>)
        }
    };
get(stove_lev, 7) ->
    {ok, #stove_lev{
            lev = 7
            ,glev = 15
            ,fund = 40000
            ,ratio = 7
            ,desc = language:get(<<"增加强化成功率7%">>)
        }
    };
get(stove_lev, 8) ->
    {ok, #stove_lev{
            lev = 8
            ,glev = 16
            ,fund = 50000
            ,ratio = 8
            ,desc = language:get(<<"增加强化成功率8%">>)
        }
    };
get(stove_lev, 9) ->
    {ok, #stove_lev{
            lev = 9
            ,glev = 17
            ,fund = 60000
            ,ratio = 9
            ,desc = language:get(<<"增加强化成功率9%">>)
        }
    };
get(stove_lev, 10) ->
    {ok, #stove_lev{
            lev = 10
            ,glev = 18
            ,fund = 70000
            ,ratio = 10
            ,desc = language:get(<<"增加强化成功率10%">>)
        }
    };
get(stove_lev, 11) ->
    {ok, #stove_lev{
            lev = 11
            ,glev = 19
            ,fund = 80000
            ,ratio = 11
            ,desc = language:get(<<"增加强化成功率11%">>)
        }
    };
get(stove_lev, 12) ->
    {ok, #stove_lev{
            lev = 12
            ,glev = 20
            ,fund = 100000
            ,ratio = 12
            ,desc = language:get(<<"增加强化成功率12%">>)
        }
    };
get(stove_lev, 13) ->
    {ok, #stove_lev{
            lev = 13
            ,glev = 21
            ,fund = 120000
            ,ratio = 13
            ,desc = language:get(<<"增加强化成功率13%">>)
        }
    };
get(stove_lev, 14) ->
    {ok, #stove_lev{
            lev = 14
            ,glev = 22
            ,fund = 150000
            ,ratio = 14
            ,desc = language:get(<<"增加强化成功率14%">>)
        }
    };
get(stove_lev, 15) ->
    {ok, #stove_lev{
            lev = 15
            ,glev = 23
            ,fund = 180000
            ,ratio = 15
            ,desc = language:get(<<"增加强化成功率15%">>)
        }
    };
get(stove_lev, 16) ->
    {ok, #stove_lev{
            lev = 16
            ,glev = 24
            ,fund = 210000
            ,ratio = 16
            ,desc = language:get(<<"增加强化成功率16%">>)
        }
    };
get(stove_lev, 17) ->
    {ok, #stove_lev{
            lev = 17
            ,glev = 25
            ,fund = 240000
            ,ratio = 17
            ,desc = language:get(<<"增加强化成功率17%">>)
        }
    };
get(stove_lev, 18) ->
    {ok, #stove_lev{
            lev = 18
            ,glev = 26
            ,fund = 270000
            ,ratio = 18
            ,desc = language:get(<<"增加强化成功率18%">>)
        }
    };
get(stove_lev, 19) ->
    {ok, #stove_lev{
            lev = 19
            ,glev = 27
            ,fund = 300000
            ,ratio = 19
            ,desc = language:get(<<"增加强化成功率19%">>)
        }
    };
get(stove_lev, 20) ->
    {ok, #stove_lev{
            lev = 20
            ,glev = 28
            ,fund = 400000
            ,ratio = 20
            ,desc = language:get(<<"增加强化成功率20%">>)
        }
    };

get(stove_lev, _Slev) ->
    ?ERR("神炉等级数据异常，等级为~w",[_Slev]),
    {ok, #stove_lev{
            lev = 0
            ,glev = 0
            ,fund = 0
            ,ratio = 0
            ,desc = language:get(<<"数据异常">>)
        }
    };

get(_Cmd, _Data) -> ok.
