%% Author: markycai<tomarky.cai@gmail.com>
%% Created: 2013-10-21
%% Description: TODO: Add description to cfg_logger
-module(cfg_logger).

-include("common.hrl").
 
-export([find/1]).


-define(LOG_TYPE(Record,TableName,DumpInterval,MaxDumpNum),
        #r_log_type{record_name = Record, 
                 default_record = #Record{},
                 record_fields = record_info(fields,Record),
                 table_name=TableName,
                 write_type=?insert,
                 dump_interval=DumpInterval,max_dump_num=MaxDumpNum}).


-define(LOG_TYPE(Record,TableName,WriteType,DumpInterval,MaxDumpNum),
        #r_log_type{record_name = Record,
                 default_record = #Record{},
                 record_fields = record_info(fields,Record),
                 table_name=TableName,
                 write_type = WriteType,
                 dump_interval=DumpInterval,max_dump_num=MaxDumpNum}).

find(log_type_list)->
    [?LOG_TYPE(r_log_test,          hello_table,            2,2),
     ?LOG_TYPE(r_log_gold,          t_log_gold,             90,100),
     ?LOG_TYPE(r_log_silver,        t_log_money,            90,100),
     ?LOG_TYPE(r_log_coin,          t_log_coin,             90,100),
     ?LOG_TYPE(r_log_goods,         t_log_item,             90,100),
     ?LOG_TYPE(r_log_role_logout,   t_log_logout,           20,100),
     ?LOG_TYPE(r_log_role_login,    t_log_login,            20,100),
     ?LOG_TYPE(r_log_role_follow,   t_log_create_loss,      20,100),
     ?LOG_TYPE(r_log_letter,        t_log_mail,             20,100),
     ?LOG_TYPE(r_log_pay_request,   t_log_pay_request,      20,100),
     ?LOG_TYPE(r_log_pay,           t_log_pay,              20,100),
     ?LOG_TYPE(r_log_role_snapshot, t_log_player_snapshot,  20,100,?replace),
     ?LOG_TYPE(r_log_role_level_up, t_log_level_up,         20,100),
     ?LOG_TYPE(r_log_mission,       t_log_mission,          20,100),
     ?LOG_TYPE(r_log_common,        t_log_common,           20,100),
     ?LOG_TYPE(r_log_family,        t_log_family,           20,100,?replace)
    ]; 

find(log_dir)->
    main_exec:get_log_dir() ++ "/tmp_log";

find(_)->[].

