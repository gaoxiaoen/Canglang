%% --------------------------
%% 活动数据 
%% @author shawnoyc@vip.qq.com
%% --------------------------
-module(campaign_data).
-export([
        get/1
       ,start_list/0
       ,to_expire/1
       ,get_expire_list/0
       ,get_merge_camp/0
       ,get_merge_camp_ids/0
       ,get_campaign_charge_ids/0
       ,get_camp_pool_time/0
       ,get_offline_camp/0
    ]
).

-include("campaign.hrl").
-include("vip.hrl").
-include("common.hrl").
-include("item.hrl").

%% campaign 结构
%%   -record(campaign, {
%%       id          = 0                          %% 活动ID
%%       ,title      = <<>>                       %% 活动名字
%%       ,begin_time = 0  %% {{2011,1,1},{1,1,1}} %% 活动开始时间
%%       ,end_time   = 0  %% {{2011,1,1},{1,1,1}} %% 活动结束时间
%%       ,do_begin = []                           %% 活动开始执行操作
%%       ,do_end = []                             %% 活动结束执行操作
%%       ,do_login = []                           %% 活动登录执行操作
%%       ,do_logout = []                          %% 活动下线执行操作
%%       ,do_charge = []                          %% 充值进行操作
%%       ,desc    = <<>>                       %% 活动描述
%%   }).

%% 温泉类活动
get_camp_pool_time() ->
    Now = util:unixtime(),
    BeginTime = util:datetime_to_seconds({{2012, 12, 8},{0,0,0}}),
    EndTime = util:datetime_to_seconds({{2012,12,10},{23,59,59}}),
    case Now >= BeginTime andalso Now =< EndTime of
        true -> true;
        false -> campaign_adm:is_camp_time(spring_double)
    end.

%% 王者归来
get_offline_camp() ->
    Now = util:unixtime(),
    BeginTime = util:datetime_to_seconds({{2012, 6,20},{4,0,0}}),
    EndTime = util:datetime_to_seconds({{2012,6,23},{23,59,59}}),
    Now >= BeginTime andalso Now =< EndTime.

%% --------------------------------------
is_koram() ->
    case util:platform(undefined) of
        "koramgame" -> true;
        _ -> false
    end.

%% 合服活动所有累积充值活动ID
get_merge_camp_ids() -> [].

%% 记录当前活动周期内，累积充值活动ID列表(用于推送弹窗)；每次活动更新
get_campaign_charge_ids() ->
    [402].

get_expire_list() ->
    [16700, 16701, 16702, 16703, 16704].

get_merge_camp() ->
    case is_koram() of
        true -> [{?STARTMODE_1, 1000, 86400 * 6}, {?STARTMODE_2, 1002, 3600*2}];
        false -> [{?STARTMODE_1, 1000, 86400 * 6}, {?STARTMODE_1, 1001, 86400 * 2}, {?STARTMODE_2, 1002, 3600*2}, {?STARTMODE_1, 1003, 86400 * 2}]
    end.

to_expire(16700) -> do_expire(16700);
to_expire(16701) -> do_expire(16701);
to_expire(16702) -> do_expire(16702);
to_expire(16703) -> do_expire(16703);
to_expire(16704) -> do_expire(16704);
to_expire(_) -> [].

do_expire(BaseId) when BaseId >= 16700 andalso BaseId =< 16704 ->
    Now = util:unixtime(),
    [{?special_expire_time, Now + 86400 * 7}];
do_expire(_BaseId) ->
    case util:datetime_to_seconds({{2012, 5, 14}, {23, 59, 10}}) of
        false ->
            ?ERR("物品失效时间转换失败"),
            [];
        Time -> [{?special_expire_time, Time}]
    end.

%% {Id, 开启时间, 结束时间}
%% {1,  {{2012,2,11},{16,28,0}}, {{2012,6,2},{17,55,0}}}
start_list() ->
    case is_koram() of
        true ->
            [
                %% 历史活动,ID不可删除
                 %% {394, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 %%,{395, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 %%,{396, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 %%,{397, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 %%,{398, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 %%,{399, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 %%,{400, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 %%,{401, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                  {402, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 ,{403, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 ,{404, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 ,{405, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 ,{406, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 ,{407, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 ,{408, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 ,{409, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 ,{410, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                 ,{411, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
            ]; 
        false ->
            case sys_env:get(srv_id) of
                "4399_mhfx_1" ->
                    [
                        %% {394, {{2013, 3, 18}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        %%,{395, {{2013, 3, 18}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        %%,{396, {{2013, 3, 18}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        %%,{397, {{2013, 3, 18}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        %%,{398, {{2013, 3, 18}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        %%,{399, {{2013, 3, 18}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        %%,{400, {{2013, 3, 18}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        %%,{401, {{2013, 3, 18}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                         {402, {{2013, 3, 20}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        ,{403, {{2013, 3, 20}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        ,{404, {{2013, 3, 20}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        ,{405, {{2013, 3, 20}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        ,{406, {{2013, 3, 20}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        ,{407, {{2013, 3, 20}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        ,{408, {{2013, 3, 20}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        ,{409, {{2013, 3, 20}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        ,{410, {{2013, 3, 20}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                        ,{411, {{2013, 3, 20}, {0, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
                    ]; 
                _ ->
                    do_get_start_list()
            end
    end.
do_get_start_list() ->
    [
        %% 历史活动,ID不可删除
        %% {394, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        %%,{395, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        %%,{396, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        %%,{397, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        %%,{398, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        %%,{399, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        %%,{400, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        %%,{401, {{2013, 3, 18}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
         {402, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        ,{403, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        ,{404, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        ,{405, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        ,{406, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        ,{407, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        ,{408, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        ,{409, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        ,{410, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
        ,{411, {{2013, 3, 20}, {8, 0, 1}}, {{2013, 3, 24}, {23, 59, 59}}}
    ].

%% {item, [{Label, 29100, 1, 1}]}
%% Label = {vip, VipType} | charge | charge_no
%% {gold, Num}
%% {buff, {BuffLabel, Duration}}
%% {special, {create_npc, {InterVal, NpcBaseIds, CreateNum, MaxNum}}},
%% 活动标签注释
%% charge_no:非充值玩家  charge:充值玩家
%% do_charge:充值触发,无条件限制
%% do_charge_line:当天累计充值触发 
%% do_charge_line_all:活动期间累计充值触发 
%% single_charge, LastLine 单笔充值触发终点线
%% single_charge, Line1, Line2 单笔充值触发区间
%% single_charge_2 触发一次单线

%% 单笔充值和累积充值邮件内容
-define(camp_mail_title_single, ?L(<<"周年庆典，单笔超值">>)).
-define(camp_mail_content_single, ?L(<<"亲爱的玩家，飞仙周年庆活动期间，您单笔充值达~w晶钻，获得了以下超值奖励，请注意查收！感谢您在过去的一年中对梦幻飞仙的鼎力支持，一路有你，精彩无限，您的支持将会是我们的无限动力，祝您游戏愉快！">>)).

-define(camp_mail_title_total, ?L(<<"春分返礼，累积豪华">>)).
-define(camp_mail_content_total, ?L(<<"亲爱的玩家，春分返礼活动期间，您累积充值达~w晶钻，获得了以下超值奖励，请注意查收！一年之计在于春，春意无限动力无限，祝您在新的一年游戏愉快，战力快涨！">>)).

%% ---------------------------------------------------------
%% 活动首冲
%% ---------------------------------------------------------
get(411 = Id) ->
    {ok, #campaign{
            id = Id 
            ,mode = ?ONLYONE
            ,title = language:get(<<"春分返礼，首充大礼">>)
            ,begin_time = {{2012, 9, 5},{0, 0, 0}}
            ,end_time = {{2011, 9, 7},{23, 59, 0}}
            ,do_begin = []
            ,do_end = []
            ,do_login = []
            ,do_logout = []
            ,do_charge = [
                {item, [{do_charge, 29542, 1, 1}]}
                %%{item, [{do_charge_line_all, 50, [{29471, 1}]}]}
            ]
            ,desc = language:get(<<"亲爱的玩家，春分返礼活动期间，您进行了首次充值，获得了【春分首充礼包】奖励，请注意查收！一年之计在于春，春意无限动力无限，祝您在新的一年游戏愉快，战力快涨！">>)
        }
    };

%% ---------------------------------------------------------
%% 单笔充值
%% ---------------------------------------------------------
%%get(394 = Id) ->
%%    {ok, #campaign{
%%            id = Id 
%%            ,mode = ?ONLYONE
%%            ,title = ?camp_mail_title_single
%%            ,begin_time = {{2011, 12, 24},{15, 40, 0}}
%%            ,end_time = {{2011, 12, 24},{15, 45, 0}}
%%            ,do_begin = []
%%            ,do_end = []
%%            ,do_login = []
%%            ,do_logout = []
%%            ,do_charge = [
%%                {item, [{single_charge, 500, 999,  [{, }]}]}
%%            ]
%%            ,desc = util:fbin(?camp_mail_content_single, [500])
%%        }
%%    };
%%get(395 = Id) ->
%%    {ok, #campaign{
%%            id = Id 
%%            ,mode = ?ONLYONE
%%            ,title = ?camp_mail_title_single
%%            ,begin_time = {{2011, 12, 24},{15, 40, 0}}
%%            ,end_time = {{2011, 12, 24},{15, 45, 0}}
%%            ,do_begin = []
%%            ,do_end = []
%%            ,do_login = []
%%            ,do_logout = []
%%            ,do_charge = [
%%                {item, [{single_charge, 1000, 2999,  [{, }]}]}
%%            ]
%%            ,desc = util:fbin(?camp_mail_content_single, [1000])
%%        }
%%    };
%%get(396 = Id) ->
%%    {ok, #campaign{
%%            id = Id 
%%            ,mode = ?ONLYONE
%%            ,title = ?camp_mail_title_single
%%            ,begin_time = {{2011, 12, 24},{15, 40, 0}}
%%            ,end_time = {{2011, 12, 24},{15, 45, 0}}
%%            ,do_begin = []
%%            ,do_end = []
%%            ,do_login = []
%%            ,do_logout = []
%%            ,do_charge = [
%%                {item, [{single_charge, 3000, 4999,  [{, }]}]}
%%            ]
%%            ,desc = util:fbin(?camp_mail_content_single, [3000])
%%        }
%%    };
%%get(397 = Id) ->
%%    {ok, #campaign{
%%            id = Id 
%%            ,mode = ?ONLYONE
%%            ,title = ?camp_mail_title_single
%%            ,begin_time = {{2011, 12, 24},{15, 40, 0}}
%%            ,end_time = {{2011, 12, 24},{15, 45, 0}}
%%            ,do_begin = []
%%            ,do_end = []
%%            ,do_login = []
%%            ,do_logout = []
%%            ,do_charge = [
%%                {item, [{single_charge, 5000, 9999,  [{, }]}]}
%%            ]
%%            ,desc = util:fbin(?camp_mail_content_single, [5000])
%%        }
%%    };
%%get(398 = Id) ->
%%    {ok, #campaign{
%%            id = Id 
%%            ,mode = ?ONLYONE
%%            ,title = ?camp_mail_title_single
%%            ,begin_time = {{2011, 12, 24},{15, 40, 0}}
%%            ,end_time = {{2011, 12, 24},{15, 45, 0}}
%%            ,do_begin = []
%%            ,do_end = []
%%            ,do_login = []
%%            ,do_logout = []
%%            ,do_charge = [
%%                {item, [{single_charge, 10000, 19999,  [{, }]}]}
%%            ]
%%            ,desc = util:fbin(?camp_mail_content_single, [10000])
%%        }
%%    };
%%get(399 = Id) ->
%%    {ok, #campaign{
%%            id = Id 
%%            ,mode = ?ONLYONE
%%            ,title = ?camp_mail_title_single
%%            ,begin_time = {{2011, 12, 24},{15, 40, 0}}
%%            ,end_time = {{2011, 12, 24},{15, 45, 0}}
%%            ,do_begin = []
%%            ,do_end = []
%%            ,do_login = []
%%            ,do_logout = []
%%            ,do_charge = [
%%                {item, [{single_charge, 20000, 49999,  [{, }]}]}
%%            ]
%%            ,desc = util:fbin(?camp_mail_content_single, [20000])
%%        }
%%    };
%%get(400 = Id) ->
%%    {ok, #campaign{
%%            id = Id 
%%            ,mode = ?ONLYONE
%%            ,title = ?camp_mail_title_single
%%            ,begin_time = {{2011, 12, 24},{15, 40, 0}}
%%            ,end_time = {{2011, 12, 24},{15, 45, 0}}
%%            ,do_begin = []
%%            ,do_end = []
%%            ,do_login = []
%%            ,do_logout = []
%%            ,do_charge = [
%%                {item, [{single_charge, 50000, 99999,  [{, }]}]}
%%            ]
%%            ,desc = util:fbin(?camp_mail_content_single, [50000])
%%        }
%%    };
%%get(401 = Id) ->
%%    {ok, #campaign{
%%            id = Id 
%%            ,mode = ?ONLYONE
%%            ,title = ?camp_mail_title_single
%%            ,begin_time = {{2011, 12, 24},{15, 40, 0}}
%%            ,end_time = {{2011, 12, 24},{15, 45, 0}}
%%            ,do_begin = []
%%            ,do_end = []
%%            ,do_login = []
%%            ,do_logout = []
%%            ,do_charge = [
%%                {item, [{single_charge, 100000,  [{, }]}]}
%%            ]
%%            ,desc = util:fbin(?camp_mail_content_single, [100000])
%%        }
%%    };
%% ---------------------------------------------------------
%% 累计充值
%% ---------------------------------------------------------
get(402 = Id) ->
    {ok, #campaign{
            id = Id 
            ,mode = ?ONLYONE
            ,title = ?camp_mail_title_total 
            ,begin_time = {{2012, 9, 5},{0, 0, 0}}
            ,end_time = {{2011, 9, 7},{23, 59, 0}}
            ,do_begin = []
            ,do_end = []
            ,do_login = []
            ,do_logout = []
            ,do_charge = [
                {item, [{do_charge_line_all, 500, [{21020, 3}, {22203, 1}, {33113, 3}, {22242, 2}, {22221, 3}]}]}
            ]
            ,desc = util:fbin(?camp_mail_content_total, [500])
        }
    };
get(403 = Id) ->
    {ok, #campaign{
            id = Id 
            ,mode = ?ONLYONE
            ,title = ?camp_mail_title_total 
            ,begin_time = {{2012, 9, 5},{0, 0, 0}}
            ,end_time = {{2011, 9, 7},{23, 59, 0}}
            ,do_begin = []
            ,do_end = []
            ,do_login = []
            ,do_logout = []
            ,do_charge = [
                {item, [{do_charge_line_all, 1000, [{21021, 2}, {22203, 2}, {25023, 1}, {22243, 1}, {22222, 1}, {33085, 5}]}]}
            ]
            ,desc = util:fbin(?camp_mail_content_total, [1000])
        }
    };
get(404 = Id) ->
    {ok, #campaign{
            id = Id 
            ,mode = ?ONLYONE
            ,title = ?camp_mail_title_total 
            ,begin_time = {{2012, 9, 5},{0, 0, 0}}
            ,end_time = {{2011, 9, 7},{23, 59, 0}}
            ,do_begin = []
            ,do_end = []
            ,do_login = []
            ,do_logout = []
            ,do_charge = [
                {item, [{do_charge_line_all, 2000, [{33141, 1}, {21026, 1}, {21021, 3}, {27003, 5}, {22243, 2}, {33085, 8}, {21030, 1}]}]}
            ]
            ,desc = util:fbin(?camp_mail_content_total, [2000])
        }
    };
get(405 = Id) ->
    {ok, #campaign{
            id = Id 
            ,mode = ?ONLYONE
            ,title = ?camp_mail_title_total 
            ,begin_time = {{2012, 9, 5},{0, 0, 0}}
            ,end_time = {{2011, 9, 7},{23, 59, 0}}
            ,do_begin = []
            ,do_end = []
            ,do_login = []
            ,do_logout = []
            ,do_charge = [
                {item, [{do_charge_line_all, 5000, [{23124, 1}, {23040, 3}, {21022, 3}, {27003, 15}, {23001, 25}, {23003, 10}, {22243, 3}, {33085, 10}]}]}
            ]
            ,desc = util:fbin(?camp_mail_content_total, [5000])
        }
    };
get(406 = Id) ->
    {ok, #campaign{
            id = Id 
            ,mode = ?ONLYONE
            ,title = ?camp_mail_title_total 
            ,begin_time = {{2012, 9, 5},{0, 0, 0}}
            ,end_time = {{2011, 9, 7},{23, 59, 0}}
            ,do_begin = []
            ,do_end = []
            ,do_login = []
            ,do_logout = []
            ,do_charge = [
                {item, [{do_charge_line_all, 10000, [{19034, 1}, {23040, 5}, {21022, 4}, {23020, 1}, {27003, 20}, {23001, 30}, {32001, 10}, {23003, 20}, {22244, 1}, {33085, 20}]}]}
            ]
            ,desc = util:fbin(?camp_mail_content_total, [10000])
        }
    };
get(407 = Id) ->
    {ok, #campaign{
            id = Id 
            ,mode = ?ONLYONE
            ,title = ?camp_mail_title_total 
            ,begin_time = {{2012, 9, 5},{0, 0, 0}}
            ,end_time = {{2011, 9, 7},{23, 59, 0}}
            ,do_begin = []
            ,do_end = []
            ,do_login = []
            ,do_logout = []
            ,do_charge = [
                {item, [{do_charge_line_all, 20000, [{26015, 1}, {32204, 1}, {23020, 2}, {32701, 10}, {33109, 10}, {32001, 20}, {29282, 1}, {33126, 50}, {33085, 30}, {33120, 20}, {33101, 30}]}]}
            ]
            ,desc = util:fbin(?camp_mail_content_total, [20000])
        }
    };
get(408 = Id) ->
    {ok, #campaign{
            id = Id 
            ,mode = ?ONLYONE
            ,title = ?camp_mail_title_total 
            ,begin_time = {{2012, 9, 5},{0, 0, 0}}
            ,end_time = {{2011, 9, 7},{23, 59, 0}}
            ,do_begin = []
            ,do_end = []
            ,do_login = []
            ,do_logout = []
            ,do_charge = [
                {item, [{do_charge_line_all, 50000, [{26035, 1}, {32204, 2}, {23020, 3}, {32701, 30}, {33109, 20}, {32001, 30}, {29282, 3}, {33127, 50}, {21700, 8}, {33120, 30}, {33101, 40}, {33169, 1}]}]}
            ]
            ,desc = util:fbin(?camp_mail_content_total, [50000])
        }
    };
get(409 = Id) ->
    {ok, #campaign{
            id = Id 
            ,mode = ?ONLYONE
            ,title = ?camp_mail_title_total 
            ,begin_time = {{2012, 9, 5},{0, 0, 0}}
            ,end_time = {{2011, 9, 7},{23, 59, 0}}
            ,do_begin = []
            ,do_end = []
            ,do_login = []
            ,do_logout = []
            ,do_charge = [
                {item, [{do_charge_line_all, 100000, [{26055, 1}, {32204, 3}, {23020, 5}, {33151, 50}, {33109, 30}, {32001, 60}, {29282, 5}, {33128, 50}, {29517, 1}, {21700, 20}, {33101, 60}, {32702, 10}, {33169, 3}]}]}
            ]
            ,desc = util:fbin(?camp_mail_content_total, [100000])
        }
    };
get(410 = Id) ->
    {ok, #campaign{
            id = Id 
            ,mode = ?ONLYONE
            ,title = ?camp_mail_title_total 
            ,begin_time = {{2012, 9, 5},{0, 0, 0}}
            ,end_time = {{2011, 9, 7},{23, 59, 0}}
            ,do_begin = []
            ,do_end = []
            ,do_login = []
            ,do_logout = []
            ,do_charge = [
                {item, [{do_charge_line_all, 200000, [{26055, 2}, {32204, 4}, {23020, 6}, {33151, 60}, {33109, 60}, {32001, 100}, {29282, 10}, {33128, 60}, {29517, 3}, {21700, 30}, {33101, 80}, {32702, 20}, {33169, 5}]}]}
            ]
            ,desc = util:fbin(?camp_mail_content_total, [200000])
        }
    };

%% ---------------------------------------------------------
%% 合服长期活动(勿删)
%% ---------------------------------------------------------
get(1000) ->
    {ok, #campaign{
            id = 1000
            ,mode = ?ONLYONE
            ,title = language:get(<<"合区登陆送福利">>)
            ,begin_time = {{2011, 12, 24},{15, 40, 0}}
            ,end_time = {{2011, 12, 24},{15, 45, 0}}
            ,do_begin = [
                {item, [{srv, 1, [{29190, 1}]}
                        ,{srv, 2, [{29190, 2}]}]
                }
            ]
            ,do_end = []
            ,do_login = [
                {item, [{srv, 1, [{29190, 1}]}
                        ,{srv, 2, [{29190, 2}]}]
                }
            ]
            ,do_logout = []
            ,do_charge = []
            ,desc = language:get(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。合区后首次登陆赠送礼包一份！ 请注意查收！感谢您在过去的一年中对梦幻飞仙的鼎力支持，梦幻飞仙祝您在新的一年里大吉大利，战力快涨！">>)
        }
    };

get(1001) ->
    {ok, #campaign{
            id = 1001
            ,mode = ?ONLYONE
            ,title = language:get(<<"合区首冲送豪礼">>)
            ,begin_time = {{2011, 12, 24},{15, 40, 0}}
            ,end_time = {{2011, 12, 24},{15, 45, 0}}
            ,do_begin = []
            ,do_end = []
            ,do_login = []
            ,do_logout = []
            ,do_charge = [
               {item, [{do_charge, 29192, 1, 1}]}
            ]
            ,desc = language:get(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。合区后首次充值赠送豪礼一份！ 请注意查收！感谢您在过去的一年中对梦幻飞仙的鼎力支持，梦幻飞仙祝您在新的一年里大吉大利，战力快涨！">>)
        }
    };

get(1002) ->
    {ok, #campaign{
            id = 1002
            ,mode = ?ONLYONE
            ,title = language:get(<<"合区双倍经验大放送">>)
            ,begin_time = {{2011, 12, 24},{15, 40, 0}}
            ,end_time = {{2011, 12, 24},{15, 45, 0}}
            ,do_begin = [
                {buff, {campaign_double_exp, 7200}}
            ]
            ,do_end = []
            ,do_login = [
                {buff, {campaign_double_exp, 7200}}
            ]
            ,do_logout = []
            ,do_charge = []
            ,desc = <<"">>
        }
    };

get(1003) ->
    {ok, #campaign{
            id = 1003
            ,mode = ?ONLYONE
            ,title = language:get(<<"合服充值送好礼">>)
            ,begin_time = {{2011, 12, 24},{15, 40, 0}}
            ,end_time = {{2011, 12, 24},{15, 45, 0}}
            ,do_begin = []
            ,do_end = []
            ,do_login = []
            ,do_logout = []
            ,do_charge = [
               {item, [{round_charge, 1000, [{29191, 1}]}]}
            ]
            ,desc = language:get(<<"亲爱的玩家，感谢您对梦幻飞仙的鼎力支持。合区活动三天内每次单笔1000晶钻以上赠送豪礼！请注意查收！感谢您在过去的一年中对梦幻飞仙的鼎力支持，梦幻飞仙祝您在新的一年里大吉大利，战力快涨！">>)
        }
    };

get(_) ->
    {false, language:get(<<"不存在的活动">>)}.
