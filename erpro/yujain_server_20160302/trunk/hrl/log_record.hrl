%%==========================系统日志配置 Begin==================================
%% 日志进程状态
%% log_key_list 进程处理的日志类型列表
-record(r_log_state,{process_name = "",process_id = 0,log_key_list = []}).
%% 系统日志配置
%% LogKey 日志key
%% NewFileInterval 新日志文件间隔时间,单位：秒
%% DumpInterval 写日志间隔时间,单位：秒
%% MaxDumpRecord 最多一次写多条件记录
-record(r_log_config,{log_key,process_id = 0,new_file_interval = 0, dump_interval = 0,max_dump_record = 0}).

%% 元宝日志记录
-record(r_log_gold,{role_id = 0,role_name = "",level = 0,
                    account_name = "",account_via = "",account_type = 0,
                    type = 0,mtype = 0,mtime = 0,
                    gold = 0,item_id = 0,num = 0,
                    remain_gold = 0,log_desc = ""}).
%% 银子日志记录
-record(r_log_silver,{role_id = 0,role_name = "",level = 0,
                      account_name = "",account_via = "",account_type = 0,
                      type = 0,mtype = 0,mtime = 0,
                      money = 0,item_id = 0, num = 0,
                      remain_money = 0,log_desc = ""}).
%% 物品日志记录
-record(r_log_goods,{role_id = 0,role_name = "",level = 0,
                     account_name = "",account_via = "",account_type = 0,
                     type = 0,mtime = 0,
                     item_id = 0,num = 0,item_via = 0,
                     map_id = 0,detail = "",log_desc = ""}).
%% 铜钱日志记录
-record(r_log_coin,{role_id = 0,role_name = "",level = 0,
                    account_name = "",account_via = "",account_type = 0,
                    type = 0,mtype = 0,mtime = 0,
                    coin = 0,item_id = 0, num = 0,
                    remain_coin = 0,log_desc = ""}).

%% 玩家流失日志
%% step 步骤，根据注册的各个步骤定义值
-define(ROLE_FOLLOW_STEP_1,1). %% 选服页
-define(ROLE_FOLLOW_STEP_2,2). %% 进入创建角色页
-define(ROLE_FOLLOW_STEP_3,3). %% 创建角色成功
-define(ROLE_FOLLOW_STEP_4,4). %% 登录验证
-define(ROLE_FOLLOW_STEP_5,5). %% 进入地图
-define(ROLE_FOLLOW_STEP_6,6). %% 接受第一个任务
-define(ROLE_FOLLOW_STEP_7,7). %% 完成第一个任务
-record(r_log_role_follow,{account_name = "",account_via = "",
                           role_id = 0,role_name = "",
                           mtime = 0,step = 0,ip = ""}).
%% 玩家登录日志
-record(r_log_role_login,{role_id = 0,role_name = "",level = 0,account_name = "",mtime = 0,ip = ""}).

%% 玩家登出日志
-record(r_log_role_logout, {role_id = 0, role_name = "", level = 0,
                            account_name = "",ip = "", 
                            map_id = 0,tx = 0, ty = 0,
                            online_time = 0,mtime = 0, reason = ""}).

%% 发送信件日志
%% is_system 是否系统信件,1是,0否
%% letter_type 信件类型,0私人信件,1帮派信件,2系统信件,3退信,4GM信件
-record(r_log_letter,{sender_role_id = 0,sender_role_name = "", sender_account_name = "",
                      receiver_role_id = 0,receiver_role_name = "",receiver_account_name = "",
                      mtime = 0,is_system = 0,letter_type = 0,title = "", content = "",
                      gold = 0, money = 0, coin = 0,
                      attachments = [],log_desc = ""}).

%% 充值 日志
%% status 充值状态 1成功2失败
-record(r_log_pay,{order_id = "",account_name = "",account_via = "", account_type = 0,
                   role_id = 0, role_name = "", level = 0, mtime = 0,
                   pay_money = 0,gold = 0,pay_time = 0,pay_status = 0,pf_order_id=""}).
%% 充值请求日志
-record(r_log_pay_request,{order_id = "",account_name = "",account_via = "",mtime = 0,
                           pay_time = 0,pay_money = 0,gold = 0,server_id = 0,pf_order_id=""}).

%% 玩家信息快照日志
-record(r_log_role_snapshot,{role_id = 0,role_name = "",account_name = "",account_via = "",account_type = 0,
                             account_status = 0,create_time = 0,faction_id = 0,category = 0,
                             gender = 0,level = 0,exp = 0,next_level_exp = 0,family_id = 0,family_name = "",
                             is_pay= 0,total_gold=0,gold = 0,silver = 0,coin=0,
                             vip_lv = 0,last_login_time = 0,last_logout_time = 0,total_online_time=0,
                             map_id = 0,tx = 0,ty = 0,
                             mtime = 0,total_consume = 0,last_device_id="",extra_info = ""}).

%% 任务日志
%% mission_type 任务类型,1主线,2支线,3循环
%% status 任务状态,1已接受,2已完成,3已领奖,4已取消
-define(LOG_MISSION_STATUS_ACCEPT,1).
-define(LOG_MISSION_STATUS_FINISH,2).
-define(LOG_MISSION_STATUS_COMMIT,3).
-define(LOG_MISSION_STATUS_CANCEL,4).
-record(r_log_mission,{role_id=0,role_name="",account_name="",role_level=0,mtime=0,mission_id=0,mission_type=0,status=0}).

%% 玩家升级日志
-record(r_log_role_level_up,{role_id=0,role_name="",ip="",account_name="",
                             prev_level=0,level=0,level_up_reason=0,mtime=0,log_desc=""}).
%% 通用日志
-record(r_log_common,{role_id=0,code=0,val_1=0,val_2=0,val_3=0,val_4=0,val_5=0,mtime=0,desc=""}).


%% 帮派日志
-record(r_log_family,{family_id=0,family_name="",create_role_id=0,create_role_name="",
                      owner_role_id=0,owner_role_name="",faction_id=0,level=0,
                      create_time=0,cur_pop=0,max_pop=0,icon_level=0,
                      total_contribute=0,status=0,
                      member_list="",
                      extra="",log_time=0,log_desc=""}).
%% 测试日志
-record(r_log_test,{hello_text="",id=1111}).

%%==========================系统日志配置 End==================================

%% record_name 
%% default_record record默认值
%% record_fields record字段
%% dump_interval 入库时间间隔
%% max_dump_num 等待最大入库条数
%% write_type 写入类型
-record(r_log_type,{record_name,default_record,record_fields,table_name,write_type,dump_interval,max_dump_num}).

-define(insert,insert).
-define(replace,replace).
