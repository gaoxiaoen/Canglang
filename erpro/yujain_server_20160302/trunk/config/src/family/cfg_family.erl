%% Author: caochuncheng2002@gmail.com
%% Created: 2013-8-23
%% Description: 帮派配置信息
-module(cfg_family).

-export([
         find/1,
         init_max_family_process_number/0,
         gen_family_cache_interval/0,
         get_office_code/1,
         gen_member_office_interval/0,
         get_family_impeach_days/0,
         get_min_inherit_contribute/0,
         get_min_inherit_level/0
        ]).


%% 创建帮派的元宝费用
find({create_family_fee,gold}) ->
    [2];
%% 创建帮派的银两费用 
find({create_family_fee,silver}) ->
    [20];
%% 最小创建帮派的玩家等级 
find({create_family,min_role_level}) ->
    [25];

%% 加入帮派最小等级
find({join_family,min_role_level}) ->
    [30];
%% 帮派申请列表最大长度
find({max_family_request_number}) ->
    [100];

%% 记录帮派日志时间隔,单位:秒,2小时检查一次  3 * 60 * 60 + 20 * 60
find(server_log_interval) ->
    [12000];

find(_) ->
    [].

%% 系统启动时，初始化帮派进程数
init_max_family_process_number() ->
    50.
%% 生成帮派列表数据间隔时间,单位:秒,5分钟生成一次 5*60
gen_family_cache_interval() ->
    300.
%% 重排帮派成员间隔时间,单位:秒,10分钟生成一次 11*60
gen_member_office_interval() ->
    660.
%% 帮派团长多少天没有上线，将被弹劾
get_family_impeach_days() ->
    4.
%% 可以继承帮派团长的最小贡献度
get_min_inherit_contribute() ->
    10000.
%% 可以继承帮派团长的最小等级
get_min_inherit_level() ->
    50.

%% 根据排名获取职位
%% 10000:团长
%% 10001:督军
%% 10002:营长
%% 10003:千夫长
%% 10004:百夫长
%% 10005:伍长
%% 10006:团员
get_office_code(1) ->  %% 10001:督军
    10001;
get_office_code(2) ->  %% 10002:营长
    10002;
get_office_code(3) ->
    10002;
get_office_code(4) ->
    10002;
get_office_code(5) ->  %% 10003:千夫长
    10003;
get_office_code(6) ->
    10003;
get_office_code(7) ->
    10003;
get_office_code(8) ->
    10003;
get_office_code(9) ->
    10003;
get_office_code(10) ->
    10003;
get_office_code(11) ->
    10003;
get_office_code(12) ->
    10003;
get_office_code(13) -> %% 10004:百夫长
    10004;
get_office_code(14) ->
    10004;
get_office_code(15) ->
    10004;
get_office_code(16) ->
    10004;
get_office_code(17) ->
    10004;
get_office_code(18) ->
    10004;
get_office_code(19) ->
    10004;
get_office_code(20) ->
    10004;
get_office_code(21) -> %% 10005:伍长
    10005;
get_office_code(22) ->
    10005;
get_office_code(23) ->
    10005;
get_office_code(24) ->
    10005;
get_office_code(25) ->
    10005;
get_office_code(26) ->
    10005;
get_office_code(27) ->
    10005;
get_office_code(_) ->  %% 10006:团员
    10006.
