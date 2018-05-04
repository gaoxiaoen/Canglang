%%----------------------------------------------------
%% 成就数据
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(achievement_data).
-export([
        list/0
        ,list/1
        ,list/2
        ,get/1
    ]
).

-include("condition.hrl").
-include("achievement.hrl").
-include("gain.hrl").

%% 所有成就目标数据
list() ->
   [10000,10001,10002,10003,10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,
10014,10015,10016,10017,10018,10019,10020,10021,10022,10023,10024,10025,10026,10027,10028,
10029,10030,10031,10032,10033,10034,10035,10036,10037,10038,10039,10040,10041,10042,10043,
10044,10045,10046,10047,10048,10049,10050,10051,10052,10053,10054,10055,10056,10057,10058,
10059,10060,10061,10062,10063,10064,10065,10066,10067,10068,10069,10070,10071,10072,10073,
10074,10075,10076,10077,10078,10079,10080,10081,10082,10083,10084,10085,10086,10087,10088,
10089,10090,10091,10092,10093,10094,10095,10096,10097,10098,10099,10100,10101,10102,10103,
10104,10105,10106,10107,10185,10186,10187,10108,10109,10110,10111,10112,10113,10114,10115,
10116,10117,10118,10119,10120,10121,10122,10123,10124,10160,10161,10162,10163,10164,10165,
10166,10167,10125,10126,10127,10128,10129,10130,10131,10132,10133,10134,10135,10136,10137,
10138,10139,10140,10141,10142,10143,10144,10145,10146,10147,10168,10169,10170,10171,10148,
10200,10201,10202,10203,10204,10205,10206,10207,10208,10209,10210,10211,10212,10213,10214,
10215,10216,10217,10218,10219,10220,10221,10222,10223,10224,10225,10226,10227,10228,10229,
10230,10231,10232,10233,10234,90101,90102,90103,90104,90105,90201,90203,90204,90205,90206,
90301,90302,90303,90304,90305,90306,90401,90402,90403,90404,90405,90406,90501,90502,90503,
90504,90505,90506].

%% 获取指定类型数据
list(2) -> [10000,10001,10002,10003,10004,10005,10006,10007,10008,10009,10010,10011,10012,10013,
10014,10015,10016,10017,10018,10019,10020,10021,10022,10023,10024,10025,10026,10027,10028,
10029,10030,10031,10032,10033,10034,10035,10036,10037,10038,10039,10040,10041,10042,10043,
10044,10045,10046,10047,10048,10049,10050,10051,10052,10053,10054,10055,10056,10057,10058,
10059,10060,10061,10062,10063,10064,10065,10066,10067,10068,10069,10070,10071,10072,10073,
10074,10075,10076,10077,10078,10079,10080,10081,10082,10083,10084,10085,10086,10087,10088,
10089,10090,10091,10092,10093,10094,10095,10096,10097,10098,10099,10100,10101,10102,10103,
10104,10105,10106,10107,10185,10186,10187,10108,10109,10110,10111,10112,10113,10114,10115,
10116,10117,10118,10119,10120,10121,10122,10123,10124,10160,10161,10162,10163,10164,10165,
10166,10167,10125,10126,10127,10128,10129,10130,10131,10132,10133,10134,10135,10136,10137,
10138,10139,10140,10141,10142,10143,10144,10145,10146,10147,10168,10169,10170,10171,10148,
10200,10201,10202,10203,10204,10205,10206,10207,10208,10209,10210,10211,10212,10213,10214,
10215,10216,10217,10218,10219,10220,10221,10222,10223,10224,10225,10226,10227,10228,10229,
10230,10231,10232,10233,10234];
list(1) -> [90101,90102,90103,90104,90105,90201,90203,90204,90205,90206,90301,90302,90303,90304,
90305,90306,90401,90402,90403,90404,90405,90406,90501,90502,90503,90504,90505,90506];
list(_) -> [].

%% 某个小类型数据列表
list(2, 1) ->
    [10000,10001,10002,10003,10004,10005,10006,10007,10008,10009
   ,10010,10011,10012,10013,10014,10015,10016,10017,10018,10019
   ,10020,10021,10022,10023,10024,10025,10026,10027,10028];
list(2, 2) ->
    [10029,10030,10031,10032,10033,10034,10035,10036,10037,10038
   ,10039,10040,10041,10042,10043,10044,10045,10046,10047,10048
   ,10049,10050,10051,10052,10053,10054,10055,10056,10057,10058
   ,10059,10060,10061,10062,10063,10064,10065,10066,10067,10068
   ,10069,10070,10071,10072,10073,10074,10075,10076,10077,10078
   ,10079,10080,10081,10082];
list(2, 3) ->
    [10083,10084,10085,10086,10087,10088,10089,10090,10091,10092
   ,10093,10094,10095,10096,10097,10098,10099,10100,10101,10102
   ,10103,10104,10105,10106,10107,10185,10186,10187,10108];
list(2, 4) ->
    [10109,10110,10111,10112,10113,10114,10115,10116,10117,10118
   ,10119,10120,10121,10122,10123,10124,10160,10161,10162,10163
   ,10164,10165,10166,10167,10125];
list(2, 5) ->
    [10126,10127,10128,10129,10130,10131,10132,10133,10134,10135
   ,10136,10137,10138,10139,10140,10141,10142,10143,10144,10145
   ,10146,10147,10168,10169,10170,10171,10148];
list(2, 6) ->
    [10200,10201,10202,10203,10204,10205,10206,10207,10208,10209
   ,10210,10211,10212,10213,10214,10215,10216,10217,10218,10219
   ,10220,10221,10222,10223,10224,10225,10226,10227,10228,10229
   ,10230,10231,10232,10233,10234];
list(1, 1) ->
    [90101,90102,90103,90104,90105];
list(1, 2) ->
    [90201,90203,90204,90205,90206];
list(1, 3) ->
    [90301,90302,90303,90304,90305,90306];
list(1, 4) ->
    [90401,90402,90403,90404,90405,90406];
list(1, 5) ->
    [90501,90502,90503,90504,90505,90506];
list(_, _) -> [].

%% 获取成就基础数据
get(10000) ->
    {ok, #achievement_base{
            id = 10000
            ,name = <<"帮会任务【一】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 5, target_value = 20}
            ]
            ,rewards = [
                #gain{label = achievement, val = 5}
               ,#gain{label = gold_bind, val = 5}
            ]
        }
    };
    
get(10001) ->
    {ok, #achievement_base{
            id = 10001
            ,name = <<"帮会任务【二】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10000}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 5, target_value = 100}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10002) ->
    {ok, #achievement_base{
            id = 10002
            ,name = <<"帮会任务【三】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10001}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 5, target_value = 500}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10003) ->
    {ok, #achievement_base{
            id = 10003
            ,name = <<"帮会任务【四】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10002}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 5, target_value = 2000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
               ,#gain{label = honor_name, val = 20003}
            ]
        }
    };
    
get(10004) ->
    {ok, #achievement_base{
            id = 10004
            ,name = <<"师门任务【一】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 4, target_value = 20}
            ]
            ,rewards = [
                #gain{label = achievement, val = 5}
               ,#gain{label = gold_bind, val = 5}
            ]
        }
    };
    
get(10005) ->
    {ok, #achievement_base{
            id = 10005
            ,name = <<"师门任务【二】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10004}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 4, target_value = 100}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10006) ->
    {ok, #achievement_base{
            id = 10006
            ,name = <<"师门任务【三】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10005}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 4, target_value = 500}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10007) ->
    {ok, #achievement_base{
            id = 10007
            ,name = <<"师门任务【四】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10006}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 4, target_value = 2000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
               ,#gain{label = honor_name, val = 20007}
            ]
        }
    };
    
get(10008) ->
    {ok, #achievement_base{
            id = 10008
            ,name = <<"护送任务【一】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 104, target_value = 5}
            ]
            ,rewards = [
                #gain{label = achievement, val = 5}
               ,#gain{label = gold_bind, val = 5}
            ]
        }
    };
    
get(10009) ->
    {ok, #achievement_base{
            id = 10009
            ,name = <<"护送任务【二】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10008}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 104, target_value = 20}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10010) ->
    {ok, #achievement_base{
            id = 10010
            ,name = <<"护送任务【三】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10009}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 104, target_value = 100}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10011) ->
    {ok, #achievement_base{
            id = 10011
            ,name = <<"护送任务【四】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10010}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 104, target_value = 500}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
               ,#gain{label = honor_name, val = 20011}
            ]
        }
    };
    
get(10012) ->
    {ok, #achievement_base{
            id = 10012
            ,name = <<"守卫任务【一】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 6, target_value = 2}
            ]
            ,rewards = [
                #gain{label = achievement, val = 5}
               ,#gain{label = gold_bind, val = 5}
            ]
        }
    };
    
get(10013) ->
    {ok, #achievement_base{
            id = 10013
            ,name = <<"守卫任务【二】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10012}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 6, target_value = 10}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10014) ->
    {ok, #achievement_base{
            id = 10014
            ,name = <<"守卫任务【三】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10013}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 6, target_value = 50}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10015) ->
    {ok, #achievement_base{
            id = 10015
            ,name = <<"守卫任务【四】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10014}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 6, target_value = 150}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
               ,#gain{label = honor_name, val = 20015}
            ]
        }
    };
    
get(10016) ->
    {ok, #achievement_base{
            id = 10016
            ,name = <<"副本任务【一】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 3, target_value = 2}
            ]
            ,rewards = [
                #gain{label = achievement, val = 5}
               ,#gain{label = gold_bind, val = 5}
            ]
        }
    };
    
get(10017) ->
    {ok, #achievement_base{
            id = 10017
            ,name = <<"副本任务【二】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10016}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 3, target_value = 20}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10018) ->
    {ok, #achievement_base{
            id = 10018
            ,name = <<"副本任务【三】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10017}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 3, target_value = 100}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10019) ->
    {ok, #achievement_base{
            id = 10019
            ,name = <<"副本任务【四】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10018}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 3, target_value = 500}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
               ,#gain{label = honor_name, val = 20019}
            ]
        }
    };
    
get(10020) ->
    {ok, #achievement_base{
            id = 10020
            ,name = <<"修行任务【一】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 8, target_value = 10}
            ]
            ,rewards = [
                #gain{label = achievement, val = 5}
               ,#gain{label = gold_bind, val = 5}
            ]
        }
    };
    
get(10021) ->
    {ok, #achievement_base{
            id = 10021
            ,name = <<"修行任务【二】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10020}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 8, target_value = 50}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10022) ->
    {ok, #achievement_base{
            id = 10022
            ,name = <<"修行任务【三】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10021}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 8, target_value = 200}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10023) ->
    {ok, #achievement_base{
            id = 10023
            ,name = <<"修行任务【四】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10022}
            ]
            ,finish_cond = [
                #condition{label = finish_task_type, target = 8, target_value = 1000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
               ,#gain{label = honor_name, val = 20023}
            ]
        }
    };
    
get(10024) ->
    {ok, #achievement_base{
            id = 10024
            ,name = <<"任务试炼【一】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = finish_task, target = 0, target_value = 1000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 5}
               ,#gain{label = gold_bind, val = 5}
            ]
        }
    };
    
get(10025) ->
    {ok, #achievement_base{
            id = 10025
            ,name = <<"任务试炼【二】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10024}
            ]
            ,finish_cond = [
                #condition{label = finish_task, target = 0, target_value = 5000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10026) ->
    {ok, #achievement_base{
            id = 10026
            ,name = <<"任务试炼【三】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10025}
            ]
            ,finish_cond = [
                #condition{label = finish_task, target = 0, target_value = 10000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10027) ->
    {ok, #achievement_base{
            id = 10027
            ,name = <<"任务试炼【四】">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10026}
            ]
            ,finish_cond = [
                #condition{label = finish_task, target = 0, target_value = 20000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
               ,#gain{label = honor_name, val = 20027}
            ]
        }
    };
    
get(10028) ->
    {ok, #achievement_base{
            id = 10028
            ,name = <<"十年一剑">>
            ,system_type = 2
            ,type = 1
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20016, target_ext = 1, target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 200}
               ,#gain{label = gold_bind, val = 200}
               ,#gain{label = honor_name, val = 20028}
            ]
        }
    };
    
get(10029) ->
    {ok, #achievement_base{
            id = 10029
            ,name = <<"等级成就【一】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = lev, target = 0, target_value = 40}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10030) ->
    {ok, #achievement_base{
            id = 10030
            ,name = <<"等级成就【二】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10029}
            ]
            ,finish_cond = [
                #condition{label = lev, target = 0, target_value = 50}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10031) ->
    {ok, #achievement_base{
            id = 10031
            ,name = <<"等级成就【三】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10030}
            ]
            ,finish_cond = [
                #condition{label = lev, target = 0, target_value = 60}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10032) ->
    {ok, #achievement_base{
            id = 10032
            ,name = <<"等级成就【四】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10031}
            ]
            ,finish_cond = [
                #condition{label = lev, target = 0, target_value = 70}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10033) ->
    {ok, #achievement_base{
            id = 10033
            ,name = <<"等级成就【五】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10032}
            ]
            ,finish_cond = [
                #condition{label = lev, target = 0, target_value = 80}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10034) ->
    {ok, #achievement_base{
            id = 10034
            ,name = <<"等级成就【六】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10033}
            ]
            ,finish_cond = [
                #condition{label = lev, target = 0, target_value = 90}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10035) ->
    {ok, #achievement_base{
            id = 10035
            ,name = <<"等级成就【七】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10034}
            ]
            ,finish_cond = [
                #condition{label = lev, target = 0, target_value = 100}
            ]
            ,rewards = [
                #gain{label = achievement, val = 60}
               ,#gain{label = gold_bind, val = 60}
               ,#gain{label = honor_name, val = 20035}
            ]
        }
    };
    
get(10036) ->
    {ok, #achievement_base{
            id = 10036
            ,name = <<"元神成就【一】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20012, target_ext = 5, target_value = 5}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10037) ->
    {ok, #achievement_base{
            id = 10037
            ,name = <<"元神成就【二】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10036}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20012, target_ext = 6, target_value = 12}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10038) ->
    {ok, #achievement_base{
            id = 10038
            ,name = <<"元神成就【三】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10037}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20012, target_ext = 7, target_value = 12}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10039) ->
    {ok, #achievement_base{
            id = 10039
            ,name = <<"元神成就【四】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10038}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20012, target_ext = 10, target_value = 5}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10040) ->
    {ok, #achievement_base{
            id = 10040
            ,name = <<"元神成就【五】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10039}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20012, target_ext = 10, target_value = 12}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10041) ->
    {ok, #achievement_base{
            id = 10041
            ,name = <<"元神成就【六】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10040}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20012, target_ext = 20, target_value = 5}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10042) ->
    {ok, #achievement_base{
            id = 10042
            ,name = <<"元神成就【七】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10041}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20012, target_ext = 20, target_value = 12}
            ]
            ,rewards = [
                #gain{label = achievement, val = 60}
               ,#gain{label = gold_bind, val = 60}
               ,#gain{label = honor_name, val = 20042}
            ]
        }
    };
    
get(10043) ->
    {ok, #achievement_base{
            id = 10043
            ,name = <<"技能成就【一】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20013, target_ext = 7, target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10044) ->
    {ok, #achievement_base{
            id = 10044
            ,name = <<"技能成就【二】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10043}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20013, target_ext = 7, target_value = 8}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10045) ->
    {ok, #achievement_base{
            id = 10045
            ,name = <<"技能成就【三】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10044}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20013, target_ext = 9, target_value = 3}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10046) ->
    {ok, #achievement_base{
            id = 10046
            ,name = <<"技能成就【四】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10045}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20013, target_ext = 10, target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10047) ->
    {ok, #achievement_base{
            id = 10047
            ,name = <<"技能成就【五】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10046}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20013, target_ext = 10, target_value = 5}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10048) ->
    {ok, #achievement_base{
            id = 10048
            ,name = <<"技能成就【六】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10047}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20013, target_ext = 10, target_value = 13}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10049) ->
    {ok, #achievement_base{
            id = 10049
            ,name = <<"技能成就【七】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10048}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20013, target_ext = 11, target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 60}
               ,#gain{label = gold_bind, val = 60}
               ,#gain{label = honor_name, val = 20049}
            ]
        }
    };
    
get(10050) ->
    {ok, #achievement_base{
            id = 10050
            ,name = <<"财富成就【一】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = coin, target = 0, target_value = 400000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10051) ->
    {ok, #achievement_base{
            id = 10051
            ,name = <<"财富成就【二】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10050}
            ]
            ,finish_cond = [
                #condition{label = coin, target = 0, target_value = 800000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10052) ->
    {ok, #achievement_base{
            id = 10052
            ,name = <<"财富成就【三】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10051}
            ]
            ,finish_cond = [
                #condition{label = coin, target = 0, target_value = 1500000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10053) ->
    {ok, #achievement_base{
            id = 10053
            ,name = <<"财富成就【四】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10052}
            ]
            ,finish_cond = [
                #condition{label = coin, target = 0, target_value = 50000000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10054) ->
    {ok, #achievement_base{
            id = 10054
            ,name = <<"财富成就【五】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10053}
            ]
            ,finish_cond = [
                #condition{label = coin, target = 0, target_value = 90000000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 60}
               ,#gain{label = gold_bind, val = 60}
               ,#gain{label = honor_name, val = 20054}
            ]
        }
    };
    
get(10055) ->
    {ok, #achievement_base{
            id = 10055
            ,name = <<"战力成就【一】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20015, target_value = 2000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10056) ->
    {ok, #achievement_base{
            id = 10056
            ,name = <<"战力成就【二】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10055}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20015, target_value = 4000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10057) ->
    {ok, #achievement_base{
            id = 10057
            ,name = <<"战力成就【三】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10056}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20015, target_value = 6500}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10058) ->
    {ok, #achievement_base{
            id = 10058
            ,name = <<"战力成就【四】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10057}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20015, target_value = 12000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 60}
               ,#gain{label = gold_bind, val = 60}
               ,#gain{label = honor_name, val = 20058}
            ]
        }
    };
    
get(10059) ->
    {ok, #achievement_base{
            id = 10059
            ,name = <<"防具成就【一】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = [armor, -1, -1, 3], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10060) ->
    {ok, #achievement_base{
            id = 10060
            ,name = <<"防具成就【二】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = [armor, -1, -1, 4], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10061) ->
    {ok, #achievement_base{
            id = 10061
            ,name = <<"防具成就【三】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [armor, -1, 9, -1], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10062) ->
    {ok, #achievement_base{
            id = 10062
            ,name = <<"防具成就【四】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10061}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [armor, -1, 12, 4], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 60}
               ,#gain{label = gold_bind, val = 60}
               ,#gain{label = honor_name, val = 20062}
            ]
        }
    };
    
get(10063) ->
    {ok, #achievement_base{
            id = 10063
            ,name = <<"武器成就【一】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = [arms, -1, -1, 3], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10064) ->
    {ok, #achievement_base{
            id = 10064
            ,name = <<"武器成就【二】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = [arms, -1, -1, 4], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10065) ->
    {ok, #achievement_base{
            id = 10065
            ,name = <<"武器成就【三】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = [arms, -1, 9, -1], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10066) ->
    {ok, #achievement_base{
            id = 10066
            ,name = <<"武器成就【四】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10065}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = [arms, -1, 12, 4], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 60}
               ,#gain{label = gold_bind, val = 60}
               ,#gain{label = honor_name, val = 20066}
            ]
        }
    };
    
get(10067) ->
    {ok, #achievement_base{
            id = 10067
            ,name = <<"翅膀成就【一】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [38, -1, 5, -1], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10068) ->
    {ok, #achievement_base{
            id = 10068
            ,name = <<"翅膀成就【二】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10067}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [38, -1, 9, -1], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10069) ->
    {ok, #achievement_base{
            id = 10069
            ,name = <<"翅膀成就【三】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10068}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [38, -1, 12, -1], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 60}
               ,#gain{label = gold_bind, val = 60}
               ,#gain{label = honor_name, val = 20069}
            ]
        }
    };
    
get(10070) ->
    {ok, #achievement_base{
            id = 10070
            ,name = <<"坐骑成就【一】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [17, -1, 5, -1], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10071) ->
    {ok, #achievement_base{
            id = 10071
            ,name = <<"坐骑成就【二】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10070}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [17, -1, 9, -1], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10072) ->
    {ok, #achievement_base{
            id = 10072
            ,name = <<"坐骑成就【三】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10071}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [17, -1, 12, -1], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 60}
               ,#gain{label = gold_bind, val = 60}
               ,#gain{label = honor_name, val = 20072}
            ]
        }
    };
    
get(10073) ->
    {ok, #achievement_base{
            id = 10073
            ,name = <<"时装成就【一】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [14, -1, 9, -1], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10074) ->
    {ok, #achievement_base{
            id = 10074
            ,name = <<"时装成就【二】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10073}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [14, -1, 12, -1], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 60}
               ,#gain{label = gold_bind, val = 60}
            ]
        }
    };
    
get(10075) ->
    {ok, #achievement_base{
            id = 10075
            ,name = <<"时装成就【三】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = dress, target_value = 2}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10076) ->
    {ok, #achievement_base{
            id = 10076
            ,name = <<"时装成就【四】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10075}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = dress, target_value = 8}
            ]
            ,rewards = [
                #gain{label = achievement, val = 60}
               ,#gain{label = gold_bind, val = 60}
               ,#gain{label = honor_name, val = 20076}
            ]
        }
    };
    
get(10077) ->
    {ok, #achievement_base{
            id = 10077
            ,name = <<"套装成就【一】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [suit, 40, -1, 4], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10078) ->
    {ok, #achievement_base{
            id = 10078
            ,name = <<"套装成就【二】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [suit, 50, -1, 4], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10079) ->
    {ok, #achievement_base{
            id = 10079
            ,name = <<"套装成就【三】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10078}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [suit, 60, -1, 4], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10080) ->
    {ok, #achievement_base{
            id = 10080
            ,name = <<"套装成就【四】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10079}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [suit, 70, -1, 4], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10081) ->
    {ok, #achievement_base{
            id = 10081
            ,name = <<"套装成就【五】">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10080}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [suit, 80, -1, 4], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 60}
               ,#gain{label = gold_bind, val = 60}
               ,#gain{label = honor_name, val = 20081}
            ]
        }
    };
    
get(10082) ->
    {ok, #achievement_base{
            id = 10082
            ,name = <<"神人成就">>
            ,system_type = 2
            ,type = 2
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20016, target_ext = 2, target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 600}
               ,#gain{label = gold_bind, val = 600}
               ,#gain{label = honor_name, val = 20082}
            ]
        }
    };
    
get(10083) ->
    {ok, #achievement_base{
            id = 10083
            ,name = <<"好友成就【一】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = has_friend, target = 0, target_value = 10}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10084) ->
    {ok, #achievement_base{
            id = 10084
            ,name = <<"好友成就【二】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10083}
            ]
            ,finish_cond = [
                #condition{label = has_friend, target = 0, target_value = 30}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10085) ->
    {ok, #achievement_base{
            id = 10085
            ,name = <<"好友成就【三】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10084}
            ]
            ,finish_cond = [
                #condition{label = has_friend, target = 0, target_value = 50}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10086) ->
    {ok, #achievement_base{
            id = 10086
            ,name = <<"好友成就【四】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10085}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20009, target_ext = 12000, target_value = 5}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
               ,#gain{label = honor_name, val = 20086}
            ]
        }
    };
    
get(10087) ->
    {ok, #achievement_base{
            id = 10087
            ,name = <<"双修成就【一】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20011, target_value = 60}
            ]
            ,rewards = [
                #gain{label = achievement, val = 5}
               ,#gain{label = gold_bind, val = 5}
            ]
        }
    };
    
get(10088) ->
    {ok, #achievement_base{
            id = 10088
            ,name = <<"双修成就【二】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10087}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20011, target_value = 600}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10089) ->
    {ok, #achievement_base{
            id = 10089
            ,name = <<"双修成就【三】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10088}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20011, target_value = 6000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10090) ->
    {ok, #achievement_base{
            id = 10090
            ,name = <<"双修成就【四】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10089}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20011, target_value = 60000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10091) ->
    {ok, #achievement_base{
            id = 10091
            ,name = <<"双修成就【五】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10090}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20011, target_value = 130000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
               ,#gain{label = honor_name, val = 20091}
            ]
        }
    };
    
get(10092) ->
    {ok, #achievement_base{
            id = 10092
            ,name = <<"送花成就【一】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20017, target_value = 99}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10093) ->
    {ok, #achievement_base{
            id = 10093
            ,name = <<"送花成就【二】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20017, target_value = 999}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10094) ->
    {ok, #achievement_base{
            id = 10094
            ,name = <<"送花成就【三】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10093}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20017, target_value = 1314}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10095) ->
    {ok, #achievement_base{
            id = 10095
            ,name = <<"送花成就【四】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10094}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20017, target_value = 9999}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
               ,#gain{label = honor_name, val = 20095}
            ]
        }
    };
    
get(10096) ->
    {ok, #achievement_base{
            id = 10096
            ,name = <<"亲密成就【一】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20009, target_value = 99}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10097) ->
    {ok, #achievement_base{
            id = 10097
            ,name = <<"亲密成就【二】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10096}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20009, target_value = 999}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10098) ->
    {ok, #achievement_base{
            id = 10098
            ,name = <<"亲密成就【三】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10097}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20009, target_value = 3000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10099) ->
    {ok, #achievement_base{
            id = 10099
            ,name = <<"亲密成就【四】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10098}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20009, target_value = 9999}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
               ,#gain{label = honor_name, val = 20099}
            ]
        }
    };
    
get(10100) ->
    {ok, #achievement_base{
            id = 10100
            ,name = <<"魅力成就【一】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20018, target_value = 99}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10101) ->
    {ok, #achievement_base{
            id = 10101
            ,name = <<"魅力成就【二】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20018, target_value = 999}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10102) ->
    {ok, #achievement_base{
            id = 10102
            ,name = <<"魅力成就【三】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10101}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20018, target_value = 5000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10103) ->
    {ok, #achievement_base{
            id = 10103
            ,name = <<"魅力成就【四】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10102}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20018, target_value = 30000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
               ,#gain{label = honor_name, val = 20103}
            ]
        }
    };
    
get(10104) ->
    {ok, #achievement_base{
            id = 10104
            ,name = <<"帮贡成就【一】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20005, target_value = 666}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10105) ->
    {ok, #achievement_base{
            id = 10105
            ,name = <<"帮贡成就【二】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10104}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20005, target_value = 6666}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10106) ->
    {ok, #achievement_base{
            id = 10106
            ,name = <<"帮贡成就【三】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10105}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20005, target_value = 66666}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10107) ->
    {ok, #achievement_base{
            id = 10107
            ,name = <<"帮贡成就【四】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10106}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20005, target_value = 666666}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
               ,#gain{label = honor_name, val = 20107}
            ]
        }
    };
    
get(10185) ->
    {ok, #achievement_base{
            id = 10185
            ,name = <<"师傅成就【一】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 122, target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
               ,#gain{label = honor_name, val = 20185}
            ]
        }
    };
    
get(10186) ->
    {ok, #achievement_base{
            id = 10186
            ,name = <<"师傅成就【二】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10185}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 122, target_value = 3}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
               ,#gain{label = honor_name, val = 20186}
            ]
        }
    };
    
get(10187) ->
    {ok, #achievement_base{
            id = 10187
            ,name = <<"师傅成就【三】">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10186}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 122, target_value = 5}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
               ,#gain{label = honor_name, val = 20187}
            ]
        }
    };
    
get(10108) ->
    {ok, #achievement_base{
            id = 10108
            ,name = <<"名流成就">>
            ,system_type = 2
            ,type = 3
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20016, target_ext = 3, target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 250}
               ,#gain{label = gold_bind, val = 250}
               ,#gain{label = honor_name, val = 20108}
            ]
        }
    };
    
get(10109) ->
    {ok, #achievement_base{
            id = 10109
            ,name = <<"竞技成就【一】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20022, target_value = 10}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10110) ->
    {ok, #achievement_base{
            id = 10110
            ,name = <<"竞技成就【二】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10109}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20022, target_value = 50}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10111) ->
    {ok, #achievement_base{
            id = 10111
            ,name = <<"竞技成就【三】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10110}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20022, target_value = 500}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10112) ->
    {ok, #achievement_base{
            id = 10112
            ,name = <<"竞技成就【四】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10111}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20022, target_value = 3000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
               ,#gain{label = honor_name, val = 20112}
            ]
        }
    };
    
get(10113) ->
    {ok, #achievement_base{
            id = 10113
            ,name = <<"刺杀成就【一】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 110, target_value = 10}
            ]
            ,rewards = [
                #gain{label = achievement, val = 10}
               ,#gain{label = gold_bind, val = 10}
            ]
        }
    };
    
get(10114) ->
    {ok, #achievement_base{
            id = 10114
            ,name = <<"刺杀成就【二】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10113}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 110, target_value = 100}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10115) ->
    {ok, #achievement_base{
            id = 10115
            ,name = <<"刺杀成就【三】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10114}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 110, target_value = 500}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10116) ->
    {ok, #achievement_base{
            id = 10116
            ,name = <<"刺杀成就【四】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10115}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 110, target_value = 1000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10117) ->
    {ok, #achievement_base{
            id = 10117
            ,name = <<"刺杀成就【五】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10116}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 110, target_value = 5000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
               ,#gain{label = honor_name, val = 20117}
            ]
        }
    };
    
get(10118) ->
    {ok, #achievement_base{
            id = 10118
            ,name = <<"BOSS成就【一】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = world_boss, target = 0, target_value = 5}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10119) ->
    {ok, #achievement_base{
            id = 10119
            ,name = <<"BOSS成就【二】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10118}
            ]
            ,finish_cond = [
                #condition{label = world_boss, target = 0, target_value = 500}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10120) ->
    {ok, #achievement_base{
            id = 10120
            ,name = <<"BOSS成就【三】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10119}
            ]
            ,finish_cond = [
                #condition{label = world_boss, target = 0, target_value = 3000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
               ,#gain{label = honor_name, val = 20120}
            ]
        }
    };
    
get(10121) ->
    {ok, #achievement_base{
            id = 10121
            ,name = <<"帮战成就【一】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20019, target_value = 2000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10122) ->
    {ok, #achievement_base{
            id = 10122
            ,name = <<"帮战成就【二】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10121}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20019, target_value = 10000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10123) ->
    {ok, #achievement_base{
            id = 10123
            ,name = <<"帮战成就【三】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10122}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20019, target_value = 50000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10124) ->
    {ok, #achievement_base{
            id = 10124
            ,name = <<"帮战成就【四】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10123}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20019, target_value = 150000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
               ,#gain{label = honor_name, val = 20124}
            ]
        }
    };
    
get(10160) ->
    {ok, #achievement_base{
            id = 10160
            ,name = <<"S级成就【一】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 121, target_ext = 3, target_value = 10}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10161) ->
    {ok, #achievement_base{
            id = 10161
            ,name = <<"S级成就【二】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10160}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 121, target_ext = 3, target_value = 300}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10162) ->
    {ok, #achievement_base{
            id = 10162
            ,name = <<"S级成就【三】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10161}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 121, target_ext = 3, target_value = 1000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10163) ->
    {ok, #achievement_base{
            id = 10163
            ,name = <<"S级成就【四】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10162}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 121, target_ext = 3, target_value = 2000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
               ,#gain{label = honor_name, val = 20163}
            ]
        }
    };
    
get(10164) ->
    {ok, #achievement_base{
            id = 10164
            ,name = <<"SSS级成就【一】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 121, target_ext = 1, target_value = 10}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10165) ->
    {ok, #achievement_base{
            id = 10165
            ,name = <<"SSS级成就【二】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10164}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 121, target_ext = 1, target_value = 300}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10166) ->
    {ok, #achievement_base{
            id = 10166
            ,name = <<"SSS级成就【三】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10165}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 121, target_ext = 1, target_value = 1000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10167) ->
    {ok, #achievement_base{
            id = 10167
            ,name = <<"SSS级成就【四】">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10166}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 121, target_ext = 1, target_value = 2000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 60}
               ,#gain{label = gold_bind, val = 60}
               ,#gain{label = honor_name, val = 20167}
            ]
        }
    };
    
get(10125) ->
    {ok, #achievement_base{
            id = 10125
            ,name = <<"征战四方">>
            ,system_type = 2
            ,type = 4
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20016, target_ext = 4, target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 400}
               ,#gain{label = gold_bind, val = 400}
               ,#gain{label = honor_name, val = 20125}
            ]
        }
    };
    
get(10126) ->
    {ok, #achievement_base{
            id = 10126
            ,name = <<"成长成就【一】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20006, target_value = 10}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10127) ->
    {ok, #achievement_base{
            id = 10127
            ,name = <<"成长成就【二】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10126}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20006, target_value = 30}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10128) ->
    {ok, #achievement_base{
            id = 10128
            ,name = <<"成长成就【三】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10127}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20006, target_value = 40}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10129) ->
    {ok, #achievement_base{
            id = 10129
            ,name = <<"成长成就【四】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10128}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20006, target_value = 50}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10130) ->
    {ok, #achievement_base{
            id = 10130
            ,name = <<"成长成就【五】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10129}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20006, target_value = 60}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
               ,#gain{label = honor_name, val = 20130}
            ]
        }
    };
    
get(10131) ->
    {ok, #achievement_base{
            id = 10131
            ,name = <<"收集成就【一】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 112, target_value = 100}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10132) ->
    {ok, #achievement_base{
            id = 10132
            ,name = <<"收集成就【二】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10131}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 112, target_value = 500}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10133) ->
    {ok, #achievement_base{
            id = 10133
            ,name = <<"收集成就【三】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10132}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 112, target_value = 1000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10134) ->
    {ok, #achievement_base{
            id = 10134
            ,name = <<"收集成就【四】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev_val, target = 0, target_value = 10133}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 112, target_value = 2000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
               ,#gain{label = honor_name, val = 20134}
            ]
        }
    };
    
get(10135) ->
    {ok, #achievement_base{
            id = 10135
            ,name = <<"宠战成就【一】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20020, target_value = 1000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 15}
               ,#gain{label = gold_bind, val = 15}
            ]
        }
    };
    
get(10136) ->
    {ok, #achievement_base{
            id = 10136
            ,name = <<"宠战成就【二】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10135}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20020, target_value = 3000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10137) ->
    {ok, #achievement_base{
            id = 10137
            ,name = <<"宠战成就【三】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10136}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20020, target_value = 5000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10138) ->
    {ok, #achievement_base{
            id = 10138
            ,name = <<"宠战成就【四】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10137}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20020, target_value = 7000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10139) ->
    {ok, #achievement_base{
            id = 10139
            ,name = <<"宠战成就【五】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10138}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20020, target_value = 8000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
               ,#gain{label = honor_name, val = 20139}
            ]
        }
    };
    
get(10140) ->
    {ok, #achievement_base{
            id = 10140
            ,name = <<"潜力成就【一】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20021, target_value = 150}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10141) ->
    {ok, #achievement_base{
            id = 10141
            ,name = <<"潜力成就【二】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10140}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20021, target_value = 200}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10142) ->
    {ok, #achievement_base{
            id = 10142
            ,name = <<"潜力成就【三】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10141}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20021, target_value = 250}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10143) ->
    {ok, #achievement_base{
            id = 10143
            ,name = <<"潜力成就【四】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10142}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20021, target_value = 300}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
               ,#gain{label = honor_name, val = 20143}
            ]
        }
    };
    
get(10144) ->
    {ok, #achievement_base{
            id = 10144
            ,name = <<"技能成就【一】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20002, target_ext = [3, 1], target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10145) ->
    {ok, #achievement_base{
            id = 10145
            ,name = <<"技能成就【二】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10144}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20002, target_ext = [3, 1], target_value = 3}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10146) ->
    {ok, #achievement_base{
            id = 10146
            ,name = <<"技能成就【三】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10145}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20002, target_ext = [3, 1], target_value = 5}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10147) ->
    {ok, #achievement_base{
            id = 10147
            ,name = <<"技能成就【四】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10146}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20002, target_ext = [3, 1], target_value = 8}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
               ,#gain{label = honor_name, val = 20147}
            ]
        }
    };
    
get(10168) ->
    {ok, #achievement_base{
            id = 10168
            ,name = <<"仙宠调教【一】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20023, target_value = 20}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10169) ->
    {ok, #achievement_base{
            id = 10169
            ,name = <<"仙宠调教【二】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10168}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20023, target_value = 50}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10170) ->
    {ok, #achievement_base{
            id = 10170
            ,name = <<"仙宠调教【三】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10169}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20023, target_value = 100}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10171) ->
    {ok, #achievement_base{
            id = 10171
            ,name = <<"仙宠调教【四】">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10170}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20023, target_value = 200}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
               ,#gain{label = honor_name, val = 20171}
            ]
        }
    };
    
get(10148) ->
    {ok, #achievement_base{
            id = 10148
            ,name = <<"异宠成就">>
            ,system_type = 2
            ,type = 5
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20016, target_ext = 5, target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 500}
               ,#gain{label = gold_bind, val = 500}
               ,#gain{label = honor_name, val = 20148}
            ]
        }
    };
    
get(10200) ->
    {ok, #achievement_base{
            id = 10200
            ,name = <<"翅膀进阶【一】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = wing_step, target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10201) ->
    {ok, #achievement_base{
            id = 10201
            ,name = <<"翅膀进阶【二】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10200}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = wing_step, target_value = 3}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10202) ->
    {ok, #achievement_base{
            id = 10202
            ,name = <<"翅膀进阶【三】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10201}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = wing_step, target_value = 5}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10203) ->
    {ok, #achievement_base{
            id = 10203
            ,name = <<"翅膀进阶【四】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10202}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = wing_step, target_value = 8}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10204) ->
    {ok, #achievement_base{
            id = 10204
            ,name = <<"翅膀进阶【五】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10203}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = wing_step, target_value = 11}
            ]
            ,rewards = [
                #gain{label = achievement, val = 100}
               ,#gain{label = gold_bind, val = 100}
               ,#gain{label = honor_name, val = 20204}
            ]
        }
    };
    
get(10205) ->
    {ok, #achievement_base{
            id = 10205
            ,name = <<"坐骑进阶【一】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = mount_step, target_value = 1}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10206) ->
    {ok, #achievement_base{
            id = 10206
            ,name = <<"坐骑进阶【二】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10205}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = mount_step, target_value = 3}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10207) ->
    {ok, #achievement_base{
            id = 10207
            ,name = <<"坐骑进阶【三】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10206}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = mount_step, target_value = 5}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10208) ->
    {ok, #achievement_base{
            id = 10208
            ,name = <<"坐骑进阶【四】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10207}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = mount_step, target_value = 7}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10209) ->
    {ok, #achievement_base{
            id = 10209
            ,name = <<"坐骑进阶【五】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10208}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = mount_step, target_value = 8}
            ]
            ,rewards = [
                #gain{label = achievement, val = 100}
               ,#gain{label = gold_bind, val = 100}
               ,#gain{label = honor_name, val = 20209}
            ]
        }
    };
    
get(10210) ->
    {ok, #achievement_base{
            id = 10210
            ,name = <<"坐骑战力【一】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20024, target_value = 3000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10211) ->
    {ok, #achievement_base{
            id = 10211
            ,name = <<"坐骑战力【二】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10210}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20024, target_value = 5000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10212) ->
    {ok, #achievement_base{
            id = 10212
            ,name = <<"坐骑战力【三】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10211}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20024, target_value = 10000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10213) ->
    {ok, #achievement_base{
            id = 10213
            ,name = <<"坐骑战力【四】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10212}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20024, target_value = 20000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10214) ->
    {ok, #achievement_base{
            id = 10214
            ,name = <<"坐骑战力【五】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10213}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20024, target_value = 50000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 100}
               ,#gain{label = gold_bind, val = 100}
               ,#gain{label = honor_name, val = 20214}
            ]
        }
    };
    
get(10215) ->
    {ok, #achievement_base{
            id = 10215
            ,name = <<"灵戒战力【一】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20025, target_value = 3000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10216) ->
    {ok, #achievement_base{
            id = 10216
            ,name = <<"灵戒战力【二】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10215}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20025, target_value = 5000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10217) ->
    {ok, #achievement_base{
            id = 10217
            ,name = <<"灵戒战力【三】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10216}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20025, target_value = 10000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10218) ->
    {ok, #achievement_base{
            id = 10218
            ,name = <<"灵戒战力【四】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10217}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20025, target_value = 15000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10219) ->
    {ok, #achievement_base{
            id = 10219
            ,name = <<"灵戒战力【五】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10218}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20025, target_value = 20000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 100}
               ,#gain{label = gold_bind, val = 100}
               ,#gain{label = honor_name, val = 20219}
            ]
        }
    };
    
get(10220) ->
    {ok, #achievement_base{
            id = 10220
            ,name = <<"妖灵战力【一】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20026, target_value = 1000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10221) ->
    {ok, #achievement_base{
            id = 10221
            ,name = <<"妖灵战力【二】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10220}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20026, target_value = 2000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10222) ->
    {ok, #achievement_base{
            id = 10222
            ,name = <<"妖灵战力【三】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10221}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20026, target_value = 3000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10223) ->
    {ok, #achievement_base{
            id = 10223
            ,name = <<"妖灵战力【四】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10222}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20026, target_value = 4000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10224) ->
    {ok, #achievement_base{
            id = 10224
            ,name = <<"妖灵战力【五】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10223}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20026, target_value = 5000}
            ]
            ,rewards = [
                #gain{label = achievement, val = 100}
               ,#gain{label = gold_bind, val = 100}
               ,#gain{label = honor_name, val = 20224}
            ]
        }
    };
    
get(10225) ->
    {ok, #achievement_base{
            id = 10225
            ,name = <<"极品妖灵【一】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 124, target_ext = 1, target_value = 6}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10226) ->
    {ok, #achievement_base{
            id = 10226
            ,name = <<"极品妖灵【二】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10225}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 124, target_ext = 2, target_value = 6}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10227) ->
    {ok, #achievement_base{
            id = 10227
            ,name = <<"极品妖灵【三】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10226}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 124, target_ext = 3, target_value = 6}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10228) ->
    {ok, #achievement_base{
            id = 10228
            ,name = <<"极品妖灵【四】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10227}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 124, target_ext = 4, target_value = 6}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10229) ->
    {ok, #achievement_base{
            id = 10229
            ,name = <<"极品妖灵【五】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10228}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 124, target_ext = 4, target_value = 10}
            ]
            ,rewards = [
                #gain{label = achievement, val = 100}
               ,#gain{label = gold_bind, val = 100}
               ,#gain{label = honor_name, val = 20229}
            ]
        }
    };
    
get(10230) ->
    {ok, #achievement_base{
            id = 10230
            ,name = <<"神魔阵【一】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20027, target_value = 100}
            ]
            ,rewards = [
                #gain{label = achievement, val = 20}
               ,#gain{label = gold_bind, val = 20}
            ]
        }
    };
    
get(10231) ->
    {ok, #achievement_base{
            id = 10231
            ,name = <<"神魔阵【二】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10230}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20027, target_value = 200}
            ]
            ,rewards = [
                #gain{label = achievement, val = 25}
               ,#gain{label = gold_bind, val = 25}
            ]
        }
    };
    
get(10232) ->
    {ok, #achievement_base{
            id = 10232
            ,name = <<"神魔阵【三】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10231}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20027, target_value = 300}
            ]
            ,rewards = [
                #gain{label = achievement, val = 40}
               ,#gain{label = gold_bind, val = 40}
            ]
        }
    };
    
get(10233) ->
    {ok, #achievement_base{
            id = 10233
            ,name = <<"神魔阵【四】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10232}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20027, target_value = 500}
            ]
            ,rewards = [
                #gain{label = achievement, val = 50}
               ,#gain{label = gold_bind, val = 50}
            ]
        }
    };
    
get(10234) ->
    {ok, #achievement_base{
            id = 10234
            ,name = <<"神魔阵【五】">>
            ,system_type = 2
            ,type = 6
            ,accept_cond = [
                #condition{label = prev, target = 0, target_value = 10233}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20027, target_value = 800}
            ]
            ,rewards = [
                #gain{label = achievement, val = 100}
               ,#gain{label = gold_bind, val = 100}
               ,#gain{label = honor_name, val = 20234}
            ]
        }
    };
    
get(90101) ->
    {ok, #achievement_base{
            id = 90101
            ,name = <<"我有仙宠了">>
            ,system_type = 1
            ,type = 1
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 1011, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [23000, 1, 5]}
               ,#gain{label = item, val = [23002, 1, 1]}
            ]
        }
    };
    
get(90102) ->
    {ok, #achievement_base{
            id = 90102
            ,name = <<"选择职业">>
            ,system_type = 1
            ,type = 1
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = special_event, target = 1001, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [21000, 1, 1]}
            ]
        }
    };
    
get(90103) ->
    {ok, #achievement_base{
            id = 90103
            ,name = <<"一骑绝尘">>
            ,system_type = 1
            ,type = 1
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [17, -1, -1, -1], target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [21000, 1, 1]}
            ]
        }
    };
    
get(90104) ->
    {ok, #achievement_base{
            id = 90104
            ,name = <<"高朋满座">>
            ,system_type = 1
            ,type = 1
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = has_friend, target = 0, target_value = 5}
            ]
            ,rewards = [
                #gain{label = item, val = [30011, 1, 1]}
            ]
        }
    };
    
get(90105) ->
    {ok, #achievement_base{
            id = 90105
            ,name = <<"封印蛟妖">>
            ,system_type = 1
            ,type = 1
            ,accept_cond = [
                            ]
            ,finish_cond = [
                #condition{label = kill_npc, target = 30005, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [31001, 1, 3]}
            ]
        }
    };
    
get(90201) ->
    {ok, #achievement_base{
            id = 90201
            ,name = <<"聚义一堂">>
            ,system_type = 1
            ,type = 2
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 30}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20001, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [30011, 1, 3]}
               ,#gain{label = item, val = [33010, 1, 3]}
            ]
        }
    };
    
get(90203) ->
    {ok, #achievement_base{
            id = 90203
            ,name = <<"青松古事">>
            ,system_type = 1
            ,type = 2
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 30}
            ]
            ,finish_cond = [
                #condition{label = kill_npc, target = 30017, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [25021, 1, 1]}
            ]
        }
    };
    
get(90204) ->
    {ok, #achievement_base{
            id = 90204
            ,name = <<"御虚炼神">>
            ,system_type = 1
            ,type = 2
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 30}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 1004, target_ext = 3, target_value = 12}
            ]
            ,rewards = [
                #gain{label = item, val = [32000, 1, 3]}
            ]
        }
    };
    
get(90205) ->
    {ok, #achievement_base{
            id = 90205
            ,name = <<"洗炼装备">>
            ,system_type = 1
            ,type = 2
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 30}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 111, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [27001, 1, 3]}
            ]
        }
    };
    
get(90206) ->
    {ok, #achievement_base{
            id = 90206
            ,name = <<"装备强化">>
            ,system_type = 1
            ,type = 2
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 30}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 1002, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [21020, 1, 3]}
            ]
        }
    };
    
get(90301) ->
    {ok, #achievement_base{
            id = 90301
            ,name = <<"第一滴血">>
            ,system_type = 1
            ,type = 3
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 40}
            ]
            ,finish_cond = [
                #condition{label = acc_event, target = 106, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [26004, 1, 1]}
               ,#gain{label = item, val = [26002, 1, 1]}
            ]
        }
    };
    
get(90302) ->
    {ok, #achievement_base{
            id = 90302
            ,name = <<"洛水殿夺宝">>
            ,system_type = 1
            ,type = 3
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 40}
            ]
            ,finish_cond = [
                #condition{label = kill_npc, target = 0, target_ext = [30075,30080,30085,30090,30101,30158], target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [30022, 1, 10]}
            ]
        }
    };
    
get(90303) ->
    {ok, #achievement_base{
            id = 90303
            ,name = <<"巡狩四方">>
            ,system_type = 1
            ,type = 3
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 40}
            ]
            ,finish_cond = [
                #condition{label = kill_npc, target = 0, target_ext = [25000,25016,25020], target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [33010, 1, 10]}
               ,#gain{label = item, val = [30011, 1, 3]}
               ,#gain{label = item, val = [25021, 1, 1]}
            ]
        }
    };
    
get(90304) ->
    {ok, #achievement_base{
            id = 90304
            ,name = <<"极道神兵">>
            ,system_type = 1
            ,type = 3
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 40}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = [arms, -1, -1, 3], target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [21000, 1, 5]}
               ,#gain{label = item, val = [27002, 1, 3]}
            ]
        }
    };
    
get(90305) ->
    {ok, #achievement_base{
            id = 90305
            ,name = <<"镇封妖邪">>
            ,system_type = 1
            ,type = 3
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 40}
            ]
            ,finish_cond = [
                #condition{label = kill_npc, target = 30057, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [22202, 1, 3]}
            ]
        }
    };
    
get(90306) ->
    {ok, #achievement_base{
            id = 90306
            ,name = <<"葬花情缘">>
            ,system_type = 1
            ,type = 3
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 40}
            ]
            ,finish_cond = [
                #condition{label = kill_npc, target = 30011, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [30210, 1, 5]}
            ]
        }
    };
    
get(90401) ->
    {ok, #achievement_base{
            id = 90401
            ,name = <<"谁与争锋">>
            ,system_type = 1
            ,type = 4
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 50}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = [arms, -1, -1, 4], target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [27003, 1, 3]}
               ,#gain{label = item, val = [21000, 1, 5]}
            ]
        }
    };
    
get(90402) ->
    {ok, #achievement_base{
            id = 90402
            ,name = <<"神庙诛妖">>
            ,system_type = 1
            ,type = 4
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 50}
            ]
            ,finish_cond = [
                #condition{label = kill_npc, target = 30023, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [30210, 1, 5]}
               ,#gain{label = item, val = [32531, 1, 5]}
            ]
        }
    };
    
get(90403) ->
    {ok, #achievement_base{
            id = 90403
            ,name = <<"动我试试">>
            ,system_type = 1
            ,type = 4
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 50}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 1, target_ext = [armor, -1, 8, -1], target_value = 6}
            ]
            ,rewards = [
                #gain{label = item, val = [22020, 1, 3]}
               ,#gain{label = item, val = [22030, 1, 3]}
               ,#gain{label = item, val = [21020, 1, 5]}
            ]
        }
    };
    
get(90404) ->
    {ok, #achievement_base{
            id = 90404
            ,name = <<"炼神返虚">>
            ,system_type = 1
            ,type = 4
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 50}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20012, target_ext = 5, target_value = 12}
            ]
            ,rewards = [
                #gain{label = item, val = [32001, 1, 1]}
            ]
        }
    };
    
get(90405) ->
    {ok, #achievement_base{
            id = 90405
            ,name = <<"绝世灵甲">>
            ,system_type = 1
            ,type = 4
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 50}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = [suit, -1, 0, 3], target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [22202, 1, 3]}
               ,#gain{label = item, val = [27002, 1, 3]}
            ]
        }
    };
    
get(90406) ->
    {ok, #achievement_base{
            id = 90406
            ,name = <<"狩猎之王">>
            ,system_type = 1
            ,type = 4
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 50}
            ]
            ,finish_cond = [
                #condition{label = kill_npc, target = 0, target_ext = [25001,25002,25003], target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [25021, 1, 1]}
               ,#gain{label = item, val = [26042, 1, 1]}
               ,#gain{label = item, val = [26040, 1, 1]}
               ,#gain{label = item, val = [30210, 1, 10]}
            ]
        }
    };
    
get(90501) ->
    {ok, #achievement_base{
            id = 90501
            ,name = <<"如虎添翼">>
            ,system_type = 1
            ,type = 5
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 60}
            ]
            ,finish_cond = [
                #condition{label = eqm_event, target = 0, target_ext = wing_fly, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [21020, 1, 5]}
            ]
        }
    };
    
get(90502) ->
    {ok, #achievement_base{
            id = 90502
            ,name = <<"独孤求败">>
            ,system_type = 1
            ,type = 5
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 60}
            ]
            ,finish_cond = [
                #condition{label = special_event, target = 20015, target_value = 8000}
            ]
            ,rewards = [
                #gain{label = item, val = [21011, 1, 5]}
               ,#gain{label = item, val = [27003, 1, 5]}
            ]
        }
    };
    
get(90503) ->
    {ok, #achievement_base{
            id = 90503
            ,name = <<"傲视群雄">>
            ,system_type = 1
            ,type = 5
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 60}
            ]
            ,finish_cond = [
                #condition{label = kill_npc, target = 30065, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [22203, 1, 3]}
            ]
        }
    };
    
get(90504) ->
    {ok, #achievement_base{
            id = 90504
            ,name = <<"狩猎帝尊">>
            ,system_type = 1
            ,type = 5
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 60}
            ]
            ,finish_cond = [
                #condition{label = kill_npc, target = 0, target_ext = [25004,25005,25006], target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [25021, 1, 1]}
               ,#gain{label = item, val = [26062, 1, 1]}
               ,#gain{label = item, val = [26060, 1, 1]}
               ,#gain{label = item, val = [30210, 1, 10]}
            ]
        }
    };
    
get(90505) ->
    {ok, #achievement_base{
            id = 90505
            ,name = <<"洛水龙宫">>
            ,system_type = 1
            ,type = 5
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 60}
            ]
            ,finish_cond = [
                #condition{label = kill_npc, target = 25043, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [22221, 1, 1]}
            ]
        }
    };
    
get(90506) ->
    {ok, #achievement_base{
            id = 90506
            ,name = <<"魔宫除妖">>
            ,system_type = 1
            ,type = 5
            ,accept_cond = [
                #condition{label = lev, target = 0, target_value = 60}
            ]
            ,finish_cond = [
                #condition{label = kill_npc, target = 30029, target_value = 1}
            ]
            ,rewards = [
                #gain{label = item, val = [32532, 1, 5]}
            ]
        }
    };
    
get(_Id) ->
    {false, <<"不存在此成就数据">>}.
